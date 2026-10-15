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
define ptr @__m____________lib_sha512g_resid__sha512g_k() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5459 = add i64 4794697086780616226, 0
%t5460 = add i64 %t5459, 0
%t5461 = add i64 %t5460, 0
%t5462 = icmp ne i64 %t5461, %t5459
%t5463 = icmp slt i64 4794697086780616226, 0
%t5464 = or i1 %t5462, %t5463
%t5465 = zext i1 %t5464 to i8
call void @resid_conv_check(i8 %t5465)
%t5466 = add i64 8158064640168781261, 0
%t5467 = add i64 %t5466, 0
%t5468 = add i64 %t5467, 0
%t5469 = icmp ne i64 %t5468, %t5466
%t5470 = icmp slt i64 8158064640168781261, 0
%t5471 = or i1 %t5469, %t5470
%t5472 = zext i1 %t5471 to i8
call void @resid_conv_check(i8 %t5472)
%t5473 = add i128 13096744586834688815, 0
%t5474 = trunc i128 %t5473 to i64
%t5475 = zext i64 %t5474 to i128
%t5476 = icmp ne i128 %t5475, %t5473
%t5477 = icmp slt i128 13096744586834688815, 0
%t5478 = or i1 %t5476, %t5477
%t5479 = zext i1 %t5478 to i8
call void @resid_conv_check(i8 %t5479)
%t5480 = add i128 16840607885511220156, 0
%t5481 = trunc i128 %t5480 to i64
%t5482 = zext i64 %t5481 to i128
%t5483 = icmp ne i128 %t5482, %t5480
%t5484 = icmp slt i128 16840607885511220156, 0
%t5485 = or i1 %t5483, %t5484
%t5486 = zext i1 %t5485 to i8
call void @resid_conv_check(i8 %t5486)
%t5487 = add i64 4131703408338449720, 0
%t5488 = add i64 %t5487, 0
%t5489 = add i64 %t5488, 0
%t5490 = icmp ne i64 %t5489, %t5487
%t5491 = icmp slt i64 4131703408338449720, 0
%t5492 = or i1 %t5490, %t5491
%t5493 = zext i1 %t5492 to i8
call void @resid_conv_check(i8 %t5493)
%t5494 = add i64 6480981068601479193, 0
%t5495 = add i64 %t5494, 0
%t5496 = add i64 %t5495, 0
%t5497 = icmp ne i64 %t5496, %t5494
%t5498 = icmp slt i64 6480981068601479193, 0
%t5499 = or i1 %t5497, %t5498
%t5500 = zext i1 %t5499 to i8
call void @resid_conv_check(i8 %t5500)
%t5501 = add i128 10538285296894168987, 0
%t5502 = trunc i128 %t5501 to i64
%t5503 = zext i64 %t5502 to i128
%t5504 = icmp ne i128 %t5503, %t5501
%t5505 = icmp slt i128 10538285296894168987, 0
%t5506 = or i1 %t5504, %t5505
%t5507 = zext i1 %t5506 to i8
call void @resid_conv_check(i8 %t5507)
%t5508 = add i128 12329834152419229976, 0
%t5509 = trunc i128 %t5508 to i64
%t5510 = zext i64 %t5509 to i128
%t5511 = icmp ne i128 %t5510, %t5508
%t5512 = icmp slt i128 12329834152419229976, 0
%t5513 = or i1 %t5511, %t5512
%t5514 = zext i1 %t5513 to i8
call void @resid_conv_check(i8 %t5514)
%t5515 = add i128 15566598209576043074, 0
%t5516 = trunc i128 %t5515 to i64
%t5517 = zext i64 %t5516 to i128
%t5518 = icmp ne i128 %t5517, %t5515
%t5519 = icmp slt i128 15566598209576043074, 0
%t5520 = or i1 %t5518, %t5519
%t5521 = zext i1 %t5520 to i8
call void @resid_conv_check(i8 %t5521)
%t5522 = add i64 1334009975649890238, 0
%t5523 = add i64 %t5522, 0
%t5524 = add i64 %t5523, 0
%t5525 = icmp ne i64 %t5524, %t5522
%t5526 = icmp slt i64 1334009975649890238, 0
%t5527 = or i1 %t5525, %t5526
%t5528 = zext i1 %t5527 to i8
call void @resid_conv_check(i8 %t5528)
%t5529 = add i64 2608012711638119052, 0
%t5530 = add i64 %t5529, 0
%t5531 = add i64 %t5530, 0
%t5532 = icmp ne i64 %t5531, %t5529
%t5533 = icmp slt i64 2608012711638119052, 0
%t5534 = or i1 %t5532, %t5533
%t5535 = zext i1 %t5534 to i8
call void @resid_conv_check(i8 %t5535)
%t5536 = add i64 6128411473006802146, 0
%t5537 = add i64 %t5536, 0
%t5538 = add i64 %t5537, 0
%t5539 = icmp ne i64 %t5538, %t5536
%t5540 = icmp slt i64 6128411473006802146, 0
%t5541 = or i1 %t5539, %t5540
%t5542 = zext i1 %t5541 to i8
call void @resid_conv_check(i8 %t5542)
%t5543 = add i64 8268148722764581231, 0
%t5544 = add i64 %t5543, 0
%t5545 = add i64 %t5544, 0
%t5546 = icmp ne i64 %t5545, %t5543
%t5547 = icmp slt i64 8268148722764581231, 0
%t5548 = or i1 %t5546, %t5547
%t5549 = zext i1 %t5548 to i8
call void @resid_conv_check(i8 %t5549)
%t5550 = add i128 9286055187155687089, 0
%t5551 = trunc i128 %t5550 to i64
%t5552 = zext i64 %t5551 to i128
%t5553 = icmp ne i128 %t5552, %t5550
%t5554 = icmp slt i128 9286055187155687089, 0
%t5555 = or i1 %t5553, %t5554
%t5556 = zext i1 %t5555 to i8
call void @resid_conv_check(i8 %t5556)
%t5557 = add i128 11230858885718282805, 0
%t5558 = trunc i128 %t5557 to i64
%t5559 = zext i64 %t5558 to i128
%t5560 = icmp ne i128 %t5559, %t5557
%t5561 = icmp slt i128 11230858885718282805, 0
%t5562 = or i1 %t5560, %t5561
%t5563 = zext i1 %t5562 to i8
call void @resid_conv_check(i8 %t5563)
%t5564 = add i128 13951009754708518548, 0
%t5565 = trunc i128 %t5564 to i64
%t5566 = zext i64 %t5565 to i128
%t5567 = icmp ne i128 %t5566, %t5564
%t5568 = icmp slt i128 13951009754708518548, 0
%t5569 = or i1 %t5567, %t5568
%t5570 = zext i1 %t5569 to i8
call void @resid_conv_check(i8 %t5570)
%t5571 = add i128 16472876342353939154, 0
%t5572 = trunc i128 %t5571 to i64
%t5573 = zext i64 %t5572 to i128
%t5574 = icmp ne i128 %t5573, %t5571
%t5575 = icmp slt i128 16472876342353939154, 0
%t5576 = or i1 %t5574, %t5575
%t5577 = zext i1 %t5576 to i8
call void @resid_conv_check(i8 %t5577)
%t5578 = add i128 17275323862435702243, 0
%t5579 = trunc i128 %t5578 to i64
%t5580 = zext i64 %t5579 to i128
%t5581 = icmp ne i128 %t5580, %t5578
%t5582 = icmp slt i128 17275323862435702243, 0
%t5583 = or i1 %t5581, %t5582
%t5584 = zext i1 %t5583 to i8
call void @resid_conv_check(i8 %t5584)
%t5585 = add i64 1135362057144423861, 0
%t5586 = add i64 %t5585, 0
%t5587 = add i64 %t5586, 0
%t5588 = icmp ne i64 %t5587, %t5585
%t5589 = icmp slt i64 1135362057144423861, 0
%t5590 = or i1 %t5588, %t5589
%t5591 = zext i1 %t5590 to i8
call void @resid_conv_check(i8 %t5591)
%t5592 = add i64 2597628984639134821, 0
%t5593 = add i64 %t5592, 0
%t5594 = add i64 %t5593, 0
%t5595 = icmp ne i64 %t5594, %t5592
%t5596 = icmp slt i64 2597628984639134821, 0
%t5597 = or i1 %t5595, %t5596
%t5598 = zext i1 %t5597 to i8
call void @resid_conv_check(i8 %t5598)
%t5599 = add i64 3308224258029322869, 0
%t5600 = add i64 %t5599, 0
%t5601 = add i64 %t5600, 0
%t5602 = icmp ne i64 %t5601, %t5599
%t5603 = icmp slt i64 3308224258029322869, 0
%t5604 = or i1 %t5602, %t5603
%t5605 = zext i1 %t5604 to i8
call void @resid_conv_check(i8 %t5605)
%t5606 = add i64 5365058923640841347, 0
%t5607 = add i64 %t5606, 0
%t5608 = add i64 %t5607, 0
%t5609 = icmp ne i64 %t5608, %t5606
%t5610 = icmp slt i64 5365058923640841347, 0
%t5611 = or i1 %t5609, %t5610
%t5612 = zext i1 %t5611 to i8
call void @resid_conv_check(i8 %t5612)
%t5613 = add i64 6679025012923562964, 0
%t5614 = add i64 %t5613, 0
%t5615 = add i64 %t5614, 0
%t5616 = icmp ne i64 %t5615, %t5613
%t5617 = icmp slt i64 6679025012923562964, 0
%t5618 = or i1 %t5616, %t5617
%t5619 = zext i1 %t5618 to i8
call void @resid_conv_check(i8 %t5619)
%t5620 = add i64 8573033837759648693, 0
%t5621 = add i64 %t5620, 0
%t5622 = add i64 %t5621, 0
%t5623 = icmp ne i64 %t5622, %t5620
%t5624 = icmp slt i64 8573033837759648693, 0
%t5625 = or i1 %t5623, %t5624
%t5626 = zext i1 %t5625 to i8
call void @resid_conv_check(i8 %t5626)
%t5627 = add i128 10970295158949994411, 0
%t5628 = trunc i128 %t5627 to i64
%t5629 = zext i64 %t5628 to i128
%t5630 = icmp ne i128 %t5629, %t5627
%t5631 = icmp slt i128 10970295158949994411, 0
%t5632 = or i1 %t5630, %t5631
%t5633 = zext i1 %t5632 to i8
call void @resid_conv_check(i8 %t5633)
%t5634 = add i128 12119686244451234320, 0
%t5635 = trunc i128 %t5634 to i64
%t5636 = zext i64 %t5635 to i128
%t5637 = icmp ne i128 %t5636, %t5634
%t5638 = icmp slt i128 12119686244451234320, 0
%t5639 = or i1 %t5637, %t5638
%t5640 = zext i1 %t5639 to i8
call void @resid_conv_check(i8 %t5640)
%t5641 = add i128 12683024718118986047, 0
%t5642 = trunc i128 %t5641 to i64
%t5643 = zext i64 %t5642 to i128
%t5644 = icmp ne i128 %t5643, %t5641
%t5645 = icmp slt i128 12683024718118986047, 0
%t5646 = or i1 %t5644, %t5645
%t5647 = zext i1 %t5646 to i8
call void @resid_conv_check(i8 %t5647)
%t5648 = add i128 13788192230050041572, 0
%t5649 = trunc i128 %t5648 to i64
%t5650 = zext i64 %t5649 to i128
%t5651 = icmp ne i128 %t5650, %t5648
%t5652 = icmp slt i128 13788192230050041572, 0
%t5653 = or i1 %t5651, %t5652
%t5654 = zext i1 %t5653 to i8
call void @resid_conv_check(i8 %t5654)
%t5655 = add i128 14330467153632333762, 0
%t5656 = trunc i128 %t5655 to i64
%t5657 = zext i64 %t5656 to i128
%t5658 = icmp ne i128 %t5657, %t5655
%t5659 = icmp slt i128 14330467153632333762, 0
%t5660 = or i1 %t5658, %t5659
%t5661 = zext i1 %t5660 to i8
call void @resid_conv_check(i8 %t5661)
%t5662 = add i128 15395433587784984357, 0
%t5663 = trunc i128 %t5662 to i64
%t5664 = zext i64 %t5663 to i128
%t5665 = icmp ne i128 %t5664, %t5662
%t5666 = icmp slt i128 15395433587784984357, 0
%t5667 = or i1 %t5665, %t5666
%t5668 = zext i1 %t5667 to i8
call void @resid_conv_check(i8 %t5668)
%t5669 = add i64 1452737877330783856, 0
%t5670 = add i64 %t5669, 0
%t5671 = add i64 %t5670, 0
%t5672 = icmp ne i64 %t5671, %t5669
%t5673 = icmp slt i64 1452737877330783856, 0
%t5674 = or i1 %t5672, %t5673
%t5675 = zext i1 %t5674 to i8
call void @resid_conv_check(i8 %t5675)
%t5676 = add i64 2861767655752347644, 0
%t5677 = add i64 %t5676, 0
%t5678 = add i64 %t5677, 0
%t5679 = icmp ne i64 %t5678, %t5676
%t5680 = icmp slt i64 2861767655752347644, 0
%t5681 = or i1 %t5679, %t5680
%t5682 = zext i1 %t5681 to i8
call void @resid_conv_check(i8 %t5682)
%t5683 = add i64 3322285676063803686, 0
%t5684 = add i64 %t5683, 0
%t5685 = add i64 %t5684, 0
%t5686 = icmp ne i64 %t5685, %t5683
%t5687 = icmp slt i64 3322285676063803686, 0
%t5688 = or i1 %t5686, %t5687
%t5689 = zext i1 %t5688 to i8
call void @resid_conv_check(i8 %t5689)
%t5690 = add i64 5560940570517711597, 0
%t5691 = add i64 %t5690, 0
%t5692 = add i64 %t5691, 0
%t5693 = icmp ne i64 %t5692, %t5690
%t5694 = icmp slt i64 5560940570517711597, 0
%t5695 = or i1 %t5693, %t5694
%t5696 = zext i1 %t5695 to i8
call void @resid_conv_check(i8 %t5696)
%t5697 = add i64 5996557281743188959, 0
%t5698 = add i64 %t5697, 0
%t5699 = add i64 %t5698, 0
%t5700 = icmp ne i64 %t5699, %t5697
%t5701 = icmp slt i64 5996557281743188959, 0
%t5702 = or i1 %t5700, %t5701
%t5703 = zext i1 %t5702 to i8
call void @resid_conv_check(i8 %t5703)
%t5704 = add i64 7280758554555802590, 0
%t5705 = add i64 %t5704, 0
%t5706 = add i64 %t5705, 0
%t5707 = icmp ne i64 %t5706, %t5704
%t5708 = icmp slt i64 7280758554555802590, 0
%t5709 = or i1 %t5707, %t5708
%t5710 = zext i1 %t5709 to i8
call void @resid_conv_check(i8 %t5710)
%t5711 = add i64 8532644243296465576, 0
%t5712 = add i64 %t5711, 0
%t5713 = add i64 %t5712, 0
%t5714 = icmp ne i64 %t5713, %t5711
%t5715 = icmp slt i64 8532644243296465576, 0
%t5716 = or i1 %t5714, %t5715
%t5717 = zext i1 %t5716 to i8
call void @resid_conv_check(i8 %t5717)
%t5718 = add i128 9350256976987008742, 0
%t5719 = trunc i128 %t5718 to i64
%t5720 = zext i64 %t5719 to i128
%t5721 = icmp ne i128 %t5720, %t5718
%t5722 = icmp slt i128 9350256976987008742, 0
%t5723 = or i1 %t5721, %t5722
%t5724 = zext i1 %t5723 to i8
call void @resid_conv_check(i8 %t5724)
%t5725 = add i128 10552545826968843579, 0
%t5726 = trunc i128 %t5725 to i64
%t5727 = zext i64 %t5726 to i128
%t5728 = icmp ne i128 %t5727, %t5725
%t5729 = icmp slt i128 10552545826968843579, 0
%t5730 = or i1 %t5728, %t5729
%t5731 = zext i1 %t5730 to i8
call void @resid_conv_check(i8 %t5731)
%t5732 = add i128 11727347734174303076, 0
%t5733 = trunc i128 %t5732 to i64
%t5734 = zext i64 %t5733 to i128
%t5735 = icmp ne i128 %t5734, %t5732
%t5736 = icmp slt i128 11727347734174303076, 0
%t5737 = or i1 %t5735, %t5736
%t5738 = zext i1 %t5737 to i8
call void @resid_conv_check(i8 %t5738)
%t5739 = add i128 12113106623233404929, 0
%t5740 = trunc i128 %t5739 to i64
%t5741 = zext i64 %t5740 to i128
%t5742 = icmp ne i128 %t5741, %t5739
%t5743 = icmp slt i128 12113106623233404929, 0
%t5744 = or i1 %t5742, %t5743
%t5745 = zext i1 %t5744 to i8
call void @resid_conv_check(i8 %t5745)
%t5746 = add i128 14000437183269869457, 0
%t5747 = trunc i128 %t5746 to i64
%t5748 = zext i64 %t5747 to i128
%t5749 = icmp ne i128 %t5748, %t5746
%t5750 = icmp slt i128 14000437183269869457, 0
%t5751 = or i1 %t5749, %t5750
%t5752 = zext i1 %t5751 to i8
call void @resid_conv_check(i8 %t5752)
%t5753 = add i128 14369950271660146224, 0
%t5754 = trunc i128 %t5753 to i64
%t5755 = zext i64 %t5754 to i128
%t5756 = icmp ne i128 %t5755, %t5753
%t5757 = icmp slt i128 14369950271660146224, 0
%t5758 = or i1 %t5756, %t5757
%t5759 = zext i1 %t5758 to i8
call void @resid_conv_check(i8 %t5759)
%t5760 = add i128 15101387698204529176, 0
%t5761 = trunc i128 %t5760 to i64
%t5762 = zext i64 %t5761 to i128
%t5763 = icmp ne i128 %t5762, %t5760
%t5764 = icmp slt i128 15101387698204529176, 0
%t5765 = or i1 %t5763, %t5764
%t5766 = zext i1 %t5765 to i8
call void @resid_conv_check(i8 %t5766)
%t5767 = add i128 15463397548674623760, 0
%t5768 = trunc i128 %t5767 to i64
%t5769 = zext i64 %t5768 to i128
%t5770 = icmp ne i128 %t5769, %t5767
%t5771 = icmp slt i128 15463397548674623760, 0
%t5772 = or i1 %t5770, %t5771
%t5773 = zext i1 %t5772 to i8
call void @resid_conv_check(i8 %t5773)
%t5774 = add i128 17586052441742319658, 0
%t5775 = trunc i128 %t5774 to i64
%t5776 = zext i64 %t5775 to i128
%t5777 = icmp ne i128 %t5776, %t5774
%t5778 = icmp slt i128 17586052441742319658, 0
%t5779 = or i1 %t5777, %t5778
%t5780 = zext i1 %t5779 to i8
call void @resid_conv_check(i8 %t5780)
%t5781 = add i64 1182934255886127544, 0
%t5782 = add i64 %t5781, 0
%t5783 = add i64 %t5782, 0
%t5784 = icmp ne i64 %t5783, %t5781
%t5785 = icmp slt i64 1182934255886127544, 0
%t5786 = or i1 %t5784, %t5785
%t5787 = zext i1 %t5786 to i8
call void @resid_conv_check(i8 %t5787)
%t5788 = add i64 1847814050463011016, 0
%t5789 = add i64 %t5788, 0
%t5790 = add i64 %t5789, 0
%t5791 = icmp ne i64 %t5790, %t5788
%t5792 = icmp slt i64 1847814050463011016, 0
%t5793 = or i1 %t5791, %t5792
%t5794 = zext i1 %t5793 to i8
call void @resid_conv_check(i8 %t5794)
%t5795 = add i64 2177327727835720531, 0
%t5796 = add i64 %t5795, 0
%t5797 = add i64 %t5796, 0
%t5798 = icmp ne i64 %t5797, %t5795
%t5799 = icmp slt i64 2177327727835720531, 0
%t5800 = or i1 %t5798, %t5799
%t5801 = zext i1 %t5800 to i8
call void @resid_conv_check(i8 %t5801)
%t5802 = add i64 2830643537854262169, 0
%t5803 = add i64 %t5802, 0
%t5804 = add i64 %t5803, 0
%t5805 = icmp ne i64 %t5804, %t5802
%t5806 = icmp slt i64 2830643537854262169, 0
%t5807 = or i1 %t5805, %t5806
%t5808 = zext i1 %t5807 to i8
call void @resid_conv_check(i8 %t5808)
%t5809 = add i64 3796741975233480872, 0
%t5810 = add i64 %t5809, 0
%t5811 = add i64 %t5810, 0
%t5812 = icmp ne i64 %t5811, %t5809
%t5813 = icmp slt i64 3796741975233480872, 0
%t5814 = or i1 %t5812, %t5813
%t5815 = zext i1 %t5814 to i8
call void @resid_conv_check(i8 %t5815)
%t5816 = add i64 4115178125766777443, 0
%t5817 = add i64 %t5816, 0
%t5818 = add i64 %t5817, 0
%t5819 = icmp ne i64 %t5818, %t5816
%t5820 = icmp slt i64 4115178125766777443, 0
%t5821 = or i1 %t5819, %t5820
%t5822 = zext i1 %t5821 to i8
call void @resid_conv_check(i8 %t5822)
%t5823 = add i64 5681478168544905931, 0
%t5824 = add i64 %t5823, 0
%t5825 = add i64 %t5824, 0
%t5826 = icmp ne i64 %t5825, %t5823
%t5827 = icmp slt i64 5681478168544905931, 0
%t5828 = or i1 %t5826, %t5827
%t5829 = zext i1 %t5828 to i8
call void @resid_conv_check(i8 %t5829)
%t5830 = add i64 6601373596472566643, 0
%t5831 = add i64 %t5830, 0
%t5832 = add i64 %t5831, 0
%t5833 = icmp ne i64 %t5832, %t5830
%t5834 = icmp slt i64 6601373596472566643, 0
%t5835 = or i1 %t5833, %t5834
%t5836 = zext i1 %t5835 to i8
call void @resid_conv_check(i8 %t5836)
%t5837 = add i64 7507060721942968483, 0
%t5838 = add i64 %t5837, 0
%t5839 = add i64 %t5838, 0
%t5840 = icmp ne i64 %t5839, %t5837
%t5841 = icmp slt i64 7507060721942968483, 0
%t5842 = or i1 %t5840, %t5841
%t5843 = zext i1 %t5842 to i8
call void @resid_conv_check(i8 %t5843)
%t5844 = add i64 8399075790359081724, 0
%t5845 = add i64 %t5844, 0
%t5846 = add i64 %t5845, 0
%t5847 = icmp ne i64 %t5846, %t5844
%t5848 = icmp slt i64 8399075790359081724, 0
%t5849 = or i1 %t5847, %t5848
%t5850 = zext i1 %t5849 to i8
call void @resid_conv_check(i8 %t5850)
%t5851 = add i64 8693463985226723168, 0
%t5852 = add i64 %t5851, 0
%t5853 = add i64 %t5852, 0
%t5854 = icmp ne i64 %t5853, %t5851
%t5855 = icmp slt i64 8693463985226723168, 0
%t5856 = or i1 %t5854, %t5855
%t5857 = zext i1 %t5856 to i8
call void @resid_conv_check(i8 %t5857)
%t5858 = add i128 9568029438360202098, 0
%t5859 = trunc i128 %t5858 to i64
%t5860 = zext i64 %t5859 to i128
%t5861 = icmp ne i128 %t5860, %t5858
%t5862 = icmp slt i128 9568029438360202098, 0
%t5863 = or i1 %t5861, %t5862
%t5864 = zext i1 %t5863 to i8
call void @resid_conv_check(i8 %t5864)
%t5865 = add i128 10144078919501101548, 0
%t5866 = trunc i128 %t5865 to i64
%t5867 = zext i64 %t5866 to i128
%t5868 = icmp ne i128 %t5867, %t5865
%t5869 = icmp slt i128 10144078919501101548, 0
%t5870 = or i1 %t5868, %t5869
%t5871 = zext i1 %t5870 to i8
call void @resid_conv_check(i8 %t5871)
%t5872 = add i128 10430055236837252648, 0
%t5873 = trunc i128 %t5872 to i64
%t5874 = zext i64 %t5873 to i128
%t5875 = icmp ne i128 %t5874, %t5872
%t5876 = icmp slt i128 10430055236837252648, 0
%t5877 = or i1 %t5875, %t5876
%t5878 = zext i1 %t5877 to i8
call void @resid_conv_check(i8 %t5878)
%t5879 = add i128 11840083180663258601, 0
%t5880 = trunc i128 %t5879 to i64
%t5881 = zext i64 %t5880 to i128
%t5882 = icmp ne i128 %t5881, %t5879
%t5883 = icmp slt i128 11840083180663258601, 0
%t5884 = or i1 %t5882, %t5883
%t5885 = zext i1 %t5884 to i8
call void @resid_conv_check(i8 %t5885)
%t5886 = add i128 13761210420658862357, 0
%t5887 = trunc i128 %t5886 to i64
%t5888 = zext i64 %t5887 to i128
%t5889 = icmp ne i128 %t5888, %t5886
%t5890 = icmp slt i128 13761210420658862357, 0
%t5891 = or i1 %t5889, %t5890
%t5892 = zext i1 %t5891 to i8
call void @resid_conv_check(i8 %t5892)
%t5893 = add i128 14299343276471374635, 0
%t5894 = trunc i128 %t5893 to i64
%t5895 = zext i64 %t5894 to i128
%t5896 = icmp ne i128 %t5895, %t5893
%t5897 = icmp slt i128 14299343276471374635, 0
%t5898 = or i1 %t5896, %t5897
%t5899 = zext i1 %t5898 to i8
call void @resid_conv_check(i8 %t5899)
%t5900 = add i128 14566680578165727644, 0
%t5901 = trunc i128 %t5900 to i64
%t5902 = zext i64 %t5901 to i128
%t5903 = icmp ne i128 %t5902, %t5900
%t5904 = icmp slt i128 14566680578165727644, 0
%t5905 = or i1 %t5903, %t5904
%t5906 = zext i1 %t5905 to i8
call void @resid_conv_check(i8 %t5906)
%t5907 = add i128 15097957966210449927, 0
%t5908 = trunc i128 %t5907 to i64
%t5909 = zext i64 %t5908 to i128
%t5910 = icmp ne i128 %t5909, %t5907
%t5911 = icmp slt i128 15097957966210449927, 0
%t5912 = or i1 %t5910, %t5911
%t5913 = zext i1 %t5912 to i8
call void @resid_conv_check(i8 %t5913)
%t5914 = add i128 16922976911328602910, 0
%t5915 = trunc i128 %t5914 to i64
%t5916 = zext i64 %t5915 to i128
%t5917 = icmp ne i128 %t5916, %t5914
%t5918 = icmp slt i128 16922976911328602910, 0
%t5919 = or i1 %t5917, %t5918
%t5920 = zext i1 %t5919 to i8
call void @resid_conv_check(i8 %t5920)
%t5921 = add i128 17689382322260857208, 0
%t5922 = trunc i128 %t5921 to i64
%t5923 = zext i64 %t5922 to i128
%t5924 = icmp ne i128 %t5923, %t5921
%t5925 = icmp slt i128 17689382322260857208, 0
%t5926 = or i1 %t5924, %t5925
%t5927 = zext i1 %t5926 to i8
call void @resid_conv_check(i8 %t5927)
%t5928 = add i64 1242879168328830382, 0
%t5929 = add i64 %t5928, 0
%t5930 = add i64 %t5929, 0
%t5931 = icmp ne i64 %t5930, %t5928
%t5932 = icmp slt i64 1242879168328830382, 0
%t5933 = or i1 %t5931, %t5932
%t5934 = zext i1 %t5933 to i8
call void @resid_conv_check(i8 %t5934)
%t5935 = add i64 1977374033974150939, 0
%t5936 = add i64 %t5935, 0
%t5937 = add i64 %t5936, 0
%t5938 = icmp ne i64 %t5937, %t5935
%t5939 = icmp slt i64 1977374033974150939, 0
%t5940 = or i1 %t5938, %t5939
%t5941 = zext i1 %t5940 to i8
call void @resid_conv_check(i8 %t5941)
%t5942 = add i64 2944078676154940804, 0
%t5943 = add i64 %t5942, 0
%t5944 = add i64 %t5943, 0
%t5945 = icmp ne i64 %t5944, %t5942
%t5946 = icmp slt i64 2944078676154940804, 0
%t5947 = or i1 %t5945, %t5946
%t5948 = zext i1 %t5947 to i8
call void @resid_conv_check(i8 %t5948)
%t5949 = add i64 3659926193048069267, 0
%t5950 = add i64 %t5949, 0
%t5951 = add i64 %t5950, 0
%t5952 = icmp ne i64 %t5951, %t5949
%t5953 = icmp slt i64 3659926193048069267, 0
%t5954 = or i1 %t5952, %t5953
%t5955 = zext i1 %t5954 to i8
call void @resid_conv_check(i8 %t5955)
%t5956 = add i64 4368137639120453308, 0
%t5957 = add i64 %t5956, 0
%t5958 = add i64 %t5957, 0
%t5959 = icmp ne i64 %t5958, %t5956
%t5960 = icmp slt i64 4368137639120453308, 0
%t5961 = or i1 %t5959, %t5960
%t5962 = zext i1 %t5961 to i8
call void @resid_conv_check(i8 %t5962)
%t5963 = add i64 4836135668995329356, 0
%t5964 = add i64 %t5963, 0
%t5965 = add i64 %t5964, 0
%t5966 = icmp ne i64 %t5965, %t5963
%t5967 = icmp slt i64 4836135668995329356, 0
%t5968 = or i1 %t5966, %t5967
%t5969 = zext i1 %t5968 to i8
call void @resid_conv_check(i8 %t5969)
%t5970 = add i64 5532061633213252278, 0
%t5971 = add i64 %t5970, 0
%t5972 = add i64 %t5971, 0
%t5973 = icmp ne i64 %t5972, %t5970
%t5974 = icmp slt i64 5532061633213252278, 0
%t5975 = or i1 %t5973, %t5974
%t5976 = zext i1 %t5975 to i8
call void @resid_conv_check(i8 %t5976)
%t5977 = add i64 6448918945643986474, 0
%t5978 = add i64 %t5977, 0
%t5979 = add i64 %t5978, 0
%t5980 = icmp ne i64 %t5979, %t5977
%t5981 = icmp slt i64 6448918945643986474, 0
%t5982 = or i1 %t5980, %t5981
%t5983 = zext i1 %t5982 to i8
call void @resid_conv_check(i8 %t5983)
%t5984 = add i64 6902733635092675308, 0
%t5985 = add i64 %t5984, 0
%t5986 = add i64 %t5985, 0
%t5987 = icmp ne i64 %t5986, %t5984
%t5988 = icmp slt i64 6902733635092675308, 0
%t5989 = or i1 %t5987, %t5988
%t5990 = zext i1 %t5989 to i8
call void @resid_conv_check(i8 %t5990)
%t5991 = add i64 7801388544844847127, 0
%t5992 = add i64 %t5991, 0
%t5993 = add i64 %t5992, 0
%t5994 = icmp ne i64 %t5993, %t5991
%t5995 = icmp slt i64 7801388544844847127, 0
%t5996 = or i1 %t5994, %t5995
%t5997 = zext i1 %t5996 to i8
call void @resid_conv_check(i8 %t5997)
%t5998 = alloca [80 x ptr]
%t6000 = call ptr @resid_box_i64(i64 %t5460)
%t6002 = getelementptr i8, ptr %t5998, i64 0
store ptr %t6000, ptr %t6002
%t6003 = call ptr @resid_box_i64(i64 %t5467)
%t6005 = getelementptr i8, ptr %t5998, i64 8
store ptr %t6003, ptr %t6005
%t6006 = call ptr @resid_box_i64(i64 %t5474)
%t6008 = getelementptr i8, ptr %t5998, i64 16
store ptr %t6006, ptr %t6008
%t6009 = call ptr @resid_box_i64(i64 %t5481)
%t6011 = getelementptr i8, ptr %t5998, i64 24
store ptr %t6009, ptr %t6011
%t6012 = call ptr @resid_box_i64(i64 %t5488)
%t6014 = getelementptr i8, ptr %t5998, i64 32
store ptr %t6012, ptr %t6014
%t6015 = call ptr @resid_box_i64(i64 %t5495)
%t6017 = getelementptr i8, ptr %t5998, i64 40
store ptr %t6015, ptr %t6017
%t6018 = call ptr @resid_box_i64(i64 %t5502)
%t6020 = getelementptr i8, ptr %t5998, i64 48
store ptr %t6018, ptr %t6020
%t6021 = call ptr @resid_box_i64(i64 %t5509)
%t6023 = getelementptr i8, ptr %t5998, i64 56
store ptr %t6021, ptr %t6023
%t6024 = call ptr @resid_box_i64(i64 %t5516)
%t6026 = getelementptr i8, ptr %t5998, i64 64
store ptr %t6024, ptr %t6026
%t6027 = call ptr @resid_box_i64(i64 %t5523)
%t6029 = getelementptr i8, ptr %t5998, i64 72
store ptr %t6027, ptr %t6029
%t6030 = call ptr @resid_box_i64(i64 %t5530)
%t6032 = getelementptr i8, ptr %t5998, i64 80
store ptr %t6030, ptr %t6032
%t6033 = call ptr @resid_box_i64(i64 %t5537)
%t6035 = getelementptr i8, ptr %t5998, i64 88
store ptr %t6033, ptr %t6035
%t6036 = call ptr @resid_box_i64(i64 %t5544)
%t6038 = getelementptr i8, ptr %t5998, i64 96
store ptr %t6036, ptr %t6038
%t6039 = call ptr @resid_box_i64(i64 %t5551)
%t6041 = getelementptr i8, ptr %t5998, i64 104
store ptr %t6039, ptr %t6041
%t6042 = call ptr @resid_box_i64(i64 %t5558)
%t6044 = getelementptr i8, ptr %t5998, i64 112
store ptr %t6042, ptr %t6044
%t6045 = call ptr @resid_box_i64(i64 %t5565)
%t6047 = getelementptr i8, ptr %t5998, i64 120
store ptr %t6045, ptr %t6047
%t6048 = call ptr @resid_box_i64(i64 %t5572)
%t6050 = getelementptr i8, ptr %t5998, i64 128
store ptr %t6048, ptr %t6050
%t6051 = call ptr @resid_box_i64(i64 %t5579)
%t6053 = getelementptr i8, ptr %t5998, i64 136
store ptr %t6051, ptr %t6053
%t6054 = call ptr @resid_box_i64(i64 %t5586)
%t6056 = getelementptr i8, ptr %t5998, i64 144
store ptr %t6054, ptr %t6056
%t6057 = call ptr @resid_box_i64(i64 %t5593)
%t6059 = getelementptr i8, ptr %t5998, i64 152
store ptr %t6057, ptr %t6059
%t6060 = call ptr @resid_box_i64(i64 %t5600)
%t6062 = getelementptr i8, ptr %t5998, i64 160
store ptr %t6060, ptr %t6062
%t6063 = call ptr @resid_box_i64(i64 %t5607)
%t6065 = getelementptr i8, ptr %t5998, i64 168
store ptr %t6063, ptr %t6065
%t6066 = call ptr @resid_box_i64(i64 %t5614)
%t6068 = getelementptr i8, ptr %t5998, i64 176
store ptr %t6066, ptr %t6068
%t6069 = call ptr @resid_box_i64(i64 %t5621)
%t6071 = getelementptr i8, ptr %t5998, i64 184
store ptr %t6069, ptr %t6071
%t6072 = call ptr @resid_box_i64(i64 %t5628)
%t6074 = getelementptr i8, ptr %t5998, i64 192
store ptr %t6072, ptr %t6074
%t6075 = call ptr @resid_box_i64(i64 %t5635)
%t6077 = getelementptr i8, ptr %t5998, i64 200
store ptr %t6075, ptr %t6077
%t6078 = call ptr @resid_box_i64(i64 %t5642)
%t6080 = getelementptr i8, ptr %t5998, i64 208
store ptr %t6078, ptr %t6080
%t6081 = call ptr @resid_box_i64(i64 %t5649)
%t6083 = getelementptr i8, ptr %t5998, i64 216
store ptr %t6081, ptr %t6083
%t6084 = call ptr @resid_box_i64(i64 %t5656)
%t6086 = getelementptr i8, ptr %t5998, i64 224
store ptr %t6084, ptr %t6086
%t6087 = call ptr @resid_box_i64(i64 %t5663)
%t6089 = getelementptr i8, ptr %t5998, i64 232
store ptr %t6087, ptr %t6089
%t6090 = call ptr @resid_box_i64(i64 489312712824947311)
%t6092 = getelementptr i8, ptr %t5998, i64 240
store ptr %t6090, ptr %t6092
%t6093 = call ptr @resid_box_i64(i64 %t5670)
%t6095 = getelementptr i8, ptr %t5998, i64 248
store ptr %t6093, ptr %t6095
%t6096 = call ptr @resid_box_i64(i64 %t5677)
%t6098 = getelementptr i8, ptr %t5998, i64 256
store ptr %t6096, ptr %t6098
%t6099 = call ptr @resid_box_i64(i64 %t5684)
%t6101 = getelementptr i8, ptr %t5998, i64 264
store ptr %t6099, ptr %t6101
%t6102 = call ptr @resid_box_i64(i64 %t5691)
%t6104 = getelementptr i8, ptr %t5998, i64 272
store ptr %t6102, ptr %t6104
%t6105 = call ptr @resid_box_i64(i64 %t5698)
%t6107 = getelementptr i8, ptr %t5998, i64 280
store ptr %t6105, ptr %t6107
%t6108 = call ptr @resid_box_i64(i64 %t5705)
%t6110 = getelementptr i8, ptr %t5998, i64 288
store ptr %t6108, ptr %t6110
%t6111 = call ptr @resid_box_i64(i64 %t5712)
%t6113 = getelementptr i8, ptr %t5998, i64 296
store ptr %t6111, ptr %t6113
%t6114 = call ptr @resid_box_i64(i64 %t5719)
%t6116 = getelementptr i8, ptr %t5998, i64 304
store ptr %t6114, ptr %t6116
%t6117 = call ptr @resid_box_i64(i64 %t5726)
%t6119 = getelementptr i8, ptr %t5998, i64 312
store ptr %t6117, ptr %t6119
%t6120 = call ptr @resid_box_i64(i64 %t5733)
%t6122 = getelementptr i8, ptr %t5998, i64 320
store ptr %t6120, ptr %t6122
%t6123 = call ptr @resid_box_i64(i64 %t5740)
%t6125 = getelementptr i8, ptr %t5998, i64 328
store ptr %t6123, ptr %t6125
%t6126 = call ptr @resid_box_i64(i64 %t5747)
%t6128 = getelementptr i8, ptr %t5998, i64 336
store ptr %t6126, ptr %t6128
%t6129 = call ptr @resid_box_i64(i64 %t5754)
%t6131 = getelementptr i8, ptr %t5998, i64 344
store ptr %t6129, ptr %t6131
%t6132 = call ptr @resid_box_i64(i64 %t5761)
%t6134 = getelementptr i8, ptr %t5998, i64 352
store ptr %t6132, ptr %t6134
%t6135 = call ptr @resid_box_i64(i64 %t5768)
%t6137 = getelementptr i8, ptr %t5998, i64 360
store ptr %t6135, ptr %t6137
%t6138 = call ptr @resid_box_i64(i64 %t5775)
%t6140 = getelementptr i8, ptr %t5998, i64 368
store ptr %t6138, ptr %t6140
%t6141 = call ptr @resid_box_i64(i64 %t5782)
%t6143 = getelementptr i8, ptr %t5998, i64 376
store ptr %t6141, ptr %t6143
%t6144 = call ptr @resid_box_i64(i64 %t5789)
%t6146 = getelementptr i8, ptr %t5998, i64 384
store ptr %t6144, ptr %t6146
%t6147 = call ptr @resid_box_i64(i64 %t5796)
%t6149 = getelementptr i8, ptr %t5998, i64 392
store ptr %t6147, ptr %t6149
%t6150 = call ptr @resid_box_i64(i64 %t5803)
%t6152 = getelementptr i8, ptr %t5998, i64 400
store ptr %t6150, ptr %t6152
%t6153 = call ptr @resid_box_i64(i64 %t5810)
%t6155 = getelementptr i8, ptr %t5998, i64 408
store ptr %t6153, ptr %t6155
%t6156 = call ptr @resid_box_i64(i64 %t5817)
%t6158 = getelementptr i8, ptr %t5998, i64 416
store ptr %t6156, ptr %t6158
%t6159 = call ptr @resid_box_i64(i64 %t5824)
%t6161 = getelementptr i8, ptr %t5998, i64 424
store ptr %t6159, ptr %t6161
%t6162 = call ptr @resid_box_i64(i64 %t5831)
%t6164 = getelementptr i8, ptr %t5998, i64 432
store ptr %t6162, ptr %t6164
%t6165 = call ptr @resid_box_i64(i64 %t5838)
%t6167 = getelementptr i8, ptr %t5998, i64 440
store ptr %t6165, ptr %t6167
%t6168 = call ptr @resid_box_i64(i64 %t5845)
%t6170 = getelementptr i8, ptr %t5998, i64 448
store ptr %t6168, ptr %t6170
%t6171 = call ptr @resid_box_i64(i64 %t5852)
%t6173 = getelementptr i8, ptr %t5998, i64 456
store ptr %t6171, ptr %t6173
%t6174 = call ptr @resid_box_i64(i64 %t5859)
%t6176 = getelementptr i8, ptr %t5998, i64 464
store ptr %t6174, ptr %t6176
%t6177 = call ptr @resid_box_i64(i64 %t5866)
%t6179 = getelementptr i8, ptr %t5998, i64 472
store ptr %t6177, ptr %t6179
%t6180 = call ptr @resid_box_i64(i64 %t5873)
%t6182 = getelementptr i8, ptr %t5998, i64 480
store ptr %t6180, ptr %t6182
%t6183 = call ptr @resid_box_i64(i64 %t5880)
%t6185 = getelementptr i8, ptr %t5998, i64 488
store ptr %t6183, ptr %t6185
%t6186 = call ptr @resid_box_i64(i64 %t5887)
%t6188 = getelementptr i8, ptr %t5998, i64 496
store ptr %t6186, ptr %t6188
%t6189 = call ptr @resid_box_i64(i64 %t5894)
%t6191 = getelementptr i8, ptr %t5998, i64 504
store ptr %t6189, ptr %t6191
%t6192 = call ptr @resid_box_i64(i64 %t5901)
%t6194 = getelementptr i8, ptr %t5998, i64 512
store ptr %t6192, ptr %t6194
%t6195 = call ptr @resid_box_i64(i64 %t5908)
%t6197 = getelementptr i8, ptr %t5998, i64 520
store ptr %t6195, ptr %t6197
%t6198 = call ptr @resid_box_i64(i64 %t5915)
%t6200 = getelementptr i8, ptr %t5998, i64 528
store ptr %t6198, ptr %t6200
%t6201 = call ptr @resid_box_i64(i64 %t5922)
%t6203 = getelementptr i8, ptr %t5998, i64 536
store ptr %t6201, ptr %t6203
%t6204 = call ptr @resid_box_i64(i64 500013540394364858)
%t6206 = getelementptr i8, ptr %t5998, i64 544
store ptr %t6204, ptr %t6206
%t6207 = call ptr @resid_box_i64(i64 748580250866718886)
%t6209 = getelementptr i8, ptr %t5998, i64 552
store ptr %t6207, ptr %t6209
%t6210 = call ptr @resid_box_i64(i64 %t5929)
%t6212 = getelementptr i8, ptr %t5998, i64 560
store ptr %t6210, ptr %t6212
%t6213 = call ptr @resid_box_i64(i64 %t5936)
%t6215 = getelementptr i8, ptr %t5998, i64 568
store ptr %t6213, ptr %t6215
%t6216 = call ptr @resid_box_i64(i64 %t5943)
%t6218 = getelementptr i8, ptr %t5998, i64 576
store ptr %t6216, ptr %t6218
%t6219 = call ptr @resid_box_i64(i64 %t5950)
%t6221 = getelementptr i8, ptr %t5998, i64 584
store ptr %t6219, ptr %t6221
%t6222 = call ptr @resid_box_i64(i64 %t5957)
%t6224 = getelementptr i8, ptr %t5998, i64 592
store ptr %t6222, ptr %t6224
%t6225 = call ptr @resid_box_i64(i64 %t5964)
%t6227 = getelementptr i8, ptr %t5998, i64 600
store ptr %t6225, ptr %t6227
%t6228 = call ptr @resid_box_i64(i64 %t5971)
%t6230 = getelementptr i8, ptr %t5998, i64 608
store ptr %t6228, ptr %t6230
%t6231 = call ptr @resid_box_i64(i64 %t5978)
%t6233 = getelementptr i8, ptr %t5998, i64 616
store ptr %t6231, ptr %t6233
%t6234 = call ptr @resid_box_i64(i64 %t5985)
%t6236 = getelementptr i8, ptr %t5998, i64 624
store ptr %t6234, ptr %t6236
%t6237 = call ptr @resid_box_i64(i64 %t5992)
%t6239 = getelementptr i8, ptr %t5998, i64 632
store ptr %t6237, ptr %t6239
%t6240 = call ptr @resid_list_new(i64 80, ptr %t5998, ptr @.lty5998)
ret ptr %t6240
}
define ptr @sha512g_iv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6241 = add i64 7640891576956012808, 0
%t6242 = add i64 %t6241, 0
%t6243 = add i64 %t6242, 0
%t6244 = icmp ne i64 %t6243, %t6241
%t6245 = icmp slt i64 7640891576956012808, 0
%t6246 = or i1 %t6244, %t6245
%t6247 = zext i1 %t6246 to i8
call void @resid_conv_check(i8 %t6247)
%t6248 = add i128 13503953896175478587, 0
%t6249 = trunc i128 %t6248 to i64
%t6250 = zext i64 %t6249 to i128
%t6251 = icmp ne i128 %t6250, %t6248
%t6252 = icmp slt i128 13503953896175478587, 0
%t6253 = or i1 %t6251, %t6252
%t6254 = zext i1 %t6253 to i8
call void @resid_conv_check(i8 %t6254)
%t6255 = add i64 4354685564936845355, 0
%t6256 = add i64 %t6255, 0
%t6257 = add i64 %t6256, 0
%t6258 = icmp ne i64 %t6257, %t6255
%t6259 = icmp slt i64 4354685564936845355, 0
%t6260 = or i1 %t6258, %t6259
%t6261 = zext i1 %t6260 to i8
call void @resid_conv_check(i8 %t6261)
%t6262 = add i128 11912009170470909681, 0
%t6263 = trunc i128 %t6262 to i64
%t6264 = zext i64 %t6263 to i128
%t6265 = icmp ne i128 %t6264, %t6262
%t6266 = icmp slt i128 11912009170470909681, 0
%t6267 = or i1 %t6265, %t6266
%t6268 = zext i1 %t6267 to i8
call void @resid_conv_check(i8 %t6268)
%t6269 = add i64 5840696475078001361, 0
%t6270 = add i64 %t6269, 0
%t6271 = add i64 %t6270, 0
%t6272 = icmp ne i64 %t6271, %t6269
%t6273 = icmp slt i64 5840696475078001361, 0
%t6274 = or i1 %t6272, %t6273
%t6275 = zext i1 %t6274 to i8
call void @resid_conv_check(i8 %t6275)
%t6276 = add i128 11170449401992604703, 0
%t6277 = trunc i128 %t6276 to i64
%t6278 = zext i64 %t6277 to i128
%t6279 = icmp ne i128 %t6278, %t6276
%t6280 = icmp slt i128 11170449401992604703, 0
%t6281 = or i1 %t6279, %t6280
%t6282 = zext i1 %t6281 to i8
call void @resid_conv_check(i8 %t6282)
%t6283 = add i64 2270897969802886507, 0
%t6284 = add i64 %t6283, 0
%t6285 = add i64 %t6284, 0
%t6286 = icmp ne i64 %t6285, %t6283
%t6287 = icmp slt i64 2270897969802886507, 0
%t6288 = or i1 %t6286, %t6287
%t6289 = zext i1 %t6288 to i8
call void @resid_conv_check(i8 %t6289)
%t6290 = add i64 6620516959819538809, 0
%t6291 = add i64 %t6290, 0
%t6292 = add i64 %t6291, 0
%t6293 = icmp ne i64 %t6292, %t6290
%t6294 = icmp slt i64 6620516959819538809, 0
%t6295 = or i1 %t6293, %t6294
%t6296 = zext i1 %t6295 to i8
call void @resid_conv_check(i8 %t6296)
%t6297 = alloca [8 x ptr]
%t6299 = call ptr @resid_box_i64(i64 %t6242)
%t6301 = getelementptr i8, ptr %t6297, i64 0
store ptr %t6299, ptr %t6301
%t6302 = call ptr @resid_box_i64(i64 %t6249)
%t6304 = getelementptr i8, ptr %t6297, i64 8
store ptr %t6302, ptr %t6304
%t6305 = call ptr @resid_box_i64(i64 %t6256)
%t6307 = getelementptr i8, ptr %t6297, i64 16
store ptr %t6305, ptr %t6307
%t6308 = call ptr @resid_box_i64(i64 %t6263)
%t6310 = getelementptr i8, ptr %t6297, i64 24
store ptr %t6308, ptr %t6310
%t6311 = call ptr @resid_box_i64(i64 %t6270)
%t6313 = getelementptr i8, ptr %t6297, i64 32
store ptr %t6311, ptr %t6313
%t6314 = call ptr @resid_box_i64(i64 %t6277)
%t6316 = getelementptr i8, ptr %t6297, i64 40
store ptr %t6314, ptr %t6316
%t6317 = call ptr @resid_box_i64(i64 %t6284)
%t6319 = getelementptr i8, ptr %t6297, i64 48
store ptr %t6317, ptr %t6319
%t6320 = call ptr @resid_box_i64(i64 %t6291)
%t6322 = getelementptr i8, ptr %t6297, i64 56
store ptr %t6320, ptr %t6322
%t6323 = call ptr @resid_list_new(i64 8, ptr %t6297, ptr @.lty6297)
ret ptr %t6323
}
define ptr @sha384g_iv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6324 = add i128 14680500436340154072, 0
%t6325 = trunc i128 %t6324 to i64
%t6326 = zext i64 %t6325 to i128
%t6327 = icmp ne i128 %t6326, %t6324
%t6328 = icmp slt i128 14680500436340154072, 0
%t6329 = or i1 %t6327, %t6328
%t6330 = zext i1 %t6329 to i8
call void @resid_conv_check(i8 %t6330)
%t6331 = add i64 7105036623409894663, 0
%t6332 = add i64 %t6331, 0
%t6333 = add i64 %t6332, 0
%t6334 = icmp ne i64 %t6333, %t6331
%t6335 = icmp slt i64 7105036623409894663, 0
%t6336 = or i1 %t6334, %t6335
%t6337 = zext i1 %t6336 to i8
call void @resid_conv_check(i8 %t6337)
%t6338 = add i128 10473403895298186519, 0
%t6339 = trunc i128 %t6338 to i64
%t6340 = zext i64 %t6339 to i128
%t6341 = icmp ne i128 %t6340, %t6338
%t6342 = icmp slt i128 10473403895298186519, 0
%t6343 = or i1 %t6341, %t6342
%t6344 = zext i1 %t6343 to i8
call void @resid_conv_check(i8 %t6344)
%t6345 = add i64 1526699215303891257, 0
%t6346 = add i64 %t6345, 0
%t6347 = add i64 %t6346, 0
%t6348 = icmp ne i64 %t6347, %t6345
%t6349 = icmp slt i64 1526699215303891257, 0
%t6350 = or i1 %t6348, %t6349
%t6351 = zext i1 %t6350 to i8
call void @resid_conv_check(i8 %t6351)
%t6352 = add i64 7436329637833083697, 0
%t6353 = add i64 %t6352, 0
%t6354 = add i64 %t6353, 0
%t6355 = icmp ne i64 %t6354, %t6352
%t6356 = icmp slt i64 7436329637833083697, 0
%t6357 = or i1 %t6355, %t6356
%t6358 = zext i1 %t6357 to i8
call void @resid_conv_check(i8 %t6358)
%t6359 = add i128 10282925794625328401, 0
%t6360 = trunc i128 %t6359 to i64
%t6361 = zext i64 %t6360 to i128
%t6362 = icmp ne i128 %t6361, %t6359
%t6363 = icmp slt i128 10282925794625328401, 0
%t6364 = or i1 %t6362, %t6363
%t6365 = zext i1 %t6364 to i8
call void @resid_conv_check(i8 %t6365)
%t6366 = add i128 15784041429090275239, 0
%t6367 = trunc i128 %t6366 to i64
%t6368 = zext i64 %t6367 to i128
%t6369 = icmp ne i128 %t6368, %t6366
%t6370 = icmp slt i128 15784041429090275239, 0
%t6371 = or i1 %t6369, %t6370
%t6372 = zext i1 %t6371 to i8
call void @resid_conv_check(i8 %t6372)
%t6373 = add i64 5167115440072839076, 0
%t6374 = add i64 %t6373, 0
%t6375 = add i64 %t6374, 0
%t6376 = icmp ne i64 %t6375, %t6373
%t6377 = icmp slt i64 5167115440072839076, 0
%t6378 = or i1 %t6376, %t6377
%t6379 = zext i1 %t6378 to i8
call void @resid_conv_check(i8 %t6379)
%t6380 = alloca [8 x ptr]
%t6382 = call ptr @resid_box_i64(i64 %t6325)
%t6384 = getelementptr i8, ptr %t6380, i64 0
store ptr %t6382, ptr %t6384
%t6385 = call ptr @resid_box_i64(i64 %t6332)
%t6387 = getelementptr i8, ptr %t6380, i64 8
store ptr %t6385, ptr %t6387
%t6388 = call ptr @resid_box_i64(i64 %t6339)
%t6390 = getelementptr i8, ptr %t6380, i64 16
store ptr %t6388, ptr %t6390
%t6391 = call ptr @resid_box_i64(i64 %t6346)
%t6393 = getelementptr i8, ptr %t6380, i64 24
store ptr %t6391, ptr %t6393
%t6394 = call ptr @resid_box_i64(i64 %t6353)
%t6396 = getelementptr i8, ptr %t6380, i64 32
store ptr %t6394, ptr %t6396
%t6397 = call ptr @resid_box_i64(i64 %t6360)
%t6399 = getelementptr i8, ptr %t6380, i64 40
store ptr %t6397, ptr %t6399
%t6400 = call ptr @resid_box_i64(i64 %t6367)
%t6402 = getelementptr i8, ptr %t6380, i64 48
store ptr %t6400, ptr %t6402
%t6403 = call ptr @resid_box_i64(i64 %t6374)
%t6405 = getelementptr i8, ptr %t6380, i64 56
store ptr %t6403, ptr %t6405
%t6406 = call ptr @resid_list_new(i64 8, ptr %t6380, ptr @.lty6380)
ret ptr %t6406
}
define ptr @sha512g_pad(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6407 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p0, i64 17)
%t6408 = extractvalue {i64, i1} %t6407, 0
%t6409 = extractvalue {i64, i1} %t6407, 1
%t6410 = zext i1 %t6409 to i8
call void @resid_overflow_check(i8 %t6410)
%t6411 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t6408, i64 127)
%t6412 = extractvalue {i64, i1} %t6411, 0
%t6413 = extractvalue {i64, i1} %t6411, 1
%t6414 = zext i1 %t6413 to i8
call void @resid_overflow_check(i8 %t6414)
%t6415 = sdiv i64 %t6412, 128
%t6416 = mul nsw i64 %t6415, 128
%t6417 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t6416, i64 %p0)
%t6418 = extractvalue {i64, i1} %t6417, 0
%t6419 = extractvalue {i64, i1} %t6417, 1
%t6420 = zext i1 %t6419 to i8
call void @resid_overflow_check(i8 %t6420)
%t6421 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t6418, i64 17)
%t6422 = extractvalue {i64, i1} %t6421, 0
%t6423 = extractvalue {i64, i1} %t6421, 1
%t6424 = zext i1 %t6423 to i8
call void @resid_overflow_check(i8 %t6424)
%t6425 = call ptr @resid_listbuf_new()
%t6426 = call ptr @__m____________lib_sha512g_resid__sha512g_pad_at(i64 %p0, i64 %t6422, i64 0, ptr %t6425)
%t6427 = call ptr @resid_listbuf_finish(ptr %t6426, ptr @.lty6427)
ret ptr %t6427
}
define ptr @__m____________lib_sha512g_resid__sha512g_pad_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ], [ %p0, %tco.s2 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ], [ %p1, %tco.s2 ]
%p2 = phi i64 [ %p2.in, %entry ], [ 1, %tco.s0 ], [ %t6440, %tco.s1 ], [ %t6466, %tco.s2 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t6432, %tco.s0 ], [ %t6446, %tco.s1 ], [ %t6483, %tco.s2 ]
%t6428 = icmp eq i64 %p2, 0
br i1 %t6428, label %L637, label %L639
L637:
%t6429 = call ptr @resid_box_i64(i64 128)
%t6432 = call ptr @resid_listbuf_push(ptr %p3, ptr %t6429)
br label %tco.s0
tco.s0:
br label %tco.head
L639:
%t6434 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 8)
%t6435 = extractvalue {i64, i1} %t6434, 0
%t6436 = extractvalue {i64, i1} %t6434, 1
%t6437 = zext i1 %t6436 to i8
call void @resid_overflow_check(i8 %t6437)
%t6438 = icmp sle i64 %p2, %t6435
br i1 %t6438, label %L640, label %L642
L640:
%t6439 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t6440 = extractvalue {i64, i1} %t6439, 0
%t6441 = extractvalue {i64, i1} %t6439, 1
%t6442 = zext i1 %t6441 to i8
call void @resid_overflow_check(i8 %t6442)
%t6443 = call ptr @resid_box_i64(i64 0)
%t6446 = call ptr @resid_listbuf_push(ptr %p3, ptr %t6443)
br label %tco.s1
tco.s1:
br label %tco.head
L642:
%t6448 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 16)
%t6449 = extractvalue {i64, i1} %t6448, 0
%t6450 = extractvalue {i64, i1} %t6448, 1
%t6451 = zext i1 %t6450 to i8
call void @resid_overflow_check(i8 %t6451)
%t6452 = icmp sle i64 %p2, %t6449
br i1 %t6452, label %L643, label %L645
L643:
%t6453 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 16)
%t6454 = extractvalue {i64, i1} %t6453, 0
%t6455 = extractvalue {i64, i1} %t6453, 1
%t6456 = zext i1 %t6455 to i8
call void @resid_overflow_check(i8 %t6456)
%t6457 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t6454, i64 %p2)
%t6458 = extractvalue {i64, i1} %t6457, 0
%t6459 = extractvalue {i64, i1} %t6457, 1
%t6460 = zext i1 %t6459 to i8
call void @resid_overflow_check(i8 %t6460)
%t6461 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t6458, i64 8)
%t6462 = extractvalue {i64, i1} %t6461, 0
%t6463 = extractvalue {i64, i1} %t6461, 1
%t6464 = zext i1 %t6463 to i8
call void @resid_overflow_check(i8 %t6464)
%t6465 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t6466 = extractvalue {i64, i1} %t6465, 0
%t6467 = extractvalue {i64, i1} %t6465, 1
%t6468 = zext i1 %t6467 to i8
call void @resid_overflow_check(i8 %t6468)
%t6469 = icmp sge i64 %t6462, 61
br i1 %t6469, label %L646, label %L647
L646:
br label %L648
L647:
%t6470 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p0, i64 8)
%t6471 = extractvalue {i64, i1} %t6470, 0
%t6472 = extractvalue {i64, i1} %t6470, 1
%t6473 = zext i1 %t6472 to i8
call void @resid_overflow_check(i8 %t6473)
%t6474 = icmp uge i64 %t6462, 64
%t6475 = add i64 %t6462, 0
%t6476 = select i1 %t6474, i64 63, i64 %t6475
%t6477 = ashr i64 %t6471, %t6476
%t6478 = and i64 %t6477, 255
br label %L648
L648:
%t6479 = phi i64 [ 0, %L646 ], [ %t6478, %L647 ]
%t6480 = call ptr @resid_box_i64(i64 %t6479)
%t6483 = call ptr @resid_listbuf_push(ptr %p3, ptr %t6480)
br label %tco.s2
tco.s2:
br label %tco.head
L645:
ret ptr %p3
}
define ptr @__m____________lib_sha512g_resid__sha512g_zero_bytes(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6487, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t6491, %tco.s0 ]
%t6485 = icmp sge i64 %p1, %p0
br i1 %t6485, label %L649, label %L651
L649:
%t6486 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty6486)
ret ptr %t6486
L651:
%t6487 = add nsw i64 %p1, 1
%t6488 = call ptr @resid_box_i64(i64 0)
%t6491 = call ptr @resid_listbuf_push(ptr %p2, ptr %t6488)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @eg_p() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6493 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
ret i512 %t6493
}
define i512 @eg_d() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6494 = sext i256 37095705934669439343138083508754565189542113879843219016388785533085940283555 to i512
ret i512 %t6494
}
define i512 @eg_l() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6495 = sext i256 7237005577332262213973186563042994240857116359379907606001950938285454250989 to i512
ret i512 %t6495
}
define i512 @eg_bx() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6496 = sext i256 15112221349535400772501151409588531511454012693041857206046113283949847762202 to i512
ret i512 %t6496
}
define i512 @eg_by() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6497 = sext i256 46316835694926478169428394003475163141307993866256225615783033603165251855960 to i512
ret i512 %t6497
}
define i512 @__m____________lib_ed25519g_resid__eg_m256() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i512 115792089237316195423570985008687907853269984665640564039457584007913129639935
}
define i512 @__m____________lib_ed25519g_resid__eg_ones() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6498 = sext i64 -1 to i512
ret i512 %t6498
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
%t6499 = call i256 @fe_mul(i256 15112221349535400772501151409588531511454012693041857206046113283949847762202, i256 46316835694926478169428394003475163141307993866256225615783033603165251855960)
ret i256 %t6499
}
define i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6500 = sext i256 %p0 to i512
ret i512 %t6500
}
define i256 @fe_add(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6501 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6502 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t6503 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t6501, i512 %t6502)
%t6504 = trunc i512 %t6503 to i256
ret i256 %t6504
}
define i256 @fe_sub(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6505 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6506 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t6507 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t6505, i512 %t6506)
%t6508 = trunc i512 %t6507 to i256
ret i256 %t6508
}
define i256 @fe_mul(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6509 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6510 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t6511 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t6509, i512 %t6510)
%t6512 = trunc i512 %t6511 to i256
ret i256 %t6512
}
define i256 @fe_sq(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6513 = call i256 @fe_mul(i256 %p0, i256 %p0)
ret i256 %t6513
}
define i256 @fe_inv(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6514 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6515 = call i512 @eg_finv__g_Int_512__Int_64_(i512 %t6514)
%t6516 = trunc i512 %t6515 to i256
ret i256 %t6516
}
define i256 @pow_acc(i256 %p0, i256 %p1, i256 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6517 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6518 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t6519 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p2)
%t6520 = call i512 @eg_fpow__g_Int_512__Int_64_(i512 %t6517, i512 %t6518, i512 %t6519, i64 %p3)
%t6521 = trunc i512 %t6520 to i256
ret i256 %t6521
}
define i256 @bytes_to_int(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6522 = sext i64 0 to i256
%t6523 = call i256 @b2a(ptr %p0, i256 %t6522, i64 31)
ret i256 %t6523
}
define i256 @b2a(ptr %p0.in, i256 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i256 [ %p1.in, %entry ], [ %t6537, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6538, %tco.s0 ]
%t6524 = icmp slt i64 %p2, 0
br i1 %t6524, label %L652, label %L654
L652:
ret i256 %p1
L654:
%t6525 = icmp eq i64 %p2, 31
br i1 %t6525, label %L655, label %L656
L655:
%t6526 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t6527 = call i64 @resid_unbox_i64(ptr %t6526)
%t6529 = and i64 %t6527, 127
br label %L657
L656:
%t6530 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t6531 = call i64 @resid_unbox_i64(ptr %t6530)
%t6533 = and i64 %t6531, 255
br label %L657
L657:
%t6534 = phi i64 [ %t6529, %L655 ], [ %t6533, %L656 ]
%t6535 = shl i256 %p1, 8
%t6536 = sext i64 %t6534 to i256
%t6537 = or i256 %t6535, %t6536
%t6538 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @int_to_bytes(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6540 = call ptr @resid_listbuf_new()
%t6541 = call ptr @__m____________lib_ed25519_resid__itob_acc(i256 %p0, i64 0, ptr %t6540)
ret ptr %t6541
}
define ptr @__m____________lib_ed25519_resid__itob_acc(i256 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i256 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6544, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t6559, %tco.s0 ]
%t6542 = icmp sgt i64 %p1, 31
br i1 %t6542, label %L658, label %L660
L658:
%t6543 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty6543)
ret ptr %t6543
L660:
%t6544 = add nsw i64 %p1, 1
%t6545 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t6546 = extractvalue {i64, i1} %t6545, 0
%t6547 = extractvalue {i64, i1} %t6545, 1
%t6548 = zext i1 %t6547 to i8
call void @resid_overflow_check(i8 %t6548)
%t6549 = sext i64 %t6546 to i256
%t6550 = icmp uge i256 %t6549, 256
%t6551 = add i256 %t6549, 0
%t6552 = select i1 %t6550, i256 255, i256 %t6551
%t6553 = ashr i256 %p0, %t6552
%t6554 = and i256 %t6553, 255
%t6555 = trunc i256 %t6554 to i64
%t6556 = call ptr @resid_box_i64(i64 %t6555)
%t6559 = call ptr @resid_listbuf_push(ptr %p2, ptr %t6556)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @slice_bytes(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6561 = icmp slt i64 %p2, %p1
br i1 %t6561, label %L661, label %L663
L661:
%t6563 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty6562)
ret ptr %t6563
L663:
%t6564 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t6565 = extractvalue {i64, i1} %t6564, 0
%t6566 = extractvalue {i64, i1} %t6564, 1
%t6567 = zext i1 %t6566 to i8
call void @resid_overflow_check(i8 %t6567)
%t6568 = musttail call ptr @resid_list_slice(ptr %p0, i64 %p1, i64 %t6565)
ret ptr %t6568
}
define ptr @concat_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6570 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %p1)
ret ptr %t6570
}
define ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6571 = call ptr @resid_rec_new(i64 256, i8 1)
%t6572 = getelementptr i8, ptr %p0, i64 0
%t6573 = load i256, ptr %t6572, align 8
%t6574 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6573)
%t6571.f0 = getelementptr i8, ptr %t6571, i64 0
store i512 %t6574, ptr %t6571.f0, align 8
%t6575 = getelementptr i8, ptr %p0, i64 32
%t6576 = load i256, ptr %t6575, align 8
%t6577 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6576)
%t6571.f8 = getelementptr i8, ptr %t6571, i64 64
store i512 %t6577, ptr %t6571.f8, align 8
%t6578 = getelementptr i8, ptr %p0, i64 64
%t6579 = load i256, ptr %t6578, align 8
%t6580 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6579)
%t6571.f16 = getelementptr i8, ptr %t6571, i64 128
store i512 %t6580, ptr %t6571.f16, align 8
%t6581 = getelementptr i8, ptr %p0, i64 96
%t6582 = load i256, ptr %t6581, align 8
%t6583 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6582)
%t6571.f24 = getelementptr i8, ptr %t6571, i64 192
store i512 %t6583, ptr %t6571.f24, align 8
ret ptr %t6571
}
define ptr @__m____________lib_ed25519_resid__ept_n(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6584 = call ptr @resid_gmalloc(i64 128)
%t6585 = getelementptr i8, ptr %p0, i64 0
%t6586 = load i512, ptr %t6585, align 8
%t6587 = trunc i512 %t6586 to i256
%t6584.f0 = getelementptr i8, ptr %t6584, i64 0
store i256 %t6587, ptr %t6584.f0, align 8
%t6588 = getelementptr i8, ptr %p0, i64 64
%t6589 = load i512, ptr %t6588, align 8
%t6590 = trunc i512 %t6589 to i256
%t6584.f4 = getelementptr i8, ptr %t6584, i64 32
store i256 %t6590, ptr %t6584.f4, align 8
%t6591 = getelementptr i8, ptr %p0, i64 128
%t6592 = load i512, ptr %t6591, align 8
%t6593 = trunc i512 %t6592 to i256
%t6584.f8 = getelementptr i8, ptr %t6584, i64 64
store i256 %t6593, ptr %t6584.f8, align 8
%t6594 = getelementptr i8, ptr %p0, i64 192
%t6595 = load i512, ptr %t6594, align 8
%t6596 = trunc i512 %t6595 to i256
%t6584.f12 = getelementptr i8, ptr %t6584, i64 96
store i256 %t6596, ptr %t6584.f12, align 8
ret ptr %t6584
}
define ptr @ept(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6597 = call ptr @resid_gmalloc(i64 128)
%t6597.f0 = getelementptr i8, ptr %t6597, i64 0
store i256 %p0, ptr %t6597.f0, align 8
%t6597.f4 = getelementptr i8, ptr %t6597, i64 32
store i256 %p1, ptr %t6597.f4, align 8
%t6598 = sext i64 1 to i256
%t6597.f8 = getelementptr i8, ptr %t6597, i64 64
store i256 %t6598, ptr %t6597.f8, align 8
%t6599 = call i256 @fe_mul(i256 %p0, i256 %p1)
%t6597.f12 = getelementptr i8, ptr %t6597, i64 96
store i256 %t6599, ptr %t6597.f12, align 8
ret ptr %t6597
}
define ptr @ept_id() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6600 = call ptr @resid_gmalloc(i64 128)
%t6601 = sext i64 0 to i256
%t6600.f0 = getelementptr i8, ptr %t6600, i64 0
store i256 %t6601, ptr %t6600.f0, align 8
%t6602 = sext i64 1 to i256
%t6600.f4 = getelementptr i8, ptr %t6600, i64 32
store i256 %t6602, ptr %t6600.f4, align 8
%t6603 = sext i64 1 to i256
%t6600.f8 = getelementptr i8, ptr %t6600, i64 64
store i256 %t6603, ptr %t6600.f8, align 8
%t6604 = sext i64 0 to i256
%t6600.f12 = getelementptr i8, ptr %t6600, i64 96
store i256 %t6604, ptr %t6600.f12, align 8
ret ptr %t6600
}
define ptr @ept_dbl(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6605 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0)
%t6606 = call ptr @eg_dbl__g_Int_512__Int_64_(ptr %t6605)
%t6607 = musttail call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t6606)
ret ptr %t6607
}
define ptr @ept_add(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6608 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0)
%t6609 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p1)
%t6610 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t6608, ptr %t6609)
%t6611 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t6610)
ret ptr %t6611
}
define ptr @ept_mul(i256 %p0, ptr %p1, ptr %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6612 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6613 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p1)
call void @resid_rec_share(ptr %t6613)
%t6614 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p2)
call void @resid_rec_share(ptr %t6614)
%t6615 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %t6612, ptr %t6613, ptr %t6614, i64 %p3)
%t6616 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t6615)
ret ptr %t6616
}
define ptr @ept_base_mul(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6617 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6618 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t6617)
%t6619 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t6618)
ret ptr %t6619
}
define ptr @ept_encode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6620 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0)
%t6621 = musttail call ptr @eg_encode__g_Int_512__Int_64_(ptr %t6620)
ret ptr %t6621
}
define i1 @ept_eq(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6622 = getelementptr i8, ptr %p0, i64 0
%t6623 = load i256, ptr %t6622, align 8
%t6624 = getelementptr i8, ptr %p1, i64 64
%t6625 = load i256, ptr %t6624, align 8
%t6626 = call i256 @fe_mul(i256 %t6623, i256 %t6625)
%t6627 = getelementptr i8, ptr %p1, i64 0
%t6628 = load i256, ptr %t6627, align 8
%t6629 = getelementptr i8, ptr %p0, i64 64
%t6630 = load i256, ptr %t6629, align 8
%t6631 = call i256 @fe_mul(i256 %t6628, i256 %t6630)
%t6632 = icmp eq i256 %t6626, %t6631
br label %LSL6633
LSL6633:
br i1 %t6632, label %LSR6633, label %LSJ6633
LSR6633:
%t6634 = getelementptr i8, ptr %p0, i64 32
%t6635 = load i256, ptr %t6634, align 8
%t6636 = getelementptr i8, ptr %p1, i64 64
%t6637 = load i256, ptr %t6636, align 8
%t6638 = call i256 @fe_mul(i256 %t6635, i256 %t6637)
%t6639 = getelementptr i8, ptr %p1, i64 32
%t6640 = load i256, ptr %t6639, align 8
%t6641 = getelementptr i8, ptr %p0, i64 64
%t6642 = load i256, ptr %t6641, align 8
%t6643 = call i256 @fe_mul(i256 %t6640, i256 %t6642)
%t6644 = icmp eq i256 %t6638, %t6643
br label %LSJ6633
LSJ6633:
%t6645 = phi i1 [ false, %LSL6633 ], [ %t6644, %LSR6633 ]
ret i1 %t6645
}
define ptr @smul_x_acc(i256 %p0, i256 %p1, i256 %p2, i256 %p3, i256 %p4, i256 %p5, i256 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6646 = call ptr @resid_gmalloc(i64 128)
%t6646.f0 = getelementptr i8, ptr %t6646, i64 0
store i256 %p1, ptr %t6646.f0, align 8
%t6646.f4 = getelementptr i8, ptr %t6646, i64 32
store i256 %p2, ptr %t6646.f4, align 8
%t6646.f8 = getelementptr i8, ptr %t6646, i64 64
store i256 %p3, ptr %t6646.f8, align 8
%t6647 = call i256 @fe_mul(i256 %p1, i256 %p2)
%t6648 = call i256 @fe_inv(i256 %p3)
%t6649 = call i256 @fe_mul(i256 %t6647, i256 %t6648)
%t6646.f12 = getelementptr i8, ptr %t6646, i64 96
store i256 %t6649, ptr %t6646.f12, align 8
%t6650 = call ptr @resid_gmalloc(i64 128)
%t6650.f0 = getelementptr i8, ptr %t6650, i64 0
store i256 %p4, ptr %t6650.f0, align 8
%t6650.f4 = getelementptr i8, ptr %t6650, i64 32
store i256 %p5, ptr %t6650.f4, align 8
%t6650.f8 = getelementptr i8, ptr %t6650, i64 64
store i256 %p6, ptr %t6650.f8, align 8
%t6651 = call i256 @fe_mul(i256 %p4, i256 %p5)
%t6652 = call i256 @fe_inv(i256 %p6)
%t6653 = call i256 @fe_mul(i256 %t6651, i256 %t6652)
%t6650.f12 = getelementptr i8, ptr %t6650, i64 96
store i256 %t6653, ptr %t6650.f12, align 8
%t6654 = call ptr @ept_mul(i256 %p0, ptr %t6646, ptr %t6650, i64 %p7)
%t6655 = getelementptr i8, ptr %t6654, i64 0
%t6656 = load i256, ptr %t6655, align 8
%t6657 = getelementptr i8, ptr %t6654, i64 64
%t6658 = load i256, ptr %t6657, align 8
%t6659 = call i256 @fe_inv(i256 %t6658)
%t6660 = call i256 @fe_mul(i256 %t6656, i256 %t6659)
%t6661 = call ptr @int_to_bytes(i256 %t6660)
ret ptr %t6661
}
define i256 @dec_y(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6662 = call i256 @bytes_to_int(ptr %p0)
ret i256 %t6662
}
define i256 @dec_x(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6663 = call i256 @dec_y(ptr %p0)
%t6664 = call i64 @resid_list_len(ptr %p0)
%t6665 = sub nsw i64 %t6664, 1
%t6666 = call ptr @resid_list_get(ptr %p0, i64 %t6665)
%t6667 = call i64 @resid_unbox_i64(ptr %t6666)
%t6669 = ashr i64 %t6667, 7
%t6670 = and i64 %t6669, 1
%t6671 = call i256 @fe_sq(i256 %t6663)
%t6672 = sext i64 1 to i256
%t6673 = call i256 @fe_sub(i256 %t6671, i256 %t6672)
%t6674 = call i256 @fe_mul(i256 37095705934669439343138083508754565189542113879843219016388785533085940283555, i256 %t6671)
%t6675 = sext i64 1 to i256
%t6676 = call i256 @fe_add(i256 %t6674, i256 %t6675)
%t6677 = call i256 @fe_inv(i256 %t6676)
%t6678 = call i256 @fe_mul(i256 %t6673, i256 %t6677)
%t6679 = sext i64 1 to i256
%t6680 = call i256 @pow_acc(i256 %t6679, i256 %t6678, i256 7237005577332262213973186563042994240829374041602535252466099000494570602494, i64 254)
%t6681 = call i256 @fe_sq(i256 %t6680)
%t6682 = icmp eq i256 %t6681, %t6678
br i1 %t6682, label %L664, label %L665
L664:
br label %L666
L665:
%t6683 = call i256 @fe_mul(i256 %t6680, i256 19681161376707505956807079304988542015446066515923890162744021073123829784752)
br label %L666
L666:
%t6684 = phi i256 [ %t6680, %L664 ], [ %t6683, %L665 ]
%t6685 = and i256 %t6684, 1
%t6686 = trunc i256 %t6685 to i64
%t6687 = icmp ne i64 %t6686, %t6670
br i1 %t6687, label %L667, label %L668
L667:
%t6688 = sext i64 0 to i256
%t6689 = call i256 @fe_sub(i256 %t6688, i256 %t6684)
br label %L669
L668:
br label %L669
L669:
%t6690 = phi i256 [ %t6689, %L667 ], [ %t6684, %L668 ]
ret i256 %t6690
}
define i1 @dec_ok(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6691 = call ptr @__m____________lib_ed25519_resid__dec_pt(ptr %p0)
%t6692 = getelementptr i8, ptr %t6691, i64 0
%t6693 = load i1, ptr %t6692, align 8
ret i1 %t6693
}
define ptr @__m____________lib_ed25519_resid__dec_pt(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6694 = call ptr @resid_gmalloc(i64 72)
%t6694.f0 = getelementptr i8, ptr %t6694, i64 0
store i1 false, ptr %t6694.f0, align 8
%t6695 = sext i64 0 to i256
%t6694.f1 = getelementptr i8, ptr %t6694, i64 8
store i256 %t6695, ptr %t6694.f1, align 8
%t6696 = sext i64 0 to i256
%t6694.f5 = getelementptr i8, ptr %t6694, i64 40
store i256 %t6696, ptr %t6694.f5, align 8
%t6697 = call i64 @resid_list_len(ptr %p0)
%t6698 = icmp ne i64 %t6697, 32
br i1 %t6698, label %L670, label %L672
L670:
ret ptr %t6694
L672:
%t6699 = call i256 @dec_y(ptr %p0)
%t6700 = icmp sge i256 %t6699, 57896044618658097711785492504343953926634992332820282019728792003956564819949
br i1 %t6700, label %L673, label %L675
L673:
ret ptr %t6694
L675:
%t6701 = call i256 @dec_x(ptr %p0)
%t6702 = icmp eq i256 %t6701, 0
br label %LSL6703
LSL6703:
br i1 %t6702, label %LSR6703, label %LSJ6703
LSR6703:
%t6704 = call ptr @resid_list_get(ptr %p0, i64 31)
%t6705 = call i64 @resid_unbox_i64(ptr %t6704)
%t6707 = ashr i64 %t6705, 7
%t6708 = and i64 %t6707, 1
%t6709 = icmp eq i64 %t6708, 1
br label %LSJ6703
LSJ6703:
%t6710 = phi i1 [ false, %LSL6703 ], [ %t6709, %LSR6703 ]
br i1 %t6710, label %L676, label %L678
L676:
ret ptr %t6694
L678:
%t6711 = call i256 @fe_sq(i256 %t6701)
%t6712 = call i256 @fe_sq(i256 %t6699)
%t6713 = call ptr @resid_gmalloc(i64 72)
%t6714 = call i256 @fe_sub(i256 %t6712, i256 %t6711)
%t6715 = sext i64 1 to i256
%t6716 = call i256 @fe_mul(i256 %t6711, i256 %t6712)
%t6717 = call i256 @fe_mul(i256 37095705934669439343138083508754565189542113879843219016388785533085940283555, i256 %t6716)
%t6718 = call i256 @fe_add(i256 %t6715, i256 %t6717)
%t6719 = icmp eq i256 %t6714, %t6718
%t6713.f0 = getelementptr i8, ptr %t6713, i64 0
store i1 %t6719, ptr %t6713.f0, align 8
%t6713.f1 = getelementptr i8, ptr %t6713, i64 8
store i256 %t6701, ptr %t6713.f1, align 8
%t6713.f5 = getelementptr i8, ptr %t6713, i64 40
store i256 %t6699, ptr %t6713.f5, align 8
ret ptr %t6713
}
define i256 @mod_l(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6720 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %p0)
%t6721 = trunc i512 %t6720 to i256
ret i256 %t6721
}
define i1 @verify_sig_bytes(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6722 = call i64 @resid_list_len(ptr %p1)
%t6723 = icmp ne i64 %t6722, 64
br label %LSL6724
LSL6724:
br i1 %t6723, label %LSJ6724, label %LSR6724
LSR6724:
%t6725 = call i64 @resid_list_len(ptr %p2)
%t6726 = icmp ne i64 %t6725, 32
br label %LSJ6724
LSJ6724:
%t6727 = phi i1 [ true, %LSL6724 ], [ %t6726, %LSR6724 ]
br i1 %t6727, label %L679, label %L681
L679:
ret i1 false
L681:
%t6728 = call ptr @resid_list_get(ptr %p1, i64 63)
%t6729 = call i64 @resid_unbox_i64(ptr %t6728)
%t6731 = icmp sge i64 %t6729, 128
br i1 %t6731, label %L682, label %L684
L682:
ret i1 false
L684:
%t6732 = call ptr @resid_list_slice(ptr %p1, i64 0, i64 32)
%t6734 = call ptr @resid_list_slice(ptr %p1, i64 32, i64 64)
%t6736 = call i256 @bytes_to_int(ptr %t6734)
%t6737 = icmp sge i256 %t6736, 7237005577332262213973186563042994240857116359379907606001950938285454250989
br i1 %t6737, label %L685, label %L687
L685:
ret i1 false
L687:
%t6738 = call ptr @__m____________lib_ed25519_resid__dec_pt(ptr %p2)
%t6739 = call ptr @__m____________lib_ed25519_resid__dec_pt(ptr %t6732)
%t6740 = getelementptr i8, ptr %t6738, i64 0
%t6741 = load i1, ptr %t6740, align 8
%t6742 = xor i1 %t6741, true
br label %LSL6743
LSL6743:
br i1 %t6742, label %LSJ6743, label %LSR6743
LSR6743:
%t6744 = getelementptr i8, ptr %t6739, i64 0
%t6745 = load i1, ptr %t6744, align 8
%t6746 = xor i1 %t6745, true
br label %LSJ6743
LSJ6743:
%t6747 = phi i1 [ true, %LSL6743 ], [ %t6746, %LSR6743 ]
br i1 %t6747, label %L688, label %L690
L688:
ret i1 false
L690:
%t6748 = getelementptr i8, ptr %t6738, i64 8
%t6749 = load i256, ptr %t6748, align 8
%t6750 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6749)
%t6751 = getelementptr i8, ptr %t6738, i64 40
%t6752 = load i256, ptr %t6751, align 8
%t6753 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6752)
%t6754 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t6750, i512 %t6753)
call void @resid_rec_share(ptr %t6754)
%t6755 = getelementptr i8, ptr %t6739, i64 8
%t6756 = load i256, ptr %t6755, align 8
%t6757 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6756)
%t6758 = getelementptr i8, ptr %t6739, i64 40
%t6759 = load i256, ptr %t6758, align 8
%t6760 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6759)
%t6761 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t6757, i512 %t6760)
%t6762 = call i64 @resid_scope_push()
%t6763 = call ptr @resid_list_concat_own(ptr %t6732, i8 1, ptr %p2)
%t6764 = call ptr @resid_list_concat_own(ptr %t6763, i8 1, ptr %p0)
%t6765 = call ptr @sha512_bytes(ptr %t6764)
%t6766 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t6765)
call void @resid_scope_pop(i64 %t6762)
%t6767 = call ptr @eg_id__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t6767)
%t6768 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6736)
%t6769 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t6768)
%t6770 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t6769)
%t6771 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %t6766, ptr %t6754, ptr %t6767, i64 255)
%t6772 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t6771, ptr %t6761)
%t6773 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t6772)
%t6774 = call i1 @ept_eq(ptr %t6770, ptr %t6773)
ret i1 %t6774
}
define i1 @verify_sig(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6775 = call ptr @bytes_of(ptr %p0)
%t6776 = call ptr @resid_list_freeze(ptr %t6775)
%t6777 = musttail call i1 @verify_sig_bytes(ptr %t6776, ptr %p1, ptr %p2)
ret i1 %t6777
}
define i256 @clamp_scalar(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6778 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6779 = call i512 @eg_clamp__g_Int_512__Int_64_(i512 %t6778)
%t6780 = trunc i512 %t6779 to i256
ret i256 %t6780
}
define ptr @pub_key(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6781 = musttail call ptr @ed25519g_pub__g_Int_64__Int_512__UInt_64_(ptr %p0)
ret ptr %t6781
}
define ptr @sign_msg_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6782 = musttail call ptr @ed25519g_sign__g_Int_64__Int_512__UInt_64_(ptr %p0, ptr %p1)
ret ptr %t6782
}
define ptr @sign_msg(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6783 = call ptr @bytes_of(ptr %p1)
%t6784 = call ptr @resid_list_freeze(ptr %t6783)
%t6785 = musttail call ptr @sign_msg_bytes(ptr %p0, ptr %t6784)
ret ptr %t6785
}
define i64 @__m____________lib_chachag_resid__cg_le32(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6786 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t6787 = call i64 @resid_unbox_i64(ptr %t6786)
%t6789 = and i64 %t6787, 255
%t6790 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t6791 = extractvalue {i64, i1} %t6790, 0
%t6792 = extractvalue {i64, i1} %t6790, 1
%t6793 = zext i1 %t6792 to i8
call void @resid_overflow_check(i8 %t6793)
%t6794 = call ptr @resid_list_get(ptr %p0, i64 %t6791)
%t6795 = call i64 @resid_unbox_i64(ptr %t6794)
%t6797 = and i64 %t6795, 255
%t6798 = shl i64 %t6797, 8
%t6799 = or i64 %t6789, %t6798
%t6800 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t6801 = extractvalue {i64, i1} %t6800, 0
%t6802 = extractvalue {i64, i1} %t6800, 1
%t6803 = zext i1 %t6802 to i8
call void @resid_overflow_check(i8 %t6803)
%t6804 = call ptr @resid_list_get(ptr %p0, i64 %t6801)
%t6805 = call i64 @resid_unbox_i64(ptr %t6804)
%t6807 = and i64 %t6805, 255
%t6808 = shl i64 %t6807, 16
%t6809 = or i64 %t6799, %t6808
%t6810 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 3)
%t6811 = extractvalue {i64, i1} %t6810, 0
%t6812 = extractvalue {i64, i1} %t6810, 1
%t6813 = zext i1 %t6812 to i8
call void @resid_overflow_check(i8 %t6813)
%t6814 = call ptr @resid_list_get(ptr %p0, i64 %t6811)
%t6815 = call i64 @resid_unbox_i64(ptr %t6814)
%t6817 = and i64 %t6815, 255
%t6818 = shl i64 %t6817, 24
%t6819 = or i64 %t6809, %t6818
ret i64 %t6819
}
define i512 @__m____________lib_chachag_resid__pg_m130() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6820 = sext i256 1361129467683753853853498429727072845823 to i512
ret i512 %t6820
}
define i512 @__m____________lib_chachag_resid__pg_p() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6821 = sext i256 1361129467683753853853498429727072845819 to i512
ret i512 %t6821
}
define i512 @__m____________lib_chachag_resid__pg_m128() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6822 = sext i256 340282366920938463463374607431768211455 to i512
ret i512 %t6822
}
define i512 @__m____________lib_chachag_resid__pg_clamp() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6823 = sext i128 21267647620597763993911028882763415551 to i512
ret i512 %t6823
}
define i64 @__m____________lib_chachag_resid__cg_pad16(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6824 = srem i64 %p0, 16
%t6825 = icmp eq i64 %t6824, 0
br i1 %t6825, label %L691, label %L692
L691:
br label %L693
L692:
%t6826 = sub nsw i64 16, %t6824
br label %L693
L693:
%t6827 = phi i64 [ 0, %L691 ], [ %t6826, %L692 ]
ret i64 %t6827
}
define ptr @__m____________lib_chachag_resid__cg_zeros(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6830, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t6834, %tco.s0 ]
%t6828 = icmp sge i64 %p1, %p0
br i1 %t6828, label %L694, label %L696
L694:
%t6829 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty6829)
ret ptr %t6829
L696:
%t6830 = add nsw i64 %p1, 1
%t6831 = call ptr @resid_box_i64(i64 0)
%t6834 = call ptr @resid_listbuf_push(ptr %p2, ptr %t6831)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__cg_le64(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6838, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t6851, %tco.s0 ]
%t6836 = icmp sge i64 %p1, 8
br i1 %t6836, label %L697, label %L699
L697:
%t6837 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty6837)
ret ptr %t6837
L699:
%t6838 = add nsw i64 %p1, 1
%t6839 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p1)
%t6840 = extractvalue {i64, i1} %t6839, 0
%t6841 = extractvalue {i64, i1} %t6839, 1
%t6842 = zext i1 %t6841 to i8
call void @resid_overflow_check(i8 %t6842)
%t6843 = icmp uge i64 %t6840, 64
%t6844 = add i64 %t6840, 0
%t6845 = select i1 %t6843, i64 63, i64 %t6844
%t6846 = ashr i64 %p0, %t6845
%t6847 = and i64 %t6846, 255
%t6848 = call ptr @resid_box_i64(i64 %t6847)
%t6851 = call ptr @resid_listbuf_push(ptr %p2, ptr %t6848)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @chacha_block(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6853 = musttail call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
ret ptr %t6853
}
define ptr @chacha20_xor(ptr %p0, i64 %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6854 = musttail call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2, ptr %p3)
ret ptr %t6854
}
define ptr @poly1305(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6855 = musttail call ptr @poly1305g__g_Int_64__Int_512_(ptr %p0, ptr %p1)
ret ptr %t6855
}
define ptr @chacha20poly1305_seal(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6856 = musttail call ptr @chacha20poly1305g_seal__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
ret ptr %t6856
}
define i1 @chacha20poly1305_open(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6857 = call ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
%t6858 = getelementptr {i32, i32, ptr}, ptr %t6857, i32 0, i32 0
%t6859w = load i32, ptr %t6858
%t6859 = sext i32 %t6859w to i64
%t6860 = icmp eq i64 %t6859, 1
br i1 %t6860, label %L700, label %L701
L700:
%t6861 = getelementptr {i32, i32, ptr}, ptr %t6857, i32 1
%t6862 = getelementptr i8, ptr %t6861, i64 0
%t6863 = getelementptr ptr, ptr %t6862, i32 0
%t6864 = load ptr, ptr %t6863
br label %L702
L701:
br label %L702
L702:
%t6865 = phi i1 [ true, %L700 ], [ false, %L701 ]
ret i1 %t6865
}
define ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6866 = musttail call ptr @chacha20poly1305g_decrypt__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
ret ptr %t6866
}
define ptr @chacha20poly1305_open_bytes(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6867 = call ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
%t6868 = getelementptr {i32, i32, ptr}, ptr %t6867, i32 0, i32 0
%t6869w = load i32, ptr %t6868
%t6869 = sext i32 %t6869w to i64
%t6870 = icmp eq i64 %t6869, 1
br i1 %t6870, label %L703, label %L704
L704:
%t6872 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty6871)
br label %L705
L703:
%t6873 = getelementptr {i32, i32, ptr}, ptr %t6867, i32 1
%t6874 = getelementptr i8, ptr %t6873, i64 0
%t6875 = getelementptr ptr, ptr %t6874, i32 0
%t6876 = load ptr, ptr %t6875
br label %L705
L705:
%t6877 = phi ptr [ %t6872, %L704 ], [ %t6876, %L703 ]
ret ptr %t6877
}
define ptr @cbe_be(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6890 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6884, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t6878 = icmp sle i64 %p1, 0
br i1 %t6878, label %L706, label %L708
L706:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p2
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L708:
%t6879 = sub nsw i64 %p1, 1
%t6880 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t6879, i64 8)
%t6881 = extractvalue {i64, i1} %t6880, 0
%t6882 = extractvalue {i64, i1} %t6880, 1
%t6883 = zext i1 %t6882 to i8
call void @resid_overflow_check(i8 %t6883)
%t6884 = sub nsw i64 %p1, 1
%t6885 = icmp uge i64 %t6881, 64
%t6886 = add i64 %t6881, 0
%t6887 = select i1 %t6885, i64 63, i64 %t6886
%t6888 = ashr i64 %p0, %t6887
%t6889 = and i64 %t6888, 255
%t6892 = call ptr @resid_box_i64(i64 %t6889)
%t6894 = getelementptr i8, ptr %t6890, i64 0
store ptr %t6892, ptr %t6894
%t6895 = call ptr @resid_list_new(i64 1, ptr %t6890, ptr @.lty6890)
%t6896 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t6895)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t6896, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t6896, %tco.s0 ]
br label %tco.head
}
define ptr @cbe_head(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6901 = alloca [1 x ptr]
%t6911 = alloca [2 x ptr]
%t6923 = alloca [1 x ptr]
%t6933 = alloca [1 x ptr]
%t6942 = alloca [1 x ptr]
%t6898 = shl i64 %p0, 5
%t6899 = icmp sle i64 %p1, 23
br i1 %t6899, label %L709, label %L711
L709:
%t6900 = or i64 %t6898, %p1
%t6903 = call ptr @resid_box_i64(i64 %t6900)
%t6905 = getelementptr i8, ptr %t6901, i64 0
store ptr %t6903, ptr %t6905
%t6906 = call ptr @resid_list_new(i64 1, ptr %t6901, ptr @.lty6901)
%t6907 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t6906)
ret ptr %t6907
L711:
%t6908 = icmp sle i64 %p1, 255
br i1 %t6908, label %L712, label %L714
L712:
%t6909 = or i64 %t6898, 24
%t6910 = add nsw i64 %p1, 0
%t6913 = call ptr @resid_box_i64(i64 %t6909)
%t6915 = getelementptr i8, ptr %t6911, i64 0
store ptr %t6913, ptr %t6915
%t6916 = call ptr @resid_box_i64(i64 %t6910)
%t6918 = getelementptr i8, ptr %t6911, i64 8
store ptr %t6916, ptr %t6918
%t6919 = call ptr @resid_list_new(i64 2, ptr %t6911, ptr @.lty6911)
%t6920 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t6919)
ret ptr %t6920
L714:
%t6921 = icmp sle i64 %p1, 65535
br i1 %t6921, label %L715, label %L717
L715:
%t6922 = or i64 %t6898, 25
%t6925 = call ptr @resid_box_i64(i64 %t6922)
%t6927 = getelementptr i8, ptr %t6923, i64 0
store ptr %t6925, ptr %t6927
%t6928 = call ptr @resid_list_new(i64 1, ptr %t6923, ptr @.lty6923)
%t6929 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t6928)
%t6930 = musttail call ptr @cbe_be(i64 %p1, i64 2, ptr %t6929)
ret ptr %t6930
L717:
%t6931 = icmp sle i64 %p1, 4294967295
br i1 %t6931, label %L718, label %L720
L718:
%t6932 = or i64 %t6898, 26
%t6935 = call ptr @resid_box_i64(i64 %t6932)
%t6937 = getelementptr i8, ptr %t6933, i64 0
store ptr %t6935, ptr %t6937
%t6938 = call ptr @resid_list_new(i64 1, ptr %t6933, ptr @.lty6933)
%t6939 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t6938)
%t6940 = musttail call ptr @cbe_be(i64 %p1, i64 4, ptr %t6939)
ret ptr %t6940
L720:
%t6941 = or i64 %t6898, 27
%t6944 = call ptr @resid_box_i64(i64 %t6941)
%t6946 = getelementptr i8, ptr %t6942, i64 0
store ptr %t6944, ptr %t6946
%t6947 = call ptr @resid_list_new(i64 1, ptr %t6942, ptr @.lty6942)
%t6948 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t6947)
%t6949 = musttail call ptr @cbe_be(i64 %p1, i64 8, ptr %t6948)
ret ptr %t6949
}
define ptr @cbe_uint(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6950 = call ptr @cbe_head(i64 0, i64 %p0, ptr %p1)
ret ptr %t6950
}
define ptr @cbe_int(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6951 = icmp sge i64 %p0, 0
br i1 %t6951, label %L721, label %L723
L721:
%t6952 = call ptr @cbe_head(i64 0, i64 %p0, ptr %p1)
ret ptr %t6952
L723:
%t6953 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p0)
%t6954 = extractvalue {i64, i1} %t6953, 0
%t6955 = extractvalue {i64, i1} %t6953, 1
%t6956 = zext i1 %t6955 to i8
call void @resid_overflow_check(i8 %t6956)
%t6957 = sub nsw i64 %t6954, 1
%t6958 = call ptr @cbe_head(i64 1, i64 %t6957, ptr %p1)
ret ptr %t6958
}
define ptr @cbe_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6959 = call i64 @resid_list_len(ptr %p0)
%t6960 = call ptr @cbe_head(i64 2, i64 %t6959, ptr %p1)
%t6961 = call ptr @resid_list_concat_own(ptr %t6960, i8 1, ptr %p0)
ret ptr %t6961
}
define ptr @cbe_text(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6962 = call ptr @bytes_of(ptr %p0)
%t6963 = call ptr @resid_list_freeze(ptr %t6962)
%t6964 = call i64 @resid_list_len(ptr %t6963)
%t6965 = call ptr @cbe_head(i64 3, i64 %t6964, ptr %p1)
%t6966 = call ptr @resid_list_concat_own(ptr %t6965, i8 1, ptr %t6963)
ret ptr %t6966
}
define ptr @cbe_array(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6967 = call ptr @cbe_head(i64 4, i64 %p0, ptr %p1)
ret ptr %t6967
}
define ptr @cbe_map(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6968 = call ptr @cbe_head(i64 5, i64 %p0, ptr %p1)
ret ptr %t6968
}
define ptr @cbe_tag(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6969 = call ptr @cbe_head(i64 6, i64 %p0, ptr %p1)
ret ptr %t6969
}
define i64 @cbe_be_read(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6972, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6975, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t6980, %tco.s0 ]
%t6970 = icmp sle i64 %p2, 0
br i1 %t6970, label %L724, label %L726
L724:
ret i64 %p3
L726:
%t6971 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t6972 = extractvalue {i64, i1} %t6971, 0
%t6973 = extractvalue {i64, i1} %t6971, 1
%t6974 = zext i1 %t6973 to i8
call void @resid_overflow_check(i8 %t6974)
%t6975 = sub nsw i64 %p2, 1
%t6976 = shl i64 %p3, 8
%t6977 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t6978 = call i64 @resid_unbox_i64(ptr %t6977)
%t6980 = or i64 %t6976, %t6978
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @cbe_read_head(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6982 = icmp slt i64 %p1, 0
br label %LSL6983
LSL6983:
br i1 %t6982, label %LSJ6983, label %LSR6983
LSR6983:
%t6984 = call i64 @resid_list_len(ptr %p0)
%t6985 = icmp sge i64 %p1, %t6984
br label %LSJ6983
LSJ6983:
%t6986 = phi i1 [ true, %LSL6983 ], [ %t6985, %LSR6983 ]
br i1 %t6986, label %L727, label %L729
L727:
%t6987 = call ptr @resid_gmalloc(i64 32)
%t6987.f0 = getelementptr i8, ptr %t6987, i64 0
store i1 false, ptr %t6987.f0, align 8
%t6987.f1 = getelementptr i8, ptr %t6987, i64 8
store i64 0, ptr %t6987.f1, align 8
%t6987.f2 = getelementptr i8, ptr %t6987, i64 16
store i64 0, ptr %t6987.f2, align 8
%t6987.f3 = getelementptr i8, ptr %t6987, i64 24
store i64 %p1, ptr %t6987.f3, align 8
ret ptr %t6987
L729:
%t6988 = call ptr @resid_list_get_nc(ptr %p0, i64 %p1)
%t6989 = call i64 @resid_unbox_i64(ptr %t6988)
%t6991 = ashr i64 %t6989, 5
%t6992 = and i64 %t6989, 31
%t6993 = icmp sle i64 %t6992, 23
br i1 %t6993, label %L730, label %L732
L730:
%t6994 = call ptr @resid_gmalloc(i64 32)
%t6994.f0 = getelementptr i8, ptr %t6994, i64 0
store i1 true, ptr %t6994.f0, align 8
%t6994.f1 = getelementptr i8, ptr %t6994, i64 8
store i64 %t6991, ptr %t6994.f1, align 8
%t6994.f2 = getelementptr i8, ptr %t6994, i64 16
store i64 %t6992, ptr %t6994.f2, align 8
%t6995 = add nsw i64 %p1, 1
%t6994.f3 = getelementptr i8, ptr %t6994, i64 24
store i64 %t6995, ptr %t6994.f3, align 8
ret ptr %t6994
L732:
%t6996 = call i64 @cbe_arg_len(i64 %t6992)
%t6997 = icmp eq i64 %t6996, 0
br i1 %t6997, label %L733, label %L735
L733:
%t6998 = call ptr @resid_gmalloc(i64 32)
%t6998.f0 = getelementptr i8, ptr %t6998, i64 0
store i1 false, ptr %t6998.f0, align 8
%t6998.f1 = getelementptr i8, ptr %t6998, i64 8
store i64 %t6991, ptr %t6998.f1, align 8
%t6998.f2 = getelementptr i8, ptr %t6998, i64 16
store i64 0, ptr %t6998.f2, align 8
%t6998.f3 = getelementptr i8, ptr %t6998, i64 24
store i64 %p1, ptr %t6998.f3, align 8
ret ptr %t6998
L735:
%t6999 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t6996)
%t7000 = extractvalue {i64, i1} %t6999, 0
%t7001 = extractvalue {i64, i1} %t6999, 1
%t7002 = zext i1 %t7001 to i8
call void @resid_overflow_check(i8 %t7002)
%t7003 = call i64 @resid_list_len(ptr %p0)
%t7004 = icmp sge i64 %t7000, %t7003
br i1 %t7004, label %L736, label %L738
L736:
%t7005 = call ptr @resid_gmalloc(i64 32)
%t7005.f0 = getelementptr i8, ptr %t7005, i64 0
store i1 false, ptr %t7005.f0, align 8
%t7005.f1 = getelementptr i8, ptr %t7005, i64 8
store i64 %t6991, ptr %t7005.f1, align 8
%t7005.f2 = getelementptr i8, ptr %t7005, i64 16
store i64 0, ptr %t7005.f2, align 8
%t7005.f3 = getelementptr i8, ptr %t7005, i64 24
store i64 %p1, ptr %t7005.f3, align 8
ret ptr %t7005
L738:
%t7006 = call ptr @resid_gmalloc(i64 32)
%t7006.f0 = getelementptr i8, ptr %t7006, i64 0
store i1 true, ptr %t7006.f0, align 8
%t7006.f1 = getelementptr i8, ptr %t7006, i64 8
store i64 %t6991, ptr %t7006.f1, align 8
%t7007 = add nsw i64 %p1, 1
%t7008 = call i64 @cbe_be_read(ptr %p0, i64 %t7007, i64 %t6996, i64 0)
%t7006.f2 = getelementptr i8, ptr %t7006, i64 16
store i64 %t7008, ptr %t7006.f2, align 8
%t7009 = add nsw i64 %p1, 1
%t7010 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7009, i64 %t6996)
%t7011 = extractvalue {i64, i1} %t7010, 0
%t7012 = extractvalue {i64, i1} %t7010, 1
%t7013 = zext i1 %t7012 to i8
call void @resid_overflow_check(i8 %t7013)
%t7006.f3 = getelementptr i8, ptr %t7006, i64 24
store i64 %t7011, ptr %t7006.f3, align 8
ret ptr %t7006
}
define i64 @cbe_arg_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7014 = icmp eq i64 %p0, 24
br i1 %t7014, label %L739, label %L741
L739:
ret i64 1
L741:
%t7015 = icmp eq i64 %p0, 25
br i1 %t7015, label %L742, label %L744
L742:
ret i64 2
L744:
%t7016 = icmp eq i64 %p0, 26
br i1 %t7016, label %L745, label %L747
L745:
ret i64 4
L747:
%t7017 = icmp eq i64 %p0, 27
br i1 %t7017, label %L748, label %L750
L748:
ret i64 8
L750:
ret i64 0
}
define ptr @cbe_read_str(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7018 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB7018)
%t7019 = call ptr @cbe_read_head(ptr %p0, i64 %p1)
%t7020 = getelementptr i8, ptr %t7019, i64 0
%t7021 = load i1, ptr %t7020, align 8
%t7022 = xor i1 %t7021, true
br label %LSL7023
LSL7023:
br i1 %t7022, label %LSJ7023, label %LSR7023
LSR7023:
%t7024 = getelementptr i8, ptr %t7019, i64 8
%t7025 = load i64, ptr %t7024, align 8
%t7026 = icmp ne i64 %t7025, %p2
br label %LSJ7023
LSJ7023:
%t7027 = phi i1 [ true, %LSL7023 ], [ %t7026, %LSR7023 ]
br label %LSL7028
LSL7028:
br i1 %t7027, label %LSJ7028, label %LSR7028
LSR7028:
%t7029 = getelementptr i8, ptr %t7019, i64 16
%t7030 = load i64, ptr %t7029, align 8
%t7031 = icmp slt i64 %t7030, 0
br label %LSJ7028
LSJ7028:
%t7032 = phi i1 [ true, %LSL7028 ], [ %t7031, %LSR7028 ]
br label %LSL7033
LSL7033:
br i1 %t7032, label %LSJ7033, label %LSR7033
LSR7033:
%t7034 = getelementptr i8, ptr %t7019, i64 16
%t7035 = load i64, ptr %t7034, align 8
%t7036 = call i64 @resid_list_len(ptr %p0)
%t7037 = getelementptr i8, ptr %t7019, i64 24
%t7038 = load i64, ptr %t7037, align 8
%t7039 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7036, i64 %t7038)
%t7040 = extractvalue {i64, i1} %t7039, 0
%t7041 = extractvalue {i64, i1} %t7039, 1
%t7042 = zext i1 %t7041 to i8
call void @resid_overflow_check(i8 %t7042)
%t7043 = icmp sgt i64 %t7035, %t7040
br label %LSJ7033
LSJ7033:
%t7044 = phi i1 [ true, %LSL7033 ], [ %t7043, %LSR7033 ]
br i1 %t7044, label %L751, label %L753
L751:
%t7045 = call ptr @resid_gmalloc(i64 24)
%t7045.f0 = getelementptr i8, ptr %t7045, i64 0
store i1 false, ptr %t7045.f0, align 8
%t7045.f1 = getelementptr i8, ptr %t7045, i64 8
store ptr %t7018, ptr %t7045.f1, align 8
%t7045.f2 = getelementptr i8, ptr %t7045, i64 16
store i64 %p1, ptr %t7045.f2, align 8
ret ptr %t7045
L753:
%t7046 = getelementptr i8, ptr %t7019, i64 24
%t7047 = load i64, ptr %t7046, align 8
%t7048 = getelementptr i8, ptr %t7019, i64 16
%t7049 = load i64, ptr %t7048, align 8
%t7050 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7047, i64 %t7049)
%t7051 = extractvalue {i64, i1} %t7050, 0
%t7052 = extractvalue {i64, i1} %t7050, 1
%t7053 = zext i1 %t7052 to i8
call void @resid_overflow_check(i8 %t7053)
%t7054 = call ptr @resid_gmalloc(i64 24)
%t7054.f0 = getelementptr i8, ptr %t7054, i64 0
store i1 true, ptr %t7054.f0, align 8
%t7055 = getelementptr i8, ptr %t7019, i64 24
%t7056 = load i64, ptr %t7055, align 8
%t7057 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7051, i64 1)
%t7058 = extractvalue {i64, i1} %t7057, 0
%t7059 = extractvalue {i64, i1} %t7057, 1
%t7060 = zext i1 %t7059 to i8
call void @resid_overflow_check(i8 %t7060)
%t7061 = call ptr @slice_bytes(ptr %p0, i64 %t7056, i64 %t7058)
%t7054.f1 = getelementptr i8, ptr %t7054, i64 8
store ptr %t7061, ptr %t7054.f1, align 8
%t7054.f2 = getelementptr i8, ptr %t7054, i64 16
store i64 %t7051, ptr %t7054.f2, align 8
ret ptr %t7054
}
define ptr @cbe_ascii__sacc(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7064, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7069, %tco.s0 ]
%t7062 = call i64 @resid_list_len(ptr %p0)
%t7063 = icmp sge i64 %p1, %t7062
br i1 %t7063, label %L754, label %L756
L754:
ret ptr %p2
L756:
%t7064 = add nsw i64 %p1, 1
%t7065 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t7066 = call i64 @resid_unbox_i64(ptr %t7065)
%t7068 = call ptr @str_from_code(i64 %t7066)
%t7069 = call ptr @resid_sacc_append(ptr %p2, ptr %t7068)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @cose_nibble(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7071 = icmp sge i64 %p0, 48
br label %LSL7072
LSL7072:
br i1 %t7071, label %LSR7072, label %LSJ7072
LSR7072:
%t7073 = icmp sle i64 %p0, 57
br label %LSJ7072
LSJ7072:
%t7074 = phi i1 [ false, %LSL7072 ], [ %t7073, %LSR7072 ]
br i1 %t7074, label %L757, label %L759
L757:
%t7075 = sub nsw i64 %p0, 48
ret i64 %t7075
L759:
%t7076 = icmp sge i64 %p0, 97
br label %LSL7077
LSL7077:
br i1 %t7076, label %LSR7077, label %LSJ7077
LSR7077:
%t7078 = icmp sle i64 %p0, 102
br label %LSJ7077
LSJ7077:
%t7079 = phi i1 [ false, %LSL7077 ], [ %t7078, %LSR7077 ]
br i1 %t7079, label %L760, label %L762
L760:
%t7080 = sub nsw i64 %p0, 87
ret i64 %t7080
L762:
%t7081 = icmp sge i64 %p0, 65
br label %LSL7082
LSL7082:
br i1 %t7081, label %LSR7082, label %LSJ7082
LSR7082:
%t7083 = icmp sle i64 %p0, 70
br label %LSJ7082
LSJ7082:
%t7084 = phi i1 [ false, %LSL7082 ], [ %t7083, %LSR7082 ]
br i1 %t7084, label %L763, label %L765
L763:
%t7085 = sub nsw i64 %p0, 55
ret i64 %t7085
L765:
ret i64 0
}
define ptr @cose_hex_acc(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7111 = alloca [1 x ptr]
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7108, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t7086 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t7087 = extractvalue {i64, i1} %t7086, 0
%t7088 = extractvalue {i64, i1} %t7086, 1
%t7089 = zext i1 %t7088 to i8
call void @resid_overflow_check(i8 %t7089)
%t7090 = icmp sge i64 %t7087, %p2
br i1 %t7090, label %L766, label %L768
L766:
%lr.cx18 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz18 = icmp eq ptr %lr.cx18, null
br i1 %lr.lz18, label %lr.x18.k, label %lr.x18.m
lr.x18.k:
ret ptr %p3
lr.x18.m:
%lr.ret18 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx18)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret18
L768:
%t7091 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t7092 = call i64 @cose_nibble(i64 %t7091)
%t7093 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t7092, i64 16)
%t7094 = extractvalue {i64, i1} %t7093, 0
%t7095 = extractvalue {i64, i1} %t7093, 1
%t7096 = zext i1 %t7095 to i8
call void @resid_overflow_check(i8 %t7096)
%t7097 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t7098 = extractvalue {i64, i1} %t7097, 0
%t7099 = extractvalue {i64, i1} %t7097, 1
%t7100 = zext i1 %t7099 to i8
call void @resid_overflow_check(i8 %t7100)
%t7101 = call i64 @resid_char_at_n(ptr %p0, i64 %t7098, i64 %p0.alen)
%t7102 = call i64 @cose_nibble(i64 %t7101)
%t7103 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7094, i64 %t7102)
%t7104 = extractvalue {i64, i1} %t7103, 0
%t7105 = extractvalue {i64, i1} %t7103, 1
%t7106 = zext i1 %t7105 to i8
call void @resid_overflow_check(i8 %t7106)
%t7107 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t7108 = extractvalue {i64, i1} %t7107, 0
%t7109 = extractvalue {i64, i1} %t7107, 1
%t7110 = zext i1 %t7109 to i8
call void @resid_overflow_check(i8 %t7110)
%t7113 = call ptr @resid_box_i64(i64 %t7104)
%t7115 = getelementptr i8, ptr %t7111, i64 0
store ptr %t7113, ptr %t7115
%t7116 = call ptr @resid_list_new(i64 1, ptr %t7111, ptr @.lty7111)
%t7117 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t7116)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t7117, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t7117, %tco.s0 ]
br label %tco.head
}
define ptr @cose_hex_decode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7119 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB7119)
%t7120 = call i64 @str_len(ptr %p0)
%t7121 = call ptr @cose_hex_acc(ptr %p0, i64 0, i64 %t7120, ptr %t7119)
ret ptr %t7121
}
define ptr @cose_sig_structure(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7123 = call ptr @resid_list_const_i64(ptr @.lc7122, i64 12, ptr @.lcd7122, ptr @.lty7122)
%t7124 = call ptr @cbe_bytes(ptr %p0, ptr %t7123)
%t7126 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty7125)
%t7127 = call ptr @cbe_bytes(ptr %t7126, ptr %t7124)
%t7128 = musttail call ptr @cbe_bytes(ptr %p1, ptr %t7127)
ret ptr %t7128
}
define ptr @cose_sign1_protected(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7129 = call ptr @bytes_of(ptr %p0)
%t7130 = call ptr @resid_list_freeze(ptr %t7129)
%t7132 = call ptr @resid_list_const_i64(ptr @.lc7131, i64 4, ptr @.lcd7131, ptr @.lty7131)
%t7133 = call ptr @cbe_bytes(ptr %t7130, ptr %t7132)
ret ptr %t7133
}
define ptr @cose_sign1_err(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7134 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB7134)
%t7135 = call ptr @resid_gmalloc(i64 48)
%t7135.f0 = getelementptr i8, ptr %t7135, i64 0
store i1 false, ptr %t7135.f0, align 8
%t7135.f1 = getelementptr i8, ptr %t7135, i64 8
store ptr %p0, ptr %t7135.f1, align 8
%t7135.f2 = getelementptr i8, ptr %t7135, i64 16
store ptr @.s7136, ptr %t7135.f2, align 8
%t7135.f3 = getelementptr i8, ptr %t7135, i64 24
store ptr %t7134, ptr %t7135.f3, align 8
%t7135.f4 = getelementptr i8, ptr %t7135, i64 32
store ptr %t7134, ptr %t7135.f4, align 8
%t7135.f5 = getelementptr i8, ptr %t7135, i64 40
store ptr %t7134, ptr %t7135.f5, align 8
ret ptr %t7135
}
define ptr @cose_kid_of(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7137 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t7138 = getelementptr i8, ptr %t7137, i64 0
%t7139 = load i1, ptr %t7138, align 8
%t7140 = xor i1 %t7139, true
br label %LSL7141
LSL7141:
br i1 %t7140, label %LSJ7141, label %LSR7141
LSR7141:
%t7142 = getelementptr i8, ptr %t7137, i64 8
%t7143 = load i64, ptr %t7142, align 8
%t7144 = icmp ne i64 %t7143, 5
br label %LSJ7141
LSJ7141:
%t7145 = phi i1 [ true, %LSL7141 ], [ %t7144, %LSR7141 ]
br i1 %t7145, label %L769, label %L771
L769:
ret ptr @.s7146
L771:
%t7147 = getelementptr i8, ptr %t7137, i64 24
%t7148 = load i64, ptr %t7147, align 8
%t7149 = getelementptr i8, ptr %t7137, i64 16
%t7150 = load i64, ptr %t7149, align 8
%t7151 = call ptr @cose_kid_scan(ptr %p0, i64 %t7148, i64 %t7150)
ret ptr %t7151
}
define ptr @cose_kid_scan(ptr %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7230, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t7231, %tco.s0.k ]
%t7152 = icmp sle i64 %p2, 0
br i1 %t7152, label %L772, label %L774
L772:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr @.s7153
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_str(ptr @.s7153, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L774:
%t7154 = call ptr @cbe_read_head(ptr %p0, i64 %p1)
%t7155 = getelementptr i8, ptr %t7154, i64 0
%t7156 = load i1, ptr %t7155, align 8
%t7157 = xor i1 %t7156, true
br i1 %t7157, label %L775, label %L777
L775:
%lr.cx18 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz18 = icmp eq ptr %lr.cx18, null
br i1 %lr.lz18, label %lr.x18.k, label %lr.x18.m
lr.x18.k:
ret ptr @.s7158
lr.x18.m:
%lr.ret18 = call ptr @resid_mv_str(ptr @.s7158, ptr %lr.cx18)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret18
L777:
%t7159 = getelementptr i8, ptr %t7154, i64 24
%t7160 = load i64, ptr %t7159, align 8
%t7161 = call ptr @cbe_read_head(ptr %p0, i64 %t7160)
%t7162 = getelementptr i8, ptr %t7161, i64 0
%t7163 = load i1, ptr %t7162, align 8
%t7164 = xor i1 %t7163, true
br i1 %t7164, label %L778, label %L780
L778:
%lr.cx28 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz28 = icmp eq ptr %lr.cx28, null
br i1 %lr.lz28, label %lr.x28.k, label %lr.x28.m
lr.x28.k:
ret ptr @.s7165
lr.x28.m:
%lr.ret28 = call ptr @resid_mv_str(ptr @.s7165, ptr %lr.cx28)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret28
L780:
%t7166 = getelementptr i8, ptr %t7154, i64 8
%t7167 = load i64, ptr %t7166, align 8
%t7168 = icmp eq i64 %t7167, 0
br label %LSL7169
LSL7169:
br i1 %t7168, label %LSR7169, label %LSJ7169
LSR7169:
%t7170 = getelementptr i8, ptr %t7154, i64 16
%t7171 = load i64, ptr %t7170, align 8
%t7172 = icmp eq i64 %t7171, 4
br label %LSJ7169
LSJ7169:
%t7173 = phi i1 [ false, %LSL7169 ], [ %t7172, %LSR7169 ]
br label %LSL7174
LSL7174:
br i1 %t7173, label %LSR7174, label %LSJ7174
LSR7174:
%t7175 = getelementptr i8, ptr %t7161, i64 8
%t7176 = load i64, ptr %t7175, align 8
%t7177 = icmp eq i64 %t7176, 2
br label %LSJ7174
LSJ7174:
%t7178 = phi i1 [ false, %LSL7174 ], [ %t7177, %LSR7174 ]
br i1 %t7178, label %L781, label %L783
L781:
%t7179 = getelementptr i8, ptr %t7154, i64 24
%t7180 = load i64, ptr %t7179, align 8
%t7181 = call ptr @cbe_read_str(ptr %p0, i64 %t7180, i64 2)
%t7182 = getelementptr i8, ptr %t7181, i64 8
%t7183 = load ptr, ptr %t7182, align 8
%t7185 = call ptr @cbe_ascii(ptr %t7183, i64 0, ptr @.s7184)
%lr.cx61 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz61 = icmp eq ptr %lr.cx61, null
br i1 %lr.lz61, label %lr.x61.k, label %lr.x61.m
lr.x61.k:
ret ptr %t7185
lr.x61.m:
%lr.ret61 = call ptr @resid_mv_str(ptr %t7185, ptr %lr.cx61)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret61
L783:
%t7186 = getelementptr i8, ptr %t7161, i64 8
%t7187 = load i64, ptr %t7186, align 8
%t7188 = icmp eq i64 %t7187, 2
br label %LSL7189
LSL7189:
br i1 %t7188, label %LSJ7189, label %LSR7189
LSR7189:
%t7190 = getelementptr i8, ptr %t7161, i64 8
%t7191 = load i64, ptr %t7190, align 8
%t7192 = icmp eq i64 %t7191, 3
br label %LSJ7189
LSJ7189:
%t7193 = phi i1 [ true, %LSL7189 ], [ %t7192, %LSR7189 ]
br label %LSL7194
LSL7194:
br i1 %t7193, label %LSR7194, label %LSJ7194
LSR7194:
%t7195 = getelementptr i8, ptr %t7161, i64 16
%t7196 = load i64, ptr %t7195, align 8
%t7197 = icmp slt i64 %t7196, 0
br label %LSL7198
LSL7198:
br i1 %t7197, label %LSJ7198, label %LSR7198
LSR7198:
%t7199 = getelementptr i8, ptr %t7161, i64 16
%t7200 = load i64, ptr %t7199, align 8
%t7201 = call i64 @resid_list_len(ptr %p0)
%t7202 = getelementptr i8, ptr %t7161, i64 24
%t7203 = load i64, ptr %t7202, align 8
%t7204 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7201, i64 %t7203)
%t7205 = extractvalue {i64, i1} %t7204, 0
%t7206 = extractvalue {i64, i1} %t7204, 1
%t7207 = zext i1 %t7206 to i8
call void @resid_overflow_check(i8 %t7207)
%t7208 = icmp sgt i64 %t7200, %t7205
br label %LSJ7198
LSJ7198:
%t7209 = phi i1 [ true, %LSL7198 ], [ %t7208, %LSR7198 ]
br label %LSJ7194
LSJ7194:
%t7210 = phi i1 [ false, %LSL7194 ], [ %t7209, %LSJ7198 ]
br i1 %t7210, label %L784, label %L786
L784:
%lr.cx106 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz106 = icmp eq ptr %lr.cx106, null
br i1 %lr.lz106, label %lr.x106.k, label %lr.x106.m
lr.x106.k:
ret ptr @.s7211
lr.x106.m:
%lr.ret106 = call ptr @resid_mv_str(ptr @.s7211, ptr %lr.cx106)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret106
L786:
%t7212 = getelementptr i8, ptr %t7161, i64 8
%t7213 = load i64, ptr %t7212, align 8
%t7214 = icmp eq i64 %t7213, 2
br label %LSL7215
LSL7215:
br i1 %t7214, label %LSJ7215, label %LSR7215
LSR7215:
%t7216 = getelementptr i8, ptr %t7161, i64 8
%t7217 = load i64, ptr %t7216, align 8
%t7218 = icmp eq i64 %t7217, 3
br label %LSJ7215
LSJ7215:
%t7219 = phi i1 [ true, %LSL7215 ], [ %t7218, %LSR7215 ]
br i1 %t7219, label %L787, label %L788
L787:
%t7220 = getelementptr i8, ptr %t7161, i64 24
%t7221 = load i64, ptr %t7220, align 8
%t7222 = getelementptr i8, ptr %t7161, i64 16
%t7223 = load i64, ptr %t7222, align 8
%t7224 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7221, i64 %t7223)
%t7225 = extractvalue {i64, i1} %t7224, 0
%t7226 = extractvalue {i64, i1} %t7224, 1
%t7227 = zext i1 %t7226 to i8
call void @resid_overflow_check(i8 %t7227)
br label %L789
L788:
%t7228 = getelementptr i8, ptr %t7161, i64 24
%t7229 = load i64, ptr %t7228, align 8
br label %L789
L789:
%t7230 = phi i64 [ %t7225, %L787 ], [ %t7229, %L788 ]
%t7231 = sub nsw i64 %p2, 1
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
%t7233 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t7234 = getelementptr i8, ptr %t7233, i64 0
%t7235 = load i1, ptr %t7234, align 8
%t7236 = xor i1 %t7235, true
br label %LSL7237
LSL7237:
br i1 %t7236, label %LSJ7237, label %LSR7237
LSR7237:
%t7238 = getelementptr i8, ptr %t7233, i64 8
%t7239 = load i64, ptr %t7238, align 8
%t7240 = icmp ne i64 %t7239, 6
br label %LSJ7237
LSJ7237:
%t7241 = phi i1 [ true, %LSL7237 ], [ %t7240, %LSR7237 ]
br label %LSL7242
LSL7242:
br i1 %t7241, label %LSJ7242, label %LSR7242
LSR7242:
%t7243 = getelementptr i8, ptr %t7233, i64 16
%t7244 = load i64, ptr %t7243, align 8
%t7245 = icmp ne i64 %t7244, 18
br label %LSJ7242
LSJ7242:
%t7246 = phi i1 [ true, %LSL7242 ], [ %t7245, %LSR7242 ]
br i1 %t7246, label %L790, label %L792
L790:
%t7248 = musttail call ptr @cose_sign1_err(ptr @.s7247)
ret ptr %t7248
L792:
%t7249 = getelementptr i8, ptr %t7233, i64 24
%t7250 = load i64, ptr %t7249, align 8
%t7251 = call ptr @cbe_read_head(ptr %p0, i64 %t7250)
%t7252 = getelementptr i8, ptr %t7251, i64 0
%t7253 = load i1, ptr %t7252, align 8
%t7254 = xor i1 %t7253, true
br label %LSL7255
LSL7255:
br i1 %t7254, label %LSJ7255, label %LSR7255
LSR7255:
%t7256 = getelementptr i8, ptr %t7251, i64 8
%t7257 = load i64, ptr %t7256, align 8
%t7258 = icmp ne i64 %t7257, 4
br label %LSJ7255
LSJ7255:
%t7259 = phi i1 [ true, %LSL7255 ], [ %t7258, %LSR7255 ]
br label %LSL7260
LSL7260:
br i1 %t7259, label %LSJ7260, label %LSR7260
LSR7260:
%t7261 = getelementptr i8, ptr %t7251, i64 16
%t7262 = load i64, ptr %t7261, align 8
%t7263 = icmp ne i64 %t7262, 4
br label %LSJ7260
LSJ7260:
%t7264 = phi i1 [ true, %LSL7260 ], [ %t7263, %LSR7260 ]
br i1 %t7264, label %L793, label %L795
L793:
%t7266 = musttail call ptr @cose_sign1_err(ptr @.s7265)
ret ptr %t7266
L795:
%t7267 = getelementptr i8, ptr %t7251, i64 24
%t7268 = load i64, ptr %t7267, align 8
%t7269 = call ptr @cbe_read_str(ptr %p0, i64 %t7268, i64 2)
%t7270 = getelementptr i8, ptr %t7269, i64 0
%t7271 = load i1, ptr %t7270, align 8
%t7272 = xor i1 %t7271, true
br i1 %t7272, label %L796, label %L798
L796:
%t7274 = musttail call ptr @cose_sign1_err(ptr @.s7273)
ret ptr %t7274
L798:
%t7275 = getelementptr i8, ptr %t7269, i64 16
%t7276 = load i64, ptr %t7275, align 8
%t7277 = call ptr @cbe_read_head(ptr %p0, i64 %t7276)
%t7278 = getelementptr i8, ptr %t7277, i64 0
%t7279 = load i1, ptr %t7278, align 8
%t7280 = xor i1 %t7279, true
br label %LSL7281
LSL7281:
br i1 %t7280, label %LSJ7281, label %LSR7281
LSR7281:
%t7282 = getelementptr i8, ptr %t7277, i64 8
%t7283 = load i64, ptr %t7282, align 8
%t7284 = icmp ne i64 %t7283, 5
br label %LSJ7281
LSJ7281:
%t7285 = phi i1 [ true, %LSL7281 ], [ %t7284, %LSR7281 ]
br label %LSL7286
LSL7286:
br i1 %t7285, label %LSJ7286, label %LSR7286
LSR7286:
%t7287 = getelementptr i8, ptr %t7277, i64 16
%t7288 = load i64, ptr %t7287, align 8
%t7289 = icmp ne i64 %t7288, 0
br label %LSJ7286
LSJ7286:
%t7290 = phi i1 [ true, %LSL7286 ], [ %t7289, %LSR7286 ]
br i1 %t7290, label %L799, label %L801
L799:
%t7292 = musttail call ptr @cose_sign1_err(ptr @.s7291)
ret ptr %t7292
L801:
%t7293 = getelementptr i8, ptr %t7277, i64 24
%t7294 = load i64, ptr %t7293, align 8
%t7295 = call ptr @cbe_read_str(ptr %p0, i64 %t7294, i64 2)
%t7296 = getelementptr i8, ptr %t7295, i64 0
%t7297 = load i1, ptr %t7296, align 8
%t7298 = xor i1 %t7297, true
br i1 %t7298, label %L802, label %L804
L802:
%t7300 = musttail call ptr @cose_sign1_err(ptr @.s7299)
ret ptr %t7300
L804:
%t7301 = getelementptr i8, ptr %t7295, i64 16
%t7302 = load i64, ptr %t7301, align 8
%t7303 = call ptr @cbe_read_str(ptr %p0, i64 %t7302, i64 2)
%t7304 = getelementptr i8, ptr %t7303, i64 0
%t7305 = load i1, ptr %t7304, align 8
%t7306 = xor i1 %t7305, true
br label %LSL7307
LSL7307:
br i1 %t7306, label %LSJ7307, label %LSR7307
LSR7307:
%t7308 = getelementptr i8, ptr %t7303, i64 8
%t7309 = load ptr, ptr %t7308, align 8
%t7310 = call i64 @resid_list_len(ptr %t7309)
%t7311 = icmp ne i64 %t7310, 64
br label %LSJ7307
LSJ7307:
%t7312 = phi i1 [ true, %LSL7307 ], [ %t7311, %LSR7307 ]
br i1 %t7312, label %L805, label %L807
L805:
%t7314 = musttail call ptr @cose_sign1_err(ptr @.s7313)
ret ptr %t7314
L807:
%t7315 = call ptr @resid_gmalloc(i64 48)
%t7315.f0 = getelementptr i8, ptr %t7315, i64 0
store i1 true, ptr %t7315.f0, align 8
%t7315.f1 = getelementptr i8, ptr %t7315, i64 8
store ptr @.s7316, ptr %t7315.f1, align 8
%t7317 = getelementptr i8, ptr %t7269, i64 8
%t7318 = load ptr, ptr %t7317, align 8
%t7319 = call ptr @cose_kid_of(ptr %t7318)
%t7315.f2 = getelementptr i8, ptr %t7315, i64 16
store ptr %t7319, ptr %t7315.f2, align 8
%t7320 = getelementptr i8, ptr %t7269, i64 8
%t7321 = load ptr, ptr %t7320, align 8
%t7315.f3 = getelementptr i8, ptr %t7315, i64 24
store ptr %t7321, ptr %t7315.f3, align 8
%t7322 = getelementptr i8, ptr %t7295, i64 8
%t7323 = load ptr, ptr %t7322, align 8
%t7315.f4 = getelementptr i8, ptr %t7315, i64 32
store ptr %t7323, ptr %t7315.f4, align 8
%t7324 = getelementptr i8, ptr %t7303, i64 8
%t7325 = load ptr, ptr %t7324, align 8
%t7315.f5 = getelementptr i8, ptr %t7315, i64 40
store ptr %t7325, ptr %t7315.f5, align 8
ret ptr %t7315
}
define i1 @cose_sign1_check(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7326 = getelementptr i8, ptr %p0, i64 24
%t7327 = load ptr, ptr %t7326, align 8
%t7328 = getelementptr i8, ptr %p0, i64 32
%t7329 = load ptr, ptr %t7328, align 8
%t7330 = call ptr @cose_sig_structure(ptr %t7327, ptr %t7329)
%t7331 = call ptr @resid_list_freeze(ptr %t7330)
%t7332 = getelementptr i8, ptr %p0, i64 40
%t7333 = load ptr, ptr %t7332, align 8
%t7334 = call i1 @verify_sig_bytes(ptr %t7331, ptr %t7333, ptr %p1)
ret i1 %t7334
}
define ptr @cose_enc_structure(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7336 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty7335)
%t7338 = call ptr @resid_list_const_i64(ptr @.lc7337, i64 10, ptr @.lcd7337, ptr @.lty7337)
%t7339 = call ptr @cbe_bytes(ptr %p0, ptr %t7338)
%t7340 = call ptr @cbe_bytes(ptr %t7336, ptr %t7339)
ret ptr %t7340
}
define ptr @cose_encrypt0_protected() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7342 = call ptr @resid_list_const_i64(ptr @.lc7341, i64 4, ptr @.lcd7341, ptr @.lty7341)
ret ptr %t7342
}
define ptr @cose_encrypt0_nonce(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7344 = call ptr @resid_list_const_i64(ptr @.lc7343, i64 25, ptr @.lcd7343, ptr @.lty7343)
%t7345 = call ptr @resid_list_concat(ptr %t7344, ptr %p0)
%t7346 = call ptr @bytes_of(ptr %p1)
%t7347 = call ptr @resid_list_freeze(ptr %t7346)
%t7348 = call ptr @resid_list_concat_own(ptr %t7345, i8 1, ptr %t7347)
%t7349 = call ptr @resid_list_concat_own(ptr %t7348, i8 1, ptr %p2)
%t7350 = call ptr @sha256_bytes(ptr %t7349)
%t7351 = call ptr @slice_bytes(ptr %t7350, i64 0, i64 11)
ret ptr %t7351
}
define ptr @cose_encrypt0_seal(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7352 = call ptr @cose_encrypt0_nonce(ptr %p1, ptr %p2, ptr %p0)
%t7353 = call ptr @resid_list_freeze(ptr %t7352)
%t7355 = call ptr @resid_list_const_i64(ptr @.lc7354, i64 16, ptr @.lcd7354, ptr @.lty7354)
%t7356 = call ptr @chacha20poly1305_seal(ptr %p1, ptr %t7353, ptr %p0, ptr %t7355)
%t7357 = call ptr @resid_list_freeze(ptr %t7356)
%t7359 = call ptr @resid_list_const_i64(ptr @.lc7358, i64 9, ptr @.lcd7358, ptr @.lty7358)
%t7360 = call ptr @cbe_bytes(ptr %t7353, ptr %t7359)
%t7361 = call ptr @cbe_bytes(ptr %t7357, ptr %t7360)
ret ptr %t7361
}
define ptr @cose_open_err(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7362 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB7362)
%t7363 = call ptr @resid_gmalloc(i64 24)
%t7363.f0 = getelementptr i8, ptr %t7363, i64 0
store i1 false, ptr %t7363.f0, align 8
%t7363.f1 = getelementptr i8, ptr %t7363, i64 8
store ptr %p0, ptr %t7363.f1, align 8
%t7363.f2 = getelementptr i8, ptr %t7363, i64 16
store ptr %t7362, ptr %t7363.f2, align 8
ret ptr %t7363
}
define i1 @cose_is_encrypt0(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7364 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t7365 = getelementptr i8, ptr %t7364, i64 0
%t7366 = load i1, ptr %t7365, align 8
br label %LSL7367
LSL7367:
br i1 %t7366, label %LSR7367, label %LSJ7367
LSR7367:
%t7368 = getelementptr i8, ptr %t7364, i64 8
%t7369 = load i64, ptr %t7368, align 8
%t7370 = icmp eq i64 %t7369, 6
br label %LSJ7367
LSJ7367:
%t7371 = phi i1 [ false, %LSL7367 ], [ %t7370, %LSR7367 ]
br label %LSL7372
LSL7372:
br i1 %t7371, label %LSR7372, label %LSJ7372
LSR7372:
%t7373 = getelementptr i8, ptr %t7364, i64 16
%t7374 = load i64, ptr %t7373, align 8
%t7375 = icmp eq i64 %t7374, 16
br label %LSJ7372
LSJ7372:
%t7376 = phi i1 [ false, %LSL7372 ], [ %t7375, %LSR7372 ]
ret i1 %t7376
}
define ptr @cose_encrypt0_open(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7377 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t7378 = getelementptr i8, ptr %t7377, i64 0
%t7379 = load i1, ptr %t7378, align 8
%t7380 = xor i1 %t7379, true
br label %LSL7381
LSL7381:
br i1 %t7380, label %LSJ7381, label %LSR7381
LSR7381:
%t7382 = getelementptr i8, ptr %t7377, i64 8
%t7383 = load i64, ptr %t7382, align 8
%t7384 = icmp ne i64 %t7383, 6
br label %LSJ7381
LSJ7381:
%t7385 = phi i1 [ true, %LSL7381 ], [ %t7384, %LSR7381 ]
br label %LSL7386
LSL7386:
br i1 %t7385, label %LSJ7386, label %LSR7386
LSR7386:
%t7387 = getelementptr i8, ptr %t7377, i64 16
%t7388 = load i64, ptr %t7387, align 8
%t7389 = icmp ne i64 %t7388, 16
br label %LSJ7386
LSJ7386:
%t7390 = phi i1 [ true, %LSL7386 ], [ %t7389, %LSR7386 ]
br i1 %t7390, label %L808, label %L810
L808:
%t7392 = call ptr @cose_open_err(ptr @.s7391)
ret ptr %t7392
L810:
%t7393 = getelementptr i8, ptr %t7377, i64 24
%t7394 = load i64, ptr %t7393, align 8
%t7395 = call ptr @cbe_read_head(ptr %p0, i64 %t7394)
%t7396 = getelementptr i8, ptr %t7395, i64 0
%t7397 = load i1, ptr %t7396, align 8
%t7398 = xor i1 %t7397, true
br label %LSL7399
LSL7399:
br i1 %t7398, label %LSJ7399, label %LSR7399
LSR7399:
%t7400 = getelementptr i8, ptr %t7395, i64 8
%t7401 = load i64, ptr %t7400, align 8
%t7402 = icmp ne i64 %t7401, 4
br label %LSJ7399
LSJ7399:
%t7403 = phi i1 [ true, %LSL7399 ], [ %t7402, %LSR7399 ]
br label %LSL7404
LSL7404:
br i1 %t7403, label %LSJ7404, label %LSR7404
LSR7404:
%t7405 = getelementptr i8, ptr %t7395, i64 16
%t7406 = load i64, ptr %t7405, align 8
%t7407 = icmp ne i64 %t7406, 3
br label %LSJ7404
LSJ7404:
%t7408 = phi i1 [ true, %LSL7404 ], [ %t7407, %LSR7404 ]
br i1 %t7408, label %L811, label %L813
L811:
%t7410 = call ptr @cose_open_err(ptr @.s7409)
ret ptr %t7410
L813:
%t7411 = getelementptr i8, ptr %t7395, i64 24
%t7412 = load i64, ptr %t7411, align 8
%t7413 = call ptr @cbe_read_str(ptr %p0, i64 %t7412, i64 2)
call void @"resid.rec.freeze.CbeStr"(ptr %t7413)
%t7414 = getelementptr i8, ptr %t7413, i64 0
%t7415 = load i1, ptr %t7414, align 8
%t7416 = xor i1 %t7415, true
br i1 %t7416, label %L814, label %L816
L814:
%t7418 = call ptr @cose_open_err(ptr @.s7417)
ret ptr %t7418
L816:
%t7419 = getelementptr i8, ptr %t7413, i64 16
%t7420 = load i64, ptr %t7419, align 8
%t7421 = call ptr @cbe_read_head(ptr %p0, i64 %t7420)
%t7422 = getelementptr i8, ptr %t7421, i64 0
%t7423 = load i1, ptr %t7422, align 8
%t7424 = xor i1 %t7423, true
br label %LSL7425
LSL7425:
br i1 %t7424, label %LSJ7425, label %LSR7425
LSR7425:
%t7426 = getelementptr i8, ptr %t7421, i64 8
%t7427 = load i64, ptr %t7426, align 8
%t7428 = icmp ne i64 %t7427, 5
br label %LSJ7425
LSJ7425:
%t7429 = phi i1 [ true, %LSL7425 ], [ %t7428, %LSR7425 ]
br label %LSL7430
LSL7430:
br i1 %t7429, label %LSJ7430, label %LSR7430
LSR7430:
%t7431 = getelementptr i8, ptr %t7421, i64 16
%t7432 = load i64, ptr %t7431, align 8
%t7433 = icmp ne i64 %t7432, 1
br label %LSJ7430
LSJ7430:
%t7434 = phi i1 [ true, %LSL7430 ], [ %t7433, %LSR7430 ]
br i1 %t7434, label %L817, label %L819
L817:
%t7436 = call ptr @cose_open_err(ptr @.s7435)
ret ptr %t7436
L819:
%t7437 = getelementptr i8, ptr %t7421, i64 24
%t7438 = load i64, ptr %t7437, align 8
%t7439 = call ptr @cbe_read_head(ptr %p0, i64 %t7438)
%t7440 = getelementptr i8, ptr %t7439, i64 0
%t7441 = load i1, ptr %t7440, align 8
%t7442 = xor i1 %t7441, true
br label %LSL7443
LSL7443:
br i1 %t7442, label %LSJ7443, label %LSR7443
LSR7443:
%t7444 = getelementptr i8, ptr %t7439, i64 8
%t7445 = load i64, ptr %t7444, align 8
%t7446 = icmp ne i64 %t7445, 0
br label %LSJ7443
LSJ7443:
%t7447 = phi i1 [ true, %LSL7443 ], [ %t7446, %LSR7443 ]
br label %LSL7448
LSL7448:
br i1 %t7447, label %LSJ7448, label %LSR7448
LSR7448:
%t7449 = getelementptr i8, ptr %t7439, i64 16
%t7450 = load i64, ptr %t7449, align 8
%t7451 = icmp ne i64 %t7450, 5
br label %LSJ7448
LSJ7448:
%t7452 = phi i1 [ true, %LSL7448 ], [ %t7451, %LSR7448 ]
br i1 %t7452, label %L820, label %L822
L820:
%t7454 = call ptr @cose_open_err(ptr @.s7453)
ret ptr %t7454
L822:
%t7455 = getelementptr i8, ptr %t7439, i64 24
%t7456 = load i64, ptr %t7455, align 8
%t7457 = call ptr @cbe_read_str(ptr %p0, i64 %t7456, i64 2)
%t7458 = getelementptr i8, ptr %t7457, i64 0
%t7459 = load i1, ptr %t7458, align 8
%t7460 = xor i1 %t7459, true
br label %LSL7461
LSL7461:
br i1 %t7460, label %LSJ7461, label %LSR7461
LSR7461:
%t7462 = getelementptr i8, ptr %t7457, i64 8
%t7463 = load ptr, ptr %t7462, align 8
%t7464 = call i64 @resid_list_len(ptr %t7463)
%t7465 = icmp ne i64 %t7464, 12
br label %LSJ7461
LSJ7461:
%t7466 = phi i1 [ true, %LSL7461 ], [ %t7465, %LSR7461 ]
br i1 %t7466, label %L823, label %L825
L823:
%t7468 = call ptr @cose_open_err(ptr @.s7467)
ret ptr %t7468
L825:
%t7469 = getelementptr i8, ptr %t7457, i64 16
%t7470 = load i64, ptr %t7469, align 8
%t7471 = call ptr @cbe_read_str(ptr %p0, i64 %t7470, i64 2)
%t7472 = getelementptr i8, ptr %t7471, i64 0
%t7473 = load i1, ptr %t7472, align 8
%t7474 = xor i1 %t7473, true
br label %LSL7475
LSL7475:
br i1 %t7474, label %LSJ7475, label %LSR7475
LSR7475:
%t7476 = getelementptr i8, ptr %t7471, i64 8
%t7477 = load ptr, ptr %t7476, align 8
%t7478 = call i64 @resid_list_len(ptr %t7477)
%t7479 = icmp slt i64 %t7478, 16
br label %LSJ7475
LSJ7475:
%t7480 = phi i1 [ true, %LSL7475 ], [ %t7479, %LSR7475 ]
br i1 %t7480, label %L826, label %L828
L826:
%t7482 = call ptr @cose_open_err(ptr @.s7481)
ret ptr %t7482
L828:
%t7483 = call i64 @resid_scope_push()
%t7484 = getelementptr i8, ptr %t7457, i64 8
%t7485 = load ptr, ptr %t7484, align 8
%t7486 = getelementptr i8, ptr %t7471, i64 8
%t7487 = load ptr, ptr %t7486, align 8
%t7488 = getelementptr i8, ptr %t7413, i64 8
%t7489 = load ptr, ptr %t7488, align 8
%t7490 = call ptr @cose_enc_structure(ptr %t7489)
%t7491 = call ptr @resid_list_freeze(ptr %t7490)
%t7492 = call i1 @chacha20poly1305_open(ptr %p1, ptr %t7485, ptr %t7487, ptr %t7491)
call void @resid_scope_pop(i64 %t7483)
%t7493 = xor i1 %t7492, true
br i1 %t7493, label %L829, label %L831
L829:
%t7495 = call ptr @cose_open_err(ptr @.s7494)
ret ptr %t7495
L831:
%t7496 = getelementptr i8, ptr %t7471, i64 8
%t7497 = load ptr, ptr %t7496, align 8
%t7498 = getelementptr i8, ptr %t7471, i64 8
%t7499 = load ptr, ptr %t7498, align 8
%t7500 = call i64 @resid_list_len(ptr %t7499)
%t7501 = sub nsw i64 %t7500, 17
%t7502 = call ptr @slice_bytes(ptr %t7497, i64 0, i64 %t7501)
%t7503 = call ptr @resid_gmalloc(i64 24)
%t7503.f0 = getelementptr i8, ptr %t7503, i64 0
store i1 true, ptr %t7503.f0, align 8
%t7503.f1 = getelementptr i8, ptr %t7503, i64 8
store ptr @.s7504, ptr %t7503.f1, align 8
%t7505 = getelementptr i8, ptr %t7457, i64 8
%t7506 = load ptr, ptr %t7505, align 8
%t7507 = call ptr @chacha20_xor(ptr %p1, i64 1, ptr %t7506, ptr %t7502)
%t7503.f2 = getelementptr i8, ptr %t7503, i64 16
store ptr %t7507, ptr %t7503.f2, align 8
ret ptr %t7503
}
define i64 @lo64(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7508 = trunc i128 %p0 to i64
ret i64 %t7508
}
define i64 @hi64(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7509 = lshr i128 %p0, 64
%t7510 = add i128 %t7509, 0
%t7511 = trunc i128 %t7510 to i64
%t7512 = zext i64 %t7511 to i128
%t7513 = icmp ne i128 %t7512, %t7510
%t7514 = icmp eq i8 0, 1
%t7515 = or i1 %t7513, %t7514
%t7516 = zext i1 %t7515 to i8
call void @resid_conv_check(i8 %t7516)
ret i64 %t7511
}
define ptr @zeros(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7519, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7523, %tco.s0 ]
%t7517 = icmp sge i64 %p1, %p0
br i1 %t7517, label %L832, label %L834
L832:
%t7518 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty7518)
ret ptr %t7518
L834:
%t7519 = add nsw i64 %p1, 1
%t7520 = call ptr @resid_box_i64(i64 0)
%t7523 = call ptr @resid_listbuf_push(ptr %p2, ptr %t7520)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @limb(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7525 = call i64 @resid_list_len(ptr %p0)
%t7526 = icmp slt i64 %p1, %t7525
br i1 %t7526, label %L835, label %L836
L835:
%t7527 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t7528 = call i64 @resid_unbox_i64(ptr %t7527)
br label %L837
L836:
br label %L837
L837:
%t7530 = phi i64 [ %t7528, %L835 ], [ 0, %L836 ]
ret i64 %t7530
}
define ptr @addmul(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %t7590, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t7591, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t7592, %tco.s0 ]
%t7531 = icmp sge i64 %p4, %p3
br i1 %t7531, label %L838, label %L840
L838:
%t7532 = call ptr @resid_list_get(ptr %p0, i64 %p3)
%t7533 = call i64 @resid_unbox_i64(ptr %t7532)
%t7535 = zext i64 %t7533 to i128
%t7536 = zext i64 %p5 to i128
%t7537 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t7535, i128 %t7536)
%t7538 = extractvalue {i128, i1} %t7537, 0
%t7539 = extractvalue {i128, i1} %t7537, 1
%t7540 = zext i1 %t7539 to i8
call void @resid_overflow_check(i8 %t7540)
%t7541 = call i64 @lo64(i128 %t7538)
%t7545 = call ptr @resid_list_with_i64(ptr %p0, i8 0, i64 %p3, i64 %t7541)
%t7546 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 1)
%t7547 = extractvalue {i64, i1} %t7546, 0
%t7548 = extractvalue {i64, i1} %t7546, 1
%t7549 = zext i1 %t7548 to i8
call void @resid_overflow_check(i8 %t7549)
%t7550 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 1)
%t7551 = extractvalue {i64, i1} %t7550, 0
%t7552 = extractvalue {i64, i1} %t7550, 1
%t7553 = zext i1 %t7552 to i8
call void @resid_overflow_check(i8 %t7553)
%t7554 = call ptr @resid_list_get(ptr %p0, i64 %t7551)
%t7555 = call i64 @resid_unbox_i64(ptr %t7554)
%t7557 = call i64 @hi64(i128 %t7538)
%t7558 = call {i64, i1} @llvm.uadd.with.overflow.i64(i64 %t7555, i64 %t7557)
%t7559 = extractvalue {i64, i1} %t7558, 0
%t7560 = extractvalue {i64, i1} %t7558, 1
%t7561 = zext i1 %t7560 to i8
call void @resid_overflow_check(i8 %t7561)
%t7565 = call ptr @resid_list_with_i64(ptr %t7545, i8 0, i64 %t7547, i64 %t7559)
ret ptr %t7565
L840:
%t7566 = call ptr @resid_list_get(ptr %p0, i64 %p4)
%t7567 = call i64 @resid_unbox_i64(ptr %t7566)
%t7569 = zext i64 %t7567 to i128
%t7570 = zext i64 %p2 to i128
%t7571 = call i64 @limb(ptr %p1, i64 %p4)
%t7572 = zext i64 %t7571 to i128
%t7573 = call {i128, i1} @llvm.umul.with.overflow.i128(i128 %t7570, i128 %t7572)
%t7574 = extractvalue {i128, i1} %t7573, 0
%t7575 = extractvalue {i128, i1} %t7573, 1
%t7576 = zext i1 %t7575 to i8
call void @resid_overflow_check(i8 %t7576)
%t7577 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t7569, i128 %t7574)
%t7578 = extractvalue {i128, i1} %t7577, 0
%t7579 = extractvalue {i128, i1} %t7577, 1
%t7580 = zext i1 %t7579 to i8
call void @resid_overflow_check(i8 %t7580)
%t7581 = zext i64 %p5 to i128
%t7582 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t7578, i128 %t7581)
%t7583 = extractvalue {i128, i1} %t7582, 0
%t7584 = extractvalue {i128, i1} %t7582, 1
%t7585 = zext i1 %t7584 to i8
call void @resid_overflow_check(i8 %t7585)
%t7586 = call i64 @lo64(i128 %t7583)
%t7590 = call ptr @resid_list_with_i64(ptr %p0, i8 0, i64 %p4, i64 %t7586)
%t7591 = add nsw i64 %p4, 1
%t7592 = call i64 @hi64(i128 %t7583)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @redc_step(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %t7669, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t7670, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t7671, %tco.s0 ]
%t7594 = icmp sge i64 %p4, %p3
br i1 %t7594, label %L841, label %L843
L841:
%t7595 = call ptr @resid_list_get(ptr %p0, i64 %p3)
%t7596 = call i64 @resid_unbox_i64(ptr %t7595)
%t7598 = zext i64 %t7596 to i128
%t7599 = zext i64 %p5 to i128
%t7600 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t7598, i128 %t7599)
%t7601 = extractvalue {i128, i1} %t7600, 0
%t7602 = extractvalue {i128, i1} %t7600, 1
%t7603 = zext i1 %t7602 to i8
call void @resid_overflow_check(i8 %t7603)
%t7604 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p3, i64 1)
%t7605 = extractvalue {i64, i1} %t7604, 0
%t7606 = extractvalue {i64, i1} %t7604, 1
%t7607 = zext i1 %t7606 to i8
call void @resid_overflow_check(i8 %t7607)
%t7608 = call i64 @lo64(i128 %t7601)
%t7612 = call ptr @resid_list_with_i64(ptr %p0, i8 0, i64 %t7605, i64 %t7608)
%t7613 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 1)
%t7614 = extractvalue {i64, i1} %t7613, 0
%t7615 = extractvalue {i64, i1} %t7613, 1
%t7616 = zext i1 %t7615 to i8
call void @resid_overflow_check(i8 %t7616)
%t7617 = call ptr @resid_list_get(ptr %p0, i64 %t7614)
%t7618 = call i64 @resid_unbox_i64(ptr %t7617)
%t7620 = call i64 @hi64(i128 %t7601)
%t7621 = call {i64, i1} @llvm.uadd.with.overflow.i64(i64 %t7618, i64 %t7620)
%t7622 = extractvalue {i64, i1} %t7621, 0
%t7623 = extractvalue {i64, i1} %t7621, 1
%t7624 = zext i1 %t7623 to i8
call void @resid_overflow_check(i8 %t7624)
%t7628 = call ptr @resid_list_with_i64(ptr %t7612, i8 0, i64 %p3, i64 %t7622)
%t7629 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 1)
%t7630 = extractvalue {i64, i1} %t7629, 0
%t7631 = extractvalue {i64, i1} %t7629, 1
%t7632 = zext i1 %t7631 to i8
call void @resid_overflow_check(i8 %t7632)
%t7636 = call ptr @resid_list_with_i64(ptr %t7628, i8 0, i64 %t7630, i64 0)
ret ptr %t7636
L843:
%t7637 = call ptr @resid_list_get(ptr %p0, i64 %p4)
%t7638 = call i64 @resid_unbox_i64(ptr %t7637)
%t7640 = zext i64 %t7638 to i128
%t7641 = zext i64 %p2 to i128
%t7642 = call ptr @resid_list_get_v(ptr %p1, i64 %p4, ptr %p1.ld, i64 %p1.ln)
%t7643 = call i64 @resid_unbox_i64(ptr %t7642)
%t7645 = zext i64 %t7643 to i128
%t7646 = call {i128, i1} @llvm.umul.with.overflow.i128(i128 %t7641, i128 %t7645)
%t7647 = extractvalue {i128, i1} %t7646, 0
%t7648 = extractvalue {i128, i1} %t7646, 1
%t7649 = zext i1 %t7648 to i8
call void @resid_overflow_check(i8 %t7649)
%t7650 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t7640, i128 %t7647)
%t7651 = extractvalue {i128, i1} %t7650, 0
%t7652 = extractvalue {i128, i1} %t7650, 1
%t7653 = zext i1 %t7652 to i8
call void @resid_overflow_check(i8 %t7653)
%t7654 = zext i64 %p5 to i128
%t7655 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t7651, i128 %t7654)
%t7656 = extractvalue {i128, i1} %t7655, 0
%t7657 = extractvalue {i128, i1} %t7655, 1
%t7658 = zext i1 %t7657 to i8
call void @resid_overflow_check(i8 %t7658)
%t7659 = icmp eq i64 %p4, 0
br i1 %t7659, label %L844, label %L845
L844:
br label %L846
L845:
%t7660 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p4, i64 1)
%t7661 = extractvalue {i64, i1} %t7660, 0
%t7662 = extractvalue {i64, i1} %t7660, 1
%t7663 = zext i1 %t7662 to i8
call void @resid_overflow_check(i8 %t7663)
%t7664 = call i64 @lo64(i128 %t7656)
%t7668 = call ptr @resid_list_with_i64(ptr %p0, i8 0, i64 %t7661, i64 %t7664)
br label %L846
L846:
%t7669 = phi ptr [ %p0, %L844 ], [ %t7668, %L845 ]
%t7670 = add nsw i64 %p4, 1
%t7671 = call i64 @hi64(i128 %t7656)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @cios(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, ptr %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t7681, %tco.s0 ]
%p6 = phi ptr [ %p6.in, %entry ], [ %t7683, %tco.s0 ]
%t7673 = icmp sge i64 %p5, %p4
br i1 %t7673, label %L847, label %L849
L847:
ret ptr %p6
L849:
%t7674 = call i64 @limb(ptr %p0, i64 %p5)
%t7675 = call ptr @addmul(ptr %p6, ptr %p1, i64 %t7674, i64 %p4, i64 0, i64 0)
%t7676 = call ptr @resid_list_freeze(ptr %t7675)
%t7677 = call ptr @resid_list_get(ptr %t7676, i64 0)
%t7678 = call i64 @resid_unbox_i64(ptr %t7677)
%t7680 = call i64 @wrapping_umul(i64 %t7678, i64 %p3)
%t7681 = add nsw i64 %p5, 1
%t7682 = call ptr @redc_step(ptr %t7676, ptr %p2, i64 %t7680, i64 %p4, i64 0, i64 0)
%t7683 = call ptr @resid_list_freeze(ptr %t7682)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @mont_mul2(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7685 = getelementptr i8, ptr %p0, i64 0
%t7686 = load ptr, ptr %t7685, align 8
%t7687 = getelementptr i8, ptr %p0, i64 16
%t7688 = load ptr, ptr %t7687, align 8
%t7689 = call ptr @resid_list_get(ptr %t7688, i64 0)
%t7690 = call i64 @resid_unbox_i64(ptr %t7689)
%t7692 = getelementptr i8, ptr %p0, i64 8
%t7693 = load i64, ptr %t7692, align 8
%t7694 = getelementptr i8, ptr %p0, i64 8
%t7695 = load i64, ptr %t7694, align 8
%t7696 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7695, i64 2)
%t7697 = extractvalue {i64, i1} %t7696, 0
%t7698 = extractvalue {i64, i1} %t7696, 1
%t7699 = zext i1 %t7698 to i8
call void @resid_overflow_check(i8 %t7699)
%t7700 = call ptr @resid_listbuf_new()
%t7701 = call ptr @zeros(i64 %t7697, i64 0, ptr %t7700)
%t7702 = call ptr @resid_list_freeze(ptr %t7701)
%t7703 = call ptr @cios(ptr %p1, ptr %p2, ptr %t7686, i64 %t7690, i64 %t7693, i64 0, ptr %t7702)
%t7704 = call ptr @bn_trim(ptr %t7703)
%t7705 = getelementptr i8, ptr %p0, i64 0
%t7706 = load ptr, ptr %t7705, align 8
%t7707 = call i64 @bn_cmp(ptr %t7704, ptr %t7706)
%t7708 = icmp sge i64 %t7707, 0
br i1 %t7708, label %L850, label %L851
L850:
%t7709 = getelementptr i8, ptr %p0, i64 0
%t7710 = load ptr, ptr %t7709, align 8
%t7711 = call ptr @bn_sub(ptr %t7704, ptr %t7710)
%t7712 = call ptr @resid_list_freeze(ptr %t7711)
br label %L852
L851:
br label %L852
L852:
%t7713 = phi ptr [ %t7712, %L850 ], [ %t7704, %L851 ]
ret ptr %t7713
}
define ptr @exp_bits(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t7721, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t7720, %tco.s0 ]
%t7714 = icmp slt i64 %p3, 0
br i1 %t7714, label %L853, label %L855
L853:
ret ptr %p4
L855:
%t7715 = call ptr @mont_mul2(ptr %p0, ptr %p4, ptr %p4)
%t7716 = call i64 @bn_bit(ptr %p2, i64 %p3)
%t7717 = icmp eq i64 %t7716, 1
br i1 %t7717, label %L856, label %L857
L856:
%t7718 = call ptr @mont_mul2(ptr %p0, ptr %t7715, ptr %p1)
%t7719 = call ptr @resid_list_freeze(ptr %t7718)
br label %L858
L857:
br label %L858
L858:
%t7720 = phi ptr [ %t7719, %L856 ], [ %t7715, %L857 ]
%t7721 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @modexp2(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7723 = call ptr @bn_mont_new(ptr %p2)
call void @"resid.rec.freeze.BnMont"(ptr %t7723)
%t7724 = getelementptr i8, ptr %t7723, i64 24
%t7725 = load ptr, ptr %t7724, align 8
%t7726 = call ptr @mont_mul2(ptr %t7723, ptr %p0, ptr %t7725)
%t7728 = call ptr @resid_list_const_i64(ptr @.lc7727, i64 1, ptr @.lcd7727, ptr @.lty7727)
%t7729 = getelementptr i8, ptr %t7723, i64 24
%t7730 = load ptr, ptr %t7729, align 8
%t7731 = call ptr @mont_mul2(ptr %t7723, ptr %t7728, ptr %t7730)
%t7732 = call i64 @bn_bit_len(ptr %p1)
%t7733 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7732, i64 1)
%t7734 = extractvalue {i64, i1} %t7733, 0
%t7735 = extractvalue {i64, i1} %t7733, 1
%t7736 = zext i1 %t7735 to i8
call void @resid_overflow_check(i8 %t7736)
%t7737 = call ptr @exp_bits(ptr %t7723, ptr %t7726, ptr %p1, i64 %t7734, ptr %t7731)
%t7739 = call ptr @resid_list_const_i64(ptr @.lc7738, i64 1, ptr @.lcd7738, ptr @.lty7738)
%t7740 = musttail call ptr @mont_mul2(ptr %t7723, ptr %t7737, ptr %t7739)
ret ptr %t7740
}
define ptr @loop(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t7743, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t7749, %tco.s0 ]
%t7741 = icmp sle i64 %p3, 0
br i1 %t7741, label %L859, label %L861
L859:
%t7742 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty7742)
ret ptr %t7742
L861:
%t7743 = sub nsw i64 %p3, 1
%t7744 = call ptr @modexp2(ptr %p0, ptr %p1, ptr %p2)
%t7745 = call ptr @resid_list_freeze(ptr %t7744)
%t7749 = call ptr @resid_listbuf_push(ptr %p4, ptr %t7745)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @run(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7751 = call ptr @resid_listbuf_new()
%t7753 = call ptr @resid_list_const_i64(ptr @.lc7752, i64 1, ptr @.lcd7752, ptr @.lty7752)
%t7754 = call ptr @loop(ptr %t7753, ptr %p0, ptr %p1, i64 %p2, ptr %t7751)
%t7755 = call ptr @resid_list_freeze(ptr %t7754)
%t7756 = call i64 @resid_list_len(ptr %t7755)
ret i64 %t7756
}
define i32 @resid_user_main() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
call void @resid_cap_check(ptr @resid.cap.main)
%t7757 = call ptr @resid_args_get(i64 1)
%t7758 = call ptr @cose_hex_decode(ptr %t7757)
%t7759 = call ptr @resid_list_freeze(ptr %t7758)
%t7760 = call ptr @bn_from_be(ptr %t7759)
%t7761 = call ptr @resid_list_freeze(ptr %t7760)
%t7763 = call ptr @resid_list_const_i64(ptr @.lc7762, i64 1, ptr @.lcd7762, ptr @.lty7762)
%t7764 = call ptr @bn_sub(ptr %t7761, ptr %t7763)
call void @resid_cap_check(ptr @resid.cap.main.1)
%t7765 = call ptr @resid_args_get(i64 2)
%t7766 = call i64 @str_parse_int(ptr %t7765)
call void @resid_cap_check(ptr @resid.cap.main.2)
%t7767 = call ptr @resid_args_get(i64 3)
%t7769 = call i8 @resid_str_eq(ptr %t7767, ptr @.s7768)
%t7770 = icmp ne i8 %t7769, 0
br i1 %t7770, label %L862, label %L864
L862:
%t7772 = call ptr @resid_list_const_i64(ptr @.lc7771, i64 1, ptr @.lcd7771, ptr @.lty7771)
%t7773 = call ptr @modexp2(ptr %t7772, ptr %t7764, ptr %t7761)
%t7774 = call ptr @resid_list_freeze(ptr %t7773)
%t7776 = call ptr @resid_list_const_i64(ptr @.lc7775, i64 1, ptr @.lcd7775, ptr @.lty7775)
%t7777 = call ptr @bn_modexp(ptr %t7776, ptr %t7764, ptr %t7761)
%t7778 = call ptr @resid_list_freeze(ptr %t7777)
%t7779 = call ptr @hex_check(ptr %t7774, ptr %t7778)
%t7780 = call i1 @println(ptr %t7779)
%t7781 = trunc i64 0 to i32
ret i32 %t7781
L864:
%t7782 = call i64 @run(ptr %t7764, ptr %t7761, i64 %t7766)
%t7783 = srem i64 %t7782, 200
%t7784 = trunc i64 %t7783 to i32
ret i32 %t7784
}
define ptr @hex_check(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7785 = call i64 @bn_cmp(ptr %p0, ptr %p1)
%t7786 = icmp eq i64 %t7785, 0
br i1 %t7786, label %L865, label %L866
L865:
br label %L867
L866:
br label %L867
L867:
%t7789 = phi ptr [ @.s7787, %L865 ], [ @.s7788, %L866 ]
ret ptr %t7789
}
define ptr @sha256g_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7790 = call ptr @resid_list_get(ptr %p2, i64 0)
%t7791 = call i64 @resid_unbox_i64(ptr %t7790)
%t7793 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7791, i64 4294967295)
%t7794 = call ptr @resid_list_get(ptr %p2, i64 1)
%t7795 = call i64 @resid_unbox_i64(ptr %t7794)
%t7797 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7795, i64 4294967295)
%t7798 = call ptr @resid_list_get(ptr %p2, i64 2)
%t7799 = call i64 @resid_unbox_i64(ptr %t7798)
%t7801 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7799, i64 4294967295)
%t7802 = call ptr @resid_list_get(ptr %p2, i64 3)
%t7803 = call i64 @resid_unbox_i64(ptr %t7802)
%t7805 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7803, i64 4294967295)
%t7806 = call ptr @resid_list_get(ptr %p2, i64 4)
%t7807 = call i64 @resid_unbox_i64(ptr %t7806)
%t7809 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7807, i64 4294967295)
%t7810 = call ptr @resid_list_get(ptr %p2, i64 5)
%t7811 = call i64 @resid_unbox_i64(ptr %t7810)
%t7813 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7811, i64 4294967295)
%t7814 = call ptr @resid_list_get(ptr %p2, i64 6)
%t7815 = call i64 @resid_unbox_i64(ptr %t7814)
%t7817 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7815, i64 4294967295)
%t7818 = call ptr @resid_list_get(ptr %p2, i64 7)
%t7819 = call i64 @resid_unbox_i64(ptr %t7818)
%t7821 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7819, i64 4294967295)
%t7822 = call ptr @__m____________lib_sha256g_resid__g_blk__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 0, ptr %p2, i64 %t7793, i64 %t7797, i64 %t7801, i64 %t7805, i64 %t7809, i64 %t7813, i64 %t7817, i64 %t7821, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret ptr %t7822
}
define ptr @base64g_decode__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7823 = call i64 @resid_list_len(ptr %p0)
%t7824 = srem i64 %t7823, 4
%t7825 = icmp sgt i64 %t7823, 0
br label %LSL7826
LSL7826:
br i1 %t7825, label %LSR7826, label %LSJ7826
LSR7826:
%t7827 = icmp eq i64 %t7824, 0
br label %LSL7828
LSL7828:
br i1 %t7827, label %LSR7828, label %LSJ7828
LSR7828:
%t7829 = icmp eq i64 %p1, 0
br label %LSJ7828
LSJ7828:
%t7830 = phi i1 [ false, %LSL7828 ], [ %t7829, %LSR7828 ]
br label %LSL7831
LSL7831:
br i1 %t7830, label %LSJ7831, label %LSR7831
LSR7831:
%t7832 = icmp eq i64 %t7824, 2
br label %LSL7833
LSL7833:
br i1 %t7832, label %LSR7833, label %LSJ7833
LSR7833:
%t7834 = icmp eq i64 %p1, 2
br label %LSJ7833
LSJ7833:
%t7835 = phi i1 [ false, %LSL7833 ], [ %t7834, %LSR7833 ]
br label %LSJ7831
LSJ7831:
%t7836 = phi i1 [ true, %LSL7831 ], [ %t7835, %LSJ7833 ]
br label %LSL7837
LSL7837:
br i1 %t7836, label %LSJ7837, label %LSR7837
LSR7837:
%t7838 = icmp eq i64 %t7824, 3
br label %LSL7839
LSL7839:
br i1 %t7838, label %LSR7839, label %LSJ7839
LSR7839:
%t7840 = icmp eq i64 %p1, 1
br label %LSJ7839
LSJ7839:
%t7841 = phi i1 [ false, %LSL7839 ], [ %t7840, %LSR7839 ]
br label %LSJ7837
LSJ7837:
%t7842 = phi i1 [ true, %LSL7837 ], [ %t7841, %LSJ7839 ]
br label %LSJ7826
LSJ7826:
%t7843 = phi i1 [ false, %LSL7826 ], [ %t7842, %LSJ7837 ]
%t7844 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB7844)
%t7845 = xor i1 %t7843, true
br i1 %t7845, label %L868, label %L870
L868:
ret ptr %t7844
L870:
%t7846 = call ptr @resid_listbuf_new()
%t7847 = call ptr @__m____________lib_crypto_resid__b64g_groups__g_Int_64__Int_64_(ptr %p0, i64 0, i64 0, ptr %t7846)
ret ptr %t7847
}
define i512 @eg_fadd__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7848 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %p1)
%t7849 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t7850 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t7848, i512 %t7849)
ret i512 %t7850
}
define i512 @eg_fsub__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7851 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t7852 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %t7851)
%t7853 = call i512 @__m____________lib_word_resid__pi_sub(i512 %t7852, i512 %p1)
%t7854 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t7855 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t7853, i512 %t7854)
ret i512 %t7855
}
define i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7856 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %p0, i512 %p1)
%t7857 = call i512 @__m____________lib_word_resid__pi_and(i512 %t7856, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t7858 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t7856, i64 256)
%t7859 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %t7858, i512 38)
%t7860 = call i512 @__m____________lib_word_resid__pi_add(i512 %t7857, i512 %t7859)
%t7861 = call i512 @__m____________lib_word_resid__pi_and(i512 %t7860, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t7862 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t7860, i64 256)
%t7863 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %t7862, i512 38)
%t7864 = call i512 @__m____________lib_word_resid__pi_add(i512 %t7861, i512 %t7863)
%t7865 = call i512 @__m____________lib_word_resid__pi_and(i512 %t7864, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t7866 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t7864, i64 256)
%t7867 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %t7866, i512 38)
%t7868 = call i512 @__m____________lib_word_resid__pi_add(i512 %t7865, i512 %t7867)
%t7869 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t7870 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t7868, i512 %t7869)
%t7871 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t7872 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t7870, i512 %t7871)
ret i512 %t7872
}
define i512 @eg_finv__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7873 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819947 to i512
%t7874 = call i512 @eg_fpow__g_Int_512__Int_64_(i512 1, i512 %p0, i512 %t7873, i64 254)
ret i512 %t7874
}
define i512 @eg_fpow__g_Int_512__Int_64_(i512 %p0.in, i512 %p1.in, i512 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t7884, %tco.s0 ], [ %t7876, %tco.s1 ]
%p1 = phi i512 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i512 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t7885, %tco.s0 ], [ %t7887, %tco.s1 ]
%t7875 = icmp slt i64 %p3, 0
br i1 %t7875, label %L871, label %L873
L871:
ret i512 %p0
L873:
%t7876 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p0)
%t7877 = sext i64 %p3 to i512
%t7878 = icmp uge i512 %t7877, 512
%t7879 = add i512 %t7877, 0
%t7880 = select i1 %t7878, i512 511, i512 %t7879
%t7881 = ashr i512 %p2, %t7880
%t7882 = and i512 %t7881, 1
%t7883 = icmp eq i512 %t7882, 1
br i1 %t7883, label %L874, label %L876
L874:
%t7884 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7876, i512 %p1)
%t7885 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
L876:
%t7887 = sub nsw i64 %p3, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define ptr @eg_dbl__g_Int_512__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7889 = getelementptr i8, ptr %p0, i64 0
%t7890 = load i512, ptr %t7889, align 8
%t7891 = getelementptr i8, ptr %p0, i64 0
%t7892 = load i512, ptr %t7891, align 8
%t7893 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7890, i512 %t7892)
%t7894 = getelementptr i8, ptr %p0, i64 64
%t7895 = load i512, ptr %t7894, align 8
%t7896 = getelementptr i8, ptr %p0, i64 64
%t7897 = load i512, ptr %t7896, align 8
%t7898 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7895, i512 %t7897)
%t7899 = getelementptr i8, ptr %p0, i64 128
%t7900 = load i512, ptr %t7899, align 8
%t7901 = getelementptr i8, ptr %p0, i64 128
%t7902 = load i512, ptr %t7901, align 8
%t7903 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7900, i512 %t7902)
%t7904 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t7903, i512 %t7903)
%t7905 = getelementptr i8, ptr %p0, i64 0
%t7906 = load i512, ptr %t7905, align 8
%t7907 = getelementptr i8, ptr %p0, i64 64
%t7908 = load i512, ptr %t7907, align 8
%t7909 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t7906, i512 %t7908)
%t7910 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7909, i512 %t7909)
%t7911 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t7910, i512 %t7893)
%t7912 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t7911, i512 %t7898)
%t7913 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t7898, i512 %t7893)
%t7914 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t7913, i512 %t7904)
%t7915 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 0, i512 %t7893)
%t7916 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t7915, i512 %t7898)
%t7917 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7912, i512 %t7914)
%t7918 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7913, i512 %t7916)
%t7919 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7914, i512 %t7913)
%t7920 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7912, i512 %t7916)
%t7921 = call ptr @resid_rec_reuse_sc(ptr %p0, i64 256)
%t7921.f0 = getelementptr i8, ptr %t7921, i64 0
store i512 %t7917, ptr %t7921.f0, align 8
%t7921.f8 = getelementptr i8, ptr %t7921, i64 64
store i512 %t7918, ptr %t7921.f8, align 8
%t7921.f16 = getelementptr i8, ptr %t7921, i64 128
store i512 %t7919, ptr %t7921.f16, align 8
%t7921.f24 = getelementptr i8, ptr %t7921, i64 192
store i512 %t7920, ptr %t7921.f24, align 8
ret ptr %t7921
}
define ptr @eg_add__g_Int_512__Int_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7922 = getelementptr i8, ptr %p0, i64 64
%t7923 = load i512, ptr %t7922, align 8
%t7924 = getelementptr i8, ptr %p0, i64 0
%t7925 = load i512, ptr %t7924, align 8
%t7926 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t7923, i512 %t7925)
%t7927 = getelementptr i8, ptr %p1, i64 64
%t7928 = load i512, ptr %t7927, align 8
%t7929 = getelementptr i8, ptr %p1, i64 0
%t7930 = load i512, ptr %t7929, align 8
%t7931 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t7928, i512 %t7930)
%t7932 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7926, i512 %t7931)
%t7933 = getelementptr i8, ptr %p0, i64 64
%t7934 = load i512, ptr %t7933, align 8
%t7935 = getelementptr i8, ptr %p0, i64 0
%t7936 = load i512, ptr %t7935, align 8
%t7937 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t7934, i512 %t7936)
%t7938 = getelementptr i8, ptr %p1, i64 64
%t7939 = load i512, ptr %t7938, align 8
%t7940 = getelementptr i8, ptr %p1, i64 0
%t7941 = load i512, ptr %t7940, align 8
%t7942 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t7939, i512 %t7941)
%t7943 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7937, i512 %t7942)
%t7944 = getelementptr i8, ptr %p0, i64 192
%t7945 = load i512, ptr %t7944, align 8
%t7946 = getelementptr i8, ptr %p0, i64 192
%t7947 = load i512, ptr %t7946, align 8
%t7948 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t7945, i512 %t7947)
%t7949 = sext i256 37095705934669439343138083508754565189542113879843219016388785533085940283555 to i512
%t7950 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7948, i512 %t7949)
%t7951 = getelementptr i8, ptr %p1, i64 192
%t7952 = load i512, ptr %t7951, align 8
%t7953 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7950, i512 %t7952)
%t7954 = getelementptr i8, ptr %p0, i64 128
%t7955 = load i512, ptr %t7954, align 8
%t7956 = getelementptr i8, ptr %p0, i64 128
%t7957 = load i512, ptr %t7956, align 8
%t7958 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t7955, i512 %t7957)
%t7959 = getelementptr i8, ptr %p1, i64 128
%t7960 = load i512, ptr %t7959, align 8
%t7961 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7958, i512 %t7960)
%t7962 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t7943, i512 %t7932)
%t7963 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t7961, i512 %t7953)
%t7964 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t7961, i512 %t7953)
%t7965 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t7943, i512 %t7932)
%t7966 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7962, i512 %t7963)
%t7967 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7964, i512 %t7965)
%t7968 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7963, i512 %t7964)
%t7969 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7962, i512 %t7965)
%t7970 = call ptr @resid_rec_reuse_sc(ptr %p0, i64 256)
%t7970.f0 = getelementptr i8, ptr %t7970, i64 0
store i512 %t7966, ptr %t7970.f0, align 8
%t7970.f8 = getelementptr i8, ptr %t7970, i64 64
store i512 %t7967, ptr %t7970.f8, align 8
%t7970.f16 = getelementptr i8, ptr %t7970, i64 128
store i512 %t7968, ptr %t7970.f16, align 8
%t7970.f24 = getelementptr i8, ptr %t7970, i64 192
store i512 %t7969, ptr %t7970.f24, align 8
ret ptr %t7970
}
define ptr @eg_ladder__g_Int_512__Int_64_(i512 %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t7978, %tco.s0.k ]
%t7971 = icmp slt i64 %p3, 0
br i1 %t7971, label %L877, label %L879
L877:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p2
lr.x11.m:
%lr.ret11 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %p2, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L879:
%t7972 = call ptr @eg_dbl__g_Int_512__Int_64_(ptr %p2)
call void @resid_rec_share(ptr %t7972)
%t7973 = sub nsw i64 511, %p3
%t7974 = call i512 @__m____________lib_word_resid__pi_shl(i512 %p0, i64 %t7973)
%t7975 = call i512 @__m____________lib_word_resid__pi_sign(i512 %t7974)
%t7976 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t7972, ptr %p1)
call void @resid_rec_share(ptr %t7976)
%t7977 = call ptr @__m____________lib_ed25519g_resid__eg_sel__g_Int_512__Int_64_(i512 %t7975, ptr %t7976, ptr %t7972)
call void @resid_rec_share(ptr %t7977)
%t7978 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p1.e.tco.s0 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %p1, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %t7977, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t7977, %tco.s0 ]
br label %tco.head
}
define ptr @eg_base_mul__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7980 = call ptr @eg_base__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t7980)
%t7981 = call ptr @eg_id__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t7981)
%t7982 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %p0, ptr %t7980, ptr %t7981, i64 255)
ret ptr %t7982
}
define ptr @eg_encode__g_Int_512__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7983 = getelementptr i8, ptr %p0, i64 128
%t7984 = load i512, ptr %t7983, align 8
%t7985 = call i512 @eg_finv__g_Int_512__Int_64_(i512 %t7984)
%t7986 = getelementptr i8, ptr %p0, i64 0
%t7987 = load i512, ptr %t7986, align 8
%t7988 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7987, i512 %t7985)
%t7989 = getelementptr i8, ptr %p0, i64 64
%t7990 = load i512, ptr %t7989, align 8
%t7991 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7990, i512 %t7985)
%t7992 = call i512 @__m____________lib_word_resid__pi_and(i512 %t7988, i512 1)
%t7993 = call i512 @__m____________lib_word_resid__pi_shl(i512 %t7992, i64 255)
%t7994 = call i512 @__m____________lib_word_resid__pi_or(i512 %t7991, i512 %t7993)
%t7995 = call ptr @resid_listbuf_new()
%t7996 = call ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %t7994, i64 32, i64 0, ptr %t7995)
ret ptr %t7996
}
define i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7997 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 32, i64 32, i64 0, i512 0)
%t7998 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 32, i64 0, i512 0)
%t7999 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 0, i512 %t7997, i64 255)
%t8000 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 %t7999, i512 %t7998, i64 255)
ret i512 %t8000
}
define ptr @eg_pt__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8001 = call ptr @resid_rec_new(i64 256, i8 1)
%t8001.f0 = getelementptr i8, ptr %t8001, i64 0
store i512 %p0, ptr %t8001.f0, align 8
%t8001.f8 = getelementptr i8, ptr %t8001, i64 64
store i512 %p1, ptr %t8001.f8, align 8
%t8001.f16 = getelementptr i8, ptr %t8001, i64 128
store i512 1, ptr %t8001.f16, align 8
%t8002 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p1)
%t8001.f24 = getelementptr i8, ptr %t8001, i64 192
store i512 %t8002, ptr %t8001.f24, align 8
ret ptr %t8001
}
define ptr @eg_id__g_Int_512__Int_64_() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8003 = call ptr @resid_rec_new(i64 256, i8 1)
%t8003.f0 = getelementptr i8, ptr %t8003, i64 0
store i512 0, ptr %t8003.f0, align 8
%t8003.f8 = getelementptr i8, ptr %t8003, i64 64
store i512 1, ptr %t8003.f8, align 8
%t8003.f16 = getelementptr i8, ptr %t8003, i64 128
store i512 1, ptr %t8003.f16, align 8
%t8003.f24 = getelementptr i8, ptr %t8003, i64 192
store i512 0, ptr %t8003.f24, align 8
ret ptr %t8003
}
define i512 @eg_clamp__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8004 = sext i256 28948022309329048855892746252171976963317496166410141009864396001978282409976 to i512
%t8005 = call i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %t8004)
%t8006 = sext i256 28948022309329048855892746252171976963317496166410141009864396001978282409984 to i512
%t8007 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8005, i512 %t8006)
ret i512 %t8007
}
define ptr @ed25519g_pub__g_Int_64__Int_512__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8008 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %p0)
%t8009 = call i512 @__m____________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %t8008)
%t8010 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t8009)
%t8011 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t8010)
%t8012 = musttail call ptr @__m____________lib_word_resid__wi_publish(ptr %t8011)
ret ptr %t8012
}
define ptr @ed25519g_sign__g_Int_64__Int_512__UInt_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8013 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %p0)
%t8014 = call i512 @__m____________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %t8013)
%t8015 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t8014)
call void @resid_rec_share(ptr %t8015)
%t8016 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t8015)
%t8017 = call ptr @resid_list_freeze(ptr %t8016)
%t8018 = call ptr @__m____________lib_word_resid__wi_publish(ptr %t8017)
%t8019 = call ptr @resid_list_freeze(ptr %t8018)
%t8020 = call ptr @d_lift_bytes__g_Int_64__UInt_64_(ptr %p1)
%t8021 = call ptr @resid_list_freeze(ptr %t8020)
%t8022 = call i64 @resid_scope_push()
%t8023 = call ptr @resid_list_slice(ptr %t8013, i64 32, i64 64)
%t8025 = call ptr @resid_list_concat(ptr %t8023, ptr %t8021)
%t8026 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %t8025)
%t8027 = call ptr @resid_list_freeze(ptr %t8026)
%t8028 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t8027)
call void @resid_scope_pop(i64 %t8022)
%t8029 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t8028)
call void @resid_rec_share(ptr %t8029)
%t8030 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t8029)
%t8031 = call ptr @resid_list_freeze(ptr %t8030)
%t8032 = call ptr @__m____________lib_word_resid__wi_publish(ptr %t8031)
%t8033 = call ptr @resid_list_freeze(ptr %t8032)
%t8034 = call ptr @resid_listbuf_new()
%t8035 = call i64 @resid_scope_push()
%t8036 = call ptr @resid_list_concat(ptr %t8033, ptr %t8019)
%t8037 = call ptr @resid_list_concat(ptr %t8036, ptr %p1)
%t8038 = call ptr @sha512_bytes(ptr %t8037)
%t8039 = call ptr @resid_list_freeze(ptr %t8038)
%t8040 = call ptr @__m____________lib_ed25519g_resid__eg_lift_bytes__g_Int_64__Int_512_(ptr %t8039, i64 0, ptr %t8034)
%t8041 = call ptr @resid_list_freeze(ptr %t8040)
%t8042 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t8041)
call void @resid_scope_pop(i64 %t8035)
%t8043 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t8042, i512 %t8014)
%t8044 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8043, i512 %t8028)
%t8045 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 0, i512 %t8044, i64 508)
%t8046 = call ptr @resid_listbuf_new()
%t8047 = call ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %t8045, i64 32, i64 0, ptr %t8046)
%t8048 = call ptr @resid_list_freeze(ptr %t8047)
%t8049 = call ptr @__m____________lib_word_resid__wi_publish(ptr %t8048)
%t8050 = call ptr @resid_list_freeze(ptr %t8049)
%t8051 = musttail call ptr @resid_list_concat(ptr %t8033, ptr %t8050)
ret ptr %t8051
}
define ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8052 = call ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
%t8053 = call ptr @__m____________lib_chachag_resid__cg_block_st__g_Int_64__Int_64_(ptr %t8052)
ret ptr %t8053
}
define ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8054 = call ptr @resid_listbuf_new()
%t8055 = call ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
%t8056 = call ptr @resid_list_freeze(ptr %t8055)
%t8057 = and i64 %p1, 4294967295
%t8058 = call ptr @__m____________lib_chachag_resid__cg_xor_run__g_Int_64__Int_64_(ptr %t8056, i64 %t8057, ptr %p3, i64 0, ptr %t8054)
%t8059 = call ptr @resid_listbuf_finish(ptr %t8058, ptr @.lty8059)
ret ptr %t8059
}
define ptr @poly1305g__g_Int_64__Int_512_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8060 = call i512 @__m____________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 16, i64 0, i512 0)
%t8061 = sext i128 21267647620597763993911028882763415551 to i512
%t8062 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8060, i512 %t8061)
%t8063 = call i512 @__m____________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p0, i64 16, i64 16, i64 0, i512 0)
%t8064 = call i512 @__m____________lib_chachag_resid__pg_blocks__g_Int_512__Int_64_(i512 0, ptr %p1, i64 0, i512 %t8062)
%t8065 = call ptr @resid_listbuf_new()
%t8066 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8064, i512 %t8063)
%t8067 = sext i256 340282366920938463463374607431768211455 to i512
%t8068 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8066, i512 %t8067)
%t8069 = call ptr @__m____________lib_chachag_resid__pg_bytes__g_Int_512__Int_64_(i512 %t8068, i64 0, ptr %t8065)
ret ptr %t8069
}
define ptr @chacha20poly1305g_seal__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8070 = call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 0, ptr %p1)
%t8071 = call ptr @resid_list_freeze(ptr %t8070)
%t8072 = call ptr @resid_list_slice(ptr %t8071, i64 0, i64 32)
%t8074 = call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 1, ptr %p1, ptr %p2)
%t8075 = call ptr @resid_list_freeze(ptr %t8074)
%t8076 = call ptr @__m____________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p3, ptr %t8075)
%t8077 = call ptr @resid_list_freeze(ptr %t8076)
%t8078 = call ptr @poly1305g__g_Int_64__Int_512_(ptr %t8072, ptr %t8077)
%t8079 = call ptr @resid_list_freeze(ptr %t8078)
%t8080 = call ptr @resid_list_concat(ptr %t8075, ptr %t8079)
ret ptr %t8080
}
define ptr @chacha20poly1305g_decrypt__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8081 = call i64 @resid_list_len(ptr %p2)
%t8082 = sub nsw i64 %t8081, 16
%t8083 = call i64 @resid_list_len(ptr %p0)
%t8084 = icmp ne i64 %t8083, 32
br label %LSL8085
LSL8085:
br i1 %t8084, label %LSJ8085, label %LSR8085
LSR8085:
%t8086 = call i64 @resid_list_len(ptr %p1)
%t8087 = icmp ne i64 %t8086, 12
br label %LSJ8085
LSJ8085:
%t8088 = phi i1 [ true, %LSL8085 ], [ %t8087, %LSR8085 ]
br label %LSL8089
LSL8089:
br i1 %t8088, label %LSJ8089, label %LSR8089
LSR8089:
%t8090 = icmp slt i64 %t8082, 0
br label %LSJ8089
LSJ8089:
%t8091 = phi i1 [ true, %LSL8089 ], [ %t8090, %LSR8089 ]
br i1 %t8091, label %L880, label %L882
L880:
ret ptr @.nbox8092
L882:
%t8093 = call ptr @resid_listbuf_new()
%t8094 = call ptr @resid_listbuf_new()
%t8095 = call ptr @resid_list_slice(ptr %p2, i64 0, i64 %t8082)
%t8097 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t8095, i64 0, ptr %t8093)
%t8098 = call ptr @resid_list_freeze(ptr %t8097)
%t8099 = call i64 @resid_list_len(ptr %p2)
%t8100 = call ptr @resid_list_slice(ptr %p2, i64 %t8082, i64 %t8099)
%t8102 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t8100, i64 0, ptr %t8094)
%t8103 = call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 0, ptr %p1)
%t8104 = call ptr @resid_list_freeze(ptr %t8103)
%t8105 = call ptr @resid_list_slice(ptr %t8104, i64 0, i64 32)
%t8107 = call ptr @__m____________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p3, ptr %t8098)
%t8108 = call ptr @resid_list_freeze(ptr %t8107)
%t8109 = call ptr @poly1305g__g_Int_64__Int_512_(ptr %t8105, ptr %t8108)
%t8110 = call ptr @resid_list_freeze(ptr %t8109)
%t8111 = call i1 @__m____________lib_crypto_resid__ct_same_pub(ptr %t8110, ptr %t8102)
%t8112 = xor i1 %t8111, true
br i1 %t8112, label %L883, label %L885
L883:
ret ptr @.nbox8113
L885:
%t8114 = call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 1, ptr %p1, ptr %t8098)
%t8115 = call ptr @resid_list_freeze(ptr %t8114)
%t8118 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty8116)
%t8117 = getelementptr {i32, i32, ptr}, ptr %t8118, i32 1
store ptr %t8115, ptr %t8117
ret ptr %t8118
}
define ptr @__m____________lib_sha256g_resid__g_blk__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in, i64 %p19.in, i64 %p20.in, i64 %p21.in, i64 %p22.in, i64 %p23.in, i64 %p24.in, i64 %p25.in, i64 %p26.in, i64 %p27.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8152 = alloca [8 x ptr]
%p3.ld = call ptr @resid_list_vdata(ptr %p3.in)
%p3.ln = call i64 @resid_list_vlen(ptr %p3.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8191, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t8192, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t8193, %tco.s0.k ]
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
%p27 = phi i64 [ %p27.in, %entry ], [ %t8179, %tco.s0.k ]
%t8119 = icmp sge i64 %p2, 64
br i1 %t8119, label %L886, label %L888
L886:
%t8120 = call ptr @resid_list_get_v(ptr %p3, i64 0, ptr %p3.ld, i64 %p3.ln)
%t8121 = call i64 @resid_unbox_i64(ptr %t8120)
%t8123 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8121, i64 %p4)
%t8124 = call ptr @resid_list_get_v(ptr %p3, i64 1, ptr %p3.ld, i64 %p3.ln)
%t8125 = call i64 @resid_unbox_i64(ptr %t8124)
%t8127 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8125, i64 %p5)
%t8128 = call ptr @resid_list_get_v(ptr %p3, i64 2, ptr %p3.ld, i64 %p3.ln)
%t8129 = call i64 @resid_unbox_i64(ptr %t8128)
%t8131 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8129, i64 %p6)
%t8132 = call ptr @resid_list_get_v(ptr %p3, i64 3, ptr %p3.ld, i64 %p3.ln)
%t8133 = call i64 @resid_unbox_i64(ptr %t8132)
%t8135 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8133, i64 %p7)
%t8136 = call ptr @resid_list_get_v(ptr %p3, i64 4, ptr %p3.ld, i64 %p3.ln)
%t8137 = call i64 @resid_unbox_i64(ptr %t8136)
%t8139 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8137, i64 %p8)
%t8140 = call ptr @resid_list_get_v(ptr %p3, i64 5, ptr %p3.ld, i64 %p3.ln)
%t8141 = call i64 @resid_unbox_i64(ptr %t8140)
%t8143 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8141, i64 %p9)
%t8144 = call ptr @resid_list_get_v(ptr %p3, i64 6, ptr %p3.ld, i64 %p3.ln)
%t8145 = call i64 @resid_unbox_i64(ptr %t8144)
%t8147 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8145, i64 %p10)
%t8148 = call ptr @resid_list_get_v(ptr %p3, i64 7, ptr %p3.ld, i64 %p3.ln)
%t8149 = call i64 @resid_unbox_i64(ptr %t8148)
%t8151 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8149, i64 %p11)
%t8154 = call ptr @resid_box_i64(i64 %t8123)
%t8156 = getelementptr i8, ptr %t8152, i64 0
store ptr %t8154, ptr %t8156
%t8157 = call ptr @resid_box_i64(i64 %t8127)
%t8159 = getelementptr i8, ptr %t8152, i64 8
store ptr %t8157, ptr %t8159
%t8160 = call ptr @resid_box_i64(i64 %t8131)
%t8162 = getelementptr i8, ptr %t8152, i64 16
store ptr %t8160, ptr %t8162
%t8163 = call ptr @resid_box_i64(i64 %t8135)
%t8165 = getelementptr i8, ptr %t8152, i64 24
store ptr %t8163, ptr %t8165
%t8166 = call ptr @resid_box_i64(i64 %t8139)
%t8168 = getelementptr i8, ptr %t8152, i64 32
store ptr %t8166, ptr %t8168
%t8169 = call ptr @resid_box_i64(i64 %t8143)
%t8171 = getelementptr i8, ptr %t8152, i64 40
store ptr %t8169, ptr %t8171
%t8172 = call ptr @resid_box_i64(i64 %t8147)
%t8174 = getelementptr i8, ptr %t8152, i64 48
store ptr %t8172, ptr %t8174
%t8175 = call ptr @resid_box_i64(i64 %t8151)
%t8177 = getelementptr i8, ptr %t8152, i64 56
store ptr %t8175, ptr %t8177
%t8178 = call ptr @resid_list_new(i64 8, ptr %t8152, ptr @.lty8152)
%lr.cx87 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz87 = icmp eq ptr %lr.cx87, null
br i1 %lr.lz87, label %lr.x87.k, label %lr.x87.m
lr.x87.k:
ret ptr %t8178
lr.x87.m:
%lr.ret87 = call ptr @resid_mv_list(ptr %t8178, ptr %lr.cx87)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret87
L888:
%t8179 = call i64 @__m____________lib_sha256g_resid__g_sched__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p12, i64 %p13, i64 %p21, i64 %p26)
%t8180 = call i64 @resid_scope_push()
%t8181 = call i64 @__m____________lib_sha256g_resid__g_bsig1__g_Int_64__Int_64_(i64 %p8)
%t8182 = call i64 @__m____________lib_word_resid__wi_add(i64 %p11, i64 %t8181)
%t8183 = call i64 @__m____________lib_sha256g_resid__g_ch__g_Int_64__Int_64_(i64 %p8, i64 %p9, i64 %p10)
%t8184 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8182, i64 %t8183)
%t8185 = call i64 @__m____________lib_sha256g_resid__sha2k(i64 %p2)
%t8186 = call i64 @__m____________lib_word_resid__wi_addk(i64 %t8184, i64 %t8185)
%t8187 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8186, i64 %t8179)
call void @resid_scope_pop(i64 %t8180)
%t8188 = call i64 @__m____________lib_sha256g_resid__g_bsig0__g_Int_64__Int_64_(i64 %p4)
%t8189 = call i64 @__m____________lib_sha256g_resid__g_maj__g_Int_64__Int_64_(i64 %p4, i64 %p5, i64 %p6)
%t8190 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8188, i64 %t8189)
%t8191 = add nsw i64 %p2, 1
%t8192 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8187, i64 %t8190)
%t8193 = call i64 @__m____________lib_word_resid__wi_add(i64 %p7, i64 %t8187)
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t8232, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8231, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t8229, %tco.s0 ]
%t8195 = call i64 @resid_list_len(ptr %p0)
%t8196 = icmp sge i64 %p1, %t8195
br i1 %t8196, label %L889, label %L891
L889:
%t8197 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty8197)
%t8198 = call ptr @__m____________lib_crypto_resid__b64g_finish__g_Int_64__Int_64_(ptr %t8197, i64 %p2)
ret ptr %t8198
L891:
%t8199 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %p1)
%t8200 = add nsw i64 %p1, 1
%t8201 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t8200)
%t8202 = add nsw i64 %p1, 2
%t8203 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t8202)
%t8204 = add nsw i64 %p1, 3
%t8205 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t8204)
%t8206 = call i64 @__m____________lib_crypto_resid__b64g_join__g_Int_64__Int_64_(i64 %t8199, i64 %t8201, i64 %t8203, i64 %t8205)
%t8207 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t8195, i64 %p1)
%t8208 = extractvalue {i64, i1} %t8207, 0
%t8209 = extractvalue {i64, i1} %t8207, 1
%t8210 = zext i1 %t8209 to i8
call void @resid_overflow_check(i8 %t8210)
%t8211 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8206, i64 16)
%t8212 = call ptr @resid_box_i64(i64 %t8211)
%t8215 = call ptr @resid_listbuf_push(ptr %p3, ptr %t8212)
%t8216 = icmp sgt i64 %t8208, 2
br i1 %t8216, label %L892, label %L893
L892:
%t8217 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8206, i64 8)
%t8218 = call ptr @resid_box_i64(i64 %t8217)
%t8221 = call ptr @resid_listbuf_push(ptr %t8215, ptr %t8218)
br label %L894
L893:
br label %L894
L894:
%t8222 = phi ptr [ %t8221, %L892 ], [ %t8215, %L893 ]
%t8223 = icmp sgt i64 %t8208, 3
br i1 %t8223, label %L895, label %L896
L895:
%t8224 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8206, i64 0)
%t8225 = call ptr @resid_box_i64(i64 %t8224)
%t8228 = call ptr @resid_listbuf_push(ptr %t8222, ptr %t8225)
br label %L897
L896:
br label %L897
L897:
%t8229 = phi ptr [ %t8228, %L895 ], [ %t8222, %L896 ]
%t8230 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8206, i64 16777216)
%t8231 = call i64 @__m____________lib_word_resid__wi_or(i64 %p2, i64 %t8230)
%t8232 = add nsw i64 %p1, 4
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8234 = call i512 @__m____________lib_word_resid__pi_sub(i512 %p0, i512 %p1)
%t8235 = call i512 @__m____________lib_word_resid__pi_sign(i512 %t8234)
%t8236 = call i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %t8235)
%t8237 = sext i64 -1 to i512
%t8238 = call i512 @__m____________lib_word_resid__pi_xor(i512 %t8235, i512 %t8237)
%t8239 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8234, i512 %t8238)
%t8240 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8236, i512 %t8239)
ret i512 %t8240
}
define ptr @__m____________lib_ed25519g_resid__eg_sel__g_Int_512__Int_64_(i512 %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8241 = sext i64 -1 to i512
%t8242 = call i512 @__m____________lib_word_resid__pi_xor(i512 %p0, i512 %t8241)
%t8243 = getelementptr i8, ptr %p1, i64 0
%t8244 = load i512, ptr %t8243, align 8
%t8245 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8244, i512 %p0)
%t8246 = getelementptr i8, ptr %p2, i64 0
%t8247 = load i512, ptr %t8246, align 8
%t8248 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8247, i512 %t8242)
%t8249 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8245, i512 %t8248)
%t8250 = getelementptr i8, ptr %p1, i64 64
%t8251 = load i512, ptr %t8250, align 8
%t8252 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8251, i512 %p0)
%t8253 = getelementptr i8, ptr %p2, i64 64
%t8254 = load i512, ptr %t8253, align 8
%t8255 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8254, i512 %t8242)
%t8256 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8252, i512 %t8255)
%t8257 = getelementptr i8, ptr %p1, i64 128
%t8258 = load i512, ptr %t8257, align 8
%t8259 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8258, i512 %p0)
%t8260 = getelementptr i8, ptr %p2, i64 128
%t8261 = load i512, ptr %t8260, align 8
%t8262 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8261, i512 %t8242)
%t8263 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8259, i512 %t8262)
%t8264 = getelementptr i8, ptr %p1, i64 192
%t8265 = load i512, ptr %t8264, align 8
%t8266 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8265, i512 %p0)
%t8267 = getelementptr i8, ptr %p2, i64 192
%t8268 = load i512, ptr %t8267, align 8
%t8269 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8268, i512 %t8242)
%t8270 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8266, i512 %t8269)
%t8271 = call ptr @resid_rec_reuse_sc(ptr %p1, i64 256)
%t8271.f0 = getelementptr i8, ptr %t8271, i64 0
store i512 %t8249, ptr %t8271.f0, align 8
%t8271.f8 = getelementptr i8, ptr %t8271, i64 64
store i512 %t8256, ptr %t8271.f8, align 8
%t8271.f16 = getelementptr i8, ptr %t8271, i64 128
store i512 %t8263, ptr %t8271.f16, align 8
%t8271.f24 = getelementptr i8, ptr %t8271, i64 192
store i512 %t8270, ptr %t8271.f24, align 8
ret ptr %t8271
}
define ptr @eg_base__g_Int_512__Int_64_() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8272 = sext i256 15112221349535400772501151409588531511454012693041857206046113283949847762202 to i512
%t8273 = sext i256 46316835694926478169428394003475163141307993866256225615783033603165251855960 to i512
%t8274 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t8272, i512 %t8273)
ret ptr %t8274
}
define ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8277, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t8286, %tco.s0 ]
%t8275 = icmp sge i64 %p2, %p1
br i1 %t8275, label %L898, label %L900
L898:
%t8276 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty8276)
ret ptr %t8276
L900:
%t8277 = add nsw i64 %p2, 1
%t8278 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p2)
%t8279 = extractvalue {i64, i1} %t8278, 0
%t8280 = extractvalue {i64, i1} %t8278, 1
%t8281 = zext i1 %t8280 to i8
call void @resid_overflow_check(i8 %t8281)
%t8282 = call i64 @__m____________lib_word_resid__pi_byte(i512 %p0, i64 %t8279)
%t8283 = call ptr @resid_box_i64(i64 %t8282)
%t8286 = call ptr @resid_listbuf_push(ptr %p3, ptr %t8283)
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t8289, %tco.s0 ]
%p4 = phi i512 [ %p4.in, %entry ], [ %t8303, %tco.s0 ]
%t8288 = icmp sge i64 %p3, %p2
br i1 %t8288, label %L901, label %L903
L901:
ret i512 %p4
L903:
%t8289 = add nsw i64 %p3, 1
%t8290 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p3)
%t8291 = extractvalue {i64, i1} %t8290, 0
%t8292 = extractvalue {i64, i1} %t8290, 1
%t8293 = zext i1 %t8292 to i8
call void @resid_overflow_check(i8 %t8293)
%t8294 = call ptr @resid_list_get_v(ptr %p0, i64 %t8291, ptr %p0.ld, i64 %p0.ln)
%t8295 = call i64 @resid_unbox_i64(ptr %t8294)
%t8297 = call i512 @__m____________lib_word_resid__pi_from_byte(i64 %t8295)
%t8298 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p3)
%t8299 = extractvalue {i64, i1} %t8298, 0
%t8300 = extractvalue {i64, i1} %t8298, 1
%t8301 = zext i1 %t8300 to i8
call void @resid_overflow_check(i8 %t8301)
%t8302 = call i512 @__m____________lib_word_resid__pi_shl(i512 %t8297, i64 %t8299)
%t8303 = call i512 @__m____________lib_word_resid__pi_or(i512 %p4, i512 %t8302)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @eg_fold_l__g_Int_512__Int_64_(i512 %p0.in, i512 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t8311, %tco.s0 ]
%p1 = phi i512 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8312, %tco.s0 ]
%t8305 = icmp slt i64 %p2, 0
br i1 %t8305, label %L904, label %L906
L904:
ret i512 %p0
L906:
%t8306 = call i512 @__m____________lib_word_resid__pi_shr(i512 %p1, i64 %p2)
%t8307 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8306, i512 1)
%t8308 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %p0)
%t8309 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8308, i512 %t8307)
%t8310 = sext i256 7237005577332262213973186563042994240857116359379907606001950938285454250989 to i512
%t8311 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8309, i512 %t8310)
%t8312 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @sha512g__g_Int_64__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8314 = add i64 7640891576956012808, 0
%t8315 = add i64 %t8314, 0
%t8316 = add i64 %t8315, 0
%t8317 = icmp ne i64 %t8316, %t8314
%t8318 = icmp slt i64 7640891576956012808, 0
%t8319 = or i1 %t8317, %t8318
%t8320 = zext i1 %t8319 to i8
call void @resid_conv_check(i8 %t8320)
%t8321 = add i128 13503953896175478587, 0
%t8322 = trunc i128 %t8321 to i64
%t8323 = zext i64 %t8322 to i128
%t8324 = icmp ne i128 %t8323, %t8321
%t8325 = icmp slt i128 13503953896175478587, 0
%t8326 = or i1 %t8324, %t8325
%t8327 = zext i1 %t8326 to i8
call void @resid_conv_check(i8 %t8327)
%t8328 = add i64 4354685564936845355, 0
%t8329 = add i64 %t8328, 0
%t8330 = add i64 %t8329, 0
%t8331 = icmp ne i64 %t8330, %t8328
%t8332 = icmp slt i64 4354685564936845355, 0
%t8333 = or i1 %t8331, %t8332
%t8334 = zext i1 %t8333 to i8
call void @resid_conv_check(i8 %t8334)
%t8335 = add i128 11912009170470909681, 0
%t8336 = trunc i128 %t8335 to i64
%t8337 = zext i64 %t8336 to i128
%t8338 = icmp ne i128 %t8337, %t8335
%t8339 = icmp slt i128 11912009170470909681, 0
%t8340 = or i1 %t8338, %t8339
%t8341 = zext i1 %t8340 to i8
call void @resid_conv_check(i8 %t8341)
%t8342 = add i64 5840696475078001361, 0
%t8343 = add i64 %t8342, 0
%t8344 = add i64 %t8343, 0
%t8345 = icmp ne i64 %t8344, %t8342
%t8346 = icmp slt i64 5840696475078001361, 0
%t8347 = or i1 %t8345, %t8346
%t8348 = zext i1 %t8347 to i8
call void @resid_conv_check(i8 %t8348)
%t8349 = add i128 11170449401992604703, 0
%t8350 = trunc i128 %t8349 to i64
%t8351 = zext i64 %t8350 to i128
%t8352 = icmp ne i128 %t8351, %t8349
%t8353 = icmp slt i128 11170449401992604703, 0
%t8354 = or i1 %t8352, %t8353
%t8355 = zext i1 %t8354 to i8
call void @resid_conv_check(i8 %t8355)
%t8356 = add i64 2270897969802886507, 0
%t8357 = add i64 %t8356, 0
%t8358 = add i64 %t8357, 0
%t8359 = icmp ne i64 %t8358, %t8356
%t8360 = icmp slt i64 2270897969802886507, 0
%t8361 = or i1 %t8359, %t8360
%t8362 = zext i1 %t8361 to i8
call void @resid_conv_check(i8 %t8362)
%t8363 = add i64 6620516959819538809, 0
%t8364 = add i64 %t8363, 0
%t8365 = add i64 %t8364, 0
%t8366 = icmp ne i64 %t8365, %t8363
%t8367 = icmp slt i64 6620516959819538809, 0
%t8368 = or i1 %t8366, %t8367
%t8369 = zext i1 %t8368 to i8
call void @resid_conv_check(i8 %t8369)
%t8370 = alloca [8 x ptr]
%t8372 = call ptr @resid_box_i64(i64 %t8315)
%t8374 = getelementptr i8, ptr %t8370, i64 0
store ptr %t8372, ptr %t8374
%t8375 = call ptr @resid_box_i64(i64 %t8322)
%t8377 = getelementptr i8, ptr %t8370, i64 8
store ptr %t8375, ptr %t8377
%t8378 = call ptr @resid_box_i64(i64 %t8329)
%t8380 = getelementptr i8, ptr %t8370, i64 16
store ptr %t8378, ptr %t8380
%t8381 = call ptr @resid_box_i64(i64 %t8336)
%t8383 = getelementptr i8, ptr %t8370, i64 24
store ptr %t8381, ptr %t8383
%t8384 = call ptr @resid_box_i64(i64 %t8343)
%t8386 = getelementptr i8, ptr %t8370, i64 32
store ptr %t8384, ptr %t8386
%t8387 = call ptr @resid_box_i64(i64 %t8350)
%t8389 = getelementptr i8, ptr %t8370, i64 40
store ptr %t8387, ptr %t8389
%t8390 = call ptr @resid_box_i64(i64 %t8357)
%t8392 = getelementptr i8, ptr %t8370, i64 48
store ptr %t8390, ptr %t8392
%t8393 = call ptr @resid_box_i64(i64 %t8364)
%t8395 = getelementptr i8, ptr %t8370, i64 56
store ptr %t8393, ptr %t8395
%t8396 = call ptr @resid_list_new(i64 8, ptr %t8370, ptr @.lty8370)
%t8397 = call ptr @__m____________lib_sha512g_resid__g5_hash__g_Int_64__UInt_64_(ptr %p0, ptr %t8396, i64 64)
ret ptr %t8397
}
define i512 @__m____________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8398 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 32, i64 0, i512 0)
%t8399 = call i512 @eg_clamp__g_Int_512__Int_64_(i512 %t8398)
ret i512 %t8399
}
define ptr @d_lift_bytes__g_Int_64__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8400 = call ptr @resid_listbuf_new()
%t8401 = call ptr @__m____________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %p0, i64 0, ptr %t8400)
ret ptr %t8401
}
define ptr @__m____________lib_ed25519g_resid__eg_lift_bytes__g_Int_64__Int_512_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8411, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8416, %tco.s0 ]
%t8402 = call i64 @resid_list_len(ptr %p0)
%t8403 = icmp sge i64 %p1, %t8402
br i1 %t8403, label %L907, label %L909
L907:
%t8404 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8404)
ret ptr %t8404
L909:
%t8405 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t8406 = call i64 @resid_unbox_i64(ptr %t8405)
%t8408 = and i64 %t8406, 255
%t8409 = sext i64 %t8408 to i512
%t8410 = call i512 @__m____________lib_word_resid__pi_lift(i512 %t8409)
%t8411 = add nsw i64 %p1, 1
%t8412 = call i64 @__m____________lib_word_resid__pi_byte(i512 %t8410, i64 0)
%t8413 = call ptr @resid_box_i64(i64 %t8412)
%t8416 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8413)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8418 = call i64 @__m____________lib_chachag_resid__cg_le32(ptr %p2, i64 0)
%t8419 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t8418)
%t8420 = call i64 @__m____________lib_chachag_resid__cg_le32(ptr %p2, i64 4)
%t8421 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t8420)
%t8422 = call i64 @__m____________lib_chachag_resid__cg_le32(ptr %p2, i64 8)
%t8423 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t8422)
%t8424 = call ptr @__m____________lib_chachag_resid__cg_state_w__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %t8419, i64 %t8421, i64 %t8423)
ret ptr %t8424
}
define ptr @__m____________lib_chachag_resid__cg_block_st__g_Int_64__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8425 = call ptr @resid_listbuf_new()
%t8426 = call ptr @resid_list_get(ptr %p0, i64 12)
%t8427 = call i64 @resid_unbox_i64(ptr %t8426)
%t8429 = call ptr @__m____________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %t8427)
%t8430 = call ptr @__m____________lib_chachag_resid__cg_ser__g_Int_64__Int_64_(ptr %t8429, i64 0, ptr %t8425)
ret ptr %t8430
}
define ptr @__m____________lib_chachag_resid__cg_xor_run__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8443, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t8445, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t8448, %tco.s0 ]
%t8431 = call i64 @resid_list_len(ptr %p2)
%t8432 = icmp sge i64 %p3, %t8431
br i1 %t8432, label %L910, label %L912
L910:
ret ptr %p4
L912:
%t8433 = call i64 @__m____________lib_word_resid__wi_lift(i64 %p1)
%t8434 = call ptr @__m____________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %t8433)
%t8435 = call i64 @resid_list_len(ptr %p2)
%t8436 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t8435, i64 %p3)
%t8437 = extractvalue {i64, i1} %t8436, 0
%t8438 = extractvalue {i64, i1} %t8436, 1
%t8439 = zext i1 %t8438 to i8
call void @resid_overflow_check(i8 %t8439)
%t8440 = icmp slt i64 %t8437, 64
br i1 %t8440, label %L913, label %L914
L913:
br label %L915
L914:
br label %L915
L915:
%t8441 = phi i64 [ %t8437, %L913 ], [ 64, %L914 ]
%t8442 = call i64 @wrapping_add(i64 %p1, i64 1)
%t8443 = and i64 %t8442, 4294967295
%t8444 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %t8441)
%t8445 = extractvalue {i64, i1} %t8444, 0
%t8446 = extractvalue {i64, i1} %t8444, 1
%t8447 = zext i1 %t8446 to i8
call void @resid_overflow_check(i8 %t8447)
%t8448 = call ptr @__m____________lib_chachag_resid__cg_xor_bytes__g_Int_64__Int_64_(ptr %t8434, ptr %p2, i64 %p3, i64 0, i64 %t8441, ptr %p4)
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t8451, %tco.s0 ]
%p4 = phi i512 [ %p4.in, %entry ], [ %t8465, %tco.s0 ]
%t8450 = icmp sge i64 %p3, %p2
br i1 %t8450, label %L916, label %L918
L916:
ret i512 %p4
L918:
%t8451 = add nsw i64 %p3, 1
%t8452 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p3)
%t8453 = extractvalue {i64, i1} %t8452, 0
%t8454 = extractvalue {i64, i1} %t8452, 1
%t8455 = zext i1 %t8454 to i8
call void @resid_overflow_check(i8 %t8455)
%t8456 = call ptr @resid_list_get_v(ptr %p0, i64 %t8453, ptr %p0.ld, i64 %p0.ln)
%t8457 = call i64 @resid_unbox_i64(ptr %t8456)
%t8459 = call i512 @__m____________lib_word_resid__pi_from_byte(i64 %t8457)
%t8460 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p3)
%t8461 = extractvalue {i64, i1} %t8460, 0
%t8462 = extractvalue {i64, i1} %t8460, 1
%t8463 = zext i1 %t8462 to i8
call void @resid_overflow_check(i8 %t8463)
%t8464 = call i512 @__m____________lib_word_resid__pi_shl(i512 %t8459, i64 %t8461)
%t8465 = call i512 @__m____________lib_word_resid__pi_or(i512 %p4, i512 %t8464)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m____________lib_chachag_resid__pg_blocks__g_Int_512__Int_64_(i512 %p0.in, ptr %p1.in, i64 %p2.in, i512 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t8489, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8491, %tco.s0 ]
%p3 = phi i512 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t8467 = call i64 @resid_list_len(ptr %p1)
%t8468 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t8467, i64 %p2)
%t8469 = extractvalue {i64, i1} %t8468, 0
%t8470 = extractvalue {i64, i1} %t8468, 1
%t8471 = zext i1 %t8470 to i8
call void @resid_overflow_check(i8 %t8471)
%t8472 = icmp sle i64 %t8469, 0
br i1 %t8472, label %L919, label %L921
L919:
ret i512 %p0
L921:
%t8473 = icmp slt i64 %t8469, 16
br i1 %t8473, label %L922, label %L923
L922:
br label %L924
L923:
br label %L924
L924:
%t8474 = phi i64 [ %t8469, %L922 ], [ 16, %L923 ]
%t8475 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t8474, i64 8)
%t8476 = extractvalue {i64, i1} %t8475, 0
%t8477 = extractvalue {i64, i1} %t8475, 1
%t8478 = zext i1 %t8477 to i8
call void @resid_overflow_check(i8 %t8478)
%t8479 = sext i64 %t8476 to i512
%t8480 = icmp uge i512 %t8479, 512
%t8481 = add i512 %t8479, 0
%t8482 = shl i512 1, %t8481
%t8483 = select i1 %t8480, i512 0, i512 %t8482
%t8484 = call i512 @__m____________lib_word_resid__pi_lift(i512 %t8483)
%t8485 = call i512 @__m____________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p1, i64 %p2, i64 %t8474, i64 0, i512 0)
%t8486 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8485, i512 %t8484)
%t8487 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %t8486)
%t8488 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t8487, i512 %p3)
%t8489 = call i512 @__m____________lib_chachag_resid__pg_reduce__g_Int_512__Int_64_(i512 %t8488)
%t8490 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %t8474)
%t8491 = extractvalue {i64, i1} %t8490, 0
%t8492 = extractvalue {i64, i1} %t8490, 1
%t8493 = zext i1 %t8492 to i8
call void @resid_overflow_check(i8 %t8493)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__pg_bytes__g_Int_512__Int_64_(i512 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8497, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8506, %tco.s0 ]
%t8495 = icmp sge i64 %p1, 16
br i1 %t8495, label %L925, label %L927
L925:
%t8496 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8496)
ret ptr %t8496
L927:
%t8497 = add nsw i64 %p1, 1
%t8498 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p1)
%t8499 = extractvalue {i64, i1} %t8498, 0
%t8500 = extractvalue {i64, i1} %t8498, 1
%t8501 = zext i1 %t8500 to i8
call void @resid_overflow_check(i8 %t8501)
%t8502 = call i64 @__m____________lib_word_resid__pi_byte(i512 %p0, i64 %t8499)
%t8503 = call ptr @resid_box_i64(i64 %t8502)
%t8506 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8503)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8508 = call i64 @resid_list_len(ptr %p0)
%t8509 = call i64 @__m____________lib_chachag_resid__cg_pad16(i64 %t8508)
%t8510 = call ptr @resid_listbuf_new()
%t8511 = call ptr @__m____________lib_chachag_resid__cg_zeros(i64 %t8509, i64 0, ptr %t8510)
%t8512 = call ptr @resid_list_freeze(ptr %t8511)
%t8513 = call ptr @resid_list_concat(ptr %p0, ptr %t8512)
%t8514 = call i64 @resid_list_len(ptr %p1)
%t8515 = call i64 @__m____________lib_chachag_resid__cg_pad16(i64 %t8514)
%t8516 = call ptr @resid_listbuf_new()
%t8517 = call ptr @__m____________lib_chachag_resid__cg_zeros(i64 %t8515, i64 0, ptr %t8516)
%t8518 = call i64 @resid_list_len(ptr %p0)
%t8519 = call ptr @resid_listbuf_new()
%t8520 = call ptr @__m____________lib_chachag_resid__cg_le64(i64 %t8518, i64 0, ptr %t8519)
%t8521 = call ptr @resid_list_freeze(ptr %t8520)
%t8522 = call ptr @resid_list_concat_own(ptr %t8517, i8 1, ptr %t8521)
%t8523 = call i64 @resid_list_len(ptr %p1)
%t8524 = call ptr @resid_listbuf_new()
%t8525 = call ptr @__m____________lib_chachag_resid__cg_le64(i64 %t8523, i64 0, ptr %t8524)
%t8526 = call ptr @resid_list_freeze(ptr %t8525)
%t8527 = call ptr @resid_list_concat_own(ptr %t8522, i8 1, ptr %t8526)
%t8528 = call ptr @resid_listbuf_new()
%t8529 = call ptr @resid_listbuf_new()
%t8530 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t8513, i64 0, ptr %t8528)
%t8531 = call ptr @resid_list_concat_own(ptr %t8530, i8 1, ptr %p1)
%t8532 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t8527, i64 0, ptr %t8529)
%t8533 = call ptr @resid_list_freeze(ptr %t8532)
%t8534 = call ptr @resid_list_concat_own(ptr %t8531, i8 1, ptr %t8533)
ret ptr %t8534
}
define ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8542, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8546, %tco.s0 ]
%t8535 = call i64 @resid_list_len(ptr %p0)
%t8536 = icmp sge i64 %p1, %t8535
br i1 %t8536, label %L928, label %L930
L928:
%t8537 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8537)
ret ptr %t8537
L930:
%t8538 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t8539 = call i64 @resid_unbox_i64(ptr %t8538)
%t8541 = call i64 @__m____________lib_word_resid__bi_lift(i64 %t8539)
%t8542 = add nsw i64 %p1, 1
%t8543 = call ptr @resid_box_i64(i64 %t8541)
%t8546 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8543)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_sha256g_resid__g_sched__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8548 = icmp slt i64 %p2, 16
br i1 %t8548, label %L931, label %L933
L931:
%t8549 = call i64 @__m____________lib_sha256g_resid__g_word_at__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2)
ret i64 %t8549
L933:
%t8550 = call i64 @__m____________lib_sha256g_resid__g_ssig1__g_Int_64__Int_64_(i64 %p6)
%t8551 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8550, i64 %p5)
%t8552 = call i64 @__m____________lib_sha256g_resid__g_ssig0__g_Int_64__Int_64_(i64 %p4)
%t8553 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8552, i64 %p3)
%t8554 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8551, i64 %t8553)
ret i64 %t8554
}
define i64 @__m____________lib_sha256g_resid__g_bsig1__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8555 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 6)
%t8556 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 11)
%t8557 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8555, i64 %t8556)
%t8558 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 25)
%t8559 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8557, i64 %t8558)
ret i64 %t8559
}
define i64 @__m____________lib_sha256g_resid__g_ch__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8560 = call i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p1)
%t8561 = call i64 @__m____________lib_word_resid__wi_not(i64 %p0)
%t8562 = call i64 @__m____________lib_word_resid__wi_and(i64 %t8561, i64 %p2)
%t8563 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8560, i64 %t8562)
ret i64 %t8563
}
define i64 @__m____________lib_sha256g_resid__g_bsig0__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8564 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 2)
%t8565 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 13)
%t8566 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8564, i64 %t8565)
%t8567 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 22)
%t8568 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8566, i64 %t8567)
ret i64 %t8568
}
define i64 @__m____________lib_sha256g_resid__g_maj__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8569 = call i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p1)
%t8570 = call i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p2)
%t8571 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8569, i64 %t8570)
%t8572 = call i64 @__m____________lib_word_resid__wi_and(i64 %p1, i64 %p2)
%t8573 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8571, i64 %t8572)
ret i64 %t8573
}
define ptr @__m____________lib_crypto_resid__b64g_finish__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8574 = call i64 @__m____________lib_word_resid__wi_byte(i64 %p1, i64 24)
%t8575 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB8575)
%t8576 = alloca [1 x ptr]
%t8578 = call ptr @resid_box_i64(i64 %t8574)
%t8580 = getelementptr i8, ptr %t8576, i64 0
store ptr %t8578, ptr %t8580
%t8581 = call ptr @resid_list_new(i64 1, ptr %t8576, ptr @.lty8576)
%t8583 = call ptr @resid_list_const_i64(ptr @.lc8582, i64 1, ptr @.lcd8582, ptr @.lty8582)
%t8584 = call i1 @__m____________lib_crypto_resid__ct_same_pub(ptr %t8581, ptr %t8583)
%t8585 = xor i1 %t8584, true
br i1 %t8585, label %L934, label %L936
L934:
ret ptr %t8575
L936:
ret ptr %p0
}
define i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8586 = call i64 @resid_list_len(ptr %p0)
%t8587 = icmp sge i64 %p1, %t8586
br i1 %t8587, label %L937, label %L939
L937:
ret i64 0
L939:
%t8588 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t8589 = call i64 @resid_unbox_i64(ptr %t8588)
%t8591 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t8589)
%t8592 = call i64 @b64g_sextet__g_Int_64__Int_64_(i64 %t8591)
ret i64 %t8592
}
define i64 @__m____________lib_crypto_resid__b64g_join__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8593 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p0, i64 63)
%t8594 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8593, i64 18)
%t8595 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p1, i64 63)
%t8596 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8595, i64 12)
%t8597 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8594, i64 %t8596)
%t8598 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p2, i64 63)
%t8599 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8598, i64 6)
%t8600 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p3, i64 63)
%t8601 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8599, i64 %t8600)
%t8602 = call i64 @__m____________lib_word_resid__wi_or(i64 %p0, i64 %p1)
%t8603 = call i64 @__m____________lib_word_resid__wi_or(i64 %p2, i64 %p3)
%t8604 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8602, i64 %t8603)
%t8605 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8604, i64 256)
%t8606 = call i64 @__m____________lib_word_resid__wi_shr(i64 %t8605, i64 8)
%t8607 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8606, i64 24)
%t8608 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8597, i64 %t8601)
%t8609 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8608, i64 %t8607)
ret i64 %t8609
}
define ptr @__m____________lib_sha512g_resid__g5_hash__g_Int_64__UInt_64_(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8610 = call ptr @resid_listbuf_new()
%t8611 = call ptr @resid_listbuf_new()
%t8612 = call i64 @resid_list_len(ptr %p0)
%t8613 = call ptr @sha512g_pad(i64 %t8612)
%t8614 = call ptr @resid_list_freeze(ptr %t8613)
%t8615 = call ptr @__m____________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %t8614, i64 0, ptr %t8610)
%t8616 = call ptr @resid_list_freeze(ptr %t8615)
%t8617 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t8616)
%t8618 = call ptr @__m____________lib_sha512g_resid__g5_lift_state__g_UInt_64__Int_64_(ptr %p1)
%t8619 = call i64 @resid_list_len(ptr %t8617)
%t8620 = call ptr @sha512g_blocks__g_Int_64__UInt_64_(ptr %t8617, i64 0, i64 %t8619, ptr %t8618)
%t8621 = call ptr @__m____________lib_sha512g_resid__g5_out__g_UInt_64__Int_64_(ptr %t8620, i64 %p2, i64 0, ptr %t8611)
ret ptr %t8621
}
define ptr @__m____________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8629, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8634, %tco.s0 ]
%t8622 = call i64 @resid_list_len(ptr %p0)
%t8623 = icmp sge i64 %p1, %t8622
br i1 %t8623, label %L940, label %L942
L940:
%t8624 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8624)
ret ptr %t8624
L942:
%t8625 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t8626 = call i64 @resid_unbox_i64(ptr %t8625)
%t8628 = call i64 @__m____________lib_word_resid__di_lift(i64 %t8626)
%t8629 = add nsw i64 %p1, 1
%t8630 = call i64 @__m____________lib_word_resid__di_byte(i64 %t8628, i64 0)
%t8631 = call ptr @resid_box_i64(i64 %t8630)
%t8634 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8631)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__cg_state_w__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8636 = and i64 %p1, 4294967295
%t8637 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t8636)
%t8638 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 0)
%t8639 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 4)
%t8640 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 8)
%t8641 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 12)
%t8642 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 16)
%t8643 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 20)
%t8644 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 24)
%t8645 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 28)
%t8646 = alloca [16 x ptr]
%t8648 = call ptr @resid_box_i64(i64 1634760805)
%t8650 = getelementptr i8, ptr %t8646, i64 0
store ptr %t8648, ptr %t8650
%t8651 = call ptr @resid_box_i64(i64 857760878)
%t8653 = getelementptr i8, ptr %t8646, i64 8
store ptr %t8651, ptr %t8653
%t8654 = call ptr @resid_box_i64(i64 2036477234)
%t8656 = getelementptr i8, ptr %t8646, i64 16
store ptr %t8654, ptr %t8656
%t8657 = call ptr @resid_box_i64(i64 1797285236)
%t8659 = getelementptr i8, ptr %t8646, i64 24
store ptr %t8657, ptr %t8659
%t8660 = call ptr @resid_box_i64(i64 %t8638)
%t8662 = getelementptr i8, ptr %t8646, i64 32
store ptr %t8660, ptr %t8662
%t8663 = call ptr @resid_box_i64(i64 %t8639)
%t8665 = getelementptr i8, ptr %t8646, i64 40
store ptr %t8663, ptr %t8665
%t8666 = call ptr @resid_box_i64(i64 %t8640)
%t8668 = getelementptr i8, ptr %t8646, i64 48
store ptr %t8666, ptr %t8668
%t8669 = call ptr @resid_box_i64(i64 %t8641)
%t8671 = getelementptr i8, ptr %t8646, i64 56
store ptr %t8669, ptr %t8671
%t8672 = call ptr @resid_box_i64(i64 %t8642)
%t8674 = getelementptr i8, ptr %t8646, i64 64
store ptr %t8672, ptr %t8674
%t8675 = call ptr @resid_box_i64(i64 %t8643)
%t8677 = getelementptr i8, ptr %t8646, i64 72
store ptr %t8675, ptr %t8677
%t8678 = call ptr @resid_box_i64(i64 %t8644)
%t8680 = getelementptr i8, ptr %t8646, i64 80
store ptr %t8678, ptr %t8680
%t8681 = call ptr @resid_box_i64(i64 %t8645)
%t8683 = getelementptr i8, ptr %t8646, i64 88
store ptr %t8681, ptr %t8683
%t8684 = call ptr @resid_box_i64(i64 %t8637)
%t8686 = getelementptr i8, ptr %t8646, i64 96
store ptr %t8684, ptr %t8686
%t8687 = call ptr @resid_box_i64(i64 %p2)
%t8689 = getelementptr i8, ptr %t8646, i64 104
store ptr %t8687, ptr %t8689
%t8690 = call ptr @resid_box_i64(i64 %p3)
%t8692 = getelementptr i8, ptr %t8646, i64 112
store ptr %t8690, ptr %t8692
%t8693 = call ptr @resid_box_i64(i64 %p4)
%t8695 = getelementptr i8, ptr %t8646, i64 120
store ptr %t8693, ptr %t8695
%t8696 = call ptr @resid_list_new(i64 16, ptr %t8646, ptr @.lty8646)
ret ptr %t8696
}
define ptr @__m____________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8697 = call ptr @resid_list_get(ptr %p0, i64 0)
%t8698 = call i64 @resid_unbox_i64(ptr %t8697)
%t8700 = call ptr @resid_list_get(ptr %p0, i64 1)
%t8701 = call i64 @resid_unbox_i64(ptr %t8700)
%t8703 = call ptr @resid_list_get(ptr %p0, i64 2)
%t8704 = call i64 @resid_unbox_i64(ptr %t8703)
%t8706 = call ptr @resid_list_get(ptr %p0, i64 3)
%t8707 = call i64 @resid_unbox_i64(ptr %t8706)
%t8709 = call ptr @resid_list_get(ptr %p0, i64 4)
%t8710 = call i64 @resid_unbox_i64(ptr %t8709)
%t8712 = call ptr @resid_list_get(ptr %p0, i64 5)
%t8713 = call i64 @resid_unbox_i64(ptr %t8712)
%t8715 = call ptr @resid_list_get(ptr %p0, i64 6)
%t8716 = call i64 @resid_unbox_i64(ptr %t8715)
%t8718 = call ptr @resid_list_get(ptr %p0, i64 7)
%t8719 = call i64 @resid_unbox_i64(ptr %t8718)
%t8721 = call ptr @resid_list_get(ptr %p0, i64 8)
%t8722 = call i64 @resid_unbox_i64(ptr %t8721)
%t8724 = call ptr @resid_list_get(ptr %p0, i64 9)
%t8725 = call i64 @resid_unbox_i64(ptr %t8724)
%t8727 = call ptr @resid_list_get(ptr %p0, i64 10)
%t8728 = call i64 @resid_unbox_i64(ptr %t8727)
%t8730 = call ptr @resid_list_get(ptr %p0, i64 11)
%t8731 = call i64 @resid_unbox_i64(ptr %t8730)
%t8733 = call ptr @resid_list_get(ptr %p0, i64 13)
%t8734 = call i64 @resid_unbox_i64(ptr %t8733)
%t8736 = call ptr @resid_list_get(ptr %p0, i64 14)
%t8737 = call i64 @resid_unbox_i64(ptr %t8736)
%t8739 = call ptr @resid_list_get(ptr %p0, i64 15)
%t8740 = call i64 @resid_unbox_i64(ptr %t8739)
%t8742 = call ptr @__m____________lib_chachag_resid__cg_core__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 10, i64 %t8698, i64 %t8701, i64 %t8704, i64 %t8707, i64 %t8710, i64 %t8713, i64 %t8716, i64 %t8719, i64 %t8722, i64 %t8725, i64 %t8728, i64 %t8731, i64 %p1, i64 %t8734, i64 %t8737, i64 %t8740)
ret ptr %t8742
}
define ptr @__m____________lib_chachag_resid__cg_ser__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8745, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8756, %tco.s0 ]
%t8743 = icmp sge i64 %p1, 64
br i1 %t8743, label %L943, label %L945
L943:
%t8744 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8744)
ret ptr %t8744
L945:
%t8745 = add nsw i64 %p1, 1
%t8746 = sdiv i64 %p1, 4
%t8747 = call ptr @resid_list_get_v(ptr %p0, i64 %t8746, ptr %p0.ld, i64 %p0.ln)
%t8748 = call i64 @resid_unbox_i64(ptr %t8747)
%t8750 = srem i64 %p1, 4
%t8751 = mul nsw i64 %t8750, 8
%t8752 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8748, i64 %t8751)
%t8753 = call ptr @resid_box_i64(i64 %t8752)
%t8756 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8753)
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t8759, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi ptr [ %p5.in, %entry ], [ %t8778, %tco.s0 ]
%t8758 = icmp sge i64 %p3, %p4
br i1 %t8758, label %L946, label %L948
L946:
ret ptr %p5
L948:
%t8759 = add nsw i64 %p3, 1
%t8760 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %p3)
%t8761 = extractvalue {i64, i1} %t8760, 0
%t8762 = extractvalue {i64, i1} %t8760, 1
%t8763 = zext i1 %t8762 to i8
call void @resid_overflow_check(i8 %t8763)
%t8764 = call ptr @resid_list_get_v(ptr %p1, i64 %t8761, ptr %p1.ld, i64 %p1.ln)
%t8765 = call i64 @resid_unbox_i64(ptr %t8764)
%t8767 = sdiv i64 %p3, 4
%t8768 = call ptr @resid_list_get_v(ptr %p0, i64 %t8767, ptr %p0.ld, i64 %p0.ln)
%t8769 = call i64 @resid_unbox_i64(ptr %t8768)
%t8771 = srem i64 %p3, 4
%t8772 = mul nsw i64 %t8771, 8
%t8773 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8769, i64 %t8772)
%t8774 = call i64 @__m____________lib_word_resid__bi_xor(i64 %t8765, i64 %t8773)
%t8775 = call ptr @resid_box_i64(i64 %t8774)
%t8778 = call ptr @resid_listbuf_push(ptr %p5, ptr %t8775)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m____________lib_chachag_resid__pg_reduce__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8780 = sext i256 1361129467683753853853498429727072845823 to i512
%t8781 = call i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %t8780)
%t8782 = call i512 @__m____________lib_word_resid__pi_shr(i512 %p0, i64 130)
%t8783 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t8782, i512 5)
%t8784 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8781, i512 %t8783)
%t8785 = sext i256 1361129467683753853853498429727072845823 to i512
%t8786 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8784, i512 %t8785)
%t8787 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t8784, i64 130)
%t8788 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t8787, i512 5)
%t8789 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8786, i512 %t8788)
%t8790 = sext i256 1361129467683753853853498429727072845819 to i512
%t8791 = call i512 @__m____________lib_word_resid__pi_sub(i512 %t8789, i512 %t8790)
%t8792 = call i512 @__m____________lib_word_resid__pi_sign(i512 %t8791)
%t8793 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8789, i512 %t8792)
%t8794 = sext i64 -1 to i512
%t8795 = call i512 @__m____________lib_word_resid__pi_xor(i512 %t8792, i512 %t8794)
%t8796 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8791, i512 %t8795)
%t8797 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8793, i512 %t8796)
ret i512 %t8797
}
define i64 @__m____________lib_sha256g_resid__g_word_at__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8798 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t8799 = extractvalue {i64, i1} %t8798, 0
%t8800 = extractvalue {i64, i1} %t8798, 1
%t8801 = zext i1 %t8800 to i8
call void @resid_overflow_check(i8 %t8801)
%t8802 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t8799)
%t8803 = extractvalue {i64, i1} %t8802, 0
%t8804 = extractvalue {i64, i1} %t8802, 1
%t8805 = zext i1 %t8804 to i8
call void @resid_overflow_check(i8 %t8805)
%t8806 = call ptr @resid_list_get(ptr %p0, i64 %t8803)
%t8807 = call i64 @resid_unbox_i64(ptr %t8806)
%t8809 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t8807)
%t8810 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8809, i64 24)
%t8811 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t8803, i64 1)
%t8812 = extractvalue {i64, i1} %t8811, 0
%t8813 = extractvalue {i64, i1} %t8811, 1
%t8814 = zext i1 %t8813 to i8
call void @resid_overflow_check(i8 %t8814)
%t8815 = call ptr @resid_list_get(ptr %p0, i64 %t8812)
%t8816 = call i64 @resid_unbox_i64(ptr %t8815)
%t8818 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t8816)
%t8819 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8818, i64 16)
%t8820 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8810, i64 %t8819)
%t8821 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t8803, i64 2)
%t8822 = extractvalue {i64, i1} %t8821, 0
%t8823 = extractvalue {i64, i1} %t8821, 1
%t8824 = zext i1 %t8823 to i8
call void @resid_overflow_check(i8 %t8824)
%t8825 = call ptr @resid_list_get(ptr %p0, i64 %t8822)
%t8826 = call i64 @resid_unbox_i64(ptr %t8825)
%t8828 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t8826)
%t8829 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8828, i64 8)
%t8830 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t8803, i64 3)
%t8831 = extractvalue {i64, i1} %t8830, 0
%t8832 = extractvalue {i64, i1} %t8830, 1
%t8833 = zext i1 %t8832 to i8
call void @resid_overflow_check(i8 %t8833)
%t8834 = call ptr @resid_list_get(ptr %p0, i64 %t8831)
%t8835 = call i64 @resid_unbox_i64(ptr %t8834)
%t8837 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t8835)
%t8838 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8829, i64 %t8837)
%t8839 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8820, i64 %t8838)
ret i64 %t8839
}
define i64 @__m____________lib_sha256g_resid__g_ssig1__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8840 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 17)
%t8841 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 19)
%t8842 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8840, i64 %t8841)
%t8843 = call i64 @__m____________lib_word_resid__wi_shr(i64 %p0, i64 10)
%t8844 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8842, i64 %t8843)
ret i64 %t8844
}
define i64 @__m____________lib_sha256g_resid__g_ssig0__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8845 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 7)
%t8846 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 18)
%t8847 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8845, i64 %t8846)
%t8848 = call i64 @__m____________lib_word_resid__wi_shr(i64 %p0, i64 3)
%t8849 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8847, i64 %t8848)
ret i64 %t8849
}
define i64 @b64g_sextet__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8850 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 65, i64 90)
%t8851 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 97, i64 122)
%t8852 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 48, i64 57)
%t8853 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 43, i64 43)
%t8854 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 47, i64 47)
%t8855 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t8850)
%t8856 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 -65)
%t8857 = call i64 @__m____________lib_word_resid__wi_and(i64 %t8855, i64 %t8856)
%t8858 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t8851)
%t8859 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 -71)
%t8860 = call i64 @__m____________lib_word_resid__wi_and(i64 %t8858, i64 %t8859)
%t8861 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8857, i64 %t8860)
%t8862 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t8852)
%t8863 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 4)
%t8864 = call i64 @__m____________lib_word_resid__wi_and(i64 %t8862, i64 %t8863)
%t8865 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t8853)
%t8866 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8865, i64 62)
%t8867 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t8854)
%t8868 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8867, i64 63)
%t8869 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8866, i64 %t8868)
%t8870 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8864, i64 %t8869)
%t8871 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8850, i64 %t8851)
%t8872 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8853, i64 %t8854)
%t8873 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8852, i64 %t8872)
%t8874 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8871, i64 %t8873)
%t8875 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8861, i64 %t8870)
%t8876 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8875, i64 63)
%t8877 = call i64 @__m____________lib_word_resid__wi_xork(i64 %t8874, i64 1)
%t8878 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8877, i64 8)
%t8879 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8876, i64 %t8878)
ret i64 %t8879
}
define ptr @__m____________lib_sha512g_resid__g5_lift_state__g_UInt_64__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8880 = call ptr @resid_gmalloc(i64 64)
%t8881 = call ptr @resid_list_get(ptr %p0, i64 0)
%t8882 = call i64 @resid_unbox_i64(ptr %t8881)
%t8884 = call i64 @__m____________lib_word_resid__di_lift(i64 %t8882)
%t8880.f0 = getelementptr i8, ptr %t8880, i64 0
store i64 %t8884, ptr %t8880.f0, align 8
%t8885 = call ptr @resid_list_get(ptr %p0, i64 1)
%t8886 = call i64 @resid_unbox_i64(ptr %t8885)
%t8888 = call i64 @__m____________lib_word_resid__di_lift(i64 %t8886)
%t8880.f1 = getelementptr i8, ptr %t8880, i64 8
store i64 %t8888, ptr %t8880.f1, align 8
%t8889 = call ptr @resid_list_get(ptr %p0, i64 2)
%t8890 = call i64 @resid_unbox_i64(ptr %t8889)
%t8892 = call i64 @__m____________lib_word_resid__di_lift(i64 %t8890)
%t8880.f2 = getelementptr i8, ptr %t8880, i64 16
store i64 %t8892, ptr %t8880.f2, align 8
%t8893 = call ptr @resid_list_get(ptr %p0, i64 3)
%t8894 = call i64 @resid_unbox_i64(ptr %t8893)
%t8896 = call i64 @__m____________lib_word_resid__di_lift(i64 %t8894)
%t8880.f3 = getelementptr i8, ptr %t8880, i64 24
store i64 %t8896, ptr %t8880.f3, align 8
%t8897 = call ptr @resid_list_get(ptr %p0, i64 4)
%t8898 = call i64 @resid_unbox_i64(ptr %t8897)
%t8900 = call i64 @__m____________lib_word_resid__di_lift(i64 %t8898)
%t8880.f4 = getelementptr i8, ptr %t8880, i64 32
store i64 %t8900, ptr %t8880.f4, align 8
%t8901 = call ptr @resid_list_get(ptr %p0, i64 5)
%t8902 = call i64 @resid_unbox_i64(ptr %t8901)
%t8904 = call i64 @__m____________lib_word_resid__di_lift(i64 %t8902)
%t8880.f5 = getelementptr i8, ptr %t8880, i64 40
store i64 %t8904, ptr %t8880.f5, align 8
%t8905 = call ptr @resid_list_get(ptr %p0, i64 6)
%t8906 = call i64 @resid_unbox_i64(ptr %t8905)
%t8908 = call i64 @__m____________lib_word_resid__di_lift(i64 %t8906)
%t8880.f6 = getelementptr i8, ptr %t8880, i64 48
store i64 %t8908, ptr %t8880.f6, align 8
%t8909 = call ptr @resid_list_get(ptr %p0, i64 7)
%t8910 = call i64 @resid_unbox_i64(ptr %t8909)
%t8912 = call i64 @__m____________lib_word_resid__di_lift(i64 %t8910)
%t8880.f7 = getelementptr i8, ptr %t8880, i64 56
store i64 %t8912, ptr %t8880.f7, align 8
ret ptr %t8880
}
define ptr @sha512g_blocks__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8915, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t8913 = icmp sge i64 %p1, %p2
br i1 %t8913, label %L949, label %L951
L949:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L951:
%t8914 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 128)
%t8915 = extractvalue {i64, i1} %t8914, 0
%t8916 = extractvalue {i64, i1} %t8914, 1
%t8917 = zext i1 %t8916 to i8
call void @resid_overflow_check(i8 %t8917)
%t8918 = call ptr @sha512g_block__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %p3)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %t8918, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t8918, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_sha512g_resid__g5_out__g_UInt_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8922, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t8932, %tco.s0 ]
%t8920 = icmp sge i64 %p2, %p1
br i1 %t8920, label %L952, label %L954
L952:
%t8921 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty8921)
ret ptr %t8921
L954:
%t8922 = add nsw i64 %p2, 1
%t8923 = sdiv i64 %p2, 8
%t8924 = call i64 @__m____________lib_sha512g_resid__g5_state_word__g_UInt_64__Int_64_(ptr %p0, i64 %t8923)
%t8925 = srem i64 %p2, 8
%t8926 = mul nsw i64 %t8925, 8
%t8927 = sub nsw i64 56, %t8926
%t8928 = call i64 @__m____________lib_word_resid__di_byte(i64 %t8924, i64 %t8927)
%t8929 = call ptr @resid_box_i64(i64 %t8928)
%t8932 = call ptr @resid_listbuf_push(ptr %p3, ptr %t8929)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8934 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t8935 = call i64 @resid_unbox_i64(ptr %t8934)
%t8937 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t8935)
%t8938 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t8939 = extractvalue {i64, i1} %t8938, 0
%t8940 = extractvalue {i64, i1} %t8938, 1
%t8941 = zext i1 %t8940 to i8
call void @resid_overflow_check(i8 %t8941)
%t8942 = call ptr @resid_list_get(ptr %p0, i64 %t8939)
%t8943 = call i64 @resid_unbox_i64(ptr %t8942)
%t8945 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t8943)
%t8946 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8945, i64 8)
%t8947 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8937, i64 %t8946)
%t8948 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t8949 = extractvalue {i64, i1} %t8948, 0
%t8950 = extractvalue {i64, i1} %t8948, 1
%t8951 = zext i1 %t8950 to i8
call void @resid_overflow_check(i8 %t8951)
%t8952 = call ptr @resid_list_get(ptr %p0, i64 %t8949)
%t8953 = call i64 @resid_unbox_i64(ptr %t8952)
%t8955 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t8953)
%t8956 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8955, i64 16)
%t8957 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 3)
%t8958 = extractvalue {i64, i1} %t8957, 0
%t8959 = extractvalue {i64, i1} %t8957, 1
%t8960 = zext i1 %t8959 to i8
call void @resid_overflow_check(i8 %t8960)
%t8961 = call ptr @resid_list_get(ptr %p0, i64 %t8958)
%t8962 = call i64 @resid_unbox_i64(ptr %t8961)
%t8964 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t8962)
%t8965 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8964, i64 24)
%t8966 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8956, i64 %t8965)
%t8967 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8947, i64 %t8966)
ret i64 %t8967
}
define ptr @__m____________lib_chachag_resid__cg_core__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9030 = alloca [16 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9178, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9135, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t9147, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t9159, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t9171, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %t9176, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t9140, %tco.s0.k ]
%p9 = phi i64 [ %p9.in, %entry ], [ %t9152, %tco.s0.k ]
%p10 = phi i64 [ %p10.in, %entry ], [ %t9164, %tco.s0.k ]
%p11 = phi i64 [ %p11.in, %entry ], [ %t9162, %tco.s0.k ]
%p12 = phi i64 [ %p12.in, %entry ], [ %t9174, %tco.s0.k ]
%p13 = phi i64 [ %p13.in, %entry ], [ %t9138, %tco.s0.k ]
%p14 = phi i64 [ %p14.in, %entry ], [ %t9150, %tco.s0.k ]
%p15 = phi i64 [ %p15.in, %entry ], [ %t9149, %tco.s0.k ]
%p16 = phi i64 [ %p16.in, %entry ], [ %t9161, %tco.s0.k ]
%p17 = phi i64 [ %p17.in, %entry ], [ %t9173, %tco.s0.k ]
%p18 = phi i64 [ %p18.in, %entry ], [ %t9137, %tco.s0.k ]
%t8968 = icmp eq i64 %p2, 0
br i1 %t8968, label %L955, label %L957
L955:
%t8969 = call ptr @resid_list_get_v(ptr %p0, i64 0, ptr %p0.ld, i64 %p0.ln)
%t8970 = call i64 @resid_unbox_i64(ptr %t8969)
%t8972 = call i64 @__m____________lib_word_resid__wi_add(i64 %p3, i64 %t8970)
%t8973 = call ptr @resid_list_get_v(ptr %p0, i64 1, ptr %p0.ld, i64 %p0.ln)
%t8974 = call i64 @resid_unbox_i64(ptr %t8973)
%t8976 = call i64 @__m____________lib_word_resid__wi_add(i64 %p4, i64 %t8974)
%t8977 = call ptr @resid_list_get_v(ptr %p0, i64 2, ptr %p0.ld, i64 %p0.ln)
%t8978 = call i64 @resid_unbox_i64(ptr %t8977)
%t8980 = call i64 @__m____________lib_word_resid__wi_add(i64 %p5, i64 %t8978)
%t8981 = call ptr @resid_list_get_v(ptr %p0, i64 3, ptr %p0.ld, i64 %p0.ln)
%t8982 = call i64 @resid_unbox_i64(ptr %t8981)
%t8984 = call i64 @__m____________lib_word_resid__wi_add(i64 %p6, i64 %t8982)
%t8985 = call ptr @resid_list_get_v(ptr %p0, i64 4, ptr %p0.ld, i64 %p0.ln)
%t8986 = call i64 @resid_unbox_i64(ptr %t8985)
%t8988 = call i64 @__m____________lib_word_resid__wi_add(i64 %p7, i64 %t8986)
%t8989 = call ptr @resid_list_get_v(ptr %p0, i64 5, ptr %p0.ld, i64 %p0.ln)
%t8990 = call i64 @resid_unbox_i64(ptr %t8989)
%t8992 = call i64 @__m____________lib_word_resid__wi_add(i64 %p8, i64 %t8990)
%t8993 = call ptr @resid_list_get_v(ptr %p0, i64 6, ptr %p0.ld, i64 %p0.ln)
%t8994 = call i64 @resid_unbox_i64(ptr %t8993)
%t8996 = call i64 @__m____________lib_word_resid__wi_add(i64 %p9, i64 %t8994)
%t8997 = call ptr @resid_list_get_v(ptr %p0, i64 7, ptr %p0.ld, i64 %p0.ln)
%t8998 = call i64 @resid_unbox_i64(ptr %t8997)
%t9000 = call i64 @__m____________lib_word_resid__wi_add(i64 %p10, i64 %t8998)
%t9001 = call ptr @resid_list_get_v(ptr %p0, i64 8, ptr %p0.ld, i64 %p0.ln)
%t9002 = call i64 @resid_unbox_i64(ptr %t9001)
%t9004 = call i64 @__m____________lib_word_resid__wi_add(i64 %p11, i64 %t9002)
%t9005 = call ptr @resid_list_get_v(ptr %p0, i64 9, ptr %p0.ld, i64 %p0.ln)
%t9006 = call i64 @resid_unbox_i64(ptr %t9005)
%t9008 = call i64 @__m____________lib_word_resid__wi_add(i64 %p12, i64 %t9006)
%t9009 = call ptr @resid_list_get_v(ptr %p0, i64 10, ptr %p0.ld, i64 %p0.ln)
%t9010 = call i64 @resid_unbox_i64(ptr %t9009)
%t9012 = call i64 @__m____________lib_word_resid__wi_add(i64 %p13, i64 %t9010)
%t9013 = call ptr @resid_list_get_v(ptr %p0, i64 11, ptr %p0.ld, i64 %p0.ln)
%t9014 = call i64 @resid_unbox_i64(ptr %t9013)
%t9016 = call i64 @__m____________lib_word_resid__wi_add(i64 %p14, i64 %t9014)
%t9017 = call i64 @__m____________lib_word_resid__wi_add(i64 %p15, i64 %p1)
%t9018 = call ptr @resid_list_get_v(ptr %p0, i64 13, ptr %p0.ld, i64 %p0.ln)
%t9019 = call i64 @resid_unbox_i64(ptr %t9018)
%t9021 = call i64 @__m____________lib_word_resid__wi_add(i64 %p16, i64 %t9019)
%t9022 = call ptr @resid_list_get_v(ptr %p0, i64 14, ptr %p0.ld, i64 %p0.ln)
%t9023 = call i64 @resid_unbox_i64(ptr %t9022)
%t9025 = call i64 @__m____________lib_word_resid__wi_add(i64 %p17, i64 %t9023)
%t9026 = call ptr @resid_list_get_v(ptr %p0, i64 15, ptr %p0.ld, i64 %p0.ln)
%t9027 = call i64 @resid_unbox_i64(ptr %t9026)
%t9029 = call i64 @__m____________lib_word_resid__wi_add(i64 %p18, i64 %t9027)
%t9032 = call ptr @resid_box_i64(i64 %t8972)
%t9034 = getelementptr i8, ptr %t9030, i64 0
store ptr %t9032, ptr %t9034
%t9035 = call ptr @resid_box_i64(i64 %t8976)
%t9037 = getelementptr i8, ptr %t9030, i64 8
store ptr %t9035, ptr %t9037
%t9038 = call ptr @resid_box_i64(i64 %t8980)
%t9040 = getelementptr i8, ptr %t9030, i64 16
store ptr %t9038, ptr %t9040
%t9041 = call ptr @resid_box_i64(i64 %t8984)
%t9043 = getelementptr i8, ptr %t9030, i64 24
store ptr %t9041, ptr %t9043
%t9044 = call ptr @resid_box_i64(i64 %t8988)
%t9046 = getelementptr i8, ptr %t9030, i64 32
store ptr %t9044, ptr %t9046
%t9047 = call ptr @resid_box_i64(i64 %t8992)
%t9049 = getelementptr i8, ptr %t9030, i64 40
store ptr %t9047, ptr %t9049
%t9050 = call ptr @resid_box_i64(i64 %t8996)
%t9052 = getelementptr i8, ptr %t9030, i64 48
store ptr %t9050, ptr %t9052
%t9053 = call ptr @resid_box_i64(i64 %t9000)
%t9055 = getelementptr i8, ptr %t9030, i64 56
store ptr %t9053, ptr %t9055
%t9056 = call ptr @resid_box_i64(i64 %t9004)
%t9058 = getelementptr i8, ptr %t9030, i64 64
store ptr %t9056, ptr %t9058
%t9059 = call ptr @resid_box_i64(i64 %t9008)
%t9061 = getelementptr i8, ptr %t9030, i64 72
store ptr %t9059, ptr %t9061
%t9062 = call ptr @resid_box_i64(i64 %t9012)
%t9064 = getelementptr i8, ptr %t9030, i64 80
store ptr %t9062, ptr %t9064
%t9065 = call ptr @resid_box_i64(i64 %t9016)
%t9067 = getelementptr i8, ptr %t9030, i64 88
store ptr %t9065, ptr %t9067
%t9068 = call ptr @resid_box_i64(i64 %t9017)
%t9070 = getelementptr i8, ptr %t9030, i64 96
store ptr %t9068, ptr %t9070
%t9071 = call ptr @resid_box_i64(i64 %t9021)
%t9073 = getelementptr i8, ptr %t9030, i64 104
store ptr %t9071, ptr %t9073
%t9074 = call ptr @resid_box_i64(i64 %t9025)
%t9076 = getelementptr i8, ptr %t9030, i64 112
store ptr %t9074, ptr %t9076
%t9077 = call ptr @resid_box_i64(i64 %t9029)
%t9079 = getelementptr i8, ptr %t9030, i64 120
store ptr %t9077, ptr %t9079
%t9080 = call ptr @resid_list_new(i64 16, ptr %t9030, ptr @.lty9030)
%lr.cx124 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz124 = icmp eq ptr %lr.cx124, null
br i1 %lr.lz124, label %lr.x124.k, label %lr.x124.m
lr.x124.k:
ret ptr %t9080
lr.x124.m:
%lr.ret124 = call ptr @resid_mv_list(ptr %t9080, ptr %lr.cx124)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret124
L957:
%t9081 = call i64 @__m____________lib_word_resid__wi_add(i64 %p3, i64 %p7)
%t9082 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p15, i64 %t9081)
%t9083 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9082, i64 16)
%t9084 = call i64 @__m____________lib_word_resid__wi_add(i64 %p11, i64 %t9083)
%t9085 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p7, i64 %t9084)
%t9086 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9085, i64 20)
%t9087 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9081, i64 %t9086)
%t9088 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9083, i64 %t9087)
%t9089 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9088, i64 24)
%t9090 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9084, i64 %t9089)
%t9091 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9086, i64 %t9090)
%t9092 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9091, i64 25)
%t9093 = call i64 @__m____________lib_word_resid__wi_add(i64 %p4, i64 %p8)
%t9094 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p16, i64 %t9093)
%t9095 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9094, i64 16)
%t9096 = call i64 @__m____________lib_word_resid__wi_add(i64 %p12, i64 %t9095)
%t9097 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p8, i64 %t9096)
%t9098 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9097, i64 20)
%t9099 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9093, i64 %t9098)
%t9100 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9095, i64 %t9099)
%t9101 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9100, i64 24)
%t9102 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9096, i64 %t9101)
%t9103 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9098, i64 %t9102)
%t9104 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9103, i64 25)
%t9105 = call i64 @__m____________lib_word_resid__wi_add(i64 %p5, i64 %p9)
%t9106 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p17, i64 %t9105)
%t9107 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9106, i64 16)
%t9108 = call i64 @__m____________lib_word_resid__wi_add(i64 %p13, i64 %t9107)
%t9109 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p9, i64 %t9108)
%t9110 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9109, i64 20)
%t9111 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9105, i64 %t9110)
%t9112 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9107, i64 %t9111)
%t9113 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9112, i64 24)
%t9114 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9108, i64 %t9113)
%t9115 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9110, i64 %t9114)
%t9116 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9115, i64 25)
%t9117 = call i64 @__m____________lib_word_resid__wi_add(i64 %p6, i64 %p10)
%t9118 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p18, i64 %t9117)
%t9119 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9118, i64 16)
%t9120 = call i64 @__m____________lib_word_resid__wi_add(i64 %p14, i64 %t9119)
%t9121 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p10, i64 %t9120)
%t9122 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9121, i64 20)
%t9123 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9117, i64 %t9122)
%t9124 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9119, i64 %t9123)
%t9125 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9124, i64 24)
%t9126 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9120, i64 %t9125)
%t9127 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9122, i64 %t9126)
%t9128 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9127, i64 25)
%t9129 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9087, i64 %t9104)
%t9130 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9125, i64 %t9129)
%t9131 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9130, i64 16)
%t9132 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9114, i64 %t9131)
%t9133 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9104, i64 %t9132)
%t9134 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9133, i64 20)
%t9135 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9129, i64 %t9134)
%t9136 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9131, i64 %t9135)
%t9137 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9136, i64 24)
%t9138 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9132, i64 %t9137)
%t9139 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9134, i64 %t9138)
%t9140 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9139, i64 25)
%t9141 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9099, i64 %t9116)
%t9142 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9089, i64 %t9141)
%t9143 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9142, i64 16)
%t9144 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9126, i64 %t9143)
%t9145 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9116, i64 %t9144)
%t9146 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9145, i64 20)
%t9147 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9141, i64 %t9146)
%t9148 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9143, i64 %t9147)
%t9149 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9148, i64 24)
%t9150 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9144, i64 %t9149)
%t9151 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9146, i64 %t9150)
%t9152 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9151, i64 25)
%t9153 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9111, i64 %t9128)
%t9154 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9101, i64 %t9153)
%t9155 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9154, i64 16)
%t9156 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9090, i64 %t9155)
%t9157 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9128, i64 %t9156)
%t9158 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9157, i64 20)
%t9159 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9153, i64 %t9158)
%t9160 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9155, i64 %t9159)
%t9161 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9160, i64 24)
%t9162 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9156, i64 %t9161)
%t9163 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9158, i64 %t9162)
%t9164 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9163, i64 25)
%t9165 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9123, i64 %t9092)
%t9166 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9113, i64 %t9165)
%t9167 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9166, i64 16)
%t9168 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9102, i64 %t9167)
%t9169 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9092, i64 %t9168)
%t9170 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9169, i64 20)
%t9171 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9165, i64 %t9170)
%t9172 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9167, i64 %t9171)
%t9173 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9172, i64 24)
%t9174 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9168, i64 %t9173)
%t9175 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9170, i64 %t9174)
%t9176 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9175, i64 25)
%t9177 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 1)
%t9178 = extractvalue {i64, i1} %t9177, 0
%t9179 = extractvalue {i64, i1} %t9177, 1
%t9180 = zext i1 %t9179 to i8
call void @resid_overflow_check(i8 %t9180)
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
%t9182 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p1)
%t9183 = extractvalue {i64, i1} %t9182, 0
%t9184 = extractvalue {i64, i1} %t9182, 1
%t9185 = zext i1 %t9184 to i8
call void @resid_overflow_check(i8 %t9185)
%t9186 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 %t9183)
%t9187 = call i64 @__m____________lib_word_resid__wi_not(i64 %p0)
%t9188 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t9189 = extractvalue {i64, i1} %t9188, 0
%t9190 = extractvalue {i64, i1} %t9188, 1
%t9191 = zext i1 %t9190 to i8
call void @resid_overflow_check(i8 %t9191)
%t9192 = call i64 @__m____________lib_word_resid__wi_addk(i64 %t9187, i64 %t9189)
%t9193 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9186, i64 %t9192)
%t9194 = call i64 @__m____________lib_word_resid__wi_shr(i64 %t9193, i64 31)
%t9195 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t9194, i64 1)
%t9196 = call i64 @__m____________lib_word_resid__wi_xork(i64 %t9195, i64 1)
ret i64 %t9196
}
define i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9197 = call i64 @__m____________lib_word_resid__wi_not(i64 %p0)
%t9198 = call i64 @__m____________lib_word_resid__wi_addk(i64 %t9197, i64 1)
ret i64 %t9198
}
define ptr @sha512g_block__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9199 = add i64 4794697086780616226, 0
%t9200 = add i64 %t9199, 0
%t9201 = add i64 %t9200, 0
%t9202 = icmp ne i64 %t9201, %t9199
%t9203 = icmp slt i64 4794697086780616226, 0
%t9204 = or i1 %t9202, %t9203
%t9205 = zext i1 %t9204 to i8
call void @resid_conv_check(i8 %t9205)
%t9206 = add i64 8158064640168781261, 0
%t9207 = add i64 %t9206, 0
%t9208 = add i64 %t9207, 0
%t9209 = icmp ne i64 %t9208, %t9206
%t9210 = icmp slt i64 8158064640168781261, 0
%t9211 = or i1 %t9209, %t9210
%t9212 = zext i1 %t9211 to i8
call void @resid_conv_check(i8 %t9212)
%t9213 = add i128 13096744586834688815, 0
%t9214 = trunc i128 %t9213 to i64
%t9215 = zext i64 %t9214 to i128
%t9216 = icmp ne i128 %t9215, %t9213
%t9217 = icmp slt i128 13096744586834688815, 0
%t9218 = or i1 %t9216, %t9217
%t9219 = zext i1 %t9218 to i8
call void @resid_conv_check(i8 %t9219)
%t9220 = add i128 16840607885511220156, 0
%t9221 = trunc i128 %t9220 to i64
%t9222 = zext i64 %t9221 to i128
%t9223 = icmp ne i128 %t9222, %t9220
%t9224 = icmp slt i128 16840607885511220156, 0
%t9225 = or i1 %t9223, %t9224
%t9226 = zext i1 %t9225 to i8
call void @resid_conv_check(i8 %t9226)
%t9227 = add i64 4131703408338449720, 0
%t9228 = add i64 %t9227, 0
%t9229 = add i64 %t9228, 0
%t9230 = icmp ne i64 %t9229, %t9227
%t9231 = icmp slt i64 4131703408338449720, 0
%t9232 = or i1 %t9230, %t9231
%t9233 = zext i1 %t9232 to i8
call void @resid_conv_check(i8 %t9233)
%t9234 = add i64 6480981068601479193, 0
%t9235 = add i64 %t9234, 0
%t9236 = add i64 %t9235, 0
%t9237 = icmp ne i64 %t9236, %t9234
%t9238 = icmp slt i64 6480981068601479193, 0
%t9239 = or i1 %t9237, %t9238
%t9240 = zext i1 %t9239 to i8
call void @resid_conv_check(i8 %t9240)
%t9241 = add i128 10538285296894168987, 0
%t9242 = trunc i128 %t9241 to i64
%t9243 = zext i64 %t9242 to i128
%t9244 = icmp ne i128 %t9243, %t9241
%t9245 = icmp slt i128 10538285296894168987, 0
%t9246 = or i1 %t9244, %t9245
%t9247 = zext i1 %t9246 to i8
call void @resid_conv_check(i8 %t9247)
%t9248 = add i128 12329834152419229976, 0
%t9249 = trunc i128 %t9248 to i64
%t9250 = zext i64 %t9249 to i128
%t9251 = icmp ne i128 %t9250, %t9248
%t9252 = icmp slt i128 12329834152419229976, 0
%t9253 = or i1 %t9251, %t9252
%t9254 = zext i1 %t9253 to i8
call void @resid_conv_check(i8 %t9254)
%t9255 = add i128 15566598209576043074, 0
%t9256 = trunc i128 %t9255 to i64
%t9257 = zext i64 %t9256 to i128
%t9258 = icmp ne i128 %t9257, %t9255
%t9259 = icmp slt i128 15566598209576043074, 0
%t9260 = or i1 %t9258, %t9259
%t9261 = zext i1 %t9260 to i8
call void @resid_conv_check(i8 %t9261)
%t9262 = add i64 1334009975649890238, 0
%t9263 = add i64 %t9262, 0
%t9264 = add i64 %t9263, 0
%t9265 = icmp ne i64 %t9264, %t9262
%t9266 = icmp slt i64 1334009975649890238, 0
%t9267 = or i1 %t9265, %t9266
%t9268 = zext i1 %t9267 to i8
call void @resid_conv_check(i8 %t9268)
%t9269 = add i64 2608012711638119052, 0
%t9270 = add i64 %t9269, 0
%t9271 = add i64 %t9270, 0
%t9272 = icmp ne i64 %t9271, %t9269
%t9273 = icmp slt i64 2608012711638119052, 0
%t9274 = or i1 %t9272, %t9273
%t9275 = zext i1 %t9274 to i8
call void @resid_conv_check(i8 %t9275)
%t9276 = add i64 6128411473006802146, 0
%t9277 = add i64 %t9276, 0
%t9278 = add i64 %t9277, 0
%t9279 = icmp ne i64 %t9278, %t9276
%t9280 = icmp slt i64 6128411473006802146, 0
%t9281 = or i1 %t9279, %t9280
%t9282 = zext i1 %t9281 to i8
call void @resid_conv_check(i8 %t9282)
%t9283 = add i64 8268148722764581231, 0
%t9284 = add i64 %t9283, 0
%t9285 = add i64 %t9284, 0
%t9286 = icmp ne i64 %t9285, %t9283
%t9287 = icmp slt i64 8268148722764581231, 0
%t9288 = or i1 %t9286, %t9287
%t9289 = zext i1 %t9288 to i8
call void @resid_conv_check(i8 %t9289)
%t9290 = add i128 9286055187155687089, 0
%t9291 = trunc i128 %t9290 to i64
%t9292 = zext i64 %t9291 to i128
%t9293 = icmp ne i128 %t9292, %t9290
%t9294 = icmp slt i128 9286055187155687089, 0
%t9295 = or i1 %t9293, %t9294
%t9296 = zext i1 %t9295 to i8
call void @resid_conv_check(i8 %t9296)
%t9297 = add i128 11230858885718282805, 0
%t9298 = trunc i128 %t9297 to i64
%t9299 = zext i64 %t9298 to i128
%t9300 = icmp ne i128 %t9299, %t9297
%t9301 = icmp slt i128 11230858885718282805, 0
%t9302 = or i1 %t9300, %t9301
%t9303 = zext i1 %t9302 to i8
call void @resid_conv_check(i8 %t9303)
%t9304 = add i128 13951009754708518548, 0
%t9305 = trunc i128 %t9304 to i64
%t9306 = zext i64 %t9305 to i128
%t9307 = icmp ne i128 %t9306, %t9304
%t9308 = icmp slt i128 13951009754708518548, 0
%t9309 = or i1 %t9307, %t9308
%t9310 = zext i1 %t9309 to i8
call void @resid_conv_check(i8 %t9310)
%t9311 = add i128 16472876342353939154, 0
%t9312 = trunc i128 %t9311 to i64
%t9313 = zext i64 %t9312 to i128
%t9314 = icmp ne i128 %t9313, %t9311
%t9315 = icmp slt i128 16472876342353939154, 0
%t9316 = or i1 %t9314, %t9315
%t9317 = zext i1 %t9316 to i8
call void @resid_conv_check(i8 %t9317)
%t9318 = add i128 17275323862435702243, 0
%t9319 = trunc i128 %t9318 to i64
%t9320 = zext i64 %t9319 to i128
%t9321 = icmp ne i128 %t9320, %t9318
%t9322 = icmp slt i128 17275323862435702243, 0
%t9323 = or i1 %t9321, %t9322
%t9324 = zext i1 %t9323 to i8
call void @resid_conv_check(i8 %t9324)
%t9325 = add i64 1135362057144423861, 0
%t9326 = add i64 %t9325, 0
%t9327 = add i64 %t9326, 0
%t9328 = icmp ne i64 %t9327, %t9325
%t9329 = icmp slt i64 1135362057144423861, 0
%t9330 = or i1 %t9328, %t9329
%t9331 = zext i1 %t9330 to i8
call void @resid_conv_check(i8 %t9331)
%t9332 = add i64 2597628984639134821, 0
%t9333 = add i64 %t9332, 0
%t9334 = add i64 %t9333, 0
%t9335 = icmp ne i64 %t9334, %t9332
%t9336 = icmp slt i64 2597628984639134821, 0
%t9337 = or i1 %t9335, %t9336
%t9338 = zext i1 %t9337 to i8
call void @resid_conv_check(i8 %t9338)
%t9339 = add i64 3308224258029322869, 0
%t9340 = add i64 %t9339, 0
%t9341 = add i64 %t9340, 0
%t9342 = icmp ne i64 %t9341, %t9339
%t9343 = icmp slt i64 3308224258029322869, 0
%t9344 = or i1 %t9342, %t9343
%t9345 = zext i1 %t9344 to i8
call void @resid_conv_check(i8 %t9345)
%t9346 = add i64 5365058923640841347, 0
%t9347 = add i64 %t9346, 0
%t9348 = add i64 %t9347, 0
%t9349 = icmp ne i64 %t9348, %t9346
%t9350 = icmp slt i64 5365058923640841347, 0
%t9351 = or i1 %t9349, %t9350
%t9352 = zext i1 %t9351 to i8
call void @resid_conv_check(i8 %t9352)
%t9353 = add i64 6679025012923562964, 0
%t9354 = add i64 %t9353, 0
%t9355 = add i64 %t9354, 0
%t9356 = icmp ne i64 %t9355, %t9353
%t9357 = icmp slt i64 6679025012923562964, 0
%t9358 = or i1 %t9356, %t9357
%t9359 = zext i1 %t9358 to i8
call void @resid_conv_check(i8 %t9359)
%t9360 = add i64 8573033837759648693, 0
%t9361 = add i64 %t9360, 0
%t9362 = add i64 %t9361, 0
%t9363 = icmp ne i64 %t9362, %t9360
%t9364 = icmp slt i64 8573033837759648693, 0
%t9365 = or i1 %t9363, %t9364
%t9366 = zext i1 %t9365 to i8
call void @resid_conv_check(i8 %t9366)
%t9367 = add i128 10970295158949994411, 0
%t9368 = trunc i128 %t9367 to i64
%t9369 = zext i64 %t9368 to i128
%t9370 = icmp ne i128 %t9369, %t9367
%t9371 = icmp slt i128 10970295158949994411, 0
%t9372 = or i1 %t9370, %t9371
%t9373 = zext i1 %t9372 to i8
call void @resid_conv_check(i8 %t9373)
%t9374 = add i128 12119686244451234320, 0
%t9375 = trunc i128 %t9374 to i64
%t9376 = zext i64 %t9375 to i128
%t9377 = icmp ne i128 %t9376, %t9374
%t9378 = icmp slt i128 12119686244451234320, 0
%t9379 = or i1 %t9377, %t9378
%t9380 = zext i1 %t9379 to i8
call void @resid_conv_check(i8 %t9380)
%t9381 = add i128 12683024718118986047, 0
%t9382 = trunc i128 %t9381 to i64
%t9383 = zext i64 %t9382 to i128
%t9384 = icmp ne i128 %t9383, %t9381
%t9385 = icmp slt i128 12683024718118986047, 0
%t9386 = or i1 %t9384, %t9385
%t9387 = zext i1 %t9386 to i8
call void @resid_conv_check(i8 %t9387)
%t9388 = add i128 13788192230050041572, 0
%t9389 = trunc i128 %t9388 to i64
%t9390 = zext i64 %t9389 to i128
%t9391 = icmp ne i128 %t9390, %t9388
%t9392 = icmp slt i128 13788192230050041572, 0
%t9393 = or i1 %t9391, %t9392
%t9394 = zext i1 %t9393 to i8
call void @resid_conv_check(i8 %t9394)
%t9395 = add i128 14330467153632333762, 0
%t9396 = trunc i128 %t9395 to i64
%t9397 = zext i64 %t9396 to i128
%t9398 = icmp ne i128 %t9397, %t9395
%t9399 = icmp slt i128 14330467153632333762, 0
%t9400 = or i1 %t9398, %t9399
%t9401 = zext i1 %t9400 to i8
call void @resid_conv_check(i8 %t9401)
%t9402 = add i128 15395433587784984357, 0
%t9403 = trunc i128 %t9402 to i64
%t9404 = zext i64 %t9403 to i128
%t9405 = icmp ne i128 %t9404, %t9402
%t9406 = icmp slt i128 15395433587784984357, 0
%t9407 = or i1 %t9405, %t9406
%t9408 = zext i1 %t9407 to i8
call void @resid_conv_check(i8 %t9408)
%t9409 = add i64 1452737877330783856, 0
%t9410 = add i64 %t9409, 0
%t9411 = add i64 %t9410, 0
%t9412 = icmp ne i64 %t9411, %t9409
%t9413 = icmp slt i64 1452737877330783856, 0
%t9414 = or i1 %t9412, %t9413
%t9415 = zext i1 %t9414 to i8
call void @resid_conv_check(i8 %t9415)
%t9416 = add i64 2861767655752347644, 0
%t9417 = add i64 %t9416, 0
%t9418 = add i64 %t9417, 0
%t9419 = icmp ne i64 %t9418, %t9416
%t9420 = icmp slt i64 2861767655752347644, 0
%t9421 = or i1 %t9419, %t9420
%t9422 = zext i1 %t9421 to i8
call void @resid_conv_check(i8 %t9422)
%t9423 = add i64 3322285676063803686, 0
%t9424 = add i64 %t9423, 0
%t9425 = add i64 %t9424, 0
%t9426 = icmp ne i64 %t9425, %t9423
%t9427 = icmp slt i64 3322285676063803686, 0
%t9428 = or i1 %t9426, %t9427
%t9429 = zext i1 %t9428 to i8
call void @resid_conv_check(i8 %t9429)
%t9430 = add i64 5560940570517711597, 0
%t9431 = add i64 %t9430, 0
%t9432 = add i64 %t9431, 0
%t9433 = icmp ne i64 %t9432, %t9430
%t9434 = icmp slt i64 5560940570517711597, 0
%t9435 = or i1 %t9433, %t9434
%t9436 = zext i1 %t9435 to i8
call void @resid_conv_check(i8 %t9436)
%t9437 = add i64 5996557281743188959, 0
%t9438 = add i64 %t9437, 0
%t9439 = add i64 %t9438, 0
%t9440 = icmp ne i64 %t9439, %t9437
%t9441 = icmp slt i64 5996557281743188959, 0
%t9442 = or i1 %t9440, %t9441
%t9443 = zext i1 %t9442 to i8
call void @resid_conv_check(i8 %t9443)
%t9444 = add i64 7280758554555802590, 0
%t9445 = add i64 %t9444, 0
%t9446 = add i64 %t9445, 0
%t9447 = icmp ne i64 %t9446, %t9444
%t9448 = icmp slt i64 7280758554555802590, 0
%t9449 = or i1 %t9447, %t9448
%t9450 = zext i1 %t9449 to i8
call void @resid_conv_check(i8 %t9450)
%t9451 = add i64 8532644243296465576, 0
%t9452 = add i64 %t9451, 0
%t9453 = add i64 %t9452, 0
%t9454 = icmp ne i64 %t9453, %t9451
%t9455 = icmp slt i64 8532644243296465576, 0
%t9456 = or i1 %t9454, %t9455
%t9457 = zext i1 %t9456 to i8
call void @resid_conv_check(i8 %t9457)
%t9458 = add i128 9350256976987008742, 0
%t9459 = trunc i128 %t9458 to i64
%t9460 = zext i64 %t9459 to i128
%t9461 = icmp ne i128 %t9460, %t9458
%t9462 = icmp slt i128 9350256976987008742, 0
%t9463 = or i1 %t9461, %t9462
%t9464 = zext i1 %t9463 to i8
call void @resid_conv_check(i8 %t9464)
%t9465 = add i128 10552545826968843579, 0
%t9466 = trunc i128 %t9465 to i64
%t9467 = zext i64 %t9466 to i128
%t9468 = icmp ne i128 %t9467, %t9465
%t9469 = icmp slt i128 10552545826968843579, 0
%t9470 = or i1 %t9468, %t9469
%t9471 = zext i1 %t9470 to i8
call void @resid_conv_check(i8 %t9471)
%t9472 = add i128 11727347734174303076, 0
%t9473 = trunc i128 %t9472 to i64
%t9474 = zext i64 %t9473 to i128
%t9475 = icmp ne i128 %t9474, %t9472
%t9476 = icmp slt i128 11727347734174303076, 0
%t9477 = or i1 %t9475, %t9476
%t9478 = zext i1 %t9477 to i8
call void @resid_conv_check(i8 %t9478)
%t9479 = add i128 12113106623233404929, 0
%t9480 = trunc i128 %t9479 to i64
%t9481 = zext i64 %t9480 to i128
%t9482 = icmp ne i128 %t9481, %t9479
%t9483 = icmp slt i128 12113106623233404929, 0
%t9484 = or i1 %t9482, %t9483
%t9485 = zext i1 %t9484 to i8
call void @resid_conv_check(i8 %t9485)
%t9486 = add i128 14000437183269869457, 0
%t9487 = trunc i128 %t9486 to i64
%t9488 = zext i64 %t9487 to i128
%t9489 = icmp ne i128 %t9488, %t9486
%t9490 = icmp slt i128 14000437183269869457, 0
%t9491 = or i1 %t9489, %t9490
%t9492 = zext i1 %t9491 to i8
call void @resid_conv_check(i8 %t9492)
%t9493 = add i128 14369950271660146224, 0
%t9494 = trunc i128 %t9493 to i64
%t9495 = zext i64 %t9494 to i128
%t9496 = icmp ne i128 %t9495, %t9493
%t9497 = icmp slt i128 14369950271660146224, 0
%t9498 = or i1 %t9496, %t9497
%t9499 = zext i1 %t9498 to i8
call void @resid_conv_check(i8 %t9499)
%t9500 = add i128 15101387698204529176, 0
%t9501 = trunc i128 %t9500 to i64
%t9502 = zext i64 %t9501 to i128
%t9503 = icmp ne i128 %t9502, %t9500
%t9504 = icmp slt i128 15101387698204529176, 0
%t9505 = or i1 %t9503, %t9504
%t9506 = zext i1 %t9505 to i8
call void @resid_conv_check(i8 %t9506)
%t9507 = add i128 15463397548674623760, 0
%t9508 = trunc i128 %t9507 to i64
%t9509 = zext i64 %t9508 to i128
%t9510 = icmp ne i128 %t9509, %t9507
%t9511 = icmp slt i128 15463397548674623760, 0
%t9512 = or i1 %t9510, %t9511
%t9513 = zext i1 %t9512 to i8
call void @resid_conv_check(i8 %t9513)
%t9514 = add i128 17586052441742319658, 0
%t9515 = trunc i128 %t9514 to i64
%t9516 = zext i64 %t9515 to i128
%t9517 = icmp ne i128 %t9516, %t9514
%t9518 = icmp slt i128 17586052441742319658, 0
%t9519 = or i1 %t9517, %t9518
%t9520 = zext i1 %t9519 to i8
call void @resid_conv_check(i8 %t9520)
%t9521 = add i64 1182934255886127544, 0
%t9522 = add i64 %t9521, 0
%t9523 = add i64 %t9522, 0
%t9524 = icmp ne i64 %t9523, %t9521
%t9525 = icmp slt i64 1182934255886127544, 0
%t9526 = or i1 %t9524, %t9525
%t9527 = zext i1 %t9526 to i8
call void @resid_conv_check(i8 %t9527)
%t9528 = add i64 1847814050463011016, 0
%t9529 = add i64 %t9528, 0
%t9530 = add i64 %t9529, 0
%t9531 = icmp ne i64 %t9530, %t9528
%t9532 = icmp slt i64 1847814050463011016, 0
%t9533 = or i1 %t9531, %t9532
%t9534 = zext i1 %t9533 to i8
call void @resid_conv_check(i8 %t9534)
%t9535 = add i64 2177327727835720531, 0
%t9536 = add i64 %t9535, 0
%t9537 = add i64 %t9536, 0
%t9538 = icmp ne i64 %t9537, %t9535
%t9539 = icmp slt i64 2177327727835720531, 0
%t9540 = or i1 %t9538, %t9539
%t9541 = zext i1 %t9540 to i8
call void @resid_conv_check(i8 %t9541)
%t9542 = add i64 2830643537854262169, 0
%t9543 = add i64 %t9542, 0
%t9544 = add i64 %t9543, 0
%t9545 = icmp ne i64 %t9544, %t9542
%t9546 = icmp slt i64 2830643537854262169, 0
%t9547 = or i1 %t9545, %t9546
%t9548 = zext i1 %t9547 to i8
call void @resid_conv_check(i8 %t9548)
%t9549 = add i64 3796741975233480872, 0
%t9550 = add i64 %t9549, 0
%t9551 = add i64 %t9550, 0
%t9552 = icmp ne i64 %t9551, %t9549
%t9553 = icmp slt i64 3796741975233480872, 0
%t9554 = or i1 %t9552, %t9553
%t9555 = zext i1 %t9554 to i8
call void @resid_conv_check(i8 %t9555)
%t9556 = add i64 4115178125766777443, 0
%t9557 = add i64 %t9556, 0
%t9558 = add i64 %t9557, 0
%t9559 = icmp ne i64 %t9558, %t9556
%t9560 = icmp slt i64 4115178125766777443, 0
%t9561 = or i1 %t9559, %t9560
%t9562 = zext i1 %t9561 to i8
call void @resid_conv_check(i8 %t9562)
%t9563 = add i64 5681478168544905931, 0
%t9564 = add i64 %t9563, 0
%t9565 = add i64 %t9564, 0
%t9566 = icmp ne i64 %t9565, %t9563
%t9567 = icmp slt i64 5681478168544905931, 0
%t9568 = or i1 %t9566, %t9567
%t9569 = zext i1 %t9568 to i8
call void @resid_conv_check(i8 %t9569)
%t9570 = add i64 6601373596472566643, 0
%t9571 = add i64 %t9570, 0
%t9572 = add i64 %t9571, 0
%t9573 = icmp ne i64 %t9572, %t9570
%t9574 = icmp slt i64 6601373596472566643, 0
%t9575 = or i1 %t9573, %t9574
%t9576 = zext i1 %t9575 to i8
call void @resid_conv_check(i8 %t9576)
%t9577 = add i64 7507060721942968483, 0
%t9578 = add i64 %t9577, 0
%t9579 = add i64 %t9578, 0
%t9580 = icmp ne i64 %t9579, %t9577
%t9581 = icmp slt i64 7507060721942968483, 0
%t9582 = or i1 %t9580, %t9581
%t9583 = zext i1 %t9582 to i8
call void @resid_conv_check(i8 %t9583)
%t9584 = add i64 8399075790359081724, 0
%t9585 = add i64 %t9584, 0
%t9586 = add i64 %t9585, 0
%t9587 = icmp ne i64 %t9586, %t9584
%t9588 = icmp slt i64 8399075790359081724, 0
%t9589 = or i1 %t9587, %t9588
%t9590 = zext i1 %t9589 to i8
call void @resid_conv_check(i8 %t9590)
%t9591 = add i64 8693463985226723168, 0
%t9592 = add i64 %t9591, 0
%t9593 = add i64 %t9592, 0
%t9594 = icmp ne i64 %t9593, %t9591
%t9595 = icmp slt i64 8693463985226723168, 0
%t9596 = or i1 %t9594, %t9595
%t9597 = zext i1 %t9596 to i8
call void @resid_conv_check(i8 %t9597)
%t9598 = add i128 9568029438360202098, 0
%t9599 = trunc i128 %t9598 to i64
%t9600 = zext i64 %t9599 to i128
%t9601 = icmp ne i128 %t9600, %t9598
%t9602 = icmp slt i128 9568029438360202098, 0
%t9603 = or i1 %t9601, %t9602
%t9604 = zext i1 %t9603 to i8
call void @resid_conv_check(i8 %t9604)
%t9605 = add i128 10144078919501101548, 0
%t9606 = trunc i128 %t9605 to i64
%t9607 = zext i64 %t9606 to i128
%t9608 = icmp ne i128 %t9607, %t9605
%t9609 = icmp slt i128 10144078919501101548, 0
%t9610 = or i1 %t9608, %t9609
%t9611 = zext i1 %t9610 to i8
call void @resid_conv_check(i8 %t9611)
%t9612 = add i128 10430055236837252648, 0
%t9613 = trunc i128 %t9612 to i64
%t9614 = zext i64 %t9613 to i128
%t9615 = icmp ne i128 %t9614, %t9612
%t9616 = icmp slt i128 10430055236837252648, 0
%t9617 = or i1 %t9615, %t9616
%t9618 = zext i1 %t9617 to i8
call void @resid_conv_check(i8 %t9618)
%t9619 = add i128 11840083180663258601, 0
%t9620 = trunc i128 %t9619 to i64
%t9621 = zext i64 %t9620 to i128
%t9622 = icmp ne i128 %t9621, %t9619
%t9623 = icmp slt i128 11840083180663258601, 0
%t9624 = or i1 %t9622, %t9623
%t9625 = zext i1 %t9624 to i8
call void @resid_conv_check(i8 %t9625)
%t9626 = add i128 13761210420658862357, 0
%t9627 = trunc i128 %t9626 to i64
%t9628 = zext i64 %t9627 to i128
%t9629 = icmp ne i128 %t9628, %t9626
%t9630 = icmp slt i128 13761210420658862357, 0
%t9631 = or i1 %t9629, %t9630
%t9632 = zext i1 %t9631 to i8
call void @resid_conv_check(i8 %t9632)
%t9633 = add i128 14299343276471374635, 0
%t9634 = trunc i128 %t9633 to i64
%t9635 = zext i64 %t9634 to i128
%t9636 = icmp ne i128 %t9635, %t9633
%t9637 = icmp slt i128 14299343276471374635, 0
%t9638 = or i1 %t9636, %t9637
%t9639 = zext i1 %t9638 to i8
call void @resid_conv_check(i8 %t9639)
%t9640 = add i128 14566680578165727644, 0
%t9641 = trunc i128 %t9640 to i64
%t9642 = zext i64 %t9641 to i128
%t9643 = icmp ne i128 %t9642, %t9640
%t9644 = icmp slt i128 14566680578165727644, 0
%t9645 = or i1 %t9643, %t9644
%t9646 = zext i1 %t9645 to i8
call void @resid_conv_check(i8 %t9646)
%t9647 = add i128 15097957966210449927, 0
%t9648 = trunc i128 %t9647 to i64
%t9649 = zext i64 %t9648 to i128
%t9650 = icmp ne i128 %t9649, %t9647
%t9651 = icmp slt i128 15097957966210449927, 0
%t9652 = or i1 %t9650, %t9651
%t9653 = zext i1 %t9652 to i8
call void @resid_conv_check(i8 %t9653)
%t9654 = add i128 16922976911328602910, 0
%t9655 = trunc i128 %t9654 to i64
%t9656 = zext i64 %t9655 to i128
%t9657 = icmp ne i128 %t9656, %t9654
%t9658 = icmp slt i128 16922976911328602910, 0
%t9659 = or i1 %t9657, %t9658
%t9660 = zext i1 %t9659 to i8
call void @resid_conv_check(i8 %t9660)
%t9661 = add i128 17689382322260857208, 0
%t9662 = trunc i128 %t9661 to i64
%t9663 = zext i64 %t9662 to i128
%t9664 = icmp ne i128 %t9663, %t9661
%t9665 = icmp slt i128 17689382322260857208, 0
%t9666 = or i1 %t9664, %t9665
%t9667 = zext i1 %t9666 to i8
call void @resid_conv_check(i8 %t9667)
%t9668 = add i64 1242879168328830382, 0
%t9669 = add i64 %t9668, 0
%t9670 = add i64 %t9669, 0
%t9671 = icmp ne i64 %t9670, %t9668
%t9672 = icmp slt i64 1242879168328830382, 0
%t9673 = or i1 %t9671, %t9672
%t9674 = zext i1 %t9673 to i8
call void @resid_conv_check(i8 %t9674)
%t9675 = add i64 1977374033974150939, 0
%t9676 = add i64 %t9675, 0
%t9677 = add i64 %t9676, 0
%t9678 = icmp ne i64 %t9677, %t9675
%t9679 = icmp slt i64 1977374033974150939, 0
%t9680 = or i1 %t9678, %t9679
%t9681 = zext i1 %t9680 to i8
call void @resid_conv_check(i8 %t9681)
%t9682 = add i64 2944078676154940804, 0
%t9683 = add i64 %t9682, 0
%t9684 = add i64 %t9683, 0
%t9685 = icmp ne i64 %t9684, %t9682
%t9686 = icmp slt i64 2944078676154940804, 0
%t9687 = or i1 %t9685, %t9686
%t9688 = zext i1 %t9687 to i8
call void @resid_conv_check(i8 %t9688)
%t9689 = add i64 3659926193048069267, 0
%t9690 = add i64 %t9689, 0
%t9691 = add i64 %t9690, 0
%t9692 = icmp ne i64 %t9691, %t9689
%t9693 = icmp slt i64 3659926193048069267, 0
%t9694 = or i1 %t9692, %t9693
%t9695 = zext i1 %t9694 to i8
call void @resid_conv_check(i8 %t9695)
%t9696 = add i64 4368137639120453308, 0
%t9697 = add i64 %t9696, 0
%t9698 = add i64 %t9697, 0
%t9699 = icmp ne i64 %t9698, %t9696
%t9700 = icmp slt i64 4368137639120453308, 0
%t9701 = or i1 %t9699, %t9700
%t9702 = zext i1 %t9701 to i8
call void @resid_conv_check(i8 %t9702)
%t9703 = add i64 4836135668995329356, 0
%t9704 = add i64 %t9703, 0
%t9705 = add i64 %t9704, 0
%t9706 = icmp ne i64 %t9705, %t9703
%t9707 = icmp slt i64 4836135668995329356, 0
%t9708 = or i1 %t9706, %t9707
%t9709 = zext i1 %t9708 to i8
call void @resid_conv_check(i8 %t9709)
%t9710 = add i64 5532061633213252278, 0
%t9711 = add i64 %t9710, 0
%t9712 = add i64 %t9711, 0
%t9713 = icmp ne i64 %t9712, %t9710
%t9714 = icmp slt i64 5532061633213252278, 0
%t9715 = or i1 %t9713, %t9714
%t9716 = zext i1 %t9715 to i8
call void @resid_conv_check(i8 %t9716)
%t9717 = add i64 6448918945643986474, 0
%t9718 = add i64 %t9717, 0
%t9719 = add i64 %t9718, 0
%t9720 = icmp ne i64 %t9719, %t9717
%t9721 = icmp slt i64 6448918945643986474, 0
%t9722 = or i1 %t9720, %t9721
%t9723 = zext i1 %t9722 to i8
call void @resid_conv_check(i8 %t9723)
%t9724 = add i64 6902733635092675308, 0
%t9725 = add i64 %t9724, 0
%t9726 = add i64 %t9725, 0
%t9727 = icmp ne i64 %t9726, %t9724
%t9728 = icmp slt i64 6902733635092675308, 0
%t9729 = or i1 %t9727, %t9728
%t9730 = zext i1 %t9729 to i8
call void @resid_conv_check(i8 %t9730)
%t9731 = add i64 7801388544844847127, 0
%t9732 = add i64 %t9731, 0
%t9733 = add i64 %t9732, 0
%t9734 = icmp ne i64 %t9733, %t9731
%t9735 = icmp slt i64 7801388544844847127, 0
%t9736 = or i1 %t9734, %t9735
%t9737 = zext i1 %t9736 to i8
call void @resid_conv_check(i8 %t9737)
%t9738 = alloca [80 x ptr]
%t9740 = call ptr @resid_box_i64(i64 %t9200)
%t9742 = getelementptr i8, ptr %t9738, i64 0
store ptr %t9740, ptr %t9742
%t9743 = call ptr @resid_box_i64(i64 %t9207)
%t9745 = getelementptr i8, ptr %t9738, i64 8
store ptr %t9743, ptr %t9745
%t9746 = call ptr @resid_box_i64(i64 %t9214)
%t9748 = getelementptr i8, ptr %t9738, i64 16
store ptr %t9746, ptr %t9748
%t9749 = call ptr @resid_box_i64(i64 %t9221)
%t9751 = getelementptr i8, ptr %t9738, i64 24
store ptr %t9749, ptr %t9751
%t9752 = call ptr @resid_box_i64(i64 %t9228)
%t9754 = getelementptr i8, ptr %t9738, i64 32
store ptr %t9752, ptr %t9754
%t9755 = call ptr @resid_box_i64(i64 %t9235)
%t9757 = getelementptr i8, ptr %t9738, i64 40
store ptr %t9755, ptr %t9757
%t9758 = call ptr @resid_box_i64(i64 %t9242)
%t9760 = getelementptr i8, ptr %t9738, i64 48
store ptr %t9758, ptr %t9760
%t9761 = call ptr @resid_box_i64(i64 %t9249)
%t9763 = getelementptr i8, ptr %t9738, i64 56
store ptr %t9761, ptr %t9763
%t9764 = call ptr @resid_box_i64(i64 %t9256)
%t9766 = getelementptr i8, ptr %t9738, i64 64
store ptr %t9764, ptr %t9766
%t9767 = call ptr @resid_box_i64(i64 %t9263)
%t9769 = getelementptr i8, ptr %t9738, i64 72
store ptr %t9767, ptr %t9769
%t9770 = call ptr @resid_box_i64(i64 %t9270)
%t9772 = getelementptr i8, ptr %t9738, i64 80
store ptr %t9770, ptr %t9772
%t9773 = call ptr @resid_box_i64(i64 %t9277)
%t9775 = getelementptr i8, ptr %t9738, i64 88
store ptr %t9773, ptr %t9775
%t9776 = call ptr @resid_box_i64(i64 %t9284)
%t9778 = getelementptr i8, ptr %t9738, i64 96
store ptr %t9776, ptr %t9778
%t9779 = call ptr @resid_box_i64(i64 %t9291)
%t9781 = getelementptr i8, ptr %t9738, i64 104
store ptr %t9779, ptr %t9781
%t9782 = call ptr @resid_box_i64(i64 %t9298)
%t9784 = getelementptr i8, ptr %t9738, i64 112
store ptr %t9782, ptr %t9784
%t9785 = call ptr @resid_box_i64(i64 %t9305)
%t9787 = getelementptr i8, ptr %t9738, i64 120
store ptr %t9785, ptr %t9787
%t9788 = call ptr @resid_box_i64(i64 %t9312)
%t9790 = getelementptr i8, ptr %t9738, i64 128
store ptr %t9788, ptr %t9790
%t9791 = call ptr @resid_box_i64(i64 %t9319)
%t9793 = getelementptr i8, ptr %t9738, i64 136
store ptr %t9791, ptr %t9793
%t9794 = call ptr @resid_box_i64(i64 %t9326)
%t9796 = getelementptr i8, ptr %t9738, i64 144
store ptr %t9794, ptr %t9796
%t9797 = call ptr @resid_box_i64(i64 %t9333)
%t9799 = getelementptr i8, ptr %t9738, i64 152
store ptr %t9797, ptr %t9799
%t9800 = call ptr @resid_box_i64(i64 %t9340)
%t9802 = getelementptr i8, ptr %t9738, i64 160
store ptr %t9800, ptr %t9802
%t9803 = call ptr @resid_box_i64(i64 %t9347)
%t9805 = getelementptr i8, ptr %t9738, i64 168
store ptr %t9803, ptr %t9805
%t9806 = call ptr @resid_box_i64(i64 %t9354)
%t9808 = getelementptr i8, ptr %t9738, i64 176
store ptr %t9806, ptr %t9808
%t9809 = call ptr @resid_box_i64(i64 %t9361)
%t9811 = getelementptr i8, ptr %t9738, i64 184
store ptr %t9809, ptr %t9811
%t9812 = call ptr @resid_box_i64(i64 %t9368)
%t9814 = getelementptr i8, ptr %t9738, i64 192
store ptr %t9812, ptr %t9814
%t9815 = call ptr @resid_box_i64(i64 %t9375)
%t9817 = getelementptr i8, ptr %t9738, i64 200
store ptr %t9815, ptr %t9817
%t9818 = call ptr @resid_box_i64(i64 %t9382)
%t9820 = getelementptr i8, ptr %t9738, i64 208
store ptr %t9818, ptr %t9820
%t9821 = call ptr @resid_box_i64(i64 %t9389)
%t9823 = getelementptr i8, ptr %t9738, i64 216
store ptr %t9821, ptr %t9823
%t9824 = call ptr @resid_box_i64(i64 %t9396)
%t9826 = getelementptr i8, ptr %t9738, i64 224
store ptr %t9824, ptr %t9826
%t9827 = call ptr @resid_box_i64(i64 %t9403)
%t9829 = getelementptr i8, ptr %t9738, i64 232
store ptr %t9827, ptr %t9829
%t9830 = call ptr @resid_box_i64(i64 489312712824947311)
%t9832 = getelementptr i8, ptr %t9738, i64 240
store ptr %t9830, ptr %t9832
%t9833 = call ptr @resid_box_i64(i64 %t9410)
%t9835 = getelementptr i8, ptr %t9738, i64 248
store ptr %t9833, ptr %t9835
%t9836 = call ptr @resid_box_i64(i64 %t9417)
%t9838 = getelementptr i8, ptr %t9738, i64 256
store ptr %t9836, ptr %t9838
%t9839 = call ptr @resid_box_i64(i64 %t9424)
%t9841 = getelementptr i8, ptr %t9738, i64 264
store ptr %t9839, ptr %t9841
%t9842 = call ptr @resid_box_i64(i64 %t9431)
%t9844 = getelementptr i8, ptr %t9738, i64 272
store ptr %t9842, ptr %t9844
%t9845 = call ptr @resid_box_i64(i64 %t9438)
%t9847 = getelementptr i8, ptr %t9738, i64 280
store ptr %t9845, ptr %t9847
%t9848 = call ptr @resid_box_i64(i64 %t9445)
%t9850 = getelementptr i8, ptr %t9738, i64 288
store ptr %t9848, ptr %t9850
%t9851 = call ptr @resid_box_i64(i64 %t9452)
%t9853 = getelementptr i8, ptr %t9738, i64 296
store ptr %t9851, ptr %t9853
%t9854 = call ptr @resid_box_i64(i64 %t9459)
%t9856 = getelementptr i8, ptr %t9738, i64 304
store ptr %t9854, ptr %t9856
%t9857 = call ptr @resid_box_i64(i64 %t9466)
%t9859 = getelementptr i8, ptr %t9738, i64 312
store ptr %t9857, ptr %t9859
%t9860 = call ptr @resid_box_i64(i64 %t9473)
%t9862 = getelementptr i8, ptr %t9738, i64 320
store ptr %t9860, ptr %t9862
%t9863 = call ptr @resid_box_i64(i64 %t9480)
%t9865 = getelementptr i8, ptr %t9738, i64 328
store ptr %t9863, ptr %t9865
%t9866 = call ptr @resid_box_i64(i64 %t9487)
%t9868 = getelementptr i8, ptr %t9738, i64 336
store ptr %t9866, ptr %t9868
%t9869 = call ptr @resid_box_i64(i64 %t9494)
%t9871 = getelementptr i8, ptr %t9738, i64 344
store ptr %t9869, ptr %t9871
%t9872 = call ptr @resid_box_i64(i64 %t9501)
%t9874 = getelementptr i8, ptr %t9738, i64 352
store ptr %t9872, ptr %t9874
%t9875 = call ptr @resid_box_i64(i64 %t9508)
%t9877 = getelementptr i8, ptr %t9738, i64 360
store ptr %t9875, ptr %t9877
%t9878 = call ptr @resid_box_i64(i64 %t9515)
%t9880 = getelementptr i8, ptr %t9738, i64 368
store ptr %t9878, ptr %t9880
%t9881 = call ptr @resid_box_i64(i64 %t9522)
%t9883 = getelementptr i8, ptr %t9738, i64 376
store ptr %t9881, ptr %t9883
%t9884 = call ptr @resid_box_i64(i64 %t9529)
%t9886 = getelementptr i8, ptr %t9738, i64 384
store ptr %t9884, ptr %t9886
%t9887 = call ptr @resid_box_i64(i64 %t9536)
%t9889 = getelementptr i8, ptr %t9738, i64 392
store ptr %t9887, ptr %t9889
%t9890 = call ptr @resid_box_i64(i64 %t9543)
%t9892 = getelementptr i8, ptr %t9738, i64 400
store ptr %t9890, ptr %t9892
%t9893 = call ptr @resid_box_i64(i64 %t9550)
%t9895 = getelementptr i8, ptr %t9738, i64 408
store ptr %t9893, ptr %t9895
%t9896 = call ptr @resid_box_i64(i64 %t9557)
%t9898 = getelementptr i8, ptr %t9738, i64 416
store ptr %t9896, ptr %t9898
%t9899 = call ptr @resid_box_i64(i64 %t9564)
%t9901 = getelementptr i8, ptr %t9738, i64 424
store ptr %t9899, ptr %t9901
%t9902 = call ptr @resid_box_i64(i64 %t9571)
%t9904 = getelementptr i8, ptr %t9738, i64 432
store ptr %t9902, ptr %t9904
%t9905 = call ptr @resid_box_i64(i64 %t9578)
%t9907 = getelementptr i8, ptr %t9738, i64 440
store ptr %t9905, ptr %t9907
%t9908 = call ptr @resid_box_i64(i64 %t9585)
%t9910 = getelementptr i8, ptr %t9738, i64 448
store ptr %t9908, ptr %t9910
%t9911 = call ptr @resid_box_i64(i64 %t9592)
%t9913 = getelementptr i8, ptr %t9738, i64 456
store ptr %t9911, ptr %t9913
%t9914 = call ptr @resid_box_i64(i64 %t9599)
%t9916 = getelementptr i8, ptr %t9738, i64 464
store ptr %t9914, ptr %t9916
%t9917 = call ptr @resid_box_i64(i64 %t9606)
%t9919 = getelementptr i8, ptr %t9738, i64 472
store ptr %t9917, ptr %t9919
%t9920 = call ptr @resid_box_i64(i64 %t9613)
%t9922 = getelementptr i8, ptr %t9738, i64 480
store ptr %t9920, ptr %t9922
%t9923 = call ptr @resid_box_i64(i64 %t9620)
%t9925 = getelementptr i8, ptr %t9738, i64 488
store ptr %t9923, ptr %t9925
%t9926 = call ptr @resid_box_i64(i64 %t9627)
%t9928 = getelementptr i8, ptr %t9738, i64 496
store ptr %t9926, ptr %t9928
%t9929 = call ptr @resid_box_i64(i64 %t9634)
%t9931 = getelementptr i8, ptr %t9738, i64 504
store ptr %t9929, ptr %t9931
%t9932 = call ptr @resid_box_i64(i64 %t9641)
%t9934 = getelementptr i8, ptr %t9738, i64 512
store ptr %t9932, ptr %t9934
%t9935 = call ptr @resid_box_i64(i64 %t9648)
%t9937 = getelementptr i8, ptr %t9738, i64 520
store ptr %t9935, ptr %t9937
%t9938 = call ptr @resid_box_i64(i64 %t9655)
%t9940 = getelementptr i8, ptr %t9738, i64 528
store ptr %t9938, ptr %t9940
%t9941 = call ptr @resid_box_i64(i64 %t9662)
%t9943 = getelementptr i8, ptr %t9738, i64 536
store ptr %t9941, ptr %t9943
%t9944 = call ptr @resid_box_i64(i64 500013540394364858)
%t9946 = getelementptr i8, ptr %t9738, i64 544
store ptr %t9944, ptr %t9946
%t9947 = call ptr @resid_box_i64(i64 748580250866718886)
%t9949 = getelementptr i8, ptr %t9738, i64 552
store ptr %t9947, ptr %t9949
%t9950 = call ptr @resid_box_i64(i64 %t9669)
%t9952 = getelementptr i8, ptr %t9738, i64 560
store ptr %t9950, ptr %t9952
%t9953 = call ptr @resid_box_i64(i64 %t9676)
%t9955 = getelementptr i8, ptr %t9738, i64 568
store ptr %t9953, ptr %t9955
%t9956 = call ptr @resid_box_i64(i64 %t9683)
%t9958 = getelementptr i8, ptr %t9738, i64 576
store ptr %t9956, ptr %t9958
%t9959 = call ptr @resid_box_i64(i64 %t9690)
%t9961 = getelementptr i8, ptr %t9738, i64 584
store ptr %t9959, ptr %t9961
%t9962 = call ptr @resid_box_i64(i64 %t9697)
%t9964 = getelementptr i8, ptr %t9738, i64 592
store ptr %t9962, ptr %t9964
%t9965 = call ptr @resid_box_i64(i64 %t9704)
%t9967 = getelementptr i8, ptr %t9738, i64 600
store ptr %t9965, ptr %t9967
%t9968 = call ptr @resid_box_i64(i64 %t9711)
%t9970 = getelementptr i8, ptr %t9738, i64 608
store ptr %t9968, ptr %t9970
%t9971 = call ptr @resid_box_i64(i64 %t9718)
%t9973 = getelementptr i8, ptr %t9738, i64 616
store ptr %t9971, ptr %t9973
%t9974 = call ptr @resid_box_i64(i64 %t9725)
%t9976 = getelementptr i8, ptr %t9738, i64 624
store ptr %t9974, ptr %t9976
%t9977 = call ptr @resid_box_i64(i64 %t9732)
%t9979 = getelementptr i8, ptr %t9738, i64 632
store ptr %t9977, ptr %t9979
%t9980 = call ptr @resid_list_new(i64 80, ptr %t9738, ptr @.lty9738)
%t9981 = getelementptr i8, ptr %p2, i64 0
%t9982 = load i64, ptr %t9981, align 8
%t9983 = getelementptr i8, ptr %p2, i64 8
%t9984 = load i64, ptr %t9983, align 8
%t9985 = getelementptr i8, ptr %p2, i64 16
%t9986 = load i64, ptr %t9985, align 8
%t9987 = getelementptr i8, ptr %p2, i64 24
%t9988 = load i64, ptr %t9987, align 8
%t9989 = getelementptr i8, ptr %p2, i64 32
%t9990 = load i64, ptr %t9989, align 8
%t9991 = getelementptr i8, ptr %p2, i64 40
%t9992 = load i64, ptr %t9991, align 8
%t9993 = getelementptr i8, ptr %p2, i64 48
%t9994 = load i64, ptr %t9993, align 8
%t9995 = getelementptr i8, ptr %p2, i64 56
%t9996 = load i64, ptr %t9995, align 8
%t9997 = call ptr @__m____________lib_sha512g_resid__g5_blk__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %t9980, i64 0, ptr %p2, i64 %t9982, i64 %t9984, i64 %t9986, i64 %t9988, i64 %t9990, i64 %t9992, i64 %t9994, i64 %t9996, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret ptr %t9997
}
define i64 @__m____________lib_sha512g_resid__g5_state_word__g_UInt_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9998 = icmp eq i64 %p1, 0
br i1 %t9998, label %L958, label %L959
L958:
%t9999 = getelementptr i8, ptr %p0, i64 0
%t10000 = load i64, ptr %t9999, align 8
br label %L960
L959:
%t10001 = icmp eq i64 %p1, 1
br i1 %t10001, label %L961, label %L962
L961:
%t10002 = getelementptr i8, ptr %p0, i64 8
%t10003 = load i64, ptr %t10002, align 8
br label %L963
L962:
%t10004 = icmp eq i64 %p1, 2
br i1 %t10004, label %L964, label %L965
L964:
%t10005 = getelementptr i8, ptr %p0, i64 16
%t10006 = load i64, ptr %t10005, align 8
br label %L966
L965:
%t10007 = icmp eq i64 %p1, 3
br i1 %t10007, label %L967, label %L968
L967:
%t10008 = getelementptr i8, ptr %p0, i64 24
%t10009 = load i64, ptr %t10008, align 8
br label %L969
L968:
%t10010 = icmp eq i64 %p1, 4
br i1 %t10010, label %L970, label %L971
L970:
%t10011 = getelementptr i8, ptr %p0, i64 32
%t10012 = load i64, ptr %t10011, align 8
br label %L972
L971:
%t10013 = icmp eq i64 %p1, 5
br i1 %t10013, label %L973, label %L974
L973:
%t10014 = getelementptr i8, ptr %p0, i64 40
%t10015 = load i64, ptr %t10014, align 8
br label %L975
L974:
%t10016 = icmp eq i64 %p1, 6
br i1 %t10016, label %L976, label %L977
L976:
%t10017 = getelementptr i8, ptr %p0, i64 48
%t10018 = load i64, ptr %t10017, align 8
br label %L978
L977:
%t10019 = getelementptr i8, ptr %p0, i64 56
%t10020 = load i64, ptr %t10019, align 8
br label %L978
L978:
%t10021 = phi i64 [ %t10018, %L976 ], [ %t10020, %L977 ]
br label %L975
L975:
%t10022 = phi i64 [ %t10015, %L973 ], [ %t10021, %L978 ]
br label %L972
L972:
%t10023 = phi i64 [ %t10012, %L970 ], [ %t10022, %L975 ]
br label %L969
L969:
%t10024 = phi i64 [ %t10009, %L967 ], [ %t10023, %L972 ]
br label %L966
L966:
%t10025 = phi i64 [ %t10006, %L964 ], [ %t10024, %L969 ]
br label %L963
L963:
%t10026 = phi i64 [ %t10003, %L961 ], [ %t10025, %L966 ]
br label %L960
L960:
%t10027 = phi i64 [ %t10000, %L958 ], [ %t10026, %L963 ]
ret i64 %t10027
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t10067, %tco.s0.k ]
%p4 = phi ptr [ %p4.in, %entry ], [ %p4.ev.tco.s0, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t10068, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %p7, %tco.s0.k ]
%p9 = phi i64 [ %p9.in, %entry ], [ %t10069, %tco.s0.k ]
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
%p28 = phi i64 [ %p28.in, %entry ], [ %t10054, %tco.s0.k ]
%t10028 = icmp sge i64 %p3, 80
br i1 %t10028, label %L979, label %L981
L979:
%t10029 = call ptr @resid_gmalloc(i64 64)
%t10030 = getelementptr i8, ptr %p4, i64 0
%t10031 = load i64, ptr %t10030, align 8
%t10032 = call i64 @__m____________lib_word_resid__di_add(i64 %t10031, i64 %p5)
%t10029.f0 = getelementptr i8, ptr %t10029, i64 0
store i64 %t10032, ptr %t10029.f0, align 8
%t10033 = getelementptr i8, ptr %p4, i64 8
%t10034 = load i64, ptr %t10033, align 8
%t10035 = call i64 @__m____________lib_word_resid__di_add(i64 %t10034, i64 %p6)
%t10029.f1 = getelementptr i8, ptr %t10029, i64 8
store i64 %t10035, ptr %t10029.f1, align 8
%t10036 = getelementptr i8, ptr %p4, i64 16
%t10037 = load i64, ptr %t10036, align 8
%t10038 = call i64 @__m____________lib_word_resid__di_add(i64 %t10037, i64 %p7)
%t10029.f2 = getelementptr i8, ptr %t10029, i64 16
store i64 %t10038, ptr %t10029.f2, align 8
%t10039 = getelementptr i8, ptr %p4, i64 24
%t10040 = load i64, ptr %t10039, align 8
%t10041 = call i64 @__m____________lib_word_resid__di_add(i64 %t10040, i64 %p8)
%t10029.f3 = getelementptr i8, ptr %t10029, i64 24
store i64 %t10041, ptr %t10029.f3, align 8
%t10042 = getelementptr i8, ptr %p4, i64 32
%t10043 = load i64, ptr %t10042, align 8
%t10044 = call i64 @__m____________lib_word_resid__di_add(i64 %t10043, i64 %p9)
%t10029.f4 = getelementptr i8, ptr %t10029, i64 32
store i64 %t10044, ptr %t10029.f4, align 8
%t10045 = getelementptr i8, ptr %p4, i64 40
%t10046 = load i64, ptr %t10045, align 8
%t10047 = call i64 @__m____________lib_word_resid__di_add(i64 %t10046, i64 %p10)
%t10029.f5 = getelementptr i8, ptr %t10029, i64 40
store i64 %t10047, ptr %t10029.f5, align 8
%t10048 = getelementptr i8, ptr %p4, i64 48
%t10049 = load i64, ptr %t10048, align 8
%t10050 = call i64 @__m____________lib_word_resid__di_add(i64 %t10049, i64 %p11)
%t10029.f6 = getelementptr i8, ptr %t10029, i64 48
store i64 %t10050, ptr %t10029.f6, align 8
%t10051 = getelementptr i8, ptr %p4, i64 56
%t10052 = load i64, ptr %t10051, align 8
%t10053 = call i64 @__m____________lib_word_resid__di_add(i64 %t10052, i64 %p12)
%t10029.f7 = getelementptr i8, ptr %t10029, i64 56
store i64 %t10053, ptr %t10029.f7, align 8
%lr.cx79 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz79 = icmp eq ptr %lr.cx79, null
br i1 %lr.lz79, label %lr.x79.k, label %lr.x79.m
lr.x79.k:
ret ptr %t10029
lr.x79.m:
%lr.ret79 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %t10029, ptr %lr.cx79)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret79
L981:
%t10054 = call i64 @__m____________lib_sha512g_resid__g5_sched__g_Int_64__UInt_64_(ptr %p0, i64 %p1, i64 %p3, i64 %p13, i64 %p14, i64 %p22, i64 %p27)
%t10055 = call i64 @__m____________lib_sha512g_resid__g5_b1__g_UInt_64__Int_64_(i64 %p9)
%t10056 = call i64 @__m____________lib_word_resid__di_add(i64 %p12, i64 %t10055)
%t10057 = call i64 @__m____________lib_sha512g_resid__g5_ch__g_UInt_64__Int_64_(i64 %p9, i64 %p10, i64 %p11)
%t10058 = call i64 @__m____________lib_word_resid__di_add(i64 %t10056, i64 %t10057)
%t10059 = call ptr @resid_list_get_v(ptr %p2, i64 %p3, ptr %p2.ld, i64 %p2.ln)
%t10060 = call i64 @resid_unbox_i64(ptr %t10059)
%t10062 = call i64 @__m____________lib_word_resid__di_addk(i64 %t10058, i64 %t10060)
%t10063 = call i64 @__m____________lib_word_resid__di_add(i64 %t10062, i64 %t10054)
%t10064 = call i64 @__m____________lib_sha512g_resid__g5_b0__g_UInt_64__Int_64_(i64 %p5)
%t10065 = call i64 @__m____________lib_sha512g_resid__g5_maj__g_UInt_64__Int_64_(i64 %p5, i64 %p6, i64 %p7)
%t10066 = call i64 @__m____________lib_word_resid__di_add(i64 %t10064, i64 %t10065)
%t10067 = add nsw i64 %p3, 1
%t10068 = call i64 @__m____________lib_word_resid__di_add(i64 %t10063, i64 %t10066)
%t10069 = call i64 @__m____________lib_word_resid__di_add(i64 %p8, i64 %t10063)
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
%t10071 = icmp slt i64 %p2, 16
br i1 %t10071, label %L982, label %L984
L982:
%t10072 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t10073 = extractvalue {i64, i1} %t10072, 0
%t10074 = extractvalue {i64, i1} %t10072, 1
%t10075 = zext i1 %t10074 to i8
call void @resid_overflow_check(i8 %t10075)
%t10076 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t10073)
%t10077 = extractvalue {i64, i1} %t10076, 0
%t10078 = extractvalue {i64, i1} %t10076, 1
%t10079 = zext i1 %t10078 to i8
call void @resid_overflow_check(i8 %t10079)
%t10080 = call i64 @__m____________lib_sha512g_resid__g5_word_at__g_Int_64__UInt_64_(ptr %p0, i64 %t10077)
ret i64 %t10080
L984:
%t10081 = call i64 @__m____________lib_sha512g_resid__g5_s1__g_UInt_64__Int_64_(i64 %p6)
%t10082 = call i64 @__m____________lib_word_resid__di_add(i64 %t10081, i64 %p5)
%t10083 = call i64 @__m____________lib_sha512g_resid__g5_s0__g_UInt_64__Int_64_(i64 %p4)
%t10084 = call i64 @__m____________lib_word_resid__di_add(i64 %t10083, i64 %p3)
%t10085 = call i64 @__m____________lib_word_resid__di_add(i64 %t10082, i64 %t10084)
ret i64 %t10085
}
define i64 @__m____________lib_sha512g_resid__g5_b1__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10086 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 14)
%t10087 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 18)
%t10088 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10086, i64 %t10087)
%t10089 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 41)
%t10090 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10088, i64 %t10089)
ret i64 %t10090
}
define i64 @__m____________lib_sha512g_resid__g5_ch__g_UInt_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10091 = call i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p1)
%t10092 = call i64 @__m____________lib_word_resid__di_not(i64 %p0)
%t10093 = call i64 @__m____________lib_word_resid__di_and(i64 %t10092, i64 %p2)
%t10094 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10091, i64 %t10093)
ret i64 %t10094
}
define i64 @__m____________lib_sha512g_resid__g5_b0__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10095 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 28)
%t10096 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 34)
%t10097 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10095, i64 %t10096)
%t10098 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 39)
%t10099 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10097, i64 %t10098)
ret i64 %t10099
}
define i64 @__m____________lib_sha512g_resid__g5_maj__g_UInt_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10100 = call i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p1)
%t10101 = call i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p2)
%t10102 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10100, i64 %t10101)
%t10103 = call i64 @__m____________lib_word_resid__di_and(i64 %p1, i64 %p2)
%t10104 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10102, i64 %t10103)
ret i64 %t10104
}
define i64 @__m____________lib_sha512g_resid__g5_word_at__g_Int_64__UInt_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10105 = call i64 @__m____________lib_sha512g_resid__g5_word_acc__g_Int_64__UInt_64_(ptr %p0, i64 %p1, i64 0, i64 0)
ret i64 %t10105
}
define i64 @__m____________lib_sha512g_resid__g5_s1__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10106 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 19)
%t10107 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 61)
%t10108 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10106, i64 %t10107)
%t10109 = call i64 @__m____________lib_word_resid__di_shr(i64 %p0, i64 6)
%t10110 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10108, i64 %t10109)
ret i64 %t10110
}
define i64 @__m____________lib_sha512g_resid__g5_s0__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10111 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 1)
%t10112 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 8)
%t10113 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10111, i64 %t10112)
%t10114 = call i64 @__m____________lib_word_resid__di_shr(i64 %p0, i64 7)
%t10115 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10113, i64 %t10114)
ret i64 %t10115
}
define i64 @__m____________lib_sha512g_resid__g5_word_acc__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t10126, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t10128, %tco.s0 ]
%t10116 = icmp sge i64 %p2, 8
br i1 %t10116, label %L985, label %L987
L985:
ret i64 %p3
L987:
%t10117 = call i64 @__m____________lib_word_resid__di_and(i64 %p3, i64 72057594037927935)
%t10118 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p2)
%t10119 = extractvalue {i64, i1} %t10118, 0
%t10120 = extractvalue {i64, i1} %t10118, 1
%t10121 = zext i1 %t10120 to i8
call void @resid_overflow_check(i8 %t10121)
%t10122 = call ptr @resid_list_get_v(ptr %p0, i64 %t10119, ptr %p0.ld, i64 %p0.ln)
%t10123 = call i64 @resid_unbox_i64(ptr %t10122)
%t10125 = call i64 @__m____________lib_word_resid__di_from_byte(i64 %t10123)
%t10126 = add nsw i64 %p2, 1
%t10127 = call i64 @__m____________lib_sha512g_resid__g5_shl8__g_UInt_64__Int_64_(i64 %t10117)
%t10128 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10127, i64 %t10125)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_sha512g_resid__g5_shl8__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10130 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 56)
%t10131 = add i128 18446744073709551360, 0
%t10132 = trunc i128 %t10131 to i64
%t10133 = zext i64 %t10132 to i128
%t10134 = icmp ne i128 %t10133, %t10131
%t10135 = icmp slt i128 18446744073709551360, 0
%t10136 = or i1 %t10134, %t10135
%t10137 = zext i1 %t10136 to i8
call void @resid_conv_check(i8 %t10137)
%t10138 = call i64 @__m____________lib_word_resid__di_and(i64 %t10130, i64 %t10132)
ret i64 %t10138
}
define i64 @__m____________lib_bignum_resid__bn_cmp_at__rs45(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 0
}
define ptr @__m____________lib_bignum_resid__bn_sub_at__rs48(ptr %p0, ptr %p1, i64 %p2, i64 %p3, i64 %p4, ptr %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10139 = call ptr @resid_listbuf_finish(ptr %p5, ptr @.lty10139)
ret ptr %t10139
}
define ptr @__m____________lib_bignum_resid__bn_short_at__rs72(ptr %p0, i64 %p1, i64 %p2, i128 %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10140 = call ptr @resid_gmalloc(i64 16)
%t10141 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty10141)
%t10142 = call ptr @__m____________lib_bignum_resid__bn_reverse(ptr %t10141)
%t10143 = call ptr @bn_trim(ptr %t10142)
%t10140.f0 = getelementptr i8, ptr %t10140, i64 0
store ptr %t10143, ptr %t10140.f0, align 8
%t10144 = add i128 %p3, 0
%t10145 = trunc i128 %t10144 to i64
%t10146 = zext i64 %t10145 to i128
%t10147 = icmp ne i128 %t10146, %t10144
%t10148 = icmp eq i8 0, 1
%t10149 = or i1 %t10147, %t10148
%t10150 = zext i1 %t10149 to i8
call void @resid_conv_check(i8 %t10150)
%t10151 = call ptr @bn_from_u64(i64 %t10145)
%t10140.f1 = getelementptr i8, ptr %t10140, i64 8
store ptr %t10151, ptr %t10140.f1, align 8
ret ptr %t10140
}
define ptr @bn_divmod__rs93(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10153 = zext i1 true to i8
call void @resid_assert(i8 %t10153, ptr @.s10152)
%t10154 = alloca [1 x ptr]
%t10156 = call ptr @resid_box_i64(i64 3)
%t10158 = getelementptr i8, ptr %t10154, i64 0
store ptr %t10156, ptr %t10158
%t10159 = call ptr @resid_list_new(i64 1, ptr %t10154, ptr @.lty10154)
%t10160 = call i64 @bn_cmp(ptr %p0, ptr %t10159)
%t10161 = icmp slt i64 %t10160, 0
br i1 %t10161, label %L988, label %L990
L988:
%t10162 = call ptr @resid_gmalloc(i64 16)
%t10163 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyE10163)
%t10162.f0 = getelementptr i8, ptr %t10162, i64 0
store ptr %t10163, ptr %t10162.f0, align 8
%t10162.f1 = getelementptr i8, ptr %t10162, i64 8
store ptr %p0, ptr %t10162.f1, align 8
ret ptr %t10162
L990:
%t10164 = call ptr @__m____________lib_bignum_resid__bn_divmod_short(ptr %p0, i64 3)
ret ptr %t10164
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
%t10165 = call ptr @resid_gmalloc(i64 16)
%t10166 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty10166)
%t10167 = call ptr @__m____________lib_bignum_resid__bn_reverse(ptr %t10166)
%t10168 = call ptr @bn_trim(ptr %t10167)
%t10165.f0 = getelementptr i8, ptr %t10165, i64 0
store ptr %t10168, ptr %t10165.f0, align 8
%t10169 = add i128 %p3, 0
%t10170 = trunc i128 %t10169 to i64
%t10171 = zext i64 %t10170 to i128
%t10172 = icmp ne i128 %t10171, %t10169
%t10173 = icmp eq i8 0, 1
%t10174 = or i1 %t10172, %t10173
%t10175 = zext i1 %t10174 to i8
call void @resid_conv_check(i8 %t10175)
%t10176 = call ptr @bn_from_u64(i64 %t10170)
%t10165.f1 = getelementptr i8, ptr %t10165, i64 8
store ptr %t10176, ptr %t10165.f1, align 8
ret ptr %t10165
}
define ptr @__m____________lib_sha256g_resid__sha256g_pad_at__rs143(i64 %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10177 = call ptr @resid_box_i64(i64 128)
%t10180 = call ptr @resid_listbuf_push(ptr %p3, ptr %t10177)
%t10181 = musttail call ptr @__m____________lib_sha256g_resid__sha256g_pad_at(i64 %p0, i64 %p1, i64 1, ptr %t10180)
ret ptr %t10181
}
define ptr @length_bytes__rs153(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10184 = alloca [1 x ptr]
%t10182 = ashr i64 %p0, 0
%t10183 = and i64 %t10182, 255
%t10186 = call ptr @resid_box_i64(i64 %t10183)
%t10188 = getelementptr i8, ptr %t10184, i64 0
store ptr %t10186, ptr %t10188
%t10189 = call ptr @resid_list_new(i64 1, ptr %t10184, ptr @.lty10184)
%t10190 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10189)
%t10191 = musttail call ptr @length_bytes(i64 %p0, i64 -1, ptr %t10190)
ret ptr %t10191
}
define ptr @length_bytes__rs152(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10194 = alloca [1 x ptr]
%t10192 = ashr i64 %p0, 8
%t10193 = and i64 %t10192, 255
%t10196 = call ptr @resid_box_i64(i64 %t10193)
%t10198 = getelementptr i8, ptr %t10194, i64 0
store ptr %t10196, ptr %t10198
%t10199 = call ptr @resid_list_new(i64 1, ptr %t10194, ptr @.lty10194)
%t10200 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10199)
%t10201 = musttail call ptr @length_bytes__rs153(i64 %p0, i64 0, ptr %t10200)
ret ptr %t10201
}
define ptr @length_bytes__rs151(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10204 = alloca [1 x ptr]
%t10202 = ashr i64 %p0, 16
%t10203 = and i64 %t10202, 255
%t10206 = call ptr @resid_box_i64(i64 %t10203)
%t10208 = getelementptr i8, ptr %t10204, i64 0
store ptr %t10206, ptr %t10208
%t10209 = call ptr @resid_list_new(i64 1, ptr %t10204, ptr @.lty10204)
%t10210 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10209)
%t10211 = musttail call ptr @length_bytes__rs152(i64 %p0, i64 1, ptr %t10210)
ret ptr %t10211
}
define ptr @length_bytes__rs150(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10214 = alloca [1 x ptr]
%t10212 = ashr i64 %p0, 24
%t10213 = and i64 %t10212, 255
%t10216 = call ptr @resid_box_i64(i64 %t10213)
%t10218 = getelementptr i8, ptr %t10214, i64 0
store ptr %t10216, ptr %t10218
%t10219 = call ptr @resid_list_new(i64 1, ptr %t10214, ptr @.lty10214)
%t10220 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10219)
%t10221 = musttail call ptr @length_bytes__rs151(i64 %p0, i64 2, ptr %t10220)
ret ptr %t10221
}
define ptr @length_bytes__rs149(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10224 = alloca [1 x ptr]
%t10222 = ashr i64 %p0, 32
%t10223 = and i64 %t10222, 255
%t10226 = call ptr @resid_box_i64(i64 %t10223)
%t10228 = getelementptr i8, ptr %t10224, i64 0
store ptr %t10226, ptr %t10228
%t10229 = call ptr @resid_list_new(i64 1, ptr %t10224, ptr @.lty10224)
%t10230 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10229)
%t10231 = musttail call ptr @length_bytes__rs150(i64 %p0, i64 3, ptr %t10230)
ret ptr %t10231
}
define ptr @length_bytes__rs148(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10234 = alloca [1 x ptr]
%t10232 = ashr i64 %p0, 40
%t10233 = and i64 %t10232, 255
%t10236 = call ptr @resid_box_i64(i64 %t10233)
%t10238 = getelementptr i8, ptr %t10234, i64 0
store ptr %t10236, ptr %t10238
%t10239 = call ptr @resid_list_new(i64 1, ptr %t10234, ptr @.lty10234)
%t10240 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10239)
%t10241 = musttail call ptr @length_bytes__rs149(i64 %p0, i64 4, ptr %t10240)
ret ptr %t10241
}
define ptr @length_bytes__rs147(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10244 = alloca [1 x ptr]
%t10242 = ashr i64 %p0, 48
%t10243 = and i64 %t10242, 255
%t10246 = call ptr @resid_box_i64(i64 %t10243)
%t10248 = getelementptr i8, ptr %t10244, i64 0
store ptr %t10246, ptr %t10248
%t10249 = call ptr @resid_list_new(i64 1, ptr %t10244, ptr @.lty10244)
%t10250 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10249)
%t10251 = musttail call ptr @length_bytes__rs148(i64 %p0, i64 5, ptr %t10250)
ret ptr %t10251
}
define ptr @length_bytes__rs146(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10254 = alloca [1 x ptr]
%t10252 = ashr i64 %p0, 56
%t10253 = and i64 %t10252, 255
%t10256 = call ptr @resid_box_i64(i64 %t10253)
%t10258 = getelementptr i8, ptr %t10254, i64 0
store ptr %t10256, ptr %t10258
%t10259 = call ptr @resid_list_new(i64 1, ptr %t10254, ptr @.lty10254)
%t10260 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10259)
%t10261 = musttail call ptr @length_bytes__rs147(i64 %p0, i64 6, ptr %t10260)
ret ptr %t10261
}
define ptr @sha_hw_words__rs174(i256 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10262 = lshr i256 %p0, 0
%t10263 = and i256 %t10262, 4294967295
%t10264 = trunc i256 %t10263 to i64
%t10265 = call ptr @resid_box_i64(i64 %t10264)
%t10268 = call ptr @resid_listbuf_push(ptr %p2, ptr %t10265)
%t10269 = call ptr @sha_hw_words(i256 %p0, i64 1, ptr %t10268)
ret ptr %t10269
}
define i64 @sched_w__rs184(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10270 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 0)
ret i64 %t10270
}
define i64 @sched_w__rs186(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10271 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 1)
ret i64 %t10271
}
define i64 @sched_w__rs188(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10272 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 2)
ret i64 %t10272
}
define i64 @sched_w__rs191(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10273 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 3)
ret i64 %t10273
}
define i64 @sched_w__rs194(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10274 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 4)
ret i64 %t10274
}
define i64 @sched_w__rs197(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10275 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 5)
ret i64 %t10275
}
define i64 @sched_w__rs200(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10276 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 6)
ret i64 %t10276
}
define i64 @sched_w__rs203(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10277 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 7)
ret i64 %t10277
}
define ptr @sha_blk__rs202(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10278 = call i64 @sched_w__rs203(ptr %p0, i64 %p1, i64 7, i64 0, i64 0, i64 %p21, i64 %p26)
%t10279 = call i64 @bsig1(i64 %p8)
%t10280 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10279)
%t10281 = extractvalue {i64, i1} %t10280, 0
%t10282 = extractvalue {i64, i1} %t10280, 1
%t10283 = zext i1 %t10282 to i8
call void @resid_overflow_check(i8 %t10283)
%t10284 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10285 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10281, i64 %t10284)
%t10286 = extractvalue {i64, i1} %t10285, 0
%t10287 = extractvalue {i64, i1} %t10285, 1
%t10288 = zext i1 %t10287 to i8
call void @resid_overflow_check(i8 %t10288)
%t10289 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10286, i64 -1424204075)
%t10290 = extractvalue {i64, i1} %t10289, 0
%t10291 = extractvalue {i64, i1} %t10289, 1
%t10292 = zext i1 %t10291 to i8
call void @resid_overflow_check(i8 %t10292)
%t10293 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10290, i64 %t10278)
%t10294 = extractvalue {i64, i1} %t10293, 0
%t10295 = extractvalue {i64, i1} %t10293, 1
%t10296 = zext i1 %t10295 to i8
call void @resid_overflow_check(i8 %t10296)
%t10297 = and i64 %t10294, 4294967295
%t10298 = call i64 @bsig0(i64 %p4)
%t10299 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10300 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10298, i64 %t10299)
%t10301 = extractvalue {i64, i1} %t10300, 0
%t10302 = extractvalue {i64, i1} %t10300, 1
%t10303 = zext i1 %t10302 to i8
call void @resid_overflow_check(i8 %t10303)
%t10304 = and i64 %t10301, 4294967295
%t10305 = add nsw i64 %t10297, %t10304
%t10306 = and i64 %t10305, 4294967295
%t10307 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10297)
%t10308 = extractvalue {i64, i1} %t10307, 0
%t10309 = extractvalue {i64, i1} %t10307, 1
%t10310 = zext i1 %t10309 to i8
call void @resid_overflow_check(i8 %t10310)
%t10311 = and i64 %t10308, 4294967295
%t10312 = musttail call ptr @sha_blk(ptr %p0, i64 %p1, i64 8, ptr %p3, i64 %t10306, i64 %p4, i64 %p5, i64 %p6, i64 %t10311, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10278)
ret ptr %t10312
}
define ptr @sha_blk__rs199(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10313 = call i64 @sched_w__rs200(ptr %p0, i64 %p1, i64 6, i64 0, i64 0, i64 0, i64 %p26)
%t10314 = call i64 @bsig1(i64 %p8)
%t10315 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10314)
%t10316 = extractvalue {i64, i1} %t10315, 0
%t10317 = extractvalue {i64, i1} %t10315, 1
%t10318 = zext i1 %t10317 to i8
call void @resid_overflow_check(i8 %t10318)
%t10319 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10320 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10316, i64 %t10319)
%t10321 = extractvalue {i64, i1} %t10320, 0
%t10322 = extractvalue {i64, i1} %t10320, 1
%t10323 = zext i1 %t10322 to i8
call void @resid_overflow_check(i8 %t10323)
%t10324 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10321, i64 -1841331548)
%t10325 = extractvalue {i64, i1} %t10324, 0
%t10326 = extractvalue {i64, i1} %t10324, 1
%t10327 = zext i1 %t10326 to i8
call void @resid_overflow_check(i8 %t10327)
%t10328 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10325, i64 %t10313)
%t10329 = extractvalue {i64, i1} %t10328, 0
%t10330 = extractvalue {i64, i1} %t10328, 1
%t10331 = zext i1 %t10330 to i8
call void @resid_overflow_check(i8 %t10331)
%t10332 = and i64 %t10329, 4294967295
%t10333 = call i64 @bsig0(i64 %p4)
%t10334 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10335 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10333, i64 %t10334)
%t10336 = extractvalue {i64, i1} %t10335, 0
%t10337 = extractvalue {i64, i1} %t10335, 1
%t10338 = zext i1 %t10337 to i8
call void @resid_overflow_check(i8 %t10338)
%t10339 = and i64 %t10336, 4294967295
%t10340 = add nsw i64 %t10332, %t10339
%t10341 = and i64 %t10340, 4294967295
%t10342 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10332)
%t10343 = extractvalue {i64, i1} %t10342, 0
%t10344 = extractvalue {i64, i1} %t10342, 1
%t10345 = zext i1 %t10344 to i8
call void @resid_overflow_check(i8 %t10345)
%t10346 = and i64 %t10343, 4294967295
%t10347 = musttail call ptr @sha_blk__rs202(ptr %p0, i64 %p1, i64 7, ptr %p3, i64 %t10341, i64 %p4, i64 %p5, i64 %p6, i64 %t10346, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10313)
ret ptr %t10347
}
define ptr @sha_blk__rs196(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10348 = call i64 @sched_w__rs197(ptr %p0, i64 %p1, i64 5, i64 0, i64 0, i64 0, i64 %p26)
%t10349 = call i64 @bsig1(i64 %p8)
%t10350 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10349)
%t10351 = extractvalue {i64, i1} %t10350, 0
%t10352 = extractvalue {i64, i1} %t10350, 1
%t10353 = zext i1 %t10352 to i8
call void @resid_overflow_check(i8 %t10353)
%t10354 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10355 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10351, i64 %t10354)
%t10356 = extractvalue {i64, i1} %t10355, 0
%t10357 = extractvalue {i64, i1} %t10355, 1
%t10358 = zext i1 %t10357 to i8
call void @resid_overflow_check(i8 %t10358)
%t10359 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10356, i64 1508970993)
%t10360 = extractvalue {i64, i1} %t10359, 0
%t10361 = extractvalue {i64, i1} %t10359, 1
%t10362 = zext i1 %t10361 to i8
call void @resid_overflow_check(i8 %t10362)
%t10363 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10360, i64 %t10348)
%t10364 = extractvalue {i64, i1} %t10363, 0
%t10365 = extractvalue {i64, i1} %t10363, 1
%t10366 = zext i1 %t10365 to i8
call void @resid_overflow_check(i8 %t10366)
%t10367 = and i64 %t10364, 4294967295
%t10368 = call i64 @bsig0(i64 %p4)
%t10369 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10370 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10368, i64 %t10369)
%t10371 = extractvalue {i64, i1} %t10370, 0
%t10372 = extractvalue {i64, i1} %t10370, 1
%t10373 = zext i1 %t10372 to i8
call void @resid_overflow_check(i8 %t10373)
%t10374 = and i64 %t10371, 4294967295
%t10375 = add nsw i64 %t10367, %t10374
%t10376 = and i64 %t10375, 4294967295
%t10377 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10367)
%t10378 = extractvalue {i64, i1} %t10377, 0
%t10379 = extractvalue {i64, i1} %t10377, 1
%t10380 = zext i1 %t10379 to i8
call void @resid_overflow_check(i8 %t10380)
%t10381 = and i64 %t10378, 4294967295
%t10382 = musttail call ptr @sha_blk__rs199(ptr %p0, i64 %p1, i64 6, ptr %p3, i64 %t10376, i64 %p4, i64 %p5, i64 %p6, i64 %t10381, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10348)
ret ptr %t10382
}
define ptr @sha_blk__rs193(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10383 = call i64 @sched_w__rs194(ptr %p0, i64 %p1, i64 4, i64 0, i64 0, i64 0, i64 %p26)
%t10384 = call i64 @bsig1(i64 %p8)
%t10385 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10384)
%t10386 = extractvalue {i64, i1} %t10385, 0
%t10387 = extractvalue {i64, i1} %t10385, 1
%t10388 = zext i1 %t10387 to i8
call void @resid_overflow_check(i8 %t10388)
%t10389 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10390 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10386, i64 %t10389)
%t10391 = extractvalue {i64, i1} %t10390, 0
%t10392 = extractvalue {i64, i1} %t10390, 1
%t10393 = zext i1 %t10392 to i8
call void @resid_overflow_check(i8 %t10393)
%t10394 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10391, i64 961987163)
%t10395 = extractvalue {i64, i1} %t10394, 0
%t10396 = extractvalue {i64, i1} %t10394, 1
%t10397 = zext i1 %t10396 to i8
call void @resid_overflow_check(i8 %t10397)
%t10398 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10395, i64 %t10383)
%t10399 = extractvalue {i64, i1} %t10398, 0
%t10400 = extractvalue {i64, i1} %t10398, 1
%t10401 = zext i1 %t10400 to i8
call void @resid_overflow_check(i8 %t10401)
%t10402 = and i64 %t10399, 4294967295
%t10403 = call i64 @bsig0(i64 %p4)
%t10404 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10405 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10403, i64 %t10404)
%t10406 = extractvalue {i64, i1} %t10405, 0
%t10407 = extractvalue {i64, i1} %t10405, 1
%t10408 = zext i1 %t10407 to i8
call void @resid_overflow_check(i8 %t10408)
%t10409 = and i64 %t10406, 4294967295
%t10410 = add nsw i64 %t10402, %t10409
%t10411 = and i64 %t10410, 4294967295
%t10412 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10402)
%t10413 = extractvalue {i64, i1} %t10412, 0
%t10414 = extractvalue {i64, i1} %t10412, 1
%t10415 = zext i1 %t10414 to i8
call void @resid_overflow_check(i8 %t10415)
%t10416 = and i64 %t10413, 4294967295
%t10417 = musttail call ptr @sha_blk__rs196(ptr %p0, i64 %p1, i64 5, ptr %p3, i64 %t10411, i64 %p4, i64 %p5, i64 %p6, i64 %t10416, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10383)
ret ptr %t10417
}
define ptr @sha_blk__rs190(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10418 = call i64 @sched_w__rs191(ptr %p0, i64 %p1, i64 3, i64 0, i64 0, i64 0, i64 %p26)
%t10419 = call i64 @bsig1(i64 %p8)
%t10420 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10419)
%t10421 = extractvalue {i64, i1} %t10420, 0
%t10422 = extractvalue {i64, i1} %t10420, 1
%t10423 = zext i1 %t10422 to i8
call void @resid_overflow_check(i8 %t10423)
%t10424 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10425 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10421, i64 %t10424)
%t10426 = extractvalue {i64, i1} %t10425, 0
%t10427 = extractvalue {i64, i1} %t10425, 1
%t10428 = zext i1 %t10427 to i8
call void @resid_overflow_check(i8 %t10428)
%t10429 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10426, i64 -373957723)
%t10430 = extractvalue {i64, i1} %t10429, 0
%t10431 = extractvalue {i64, i1} %t10429, 1
%t10432 = zext i1 %t10431 to i8
call void @resid_overflow_check(i8 %t10432)
%t10433 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10430, i64 %t10418)
%t10434 = extractvalue {i64, i1} %t10433, 0
%t10435 = extractvalue {i64, i1} %t10433, 1
%t10436 = zext i1 %t10435 to i8
call void @resid_overflow_check(i8 %t10436)
%t10437 = and i64 %t10434, 4294967295
%t10438 = call i64 @bsig0(i64 %p4)
%t10439 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10440 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10438, i64 %t10439)
%t10441 = extractvalue {i64, i1} %t10440, 0
%t10442 = extractvalue {i64, i1} %t10440, 1
%t10443 = zext i1 %t10442 to i8
call void @resid_overflow_check(i8 %t10443)
%t10444 = and i64 %t10441, 4294967295
%t10445 = add nsw i64 %t10437, %t10444
%t10446 = and i64 %t10445, 4294967295
%t10447 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10437)
%t10448 = extractvalue {i64, i1} %t10447, 0
%t10449 = extractvalue {i64, i1} %t10447, 1
%t10450 = zext i1 %t10449 to i8
call void @resid_overflow_check(i8 %t10450)
%t10451 = and i64 %t10448, 4294967295
%t10452 = musttail call ptr @sha_blk__rs193(ptr %p0, i64 %p1, i64 4, ptr %p3, i64 %t10446, i64 %p4, i64 %p5, i64 %p6, i64 %t10451, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p25, i64 %p26, i64 %p27, i64 %t10418)
ret ptr %t10452
}
define ptr @sha_blk__rs187(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10453 = call i64 @sched_w__rs188(ptr %p0, i64 %p1, i64 2, i64 0, i64 0, i64 0, i64 %p26)
%t10454 = call i64 @bsig1(i64 %p8)
%t10455 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10454)
%t10456 = extractvalue {i64, i1} %t10455, 0
%t10457 = extractvalue {i64, i1} %t10455, 1
%t10458 = zext i1 %t10457 to i8
call void @resid_overflow_check(i8 %t10458)
%t10459 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10460 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10456, i64 %t10459)
%t10461 = extractvalue {i64, i1} %t10460, 0
%t10462 = extractvalue {i64, i1} %t10460, 1
%t10463 = zext i1 %t10462 to i8
call void @resid_overflow_check(i8 %t10463)
%t10464 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10461, i64 -1245643825)
%t10465 = extractvalue {i64, i1} %t10464, 0
%t10466 = extractvalue {i64, i1} %t10464, 1
%t10467 = zext i1 %t10466 to i8
call void @resid_overflow_check(i8 %t10467)
%t10468 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10465, i64 %t10453)
%t10469 = extractvalue {i64, i1} %t10468, 0
%t10470 = extractvalue {i64, i1} %t10468, 1
%t10471 = zext i1 %t10470 to i8
call void @resid_overflow_check(i8 %t10471)
%t10472 = and i64 %t10469, 4294967295
%t10473 = call i64 @bsig0(i64 %p4)
%t10474 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10475 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10473, i64 %t10474)
%t10476 = extractvalue {i64, i1} %t10475, 0
%t10477 = extractvalue {i64, i1} %t10475, 1
%t10478 = zext i1 %t10477 to i8
call void @resid_overflow_check(i8 %t10478)
%t10479 = and i64 %t10476, 4294967295
%t10480 = add nsw i64 %t10472, %t10479
%t10481 = and i64 %t10480, 4294967295
%t10482 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10472)
%t10483 = extractvalue {i64, i1} %t10482, 0
%t10484 = extractvalue {i64, i1} %t10482, 1
%t10485 = zext i1 %t10484 to i8
call void @resid_overflow_check(i8 %t10485)
%t10486 = and i64 %t10483, 4294967295
%t10487 = musttail call ptr @sha_blk__rs190(ptr %p0, i64 %p1, i64 3, ptr %p3, i64 %t10481, i64 %p4, i64 %p5, i64 %p6, i64 %t10486, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p26, i64 %p27, i64 %t10453)
ret ptr %t10487
}
define ptr @sha_blk__rs185(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10488 = call i64 @sched_w__rs186(ptr %p0, i64 %p1, i64 1, i64 0, i64 0, i64 0, i64 0)
%t10489 = call i64 @bsig1(i64 %p8)
%t10490 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10489)
%t10491 = extractvalue {i64, i1} %t10490, 0
%t10492 = extractvalue {i64, i1} %t10490, 1
%t10493 = zext i1 %t10492 to i8
call void @resid_overflow_check(i8 %t10493)
%t10494 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10495 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10491, i64 %t10494)
%t10496 = extractvalue {i64, i1} %t10495, 0
%t10497 = extractvalue {i64, i1} %t10495, 1
%t10498 = zext i1 %t10497 to i8
call void @resid_overflow_check(i8 %t10498)
%t10499 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10496, i64 1899447441)
%t10500 = extractvalue {i64, i1} %t10499, 0
%t10501 = extractvalue {i64, i1} %t10499, 1
%t10502 = zext i1 %t10501 to i8
call void @resid_overflow_check(i8 %t10502)
%t10503 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10500, i64 %t10488)
%t10504 = extractvalue {i64, i1} %t10503, 0
%t10505 = extractvalue {i64, i1} %t10503, 1
%t10506 = zext i1 %t10505 to i8
call void @resid_overflow_check(i8 %t10506)
%t10507 = and i64 %t10504, 4294967295
%t10508 = call i64 @bsig0(i64 %p4)
%t10509 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10510 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10508, i64 %t10509)
%t10511 = extractvalue {i64, i1} %t10510, 0
%t10512 = extractvalue {i64, i1} %t10510, 1
%t10513 = zext i1 %t10512 to i8
call void @resid_overflow_check(i8 %t10513)
%t10514 = and i64 %t10511, 4294967295
%t10515 = add nsw i64 %t10507, %t10514
%t10516 = and i64 %t10515, 4294967295
%t10517 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10507)
%t10518 = extractvalue {i64, i1} %t10517, 0
%t10519 = extractvalue {i64, i1} %t10517, 1
%t10520 = zext i1 %t10519 to i8
call void @resid_overflow_check(i8 %t10520)
%t10521 = and i64 %t10518, 4294967295
%t10522 = musttail call ptr @sha_blk__rs187(ptr %p0, i64 %p1, i64 2, ptr %p3, i64 %t10516, i64 %p4, i64 %p5, i64 %p6, i64 %t10521, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p27, i64 %t10488)
ret ptr %t10522
}
define ptr @sha_blk__rs183(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10523 = call i64 @sched_w__rs184(ptr %p0, i64 %p1, i64 0, i64 0, i64 0, i64 0, i64 0)
%t10524 = call i64 @bsig1(i64 %p8)
%t10525 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10524)
%t10526 = extractvalue {i64, i1} %t10525, 0
%t10527 = extractvalue {i64, i1} %t10525, 1
%t10528 = zext i1 %t10527 to i8
call void @resid_overflow_check(i8 %t10528)
%t10529 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10530 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10526, i64 %t10529)
%t10531 = extractvalue {i64, i1} %t10530, 0
%t10532 = extractvalue {i64, i1} %t10530, 1
%t10533 = zext i1 %t10532 to i8
call void @resid_overflow_check(i8 %t10533)
%t10534 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10531, i64 1116352408)
%t10535 = extractvalue {i64, i1} %t10534, 0
%t10536 = extractvalue {i64, i1} %t10534, 1
%t10537 = zext i1 %t10536 to i8
call void @resid_overflow_check(i8 %t10537)
%t10538 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10535, i64 %t10523)
%t10539 = extractvalue {i64, i1} %t10538, 0
%t10540 = extractvalue {i64, i1} %t10538, 1
%t10541 = zext i1 %t10540 to i8
call void @resid_overflow_check(i8 %t10541)
%t10542 = and i64 %t10539, 4294967295
%t10543 = call i64 @bsig0(i64 %p4)
%t10544 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10545 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10543, i64 %t10544)
%t10546 = extractvalue {i64, i1} %t10545, 0
%t10547 = extractvalue {i64, i1} %t10545, 1
%t10548 = zext i1 %t10547 to i8
call void @resid_overflow_check(i8 %t10548)
%t10549 = and i64 %t10546, 4294967295
%t10550 = add nsw i64 %t10542, %t10549
%t10551 = and i64 %t10550, 4294967295
%t10552 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10542)
%t10553 = extractvalue {i64, i1} %t10552, 0
%t10554 = extractvalue {i64, i1} %t10552, 1
%t10555 = zext i1 %t10554 to i8
call void @resid_overflow_check(i8 %t10555)
%t10556 = and i64 %t10553, 4294967295
%t10557 = musttail call ptr @sha_blk__rs185(ptr %p0, i64 %p1, i64 1, ptr %p3, i64 %t10551, i64 %p4, i64 %p5, i64 %p6, i64 %t10556, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %t10523)
ret ptr %t10557
}
define ptr @hex_state__rs228(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10558 = call ptr @resid_list_get(ptr %p0, i64 1)
%t10559 = call i64 @resid_unbox_i64(ptr %t10558)
%t10561 = call ptr @hex_word(i64 %t10559)
%t10562 = call ptr @resid_str_concat(ptr %p2, ptr %t10561)
%t10563 = musttail call ptr @hex_state(ptr %p0, i64 2, ptr %t10562)
ret ptr %t10563
}
define ptr @hex_state__rs227(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10565 = call ptr @resid_list_get(ptr %p0, i64 0)
%t10566 = call i64 @resid_unbox_i64(ptr %t10565)
%t10568 = call ptr @hex_word(i64 %t10566)
%t10569 = call ptr @resid_str_concat(ptr @.s10564, ptr %t10568)
%t10570 = musttail call ptr @hex_state__rs228(ptr %p0, i64 1, ptr %t10569)
ret ptr %t10570
}
define ptr @wtb_inner__rs229(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10572 = alloca [1 x ptr]
%t10571 = call i64 @word_byte(ptr %p0, i64 %p1, i64 0)
%t10574 = call ptr @resid_box_i64(i64 %t10571)
%t10576 = getelementptr i8, ptr %t10572, i64 0
store ptr %t10574, ptr %t10576
%t10577 = call ptr @resid_list_new(i64 1, ptr %t10572, ptr @.lty10572)
%t10578 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t10577)
%t10579 = musttail call ptr @wtb_inner(ptr %p0, i64 %p1, i64 1, ptr %t10578)
ret ptr %t10579
}
define ptr @wtb_inner__rs232(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10581 = alloca [1 x ptr]
%t10580 = call i64 @word_byte(ptr %p0, i64 0, i64 0)
%t10583 = call ptr @resid_box_i64(i64 %t10580)
%t10585 = getelementptr i8, ptr %t10581, i64 0
store ptr %t10583, ptr %t10585
%t10586 = call ptr @resid_list_new(i64 1, ptr %t10581, ptr @.lty10581)
%t10587 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t10586)
%t10588 = musttail call ptr @wtb_inner(ptr %p0, i64 0, i64 1, ptr %t10587)
ret ptr %t10588
}
define ptr @wtb_outer__rs231(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10589 = call ptr @wtb_inner__rs232(ptr %p0, i64 0, i64 0, ptr %p2)
%t10590 = musttail call ptr @wtb_outer(ptr %p0, i64 1, ptr %t10589)
ret ptr %t10590
}
define i64 @pick__rs262(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p2
}
define ptr @w64__rs265(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10591 = and i64 %p1, 4294967295
%t10592 = alloca [2 x ptr]
%t10594 = call ptr @resid_box_i64(i64 0)
%t10596 = getelementptr i8, ptr %t10592, i64 0
store ptr %t10594, ptr %t10596
%t10597 = call ptr @resid_box_i64(i64 %t10591)
%t10599 = getelementptr i8, ptr %t10592, i64 8
store ptr %t10597, ptr %t10599
%t10600 = call ptr @resid_list_new(i64 2, ptr %t10592, ptr @.lty10592)
ret ptr %t10600
}
define i64 @shr_big__rs269(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10601 = ashr i64 %p0, 56
ret i64 %t10601
}
define i64 @shr_big__rs268(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10602 = ashr i64 %p0, 32
%t10603 = musttail call i64 @shr_big__rs269(i64 %t10602, i64 56)
ret i64 %t10603
}
define i64 @shr_big__rs267(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10604 = ashr i64 %p0, 32
%t10605 = musttail call i64 @shr_big__rs268(i64 %t10604, i64 88)
ret i64 %t10605
}
define i64 @shr_big__rs273(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10606 = ashr i64 %p0, 48
ret i64 %t10606
}
define i64 @shr_big__rs272(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10607 = ashr i64 %p0, 32
%t10608 = musttail call i64 @shr_big__rs273(i64 %t10607, i64 48)
ret i64 %t10608
}
define i64 @shr_big__rs271(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10609 = ashr i64 %p0, 32
%t10610 = musttail call i64 @shr_big__rs272(i64 %t10609, i64 80)
ret i64 %t10610
}
define i64 @shr_big__rs276(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10611 = ashr i64 %p0, 32
%t10612 = musttail call i64 @shr_big(i64 %t10611, i64 40)
ret i64 %t10612
}
define i64 @shr_big__rs275(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10613 = ashr i64 %p0, 32
%t10614 = musttail call i64 @shr_big__rs276(i64 %t10613, i64 72)
ret i64 %t10614
}
define ptr @len512_bytes__rs281(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10617 = alloca [1 x ptr]
%t10615 = call i64 @shr_big(i64 %p1, i64 64)
%t10616 = and i64 %t10615, 255
%t10619 = call ptr @resid_box_i64(i64 %t10616)
%t10621 = getelementptr i8, ptr %t10617, i64 0
store ptr %t10619, ptr %t10621
%t10622 = call ptr @resid_list_new(i64 1, ptr %t10617, ptr @.lty10617)
%t10623 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10622)
%t10624 = musttail call ptr @len512_bytes(ptr %t10623, i64 %p1, i64 7)
ret ptr %t10624
}
define ptr @len512_bytes__rs280(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10627 = alloca [1 x ptr]
%t10625 = call i64 @shr_big__rs276(i64 %p1, i64 72)
%t10626 = and i64 %t10625, 255
%t10629 = call ptr @resid_box_i64(i64 %t10626)
%t10631 = getelementptr i8, ptr %t10627, i64 0
store ptr %t10629, ptr %t10631
%t10632 = call ptr @resid_list_new(i64 1, ptr %t10627, ptr @.lty10627)
%t10633 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10632)
%t10634 = musttail call ptr @len512_bytes__rs281(ptr %t10633, i64 %p1, i64 8)
ret ptr %t10634
}
define ptr @len512_bytes__rs279(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10637 = alloca [1 x ptr]
%t10635 = call i64 @shr_big__rs272(i64 %p1, i64 80)
%t10636 = and i64 %t10635, 255
%t10639 = call ptr @resid_box_i64(i64 %t10636)
%t10641 = getelementptr i8, ptr %t10637, i64 0
store ptr %t10639, ptr %t10641
%t10642 = call ptr @resid_list_new(i64 1, ptr %t10637, ptr @.lty10637)
%t10643 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10642)
%t10644 = musttail call ptr @len512_bytes__rs280(ptr %t10643, i64 %p1, i64 9)
ret ptr %t10644
}
define ptr @len512_bytes__rs278(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10647 = alloca [1 x ptr]
%t10645 = call i64 @shr_big__rs268(i64 %p1, i64 88)
%t10646 = and i64 %t10645, 255
%t10649 = call ptr @resid_box_i64(i64 %t10646)
%t10651 = getelementptr i8, ptr %t10647, i64 0
store ptr %t10649, ptr %t10651
%t10652 = call ptr @resid_list_new(i64 1, ptr %t10647, ptr @.lty10647)
%t10653 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10652)
%t10654 = musttail call ptr @len512_bytes__rs279(ptr %t10653, i64 %p1, i64 10)
ret ptr %t10654
}
define ptr @len512_bytes__rs277(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10657 = alloca [1 x ptr]
%t10655 = call i64 @shr_big(i64 %p1, i64 96)
%t10656 = and i64 %t10655, 255
%t10659 = call ptr @resid_box_i64(i64 %t10656)
%t10661 = getelementptr i8, ptr %t10657, i64 0
store ptr %t10659, ptr %t10661
%t10662 = call ptr @resid_list_new(i64 1, ptr %t10657, ptr @.lty10657)
%t10663 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10662)
%t10664 = musttail call ptr @len512_bytes__rs278(ptr %t10663, i64 %p1, i64 11)
ret ptr %t10664
}
define ptr @len512_bytes__rs274(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10667 = alloca [1 x ptr]
%t10665 = call i64 @shr_big__rs275(i64 %p1, i64 104)
%t10666 = and i64 %t10665, 255
%t10669 = call ptr @resid_box_i64(i64 %t10666)
%t10671 = getelementptr i8, ptr %t10667, i64 0
store ptr %t10669, ptr %t10671
%t10672 = call ptr @resid_list_new(i64 1, ptr %t10667, ptr @.lty10667)
%t10673 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10672)
%t10674 = musttail call ptr @len512_bytes__rs277(ptr %t10673, i64 %p1, i64 12)
ret ptr %t10674
}
define ptr @len512_bytes__rs270(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10677 = alloca [1 x ptr]
%t10675 = call i64 @shr_big__rs271(i64 %p1, i64 112)
%t10676 = and i64 %t10675, 255
%t10679 = call ptr @resid_box_i64(i64 %t10676)
%t10681 = getelementptr i8, ptr %t10677, i64 0
store ptr %t10679, ptr %t10681
%t10682 = call ptr @resid_list_new(i64 1, ptr %t10677, ptr @.lty10677)
%t10683 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10682)
%t10684 = musttail call ptr @len512_bytes__rs274(ptr %t10683, i64 %p1, i64 13)
ret ptr %t10684
}
define ptr @len512_bytes__rs266(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10687 = alloca [1 x ptr]
%t10685 = call i64 @shr_big__rs267(i64 %p1, i64 120)
%t10686 = and i64 %t10685, 255
%t10689 = call ptr @resid_box_i64(i64 %t10686)
%t10691 = getelementptr i8, ptr %t10687, i64 0
store ptr %t10689, ptr %t10691
%t10692 = call ptr @resid_list_new(i64 1, ptr %t10687, ptr @.lty10687)
%t10693 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10692)
%t10694 = musttail call ptr @len512_bytes__rs270(ptr %t10693, i64 %p1, i64 14)
ret ptr %t10694
}
define ptr @mw512_acc__rs282(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10695 = call ptr @mw512(ptr %p0, i64 %p1, i64 0)
%t10696 = call ptr @resid_list_freeze(ptr %t10695)
%t10697 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t10696)
%t10698 = musttail call ptr @mw512_acc(ptr %p0, i64 %p1, i64 1, ptr %t10697)
ret ptr %t10698
}
define ptr @w64_rotr__rs284(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10699 = musttail call ptr @w64_rotr_small(ptr %p0, i64 1)
ret ptr %t10699
}
define ptr @w64_rotr__rs286(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10700 = musttail call ptr @w64_rotr_small(ptr %p0, i64 8)
ret ptr %t10700
}
define ptr @w64_shr__rs288(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10701 = musttail call ptr @w64_shr_small(ptr %p0, i64 7)
ret ptr %t10701
}
define ptr @w64_rotr__rs290(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10702 = musttail call ptr @w64_rotr_small(ptr %p0, i64 19)
ret ptr %t10702
}
define ptr @w64_rotr__rs292(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10703 = call i64 @w64_lo(ptr %p0)
%t10704 = call i64 @w64_hi(ptr %p0)
%t10705 = call ptr @w64(i64 %t10703, i64 %t10704)
%t10706 = musttail call ptr @w64_rotr_small(ptr %t10705, i64 29)
ret ptr %t10706
}
define ptr @w64_shr__rs294(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10707 = musttail call ptr @w64_shr_small(ptr %p0, i64 6)
ret ptr %t10707
}
define ptr @w64_rotr__rs296(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10708 = musttail call ptr @w64_rotr_small(ptr %p0, i64 28)
ret ptr %t10708
}
define ptr @w64_rotr__rs298(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10709 = call i64 @w64_lo(ptr %p0)
%t10710 = call i64 @w64_hi(ptr %p0)
%t10711 = call ptr @w64(i64 %t10709, i64 %t10710)
%t10712 = musttail call ptr @w64_rotr_small(ptr %t10711, i64 2)
ret ptr %t10712
}
define ptr @w64_rotr__rs300(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10713 = call i64 @w64_lo(ptr %p0)
%t10714 = call i64 @w64_hi(ptr %p0)
%t10715 = call ptr @w64(i64 %t10713, i64 %t10714)
%t10716 = musttail call ptr @w64_rotr_small(ptr %t10715, i64 7)
ret ptr %t10716
}
define ptr @w64_rotr__rs302(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10717 = musttail call ptr @w64_rotr_small(ptr %p0, i64 14)
ret ptr %t10717
}
define i64 @fw_hi__rs305(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10718 = call ptr @resid_list_get(ptr %p0, i64 0)
%t10719 = call i64 @resid_unbox_i64(ptr %t10718)
ret i64 %t10719
}
define i64 @fw_lo__rs306(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10721 = call ptr @resid_list_get(ptr %p0, i64 1)
%t10722 = call i64 @resid_unbox_i64(ptr %t10721)
ret i64 %t10722
}
define i64 @fw_hi__rs308(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10724 = call ptr @resid_list_get(ptr %p0, i64 2)
%t10725 = call i64 @resid_unbox_i64(ptr %t10724)
ret i64 %t10725
}
define i64 @fw_lo__rs309(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10727 = call ptr @resid_list_get(ptr %p0, i64 3)
%t10728 = call i64 @resid_unbox_i64(ptr %t10727)
ret i64 %t10728
}
define i64 @fw_hi__rs311(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10730 = call ptr @resid_list_get(ptr %p0, i64 4)
%t10731 = call i64 @resid_unbox_i64(ptr %t10730)
ret i64 %t10731
}
define i64 @fw_lo__rs312(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10733 = call ptr @resid_list_get(ptr %p0, i64 5)
%t10734 = call i64 @resid_unbox_i64(ptr %t10733)
ret i64 %t10734
}
define i64 @fw_hi__rs314(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10736 = call ptr @resid_list_get(ptr %p0, i64 6)
%t10737 = call i64 @resid_unbox_i64(ptr %t10736)
ret i64 %t10737
}
define i64 @fw_lo__rs315(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10739 = call ptr @resid_list_get(ptr %p0, i64 7)
%t10740 = call i64 @resid_unbox_i64(ptr %t10739)
ret i64 %t10740
}
define i64 @fw_hi__rs317(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10742 = call ptr @resid_list_get(ptr %p0, i64 8)
%t10743 = call i64 @resid_unbox_i64(ptr %t10742)
ret i64 %t10743
}
define i64 @fw_lo__rs318(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10745 = call ptr @resid_list_get(ptr %p0, i64 9)
%t10746 = call i64 @resid_unbox_i64(ptr %t10745)
ret i64 %t10746
}
define i64 @fw_hi__rs320(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10748 = call ptr @resid_list_get(ptr %p0, i64 10)
%t10749 = call i64 @resid_unbox_i64(ptr %t10748)
ret i64 %t10749
}
define i64 @fw_lo__rs321(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10751 = call ptr @resid_list_get(ptr %p0, i64 11)
%t10752 = call i64 @resid_unbox_i64(ptr %t10751)
ret i64 %t10752
}
define i64 @fw_hi__rs323(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10754 = call ptr @resid_list_get(ptr %p0, i64 12)
%t10755 = call i64 @resid_unbox_i64(ptr %t10754)
ret i64 %t10755
}
define i64 @fw_lo__rs324(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10757 = call ptr @resid_list_get(ptr %p0, i64 13)
%t10758 = call i64 @resid_unbox_i64(ptr %t10757)
ret i64 %t10758
}
define i64 @fw_hi__rs326(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10760 = call ptr @resid_list_get(ptr %p0, i64 14)
%t10761 = call i64 @resid_unbox_i64(ptr %t10760)
ret i64 %t10761
}
define i64 @fw_lo__rs327(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10763 = call ptr @resid_list_get(ptr %p0, i64 15)
%t10764 = call i64 @resid_unbox_i64(ptr %t10763)
ret i64 %t10764
}
define ptr @sha512_rounds_flat__rs330(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10766 = call ptr @sha512_round_flat(ptr %p0, ptr %p1, i64 0)
%t10767 = musttail call ptr @sha512_rounds_flat(ptr %t10766, ptr %p1, i64 1)
ret ptr %t10767
}
define ptr @add_st_acc__rs334(ptr %p0, ptr %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10768 = call ptr @add_st_word(ptr %p0, ptr %p1, i64 0)
%t10769 = call ptr @resid_list_freeze(ptr %t10768)
%t10770 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t10769)
%t10771 = musttail call ptr @add_st_acc(ptr %p0, ptr %p1, i64 1, ptr %t10770)
ret ptr %t10771
}
define i64 @w64_bytes__rs344(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10772 = add nsw i64 %p1, 0
%t10773 = call ptr @resid_list_get(ptr %p0, i64 %t10772)
%t10774 = call i64 @resid_unbox_i64(ptr %t10773)
%t10776 = and i64 %t10774, 255
%t10777 = or i64 0, %t10776
%t10778 = musttail call i64 @w64_bytes(ptr %p0, i64 %p1, i64 1, i64 %t10777)
ret i64 %t10778
}
define i64 @sched64__rs347(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10779 = call i64 @word64_at(ptr %p0, i64 %p1, i64 0)
ret i64 %t10779
}
define i64 @sched64__rs350(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10780 = call i64 @word64_at(ptr %p0, i64 %p1, i64 1)
ret i64 %t10780
}
define i64 @sched64__rs353(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10781 = call i64 @word64_at(ptr %p0, i64 %p1, i64 2)
ret i64 %t10781
}
define i64 @sched64__rs356(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10782 = call i64 @word64_at(ptr %p0, i64 %p1, i64 3)
ret i64 %t10782
}
define i64 @sched64__rs359(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10783 = call i64 @word64_at(ptr %p0, i64 %p1, i64 4)
ret i64 %t10783
}
define i64 @sched64__rs362(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10784 = call i64 @word64_at(ptr %p0, i64 %p1, i64 5)
ret i64 %t10784
}
define i64 @sched64__rs365(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10785 = call i64 @word64_at(ptr %p0, i64 %p1, i64 6)
ret i64 %t10785
}
define i64 @sched64__rs368(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10786 = call i64 @word64_at(ptr %p0, i64 %p1, i64 7)
ret i64 %t10786
}
define ptr @be64_push__rs380(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10787 = lshr i64 %p0, 56
%t10788 = and i64 %t10787, 255
%t10789 = call ptr @resid_box_i64(i64 %t10788)
%t10792 = call ptr @resid_listbuf_push(ptr %p2, ptr %t10789)
%t10793 = musttail call ptr @be64_push(i64 %p0, i64 1, ptr %t10792)
ret ptr %t10793
}
define ptr @__m____________lib_crypto_resid__sha1_words16__rs394(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10795 = alloca [1 x ptr]
%t10794 = call i64 @__m____________lib_crypto_resid__sha1_word(ptr %p0, i64 %p1, i64 0)
%t10797 = call ptr @resid_box_i64(i64 %t10794)
%t10799 = getelementptr i8, ptr %t10795, i64 0
store ptr %t10797, ptr %t10799
%t10800 = call ptr @resid_list_new(i64 1, ptr %t10795, ptr @.lty10795)
%t10801 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t10800)
%t10802 = musttail call ptr @__m____________lib_crypto_resid__sha1_words16(ptr %p0, i64 %p1, i64 1, ptr %t10801)
ret ptr %t10802
}
define i64 @__m____________lib_crypto_resid__sha1_f__rs398(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10803 = and i64 %p1, %p2
%t10804 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 4294967295, i64 %p1)
%t10805 = extractvalue {i64, i1} %t10804, 0
%t10806 = extractvalue {i64, i1} %t10804, 1
%t10807 = zext i1 %t10806 to i8
call void @resid_overflow_check(i8 %t10807)
%t10808 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t10805)
%t10809 = and i64 %t10808, %p3
%t10810 = or i64 %t10803, %t10809
%t10811 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t10810)
ret i64 %t10811
}
define ptr @cbe_ascii(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10812 = call ptr @resid_sacc_from(ptr %p2)
%t10813 = musttail call ptr @cbe_ascii__sacc(ptr %p0, i64 %p1, ptr %t10812)
ret ptr %t10813
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
@.lty5998 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6297 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6380 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6427 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6486 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6543 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6562 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty6829 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6837 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6871 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty6890 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6901 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6911 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6923 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6933 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6942 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB7018 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty7111 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB7119 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty7122 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7122 = private global ptr null
@.lcd7122 = private unnamed_addr constant [12 x i64] [i64 132, i64 106, i64 83, i64 105, i64 103, i64 110, i64 97, i64 116, i64 117, i64 114, i64 101, i64 49]
@.lty7125 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty7131 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7131 = private global ptr null
@.lcd7131 = private unnamed_addr constant [4 x i64] [i64 162, i64 1, i64 39, i64 4]
@.ltyB7134 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.s7136 = private unnamed_addr constant [1 x i8] c"\00"
@.s7146 = private unnamed_addr constant [1 x i8] c"\00"
@.s7153 = private unnamed_addr constant [1 x i8] c"\00"
@.s7158 = private unnamed_addr constant [1 x i8] c"\00"
@.s7165 = private unnamed_addr constant [1 x i8] c"\00"
@.s7184 = private unnamed_addr constant [1 x i8] c"\00"
@.s7211 = private unnamed_addr constant [1 x i8] c"\00"
@.s7247 = private unnamed_addr constant [21 x i8] c"cose: missing tag 18\00"
@.s7265 = private unnamed_addr constant [24 x i8] c"cose: expected array(4)\00"
@.s7273 = private unnamed_addr constant [27 x i8] c"cose: bad protected header\00"
@.s7291 = private unnamed_addr constant [37 x i8] c"cose: expected empty unprotected map\00"
@.s7299 = private unnamed_addr constant [18 x i8] c"cose: bad payload\00"
@.s7313 = private unnamed_addr constant [20 x i8] c"cose: bad signature\00"
@.s7316 = private unnamed_addr constant [1 x i8] c"\00"
@.lty7335 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty7337 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7337 = private global ptr null
@.lcd7337 = private unnamed_addr constant [10 x i64] [i64 131, i64 104, i64 69, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48]
@.lty7341 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7341 = private global ptr null
@.lcd7341 = private unnamed_addr constant [4 x i64] [i64 161, i64 1, i64 24, i64 24]
@.lty7343 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7343 = private global ptr null
@.lcd7343 = private unnamed_addr constant [25 x i64] [i64 114, i64 101, i64 115, i64 105, i64 100, i64 47, i64 99, i64 111, i64 115, i64 101, i64 47, i64 101, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48, i64 47, i64 110, i64 111, i64 110, i64 99, i64 101]
@.lty7354 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7354 = private global ptr null
@.lcd7354 = private unnamed_addr constant [16 x i64] [i64 131, i64 104, i64 69, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48, i64 68, i64 161, i64 1, i64 24, i64 24, i64 64]
@.lty7358 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7358 = private global ptr null
@.lcd7358 = private unnamed_addr constant [9 x i64] [i64 208, i64 131, i64 68, i64 161, i64 1, i64 24, i64 24, i64 161, i64 5]
@.ltyB7362 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.s7391 = private unnamed_addr constant [21 x i8] c"cose: missing tag 16\00"
@.s7409 = private unnamed_addr constant [24 x i8] c"cose: expected array(3)\00"
@.s7417 = private unnamed_addr constant [27 x i8] c"cose: bad protected header\00"
@.s7435 = private unnamed_addr constant [34 x i8] c"cose: expected unprotected map(1)\00"
@.s7453 = private unnamed_addr constant [24 x i8] c"cose: expected iv key 5\00"
@.s7467 = private unnamed_addr constant [26 x i8] c"cose: iv must be 12 bytes\00"
@.s7481 = private unnamed_addr constant [21 x i8] c"cose: bad ciphertext\00"
@.s7494 = private unnamed_addr constant [28 x i8] c"cose: authentication failed\00"
@.s7504 = private unnamed_addr constant [1 x i8] c"\00"
@.lty7518 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty7727 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7727 = private global ptr null
@.lcd7727 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty7738 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7738 = private global ptr null
@.lcd7738 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty7742 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.lty7752 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7752 = private global ptr null
@.lcd7752 = private unnamed_addr constant [1 x i64] [i64 5]
@.lty7762 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7762 = private global ptr null
@.lcd7762 = private unnamed_addr constant [1 x i64] [i64 3]
@.s7768 = private unnamed_addr constant [6 x i8] c"check\00"
@.lty7771 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7771 = private global ptr null
@.lcd7771 = private unnamed_addr constant [1 x i64] [i64 5]
@.lty7775 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7775 = private global ptr null
@.lcd7775 = private unnamed_addr constant [1 x i64] [i64 5]
@resid.cap.main = unnamed_addr constant [5 x i8] c"args\00"
@resid.cap.main.1 = unnamed_addr constant [5 x i8] c"args\00"
@resid.cap.main.2 = unnamed_addr constant [5 x i8] c"args\00"
@.s7787 = private unnamed_addr constant [5 x i8] c"same\00"
@.s7788 = private unnamed_addr constant [10 x i8] c"DIFFERENT\00"
@.ltyB7844 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty8059 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.oty8092 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox8092 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty8092}, align 16
@.oty8113 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox8113 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty8113}, align 16
@.oty8116 = private unnamed_addr constant [18 x i8] c"Option(List(Int))\00"
@.lty8152 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8197 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8276 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8370 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty8404 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8496 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8537 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB8575 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty8576 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8582 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8582 = private global ptr null
@.lcd8582 = private unnamed_addr constant [1 x i64] [i64 0]
@.lty8624 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8646 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8744 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8921 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9030 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9738 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10139 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10141 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.s10152 = private unnamed_addr constant [28 x i8] c"bn_divmod: division by zero\00"
@.lty10154 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.ltyE10163 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10166 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10184 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10194 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10204 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10214 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10224 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10234 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10244 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10254 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.s10564 = private unnamed_addr constant [1 x i8] c"\00"
@.lty10572 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10581 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10592 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10617 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10627 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10637 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10647 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10657 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10667 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10677 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10687 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10795 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
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
