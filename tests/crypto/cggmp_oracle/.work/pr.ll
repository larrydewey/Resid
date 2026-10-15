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
%t1137 = getelementptr i8, ptr %p0, i64 8
%t1138 = load i64, ptr %t1137, align 8
%t1139 = icmp sle i64 %t1138, 32
br i1 %t1139, label %L181, label %L183
L181:
%t1140 = getelementptr i8, ptr %p0, i64 0
%t1141 = load ptr, ptr %t1140, align 8
%t1142 = getelementptr i8, ptr %p0, i64 8
%t1143 = load i64, ptr %t1142, align 8
%t1144 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t1143, i64 64)
%t1145 = extractvalue {i64, i1} %t1144, 0
%t1146 = extractvalue {i64, i1} %t1144, 1
%t1147 = zext i1 %t1146 to i8
call void @resid_overflow_check(i8 %t1147)
%t1148 = call ptr @__m____________lib_bignum_resid__bn_native_exp(ptr %p1, ptr %p2, ptr %t1141, i64 %t1145)
ret ptr %t1148
L183:
%t1149 = getelementptr i8, ptr %p0, i64 8
%t1150 = load i64, ptr %t1149, align 8
%t1151 = icmp sle i64 %t1150, 64
br i1 %t1151, label %L184, label %L186
L184:
%t1152 = getelementptr i8, ptr %p0, i64 0
%t1153 = load ptr, ptr %t1152, align 8
%t1154 = getelementptr i8, ptr %p0, i64 8
%t1155 = load i64, ptr %t1154, align 8
%t1156 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t1155, i64 64)
%t1157 = extractvalue {i64, i1} %t1156, 0
%t1158 = extractvalue {i64, i1} %t1156, 1
%t1159 = zext i1 %t1158 to i8
call void @resid_overflow_check(i8 %t1159)
%t1160 = call ptr @__m____________lib_bignum_resid__bn_native_exp(ptr %p1, ptr %p2, ptr %t1153, i64 %t1157)
ret ptr %t1160
L186:
%t1161 = musttail call ptr @__m____________lib_bignum_resid__bn_modexp_lists(ptr %p0, ptr %p1, ptr %p2)
ret ptr %t1161
}
define ptr @__m____________lib_bignum_resid__bn_modexp_lists(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1162 = getelementptr i8, ptr %p0, i64 24
%t1163 = load ptr, ptr %t1162, align 8
%t1164 = call ptr @__m____________lib_bignum_resid__bn_mont_mul(ptr %p0, ptr %p1, ptr %t1163)
%t1166 = call ptr @resid_list_const_i64(ptr @.lc1165, i64 1, ptr @.lcd1165, ptr @.lty1165)
%t1167 = getelementptr i8, ptr %p0, i64 24
%t1168 = load ptr, ptr %t1167, align 8
%t1169 = call ptr @__m____________lib_bignum_resid__bn_mont_mul(ptr %p0, ptr %t1166, ptr %t1168)
%t1170 = call ptr @resid_list_freeze(ptr %t1169)
%t1171 = call i64 @bn_bit_len(ptr %p2)
%t1172 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t1171, i64 1)
%t1173 = extractvalue {i64, i1} %t1172, 0
%t1174 = extractvalue {i64, i1} %t1172, 1
%t1175 = zext i1 %t1174 to i8
call void @resid_overflow_check(i8 %t1175)
%t1176 = call ptr @__m____________lib_bignum_resid__bn_exp_bits(ptr %p0, ptr %t1164, ptr %p2, i64 %t1173, ptr %t1170)
%t1177 = call ptr @resid_list_freeze(ptr %t1176)
%t1178 = call ptr @__m____________lib_bignum_resid__bn_redc(ptr %p0, ptr %t1177)
ret ptr %t1178
}
define ptr @__m____________lib_bignum_resid__bn_exp_bits(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1186, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t1185, %tco.s0 ]
%t1179 = icmp slt i64 %p3, 0
br i1 %t1179, label %L187, label %L189
L187:
ret ptr %p4
L189:
%t1180 = call ptr @__m____________lib_bignum_resid__bn_mont_mul(ptr %p0, ptr %p4, ptr %p4)
%t1181 = call i64 @bn_bit(ptr %p2, i64 %p3)
%t1182 = icmp eq i64 %t1181, 1
br i1 %t1182, label %L190, label %L191
L190:
%t1183 = call ptr @__m____________lib_bignum_resid__bn_mont_mul(ptr %p0, ptr %t1180, ptr %p1)
%t1184 = call ptr @resid_list_freeze(ptr %t1183)
br label %L192
L191:
br label %L192
L192:
%t1185 = phi ptr [ %t1184, %L190 ], [ %t1180, %L191 ]
%t1186 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_modexp(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1188 = call i1 @bn_is_odd(ptr %p2)
br i1 %t1188, label %L193, label %L195
L193:
%t1189 = call ptr @bn_mont_new(ptr %p2)
%t1190 = call ptr @bn_mod(ptr %p0, ptr %p2)
%t1191 = musttail call ptr @bn_modexp_mont(ptr %t1189, ptr %t1190, ptr %p1)
ret ptr %t1191
L195:
%t1192 = call ptr @bn_mod(ptr %p0, ptr %p2)
%t1193 = call i64 @bn_bit_len(ptr %p1)
%t1194 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t1193, i64 1)
%t1195 = extractvalue {i64, i1} %t1194, 0
%t1196 = extractvalue {i64, i1} %t1194, 1
%t1197 = zext i1 %t1196 to i8
call void @resid_overflow_check(i8 %t1197)
%t1199 = call ptr @resid_list_const_i64(ptr @.lc1198, i64 1, ptr @.lcd1198, ptr @.lty1198)
%t1200 = call ptr @bn_mod(ptr %t1199, ptr %p2)
%t1201 = call ptr @__m____________lib_bignum_resid__bn_modexp_plain(ptr %t1192, ptr %p1, ptr %p2, i64 %t1195, ptr %t1200)
ret ptr %t1201
}
define ptr @__m____________lib_bignum_resid__bn_modexp_plain(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1204, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t1209, %tco.s0 ]
%t1202 = icmp slt i64 %p3, 0
br i1 %t1202, label %L196, label %L198
L196:
ret ptr %p4
L198:
%t1203 = call ptr @bn_modmul(ptr %p4, ptr %p4, ptr %p2)
%t1204 = sub nsw i64 %p3, 1
%t1205 = call i64 @bn_bit(ptr %p1, i64 %p3)
%t1206 = icmp eq i64 %t1205, 1
br i1 %t1206, label %L199, label %L200
L199:
%t1207 = call ptr @bn_modmul(ptr %t1203, ptr %p0, ptr %p2)
%t1208 = call ptr @resid_list_freeze(ptr %t1207)
br label %L201
L200:
br label %L201
L201:
%t1209 = phi ptr [ %t1208, %L199 ], [ %t1203, %L200 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @bn_miller_rabin(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1211 = call ptr @bn_mont_new(ptr %p0)
%t1213 = call ptr @resid_list_const_i64(ptr @.lc1212, i64 1, ptr @.lcd1212, ptr @.lty1212)
%t1214 = call ptr @bn_sub(ptr %p0, ptr %t1213)
%t1215 = call i64 @__m____________lib_bignum_resid__bn_trailing_zeros(ptr %t1214, i64 0)
%t1216 = call ptr @bn_shr(ptr %t1214, i64 %t1215)
%t1217 = call i1 @__m____________lib_bignum_resid__bn_mr_each(ptr %t1211, ptr %t1214, ptr %t1216, i64 %t1215, ptr %p1, i64 0)
ret i1 %t1217
}
define i64 @__m____________lib_bignum_resid__bn_trailing_zeros(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1225, %tco.s0 ]
%t1218 = call i64 @bn_bit(ptr %p0, i64 %p1)
%t1219 = icmp eq i64 %t1218, 1
br label %LSL1220
LSL1220:
br i1 %t1219, label %LSJ1220, label %LSR1220
LSR1220:
%t1221 = call i64 @bn_bit_len(ptr %p0)
%t1222 = icmp sgt i64 %p1, %t1221
br label %LSJ1220
LSJ1220:
%t1223 = phi i1 [ true, %LSL1220 ], [ %t1222, %LSR1220 ]
br i1 %t1223, label %L202, label %L204
L202:
ret i64 %p1
L204:
%t1224 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t1225 = extractvalue {i64, i1} %t1224, 0
%t1226 = extractvalue {i64, i1} %t1224, 1
%t1227 = zext i1 %t1226 to i8
call void @resid_overflow_check(i8 %t1227)
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
%p5 = phi i64 [ %p5.in, %entry ], [ %t1236, %tco.s0.k ]
%t1229 = call i64 @resid_list_len(ptr %p4)
%t1230 = icmp sge i64 %p5, %t1229
br i1 %t1230, label %L205, label %L207
L205:
call void @resid_scope_pop(i64 %lml)
ret i1 true
L207:
%t1231 = call ptr @resid_list_get_v(ptr %p4, i64 %p5, ptr %p4.ld, i64 %p4.ln)
%t1234 = call i1 @__m____________lib_bignum_resid__bn_mr_witness(ptr %p0, ptr %p1, ptr %p2, i64 %p3, ptr %t1231)
%t1235 = xor i1 %t1234, true
br i1 %t1235, label %L208, label %L210
L208:
call void @resid_scope_pop(i64 %lml)
ret i1 false
L210:
%t1236 = add nsw i64 %p5, 1
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
%t1238 = getelementptr i8, ptr %p0, i64 0
%t1239 = load ptr, ptr %t1238, align 8
%t1240 = call ptr @bn_mod(ptr %p4, ptr %t1239)
%t1241 = call ptr @bn_modexp_mont(ptr %p0, ptr %t1240, ptr %p2)
%t1243 = call ptr @resid_list_const_i64(ptr @.lc1242, i64 1, ptr @.lcd1242, ptr @.lty1242)
%t1244 = call i64 @bn_cmp(ptr %t1241, ptr %t1243)
%t1245 = icmp eq i64 %t1244, 0
br label %LSL1246
LSL1246:
br i1 %t1245, label %LSJ1246, label %LSR1246
LSR1246:
%t1247 = call i64 @bn_cmp(ptr %t1241, ptr %p1)
%t1248 = icmp eq i64 %t1247, 0
br label %LSJ1246
LSJ1246:
%t1249 = phi i1 [ true, %LSL1246 ], [ %t1248, %LSR1246 ]
br i1 %t1249, label %L211, label %L213
L211:
ret i1 true
L213:
%t1250 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p3, i64 1)
%t1251 = extractvalue {i64, i1} %t1250, 0
%t1252 = extractvalue {i64, i1} %t1250, 1
%t1253 = zext i1 %t1252 to i8
call void @resid_overflow_check(i8 %t1253)
%t1254 = call i1 @__m____________lib_bignum_resid__bn_mr_square(ptr %p0, ptr %p1, ptr %t1241, i64 %t1251)
ret i1 %t1254
}
define i1 @__m____________lib_bignum_resid__bn_mr_square(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t1258, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1265, %tco.s0 ]
%t1255 = icmp sle i64 %p3, 0
br i1 %t1255, label %L214, label %L216
L214:
ret i1 false
L216:
%t1256 = getelementptr i8, ptr %p0, i64 0
%t1257 = load ptr, ptr %t1256, align 8
%t1258 = call ptr @bn_modmul(ptr %p2, ptr %p2, ptr %t1257)
%t1259 = call i64 @bn_cmp(ptr %t1258, ptr %p1)
%t1260 = icmp eq i64 %t1259, 0
br i1 %t1260, label %L217, label %L219
L217:
ret i1 true
L219:
%t1262 = call ptr @resid_list_const_i64(ptr @.lc1261, i64 1, ptr @.lcd1261, ptr @.lty1261)
%t1263 = call i64 @bn_cmp(ptr %t1258, ptr %t1262)
%t1264 = icmp eq i64 %t1263, 0
br i1 %t1264, label %L220, label %L222
L220:
ret i1 false
L222:
%t1265 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_small_primes(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1267 = call ptr @resid_listbuf_new()
%t1268 = call ptr @__m____________lib_bignum_resid__bn_sp_from(i64 %p0, i64 3, ptr %t1267)
ret ptr %t1268
}
define ptr @__m____________lib_bignum_resid__bn_sp_from(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1278, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t1276, %tco.s0 ]
%t1269 = icmp sgt i64 %p1, %p0
br i1 %t1269, label %L223, label %L225
L223:
%t1270 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty1270)
ret ptr %t1270
L225:
%t1271 = call i1 @__m____________lib_bignum_resid__bn_sp_is_prime(i64 %p1, i64 3)
br i1 %t1271, label %L226, label %L227
L226:
%t1272 = call ptr @resid_box_i64(i64 %p1)
%t1275 = call ptr @resid_listbuf_push(ptr %p2, ptr %t1272)
br label %L228
L227:
br label %L228
L228:
%t1276 = phi ptr [ %t1275, %L226 ], [ %p2, %L227 ]
%t1277 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t1278 = extractvalue {i64, i1} %t1277, 0
%t1279 = extractvalue {i64, i1} %t1277, 1
%t1280 = zext i1 %t1279 to i8
call void @resid_overflow_check(i8 %t1280)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @__m____________lib_bignum_resid__bn_sp_is_prime(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1297, %tco.s0 ]
%t1282 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 %p1)
%t1283 = extractvalue {i64, i1} %t1282, 0
%t1284 = extractvalue {i64, i1} %t1282, 1
%t1285 = zext i1 %t1284 to i8
call void @resid_overflow_check(i8 %t1285)
%t1286 = icmp sgt i64 %t1283, %p0
br i1 %t1286, label %L229, label %L231
L229:
ret i1 true
L231:
%t1287 = icmp eq i64 %p1, 0
%t1288 = zext i1 %t1287 to i8
call void @resid_div_check(i8 %t1288)
%t1289 = icmp eq i64 %p1, -1
%t1290 = icmp eq i64 %p0, -9223372036854775808
%t1291 = and i1 %t1289, %t1290
%t1292 = select i1 %t1289, i64 1, i64 %p1
%t1293 = srem i64 %p0, %t1292
%t1295 = icmp eq i64 %t1293, 0
br i1 %t1295, label %L232, label %L234
L232:
ret i1 false
L234:
%t1296 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t1297 = extractvalue {i64, i1} %t1296, 0
%t1298 = extractvalue {i64, i1} %t1296, 1
%t1299 = zext i1 %t1298 to i8
call void @resid_overflow_check(i8 %t1299)
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
%t1301 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 1)
%t1302 = extractvalue {i64, i1} %t1301, 0
%t1303 = extractvalue {i64, i1} %t1301, 1
%t1304 = zext i1 %t1303 to i8
call void @resid_overflow_check(i8 %t1304)
%t1305 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t1302, i64 7)
%t1306 = extractvalue {i64, i1} %t1305, 0
%t1307 = extractvalue {i64, i1} %t1305, 1
%t1308 = zext i1 %t1307 to i8
call void @resid_overflow_check(i8 %t1308)
%t1309 = sdiv i64 %t1306, 8
%t1310 = call ptr @resid_listbuf_new()
%t1311 = call ptr @__m____________lib_bignum_resid__bn_take_int(ptr %p0, i64 %t1309, i64 0, ptr %t1310)
%t1312 = call ptr @bn_from_be(ptr %t1311)
%t1314 = call ptr @resid_list_const_i64(ptr @.lc1313, i64 1, ptr @.lcd1313, ptr @.lty1313)
%t1315 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 1)
%t1316 = extractvalue {i64, i1} %t1315, 0
%t1317 = extractvalue {i64, i1} %t1315, 1
%t1318 = zext i1 %t1317 to i8
call void @resid_overflow_check(i8 %t1318)
%t1319 = call ptr @bn_shl(ptr %t1314, i64 %t1316)
%t1321 = call ptr @resid_list_const_i64(ptr @.lc1320, i64 1, ptr @.lcd1320, ptr @.lty1320)
%t1322 = call ptr @bn_sub(ptr %t1319, ptr %t1321)
%t1323 = call ptr @bn_and(ptr %t1312, ptr %t1322)
%t1325 = call ptr @resid_list_const_i64(ptr @.lc1324, i64 1, ptr @.lcd1324, ptr @.lty1324)
%t1326 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 3)
%t1327 = extractvalue {i64, i1} %t1326, 0
%t1328 = extractvalue {i64, i1} %t1326, 1
%t1329 = zext i1 %t1328 to i8
call void @resid_overflow_check(i8 %t1329)
%t1330 = call ptr @bn_shl(ptr %t1325, i64 %t1327)
%t1331 = call ptr @resid_list_freeze(ptr %t1330)
%t1332 = call ptr @bn_or(ptr %t1323, ptr %t1331)
%t1333 = call ptr @resid_list_freeze(ptr %t1332)
%t1335 = call ptr @resid_list_const_i64(ptr @.lc1334, i64 1, ptr @.lcd1334, ptr @.lty1334)
%t1336 = call ptr @bn_or(ptr %t1333, ptr %t1335)
%t1337 = call ptr @resid_list_freeze(ptr %t1336)
%t1339 = call ptr @resid_list_const_i64(ptr @.lc1338, i64 302, ptr @.lcd1338, ptr @.lty1338)
%t1340 = call ptr @resid_listbuf_new()
%t1341 = call ptr @__m____________lib_bignum_resid__bn_residues(ptr %t1337, ptr %t1339, i64 0, ptr %t1340)
%t1343 = call ptr @resid_list_const_i64(ptr @.lc1342, i64 302, ptr @.lcd1342, ptr @.lty1342)
%t1344 = call ptr @__m____________lib_bignum_resid__bn_safe_search(ptr %t1337, ptr %t1343, ptr %t1341, i64 0)
ret ptr %t1344
}
define ptr @__m____________lib_bignum_resid__bn_take_int(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1347, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t1354, %tco.s0 ]
%t1345 = icmp sge i64 %p2, %p1
br i1 %t1345, label %L235, label %L237
L235:
%t1346 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty1346)
ret ptr %t1346
L237:
%t1347 = add nsw i64 %p2, 1
%t1348 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t1349 = call i64 @resid_unbox_i64(ptr %t1348)
%t1351 = call ptr @resid_box_i64(i64 %t1349)
%t1354 = call ptr @resid_listbuf_push(ptr %p3, ptr %t1351)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_bignum_resid__bn_residues(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1369 = alloca [1 x ptr]
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1376, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t1393, %tco.s0 ]
%t1356 = call i64 @resid_list_len(ptr %p1)
%t1357 = icmp sge i64 %p2, %t1356
br i1 %t1357, label %L238, label %L240
L238:
%t1358 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty1358)
ret ptr %t1358
L240:
%t1359 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t1360 = call i64 @resid_unbox_i64(ptr %t1359)
%t1362 = add i64 %t1360, 0
%t1363 = add i64 %t1362, 0
%t1364 = add i64 %t1363, 0
%t1365 = icmp ne i64 %t1364, %t1362
%t1366 = icmp slt i64 %t1360, 0
%t1367 = or i1 %t1365, %t1366
%t1368 = zext i1 %t1367 to i8
call void @resid_conv_check(i8 %t1368)
%t1371 = call ptr @resid_box_i64(i64 %t1363)
%t1373 = getelementptr i8, ptr %t1369, i64 0
store ptr %t1371, ptr %t1373
%t1374 = call ptr @resid_list_new(i64 1, ptr %t1369, ptr @.lty1369)
%t1375 = call ptr @bn_mod(ptr %p0, ptr %t1374)
%t1376 = add nsw i64 %p2, 1
%t1377 = call i64 @resid_list_len(ptr %t1375)
%t1378 = icmp eq i64 %t1377, 0
br i1 %t1378, label %L241, label %L242
L241:
br label %L243
L242:
%t1379 = call ptr @resid_list_get(ptr %t1375, i64 0)
%t1380 = call i64 @resid_unbox_i64(ptr %t1379)
%t1382 = add i64 %t1380, 0
%t1383 = add i64 %t1382, 0
%t1384 = add i64 %t1383, 0
%t1385 = icmp ne i64 %t1384, %t1382
%t1386 = icmp slt i64 %t1383, 0
%t1387 = or i1 %t1385, %t1386
%t1388 = zext i1 %t1387 to i8
call void @resid_conv_check(i8 %t1388)
br label %L243
L243:
%t1389 = phi i64 [ 0, %L241 ], [ %t1383, %L242 ]
%t1390 = call ptr @resid_box_i64(i64 %t1389)
%t1393 = call ptr @resid_listbuf_push(ptr %p3, ptr %t1390)
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t1439, %tco.s0 ]
%t1395 = call i64 @resid_list_len(ptr %p0)
%t1396 = icmp sge i64 %p3, %t1395
br i1 %t1396, label %L244, label %L246
L244:
ret i1 true
L246:
%t1397 = call ptr @resid_list_get_v(ptr %p0, i64 %p3, ptr %p0.ld, i64 %p0.ln)
%t1398 = call i64 @resid_unbox_i64(ptr %t1397)
%t1400 = call ptr @resid_list_get_v(ptr %p1, i64 %p3, ptr %p1.ld, i64 %p1.ln)
%t1401 = call i64 @resid_unbox_i64(ptr %t1400)
%t1403 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p2)
%t1404 = extractvalue {i64, i1} %t1403, 0
%t1405 = extractvalue {i64, i1} %t1403, 1
%t1406 = zext i1 %t1405 to i8
call void @resid_overflow_check(i8 %t1406)
%t1407 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t1401, i64 %t1404)
%t1408 = extractvalue {i64, i1} %t1407, 0
%t1409 = extractvalue {i64, i1} %t1407, 1
%t1410 = zext i1 %t1409 to i8
call void @resid_overflow_check(i8 %t1410)
%t1411 = icmp eq i64 %t1398, 0
%t1412 = zext i1 %t1411 to i8
call void @resid_div_check(i8 %t1412)
%t1413 = icmp eq i64 %t1398, -1
%t1414 = icmp eq i64 %t1408, -9223372036854775808
%t1415 = and i1 %t1413, %t1414
%t1416 = select i1 %t1413, i64 1, i64 %t1398
%t1417 = srem i64 %t1408, %t1416
%t1419 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %t1417)
%t1420 = extractvalue {i64, i1} %t1419, 0
%t1421 = extractvalue {i64, i1} %t1419, 1
%t1422 = zext i1 %t1421 to i8
call void @resid_overflow_check(i8 %t1422)
%t1423 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t1420, i64 1)
%t1424 = extractvalue {i64, i1} %t1423, 0
%t1425 = extractvalue {i64, i1} %t1423, 1
%t1426 = zext i1 %t1425 to i8
call void @resid_overflow_check(i8 %t1426)
%t1427 = icmp eq i64 %t1398, 0
%t1428 = zext i1 %t1427 to i8
call void @resid_div_check(i8 %t1428)
%t1429 = icmp eq i64 %t1398, -1
%t1430 = icmp eq i64 %t1424, -9223372036854775808
%t1431 = and i1 %t1429, %t1430
%t1432 = select i1 %t1429, i64 1, i64 %t1398
%t1433 = srem i64 %t1424, %t1432
%t1435 = icmp eq i64 %t1417, 0
br label %LSL1436
LSL1436:
br i1 %t1435, label %LSJ1436, label %LSR1436
LSR1436:
%t1437 = icmp eq i64 %t1433, 0
br label %LSJ1436
LSJ1436:
%t1438 = phi i1 [ true, %LSL1436 ], [ %t1437, %LSR1436 ]
br i1 %t1438, label %L247, label %L249
L247:
ret i1 false
L249:
%t1439 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_mr_bases() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1442 = call ptr @resid_list_const_i64(ptr @.lc1441, i64 1, ptr @.lcd1441, ptr @.lty1441)
%t1444 = call ptr @resid_list_const_i64(ptr @.lc1443, i64 1, ptr @.lcd1443, ptr @.lty1443)
%t1446 = call ptr @resid_list_const_i64(ptr @.lc1445, i64 1, ptr @.lcd1445, ptr @.lty1445)
%t1448 = call ptr @resid_list_const_i64(ptr @.lc1447, i64 1, ptr @.lcd1447, ptr @.lty1447)
%t1450 = call ptr @resid_list_const_i64(ptr @.lc1449, i64 1, ptr @.lcd1449, ptr @.lty1449)
%t1452 = call ptr @resid_list_const_i64(ptr @.lc1451, i64 1, ptr @.lcd1451, ptr @.lty1451)
%t1454 = call ptr @resid_list_const_i64(ptr @.lc1453, i64 1, ptr @.lcd1453, ptr @.lty1453)
%t1456 = call ptr @resid_list_const_i64(ptr @.lc1455, i64 1, ptr @.lcd1455, ptr @.lty1455)
%t1458 = call ptr @resid_list_const_i64(ptr @.lc1457, i64 1, ptr @.lcd1457, ptr @.lty1457)
%t1460 = call ptr @resid_list_const_i64(ptr @.lc1459, i64 1, ptr @.lcd1459, ptr @.lty1459)
%t1462 = call ptr @resid_list_const_i64(ptr @.lc1461, i64 1, ptr @.lcd1461, ptr @.lty1461)
%t1464 = call ptr @resid_list_const_i64(ptr @.lc1463, i64 1, ptr @.lcd1463, ptr @.lty1463)
%t1465 = alloca [12 x ptr]
%t1469 = getelementptr i8, ptr %t1465, i64 0
store ptr %t1442, ptr %t1469
%t1472 = getelementptr i8, ptr %t1465, i64 8
store ptr %t1444, ptr %t1472
%t1475 = getelementptr i8, ptr %t1465, i64 16
store ptr %t1446, ptr %t1475
%t1478 = getelementptr i8, ptr %t1465, i64 24
store ptr %t1448, ptr %t1478
%t1481 = getelementptr i8, ptr %t1465, i64 32
store ptr %t1450, ptr %t1481
%t1484 = getelementptr i8, ptr %t1465, i64 40
store ptr %t1452, ptr %t1484
%t1487 = getelementptr i8, ptr %t1465, i64 48
store ptr %t1454, ptr %t1487
%t1490 = getelementptr i8, ptr %t1465, i64 56
store ptr %t1456, ptr %t1490
%t1493 = getelementptr i8, ptr %t1465, i64 64
store ptr %t1458, ptr %t1493
%t1496 = getelementptr i8, ptr %t1465, i64 72
store ptr %t1460, ptr %t1496
%t1499 = getelementptr i8, ptr %t1465, i64 80
store ptr %t1462, ptr %t1499
%t1502 = getelementptr i8, ptr %t1465, i64 88
store ptr %t1464, ptr %t1502
%t1503 = call ptr @resid_list_new(i64 12, ptr %t1465, ptr @.lty1465)
ret ptr %t1503
}
define ptr @__m____________lib_bignum_resid__bn_safe_search(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1518 = alloca [1 x ptr]
%t1534 = alloca [1 x ptr]
%t1544 = alloca [1 x ptr]
%t1553 = alloca [1 x ptr]
%t1559 = alloca [1 x ptr]
%t1565 = alloca [1 x ptr]
%t1571 = alloca [1 x ptr]
%t1577 = alloca [1 x ptr]
%t1583 = alloca [1 x ptr]
%t1589 = alloca [1 x ptr]
%t1595 = alloca [1 x ptr]
%t1601 = alloca [1 x ptr]
%t1607 = alloca [1 x ptr]
%t1613 = alloca [1 x ptr]
%t1619 = alloca [1 x ptr]
%t1625 = alloca [12 x ptr]
%t1667 = alloca [1 x ptr]
%t1673 = alloca [1 x ptr]
%t1679 = alloca [1 x ptr]
%t1685 = alloca [1 x ptr]
%t1691 = alloca [1 x ptr]
%t1697 = alloca [1 x ptr]
%t1703 = alloca [1 x ptr]
%t1709 = alloca [1 x ptr]
%t1715 = alloca [1 x ptr]
%t1721 = alloca [1 x ptr]
%t1727 = alloca [1 x ptr]
%t1733 = alloca [1 x ptr]
%t1739 = alloca [12 x ptr]
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1783, %tco.s0 ]
%t1504 = icmp sge i64 %p3, 2048
br i1 %t1504, label %L250, label %L252
L250:
ret ptr @.nbox1505
L252:
%t1506 = call i1 @__m____________lib_bignum_resid__bn_sieve_ok(ptr %p1, ptr %p2, i64 %p3, i64 0)
br i1 %t1506, label %L253, label %L255
L253:
%t1507 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p3)
%t1508 = extractvalue {i64, i1} %t1507, 0
%t1509 = extractvalue {i64, i1} %t1507, 1
%t1510 = zext i1 %t1509 to i8
call void @resid_overflow_check(i8 %t1510)
%t1511 = add i64 %t1508, 0
%t1512 = add i64 %t1511, 0
%t1513 = add i64 %t1512, 0
%t1514 = icmp ne i64 %t1513, %t1511
%t1515 = icmp slt i64 %t1508, 0
%t1516 = or i1 %t1514, %t1515
%t1517 = zext i1 %t1516 to i8
call void @resid_conv_check(i8 %t1517)
%t1520 = call ptr @resid_box_i64(i64 %t1512)
%t1522 = getelementptr i8, ptr %t1518, i64 0
store ptr %t1520, ptr %t1522
%t1523 = call ptr @resid_list_new(i64 1, ptr %t1518, ptr @.lty1518)
%t1524 = call ptr @bn_add(ptr %p0, ptr %t1523)
%t1525 = call ptr @resid_list_freeze(ptr %t1524)
%t1526 = call ptr @bn_shl(ptr %t1525, i64 1)
%t1527 = call ptr @resid_list_freeze(ptr %t1526)
%t1529 = call ptr @resid_list_const_i64(ptr @.lc1528, i64 1, ptr @.lcd1528, ptr @.lty1528)
%t1530 = call ptr @bn_add(ptr %t1527, ptr %t1529)
%t1531 = call ptr @resid_list_freeze(ptr %t1530)
%t1533 = call ptr @resid_list_const_i64(ptr @.lc1532, i64 1, ptr @.lcd1532, ptr @.lty1532)
%t1538 = getelementptr i8, ptr %t1534, i64 0
store ptr %t1533, ptr %t1538
%t1539 = call ptr @resid_list_new(i64 1, ptr %t1534, ptr @.lty1534)
%t1540 = call i1 @bn_miller_rabin(ptr %t1525, ptr %t1539)
br label %LSL1541
LSL1541:
br i1 %t1540, label %LSR1541, label %LSJ1541
LSR1541:
%t1543 = call ptr @resid_list_const_i64(ptr @.lc1542, i64 1, ptr @.lcd1542, ptr @.lty1542)
%t1548 = getelementptr i8, ptr %t1544, i64 0
store ptr %t1543, ptr %t1548
%t1549 = call ptr @resid_list_new(i64 1, ptr %t1544, ptr @.lty1544)
%t1550 = call i1 @bn_miller_rabin(ptr %t1531, ptr %t1549)
br label %LSJ1541
LSJ1541:
%t1551 = phi i1 [ false, %LSL1541 ], [ %t1550, %LSR1541 ]
br label %LSL1552
LSL1552:
br i1 %t1551, label %LSR1552, label %LSJ1552
LSR1552:
%t1555 = call ptr @resid_box_i64(i64 2)
%t1557 = getelementptr i8, ptr %t1553, i64 0
store ptr %t1555, ptr %t1557
%t1558 = call ptr @resid_list_new(i64 1, ptr %t1553, ptr @.lty1553)
%t1561 = call ptr @resid_box_i64(i64 3)
%t1563 = getelementptr i8, ptr %t1559, i64 0
store ptr %t1561, ptr %t1563
%t1564 = call ptr @resid_list_new(i64 1, ptr %t1559, ptr @.lty1559)
%t1567 = call ptr @resid_box_i64(i64 5)
%t1569 = getelementptr i8, ptr %t1565, i64 0
store ptr %t1567, ptr %t1569
%t1570 = call ptr @resid_list_new(i64 1, ptr %t1565, ptr @.lty1565)
%t1573 = call ptr @resid_box_i64(i64 7)
%t1575 = getelementptr i8, ptr %t1571, i64 0
store ptr %t1573, ptr %t1575
%t1576 = call ptr @resid_list_new(i64 1, ptr %t1571, ptr @.lty1571)
%t1579 = call ptr @resid_box_i64(i64 11)
%t1581 = getelementptr i8, ptr %t1577, i64 0
store ptr %t1579, ptr %t1581
%t1582 = call ptr @resid_list_new(i64 1, ptr %t1577, ptr @.lty1577)
%t1585 = call ptr @resid_box_i64(i64 13)
%t1587 = getelementptr i8, ptr %t1583, i64 0
store ptr %t1585, ptr %t1587
%t1588 = call ptr @resid_list_new(i64 1, ptr %t1583, ptr @.lty1583)
%t1591 = call ptr @resid_box_i64(i64 17)
%t1593 = getelementptr i8, ptr %t1589, i64 0
store ptr %t1591, ptr %t1593
%t1594 = call ptr @resid_list_new(i64 1, ptr %t1589, ptr @.lty1589)
%t1597 = call ptr @resid_box_i64(i64 19)
%t1599 = getelementptr i8, ptr %t1595, i64 0
store ptr %t1597, ptr %t1599
%t1600 = call ptr @resid_list_new(i64 1, ptr %t1595, ptr @.lty1595)
%t1603 = call ptr @resid_box_i64(i64 23)
%t1605 = getelementptr i8, ptr %t1601, i64 0
store ptr %t1603, ptr %t1605
%t1606 = call ptr @resid_list_new(i64 1, ptr %t1601, ptr @.lty1601)
%t1609 = call ptr @resid_box_i64(i64 29)
%t1611 = getelementptr i8, ptr %t1607, i64 0
store ptr %t1609, ptr %t1611
%t1612 = call ptr @resid_list_new(i64 1, ptr %t1607, ptr @.lty1607)
%t1615 = call ptr @resid_box_i64(i64 31)
%t1617 = getelementptr i8, ptr %t1613, i64 0
store ptr %t1615, ptr %t1617
%t1618 = call ptr @resid_list_new(i64 1, ptr %t1613, ptr @.lty1613)
%t1621 = call ptr @resid_box_i64(i64 37)
%t1623 = getelementptr i8, ptr %t1619, i64 0
store ptr %t1621, ptr %t1623
%t1624 = call ptr @resid_list_new(i64 1, ptr %t1619, ptr @.lty1619)
%t1629 = getelementptr i8, ptr %t1625, i64 0
store ptr %t1558, ptr %t1629
%t1632 = getelementptr i8, ptr %t1625, i64 8
store ptr %t1564, ptr %t1632
%t1635 = getelementptr i8, ptr %t1625, i64 16
store ptr %t1570, ptr %t1635
%t1638 = getelementptr i8, ptr %t1625, i64 24
store ptr %t1576, ptr %t1638
%t1641 = getelementptr i8, ptr %t1625, i64 32
store ptr %t1582, ptr %t1641
%t1644 = getelementptr i8, ptr %t1625, i64 40
store ptr %t1588, ptr %t1644
%t1647 = getelementptr i8, ptr %t1625, i64 48
store ptr %t1594, ptr %t1647
%t1650 = getelementptr i8, ptr %t1625, i64 56
store ptr %t1600, ptr %t1650
%t1653 = getelementptr i8, ptr %t1625, i64 64
store ptr %t1606, ptr %t1653
%t1656 = getelementptr i8, ptr %t1625, i64 72
store ptr %t1612, ptr %t1656
%t1659 = getelementptr i8, ptr %t1625, i64 80
store ptr %t1618, ptr %t1659
%t1662 = getelementptr i8, ptr %t1625, i64 88
store ptr %t1624, ptr %t1662
%t1663 = call ptr @resid_list_new(i64 12, ptr %t1625, ptr @.lty1625)
%t1664 = call i1 @bn_miller_rabin(ptr %t1525, ptr %t1663)
br label %LSJ1552
LSJ1552:
%t1665 = phi i1 [ false, %LSL1552 ], [ %t1664, %LSR1552 ]
br label %LSL1666
LSL1666:
br i1 %t1665, label %LSR1666, label %LSJ1666
LSR1666:
%t1669 = call ptr @resid_box_i64(i64 2)
%t1671 = getelementptr i8, ptr %t1667, i64 0
store ptr %t1669, ptr %t1671
%t1672 = call ptr @resid_list_new(i64 1, ptr %t1667, ptr @.lty1667)
%t1675 = call ptr @resid_box_i64(i64 3)
%t1677 = getelementptr i8, ptr %t1673, i64 0
store ptr %t1675, ptr %t1677
%t1678 = call ptr @resid_list_new(i64 1, ptr %t1673, ptr @.lty1673)
%t1681 = call ptr @resid_box_i64(i64 5)
%t1683 = getelementptr i8, ptr %t1679, i64 0
store ptr %t1681, ptr %t1683
%t1684 = call ptr @resid_list_new(i64 1, ptr %t1679, ptr @.lty1679)
%t1687 = call ptr @resid_box_i64(i64 7)
%t1689 = getelementptr i8, ptr %t1685, i64 0
store ptr %t1687, ptr %t1689
%t1690 = call ptr @resid_list_new(i64 1, ptr %t1685, ptr @.lty1685)
%t1693 = call ptr @resid_box_i64(i64 11)
%t1695 = getelementptr i8, ptr %t1691, i64 0
store ptr %t1693, ptr %t1695
%t1696 = call ptr @resid_list_new(i64 1, ptr %t1691, ptr @.lty1691)
%t1699 = call ptr @resid_box_i64(i64 13)
%t1701 = getelementptr i8, ptr %t1697, i64 0
store ptr %t1699, ptr %t1701
%t1702 = call ptr @resid_list_new(i64 1, ptr %t1697, ptr @.lty1697)
%t1705 = call ptr @resid_box_i64(i64 17)
%t1707 = getelementptr i8, ptr %t1703, i64 0
store ptr %t1705, ptr %t1707
%t1708 = call ptr @resid_list_new(i64 1, ptr %t1703, ptr @.lty1703)
%t1711 = call ptr @resid_box_i64(i64 19)
%t1713 = getelementptr i8, ptr %t1709, i64 0
store ptr %t1711, ptr %t1713
%t1714 = call ptr @resid_list_new(i64 1, ptr %t1709, ptr @.lty1709)
%t1717 = call ptr @resid_box_i64(i64 23)
%t1719 = getelementptr i8, ptr %t1715, i64 0
store ptr %t1717, ptr %t1719
%t1720 = call ptr @resid_list_new(i64 1, ptr %t1715, ptr @.lty1715)
%t1723 = call ptr @resid_box_i64(i64 29)
%t1725 = getelementptr i8, ptr %t1721, i64 0
store ptr %t1723, ptr %t1725
%t1726 = call ptr @resid_list_new(i64 1, ptr %t1721, ptr @.lty1721)
%t1729 = call ptr @resid_box_i64(i64 31)
%t1731 = getelementptr i8, ptr %t1727, i64 0
store ptr %t1729, ptr %t1731
%t1732 = call ptr @resid_list_new(i64 1, ptr %t1727, ptr @.lty1727)
%t1735 = call ptr @resid_box_i64(i64 37)
%t1737 = getelementptr i8, ptr %t1733, i64 0
store ptr %t1735, ptr %t1737
%t1738 = call ptr @resid_list_new(i64 1, ptr %t1733, ptr @.lty1733)
%t1743 = getelementptr i8, ptr %t1739, i64 0
store ptr %t1672, ptr %t1743
%t1746 = getelementptr i8, ptr %t1739, i64 8
store ptr %t1678, ptr %t1746
%t1749 = getelementptr i8, ptr %t1739, i64 16
store ptr %t1684, ptr %t1749
%t1752 = getelementptr i8, ptr %t1739, i64 24
store ptr %t1690, ptr %t1752
%t1755 = getelementptr i8, ptr %t1739, i64 32
store ptr %t1696, ptr %t1755
%t1758 = getelementptr i8, ptr %t1739, i64 40
store ptr %t1702, ptr %t1758
%t1761 = getelementptr i8, ptr %t1739, i64 48
store ptr %t1708, ptr %t1761
%t1764 = getelementptr i8, ptr %t1739, i64 56
store ptr %t1714, ptr %t1764
%t1767 = getelementptr i8, ptr %t1739, i64 64
store ptr %t1720, ptr %t1767
%t1770 = getelementptr i8, ptr %t1739, i64 72
store ptr %t1726, ptr %t1770
%t1773 = getelementptr i8, ptr %t1739, i64 80
store ptr %t1732, ptr %t1773
%t1776 = getelementptr i8, ptr %t1739, i64 88
store ptr %t1738, ptr %t1776
%t1777 = call ptr @resid_list_new(i64 12, ptr %t1739, ptr @.lty1739)
%t1778 = call i1 @bn_miller_rabin(ptr %t1531, ptr %t1777)
br label %LSJ1666
LSJ1666:
%t1779 = phi i1 [ false, %LSL1666 ], [ %t1778, %LSR1666 ]
br i1 %t1779, label %L256, label %L258
L256:
%t1782 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty1780)
%t1781 = getelementptr {i32, i32, ptr}, ptr %t1782, i32 1
store ptr %t1531, ptr %t1781
ret ptr %t1782
L258:
br label %L255
L255:
%t1783 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_and(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1785 = call i64 @resid_list_len(ptr %p0)
%t1786 = call i64 @resid_list_len(ptr %p1)
%t1787 = icmp slt i64 %t1785, %t1786
br i1 %t1787, label %L259, label %L260
L259:
%t1788 = call i64 @resid_list_len(ptr %p0)
br label %L261
L260:
%t1789 = call i64 @resid_list_len(ptr %p1)
br label %L261
L261:
%t1790 = phi i64 [ %t1788, %L259 ], [ %t1789, %L260 ]
%t1791 = call ptr @resid_listbuf_new()
%t1792 = call ptr @__m____________lib_bignum_resid__bn_and_at(ptr %p0, ptr %p1, i64 0, i64 %t1790, ptr %t1791)
%t1793 = call ptr @bn_trim(ptr %t1792)
ret ptr %t1793
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t1796, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t1807, %tco.s0 ]
%t1794 = icmp sge i64 %p2, %p3
br i1 %t1794, label %L262, label %L264
L262:
%t1795 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty1795)
ret ptr %t1795
L264:
%t1796 = add nsw i64 %p2, 1
%t1797 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t1798 = call i64 @resid_unbox_i64(ptr %t1797)
%t1800 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t1801 = call i64 @resid_unbox_i64(ptr %t1800)
%t1803 = and i64 %t1798, %t1801
%t1804 = call ptr @resid_box_i64(i64 %t1803)
%t1807 = call ptr @resid_listbuf_push(ptr %p4, ptr %t1804)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_or(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1809 = call i64 @resid_list_len(ptr %p0)
%t1810 = call i64 @resid_list_len(ptr %p1)
%t1811 = icmp sgt i64 %t1809, %t1810
br i1 %t1811, label %L265, label %L266
L265:
%t1812 = call i64 @resid_list_len(ptr %p0)
br label %L267
L266:
%t1813 = call i64 @resid_list_len(ptr %p1)
br label %L267
L267:
%t1814 = phi i64 [ %t1812, %L265 ], [ %t1813, %L266 ]
%t1815 = call ptr @resid_listbuf_new()
%t1816 = call ptr @__m____________lib_bignum_resid__bn_or_at(ptr %p0, ptr %p1, i64 0, i64 %t1814, ptr %t1815)
ret ptr %t1816
}
define ptr @__m____________lib_bignum_resid__bn_or_at(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1819, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t1826, %tco.s0 ]
%t1817 = icmp sge i64 %p2, %p3
br i1 %t1817, label %L268, label %L270
L268:
%t1818 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty1818)
ret ptr %t1818
L270:
%t1819 = add nsw i64 %p2, 1
%t1820 = call i64 @__m____________lib_bignum_resid__bn_get(ptr %p0, i64 %p2)
%t1821 = call i64 @__m____________lib_bignum_resid__bn_get(ptr %p1, i64 %p2)
%t1822 = or i64 %t1820, %t1821
%t1823 = call ptr @resid_box_i64(i64 %t1822)
%t1826 = call ptr @resid_listbuf_push(ptr %p4, ptr %t1823)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_safe_prime_stream(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1828 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 1)
%t1829 = extractvalue {i64, i1} %t1828, 0
%t1830 = extractvalue {i64, i1} %t1828, 1
%t1831 = zext i1 %t1830 to i8
call void @resid_overflow_check(i8 %t1831)
%t1832 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t1829, i64 7)
%t1833 = extractvalue {i64, i1} %t1832, 0
%t1834 = extractvalue {i64, i1} %t1832, 1
%t1835 = zext i1 %t1834 to i8
call void @resid_overflow_check(i8 %t1835)
%t1836 = sdiv i64 %t1833, 8
%t1837 = call ptr @__m____________lib_bignum_resid__bn_sps_from(ptr %p0, i64 %p1, i64 %t1836, i64 0)
ret ptr %t1837
}
define ptr @__m____________lib_bignum_resid__bn_sps_from(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1838 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %p2)
%t1839 = extractvalue {i64, i1} %t1838, 0
%t1840 = extractvalue {i64, i1} %t1838, 1
%t1841 = zext i1 %t1840 to i8
call void @resid_overflow_check(i8 %t1841)
%t1842 = call i64 @resid_list_len(ptr %p0)
%t1843 = icmp sgt i64 %t1839, %t1842
br i1 %t1843, label %L271, label %L273
L271:
ret ptr @.nbox1844
L273:
%t1845 = call ptr @bn_slice_int(ptr %p0, i64 %p3, i64 %p2)
%t1846 = call ptr @resid_list_freeze(ptr %t1845)
%t1847 = call ptr @bn_safe_prime(ptr %t1846, i64 %p1)
%t1848 = getelementptr {i32, i32, ptr}, ptr %t1847, i32 0, i32 0
%t1849w = load i32, ptr %t1848
%t1849 = sext i32 %t1849w to i64
%t1850 = icmp eq i64 %t1849, 1
br i1 %t1850, label %L274, label %L275
L274:
%t1851 = getelementptr {i32, i32, ptr}, ptr %t1847, i32 1
%t1852 = getelementptr i8, ptr %t1851, i64 0
%t1853 = getelementptr ptr, ptr %t1852, i32 0
%t1854 = load ptr, ptr %t1853
%t1857 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty1855)
%t1856 = getelementptr {i32, i32, ptr}, ptr %t1857, i32 1
store ptr %t1854, ptr %t1856
br label %L276
L275:
%t1858 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %p2)
%t1859 = extractvalue {i64, i1} %t1858, 0
%t1860 = extractvalue {i64, i1} %t1858, 1
%t1861 = zext i1 %t1860 to i8
call void @resid_overflow_check(i8 %t1861)
%t1862 = call ptr @__m____________lib_bignum_resid__bn_sps_from(ptr %p0, i64 %p1, i64 %p2, i64 %t1859)
br label %L276
L276:
%t1863 = phi ptr [ %t1857, %L274 ], [ %t1862, %L275 ]
ret ptr %t1863
}
define ptr @bn_slice_int(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1864 = call ptr @resid_listbuf_new()
%t1865 = call ptr @__m____________lib_bignum_resid__bn_slice_at(ptr %p0, i64 %p1, i64 %p2, i64 0, ptr %t1864)
ret ptr %t1865
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t1868, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t1879, %tco.s0 ]
%t1866 = icmp sge i64 %p3, %p2
br i1 %t1866, label %L277, label %L279
L277:
%t1867 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty1867)
ret ptr %t1867
L279:
%t1868 = add nsw i64 %p3, 1
%t1869 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p3)
%t1870 = extractvalue {i64, i1} %t1869, 0
%t1871 = extractvalue {i64, i1} %t1869, 1
%t1872 = zext i1 %t1871 to i8
call void @resid_overflow_check(i8 %t1872)
%t1873 = call ptr @resid_list_get_v(ptr %p0, i64 %t1870, ptr %p0.ld, i64 %p0.ln)
%t1874 = call i64 @resid_unbox_i64(ptr %t1873)
%t1876 = call ptr @resid_box_i64(i64 %t1874)
%t1879 = call ptr @resid_listbuf_push(ptr %p4, ptr %t1876)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @bn_jacobi(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1881 = call ptr @bn_mod(ptr %p0, ptr %p1)
%t1882 = call i64 @__m____________lib_bignum_resid__bn_jac(ptr %t1881, ptr %p1, i64 1)
ret i64 %t1882
}
define i64 @__m____________lib_bignum_resid__bn_jac(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %t1905, %tco.s0 ], [ %t1924, %tco.s1 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p0, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1904, %tco.s0 ], [ %t1923, %tco.s1 ]
%t1883 = call i64 @resid_list_len(ptr %p0)
%t1884 = icmp eq i64 %t1883, 0
br i1 %t1884, label %L280, label %L282
L280:
%t1886 = call ptr @resid_list_const_i64(ptr @.lc1885, i64 1, ptr @.lcd1885, ptr @.lty1885)
%t1887 = call i64 @bn_cmp(ptr %p1, ptr %t1886)
%t1888 = icmp eq i64 %t1887, 0
br i1 %t1888, label %L283, label %L284
L283:
br label %L285
L284:
br label %L285
L285:
%t1889 = phi i64 [ %p2, %L283 ], [ 0, %L284 ]
ret i64 %t1889
L282:
%t1890 = call i1 @bn_is_odd(ptr %p0)
%t1891 = xor i1 %t1890, true
br i1 %t1891, label %L286, label %L288
L286:
%t1892 = call ptr @resid_list_get(ptr %p1, i64 0)
%t1893 = call i64 @resid_unbox_i64(ptr %t1892)
%t1895 = and i64 %t1893, 7
%t1896 = icmp eq i64 %t1895, 3
br label %LSL1897
LSL1897:
br i1 %t1896, label %LSJ1897, label %LSR1897
LSR1897:
%t1898 = icmp eq i64 %t1895, 5
br label %LSJ1897
LSJ1897:
%t1899 = phi i1 [ true, %LSL1897 ], [ %t1898, %LSR1897 ]
br i1 %t1899, label %L289, label %L290
L289:
%t1900 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p2)
%t1901 = extractvalue {i64, i1} %t1900, 0
%t1902 = extractvalue {i64, i1} %t1900, 1
%t1903 = zext i1 %t1902 to i8
call void @resid_overflow_check(i8 %t1903)
br label %L291
L290:
br label %L291
L291:
%t1904 = phi i64 [ %t1901, %L289 ], [ %p2, %L290 ]
%t1905 = call ptr @bn_shr(ptr %p0, i64 1)
br label %tco.s0
tco.s0:
br label %tco.head
L288:
%t1907 = call ptr @resid_list_get(ptr %p0, i64 0)
%t1908 = call i64 @resid_unbox_i64(ptr %t1907)
%t1910 = and i64 %t1908, 3
%t1911 = icmp eq i64 %t1910, 3
br label %LSL1912
LSL1912:
br i1 %t1911, label %LSR1912, label %LSJ1912
LSR1912:
%t1913 = call ptr @resid_list_get(ptr %p1, i64 0)
%t1914 = call i64 @resid_unbox_i64(ptr %t1913)
%t1916 = and i64 %t1914, 3
%t1917 = icmp eq i64 %t1916, 3
br label %LSJ1912
LSJ1912:
%t1918 = phi i1 [ false, %LSL1912 ], [ %t1917, %LSR1912 ]
br i1 %t1918, label %L292, label %L293
L292:
%t1919 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p2)
%t1920 = extractvalue {i64, i1} %t1919, 0
%t1921 = extractvalue {i64, i1} %t1919, 1
%t1922 = zext i1 %t1921 to i8
call void @resid_overflow_check(i8 %t1922)
br label %L294
L293:
br label %L294
L294:
%t1923 = phi i64 [ %t1920, %L292 ], [ %p2, %L293 ]
%t1924 = call ptr @bn_mod(ptr %p1, ptr %p0)
br label %tco.s1
tco.s1:
br label %tco.head
}
define i4224 @__m____________lib_bignum_resid__bw_mask() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1926 = zext i64 2048 to i4224
%t1927 = icmp uge i4224 %t1926, 4224
%t1928 = add i4224 %t1926, 0
%t1929 = shl i4224 1, %t1928
%t1930 = select i1 %t1927, i4224 0, i4224 %t1929
%t1931 = call {i4224, i1} @llvm.usub.with.overflow.i4224(i4224 %t1930, i4224 1)
%t1932 = extractvalue {i4224, i1} %t1931, 0
%t1933 = extractvalue {i4224, i1} %t1931, 1
%t1934 = zext i1 %t1933 to i8
call void @resid_overflow_check(i8 %t1934)
ret i4224 %t1932
}
define i4224 @__m____________lib_bignum_resid__bw_of(ptr %p0.in, i64 %p1.in, i4224 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1936, %tco.s0 ]
%p2 = phi i4224 [ %p2.in, %entry ], [ %t1942, %tco.s0 ]
%t1935 = icmp slt i64 %p1, 0
br i1 %t1935, label %L295, label %L297
L295:
ret i4224 %p2
L297:
%t1936 = sub nsw i64 %p1, 1
%t1937 = shl i4224 %p2, 64
%t1938 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t1939 = call i64 @resid_unbox_i64(ptr %t1938)
%t1941 = zext i64 %t1939 to i4224
%t1942 = or i4224 %t1937, %t1941
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_bignum_resid__bw_to(i4224 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i4224 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1962, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t1969, %tco.s0 ]
%t1944 = icmp sge i64 %p2, %p1
br i1 %t1944, label %L298, label %L300
L298:
%t1945 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty1945)
%t1946 = call ptr @bn_trim(ptr %t1945)
ret ptr %t1946
L300:
%t1947 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 64, i64 %p2)
%t1948 = extractvalue {i64, i1} %t1947, 0
%t1949 = extractvalue {i64, i1} %t1947, 1
%t1950 = zext i1 %t1949 to i8
call void @resid_overflow_check(i8 %t1950)
%t1951 = sext i64 %t1948 to i4224
%t1952 = add i4224 %t1951, 0
%t1953 = add i4224 %t1952, 0
%t1954 = icmp ne i4224 %t1953, %t1951
%t1955 = icmp slt i64 %t1948, 0
%t1956 = or i1 %t1954, %t1955
%t1957 = zext i1 %t1956 to i8
call void @resid_conv_check(i8 %t1957)
%t1958 = icmp uge i4224 %t1952, 4224
%t1959 = add i4224 %t1952, 0
%t1960 = lshr i4224 %p0, %t1959
%t1961 = select i1 %t1958, i4224 0, i4224 %t1960
%t1962 = add nsw i64 %p2, 1
%t1963 = sext i128 18446744073709551615 to i4224
%t1964 = and i4224 %t1961, %t1963
%t1965 = trunc i4224 %t1964 to i64
%t1966 = call ptr @resid_box_i64(i64 %t1965)
%t1969 = call ptr @resid_listbuf_push(ptr %p3, ptr %t1966)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i4224 @__m____________lib_bignum_resid__bw_ninv(i4224 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1971 = call i4224 @__m____________lib_bignum_resid__bw_mask()
%t1972 = and i4224 %p0, %t1971
%t1973 = and i4224 %p0, %t1971
%t1974 = call i4224 @__m____________lib_bignum_resid__bw_newton(i4224 %t1972, i4224 %t1973, i64 0, i4224 %t1971)
%t1975 = zext i64 2048 to i4224
%t1976 = icmp uge i4224 %t1975, 4224
%t1977 = add i4224 %t1975, 0
%t1978 = shl i4224 1, %t1977
%t1979 = select i1 %t1976, i4224 0, i4224 %t1978
%t1980 = call {i4224, i1} @llvm.usub.with.overflow.i4224(i4224 %t1979, i4224 %t1974)
%t1981 = extractvalue {i4224, i1} %t1980, 0
%t1982 = extractvalue {i4224, i1} %t1980, 1
%t1983 = zext i1 %t1982 to i8
call void @resid_overflow_check(i8 %t1983)
%t1984 = and i4224 %t1981, %t1971
ret i4224 %t1984
}
define i4224 @__m____________lib_bignum_resid__bw_newton(i4224 %p0.in, i4224 %p1.in, i64 %p2.in, i4224 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i4224 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i4224 [ %p1.in, %entry ], [ %t2003, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2004, %tco.s0 ]
%p3 = phi i4224 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t1985 = icmp sge i64 %p2, 10
br i1 %t1985, label %L301, label %L303
L301:
ret i4224 %p1
L303:
%t1986 = mul i4224 %p0, %p1
%t1987 = and i4224 %t1986, %p3
%t1988 = zext i64 2048 to i4224
%t1989 = icmp uge i4224 %t1988, 4224
%t1990 = add i4224 %t1988, 0
%t1991 = shl i4224 1, %t1990
%t1992 = select i1 %t1989, i4224 0, i4224 %t1991
%t1993 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t1992, i4224 2)
%t1994 = extractvalue {i4224, i1} %t1993, 0
%t1995 = extractvalue {i4224, i1} %t1993, 1
%t1996 = zext i1 %t1995 to i8
call void @resid_overflow_check(i8 %t1996)
%t1997 = call {i4224, i1} @llvm.usub.with.overflow.i4224(i4224 %t1994, i4224 %t1987)
%t1998 = extractvalue {i4224, i1} %t1997, 0
%t1999 = extractvalue {i4224, i1} %t1997, 1
%t2000 = zext i1 %t1999 to i8
call void @resid_overflow_check(i8 %t2000)
%t2001 = and i4224 %t1998, %p3
%t2002 = mul i4224 %p1, %t2001
%t2003 = and i4224 %t2002, %p3
%t2004 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define i4224 @__m____________lib_bignum_resid__bw_double(i4224 %p0.in, i4224 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i4224 [ %p0.in, %entry ], [ %t2013, %tco.s0 ]
%p1 = phi i4224 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2014, %tco.s0 ]
%t2006 = icmp sle i64 %p2, 0
br i1 %t2006, label %L304, label %L306
L304:
ret i4224 %p0
L306:
%t2007 = shl i4224 %p0, 1
%t2008 = icmp uge i4224 %t2007, %p1
br i1 %t2008, label %L307, label %L308
L307:
%t2009 = call {i4224, i1} @llvm.usub.with.overflow.i4224(i4224 %t2007, i4224 %p1)
%t2010 = extractvalue {i4224, i1} %t2009, 0
%t2011 = extractvalue {i4224, i1} %t2009, 1
%t2012 = zext i1 %t2011 to i8
call void @resid_overflow_check(i8 %t2012)
br label %L309
L308:
br label %L309
L309:
%t2013 = phi i4224 [ %t2010, %L307 ], [ %t2007, %L308 ]
%t2014 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define i4224 @__m____________lib_bignum_resid__bw_mm1(i4224 %p0, i4224 %p1, i4224 %p2, i4224 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2016 = call i4224 @__m____________lib_bignum_resid__bw_mask()
%t2017 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %p0, i4224 %p1)
%t2018 = extractvalue {i4224, i1} %t2017, 0
%t2019 = extractvalue {i4224, i1} %t2017, 1
%t2020 = zext i1 %t2019 to i8
call void @resid_overflow_check(i8 %t2020)
%t2021 = and i4224 %t2018, %t2016
%t2022 = mul i4224 %t2021, %p3
%t2023 = and i4224 %t2022, %t2016
%t2024 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2023, i4224 %p2)
%t2025 = extractvalue {i4224, i1} %t2024, 0
%t2026 = extractvalue {i4224, i1} %t2024, 1
%t2027 = zext i1 %t2026 to i8
call void @resid_overflow_check(i8 %t2027)
%t2028 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2018, i4224 %t2025)
%t2029 = extractvalue {i4224, i1} %t2028, 0
%t2030 = extractvalue {i4224, i1} %t2028, 1
%t2031 = zext i1 %t2030 to i8
call void @resid_overflow_check(i8 %t2031)
%t2032 = zext i64 2048 to i4224
%t2033 = icmp uge i4224 %t2032, 4224
%t2034 = add i4224 %t2032, 0
%t2035 = lshr i4224 %t2029, %t2034
%t2036 = select i1 %t2033, i4224 0, i4224 %t2035
%t2037 = icmp uge i4224 %t2036, %p2
br i1 %t2037, label %L310, label %L311
L310:
%t2038 = call {i4224, i1} @llvm.usub.with.overflow.i4224(i4224 %t2036, i4224 %p2)
%t2039 = extractvalue {i4224, i1} %t2038, 0
%t2040 = extractvalue {i4224, i1} %t2038, 1
%t2041 = zext i1 %t2040 to i8
call void @resid_overflow_check(i8 %t2041)
br label %L312
L311:
br label %L312
L312:
%t2042 = phi i4224 [ %t2039, %L310 ], [ %t2036, %L311 ]
ret i4224 %t2042
}
define i4224 @__m____________lib_bignum_resid__bw_mm2(i4224 %p0, i4224 %p1, i4224 %p2, i4224 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2043 = call i4224 @__m____________lib_bignum_resid__bw_mask()
%t2044 = and i4224 %p0, %t2043
%t2045 = zext i64 2048 to i4224
%t2046 = icmp uge i4224 %t2045, 4224
%t2047 = add i4224 %t2045, 0
%t2048 = lshr i4224 %p0, %t2047
%t2049 = select i1 %t2046, i4224 0, i4224 %t2048
%t2050 = and i4224 %p1, %t2043
%t2051 = zext i64 2048 to i4224
%t2052 = icmp uge i4224 %t2051, 4224
%t2053 = add i4224 %t2051, 0
%t2054 = lshr i4224 %p1, %t2053
%t2055 = select i1 %t2052, i4224 0, i4224 %t2054
%t2056 = and i4224 %p2, %t2043
%t2057 = zext i64 2048 to i4224
%t2058 = icmp uge i4224 %t2057, 4224
%t2059 = add i4224 %t2057, 0
%t2060 = lshr i4224 %p2, %t2059
%t2061 = select i1 %t2058, i4224 0, i4224 %t2060
%t2062 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2044, i4224 %t2050)
%t2063 = extractvalue {i4224, i1} %t2062, 0
%t2064 = extractvalue {i4224, i1} %t2062, 1
%t2065 = zext i1 %t2064 to i8
call void @resid_overflow_check(i8 %t2065)
%t2066 = and i4224 %t2063, %t2043
%t2067 = zext i64 2048 to i4224
%t2068 = icmp uge i4224 %t2067, 4224
%t2069 = add i4224 %t2067, 0
%t2070 = lshr i4224 %t2063, %t2069
%t2071 = select i1 %t2068, i4224 0, i4224 %t2070
%t2072 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2049, i4224 %t2050)
%t2073 = extractvalue {i4224, i1} %t2072, 0
%t2074 = extractvalue {i4224, i1} %t2072, 1
%t2075 = zext i1 %t2074 to i8
call void @resid_overflow_check(i8 %t2075)
%t2076 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2073, i4224 %t2071)
%t2077 = extractvalue {i4224, i1} %t2076, 0
%t2078 = extractvalue {i4224, i1} %t2076, 1
%t2079 = zext i1 %t2078 to i8
call void @resid_overflow_check(i8 %t2079)
%t2080 = and i4224 %t2077, %t2043
%t2081 = zext i64 2048 to i4224
%t2082 = icmp uge i4224 %t2081, 4224
%t2083 = add i4224 %t2081, 0
%t2084 = lshr i4224 %t2077, %t2083
%t2085 = select i1 %t2082, i4224 0, i4224 %t2084
%t2086 = mul i4224 %t2066, %p3
%t2087 = and i4224 %t2086, %t2043
%t2088 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2087, i4224 %t2056)
%t2089 = extractvalue {i4224, i1} %t2088, 0
%t2090 = extractvalue {i4224, i1} %t2088, 1
%t2091 = zext i1 %t2090 to i8
call void @resid_overflow_check(i8 %t2091)
%t2092 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2066, i4224 %t2089)
%t2093 = extractvalue {i4224, i1} %t2092, 0
%t2094 = extractvalue {i4224, i1} %t2092, 1
%t2095 = zext i1 %t2094 to i8
call void @resid_overflow_check(i8 %t2095)
%t2096 = zext i64 2048 to i4224
%t2097 = icmp uge i4224 %t2096, 4224
%t2098 = add i4224 %t2096, 0
%t2099 = lshr i4224 %t2093, %t2098
%t2100 = select i1 %t2097, i4224 0, i4224 %t2099
%t2101 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2087, i4224 %t2061)
%t2102 = extractvalue {i4224, i1} %t2101, 0
%t2103 = extractvalue {i4224, i1} %t2101, 1
%t2104 = zext i1 %t2103 to i8
call void @resid_overflow_check(i8 %t2104)
%t2105 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2080, i4224 %t2102)
%t2106 = extractvalue {i4224, i1} %t2105, 0
%t2107 = extractvalue {i4224, i1} %t2105, 1
%t2108 = zext i1 %t2107 to i8
call void @resid_overflow_check(i8 %t2108)
%t2109 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2106, i4224 %t2100)
%t2110 = extractvalue {i4224, i1} %t2109, 0
%t2111 = extractvalue {i4224, i1} %t2109, 1
%t2112 = zext i1 %t2111 to i8
call void @resid_overflow_check(i8 %t2112)
%t2113 = and i4224 %t2110, %t2043
%t2114 = zext i64 2048 to i4224
%t2115 = icmp uge i4224 %t2114, 4224
%t2116 = add i4224 %t2114, 0
%t2117 = lshr i4224 %t2110, %t2116
%t2118 = select i1 %t2115, i4224 0, i4224 %t2117
%t2119 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2085, i4224 %t2118)
%t2120 = extractvalue {i4224, i1} %t2119, 0
%t2121 = extractvalue {i4224, i1} %t2119, 1
%t2122 = zext i1 %t2121 to i8
call void @resid_overflow_check(i8 %t2122)
%t2123 = and i4224 %t2120, %t2043
%t2124 = zext i64 2048 to i4224
%t2125 = icmp uge i4224 %t2124, 4224
%t2126 = add i4224 %t2124, 0
%t2127 = lshr i4224 %t2120, %t2126
%t2128 = select i1 %t2125, i4224 0, i4224 %t2127
%t2129 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2044, i4224 %t2055)
%t2130 = extractvalue {i4224, i1} %t2129, 0
%t2131 = extractvalue {i4224, i1} %t2129, 1
%t2132 = zext i1 %t2131 to i8
call void @resid_overflow_check(i8 %t2132)
%t2133 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2113, i4224 %t2130)
%t2134 = extractvalue {i4224, i1} %t2133, 0
%t2135 = extractvalue {i4224, i1} %t2133, 1
%t2136 = zext i1 %t2135 to i8
call void @resid_overflow_check(i8 %t2136)
%t2137 = and i4224 %t2134, %t2043
%t2138 = zext i64 2048 to i4224
%t2139 = icmp uge i4224 %t2138, 4224
%t2140 = add i4224 %t2138, 0
%t2141 = lshr i4224 %t2134, %t2140
%t2142 = select i1 %t2139, i4224 0, i4224 %t2141
%t2143 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2049, i4224 %t2055)
%t2144 = extractvalue {i4224, i1} %t2143, 0
%t2145 = extractvalue {i4224, i1} %t2143, 1
%t2146 = zext i1 %t2145 to i8
call void @resid_overflow_check(i8 %t2146)
%t2147 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2123, i4224 %t2144)
%t2148 = extractvalue {i4224, i1} %t2147, 0
%t2149 = extractvalue {i4224, i1} %t2147, 1
%t2150 = zext i1 %t2149 to i8
call void @resid_overflow_check(i8 %t2150)
%t2151 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2148, i4224 %t2142)
%t2152 = extractvalue {i4224, i1} %t2151, 0
%t2153 = extractvalue {i4224, i1} %t2151, 1
%t2154 = zext i1 %t2153 to i8
call void @resid_overflow_check(i8 %t2154)
%t2155 = and i4224 %t2152, %t2043
%t2156 = zext i64 2048 to i4224
%t2157 = icmp uge i4224 %t2156, 4224
%t2158 = add i4224 %t2156, 0
%t2159 = lshr i4224 %t2152, %t2158
%t2160 = select i1 %t2157, i4224 0, i4224 %t2159
%t2161 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2128, i4224 %t2160)
%t2162 = extractvalue {i4224, i1} %t2161, 0
%t2163 = extractvalue {i4224, i1} %t2161, 1
%t2164 = zext i1 %t2163 to i8
call void @resid_overflow_check(i8 %t2164)
%t2165 = and i4224 %t2162, %t2043
%t2166 = zext i64 2048 to i4224
%t2167 = icmp uge i4224 %t2166, 4224
%t2168 = add i4224 %t2166, 0
%t2169 = lshr i4224 %t2162, %t2168
%t2170 = select i1 %t2167, i4224 0, i4224 %t2169
%t2171 = mul i4224 %t2137, %p3
%t2172 = and i4224 %t2171, %t2043
%t2173 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2172, i4224 %t2056)
%t2174 = extractvalue {i4224, i1} %t2173, 0
%t2175 = extractvalue {i4224, i1} %t2173, 1
%t2176 = zext i1 %t2175 to i8
call void @resid_overflow_check(i8 %t2176)
%t2177 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2137, i4224 %t2174)
%t2178 = extractvalue {i4224, i1} %t2177, 0
%t2179 = extractvalue {i4224, i1} %t2177, 1
%t2180 = zext i1 %t2179 to i8
call void @resid_overflow_check(i8 %t2180)
%t2181 = zext i64 2048 to i4224
%t2182 = icmp uge i4224 %t2181, 4224
%t2183 = add i4224 %t2181, 0
%t2184 = lshr i4224 %t2178, %t2183
%t2185 = select i1 %t2182, i4224 0, i4224 %t2184
%t2186 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2172, i4224 %t2061)
%t2187 = extractvalue {i4224, i1} %t2186, 0
%t2188 = extractvalue {i4224, i1} %t2186, 1
%t2189 = zext i1 %t2188 to i8
call void @resid_overflow_check(i8 %t2189)
%t2190 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2155, i4224 %t2187)
%t2191 = extractvalue {i4224, i1} %t2190, 0
%t2192 = extractvalue {i4224, i1} %t2190, 1
%t2193 = zext i1 %t2192 to i8
call void @resid_overflow_check(i8 %t2193)
%t2194 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2191, i4224 %t2185)
%t2195 = extractvalue {i4224, i1} %t2194, 0
%t2196 = extractvalue {i4224, i1} %t2194, 1
%t2197 = zext i1 %t2196 to i8
call void @resid_overflow_check(i8 %t2197)
%t2198 = and i4224 %t2195, %t2043
%t2199 = zext i64 2048 to i4224
%t2200 = icmp uge i4224 %t2199, 4224
%t2201 = add i4224 %t2199, 0
%t2202 = lshr i4224 %t2195, %t2201
%t2203 = select i1 %t2200, i4224 0, i4224 %t2202
%t2204 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2165, i4224 %t2203)
%t2205 = extractvalue {i4224, i1} %t2204, 0
%t2206 = extractvalue {i4224, i1} %t2204, 1
%t2207 = zext i1 %t2206 to i8
call void @resid_overflow_check(i8 %t2207)
%t2208 = and i4224 %t2205, %t2043
%t2209 = zext i64 2048 to i4224
%t2210 = icmp uge i4224 %t2209, 4224
%t2211 = add i4224 %t2209, 0
%t2212 = lshr i4224 %t2205, %t2211
%t2213 = select i1 %t2210, i4224 0, i4224 %t2212
%t2214 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2170, i4224 %t2213)
%t2215 = extractvalue {i4224, i1} %t2214, 0
%t2216 = extractvalue {i4224, i1} %t2214, 1
%t2217 = zext i1 %t2216 to i8
call void @resid_overflow_check(i8 %t2217)
%t2218 = zext i64 2048 to i4224
%t2219 = icmp uge i4224 %t2218, 4224
%t2220 = add i4224 %t2218, 0
%t2221 = shl i4224 %t2208, %t2220
%t2222 = select i1 %t2219, i4224 0, i4224 %t2221
%t2223 = or i4224 %t2198, %t2222
%t2224 = zext i64 4096 to i4224
%t2225 = icmp uge i4224 %t2224, 4224
%t2226 = add i4224 %t2224, 0
%t2227 = shl i4224 1, %t2226
%t2228 = select i1 %t2225, i4224 0, i4224 %t2227
%t2229 = icmp ne i4224 %t2215, 0
br i1 %t2229, label %L313, label %L314
L313:
%t2230 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2223, i4224 %t2228)
%t2231 = extractvalue {i4224, i1} %t2230, 0
%t2232 = extractvalue {i4224, i1} %t2230, 1
%t2233 = zext i1 %t2232 to i8
call void @resid_overflow_check(i8 %t2233)
%t2234 = call {i4224, i1} @llvm.usub.with.overflow.i4224(i4224 %t2231, i4224 %p2)
%t2235 = extractvalue {i4224, i1} %t2234, 0
%t2236 = extractvalue {i4224, i1} %t2234, 1
%t2237 = zext i1 %t2236 to i8
call void @resid_overflow_check(i8 %t2237)
br label %L315
L314:
%t2238 = icmp uge i4224 %t2223, %p2
br i1 %t2238, label %L316, label %L317
L316:
%t2239 = call {i4224, i1} @llvm.usub.with.overflow.i4224(i4224 %t2223, i4224 %p2)
%t2240 = extractvalue {i4224, i1} %t2239, 0
%t2241 = extractvalue {i4224, i1} %t2239, 1
%t2242 = zext i1 %t2241 to i8
call void @resid_overflow_check(i8 %t2242)
br label %L318
L317:
br label %L318
L318:
%t2243 = phi i4224 [ %t2240, %L316 ], [ %t2223, %L317 ]
br label %L315
L315:
%t2244 = phi i4224 [ %t2235, %L313 ], [ %t2243, %L318 ]
ret i4224 %t2244
}
define i4224 @__m____________lib_bignum_resid__bw_mul(i1 %p0, i4224 %p1, i4224 %p2, i4224 %p3, i4224 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br i1 %p0, label %L319, label %L320
L319:
%t2245 = call i4224 @__m____________lib_bignum_resid__bw_mm2(i4224 %p1, i4224 %p2, i4224 %p3, i4224 %p4)
br label %L321
L320:
%t2246 = call i4224 @__m____________lib_bignum_resid__bw_mm1(i4224 %p1, i4224 %p2, i4224 %p3, i4224 %p4)
br label %L321
L321:
%t2247 = phi i4224 [ %t2245, %L319 ], [ %t2246, %L320 ]
ret i4224 %t2247
}
define i4224 @__m____________lib_bignum_resid__bw_exp(i1 %p0.in, i4224 %p1.in, ptr %p2.in, i64 %p3.in, i4224 %p4.in, i4224 %p5.in, i4224 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i1 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i4224 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t2254, %tco.s0 ]
%p4 = phi i4224 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i4224 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%p6 = phi i4224 [ %p6.in, %entry ], [ %t2253, %tco.s0 ]
%t2248 = icmp slt i64 %p3, 0
br i1 %t2248, label %L322, label %L324
L322:
ret i4224 %p6
L324:
%t2249 = call i4224 @__m____________lib_bignum_resid__bw_mul(i1 %p0, i4224 %p6, i4224 %p6, i4224 %p4, i4224 %p5)
%t2250 = call i64 @bn_bit(ptr %p2, i64 %p3)
%t2251 = icmp eq i64 %t2250, 1
br i1 %t2251, label %L325, label %L326
L325:
%t2252 = call i4224 @__m____________lib_bignum_resid__bw_mul(i1 %p0, i4224 %t2249, i4224 %p1, i4224 %p4, i4224 %p5)
br label %L327
L326:
br label %L327
L327:
%t2253 = phi i4224 [ %t2252, %L325 ], [ %t2249, %L326 ]
%t2254 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_bignum_resid__bn_native_exp(ptr %p0, ptr %p1, ptr %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2256 = icmp sgt i64 %p3, 2048
br i1 %t2256, label %L328, label %L329
L328:
br label %L330
L329:
br label %L330
L330:
%t2257 = phi i64 [ 4096, %L328 ], [ 2048, %L329 ]
%t2258 = call i64 @resid_list_len(ptr %p2)
%t2259 = sub nsw i64 %t2258, 1
%t2260 = sext i64 0 to i4224
%t2261 = call i4224 @__m____________lib_bignum_resid__bw_of(ptr %p2, i64 %t2259, i4224 %t2260)
%t2262 = call i4224 @__m____________lib_bignum_resid__bw_ninv(i4224 %t2261)
%t2263 = sext i64 1 to i4224
%t2264 = call i4224 @__m____________lib_bignum_resid__bw_double(i4224 %t2263, i4224 %t2261, i64 %t2257)
%t2265 = call i4224 @__m____________lib_bignum_resid__bw_double(i4224 %t2264, i4224 %t2261, i64 %t2257)
%t2266 = call i64 @resid_list_len(ptr %p0)
%t2267 = sub nsw i64 %t2266, 1
%t2268 = sext i64 0 to i4224
%t2269 = call i4224 @__m____________lib_bignum_resid__bw_of(ptr %p0, i64 %t2267, i4224 %t2268)
%t2270 = call i4224 @__m____________lib_bignum_resid__bw_mul(i1 %t2256, i4224 %t2269, i4224 %t2265, i4224 %t2261, i4224 %t2262)
%t2271 = call i64 @bn_bit_len(ptr %p1)
%t2272 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t2271, i64 1)
%t2273 = extractvalue {i64, i1} %t2272, 0
%t2274 = extractvalue {i64, i1} %t2272, 1
%t2275 = zext i1 %t2274 to i8
call void @resid_overflow_check(i8 %t2275)
%t2276 = call i4224 @__m____________lib_bignum_resid__bw_exp(i1 %t2256, i4224 %t2270, ptr %p1, i64 %t2273, i4224 %t2261, i4224 %t2262, i4224 %t2264)
%t2277 = sext i64 1 to i4224
%t2278 = call i4224 @__m____________lib_bignum_resid__bw_mul(i1 %t2256, i4224 %t2276, i4224 %t2277, i4224 %t2261, i4224 %t2262)
%t2279 = call i64 @resid_list_len(ptr %p2)
%t2280 = call ptr @resid_listbuf_new()
%t2281 = call ptr @__m____________lib_bignum_resid__bw_to(i4224 %t2278, i64 %t2279, i64 0, ptr %t2280)
ret ptr %t2281
}
define i64 @__m____________lib_word_resid__wi_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2282 = xor i64 %p0, %p1
ret i64 %t2282
}
define i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2283 = and i64 %p0, %p1
ret i64 %t2283
}
define i64 @__m____________lib_word_resid__wi_or(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2284 = or i64 %p0, %p1
ret i64 %t2284
}
define i64 @__m____________lib_word_resid__wi_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2285 = call i64 @wrapping_add(i64 %p0, i64 %p1)
%t2286 = and i64 %t2285, 4294967295
ret i64 %t2286
}
define i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2287 = call i64 @wrapping_add(i64 %p0, i64 %p1)
%t2288 = and i64 %t2287, 4294967295
ret i64 %t2288
}
define i64 @__m____________lib_word_resid__wi_xork(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2289 = xor i64 %p0, %p1
ret i64 %t2289
}
define i64 @__m____________lib_word_resid__wi_andk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2290 = and i64 %p0, %p1
ret i64 %t2290
}
define i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2291 = icmp uge i64 %p1, 64
%t2292 = add i64 %p1, 0
%t2293 = select i1 %t2291, i64 63, i64 %t2292
%t2294 = ashr i64 %p0, %t2293
%t2295 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t2296 = extractvalue {i64, i1} %t2295, 0
%t2297 = extractvalue {i64, i1} %t2295, 1
%t2298 = zext i1 %t2297 to i8
call void @resid_overflow_check(i8 %t2298)
%t2299 = icmp uge i64 %t2296, 64
%t2300 = add i64 %t2296, 0
%t2301 = shl i64 %p0, %t2300
%t2302 = select i1 %t2299, i64 0, i64 %t2301
%t2303 = or i64 %t2294, %t2302
%t2304 = and i64 %t2303, 4294967295
ret i64 %t2304
}
define i64 @__m____________lib_word_resid__wi_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2305 = icmp uge i64 %p1, 64
%t2306 = add i64 %p1, 0
%t2307 = select i1 %t2305, i64 63, i64 %t2306
%t2308 = ashr i64 %p0, %t2307
ret i64 %t2308
}
define i64 @__m____________lib_word_resid__wi_shl(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2309 = icmp uge i64 %p1, 64
%t2310 = add i64 %p1, 0
%t2311 = shl i64 %p0, %t2310
%t2312 = select i1 %t2309, i64 0, i64 %t2311
%t2313 = and i64 %t2312, 4294967295
ret i64 %t2313
}
define i64 @__m____________lib_word_resid__wi_not(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2314 = xor i64 %p0, 4294967295
%t2315 = and i64 %t2314, 4294967295
ret i64 %t2315
}
define i64 @__m____________lib_word_resid__wi_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i64 @__m____________lib_word_resid__wi_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2316 = and i64 %p0, 255
ret i64 %t2316
}
define i64 @__m____________lib_word_resid__wi_byte(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2317 = icmp uge i64 %p1, 64
%t2318 = add i64 %p1, 0
%t2319 = select i1 %t2317, i64 63, i64 %t2318
%t2320 = ashr i64 %p0, %t2319
%t2321 = and i64 %t2320, 255
ret i64 %t2321
}
define i64 @__m____________lib_word_resid__bi_xork(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2322 = xor i64 %p0, %p1
ret i64 %t2322
}
define i64 @__m____________lib_word_resid__bi_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2323 = xor i64 %p0, %p1
ret i64 %t2323
}
define i64 @__m____________lib_word_resid__bi_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i32 @__m____________lib_word_resid__ws_xor(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2324 = xor i32 %p0, %p1
ret i32 %t2324
}
define i32 @__m____________lib_word_resid__ws_and(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2325 = and i32 %p0, %p1
ret i32 %t2325
}
define i32 @__m____________lib_word_resid__ws_or(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2326 = or i32 %p0, %p1
ret i32 %t2326
}
define i32 @__m____________lib_word_resid__ws_add(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2327 = add i32 %p0, %p1
ret i32 %t2327
}
define i32 @__m____________lib_word_resid__ws_addk(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2328 = trunc i64 %p1 to i32
%t2329 = add i32 %p0, %t2328
ret i32 %t2329
}
define i32 @__m____________lib_word_resid__ws_xork(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2330 = trunc i64 %p1 to i32
%t2331 = xor i32 %p0, %t2330
ret i32 %t2331
}
define i32 @__m____________lib_word_resid__ws_andk(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2332 = trunc i64 %p1 to i32
%t2333 = and i32 %p0, %t2332
ret i32 %t2333
}
define i32 @__m____________lib_word_resid__ws_rotr(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2334 = trunc i64 %p1 to i32
%t2335 = icmp uge i32 %t2334, 32
%t2336 = add i32 %t2334, 0
%t2337 = lshr i32 %p0, %t2336
%t2338 = select i1 %t2335, i32 0, i32 %t2337
%t2339 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t2340 = extractvalue {i64, i1} %t2339, 0
%t2341 = extractvalue {i64, i1} %t2339, 1
%t2342 = zext i1 %t2341 to i8
call void @resid_overflow_check(i8 %t2342)
%t2343 = trunc i64 %t2340 to i32
%t2344 = icmp uge i32 %t2343, 32
%t2345 = add i32 %t2343, 0
%t2346 = shl i32 %p0, %t2345
%t2347 = select i1 %t2344, i32 0, i32 %t2346
%t2348 = or i32 %t2338, %t2347
ret i32 %t2348
}
define i32 @__m____________lib_word_resid__ws_shr(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2349 = trunc i64 %p1 to i32
%t2350 = icmp uge i32 %t2349, 32
%t2351 = add i32 %t2349, 0
%t2352 = lshr i32 %p0, %t2351
%t2353 = select i1 %t2350, i32 0, i32 %t2352
ret i32 %t2353
}
define i32 @__m____________lib_word_resid__ws_shl(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2354 = trunc i64 %p1 to i32
%t2355 = icmp uge i32 %t2354, 32
%t2356 = add i32 %t2354, 0
%t2357 = shl i32 %p0, %t2356
%t2358 = select i1 %t2355, i32 0, i32 %t2357
ret i32 %t2358
}
define i32 @__m____________lib_word_resid__ws_not(i32 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2359 = xor i32 %p0, 4294967295
ret i32 %t2359
}
define i32 @__m____________lib_word_resid__ws_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2360 = trunc i64 %p0 to i32
ret i32 %t2360
}
define i32 @__m____________lib_word_resid__ws_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2361 = zext i8 %p0 to i32
ret i32 %t2361
}
define i8 @__m____________lib_word_resid__ws_byte(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2362 = trunc i64 %p1 to i32
%t2363 = icmp uge i32 %t2362, 32
%t2364 = add i32 %t2362, 0
%t2365 = lshr i32 %p0, %t2364
%t2366 = select i1 %t2363, i32 0, i32 %t2365
%t2367 = trunc i32 %t2366 to i8
ret i8 %t2367
}
define i8 @__m____________lib_word_resid__bs_xork(i8 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2368 = trunc i64 %p1 to i8
%t2369 = xor i8 %p0, %t2368
ret i8 %t2369
}
define i8 @__m____________lib_word_resid__bs_xor(i8 %p0, i8 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2370 = xor i8 %p0, %p1
ret i8 %t2370
}
define i8 @__m____________lib_word_resid__bs_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2371 = trunc i64 %p0 to i8
ret i8 %t2371
}
define ptr @secret_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2372 = call ptr @resid_listbuf_new()
%t2373 = call ptr @__m____________lib_word_resid__secret_bytes_at(ptr %p0, i64 0, ptr %t2372)
ret ptr %t2373
}
define ptr @__m____________lib_word_resid__secret_bytes_at(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2377, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t2385, %tco.s0 ]
%t2374 = call i64 @resid_list_len(ptr %p0)
%t2375 = icmp sge i64 %p1, %t2374
br i1 %t2375, label %L331, label %L333
L331:
%t2376 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty2376)
ret ptr %t2376
L333:
%t2377 = add nsw i64 %p1, 1
%t2378 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t2379 = call i64 @resid_unbox_i64(ptr %t2378)
%t2381 = trunc i64 %t2379 to i8
%t2383 = zext i8 %t2381 to i64
%t2382 = call ptr @resid_box_i64(i64 %t2383)
%t2385 = call ptr @resid_listbuf_push(ptr %p2, ptr %t2382)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_word_resid__di_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2387 = xor i64 %p0, %p1
ret i64 %t2387
}
define i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2388 = and i64 %p0, %p1
ret i64 %t2388
}
define i64 @__m____________lib_word_resid__di_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2389 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2389
}
define i64 @__m____________lib_word_resid__di_addk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2390 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2390
}
define i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2391 = add i64 %p1, 0
%t2392 = add i64 %t2391, 0
%t2393 = add i64 %t2392, 0
%t2394 = icmp ne i64 %t2393, %t2391
%t2395 = icmp slt i64 %p1, 0
%t2396 = or i1 %t2394, %t2395
%t2397 = zext i1 %t2396 to i8
call void @resid_conv_check(i8 %t2397)
%t2398 = icmp uge i64 %t2392, 64
%t2399 = add i64 %t2392, 0
%t2400 = lshr i64 %p0, %t2399
%t2401 = select i1 %t2398, i64 0, i64 %t2400
%t2402 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 64, i64 %p1)
%t2403 = extractvalue {i64, i1} %t2402, 0
%t2404 = extractvalue {i64, i1} %t2402, 1
%t2405 = zext i1 %t2404 to i8
call void @resid_overflow_check(i8 %t2405)
%t2406 = add i64 %t2403, 0
%t2407 = add i64 %t2406, 0
%t2408 = add i64 %t2407, 0
%t2409 = icmp ne i64 %t2408, %t2406
%t2410 = icmp slt i64 %t2403, 0
%t2411 = or i1 %t2409, %t2410
%t2412 = zext i1 %t2411 to i8
call void @resid_conv_check(i8 %t2412)
%t2413 = icmp uge i64 %t2407, 64
%t2414 = add i64 %t2407, 0
%t2415 = shl i64 %p0, %t2414
%t2416 = select i1 %t2413, i64 0, i64 %t2415
%t2417 = or i64 %t2401, %t2416
ret i64 %t2417
}
define i64 @__m____________lib_word_resid__di_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2418 = add i64 %p1, 0
%t2419 = add i64 %t2418, 0
%t2420 = add i64 %t2419, 0
%t2421 = icmp ne i64 %t2420, %t2418
%t2422 = icmp slt i64 %p1, 0
%t2423 = or i1 %t2421, %t2422
%t2424 = zext i1 %t2423 to i8
call void @resid_conv_check(i8 %t2424)
%t2425 = icmp uge i64 %t2419, 64
%t2426 = add i64 %t2419, 0
%t2427 = lshr i64 %p0, %t2426
%t2428 = select i1 %t2425, i64 0, i64 %t2427
ret i64 %t2428
}
define i64 @__m____________lib_word_resid__di_not(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2429 = add i128 18446744073709551615, 0
%t2430 = trunc i128 %t2429 to i64
%t2431 = zext i64 %t2430 to i128
%t2432 = icmp ne i128 %t2431, %t2429
%t2433 = icmp slt i128 18446744073709551615, 0
%t2434 = or i1 %t2432, %t2433
%t2435 = zext i1 %t2434 to i8
call void @resid_conv_check(i8 %t2435)
%t2436 = xor i64 %p0, %t2430
ret i64 %t2436
}
define i64 @__m____________lib_word_resid__di_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i64 @__m____________lib_word_resid__di_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2437 = and i64 %p0, 255
ret i64 %t2437
}
define i64 @__m____________lib_word_resid__di_byte(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2438 = add i64 %p1, 0
%t2439 = add i64 %t2438, 0
%t2440 = add i64 %t2439, 0
%t2441 = icmp ne i64 %t2440, %t2438
%t2442 = icmp slt i64 %p1, 0
%t2443 = or i1 %t2441, %t2442
%t2444 = zext i1 %t2443 to i8
call void @resid_conv_check(i8 %t2444)
%t2445 = icmp uge i64 %t2439, 64
%t2446 = add i64 %t2439, 0
%t2447 = lshr i64 %p0, %t2446
%t2448 = select i1 %t2445, i64 0, i64 %t2447
%t2449 = and i64 %t2448, 255
ret i64 %t2449
}
define i64 @__m____________lib_word_resid__ds_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2450 = xor i64 %p0, %p1
ret i64 %t2450
}
define i64 @__m____________lib_word_resid__ds_and(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2451 = and i64 %p0, %p1
ret i64 %t2451
}
define i64 @__m____________lib_word_resid__ds_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2452 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2452
}
define i64 @__m____________lib_word_resid__ds_addk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2453 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2453
}
define i64 @__m____________lib_word_resid__ds_rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2454 = add i64 %p1, 0
%t2455 = add i64 %t2454, 0
%t2456 = add i64 %t2455, 0
%t2457 = icmp ne i64 %t2456, %t2454
%t2458 = icmp slt i64 %p1, 0
%t2459 = or i1 %t2457, %t2458
%t2460 = zext i1 %t2459 to i8
call void @resid_conv_check(i8 %t2460)
%t2461 = icmp uge i64 %t2455, 64
%t2462 = add i64 %t2455, 0
%t2463 = lshr i64 %p0, %t2462
%t2464 = select i1 %t2461, i64 0, i64 %t2463
%t2465 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 64, i64 %p1)
%t2466 = extractvalue {i64, i1} %t2465, 0
%t2467 = extractvalue {i64, i1} %t2465, 1
%t2468 = zext i1 %t2467 to i8
call void @resid_overflow_check(i8 %t2468)
%t2469 = add i64 %t2466, 0
%t2470 = add i64 %t2469, 0
%t2471 = add i64 %t2470, 0
%t2472 = icmp ne i64 %t2471, %t2469
%t2473 = icmp slt i64 %t2466, 0
%t2474 = or i1 %t2472, %t2473
%t2475 = zext i1 %t2474 to i8
call void @resid_conv_check(i8 %t2475)
%t2476 = icmp uge i64 %t2470, 64
%t2477 = add i64 %t2470, 0
%t2478 = shl i64 %p0, %t2477
%t2479 = select i1 %t2476, i64 0, i64 %t2478
%t2480 = or i64 %t2464, %t2479
ret i64 %t2480
}
define i64 @__m____________lib_word_resid__ds_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2481 = add i64 %p1, 0
%t2482 = add i64 %t2481, 0
%t2483 = add i64 %t2482, 0
%t2484 = icmp ne i64 %t2483, %t2481
%t2485 = icmp slt i64 %p1, 0
%t2486 = or i1 %t2484, %t2485
%t2487 = zext i1 %t2486 to i8
call void @resid_conv_check(i8 %t2487)
%t2488 = icmp uge i64 %t2482, 64
%t2489 = add i64 %t2482, 0
%t2490 = lshr i64 %p0, %t2489
%t2491 = select i1 %t2488, i64 0, i64 %t2490
ret i64 %t2491
}
define i64 @__m____________lib_word_resid__ds_not(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2492 = add i128 18446744073709551615, 0
%t2493 = trunc i128 %t2492 to i64
%t2494 = zext i64 %t2493 to i128
%t2495 = icmp ne i128 %t2494, %t2492
%t2496 = icmp slt i128 18446744073709551615, 0
%t2497 = or i1 %t2495, %t2496
%t2498 = zext i1 %t2497 to i8
call void @resid_conv_check(i8 %t2498)
%t2499 = xor i64 %p0, %t2493
ret i64 %t2499
}
define i64 @__m____________lib_word_resid__ds_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i64 @__m____________lib_word_resid__ds_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2500 = zext i8 %p0 to i64
ret i64 %t2500
}
define i8 @__m____________lib_word_resid__ds_byte(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2501 = add i64 %p1, 0
%t2502 = add i64 %t2501, 0
%t2503 = add i64 %t2502, 0
%t2504 = icmp ne i64 %t2503, %t2501
%t2505 = icmp slt i64 %p1, 0
%t2506 = or i1 %t2504, %t2505
%t2507 = zext i1 %t2506 to i8
call void @resid_conv_check(i8 %t2507)
%t2508 = icmp uge i64 %t2502, 64
%t2509 = add i64 %t2502, 0
%t2510 = lshr i64 %p0, %t2509
%t2511 = select i1 %t2508, i64 0, i64 %t2510
%t2512 = trunc i64 %t2511 to i8
ret i8 %t2512
}
define i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2513 = add i512 %p0, %p1
ret i512 %t2513
}
define i512 @__m____________lib_word_resid__pi_sub(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2514 = sub i512 %p0, %p1
ret i512 %t2514
}
define i512 @__m____________lib_word_resid__pi_mul(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2515 = mul i512 %p0, %p1
ret i512 %t2515
}
define i512 @__m____________lib_word_resid__pi_mul256(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2516 = trunc i512 %p0 to i256
%t2517 = zext i256 %t2516 to i512
%t2518 = trunc i512 %p1 to i256
%t2519 = zext i256 %t2518 to i512
%t2520 = mul i512 %t2517, %t2519
ret i512 %t2520
}
define i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2521 = and i512 %p0, %p1
ret i512 %t2521
}
define i512 @__m____________lib_word_resid__pi_or(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2522 = or i512 %p0, %p1
ret i512 %t2522
}
define i512 @__m____________lib_word_resid__pi_xor(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2523 = xor i512 %p0, %p1
ret i512 %t2523
}
define i512 @__m____________lib_word_resid__pi_shl(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2524 = sext i64 %p1 to i512
%t2525 = icmp uge i512 %t2524, 512
%t2526 = add i512 %t2524, 0
%t2527 = shl i512 %p0, %t2526
%t2528 = select i1 %t2525, i512 0, i512 %t2527
ret i512 %t2528
}
define i512 @__m____________lib_word_resid__pi_shr(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2529 = sext i64 %p1 to i512
%t2530 = icmp uge i512 %t2529, 512
%t2531 = add i512 %t2529, 0
%t2532 = select i1 %t2530, i512 511, i512 %t2531
%t2533 = ashr i512 %p0, %t2532
ret i512 %t2533
}
define i512 @__m____________lib_word_resid__pi_sign(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2534 = ashr i512 %p0, 511
%t2535 = trunc i512 %t2534 to i64
%t2536 = call i64 asm "", "=r,0"(i64 %t2535)
%t2537 = sext i64 %t2536 to i512
ret i512 %t2537
}
define i512 @__m____________lib_word_resid__pi_lift(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i512 %p0
}
define i512 @__m____________lib_word_resid__pi_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2538 = and i64 %p0, 255
%t2539 = sext i64 %t2538 to i512
ret i512 %t2539
}
define i64 @__m____________lib_word_resid__pi_byte(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2540 = sext i64 %p1 to i512
%t2541 = icmp uge i512 %t2540, 512
%t2542 = add i512 %t2540, 0
%t2543 = select i1 %t2541, i512 511, i512 %t2542
%t2544 = ashr i512 %p0, %t2543
%t2545 = and i512 %t2544, 255
%t2546 = trunc i512 %t2545 to i64
ret i64 %t2546
}
define i512 @__m____________lib_word_resid__ps_add(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2547 = add i512 %p0, %p1
ret i512 %t2547
}
define i512 @__m____________lib_word_resid__ps_sub(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2548 = sub i512 %p0, %p1
ret i512 %t2548
}
define i512 @__m____________lib_word_resid__ps_mul(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2549 = mul i512 %p0, %p1
ret i512 %t2549
}
define i512 @__m____________lib_word_resid__ps_mul256(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2550 = trunc i512 %p0 to i256
%t2551 = zext i256 %t2550 to i512
%t2552 = trunc i512 %p1 to i256
%t2553 = zext i256 %t2552 to i512
%t2554 = mul i512 %t2551, %t2553
ret i512 %t2554
}
define i512 @__m____________lib_word_resid__ps_and(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2555 = and i512 %p0, %p1
ret i512 %t2555
}
define i512 @__m____________lib_word_resid__ps_or(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2556 = or i512 %p0, %p1
ret i512 %t2556
}
define i512 @__m____________lib_word_resid__ps_xor(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2557 = xor i512 %p0, %p1
ret i512 %t2557
}
define i512 @__m____________lib_word_resid__ps_shl(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2558 = sext i64 %p1 to i512
%t2559 = icmp uge i512 %t2558, 512
%t2560 = add i512 %t2558, 0
%t2561 = shl i512 %p0, %t2560
%t2562 = select i1 %t2559, i512 0, i512 %t2561
ret i512 %t2562
}
define i512 @__m____________lib_word_resid__ps_shr(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2563 = sext i64 %p1 to i512
%t2564 = icmp uge i512 %t2563, 512
%t2565 = add i512 %t2563, 0
%t2566 = select i1 %t2564, i512 511, i512 %t2565
%t2567 = ashr i512 %p0, %t2566
ret i512 %t2567
}
define i512 @__m____________lib_word_resid__ps_sign(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2568 = ashr i512 %p0, 511
%t2569 = trunc i512 %t2568 to i64
%t2570 = call i64 asm "", "=r,0"(i64 %t2569)
%t2571 = sext i64 %t2570 to i512
ret i512 %t2571
}
define i512 @__m____________lib_word_resid__ps_lift(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i512 %p0
}
define i512 @__m____________lib_word_resid__ps_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2572 = zext i8 %p0 to i512
ret i512 %t2572
}
define i8 @__m____________lib_word_resid__ps_byte(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2573 = sext i64 %p1 to i512
%t2574 = icmp uge i512 %t2573, 512
%t2575 = add i512 %t2573, 0
%t2576 = select i1 %t2574, i512 511, i512 %t2575
%t2577 = ashr i512 %p0, %t2576
%t2578 = trunc i512 %t2577 to i8
ret i8 %t2578
}
define ptr @__m____________lib_word_resid__wi_publish(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret ptr %p0
}
define ptr @__m____________lib_word_resid__ws_publish(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
call void @resid_cap_check(ptr @.declassify.cap)
%t2579 = call ptr @resid_listbuf_new()
%t2580 = call ptr @__m____________lib_word_resid__ws_widen(ptr %p0, i64 0, ptr %t2579)
ret ptr %t2580
}
define ptr @__m____________lib_word_resid__ws_widen(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2588 = alloca [17 x i8], align 16 ; fixed
%t2589 = alloca [48 x i8], align 16 ; fixed
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2584, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t2602, %tco.s0 ]
%t2581 = call i64 @resid_list_len(ptr %p0)
%t2582 = icmp sge i64 %p1, %t2581
br i1 %t2582, label %L334, label %L336
L334:
%t2583 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty2583)
ret ptr %t2583
L336:
%t2584 = add nsw i64 %p1, 1
%t2585 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t2587 = call i64 @resid_unbox_i64(ptr %t2585)
%t2586 = trunc i64 %t2587 to i8
store i8 %t2586, ptr %t2588
%t2590 = ptrtoint ptr %t2588 to i64
store i64 1296236546, ptr %t2589
%t2591 = getelementptr i64, ptr %t2589, i64 1
store i64 %t2590, ptr %t2591
%t2592 = getelementptr i64, ptr %t2589, i64 2
store i64 1, ptr %t2592
%t2593 = getelementptr i64, ptr %t2589, i64 3
store i64 0, ptr %t2593
%t2594 = getelementptr i64, ptr %t2589, i64 4
store i64 0, ptr %t2594
%t2595 = getelementptr i64, ptr %t2589, i64 5
store i64 0, ptr %t2595
%t2596 = call i64 asm sideeffect "rolq $$3, %rdi ; rolq $$13, %rdi ; rolq $$61, %rdi ; rolq $$51, %rdi ; xchgq %rbx, %rbx", "={dx},{ax},0,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(ptr %t2589, i64 0)
%t2597 = load i8, ptr %t2588
%t2598 = zext i8 %t2597 to i64
%t2599 = call ptr @resid_box_i64(i64 %t2598)
%t2602 = call ptr @resid_listbuf_push(ptr %p2, ptr %t2599)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i128 @__m____________lib_word_resid__xi_xor(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2604 = xor i128 %p0, %p1
ret i128 %t2604
}
define i128 @__m____________lib_word_resid__xi_and(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2605 = and i128 %p0, %p1
ret i128 %t2605
}
define i128 @__m____________lib_word_resid__xi_or(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2606 = or i128 %p0, %p1
ret i128 %t2606
}
define i128 @__m____________lib_word_resid__xi_shl(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2607 = sext i64 %p1 to i128
%t2608 = add i128 %t2607, 0
%t2609 = add i128 %t2608, 0
%t2610 = icmp ne i128 %t2609, %t2607
%t2611 = icmp slt i64 %p1, 0
%t2612 = or i1 %t2610, %t2611
%t2613 = zext i1 %t2612 to i8
call void @resid_conv_check(i8 %t2613)
%t2614 = icmp uge i128 %t2608, 128
%t2615 = add i128 %t2608, 0
%t2616 = shl i128 %p0, %t2615
%t2617 = select i1 %t2614, i128 0, i128 %t2616
ret i128 %t2617
}
define i128 @__m____________lib_word_resid__xi_shr(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2618 = sext i64 %p1 to i128
%t2619 = add i128 %t2618, 0
%t2620 = add i128 %t2619, 0
%t2621 = icmp ne i128 %t2620, %t2618
%t2622 = icmp slt i64 %p1, 0
%t2623 = or i1 %t2621, %t2622
%t2624 = zext i1 %t2623 to i8
call void @resid_conv_check(i8 %t2624)
%t2625 = icmp uge i128 %t2619, 128
%t2626 = add i128 %t2619, 0
%t2627 = lshr i128 %p0, %t2626
%t2628 = select i1 %t2625, i128 0, i128 %t2627
ret i128 %t2628
}
define i128 @__m____________lib_word_resid__xi_lift(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i128 %p0
}
define i128 @__m____________lib_word_resid__xi_from_word(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2629 = and i64 %p0, 4294967295
%t2630 = zext i64 %t2629 to i128
ret i128 %t2630
}
define i64 @__m____________lib_word_resid__xi_word(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2631 = sext i64 %p1 to i128
%t2632 = add i128 %t2631, 0
%t2633 = add i128 %t2632, 0
%t2634 = icmp ne i128 %t2633, %t2631
%t2635 = icmp slt i64 %p1, 0
%t2636 = or i1 %t2634, %t2635
%t2637 = zext i1 %t2636 to i8
call void @resid_conv_check(i8 %t2637)
%t2638 = icmp uge i128 %t2632, 128
%t2639 = add i128 %t2632, 0
%t2640 = lshr i128 %p0, %t2639
%t2641 = select i1 %t2638, i128 0, i128 %t2640
%t2642 = and i128 %t2641, 4294967295
%t2643 = trunc i128 %t2642 to i64
ret i64 %t2643
}
define i128 @__m____________lib_word_resid__xi_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2644 = and i64 %p0, 255
%t2645 = zext i64 %t2644 to i128
ret i128 %t2645
}
define i64 @__m____________lib_word_resid__xi_byte(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2646 = sext i64 %p1 to i128
%t2647 = add i128 %t2646, 0
%t2648 = add i128 %t2647, 0
%t2649 = icmp ne i128 %t2648, %t2646
%t2650 = icmp slt i64 %p1, 0
%t2651 = or i1 %t2649, %t2650
%t2652 = zext i1 %t2651 to i8
call void @resid_conv_check(i8 %t2652)
%t2653 = icmp uge i128 %t2647, 128
%t2654 = add i128 %t2647, 0
%t2655 = lshr i128 %p0, %t2654
%t2656 = select i1 %t2653, i128 0, i128 %t2655
%t2657 = and i128 %t2656, 255
%t2658 = trunc i128 %t2657 to i64
ret i64 %t2658
}
define i128 @__m____________lib_word_resid__xi_bit(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2659 = sext i64 %p1 to i128
%t2660 = add i128 %t2659, 0
%t2661 = add i128 %t2660, 0
%t2662 = icmp ne i128 %t2661, %t2659
%t2663 = icmp slt i64 %p1, 0
%t2664 = or i1 %t2662, %t2663
%t2665 = zext i1 %t2664 to i8
call void @resid_conv_check(i8 %t2665)
%t2666 = icmp uge i128 %t2660, 128
%t2667 = add i128 %t2660, 0
%t2668 = lshr i128 %p0, %t2667
%t2669 = select i1 %t2666, i128 0, i128 %t2668
%t2670 = and i128 %t2669, 1
%t2671 = trunc i128 %t2670 to i64
%t2672 = call i64 asm "", "=r,0"(i64 %t2671)
%t2673 = sext i64 %t2672 to i128
%t2674 = sub i128 0, %t2673
ret i128 %t2674
}
define i128 @__m____________lib_word_resid__xi_aes_round(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2675 = bitcast i128 %p0 to <2 x i64>
%t2676 = bitcast i128 %p1 to <2 x i64>
%t2677 = call <2 x i64> @llvm.x86.aesni.aesenc(<2 x i64> %t2675, <2 x i64> %t2676)
%t2678 = bitcast <2 x i64> %t2677 to i128
ret i128 %t2678
}
define i128 @__m____________lib_word_resid__xi_aes_last(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2679 = bitcast i128 %p0 to <2 x i64>
%t2680 = bitcast i128 %p1 to <2 x i64>
%t2681 = call <2 x i64> @llvm.x86.aesni.aesenclast(<2 x i64> %t2679, <2 x i64> %t2680)
%t2682 = bitcast <2 x i64> %t2681 to i128
ret i128 %t2682
}
define i128 @__m____________lib_word_resid__xi_clmul(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2683 = call i128 @e.gf128(i128 %p0, i128 %p1)
ret i128 %t2683
}
define i128 @__m____________lib_word_resid__xs_xor(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2684 = xor i128 %p0, %p1
ret i128 %t2684
}
define i128 @__m____________lib_word_resid__xs_and(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2685 = and i128 %p0, %p1
ret i128 %t2685
}
define i128 @__m____________lib_word_resid__xs_or(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2686 = or i128 %p0, %p1
ret i128 %t2686
}
define i128 @__m____________lib_word_resid__xs_shl(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2687 = sext i64 %p1 to i128
%t2688 = add i128 %t2687, 0
%t2689 = add i128 %t2688, 0
%t2690 = icmp ne i128 %t2689, %t2687
%t2691 = icmp slt i64 %p1, 0
%t2692 = or i1 %t2690, %t2691
%t2693 = zext i1 %t2692 to i8
call void @resid_conv_check(i8 %t2693)
%t2694 = icmp uge i128 %t2688, 128
%t2695 = add i128 %t2688, 0
%t2696 = shl i128 %p0, %t2695
%t2697 = select i1 %t2694, i128 0, i128 %t2696
ret i128 %t2697
}
define i128 @__m____________lib_word_resid__xs_shr(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2698 = sext i64 %p1 to i128
%t2699 = add i128 %t2698, 0
%t2700 = add i128 %t2699, 0
%t2701 = icmp ne i128 %t2700, %t2698
%t2702 = icmp slt i64 %p1, 0
%t2703 = or i1 %t2701, %t2702
%t2704 = zext i1 %t2703 to i8
call void @resid_conv_check(i8 %t2704)
%t2705 = icmp uge i128 %t2699, 128
%t2706 = add i128 %t2699, 0
%t2707 = lshr i128 %p0, %t2706
%t2708 = select i1 %t2705, i128 0, i128 %t2707
ret i128 %t2708
}
define i128 @__m____________lib_word_resid__xs_lift(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i128 %p0
}
define i128 @__m____________lib_word_resid__xs_from_word(i32 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2709 = zext i32 %p0 to i128
ret i128 %t2709
}
define i32 @__m____________lib_word_resid__xs_word(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2710 = sext i64 %p1 to i128
%t2711 = add i128 %t2710, 0
%t2712 = add i128 %t2711, 0
%t2713 = icmp ne i128 %t2712, %t2710
%t2714 = icmp slt i64 %p1, 0
%t2715 = or i1 %t2713, %t2714
%t2716 = zext i1 %t2715 to i8
call void @resid_conv_check(i8 %t2716)
%t2717 = icmp uge i128 %t2711, 128
%t2718 = add i128 %t2711, 0
%t2719 = lshr i128 %p0, %t2718
%t2720 = select i1 %t2717, i128 0, i128 %t2719
%t2721 = trunc i128 %t2720 to i32
ret i32 %t2721
}
define i128 @__m____________lib_word_resid__xs_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2722 = zext i8 %p0 to i128
ret i128 %t2722
}
define i8 @__m____________lib_word_resid__xs_byte(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2723 = sext i64 %p1 to i128
%t2724 = add i128 %t2723, 0
%t2725 = add i128 %t2724, 0
%t2726 = icmp ne i128 %t2725, %t2723
%t2727 = icmp slt i64 %p1, 0
%t2728 = or i1 %t2726, %t2727
%t2729 = zext i1 %t2728 to i8
call void @resid_conv_check(i8 %t2729)
%t2730 = icmp uge i128 %t2724, 128
%t2731 = add i128 %t2724, 0
%t2732 = lshr i128 %p0, %t2731
%t2733 = select i1 %t2730, i128 0, i128 %t2732
%t2734 = trunc i128 %t2733 to i8
ret i8 %t2734
}
define i128 @__m____________lib_word_resid__xs_bit(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2735 = sext i64 %p1 to i128
%t2736 = add i128 %t2735, 0
%t2737 = add i128 %t2736, 0
%t2738 = icmp ne i128 %t2737, %t2735
%t2739 = icmp slt i64 %p1, 0
%t2740 = or i1 %t2738, %t2739
%t2741 = zext i1 %t2740 to i8
call void @resid_conv_check(i8 %t2741)
%t2742 = icmp uge i128 %t2736, 128
%t2743 = add i128 %t2736, 0
%t2744 = lshr i128 %p0, %t2743
%t2745 = select i1 %t2742, i128 0, i128 %t2744
%t2746 = and i128 %t2745, 1
%t2747 = trunc i128 %t2746 to i64
%t2748 = call i64 asm "", "=r,0"(i64 %t2747)
%t2749 = sext i64 %t2748 to i128
%t2750 = sub i128 0, %t2749
ret i128 %t2750
}
define i128 @__m____________lib_word_resid__xs_aes_round(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2751 = bitcast i128 %p0 to <2 x i64>
%t2752 = bitcast i128 %p1 to <2 x i64>
%t2753 = call <2 x i64> @llvm.x86.aesni.aesenc(<2 x i64> %t2751, <2 x i64> %t2752)
%t2754 = bitcast <2 x i64> %t2753 to i128
ret i128 %t2754
}
define i128 @__m____________lib_word_resid__xs_aes_last(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2755 = bitcast i128 %p0 to <2 x i64>
%t2756 = bitcast i128 %p1 to <2 x i64>
%t2757 = call <2 x i64> @llvm.x86.aesni.aesenclast(<2 x i64> %t2755, <2 x i64> %t2756)
%t2758 = bitcast <2 x i64> %t2757 to i128
ret i128 %t2758
}
define i128 @__m____________lib_word_resid__xs_clmul(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2759 = call i128 @e.gf128(i128 %p0, i128 %p1)
ret i128 %t2759
}
define i64 @__m____________lib_sha256g_resid__sha2k(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2761 = call ptr @resid_list_const_i64(ptr @.lc2760, i64 64, ptr @.lcd2760, ptr @.lty2760)
%t2762 = call ptr @resid_list_get(ptr %t2761, i64 %p0)
%t2763 = call i64 @resid_unbox_i64(ptr %t2762)
ret i64 %t2763
}
define ptr @sha256g_pad(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2765 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p0, i64 9)
%t2766 = extractvalue {i64, i1} %t2765, 0
%t2767 = extractvalue {i64, i1} %t2765, 1
%t2768 = zext i1 %t2767 to i8
call void @resid_overflow_check(i8 %t2768)
%t2769 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2766, i64 63)
%t2770 = extractvalue {i64, i1} %t2769, 0
%t2771 = extractvalue {i64, i1} %t2769, 1
%t2772 = zext i1 %t2771 to i8
call void @resid_overflow_check(i8 %t2772)
%t2773 = sdiv i64 %t2770, 64
%t2774 = mul nsw i64 %t2773, 64
%t2775 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t2774, i64 %p0)
%t2776 = extractvalue {i64, i1} %t2775, 0
%t2777 = extractvalue {i64, i1} %t2775, 1
%t2778 = zext i1 %t2777 to i8
call void @resid_overflow_check(i8 %t2778)
%t2779 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t2776, i64 9)
%t2780 = extractvalue {i64, i1} %t2779, 0
%t2781 = extractvalue {i64, i1} %t2779, 1
%t2782 = zext i1 %t2781 to i8
call void @resid_overflow_check(i8 %t2782)
%t2783 = call ptr @resid_listbuf_new()
%t2784 = call ptr @__m____________lib_sha256g_resid__sha256g_pad_at__rs150(i64 %p0, i64 %t2780, i64 0, ptr %t2783)
%t2785 = call ptr @resid_listbuf_finish(ptr %t2784, ptr @.lty2785)
ret ptr %t2785
}
define ptr @__m____________lib_sha256g_resid__sha256g_pad_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ], [ %p0, %tco.s2 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ], [ %p1, %tco.s2 ]
%p2 = phi i64 [ %p2.in, %entry ], [ 1, %tco.s0 ], [ %t2794, %tco.s1 ], [ %t2820, %tco.s2 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t2790, %tco.s0 ], [ %t2800, %tco.s1 ], [ %t2835, %tco.s2 ]
%t2786 = icmp eq i64 %p2, 0
br i1 %t2786, label %L337, label %L339
L337:
%t2787 = call ptr @resid_box_i64(i64 128)
%t2790 = call ptr @resid_listbuf_push(ptr %p3, ptr %t2787)
br label %tco.s0
tco.s0:
br label %tco.head
L339:
%t2792 = icmp sle i64 %p2, %p1
br i1 %t2792, label %L340, label %L342
L340:
%t2793 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t2794 = extractvalue {i64, i1} %t2793, 0
%t2795 = extractvalue {i64, i1} %t2793, 1
%t2796 = zext i1 %t2795 to i8
call void @resid_overflow_check(i8 %t2796)
%t2797 = call ptr @resid_box_i64(i64 0)
%t2800 = call ptr @resid_listbuf_push(ptr %p3, ptr %t2797)
br label %tco.s1
tco.s1:
br label %tco.head
L342:
%t2802 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 8)
%t2803 = extractvalue {i64, i1} %t2802, 0
%t2804 = extractvalue {i64, i1} %t2802, 1
%t2805 = zext i1 %t2804 to i8
call void @resid_overflow_check(i8 %t2805)
%t2806 = icmp sle i64 %p2, %t2803
br i1 %t2806, label %L343, label %L345
L343:
%t2807 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 8)
%t2808 = extractvalue {i64, i1} %t2807, 0
%t2809 = extractvalue {i64, i1} %t2807, 1
%t2810 = zext i1 %t2809 to i8
call void @resid_overflow_check(i8 %t2810)
%t2811 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t2808, i64 %p2)
%t2812 = extractvalue {i64, i1} %t2811, 0
%t2813 = extractvalue {i64, i1} %t2811, 1
%t2814 = zext i1 %t2813 to i8
call void @resid_overflow_check(i8 %t2814)
%t2815 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t2812, i64 8)
%t2816 = extractvalue {i64, i1} %t2815, 0
%t2817 = extractvalue {i64, i1} %t2815, 1
%t2818 = zext i1 %t2817 to i8
call void @resid_overflow_check(i8 %t2818)
%t2819 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t2820 = extractvalue {i64, i1} %t2819, 0
%t2821 = extractvalue {i64, i1} %t2819, 1
%t2822 = zext i1 %t2821 to i8
call void @resid_overflow_check(i8 %t2822)
%t2823 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p0, i64 8)
%t2824 = extractvalue {i64, i1} %t2823, 0
%t2825 = extractvalue {i64, i1} %t2823, 1
%t2826 = zext i1 %t2825 to i8
call void @resid_overflow_check(i8 %t2826)
%t2827 = icmp uge i64 %t2816, 64
%t2828 = add i64 %t2816, 0
%t2829 = select i1 %t2827, i64 63, i64 %t2828
%t2830 = ashr i64 %t2824, %t2829
%t2831 = and i64 %t2830, 255
%t2832 = call ptr @resid_box_i64(i64 %t2831)
%t2835 = call ptr @resid_listbuf_push(ptr %p3, ptr %t2832)
br label %tco.s2
tco.s2:
br label %tco.head
L345:
ret ptr %p3
}
define ptr @sha256g_iv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2838 = call ptr @resid_list_const_i64(ptr @.lc2837, i64 8, ptr @.lcd2837, ptr @.lty2837)
ret ptr %t2838
}
define ptr @__m____________lib_sha256g_resid__sha256g_zeros(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2841, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t2845, %tco.s0 ]
%t2839 = icmp sge i64 %p1, %p0
br i1 %t2839, label %L346, label %L348
L346:
%t2840 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty2840)
ret ptr %t2840
L348:
%t2841 = add nsw i64 %p1, 1
%t2842 = call ptr @resid_box_i64(i64 0)
%t2845 = call ptr @resid_listbuf_push(ptr %p2, ptr %t2842)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @mask32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2847 = and i64 %p0, 4294967295
ret i64 %t2847
}
define i64 @rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2848 = icmp uge i64 %p1, 64
%t2849 = add i64 %p1, 0
%t2850 = select i1 %t2848, i64 63, i64 %t2849
%t2851 = ashr i64 %p0, %t2850
%t2852 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t2853 = extractvalue {i64, i1} %t2852, 0
%t2854 = extractvalue {i64, i1} %t2852, 1
%t2855 = zext i1 %t2854 to i8
call void @resid_overflow_check(i8 %t2855)
%t2856 = icmp uge i64 %t2853, 64
%t2857 = add i64 %t2853, 0
%t2858 = shl i64 %p0, %t2857
%t2859 = select i1 %t2856, i64 0, i64 %t2858
%t2860 = or i64 %t2851, %t2859
%t2861 = and i64 %t2860, 4294967295
ret i64 %t2861
}
define i64 @not32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2862 = xor i64 %p0, 4294967295
%t2863 = and i64 %t2862, 4294967295
ret i64 %t2863
}
define i64 @k_at(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2865 = call ptr @resid_list_const_i64(ptr @.lc2864, i64 64, ptr @.lcd2864, ptr @.lty2864)
%t2866 = call ptr @resid_list_get(ptr %t2865, i64 %p0)
%t2867 = call i64 @resid_unbox_i64(ptr %t2866)
ret i64 %t2867
}
define ptr @utf8_push_cp(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2869 = icmp slt i64 %p0, 128
br i1 %t2869, label %L349, label %L351
L349:
%t2870 = call ptr @resid_box_i64(i64 %p0)
%t2873 = call ptr @resid_listbuf_push(ptr %p1, ptr %t2870)
ret ptr %t2873
L351:
%t2874 = icmp slt i64 %p0, 2048
br i1 %t2874, label %L352, label %L354
L352:
%t2875 = ashr i64 %p0, 6
%t2876 = or i64 192, %t2875
%t2877 = call ptr @resid_box_i64(i64 %t2876)
%t2880 = call ptr @resid_listbuf_push(ptr %p1, ptr %t2877)
%t2881 = and i64 %p0, 63
%t2882 = or i64 128, %t2881
%t2883 = call ptr @resid_box_i64(i64 %t2882)
%t2886 = call ptr @resid_listbuf_push(ptr %t2880, ptr %t2883)
ret ptr %t2886
L354:
%t2887 = icmp slt i64 %p0, 65536
br i1 %t2887, label %L355, label %L357
L355:
%t2888 = ashr i64 %p0, 12
%t2889 = or i64 224, %t2888
%t2890 = call ptr @resid_box_i64(i64 %t2889)
%t2893 = call ptr @resid_listbuf_push(ptr %p1, ptr %t2890)
%t2894 = ashr i64 %p0, 6
%t2895 = and i64 %t2894, 63
%t2896 = or i64 128, %t2895
%t2897 = call ptr @resid_box_i64(i64 %t2896)
%t2900 = call ptr @resid_listbuf_push(ptr %t2893, ptr %t2897)
%t2901 = and i64 %p0, 63
%t2902 = or i64 128, %t2901
%t2903 = call ptr @resid_box_i64(i64 %t2902)
%t2906 = call ptr @resid_listbuf_push(ptr %t2900, ptr %t2903)
ret ptr %t2906
L357:
%t2907 = ashr i64 %p0, 18
%t2908 = or i64 240, %t2907
%t2909 = call ptr @resid_box_i64(i64 %t2908)
%t2912 = call ptr @resid_listbuf_push(ptr %p1, ptr %t2909)
%t2913 = ashr i64 %p0, 12
%t2914 = and i64 %t2913, 63
%t2915 = or i64 128, %t2914
%t2916 = call ptr @resid_box_i64(i64 %t2915)
%t2919 = call ptr @resid_listbuf_push(ptr %t2912, ptr %t2916)
%t2920 = ashr i64 %p0, 6
%t2921 = and i64 %t2920, 63
%t2922 = or i64 128, %t2921
%t2923 = call ptr @resid_box_i64(i64 %t2922)
%t2926 = call ptr @resid_listbuf_push(ptr %t2919, ptr %t2923)
%t2927 = and i64 %p0, 63
%t2928 = or i64 128, %t2927
%t2929 = call ptr @resid_box_i64(i64 %t2928)
%t2932 = call ptr @resid_listbuf_push(ptr %t2926, ptr %t2929)
ret ptr %t2932
}
define ptr @utf8_run(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2936, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t2938, %tco.s0 ]
%t2933 = call i64 @str_len(ptr %p0)
%t2934 = icmp sge i64 %p1, %t2933
br i1 %t2934, label %L358, label %L360
L358:
%t2935 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty2935)
ret ptr %t2935
L360:
%t2936 = add nsw i64 %p1, 1
%t2937 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t2938 = call ptr @utf8_push_cp(i64 %t2937, ptr %p2)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @msg_bytes(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2940 = call ptr @resid_listbuf_new()
%t2941 = call ptr @utf8_run(ptr %p0, i64 %p1, ptr %t2940)
%t2942 = call ptr @resid_list_freeze(ptr %t2941)
%t2943 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t2942)
ret ptr %t2943
}
define ptr @bytes_of(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2944 = call ptr @resid_listbuf_new()
%t2945 = call ptr @utf8_run(ptr %p0, i64 0, ptr %t2944)
ret ptr %t2945
}
define i1 @str_is_ascii(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2950, %tco.s0 ]
%t2946 = call i64 @str_len(ptr %p0)
%t2947 = icmp sge i64 %p1, %t2946
br i1 %t2947, label %L361, label %L363
L361:
ret i1 true
L363:
%t2948 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t2949 = icmp sge i64 %t2948, 128
br i1 %t2949, label %L364, label %L366
L364:
ret i1 false
L366:
%t2950 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @slice_seed(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2956 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2964, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2967, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t2952 = icmp sle i64 %p2, 0
br i1 %t2952, label %L367, label %L369
L367:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p3
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L369:
%t2953 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t2954 = call i64 @resid_unbox_i64(ptr %t2953)
%t2958 = call ptr @resid_box_i64(i64 %t2954)
%t2960 = getelementptr i8, ptr %t2956, i64 0
store ptr %t2958, ptr %t2960
%t2961 = call ptr @resid_list_new(i64 1, ptr %t2956, ptr @.lty2956)
%t2962 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t2961)
%t2963 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t2964 = extractvalue {i64, i1} %t2963, 0
%t2965 = extractvalue {i64, i1} %t2963, 1
%t2966 = zext i1 %t2965 to i8
call void @resid_overflow_check(i8 %t2966)
%t2967 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t2962, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t2962, %tco.s0 ]
br label %tco.head
}
define ptr @zeros_l(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2973, %tco.s0.k ]
%t2969 = icmp sle i64 %p1, 0
br i1 %t2969, label %L370, label %L372
L370:
%lr.cx9 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz9 = icmp eq ptr %lr.cx9, null
br i1 %lr.lz9, label %lr.x9.k, label %lr.x9.m
lr.x9.k:
ret ptr %p0
lr.x9.m:
%lr.ret9 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx9)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret9
L372:
%t2971 = call ptr @resid_list_const_i64(ptr @.lc2970, i64 1, ptr @.lcd2970, ptr @.lty2970)
%t2972 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t2971)
%t2973 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t2972, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t2972, %tco.s0 ]
br label %tco.head
}
define ptr @length_bytes(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2985 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2992, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t2975 = icmp slt i64 %p1, 0
br i1 %t2975, label %L373, label %L375
L373:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p2
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L375:
%t2976 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t2977 = extractvalue {i64, i1} %t2976, 0
%t2978 = extractvalue {i64, i1} %t2976, 1
%t2979 = zext i1 %t2978 to i8
call void @resid_overflow_check(i8 %t2979)
%t2980 = icmp uge i64 %t2977, 64
%t2981 = add i64 %t2977, 0
%t2982 = select i1 %t2980, i64 63, i64 %t2981
%t2983 = ashr i64 %p0, %t2982
%t2984 = and i64 %t2983, 255
%t2987 = call ptr @resid_box_i64(i64 %t2984)
%t2989 = getelementptr i8, ptr %t2985, i64 0
store ptr %t2987, ptr %t2989
%t2990 = call ptr @resid_list_new(i64 1, ptr %t2985, ptr @.lty2985)
%t2991 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t2990)
%t2992 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t2991, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t2991, %tco.s0 ]
br label %tco.head
}
define ptr @pad_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2994 = call i64 @resid_list_len(ptr %p0)
%t2996 = call ptr @resid_list_const_i64(ptr @.lc2995, i64 1, ptr @.lcd2995, ptr @.lty2995)
%t2997 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t2996)
%t2998 = add nsw i64 %t2994, 9
%t2999 = add nsw i64 %t2998, 63
%t3000 = sdiv i64 %t2999, 64
%t3001 = mul nsw i64 %t3000, 64
%t3002 = sub nsw i64 %t3001, %t2998
%t3003 = call ptr @zeros_l(ptr %t2997, i64 %t3002)
%t3004 = mul nsw i64 %t2994, 8
%t3005 = call ptr @length_bytes__rs153(i64 %t3004, i64 7, ptr %t3003)
ret ptr %t3005
}
define ptr @bw_acc(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3046 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3053, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3006 = icmp sge i64 %p2, 16
br i1 %t3006, label %L376, label %L378
L376:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p3
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L378:
%t3007 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t3008 = extractvalue {i64, i1} %t3007, 0
%t3009 = extractvalue {i64, i1} %t3007, 1
%t3010 = zext i1 %t3009 to i8
call void @resid_overflow_check(i8 %t3010)
%t3011 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t3008)
%t3012 = extractvalue {i64, i1} %t3011, 0
%t3013 = extractvalue {i64, i1} %t3011, 1
%t3014 = zext i1 %t3013 to i8
call void @resid_overflow_check(i8 %t3014)
%t3015 = call ptr @resid_list_get_v(ptr %p0, i64 %t3012, ptr %p0.ld, i64 %p0.ln)
%t3016 = call i64 @resid_unbox_i64(ptr %t3015)
%t3018 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3012, i64 1)
%t3019 = extractvalue {i64, i1} %t3018, 0
%t3020 = extractvalue {i64, i1} %t3018, 1
%t3021 = zext i1 %t3020 to i8
call void @resid_overflow_check(i8 %t3021)
%t3022 = call ptr @resid_list_get_v(ptr %p0, i64 %t3019, ptr %p0.ld, i64 %p0.ln)
%t3023 = call i64 @resid_unbox_i64(ptr %t3022)
%t3025 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3012, i64 2)
%t3026 = extractvalue {i64, i1} %t3025, 0
%t3027 = extractvalue {i64, i1} %t3025, 1
%t3028 = zext i1 %t3027 to i8
call void @resid_overflow_check(i8 %t3028)
%t3029 = call ptr @resid_list_get_v(ptr %p0, i64 %t3026, ptr %p0.ld, i64 %p0.ln)
%t3030 = call i64 @resid_unbox_i64(ptr %t3029)
%t3032 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3012, i64 3)
%t3033 = extractvalue {i64, i1} %t3032, 0
%t3034 = extractvalue {i64, i1} %t3032, 1
%t3035 = zext i1 %t3034 to i8
call void @resid_overflow_check(i8 %t3035)
%t3036 = call ptr @resid_list_get_v(ptr %p0, i64 %t3033, ptr %p0.ld, i64 %p0.ln)
%t3037 = call i64 @resid_unbox_i64(ptr %t3036)
%t3039 = shl i64 %t3016, 24
%t3040 = shl i64 %t3023, 16
%t3041 = shl i64 %t3030, 8
%t3042 = or i64 %t3039, %t3040
%t3043 = or i64 %t3042, %t3041
%t3044 = or i64 %t3043, %t3037
%t3045 = and i64 %t3044, 4294967295
%t3048 = call ptr @resid_box_i64(i64 %t3045)
%t3050 = getelementptr i8, ptr %t3046, i64 0
store ptr %t3048, ptr %t3050
%t3051 = call ptr @resid_list_new(i64 1, ptr %t3046, ptr @.lty3046)
%t3052 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3051)
%t3053 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3052, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3052, %tco.s0 ]
br label %tco.head
}
define ptr @block_words(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3056 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3055)
%t3057 = call ptr @bw_acc(ptr %p0, i64 %p1, i64 0, ptr %t3056)
ret ptr %t3057
}
define ptr @ext_w(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3110 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3117, %tco.s0.k ]
%t3058 = icmp sge i64 %p1, 64
br i1 %t3058, label %L379, label %L381
L379:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p0
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L381:
%t3059 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 15)
%t3060 = extractvalue {i64, i1} %t3059, 0
%t3061 = extractvalue {i64, i1} %t3059, 1
%t3062 = zext i1 %t3061 to i8
call void @resid_overflow_check(i8 %t3062)
%t3063 = call ptr @resid_list_get(ptr %p0, i64 %t3060)
%t3064 = call i64 @resid_unbox_i64(ptr %t3063)
%t3066 = call i64 @rotr(i64 %t3064, i64 7)
%t3067 = call i64 @rotr(i64 %t3064, i64 18)
%t3068 = ashr i64 %t3064, 3
%t3069 = xor i64 %t3066, %t3067
%t3070 = xor i64 %t3069, %t3068
%t3071 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 2)
%t3072 = extractvalue {i64, i1} %t3071, 0
%t3073 = extractvalue {i64, i1} %t3071, 1
%t3074 = zext i1 %t3073 to i8
call void @resid_overflow_check(i8 %t3074)
%t3075 = call ptr @resid_list_get(ptr %p0, i64 %t3072)
%t3076 = call i64 @resid_unbox_i64(ptr %t3075)
%t3078 = call i64 @rotr(i64 %t3076, i64 17)
%t3079 = call i64 @rotr(i64 %t3076, i64 19)
%t3080 = ashr i64 %t3076, 10
%t3081 = xor i64 %t3078, %t3079
%t3082 = xor i64 %t3081, %t3080
%t3083 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 16)
%t3084 = extractvalue {i64, i1} %t3083, 0
%t3085 = extractvalue {i64, i1} %t3083, 1
%t3086 = zext i1 %t3085 to i8
call void @resid_overflow_check(i8 %t3086)
%t3087 = call ptr @resid_list_get(ptr %p0, i64 %t3084)
%t3088 = call i64 @resid_unbox_i64(ptr %t3087)
%t3090 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3088, i64 %t3070)
%t3091 = extractvalue {i64, i1} %t3090, 0
%t3092 = extractvalue {i64, i1} %t3090, 1
%t3093 = zext i1 %t3092 to i8
call void @resid_overflow_check(i8 %t3093)
%t3094 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 7)
%t3095 = extractvalue {i64, i1} %t3094, 0
%t3096 = extractvalue {i64, i1} %t3094, 1
%t3097 = zext i1 %t3096 to i8
call void @resid_overflow_check(i8 %t3097)
%t3098 = call ptr @resid_list_get(ptr %p0, i64 %t3095)
%t3099 = call i64 @resid_unbox_i64(ptr %t3098)
%t3101 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3099, i64 %t3082)
%t3102 = extractvalue {i64, i1} %t3101, 0
%t3103 = extractvalue {i64, i1} %t3101, 1
%t3104 = zext i1 %t3103 to i8
call void @resid_overflow_check(i8 %t3104)
%t3105 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3091, i64 %t3102)
%t3106 = extractvalue {i64, i1} %t3105, 0
%t3107 = extractvalue {i64, i1} %t3105, 1
%t3108 = zext i1 %t3107 to i8
call void @resid_overflow_check(i8 %t3108)
%t3109 = and i64 %t3106, 4294967295
%t3112 = call ptr @resid_box_i64(i64 %t3109)
%t3114 = getelementptr i8, ptr %t3110, i64 0
store ptr %t3112, ptr %t3114
%t3115 = call ptr @resid_list_new(i64 1, ptr %t3110, ptr @.lty3110)
%t3116 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t3115)
%t3117 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t3116, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t3116, %tco.s0 ]
br label %tco.head
}
define i64 @pick(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3119 = icmp eq i64 %p3, %p1
br i1 %t3119, label %L382, label %L384
L382:
ret i64 %p2
L384:
%t3120 = call ptr @resid_list_get(ptr %p0, i64 %p3)
%t3121 = call i64 @resid_unbox_i64(ptr %t3120)
ret i64 %t3121
}
define ptr @ls_build(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3123 = icmp sgt i64 %p3, 0
br i1 %t3123, label %L385, label %L387
L385:
%t3124 = sub nsw i64 %p3, 1
%t3125 = call ptr @ls_build(ptr %p0, i64 %p1, i64 %p2, i64 %t3124)
%t3126 = call i64 @pick(ptr %p0, i64 %p1, i64 %p2, i64 %p3)
%t3127 = alloca [1 x ptr]
%t3129 = call ptr @resid_box_i64(i64 %t3126)
%t3131 = getelementptr i8, ptr %t3127, i64 0
store ptr %t3129, ptr %t3131
%t3132 = call ptr @resid_list_new(i64 1, ptr %t3127, ptr @.lty3127)
%t3133 = call ptr @resid_list_concat_own(ptr %t3125, i8 1, ptr %t3132)
ret ptr %t3133
L387:
%t3134 = call i64 @pick(ptr %p0, i64 %p1, i64 %p2, i64 0)
%t3135 = alloca [1 x ptr]
%t3137 = call ptr @resid_box_i64(i64 %t3134)
%t3139 = getelementptr i8, ptr %t3135, i64 0
store ptr %t3137, ptr %t3139
%t3140 = call ptr @resid_list_new(i64 1, ptr %t3135, ptr @.lty3135)
ret ptr %t3140
}
define ptr @ls_set(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3141 = call i64 @resid_list_len(ptr %p0)
%t3142 = sub nsw i64 %t3141, 1
%t3143 = call ptr @ls_build(ptr %p0, i64 %p1, i64 %p2, i64 %t3142)
ret ptr %t3143
}
define i64 @ch_of(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3144 = call i64 @not32(i64 %p0)
%t3145 = and i64 %p0, %p1
%t3146 = and i64 %t3144, %p2
%t3147 = xor i64 %t3145, %t3146
ret i64 %t3147
}
define ptr @sha_round(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3148 = call ptr @resid_list_get(ptr %p0, i64 0)
%t3149 = call i64 @resid_unbox_i64(ptr %t3148)
%t3151 = call ptr @resid_list_get(ptr %p0, i64 1)
%t3152 = call i64 @resid_unbox_i64(ptr %t3151)
%t3154 = call ptr @resid_list_get(ptr %p0, i64 2)
%t3155 = call i64 @resid_unbox_i64(ptr %t3154)
%t3157 = call ptr @resid_list_get(ptr %p0, i64 3)
%t3158 = call i64 @resid_unbox_i64(ptr %t3157)
%t3160 = call ptr @resid_list_get(ptr %p0, i64 4)
%t3161 = call i64 @resid_unbox_i64(ptr %t3160)
%t3163 = call ptr @resid_list_get(ptr %p0, i64 5)
%t3164 = call i64 @resid_unbox_i64(ptr %t3163)
%t3166 = call ptr @resid_list_get(ptr %p0, i64 6)
%t3167 = call i64 @resid_unbox_i64(ptr %t3166)
%t3169 = call ptr @resid_list_get(ptr %p0, i64 7)
%t3170 = call i64 @resid_unbox_i64(ptr %t3169)
%t3172 = call ptr @resid_list_get(ptr %p1, i64 %p2)
%t3173 = call i64 @resid_unbox_i64(ptr %t3172)
%t3175 = call i64 @resid_scope_push()
%t3176 = call i64 @k_at(i64 %p2)
call void @resid_scope_pop(i64 %t3175)
%t3177 = call i64 @rotr(i64 %t3161, i64 6)
%t3178 = call i64 @rotr(i64 %t3161, i64 11)
%t3179 = call i64 @rotr(i64 %t3161, i64 25)
%t3180 = xor i64 %t3177, %t3178
%t3181 = xor i64 %t3180, %t3179
%t3182 = call i64 @ch_of(i64 %t3161, i64 %t3164, i64 %t3167)
%t3183 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3170, i64 %t3181)
%t3184 = extractvalue {i64, i1} %t3183, 0
%t3185 = extractvalue {i64, i1} %t3183, 1
%t3186 = zext i1 %t3185 to i8
call void @resid_overflow_check(i8 %t3186)
%t3187 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3184, i64 %t3182)
%t3188 = extractvalue {i64, i1} %t3187, 0
%t3189 = extractvalue {i64, i1} %t3187, 1
%t3190 = zext i1 %t3189 to i8
call void @resid_overflow_check(i8 %t3190)
%t3191 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3188, i64 %t3176)
%t3192 = extractvalue {i64, i1} %t3191, 0
%t3193 = extractvalue {i64, i1} %t3191, 1
%t3194 = zext i1 %t3193 to i8
call void @resid_overflow_check(i8 %t3194)
%t3195 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3192, i64 %t3173)
%t3196 = extractvalue {i64, i1} %t3195, 0
%t3197 = extractvalue {i64, i1} %t3195, 1
%t3198 = zext i1 %t3197 to i8
call void @resid_overflow_check(i8 %t3198)
%t3199 = and i64 %t3196, 4294967295
%t3200 = call i64 @rotr(i64 %t3149, i64 2)
%t3201 = call i64 @rotr(i64 %t3149, i64 13)
%t3202 = call i64 @rotr(i64 %t3149, i64 22)
%t3203 = xor i64 %t3200, %t3201
%t3204 = xor i64 %t3203, %t3202
%t3205 = and i64 %t3149, %t3152
%t3206 = and i64 %t3149, %t3155
%t3207 = and i64 %t3152, %t3155
%t3208 = xor i64 %t3205, %t3206
%t3209 = xor i64 %t3208, %t3207
%t3210 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3204, i64 %t3209)
%t3211 = extractvalue {i64, i1} %t3210, 0
%t3212 = extractvalue {i64, i1} %t3210, 1
%t3213 = zext i1 %t3212 to i8
call void @resid_overflow_check(i8 %t3213)
%t3214 = and i64 %t3211, 4294967295
%t3215 = add nsw i64 %t3199, %t3214
%t3216 = and i64 %t3215, 4294967295
%t3217 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3158, i64 %t3199)
%t3218 = extractvalue {i64, i1} %t3217, 0
%t3219 = extractvalue {i64, i1} %t3217, 1
%t3220 = zext i1 %t3219 to i8
call void @resid_overflow_check(i8 %t3220)
%t3221 = and i64 %t3218, 4294967295
%t3222 = alloca [8 x ptr]
%t3224 = call ptr @resid_box_i64(i64 %t3216)
%t3226 = getelementptr i8, ptr %t3222, i64 0
store ptr %t3224, ptr %t3226
%t3227 = call ptr @resid_box_i64(i64 %t3149)
%t3229 = getelementptr i8, ptr %t3222, i64 8
store ptr %t3227, ptr %t3229
%t3230 = call ptr @resid_box_i64(i64 %t3152)
%t3232 = getelementptr i8, ptr %t3222, i64 16
store ptr %t3230, ptr %t3232
%t3233 = call ptr @resid_box_i64(i64 %t3155)
%t3235 = getelementptr i8, ptr %t3222, i64 24
store ptr %t3233, ptr %t3235
%t3236 = call ptr @resid_box_i64(i64 %t3221)
%t3238 = getelementptr i8, ptr %t3222, i64 32
store ptr %t3236, ptr %t3238
%t3239 = call ptr @resid_box_i64(i64 %t3161)
%t3241 = getelementptr i8, ptr %t3222, i64 40
store ptr %t3239, ptr %t3241
%t3242 = call ptr @resid_box_i64(i64 %t3164)
%t3244 = getelementptr i8, ptr %t3222, i64 48
store ptr %t3242, ptr %t3244
%t3245 = call ptr @resid_box_i64(i64 %t3167)
%t3247 = getelementptr i8, ptr %t3222, i64 56
store ptr %t3245, ptr %t3247
%t3248 = call ptr @resid_list_new(i64 8, ptr %t3222, ptr @.lty3222)
ret ptr %t3248
}
define ptr @sha_rounds(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3251, %tco.s0.k ]
%t3249 = icmp sge i64 %p2, 64
br i1 %t3249, label %L388, label %L390
L388:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p0
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L390:
%t3250 = call ptr @sha_round(ptr %p0, ptr %p1, i64 %p2)
%t3251 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t3250, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t3250, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
br label %tco.head
}
define i64 @add_w(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3253 = call ptr @resid_list_get(ptr %p0, i64 %p2)
%t3254 = call i64 @resid_unbox_i64(ptr %t3253)
%t3256 = call ptr @resid_list_get(ptr %p1, i64 %p2)
%t3257 = call i64 @resid_unbox_i64(ptr %t3256)
%t3259 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3254, i64 %t3257)
%t3260 = extractvalue {i64, i1} %t3259, 0
%t3261 = extractvalue {i64, i1} %t3259, 1
%t3262 = zext i1 %t3261 to i8
call void @resid_overflow_check(i8 %t3262)
%t3263 = and i64 %t3260, 4294967295
ret i64 %t3263
}
define ptr @add_h(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3264 = call i64 @add_w(ptr %p0, ptr %p1, i64 0)
%t3265 = call i64 @add_w(ptr %p0, ptr %p1, i64 1)
%t3266 = call i64 @add_w(ptr %p0, ptr %p1, i64 2)
%t3267 = call i64 @add_w(ptr %p0, ptr %p1, i64 3)
%t3268 = call i64 @add_w(ptr %p0, ptr %p1, i64 4)
%t3269 = call i64 @add_w(ptr %p0, ptr %p1, i64 5)
%t3270 = call i64 @add_w(ptr %p0, ptr %p1, i64 6)
%t3271 = call i64 @add_w(ptr %p0, ptr %p1, i64 7)
%t3272 = alloca [8 x ptr]
%t3274 = call ptr @resid_box_i64(i64 %t3264)
%t3276 = getelementptr i8, ptr %t3272, i64 0
store ptr %t3274, ptr %t3276
%t3277 = call ptr @resid_box_i64(i64 %t3265)
%t3279 = getelementptr i8, ptr %t3272, i64 8
store ptr %t3277, ptr %t3279
%t3280 = call ptr @resid_box_i64(i64 %t3266)
%t3282 = getelementptr i8, ptr %t3272, i64 16
store ptr %t3280, ptr %t3282
%t3283 = call ptr @resid_box_i64(i64 %t3267)
%t3285 = getelementptr i8, ptr %t3272, i64 24
store ptr %t3283, ptr %t3285
%t3286 = call ptr @resid_box_i64(i64 %t3268)
%t3288 = getelementptr i8, ptr %t3272, i64 32
store ptr %t3286, ptr %t3288
%t3289 = call ptr @resid_box_i64(i64 %t3269)
%t3291 = getelementptr i8, ptr %t3272, i64 40
store ptr %t3289, ptr %t3291
%t3292 = call ptr @resid_box_i64(i64 %t3270)
%t3294 = getelementptr i8, ptr %t3272, i64 48
store ptr %t3292, ptr %t3294
%t3295 = call ptr @resid_box_i64(i64 %t3271)
%t3297 = getelementptr i8, ptr %t3272, i64 56
store ptr %t3295, ptr %t3297
%t3298 = call ptr @resid_list_new(i64 8, ptr %t3272, ptr @.lty3272)
ret ptr %t3298
}
define ptr @digest_block(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3299 = musttail call ptr @sha256g_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
ret ptr %t3299
}
define i64 @word_at_list(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3300 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t3301 = extractvalue {i64, i1} %t3300, 0
%t3302 = extractvalue {i64, i1} %t3300, 1
%t3303 = zext i1 %t3302 to i8
call void @resid_overflow_check(i8 %t3303)
%t3304 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t3301)
%t3305 = extractvalue {i64, i1} %t3304, 0
%t3306 = extractvalue {i64, i1} %t3304, 1
%t3307 = zext i1 %t3306 to i8
call void @resid_overflow_check(i8 %t3307)
%t3308 = call ptr @resid_list_get(ptr %p0, i64 %t3305)
%t3309 = call i64 @resid_unbox_i64(ptr %t3308)
%t3311 = and i64 %t3309, 255
%t3312 = shl i64 %t3311, 24
%t3313 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3305, i64 1)
%t3314 = extractvalue {i64, i1} %t3313, 0
%t3315 = extractvalue {i64, i1} %t3313, 1
%t3316 = zext i1 %t3315 to i8
call void @resid_overflow_check(i8 %t3316)
%t3317 = call ptr @resid_list_get(ptr %p0, i64 %t3314)
%t3318 = call i64 @resid_unbox_i64(ptr %t3317)
%t3320 = and i64 %t3318, 255
%t3321 = shl i64 %t3320, 16
%t3322 = or i64 %t3312, %t3321
%t3323 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3305, i64 2)
%t3324 = extractvalue {i64, i1} %t3323, 0
%t3325 = extractvalue {i64, i1} %t3323, 1
%t3326 = zext i1 %t3325 to i8
call void @resid_overflow_check(i8 %t3326)
%t3327 = call ptr @resid_list_get(ptr %p0, i64 %t3324)
%t3328 = call i64 @resid_unbox_i64(ptr %t3327)
%t3330 = and i64 %t3328, 255
%t3331 = shl i64 %t3330, 8
%t3332 = or i64 %t3322, %t3331
%t3333 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3305, i64 3)
%t3334 = extractvalue {i64, i1} %t3333, 0
%t3335 = extractvalue {i64, i1} %t3333, 1
%t3336 = zext i1 %t3335 to i8
call void @resid_overflow_check(i8 %t3336)
%t3337 = call ptr @resid_list_get(ptr %p0, i64 %t3334)
%t3338 = call i64 @resid_unbox_i64(ptr %t3337)
%t3340 = and i64 %t3338, 255
%t3341 = or i64 %t3332, %t3340
%t3342 = and i64 %t3341, 4294967295
ret i64 %t3342
}
define ptr @digest_blocks(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3350, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3343 = icmp sge i64 %p1, %p2
br i1 %t3343, label %L391, label %L393
L391:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L393:
%t3344 = call i8 @resid_cpu_has_sha256()
%t3345 = icmp ne i8 %t3344, 0
br i1 %t3345, label %L394, label %L396
L394:
%t3346 = call i256 @sha_hw_state(ptr %p3, i64 0, i256 0)
%t3347 = call ptr @sha_hw_blocks(ptr %p0, i64 %p1, i64 %p2, i256 %t3346)
%lr.cx19 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz19 = icmp eq ptr %lr.cx19, null
br i1 %lr.lz19, label %lr.x19.k, label %lr.x19.m
lr.x19.k:
ret ptr %t3347
lr.x19.m:
%lr.ret19 = call ptr @resid_mv_list(ptr %t3347, ptr %lr.cx19)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret19
L396:
%t3348 = call ptr @digest_block(ptr %p0, i64 %p1, ptr %p3)
%t3349 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t3350 = extractvalue {i64, i1} %t3349, 0
%t3351 = extractvalue {i64, i1} %t3349, 1
%t3352 = zext i1 %t3351 to i8
call void @resid_overflow_check(i8 %t3352)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3348, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3348, %tco.s0 ]
br label %tco.head
}
define i256 @sha_hw_state(ptr %p0.in, i64 %p1.in, i256 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3355, %tco.s0 ]
%p2 = phi i256 [ %p2.in, %entry ], [ %t3382, %tco.s0 ]
%t3354 = icmp sge i64 %p1, 8
br i1 %t3354, label %L397, label %L399
L397:
ret i256 %p2
L399:
%t3355 = add nsw i64 %p1, 1
%t3356 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3357 = call i64 @resid_unbox_i64(ptr %t3356)
%t3359 = and i64 %t3357, 4294967295
%t3360 = sext i64 %t3359 to i256
%t3361 = add i256 %t3360, 0
%t3362 = add i256 %t3361, 0
%t3363 = icmp ne i256 %t3362, %t3360
%t3364 = icmp slt i64 %t3359, 0
%t3365 = or i1 %t3363, %t3364
%t3366 = zext i1 %t3365 to i8
call void @resid_conv_check(i8 %t3366)
%t3367 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 32, i64 %p1)
%t3368 = extractvalue {i64, i1} %t3367, 0
%t3369 = extractvalue {i64, i1} %t3367, 1
%t3370 = zext i1 %t3369 to i8
call void @resid_overflow_check(i8 %t3370)
%t3371 = sext i64 %t3368 to i256
%t3372 = add i256 %t3371, 0
%t3373 = add i256 %t3372, 0
%t3374 = icmp ne i256 %t3373, %t3371
%t3375 = icmp slt i64 %t3368, 0
%t3376 = or i1 %t3374, %t3375
%t3377 = zext i1 %t3376 to i8
call void @resid_conv_check(i8 %t3377)
%t3378 = icmp uge i256 %t3372, 256
%t3379 = add i256 %t3372, 0
%t3380 = shl i256 %t3361, %t3379
%t3381 = select i1 %t3378, i256 0, i256 %t3380
%t3382 = or i256 %p2, %t3381
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @sha_hw_words(i256 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i256 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3386, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t3407, %tco.s0 ]
%t3384 = icmp sge i64 %p1, 8
br i1 %t3384, label %L400, label %L402
L400:
%t3385 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty3385)
ret ptr %t3385
L402:
%t3386 = add nsw i64 %p1, 1
%t3387 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 32, i64 %p1)
%t3388 = extractvalue {i64, i1} %t3387, 0
%t3389 = extractvalue {i64, i1} %t3387, 1
%t3390 = zext i1 %t3389 to i8
call void @resid_overflow_check(i8 %t3390)
%t3391 = sext i64 %t3388 to i256
%t3392 = add i256 %t3391, 0
%t3393 = add i256 %t3392, 0
%t3394 = icmp ne i256 %t3393, %t3391
%t3395 = icmp slt i64 %t3388, 0
%t3396 = or i1 %t3394, %t3395
%t3397 = zext i1 %t3396 to i8
call void @resid_conv_check(i8 %t3397)
%t3398 = icmp uge i256 %t3392, 256
%t3399 = add i256 %t3392, 0
%t3400 = lshr i256 %p0, %t3399
%t3401 = select i1 %t3398, i256 0, i256 %t3400
%t3402 = and i256 %t3401, 4294967295
%t3403 = trunc i256 %t3402 to i64
%t3404 = call ptr @resid_box_i64(i64 %t3403)
%t3407 = call ptr @resid_listbuf_push(ptr %p2, ptr %t3404)
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t3410, %tco.s0 ]
%p3 = phi i512 [ %p3.in, %entry ], [ %t3434, %tco.s0 ]
%t3409 = icmp sge i64 %p2, 16
br i1 %t3409, label %L403, label %L405
L403:
ret i512 %p3
L405:
%t3410 = add nsw i64 %p2, 1
%t3411 = call i64 @word_at_list(ptr %p0, i64 %p1, i64 %p2)
%t3412 = sext i64 %t3411 to i512
%t3413 = add i512 %t3412, 0
%t3414 = add i512 %t3413, 0
%t3415 = icmp ne i512 %t3414, %t3412
%t3416 = icmp slt i64 %t3411, 0
%t3417 = or i1 %t3415, %t3416
%t3418 = zext i1 %t3417 to i8
call void @resid_conv_check(i8 %t3418)
%t3419 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 32, i64 %p2)
%t3420 = extractvalue {i64, i1} %t3419, 0
%t3421 = extractvalue {i64, i1} %t3419, 1
%t3422 = zext i1 %t3421 to i8
call void @resid_overflow_check(i8 %t3422)
%t3423 = sext i64 %t3420 to i512
%t3424 = add i512 %t3423, 0
%t3425 = add i512 %t3424, 0
%t3426 = icmp ne i512 %t3425, %t3423
%t3427 = icmp slt i64 %t3420, 0
%t3428 = or i1 %t3426, %t3427
%t3429 = zext i1 %t3428 to i8
call void @resid_conv_check(i8 %t3429)
%t3430 = icmp uge i512 %t3424, 512
%t3431 = add i512 %t3424, 0
%t3432 = shl i512 %t3413, %t3431
%t3433 = select i1 %t3430, i512 0, i512 %t3432
%t3434 = or i512 %p3, %t3433
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t3437, %tco.s0 ]
%p3 = phi i512 [ %p3.in, %entry ], [ %t3461, %tco.s0 ]
%t3436 = icmp sge i64 %p2, 16
br i1 %t3436, label %L406, label %L408
L406:
ret i512 %p3
L408:
%t3437 = add nsw i64 %p2, 1
%t3438 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 %p2)
%t3439 = sext i64 %t3438 to i512
%t3440 = add i512 %t3439, 0
%t3441 = add i512 %t3440, 0
%t3442 = icmp ne i512 %t3441, %t3439
%t3443 = icmp slt i64 %t3438, 0
%t3444 = or i1 %t3442, %t3443
%t3445 = zext i1 %t3444 to i8
call void @resid_conv_check(i8 %t3445)
%t3446 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 32, i64 %p2)
%t3447 = extractvalue {i64, i1} %t3446, 0
%t3448 = extractvalue {i64, i1} %t3446, 1
%t3449 = zext i1 %t3448 to i8
call void @resid_overflow_check(i8 %t3449)
%t3450 = sext i64 %t3447 to i512
%t3451 = add i512 %t3450, 0
%t3452 = add i512 %t3451, 0
%t3453 = icmp ne i512 %t3452, %t3450
%t3454 = icmp slt i64 %t3447, 0
%t3455 = or i1 %t3453, %t3454
%t3456 = zext i1 %t3455 to i8
call void @resid_conv_check(i8 %t3456)
%t3457 = icmp uge i512 %t3451, 512
%t3458 = add i512 %t3451, 0
%t3459 = shl i512 %t3440, %t3458
%t3460 = select i1 %t3457, i512 0, i512 %t3459
%t3461 = or i512 %p3, %t3460
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t3467, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi i256 [ %p3.in, %entry ], [ %t3471, %tco.s0.k ]
%t3463 = icmp sge i64 %p1, %p2
br i1 %t3463, label %L409, label %L411
L409:
%t3464 = call ptr @resid_listbuf_new()
%t3465 = call ptr @sha_hw_words__rs181(i256 %p3, i64 0, ptr %t3464)
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %t3465
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %t3465, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L411:
%t3466 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t3467 = extractvalue {i64, i1} %t3466, 0
%t3468 = extractvalue {i64, i1} %t3466, 1
%t3469 = zext i1 %t3468 to i8
call void @resid_overflow_check(i8 %t3469)
%t3470 = call i512 @sha_hw_block(ptr %p0, i64 %p1, i64 0, i512 0)
%t3471 = call i256 @e.sha256(i256 %p3, i512 %t3470)
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t3477, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi i256 [ %p3.in, %entry ], [ %t3481, %tco.s0.k ]
%t3473 = icmp sge i64 %p1, %p2
br i1 %t3473, label %L412, label %L414
L412:
%t3474 = call ptr @resid_listbuf_new()
%t3475 = call ptr @sha_hw_words__rs181(i256 %p3, i64 0, ptr %t3474)
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %t3475
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %t3475, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L414:
%t3476 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t3477 = extractvalue {i64, i1} %t3476, 0
%t3478 = extractvalue {i64, i1} %t3476, 1
%t3479 = zext i1 %t3478 to i8
call void @resid_overflow_check(i8 %t3479)
%t3480 = call i512 @sha_hw_block_str(ptr %p0, i64 %p1, i64 0, i512 0)
%t3481 = call i256 @e.sha256(i256 %p3, i512 %t3480)
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
%t3483 = icmp slt i64 %p0, 10
br i1 %t3483, label %L415, label %L417
L415:
%t3484 = add nsw i64 %p0, 48
%t3485 = musttail call ptr @str_from_code(i64 %t3484)
ret ptr %t3485
L417:
%t3486 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p0, i64 87)
%t3487 = extractvalue {i64, i1} %t3486, 0
%t3488 = extractvalue {i64, i1} %t3486, 1
%t3489 = zext i1 %t3488 to i8
call void @resid_overflow_check(i8 %t3489)
%t3490 = musttail call ptr @str_from_code(i64 %t3487)
ret ptr %t3490
}
define ptr @hex_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3491 = ashr i64 %p0, 4
%t3492 = call ptr @hex_digit(i64 %t3491)
%t3493 = and i64 %p0, 15
%t3494 = call ptr @hex_digit(i64 %t3493)
%t3495 = call ptr @resid_str_concat(ptr %t3492, ptr %t3494)
ret ptr %t3495
}
define ptr @hex_word(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3496 = ashr i64 %p0, 24
%t3497 = call ptr @hex_byte(i64 %t3496)
%t3498 = and i64 %p0, 16711680
%t3499 = ashr i64 %t3498, 16
%t3500 = call ptr @hex_byte(i64 %t3499)
%t3501 = call ptr @resid_str_concat(ptr %t3497, ptr %t3500)
%t3502 = and i64 %p0, 65280
%t3503 = ashr i64 %t3502, 8
%t3504 = call ptr @hex_byte(i64 %t3503)
%t3505 = call ptr @resid_str_concat(ptr %t3501, ptr %t3504)
%t3506 = and i64 %p0, 255
%t3507 = call ptr @hex_byte(i64 %t3506)
%t3508 = call ptr @resid_str_concat(ptr %t3505, ptr %t3507)
ret ptr %t3508
}
define ptr @hex_state(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3515, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t3514, %tco.s0 ]
%t3509 = icmp sge i64 %p1, 8
br i1 %t3509, label %L418, label %L420
L418:
ret ptr %p2
L420:
%t3510 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3511 = call i64 @resid_unbox_i64(ptr %t3510)
%t3513 = call ptr @hex_word(i64 %t3511)
%t3514 = call ptr @resid_str_concat(ptr %p2, ptr %t3513)
%t3515 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bw_acc_str(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3540 = alloca [1 x ptr]
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3547, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3517 = icmp sge i64 %p2, 16
br i1 %t3517, label %L421, label %L423
L421:
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %p3
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L423:
%t3518 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t3519 = extractvalue {i64, i1} %t3518, 0
%t3520 = extractvalue {i64, i1} %t3518, 1
%t3521 = zext i1 %t3520 to i8
call void @resid_overflow_check(i8 %t3521)
%t3522 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t3519)
%t3523 = extractvalue {i64, i1} %t3522, 0
%t3524 = extractvalue {i64, i1} %t3522, 1
%t3525 = zext i1 %t3524 to i8
call void @resid_overflow_check(i8 %t3525)
%t3526 = call i64 @resid_char_at_n(ptr %p0, i64 %t3523, i64 %p0.alen)
%t3527 = add nsw i64 %t3523, 1
%t3528 = call i64 @resid_char_at_n(ptr %p0, i64 %t3527, i64 %p0.alen)
%t3529 = add nsw i64 %t3523, 2
%t3530 = call i64 @resid_char_at_n(ptr %p0, i64 %t3529, i64 %p0.alen)
%t3531 = add nsw i64 %t3523, 3
%t3532 = call i64 @resid_char_at_n(ptr %p0, i64 %t3531, i64 %p0.alen)
%t3533 = shl i64 %t3526, 24
%t3534 = shl i64 %t3528, 16
%t3535 = shl i64 %t3530, 8
%t3536 = or i64 %t3533, %t3534
%t3537 = or i64 %t3536, %t3535
%t3538 = or i64 %t3537, %t3532
%t3539 = and i64 %t3538, 4294967295
%t3542 = call ptr @resid_box_i64(i64 %t3539)
%t3544 = getelementptr i8, ptr %t3540, i64 0
store ptr %t3542, ptr %t3544
%t3545 = call ptr @resid_list_new(i64 1, ptr %t3540, ptr @.lty3540)
%t3546 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3545)
%t3547 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3546, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3546, %tco.s0 ]
br label %tco.head
}
define i64 @word_at_str(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3549 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t3550 = extractvalue {i64, i1} %t3549, 0
%t3551 = extractvalue {i64, i1} %t3549, 1
%t3552 = zext i1 %t3551 to i8
call void @resid_overflow_check(i8 %t3552)
%t3553 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t3550)
%t3554 = extractvalue {i64, i1} %t3553, 0
%t3555 = extractvalue {i64, i1} %t3553, 1
%t3556 = zext i1 %t3555 to i8
call void @resid_overflow_check(i8 %t3556)
%t3557 = call i64 @str_char_at(ptr %p0, i64 %t3554)
%t3558 = add nsw i64 %t3554, 1
%t3559 = call i64 @str_char_at(ptr %p0, i64 %t3558)
%t3560 = add nsw i64 %t3554, 2
%t3561 = call i64 @str_char_at(ptr %p0, i64 %t3560)
%t3562 = add nsw i64 %t3554, 3
%t3563 = call i64 @str_char_at(ptr %p0, i64 %t3562)
%t3564 = shl i64 %t3557, 24
%t3565 = shl i64 %t3559, 16
%t3566 = shl i64 %t3561, 8
%t3567 = or i64 %t3564, %t3565
%t3568 = or i64 %t3567, %t3566
%t3569 = or i64 %t3568, %t3563
%t3570 = and i64 %t3569, 4294967295
ret i64 %t3570
}
define i64 @ssig0(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3571 = call i64 @rotr(i64 %p0, i64 7)
%t3572 = call i64 @rotr(i64 %p0, i64 18)
%t3573 = ashr i64 %p0, 3
%t3574 = xor i64 %t3571, %t3572
%t3575 = xor i64 %t3574, %t3573
ret i64 %t3575
}
define i64 @ssig1(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3576 = call i64 @rotr(i64 %p0, i64 17)
%t3577 = call i64 @rotr(i64 %p0, i64 19)
%t3578 = ashr i64 %p0, 10
%t3579 = xor i64 %t3576, %t3577
%t3580 = xor i64 %t3579, %t3578
ret i64 %t3580
}
define i64 @bsig0(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3581 = call i64 @rotr(i64 %p0, i64 2)
%t3582 = call i64 @rotr(i64 %p0, i64 13)
%t3583 = call i64 @rotr(i64 %p0, i64 22)
%t3584 = xor i64 %t3581, %t3582
%t3585 = xor i64 %t3584, %t3583
ret i64 %t3585
}
define i64 @bsig1(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3586 = call i64 @rotr(i64 %p0, i64 6)
%t3587 = call i64 @rotr(i64 %p0, i64 11)
%t3588 = call i64 @rotr(i64 %p0, i64 25)
%t3589 = xor i64 %t3586, %t3587
%t3590 = xor i64 %t3589, %t3588
ret i64 %t3590
}
define i64 @maj_of(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3591 = and i64 %p0, %p1
%t3592 = and i64 %p0, %p2
%t3593 = and i64 %p1, %p2
%t3594 = xor i64 %t3591, %t3592
%t3595 = xor i64 %t3594, %t3593
ret i64 %t3595
}
define i64 @sched_w(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3596 = icmp slt i64 %p2, 16
br i1 %t3596, label %L424, label %L426
L424:
%t3597 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 %p2)
ret i64 %t3597
L426:
%t3598 = call i64 @ssig1(i64 %p6)
%t3599 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3598, i64 %p5)
%t3600 = extractvalue {i64, i1} %t3599, 0
%t3601 = extractvalue {i64, i1} %t3599, 1
%t3602 = zext i1 %t3601 to i8
call void @resid_overflow_check(i8 %t3602)
%t3603 = call i64 @ssig0(i64 %p4)
%t3604 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3603, i64 %p3)
%t3605 = extractvalue {i64, i1} %t3604, 0
%t3606 = extractvalue {i64, i1} %t3604, 1
%t3607 = zext i1 %t3606 to i8
call void @resid_overflow_check(i8 %t3607)
%t3608 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3600, i64 %t3605)
%t3609 = extractvalue {i64, i1} %t3608, 0
%t3610 = extractvalue {i64, i1} %t3608, 1
%t3611 = zext i1 %t3610 to i8
call void @resid_overflow_check(i8 %t3611)
%t3612 = and i64 %t3609, 4294967295
ret i64 %t3612
}
define ptr @sha_blk(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in, i64 %p19.in, i64 %p20.in, i64 %p21.in, i64 %p22.in, i64 %p23.in, i64 %p24.in, i64 %p25.in, i64 %p26.in, i64 %p27.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3678 = alloca [8 x ptr]
%p3.ld = call ptr @resid_list_vdata(ptr %p3.in)
%p3.ln = call i64 @resid_list_vlen(ptr %p3.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3741, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t3735, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t3740, %tco.s0.k ]
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
%p27 = phi i64 [ %p27.in, %entry ], [ %t3705, %tco.s0.k ]
%t3613 = icmp sge i64 %p2, 64
br i1 %t3613, label %L427, label %L429
L427:
%t3614 = call ptr @resid_list_get_v(ptr %p3, i64 0, ptr %p3.ld, i64 %p3.ln)
%t3615 = call i64 @resid_unbox_i64(ptr %t3614)
%t3617 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3615, i64 %p4)
%t3618 = extractvalue {i64, i1} %t3617, 0
%t3619 = extractvalue {i64, i1} %t3617, 1
%t3620 = zext i1 %t3619 to i8
call void @resid_overflow_check(i8 %t3620)
%t3621 = and i64 %t3618, 4294967295
%t3622 = call ptr @resid_list_get_v(ptr %p3, i64 1, ptr %p3.ld, i64 %p3.ln)
%t3623 = call i64 @resid_unbox_i64(ptr %t3622)
%t3625 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3623, i64 %p5)
%t3626 = extractvalue {i64, i1} %t3625, 0
%t3627 = extractvalue {i64, i1} %t3625, 1
%t3628 = zext i1 %t3627 to i8
call void @resid_overflow_check(i8 %t3628)
%t3629 = and i64 %t3626, 4294967295
%t3630 = call ptr @resid_list_get_v(ptr %p3, i64 2, ptr %p3.ld, i64 %p3.ln)
%t3631 = call i64 @resid_unbox_i64(ptr %t3630)
%t3633 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3631, i64 %p6)
%t3634 = extractvalue {i64, i1} %t3633, 0
%t3635 = extractvalue {i64, i1} %t3633, 1
%t3636 = zext i1 %t3635 to i8
call void @resid_overflow_check(i8 %t3636)
%t3637 = and i64 %t3634, 4294967295
%t3638 = call ptr @resid_list_get_v(ptr %p3, i64 3, ptr %p3.ld, i64 %p3.ln)
%t3639 = call i64 @resid_unbox_i64(ptr %t3638)
%t3641 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3639, i64 %p7)
%t3642 = extractvalue {i64, i1} %t3641, 0
%t3643 = extractvalue {i64, i1} %t3641, 1
%t3644 = zext i1 %t3643 to i8
call void @resid_overflow_check(i8 %t3644)
%t3645 = and i64 %t3642, 4294967295
%t3646 = call ptr @resid_list_get_v(ptr %p3, i64 4, ptr %p3.ld, i64 %p3.ln)
%t3647 = call i64 @resid_unbox_i64(ptr %t3646)
%t3649 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3647, i64 %p8)
%t3650 = extractvalue {i64, i1} %t3649, 0
%t3651 = extractvalue {i64, i1} %t3649, 1
%t3652 = zext i1 %t3651 to i8
call void @resid_overflow_check(i8 %t3652)
%t3653 = and i64 %t3650, 4294967295
%t3654 = call ptr @resid_list_get_v(ptr %p3, i64 5, ptr %p3.ld, i64 %p3.ln)
%t3655 = call i64 @resid_unbox_i64(ptr %t3654)
%t3657 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3655, i64 %p9)
%t3658 = extractvalue {i64, i1} %t3657, 0
%t3659 = extractvalue {i64, i1} %t3657, 1
%t3660 = zext i1 %t3659 to i8
call void @resid_overflow_check(i8 %t3660)
%t3661 = and i64 %t3658, 4294967295
%t3662 = call ptr @resid_list_get_v(ptr %p3, i64 6, ptr %p3.ld, i64 %p3.ln)
%t3663 = call i64 @resid_unbox_i64(ptr %t3662)
%t3665 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3663, i64 %p10)
%t3666 = extractvalue {i64, i1} %t3665, 0
%t3667 = extractvalue {i64, i1} %t3665, 1
%t3668 = zext i1 %t3667 to i8
call void @resid_overflow_check(i8 %t3668)
%t3669 = and i64 %t3666, 4294967295
%t3670 = call ptr @resid_list_get_v(ptr %p3, i64 7, ptr %p3.ld, i64 %p3.ln)
%t3671 = call i64 @resid_unbox_i64(ptr %t3670)
%t3673 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3671, i64 %p11)
%t3674 = extractvalue {i64, i1} %t3673, 0
%t3675 = extractvalue {i64, i1} %t3673, 1
%t3676 = zext i1 %t3675 to i8
call void @resid_overflow_check(i8 %t3676)
%t3677 = and i64 %t3674, 4294967295
%t3680 = call ptr @resid_box_i64(i64 %t3621)
%t3682 = getelementptr i8, ptr %t3678, i64 0
store ptr %t3680, ptr %t3682
%t3683 = call ptr @resid_box_i64(i64 %t3629)
%t3685 = getelementptr i8, ptr %t3678, i64 8
store ptr %t3683, ptr %t3685
%t3686 = call ptr @resid_box_i64(i64 %t3637)
%t3688 = getelementptr i8, ptr %t3678, i64 16
store ptr %t3686, ptr %t3688
%t3689 = call ptr @resid_box_i64(i64 %t3645)
%t3691 = getelementptr i8, ptr %t3678, i64 24
store ptr %t3689, ptr %t3691
%t3692 = call ptr @resid_box_i64(i64 %t3653)
%t3694 = getelementptr i8, ptr %t3678, i64 32
store ptr %t3692, ptr %t3694
%t3695 = call ptr @resid_box_i64(i64 %t3661)
%t3697 = getelementptr i8, ptr %t3678, i64 40
store ptr %t3695, ptr %t3697
%t3698 = call ptr @resid_box_i64(i64 %t3669)
%t3700 = getelementptr i8, ptr %t3678, i64 48
store ptr %t3698, ptr %t3700
%t3701 = call ptr @resid_box_i64(i64 %t3677)
%t3703 = getelementptr i8, ptr %t3678, i64 56
store ptr %t3701, ptr %t3703
%t3704 = call ptr @resid_list_new(i64 8, ptr %t3678, ptr @.lty3678)
%lr.cx127 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz127 = icmp eq ptr %lr.cx127, null
br i1 %lr.lz127, label %lr.x127.k, label %lr.x127.m
lr.x127.k:
ret ptr %t3704
lr.x127.m:
%lr.ret127 = call ptr @resid_mv_list(ptr %t3704, ptr %lr.cx127)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret127
L429:
%t3705 = call i64 @sched_w(ptr %p0, i64 %p1, i64 %p2, i64 %p12, i64 %p13, i64 %p21, i64 %p26)
%t3706 = call i64 @bsig1(i64 %p8)
%t3707 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t3706)
%t3708 = extractvalue {i64, i1} %t3707, 0
%t3709 = extractvalue {i64, i1} %t3707, 1
%t3710 = zext i1 %t3709 to i8
call void @resid_overflow_check(i8 %t3710)
%t3711 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t3712 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3708, i64 %t3711)
%t3713 = extractvalue {i64, i1} %t3712, 0
%t3714 = extractvalue {i64, i1} %t3712, 1
%t3715 = zext i1 %t3714 to i8
call void @resid_overflow_check(i8 %t3715)
%t3716 = call i64 @resid_scope_push()
%t3717 = call i64 @k_at(i64 %p2)
%t3718 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3713, i64 %t3717)
%t3719 = extractvalue {i64, i1} %t3718, 0
%t3720 = extractvalue {i64, i1} %t3718, 1
%t3721 = zext i1 %t3720 to i8
call void @resid_overflow_check(i8 %t3721)
call void @resid_scope_pop(i64 %t3716)
%t3722 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3719, i64 %t3705)
%t3723 = extractvalue {i64, i1} %t3722, 0
%t3724 = extractvalue {i64, i1} %t3722, 1
%t3725 = zext i1 %t3724 to i8
call void @resid_overflow_check(i8 %t3725)
%t3726 = and i64 %t3723, 4294967295
%t3727 = call i64 @bsig0(i64 %p4)
%t3728 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t3729 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3727, i64 %t3728)
%t3730 = extractvalue {i64, i1} %t3729, 0
%t3731 = extractvalue {i64, i1} %t3729, 1
%t3732 = zext i1 %t3731 to i8
call void @resid_overflow_check(i8 %t3732)
%t3733 = and i64 %t3730, 4294967295
%t3734 = add nsw i64 %t3726, %t3733
%t3735 = and i64 %t3734, 4294967295
%t3736 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t3726)
%t3737 = extractvalue {i64, i1} %t3736, 0
%t3738 = extractvalue {i64, i1} %t3736, 1
%t3739 = zext i1 %t3738 to i8
call void @resid_overflow_check(i8 %t3739)
%t3740 = and i64 %t3737, 4294967295
%t3741 = add nsw i64 %p2, 1
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
%t3743 = call ptr @resid_list_get(ptr %p2, i64 0)
%t3744 = call i64 @resid_unbox_i64(ptr %t3743)
%t3746 = call ptr @resid_list_get(ptr %p2, i64 1)
%t3747 = call i64 @resid_unbox_i64(ptr %t3746)
%t3749 = call ptr @resid_list_get(ptr %p2, i64 2)
%t3750 = call i64 @resid_unbox_i64(ptr %t3749)
%t3752 = call ptr @resid_list_get(ptr %p2, i64 3)
%t3753 = call i64 @resid_unbox_i64(ptr %t3752)
%t3755 = call ptr @resid_list_get(ptr %p2, i64 4)
%t3756 = call i64 @resid_unbox_i64(ptr %t3755)
%t3758 = call ptr @resid_list_get(ptr %p2, i64 5)
%t3759 = call i64 @resid_unbox_i64(ptr %t3758)
%t3761 = call ptr @resid_list_get(ptr %p2, i64 6)
%t3762 = call i64 @resid_unbox_i64(ptr %t3761)
%t3764 = call ptr @resid_list_get(ptr %p2, i64 7)
%t3765 = call i64 @resid_unbox_i64(ptr %t3764)
%t3767 = call ptr @sha_blk__rs190(ptr %p0, i64 %p1, i64 0, ptr %p2, i64 %t3744, i64 %t3747, i64 %t3750, i64 %t3753, i64 %t3756, i64 %t3759, i64 %t3762, i64 %t3765, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret ptr %t3767
}
define ptr @digest_blocks_str(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3775, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3768 = icmp sge i64 %p1, %p2
br i1 %t3768, label %L430, label %L432
L430:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L432:
%t3769 = call i8 @resid_cpu_has_sha256()
%t3770 = icmp ne i8 %t3769, 0
br i1 %t3770, label %L433, label %L435
L433:
%t3771 = call i256 @sha_hw_state(ptr %p3, i64 0, i256 0)
%t3772 = call ptr @sha_hw_blocks_str(ptr %p0, i64 %p1, i64 %p2, i256 %t3771)
%lr.cx19 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz19 = icmp eq ptr %lr.cx19, null
br i1 %lr.lz19, label %lr.x19.k, label %lr.x19.m
lr.x19.k:
ret ptr %t3772
lr.x19.m:
%lr.ret19 = call ptr @resid_mv_list(ptr %t3772, ptr %lr.cx19)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret19
L435:
%t3773 = call ptr @digest_block_str(ptr %p0, i64 %p1, ptr %p3)
%t3774 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t3775 = extractvalue {i64, i1} %t3774, 0
%t3776 = extractvalue {i64, i1} %t3774, 1
%t3777 = zext i1 %t3776 to i8
call void @resid_overflow_check(i8 %t3777)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3773, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3773, %tco.s0 ]
br label %tco.head
}
define ptr @str_bytes_range(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3781 = alloca [1 x ptr]
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3788, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3779 = icmp sge i64 %p1, %p2
br i1 %t3779, label %L436, label %L438
L436:
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %p3
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L438:
%t3780 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t3783 = call ptr @resid_box_i64(i64 %t3780)
%t3785 = getelementptr i8, ptr %t3781, i64 0
store ptr %t3783, ptr %t3785
%t3786 = call ptr @resid_list_new(i64 1, ptr %t3781, ptr @.lty3781)
%t3787 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3786)
%t3788 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3787, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3787, %tco.s0 ]
br label %tco.head
}
define ptr @pad_tail(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3790 = call i64 @resid_list_len(ptr %p0)
%t3792 = call ptr @resid_list_const_i64(ptr @.lc3791, i64 1, ptr @.lcd3791, ptr @.lty3791)
%t3793 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t3792)
%t3794 = add nsw i64 %t3790, 9
%t3795 = add nsw i64 %t3794, 63
%t3796 = sdiv i64 %t3795, 64
%t3797 = mul nsw i64 %t3796, 64
%t3798 = sub nsw i64 %t3797, %t3794
%t3799 = call ptr @zeros_l(ptr %t3793, i64 %t3798)
%t3800 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t3801 = extractvalue {i64, i1} %t3800, 0
%t3802 = extractvalue {i64, i1} %t3800, 1
%t3803 = zext i1 %t3802 to i8
call void @resid_overflow_check(i8 %t3803)
%t3804 = call ptr @length_bytes__rs153(i64 %t3801, i64 7, ptr %t3799)
ret ptr %t3804
}
define ptr @sha256(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3805 = call i1 @str_is_ascii(ptr %p0, i64 0)
%t3806 = xor i1 %t3805, true
br i1 %t3806, label %L439, label %L441
L439:
%t3807 = call ptr @bytes_of(ptr %p0)
%t3808 = call ptr @sha256_bytes(ptr %t3807)
%t3809 = musttail call ptr @hex_encode(ptr %t3808)
ret ptr %t3809
L441:
%t3810 = musttail call ptr @__m____________lib_crypto_resid__sha256_ascii(ptr %p0)
ret ptr %t3810
}
define ptr @__m____________lib_crypto_resid__sha256_ascii(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3811 = call i64 @str_len(ptr %p0)
%t3812 = sdiv i64 %t3811, 64
%t3813 = mul nsw i64 %t3812, 64
%t3815 = call ptr @resid_list_const_i64(ptr @.lc3814, i64 8, ptr @.lcd3814, ptr @.lty3814)
%t3816 = call ptr @digest_blocks_str(ptr %p0, i64 0, i64 %t3813, ptr %t3815)
%t3818 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3817)
%t3819 = call ptr @str_bytes_range(ptr %p0, i64 %t3813, i64 %t3811, ptr %t3818)
%t3820 = call ptr @pad_tail(ptr %t3819, i64 %t3811)
%t3821 = call i64 @resid_list_len(ptr %t3820)
%t3822 = call ptr @digest_blocks(ptr %t3820, i64 0, i64 %t3821, ptr %t3816)
%t3824 = call ptr @hex_state__rs234(ptr %t3822, i64 0, ptr @.s3823)
ret ptr %t3824
}
define i64 @word_byte(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3825 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 3, i64 %p2)
%t3826 = extractvalue {i64, i1} %t3825, 0
%t3827 = extractvalue {i64, i1} %t3825, 1
%t3828 = zext i1 %t3827 to i8
call void @resid_overflow_check(i8 %t3828)
%t3829 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t3826, i64 8)
%t3830 = extractvalue {i64, i1} %t3829, 0
%t3831 = extractvalue {i64, i1} %t3829, 1
%t3832 = zext i1 %t3831 to i8
call void @resid_overflow_check(i8 %t3832)
%t3833 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t3834 = call i64 @resid_unbox_i64(ptr %t3833)
%t3836 = icmp uge i64 %t3830, 64
%t3837 = add i64 %t3830, 0
%t3838 = select i1 %t3836, i64 63, i64 %t3837
%t3839 = ashr i64 %t3834, %t3838
%t3840 = and i64 %t3839, 255
ret i64 %t3840
}
define ptr @wtb_inner(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3843 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3850, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3841 = icmp sgt i64 %p2, 3
br i1 %t3841, label %L442, label %L444
L442:
%lr.cx12 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz12 = icmp eq ptr %lr.cx12, null
br i1 %lr.lz12, label %lr.x12.k, label %lr.x12.m
lr.x12.k:
ret ptr %p3
lr.x12.m:
%lr.ret12 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx12)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret12
L444:
%t3842 = call i64 @word_byte(ptr %p0, i64 %p1, i64 %p2)
%t3845 = call ptr @resid_box_i64(i64 %t3842)
%t3847 = getelementptr i8, ptr %t3843, i64 0
store ptr %t3845, ptr %t3847
%t3848 = call ptr @resid_list_new(i64 1, ptr %t3843, ptr @.lty3843)
%t3849 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3848)
%t3850 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3849, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3849, %tco.s0 ]
br label %tco.head
}
define ptr @wtb_outer(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3854, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t3852 = icmp sgt i64 %p1, 7
br i1 %t3852, label %L445, label %L447
L445:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p2
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L447:
%t3853 = call ptr @wtb_inner__rs236(ptr %p0, i64 %p1, i64 0, ptr %p2)
%t3854 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t3853, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t3853, %tco.s0 ]
br label %tco.head
}
define ptr @words_to_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3857 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3856)
%t3858 = call ptr @wtb_outer__rs238(ptr %p0, i64 0, ptr %t3857)
ret ptr %t3858
}
define ptr @sha256_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3859 = call i64 @resid_list_len(ptr %p0)
%t3860 = sdiv i64 %t3859, 64
%t3861 = mul nsw i64 %t3860, 64
%t3863 = call ptr @resid_list_const_i64(ptr @.lc3862, i64 8, ptr @.lcd3862, ptr @.lty3862)
%t3864 = call ptr @digest_blocks(ptr %p0, i64 0, i64 %t3861, ptr %t3863)
%t3865 = call i64 @resid_list_len(ptr %p0)
%t3866 = call ptr @resid_list_slice(ptr %p0, i64 %t3861, i64 %t3865)
%t3868 = call ptr @pad_tail(ptr %t3866, i64 %t3859)
%t3869 = call i64 @resid_list_len(ptr %t3868)
%t3870 = call ptr @digest_blocks(ptr %t3868, i64 0, i64 %t3869, ptr %t3864)
%t3871 = musttail call ptr @words_to_bytes(ptr %t3870)
ret ptr %t3871
}
define ptr @hex_range(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3878, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t3877, %tco.s0 ]
%t3872 = icmp sge i64 %p1, %p2
br i1 %t3872, label %L448, label %L450
L448:
ret ptr %p3
L450:
%t3873 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3874 = call i64 @resid_unbox_i64(ptr %t3873)
%t3876 = call ptr @hex_byte(i64 %t3874)
%t3877 = call ptr @resid_str_concat(ptr %p3, ptr %t3876)
%t3878 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @hex_encode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3880 = call i64 @resid_list_len(ptr %p0)
%t3882 = call ptr @hex_range(ptr %p0, i64 0, i64 %t3880, ptr @.s3881)
ret ptr %t3882
}
define ptr @__m____________lib_crypto_resid__sc_acc(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3888 = alloca [1 x ptr]
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3895, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3883 = call i64 @resid_list_len(ptr %p1)
%t3884 = icmp sge i64 %p2, %t3883
br i1 %t3884, label %L451, label %L453
L451:
%lr.cx15 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz15 = icmp eq ptr %lr.cx15, null
br i1 %lr.lz15, label %lr.x15.k, label %lr.x15.m
lr.x15.k:
ret ptr %p3
lr.x15.m:
%lr.ret15 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx15)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret15
L453:
%t3885 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t3886 = call i64 @resid_unbox_i64(ptr %t3885)
%t3890 = call ptr @resid_box_i64(i64 %t3886)
%t3892 = getelementptr i8, ptr %t3888, i64 0
store ptr %t3890, ptr %t3892
%t3893 = call ptr @resid_list_new(i64 1, ptr %t3888, ptr @.lty3888)
%t3894 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3893)
%t3895 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3894, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3894, %tco.s0 ]
br label %tco.head
}
define ptr @sconcat(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3897 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %p1)
ret ptr %t3897
}
define i64 @byte_at_or0(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3898 = call i64 @resid_list_len(ptr %p0)
%t3899 = icmp slt i64 %p1, %t3898
br i1 %t3899, label %L454, label %L456
L454:
%t3900 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t3901 = call i64 @resid_unbox_i64(ptr %t3900)
ret i64 %t3901
L456:
ret i64 0
}
define ptr @xor_lists(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3911 = alloca [1 x ptr]
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3918, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3903 = call i64 @resid_list_len(ptr %p1)
%t3904 = icmp sge i64 %p2, %t3903
br i1 %t3904, label %L457, label %L459
L457:
%lr.cx15 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz15 = icmp eq ptr %lr.cx15, null
br i1 %lr.lz15, label %lr.x15.k, label %lr.x15.m
lr.x15.k:
ret ptr %p3
lr.x15.m:
%lr.ret15 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx15)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret15
L459:
%t3905 = call i64 @byte_at_or0(ptr %p0, i64 %p2)
%t3906 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t3907 = call i64 @resid_unbox_i64(ptr %t3906)
%t3909 = xor i64 %t3905, %t3907
%t3910 = and i64 %t3909, 255
%t3913 = call ptr @resid_box_i64(i64 %t3910)
%t3915 = getelementptr i8, ptr %t3911, i64 0
store ptr %t3913, ptr %t3915
%t3916 = call ptr @resid_list_new(i64 1, ptr %t3911, ptr @.lty3911)
%t3917 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3916)
%t3918 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3917, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3917, %tco.s0 ]
br label %tco.head
}
define ptr @key_block(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3920 = call i64 @resid_list_len(ptr %p0)
%t3921 = icmp sgt i64 %t3920, 64
br i1 %t3921, label %L460, label %L462
L460:
%t3922 = call ptr @sha256_bytes(ptr %p0)
%t3923 = call i64 @resid_list_len(ptr %t3922)
%t3924 = sub nsw i64 64, %t3923
%t3926 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3925)
%t3927 = call ptr @zeros_l(ptr %t3926, i64 %t3924)
%t3928 = call ptr @resid_list_freeze(ptr %t3927)
%t3929 = call ptr @sconcat(ptr %t3922, ptr %t3928)
ret ptr %t3929
L462:
%t3930 = sub nsw i64 64, %t3920
%t3932 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3931)
%t3933 = call ptr @zeros_l(ptr %t3932, i64 %t3930)
%t3934 = call ptr @resid_list_freeze(ptr %t3933)
%t3935 = call ptr @sconcat(ptr %p0, ptr %t3934)
ret ptr %t3935
}
define ptr @map_ipad(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3943 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3950, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t3936 = call i64 @resid_list_len(ptr %p0)
%t3937 = icmp sge i64 %p1, %t3936
br i1 %t3937, label %L463, label %L465
L463:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p2
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L465:
%t3938 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3939 = call i64 @resid_unbox_i64(ptr %t3938)
%t3941 = xor i64 %t3939, 54
%t3942 = and i64 %t3941, 255
%t3945 = call ptr @resid_box_i64(i64 %t3942)
%t3947 = getelementptr i8, ptr %t3943, i64 0
store ptr %t3945, ptr %t3947
%t3948 = call ptr @resid_list_new(i64 1, ptr %t3943, ptr @.lty3943)
%t3949 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t3948)
%t3950 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t3949, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t3949, %tco.s0 ]
br label %tco.head
}
define ptr @map_opad(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3959 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3966, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t3952 = call i64 @resid_list_len(ptr %p0)
%t3953 = icmp sge i64 %p1, %t3952
br i1 %t3953, label %L466, label %L468
L466:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p2
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L468:
%t3954 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3955 = call i64 @resid_unbox_i64(ptr %t3954)
%t3957 = xor i64 %t3955, 92
%t3958 = and i64 %t3957, 255
%t3961 = call ptr @resid_box_i64(i64 %t3958)
%t3963 = getelementptr i8, ptr %t3959, i64 0
store ptr %t3961, ptr %t3963
%t3964 = call ptr @resid_list_new(i64 1, ptr %t3959, ptr @.lty3959)
%t3965 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t3964)
%t3966 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t3965, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t3965, %tco.s0 ]
br label %tco.head
}
define ptr @hmac_sha256_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3968 = call ptr @key_block(ptr %p0)
%t3970 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3969)
%t3971 = call ptr @map_ipad(ptr %t3968, i64 0, ptr %t3970)
%t3973 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3972)
%t3974 = call ptr @map_opad(ptr %t3968, i64 0, ptr %t3973)
%t3975 = call ptr @sconcat(ptr %t3971, ptr %p1)
%t3976 = call ptr @sha256_bytes(ptr %t3975)
%t3977 = call ptr @resid_list_freeze(ptr %t3976)
%t3978 = call ptr @sconcat(ptr %t3974, ptr %t3977)
%t3979 = call ptr @sha256_bytes(ptr %t3978)
ret ptr %t3979
}
define i1 @ct_equal(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3984 = alloca [24 x i8], align 16 ; fixed
%t3985 = alloca [48 x i8], align 16 ; fixed
%t3980 = call i64 @resid_list_len(ptr %p0)
%t3981 = call i64 @resid_list_len(ptr %p1)
%t3982 = icmp ne i64 %t3980, %t3981
br i1 %t3982, label %L469, label %L471
L469:
ret i1 false
L471:
%t3983 = call i64 @ct_acc(ptr %p0, ptr %p1, i64 0, i64 0)
store i64 %t3983, ptr %t3984
%t3986 = ptrtoint ptr %t3984 to i64
store i64 1296236546, ptr %t3985
%t3987 = getelementptr i64, ptr %t3985, i64 1
store i64 %t3986, ptr %t3987
%t3988 = getelementptr i64, ptr %t3985, i64 2
store i64 8, ptr %t3988
%t3989 = getelementptr i64, ptr %t3985, i64 3
store i64 0, ptr %t3989
%t3990 = getelementptr i64, ptr %t3985, i64 4
store i64 0, ptr %t3990
%t3991 = getelementptr i64, ptr %t3985, i64 5
store i64 0, ptr %t3991
%t3992 = call i64 asm sideeffect "rolq $$3, %rdi ; rolq $$13, %rdi ; rolq $$61, %rdi ; rolq $$51, %rdi ; xchgq %rbx, %rbx", "={dx},{ax},0,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(ptr %t3985, i64 0)
%t3993 = load i64, ptr %t3984
%t3994 = icmp eq i64 %t3993, 0
ret i1 %t3994
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4005, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t4004, %tco.s0 ]
%t3995 = call i64 @resid_list_len(ptr %p0)
%t3996 = icmp sge i64 %p2, %t3995
br i1 %t3996, label %L472, label %L474
L472:
ret i64 %p3
L474:
%t3997 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t3998 = call i64 @resid_unbox_i64(ptr %t3997)
%t4000 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t4001 = call i64 @resid_unbox_i64(ptr %t4000)
%t4003 = xor i64 %t3998, %t4001
%t4004 = or i64 %p3, %t4003
%t4005 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @ct_eq(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
call void @resid_cap_check(ptr @.declassify.cap)
%t4024 = alloca [20 x i8], align 16 ; fixed
%t4025 = alloca [48 x i8], align 16 ; fixed
%t4007 = call i64 @resid_list_len(ptr %p0)
%t4008 = call i64 @resid_list_len(ptr %p1)
%t4009 = icmp ne i64 %t4007, %t4008
br i1 %t4009, label %L475, label %L477
L475:
ret i1 false
L477:
%t4010 = call i64 @resid_list_len(ptr %p0)
%t4011 = icmp eq i64 %t4010, 0
br i1 %t4011, label %L478, label %L480
L478:
ret i1 true
L480:
%t4012 = call ptr @resid_list_get(ptr %p0, i64 0)
%t4014 = call i64 @resid_unbox_i64(ptr %t4012)
%t4013 = trunc i64 %t4014 to i8
%t4015 = call ptr @resid_list_get(ptr %p1, i64 0)
%t4017 = call i64 @resid_unbox_i64(ptr %t4015)
%t4016 = trunc i64 %t4017 to i8
%t4018 = xor i8 %t4013, %t4016
%t4019 = call i8 @__m____________lib_crypto_resid__ct_eq_acc(ptr %p0, ptr %p1, i64 1, i8 %t4018)
%t4020 = zext i8 %t4019 to i32
%t4021 = sub i32 0, %t4020
%t4022 = or i32 %t4020, %t4021
%t4023 = lshr i32 %t4022, 31
store i32 %t4023, ptr %t4024
%t4026 = ptrtoint ptr %t4024 to i64
store i64 1296236546, ptr %t4025
%t4027 = getelementptr i64, ptr %t4025, i64 1
store i64 %t4026, ptr %t4027
%t4028 = getelementptr i64, ptr %t4025, i64 2
store i64 4, ptr %t4028
%t4029 = getelementptr i64, ptr %t4025, i64 3
store i64 0, ptr %t4029
%t4030 = getelementptr i64, ptr %t4025, i64 4
store i64 0, ptr %t4030
%t4031 = getelementptr i64, ptr %t4025, i64 5
store i64 0, ptr %t4031
%t4032 = call i64 asm sideeffect "rolq $$3, %rdi ; rolq $$13, %rdi ; rolq $$61, %rdi ; rolq $$51, %rdi ; xchgq %rbx, %rbx", "={dx},{ax},0,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(ptr %t4025, i64 0)
%t4033 = load i32, ptr %t4024
%t4034 = icmp eq i32 %t4033, 0
ret i1 %t4034
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4037, %tco.s0 ]
%p3 = phi i8 [ %p3.in, %entry ], [ %t4045, %tco.s0 ]
%t4035 = call i64 @resid_list_len(ptr %p0)
%t4036 = icmp sge i64 %p2, %t4035
br i1 %t4036, label %L481, label %L483
L481:
ret i8 %p3
L483:
%t4037 = add nsw i64 %p2, 1
%t4038 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t4040 = call i64 @resid_unbox_i64(ptr %t4038)
%t4039 = trunc i64 %t4040 to i8
%t4041 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t4043 = call i64 @resid_unbox_i64(ptr %t4041)
%t4042 = trunc i64 %t4043 to i8
%t4044 = xor i8 %t4039, %t4042
%t4045 = or i8 %p3, %t4044
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @__m____________lib_crypto_resid__ct_same_pub(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4047 = musttail call i1 @ct_equal(ptr %p0, ptr %p1)
ret i1 %t4047
}
define i1 @__m____________lib_crypto_resid__ct_same_secret(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4048 = musttail call i1 @ct_eq(ptr %p0, ptr %p1)
ret i1 %t4048
}
define ptr @b64_char(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4049 = icmp slt i64 %p0, 26
br i1 %t4049, label %L484, label %L486
L484:
%t4050 = add nsw i64 %p0, 65
%t4051 = musttail call ptr @str_from_code(i64 %t4050)
ret ptr %t4051
L486:
%t4052 = icmp slt i64 %p0, 52
br i1 %t4052, label %L487, label %L489
L487:
%t4053 = add nsw i64 %p0, 71
%t4054 = musttail call ptr @str_from_code(i64 %t4053)
ret ptr %t4054
L489:
%t4055 = icmp slt i64 %p0, 62
br i1 %t4055, label %L490, label %L492
L490:
%t4056 = sub nsw i64 %p0, 4
%t4057 = musttail call ptr @str_from_code(i64 %t4056)
ret ptr %t4057
L492:
%t4058 = icmp eq i64 %p0, 62
br i1 %t4058, label %L493, label %L495
L493:
ret ptr @.s4059
L495:
ret ptr @.s4060
}
define ptr @base64_encode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4061 = call i64 @resid_list_len(ptr %p0)
%t4062x = insertvalue {ptr,ptr} zeroinitializer, ptr null, 0
%t4062 = insertvalue {ptr,ptr} %t4062x, ptr null, 1
%t4063 = call {ptr,ptr} @b64_enc(ptr %p0, i64 0, i64 %t4061, {ptr,ptr} %t4062)
%t4064b = extractvalue {ptr,ptr} %t4063, 0
%t4064l = extractvalue {ptr,ptr} %t4063, 1
%t4064 = call ptr @resid_sb2_finish(ptr %t4064b, ptr %t4064l)
ret ptr %t4064
}
define i64 @__m____________lib_crypto_resid__b64_code(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4065 = icmp slt i64 %p0, 26
br i1 %t4065, label %L496, label %L498
L496:
%t4066 = add nsw i64 %p0, 65
ret i64 %t4066
L498:
%t4067 = icmp slt i64 %p0, 52
br i1 %t4067, label %L499, label %L501
L499:
%t4068 = add nsw i64 %p0, 71
ret i64 %t4068
L501:
%t4069 = icmp slt i64 %p0, 62
br i1 %t4069, label %L502, label %L504
L502:
%t4070 = sub nsw i64 %p0, 4
ret i64 %t4070
L504:
%t4071 = icmp eq i64 %p0, 62
br i1 %t4071, label %L505, label %L506
L505:
br label %L507
L506:
br label %L507
L507:
%t4072 = phi i64 [ 43, %L505 ], [ 47, %L506 ]
ret i64 %t4072
}
define {ptr,ptr} @b64_enc(ptr %p0.in, i64 %p1.in, i64 %p2.in, {ptr,ptr} %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4120, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi {ptr,ptr} [ %p3.in, %entry ], [ %t4118, %tco.s0 ]
%t4073 = icmp sge i64 %p1, %p2
br i1 %t4073, label %L508, label %L510
L508:
ret {ptr,ptr} %p3
L510:
%t4074 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 %p1)
%t4075 = extractvalue {i64, i1} %t4074, 0
%t4076 = extractvalue {i64, i1} %t4074, 1
%t4077 = zext i1 %t4076 to i8
call void @resid_overflow_check(i8 %t4077)
%t4078 = icmp sgt i64 %t4075, 1
br i1 %t4078, label %L511, label %L512
L511:
%t4079 = add nsw i64 %p1, 1
%t4080 = call ptr @resid_list_get_v(ptr %p0, i64 %t4079, ptr %p0.ld, i64 %p0.ln)
%t4081 = call i64 @resid_unbox_i64(ptr %t4080)
br label %L513
L512:
br label %L513
L513:
%t4083 = phi i64 [ %t4081, %L511 ], [ 0, %L512 ]
%t4084 = icmp sgt i64 %t4075, 2
br i1 %t4084, label %L514, label %L515
L514:
%t4085 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t4086 = extractvalue {i64, i1} %t4085, 0
%t4087 = extractvalue {i64, i1} %t4085, 1
%t4088 = zext i1 %t4087 to i8
call void @resid_overflow_check(i8 %t4088)
%t4089 = call ptr @resid_list_get_v(ptr %p0, i64 %t4086, ptr %p0.ld, i64 %p0.ln)
%t4090 = call i64 @resid_unbox_i64(ptr %t4089)
br label %L516
L515:
br label %L516
L516:
%t4092 = phi i64 [ %t4090, %L514 ], [ 0, %L515 ]
%t4093 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t4094 = call i64 @resid_unbox_i64(ptr %t4093)
%t4096 = shl i64 %t4094, 16
%t4097 = shl i64 %t4083, 8
%t4098 = or i64 %t4096, %t4097
%t4099 = or i64 %t4098, %t4092
%t4100 = ashr i64 %t4099, 18
%t4101 = and i64 %t4100, 63
%t4102 = call i64 @__m____________lib_crypto_resid__b64_code(i64 %t4101)
%t4103b = extractvalue {ptr,ptr} %p3, 0
%t4103l = extractvalue {ptr,ptr} %p3, 1
%t4103a = icmp ult i64 %t4102, 128
%t4103r = icmp ult ptr %t4103b, %t4103l
%t4103k = and i1 %t4103a, %t4103r
br i1 %t4103k, label %L517, label %L518
L517:
%t4103v = trunc i64 %t4102 to i8
store i8 %t4103v, ptr %t4103b, align 1
%t4103q = getelementptr i8, ptr %t4103b, i64 1
%t4103f = insertvalue {ptr,ptr} %p3, ptr %t4103q, 0
br label %L519
L518:
%t4103nb = call ptr @resid_sb2_push_cp(ptr %t4103b, ptr %t4103l, i64 %t4102)
%t4103nl = call ptr @resid_sb2_lim()
%t4103sx = insertvalue {ptr,ptr} zeroinitializer, ptr %t4103nb, 0
%t4103s = insertvalue {ptr,ptr} %t4103sx, ptr %t4103nl, 1
br label %L519
L519:
%t4103 = phi {ptr,ptr} [ %t4103f, %L517 ], [ %t4103s, %L518 ]
%t4104 = ashr i64 %t4099, 12
%t4105 = and i64 %t4104, 63
%t4106 = call i64 @__m____________lib_crypto_resid__b64_code(i64 %t4105)
%t4107b = extractvalue {ptr,ptr} %t4103, 0
%t4107l = extractvalue {ptr,ptr} %t4103, 1
%t4107a = icmp ult i64 %t4106, 128
%t4107r = icmp ult ptr %t4107b, %t4107l
%t4107k = and i1 %t4107a, %t4107r
br i1 %t4107k, label %L520, label %L521
L520:
%t4107v = trunc i64 %t4106 to i8
store i8 %t4107v, ptr %t4107b, align 1
%t4107q = getelementptr i8, ptr %t4107b, i64 1
%t4107f = insertvalue {ptr,ptr} %t4103, ptr %t4107q, 0
br label %L522
L521:
%t4107nb = call ptr @resid_sb2_push_cp(ptr %t4107b, ptr %t4107l, i64 %t4106)
%t4107nl = call ptr @resid_sb2_lim()
%t4107sx = insertvalue {ptr,ptr} zeroinitializer, ptr %t4107nb, 0
%t4107s = insertvalue {ptr,ptr} %t4107sx, ptr %t4107nl, 1
br label %L522
L522:
%t4107 = phi {ptr,ptr} [ %t4107f, %L520 ], [ %t4107s, %L521 ]
%t4108 = icmp sgt i64 %t4075, 1
br i1 %t4108, label %L523, label %L524
L523:
%t4109 = ashr i64 %t4099, 6
%t4110 = and i64 %t4109, 63
%t4111 = call i64 @__m____________lib_crypto_resid__b64_code(i64 %t4110)
br label %L525
L524:
br label %L525
L525:
%t4112 = phi i64 [ %t4111, %L523 ], [ 61, %L524 ]
%t4113b = extractvalue {ptr,ptr} %t4107, 0
%t4113l = extractvalue {ptr,ptr} %t4107, 1
%t4113a = icmp ult i64 %t4112, 128
%t4113r = icmp ult ptr %t4113b, %t4113l
%t4113k = and i1 %t4113a, %t4113r
br i1 %t4113k, label %L526, label %L527
L526:
%t4113v = trunc i64 %t4112 to i8
store i8 %t4113v, ptr %t4113b, align 1
%t4113q = getelementptr i8, ptr %t4113b, i64 1
%t4113f = insertvalue {ptr,ptr} %t4107, ptr %t4113q, 0
br label %L528
L527:
%t4113nb = call ptr @resid_sb2_push_cp(ptr %t4113b, ptr %t4113l, i64 %t4112)
%t4113nl = call ptr @resid_sb2_lim()
%t4113sx = insertvalue {ptr,ptr} zeroinitializer, ptr %t4113nb, 0
%t4113s = insertvalue {ptr,ptr} %t4113sx, ptr %t4113nl, 1
br label %L528
L528:
%t4113 = phi {ptr,ptr} [ %t4113f, %L526 ], [ %t4113s, %L527 ]
%t4114 = icmp sgt i64 %t4075, 2
br i1 %t4114, label %L529, label %L530
L529:
%t4115 = and i64 %t4099, 63
%t4116 = call i64 @__m____________lib_crypto_resid__b64_code(i64 %t4115)
br label %L531
L530:
br label %L531
L531:
%t4117 = phi i64 [ %t4116, %L529 ], [ 61, %L530 ]
%t4118b = extractvalue {ptr,ptr} %t4113, 0
%t4118l = extractvalue {ptr,ptr} %t4113, 1
%t4118a = icmp ult i64 %t4117, 128
%t4118r = icmp ult ptr %t4118b, %t4118l
%t4118k = and i1 %t4118a, %t4118r
br i1 %t4118k, label %L532, label %L533
L532:
%t4118v = trunc i64 %t4117 to i8
store i8 %t4118v, ptr %t4118b, align 1
%t4118q = getelementptr i8, ptr %t4118b, i64 1
%t4118f = insertvalue {ptr,ptr} %t4113, ptr %t4118q, 0
br label %L534
L533:
%t4118nb = call ptr @resid_sb2_push_cp(ptr %t4118b, ptr %t4118l, i64 %t4117)
%t4118nl = call ptr @resid_sb2_lim()
%t4118sx = insertvalue {ptr,ptr} zeroinitializer, ptr %t4118nb, 0
%t4118s = insertvalue {ptr,ptr} %t4118sx, ptr %t4118nl, 1
br label %L534
L534:
%t4118 = phi {ptr,ptr} [ %t4118f, %L532 ], [ %t4118s, %L533 ]
%t4119 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 3)
%t4120 = extractvalue {i64, i1} %t4119, 0
%t4121 = extractvalue {i64, i1} %t4119, 1
%t4122 = zext i1 %t4121 to i8
call void @resid_overflow_check(i8 %t4122)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @base64_decode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4124 = call i64 @str_len(ptr %p0)
%t4125 = call ptr @resid_listbuf_new()
%t4126 = call ptr @__m____________lib_crypto_resid__b64_strip(ptr %p0, i64 0, i64 %t4124, ptr %t4125)
%t4127 = call i64 @resid_list_len(ptr %t4126)
%t4128 = call i64 @__m____________lib_crypto_resid__b64_pads(ptr %t4126, i64 %t4127, i64 0)
%t4129 = call i64 @resid_list_len(ptr %t4126)
%t4130 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t4129, i64 %t4128)
%t4131 = extractvalue {i64, i1} %t4130, 0
%t4132 = extractvalue {i64, i1} %t4130, 1
%t4133 = zext i1 %t4132 to i8
call void @resid_overflow_check(i8 %t4133)
%t4134 = call ptr @resid_list_slice(ptr %t4126, i64 0, i64 %t4131)
%t4136 = call ptr @base64g_decode__g_Int_64__Int_64_(ptr %t4134, i64 %t4128)
ret ptr %t4136
}
define i1 @__m____________lib_crypto_resid__b64_is_space(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4137 = icmp eq i64 %p0, 32
br label %LSL4138
LSL4138:
br i1 %t4137, label %LSJ4138, label %LSR4138
LSR4138:
%t4139 = icmp eq i64 %p0, 9
br label %LSJ4138
LSJ4138:
%t4140 = phi i1 [ true, %LSL4138 ], [ %t4139, %LSR4138 ]
br label %LSL4141
LSL4141:
br i1 %t4140, label %LSJ4141, label %LSR4141
LSR4141:
%t4142 = icmp eq i64 %p0, 10
br label %LSJ4141
LSJ4141:
%t4143 = phi i1 [ true, %LSL4141 ], [ %t4142, %LSR4141 ]
br label %LSL4144
LSL4144:
br i1 %t4143, label %LSJ4144, label %LSR4144
LSR4144:
%t4145 = icmp eq i64 %p0, 13
br label %LSJ4144
LSJ4144:
%t4146 = phi i1 [ true, %LSL4144 ], [ %t4145, %LSR4144 ]
br i1 %t4146, label %L535, label %L537
L535:
ret i1 true
L537:
ret i1 false
}
define ptr @__m____________lib_crypto_resid__b64_strip(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4161, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t4160, %tco.s0 ]
%t4147 = icmp sge i64 %p1, %p2
br i1 %t4147, label %L538, label %L540
L538:
%t4148 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty4148)
ret ptr %t4148
L540:
%t4149 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t4150 = call i1 @__m____________lib_crypto_resid__b64_is_space(i64 %t4149)
br i1 %t4150, label %L541, label %L542
L541:
br label %L543
L542:
%t4151 = icmp sgt i64 %t4149, 127
br label %LSL4152
LSL4152:
br i1 %t4151, label %LSJ4152, label %LSR4152
LSR4152:
%t4153 = icmp slt i64 %t4149, 0
br label %LSJ4152
LSJ4152:
%t4154 = phi i1 [ true, %LSL4152 ], [ %t4153, %LSR4152 ]
br i1 %t4154, label %L544, label %L545
L544:
br label %L546
L545:
br label %L546
L546:
%t4155 = phi i64 [ 0, %L544 ], [ %t4149, %L545 ]
%t4156 = call ptr @resid_box_i64(i64 %t4155)
%t4159 = call ptr @resid_listbuf_push(ptr %p3, ptr %t4156)
br label %L543
L543:
%t4160 = phi ptr [ %p3, %L541 ], [ %t4159, %L546 ]
%t4161 = add nsw i64 %p1, 1
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4183, %tco.s0 ]
%t4163 = icmp sge i64 %p2, 2
br label %LSL4164
LSL4164:
br i1 %t4163, label %LSJ4164, label %LSR4164
LSR4164:
%t4165 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 %p2)
%t4166 = extractvalue {i64, i1} %t4165, 0
%t4167 = extractvalue {i64, i1} %t4165, 1
%t4168 = zext i1 %t4167 to i8
call void @resid_overflow_check(i8 %t4168)
%t4169 = icmp sle i64 %t4166, 0
br label %LSJ4164
LSJ4164:
%t4170 = phi i1 [ true, %LSL4164 ], [ %t4169, %LSR4164 ]
br i1 %t4170, label %L547, label %L549
L547:
ret i64 %p2
L549:
%t4171 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 %p2)
%t4172 = extractvalue {i64, i1} %t4171, 0
%t4173 = extractvalue {i64, i1} %t4171, 1
%t4174 = zext i1 %t4173 to i8
call void @resid_overflow_check(i8 %t4174)
%t4175 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t4172, i64 1)
%t4176 = extractvalue {i64, i1} %t4175, 0
%t4177 = extractvalue {i64, i1} %t4175, 1
%t4178 = zext i1 %t4177 to i8
call void @resid_overflow_check(i8 %t4178)
%t4179 = call ptr @resid_list_get_v(ptr %p0, i64 %t4176, ptr %p0.ld, i64 %p0.ln)
%t4180 = call i64 @resid_unbox_i64(ptr %t4179)
%t4182 = icmp ne i64 %t4180, 61
br i1 %t4182, label %L550, label %L552
L550:
ret i64 %p2
L552:
%t4183 = add nsw i64 %p2, 1
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4189, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t4185 = icmp sle i64 %p2, 0
br i1 %t4185, label %L553, label %L555
L553:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L555:
%t4186 = call ptr @hmac_sha256_bytes(ptr %p1, ptr %p0)
%t4187 = call ptr @resid_list_freeze(ptr %t4186)
%t4188 = call ptr @pbkdf2_xor_acc(ptr %p3, ptr %t4187, i64 0)
%t4189 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4187, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t4188, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4187, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t4188, %tco.s0 ]
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4202, %tco.s0.k ]
%t4191 = call i64 @resid_list_len(ptr %p1)
%t4192 = icmp sge i64 %p2, %t4191
br i1 %t4192, label %L556, label %L558
L556:
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %p0
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L558:
%t4193 = call ptr @resid_list_get(ptr %p0, i64 %p2)
%t4194 = call i64 @resid_unbox_i64(ptr %t4193)
%t4196 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t4197 = call i64 @resid_unbox_i64(ptr %t4196)
%t4199 = xor i64 %t4194, %t4197
%t4200 = and i64 %t4199, 255
%t4201 = call ptr @ls_set(ptr %p0, i64 %p2, i64 %t4200)
%t4202 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4201, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4201, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
br label %tco.head
}
define ptr @pbkdf2_hmac_sha256(ptr %p0, ptr %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4204 = and i64 %p3, 255
%t4205 = ashr i64 %p3, 8
%t4206 = and i64 %t4205, 255
%t4207 = ashr i64 %p3, 16
%t4208 = and i64 %t4207, 255
%t4209 = ashr i64 %p3, 24
%t4210 = and i64 %t4209, 255
%t4211 = alloca [4 x ptr]
%t4213 = call ptr @resid_box_i64(i64 %t4210)
%t4215 = getelementptr i8, ptr %t4211, i64 0
store ptr %t4213, ptr %t4215
%t4216 = call ptr @resid_box_i64(i64 %t4208)
%t4218 = getelementptr i8, ptr %t4211, i64 8
store ptr %t4216, ptr %t4218
%t4219 = call ptr @resid_box_i64(i64 %t4206)
%t4221 = getelementptr i8, ptr %t4211, i64 16
store ptr %t4219, ptr %t4221
%t4222 = call ptr @resid_box_i64(i64 %t4204)
%t4224 = getelementptr i8, ptr %t4211, i64 24
store ptr %t4222, ptr %t4224
%t4225 = call ptr @resid_list_new(i64 4, ptr %t4211, ptr @.lty4211)
%t4226 = call ptr @sconcat(ptr %p1, ptr %t4225)
%t4227 = call ptr @resid_list_freeze(ptr %t4226)
%t4228 = call ptr @hmac_sha256_bytes(ptr %p0, ptr %t4227)
%t4229 = call ptr @resid_list_freeze(ptr %t4228)
%t4230 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 1)
%t4231 = extractvalue {i64, i1} %t4230, 0
%t4232 = extractvalue {i64, i1} %t4230, 1
%t4233 = zext i1 %t4232 to i8
call void @resid_overflow_check(i8 %t4233)
%t4234 = call ptr @pbkdf2_f(ptr %t4229, ptr %p0, i64 %t4231, ptr %t4229)
ret ptr %t4234
}
define ptr @hkdf_extract(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4235 = musttail call ptr @hmac_sha256_bytes(ptr %p0, ptr %p1)
ret ptr %t4235
}
define i64 @hkdf_rounds(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4236 = sdiv i64 %p0, 32
%t4237 = srem i64 %p0, 32
%t4238 = icmp ne i64 %t4237, 0
br i1 %t4238, label %L559, label %L561
L559:
%t4239 = add nsw i64 %t4236, 1
ret i64 %t4239
L561:
ret i64 %t4236
}
define ptr @hkdf_exp_acc(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4243 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4254, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0.k ]
%p4 = phi ptr [ %p4.in, %entry ], [ %p4.ev.tco.s0, %tco.s0.k ]
%p5 = phi ptr [ %p5.in, %entry ], [ %p5.ev.tco.s0, %tco.s0.k ]
%t4240 = icmp sgt i64 %p2, %p3
br i1 %t4240, label %L562, label %L564
L562:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p5
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p5, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L564:
%t4241 = call ptr @sconcat(ptr %p4, ptr %p1)
%t4242 = call ptr @resid_list_freeze(ptr %t4241)
%t4245 = call ptr @resid_box_i64(i64 %p2)
%t4247 = getelementptr i8, ptr %t4243, i64 0
store ptr %t4245, ptr %t4247
%t4249e = load ptr, ptr %t4243
%t4249 = call ptr @resid_list_push(ptr %t4242, ptr %t4249e)
%t4250 = call ptr @hmac_sha256_bytes(ptr %p0, ptr %t4249)
%t4251 = call ptr @resid_list_freeze(ptr %t4250)
%t4252 = call ptr @sconcat(ptr %p5, ptr %t4251)
%t4253 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t4254 = extractvalue {i64, i1} %t4253, 0
%t4255 = extractvalue {i64, i1} %t4253, 1
%t4256 = zext i1 %t4255 to i8
call void @resid_overflow_check(i8 %t4256)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p4.e.tco.s0 = call ptr @resid_mv_list(ptr %t4251, ptr %lr.cx.tco.s0)
%p5.e.tco.s0 = call ptr @resid_mv_list(ptr %t4252, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p4.ev.tco.s0 = phi ptr [ %p4.e.tco.s0, %tco.s0.c ], [ %t4251, %tco.s0 ]
%p5.ev.tco.s0 = phi ptr [ %p5.e.tco.s0, %tco.s0.c ], [ %t4252, %tco.s0 ]
br label %tco.head
}
define ptr @hkdf_expand(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4258 = icmp slt i64 %p2, 0
br label %LSL4259
LSL4259:
br i1 %t4258, label %LSJ4259, label %LSR4259
LSR4259:
%t4260 = icmp sgt i64 %p2, 8160
br label %LSJ4259
LSJ4259:
%t4261 = phi i1 [ true, %LSL4259 ], [ %t4260, %LSR4259 ]
br i1 %t4261, label %L565, label %L567
L565:
%t4263 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4262)
ret ptr %t4263
L567:
%t4264 = call i64 @hkdf_rounds(i64 %p2)
%t4266 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4265)
%t4268 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4267)
%t4269 = call ptr @hkdf_exp_acc(ptr %p0, ptr %p1, i64 1, i64 %t4264, ptr %t4266, ptr %t4268)
%t4271 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4270)
%t4272 = call ptr @hkdf_take(ptr %t4269, i64 0, i64 %p2, ptr %t4271)
ret ptr %t4272
}
define ptr @hkdf_take(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4277 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4284, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t4273 = icmp sge i64 %p1, %p2
br i1 %t4273, label %L568, label %L570
L568:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p3
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L570:
%t4274 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t4275 = call i64 @resid_unbox_i64(ptr %t4274)
%t4279 = call ptr @resid_box_i64(i64 %t4275)
%t4281 = getelementptr i8, ptr %t4277, i64 0
store ptr %t4279, ptr %t4281
%t4282 = call ptr @resid_list_new(i64 1, ptr %t4277, ptr @.lty4277)
%t4283 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t4282)
%t4284 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t4283, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t4283, %tco.s0 ]
br label %tco.head
}
define ptr @hkdf_sha256(ptr %p0, ptr %p1, ptr %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4286 = call ptr @hkdf_extract(ptr %p0, ptr %p1)
%t4287 = call ptr @resid_list_freeze(ptr %t4286)
%t4288 = call ptr @hkdf_expand(ptr %t4287, ptr %p2, i64 %p3)
ret ptr %t4288
}
define ptr @random_bytes(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4289 = icmp sle i64 %p0, 0
br i1 %t4289, label %L571, label %L573
L571:
%t4291 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4290)
ret ptr %t4291
L573:
%t4293 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4292)
%t4294 = call ptr @__m____________lib_crypto_resid__rand_blocks(i64 %p0, ptr %t4293)
ret ptr %t4294
}
define ptr @__m____________lib_crypto_resid__rand_blocks(i64 %p0.in, ptr %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%t4295 = call i64 @resid_list_len(ptr %p1)
%t4296 = icmp sge i64 %t4295, %p0
br i1 %t4296, label %L574, label %L576
L574:
%t4297 = call ptr @resid_list_slice(ptr %p1, i64 0, i64 %p0)
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %t4297
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %t4297, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L576:
%t4299 = call ptr @__m____________lib_crypto_resid__rand_block()
%t4300 = call ptr @resid_list_freeze(ptr %t4299)
%t4301 = call ptr @resid_list_concat_own(ptr %p1, i8 1, ptr %t4300)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %t4301, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %t4301, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_crypto_resid__rand_block() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4303 = call ptr @resid_random_os(i64 32)
%t4304 = call i64 @resid_list_len(ptr %t4303)
%t4305 = icmp eq i64 %t4304, 32
%t4307 = zext i1 %t4305 to i8
call void @resid_assert(i8 %t4307, ptr @.s4306)
%t4308 = call ptr @resid_random_cpu(i64 32)
%t4310 = call ptr @resid_list_const_i64(ptr @.lc4309, i64 4, ptr @.lcd4309, ptr @.lty4309)
%t4311 = call ptr @resid_list_concat(ptr %t4310, ptr %t4303)
%t4312 = call i64 @resid_list_len(ptr %t4308)
%t4313 = call ptr @__m____________lib_crypto_resid__rand_u32(i64 %t4312)
%t4314 = call ptr @resid_list_freeze(ptr %t4313)
%t4315 = call ptr @resid_list_concat(ptr %t4311, ptr %t4314)
%t4316 = call ptr @resid_list_concat(ptr %t4315, ptr %t4308)
%t4317 = call ptr @sha512_bytes(ptr %t4316)
ret ptr %t4317
}
define ptr @__m____________lib_crypto_resid__rand_u32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4318 = ashr i64 %p0, 24
%t4319 = and i64 %t4318, 255
%t4320 = ashr i64 %p0, 16
%t4321 = and i64 %t4320, 255
%t4322 = ashr i64 %p0, 8
%t4323 = and i64 %t4322, 255
%t4324 = and i64 %p0, 255
%t4325 = alloca [4 x ptr]
%t4327 = call ptr @resid_box_i64(i64 %t4319)
%t4329 = getelementptr i8, ptr %t4325, i64 0
store ptr %t4327, ptr %t4329
%t4330 = call ptr @resid_box_i64(i64 %t4321)
%t4332 = getelementptr i8, ptr %t4325, i64 8
store ptr %t4330, ptr %t4332
%t4333 = call ptr @resid_box_i64(i64 %t4323)
%t4335 = getelementptr i8, ptr %t4325, i64 16
store ptr %t4333, ptr %t4335
%t4336 = call ptr @resid_box_i64(i64 %t4324)
%t4338 = getelementptr i8, ptr %t4325, i64 24
store ptr %t4336, ptr %t4338
%t4339 = call ptr @resid_list_new(i64 4, ptr %t4325, ptr @.lty4325)
ret ptr %t4339
}
define ptr @random_hex(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4340 = call ptr @random_bytes(i64 %p0)
%t4341 = call ptr @hex_encode(ptr %t4340)
ret ptr %t4341
}
define ptr @w64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4342 = and i64 %p0, 4294967295
%t4343 = and i64 %p1, 4294967295
%t4344 = alloca [2 x ptr]
%t4346 = call ptr @resid_box_i64(i64 %t4342)
%t4348 = getelementptr i8, ptr %t4344, i64 0
store ptr %t4346, ptr %t4348
%t4349 = call ptr @resid_box_i64(i64 %t4343)
%t4351 = getelementptr i8, ptr %t4344, i64 8
store ptr %t4349, ptr %t4351
%t4352 = call ptr @resid_list_new(i64 2, ptr %t4344, ptr @.lty4344)
ret ptr %t4352
}
define i64 @w64_hi(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4353 = call ptr @resid_list_get(ptr %p0, i64 0)
%t4354 = musttail call i64 @resid_unbox_i64(ptr %t4353)
ret i64 %t4354
}
define i64 @w64_lo(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4356 = call ptr @resid_list_get(ptr %p0, i64 1)
%t4357 = musttail call i64 @resid_unbox_i64(ptr %t4356)
ret i64 %t4357
}
define ptr @w64_add(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4359 = call i64 @w64_lo(ptr %p0)
%t4360 = call i64 @w64_lo(ptr %p1)
%t4361 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4359, i64 %t4360)
%t4362 = extractvalue {i64, i1} %t4361, 0
%t4363 = extractvalue {i64, i1} %t4361, 1
%t4364 = zext i1 %t4363 to i8
call void @resid_overflow_check(i8 %t4364)
%t4365 = and i64 %t4362, 4294967295
%t4366 = ashr i64 %t4362, 32
%t4367 = call i64 @w64_hi(ptr %p0)
%t4368 = call i64 @w64_hi(ptr %p1)
%t4369 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4367, i64 %t4368)
%t4370 = extractvalue {i64, i1} %t4369, 0
%t4371 = extractvalue {i64, i1} %t4369, 1
%t4372 = zext i1 %t4371 to i8
call void @resid_overflow_check(i8 %t4372)
%t4373 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4370, i64 %t4366)
%t4374 = extractvalue {i64, i1} %t4373, 0
%t4375 = extractvalue {i64, i1} %t4373, 1
%t4376 = zext i1 %t4375 to i8
call void @resid_overflow_check(i8 %t4376)
%t4377 = call ptr @w64(i64 %t4374, i64 %t4365)
ret ptr %t4377
}
define ptr @w64_xor(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4378 = call i64 @w64_hi(ptr %p0)
%t4379 = call i64 @w64_hi(ptr %p1)
%t4380 = xor i64 %t4378, %t4379
%t4381 = call i64 @w64_lo(ptr %p0)
%t4382 = call i64 @w64_lo(ptr %p1)
%t4383 = xor i64 %t4381, %t4382
%t4384 = call ptr @w64(i64 %t4380, i64 %t4383)
ret ptr %t4384
}
define ptr @w64_and(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4385 = call i64 @w64_hi(ptr %p0)
%t4386 = call i64 @w64_hi(ptr %p1)
%t4387 = and i64 %t4385, %t4386
%t4388 = call i64 @w64_lo(ptr %p0)
%t4389 = call i64 @w64_lo(ptr %p1)
%t4390 = and i64 %t4388, %t4389
%t4391 = call ptr @w64(i64 %t4387, i64 %t4390)
ret ptr %t4391
}
define ptr @w64_not(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4392 = call i64 @w64_hi(ptr %p0)
%t4393 = xor i64 %t4392, 4294967295
%t4394 = and i64 %t4393, 4294967295
%t4395 = call i64 @w64_lo(ptr %p0)
%t4396 = xor i64 %t4395, 4294967295
%t4397 = and i64 %t4396, 4294967295
%t4398 = call ptr @w64(i64 %t4394, i64 %t4397)
ret ptr %t4398
}
define ptr @w64_zext(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4399 = call i64 @w64_lo(ptr %p0)
%t4400 = call ptr @w64__rs272(i64 0, i64 %t4399)
ret ptr %t4400
}
define ptr @w64_rotr_small(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4401 = call i64 @w64_hi(ptr %p0)
%t4402 = call i64 @w64_lo(ptr %p0)
%t4403 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t4404 = extractvalue {i64, i1} %t4403, 0
%t4405 = extractvalue {i64, i1} %t4403, 1
%t4406 = zext i1 %t4405 to i8
call void @resid_overflow_check(i8 %t4406)
%t4407 = icmp uge i64 %p1, 64
%t4408 = add i64 %p1, 0
%t4409 = select i1 %t4407, i64 63, i64 %t4408
%t4410 = ashr i64 %t4401, %t4409
%t4411 = icmp uge i64 %t4404, 64
%t4412 = add i64 %t4404, 0
%t4413 = shl i64 %t4402, %t4412
%t4414 = select i1 %t4411, i64 0, i64 %t4413
%t4415 = or i64 %t4410, %t4414
%t4416 = icmp uge i64 %p1, 64
%t4417 = add i64 %p1, 0
%t4418 = select i1 %t4416, i64 63, i64 %t4417
%t4419 = ashr i64 %t4402, %t4418
%t4420 = icmp uge i64 %t4404, 64
%t4421 = add i64 %t4404, 0
%t4422 = shl i64 %t4401, %t4421
%t4423 = select i1 %t4420, i64 0, i64 %t4422
%t4424 = or i64 %t4419, %t4423
%t4425 = call ptr @w64(i64 %t4415, i64 %t4424)
ret ptr %t4425
}
define ptr @w64_rotr(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4426 = icmp eq i64 %p1, 0
br i1 %t4426, label %L577, label %L579
L577:
ret ptr %p0
L579:
%t4427 = icmp eq i64 %p1, 32
br i1 %t4427, label %L580, label %L582
L580:
%t4428 = call i64 @w64_lo(ptr %p0)
%t4429 = call i64 @w64_hi(ptr %p0)
%t4430 = call ptr @w64(i64 %t4428, i64 %t4429)
ret ptr %t4430
L582:
%t4431 = icmp sgt i64 %p1, 32
br i1 %t4431, label %L583, label %L585
L583:
%t4432 = sub nsw i64 %p1, 32
%t4433 = call i64 @w64_lo(ptr %p0)
%t4434 = call i64 @w64_hi(ptr %p0)
%t4435 = call ptr @w64(i64 %t4433, i64 %t4434)
%t4436 = musttail call ptr @w64_rotr_small(ptr %t4435, i64 %t4432)
ret ptr %t4436
L585:
%t4437 = musttail call ptr @w64_rotr_small(ptr %p0, i64 %p1)
ret ptr %t4437
}
define ptr @w64_shr_small(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4438 = call i64 @w64_hi(ptr %p0)
%t4439 = call i64 @w64_lo(ptr %p0)
%t4440 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t4441 = extractvalue {i64, i1} %t4440, 0
%t4442 = extractvalue {i64, i1} %t4440, 1
%t4443 = zext i1 %t4442 to i8
call void @resid_overflow_check(i8 %t4443)
%t4444 = icmp uge i64 %p1, 64
%t4445 = add i64 %p1, 0
%t4446 = select i1 %t4444, i64 63, i64 %t4445
%t4447 = ashr i64 %t4439, %t4446
%t4448 = icmp uge i64 %t4441, 64
%t4449 = add i64 %t4441, 0
%t4450 = shl i64 %t4438, %t4449
%t4451 = select i1 %t4448, i64 0, i64 %t4450
%t4452 = or i64 %t4447, %t4451
%t4453 = icmp uge i64 %p1, 64
%t4454 = add i64 %p1, 0
%t4455 = select i1 %t4453, i64 63, i64 %t4454
%t4456 = ashr i64 %t4438, %t4455
%t4457 = call ptr @w64(i64 %t4456, i64 %t4452)
ret ptr %t4457
}
define ptr @w64_shr(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4458 = icmp eq i64 %p1, 0
br i1 %t4458, label %L586, label %L588
L586:
ret ptr %p0
L588:
%t4459 = icmp sge i64 %p1, 32
br i1 %t4459, label %L589, label %L591
L589:
%t4460 = sub nsw i64 %p1, 32
%t4461 = call i64 @w64_hi(ptr %p0)
%t4462 = icmp uge i64 %t4460, 64
%t4463 = add i64 %t4460, 0
%t4464 = select i1 %t4462, i64 63, i64 %t4463
%t4465 = ashr i64 %t4461, %t4464
%t4466 = call ptr @w64__rs272(i64 0, i64 %t4465)
ret ptr %t4466
L591:
%t4467 = musttail call ptr @w64_shr_small(ptr %p0, i64 %p1)
ret ptr %t4467
}
define ptr @k512_limb_at(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4469 = call ptr @resid_list_const_i64(ptr @.lc4468, i64 160, ptr @.lcd4468, ptr @.lty4468)
%t4470 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p0, i64 2)
%t4471 = extractvalue {i64, i1} %t4470, 0
%t4472 = extractvalue {i64, i1} %t4470, 1
%t4473 = zext i1 %t4472 to i8
call void @resid_overflow_check(i8 %t4473)
%t4474 = call ptr @resid_list_get(ptr %t4469, i64 %t4471)
%t4475 = call i64 @resid_unbox_i64(ptr %t4474)
%t4478 = call ptr @resid_list_const_i64(ptr @.lc4477, i64 160, ptr @.lcd4477, ptr @.lty4477)
%t4479 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p0, i64 2)
%t4480 = extractvalue {i64, i1} %t4479, 0
%t4481 = extractvalue {i64, i1} %t4479, 1
%t4482 = zext i1 %t4481 to i8
call void @resid_overflow_check(i8 %t4482)
%t4483 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4480, i64 1)
%t4484 = extractvalue {i64, i1} %t4483, 0
%t4485 = extractvalue {i64, i1} %t4483, 1
%t4486 = zext i1 %t4485 to i8
call void @resid_overflow_check(i8 %t4486)
%t4487 = call ptr @resid_list_get(ptr %t4478, i64 %t4484)
%t4488 = call i64 @resid_unbox_i64(ptr %t4487)
%t4490 = call ptr @w64(i64 %t4475, i64 %t4488)
ret ptr %t4490
}
define ptr @h512_state() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4492 = call ptr @resid_list_const_i64(ptr @.lc4491, i64 16, ptr @.lcd4491, ptr @.lty4491)
ret ptr %t4492
}
define ptr @h512_seed(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4500 = alloca [1 x ptr]
%t4507 = alloca [1 x ptr]
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t4514, %tco.s0.k ]
%t4493 = icmp sge i64 %p3, 8
br i1 %t4493, label %L592, label %L594
L592:
%lr.cx17 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz17 = icmp eq ptr %lr.cx17, null
br i1 %lr.lz17, label %lr.x17.k, label %lr.x17.m
lr.x17.k:
ret ptr %p0
lr.x17.m:
%lr.ret17 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx17)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret17
L594:
%t4494 = call ptr @resid_list_get_v(ptr %p1, i64 %p3, ptr %p1.ld, i64 %p1.ln)
%t4495 = call i64 @resid_unbox_i64(ptr %t4494)
%t4497 = call ptr @resid_list_get_v(ptr %p2, i64 %p3, ptr %p2.ld, i64 %p2.ln)
%t4498 = call i64 @resid_unbox_i64(ptr %t4497)
%t4502 = call ptr @resid_box_i64(i64 %t4495)
%t4504 = getelementptr i8, ptr %t4500, i64 0
store ptr %t4502, ptr %t4504
%t4505 = call ptr @resid_list_new(i64 1, ptr %t4500, ptr @.lty4500)
%t4506 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t4505)
%t4509 = call ptr @resid_box_i64(i64 %t4498)
%t4511 = getelementptr i8, ptr %t4507, i64 0
store ptr %t4509, ptr %t4511
%t4512 = call ptr @resid_list_new(i64 1, ptr %t4507, ptr @.lty4507)
%t4513 = call ptr @resid_list_concat_own(ptr %t4506, i8 1, ptr %t4512)
%t4514 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4513, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4513, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %p2, %tco.s0 ]
br label %tco.head
}
define ptr @pad512(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4516 = call i64 @resid_list_len(ptr %p0)
%t4518 = call ptr @resid_list_const_i64(ptr @.lc4517, i64 1, ptr @.lcd4517, ptr @.lty4517)
%t4519 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t4518)
%t4520 = add nsw i64 %t4516, 17
%t4521 = add nsw i64 %t4520, 127
%t4522 = sdiv i64 %t4521, 128
%t4523 = mul nsw i64 %t4522, 128
%t4524 = sub nsw i64 %t4523, %t4520
%t4525 = call ptr @zeros_l(ptr %t4519, i64 %t4524)
%t4526 = mul nsw i64 %t4516, 8
%t4527 = call ptr @len512_bytes__rs273(ptr %t4525, i64 %t4526, i64 15)
ret ptr %t4527
}
define i64 @shr_big(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t4533, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4534, %tco.s0 ]
%t4528 = icmp sle i64 %p1, 63
br i1 %t4528, label %L595, label %L597
L595:
%t4529 = icmp uge i64 %p1, 64
%t4530 = add i64 %p1, 0
%t4531 = select i1 %t4529, i64 63, i64 %t4530
%t4532 = ashr i64 %p0, %t4531
ret i64 %t4532
L597:
%t4533 = ashr i64 %p0, 32
%t4534 = sub nsw i64 %p1, 32
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @len512_bytes(ptr %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4543 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4550, %tco.s0.k ]
%t4536 = icmp slt i64 %p2, 0
br i1 %t4536, label %L598, label %L600
L598:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p0
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L600:
%t4537 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t4538 = extractvalue {i64, i1} %t4537, 0
%t4539 = extractvalue {i64, i1} %t4537, 1
%t4540 = zext i1 %t4539 to i8
call void @resid_overflow_check(i8 %t4540)
%t4541 = call i64 @shr_big(i64 %p1, i64 %t4538)
%t4542 = and i64 %t4541, 255
%t4545 = call ptr @resid_box_i64(i64 %t4542)
%t4547 = getelementptr i8, ptr %t4543, i64 0
store ptr %t4545, ptr %t4547
%t4548 = call ptr @resid_list_new(i64 1, ptr %t4543, ptr @.lty4543)
%t4549 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t4548)
%t4550 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4549, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4549, %tco.s0 ]
br label %tco.head
}
define ptr @mw512(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4552 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t4553 = extractvalue {i64, i1} %t4552, 0
%t4554 = extractvalue {i64, i1} %t4552, 1
%t4555 = zext i1 %t4554 to i8
call void @resid_overflow_check(i8 %t4555)
%t4556 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t4553)
%t4557 = extractvalue {i64, i1} %t4556, 0
%t4558 = extractvalue {i64, i1} %t4556, 1
%t4559 = zext i1 %t4558 to i8
call void @resid_overflow_check(i8 %t4559)
%t4560 = call ptr @resid_list_get(ptr %p0, i64 %t4557)
%t4561 = call i64 @resid_unbox_i64(ptr %t4560)
%t4563 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4557, i64 1)
%t4564 = extractvalue {i64, i1} %t4563, 0
%t4565 = extractvalue {i64, i1} %t4563, 1
%t4566 = zext i1 %t4565 to i8
call void @resid_overflow_check(i8 %t4566)
%t4567 = call ptr @resid_list_get(ptr %p0, i64 %t4564)
%t4568 = call i64 @resid_unbox_i64(ptr %t4567)
%t4570 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4557, i64 2)
%t4571 = extractvalue {i64, i1} %t4570, 0
%t4572 = extractvalue {i64, i1} %t4570, 1
%t4573 = zext i1 %t4572 to i8
call void @resid_overflow_check(i8 %t4573)
%t4574 = call ptr @resid_list_get(ptr %p0, i64 %t4571)
%t4575 = call i64 @resid_unbox_i64(ptr %t4574)
%t4577 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4557, i64 3)
%t4578 = extractvalue {i64, i1} %t4577, 0
%t4579 = extractvalue {i64, i1} %t4577, 1
%t4580 = zext i1 %t4579 to i8
call void @resid_overflow_check(i8 %t4580)
%t4581 = call ptr @resid_list_get(ptr %p0, i64 %t4578)
%t4582 = call i64 @resid_unbox_i64(ptr %t4581)
%t4584 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4557, i64 4)
%t4585 = extractvalue {i64, i1} %t4584, 0
%t4586 = extractvalue {i64, i1} %t4584, 1
%t4587 = zext i1 %t4586 to i8
call void @resid_overflow_check(i8 %t4587)
%t4588 = call ptr @resid_list_get(ptr %p0, i64 %t4585)
%t4589 = call i64 @resid_unbox_i64(ptr %t4588)
%t4591 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4557, i64 5)
%t4592 = extractvalue {i64, i1} %t4591, 0
%t4593 = extractvalue {i64, i1} %t4591, 1
%t4594 = zext i1 %t4593 to i8
call void @resid_overflow_check(i8 %t4594)
%t4595 = call ptr @resid_list_get(ptr %p0, i64 %t4592)
%t4596 = call i64 @resid_unbox_i64(ptr %t4595)
%t4598 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4557, i64 6)
%t4599 = extractvalue {i64, i1} %t4598, 0
%t4600 = extractvalue {i64, i1} %t4598, 1
%t4601 = zext i1 %t4600 to i8
call void @resid_overflow_check(i8 %t4601)
%t4602 = call ptr @resid_list_get(ptr %p0, i64 %t4599)
%t4603 = call i64 @resid_unbox_i64(ptr %t4602)
%t4605 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4557, i64 7)
%t4606 = extractvalue {i64, i1} %t4605, 0
%t4607 = extractvalue {i64, i1} %t4605, 1
%t4608 = zext i1 %t4607 to i8
call void @resid_overflow_check(i8 %t4608)
%t4609 = call ptr @resid_list_get(ptr %p0, i64 %t4606)
%t4610 = call i64 @resid_unbox_i64(ptr %t4609)
%t4612 = shl i64 %t4561, 24
%t4613 = shl i64 %t4568, 16
%t4614 = shl i64 %t4575, 8
%t4615 = or i64 %t4612, %t4613
%t4616 = or i64 %t4615, %t4614
%t4617 = or i64 %t4616, %t4582
%t4618 = and i64 %t4617, 4294967295
%t4619 = shl i64 %t4589, 24
%t4620 = shl i64 %t4596, 16
%t4621 = shl i64 %t4603, 8
%t4622 = or i64 %t4619, %t4620
%t4623 = or i64 %t4622, %t4621
%t4624 = or i64 %t4623, %t4610
%t4625 = and i64 %t4624, 4294967295
%t4626 = alloca [2 x ptr]
%t4628 = call ptr @resid_box_i64(i64 %t4618)
%t4630 = getelementptr i8, ptr %t4626, i64 0
store ptr %t4628, ptr %t4630
%t4631 = call ptr @resid_box_i64(i64 %t4625)
%t4633 = getelementptr i8, ptr %t4626, i64 8
store ptr %t4631, ptr %t4633
%t4634 = call ptr @resid_list_new(i64 2, ptr %t4626, ptr @.lty4626)
ret ptr %t4634
}
define ptr @mw512_acc(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4639, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t4635 = icmp sge i64 %p2, 16
br i1 %t4635, label %L601, label %L603
L601:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L603:
%t4636 = call ptr @mw512(ptr %p0, i64 %p1, i64 %p2)
%t4637 = call ptr @resid_list_freeze(ptr %t4636)
%t4638 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t4637)
%t4639 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t4638, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t4638, %tco.s0 ]
br label %tco.head
}
define ptr @msg_words512(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4642 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4641)
%t4643 = call ptr @mw512_acc__rs289(ptr %p0, i64 %p1, i64 0, ptr %t4642)
ret ptr %t4643
}
define i64 @fw_hi(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4644 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4645 = extractvalue {i64, i1} %t4644, 0
%t4646 = extractvalue {i64, i1} %t4644, 1
%t4647 = zext i1 %t4646 to i8
call void @resid_overflow_check(i8 %t4647)
%t4648 = call ptr @resid_list_get(ptr %p0, i64 %t4645)
%t4649 = call i64 @resid_unbox_i64(ptr %t4648)
ret i64 %t4649
}
define i64 @fw_lo(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4651 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4652 = extractvalue {i64, i1} %t4651, 0
%t4653 = extractvalue {i64, i1} %t4651, 1
%t4654 = zext i1 %t4653 to i8
call void @resid_overflow_check(i8 %t4654)
%t4655 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4652, i64 1)
%t4656 = extractvalue {i64, i1} %t4655, 0
%t4657 = extractvalue {i64, i1} %t4655, 1
%t4658 = zext i1 %t4657 to i8
call void @resid_overflow_check(i8 %t4658)
%t4659 = call ptr @resid_list_get(ptr %p0, i64 %t4656)
%t4660 = call i64 @resid_unbox_i64(ptr %t4659)
ret i64 %t4660
}
define ptr @fw_pair(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4662 = call i64 @fw_hi(ptr %p0, i64 %p1)
%t4663 = call i64 @fw_lo(ptr %p0, i64 %p1)
%t4664 = call ptr @w64(i64 %t4662, i64 %t4663)
ret ptr %t4664
}
define i64 @ch64_of(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4665 = call i64 @not32(i64 %p0)
%t4666 = and i64 %p0, %p1
%t4667 = and i64 %t4665, %p2
%t4668 = xor i64 %t4666, %t4667
ret i64 %t4668
}
define ptr @hex_byte_at(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4669 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t4670 = call i64 @resid_unbox_i64(ptr %t4669)
%t4672 = and i64 %t4670, 255
%t4673 = ashr i64 %t4672, 4
%t4674 = and i64 %t4673, 15
%t4675 = call ptr @hex_digit(i64 %t4674)
%t4676 = and i64 %t4672, 15
%t4677 = call ptr @hex_digit(i64 %t4676)
%t4678 = call ptr @resid_str_concat(ptr %t4675, ptr %t4677)
ret ptr %t4678
}
define ptr @sig0(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4679 = call ptr @w64_rotr__rs291(ptr %p0, i64 1)
%t4680 = call ptr @w64_rotr__rs293(ptr %p0, i64 8)
%t4681 = call ptr @w64_shr__rs295(ptr %p0, i64 7)
%t4682 = call ptr @w64_xor(ptr %t4679, ptr %t4680)
%t4683 = call ptr @w64_xor(ptr %t4682, ptr %t4681)
ret ptr %t4683
}
define ptr @sig1(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4684 = call ptr @w64_rotr__rs297(ptr %p0, i64 19)
%t4685 = call ptr @w64_rotr__rs299(ptr %p0, i64 61)
%t4686 = call ptr @w64_shr__rs301(ptr %p0, i64 6)
%t4687 = call ptr @w64_xor(ptr %t4684, ptr %t4685)
%t4688 = call ptr @w64_xor(ptr %t4687, ptr %t4686)
ret ptr %t4688
}
define ptr @big_sig0(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4689 = call ptr @w64_rotr__rs303(ptr %p0, i64 28)
%t4690 = call ptr @w64_rotr__rs305(ptr %p0, i64 34)
%t4691 = call ptr @w64_rotr__rs307(ptr %p0, i64 39)
%t4692 = call ptr @w64_xor(ptr %t4689, ptr %t4690)
%t4693 = call ptr @w64_xor(ptr %t4692, ptr %t4691)
ret ptr %t4693
}
define ptr @big_sig1(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4694 = call ptr @w64_rotr__rs309(ptr %p0, i64 14)
%t4695 = call ptr @w64_rotr(ptr %p0, i64 18)
%t4696 = call ptr @w64_rotr(ptr %p0, i64 41)
%t4697 = call ptr @w64_xor(ptr %t4694, ptr %t4695)
%t4698 = call ptr @w64_xor(ptr %t4697, ptr %t4696)
ret ptr %t4698
}
define ptr @maj64(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4699 = call ptr @w64_and(ptr %p0, ptr %p1)
%t4700 = call ptr @w64_and(ptr %p0, ptr %p2)
%t4701 = call ptr @w64_and(ptr %p1, ptr %p2)
%t4702 = call ptr @w64_xor(ptr %t4699, ptr %t4700)
%t4703 = call ptr @w64_xor(ptr %t4702, ptr %t4701)
ret ptr %t4703
}
define ptr @ext512_flat(ptr %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4731 = alloca [1 x ptr]
%t4738 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4746, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%t4704 = icmp sge i64 %p1, %p2
br i1 %t4704, label %L604, label %L606
L604:
%lr.cx12 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz12 = icmp eq ptr %lr.cx12, null
br i1 %lr.lz12, label %lr.x12.k, label %lr.x12.m
lr.x12.k:
ret ptr %p0
lr.x12.m:
%lr.ret12 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx12)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret12
L606:
%t4705 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 15)
%t4706 = extractvalue {i64, i1} %t4705, 0
%t4707 = extractvalue {i64, i1} %t4705, 1
%t4708 = zext i1 %t4707 to i8
call void @resid_overflow_check(i8 %t4708)
%t4709 = call ptr @fw_pair(ptr %p0, i64 %t4706)
%t4710 = call ptr @sig0(ptr %t4709)
%t4711 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 2)
%t4712 = extractvalue {i64, i1} %t4711, 0
%t4713 = extractvalue {i64, i1} %t4711, 1
%t4714 = zext i1 %t4713 to i8
call void @resid_overflow_check(i8 %t4714)
%t4715 = call ptr @fw_pair(ptr %p0, i64 %t4712)
%t4716 = call ptr @sig1(ptr %t4715)
%t4717 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 16)
%t4718 = extractvalue {i64, i1} %t4717, 0
%t4719 = extractvalue {i64, i1} %t4717, 1
%t4720 = zext i1 %t4719 to i8
call void @resid_overflow_check(i8 %t4720)
%t4721 = call ptr @fw_pair(ptr %p0, i64 %t4718)
%t4722 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 7)
%t4723 = extractvalue {i64, i1} %t4722, 0
%t4724 = extractvalue {i64, i1} %t4722, 1
%t4725 = zext i1 %t4724 to i8
call void @resid_overflow_check(i8 %t4725)
%t4726 = call ptr @fw_pair(ptr %p0, i64 %t4723)
%t4727 = call ptr @w64_add(ptr %t4721, ptr %t4710)
%t4728 = call ptr @w64_add(ptr %t4726, ptr %t4716)
%t4729 = call ptr @w64_add(ptr %t4727, ptr %t4728)
%t4730 = call i64 @w64_hi(ptr %t4729)
%t4733 = call ptr @resid_box_i64(i64 %t4730)
%t4735 = getelementptr i8, ptr %t4731, i64 0
store ptr %t4733, ptr %t4735
%t4736 = call ptr @resid_list_new(i64 1, ptr %t4731, ptr @.lty4731)
%t4737 = call i64 @w64_lo(ptr %t4729)
%t4740 = call ptr @resid_box_i64(i64 %t4737)
%t4742 = getelementptr i8, ptr %t4738, i64 0
store ptr %t4740, ptr %t4742
%t4743 = call ptr @resid_list_new(i64 1, ptr %t4738, ptr @.lty4738)
%t4744 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t4736)
%t4745 = call ptr @resid_list_concat_own(ptr %t4744, i8 1, ptr %t4743)
%t4746 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4745, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4745, %tco.s0 ]
br label %tco.head
}
define ptr @state512_init() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4749 = call ptr @resid_list_const_i64(ptr @.lc4748, i64 16, ptr @.lcd4748, ptr @.lty4748)
ret ptr %t4749
}
define ptr @st_set(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4750 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4751 = extractvalue {i64, i1} %t4750, 0
%t4752 = extractvalue {i64, i1} %t4750, 1
%t4753 = zext i1 %t4752 to i8
call void @resid_overflow_check(i8 %t4753)
%t4754 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4751, i64 1)
%t4755 = extractvalue {i64, i1} %t4754, 0
%t4756 = extractvalue {i64, i1} %t4754, 1
%t4757 = zext i1 %t4756 to i8
call void @resid_overflow_check(i8 %t4757)
%t4758 = call i64 @w64_hi(ptr %p2)
%t4759 = call ptr @ls_set(ptr %p0, i64 %t4751, i64 %t4758)
%t4760 = call i64 @w64_lo(ptr %p2)
%t4761 = call ptr @ls_set(ptr %t4759, i64 %t4755, i64 %t4760)
ret ptr %t4761
}
define i64 @st_hi(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4762 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4763 = extractvalue {i64, i1} %t4762, 0
%t4764 = extractvalue {i64, i1} %t4762, 1
%t4765 = zext i1 %t4764 to i8
call void @resid_overflow_check(i8 %t4765)
%t4766 = call ptr @resid_list_get(ptr %p0, i64 %t4763)
%t4767 = call i64 @resid_unbox_i64(ptr %t4766)
ret i64 %t4767
}
define i64 @st_lo(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4769 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4770 = extractvalue {i64, i1} %t4769, 0
%t4771 = extractvalue {i64, i1} %t4769, 1
%t4772 = zext i1 %t4771 to i8
call void @resid_overflow_check(i8 %t4772)
%t4773 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4770, i64 1)
%t4774 = extractvalue {i64, i1} %t4773, 0
%t4775 = extractvalue {i64, i1} %t4773, 1
%t4776 = zext i1 %t4775 to i8
call void @resid_overflow_check(i8 %t4776)
%t4777 = call ptr @resid_list_get(ptr %p0, i64 %t4774)
%t4778 = call i64 @resid_unbox_i64(ptr %t4777)
ret i64 %t4778
}
define ptr @sha512_round_flat(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4780 = call ptr @fw_pair(ptr %p0, i64 0)
%t4781 = call ptr @fw_pair(ptr %p0, i64 1)
%t4782 = call ptr @fw_pair(ptr %p0, i64 2)
%t4783 = call ptr @fw_pair(ptr %p0, i64 3)
%t4784 = call ptr @fw_pair(ptr %p0, i64 4)
%t4785 = call ptr @resid_list_freeze(ptr %t4784)
%t4786 = call ptr @fw_pair(ptr %p0, i64 5)
%t4787 = call ptr @fw_pair(ptr %p0, i64 6)
%t4788 = call ptr @fw_pair(ptr %p0, i64 7)
%t4789 = call ptr @fw_pair(ptr %p1, i64 %p2)
%t4790 = call ptr @k512_limb_at(i64 %p2)
%t4791 = call ptr @big_sig1(ptr %t4785)
%t4792 = call ptr @w64_not(ptr %t4785)
%t4793 = call ptr @w64_and(ptr %t4785, ptr %t4786)
%t4794 = call ptr @w64_and(ptr %t4792, ptr %t4787)
%t4795 = call ptr @w64_xor(ptr %t4793, ptr %t4794)
%t4796 = call ptr @w64_add(ptr %t4788, ptr %t4791)
%t4797 = call ptr @w64_add(ptr %t4796, ptr %t4795)
%t4798 = call ptr @w64_add(ptr %t4797, ptr %t4790)
%t4799 = call ptr @w64_add(ptr %t4798, ptr %t4789)
%t4800 = call ptr @big_sig0(ptr %t4780)
%t4801 = call ptr @maj64(ptr %t4780, ptr %t4781, ptr %t4782)
%t4802 = call ptr @w64_add(ptr %t4800, ptr %t4801)
%t4803 = call ptr @w64_add(ptr %t4799, ptr %t4802)
%t4804 = call ptr @w64_add(ptr %t4783, ptr %t4799)
%t4805 = call ptr @resid_list_get(ptr %t4803, i64 0)
%t4806 = call i64 @resid_unbox_i64(ptr %t4805)
%t4808 = call ptr @resid_list_get(ptr %t4803, i64 1)
%t4809 = call i64 @resid_unbox_i64(ptr %t4808)
%t4811 = call ptr @resid_list_get(ptr %t4780, i64 0)
%t4812 = call i64 @resid_unbox_i64(ptr %t4811)
%t4814 = call ptr @resid_list_get(ptr %t4780, i64 1)
%t4815 = call i64 @resid_unbox_i64(ptr %t4814)
%t4817 = call ptr @resid_list_get(ptr %t4781, i64 0)
%t4818 = call i64 @resid_unbox_i64(ptr %t4817)
%t4820 = call ptr @resid_list_get(ptr %t4781, i64 1)
%t4821 = call i64 @resid_unbox_i64(ptr %t4820)
%t4823 = call ptr @resid_list_get(ptr %t4782, i64 0)
%t4824 = call i64 @resid_unbox_i64(ptr %t4823)
%t4826 = call ptr @resid_list_get(ptr %t4782, i64 1)
%t4827 = call i64 @resid_unbox_i64(ptr %t4826)
%t4829 = call ptr @resid_list_get(ptr %t4804, i64 0)
%t4830 = call i64 @resid_unbox_i64(ptr %t4829)
%t4832 = call ptr @resid_list_get(ptr %t4804, i64 1)
%t4833 = call i64 @resid_unbox_i64(ptr %t4832)
%t4835 = call ptr @resid_list_get(ptr %t4785, i64 0)
%t4836 = call i64 @resid_unbox_i64(ptr %t4835)
%t4838 = call ptr @resid_list_get(ptr %t4785, i64 1)
%t4839 = call i64 @resid_unbox_i64(ptr %t4838)
%t4841 = call ptr @resid_list_get(ptr %t4786, i64 0)
%t4842 = call i64 @resid_unbox_i64(ptr %t4841)
%t4844 = call ptr @resid_list_get(ptr %t4786, i64 1)
%t4845 = call i64 @resid_unbox_i64(ptr %t4844)
%t4847 = call ptr @resid_list_get(ptr %t4787, i64 0)
%t4848 = call i64 @resid_unbox_i64(ptr %t4847)
%t4850 = call ptr @resid_list_get(ptr %t4787, i64 1)
%t4851 = call i64 @resid_unbox_i64(ptr %t4850)
%t4853 = alloca [16 x ptr]
%t4855 = call ptr @resid_box_i64(i64 %t4806)
%t4857 = getelementptr i8, ptr %t4853, i64 0
store ptr %t4855, ptr %t4857
%t4858 = call ptr @resid_box_i64(i64 %t4809)
%t4860 = getelementptr i8, ptr %t4853, i64 8
store ptr %t4858, ptr %t4860
%t4861 = call ptr @resid_box_i64(i64 %t4812)
%t4863 = getelementptr i8, ptr %t4853, i64 16
store ptr %t4861, ptr %t4863
%t4864 = call ptr @resid_box_i64(i64 %t4815)
%t4866 = getelementptr i8, ptr %t4853, i64 24
store ptr %t4864, ptr %t4866
%t4867 = call ptr @resid_box_i64(i64 %t4818)
%t4869 = getelementptr i8, ptr %t4853, i64 32
store ptr %t4867, ptr %t4869
%t4870 = call ptr @resid_box_i64(i64 %t4821)
%t4872 = getelementptr i8, ptr %t4853, i64 40
store ptr %t4870, ptr %t4872
%t4873 = call ptr @resid_box_i64(i64 %t4824)
%t4875 = getelementptr i8, ptr %t4853, i64 48
store ptr %t4873, ptr %t4875
%t4876 = call ptr @resid_box_i64(i64 %t4827)
%t4878 = getelementptr i8, ptr %t4853, i64 56
store ptr %t4876, ptr %t4878
%t4879 = call ptr @resid_box_i64(i64 %t4830)
%t4881 = getelementptr i8, ptr %t4853, i64 64
store ptr %t4879, ptr %t4881
%t4882 = call ptr @resid_box_i64(i64 %t4833)
%t4884 = getelementptr i8, ptr %t4853, i64 72
store ptr %t4882, ptr %t4884
%t4885 = call ptr @resid_box_i64(i64 %t4836)
%t4887 = getelementptr i8, ptr %t4853, i64 80
store ptr %t4885, ptr %t4887
%t4888 = call ptr @resid_box_i64(i64 %t4839)
%t4890 = getelementptr i8, ptr %t4853, i64 88
store ptr %t4888, ptr %t4890
%t4891 = call ptr @resid_box_i64(i64 %t4842)
%t4893 = getelementptr i8, ptr %t4853, i64 96
store ptr %t4891, ptr %t4893
%t4894 = call ptr @resid_box_i64(i64 %t4845)
%t4896 = getelementptr i8, ptr %t4853, i64 104
store ptr %t4894, ptr %t4896
%t4897 = call ptr @resid_box_i64(i64 %t4848)
%t4899 = getelementptr i8, ptr %t4853, i64 112
store ptr %t4897, ptr %t4899
%t4900 = call ptr @resid_box_i64(i64 %t4851)
%t4902 = getelementptr i8, ptr %t4853, i64 120
store ptr %t4900, ptr %t4902
%t4903 = call ptr @resid_list_new(i64 16, ptr %t4853, ptr @.lty4853)
ret ptr %t4903
}
define ptr @sha512_rounds_flat(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4906, %tco.s0.k ]
%t4904 = icmp sge i64 %p2, 80
br i1 %t4904, label %L607, label %L609
L607:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p0
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L609:
%t4905 = call ptr @sha512_round_flat(ptr %p0, ptr %p1, i64 %p2)
%t4906 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4905, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4905, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
br label %tco.head
}
define ptr @add_st_word(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4908 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 2)
%t4909 = extractvalue {i64, i1} %t4908, 0
%t4910 = extractvalue {i64, i1} %t4908, 1
%t4911 = zext i1 %t4910 to i8
call void @resid_overflow_check(i8 %t4911)
%t4912 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4909, i64 1)
%t4913 = extractvalue {i64, i1} %t4912, 0
%t4914 = extractvalue {i64, i1} %t4912, 1
%t4915 = zext i1 %t4914 to i8
call void @resid_overflow_check(i8 %t4915)
%t4916 = call ptr @resid_list_get(ptr %p0, i64 %t4909)
%t4917 = call i64 @resid_unbox_i64(ptr %t4916)
%t4919 = call ptr @resid_list_get(ptr %p0, i64 %t4913)
%t4920 = call i64 @resid_unbox_i64(ptr %t4919)
%t4922 = call ptr @w64(i64 %t4917, i64 %t4920)
%t4923 = call ptr @resid_list_get(ptr %p1, i64 %t4909)
%t4924 = call i64 @resid_unbox_i64(ptr %t4923)
%t4926 = call ptr @resid_list_get(ptr %p1, i64 %t4913)
%t4927 = call i64 @resid_unbox_i64(ptr %t4926)
%t4929 = call ptr @w64(i64 %t4924, i64 %t4927)
%t4930 = call ptr @w64_add(ptr %t4922, ptr %t4929)
ret ptr %t4930
}
define ptr @add_st_acc(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4932, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t4931 = icmp sge i64 %p2, 8
br i1 %t4931, label %L610, label %L612
L610:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L612:
%t4932 = add nsw i64 %p2, 1
%t4933 = call ptr @add_st_word(ptr %p0, ptr %p1, i64 %p2)
%t4934 = call ptr @resid_list_freeze(ptr %t4933)
%t4935 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t4934)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t4935, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t4935, %tco.s0 ]
br label %tco.head
}
define ptr @add_st(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4938 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4937)
%t4939 = call ptr @add_st_acc(ptr %p0, ptr %p1, i64 %p2, ptr %t4938)
ret ptr %t4939
}
define ptr @digest_block512f(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4940 = call ptr @msg_words512(ptr %p0, i64 %p1)
%t4941 = call ptr @ext512_flat(ptr %t4940, i64 16, i64 80)
%t4942 = call ptr @sha512_rounds_flat__rs337(ptr %p2, ptr %t4941, i64 0)
%t4943 = call ptr @add_st(ptr %p2, ptr %t4942, i64 0)
ret ptr %t4943
}
define ptr @digest_blocks512f(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4947, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t4944 = icmp sge i64 %p1, %p2
br i1 %t4944, label %L613, label %L615
L613:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L615:
%t4945 = call ptr @digest_block512f(ptr %p0, i64 %p1, ptr %p3)
%t4946 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 128)
%t4947 = extractvalue {i64, i1} %t4946, 0
%t4948 = extractvalue {i64, i1} %t4946, 1
%t4949 = zext i1 %t4948 to i8
call void @resid_overflow_check(i8 %t4949)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t4945, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t4945, %tco.s0 ]
br label %tco.head
}
define ptr @hex_range_b(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4955, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t4953, %tco.s0 ]
%t4951 = icmp sgt i64 %p1, %p2
br i1 %t4951, label %L616, label %L618
L616:
ret ptr %p3
L618:
%t4952 = call ptr @hex_byte_at(ptr %p0, i64 %p1)
%t4953 = call ptr @resid_str_concat(ptr %p3, ptr %t4952)
%t4954 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t4955 = extractvalue {i64, i1} %t4954, 0
%t4956 = extractvalue {i64, i1} %t4954, 1
%t4957 = zext i1 %t4956 to i8
call void @resid_overflow_check(i8 %t4957)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @r64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4959 = add i64 %p1, 0
%t4960 = add i64 %t4959, 0
%t4961 = add i64 %t4960, 0
%t4962 = icmp ne i64 %t4961, %t4959
%t4963 = icmp slt i64 %p1, 0
%t4964 = or i1 %t4962, %t4963
%t4965 = zext i1 %t4964 to i8
call void @resid_conv_check(i8 %t4965)
%t4966 = icmp uge i64 %t4960, 64
%t4967 = add i64 %t4960, 0
%t4968 = lshr i64 %p0, %t4967
%t4969 = select i1 %t4966, i64 0, i64 %t4968
%t4970 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 64, i64 %p1)
%t4971 = extractvalue {i64, i1} %t4970, 0
%t4972 = extractvalue {i64, i1} %t4970, 1
%t4973 = zext i1 %t4972 to i8
call void @resid_overflow_check(i8 %t4973)
%t4974 = add i64 %t4971, 0
%t4975 = add i64 %t4974, 0
%t4976 = add i64 %t4975, 0
%t4977 = icmp ne i64 %t4976, %t4974
%t4978 = icmp slt i64 %t4971, 0
%t4979 = or i1 %t4977, %t4978
%t4980 = zext i1 %t4979 to i8
call void @resid_conv_check(i8 %t4980)
%t4981 = icmp uge i64 %t4975, 64
%t4982 = add i64 %t4975, 0
%t4983 = shl i64 %p0, %t4982
%t4984 = select i1 %t4981, i64 0, i64 %t4983
%t4985 = or i64 %t4969, %t4984
ret i64 %t4985
}
define i64 @bs0_64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4986 = call i64 @r64(i64 %p0, i64 28)
%t4987 = call i64 @r64(i64 %p0, i64 34)
%t4988 = xor i64 %t4986, %t4987
%t4989 = call i64 @r64(i64 %p0, i64 39)
%t4990 = xor i64 %t4988, %t4989
ret i64 %t4990
}
define i64 @bs1_64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4991 = call i64 @r64(i64 %p0, i64 14)
%t4992 = call i64 @r64(i64 %p0, i64 18)
%t4993 = xor i64 %t4991, %t4992
%t4994 = call i64 @r64(i64 %p0, i64 41)
%t4995 = xor i64 %t4993, %t4994
ret i64 %t4995
}
define i64 @ss0_64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4996 = call i64 @r64(i64 %p0, i64 1)
%t4997 = call i64 @r64(i64 %p0, i64 8)
%t4998 = xor i64 %t4996, %t4997
%t4999 = lshr i64 %p0, 7
%t5000 = xor i64 %t4998, %t4999
ret i64 %t5000
}
define i64 @ss1_64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5001 = call i64 @r64(i64 %p0, i64 19)
%t5002 = call i64 @r64(i64 %p0, i64 61)
%t5003 = xor i64 %t5001, %t5002
%t5004 = lshr i64 %p0, 6
%t5005 = xor i64 %t5003, %t5004
ret i64 %t5005
}
define i64 @k512_u(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5006 = call ptr @k512_limb_at(i64 %p0)
%t5007 = call ptr @resid_list_get(ptr %t5006, i64 0)
%t5008 = call i64 @resid_unbox_i64(ptr %t5007)
%t5010 = add i64 %t5008, 0
%t5011 = add i64 %t5010, 0
%t5012 = add i64 %t5011, 0
%t5013 = icmp ne i64 %t5012, %t5010
%t5014 = icmp slt i64 %t5008, 0
%t5015 = or i1 %t5013, %t5014
%t5016 = zext i1 %t5015 to i8
call void @resid_conv_check(i8 %t5016)
%t5017 = shl i64 %t5011, 32
%t5018 = call ptr @resid_list_get(ptr %t5006, i64 1)
%t5019 = call i64 @resid_unbox_i64(ptr %t5018)
%t5021 = add i64 %t5019, 0
%t5022 = add i64 %t5021, 0
%t5023 = add i64 %t5022, 0
%t5024 = icmp ne i64 %t5023, %t5021
%t5025 = icmp slt i64 %t5019, 0
%t5026 = or i1 %t5024, %t5025
%t5027 = zext i1 %t5026 to i8
call void @resid_conv_check(i8 %t5027)
%t5028 = or i64 %t5017, %t5022
ret i64 %t5028
}
define i64 @word64_at(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5029 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t5030 = extractvalue {i64, i1} %t5029, 0
%t5031 = extractvalue {i64, i1} %t5029, 1
%t5032 = zext i1 %t5031 to i8
call void @resid_overflow_check(i8 %t5032)
%t5033 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t5030)
%t5034 = extractvalue {i64, i1} %t5033, 0
%t5035 = extractvalue {i64, i1} %t5033, 1
%t5036 = zext i1 %t5035 to i8
call void @resid_overflow_check(i8 %t5036)
%t5037 = call i64 @w64_bytes__rs351(ptr %p0, i64 %t5034, i64 0, i64 0)
ret i64 %t5037
}
define i64 @w64_bytes(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5039, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t5049, %tco.s0 ]
%t5038 = icmp sge i64 %p2, 8
br i1 %t5038, label %L619, label %L621
L619:
ret i64 %p3
L621:
%t5039 = add nsw i64 %p2, 1
%t5040 = shl i64 %p3, 8
%t5041 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p2)
%t5042 = extractvalue {i64, i1} %t5041, 0
%t5043 = extractvalue {i64, i1} %t5041, 1
%t5044 = zext i1 %t5043 to i8
call void @resid_overflow_check(i8 %t5044)
%t5045 = call ptr @resid_list_get_v(ptr %p0, i64 %t5042, ptr %p0.ld, i64 %p0.ln)
%t5046 = call i64 @resid_unbox_i64(ptr %t5045)
%t5048 = and i64 %t5046, 255
%t5049 = or i64 %t5040, %t5048
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @sched64(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5051 = icmp slt i64 %p2, 16
br i1 %t5051, label %L622, label %L624
L622:
%t5052 = call i64 @word64_at(ptr %p0, i64 %p1, i64 %p2)
ret i64 %t5052
L624:
%t5053 = call i64 @ss1_64(i64 %p6)
%t5054 = call i64 @wrapping_uadd(i64 %t5053, i64 %p5)
%t5055 = call i64 @ss0_64(i64 %p4)
%t5056 = call i64 @wrapping_uadd(i64 %t5055, i64 %p3)
%t5057 = call i64 @wrapping_uadd(i64 %t5054, i64 %t5056)
ret i64 %t5057
}
define ptr @sha512_blk(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in, i64 %p19.in, i64 %p20.in, i64 %p21.in, i64 %p22.in, i64 %p23.in, i64 %p24.in, i64 %p25.in, i64 %p26.in, i64 %p27.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5103, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t5104, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t5105, %tco.s0.k ]
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
%p27 = phi i64 [ %p27.in, %entry ], [ %t5084, %tco.s0.k ]
%t5058 = icmp sge i64 %p2, 80
br i1 %t5058, label %L625, label %L627
L625:
%t5059 = call ptr @resid_gmalloc(i64 64)
%t5060 = getelementptr i8, ptr %p3, i64 0
%t5061 = load i64, ptr %t5060, align 8
%t5062 = call i64 @wrapping_uadd(i64 %t5061, i64 %p4)
%t5059.f0 = getelementptr i8, ptr %t5059, i64 0
store i64 %t5062, ptr %t5059.f0, align 8
%t5063 = getelementptr i8, ptr %p3, i64 8
%t5064 = load i64, ptr %t5063, align 8
%t5065 = call i64 @wrapping_uadd(i64 %t5064, i64 %p5)
%t5059.f1 = getelementptr i8, ptr %t5059, i64 8
store i64 %t5065, ptr %t5059.f1, align 8
%t5066 = getelementptr i8, ptr %p3, i64 16
%t5067 = load i64, ptr %t5066, align 8
%t5068 = call i64 @wrapping_uadd(i64 %t5067, i64 %p6)
%t5059.f2 = getelementptr i8, ptr %t5059, i64 16
store i64 %t5068, ptr %t5059.f2, align 8
%t5069 = getelementptr i8, ptr %p3, i64 24
%t5070 = load i64, ptr %t5069, align 8
%t5071 = call i64 @wrapping_uadd(i64 %t5070, i64 %p7)
%t5059.f3 = getelementptr i8, ptr %t5059, i64 24
store i64 %t5071, ptr %t5059.f3, align 8
%t5072 = getelementptr i8, ptr %p3, i64 32
%t5073 = load i64, ptr %t5072, align 8
%t5074 = call i64 @wrapping_uadd(i64 %t5073, i64 %p8)
%t5059.f4 = getelementptr i8, ptr %t5059, i64 32
store i64 %t5074, ptr %t5059.f4, align 8
%t5075 = getelementptr i8, ptr %p3, i64 40
%t5076 = load i64, ptr %t5075, align 8
%t5077 = call i64 @wrapping_uadd(i64 %t5076, i64 %p9)
%t5059.f5 = getelementptr i8, ptr %t5059, i64 40
store i64 %t5077, ptr %t5059.f5, align 8
%t5078 = getelementptr i8, ptr %p3, i64 48
%t5079 = load i64, ptr %t5078, align 8
%t5080 = call i64 @wrapping_uadd(i64 %t5079, i64 %p10)
%t5059.f6 = getelementptr i8, ptr %t5059, i64 48
store i64 %t5080, ptr %t5059.f6, align 8
%t5081 = getelementptr i8, ptr %p3, i64 56
%t5082 = load i64, ptr %t5081, align 8
%t5083 = call i64 @wrapping_uadd(i64 %t5082, i64 %p11)
%t5059.f7 = getelementptr i8, ptr %t5059, i64 56
store i64 %t5083, ptr %t5059.f7, align 8
%lr.cx76 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz76 = icmp eq ptr %lr.cx76, null
br i1 %lr.lz76, label %lr.x76.k, label %lr.x76.m
lr.x76.k:
ret ptr %t5059
lr.x76.m:
%lr.ret76 = call ptr @"resid.rec.evac.W512"(ptr %t5059, ptr %lr.cx76)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret76
L627:
%t5084 = call i64 @sched64(ptr %p0, i64 %p1, i64 %p2, i64 %p12, i64 %p13, i64 %p21, i64 %p26)
%t5085 = and i64 %p8, %p9
%t5086 = xor i64 %p8, -1
%t5087 = and i64 %t5086, %p10
%t5088 = xor i64 %t5085, %t5087
%t5089 = call i64 @resid_scope_push()
%t5090 = call i64 @bs1_64(i64 %p8)
%t5091 = call i64 @wrapping_uadd(i64 %p11, i64 %t5090)
%t5092 = call i64 @k512_u(i64 %p2)
%t5093 = call i64 @wrapping_uadd(i64 %t5088, i64 %t5092)
%t5094 = call i64 @wrapping_uadd(i64 %t5091, i64 %t5093)
%t5095 = call i64 @wrapping_uadd(i64 %t5094, i64 %t5084)
call void @resid_scope_pop(i64 %t5089)
%t5096 = call i64 @bs0_64(i64 %p4)
%t5097 = and i64 %p4, %p5
%t5098 = and i64 %p4, %p6
%t5099 = xor i64 %t5097, %t5098
%t5100 = and i64 %p5, %p6
%t5101 = xor i64 %t5099, %t5100
%t5102 = call i64 @wrapping_uadd(i64 %t5096, i64 %t5101)
%t5103 = add nsw i64 %p2, 1
%t5104 = call i64 @wrapping_uadd(i64 %t5095, i64 %t5102)
%t5105 = call i64 @wrapping_uadd(i64 %p7, i64 %t5095)
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t5113, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t5107 = icmp sge i64 %p1, %p2
br i1 %t5107, label %L628, label %L630
L628:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @"resid.rec.evac.W512"(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L630:
%t5108 = call i8 @resid_cpu_has_sha512()
%t5109 = icmp ne i8 %t5108, 0
br i1 %t5109, label %L631, label %L633
L631:
%t5110 = call i512 @sha512_hw_state(ptr %p3)
%t5111 = call ptr @sha512_hw_blocks(ptr %p0, i64 %p1, i64 %p2, i512 %t5110)
%lr.cx19 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz19 = icmp eq ptr %lr.cx19, null
br i1 %lr.lz19, label %lr.x19.k, label %lr.x19.m
lr.x19.k:
ret ptr %t5111
lr.x19.m:
%lr.ret19 = call ptr @"resid.rec.evac.W512"(ptr %t5111, ptr %lr.cx19)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret19
L633:
%t5112 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 128)
%t5113 = extractvalue {i64, i1} %t5112, 0
%t5114 = extractvalue {i64, i1} %t5112, 1
%t5115 = zext i1 %t5114 to i8
call void @resid_overflow_check(i8 %t5115)
%t5116 = getelementptr i8, ptr %p3, i64 0
%t5117 = load i64, ptr %t5116, align 8
%t5118 = getelementptr i8, ptr %p3, i64 8
%t5119 = load i64, ptr %t5118, align 8
%t5120 = getelementptr i8, ptr %p3, i64 16
%t5121 = load i64, ptr %t5120, align 8
%t5122 = getelementptr i8, ptr %p3, i64 24
%t5123 = load i64, ptr %t5122, align 8
%t5124 = getelementptr i8, ptr %p3, i64 32
%t5125 = load i64, ptr %t5124, align 8
%t5126 = getelementptr i8, ptr %p3, i64 40
%t5127 = load i64, ptr %t5126, align 8
%t5128 = getelementptr i8, ptr %p3, i64 48
%t5129 = load i64, ptr %t5128, align 8
%t5130 = getelementptr i8, ptr %p3, i64 56
%t5131 = load i64, ptr %t5130, align 8
%t5132 = call ptr @sha512_blk(ptr %p0, i64 %p1, i64 0, ptr %p3, i64 %t5117, i64 %t5119, i64 %t5121, i64 %t5123, i64 %t5125, i64 %t5127, i64 %t5129, i64 %t5131, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @"resid.rec.evac.W512"(ptr %t5132, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t5132, %tco.s0 ]
br label %tco.head
}
define i512 @sha512_hw_state(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5134 = getelementptr i8, ptr %p0, i64 0
%t5135 = load i64, ptr %t5134, align 8
%t5136 = zext i64 %t5135 to i512
%t5137 = getelementptr i8, ptr %p0, i64 8
%t5138 = load i64, ptr %t5137, align 8
%t5139 = zext i64 %t5138 to i512
%t5140 = shl i512 %t5139, 64
%t5141 = or i512 %t5136, %t5140
%t5142 = getelementptr i8, ptr %p0, i64 16
%t5143 = load i64, ptr %t5142, align 8
%t5144 = zext i64 %t5143 to i512
%t5145 = shl i512 %t5144, 128
%t5146 = or i512 %t5141, %t5145
%t5147 = getelementptr i8, ptr %p0, i64 24
%t5148 = load i64, ptr %t5147, align 8
%t5149 = zext i64 %t5148 to i512
%t5150 = shl i512 %t5149, 192
%t5151 = or i512 %t5146, %t5150
%t5152 = getelementptr i8, ptr %p0, i64 32
%t5153 = load i64, ptr %t5152, align 8
%t5154 = zext i64 %t5153 to i512
%t5155 = shl i512 %t5154, 256
%t5156 = or i512 %t5151, %t5155
%t5157 = getelementptr i8, ptr %p0, i64 40
%t5158 = load i64, ptr %t5157, align 8
%t5159 = zext i64 %t5158 to i512
%t5160 = shl i512 %t5159, 320
%t5161 = or i512 %t5156, %t5160
%t5162 = getelementptr i8, ptr %p0, i64 48
%t5163 = load i64, ptr %t5162, align 8
%t5164 = zext i64 %t5163 to i512
%t5165 = shl i512 %t5164, 384
%t5166 = or i512 %t5161, %t5165
%t5167 = getelementptr i8, ptr %p0, i64 56
%t5168 = load i64, ptr %t5167, align 8
%t5169 = zext i64 %t5168 to i512
%t5170 = shl i512 %t5169, 448
%t5171 = or i512 %t5166, %t5170
ret i512 %t5171
}
define i64 @sha512_hw_word(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5172 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 64, i64 %p1)
%t5173 = extractvalue {i64, i1} %t5172, 0
%t5174 = extractvalue {i64, i1} %t5172, 1
%t5175 = zext i1 %t5174 to i8
call void @resid_overflow_check(i8 %t5175)
%t5176 = sext i64 %t5173 to i512
%t5177 = add i512 %t5176, 0
%t5178 = add i512 %t5177, 0
%t5179 = icmp ne i512 %t5178, %t5176
%t5180 = icmp slt i64 %t5173, 0
%t5181 = or i1 %t5179, %t5180
%t5182 = zext i1 %t5181 to i8
call void @resid_conv_check(i8 %t5182)
%t5183 = icmp uge i512 %t5177, 512
%t5184 = add i512 %t5177, 0
%t5185 = lshr i512 %p0, %t5184
%t5186 = select i1 %t5183, i512 0, i512 %t5185
%t5187 = sext i128 18446744073709551615 to i512
%t5188 = add i512 %t5187, 0
%t5189 = add i512 %t5188, 0
%t5190 = icmp ne i512 %t5189, %t5187
%t5191 = icmp slt i128 18446744073709551615, 0
%t5192 = or i1 %t5190, %t5191
%t5193 = zext i1 %t5192 to i8
call void @resid_conv_check(i8 %t5193)
%t5194 = and i512 %t5186, %t5188
%t5195 = add i512 %t5194, 0
%t5196 = trunc i512 %t5195 to i64
%t5197 = zext i64 %t5196 to i512
%t5198 = icmp ne i512 %t5197, %t5195
%t5199 = icmp eq i8 0, 1
%t5200 = or i1 %t5198, %t5199
%t5201 = zext i1 %t5200 to i8
call void @resid_conv_check(i8 %t5201)
ret i64 %t5196
}
define i512 @sha512_hw_block(ptr %p0.in, i64 %p1.in, i64 %p2.in, i512 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5230, %tco.s0 ]
%p3 = phi i512 [ %p3.in, %entry ], [ %t5247, %tco.s0 ]
%t5202 = icmp sge i64 %p2, 8
br i1 %t5202, label %L634, label %L636
L634:
ret i512 %p3
L636:
%t5203 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p2)
%t5204 = extractvalue {i64, i1} %t5203, 0
%t5205 = extractvalue {i64, i1} %t5203, 1
%t5206 = zext i1 %t5205 to i8
call void @resid_overflow_check(i8 %t5206)
%t5207 = call i64 @word_at_list(ptr %p0, i64 %p1, i64 %t5204)
%t5208 = add i64 %t5207, 0
%t5209 = add i64 %t5208, 0
%t5210 = add i64 %t5209, 0
%t5211 = icmp ne i64 %t5210, %t5208
%t5212 = icmp slt i64 %t5207, 0
%t5213 = or i1 %t5211, %t5212
%t5214 = zext i1 %t5213 to i8
call void @resid_conv_check(i8 %t5214)
%t5215 = shl i64 %t5209, 32
%t5216 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p2)
%t5217 = extractvalue {i64, i1} %t5216, 0
%t5218 = extractvalue {i64, i1} %t5216, 1
%t5219 = zext i1 %t5218 to i8
call void @resid_overflow_check(i8 %t5219)
%t5220 = add nsw i64 %t5217, 1
%t5221 = call i64 @word_at_list(ptr %p0, i64 %p1, i64 %t5220)
%t5222 = add i64 %t5221, 0
%t5223 = add i64 %t5222, 0
%t5224 = add i64 %t5223, 0
%t5225 = icmp ne i64 %t5224, %t5222
%t5226 = icmp slt i64 %t5221, 0
%t5227 = or i1 %t5225, %t5226
%t5228 = zext i1 %t5227 to i8
call void @resid_conv_check(i8 %t5228)
%t5229 = or i64 %t5215, %t5223
%t5230 = add nsw i64 %p2, 1
%t5231 = zext i64 %t5229 to i512
%t5232 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 64, i64 %p2)
%t5233 = extractvalue {i64, i1} %t5232, 0
%t5234 = extractvalue {i64, i1} %t5232, 1
%t5235 = zext i1 %t5234 to i8
call void @resid_overflow_check(i8 %t5235)
%t5236 = sext i64 %t5233 to i512
%t5237 = add i512 %t5236, 0
%t5238 = add i512 %t5237, 0
%t5239 = icmp ne i512 %t5238, %t5236
%t5240 = icmp slt i64 %t5233, 0
%t5241 = or i1 %t5239, %t5240
%t5242 = zext i1 %t5241 to i8
call void @resid_conv_check(i8 %t5242)
%t5243 = icmp uge i512 %t5237, 512
%t5244 = add i512 %t5237, 0
%t5245 = shl i512 %t5231, %t5244
%t5246 = select i1 %t5243, i512 0, i512 %t5245
%t5247 = or i512 %p3, %t5246
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t5260, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi i512 [ %p3.in, %entry ], [ %t5269, %tco.s0.k ]
%t5249 = icmp sge i64 %p1, %p2
br i1 %t5249, label %L637, label %L639
L637:
%t5250 = call ptr @resid_gmalloc(i64 64)
%t5251 = call i64 @sha512_hw_word(i512 %p3, i64 0)
%t5250.f0 = getelementptr i8, ptr %t5250, i64 0
store i64 %t5251, ptr %t5250.f0, align 8
%t5252 = call i64 @sha512_hw_word(i512 %p3, i64 1)
%t5250.f1 = getelementptr i8, ptr %t5250, i64 8
store i64 %t5252, ptr %t5250.f1, align 8
%t5253 = call i64 @sha512_hw_word(i512 %p3, i64 2)
%t5250.f2 = getelementptr i8, ptr %t5250, i64 16
store i64 %t5253, ptr %t5250.f2, align 8
%t5254 = call i64 @sha512_hw_word(i512 %p3, i64 3)
%t5250.f3 = getelementptr i8, ptr %t5250, i64 24
store i64 %t5254, ptr %t5250.f3, align 8
%t5255 = call i64 @sha512_hw_word(i512 %p3, i64 4)
%t5250.f4 = getelementptr i8, ptr %t5250, i64 32
store i64 %t5255, ptr %t5250.f4, align 8
%t5256 = call i64 @sha512_hw_word(i512 %p3, i64 5)
%t5250.f5 = getelementptr i8, ptr %t5250, i64 40
store i64 %t5256, ptr %t5250.f5, align 8
%t5257 = call i64 @sha512_hw_word(i512 %p3, i64 6)
%t5250.f6 = getelementptr i8, ptr %t5250, i64 48
store i64 %t5257, ptr %t5250.f6, align 8
%t5258 = call i64 @sha512_hw_word(i512 %p3, i64 7)
%t5250.f7 = getelementptr i8, ptr %t5250, i64 56
store i64 %t5258, ptr %t5250.f7, align 8
%lr.cx36 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz36 = icmp eq ptr %lr.cx36, null
br i1 %lr.lz36, label %lr.x36.k, label %lr.x36.m
lr.x36.k:
ret ptr %t5250
lr.x36.m:
%lr.ret36 = call ptr @"resid.rec.evac.W512"(ptr %t5250, ptr %lr.cx36)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret36
L639:
%t5259 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 128)
%t5260 = extractvalue {i64, i1} %t5259, 0
%t5261 = extractvalue {i64, i1} %t5259, 1
%t5262 = zext i1 %t5261 to i8
call void @resid_overflow_check(i8 %t5262)
%t5263 = call i512 @sha512_hw_block(ptr %p0, i64 %p1, i64 0, i512 0)
%t5264 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t5265 = extractvalue {i64, i1} %t5264, 0
%t5266 = extractvalue {i64, i1} %t5264, 1
%t5267 = zext i1 %t5266 to i8
call void @resid_overflow_check(i8 %t5267)
%t5268 = call i512 @sha512_hw_block(ptr %p0, i64 %t5265, i64 0, i512 0)
%t5269 = call i512 @e.sha512(i512 %p3, i512 %t5263, i512 %t5268)
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
%t5271 = call ptr @resid_gmalloc(i64 64)
%t5272 = add i64 7640891576956012808, 0
%t5273 = add i64 %t5272, 0
%t5274 = add i64 %t5273, 0
%t5275 = icmp ne i64 %t5274, %t5272
%t5276 = icmp slt i64 7640891576956012808, 0
%t5277 = or i1 %t5275, %t5276
%t5278 = zext i1 %t5277 to i8
call void @resid_conv_check(i8 %t5278)
%t5271.f0 = getelementptr i8, ptr %t5271, i64 0
store i64 %t5273, ptr %t5271.f0, align 8
%t5279 = add i128 13503953896175478587, 0
%t5280 = trunc i128 %t5279 to i64
%t5281 = zext i64 %t5280 to i128
%t5282 = icmp ne i128 %t5281, %t5279
%t5283 = icmp slt i128 13503953896175478587, 0
%t5284 = or i1 %t5282, %t5283
%t5285 = zext i1 %t5284 to i8
call void @resid_conv_check(i8 %t5285)
%t5271.f1 = getelementptr i8, ptr %t5271, i64 8
store i64 %t5280, ptr %t5271.f1, align 8
%t5286 = add i64 4354685564936845355, 0
%t5287 = add i64 %t5286, 0
%t5288 = add i64 %t5287, 0
%t5289 = icmp ne i64 %t5288, %t5286
%t5290 = icmp slt i64 4354685564936845355, 0
%t5291 = or i1 %t5289, %t5290
%t5292 = zext i1 %t5291 to i8
call void @resid_conv_check(i8 %t5292)
%t5271.f2 = getelementptr i8, ptr %t5271, i64 16
store i64 %t5287, ptr %t5271.f2, align 8
%t5293 = add i128 11912009170470909681, 0
%t5294 = trunc i128 %t5293 to i64
%t5295 = zext i64 %t5294 to i128
%t5296 = icmp ne i128 %t5295, %t5293
%t5297 = icmp slt i128 11912009170470909681, 0
%t5298 = or i1 %t5296, %t5297
%t5299 = zext i1 %t5298 to i8
call void @resid_conv_check(i8 %t5299)
%t5271.f3 = getelementptr i8, ptr %t5271, i64 24
store i64 %t5294, ptr %t5271.f3, align 8
%t5300 = add i64 5840696475078001361, 0
%t5301 = add i64 %t5300, 0
%t5302 = add i64 %t5301, 0
%t5303 = icmp ne i64 %t5302, %t5300
%t5304 = icmp slt i64 5840696475078001361, 0
%t5305 = or i1 %t5303, %t5304
%t5306 = zext i1 %t5305 to i8
call void @resid_conv_check(i8 %t5306)
%t5271.f4 = getelementptr i8, ptr %t5271, i64 32
store i64 %t5301, ptr %t5271.f4, align 8
%t5307 = add i128 11170449401992604703, 0
%t5308 = trunc i128 %t5307 to i64
%t5309 = zext i64 %t5308 to i128
%t5310 = icmp ne i128 %t5309, %t5307
%t5311 = icmp slt i128 11170449401992604703, 0
%t5312 = or i1 %t5310, %t5311
%t5313 = zext i1 %t5312 to i8
call void @resid_conv_check(i8 %t5313)
%t5271.f5 = getelementptr i8, ptr %t5271, i64 40
store i64 %t5308, ptr %t5271.f5, align 8
%t5314 = add i64 2270897969802886507, 0
%t5315 = add i64 %t5314, 0
%t5316 = add i64 %t5315, 0
%t5317 = icmp ne i64 %t5316, %t5314
%t5318 = icmp slt i64 2270897969802886507, 0
%t5319 = or i1 %t5317, %t5318
%t5320 = zext i1 %t5319 to i8
call void @resid_conv_check(i8 %t5320)
%t5271.f6 = getelementptr i8, ptr %t5271, i64 48
store i64 %t5315, ptr %t5271.f6, align 8
%t5321 = add i64 6620516959819538809, 0
%t5322 = add i64 %t5321, 0
%t5323 = add i64 %t5322, 0
%t5324 = icmp ne i64 %t5323, %t5321
%t5325 = icmp slt i64 6620516959819538809, 0
%t5326 = or i1 %t5324, %t5325
%t5327 = zext i1 %t5326 to i8
call void @resid_conv_check(i8 %t5327)
%t5271.f7 = getelementptr i8, ptr %t5271, i64 56
store i64 %t5322, ptr %t5271.f7, align 8
ret ptr %t5271
}
define i64 @w64u(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5328 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p1)
%t5329 = extractvalue {i64, i1} %t5328, 0
%t5330 = extractvalue {i64, i1} %t5328, 1
%t5331 = zext i1 %t5330 to i8
call void @resid_overflow_check(i8 %t5331)
%t5332 = call ptr @resid_list_get(ptr %p0, i64 %t5329)
%t5333 = call i64 @resid_unbox_i64(ptr %t5332)
%t5335 = add i64 %t5333, 0
%t5336 = add i64 %t5335, 0
%t5337 = add i64 %t5336, 0
%t5338 = icmp ne i64 %t5337, %t5335
%t5339 = icmp slt i64 %t5333, 0
%t5340 = or i1 %t5338, %t5339
%t5341 = zext i1 %t5340 to i8
call void @resid_conv_check(i8 %t5341)
%t5342 = shl i64 %t5336, 32
%t5343 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p1)
%t5344 = extractvalue {i64, i1} %t5343, 0
%t5345 = extractvalue {i64, i1} %t5343, 1
%t5346 = zext i1 %t5345 to i8
call void @resid_overflow_check(i8 %t5346)
%t5347 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5344, i64 1)
%t5348 = extractvalue {i64, i1} %t5347, 0
%t5349 = extractvalue {i64, i1} %t5347, 1
%t5350 = zext i1 %t5349 to i8
call void @resid_overflow_check(i8 %t5350)
%t5351 = call ptr @resid_list_get(ptr %p0, i64 %t5348)
%t5352 = call i64 @resid_unbox_i64(ptr %t5351)
%t5354 = add i64 %t5352, 0
%t5355 = add i64 %t5354, 0
%t5356 = add i64 %t5355, 0
%t5357 = icmp ne i64 %t5356, %t5354
%t5358 = icmp slt i64 %t5352, 0
%t5359 = or i1 %t5357, %t5358
%t5360 = zext i1 %t5359 to i8
call void @resid_conv_check(i8 %t5360)
%t5361 = or i64 %t5342, %t5355
ret i64 %t5361
}
define ptr @be64_push(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5363, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t5387, %tco.s0 ]
%t5362 = icmp sge i64 %p1, 8
br i1 %t5362, label %L640, label %L642
L640:
ret ptr %p2
L642:
%t5363 = add nsw i64 %p1, 1
%t5364 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t5365 = extractvalue {i64, i1} %t5364, 0
%t5366 = extractvalue {i64, i1} %t5364, 1
%t5367 = zext i1 %t5366 to i8
call void @resid_overflow_check(i8 %t5367)
%t5368 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 56, i64 %t5365)
%t5369 = extractvalue {i64, i1} %t5368, 0
%t5370 = extractvalue {i64, i1} %t5368, 1
%t5371 = zext i1 %t5370 to i8
call void @resid_overflow_check(i8 %t5371)
%t5372 = add i64 %t5369, 0
%t5373 = add i64 %t5372, 0
%t5374 = add i64 %t5373, 0
%t5375 = icmp ne i64 %t5374, %t5372
%t5376 = icmp slt i64 %t5369, 0
%t5377 = or i1 %t5375, %t5376
%t5378 = zext i1 %t5377 to i8
call void @resid_conv_check(i8 %t5378)
%t5379 = icmp uge i64 %t5373, 64
%t5380 = add i64 %t5373, 0
%t5381 = lshr i64 %p0, %t5380
%t5382 = select i1 %t5379, i64 0, i64 %t5381
%t5383 = and i64 %t5382, 255
%t5384 = call ptr @resid_box_i64(i64 %t5383)
%t5387 = call ptr @resid_listbuf_push(ptr %p2, ptr %t5384)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @words64_bytes(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5389 = getelementptr i8, ptr %p0, i64 24
%t5390 = load i64, ptr %t5389, align 8
%t5391 = getelementptr i8, ptr %p0, i64 16
%t5392 = load i64, ptr %t5391, align 8
%t5393 = getelementptr i8, ptr %p0, i64 8
%t5394 = load i64, ptr %t5393, align 8
%t5395 = getelementptr i8, ptr %p0, i64 0
%t5396 = load i64, ptr %t5395, align 8
%t5397 = call ptr @be64_push__rs387(i64 %t5396, i64 0, ptr %p2)
%t5398 = call ptr @be64_push__rs387(i64 %t5394, i64 0, ptr %t5397)
%t5399 = call ptr @be64_push__rs387(i64 %t5392, i64 0, ptr %t5398)
%t5400 = call ptr @be64_push__rs387(i64 %t5390, i64 0, ptr %t5399)
%t5401 = getelementptr i8, ptr %p0, i64 56
%t5402 = load i64, ptr %t5401, align 8
%t5403 = getelementptr i8, ptr %p0, i64 48
%t5404 = load i64, ptr %t5403, align 8
%t5405 = getelementptr i8, ptr %p0, i64 40
%t5406 = load i64, ptr %t5405, align 8
%t5407 = getelementptr i8, ptr %p0, i64 32
%t5408 = load i64, ptr %t5407, align 8
%t5409 = call ptr @be64_push__rs387(i64 %t5408, i64 0, ptr %t5400)
%t5410 = call ptr @be64_push__rs387(i64 %t5406, i64 0, ptr %t5409)
%t5411 = call ptr @be64_push__rs387(i64 %t5404, i64 0, ptr %t5410)
%t5412 = call ptr @be64_push__rs387(i64 %t5402, i64 0, ptr %t5411)
%t5413 = call ptr @resid_listbuf_finish(ptr %t5412, ptr @.lty5413)
ret ptr %t5413
}
define ptr @sha512_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5414 = call i64 @resid_list_len(ptr %p0)
%t5415 = sdiv i64 %t5414, 128
%t5416 = mul nsw i64 %t5415, 128
%t5417 = call ptr @sha512_iv()
%t5418 = call ptr @sha512_blocks(ptr %p0, i64 0, i64 %t5416, ptr %t5417)
%t5419 = call i64 @resid_list_len(ptr %p0)
%t5420 = call ptr @resid_list_slice(ptr %p0, i64 %t5416, i64 %t5419)
%t5422 = call ptr @pad512_tail(ptr %t5420, i64 %t5414)
%t5423 = call i64 @resid_list_len(ptr %t5422)
%t5424 = call ptr @sha512_blocks(ptr %t5422, i64 0, i64 %t5423, ptr %t5418)
%t5425 = call ptr @resid_listbuf_new()
%t5426 = call ptr @words64_bytes(ptr %t5424, i64 0, ptr %t5425)
ret ptr %t5426
}
define ptr @pad512_tail(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5427 = call i64 @resid_list_len(ptr %p0)
%t5428 = add nsw i64 %t5427, 17
%t5429 = add nsw i64 %t5428, 127
%t5430 = sdiv i64 %t5429, 128
%t5432 = call ptr @resid_list_const_i64(ptr @.lc5431, i64 1, ptr @.lcd5431, ptr @.lty5431)
%t5433 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t5432)
%t5434 = mul nsw i64 %t5430, 128
%t5435 = sub nsw i64 %t5434, %t5427
%t5436 = sub nsw i64 %t5435, 17
%t5437 = call ptr @zeros_l(ptr %t5433, i64 %t5436)
%t5438 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t5439 = extractvalue {i64, i1} %t5438, 0
%t5440 = extractvalue {i64, i1} %t5438, 1
%t5441 = zext i1 %t5440 to i8
call void @resid_overflow_check(i8 %t5441)
%t5442 = call ptr @len512_bytes__rs273(ptr %t5437, i64 %t5439, i64 15)
ret ptr %t5442
}
define ptr @limb_bytes_acc(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5455 = alloca [1 x ptr]
%t5462 = alloca [1 x ptr]
%t5469 = alloca [1 x ptr]
%t5476 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5483, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t5443 = icmp sge i64 %p1, 16
br i1 %t5443, label %L643, label %L645
L643:
%lr.cx16 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz16 = icmp eq ptr %lr.cx16, null
br i1 %lr.lz16, label %lr.x16.k, label %lr.x16.m
lr.x16.k:
ret ptr %p2
lr.x16.m:
%lr.ret16 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx16)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret16
L645:
%t5444 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t5445 = call i64 @resid_unbox_i64(ptr %t5444)
%t5447 = and i64 %t5445, 4294967295
%t5448 = ashr i64 %t5447, 24
%t5449 = and i64 %t5448, 255
%t5450 = ashr i64 %t5447, 16
%t5451 = and i64 %t5450, 255
%t5452 = ashr i64 %t5447, 8
%t5453 = and i64 %t5452, 255
%t5454 = and i64 %t5447, 255
%t5457 = call ptr @resid_box_i64(i64 %t5449)
%t5459 = getelementptr i8, ptr %t5455, i64 0
store ptr %t5457, ptr %t5459
%t5460 = call ptr @resid_list_new(i64 1, ptr %t5455, ptr @.lty5455)
%t5461 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t5460)
%t5464 = call ptr @resid_box_i64(i64 %t5451)
%t5466 = getelementptr i8, ptr %t5462, i64 0
store ptr %t5464, ptr %t5466
%t5467 = call ptr @resid_list_new(i64 1, ptr %t5462, ptr @.lty5462)
%t5468 = call ptr @resid_list_concat_own(ptr %t5461, i8 1, ptr %t5467)
%t5471 = call ptr @resid_box_i64(i64 %t5453)
%t5473 = getelementptr i8, ptr %t5469, i64 0
store ptr %t5471, ptr %t5473
%t5474 = call ptr @resid_list_new(i64 1, ptr %t5469, ptr @.lty5469)
%t5475 = call ptr @resid_list_concat_own(ptr %t5468, i8 1, ptr %t5474)
%t5478 = call ptr @resid_box_i64(i64 %t5454)
%t5480 = getelementptr i8, ptr %t5476, i64 0
store ptr %t5478, ptr %t5480
%t5481 = call ptr @resid_list_new(i64 1, ptr %t5476, ptr @.lty5476)
%t5482 = call ptr @resid_list_concat_own(ptr %t5475, i8 1, ptr %t5481)
%t5483 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t5482, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t5482, %tco.s0 ]
br label %tco.head
}
define ptr @limbs_to_hex_bytes(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5486 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty5485)
%t5487 = call ptr @limb_bytes_acc(ptr %p0, i64 0, ptr %t5486)
ret ptr %t5487
}
define i64 @__m____________lib_crypto_resid__u32mask(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5488 = and i64 %p0, 4294967295
ret i64 %t5488
}
define i64 @__m____________lib_crypto_resid__sha1_rol(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5489 = icmp uge i64 %p1, 64
%t5490 = add i64 %p1, 0
%t5491 = shl i64 %p0, %t5490
%t5492 = select i1 %t5489, i64 0, i64 %t5491
%t5493 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5492)
%t5494 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %p0)
%t5495 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t5496 = extractvalue {i64, i1} %t5495, 0
%t5497 = extractvalue {i64, i1} %t5495, 1
%t5498 = zext i1 %t5497 to i8
call void @resid_overflow_check(i8 %t5498)
%t5499 = icmp uge i64 %t5496, 64
%t5500 = add i64 %t5496, 0
%t5501 = select i1 %t5499, i64 63, i64 %t5500
%t5502 = ashr i64 %t5494, %t5501
%t5503 = or i64 %t5493, %t5502
%t5504 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5503)
ret i64 %t5504
}
define i64 @__m____________lib_crypto_resid__sha1_word(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5505 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t5506 = extractvalue {i64, i1} %t5505, 0
%t5507 = extractvalue {i64, i1} %t5505, 1
%t5508 = zext i1 %t5507 to i8
call void @resid_overflow_check(i8 %t5508)
%t5509 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t5506)
%t5510 = extractvalue {i64, i1} %t5509, 0
%t5511 = extractvalue {i64, i1} %t5509, 1
%t5512 = zext i1 %t5511 to i8
call void @resid_overflow_check(i8 %t5512)
%t5513 = call ptr @resid_list_get(ptr %p0, i64 %t5510)
%t5514 = call i64 @resid_unbox_i64(ptr %t5513)
%t5516 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t5514, i64 256)
%t5517 = extractvalue {i64, i1} %t5516, 0
%t5518 = extractvalue {i64, i1} %t5516, 1
%t5519 = zext i1 %t5518 to i8
call void @resid_overflow_check(i8 %t5519)
%t5520 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5510, i64 1)
%t5521 = extractvalue {i64, i1} %t5520, 0
%t5522 = extractvalue {i64, i1} %t5520, 1
%t5523 = zext i1 %t5522 to i8
call void @resid_overflow_check(i8 %t5523)
%t5524 = call ptr @resid_list_get(ptr %p0, i64 %t5521)
%t5525 = call i64 @resid_unbox_i64(ptr %t5524)
%t5527 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5517, i64 %t5525)
%t5528 = extractvalue {i64, i1} %t5527, 0
%t5529 = extractvalue {i64, i1} %t5527, 1
%t5530 = zext i1 %t5529 to i8
call void @resid_overflow_check(i8 %t5530)
%t5531 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t5528, i64 256)
%t5532 = extractvalue {i64, i1} %t5531, 0
%t5533 = extractvalue {i64, i1} %t5531, 1
%t5534 = zext i1 %t5533 to i8
call void @resid_overflow_check(i8 %t5534)
%t5535 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5510, i64 2)
%t5536 = extractvalue {i64, i1} %t5535, 0
%t5537 = extractvalue {i64, i1} %t5535, 1
%t5538 = zext i1 %t5537 to i8
call void @resid_overflow_check(i8 %t5538)
%t5539 = call ptr @resid_list_get(ptr %p0, i64 %t5536)
%t5540 = call i64 @resid_unbox_i64(ptr %t5539)
%t5542 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5532, i64 %t5540)
%t5543 = extractvalue {i64, i1} %t5542, 0
%t5544 = extractvalue {i64, i1} %t5542, 1
%t5545 = zext i1 %t5544 to i8
call void @resid_overflow_check(i8 %t5545)
%t5546 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t5543, i64 256)
%t5547 = extractvalue {i64, i1} %t5546, 0
%t5548 = extractvalue {i64, i1} %t5546, 1
%t5549 = zext i1 %t5548 to i8
call void @resid_overflow_check(i8 %t5549)
%t5550 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5510, i64 3)
%t5551 = extractvalue {i64, i1} %t5550, 0
%t5552 = extractvalue {i64, i1} %t5550, 1
%t5553 = zext i1 %t5552 to i8
call void @resid_overflow_check(i8 %t5553)
%t5554 = call ptr @resid_list_get(ptr %p0, i64 %t5551)
%t5555 = call i64 @resid_unbox_i64(ptr %t5554)
%t5557 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5547, i64 %t5555)
%t5558 = extractvalue {i64, i1} %t5557, 0
%t5559 = extractvalue {i64, i1} %t5557, 1
%t5560 = zext i1 %t5559 to i8
call void @resid_overflow_check(i8 %t5560)
ret i64 %t5558
}
define ptr @__m____________lib_crypto_resid__sha1_words16(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5564 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5562, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t5561 = icmp sge i64 %p2, 16
br i1 %t5561, label %L646, label %L648
L646:
%lr.cx12 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz12 = icmp eq ptr %lr.cx12, null
br i1 %lr.lz12, label %lr.x12.k, label %lr.x12.m
lr.x12.k:
ret ptr %p3
lr.x12.m:
%lr.ret12 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx12)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret12
L648:
%t5562 = add nsw i64 %p2, 1
%t5563 = call i64 @__m____________lib_crypto_resid__sha1_word(ptr %p0, i64 %p1, i64 %p2)
%t5566 = call ptr @resid_box_i64(i64 %t5563)
%t5568 = getelementptr i8, ptr %t5564, i64 0
store ptr %t5566, ptr %t5568
%t5569 = call ptr @resid_list_new(i64 1, ptr %t5564, ptr @.lty5564)
%t5570 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t5569)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t5570, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t5570, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_crypto_resid__sha1_expand(i64 %p0.in, ptr %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5607 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t5605, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%t5572 = icmp sge i64 %p0, 80
br i1 %t5572, label %L649, label %L651
L649:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p1
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L651:
%t5573 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p0, i64 3)
%t5574 = extractvalue {i64, i1} %t5573, 0
%t5575 = extractvalue {i64, i1} %t5573, 1
%t5576 = zext i1 %t5575 to i8
call void @resid_overflow_check(i8 %t5576)
%t5577 = call ptr @resid_list_get(ptr %p1, i64 %t5574)
%t5578 = call i64 @resid_unbox_i64(ptr %t5577)
%t5580 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p0, i64 8)
%t5581 = extractvalue {i64, i1} %t5580, 0
%t5582 = extractvalue {i64, i1} %t5580, 1
%t5583 = zext i1 %t5582 to i8
call void @resid_overflow_check(i8 %t5583)
%t5584 = call ptr @resid_list_get(ptr %p1, i64 %t5581)
%t5585 = call i64 @resid_unbox_i64(ptr %t5584)
%t5587 = xor i64 %t5578, %t5585
%t5588 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p0, i64 14)
%t5589 = extractvalue {i64, i1} %t5588, 0
%t5590 = extractvalue {i64, i1} %t5588, 1
%t5591 = zext i1 %t5590 to i8
call void @resid_overflow_check(i8 %t5591)
%t5592 = call ptr @resid_list_get(ptr %p1, i64 %t5589)
%t5593 = call i64 @resid_unbox_i64(ptr %t5592)
%t5595 = xor i64 %t5587, %t5593
%t5596 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p0, i64 16)
%t5597 = extractvalue {i64, i1} %t5596, 0
%t5598 = extractvalue {i64, i1} %t5596, 1
%t5599 = zext i1 %t5598 to i8
call void @resid_overflow_check(i8 %t5599)
%t5600 = call ptr @resid_list_get(ptr %p1, i64 %t5597)
%t5601 = call i64 @resid_unbox_i64(ptr %t5600)
%t5603 = xor i64 %t5595, %t5601
%t5604 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5603)
%t5605 = add nsw i64 %p0, 1
%t5606 = call i64 @__m____________lib_crypto_resid__sha1_rol(i64 %t5604, i64 1)
%t5609 = call ptr @resid_box_i64(i64 %t5606)
%t5611 = getelementptr i8, ptr %t5607, i64 0
store ptr %t5609, ptr %t5611
%t5612 = call ptr @resid_list_new(i64 1, ptr %t5607, ptr @.lty5607)
%t5613 = call ptr @resid_list_concat_own(ptr %p1, i8 1, ptr %t5612)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %t5613, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %t5613, %tco.s0 ]
br label %tco.head
}
define i64 @__m____________lib_crypto_resid__sha1_f(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5615 = icmp slt i64 %p0, 20
%t5616 = icmp sge i64 %p0, 20
br label %LSL5617
LSL5617:
br i1 %t5616, label %LSR5617, label %LSJ5617
LSR5617:
%t5618 = icmp slt i64 %p0, 40
br label %LSJ5617
LSJ5617:
%t5619 = phi i1 [ false, %LSL5617 ], [ %t5618, %LSR5617 ]
%t5620 = icmp sge i64 %p0, 40
br label %LSL5621
LSL5621:
br i1 %t5620, label %LSR5621, label %LSJ5621
LSR5621:
%t5622 = icmp slt i64 %p0, 60
br label %LSJ5621
LSJ5621:
%t5623 = phi i1 [ false, %LSL5621 ], [ %t5622, %LSR5621 ]
br i1 %t5615, label %L652, label %L654
L652:
%t5624 = and i64 %p1, %p2
%t5625 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 4294967295, i64 %p1)
%t5626 = extractvalue {i64, i1} %t5625, 0
%t5627 = extractvalue {i64, i1} %t5625, 1
%t5628 = zext i1 %t5627 to i8
call void @resid_overflow_check(i8 %t5628)
%t5629 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5626)
%t5630 = and i64 %t5629, %p3
%t5631 = or i64 %t5624, %t5630
%t5632 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5631)
ret i64 %t5632
L654:
br i1 %t5619, label %L655, label %L657
L655:
%t5633 = xor i64 %p1, %p2
%t5634 = xor i64 %t5633, %p3
%t5635 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5634)
ret i64 %t5635
L657:
br i1 %t5623, label %L658, label %L660
L658:
%t5636 = and i64 %p1, %p2
%t5637 = and i64 %p1, %p3
%t5638 = or i64 %t5636, %t5637
%t5639 = and i64 %p2, %p3
%t5640 = or i64 %t5638, %t5639
%t5641 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5640)
ret i64 %t5641
L660:
%t5642 = xor i64 %p1, %p2
%t5643 = xor i64 %t5642, %p3
%t5644 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5643)
ret i64 %t5644
}
define i64 @__m____________lib_crypto_resid__sha1_k(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5645 = icmp slt i64 %p0, 20
%t5646 = icmp sge i64 %p0, 20
br label %LSL5647
LSL5647:
br i1 %t5646, label %LSR5647, label %LSJ5647
LSR5647:
%t5648 = icmp slt i64 %p0, 40
br label %LSJ5647
LSJ5647:
%t5649 = phi i1 [ false, %LSL5647 ], [ %t5648, %LSR5647 ]
%t5650 = icmp sge i64 %p0, 40
br label %LSL5651
LSL5651:
br i1 %t5650, label %LSR5651, label %LSJ5651
LSR5651:
%t5652 = icmp slt i64 %p0, 60
br label %LSJ5651
LSJ5651:
%t5653 = phi i1 [ false, %LSL5651 ], [ %t5652, %LSR5651 ]
br i1 %t5645, label %L661, label %L663
L661:
ret i64 1518500249
L663:
br i1 %t5649, label %L664, label %L666
L664:
ret i64 1859775393
L666:
br i1 %t5653, label %L667, label %L669
L667:
ret i64 2400959708
L669:
ret i64 3395469782
}
define ptr @__m____________lib_crypto_resid__sha1_rounds(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5655 = alloca [5 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5697, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5695, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p2, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t5696, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%t5654 = icmp sge i64 %p1, 80
br i1 %t5654, label %L670, label %L672
L670:
%t5657 = call ptr @resid_box_i64(i64 %p2)
%t5659 = getelementptr i8, ptr %t5655, i64 0
store ptr %t5657, ptr %t5659
%t5660 = call ptr @resid_box_i64(i64 %p3)
%t5662 = getelementptr i8, ptr %t5655, i64 8
store ptr %t5660, ptr %t5662
%t5663 = call ptr @resid_box_i64(i64 %p4)
%t5665 = getelementptr i8, ptr %t5655, i64 16
store ptr %t5663, ptr %t5665
%t5666 = call ptr @resid_box_i64(i64 %p5)
%t5668 = getelementptr i8, ptr %t5655, i64 24
store ptr %t5666, ptr %t5668
%t5669 = call ptr @resid_box_i64(i64 %p6)
%t5671 = getelementptr i8, ptr %t5655, i64 32
store ptr %t5669, ptr %t5671
%t5672 = call ptr @resid_list_new(i64 5, ptr %t5655, ptr @.lty5655)
%lr.cx33 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz33 = icmp eq ptr %lr.cx33, null
br i1 %lr.lz33, label %lr.x33.k, label %lr.x33.m
lr.x33.k:
ret ptr %t5672
lr.x33.m:
%lr.ret33 = call ptr @resid_mv_list(ptr %t5672, ptr %lr.cx33)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret33
L672:
%t5673 = call i64 @__m____________lib_crypto_resid__sha1_rol(i64 %p2, i64 5)
%t5674 = call i64 @__m____________lib_crypto_resid__sha1_f(i64 %p1, i64 %p3, i64 %p4, i64 %p5)
%t5675 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5673, i64 %t5674)
%t5676 = extractvalue {i64, i1} %t5675, 0
%t5677 = extractvalue {i64, i1} %t5675, 1
%t5678 = zext i1 %t5677 to i8
call void @resid_overflow_check(i8 %t5678)
%t5679 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5676, i64 %p6)
%t5680 = extractvalue {i64, i1} %t5679, 0
%t5681 = extractvalue {i64, i1} %t5679, 1
%t5682 = zext i1 %t5681 to i8
call void @resid_overflow_check(i8 %t5682)
%t5683 = call i64 @__m____________lib_crypto_resid__sha1_k(i64 %p1)
%t5684 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5680, i64 %t5683)
%t5685 = extractvalue {i64, i1} %t5684, 0
%t5686 = extractvalue {i64, i1} %t5684, 1
%t5687 = zext i1 %t5686 to i8
call void @resid_overflow_check(i8 %t5687)
%t5688 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t5689 = call i64 @resid_unbox_i64(ptr %t5688)
%t5691 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5685, i64 %t5689)
%t5692 = extractvalue {i64, i1} %t5691, 0
%t5693 = extractvalue {i64, i1} %t5691, 1
%t5694 = zext i1 %t5693 to i8
call void @resid_overflow_check(i8 %t5694)
%t5695 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5692)
%t5696 = call i64 @__m____________lib_crypto_resid__sha1_rol(i64 %p3, i64 30)
%t5697 = add nsw i64 %p1, 1
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
%t5700 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty5699)
%t5701 = call ptr @__m____________lib_crypto_resid__sha1_words16(ptr %p0, i64 %p1, i64 0, ptr %t5700)
%t5702 = call ptr @__m____________lib_crypto_resid__sha1_expand(i64 16, ptr %t5701)
%t5703 = call ptr @resid_list_get(ptr %p2, i64 0)
%t5704 = call i64 @resid_unbox_i64(ptr %t5703)
%t5706 = call ptr @resid_list_get(ptr %p2, i64 1)
%t5707 = call i64 @resid_unbox_i64(ptr %t5706)
%t5709 = call ptr @resid_list_get(ptr %p2, i64 2)
%t5710 = call i64 @resid_unbox_i64(ptr %t5709)
%t5712 = call ptr @resid_list_get(ptr %p2, i64 3)
%t5713 = call i64 @resid_unbox_i64(ptr %t5712)
%t5715 = call ptr @resid_list_get(ptr %p2, i64 4)
%t5716 = call i64 @resid_unbox_i64(ptr %t5715)
%t5718 = call ptr @__m____________lib_crypto_resid__sha1_rounds(ptr %t5702, i64 0, i64 %t5704, i64 %t5707, i64 %t5710, i64 %t5713, i64 %t5716)
%t5719 = call ptr @resid_list_get(ptr %p2, i64 0)
%t5720 = call i64 @resid_unbox_i64(ptr %t5719)
%t5722 = call ptr @resid_list_get(ptr %t5718, i64 0)
%t5723 = call i64 @resid_unbox_i64(ptr %t5722)
%t5725 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5720, i64 %t5723)
%t5726 = extractvalue {i64, i1} %t5725, 0
%t5727 = extractvalue {i64, i1} %t5725, 1
%t5728 = zext i1 %t5727 to i8
call void @resid_overflow_check(i8 %t5728)
%t5729 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5726)
%t5730 = call ptr @resid_list_get(ptr %p2, i64 1)
%t5731 = call i64 @resid_unbox_i64(ptr %t5730)
%t5733 = call ptr @resid_list_get(ptr %t5718, i64 1)
%t5734 = call i64 @resid_unbox_i64(ptr %t5733)
%t5736 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5731, i64 %t5734)
%t5737 = extractvalue {i64, i1} %t5736, 0
%t5738 = extractvalue {i64, i1} %t5736, 1
%t5739 = zext i1 %t5738 to i8
call void @resid_overflow_check(i8 %t5739)
%t5740 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5737)
%t5741 = call ptr @resid_list_get(ptr %p2, i64 2)
%t5742 = call i64 @resid_unbox_i64(ptr %t5741)
%t5744 = call ptr @resid_list_get(ptr %t5718, i64 2)
%t5745 = call i64 @resid_unbox_i64(ptr %t5744)
%t5747 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5742, i64 %t5745)
%t5748 = extractvalue {i64, i1} %t5747, 0
%t5749 = extractvalue {i64, i1} %t5747, 1
%t5750 = zext i1 %t5749 to i8
call void @resid_overflow_check(i8 %t5750)
%t5751 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5748)
%t5752 = call ptr @resid_list_get(ptr %p2, i64 3)
%t5753 = call i64 @resid_unbox_i64(ptr %t5752)
%t5755 = call ptr @resid_list_get(ptr %t5718, i64 3)
%t5756 = call i64 @resid_unbox_i64(ptr %t5755)
%t5758 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5753, i64 %t5756)
%t5759 = extractvalue {i64, i1} %t5758, 0
%t5760 = extractvalue {i64, i1} %t5758, 1
%t5761 = zext i1 %t5760 to i8
call void @resid_overflow_check(i8 %t5761)
%t5762 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5759)
%t5763 = call ptr @resid_list_get(ptr %p2, i64 4)
%t5764 = call i64 @resid_unbox_i64(ptr %t5763)
%t5766 = call ptr @resid_list_get(ptr %t5718, i64 4)
%t5767 = call i64 @resid_unbox_i64(ptr %t5766)
%t5769 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5764, i64 %t5767)
%t5770 = extractvalue {i64, i1} %t5769, 0
%t5771 = extractvalue {i64, i1} %t5769, 1
%t5772 = zext i1 %t5771 to i8
call void @resid_overflow_check(i8 %t5772)
%t5773 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5770)
%t5774 = alloca [5 x ptr]
%t5776 = call ptr @resid_box_i64(i64 %t5729)
%t5778 = getelementptr i8, ptr %t5774, i64 0
store ptr %t5776, ptr %t5778
%t5779 = call ptr @resid_box_i64(i64 %t5740)
%t5781 = getelementptr i8, ptr %t5774, i64 8
store ptr %t5779, ptr %t5781
%t5782 = call ptr @resid_box_i64(i64 %t5751)
%t5784 = getelementptr i8, ptr %t5774, i64 16
store ptr %t5782, ptr %t5784
%t5785 = call ptr @resid_box_i64(i64 %t5762)
%t5787 = getelementptr i8, ptr %t5774, i64 24
store ptr %t5785, ptr %t5787
%t5788 = call ptr @resid_box_i64(i64 %t5773)
%t5790 = getelementptr i8, ptr %t5774, i64 32
store ptr %t5788, ptr %t5790
%t5791 = call ptr @resid_list_new(i64 5, ptr %t5774, ptr @.lty5774)
ret ptr %t5791
}
define ptr @__m____________lib_crypto_resid__sha1_blocks(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5794, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t5798, %tco.s0.k ]
%t5792 = icmp sge i64 %p4, %p2
br i1 %t5792, label %L673, label %L675
L673:
%lr.cx12 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz12 = icmp eq ptr %lr.cx12, null
br i1 %lr.lz12, label %lr.x12.k, label %lr.x12.m
lr.x12.k:
ret ptr %p3
lr.x12.m:
%lr.ret12 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx12)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret12
L675:
%t5793 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t5794 = extractvalue {i64, i1} %t5793, 0
%t5795 = extractvalue {i64, i1} %t5793, 1
%t5796 = zext i1 %t5795 to i8
call void @resid_overflow_check(i8 %t5796)
%t5797 = call ptr @__m____________lib_crypto_resid__sha1_step(ptr %p0, i64 %p1, ptr %p3)
%t5798 = add nsw i64 %p4, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t5797, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t5797, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_crypto_resid__sha1_be_bytes(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5814 = alloca [4 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5813, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t5800 = icmp sge i64 %p1, 5
br i1 %t5800, label %L676, label %L678
L676:
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %p2
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L678:
%t5801 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t5802 = call i64 @resid_unbox_i64(ptr %t5801)
%t5804 = ashr i64 %t5802, 24
%t5805 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5804)
%t5806 = ashr i64 %t5802, 16
%t5807 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5806)
%t5808 = and i64 %t5807, 255
%t5809 = ashr i64 %t5802, 8
%t5810 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5809)
%t5811 = and i64 %t5810, 255
%t5812 = and i64 %t5802, 255
%t5813 = add nsw i64 %p1, 1
%t5816 = call ptr @resid_box_i64(i64 %t5805)
%t5818 = getelementptr i8, ptr %t5814, i64 0
store ptr %t5816, ptr %t5818
%t5819 = call ptr @resid_box_i64(i64 %t5808)
%t5821 = getelementptr i8, ptr %t5814, i64 8
store ptr %t5819, ptr %t5821
%t5822 = call ptr @resid_box_i64(i64 %t5811)
%t5824 = getelementptr i8, ptr %t5814, i64 16
store ptr %t5822, ptr %t5824
%t5825 = call ptr @resid_box_i64(i64 %t5812)
%t5827 = getelementptr i8, ptr %t5814, i64 24
store ptr %t5825, ptr %t5827
%t5828 = call ptr @resid_list_new(i64 4, ptr %t5814, ptr @.lty5814)
%t5829 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t5828)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t5829, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t5829, %tco.s0 ]
br label %tco.head
}
define ptr @sha1_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5831 = call ptr @pad_bytes(ptr %p0)
%t5832 = call i64 @resid_list_len(ptr %t5831)
%t5833 = sdiv i64 %t5832, 64
%t5835 = call ptr @resid_list_const_i64(ptr @.lc5834, i64 5, ptr @.lcd5834, ptr @.lty5834)
%t5836 = call ptr @__m____________lib_crypto_resid__sha1_blocks(ptr %t5831, i64 0, i64 %t5833, ptr %t5835, i64 0)
%t5838 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty5837)
%t5839 = call ptr @__m____________lib_crypto_resid__sha1_be_bytes(ptr %t5836, i64 0, ptr %t5838)
ret ptr %t5839
}
define ptr @__m____________lib_sha512g_resid__sha512g_k() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5840 = add i64 4794697086780616226, 0
%t5841 = add i64 %t5840, 0
%t5842 = add i64 %t5841, 0
%t5843 = icmp ne i64 %t5842, %t5840
%t5844 = icmp slt i64 4794697086780616226, 0
%t5845 = or i1 %t5843, %t5844
%t5846 = zext i1 %t5845 to i8
call void @resid_conv_check(i8 %t5846)
%t5847 = add i64 8158064640168781261, 0
%t5848 = add i64 %t5847, 0
%t5849 = add i64 %t5848, 0
%t5850 = icmp ne i64 %t5849, %t5847
%t5851 = icmp slt i64 8158064640168781261, 0
%t5852 = or i1 %t5850, %t5851
%t5853 = zext i1 %t5852 to i8
call void @resid_conv_check(i8 %t5853)
%t5854 = add i128 13096744586834688815, 0
%t5855 = trunc i128 %t5854 to i64
%t5856 = zext i64 %t5855 to i128
%t5857 = icmp ne i128 %t5856, %t5854
%t5858 = icmp slt i128 13096744586834688815, 0
%t5859 = or i1 %t5857, %t5858
%t5860 = zext i1 %t5859 to i8
call void @resid_conv_check(i8 %t5860)
%t5861 = add i128 16840607885511220156, 0
%t5862 = trunc i128 %t5861 to i64
%t5863 = zext i64 %t5862 to i128
%t5864 = icmp ne i128 %t5863, %t5861
%t5865 = icmp slt i128 16840607885511220156, 0
%t5866 = or i1 %t5864, %t5865
%t5867 = zext i1 %t5866 to i8
call void @resid_conv_check(i8 %t5867)
%t5868 = add i64 4131703408338449720, 0
%t5869 = add i64 %t5868, 0
%t5870 = add i64 %t5869, 0
%t5871 = icmp ne i64 %t5870, %t5868
%t5872 = icmp slt i64 4131703408338449720, 0
%t5873 = or i1 %t5871, %t5872
%t5874 = zext i1 %t5873 to i8
call void @resid_conv_check(i8 %t5874)
%t5875 = add i64 6480981068601479193, 0
%t5876 = add i64 %t5875, 0
%t5877 = add i64 %t5876, 0
%t5878 = icmp ne i64 %t5877, %t5875
%t5879 = icmp slt i64 6480981068601479193, 0
%t5880 = or i1 %t5878, %t5879
%t5881 = zext i1 %t5880 to i8
call void @resid_conv_check(i8 %t5881)
%t5882 = add i128 10538285296894168987, 0
%t5883 = trunc i128 %t5882 to i64
%t5884 = zext i64 %t5883 to i128
%t5885 = icmp ne i128 %t5884, %t5882
%t5886 = icmp slt i128 10538285296894168987, 0
%t5887 = or i1 %t5885, %t5886
%t5888 = zext i1 %t5887 to i8
call void @resid_conv_check(i8 %t5888)
%t5889 = add i128 12329834152419229976, 0
%t5890 = trunc i128 %t5889 to i64
%t5891 = zext i64 %t5890 to i128
%t5892 = icmp ne i128 %t5891, %t5889
%t5893 = icmp slt i128 12329834152419229976, 0
%t5894 = or i1 %t5892, %t5893
%t5895 = zext i1 %t5894 to i8
call void @resid_conv_check(i8 %t5895)
%t5896 = add i128 15566598209576043074, 0
%t5897 = trunc i128 %t5896 to i64
%t5898 = zext i64 %t5897 to i128
%t5899 = icmp ne i128 %t5898, %t5896
%t5900 = icmp slt i128 15566598209576043074, 0
%t5901 = or i1 %t5899, %t5900
%t5902 = zext i1 %t5901 to i8
call void @resid_conv_check(i8 %t5902)
%t5903 = add i64 1334009975649890238, 0
%t5904 = add i64 %t5903, 0
%t5905 = add i64 %t5904, 0
%t5906 = icmp ne i64 %t5905, %t5903
%t5907 = icmp slt i64 1334009975649890238, 0
%t5908 = or i1 %t5906, %t5907
%t5909 = zext i1 %t5908 to i8
call void @resid_conv_check(i8 %t5909)
%t5910 = add i64 2608012711638119052, 0
%t5911 = add i64 %t5910, 0
%t5912 = add i64 %t5911, 0
%t5913 = icmp ne i64 %t5912, %t5910
%t5914 = icmp slt i64 2608012711638119052, 0
%t5915 = or i1 %t5913, %t5914
%t5916 = zext i1 %t5915 to i8
call void @resid_conv_check(i8 %t5916)
%t5917 = add i64 6128411473006802146, 0
%t5918 = add i64 %t5917, 0
%t5919 = add i64 %t5918, 0
%t5920 = icmp ne i64 %t5919, %t5917
%t5921 = icmp slt i64 6128411473006802146, 0
%t5922 = or i1 %t5920, %t5921
%t5923 = zext i1 %t5922 to i8
call void @resid_conv_check(i8 %t5923)
%t5924 = add i64 8268148722764581231, 0
%t5925 = add i64 %t5924, 0
%t5926 = add i64 %t5925, 0
%t5927 = icmp ne i64 %t5926, %t5924
%t5928 = icmp slt i64 8268148722764581231, 0
%t5929 = or i1 %t5927, %t5928
%t5930 = zext i1 %t5929 to i8
call void @resid_conv_check(i8 %t5930)
%t5931 = add i128 9286055187155687089, 0
%t5932 = trunc i128 %t5931 to i64
%t5933 = zext i64 %t5932 to i128
%t5934 = icmp ne i128 %t5933, %t5931
%t5935 = icmp slt i128 9286055187155687089, 0
%t5936 = or i1 %t5934, %t5935
%t5937 = zext i1 %t5936 to i8
call void @resid_conv_check(i8 %t5937)
%t5938 = add i128 11230858885718282805, 0
%t5939 = trunc i128 %t5938 to i64
%t5940 = zext i64 %t5939 to i128
%t5941 = icmp ne i128 %t5940, %t5938
%t5942 = icmp slt i128 11230858885718282805, 0
%t5943 = or i1 %t5941, %t5942
%t5944 = zext i1 %t5943 to i8
call void @resid_conv_check(i8 %t5944)
%t5945 = add i128 13951009754708518548, 0
%t5946 = trunc i128 %t5945 to i64
%t5947 = zext i64 %t5946 to i128
%t5948 = icmp ne i128 %t5947, %t5945
%t5949 = icmp slt i128 13951009754708518548, 0
%t5950 = or i1 %t5948, %t5949
%t5951 = zext i1 %t5950 to i8
call void @resid_conv_check(i8 %t5951)
%t5952 = add i128 16472876342353939154, 0
%t5953 = trunc i128 %t5952 to i64
%t5954 = zext i64 %t5953 to i128
%t5955 = icmp ne i128 %t5954, %t5952
%t5956 = icmp slt i128 16472876342353939154, 0
%t5957 = or i1 %t5955, %t5956
%t5958 = zext i1 %t5957 to i8
call void @resid_conv_check(i8 %t5958)
%t5959 = add i128 17275323862435702243, 0
%t5960 = trunc i128 %t5959 to i64
%t5961 = zext i64 %t5960 to i128
%t5962 = icmp ne i128 %t5961, %t5959
%t5963 = icmp slt i128 17275323862435702243, 0
%t5964 = or i1 %t5962, %t5963
%t5965 = zext i1 %t5964 to i8
call void @resid_conv_check(i8 %t5965)
%t5966 = add i64 1135362057144423861, 0
%t5967 = add i64 %t5966, 0
%t5968 = add i64 %t5967, 0
%t5969 = icmp ne i64 %t5968, %t5966
%t5970 = icmp slt i64 1135362057144423861, 0
%t5971 = or i1 %t5969, %t5970
%t5972 = zext i1 %t5971 to i8
call void @resid_conv_check(i8 %t5972)
%t5973 = add i64 2597628984639134821, 0
%t5974 = add i64 %t5973, 0
%t5975 = add i64 %t5974, 0
%t5976 = icmp ne i64 %t5975, %t5973
%t5977 = icmp slt i64 2597628984639134821, 0
%t5978 = or i1 %t5976, %t5977
%t5979 = zext i1 %t5978 to i8
call void @resid_conv_check(i8 %t5979)
%t5980 = add i64 3308224258029322869, 0
%t5981 = add i64 %t5980, 0
%t5982 = add i64 %t5981, 0
%t5983 = icmp ne i64 %t5982, %t5980
%t5984 = icmp slt i64 3308224258029322869, 0
%t5985 = or i1 %t5983, %t5984
%t5986 = zext i1 %t5985 to i8
call void @resid_conv_check(i8 %t5986)
%t5987 = add i64 5365058923640841347, 0
%t5988 = add i64 %t5987, 0
%t5989 = add i64 %t5988, 0
%t5990 = icmp ne i64 %t5989, %t5987
%t5991 = icmp slt i64 5365058923640841347, 0
%t5992 = or i1 %t5990, %t5991
%t5993 = zext i1 %t5992 to i8
call void @resid_conv_check(i8 %t5993)
%t5994 = add i64 6679025012923562964, 0
%t5995 = add i64 %t5994, 0
%t5996 = add i64 %t5995, 0
%t5997 = icmp ne i64 %t5996, %t5994
%t5998 = icmp slt i64 6679025012923562964, 0
%t5999 = or i1 %t5997, %t5998
%t6000 = zext i1 %t5999 to i8
call void @resid_conv_check(i8 %t6000)
%t6001 = add i64 8573033837759648693, 0
%t6002 = add i64 %t6001, 0
%t6003 = add i64 %t6002, 0
%t6004 = icmp ne i64 %t6003, %t6001
%t6005 = icmp slt i64 8573033837759648693, 0
%t6006 = or i1 %t6004, %t6005
%t6007 = zext i1 %t6006 to i8
call void @resid_conv_check(i8 %t6007)
%t6008 = add i128 10970295158949994411, 0
%t6009 = trunc i128 %t6008 to i64
%t6010 = zext i64 %t6009 to i128
%t6011 = icmp ne i128 %t6010, %t6008
%t6012 = icmp slt i128 10970295158949994411, 0
%t6013 = or i1 %t6011, %t6012
%t6014 = zext i1 %t6013 to i8
call void @resid_conv_check(i8 %t6014)
%t6015 = add i128 12119686244451234320, 0
%t6016 = trunc i128 %t6015 to i64
%t6017 = zext i64 %t6016 to i128
%t6018 = icmp ne i128 %t6017, %t6015
%t6019 = icmp slt i128 12119686244451234320, 0
%t6020 = or i1 %t6018, %t6019
%t6021 = zext i1 %t6020 to i8
call void @resid_conv_check(i8 %t6021)
%t6022 = add i128 12683024718118986047, 0
%t6023 = trunc i128 %t6022 to i64
%t6024 = zext i64 %t6023 to i128
%t6025 = icmp ne i128 %t6024, %t6022
%t6026 = icmp slt i128 12683024718118986047, 0
%t6027 = or i1 %t6025, %t6026
%t6028 = zext i1 %t6027 to i8
call void @resid_conv_check(i8 %t6028)
%t6029 = add i128 13788192230050041572, 0
%t6030 = trunc i128 %t6029 to i64
%t6031 = zext i64 %t6030 to i128
%t6032 = icmp ne i128 %t6031, %t6029
%t6033 = icmp slt i128 13788192230050041572, 0
%t6034 = or i1 %t6032, %t6033
%t6035 = zext i1 %t6034 to i8
call void @resid_conv_check(i8 %t6035)
%t6036 = add i128 14330467153632333762, 0
%t6037 = trunc i128 %t6036 to i64
%t6038 = zext i64 %t6037 to i128
%t6039 = icmp ne i128 %t6038, %t6036
%t6040 = icmp slt i128 14330467153632333762, 0
%t6041 = or i1 %t6039, %t6040
%t6042 = zext i1 %t6041 to i8
call void @resid_conv_check(i8 %t6042)
%t6043 = add i128 15395433587784984357, 0
%t6044 = trunc i128 %t6043 to i64
%t6045 = zext i64 %t6044 to i128
%t6046 = icmp ne i128 %t6045, %t6043
%t6047 = icmp slt i128 15395433587784984357, 0
%t6048 = or i1 %t6046, %t6047
%t6049 = zext i1 %t6048 to i8
call void @resid_conv_check(i8 %t6049)
%t6050 = add i64 1452737877330783856, 0
%t6051 = add i64 %t6050, 0
%t6052 = add i64 %t6051, 0
%t6053 = icmp ne i64 %t6052, %t6050
%t6054 = icmp slt i64 1452737877330783856, 0
%t6055 = or i1 %t6053, %t6054
%t6056 = zext i1 %t6055 to i8
call void @resid_conv_check(i8 %t6056)
%t6057 = add i64 2861767655752347644, 0
%t6058 = add i64 %t6057, 0
%t6059 = add i64 %t6058, 0
%t6060 = icmp ne i64 %t6059, %t6057
%t6061 = icmp slt i64 2861767655752347644, 0
%t6062 = or i1 %t6060, %t6061
%t6063 = zext i1 %t6062 to i8
call void @resid_conv_check(i8 %t6063)
%t6064 = add i64 3322285676063803686, 0
%t6065 = add i64 %t6064, 0
%t6066 = add i64 %t6065, 0
%t6067 = icmp ne i64 %t6066, %t6064
%t6068 = icmp slt i64 3322285676063803686, 0
%t6069 = or i1 %t6067, %t6068
%t6070 = zext i1 %t6069 to i8
call void @resid_conv_check(i8 %t6070)
%t6071 = add i64 5560940570517711597, 0
%t6072 = add i64 %t6071, 0
%t6073 = add i64 %t6072, 0
%t6074 = icmp ne i64 %t6073, %t6071
%t6075 = icmp slt i64 5560940570517711597, 0
%t6076 = or i1 %t6074, %t6075
%t6077 = zext i1 %t6076 to i8
call void @resid_conv_check(i8 %t6077)
%t6078 = add i64 5996557281743188959, 0
%t6079 = add i64 %t6078, 0
%t6080 = add i64 %t6079, 0
%t6081 = icmp ne i64 %t6080, %t6078
%t6082 = icmp slt i64 5996557281743188959, 0
%t6083 = or i1 %t6081, %t6082
%t6084 = zext i1 %t6083 to i8
call void @resid_conv_check(i8 %t6084)
%t6085 = add i64 7280758554555802590, 0
%t6086 = add i64 %t6085, 0
%t6087 = add i64 %t6086, 0
%t6088 = icmp ne i64 %t6087, %t6085
%t6089 = icmp slt i64 7280758554555802590, 0
%t6090 = or i1 %t6088, %t6089
%t6091 = zext i1 %t6090 to i8
call void @resid_conv_check(i8 %t6091)
%t6092 = add i64 8532644243296465576, 0
%t6093 = add i64 %t6092, 0
%t6094 = add i64 %t6093, 0
%t6095 = icmp ne i64 %t6094, %t6092
%t6096 = icmp slt i64 8532644243296465576, 0
%t6097 = or i1 %t6095, %t6096
%t6098 = zext i1 %t6097 to i8
call void @resid_conv_check(i8 %t6098)
%t6099 = add i128 9350256976987008742, 0
%t6100 = trunc i128 %t6099 to i64
%t6101 = zext i64 %t6100 to i128
%t6102 = icmp ne i128 %t6101, %t6099
%t6103 = icmp slt i128 9350256976987008742, 0
%t6104 = or i1 %t6102, %t6103
%t6105 = zext i1 %t6104 to i8
call void @resid_conv_check(i8 %t6105)
%t6106 = add i128 10552545826968843579, 0
%t6107 = trunc i128 %t6106 to i64
%t6108 = zext i64 %t6107 to i128
%t6109 = icmp ne i128 %t6108, %t6106
%t6110 = icmp slt i128 10552545826968843579, 0
%t6111 = or i1 %t6109, %t6110
%t6112 = zext i1 %t6111 to i8
call void @resid_conv_check(i8 %t6112)
%t6113 = add i128 11727347734174303076, 0
%t6114 = trunc i128 %t6113 to i64
%t6115 = zext i64 %t6114 to i128
%t6116 = icmp ne i128 %t6115, %t6113
%t6117 = icmp slt i128 11727347734174303076, 0
%t6118 = or i1 %t6116, %t6117
%t6119 = zext i1 %t6118 to i8
call void @resid_conv_check(i8 %t6119)
%t6120 = add i128 12113106623233404929, 0
%t6121 = trunc i128 %t6120 to i64
%t6122 = zext i64 %t6121 to i128
%t6123 = icmp ne i128 %t6122, %t6120
%t6124 = icmp slt i128 12113106623233404929, 0
%t6125 = or i1 %t6123, %t6124
%t6126 = zext i1 %t6125 to i8
call void @resid_conv_check(i8 %t6126)
%t6127 = add i128 14000437183269869457, 0
%t6128 = trunc i128 %t6127 to i64
%t6129 = zext i64 %t6128 to i128
%t6130 = icmp ne i128 %t6129, %t6127
%t6131 = icmp slt i128 14000437183269869457, 0
%t6132 = or i1 %t6130, %t6131
%t6133 = zext i1 %t6132 to i8
call void @resid_conv_check(i8 %t6133)
%t6134 = add i128 14369950271660146224, 0
%t6135 = trunc i128 %t6134 to i64
%t6136 = zext i64 %t6135 to i128
%t6137 = icmp ne i128 %t6136, %t6134
%t6138 = icmp slt i128 14369950271660146224, 0
%t6139 = or i1 %t6137, %t6138
%t6140 = zext i1 %t6139 to i8
call void @resid_conv_check(i8 %t6140)
%t6141 = add i128 15101387698204529176, 0
%t6142 = trunc i128 %t6141 to i64
%t6143 = zext i64 %t6142 to i128
%t6144 = icmp ne i128 %t6143, %t6141
%t6145 = icmp slt i128 15101387698204529176, 0
%t6146 = or i1 %t6144, %t6145
%t6147 = zext i1 %t6146 to i8
call void @resid_conv_check(i8 %t6147)
%t6148 = add i128 15463397548674623760, 0
%t6149 = trunc i128 %t6148 to i64
%t6150 = zext i64 %t6149 to i128
%t6151 = icmp ne i128 %t6150, %t6148
%t6152 = icmp slt i128 15463397548674623760, 0
%t6153 = or i1 %t6151, %t6152
%t6154 = zext i1 %t6153 to i8
call void @resid_conv_check(i8 %t6154)
%t6155 = add i128 17586052441742319658, 0
%t6156 = trunc i128 %t6155 to i64
%t6157 = zext i64 %t6156 to i128
%t6158 = icmp ne i128 %t6157, %t6155
%t6159 = icmp slt i128 17586052441742319658, 0
%t6160 = or i1 %t6158, %t6159
%t6161 = zext i1 %t6160 to i8
call void @resid_conv_check(i8 %t6161)
%t6162 = add i64 1182934255886127544, 0
%t6163 = add i64 %t6162, 0
%t6164 = add i64 %t6163, 0
%t6165 = icmp ne i64 %t6164, %t6162
%t6166 = icmp slt i64 1182934255886127544, 0
%t6167 = or i1 %t6165, %t6166
%t6168 = zext i1 %t6167 to i8
call void @resid_conv_check(i8 %t6168)
%t6169 = add i64 1847814050463011016, 0
%t6170 = add i64 %t6169, 0
%t6171 = add i64 %t6170, 0
%t6172 = icmp ne i64 %t6171, %t6169
%t6173 = icmp slt i64 1847814050463011016, 0
%t6174 = or i1 %t6172, %t6173
%t6175 = zext i1 %t6174 to i8
call void @resid_conv_check(i8 %t6175)
%t6176 = add i64 2177327727835720531, 0
%t6177 = add i64 %t6176, 0
%t6178 = add i64 %t6177, 0
%t6179 = icmp ne i64 %t6178, %t6176
%t6180 = icmp slt i64 2177327727835720531, 0
%t6181 = or i1 %t6179, %t6180
%t6182 = zext i1 %t6181 to i8
call void @resid_conv_check(i8 %t6182)
%t6183 = add i64 2830643537854262169, 0
%t6184 = add i64 %t6183, 0
%t6185 = add i64 %t6184, 0
%t6186 = icmp ne i64 %t6185, %t6183
%t6187 = icmp slt i64 2830643537854262169, 0
%t6188 = or i1 %t6186, %t6187
%t6189 = zext i1 %t6188 to i8
call void @resid_conv_check(i8 %t6189)
%t6190 = add i64 3796741975233480872, 0
%t6191 = add i64 %t6190, 0
%t6192 = add i64 %t6191, 0
%t6193 = icmp ne i64 %t6192, %t6190
%t6194 = icmp slt i64 3796741975233480872, 0
%t6195 = or i1 %t6193, %t6194
%t6196 = zext i1 %t6195 to i8
call void @resid_conv_check(i8 %t6196)
%t6197 = add i64 4115178125766777443, 0
%t6198 = add i64 %t6197, 0
%t6199 = add i64 %t6198, 0
%t6200 = icmp ne i64 %t6199, %t6197
%t6201 = icmp slt i64 4115178125766777443, 0
%t6202 = or i1 %t6200, %t6201
%t6203 = zext i1 %t6202 to i8
call void @resid_conv_check(i8 %t6203)
%t6204 = add i64 5681478168544905931, 0
%t6205 = add i64 %t6204, 0
%t6206 = add i64 %t6205, 0
%t6207 = icmp ne i64 %t6206, %t6204
%t6208 = icmp slt i64 5681478168544905931, 0
%t6209 = or i1 %t6207, %t6208
%t6210 = zext i1 %t6209 to i8
call void @resid_conv_check(i8 %t6210)
%t6211 = add i64 6601373596472566643, 0
%t6212 = add i64 %t6211, 0
%t6213 = add i64 %t6212, 0
%t6214 = icmp ne i64 %t6213, %t6211
%t6215 = icmp slt i64 6601373596472566643, 0
%t6216 = or i1 %t6214, %t6215
%t6217 = zext i1 %t6216 to i8
call void @resid_conv_check(i8 %t6217)
%t6218 = add i64 7507060721942968483, 0
%t6219 = add i64 %t6218, 0
%t6220 = add i64 %t6219, 0
%t6221 = icmp ne i64 %t6220, %t6218
%t6222 = icmp slt i64 7507060721942968483, 0
%t6223 = or i1 %t6221, %t6222
%t6224 = zext i1 %t6223 to i8
call void @resid_conv_check(i8 %t6224)
%t6225 = add i64 8399075790359081724, 0
%t6226 = add i64 %t6225, 0
%t6227 = add i64 %t6226, 0
%t6228 = icmp ne i64 %t6227, %t6225
%t6229 = icmp slt i64 8399075790359081724, 0
%t6230 = or i1 %t6228, %t6229
%t6231 = zext i1 %t6230 to i8
call void @resid_conv_check(i8 %t6231)
%t6232 = add i64 8693463985226723168, 0
%t6233 = add i64 %t6232, 0
%t6234 = add i64 %t6233, 0
%t6235 = icmp ne i64 %t6234, %t6232
%t6236 = icmp slt i64 8693463985226723168, 0
%t6237 = or i1 %t6235, %t6236
%t6238 = zext i1 %t6237 to i8
call void @resid_conv_check(i8 %t6238)
%t6239 = add i128 9568029438360202098, 0
%t6240 = trunc i128 %t6239 to i64
%t6241 = zext i64 %t6240 to i128
%t6242 = icmp ne i128 %t6241, %t6239
%t6243 = icmp slt i128 9568029438360202098, 0
%t6244 = or i1 %t6242, %t6243
%t6245 = zext i1 %t6244 to i8
call void @resid_conv_check(i8 %t6245)
%t6246 = add i128 10144078919501101548, 0
%t6247 = trunc i128 %t6246 to i64
%t6248 = zext i64 %t6247 to i128
%t6249 = icmp ne i128 %t6248, %t6246
%t6250 = icmp slt i128 10144078919501101548, 0
%t6251 = or i1 %t6249, %t6250
%t6252 = zext i1 %t6251 to i8
call void @resid_conv_check(i8 %t6252)
%t6253 = add i128 10430055236837252648, 0
%t6254 = trunc i128 %t6253 to i64
%t6255 = zext i64 %t6254 to i128
%t6256 = icmp ne i128 %t6255, %t6253
%t6257 = icmp slt i128 10430055236837252648, 0
%t6258 = or i1 %t6256, %t6257
%t6259 = zext i1 %t6258 to i8
call void @resid_conv_check(i8 %t6259)
%t6260 = add i128 11840083180663258601, 0
%t6261 = trunc i128 %t6260 to i64
%t6262 = zext i64 %t6261 to i128
%t6263 = icmp ne i128 %t6262, %t6260
%t6264 = icmp slt i128 11840083180663258601, 0
%t6265 = or i1 %t6263, %t6264
%t6266 = zext i1 %t6265 to i8
call void @resid_conv_check(i8 %t6266)
%t6267 = add i128 13761210420658862357, 0
%t6268 = trunc i128 %t6267 to i64
%t6269 = zext i64 %t6268 to i128
%t6270 = icmp ne i128 %t6269, %t6267
%t6271 = icmp slt i128 13761210420658862357, 0
%t6272 = or i1 %t6270, %t6271
%t6273 = zext i1 %t6272 to i8
call void @resid_conv_check(i8 %t6273)
%t6274 = add i128 14299343276471374635, 0
%t6275 = trunc i128 %t6274 to i64
%t6276 = zext i64 %t6275 to i128
%t6277 = icmp ne i128 %t6276, %t6274
%t6278 = icmp slt i128 14299343276471374635, 0
%t6279 = or i1 %t6277, %t6278
%t6280 = zext i1 %t6279 to i8
call void @resid_conv_check(i8 %t6280)
%t6281 = add i128 14566680578165727644, 0
%t6282 = trunc i128 %t6281 to i64
%t6283 = zext i64 %t6282 to i128
%t6284 = icmp ne i128 %t6283, %t6281
%t6285 = icmp slt i128 14566680578165727644, 0
%t6286 = or i1 %t6284, %t6285
%t6287 = zext i1 %t6286 to i8
call void @resid_conv_check(i8 %t6287)
%t6288 = add i128 15097957966210449927, 0
%t6289 = trunc i128 %t6288 to i64
%t6290 = zext i64 %t6289 to i128
%t6291 = icmp ne i128 %t6290, %t6288
%t6292 = icmp slt i128 15097957966210449927, 0
%t6293 = or i1 %t6291, %t6292
%t6294 = zext i1 %t6293 to i8
call void @resid_conv_check(i8 %t6294)
%t6295 = add i128 16922976911328602910, 0
%t6296 = trunc i128 %t6295 to i64
%t6297 = zext i64 %t6296 to i128
%t6298 = icmp ne i128 %t6297, %t6295
%t6299 = icmp slt i128 16922976911328602910, 0
%t6300 = or i1 %t6298, %t6299
%t6301 = zext i1 %t6300 to i8
call void @resid_conv_check(i8 %t6301)
%t6302 = add i128 17689382322260857208, 0
%t6303 = trunc i128 %t6302 to i64
%t6304 = zext i64 %t6303 to i128
%t6305 = icmp ne i128 %t6304, %t6302
%t6306 = icmp slt i128 17689382322260857208, 0
%t6307 = or i1 %t6305, %t6306
%t6308 = zext i1 %t6307 to i8
call void @resid_conv_check(i8 %t6308)
%t6309 = add i64 1242879168328830382, 0
%t6310 = add i64 %t6309, 0
%t6311 = add i64 %t6310, 0
%t6312 = icmp ne i64 %t6311, %t6309
%t6313 = icmp slt i64 1242879168328830382, 0
%t6314 = or i1 %t6312, %t6313
%t6315 = zext i1 %t6314 to i8
call void @resid_conv_check(i8 %t6315)
%t6316 = add i64 1977374033974150939, 0
%t6317 = add i64 %t6316, 0
%t6318 = add i64 %t6317, 0
%t6319 = icmp ne i64 %t6318, %t6316
%t6320 = icmp slt i64 1977374033974150939, 0
%t6321 = or i1 %t6319, %t6320
%t6322 = zext i1 %t6321 to i8
call void @resid_conv_check(i8 %t6322)
%t6323 = add i64 2944078676154940804, 0
%t6324 = add i64 %t6323, 0
%t6325 = add i64 %t6324, 0
%t6326 = icmp ne i64 %t6325, %t6323
%t6327 = icmp slt i64 2944078676154940804, 0
%t6328 = or i1 %t6326, %t6327
%t6329 = zext i1 %t6328 to i8
call void @resid_conv_check(i8 %t6329)
%t6330 = add i64 3659926193048069267, 0
%t6331 = add i64 %t6330, 0
%t6332 = add i64 %t6331, 0
%t6333 = icmp ne i64 %t6332, %t6330
%t6334 = icmp slt i64 3659926193048069267, 0
%t6335 = or i1 %t6333, %t6334
%t6336 = zext i1 %t6335 to i8
call void @resid_conv_check(i8 %t6336)
%t6337 = add i64 4368137639120453308, 0
%t6338 = add i64 %t6337, 0
%t6339 = add i64 %t6338, 0
%t6340 = icmp ne i64 %t6339, %t6337
%t6341 = icmp slt i64 4368137639120453308, 0
%t6342 = or i1 %t6340, %t6341
%t6343 = zext i1 %t6342 to i8
call void @resid_conv_check(i8 %t6343)
%t6344 = add i64 4836135668995329356, 0
%t6345 = add i64 %t6344, 0
%t6346 = add i64 %t6345, 0
%t6347 = icmp ne i64 %t6346, %t6344
%t6348 = icmp slt i64 4836135668995329356, 0
%t6349 = or i1 %t6347, %t6348
%t6350 = zext i1 %t6349 to i8
call void @resid_conv_check(i8 %t6350)
%t6351 = add i64 5532061633213252278, 0
%t6352 = add i64 %t6351, 0
%t6353 = add i64 %t6352, 0
%t6354 = icmp ne i64 %t6353, %t6351
%t6355 = icmp slt i64 5532061633213252278, 0
%t6356 = or i1 %t6354, %t6355
%t6357 = zext i1 %t6356 to i8
call void @resid_conv_check(i8 %t6357)
%t6358 = add i64 6448918945643986474, 0
%t6359 = add i64 %t6358, 0
%t6360 = add i64 %t6359, 0
%t6361 = icmp ne i64 %t6360, %t6358
%t6362 = icmp slt i64 6448918945643986474, 0
%t6363 = or i1 %t6361, %t6362
%t6364 = zext i1 %t6363 to i8
call void @resid_conv_check(i8 %t6364)
%t6365 = add i64 6902733635092675308, 0
%t6366 = add i64 %t6365, 0
%t6367 = add i64 %t6366, 0
%t6368 = icmp ne i64 %t6367, %t6365
%t6369 = icmp slt i64 6902733635092675308, 0
%t6370 = or i1 %t6368, %t6369
%t6371 = zext i1 %t6370 to i8
call void @resid_conv_check(i8 %t6371)
%t6372 = add i64 7801388544844847127, 0
%t6373 = add i64 %t6372, 0
%t6374 = add i64 %t6373, 0
%t6375 = icmp ne i64 %t6374, %t6372
%t6376 = icmp slt i64 7801388544844847127, 0
%t6377 = or i1 %t6375, %t6376
%t6378 = zext i1 %t6377 to i8
call void @resid_conv_check(i8 %t6378)
%t6379 = alloca [80 x ptr]
%t6381 = call ptr @resid_box_i64(i64 %t5841)
%t6383 = getelementptr i8, ptr %t6379, i64 0
store ptr %t6381, ptr %t6383
%t6384 = call ptr @resid_box_i64(i64 %t5848)
%t6386 = getelementptr i8, ptr %t6379, i64 8
store ptr %t6384, ptr %t6386
%t6387 = call ptr @resid_box_i64(i64 %t5855)
%t6389 = getelementptr i8, ptr %t6379, i64 16
store ptr %t6387, ptr %t6389
%t6390 = call ptr @resid_box_i64(i64 %t5862)
%t6392 = getelementptr i8, ptr %t6379, i64 24
store ptr %t6390, ptr %t6392
%t6393 = call ptr @resid_box_i64(i64 %t5869)
%t6395 = getelementptr i8, ptr %t6379, i64 32
store ptr %t6393, ptr %t6395
%t6396 = call ptr @resid_box_i64(i64 %t5876)
%t6398 = getelementptr i8, ptr %t6379, i64 40
store ptr %t6396, ptr %t6398
%t6399 = call ptr @resid_box_i64(i64 %t5883)
%t6401 = getelementptr i8, ptr %t6379, i64 48
store ptr %t6399, ptr %t6401
%t6402 = call ptr @resid_box_i64(i64 %t5890)
%t6404 = getelementptr i8, ptr %t6379, i64 56
store ptr %t6402, ptr %t6404
%t6405 = call ptr @resid_box_i64(i64 %t5897)
%t6407 = getelementptr i8, ptr %t6379, i64 64
store ptr %t6405, ptr %t6407
%t6408 = call ptr @resid_box_i64(i64 %t5904)
%t6410 = getelementptr i8, ptr %t6379, i64 72
store ptr %t6408, ptr %t6410
%t6411 = call ptr @resid_box_i64(i64 %t5911)
%t6413 = getelementptr i8, ptr %t6379, i64 80
store ptr %t6411, ptr %t6413
%t6414 = call ptr @resid_box_i64(i64 %t5918)
%t6416 = getelementptr i8, ptr %t6379, i64 88
store ptr %t6414, ptr %t6416
%t6417 = call ptr @resid_box_i64(i64 %t5925)
%t6419 = getelementptr i8, ptr %t6379, i64 96
store ptr %t6417, ptr %t6419
%t6420 = call ptr @resid_box_i64(i64 %t5932)
%t6422 = getelementptr i8, ptr %t6379, i64 104
store ptr %t6420, ptr %t6422
%t6423 = call ptr @resid_box_i64(i64 %t5939)
%t6425 = getelementptr i8, ptr %t6379, i64 112
store ptr %t6423, ptr %t6425
%t6426 = call ptr @resid_box_i64(i64 %t5946)
%t6428 = getelementptr i8, ptr %t6379, i64 120
store ptr %t6426, ptr %t6428
%t6429 = call ptr @resid_box_i64(i64 %t5953)
%t6431 = getelementptr i8, ptr %t6379, i64 128
store ptr %t6429, ptr %t6431
%t6432 = call ptr @resid_box_i64(i64 %t5960)
%t6434 = getelementptr i8, ptr %t6379, i64 136
store ptr %t6432, ptr %t6434
%t6435 = call ptr @resid_box_i64(i64 %t5967)
%t6437 = getelementptr i8, ptr %t6379, i64 144
store ptr %t6435, ptr %t6437
%t6438 = call ptr @resid_box_i64(i64 %t5974)
%t6440 = getelementptr i8, ptr %t6379, i64 152
store ptr %t6438, ptr %t6440
%t6441 = call ptr @resid_box_i64(i64 %t5981)
%t6443 = getelementptr i8, ptr %t6379, i64 160
store ptr %t6441, ptr %t6443
%t6444 = call ptr @resid_box_i64(i64 %t5988)
%t6446 = getelementptr i8, ptr %t6379, i64 168
store ptr %t6444, ptr %t6446
%t6447 = call ptr @resid_box_i64(i64 %t5995)
%t6449 = getelementptr i8, ptr %t6379, i64 176
store ptr %t6447, ptr %t6449
%t6450 = call ptr @resid_box_i64(i64 %t6002)
%t6452 = getelementptr i8, ptr %t6379, i64 184
store ptr %t6450, ptr %t6452
%t6453 = call ptr @resid_box_i64(i64 %t6009)
%t6455 = getelementptr i8, ptr %t6379, i64 192
store ptr %t6453, ptr %t6455
%t6456 = call ptr @resid_box_i64(i64 %t6016)
%t6458 = getelementptr i8, ptr %t6379, i64 200
store ptr %t6456, ptr %t6458
%t6459 = call ptr @resid_box_i64(i64 %t6023)
%t6461 = getelementptr i8, ptr %t6379, i64 208
store ptr %t6459, ptr %t6461
%t6462 = call ptr @resid_box_i64(i64 %t6030)
%t6464 = getelementptr i8, ptr %t6379, i64 216
store ptr %t6462, ptr %t6464
%t6465 = call ptr @resid_box_i64(i64 %t6037)
%t6467 = getelementptr i8, ptr %t6379, i64 224
store ptr %t6465, ptr %t6467
%t6468 = call ptr @resid_box_i64(i64 %t6044)
%t6470 = getelementptr i8, ptr %t6379, i64 232
store ptr %t6468, ptr %t6470
%t6471 = call ptr @resid_box_i64(i64 489312712824947311)
%t6473 = getelementptr i8, ptr %t6379, i64 240
store ptr %t6471, ptr %t6473
%t6474 = call ptr @resid_box_i64(i64 %t6051)
%t6476 = getelementptr i8, ptr %t6379, i64 248
store ptr %t6474, ptr %t6476
%t6477 = call ptr @resid_box_i64(i64 %t6058)
%t6479 = getelementptr i8, ptr %t6379, i64 256
store ptr %t6477, ptr %t6479
%t6480 = call ptr @resid_box_i64(i64 %t6065)
%t6482 = getelementptr i8, ptr %t6379, i64 264
store ptr %t6480, ptr %t6482
%t6483 = call ptr @resid_box_i64(i64 %t6072)
%t6485 = getelementptr i8, ptr %t6379, i64 272
store ptr %t6483, ptr %t6485
%t6486 = call ptr @resid_box_i64(i64 %t6079)
%t6488 = getelementptr i8, ptr %t6379, i64 280
store ptr %t6486, ptr %t6488
%t6489 = call ptr @resid_box_i64(i64 %t6086)
%t6491 = getelementptr i8, ptr %t6379, i64 288
store ptr %t6489, ptr %t6491
%t6492 = call ptr @resid_box_i64(i64 %t6093)
%t6494 = getelementptr i8, ptr %t6379, i64 296
store ptr %t6492, ptr %t6494
%t6495 = call ptr @resid_box_i64(i64 %t6100)
%t6497 = getelementptr i8, ptr %t6379, i64 304
store ptr %t6495, ptr %t6497
%t6498 = call ptr @resid_box_i64(i64 %t6107)
%t6500 = getelementptr i8, ptr %t6379, i64 312
store ptr %t6498, ptr %t6500
%t6501 = call ptr @resid_box_i64(i64 %t6114)
%t6503 = getelementptr i8, ptr %t6379, i64 320
store ptr %t6501, ptr %t6503
%t6504 = call ptr @resid_box_i64(i64 %t6121)
%t6506 = getelementptr i8, ptr %t6379, i64 328
store ptr %t6504, ptr %t6506
%t6507 = call ptr @resid_box_i64(i64 %t6128)
%t6509 = getelementptr i8, ptr %t6379, i64 336
store ptr %t6507, ptr %t6509
%t6510 = call ptr @resid_box_i64(i64 %t6135)
%t6512 = getelementptr i8, ptr %t6379, i64 344
store ptr %t6510, ptr %t6512
%t6513 = call ptr @resid_box_i64(i64 %t6142)
%t6515 = getelementptr i8, ptr %t6379, i64 352
store ptr %t6513, ptr %t6515
%t6516 = call ptr @resid_box_i64(i64 %t6149)
%t6518 = getelementptr i8, ptr %t6379, i64 360
store ptr %t6516, ptr %t6518
%t6519 = call ptr @resid_box_i64(i64 %t6156)
%t6521 = getelementptr i8, ptr %t6379, i64 368
store ptr %t6519, ptr %t6521
%t6522 = call ptr @resid_box_i64(i64 %t6163)
%t6524 = getelementptr i8, ptr %t6379, i64 376
store ptr %t6522, ptr %t6524
%t6525 = call ptr @resid_box_i64(i64 %t6170)
%t6527 = getelementptr i8, ptr %t6379, i64 384
store ptr %t6525, ptr %t6527
%t6528 = call ptr @resid_box_i64(i64 %t6177)
%t6530 = getelementptr i8, ptr %t6379, i64 392
store ptr %t6528, ptr %t6530
%t6531 = call ptr @resid_box_i64(i64 %t6184)
%t6533 = getelementptr i8, ptr %t6379, i64 400
store ptr %t6531, ptr %t6533
%t6534 = call ptr @resid_box_i64(i64 %t6191)
%t6536 = getelementptr i8, ptr %t6379, i64 408
store ptr %t6534, ptr %t6536
%t6537 = call ptr @resid_box_i64(i64 %t6198)
%t6539 = getelementptr i8, ptr %t6379, i64 416
store ptr %t6537, ptr %t6539
%t6540 = call ptr @resid_box_i64(i64 %t6205)
%t6542 = getelementptr i8, ptr %t6379, i64 424
store ptr %t6540, ptr %t6542
%t6543 = call ptr @resid_box_i64(i64 %t6212)
%t6545 = getelementptr i8, ptr %t6379, i64 432
store ptr %t6543, ptr %t6545
%t6546 = call ptr @resid_box_i64(i64 %t6219)
%t6548 = getelementptr i8, ptr %t6379, i64 440
store ptr %t6546, ptr %t6548
%t6549 = call ptr @resid_box_i64(i64 %t6226)
%t6551 = getelementptr i8, ptr %t6379, i64 448
store ptr %t6549, ptr %t6551
%t6552 = call ptr @resid_box_i64(i64 %t6233)
%t6554 = getelementptr i8, ptr %t6379, i64 456
store ptr %t6552, ptr %t6554
%t6555 = call ptr @resid_box_i64(i64 %t6240)
%t6557 = getelementptr i8, ptr %t6379, i64 464
store ptr %t6555, ptr %t6557
%t6558 = call ptr @resid_box_i64(i64 %t6247)
%t6560 = getelementptr i8, ptr %t6379, i64 472
store ptr %t6558, ptr %t6560
%t6561 = call ptr @resid_box_i64(i64 %t6254)
%t6563 = getelementptr i8, ptr %t6379, i64 480
store ptr %t6561, ptr %t6563
%t6564 = call ptr @resid_box_i64(i64 %t6261)
%t6566 = getelementptr i8, ptr %t6379, i64 488
store ptr %t6564, ptr %t6566
%t6567 = call ptr @resid_box_i64(i64 %t6268)
%t6569 = getelementptr i8, ptr %t6379, i64 496
store ptr %t6567, ptr %t6569
%t6570 = call ptr @resid_box_i64(i64 %t6275)
%t6572 = getelementptr i8, ptr %t6379, i64 504
store ptr %t6570, ptr %t6572
%t6573 = call ptr @resid_box_i64(i64 %t6282)
%t6575 = getelementptr i8, ptr %t6379, i64 512
store ptr %t6573, ptr %t6575
%t6576 = call ptr @resid_box_i64(i64 %t6289)
%t6578 = getelementptr i8, ptr %t6379, i64 520
store ptr %t6576, ptr %t6578
%t6579 = call ptr @resid_box_i64(i64 %t6296)
%t6581 = getelementptr i8, ptr %t6379, i64 528
store ptr %t6579, ptr %t6581
%t6582 = call ptr @resid_box_i64(i64 %t6303)
%t6584 = getelementptr i8, ptr %t6379, i64 536
store ptr %t6582, ptr %t6584
%t6585 = call ptr @resid_box_i64(i64 500013540394364858)
%t6587 = getelementptr i8, ptr %t6379, i64 544
store ptr %t6585, ptr %t6587
%t6588 = call ptr @resid_box_i64(i64 748580250866718886)
%t6590 = getelementptr i8, ptr %t6379, i64 552
store ptr %t6588, ptr %t6590
%t6591 = call ptr @resid_box_i64(i64 %t6310)
%t6593 = getelementptr i8, ptr %t6379, i64 560
store ptr %t6591, ptr %t6593
%t6594 = call ptr @resid_box_i64(i64 %t6317)
%t6596 = getelementptr i8, ptr %t6379, i64 568
store ptr %t6594, ptr %t6596
%t6597 = call ptr @resid_box_i64(i64 %t6324)
%t6599 = getelementptr i8, ptr %t6379, i64 576
store ptr %t6597, ptr %t6599
%t6600 = call ptr @resid_box_i64(i64 %t6331)
%t6602 = getelementptr i8, ptr %t6379, i64 584
store ptr %t6600, ptr %t6602
%t6603 = call ptr @resid_box_i64(i64 %t6338)
%t6605 = getelementptr i8, ptr %t6379, i64 592
store ptr %t6603, ptr %t6605
%t6606 = call ptr @resid_box_i64(i64 %t6345)
%t6608 = getelementptr i8, ptr %t6379, i64 600
store ptr %t6606, ptr %t6608
%t6609 = call ptr @resid_box_i64(i64 %t6352)
%t6611 = getelementptr i8, ptr %t6379, i64 608
store ptr %t6609, ptr %t6611
%t6612 = call ptr @resid_box_i64(i64 %t6359)
%t6614 = getelementptr i8, ptr %t6379, i64 616
store ptr %t6612, ptr %t6614
%t6615 = call ptr @resid_box_i64(i64 %t6366)
%t6617 = getelementptr i8, ptr %t6379, i64 624
store ptr %t6615, ptr %t6617
%t6618 = call ptr @resid_box_i64(i64 %t6373)
%t6620 = getelementptr i8, ptr %t6379, i64 632
store ptr %t6618, ptr %t6620
%t6621 = call ptr @resid_list_new(i64 80, ptr %t6379, ptr @.lty6379)
ret ptr %t6621
}
define ptr @sha512g_iv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6622 = add i64 7640891576956012808, 0
%t6623 = add i64 %t6622, 0
%t6624 = add i64 %t6623, 0
%t6625 = icmp ne i64 %t6624, %t6622
%t6626 = icmp slt i64 7640891576956012808, 0
%t6627 = or i1 %t6625, %t6626
%t6628 = zext i1 %t6627 to i8
call void @resid_conv_check(i8 %t6628)
%t6629 = add i128 13503953896175478587, 0
%t6630 = trunc i128 %t6629 to i64
%t6631 = zext i64 %t6630 to i128
%t6632 = icmp ne i128 %t6631, %t6629
%t6633 = icmp slt i128 13503953896175478587, 0
%t6634 = or i1 %t6632, %t6633
%t6635 = zext i1 %t6634 to i8
call void @resid_conv_check(i8 %t6635)
%t6636 = add i64 4354685564936845355, 0
%t6637 = add i64 %t6636, 0
%t6638 = add i64 %t6637, 0
%t6639 = icmp ne i64 %t6638, %t6636
%t6640 = icmp slt i64 4354685564936845355, 0
%t6641 = or i1 %t6639, %t6640
%t6642 = zext i1 %t6641 to i8
call void @resid_conv_check(i8 %t6642)
%t6643 = add i128 11912009170470909681, 0
%t6644 = trunc i128 %t6643 to i64
%t6645 = zext i64 %t6644 to i128
%t6646 = icmp ne i128 %t6645, %t6643
%t6647 = icmp slt i128 11912009170470909681, 0
%t6648 = or i1 %t6646, %t6647
%t6649 = zext i1 %t6648 to i8
call void @resid_conv_check(i8 %t6649)
%t6650 = add i64 5840696475078001361, 0
%t6651 = add i64 %t6650, 0
%t6652 = add i64 %t6651, 0
%t6653 = icmp ne i64 %t6652, %t6650
%t6654 = icmp slt i64 5840696475078001361, 0
%t6655 = or i1 %t6653, %t6654
%t6656 = zext i1 %t6655 to i8
call void @resid_conv_check(i8 %t6656)
%t6657 = add i128 11170449401992604703, 0
%t6658 = trunc i128 %t6657 to i64
%t6659 = zext i64 %t6658 to i128
%t6660 = icmp ne i128 %t6659, %t6657
%t6661 = icmp slt i128 11170449401992604703, 0
%t6662 = or i1 %t6660, %t6661
%t6663 = zext i1 %t6662 to i8
call void @resid_conv_check(i8 %t6663)
%t6664 = add i64 2270897969802886507, 0
%t6665 = add i64 %t6664, 0
%t6666 = add i64 %t6665, 0
%t6667 = icmp ne i64 %t6666, %t6664
%t6668 = icmp slt i64 2270897969802886507, 0
%t6669 = or i1 %t6667, %t6668
%t6670 = zext i1 %t6669 to i8
call void @resid_conv_check(i8 %t6670)
%t6671 = add i64 6620516959819538809, 0
%t6672 = add i64 %t6671, 0
%t6673 = add i64 %t6672, 0
%t6674 = icmp ne i64 %t6673, %t6671
%t6675 = icmp slt i64 6620516959819538809, 0
%t6676 = or i1 %t6674, %t6675
%t6677 = zext i1 %t6676 to i8
call void @resid_conv_check(i8 %t6677)
%t6678 = alloca [8 x ptr]
%t6680 = call ptr @resid_box_i64(i64 %t6623)
%t6682 = getelementptr i8, ptr %t6678, i64 0
store ptr %t6680, ptr %t6682
%t6683 = call ptr @resid_box_i64(i64 %t6630)
%t6685 = getelementptr i8, ptr %t6678, i64 8
store ptr %t6683, ptr %t6685
%t6686 = call ptr @resid_box_i64(i64 %t6637)
%t6688 = getelementptr i8, ptr %t6678, i64 16
store ptr %t6686, ptr %t6688
%t6689 = call ptr @resid_box_i64(i64 %t6644)
%t6691 = getelementptr i8, ptr %t6678, i64 24
store ptr %t6689, ptr %t6691
%t6692 = call ptr @resid_box_i64(i64 %t6651)
%t6694 = getelementptr i8, ptr %t6678, i64 32
store ptr %t6692, ptr %t6694
%t6695 = call ptr @resid_box_i64(i64 %t6658)
%t6697 = getelementptr i8, ptr %t6678, i64 40
store ptr %t6695, ptr %t6697
%t6698 = call ptr @resid_box_i64(i64 %t6665)
%t6700 = getelementptr i8, ptr %t6678, i64 48
store ptr %t6698, ptr %t6700
%t6701 = call ptr @resid_box_i64(i64 %t6672)
%t6703 = getelementptr i8, ptr %t6678, i64 56
store ptr %t6701, ptr %t6703
%t6704 = call ptr @resid_list_new(i64 8, ptr %t6678, ptr @.lty6678)
ret ptr %t6704
}
define ptr @sha384g_iv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6705 = add i128 14680500436340154072, 0
%t6706 = trunc i128 %t6705 to i64
%t6707 = zext i64 %t6706 to i128
%t6708 = icmp ne i128 %t6707, %t6705
%t6709 = icmp slt i128 14680500436340154072, 0
%t6710 = or i1 %t6708, %t6709
%t6711 = zext i1 %t6710 to i8
call void @resid_conv_check(i8 %t6711)
%t6712 = add i64 7105036623409894663, 0
%t6713 = add i64 %t6712, 0
%t6714 = add i64 %t6713, 0
%t6715 = icmp ne i64 %t6714, %t6712
%t6716 = icmp slt i64 7105036623409894663, 0
%t6717 = or i1 %t6715, %t6716
%t6718 = zext i1 %t6717 to i8
call void @resid_conv_check(i8 %t6718)
%t6719 = add i128 10473403895298186519, 0
%t6720 = trunc i128 %t6719 to i64
%t6721 = zext i64 %t6720 to i128
%t6722 = icmp ne i128 %t6721, %t6719
%t6723 = icmp slt i128 10473403895298186519, 0
%t6724 = or i1 %t6722, %t6723
%t6725 = zext i1 %t6724 to i8
call void @resid_conv_check(i8 %t6725)
%t6726 = add i64 1526699215303891257, 0
%t6727 = add i64 %t6726, 0
%t6728 = add i64 %t6727, 0
%t6729 = icmp ne i64 %t6728, %t6726
%t6730 = icmp slt i64 1526699215303891257, 0
%t6731 = or i1 %t6729, %t6730
%t6732 = zext i1 %t6731 to i8
call void @resid_conv_check(i8 %t6732)
%t6733 = add i64 7436329637833083697, 0
%t6734 = add i64 %t6733, 0
%t6735 = add i64 %t6734, 0
%t6736 = icmp ne i64 %t6735, %t6733
%t6737 = icmp slt i64 7436329637833083697, 0
%t6738 = or i1 %t6736, %t6737
%t6739 = zext i1 %t6738 to i8
call void @resid_conv_check(i8 %t6739)
%t6740 = add i128 10282925794625328401, 0
%t6741 = trunc i128 %t6740 to i64
%t6742 = zext i64 %t6741 to i128
%t6743 = icmp ne i128 %t6742, %t6740
%t6744 = icmp slt i128 10282925794625328401, 0
%t6745 = or i1 %t6743, %t6744
%t6746 = zext i1 %t6745 to i8
call void @resid_conv_check(i8 %t6746)
%t6747 = add i128 15784041429090275239, 0
%t6748 = trunc i128 %t6747 to i64
%t6749 = zext i64 %t6748 to i128
%t6750 = icmp ne i128 %t6749, %t6747
%t6751 = icmp slt i128 15784041429090275239, 0
%t6752 = or i1 %t6750, %t6751
%t6753 = zext i1 %t6752 to i8
call void @resid_conv_check(i8 %t6753)
%t6754 = add i64 5167115440072839076, 0
%t6755 = add i64 %t6754, 0
%t6756 = add i64 %t6755, 0
%t6757 = icmp ne i64 %t6756, %t6754
%t6758 = icmp slt i64 5167115440072839076, 0
%t6759 = or i1 %t6757, %t6758
%t6760 = zext i1 %t6759 to i8
call void @resid_conv_check(i8 %t6760)
%t6761 = alloca [8 x ptr]
%t6763 = call ptr @resid_box_i64(i64 %t6706)
%t6765 = getelementptr i8, ptr %t6761, i64 0
store ptr %t6763, ptr %t6765
%t6766 = call ptr @resid_box_i64(i64 %t6713)
%t6768 = getelementptr i8, ptr %t6761, i64 8
store ptr %t6766, ptr %t6768
%t6769 = call ptr @resid_box_i64(i64 %t6720)
%t6771 = getelementptr i8, ptr %t6761, i64 16
store ptr %t6769, ptr %t6771
%t6772 = call ptr @resid_box_i64(i64 %t6727)
%t6774 = getelementptr i8, ptr %t6761, i64 24
store ptr %t6772, ptr %t6774
%t6775 = call ptr @resid_box_i64(i64 %t6734)
%t6777 = getelementptr i8, ptr %t6761, i64 32
store ptr %t6775, ptr %t6777
%t6778 = call ptr @resid_box_i64(i64 %t6741)
%t6780 = getelementptr i8, ptr %t6761, i64 40
store ptr %t6778, ptr %t6780
%t6781 = call ptr @resid_box_i64(i64 %t6748)
%t6783 = getelementptr i8, ptr %t6761, i64 48
store ptr %t6781, ptr %t6783
%t6784 = call ptr @resid_box_i64(i64 %t6755)
%t6786 = getelementptr i8, ptr %t6761, i64 56
store ptr %t6784, ptr %t6786
%t6787 = call ptr @resid_list_new(i64 8, ptr %t6761, ptr @.lty6761)
ret ptr %t6787
}
define ptr @sha512g_pad(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6788 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p0, i64 17)
%t6789 = extractvalue {i64, i1} %t6788, 0
%t6790 = extractvalue {i64, i1} %t6788, 1
%t6791 = zext i1 %t6790 to i8
call void @resid_overflow_check(i8 %t6791)
%t6792 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t6789, i64 127)
%t6793 = extractvalue {i64, i1} %t6792, 0
%t6794 = extractvalue {i64, i1} %t6792, 1
%t6795 = zext i1 %t6794 to i8
call void @resid_overflow_check(i8 %t6795)
%t6796 = sdiv i64 %t6793, 128
%t6797 = mul nsw i64 %t6796, 128
%t6798 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t6797, i64 %p0)
%t6799 = extractvalue {i64, i1} %t6798, 0
%t6800 = extractvalue {i64, i1} %t6798, 1
%t6801 = zext i1 %t6800 to i8
call void @resid_overflow_check(i8 %t6801)
%t6802 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t6799, i64 17)
%t6803 = extractvalue {i64, i1} %t6802, 0
%t6804 = extractvalue {i64, i1} %t6802, 1
%t6805 = zext i1 %t6804 to i8
call void @resid_overflow_check(i8 %t6805)
%t6806 = call ptr @resid_listbuf_new()
%t6807 = call ptr @__m____________lib_sha512g_resid__sha512g_pad_at(i64 %p0, i64 %t6803, i64 0, ptr %t6806)
%t6808 = call ptr @resid_listbuf_finish(ptr %t6807, ptr @.lty6808)
ret ptr %t6808
}
define ptr @__m____________lib_sha512g_resid__sha512g_pad_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ], [ %p0, %tco.s2 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ], [ %p1, %tco.s2 ]
%p2 = phi i64 [ %p2.in, %entry ], [ 1, %tco.s0 ], [ %t6821, %tco.s1 ], [ %t6847, %tco.s2 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t6813, %tco.s0 ], [ %t6827, %tco.s1 ], [ %t6864, %tco.s2 ]
%t6809 = icmp eq i64 %p2, 0
br i1 %t6809, label %L679, label %L681
L679:
%t6810 = call ptr @resid_box_i64(i64 128)
%t6813 = call ptr @resid_listbuf_push(ptr %p3, ptr %t6810)
br label %tco.s0
tco.s0:
br label %tco.head
L681:
%t6815 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 8)
%t6816 = extractvalue {i64, i1} %t6815, 0
%t6817 = extractvalue {i64, i1} %t6815, 1
%t6818 = zext i1 %t6817 to i8
call void @resid_overflow_check(i8 %t6818)
%t6819 = icmp sle i64 %p2, %t6816
br i1 %t6819, label %L682, label %L684
L682:
%t6820 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t6821 = extractvalue {i64, i1} %t6820, 0
%t6822 = extractvalue {i64, i1} %t6820, 1
%t6823 = zext i1 %t6822 to i8
call void @resid_overflow_check(i8 %t6823)
%t6824 = call ptr @resid_box_i64(i64 0)
%t6827 = call ptr @resid_listbuf_push(ptr %p3, ptr %t6824)
br label %tco.s1
tco.s1:
br label %tco.head
L684:
%t6829 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 16)
%t6830 = extractvalue {i64, i1} %t6829, 0
%t6831 = extractvalue {i64, i1} %t6829, 1
%t6832 = zext i1 %t6831 to i8
call void @resid_overflow_check(i8 %t6832)
%t6833 = icmp sle i64 %p2, %t6830
br i1 %t6833, label %L685, label %L687
L685:
%t6834 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 16)
%t6835 = extractvalue {i64, i1} %t6834, 0
%t6836 = extractvalue {i64, i1} %t6834, 1
%t6837 = zext i1 %t6836 to i8
call void @resid_overflow_check(i8 %t6837)
%t6838 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t6835, i64 %p2)
%t6839 = extractvalue {i64, i1} %t6838, 0
%t6840 = extractvalue {i64, i1} %t6838, 1
%t6841 = zext i1 %t6840 to i8
call void @resid_overflow_check(i8 %t6841)
%t6842 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t6839, i64 8)
%t6843 = extractvalue {i64, i1} %t6842, 0
%t6844 = extractvalue {i64, i1} %t6842, 1
%t6845 = zext i1 %t6844 to i8
call void @resid_overflow_check(i8 %t6845)
%t6846 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t6847 = extractvalue {i64, i1} %t6846, 0
%t6848 = extractvalue {i64, i1} %t6846, 1
%t6849 = zext i1 %t6848 to i8
call void @resid_overflow_check(i8 %t6849)
%t6850 = icmp sge i64 %t6843, 61
br i1 %t6850, label %L688, label %L689
L688:
br label %L690
L689:
%t6851 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p0, i64 8)
%t6852 = extractvalue {i64, i1} %t6851, 0
%t6853 = extractvalue {i64, i1} %t6851, 1
%t6854 = zext i1 %t6853 to i8
call void @resid_overflow_check(i8 %t6854)
%t6855 = icmp uge i64 %t6843, 64
%t6856 = add i64 %t6843, 0
%t6857 = select i1 %t6855, i64 63, i64 %t6856
%t6858 = ashr i64 %t6852, %t6857
%t6859 = and i64 %t6858, 255
br label %L690
L690:
%t6860 = phi i64 [ 0, %L688 ], [ %t6859, %L689 ]
%t6861 = call ptr @resid_box_i64(i64 %t6860)
%t6864 = call ptr @resid_listbuf_push(ptr %p3, ptr %t6861)
br label %tco.s2
tco.s2:
br label %tco.head
L687:
ret ptr %p3
}
define ptr @__m____________lib_sha512g_resid__sha512g_zero_bytes(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6868, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t6872, %tco.s0 ]
%t6866 = icmp sge i64 %p1, %p0
br i1 %t6866, label %L691, label %L693
L691:
%t6867 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty6867)
ret ptr %t6867
L693:
%t6868 = add nsw i64 %p1, 1
%t6869 = call ptr @resid_box_i64(i64 0)
%t6872 = call ptr @resid_listbuf_push(ptr %p2, ptr %t6869)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @eg_p() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6874 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
ret i512 %t6874
}
define i512 @eg_d() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6875 = sext i256 37095705934669439343138083508754565189542113879843219016388785533085940283555 to i512
ret i512 %t6875
}
define i512 @eg_l() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6876 = sext i256 7237005577332262213973186563042994240857116359379907606001950938285454250989 to i512
ret i512 %t6876
}
define i512 @eg_bx() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6877 = sext i256 15112221349535400772501151409588531511454012693041857206046113283949847762202 to i512
ret i512 %t6877
}
define i512 @eg_by() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6878 = sext i256 46316835694926478169428394003475163141307993866256225615783033603165251855960 to i512
ret i512 %t6878
}
define i512 @__m____________lib_ed25519g_resid__eg_m256() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i512 115792089237316195423570985008687907853269984665640564039457584007913129639935
}
define i512 @__m____________lib_ed25519g_resid__eg_ones() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6879 = sext i64 -1 to i512
ret i512 %t6879
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
%t6880 = call i256 @fe_mul(i256 15112221349535400772501151409588531511454012693041857206046113283949847762202, i256 46316835694926478169428394003475163141307993866256225615783033603165251855960)
ret i256 %t6880
}
define i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6881 = sext i256 %p0 to i512
ret i512 %t6881
}
define i256 @fe_add(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6882 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6883 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t6884 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t6882, i512 %t6883)
%t6885 = trunc i512 %t6884 to i256
ret i256 %t6885
}
define i256 @fe_sub(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6886 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6887 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t6888 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t6886, i512 %t6887)
%t6889 = trunc i512 %t6888 to i256
ret i256 %t6889
}
define i256 @fe_mul(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6890 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6891 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t6892 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t6890, i512 %t6891)
%t6893 = trunc i512 %t6892 to i256
ret i256 %t6893
}
define i256 @fe_sq(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6894 = call i256 @fe_mul(i256 %p0, i256 %p0)
ret i256 %t6894
}
define i256 @fe_inv(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6895 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6896 = call i512 @eg_finv__g_Int_512__Int_64_(i512 %t6895)
%t6897 = trunc i512 %t6896 to i256
ret i256 %t6897
}
define i256 @pow_acc(i256 %p0, i256 %p1, i256 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6898 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6899 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t6900 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p2)
%t6901 = call i512 @eg_fpow__g_Int_512__Int_64_(i512 %t6898, i512 %t6899, i512 %t6900, i64 %p3)
%t6902 = trunc i512 %t6901 to i256
ret i256 %t6902
}
define i256 @bytes_to_int(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6903 = sext i64 0 to i256
%t6904 = call i256 @b2a(ptr %p0, i256 %t6903, i64 31)
ret i256 %t6904
}
define i256 @b2a(ptr %p0.in, i256 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i256 [ %p1.in, %entry ], [ %t6918, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6919, %tco.s0 ]
%t6905 = icmp slt i64 %p2, 0
br i1 %t6905, label %L694, label %L696
L694:
ret i256 %p1
L696:
%t6906 = icmp eq i64 %p2, 31
br i1 %t6906, label %L697, label %L698
L697:
%t6907 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t6908 = call i64 @resid_unbox_i64(ptr %t6907)
%t6910 = and i64 %t6908, 127
br label %L699
L698:
%t6911 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t6912 = call i64 @resid_unbox_i64(ptr %t6911)
%t6914 = and i64 %t6912, 255
br label %L699
L699:
%t6915 = phi i64 [ %t6910, %L697 ], [ %t6914, %L698 ]
%t6916 = shl i256 %p1, 8
%t6917 = sext i64 %t6915 to i256
%t6918 = or i256 %t6916, %t6917
%t6919 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @int_to_bytes(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6921 = call ptr @resid_listbuf_new()
%t6922 = call ptr @__m____________lib_ed25519_resid__itob_acc(i256 %p0, i64 0, ptr %t6921)
ret ptr %t6922
}
define ptr @__m____________lib_ed25519_resid__itob_acc(i256 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i256 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6925, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t6940, %tco.s0 ]
%t6923 = icmp sgt i64 %p1, 31
br i1 %t6923, label %L700, label %L702
L700:
%t6924 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty6924)
ret ptr %t6924
L702:
%t6925 = add nsw i64 %p1, 1
%t6926 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t6927 = extractvalue {i64, i1} %t6926, 0
%t6928 = extractvalue {i64, i1} %t6926, 1
%t6929 = zext i1 %t6928 to i8
call void @resid_overflow_check(i8 %t6929)
%t6930 = sext i64 %t6927 to i256
%t6931 = icmp uge i256 %t6930, 256
%t6932 = add i256 %t6930, 0
%t6933 = select i1 %t6931, i256 255, i256 %t6932
%t6934 = ashr i256 %p0, %t6933
%t6935 = and i256 %t6934, 255
%t6936 = trunc i256 %t6935 to i64
%t6937 = call ptr @resid_box_i64(i64 %t6936)
%t6940 = call ptr @resid_listbuf_push(ptr %p2, ptr %t6937)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @slice_bytes(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6942 = icmp slt i64 %p2, %p1
br i1 %t6942, label %L703, label %L705
L703:
%t6944 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty6943)
ret ptr %t6944
L705:
%t6945 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t6946 = extractvalue {i64, i1} %t6945, 0
%t6947 = extractvalue {i64, i1} %t6945, 1
%t6948 = zext i1 %t6947 to i8
call void @resid_overflow_check(i8 %t6948)
%t6949 = musttail call ptr @resid_list_slice(ptr %p0, i64 %p1, i64 %t6946)
ret ptr %t6949
}
define ptr @concat_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6951 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %p1)
ret ptr %t6951
}
define ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6952 = call ptr @resid_rec_new(i64 256, i8 1)
%t6953 = getelementptr i8, ptr %p0, i64 0
%t6954 = load i256, ptr %t6953, align 8
%t6955 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6954)
%t6952.f0 = getelementptr i8, ptr %t6952, i64 0
store i512 %t6955, ptr %t6952.f0, align 8
%t6956 = getelementptr i8, ptr %p0, i64 32
%t6957 = load i256, ptr %t6956, align 8
%t6958 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6957)
%t6952.f8 = getelementptr i8, ptr %t6952, i64 64
store i512 %t6958, ptr %t6952.f8, align 8
%t6959 = getelementptr i8, ptr %p0, i64 64
%t6960 = load i256, ptr %t6959, align 8
%t6961 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6960)
%t6952.f16 = getelementptr i8, ptr %t6952, i64 128
store i512 %t6961, ptr %t6952.f16, align 8
%t6962 = getelementptr i8, ptr %p0, i64 96
%t6963 = load i256, ptr %t6962, align 8
%t6964 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6963)
%t6952.f24 = getelementptr i8, ptr %t6952, i64 192
store i512 %t6964, ptr %t6952.f24, align 8
ret ptr %t6952
}
define ptr @__m____________lib_ed25519_resid__ept_n(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6965 = call ptr @resid_gmalloc(i64 128)
%t6966 = getelementptr i8, ptr %p0, i64 0
%t6967 = load i512, ptr %t6966, align 8
%t6968 = trunc i512 %t6967 to i256
%t6965.f0 = getelementptr i8, ptr %t6965, i64 0
store i256 %t6968, ptr %t6965.f0, align 8
%t6969 = getelementptr i8, ptr %p0, i64 64
%t6970 = load i512, ptr %t6969, align 8
%t6971 = trunc i512 %t6970 to i256
%t6965.f4 = getelementptr i8, ptr %t6965, i64 32
store i256 %t6971, ptr %t6965.f4, align 8
%t6972 = getelementptr i8, ptr %p0, i64 128
%t6973 = load i512, ptr %t6972, align 8
%t6974 = trunc i512 %t6973 to i256
%t6965.f8 = getelementptr i8, ptr %t6965, i64 64
store i256 %t6974, ptr %t6965.f8, align 8
%t6975 = getelementptr i8, ptr %p0, i64 192
%t6976 = load i512, ptr %t6975, align 8
%t6977 = trunc i512 %t6976 to i256
%t6965.f12 = getelementptr i8, ptr %t6965, i64 96
store i256 %t6977, ptr %t6965.f12, align 8
ret ptr %t6965
}
define ptr @ept(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6978 = call ptr @resid_gmalloc(i64 128)
%t6978.f0 = getelementptr i8, ptr %t6978, i64 0
store i256 %p0, ptr %t6978.f0, align 8
%t6978.f4 = getelementptr i8, ptr %t6978, i64 32
store i256 %p1, ptr %t6978.f4, align 8
%t6979 = sext i64 1 to i256
%t6978.f8 = getelementptr i8, ptr %t6978, i64 64
store i256 %t6979, ptr %t6978.f8, align 8
%t6980 = call i256 @fe_mul(i256 %p0, i256 %p1)
%t6978.f12 = getelementptr i8, ptr %t6978, i64 96
store i256 %t6980, ptr %t6978.f12, align 8
ret ptr %t6978
}
define ptr @ept_id() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6981 = call ptr @resid_gmalloc(i64 128)
%t6982 = sext i64 0 to i256
%t6981.f0 = getelementptr i8, ptr %t6981, i64 0
store i256 %t6982, ptr %t6981.f0, align 8
%t6983 = sext i64 1 to i256
%t6981.f4 = getelementptr i8, ptr %t6981, i64 32
store i256 %t6983, ptr %t6981.f4, align 8
%t6984 = sext i64 1 to i256
%t6981.f8 = getelementptr i8, ptr %t6981, i64 64
store i256 %t6984, ptr %t6981.f8, align 8
%t6985 = sext i64 0 to i256
%t6981.f12 = getelementptr i8, ptr %t6981, i64 96
store i256 %t6985, ptr %t6981.f12, align 8
ret ptr %t6981
}
define ptr @ept_dbl(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6986 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0)
%t6987 = call ptr @eg_dbl__g_Int_512__Int_64_(ptr %t6986)
%t6988 = musttail call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t6987)
ret ptr %t6988
}
define ptr @ept_add(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6989 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0)
%t6990 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p1)
%t6991 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t6989, ptr %t6990)
%t6992 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t6991)
ret ptr %t6992
}
define ptr @ept_mul(i256 %p0, ptr %p1, ptr %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6993 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6994 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p1)
call void @resid_rec_share(ptr %t6994)
%t6995 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p2)
call void @resid_rec_share(ptr %t6995)
%t6996 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %t6993, ptr %t6994, ptr %t6995, i64 %p3)
%t6997 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t6996)
ret ptr %t6997
}
define ptr @ept_base_mul(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6998 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6999 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t6998)
%t7000 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t6999)
ret ptr %t7000
}
define ptr @ept_encode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7001 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0)
%t7002 = musttail call ptr @eg_encode__g_Int_512__Int_64_(ptr %t7001)
ret ptr %t7002
}
define i1 @ept_eq(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7003 = getelementptr i8, ptr %p0, i64 0
%t7004 = load i256, ptr %t7003, align 8
%t7005 = getelementptr i8, ptr %p1, i64 64
%t7006 = load i256, ptr %t7005, align 8
%t7007 = call i256 @fe_mul(i256 %t7004, i256 %t7006)
%t7008 = getelementptr i8, ptr %p1, i64 0
%t7009 = load i256, ptr %t7008, align 8
%t7010 = getelementptr i8, ptr %p0, i64 64
%t7011 = load i256, ptr %t7010, align 8
%t7012 = call i256 @fe_mul(i256 %t7009, i256 %t7011)
%t7013 = icmp eq i256 %t7007, %t7012
br label %LSL7014
LSL7014:
br i1 %t7013, label %LSR7014, label %LSJ7014
LSR7014:
%t7015 = getelementptr i8, ptr %p0, i64 32
%t7016 = load i256, ptr %t7015, align 8
%t7017 = getelementptr i8, ptr %p1, i64 64
%t7018 = load i256, ptr %t7017, align 8
%t7019 = call i256 @fe_mul(i256 %t7016, i256 %t7018)
%t7020 = getelementptr i8, ptr %p1, i64 32
%t7021 = load i256, ptr %t7020, align 8
%t7022 = getelementptr i8, ptr %p0, i64 64
%t7023 = load i256, ptr %t7022, align 8
%t7024 = call i256 @fe_mul(i256 %t7021, i256 %t7023)
%t7025 = icmp eq i256 %t7019, %t7024
br label %LSJ7014
LSJ7014:
%t7026 = phi i1 [ false, %LSL7014 ], [ %t7025, %LSR7014 ]
ret i1 %t7026
}
define ptr @smul_x_acc(i256 %p0, i256 %p1, i256 %p2, i256 %p3, i256 %p4, i256 %p5, i256 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7027 = call ptr @resid_gmalloc(i64 128)
%t7027.f0 = getelementptr i8, ptr %t7027, i64 0
store i256 %p1, ptr %t7027.f0, align 8
%t7027.f4 = getelementptr i8, ptr %t7027, i64 32
store i256 %p2, ptr %t7027.f4, align 8
%t7027.f8 = getelementptr i8, ptr %t7027, i64 64
store i256 %p3, ptr %t7027.f8, align 8
%t7028 = call i256 @fe_mul(i256 %p1, i256 %p2)
%t7029 = call i256 @fe_inv(i256 %p3)
%t7030 = call i256 @fe_mul(i256 %t7028, i256 %t7029)
%t7027.f12 = getelementptr i8, ptr %t7027, i64 96
store i256 %t7030, ptr %t7027.f12, align 8
%t7031 = call ptr @resid_gmalloc(i64 128)
%t7031.f0 = getelementptr i8, ptr %t7031, i64 0
store i256 %p4, ptr %t7031.f0, align 8
%t7031.f4 = getelementptr i8, ptr %t7031, i64 32
store i256 %p5, ptr %t7031.f4, align 8
%t7031.f8 = getelementptr i8, ptr %t7031, i64 64
store i256 %p6, ptr %t7031.f8, align 8
%t7032 = call i256 @fe_mul(i256 %p4, i256 %p5)
%t7033 = call i256 @fe_inv(i256 %p6)
%t7034 = call i256 @fe_mul(i256 %t7032, i256 %t7033)
%t7031.f12 = getelementptr i8, ptr %t7031, i64 96
store i256 %t7034, ptr %t7031.f12, align 8
%t7035 = call ptr @ept_mul(i256 %p0, ptr %t7027, ptr %t7031, i64 %p7)
%t7036 = getelementptr i8, ptr %t7035, i64 0
%t7037 = load i256, ptr %t7036, align 8
%t7038 = getelementptr i8, ptr %t7035, i64 64
%t7039 = load i256, ptr %t7038, align 8
%t7040 = call i256 @fe_inv(i256 %t7039)
%t7041 = call i256 @fe_mul(i256 %t7037, i256 %t7040)
%t7042 = call ptr @int_to_bytes(i256 %t7041)
ret ptr %t7042
}
define i256 @dec_y(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7043 = call i256 @bytes_to_int(ptr %p0)
ret i256 %t7043
}
define i256 @dec_x(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7044 = call i256 @dec_y(ptr %p0)
%t7045 = call i64 @resid_list_len(ptr %p0)
%t7046 = sub nsw i64 %t7045, 1
%t7047 = call ptr @resid_list_get(ptr %p0, i64 %t7046)
%t7048 = call i64 @resid_unbox_i64(ptr %t7047)
%t7050 = ashr i64 %t7048, 7
%t7051 = and i64 %t7050, 1
%t7052 = call i256 @fe_sq(i256 %t7044)
%t7053 = sext i64 1 to i256
%t7054 = call i256 @fe_sub(i256 %t7052, i256 %t7053)
%t7055 = call i256 @fe_mul(i256 37095705934669439343138083508754565189542113879843219016388785533085940283555, i256 %t7052)
%t7056 = sext i64 1 to i256
%t7057 = call i256 @fe_add(i256 %t7055, i256 %t7056)
%t7058 = call i256 @fe_inv(i256 %t7057)
%t7059 = call i256 @fe_mul(i256 %t7054, i256 %t7058)
%t7060 = sext i64 1 to i256
%t7061 = call i256 @pow_acc(i256 %t7060, i256 %t7059, i256 7237005577332262213973186563042994240829374041602535252466099000494570602494, i64 254)
%t7062 = call i256 @fe_sq(i256 %t7061)
%t7063 = icmp eq i256 %t7062, %t7059
br i1 %t7063, label %L706, label %L707
L706:
br label %L708
L707:
%t7064 = call i256 @fe_mul(i256 %t7061, i256 19681161376707505956807079304988542015446066515923890162744021073123829784752)
br label %L708
L708:
%t7065 = phi i256 [ %t7061, %L706 ], [ %t7064, %L707 ]
%t7066 = and i256 %t7065, 1
%t7067 = trunc i256 %t7066 to i64
%t7068 = icmp ne i64 %t7067, %t7051
br i1 %t7068, label %L709, label %L710
L709:
%t7069 = sext i64 0 to i256
%t7070 = call i256 @fe_sub(i256 %t7069, i256 %t7065)
br label %L711
L710:
br label %L711
L711:
%t7071 = phi i256 [ %t7070, %L709 ], [ %t7065, %L710 ]
ret i256 %t7071
}
define i1 @dec_ok(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7072 = call ptr @__m____________lib_ed25519_resid__dec_pt(ptr %p0)
%t7073 = getelementptr i8, ptr %t7072, i64 0
%t7074 = load i1, ptr %t7073, align 8
ret i1 %t7074
}
define ptr @__m____________lib_ed25519_resid__dec_pt(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7075 = call ptr @resid_gmalloc(i64 72)
%t7075.f0 = getelementptr i8, ptr %t7075, i64 0
store i1 false, ptr %t7075.f0, align 8
%t7076 = sext i64 0 to i256
%t7075.f1 = getelementptr i8, ptr %t7075, i64 8
store i256 %t7076, ptr %t7075.f1, align 8
%t7077 = sext i64 0 to i256
%t7075.f5 = getelementptr i8, ptr %t7075, i64 40
store i256 %t7077, ptr %t7075.f5, align 8
%t7078 = call i64 @resid_list_len(ptr %p0)
%t7079 = icmp ne i64 %t7078, 32
br i1 %t7079, label %L712, label %L714
L712:
ret ptr %t7075
L714:
%t7080 = call i256 @dec_y(ptr %p0)
%t7081 = icmp sge i256 %t7080, 57896044618658097711785492504343953926634992332820282019728792003956564819949
br i1 %t7081, label %L715, label %L717
L715:
ret ptr %t7075
L717:
%t7082 = call i256 @dec_x(ptr %p0)
%t7083 = icmp eq i256 %t7082, 0
br label %LSL7084
LSL7084:
br i1 %t7083, label %LSR7084, label %LSJ7084
LSR7084:
%t7085 = call ptr @resid_list_get(ptr %p0, i64 31)
%t7086 = call i64 @resid_unbox_i64(ptr %t7085)
%t7088 = ashr i64 %t7086, 7
%t7089 = and i64 %t7088, 1
%t7090 = icmp eq i64 %t7089, 1
br label %LSJ7084
LSJ7084:
%t7091 = phi i1 [ false, %LSL7084 ], [ %t7090, %LSR7084 ]
br i1 %t7091, label %L718, label %L720
L718:
ret ptr %t7075
L720:
%t7092 = call i256 @fe_sq(i256 %t7082)
%t7093 = call i256 @fe_sq(i256 %t7080)
%t7094 = call ptr @resid_gmalloc(i64 72)
%t7095 = call i256 @fe_sub(i256 %t7093, i256 %t7092)
%t7096 = sext i64 1 to i256
%t7097 = call i256 @fe_mul(i256 %t7092, i256 %t7093)
%t7098 = call i256 @fe_mul(i256 37095705934669439343138083508754565189542113879843219016388785533085940283555, i256 %t7097)
%t7099 = call i256 @fe_add(i256 %t7096, i256 %t7098)
%t7100 = icmp eq i256 %t7095, %t7099
%t7094.f0 = getelementptr i8, ptr %t7094, i64 0
store i1 %t7100, ptr %t7094.f0, align 8
%t7094.f1 = getelementptr i8, ptr %t7094, i64 8
store i256 %t7082, ptr %t7094.f1, align 8
%t7094.f5 = getelementptr i8, ptr %t7094, i64 40
store i256 %t7080, ptr %t7094.f5, align 8
ret ptr %t7094
}
define i256 @mod_l(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7101 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %p0)
%t7102 = trunc i512 %t7101 to i256
ret i256 %t7102
}
define i1 @verify_sig_bytes(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7103 = call i64 @resid_list_len(ptr %p1)
%t7104 = icmp ne i64 %t7103, 64
br label %LSL7105
LSL7105:
br i1 %t7104, label %LSJ7105, label %LSR7105
LSR7105:
%t7106 = call i64 @resid_list_len(ptr %p2)
%t7107 = icmp ne i64 %t7106, 32
br label %LSJ7105
LSJ7105:
%t7108 = phi i1 [ true, %LSL7105 ], [ %t7107, %LSR7105 ]
br i1 %t7108, label %L721, label %L723
L721:
ret i1 false
L723:
%t7109 = call ptr @resid_list_get(ptr %p1, i64 63)
%t7110 = call i64 @resid_unbox_i64(ptr %t7109)
%t7112 = icmp sge i64 %t7110, 128
br i1 %t7112, label %L724, label %L726
L724:
ret i1 false
L726:
%t7113 = call ptr @resid_list_slice(ptr %p1, i64 0, i64 32)
%t7115 = call ptr @resid_list_slice(ptr %p1, i64 32, i64 64)
%t7117 = call i256 @bytes_to_int(ptr %t7115)
%t7118 = icmp sge i256 %t7117, 7237005577332262213973186563042994240857116359379907606001950938285454250989
br i1 %t7118, label %L727, label %L729
L727:
ret i1 false
L729:
%t7119 = call ptr @__m____________lib_ed25519_resid__dec_pt(ptr %p2)
%t7120 = call ptr @__m____________lib_ed25519_resid__dec_pt(ptr %t7113)
%t7121 = getelementptr i8, ptr %t7119, i64 0
%t7122 = load i1, ptr %t7121, align 8
%t7123 = xor i1 %t7122, true
br label %LSL7124
LSL7124:
br i1 %t7123, label %LSJ7124, label %LSR7124
LSR7124:
%t7125 = getelementptr i8, ptr %t7120, i64 0
%t7126 = load i1, ptr %t7125, align 8
%t7127 = xor i1 %t7126, true
br label %LSJ7124
LSJ7124:
%t7128 = phi i1 [ true, %LSL7124 ], [ %t7127, %LSR7124 ]
br i1 %t7128, label %L730, label %L732
L730:
ret i1 false
L732:
%t7129 = getelementptr i8, ptr %t7119, i64 8
%t7130 = load i256, ptr %t7129, align 8
%t7131 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7130)
%t7132 = getelementptr i8, ptr %t7119, i64 40
%t7133 = load i256, ptr %t7132, align 8
%t7134 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7133)
%t7135 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t7131, i512 %t7134)
call void @resid_rec_share(ptr %t7135)
%t7136 = getelementptr i8, ptr %t7120, i64 8
%t7137 = load i256, ptr %t7136, align 8
%t7138 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7137)
%t7139 = getelementptr i8, ptr %t7120, i64 40
%t7140 = load i256, ptr %t7139, align 8
%t7141 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7140)
%t7142 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t7138, i512 %t7141)
%t7143 = call i64 @resid_scope_push()
%t7144 = call ptr @resid_list_concat_own(ptr %t7113, i8 1, ptr %p2)
%t7145 = call ptr @resid_list_concat_own(ptr %t7144, i8 1, ptr %p0)
%t7146 = call ptr @sha512_bytes(ptr %t7145)
%t7147 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t7146)
call void @resid_scope_pop(i64 %t7143)
%t7148 = call ptr @eg_id__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t7148)
%t7149 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7117)
%t7150 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t7149)
%t7151 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t7150)
%t7152 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %t7147, ptr %t7135, ptr %t7148, i64 255)
%t7153 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t7152, ptr %t7142)
%t7154 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t7153)
%t7155 = call i1 @ept_eq(ptr %t7151, ptr %t7154)
ret i1 %t7155
}
define i1 @verify_sig(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7156 = call ptr @bytes_of(ptr %p0)
%t7157 = call ptr @resid_list_freeze(ptr %t7156)
%t7158 = musttail call i1 @verify_sig_bytes(ptr %t7157, ptr %p1, ptr %p2)
ret i1 %t7158
}
define i256 @clamp_scalar(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7159 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t7160 = call i512 @eg_clamp__g_Int_512__Int_64_(i512 %t7159)
%t7161 = trunc i512 %t7160 to i256
ret i256 %t7161
}
define ptr @pub_key(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7162 = musttail call ptr @ed25519g_pub__g_Int_64__Int_512__UInt_64_(ptr %p0)
ret ptr %t7162
}
define ptr @sign_msg_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7163 = musttail call ptr @ed25519g_sign__g_Int_64__Int_512__UInt_64_(ptr %p0, ptr %p1)
ret ptr %t7163
}
define ptr @sign_msg(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7164 = call ptr @bytes_of(ptr %p1)
%t7165 = call ptr @resid_list_freeze(ptr %t7164)
%t7166 = musttail call ptr @sign_msg_bytes(ptr %p0, ptr %t7165)
ret ptr %t7166
}
define i64 @__m____________lib_chachag_resid__cg_le32(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7167 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t7168 = call i64 @resid_unbox_i64(ptr %t7167)
%t7170 = and i64 %t7168, 255
%t7171 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t7172 = extractvalue {i64, i1} %t7171, 0
%t7173 = extractvalue {i64, i1} %t7171, 1
%t7174 = zext i1 %t7173 to i8
call void @resid_overflow_check(i8 %t7174)
%t7175 = call ptr @resid_list_get(ptr %p0, i64 %t7172)
%t7176 = call i64 @resid_unbox_i64(ptr %t7175)
%t7178 = and i64 %t7176, 255
%t7179 = shl i64 %t7178, 8
%t7180 = or i64 %t7170, %t7179
%t7181 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t7182 = extractvalue {i64, i1} %t7181, 0
%t7183 = extractvalue {i64, i1} %t7181, 1
%t7184 = zext i1 %t7183 to i8
call void @resid_overflow_check(i8 %t7184)
%t7185 = call ptr @resid_list_get(ptr %p0, i64 %t7182)
%t7186 = call i64 @resid_unbox_i64(ptr %t7185)
%t7188 = and i64 %t7186, 255
%t7189 = shl i64 %t7188, 16
%t7190 = or i64 %t7180, %t7189
%t7191 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 3)
%t7192 = extractvalue {i64, i1} %t7191, 0
%t7193 = extractvalue {i64, i1} %t7191, 1
%t7194 = zext i1 %t7193 to i8
call void @resid_overflow_check(i8 %t7194)
%t7195 = call ptr @resid_list_get(ptr %p0, i64 %t7192)
%t7196 = call i64 @resid_unbox_i64(ptr %t7195)
%t7198 = and i64 %t7196, 255
%t7199 = shl i64 %t7198, 24
%t7200 = or i64 %t7190, %t7199
ret i64 %t7200
}
define i512 @__m____________lib_chachag_resid__pg_m130() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7201 = sext i256 1361129467683753853853498429727072845823 to i512
ret i512 %t7201
}
define i512 @__m____________lib_chachag_resid__pg_p() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7202 = sext i256 1361129467683753853853498429727072845819 to i512
ret i512 %t7202
}
define i512 @__m____________lib_chachag_resid__pg_m128() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7203 = sext i256 340282366920938463463374607431768211455 to i512
ret i512 %t7203
}
define i512 @__m____________lib_chachag_resid__pg_clamp() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7204 = sext i128 21267647620597763993911028882763415551 to i512
ret i512 %t7204
}
define i64 @__m____________lib_chachag_resid__cg_pad16(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7205 = srem i64 %p0, 16
%t7206 = icmp eq i64 %t7205, 0
br i1 %t7206, label %L733, label %L734
L733:
br label %L735
L734:
%t7207 = sub nsw i64 16, %t7205
br label %L735
L735:
%t7208 = phi i64 [ 0, %L733 ], [ %t7207, %L734 ]
ret i64 %t7208
}
define ptr @__m____________lib_chachag_resid__cg_zeros(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7211, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7215, %tco.s0 ]
%t7209 = icmp sge i64 %p1, %p0
br i1 %t7209, label %L736, label %L738
L736:
%t7210 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty7210)
ret ptr %t7210
L738:
%t7211 = add nsw i64 %p1, 1
%t7212 = call ptr @resid_box_i64(i64 0)
%t7215 = call ptr @resid_listbuf_push(ptr %p2, ptr %t7212)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__cg_le64(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7219, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7232, %tco.s0 ]
%t7217 = icmp sge i64 %p1, 8
br i1 %t7217, label %L739, label %L741
L739:
%t7218 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty7218)
ret ptr %t7218
L741:
%t7219 = add nsw i64 %p1, 1
%t7220 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p1)
%t7221 = extractvalue {i64, i1} %t7220, 0
%t7222 = extractvalue {i64, i1} %t7220, 1
%t7223 = zext i1 %t7222 to i8
call void @resid_overflow_check(i8 %t7223)
%t7224 = icmp uge i64 %t7221, 64
%t7225 = add i64 %t7221, 0
%t7226 = select i1 %t7224, i64 63, i64 %t7225
%t7227 = ashr i64 %p0, %t7226
%t7228 = and i64 %t7227, 255
%t7229 = call ptr @resid_box_i64(i64 %t7228)
%t7232 = call ptr @resid_listbuf_push(ptr %p2, ptr %t7229)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @chacha_block(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7234 = musttail call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
ret ptr %t7234
}
define ptr @chacha20_xor(ptr %p0, i64 %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7235 = musttail call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2, ptr %p3)
ret ptr %t7235
}
define ptr @poly1305(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7236 = musttail call ptr @poly1305g__g_Int_64__Int_512_(ptr %p0, ptr %p1)
ret ptr %t7236
}
define ptr @chacha20poly1305_seal(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7237 = musttail call ptr @chacha20poly1305g_seal__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
ret ptr %t7237
}
define i1 @chacha20poly1305_open(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7238 = call ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
%t7239 = getelementptr {i32, i32, ptr}, ptr %t7238, i32 0, i32 0
%t7240w = load i32, ptr %t7239
%t7240 = sext i32 %t7240w to i64
%t7241 = icmp eq i64 %t7240, 1
br i1 %t7241, label %L742, label %L743
L742:
%t7242 = getelementptr {i32, i32, ptr}, ptr %t7238, i32 1
%t7243 = getelementptr i8, ptr %t7242, i64 0
%t7244 = getelementptr ptr, ptr %t7243, i32 0
%t7245 = load ptr, ptr %t7244
br label %L744
L743:
br label %L744
L744:
%t7246 = phi i1 [ true, %L742 ], [ false, %L743 ]
ret i1 %t7246
}
define ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7247 = musttail call ptr @chacha20poly1305g_decrypt__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
ret ptr %t7247
}
define ptr @chacha20poly1305_open_bytes(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7248 = call ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
%t7249 = getelementptr {i32, i32, ptr}, ptr %t7248, i32 0, i32 0
%t7250w = load i32, ptr %t7249
%t7250 = sext i32 %t7250w to i64
%t7251 = icmp eq i64 %t7250, 1
br i1 %t7251, label %L745, label %L746
L746:
%t7253 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty7252)
br label %L747
L745:
%t7254 = getelementptr {i32, i32, ptr}, ptr %t7248, i32 1
%t7255 = getelementptr i8, ptr %t7254, i64 0
%t7256 = getelementptr ptr, ptr %t7255, i32 0
%t7257 = load ptr, ptr %t7256
br label %L747
L747:
%t7258 = phi ptr [ %t7253, %L746 ], [ %t7257, %L745 ]
ret ptr %t7258
}
define ptr @cbe_be(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7271 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7265, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t7259 = icmp sle i64 %p1, 0
br i1 %t7259, label %L748, label %L750
L748:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p2
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L750:
%t7260 = sub nsw i64 %p1, 1
%t7261 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t7260, i64 8)
%t7262 = extractvalue {i64, i1} %t7261, 0
%t7263 = extractvalue {i64, i1} %t7261, 1
%t7264 = zext i1 %t7263 to i8
call void @resid_overflow_check(i8 %t7264)
%t7265 = sub nsw i64 %p1, 1
%t7266 = icmp uge i64 %t7262, 64
%t7267 = add i64 %t7262, 0
%t7268 = select i1 %t7266, i64 63, i64 %t7267
%t7269 = ashr i64 %p0, %t7268
%t7270 = and i64 %t7269, 255
%t7273 = call ptr @resid_box_i64(i64 %t7270)
%t7275 = getelementptr i8, ptr %t7271, i64 0
store ptr %t7273, ptr %t7275
%t7276 = call ptr @resid_list_new(i64 1, ptr %t7271, ptr @.lty7271)
%t7277 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7276)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t7277, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t7277, %tco.s0 ]
br label %tco.head
}
define ptr @cbe_head(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7282 = alloca [1 x ptr]
%t7292 = alloca [2 x ptr]
%t7304 = alloca [1 x ptr]
%t7314 = alloca [1 x ptr]
%t7323 = alloca [1 x ptr]
%t7279 = shl i64 %p0, 5
%t7280 = icmp sle i64 %p1, 23
br i1 %t7280, label %L751, label %L753
L751:
%t7281 = or i64 %t7279, %p1
%t7284 = call ptr @resid_box_i64(i64 %t7281)
%t7286 = getelementptr i8, ptr %t7282, i64 0
store ptr %t7284, ptr %t7286
%t7287 = call ptr @resid_list_new(i64 1, ptr %t7282, ptr @.lty7282)
%t7288 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7287)
ret ptr %t7288
L753:
%t7289 = icmp sle i64 %p1, 255
br i1 %t7289, label %L754, label %L756
L754:
%t7290 = or i64 %t7279, 24
%t7291 = add nsw i64 %p1, 0
%t7294 = call ptr @resid_box_i64(i64 %t7290)
%t7296 = getelementptr i8, ptr %t7292, i64 0
store ptr %t7294, ptr %t7296
%t7297 = call ptr @resid_box_i64(i64 %t7291)
%t7299 = getelementptr i8, ptr %t7292, i64 8
store ptr %t7297, ptr %t7299
%t7300 = call ptr @resid_list_new(i64 2, ptr %t7292, ptr @.lty7292)
%t7301 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7300)
ret ptr %t7301
L756:
%t7302 = icmp sle i64 %p1, 65535
br i1 %t7302, label %L757, label %L759
L757:
%t7303 = or i64 %t7279, 25
%t7306 = call ptr @resid_box_i64(i64 %t7303)
%t7308 = getelementptr i8, ptr %t7304, i64 0
store ptr %t7306, ptr %t7308
%t7309 = call ptr @resid_list_new(i64 1, ptr %t7304, ptr @.lty7304)
%t7310 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7309)
%t7311 = musttail call ptr @cbe_be(i64 %p1, i64 2, ptr %t7310)
ret ptr %t7311
L759:
%t7312 = icmp sle i64 %p1, 4294967295
br i1 %t7312, label %L760, label %L762
L760:
%t7313 = or i64 %t7279, 26
%t7316 = call ptr @resid_box_i64(i64 %t7313)
%t7318 = getelementptr i8, ptr %t7314, i64 0
store ptr %t7316, ptr %t7318
%t7319 = call ptr @resid_list_new(i64 1, ptr %t7314, ptr @.lty7314)
%t7320 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7319)
%t7321 = musttail call ptr @cbe_be(i64 %p1, i64 4, ptr %t7320)
ret ptr %t7321
L762:
%t7322 = or i64 %t7279, 27
%t7325 = call ptr @resid_box_i64(i64 %t7322)
%t7327 = getelementptr i8, ptr %t7323, i64 0
store ptr %t7325, ptr %t7327
%t7328 = call ptr @resid_list_new(i64 1, ptr %t7323, ptr @.lty7323)
%t7329 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7328)
%t7330 = musttail call ptr @cbe_be(i64 %p1, i64 8, ptr %t7329)
ret ptr %t7330
}
define ptr @cbe_uint(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7331 = call ptr @cbe_head(i64 0, i64 %p0, ptr %p1)
ret ptr %t7331
}
define ptr @cbe_int(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7332 = icmp sge i64 %p0, 0
br i1 %t7332, label %L763, label %L765
L763:
%t7333 = call ptr @cbe_head(i64 0, i64 %p0, ptr %p1)
ret ptr %t7333
L765:
%t7334 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p0)
%t7335 = extractvalue {i64, i1} %t7334, 0
%t7336 = extractvalue {i64, i1} %t7334, 1
%t7337 = zext i1 %t7336 to i8
call void @resid_overflow_check(i8 %t7337)
%t7338 = sub nsw i64 %t7335, 1
%t7339 = call ptr @cbe_head(i64 1, i64 %t7338, ptr %p1)
ret ptr %t7339
}
define ptr @cbe_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7340 = call i64 @resid_list_len(ptr %p0)
%t7341 = call ptr @cbe_head(i64 2, i64 %t7340, ptr %p1)
%t7342 = call ptr @resid_list_concat_own(ptr %t7341, i8 1, ptr %p0)
ret ptr %t7342
}
define ptr @cbe_text(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7343 = call ptr @bytes_of(ptr %p0)
%t7344 = call ptr @resid_list_freeze(ptr %t7343)
%t7345 = call i64 @resid_list_len(ptr %t7344)
%t7346 = call ptr @cbe_head(i64 3, i64 %t7345, ptr %p1)
%t7347 = call ptr @resid_list_concat_own(ptr %t7346, i8 1, ptr %t7344)
ret ptr %t7347
}
define ptr @cbe_array(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7348 = call ptr @cbe_head(i64 4, i64 %p0, ptr %p1)
ret ptr %t7348
}
define ptr @cbe_map(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7349 = call ptr @cbe_head(i64 5, i64 %p0, ptr %p1)
ret ptr %t7349
}
define ptr @cbe_tag(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7350 = call ptr @cbe_head(i64 6, i64 %p0, ptr %p1)
ret ptr %t7350
}
define i64 @cbe_be_read(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7353, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t7356, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t7361, %tco.s0 ]
%t7351 = icmp sle i64 %p2, 0
br i1 %t7351, label %L766, label %L768
L766:
ret i64 %p3
L768:
%t7352 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t7353 = extractvalue {i64, i1} %t7352, 0
%t7354 = extractvalue {i64, i1} %t7352, 1
%t7355 = zext i1 %t7354 to i8
call void @resid_overflow_check(i8 %t7355)
%t7356 = sub nsw i64 %p2, 1
%t7357 = shl i64 %p3, 8
%t7358 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t7359 = call i64 @resid_unbox_i64(ptr %t7358)
%t7361 = or i64 %t7357, %t7359
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @cbe_read_head(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7363 = icmp slt i64 %p1, 0
br label %LSL7364
LSL7364:
br i1 %t7363, label %LSJ7364, label %LSR7364
LSR7364:
%t7365 = call i64 @resid_list_len(ptr %p0)
%t7366 = icmp sge i64 %p1, %t7365
br label %LSJ7364
LSJ7364:
%t7367 = phi i1 [ true, %LSL7364 ], [ %t7366, %LSR7364 ]
br i1 %t7367, label %L769, label %L771
L769:
%t7368 = call ptr @resid_gmalloc(i64 32)
%t7368.f0 = getelementptr i8, ptr %t7368, i64 0
store i1 false, ptr %t7368.f0, align 8
%t7368.f1 = getelementptr i8, ptr %t7368, i64 8
store i64 0, ptr %t7368.f1, align 8
%t7368.f2 = getelementptr i8, ptr %t7368, i64 16
store i64 0, ptr %t7368.f2, align 8
%t7368.f3 = getelementptr i8, ptr %t7368, i64 24
store i64 %p1, ptr %t7368.f3, align 8
ret ptr %t7368
L771:
%t7369 = call ptr @resid_list_get_nc(ptr %p0, i64 %p1)
%t7370 = call i64 @resid_unbox_i64(ptr %t7369)
%t7372 = ashr i64 %t7370, 5
%t7373 = and i64 %t7370, 31
%t7374 = icmp sle i64 %t7373, 23
br i1 %t7374, label %L772, label %L774
L772:
%t7375 = call ptr @resid_gmalloc(i64 32)
%t7375.f0 = getelementptr i8, ptr %t7375, i64 0
store i1 true, ptr %t7375.f0, align 8
%t7375.f1 = getelementptr i8, ptr %t7375, i64 8
store i64 %t7372, ptr %t7375.f1, align 8
%t7375.f2 = getelementptr i8, ptr %t7375, i64 16
store i64 %t7373, ptr %t7375.f2, align 8
%t7376 = add nsw i64 %p1, 1
%t7375.f3 = getelementptr i8, ptr %t7375, i64 24
store i64 %t7376, ptr %t7375.f3, align 8
ret ptr %t7375
L774:
%t7377 = call i64 @cbe_arg_len(i64 %t7373)
%t7378 = icmp eq i64 %t7377, 0
br i1 %t7378, label %L775, label %L777
L775:
%t7379 = call ptr @resid_gmalloc(i64 32)
%t7379.f0 = getelementptr i8, ptr %t7379, i64 0
store i1 false, ptr %t7379.f0, align 8
%t7379.f1 = getelementptr i8, ptr %t7379, i64 8
store i64 %t7372, ptr %t7379.f1, align 8
%t7379.f2 = getelementptr i8, ptr %t7379, i64 16
store i64 0, ptr %t7379.f2, align 8
%t7379.f3 = getelementptr i8, ptr %t7379, i64 24
store i64 %p1, ptr %t7379.f3, align 8
ret ptr %t7379
L777:
%t7380 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t7377)
%t7381 = extractvalue {i64, i1} %t7380, 0
%t7382 = extractvalue {i64, i1} %t7380, 1
%t7383 = zext i1 %t7382 to i8
call void @resid_overflow_check(i8 %t7383)
%t7384 = call i64 @resid_list_len(ptr %p0)
%t7385 = icmp sge i64 %t7381, %t7384
br i1 %t7385, label %L778, label %L780
L778:
%t7386 = call ptr @resid_gmalloc(i64 32)
%t7386.f0 = getelementptr i8, ptr %t7386, i64 0
store i1 false, ptr %t7386.f0, align 8
%t7386.f1 = getelementptr i8, ptr %t7386, i64 8
store i64 %t7372, ptr %t7386.f1, align 8
%t7386.f2 = getelementptr i8, ptr %t7386, i64 16
store i64 0, ptr %t7386.f2, align 8
%t7386.f3 = getelementptr i8, ptr %t7386, i64 24
store i64 %p1, ptr %t7386.f3, align 8
ret ptr %t7386
L780:
%t7387 = call ptr @resid_gmalloc(i64 32)
%t7387.f0 = getelementptr i8, ptr %t7387, i64 0
store i1 true, ptr %t7387.f0, align 8
%t7387.f1 = getelementptr i8, ptr %t7387, i64 8
store i64 %t7372, ptr %t7387.f1, align 8
%t7388 = add nsw i64 %p1, 1
%t7389 = call i64 @cbe_be_read(ptr %p0, i64 %t7388, i64 %t7377, i64 0)
%t7387.f2 = getelementptr i8, ptr %t7387, i64 16
store i64 %t7389, ptr %t7387.f2, align 8
%t7390 = add nsw i64 %p1, 1
%t7391 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7390, i64 %t7377)
%t7392 = extractvalue {i64, i1} %t7391, 0
%t7393 = extractvalue {i64, i1} %t7391, 1
%t7394 = zext i1 %t7393 to i8
call void @resid_overflow_check(i8 %t7394)
%t7387.f3 = getelementptr i8, ptr %t7387, i64 24
store i64 %t7392, ptr %t7387.f3, align 8
ret ptr %t7387
}
define i64 @cbe_arg_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7395 = icmp eq i64 %p0, 24
br i1 %t7395, label %L781, label %L783
L781:
ret i64 1
L783:
%t7396 = icmp eq i64 %p0, 25
br i1 %t7396, label %L784, label %L786
L784:
ret i64 2
L786:
%t7397 = icmp eq i64 %p0, 26
br i1 %t7397, label %L787, label %L789
L787:
ret i64 4
L789:
%t7398 = icmp eq i64 %p0, 27
br i1 %t7398, label %L790, label %L792
L790:
ret i64 8
L792:
ret i64 0
}
define ptr @cbe_read_str(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7399 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB7399)
%t7400 = call ptr @cbe_read_head(ptr %p0, i64 %p1)
%t7401 = getelementptr i8, ptr %t7400, i64 0
%t7402 = load i1, ptr %t7401, align 8
%t7403 = xor i1 %t7402, true
br label %LSL7404
LSL7404:
br i1 %t7403, label %LSJ7404, label %LSR7404
LSR7404:
%t7405 = getelementptr i8, ptr %t7400, i64 8
%t7406 = load i64, ptr %t7405, align 8
%t7407 = icmp ne i64 %t7406, %p2
br label %LSJ7404
LSJ7404:
%t7408 = phi i1 [ true, %LSL7404 ], [ %t7407, %LSR7404 ]
br label %LSL7409
LSL7409:
br i1 %t7408, label %LSJ7409, label %LSR7409
LSR7409:
%t7410 = getelementptr i8, ptr %t7400, i64 16
%t7411 = load i64, ptr %t7410, align 8
%t7412 = icmp slt i64 %t7411, 0
br label %LSJ7409
LSJ7409:
%t7413 = phi i1 [ true, %LSL7409 ], [ %t7412, %LSR7409 ]
br label %LSL7414
LSL7414:
br i1 %t7413, label %LSJ7414, label %LSR7414
LSR7414:
%t7415 = getelementptr i8, ptr %t7400, i64 16
%t7416 = load i64, ptr %t7415, align 8
%t7417 = call i64 @resid_list_len(ptr %p0)
%t7418 = getelementptr i8, ptr %t7400, i64 24
%t7419 = load i64, ptr %t7418, align 8
%t7420 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7417, i64 %t7419)
%t7421 = extractvalue {i64, i1} %t7420, 0
%t7422 = extractvalue {i64, i1} %t7420, 1
%t7423 = zext i1 %t7422 to i8
call void @resid_overflow_check(i8 %t7423)
%t7424 = icmp sgt i64 %t7416, %t7421
br label %LSJ7414
LSJ7414:
%t7425 = phi i1 [ true, %LSL7414 ], [ %t7424, %LSR7414 ]
br i1 %t7425, label %L793, label %L795
L793:
%t7426 = call ptr @resid_gmalloc(i64 24)
%t7426.f0 = getelementptr i8, ptr %t7426, i64 0
store i1 false, ptr %t7426.f0, align 8
%t7426.f1 = getelementptr i8, ptr %t7426, i64 8
store ptr %t7399, ptr %t7426.f1, align 8
%t7426.f2 = getelementptr i8, ptr %t7426, i64 16
store i64 %p1, ptr %t7426.f2, align 8
ret ptr %t7426
L795:
%t7427 = getelementptr i8, ptr %t7400, i64 24
%t7428 = load i64, ptr %t7427, align 8
%t7429 = getelementptr i8, ptr %t7400, i64 16
%t7430 = load i64, ptr %t7429, align 8
%t7431 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7428, i64 %t7430)
%t7432 = extractvalue {i64, i1} %t7431, 0
%t7433 = extractvalue {i64, i1} %t7431, 1
%t7434 = zext i1 %t7433 to i8
call void @resid_overflow_check(i8 %t7434)
%t7435 = call ptr @resid_gmalloc(i64 24)
%t7435.f0 = getelementptr i8, ptr %t7435, i64 0
store i1 true, ptr %t7435.f0, align 8
%t7436 = getelementptr i8, ptr %t7400, i64 24
%t7437 = load i64, ptr %t7436, align 8
%t7438 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7432, i64 1)
%t7439 = extractvalue {i64, i1} %t7438, 0
%t7440 = extractvalue {i64, i1} %t7438, 1
%t7441 = zext i1 %t7440 to i8
call void @resid_overflow_check(i8 %t7441)
%t7442 = call ptr @slice_bytes(ptr %p0, i64 %t7437, i64 %t7439)
%t7435.f1 = getelementptr i8, ptr %t7435, i64 8
store ptr %t7442, ptr %t7435.f1, align 8
%t7435.f2 = getelementptr i8, ptr %t7435, i64 16
store i64 %t7432, ptr %t7435.f2, align 8
ret ptr %t7435
}
define ptr @cbe_ascii__sacc(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7445, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7450, %tco.s0 ]
%t7443 = call i64 @resid_list_len(ptr %p0)
%t7444 = icmp sge i64 %p1, %t7443
br i1 %t7444, label %L796, label %L798
L796:
ret ptr %p2
L798:
%t7445 = add nsw i64 %p1, 1
%t7446 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t7447 = call i64 @resid_unbox_i64(ptr %t7446)
%t7449 = call ptr @str_from_code(i64 %t7447)
%t7450 = call ptr @resid_sacc_append(ptr %p2, ptr %t7449)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @cose_nibble(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7452 = icmp sge i64 %p0, 48
br label %LSL7453
LSL7453:
br i1 %t7452, label %LSR7453, label %LSJ7453
LSR7453:
%t7454 = icmp sle i64 %p0, 57
br label %LSJ7453
LSJ7453:
%t7455 = phi i1 [ false, %LSL7453 ], [ %t7454, %LSR7453 ]
br i1 %t7455, label %L799, label %L801
L799:
%t7456 = sub nsw i64 %p0, 48
ret i64 %t7456
L801:
%t7457 = icmp sge i64 %p0, 97
br label %LSL7458
LSL7458:
br i1 %t7457, label %LSR7458, label %LSJ7458
LSR7458:
%t7459 = icmp sle i64 %p0, 102
br label %LSJ7458
LSJ7458:
%t7460 = phi i1 [ false, %LSL7458 ], [ %t7459, %LSR7458 ]
br i1 %t7460, label %L802, label %L804
L802:
%t7461 = sub nsw i64 %p0, 87
ret i64 %t7461
L804:
%t7462 = icmp sge i64 %p0, 65
br label %LSL7463
LSL7463:
br i1 %t7462, label %LSR7463, label %LSJ7463
LSR7463:
%t7464 = icmp sle i64 %p0, 70
br label %LSJ7463
LSJ7463:
%t7465 = phi i1 [ false, %LSL7463 ], [ %t7464, %LSR7463 ]
br i1 %t7465, label %L805, label %L807
L805:
%t7466 = sub nsw i64 %p0, 55
ret i64 %t7466
L807:
ret i64 0
}
define ptr @cose_hex_acc(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7492 = alloca [1 x ptr]
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7489, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t7467 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t7468 = extractvalue {i64, i1} %t7467, 0
%t7469 = extractvalue {i64, i1} %t7467, 1
%t7470 = zext i1 %t7469 to i8
call void @resid_overflow_check(i8 %t7470)
%t7471 = icmp sge i64 %t7468, %p2
br i1 %t7471, label %L808, label %L810
L808:
%lr.cx18 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz18 = icmp eq ptr %lr.cx18, null
br i1 %lr.lz18, label %lr.x18.k, label %lr.x18.m
lr.x18.k:
ret ptr %p3
lr.x18.m:
%lr.ret18 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx18)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret18
L810:
%t7472 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t7473 = call i64 @cose_nibble(i64 %t7472)
%t7474 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t7473, i64 16)
%t7475 = extractvalue {i64, i1} %t7474, 0
%t7476 = extractvalue {i64, i1} %t7474, 1
%t7477 = zext i1 %t7476 to i8
call void @resid_overflow_check(i8 %t7477)
%t7478 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t7479 = extractvalue {i64, i1} %t7478, 0
%t7480 = extractvalue {i64, i1} %t7478, 1
%t7481 = zext i1 %t7480 to i8
call void @resid_overflow_check(i8 %t7481)
%t7482 = call i64 @resid_char_at_n(ptr %p0, i64 %t7479, i64 %p0.alen)
%t7483 = call i64 @cose_nibble(i64 %t7482)
%t7484 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7475, i64 %t7483)
%t7485 = extractvalue {i64, i1} %t7484, 0
%t7486 = extractvalue {i64, i1} %t7484, 1
%t7487 = zext i1 %t7486 to i8
call void @resid_overflow_check(i8 %t7487)
%t7488 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t7489 = extractvalue {i64, i1} %t7488, 0
%t7490 = extractvalue {i64, i1} %t7488, 1
%t7491 = zext i1 %t7490 to i8
call void @resid_overflow_check(i8 %t7491)
%t7494 = call ptr @resid_box_i64(i64 %t7485)
%t7496 = getelementptr i8, ptr %t7492, i64 0
store ptr %t7494, ptr %t7496
%t7497 = call ptr @resid_list_new(i64 1, ptr %t7492, ptr @.lty7492)
%t7498 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t7497)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t7498, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t7498, %tco.s0 ]
br label %tco.head
}
define ptr @cose_hex_decode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7500 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB7500)
%t7501 = call i64 @str_len(ptr %p0)
%t7502 = call ptr @cose_hex_acc(ptr %p0, i64 0, i64 %t7501, ptr %t7500)
ret ptr %t7502
}
define ptr @cose_sig_structure(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7504 = call ptr @resid_list_const_i64(ptr @.lc7503, i64 12, ptr @.lcd7503, ptr @.lty7503)
%t7505 = call ptr @cbe_bytes(ptr %p0, ptr %t7504)
%t7507 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty7506)
%t7508 = call ptr @cbe_bytes(ptr %t7507, ptr %t7505)
%t7509 = musttail call ptr @cbe_bytes(ptr %p1, ptr %t7508)
ret ptr %t7509
}
define ptr @cose_sign1_protected(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7510 = call ptr @bytes_of(ptr %p0)
%t7511 = call ptr @resid_list_freeze(ptr %t7510)
%t7513 = call ptr @resid_list_const_i64(ptr @.lc7512, i64 4, ptr @.lcd7512, ptr @.lty7512)
%t7514 = call ptr @cbe_bytes(ptr %t7511, ptr %t7513)
ret ptr %t7514
}
define ptr @cose_sign1_err(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7515 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB7515)
%t7516 = call ptr @resid_gmalloc(i64 48)
%t7516.f0 = getelementptr i8, ptr %t7516, i64 0
store i1 false, ptr %t7516.f0, align 8
%t7516.f1 = getelementptr i8, ptr %t7516, i64 8
store ptr %p0, ptr %t7516.f1, align 8
%t7516.f2 = getelementptr i8, ptr %t7516, i64 16
store ptr @.s7517, ptr %t7516.f2, align 8
%t7516.f3 = getelementptr i8, ptr %t7516, i64 24
store ptr %t7515, ptr %t7516.f3, align 8
%t7516.f4 = getelementptr i8, ptr %t7516, i64 32
store ptr %t7515, ptr %t7516.f4, align 8
%t7516.f5 = getelementptr i8, ptr %t7516, i64 40
store ptr %t7515, ptr %t7516.f5, align 8
ret ptr %t7516
}
define ptr @cose_kid_of(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7518 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t7519 = getelementptr i8, ptr %t7518, i64 0
%t7520 = load i1, ptr %t7519, align 8
%t7521 = xor i1 %t7520, true
br label %LSL7522
LSL7522:
br i1 %t7521, label %LSJ7522, label %LSR7522
LSR7522:
%t7523 = getelementptr i8, ptr %t7518, i64 8
%t7524 = load i64, ptr %t7523, align 8
%t7525 = icmp ne i64 %t7524, 5
br label %LSJ7522
LSJ7522:
%t7526 = phi i1 [ true, %LSL7522 ], [ %t7525, %LSR7522 ]
br i1 %t7526, label %L811, label %L813
L811:
ret ptr @.s7527
L813:
%t7528 = getelementptr i8, ptr %t7518, i64 24
%t7529 = load i64, ptr %t7528, align 8
%t7530 = getelementptr i8, ptr %t7518, i64 16
%t7531 = load i64, ptr %t7530, align 8
%t7532 = call ptr @cose_kid_scan(ptr %p0, i64 %t7529, i64 %t7531)
ret ptr %t7532
}
define ptr @cose_kid_scan(ptr %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7611, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t7612, %tco.s0.k ]
%t7533 = icmp sle i64 %p2, 0
br i1 %t7533, label %L814, label %L816
L814:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr @.s7534
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_str(ptr @.s7534, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L816:
%t7535 = call ptr @cbe_read_head(ptr %p0, i64 %p1)
%t7536 = getelementptr i8, ptr %t7535, i64 0
%t7537 = load i1, ptr %t7536, align 8
%t7538 = xor i1 %t7537, true
br i1 %t7538, label %L817, label %L819
L817:
%lr.cx18 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz18 = icmp eq ptr %lr.cx18, null
br i1 %lr.lz18, label %lr.x18.k, label %lr.x18.m
lr.x18.k:
ret ptr @.s7539
lr.x18.m:
%lr.ret18 = call ptr @resid_mv_str(ptr @.s7539, ptr %lr.cx18)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret18
L819:
%t7540 = getelementptr i8, ptr %t7535, i64 24
%t7541 = load i64, ptr %t7540, align 8
%t7542 = call ptr @cbe_read_head(ptr %p0, i64 %t7541)
%t7543 = getelementptr i8, ptr %t7542, i64 0
%t7544 = load i1, ptr %t7543, align 8
%t7545 = xor i1 %t7544, true
br i1 %t7545, label %L820, label %L822
L820:
%lr.cx28 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz28 = icmp eq ptr %lr.cx28, null
br i1 %lr.lz28, label %lr.x28.k, label %lr.x28.m
lr.x28.k:
ret ptr @.s7546
lr.x28.m:
%lr.ret28 = call ptr @resid_mv_str(ptr @.s7546, ptr %lr.cx28)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret28
L822:
%t7547 = getelementptr i8, ptr %t7535, i64 8
%t7548 = load i64, ptr %t7547, align 8
%t7549 = icmp eq i64 %t7548, 0
br label %LSL7550
LSL7550:
br i1 %t7549, label %LSR7550, label %LSJ7550
LSR7550:
%t7551 = getelementptr i8, ptr %t7535, i64 16
%t7552 = load i64, ptr %t7551, align 8
%t7553 = icmp eq i64 %t7552, 4
br label %LSJ7550
LSJ7550:
%t7554 = phi i1 [ false, %LSL7550 ], [ %t7553, %LSR7550 ]
br label %LSL7555
LSL7555:
br i1 %t7554, label %LSR7555, label %LSJ7555
LSR7555:
%t7556 = getelementptr i8, ptr %t7542, i64 8
%t7557 = load i64, ptr %t7556, align 8
%t7558 = icmp eq i64 %t7557, 2
br label %LSJ7555
LSJ7555:
%t7559 = phi i1 [ false, %LSL7555 ], [ %t7558, %LSR7555 ]
br i1 %t7559, label %L823, label %L825
L823:
%t7560 = getelementptr i8, ptr %t7535, i64 24
%t7561 = load i64, ptr %t7560, align 8
%t7562 = call ptr @cbe_read_str(ptr %p0, i64 %t7561, i64 2)
%t7563 = getelementptr i8, ptr %t7562, i64 8
%t7564 = load ptr, ptr %t7563, align 8
%t7566 = call ptr @cbe_ascii(ptr %t7564, i64 0, ptr @.s7565)
%lr.cx61 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz61 = icmp eq ptr %lr.cx61, null
br i1 %lr.lz61, label %lr.x61.k, label %lr.x61.m
lr.x61.k:
ret ptr %t7566
lr.x61.m:
%lr.ret61 = call ptr @resid_mv_str(ptr %t7566, ptr %lr.cx61)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret61
L825:
%t7567 = getelementptr i8, ptr %t7542, i64 8
%t7568 = load i64, ptr %t7567, align 8
%t7569 = icmp eq i64 %t7568, 2
br label %LSL7570
LSL7570:
br i1 %t7569, label %LSJ7570, label %LSR7570
LSR7570:
%t7571 = getelementptr i8, ptr %t7542, i64 8
%t7572 = load i64, ptr %t7571, align 8
%t7573 = icmp eq i64 %t7572, 3
br label %LSJ7570
LSJ7570:
%t7574 = phi i1 [ true, %LSL7570 ], [ %t7573, %LSR7570 ]
br label %LSL7575
LSL7575:
br i1 %t7574, label %LSR7575, label %LSJ7575
LSR7575:
%t7576 = getelementptr i8, ptr %t7542, i64 16
%t7577 = load i64, ptr %t7576, align 8
%t7578 = icmp slt i64 %t7577, 0
br label %LSL7579
LSL7579:
br i1 %t7578, label %LSJ7579, label %LSR7579
LSR7579:
%t7580 = getelementptr i8, ptr %t7542, i64 16
%t7581 = load i64, ptr %t7580, align 8
%t7582 = call i64 @resid_list_len(ptr %p0)
%t7583 = getelementptr i8, ptr %t7542, i64 24
%t7584 = load i64, ptr %t7583, align 8
%t7585 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7582, i64 %t7584)
%t7586 = extractvalue {i64, i1} %t7585, 0
%t7587 = extractvalue {i64, i1} %t7585, 1
%t7588 = zext i1 %t7587 to i8
call void @resid_overflow_check(i8 %t7588)
%t7589 = icmp sgt i64 %t7581, %t7586
br label %LSJ7579
LSJ7579:
%t7590 = phi i1 [ true, %LSL7579 ], [ %t7589, %LSR7579 ]
br label %LSJ7575
LSJ7575:
%t7591 = phi i1 [ false, %LSL7575 ], [ %t7590, %LSJ7579 ]
br i1 %t7591, label %L826, label %L828
L826:
%lr.cx106 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz106 = icmp eq ptr %lr.cx106, null
br i1 %lr.lz106, label %lr.x106.k, label %lr.x106.m
lr.x106.k:
ret ptr @.s7592
lr.x106.m:
%lr.ret106 = call ptr @resid_mv_str(ptr @.s7592, ptr %lr.cx106)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret106
L828:
%t7593 = getelementptr i8, ptr %t7542, i64 8
%t7594 = load i64, ptr %t7593, align 8
%t7595 = icmp eq i64 %t7594, 2
br label %LSL7596
LSL7596:
br i1 %t7595, label %LSJ7596, label %LSR7596
LSR7596:
%t7597 = getelementptr i8, ptr %t7542, i64 8
%t7598 = load i64, ptr %t7597, align 8
%t7599 = icmp eq i64 %t7598, 3
br label %LSJ7596
LSJ7596:
%t7600 = phi i1 [ true, %LSL7596 ], [ %t7599, %LSR7596 ]
br i1 %t7600, label %L829, label %L830
L829:
%t7601 = getelementptr i8, ptr %t7542, i64 24
%t7602 = load i64, ptr %t7601, align 8
%t7603 = getelementptr i8, ptr %t7542, i64 16
%t7604 = load i64, ptr %t7603, align 8
%t7605 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7602, i64 %t7604)
%t7606 = extractvalue {i64, i1} %t7605, 0
%t7607 = extractvalue {i64, i1} %t7605, 1
%t7608 = zext i1 %t7607 to i8
call void @resid_overflow_check(i8 %t7608)
br label %L831
L830:
%t7609 = getelementptr i8, ptr %t7542, i64 24
%t7610 = load i64, ptr %t7609, align 8
br label %L831
L831:
%t7611 = phi i64 [ %t7606, %L829 ], [ %t7610, %L830 ]
%t7612 = sub nsw i64 %p2, 1
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
%t7614 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t7615 = getelementptr i8, ptr %t7614, i64 0
%t7616 = load i1, ptr %t7615, align 8
%t7617 = xor i1 %t7616, true
br label %LSL7618
LSL7618:
br i1 %t7617, label %LSJ7618, label %LSR7618
LSR7618:
%t7619 = getelementptr i8, ptr %t7614, i64 8
%t7620 = load i64, ptr %t7619, align 8
%t7621 = icmp ne i64 %t7620, 6
br label %LSJ7618
LSJ7618:
%t7622 = phi i1 [ true, %LSL7618 ], [ %t7621, %LSR7618 ]
br label %LSL7623
LSL7623:
br i1 %t7622, label %LSJ7623, label %LSR7623
LSR7623:
%t7624 = getelementptr i8, ptr %t7614, i64 16
%t7625 = load i64, ptr %t7624, align 8
%t7626 = icmp ne i64 %t7625, 18
br label %LSJ7623
LSJ7623:
%t7627 = phi i1 [ true, %LSL7623 ], [ %t7626, %LSR7623 ]
br i1 %t7627, label %L832, label %L834
L832:
%t7629 = musttail call ptr @cose_sign1_err(ptr @.s7628)
ret ptr %t7629
L834:
%t7630 = getelementptr i8, ptr %t7614, i64 24
%t7631 = load i64, ptr %t7630, align 8
%t7632 = call ptr @cbe_read_head(ptr %p0, i64 %t7631)
%t7633 = getelementptr i8, ptr %t7632, i64 0
%t7634 = load i1, ptr %t7633, align 8
%t7635 = xor i1 %t7634, true
br label %LSL7636
LSL7636:
br i1 %t7635, label %LSJ7636, label %LSR7636
LSR7636:
%t7637 = getelementptr i8, ptr %t7632, i64 8
%t7638 = load i64, ptr %t7637, align 8
%t7639 = icmp ne i64 %t7638, 4
br label %LSJ7636
LSJ7636:
%t7640 = phi i1 [ true, %LSL7636 ], [ %t7639, %LSR7636 ]
br label %LSL7641
LSL7641:
br i1 %t7640, label %LSJ7641, label %LSR7641
LSR7641:
%t7642 = getelementptr i8, ptr %t7632, i64 16
%t7643 = load i64, ptr %t7642, align 8
%t7644 = icmp ne i64 %t7643, 4
br label %LSJ7641
LSJ7641:
%t7645 = phi i1 [ true, %LSL7641 ], [ %t7644, %LSR7641 ]
br i1 %t7645, label %L835, label %L837
L835:
%t7647 = musttail call ptr @cose_sign1_err(ptr @.s7646)
ret ptr %t7647
L837:
%t7648 = getelementptr i8, ptr %t7632, i64 24
%t7649 = load i64, ptr %t7648, align 8
%t7650 = call ptr @cbe_read_str(ptr %p0, i64 %t7649, i64 2)
%t7651 = getelementptr i8, ptr %t7650, i64 0
%t7652 = load i1, ptr %t7651, align 8
%t7653 = xor i1 %t7652, true
br i1 %t7653, label %L838, label %L840
L838:
%t7655 = musttail call ptr @cose_sign1_err(ptr @.s7654)
ret ptr %t7655
L840:
%t7656 = getelementptr i8, ptr %t7650, i64 16
%t7657 = load i64, ptr %t7656, align 8
%t7658 = call ptr @cbe_read_head(ptr %p0, i64 %t7657)
%t7659 = getelementptr i8, ptr %t7658, i64 0
%t7660 = load i1, ptr %t7659, align 8
%t7661 = xor i1 %t7660, true
br label %LSL7662
LSL7662:
br i1 %t7661, label %LSJ7662, label %LSR7662
LSR7662:
%t7663 = getelementptr i8, ptr %t7658, i64 8
%t7664 = load i64, ptr %t7663, align 8
%t7665 = icmp ne i64 %t7664, 5
br label %LSJ7662
LSJ7662:
%t7666 = phi i1 [ true, %LSL7662 ], [ %t7665, %LSR7662 ]
br label %LSL7667
LSL7667:
br i1 %t7666, label %LSJ7667, label %LSR7667
LSR7667:
%t7668 = getelementptr i8, ptr %t7658, i64 16
%t7669 = load i64, ptr %t7668, align 8
%t7670 = icmp ne i64 %t7669, 0
br label %LSJ7667
LSJ7667:
%t7671 = phi i1 [ true, %LSL7667 ], [ %t7670, %LSR7667 ]
br i1 %t7671, label %L841, label %L843
L841:
%t7673 = musttail call ptr @cose_sign1_err(ptr @.s7672)
ret ptr %t7673
L843:
%t7674 = getelementptr i8, ptr %t7658, i64 24
%t7675 = load i64, ptr %t7674, align 8
%t7676 = call ptr @cbe_read_str(ptr %p0, i64 %t7675, i64 2)
%t7677 = getelementptr i8, ptr %t7676, i64 0
%t7678 = load i1, ptr %t7677, align 8
%t7679 = xor i1 %t7678, true
br i1 %t7679, label %L844, label %L846
L844:
%t7681 = musttail call ptr @cose_sign1_err(ptr @.s7680)
ret ptr %t7681
L846:
%t7682 = getelementptr i8, ptr %t7676, i64 16
%t7683 = load i64, ptr %t7682, align 8
%t7684 = call ptr @cbe_read_str(ptr %p0, i64 %t7683, i64 2)
%t7685 = getelementptr i8, ptr %t7684, i64 0
%t7686 = load i1, ptr %t7685, align 8
%t7687 = xor i1 %t7686, true
br label %LSL7688
LSL7688:
br i1 %t7687, label %LSJ7688, label %LSR7688
LSR7688:
%t7689 = getelementptr i8, ptr %t7684, i64 8
%t7690 = load ptr, ptr %t7689, align 8
%t7691 = call i64 @resid_list_len(ptr %t7690)
%t7692 = icmp ne i64 %t7691, 64
br label %LSJ7688
LSJ7688:
%t7693 = phi i1 [ true, %LSL7688 ], [ %t7692, %LSR7688 ]
br i1 %t7693, label %L847, label %L849
L847:
%t7695 = musttail call ptr @cose_sign1_err(ptr @.s7694)
ret ptr %t7695
L849:
%t7696 = call ptr @resid_gmalloc(i64 48)
%t7696.f0 = getelementptr i8, ptr %t7696, i64 0
store i1 true, ptr %t7696.f0, align 8
%t7696.f1 = getelementptr i8, ptr %t7696, i64 8
store ptr @.s7697, ptr %t7696.f1, align 8
%t7698 = getelementptr i8, ptr %t7650, i64 8
%t7699 = load ptr, ptr %t7698, align 8
%t7700 = call ptr @cose_kid_of(ptr %t7699)
%t7696.f2 = getelementptr i8, ptr %t7696, i64 16
store ptr %t7700, ptr %t7696.f2, align 8
%t7701 = getelementptr i8, ptr %t7650, i64 8
%t7702 = load ptr, ptr %t7701, align 8
%t7696.f3 = getelementptr i8, ptr %t7696, i64 24
store ptr %t7702, ptr %t7696.f3, align 8
%t7703 = getelementptr i8, ptr %t7676, i64 8
%t7704 = load ptr, ptr %t7703, align 8
%t7696.f4 = getelementptr i8, ptr %t7696, i64 32
store ptr %t7704, ptr %t7696.f4, align 8
%t7705 = getelementptr i8, ptr %t7684, i64 8
%t7706 = load ptr, ptr %t7705, align 8
%t7696.f5 = getelementptr i8, ptr %t7696, i64 40
store ptr %t7706, ptr %t7696.f5, align 8
ret ptr %t7696
}
define i1 @cose_sign1_check(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7707 = getelementptr i8, ptr %p0, i64 24
%t7708 = load ptr, ptr %t7707, align 8
%t7709 = getelementptr i8, ptr %p0, i64 32
%t7710 = load ptr, ptr %t7709, align 8
%t7711 = call ptr @cose_sig_structure(ptr %t7708, ptr %t7710)
%t7712 = call ptr @resid_list_freeze(ptr %t7711)
%t7713 = getelementptr i8, ptr %p0, i64 40
%t7714 = load ptr, ptr %t7713, align 8
%t7715 = call i1 @verify_sig_bytes(ptr %t7712, ptr %t7714, ptr %p1)
ret i1 %t7715
}
define ptr @cose_enc_structure(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7717 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty7716)
%t7719 = call ptr @resid_list_const_i64(ptr @.lc7718, i64 10, ptr @.lcd7718, ptr @.lty7718)
%t7720 = call ptr @cbe_bytes(ptr %p0, ptr %t7719)
%t7721 = call ptr @cbe_bytes(ptr %t7717, ptr %t7720)
ret ptr %t7721
}
define ptr @cose_encrypt0_protected() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7723 = call ptr @resid_list_const_i64(ptr @.lc7722, i64 4, ptr @.lcd7722, ptr @.lty7722)
ret ptr %t7723
}
define ptr @cose_encrypt0_nonce(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7725 = call ptr @resid_list_const_i64(ptr @.lc7724, i64 25, ptr @.lcd7724, ptr @.lty7724)
%t7726 = call ptr @resid_list_concat(ptr %t7725, ptr %p0)
%t7727 = call ptr @bytes_of(ptr %p1)
%t7728 = call ptr @resid_list_freeze(ptr %t7727)
%t7729 = call ptr @resid_list_concat_own(ptr %t7726, i8 1, ptr %t7728)
%t7730 = call ptr @resid_list_concat_own(ptr %t7729, i8 1, ptr %p2)
%t7731 = call ptr @sha256_bytes(ptr %t7730)
%t7732 = call ptr @slice_bytes(ptr %t7731, i64 0, i64 11)
ret ptr %t7732
}
define ptr @cose_encrypt0_seal(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7733 = call ptr @cose_encrypt0_nonce(ptr %p1, ptr %p2, ptr %p0)
%t7734 = call ptr @resid_list_freeze(ptr %t7733)
%t7736 = call ptr @resid_list_const_i64(ptr @.lc7735, i64 16, ptr @.lcd7735, ptr @.lty7735)
%t7737 = call ptr @chacha20poly1305_seal(ptr %p1, ptr %t7734, ptr %p0, ptr %t7736)
%t7738 = call ptr @resid_list_freeze(ptr %t7737)
%t7740 = call ptr @resid_list_const_i64(ptr @.lc7739, i64 9, ptr @.lcd7739, ptr @.lty7739)
%t7741 = call ptr @cbe_bytes(ptr %t7734, ptr %t7740)
%t7742 = call ptr @cbe_bytes(ptr %t7738, ptr %t7741)
ret ptr %t7742
}
define ptr @cose_open_err(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7743 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB7743)
%t7744 = call ptr @resid_gmalloc(i64 24)
%t7744.f0 = getelementptr i8, ptr %t7744, i64 0
store i1 false, ptr %t7744.f0, align 8
%t7744.f1 = getelementptr i8, ptr %t7744, i64 8
store ptr %p0, ptr %t7744.f1, align 8
%t7744.f2 = getelementptr i8, ptr %t7744, i64 16
store ptr %t7743, ptr %t7744.f2, align 8
ret ptr %t7744
}
define i1 @cose_is_encrypt0(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7745 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t7746 = getelementptr i8, ptr %t7745, i64 0
%t7747 = load i1, ptr %t7746, align 8
br label %LSL7748
LSL7748:
br i1 %t7747, label %LSR7748, label %LSJ7748
LSR7748:
%t7749 = getelementptr i8, ptr %t7745, i64 8
%t7750 = load i64, ptr %t7749, align 8
%t7751 = icmp eq i64 %t7750, 6
br label %LSJ7748
LSJ7748:
%t7752 = phi i1 [ false, %LSL7748 ], [ %t7751, %LSR7748 ]
br label %LSL7753
LSL7753:
br i1 %t7752, label %LSR7753, label %LSJ7753
LSR7753:
%t7754 = getelementptr i8, ptr %t7745, i64 16
%t7755 = load i64, ptr %t7754, align 8
%t7756 = icmp eq i64 %t7755, 16
br label %LSJ7753
LSJ7753:
%t7757 = phi i1 [ false, %LSL7753 ], [ %t7756, %LSR7753 ]
ret i1 %t7757
}
define ptr @cose_encrypt0_open(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7758 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t7759 = getelementptr i8, ptr %t7758, i64 0
%t7760 = load i1, ptr %t7759, align 8
%t7761 = xor i1 %t7760, true
br label %LSL7762
LSL7762:
br i1 %t7761, label %LSJ7762, label %LSR7762
LSR7762:
%t7763 = getelementptr i8, ptr %t7758, i64 8
%t7764 = load i64, ptr %t7763, align 8
%t7765 = icmp ne i64 %t7764, 6
br label %LSJ7762
LSJ7762:
%t7766 = phi i1 [ true, %LSL7762 ], [ %t7765, %LSR7762 ]
br label %LSL7767
LSL7767:
br i1 %t7766, label %LSJ7767, label %LSR7767
LSR7767:
%t7768 = getelementptr i8, ptr %t7758, i64 16
%t7769 = load i64, ptr %t7768, align 8
%t7770 = icmp ne i64 %t7769, 16
br label %LSJ7767
LSJ7767:
%t7771 = phi i1 [ true, %LSL7767 ], [ %t7770, %LSR7767 ]
br i1 %t7771, label %L850, label %L852
L850:
%t7773 = call ptr @cose_open_err(ptr @.s7772)
ret ptr %t7773
L852:
%t7774 = getelementptr i8, ptr %t7758, i64 24
%t7775 = load i64, ptr %t7774, align 8
%t7776 = call ptr @cbe_read_head(ptr %p0, i64 %t7775)
%t7777 = getelementptr i8, ptr %t7776, i64 0
%t7778 = load i1, ptr %t7777, align 8
%t7779 = xor i1 %t7778, true
br label %LSL7780
LSL7780:
br i1 %t7779, label %LSJ7780, label %LSR7780
LSR7780:
%t7781 = getelementptr i8, ptr %t7776, i64 8
%t7782 = load i64, ptr %t7781, align 8
%t7783 = icmp ne i64 %t7782, 4
br label %LSJ7780
LSJ7780:
%t7784 = phi i1 [ true, %LSL7780 ], [ %t7783, %LSR7780 ]
br label %LSL7785
LSL7785:
br i1 %t7784, label %LSJ7785, label %LSR7785
LSR7785:
%t7786 = getelementptr i8, ptr %t7776, i64 16
%t7787 = load i64, ptr %t7786, align 8
%t7788 = icmp ne i64 %t7787, 3
br label %LSJ7785
LSJ7785:
%t7789 = phi i1 [ true, %LSL7785 ], [ %t7788, %LSR7785 ]
br i1 %t7789, label %L853, label %L855
L853:
%t7791 = call ptr @cose_open_err(ptr @.s7790)
ret ptr %t7791
L855:
%t7792 = getelementptr i8, ptr %t7776, i64 24
%t7793 = load i64, ptr %t7792, align 8
%t7794 = call ptr @cbe_read_str(ptr %p0, i64 %t7793, i64 2)
call void @"resid.rec.freeze.CbeStr"(ptr %t7794)
%t7795 = getelementptr i8, ptr %t7794, i64 0
%t7796 = load i1, ptr %t7795, align 8
%t7797 = xor i1 %t7796, true
br i1 %t7797, label %L856, label %L858
L856:
%t7799 = call ptr @cose_open_err(ptr @.s7798)
ret ptr %t7799
L858:
%t7800 = getelementptr i8, ptr %t7794, i64 16
%t7801 = load i64, ptr %t7800, align 8
%t7802 = call ptr @cbe_read_head(ptr %p0, i64 %t7801)
%t7803 = getelementptr i8, ptr %t7802, i64 0
%t7804 = load i1, ptr %t7803, align 8
%t7805 = xor i1 %t7804, true
br label %LSL7806
LSL7806:
br i1 %t7805, label %LSJ7806, label %LSR7806
LSR7806:
%t7807 = getelementptr i8, ptr %t7802, i64 8
%t7808 = load i64, ptr %t7807, align 8
%t7809 = icmp ne i64 %t7808, 5
br label %LSJ7806
LSJ7806:
%t7810 = phi i1 [ true, %LSL7806 ], [ %t7809, %LSR7806 ]
br label %LSL7811
LSL7811:
br i1 %t7810, label %LSJ7811, label %LSR7811
LSR7811:
%t7812 = getelementptr i8, ptr %t7802, i64 16
%t7813 = load i64, ptr %t7812, align 8
%t7814 = icmp ne i64 %t7813, 1
br label %LSJ7811
LSJ7811:
%t7815 = phi i1 [ true, %LSL7811 ], [ %t7814, %LSR7811 ]
br i1 %t7815, label %L859, label %L861
L859:
%t7817 = call ptr @cose_open_err(ptr @.s7816)
ret ptr %t7817
L861:
%t7818 = getelementptr i8, ptr %t7802, i64 24
%t7819 = load i64, ptr %t7818, align 8
%t7820 = call ptr @cbe_read_head(ptr %p0, i64 %t7819)
%t7821 = getelementptr i8, ptr %t7820, i64 0
%t7822 = load i1, ptr %t7821, align 8
%t7823 = xor i1 %t7822, true
br label %LSL7824
LSL7824:
br i1 %t7823, label %LSJ7824, label %LSR7824
LSR7824:
%t7825 = getelementptr i8, ptr %t7820, i64 8
%t7826 = load i64, ptr %t7825, align 8
%t7827 = icmp ne i64 %t7826, 0
br label %LSJ7824
LSJ7824:
%t7828 = phi i1 [ true, %LSL7824 ], [ %t7827, %LSR7824 ]
br label %LSL7829
LSL7829:
br i1 %t7828, label %LSJ7829, label %LSR7829
LSR7829:
%t7830 = getelementptr i8, ptr %t7820, i64 16
%t7831 = load i64, ptr %t7830, align 8
%t7832 = icmp ne i64 %t7831, 5
br label %LSJ7829
LSJ7829:
%t7833 = phi i1 [ true, %LSL7829 ], [ %t7832, %LSR7829 ]
br i1 %t7833, label %L862, label %L864
L862:
%t7835 = call ptr @cose_open_err(ptr @.s7834)
ret ptr %t7835
L864:
%t7836 = getelementptr i8, ptr %t7820, i64 24
%t7837 = load i64, ptr %t7836, align 8
%t7838 = call ptr @cbe_read_str(ptr %p0, i64 %t7837, i64 2)
%t7839 = getelementptr i8, ptr %t7838, i64 0
%t7840 = load i1, ptr %t7839, align 8
%t7841 = xor i1 %t7840, true
br label %LSL7842
LSL7842:
br i1 %t7841, label %LSJ7842, label %LSR7842
LSR7842:
%t7843 = getelementptr i8, ptr %t7838, i64 8
%t7844 = load ptr, ptr %t7843, align 8
%t7845 = call i64 @resid_list_len(ptr %t7844)
%t7846 = icmp ne i64 %t7845, 12
br label %LSJ7842
LSJ7842:
%t7847 = phi i1 [ true, %LSL7842 ], [ %t7846, %LSR7842 ]
br i1 %t7847, label %L865, label %L867
L865:
%t7849 = call ptr @cose_open_err(ptr @.s7848)
ret ptr %t7849
L867:
%t7850 = getelementptr i8, ptr %t7838, i64 16
%t7851 = load i64, ptr %t7850, align 8
%t7852 = call ptr @cbe_read_str(ptr %p0, i64 %t7851, i64 2)
%t7853 = getelementptr i8, ptr %t7852, i64 0
%t7854 = load i1, ptr %t7853, align 8
%t7855 = xor i1 %t7854, true
br label %LSL7856
LSL7856:
br i1 %t7855, label %LSJ7856, label %LSR7856
LSR7856:
%t7857 = getelementptr i8, ptr %t7852, i64 8
%t7858 = load ptr, ptr %t7857, align 8
%t7859 = call i64 @resid_list_len(ptr %t7858)
%t7860 = icmp slt i64 %t7859, 16
br label %LSJ7856
LSJ7856:
%t7861 = phi i1 [ true, %LSL7856 ], [ %t7860, %LSR7856 ]
br i1 %t7861, label %L868, label %L870
L868:
%t7863 = call ptr @cose_open_err(ptr @.s7862)
ret ptr %t7863
L870:
%t7864 = call i64 @resid_scope_push()
%t7865 = getelementptr i8, ptr %t7838, i64 8
%t7866 = load ptr, ptr %t7865, align 8
%t7867 = getelementptr i8, ptr %t7852, i64 8
%t7868 = load ptr, ptr %t7867, align 8
%t7869 = getelementptr i8, ptr %t7794, i64 8
%t7870 = load ptr, ptr %t7869, align 8
%t7871 = call ptr @cose_enc_structure(ptr %t7870)
%t7872 = call ptr @resid_list_freeze(ptr %t7871)
%t7873 = call i1 @chacha20poly1305_open(ptr %p1, ptr %t7866, ptr %t7868, ptr %t7872)
call void @resid_scope_pop(i64 %t7864)
%t7874 = xor i1 %t7873, true
br i1 %t7874, label %L871, label %L873
L871:
%t7876 = call ptr @cose_open_err(ptr @.s7875)
ret ptr %t7876
L873:
%t7877 = getelementptr i8, ptr %t7852, i64 8
%t7878 = load ptr, ptr %t7877, align 8
%t7879 = getelementptr i8, ptr %t7852, i64 8
%t7880 = load ptr, ptr %t7879, align 8
%t7881 = call i64 @resid_list_len(ptr %t7880)
%t7882 = sub nsw i64 %t7881, 17
%t7883 = call ptr @slice_bytes(ptr %t7878, i64 0, i64 %t7882)
%t7884 = call ptr @resid_gmalloc(i64 24)
%t7884.f0 = getelementptr i8, ptr %t7884, i64 0
store i1 true, ptr %t7884.f0, align 8
%t7884.f1 = getelementptr i8, ptr %t7884, i64 8
store ptr @.s7885, ptr %t7884.f1, align 8
%t7886 = getelementptr i8, ptr %t7838, i64 8
%t7887 = load ptr, ptr %t7886, align 8
%t7888 = call ptr @chacha20_xor(ptr %p1, i64 1, ptr %t7887, ptr %t7883)
%t7884.f2 = getelementptr i8, ptr %t7884, i64 16
store ptr %t7888, ptr %t7884.f2, align 8
ret ptr %t7884
}
define ptr @op(ptr %p0, ptr %p1, ptr %p2, ptr %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7889 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p4, i64 1)
%t7890 = extractvalue {i64, i1} %t7889, 0
%t7891 = extractvalue {i64, i1} %t7889, 1
%t7892 = zext i1 %t7891 to i8
call void @resid_overflow_check(i8 %t7892)
%t7893 = add i64 %t7890, 0
%t7894 = add i64 %t7893, 0
%t7895 = add i64 %t7894, 0
%t7896 = icmp ne i64 %t7895, %t7893
%t7897 = icmp slt i64 %t7890, 0
%t7898 = or i1 %t7896, %t7897
%t7899 = zext i1 %t7898 to i8
call void @resid_conv_check(i8 %t7899)
%t7900 = alloca [1 x ptr]
%t7902 = call ptr @resid_box_i64(i64 %t7894)
%t7904 = getelementptr i8, ptr %t7900, i64 0
store ptr %t7902, ptr %t7904
%t7905 = call ptr @resid_list_new(i64 1, ptr %t7900, ptr @.lty7900)
%t7906 = call ptr @bn_add(ptr %p1, ptr %t7905)
%t7908 = call i8 @resid_str_eq(ptr %p0, ptr @.s7907)
%t7909 = icmp ne i8 %t7908, 0
br i1 %t7909, label %L874, label %L876
L874:
%t7910 = call ptr @bn_mul(ptr %t7906, ptr %p2)
ret ptr %t7910
L876:
%t7912 = call i8 @resid_str_eq(ptr %p0, ptr @.s7911)
%t7913 = icmp ne i8 %t7912, 0
br i1 %t7913, label %L877, label %L879
L877:
%t7914 = call ptr @bn_mul(ptr %t7906, ptr %p2)
%t7915 = call ptr @bn_mod(ptr %t7914, ptr %p3)
ret ptr %t7915
L879:
%t7917 = call i8 @resid_str_eq(ptr %p0, ptr @.s7916)
%t7918 = icmp ne i8 %t7917, 0
br i1 %t7918, label %L880, label %L882
L880:
%t7919 = call ptr @bn_modmul(ptr %t7906, ptr %p2, ptr %p3)
ret ptr %t7919
L882:
%t7921 = call i8 @resid_str_eq(ptr %p0, ptr @.s7920)
%t7922 = icmp ne i8 %t7921, 0
br i1 %t7922, label %L883, label %L885
L883:
%t7923 = call ptr @bn_modinv(ptr %t7906, ptr %p3)
%t7924 = getelementptr {i32, i32, ptr}, ptr %t7923, i32 0, i32 0
%t7925w = load i32, ptr %t7924
%t7925 = sext i32 %t7925w to i64
%t7926 = icmp eq i64 %t7925, 1
br i1 %t7926, label %L886, label %L887
L886:
%t7927 = getelementptr {i32, i32, ptr}, ptr %t7923, i32 1
%t7928 = getelementptr i8, ptr %t7927, i64 0
%t7929 = getelementptr ptr, ptr %t7928, i32 0
%t7930 = load ptr, ptr %t7929
br label %L888
L887:
%t7932 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty7931)
br label %L888
L888:
%t7933 = phi ptr [ %t7930, %L886 ], [ %t7932, %L887 ]
ret ptr %t7933
L885:
%t7935 = call i8 @resid_str_eq(ptr %p0, ptr @.s7934)
%t7936 = icmp ne i8 %t7935, 0
br i1 %t7936, label %L889, label %L891
L889:
%t7937 = call ptr @bn_gcd(ptr %t7906, ptr %p3)
ret ptr %t7937
L891:
%t7939 = call i8 @resid_str_eq(ptr %p0, ptr @.s7938)
%t7940 = icmp ne i8 %t7939, 0
br i1 %t7940, label %L892, label %L894
L892:
%t7941 = call ptr @bn_mul(ptr %t7906, ptr %p2)
%t7942 = call ptr @bn_shr(ptr %t7941, i64 100)
ret ptr %t7942
L894:
ret ptr %t7906
}
define ptr @loop(ptr %p0.in, ptr %p1.in, ptr %p2.in, ptr %p3.in, i64 %p4.in, i64 %p5.in, ptr %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t7945, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%p6 = phi ptr [ %p6.in, %entry ], [ %t7951, %tco.s0 ]
%t7943 = icmp sge i64 %p4, %p5
br i1 %t7943, label %L895, label %L897
L895:
%t7944 = call ptr @resid_listbuf_finish(ptr %p6, ptr @.lty7944)
ret ptr %t7944
L897:
%t7945 = add nsw i64 %p4, 1
%t7946 = call ptr @op(ptr %p0, ptr %p1, ptr %p2, ptr %p3, i64 %p4)
%t7947 = call ptr @resid_list_freeze(ptr %t7946)
%t7951 = call ptr @resid_listbuf_push(ptr %p6, ptr %t7947)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @run(ptr %p0, ptr %p1, ptr %p2, ptr %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7953 = call ptr @resid_listbuf_new()
%t7954 = call ptr @loop(ptr %p0, ptr %p1, ptr %p2, ptr %p3, i64 0, i64 %p4, ptr %t7953)
%t7955 = call ptr @resid_list_freeze(ptr %t7954)
%t7956 = call i64 @resid_list_len(ptr %t7955)
ret i64 %t7956
}
define i32 @resid_user_main() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
call void @resid_cap_check(ptr @resid.cap.main)
%t7957 = call ptr @resid_args_get(i64 1)
%t7958 = call ptr @cose_hex_decode(ptr %t7957)
%t7959 = call ptr @resid_list_freeze(ptr %t7958)
%t7960 = call ptr @bn_from_be(ptr %t7959)
%t7961 = call ptr @resid_list_freeze(ptr %t7960)
%t7963 = call ptr @resid_list_const_i64(ptr @.lc7962, i64 1, ptr @.lcd7962, ptr @.lty7962)
%t7964 = call ptr @bn_sub(ptr %t7961, ptr %t7963)
%t7966 = call ptr @resid_list_const_i64(ptr @.lc7965, i64 1, ptr @.lcd7965, ptr @.lty7965)
%t7967 = call ptr @bn_sub(ptr %t7961, ptr %t7966)
call void @resid_cap_check(ptr @resid.cap.main.1)
%t7968 = call ptr @resid_args_get(i64 2)
call void @resid_cap_check(ptr @resid.cap.main.2)
%t7969 = call ptr @resid_args_get(i64 3)
%t7970 = call i64 @str_parse_int(ptr %t7969)
%t7971 = call i64 @run(ptr %t7968, ptr %t7964, ptr %t7967, ptr %t7961, i64 %t7970)
%t7972 = srem i64 %t7971, 200
%t7973 = trunc i64 %t7972 to i32
ret i32 %t7973
}
define ptr @sha256g_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7974 = call ptr @resid_list_get(ptr %p2, i64 0)
%t7975 = call i64 @resid_unbox_i64(ptr %t7974)
%t7977 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7975, i64 4294967295)
%t7978 = call ptr @resid_list_get(ptr %p2, i64 1)
%t7979 = call i64 @resid_unbox_i64(ptr %t7978)
%t7981 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7979, i64 4294967295)
%t7982 = call ptr @resid_list_get(ptr %p2, i64 2)
%t7983 = call i64 @resid_unbox_i64(ptr %t7982)
%t7985 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7983, i64 4294967295)
%t7986 = call ptr @resid_list_get(ptr %p2, i64 3)
%t7987 = call i64 @resid_unbox_i64(ptr %t7986)
%t7989 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7987, i64 4294967295)
%t7990 = call ptr @resid_list_get(ptr %p2, i64 4)
%t7991 = call i64 @resid_unbox_i64(ptr %t7990)
%t7993 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7991, i64 4294967295)
%t7994 = call ptr @resid_list_get(ptr %p2, i64 5)
%t7995 = call i64 @resid_unbox_i64(ptr %t7994)
%t7997 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7995, i64 4294967295)
%t7998 = call ptr @resid_list_get(ptr %p2, i64 6)
%t7999 = call i64 @resid_unbox_i64(ptr %t7998)
%t8001 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t7999, i64 4294967295)
%t8002 = call ptr @resid_list_get(ptr %p2, i64 7)
%t8003 = call i64 @resid_unbox_i64(ptr %t8002)
%t8005 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8003, i64 4294967295)
%t8006 = call ptr @__m____________lib_sha256g_resid__g_blk__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 0, ptr %p2, i64 %t7977, i64 %t7981, i64 %t7985, i64 %t7989, i64 %t7993, i64 %t7997, i64 %t8001, i64 %t8005, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret ptr %t8006
}
define ptr @base64g_decode__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8007 = call i64 @resid_list_len(ptr %p0)
%t8008 = srem i64 %t8007, 4
%t8009 = icmp sgt i64 %t8007, 0
br label %LSL8010
LSL8010:
br i1 %t8009, label %LSR8010, label %LSJ8010
LSR8010:
%t8011 = icmp eq i64 %t8008, 0
br label %LSL8012
LSL8012:
br i1 %t8011, label %LSR8012, label %LSJ8012
LSR8012:
%t8013 = icmp eq i64 %p1, 0
br label %LSJ8012
LSJ8012:
%t8014 = phi i1 [ false, %LSL8012 ], [ %t8013, %LSR8012 ]
br label %LSL8015
LSL8015:
br i1 %t8014, label %LSJ8015, label %LSR8015
LSR8015:
%t8016 = icmp eq i64 %t8008, 2
br label %LSL8017
LSL8017:
br i1 %t8016, label %LSR8017, label %LSJ8017
LSR8017:
%t8018 = icmp eq i64 %p1, 2
br label %LSJ8017
LSJ8017:
%t8019 = phi i1 [ false, %LSL8017 ], [ %t8018, %LSR8017 ]
br label %LSJ8015
LSJ8015:
%t8020 = phi i1 [ true, %LSL8015 ], [ %t8019, %LSJ8017 ]
br label %LSL8021
LSL8021:
br i1 %t8020, label %LSJ8021, label %LSR8021
LSR8021:
%t8022 = icmp eq i64 %t8008, 3
br label %LSL8023
LSL8023:
br i1 %t8022, label %LSR8023, label %LSJ8023
LSR8023:
%t8024 = icmp eq i64 %p1, 1
br label %LSJ8023
LSJ8023:
%t8025 = phi i1 [ false, %LSL8023 ], [ %t8024, %LSR8023 ]
br label %LSJ8021
LSJ8021:
%t8026 = phi i1 [ true, %LSL8021 ], [ %t8025, %LSJ8023 ]
br label %LSJ8010
LSJ8010:
%t8027 = phi i1 [ false, %LSL8010 ], [ %t8026, %LSJ8021 ]
%t8028 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB8028)
%t8029 = xor i1 %t8027, true
br i1 %t8029, label %L898, label %L900
L898:
ret ptr %t8028
L900:
%t8030 = call ptr @resid_listbuf_new()
%t8031 = call ptr @__m____________lib_crypto_resid__b64g_groups__g_Int_64__Int_64_(ptr %p0, i64 0, i64 0, ptr %t8030)
ret ptr %t8031
}
define i512 @eg_fadd__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8032 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %p1)
%t8033 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8034 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8032, i512 %t8033)
ret i512 %t8034
}
define i512 @eg_fsub__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8035 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8036 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %t8035)
%t8037 = call i512 @__m____________lib_word_resid__pi_sub(i512 %t8036, i512 %p1)
%t8038 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8039 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8037, i512 %t8038)
ret i512 %t8039
}
define i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8040 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %p0, i512 %p1)
%t8041 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8040, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t8042 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t8040, i64 256)
%t8043 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %t8042, i512 38)
%t8044 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8041, i512 %t8043)
%t8045 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8044, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t8046 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t8044, i64 256)
%t8047 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %t8046, i512 38)
%t8048 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8045, i512 %t8047)
%t8049 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8048, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t8050 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t8048, i64 256)
%t8051 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %t8050, i512 38)
%t8052 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8049, i512 %t8051)
%t8053 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8054 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8052, i512 %t8053)
%t8055 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8056 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8054, i512 %t8055)
ret i512 %t8056
}
define i512 @eg_finv__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8057 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819947 to i512
%t8058 = call i512 @eg_fpow__g_Int_512__Int_64_(i512 1, i512 %p0, i512 %t8057, i64 254)
ret i512 %t8058
}
define i512 @eg_fpow__g_Int_512__Int_64_(i512 %p0.in, i512 %p1.in, i512 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t8068, %tco.s0 ], [ %t8060, %tco.s1 ]
%p1 = phi i512 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i512 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t8069, %tco.s0 ], [ %t8071, %tco.s1 ]
%t8059 = icmp slt i64 %p3, 0
br i1 %t8059, label %L901, label %L903
L901:
ret i512 %p0
L903:
%t8060 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p0)
%t8061 = sext i64 %p3 to i512
%t8062 = icmp uge i512 %t8061, 512
%t8063 = add i512 %t8061, 0
%t8064 = select i1 %t8062, i512 511, i512 %t8063
%t8065 = ashr i512 %p2, %t8064
%t8066 = and i512 %t8065, 1
%t8067 = icmp eq i512 %t8066, 1
br i1 %t8067, label %L904, label %L906
L904:
%t8068 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8060, i512 %p1)
%t8069 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
L906:
%t8071 = sub nsw i64 %p3, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define ptr @eg_dbl__g_Int_512__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8073 = getelementptr i8, ptr %p0, i64 0
%t8074 = load i512, ptr %t8073, align 8
%t8075 = getelementptr i8, ptr %p0, i64 0
%t8076 = load i512, ptr %t8075, align 8
%t8077 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8074, i512 %t8076)
%t8078 = getelementptr i8, ptr %p0, i64 64
%t8079 = load i512, ptr %t8078, align 8
%t8080 = getelementptr i8, ptr %p0, i64 64
%t8081 = load i512, ptr %t8080, align 8
%t8082 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8079, i512 %t8081)
%t8083 = getelementptr i8, ptr %p0, i64 128
%t8084 = load i512, ptr %t8083, align 8
%t8085 = getelementptr i8, ptr %p0, i64 128
%t8086 = load i512, ptr %t8085, align 8
%t8087 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8084, i512 %t8086)
%t8088 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8087, i512 %t8087)
%t8089 = getelementptr i8, ptr %p0, i64 0
%t8090 = load i512, ptr %t8089, align 8
%t8091 = getelementptr i8, ptr %p0, i64 64
%t8092 = load i512, ptr %t8091, align 8
%t8093 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8090, i512 %t8092)
%t8094 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8093, i512 %t8093)
%t8095 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8094, i512 %t8077)
%t8096 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8095, i512 %t8082)
%t8097 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8082, i512 %t8077)
%t8098 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8097, i512 %t8088)
%t8099 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 0, i512 %t8077)
%t8100 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8099, i512 %t8082)
%t8101 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8096, i512 %t8098)
%t8102 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8097, i512 %t8100)
%t8103 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8098, i512 %t8097)
%t8104 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8096, i512 %t8100)
%t8105 = call ptr @resid_rec_reuse_sc(ptr %p0, i64 256)
%t8105.f0 = getelementptr i8, ptr %t8105, i64 0
store i512 %t8101, ptr %t8105.f0, align 8
%t8105.f8 = getelementptr i8, ptr %t8105, i64 64
store i512 %t8102, ptr %t8105.f8, align 8
%t8105.f16 = getelementptr i8, ptr %t8105, i64 128
store i512 %t8103, ptr %t8105.f16, align 8
%t8105.f24 = getelementptr i8, ptr %t8105, i64 192
store i512 %t8104, ptr %t8105.f24, align 8
ret ptr %t8105
}
define ptr @eg_add__g_Int_512__Int_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8106 = getelementptr i8, ptr %p0, i64 64
%t8107 = load i512, ptr %t8106, align 8
%t8108 = getelementptr i8, ptr %p0, i64 0
%t8109 = load i512, ptr %t8108, align 8
%t8110 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8107, i512 %t8109)
%t8111 = getelementptr i8, ptr %p1, i64 64
%t8112 = load i512, ptr %t8111, align 8
%t8113 = getelementptr i8, ptr %p1, i64 0
%t8114 = load i512, ptr %t8113, align 8
%t8115 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8112, i512 %t8114)
%t8116 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8110, i512 %t8115)
%t8117 = getelementptr i8, ptr %p0, i64 64
%t8118 = load i512, ptr %t8117, align 8
%t8119 = getelementptr i8, ptr %p0, i64 0
%t8120 = load i512, ptr %t8119, align 8
%t8121 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8118, i512 %t8120)
%t8122 = getelementptr i8, ptr %p1, i64 64
%t8123 = load i512, ptr %t8122, align 8
%t8124 = getelementptr i8, ptr %p1, i64 0
%t8125 = load i512, ptr %t8124, align 8
%t8126 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8123, i512 %t8125)
%t8127 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8121, i512 %t8126)
%t8128 = getelementptr i8, ptr %p0, i64 192
%t8129 = load i512, ptr %t8128, align 8
%t8130 = getelementptr i8, ptr %p0, i64 192
%t8131 = load i512, ptr %t8130, align 8
%t8132 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8129, i512 %t8131)
%t8133 = sext i256 37095705934669439343138083508754565189542113879843219016388785533085940283555 to i512
%t8134 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8132, i512 %t8133)
%t8135 = getelementptr i8, ptr %p1, i64 192
%t8136 = load i512, ptr %t8135, align 8
%t8137 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8134, i512 %t8136)
%t8138 = getelementptr i8, ptr %p0, i64 128
%t8139 = load i512, ptr %t8138, align 8
%t8140 = getelementptr i8, ptr %p0, i64 128
%t8141 = load i512, ptr %t8140, align 8
%t8142 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8139, i512 %t8141)
%t8143 = getelementptr i8, ptr %p1, i64 128
%t8144 = load i512, ptr %t8143, align 8
%t8145 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8142, i512 %t8144)
%t8146 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8127, i512 %t8116)
%t8147 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8145, i512 %t8137)
%t8148 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8145, i512 %t8137)
%t8149 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8127, i512 %t8116)
%t8150 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8146, i512 %t8147)
%t8151 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8148, i512 %t8149)
%t8152 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8147, i512 %t8148)
%t8153 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8146, i512 %t8149)
%t8154 = call ptr @resid_rec_reuse_sc(ptr %p0, i64 256)
%t8154.f0 = getelementptr i8, ptr %t8154, i64 0
store i512 %t8150, ptr %t8154.f0, align 8
%t8154.f8 = getelementptr i8, ptr %t8154, i64 64
store i512 %t8151, ptr %t8154.f8, align 8
%t8154.f16 = getelementptr i8, ptr %t8154, i64 128
store i512 %t8152, ptr %t8154.f16, align 8
%t8154.f24 = getelementptr i8, ptr %t8154, i64 192
store i512 %t8153, ptr %t8154.f24, align 8
ret ptr %t8154
}
define ptr @eg_ladder__g_Int_512__Int_64_(i512 %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t8162, %tco.s0.k ]
%t8155 = icmp slt i64 %p3, 0
br i1 %t8155, label %L907, label %L909
L907:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p2
lr.x11.m:
%lr.ret11 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %p2, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L909:
%t8156 = call ptr @eg_dbl__g_Int_512__Int_64_(ptr %p2)
call void @resid_rec_share(ptr %t8156)
%t8157 = sub nsw i64 511, %p3
%t8158 = call i512 @__m____________lib_word_resid__pi_shl(i512 %p0, i64 %t8157)
%t8159 = call i512 @__m____________lib_word_resid__pi_sign(i512 %t8158)
%t8160 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t8156, ptr %p1)
call void @resid_rec_share(ptr %t8160)
%t8161 = call ptr @__m____________lib_ed25519g_resid__eg_sel__g_Int_512__Int_64_(i512 %t8159, ptr %t8160, ptr %t8156)
call void @resid_rec_share(ptr %t8161)
%t8162 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p1.e.tco.s0 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %p1, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %t8161, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t8161, %tco.s0 ]
br label %tco.head
}
define ptr @eg_base_mul__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8164 = call ptr @eg_base__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t8164)
%t8165 = call ptr @eg_id__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t8165)
%t8166 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %p0, ptr %t8164, ptr %t8165, i64 255)
ret ptr %t8166
}
define ptr @eg_encode__g_Int_512__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8167 = getelementptr i8, ptr %p0, i64 128
%t8168 = load i512, ptr %t8167, align 8
%t8169 = call i512 @eg_finv__g_Int_512__Int_64_(i512 %t8168)
%t8170 = getelementptr i8, ptr %p0, i64 0
%t8171 = load i512, ptr %t8170, align 8
%t8172 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8171, i512 %t8169)
%t8173 = getelementptr i8, ptr %p0, i64 64
%t8174 = load i512, ptr %t8173, align 8
%t8175 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8174, i512 %t8169)
%t8176 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8172, i512 1)
%t8177 = call i512 @__m____________lib_word_resid__pi_shl(i512 %t8176, i64 255)
%t8178 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8175, i512 %t8177)
%t8179 = call ptr @resid_listbuf_new()
%t8180 = call ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %t8178, i64 32, i64 0, ptr %t8179)
ret ptr %t8180
}
define i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8181 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 32, i64 32, i64 0, i512 0)
%t8182 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 32, i64 0, i512 0)
%t8183 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 0, i512 %t8181, i64 255)
%t8184 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 %t8183, i512 %t8182, i64 255)
ret i512 %t8184
}
define ptr @eg_pt__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8185 = call ptr @resid_rec_new(i64 256, i8 1)
%t8185.f0 = getelementptr i8, ptr %t8185, i64 0
store i512 %p0, ptr %t8185.f0, align 8
%t8185.f8 = getelementptr i8, ptr %t8185, i64 64
store i512 %p1, ptr %t8185.f8, align 8
%t8185.f16 = getelementptr i8, ptr %t8185, i64 128
store i512 1, ptr %t8185.f16, align 8
%t8186 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p1)
%t8185.f24 = getelementptr i8, ptr %t8185, i64 192
store i512 %t8186, ptr %t8185.f24, align 8
ret ptr %t8185
}
define ptr @eg_id__g_Int_512__Int_64_() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8187 = call ptr @resid_rec_new(i64 256, i8 1)
%t8187.f0 = getelementptr i8, ptr %t8187, i64 0
store i512 0, ptr %t8187.f0, align 8
%t8187.f8 = getelementptr i8, ptr %t8187, i64 64
store i512 1, ptr %t8187.f8, align 8
%t8187.f16 = getelementptr i8, ptr %t8187, i64 128
store i512 1, ptr %t8187.f16, align 8
%t8187.f24 = getelementptr i8, ptr %t8187, i64 192
store i512 0, ptr %t8187.f24, align 8
ret ptr %t8187
}
define i512 @eg_clamp__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8188 = sext i256 28948022309329048855892746252171976963317496166410141009864396001978282409976 to i512
%t8189 = call i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %t8188)
%t8190 = sext i256 28948022309329048855892746252171976963317496166410141009864396001978282409984 to i512
%t8191 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8189, i512 %t8190)
ret i512 %t8191
}
define ptr @ed25519g_pub__g_Int_64__Int_512__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8192 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %p0)
%t8193 = call i512 @__m____________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %t8192)
%t8194 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t8193)
%t8195 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t8194)
%t8196 = musttail call ptr @__m____________lib_word_resid__wi_publish(ptr %t8195)
ret ptr %t8196
}
define ptr @ed25519g_sign__g_Int_64__Int_512__UInt_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8197 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %p0)
%t8198 = call i512 @__m____________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %t8197)
%t8199 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t8198)
call void @resid_rec_share(ptr %t8199)
%t8200 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t8199)
%t8201 = call ptr @resid_list_freeze(ptr %t8200)
%t8202 = call ptr @__m____________lib_word_resid__wi_publish(ptr %t8201)
%t8203 = call ptr @resid_list_freeze(ptr %t8202)
%t8204 = call ptr @d_lift_bytes__g_Int_64__UInt_64_(ptr %p1)
%t8205 = call ptr @resid_list_freeze(ptr %t8204)
%t8206 = call i64 @resid_scope_push()
%t8207 = call ptr @resid_list_slice(ptr %t8197, i64 32, i64 64)
%t8209 = call ptr @resid_list_concat(ptr %t8207, ptr %t8205)
%t8210 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %t8209)
%t8211 = call ptr @resid_list_freeze(ptr %t8210)
%t8212 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t8211)
call void @resid_scope_pop(i64 %t8206)
%t8213 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t8212)
call void @resid_rec_share(ptr %t8213)
%t8214 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t8213)
%t8215 = call ptr @resid_list_freeze(ptr %t8214)
%t8216 = call ptr @__m____________lib_word_resid__wi_publish(ptr %t8215)
%t8217 = call ptr @resid_list_freeze(ptr %t8216)
%t8218 = call ptr @resid_listbuf_new()
%t8219 = call i64 @resid_scope_push()
%t8220 = call ptr @resid_list_concat(ptr %t8217, ptr %t8203)
%t8221 = call ptr @resid_list_concat(ptr %t8220, ptr %p1)
%t8222 = call ptr @sha512_bytes(ptr %t8221)
%t8223 = call ptr @resid_list_freeze(ptr %t8222)
%t8224 = call ptr @__m____________lib_ed25519g_resid__eg_lift_bytes__g_Int_64__Int_512_(ptr %t8223, i64 0, ptr %t8218)
%t8225 = call ptr @resid_list_freeze(ptr %t8224)
%t8226 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t8225)
call void @resid_scope_pop(i64 %t8219)
%t8227 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t8226, i512 %t8198)
%t8228 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8227, i512 %t8212)
%t8229 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 0, i512 %t8228, i64 508)
%t8230 = call ptr @resid_listbuf_new()
%t8231 = call ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %t8229, i64 32, i64 0, ptr %t8230)
%t8232 = call ptr @resid_list_freeze(ptr %t8231)
%t8233 = call ptr @__m____________lib_word_resid__wi_publish(ptr %t8232)
%t8234 = call ptr @resid_list_freeze(ptr %t8233)
%t8235 = musttail call ptr @resid_list_concat(ptr %t8217, ptr %t8234)
ret ptr %t8235
}
define ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8236 = call ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
%t8237 = call ptr @__m____________lib_chachag_resid__cg_block_st__g_Int_64__Int_64_(ptr %t8236)
ret ptr %t8237
}
define ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8238 = call ptr @resid_listbuf_new()
%t8239 = call ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
%t8240 = call ptr @resid_list_freeze(ptr %t8239)
%t8241 = and i64 %p1, 4294967295
%t8242 = call ptr @__m____________lib_chachag_resid__cg_xor_run__g_Int_64__Int_64_(ptr %t8240, i64 %t8241, ptr %p3, i64 0, ptr %t8238)
%t8243 = call ptr @resid_listbuf_finish(ptr %t8242, ptr @.lty8243)
ret ptr %t8243
}
define ptr @poly1305g__g_Int_64__Int_512_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8244 = call i512 @__m____________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 16, i64 0, i512 0)
%t8245 = sext i128 21267647620597763993911028882763415551 to i512
%t8246 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8244, i512 %t8245)
%t8247 = call i512 @__m____________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p0, i64 16, i64 16, i64 0, i512 0)
%t8248 = call i512 @__m____________lib_chachag_resid__pg_blocks__g_Int_512__Int_64_(i512 0, ptr %p1, i64 0, i512 %t8246)
%t8249 = call ptr @resid_listbuf_new()
%t8250 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8248, i512 %t8247)
%t8251 = sext i256 340282366920938463463374607431768211455 to i512
%t8252 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8250, i512 %t8251)
%t8253 = call ptr @__m____________lib_chachag_resid__pg_bytes__g_Int_512__Int_64_(i512 %t8252, i64 0, ptr %t8249)
ret ptr %t8253
}
define ptr @chacha20poly1305g_seal__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8254 = call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 0, ptr %p1)
%t8255 = call ptr @resid_list_freeze(ptr %t8254)
%t8256 = call ptr @resid_list_slice(ptr %t8255, i64 0, i64 32)
%t8258 = call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 1, ptr %p1, ptr %p2)
%t8259 = call ptr @resid_list_freeze(ptr %t8258)
%t8260 = call ptr @__m____________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p3, ptr %t8259)
%t8261 = call ptr @resid_list_freeze(ptr %t8260)
%t8262 = call ptr @poly1305g__g_Int_64__Int_512_(ptr %t8256, ptr %t8261)
%t8263 = call ptr @resid_list_freeze(ptr %t8262)
%t8264 = call ptr @resid_list_concat(ptr %t8259, ptr %t8263)
ret ptr %t8264
}
define ptr @chacha20poly1305g_decrypt__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8265 = call i64 @resid_list_len(ptr %p2)
%t8266 = sub nsw i64 %t8265, 16
%t8267 = call i64 @resid_list_len(ptr %p0)
%t8268 = icmp ne i64 %t8267, 32
br label %LSL8269
LSL8269:
br i1 %t8268, label %LSJ8269, label %LSR8269
LSR8269:
%t8270 = call i64 @resid_list_len(ptr %p1)
%t8271 = icmp ne i64 %t8270, 12
br label %LSJ8269
LSJ8269:
%t8272 = phi i1 [ true, %LSL8269 ], [ %t8271, %LSR8269 ]
br label %LSL8273
LSL8273:
br i1 %t8272, label %LSJ8273, label %LSR8273
LSR8273:
%t8274 = icmp slt i64 %t8266, 0
br label %LSJ8273
LSJ8273:
%t8275 = phi i1 [ true, %LSL8273 ], [ %t8274, %LSR8273 ]
br i1 %t8275, label %L910, label %L912
L910:
ret ptr @.nbox8276
L912:
%t8277 = call ptr @resid_listbuf_new()
%t8278 = call ptr @resid_listbuf_new()
%t8279 = call ptr @resid_list_slice(ptr %p2, i64 0, i64 %t8266)
%t8281 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t8279, i64 0, ptr %t8277)
%t8282 = call ptr @resid_list_freeze(ptr %t8281)
%t8283 = call i64 @resid_list_len(ptr %p2)
%t8284 = call ptr @resid_list_slice(ptr %p2, i64 %t8266, i64 %t8283)
%t8286 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t8284, i64 0, ptr %t8278)
%t8287 = call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 0, ptr %p1)
%t8288 = call ptr @resid_list_freeze(ptr %t8287)
%t8289 = call ptr @resid_list_slice(ptr %t8288, i64 0, i64 32)
%t8291 = call ptr @__m____________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p3, ptr %t8282)
%t8292 = call ptr @resid_list_freeze(ptr %t8291)
%t8293 = call ptr @poly1305g__g_Int_64__Int_512_(ptr %t8289, ptr %t8292)
%t8294 = call ptr @resid_list_freeze(ptr %t8293)
%t8295 = call i1 @__m____________lib_crypto_resid__ct_same_pub(ptr %t8294, ptr %t8286)
%t8296 = xor i1 %t8295, true
br i1 %t8296, label %L913, label %L915
L913:
ret ptr @.nbox8297
L915:
%t8298 = call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 1, ptr %p1, ptr %t8282)
%t8299 = call ptr @resid_list_freeze(ptr %t8298)
%t8302 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty8300)
%t8301 = getelementptr {i32, i32, ptr}, ptr %t8302, i32 1
store ptr %t8299, ptr %t8301
ret ptr %t8302
}
define ptr @__m____________lib_sha256g_resid__g_blk__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in, i64 %p19.in, i64 %p20.in, i64 %p21.in, i64 %p22.in, i64 %p23.in, i64 %p24.in, i64 %p25.in, i64 %p26.in, i64 %p27.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8336 = alloca [8 x ptr]
%p3.ld = call ptr @resid_list_vdata(ptr %p3.in)
%p3.ln = call i64 @resid_list_vlen(ptr %p3.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8375, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t8376, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t8377, %tco.s0.k ]
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
%p27 = phi i64 [ %p27.in, %entry ], [ %t8363, %tco.s0.k ]
%t8303 = icmp sge i64 %p2, 64
br i1 %t8303, label %L916, label %L918
L916:
%t8304 = call ptr @resid_list_get_v(ptr %p3, i64 0, ptr %p3.ld, i64 %p3.ln)
%t8305 = call i64 @resid_unbox_i64(ptr %t8304)
%t8307 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8305, i64 %p4)
%t8308 = call ptr @resid_list_get_v(ptr %p3, i64 1, ptr %p3.ld, i64 %p3.ln)
%t8309 = call i64 @resid_unbox_i64(ptr %t8308)
%t8311 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8309, i64 %p5)
%t8312 = call ptr @resid_list_get_v(ptr %p3, i64 2, ptr %p3.ld, i64 %p3.ln)
%t8313 = call i64 @resid_unbox_i64(ptr %t8312)
%t8315 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8313, i64 %p6)
%t8316 = call ptr @resid_list_get_v(ptr %p3, i64 3, ptr %p3.ld, i64 %p3.ln)
%t8317 = call i64 @resid_unbox_i64(ptr %t8316)
%t8319 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8317, i64 %p7)
%t8320 = call ptr @resid_list_get_v(ptr %p3, i64 4, ptr %p3.ld, i64 %p3.ln)
%t8321 = call i64 @resid_unbox_i64(ptr %t8320)
%t8323 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8321, i64 %p8)
%t8324 = call ptr @resid_list_get_v(ptr %p3, i64 5, ptr %p3.ld, i64 %p3.ln)
%t8325 = call i64 @resid_unbox_i64(ptr %t8324)
%t8327 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8325, i64 %p9)
%t8328 = call ptr @resid_list_get_v(ptr %p3, i64 6, ptr %p3.ld, i64 %p3.ln)
%t8329 = call i64 @resid_unbox_i64(ptr %t8328)
%t8331 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8329, i64 %p10)
%t8332 = call ptr @resid_list_get_v(ptr %p3, i64 7, ptr %p3.ld, i64 %p3.ln)
%t8333 = call i64 @resid_unbox_i64(ptr %t8332)
%t8335 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8333, i64 %p11)
%t8338 = call ptr @resid_box_i64(i64 %t8307)
%t8340 = getelementptr i8, ptr %t8336, i64 0
store ptr %t8338, ptr %t8340
%t8341 = call ptr @resid_box_i64(i64 %t8311)
%t8343 = getelementptr i8, ptr %t8336, i64 8
store ptr %t8341, ptr %t8343
%t8344 = call ptr @resid_box_i64(i64 %t8315)
%t8346 = getelementptr i8, ptr %t8336, i64 16
store ptr %t8344, ptr %t8346
%t8347 = call ptr @resid_box_i64(i64 %t8319)
%t8349 = getelementptr i8, ptr %t8336, i64 24
store ptr %t8347, ptr %t8349
%t8350 = call ptr @resid_box_i64(i64 %t8323)
%t8352 = getelementptr i8, ptr %t8336, i64 32
store ptr %t8350, ptr %t8352
%t8353 = call ptr @resid_box_i64(i64 %t8327)
%t8355 = getelementptr i8, ptr %t8336, i64 40
store ptr %t8353, ptr %t8355
%t8356 = call ptr @resid_box_i64(i64 %t8331)
%t8358 = getelementptr i8, ptr %t8336, i64 48
store ptr %t8356, ptr %t8358
%t8359 = call ptr @resid_box_i64(i64 %t8335)
%t8361 = getelementptr i8, ptr %t8336, i64 56
store ptr %t8359, ptr %t8361
%t8362 = call ptr @resid_list_new(i64 8, ptr %t8336, ptr @.lty8336)
%lr.cx87 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz87 = icmp eq ptr %lr.cx87, null
br i1 %lr.lz87, label %lr.x87.k, label %lr.x87.m
lr.x87.k:
ret ptr %t8362
lr.x87.m:
%lr.ret87 = call ptr @resid_mv_list(ptr %t8362, ptr %lr.cx87)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret87
L918:
%t8363 = call i64 @__m____________lib_sha256g_resid__g_sched__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p12, i64 %p13, i64 %p21, i64 %p26)
%t8364 = call i64 @resid_scope_push()
%t8365 = call i64 @__m____________lib_sha256g_resid__g_bsig1__g_Int_64__Int_64_(i64 %p8)
%t8366 = call i64 @__m____________lib_word_resid__wi_add(i64 %p11, i64 %t8365)
%t8367 = call i64 @__m____________lib_sha256g_resid__g_ch__g_Int_64__Int_64_(i64 %p8, i64 %p9, i64 %p10)
%t8368 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8366, i64 %t8367)
%t8369 = call i64 @__m____________lib_sha256g_resid__sha2k(i64 %p2)
%t8370 = call i64 @__m____________lib_word_resid__wi_addk(i64 %t8368, i64 %t8369)
%t8371 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8370, i64 %t8363)
call void @resid_scope_pop(i64 %t8364)
%t8372 = call i64 @__m____________lib_sha256g_resid__g_bsig0__g_Int_64__Int_64_(i64 %p4)
%t8373 = call i64 @__m____________lib_sha256g_resid__g_maj__g_Int_64__Int_64_(i64 %p4, i64 %p5, i64 %p6)
%t8374 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8372, i64 %t8373)
%t8375 = add nsw i64 %p2, 1
%t8376 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8371, i64 %t8374)
%t8377 = call i64 @__m____________lib_word_resid__wi_add(i64 %p7, i64 %t8371)
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t8416, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8415, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t8413, %tco.s0 ]
%t8379 = call i64 @resid_list_len(ptr %p0)
%t8380 = icmp sge i64 %p1, %t8379
br i1 %t8380, label %L919, label %L921
L919:
%t8381 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty8381)
%t8382 = call ptr @__m____________lib_crypto_resid__b64g_finish__g_Int_64__Int_64_(ptr %t8381, i64 %p2)
ret ptr %t8382
L921:
%t8383 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %p1)
%t8384 = add nsw i64 %p1, 1
%t8385 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t8384)
%t8386 = add nsw i64 %p1, 2
%t8387 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t8386)
%t8388 = add nsw i64 %p1, 3
%t8389 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t8388)
%t8390 = call i64 @__m____________lib_crypto_resid__b64g_join__g_Int_64__Int_64_(i64 %t8383, i64 %t8385, i64 %t8387, i64 %t8389)
%t8391 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t8379, i64 %p1)
%t8392 = extractvalue {i64, i1} %t8391, 0
%t8393 = extractvalue {i64, i1} %t8391, 1
%t8394 = zext i1 %t8393 to i8
call void @resid_overflow_check(i8 %t8394)
%t8395 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8390, i64 16)
%t8396 = call ptr @resid_box_i64(i64 %t8395)
%t8399 = call ptr @resid_listbuf_push(ptr %p3, ptr %t8396)
%t8400 = icmp sgt i64 %t8392, 2
br i1 %t8400, label %L922, label %L923
L922:
%t8401 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8390, i64 8)
%t8402 = call ptr @resid_box_i64(i64 %t8401)
%t8405 = call ptr @resid_listbuf_push(ptr %t8399, ptr %t8402)
br label %L924
L923:
br label %L924
L924:
%t8406 = phi ptr [ %t8405, %L922 ], [ %t8399, %L923 ]
%t8407 = icmp sgt i64 %t8392, 3
br i1 %t8407, label %L925, label %L926
L925:
%t8408 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8390, i64 0)
%t8409 = call ptr @resid_box_i64(i64 %t8408)
%t8412 = call ptr @resid_listbuf_push(ptr %t8406, ptr %t8409)
br label %L927
L926:
br label %L927
L927:
%t8413 = phi ptr [ %t8412, %L925 ], [ %t8406, %L926 ]
%t8414 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8390, i64 16777216)
%t8415 = call i64 @__m____________lib_word_resid__wi_or(i64 %p2, i64 %t8414)
%t8416 = add nsw i64 %p1, 4
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8418 = call i512 @__m____________lib_word_resid__pi_sub(i512 %p0, i512 %p1)
%t8419 = call i512 @__m____________lib_word_resid__pi_sign(i512 %t8418)
%t8420 = call i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %t8419)
%t8421 = sext i64 -1 to i512
%t8422 = call i512 @__m____________lib_word_resid__pi_xor(i512 %t8419, i512 %t8421)
%t8423 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8418, i512 %t8422)
%t8424 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8420, i512 %t8423)
ret i512 %t8424
}
define ptr @__m____________lib_ed25519g_resid__eg_sel__g_Int_512__Int_64_(i512 %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8425 = sext i64 -1 to i512
%t8426 = call i512 @__m____________lib_word_resid__pi_xor(i512 %p0, i512 %t8425)
%t8427 = getelementptr i8, ptr %p1, i64 0
%t8428 = load i512, ptr %t8427, align 8
%t8429 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8428, i512 %p0)
%t8430 = getelementptr i8, ptr %p2, i64 0
%t8431 = load i512, ptr %t8430, align 8
%t8432 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8431, i512 %t8426)
%t8433 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8429, i512 %t8432)
%t8434 = getelementptr i8, ptr %p1, i64 64
%t8435 = load i512, ptr %t8434, align 8
%t8436 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8435, i512 %p0)
%t8437 = getelementptr i8, ptr %p2, i64 64
%t8438 = load i512, ptr %t8437, align 8
%t8439 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8438, i512 %t8426)
%t8440 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8436, i512 %t8439)
%t8441 = getelementptr i8, ptr %p1, i64 128
%t8442 = load i512, ptr %t8441, align 8
%t8443 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8442, i512 %p0)
%t8444 = getelementptr i8, ptr %p2, i64 128
%t8445 = load i512, ptr %t8444, align 8
%t8446 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8445, i512 %t8426)
%t8447 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8443, i512 %t8446)
%t8448 = getelementptr i8, ptr %p1, i64 192
%t8449 = load i512, ptr %t8448, align 8
%t8450 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8449, i512 %p0)
%t8451 = getelementptr i8, ptr %p2, i64 192
%t8452 = load i512, ptr %t8451, align 8
%t8453 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8452, i512 %t8426)
%t8454 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8450, i512 %t8453)
%t8455 = call ptr @resid_rec_reuse_sc(ptr %p1, i64 256)
%t8455.f0 = getelementptr i8, ptr %t8455, i64 0
store i512 %t8433, ptr %t8455.f0, align 8
%t8455.f8 = getelementptr i8, ptr %t8455, i64 64
store i512 %t8440, ptr %t8455.f8, align 8
%t8455.f16 = getelementptr i8, ptr %t8455, i64 128
store i512 %t8447, ptr %t8455.f16, align 8
%t8455.f24 = getelementptr i8, ptr %t8455, i64 192
store i512 %t8454, ptr %t8455.f24, align 8
ret ptr %t8455
}
define ptr @eg_base__g_Int_512__Int_64_() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8456 = sext i256 15112221349535400772501151409588531511454012693041857206046113283949847762202 to i512
%t8457 = sext i256 46316835694926478169428394003475163141307993866256225615783033603165251855960 to i512
%t8458 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t8456, i512 %t8457)
ret ptr %t8458
}
define ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8461, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t8470, %tco.s0 ]
%t8459 = icmp sge i64 %p2, %p1
br i1 %t8459, label %L928, label %L930
L928:
%t8460 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty8460)
ret ptr %t8460
L930:
%t8461 = add nsw i64 %p2, 1
%t8462 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p2)
%t8463 = extractvalue {i64, i1} %t8462, 0
%t8464 = extractvalue {i64, i1} %t8462, 1
%t8465 = zext i1 %t8464 to i8
call void @resid_overflow_check(i8 %t8465)
%t8466 = call i64 @__m____________lib_word_resid__pi_byte(i512 %p0, i64 %t8463)
%t8467 = call ptr @resid_box_i64(i64 %t8466)
%t8470 = call ptr @resid_listbuf_push(ptr %p3, ptr %t8467)
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t8473, %tco.s0 ]
%p4 = phi i512 [ %p4.in, %entry ], [ %t8487, %tco.s0 ]
%t8472 = icmp sge i64 %p3, %p2
br i1 %t8472, label %L931, label %L933
L931:
ret i512 %p4
L933:
%t8473 = add nsw i64 %p3, 1
%t8474 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p3)
%t8475 = extractvalue {i64, i1} %t8474, 0
%t8476 = extractvalue {i64, i1} %t8474, 1
%t8477 = zext i1 %t8476 to i8
call void @resid_overflow_check(i8 %t8477)
%t8478 = call ptr @resid_list_get_v(ptr %p0, i64 %t8475, ptr %p0.ld, i64 %p0.ln)
%t8479 = call i64 @resid_unbox_i64(ptr %t8478)
%t8481 = call i512 @__m____________lib_word_resid__pi_from_byte(i64 %t8479)
%t8482 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p3)
%t8483 = extractvalue {i64, i1} %t8482, 0
%t8484 = extractvalue {i64, i1} %t8482, 1
%t8485 = zext i1 %t8484 to i8
call void @resid_overflow_check(i8 %t8485)
%t8486 = call i512 @__m____________lib_word_resid__pi_shl(i512 %t8481, i64 %t8483)
%t8487 = call i512 @__m____________lib_word_resid__pi_or(i512 %p4, i512 %t8486)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @eg_fold_l__g_Int_512__Int_64_(i512 %p0.in, i512 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t8495, %tco.s0 ]
%p1 = phi i512 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8496, %tco.s0 ]
%t8489 = icmp slt i64 %p2, 0
br i1 %t8489, label %L934, label %L936
L934:
ret i512 %p0
L936:
%t8490 = call i512 @__m____________lib_word_resid__pi_shr(i512 %p1, i64 %p2)
%t8491 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8490, i512 1)
%t8492 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %p0)
%t8493 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8492, i512 %t8491)
%t8494 = sext i256 7237005577332262213973186563042994240857116359379907606001950938285454250989 to i512
%t8495 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8493, i512 %t8494)
%t8496 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @sha512g__g_Int_64__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8498 = add i64 7640891576956012808, 0
%t8499 = add i64 %t8498, 0
%t8500 = add i64 %t8499, 0
%t8501 = icmp ne i64 %t8500, %t8498
%t8502 = icmp slt i64 7640891576956012808, 0
%t8503 = or i1 %t8501, %t8502
%t8504 = zext i1 %t8503 to i8
call void @resid_conv_check(i8 %t8504)
%t8505 = add i128 13503953896175478587, 0
%t8506 = trunc i128 %t8505 to i64
%t8507 = zext i64 %t8506 to i128
%t8508 = icmp ne i128 %t8507, %t8505
%t8509 = icmp slt i128 13503953896175478587, 0
%t8510 = or i1 %t8508, %t8509
%t8511 = zext i1 %t8510 to i8
call void @resid_conv_check(i8 %t8511)
%t8512 = add i64 4354685564936845355, 0
%t8513 = add i64 %t8512, 0
%t8514 = add i64 %t8513, 0
%t8515 = icmp ne i64 %t8514, %t8512
%t8516 = icmp slt i64 4354685564936845355, 0
%t8517 = or i1 %t8515, %t8516
%t8518 = zext i1 %t8517 to i8
call void @resid_conv_check(i8 %t8518)
%t8519 = add i128 11912009170470909681, 0
%t8520 = trunc i128 %t8519 to i64
%t8521 = zext i64 %t8520 to i128
%t8522 = icmp ne i128 %t8521, %t8519
%t8523 = icmp slt i128 11912009170470909681, 0
%t8524 = or i1 %t8522, %t8523
%t8525 = zext i1 %t8524 to i8
call void @resid_conv_check(i8 %t8525)
%t8526 = add i64 5840696475078001361, 0
%t8527 = add i64 %t8526, 0
%t8528 = add i64 %t8527, 0
%t8529 = icmp ne i64 %t8528, %t8526
%t8530 = icmp slt i64 5840696475078001361, 0
%t8531 = or i1 %t8529, %t8530
%t8532 = zext i1 %t8531 to i8
call void @resid_conv_check(i8 %t8532)
%t8533 = add i128 11170449401992604703, 0
%t8534 = trunc i128 %t8533 to i64
%t8535 = zext i64 %t8534 to i128
%t8536 = icmp ne i128 %t8535, %t8533
%t8537 = icmp slt i128 11170449401992604703, 0
%t8538 = or i1 %t8536, %t8537
%t8539 = zext i1 %t8538 to i8
call void @resid_conv_check(i8 %t8539)
%t8540 = add i64 2270897969802886507, 0
%t8541 = add i64 %t8540, 0
%t8542 = add i64 %t8541, 0
%t8543 = icmp ne i64 %t8542, %t8540
%t8544 = icmp slt i64 2270897969802886507, 0
%t8545 = or i1 %t8543, %t8544
%t8546 = zext i1 %t8545 to i8
call void @resid_conv_check(i8 %t8546)
%t8547 = add i64 6620516959819538809, 0
%t8548 = add i64 %t8547, 0
%t8549 = add i64 %t8548, 0
%t8550 = icmp ne i64 %t8549, %t8547
%t8551 = icmp slt i64 6620516959819538809, 0
%t8552 = or i1 %t8550, %t8551
%t8553 = zext i1 %t8552 to i8
call void @resid_conv_check(i8 %t8553)
%t8554 = alloca [8 x ptr]
%t8556 = call ptr @resid_box_i64(i64 %t8499)
%t8558 = getelementptr i8, ptr %t8554, i64 0
store ptr %t8556, ptr %t8558
%t8559 = call ptr @resid_box_i64(i64 %t8506)
%t8561 = getelementptr i8, ptr %t8554, i64 8
store ptr %t8559, ptr %t8561
%t8562 = call ptr @resid_box_i64(i64 %t8513)
%t8564 = getelementptr i8, ptr %t8554, i64 16
store ptr %t8562, ptr %t8564
%t8565 = call ptr @resid_box_i64(i64 %t8520)
%t8567 = getelementptr i8, ptr %t8554, i64 24
store ptr %t8565, ptr %t8567
%t8568 = call ptr @resid_box_i64(i64 %t8527)
%t8570 = getelementptr i8, ptr %t8554, i64 32
store ptr %t8568, ptr %t8570
%t8571 = call ptr @resid_box_i64(i64 %t8534)
%t8573 = getelementptr i8, ptr %t8554, i64 40
store ptr %t8571, ptr %t8573
%t8574 = call ptr @resid_box_i64(i64 %t8541)
%t8576 = getelementptr i8, ptr %t8554, i64 48
store ptr %t8574, ptr %t8576
%t8577 = call ptr @resid_box_i64(i64 %t8548)
%t8579 = getelementptr i8, ptr %t8554, i64 56
store ptr %t8577, ptr %t8579
%t8580 = call ptr @resid_list_new(i64 8, ptr %t8554, ptr @.lty8554)
%t8581 = call ptr @__m____________lib_sha512g_resid__g5_hash__g_Int_64__UInt_64_(ptr %p0, ptr %t8580, i64 64)
ret ptr %t8581
}
define i512 @__m____________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8582 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 32, i64 0, i512 0)
%t8583 = call i512 @eg_clamp__g_Int_512__Int_64_(i512 %t8582)
ret i512 %t8583
}
define ptr @d_lift_bytes__g_Int_64__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8584 = call ptr @resid_listbuf_new()
%t8585 = call ptr @__m____________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %p0, i64 0, ptr %t8584)
ret ptr %t8585
}
define ptr @__m____________lib_ed25519g_resid__eg_lift_bytes__g_Int_64__Int_512_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8595, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8600, %tco.s0 ]
%t8586 = call i64 @resid_list_len(ptr %p0)
%t8587 = icmp sge i64 %p1, %t8586
br i1 %t8587, label %L937, label %L939
L937:
%t8588 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8588)
ret ptr %t8588
L939:
%t8589 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t8590 = call i64 @resid_unbox_i64(ptr %t8589)
%t8592 = and i64 %t8590, 255
%t8593 = sext i64 %t8592 to i512
%t8594 = call i512 @__m____________lib_word_resid__pi_lift(i512 %t8593)
%t8595 = add nsw i64 %p1, 1
%t8596 = call i64 @__m____________lib_word_resid__pi_byte(i512 %t8594, i64 0)
%t8597 = call ptr @resid_box_i64(i64 %t8596)
%t8600 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8597)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8602 = call i64 @__m____________lib_chachag_resid__cg_le32(ptr %p2, i64 0)
%t8603 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t8602)
%t8604 = call i64 @__m____________lib_chachag_resid__cg_le32(ptr %p2, i64 4)
%t8605 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t8604)
%t8606 = call i64 @__m____________lib_chachag_resid__cg_le32(ptr %p2, i64 8)
%t8607 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t8606)
%t8608 = call ptr @__m____________lib_chachag_resid__cg_state_w__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %t8603, i64 %t8605, i64 %t8607)
ret ptr %t8608
}
define ptr @__m____________lib_chachag_resid__cg_block_st__g_Int_64__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8609 = call ptr @resid_listbuf_new()
%t8610 = call ptr @resid_list_get(ptr %p0, i64 12)
%t8611 = call i64 @resid_unbox_i64(ptr %t8610)
%t8613 = call ptr @__m____________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %t8611)
%t8614 = call ptr @__m____________lib_chachag_resid__cg_ser__g_Int_64__Int_64_(ptr %t8613, i64 0, ptr %t8609)
ret ptr %t8614
}
define ptr @__m____________lib_chachag_resid__cg_xor_run__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8627, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t8629, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t8632, %tco.s0 ]
%t8615 = call i64 @resid_list_len(ptr %p2)
%t8616 = icmp sge i64 %p3, %t8615
br i1 %t8616, label %L940, label %L942
L940:
ret ptr %p4
L942:
%t8617 = call i64 @__m____________lib_word_resid__wi_lift(i64 %p1)
%t8618 = call ptr @__m____________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %t8617)
%t8619 = call i64 @resid_list_len(ptr %p2)
%t8620 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t8619, i64 %p3)
%t8621 = extractvalue {i64, i1} %t8620, 0
%t8622 = extractvalue {i64, i1} %t8620, 1
%t8623 = zext i1 %t8622 to i8
call void @resid_overflow_check(i8 %t8623)
%t8624 = icmp slt i64 %t8621, 64
br i1 %t8624, label %L943, label %L944
L943:
br label %L945
L944:
br label %L945
L945:
%t8625 = phi i64 [ %t8621, %L943 ], [ 64, %L944 ]
%t8626 = call i64 @wrapping_add(i64 %p1, i64 1)
%t8627 = and i64 %t8626, 4294967295
%t8628 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %t8625)
%t8629 = extractvalue {i64, i1} %t8628, 0
%t8630 = extractvalue {i64, i1} %t8628, 1
%t8631 = zext i1 %t8630 to i8
call void @resid_overflow_check(i8 %t8631)
%t8632 = call ptr @__m____________lib_chachag_resid__cg_xor_bytes__g_Int_64__Int_64_(ptr %t8618, ptr %p2, i64 %p3, i64 0, i64 %t8625, ptr %p4)
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t8635, %tco.s0 ]
%p4 = phi i512 [ %p4.in, %entry ], [ %t8649, %tco.s0 ]
%t8634 = icmp sge i64 %p3, %p2
br i1 %t8634, label %L946, label %L948
L946:
ret i512 %p4
L948:
%t8635 = add nsw i64 %p3, 1
%t8636 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p3)
%t8637 = extractvalue {i64, i1} %t8636, 0
%t8638 = extractvalue {i64, i1} %t8636, 1
%t8639 = zext i1 %t8638 to i8
call void @resid_overflow_check(i8 %t8639)
%t8640 = call ptr @resid_list_get_v(ptr %p0, i64 %t8637, ptr %p0.ld, i64 %p0.ln)
%t8641 = call i64 @resid_unbox_i64(ptr %t8640)
%t8643 = call i512 @__m____________lib_word_resid__pi_from_byte(i64 %t8641)
%t8644 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p3)
%t8645 = extractvalue {i64, i1} %t8644, 0
%t8646 = extractvalue {i64, i1} %t8644, 1
%t8647 = zext i1 %t8646 to i8
call void @resid_overflow_check(i8 %t8647)
%t8648 = call i512 @__m____________lib_word_resid__pi_shl(i512 %t8643, i64 %t8645)
%t8649 = call i512 @__m____________lib_word_resid__pi_or(i512 %p4, i512 %t8648)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m____________lib_chachag_resid__pg_blocks__g_Int_512__Int_64_(i512 %p0.in, ptr %p1.in, i64 %p2.in, i512 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t8673, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8675, %tco.s0 ]
%p3 = phi i512 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t8651 = call i64 @resid_list_len(ptr %p1)
%t8652 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t8651, i64 %p2)
%t8653 = extractvalue {i64, i1} %t8652, 0
%t8654 = extractvalue {i64, i1} %t8652, 1
%t8655 = zext i1 %t8654 to i8
call void @resid_overflow_check(i8 %t8655)
%t8656 = icmp sle i64 %t8653, 0
br i1 %t8656, label %L949, label %L951
L949:
ret i512 %p0
L951:
%t8657 = icmp slt i64 %t8653, 16
br i1 %t8657, label %L952, label %L953
L952:
br label %L954
L953:
br label %L954
L954:
%t8658 = phi i64 [ %t8653, %L952 ], [ 16, %L953 ]
%t8659 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t8658, i64 8)
%t8660 = extractvalue {i64, i1} %t8659, 0
%t8661 = extractvalue {i64, i1} %t8659, 1
%t8662 = zext i1 %t8661 to i8
call void @resid_overflow_check(i8 %t8662)
%t8663 = sext i64 %t8660 to i512
%t8664 = icmp uge i512 %t8663, 512
%t8665 = add i512 %t8663, 0
%t8666 = shl i512 1, %t8665
%t8667 = select i1 %t8664, i512 0, i512 %t8666
%t8668 = call i512 @__m____________lib_word_resid__pi_lift(i512 %t8667)
%t8669 = call i512 @__m____________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p1, i64 %p2, i64 %t8658, i64 0, i512 0)
%t8670 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8669, i512 %t8668)
%t8671 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %t8670)
%t8672 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t8671, i512 %p3)
%t8673 = call i512 @__m____________lib_chachag_resid__pg_reduce__g_Int_512__Int_64_(i512 %t8672)
%t8674 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %t8658)
%t8675 = extractvalue {i64, i1} %t8674, 0
%t8676 = extractvalue {i64, i1} %t8674, 1
%t8677 = zext i1 %t8676 to i8
call void @resid_overflow_check(i8 %t8677)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__pg_bytes__g_Int_512__Int_64_(i512 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8681, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8690, %tco.s0 ]
%t8679 = icmp sge i64 %p1, 16
br i1 %t8679, label %L955, label %L957
L955:
%t8680 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8680)
ret ptr %t8680
L957:
%t8681 = add nsw i64 %p1, 1
%t8682 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p1)
%t8683 = extractvalue {i64, i1} %t8682, 0
%t8684 = extractvalue {i64, i1} %t8682, 1
%t8685 = zext i1 %t8684 to i8
call void @resid_overflow_check(i8 %t8685)
%t8686 = call i64 @__m____________lib_word_resid__pi_byte(i512 %p0, i64 %t8683)
%t8687 = call ptr @resid_box_i64(i64 %t8686)
%t8690 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8687)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8692 = call i64 @resid_list_len(ptr %p0)
%t8693 = call i64 @__m____________lib_chachag_resid__cg_pad16(i64 %t8692)
%t8694 = call ptr @resid_listbuf_new()
%t8695 = call ptr @__m____________lib_chachag_resid__cg_zeros(i64 %t8693, i64 0, ptr %t8694)
%t8696 = call ptr @resid_list_freeze(ptr %t8695)
%t8697 = call ptr @resid_list_concat(ptr %p0, ptr %t8696)
%t8698 = call i64 @resid_list_len(ptr %p1)
%t8699 = call i64 @__m____________lib_chachag_resid__cg_pad16(i64 %t8698)
%t8700 = call ptr @resid_listbuf_new()
%t8701 = call ptr @__m____________lib_chachag_resid__cg_zeros(i64 %t8699, i64 0, ptr %t8700)
%t8702 = call i64 @resid_list_len(ptr %p0)
%t8703 = call ptr @resid_listbuf_new()
%t8704 = call ptr @__m____________lib_chachag_resid__cg_le64(i64 %t8702, i64 0, ptr %t8703)
%t8705 = call ptr @resid_list_freeze(ptr %t8704)
%t8706 = call ptr @resid_list_concat_own(ptr %t8701, i8 1, ptr %t8705)
%t8707 = call i64 @resid_list_len(ptr %p1)
%t8708 = call ptr @resid_listbuf_new()
%t8709 = call ptr @__m____________lib_chachag_resid__cg_le64(i64 %t8707, i64 0, ptr %t8708)
%t8710 = call ptr @resid_list_freeze(ptr %t8709)
%t8711 = call ptr @resid_list_concat_own(ptr %t8706, i8 1, ptr %t8710)
%t8712 = call ptr @resid_listbuf_new()
%t8713 = call ptr @resid_listbuf_new()
%t8714 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t8697, i64 0, ptr %t8712)
%t8715 = call ptr @resid_list_concat_own(ptr %t8714, i8 1, ptr %p1)
%t8716 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t8711, i64 0, ptr %t8713)
%t8717 = call ptr @resid_list_freeze(ptr %t8716)
%t8718 = call ptr @resid_list_concat_own(ptr %t8715, i8 1, ptr %t8717)
ret ptr %t8718
}
define ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8726, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8730, %tco.s0 ]
%t8719 = call i64 @resid_list_len(ptr %p0)
%t8720 = icmp sge i64 %p1, %t8719
br i1 %t8720, label %L958, label %L960
L958:
%t8721 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8721)
ret ptr %t8721
L960:
%t8722 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t8723 = call i64 @resid_unbox_i64(ptr %t8722)
%t8725 = call i64 @__m____________lib_word_resid__bi_lift(i64 %t8723)
%t8726 = add nsw i64 %p1, 1
%t8727 = call ptr @resid_box_i64(i64 %t8725)
%t8730 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8727)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_sha256g_resid__g_sched__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8732 = icmp slt i64 %p2, 16
br i1 %t8732, label %L961, label %L963
L961:
%t8733 = call i64 @__m____________lib_sha256g_resid__g_word_at__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2)
ret i64 %t8733
L963:
%t8734 = call i64 @__m____________lib_sha256g_resid__g_ssig1__g_Int_64__Int_64_(i64 %p6)
%t8735 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8734, i64 %p5)
%t8736 = call i64 @__m____________lib_sha256g_resid__g_ssig0__g_Int_64__Int_64_(i64 %p4)
%t8737 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8736, i64 %p3)
%t8738 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8735, i64 %t8737)
ret i64 %t8738
}
define i64 @__m____________lib_sha256g_resid__g_bsig1__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8739 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 6)
%t8740 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 11)
%t8741 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8739, i64 %t8740)
%t8742 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 25)
%t8743 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8741, i64 %t8742)
ret i64 %t8743
}
define i64 @__m____________lib_sha256g_resid__g_ch__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8744 = call i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p1)
%t8745 = call i64 @__m____________lib_word_resid__wi_not(i64 %p0)
%t8746 = call i64 @__m____________lib_word_resid__wi_and(i64 %t8745, i64 %p2)
%t8747 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8744, i64 %t8746)
ret i64 %t8747
}
define i64 @__m____________lib_sha256g_resid__g_bsig0__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8748 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 2)
%t8749 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 13)
%t8750 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8748, i64 %t8749)
%t8751 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 22)
%t8752 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8750, i64 %t8751)
ret i64 %t8752
}
define i64 @__m____________lib_sha256g_resid__g_maj__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8753 = call i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p1)
%t8754 = call i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p2)
%t8755 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8753, i64 %t8754)
%t8756 = call i64 @__m____________lib_word_resid__wi_and(i64 %p1, i64 %p2)
%t8757 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8755, i64 %t8756)
ret i64 %t8757
}
define ptr @__m____________lib_crypto_resid__b64g_finish__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8758 = call i64 @__m____________lib_word_resid__wi_byte(i64 %p1, i64 24)
%t8759 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB8759)
%t8760 = alloca [1 x ptr]
%t8762 = call ptr @resid_box_i64(i64 %t8758)
%t8764 = getelementptr i8, ptr %t8760, i64 0
store ptr %t8762, ptr %t8764
%t8765 = call ptr @resid_list_new(i64 1, ptr %t8760, ptr @.lty8760)
%t8767 = call ptr @resid_list_const_i64(ptr @.lc8766, i64 1, ptr @.lcd8766, ptr @.lty8766)
%t8768 = call i1 @__m____________lib_crypto_resid__ct_same_pub(ptr %t8765, ptr %t8767)
%t8769 = xor i1 %t8768, true
br i1 %t8769, label %L964, label %L966
L964:
ret ptr %t8759
L966:
ret ptr %p0
}
define i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8770 = call i64 @resid_list_len(ptr %p0)
%t8771 = icmp sge i64 %p1, %t8770
br i1 %t8771, label %L967, label %L969
L967:
ret i64 0
L969:
%t8772 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t8773 = call i64 @resid_unbox_i64(ptr %t8772)
%t8775 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t8773)
%t8776 = call i64 @b64g_sextet__g_Int_64__Int_64_(i64 %t8775)
ret i64 %t8776
}
define i64 @__m____________lib_crypto_resid__b64g_join__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8777 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p0, i64 63)
%t8778 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8777, i64 18)
%t8779 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p1, i64 63)
%t8780 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8779, i64 12)
%t8781 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8778, i64 %t8780)
%t8782 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p2, i64 63)
%t8783 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8782, i64 6)
%t8784 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p3, i64 63)
%t8785 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8783, i64 %t8784)
%t8786 = call i64 @__m____________lib_word_resid__wi_or(i64 %p0, i64 %p1)
%t8787 = call i64 @__m____________lib_word_resid__wi_or(i64 %p2, i64 %p3)
%t8788 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8786, i64 %t8787)
%t8789 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8788, i64 256)
%t8790 = call i64 @__m____________lib_word_resid__wi_shr(i64 %t8789, i64 8)
%t8791 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8790, i64 24)
%t8792 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8781, i64 %t8785)
%t8793 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8792, i64 %t8791)
ret i64 %t8793
}
define ptr @__m____________lib_sha512g_resid__g5_hash__g_Int_64__UInt_64_(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8794 = call ptr @resid_listbuf_new()
%t8795 = call ptr @resid_listbuf_new()
%t8796 = call i64 @resid_list_len(ptr %p0)
%t8797 = call ptr @sha512g_pad(i64 %t8796)
%t8798 = call ptr @resid_list_freeze(ptr %t8797)
%t8799 = call ptr @__m____________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %t8798, i64 0, ptr %t8794)
%t8800 = call ptr @resid_list_freeze(ptr %t8799)
%t8801 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t8800)
%t8802 = call ptr @__m____________lib_sha512g_resid__g5_lift_state__g_UInt_64__Int_64_(ptr %p1)
%t8803 = call i64 @resid_list_len(ptr %t8801)
%t8804 = call ptr @sha512g_blocks__g_Int_64__UInt_64_(ptr %t8801, i64 0, i64 %t8803, ptr %t8802)
%t8805 = call ptr @__m____________lib_sha512g_resid__g5_out__g_UInt_64__Int_64_(ptr %t8804, i64 %p2, i64 0, ptr %t8795)
ret ptr %t8805
}
define ptr @__m____________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8813, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8818, %tco.s0 ]
%t8806 = call i64 @resid_list_len(ptr %p0)
%t8807 = icmp sge i64 %p1, %t8806
br i1 %t8807, label %L970, label %L972
L970:
%t8808 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8808)
ret ptr %t8808
L972:
%t8809 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t8810 = call i64 @resid_unbox_i64(ptr %t8809)
%t8812 = call i64 @__m____________lib_word_resid__di_lift(i64 %t8810)
%t8813 = add nsw i64 %p1, 1
%t8814 = call i64 @__m____________lib_word_resid__di_byte(i64 %t8812, i64 0)
%t8815 = call ptr @resid_box_i64(i64 %t8814)
%t8818 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8815)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__cg_state_w__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8820 = and i64 %p1, 4294967295
%t8821 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t8820)
%t8822 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 0)
%t8823 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 4)
%t8824 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 8)
%t8825 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 12)
%t8826 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 16)
%t8827 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 20)
%t8828 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 24)
%t8829 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 28)
%t8830 = alloca [16 x ptr]
%t8832 = call ptr @resid_box_i64(i64 1634760805)
%t8834 = getelementptr i8, ptr %t8830, i64 0
store ptr %t8832, ptr %t8834
%t8835 = call ptr @resid_box_i64(i64 857760878)
%t8837 = getelementptr i8, ptr %t8830, i64 8
store ptr %t8835, ptr %t8837
%t8838 = call ptr @resid_box_i64(i64 2036477234)
%t8840 = getelementptr i8, ptr %t8830, i64 16
store ptr %t8838, ptr %t8840
%t8841 = call ptr @resid_box_i64(i64 1797285236)
%t8843 = getelementptr i8, ptr %t8830, i64 24
store ptr %t8841, ptr %t8843
%t8844 = call ptr @resid_box_i64(i64 %t8822)
%t8846 = getelementptr i8, ptr %t8830, i64 32
store ptr %t8844, ptr %t8846
%t8847 = call ptr @resid_box_i64(i64 %t8823)
%t8849 = getelementptr i8, ptr %t8830, i64 40
store ptr %t8847, ptr %t8849
%t8850 = call ptr @resid_box_i64(i64 %t8824)
%t8852 = getelementptr i8, ptr %t8830, i64 48
store ptr %t8850, ptr %t8852
%t8853 = call ptr @resid_box_i64(i64 %t8825)
%t8855 = getelementptr i8, ptr %t8830, i64 56
store ptr %t8853, ptr %t8855
%t8856 = call ptr @resid_box_i64(i64 %t8826)
%t8858 = getelementptr i8, ptr %t8830, i64 64
store ptr %t8856, ptr %t8858
%t8859 = call ptr @resid_box_i64(i64 %t8827)
%t8861 = getelementptr i8, ptr %t8830, i64 72
store ptr %t8859, ptr %t8861
%t8862 = call ptr @resid_box_i64(i64 %t8828)
%t8864 = getelementptr i8, ptr %t8830, i64 80
store ptr %t8862, ptr %t8864
%t8865 = call ptr @resid_box_i64(i64 %t8829)
%t8867 = getelementptr i8, ptr %t8830, i64 88
store ptr %t8865, ptr %t8867
%t8868 = call ptr @resid_box_i64(i64 %t8821)
%t8870 = getelementptr i8, ptr %t8830, i64 96
store ptr %t8868, ptr %t8870
%t8871 = call ptr @resid_box_i64(i64 %p2)
%t8873 = getelementptr i8, ptr %t8830, i64 104
store ptr %t8871, ptr %t8873
%t8874 = call ptr @resid_box_i64(i64 %p3)
%t8876 = getelementptr i8, ptr %t8830, i64 112
store ptr %t8874, ptr %t8876
%t8877 = call ptr @resid_box_i64(i64 %p4)
%t8879 = getelementptr i8, ptr %t8830, i64 120
store ptr %t8877, ptr %t8879
%t8880 = call ptr @resid_list_new(i64 16, ptr %t8830, ptr @.lty8830)
ret ptr %t8880
}
define ptr @__m____________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8881 = call ptr @resid_list_get(ptr %p0, i64 0)
%t8882 = call i64 @resid_unbox_i64(ptr %t8881)
%t8884 = call ptr @resid_list_get(ptr %p0, i64 1)
%t8885 = call i64 @resid_unbox_i64(ptr %t8884)
%t8887 = call ptr @resid_list_get(ptr %p0, i64 2)
%t8888 = call i64 @resid_unbox_i64(ptr %t8887)
%t8890 = call ptr @resid_list_get(ptr %p0, i64 3)
%t8891 = call i64 @resid_unbox_i64(ptr %t8890)
%t8893 = call ptr @resid_list_get(ptr %p0, i64 4)
%t8894 = call i64 @resid_unbox_i64(ptr %t8893)
%t8896 = call ptr @resid_list_get(ptr %p0, i64 5)
%t8897 = call i64 @resid_unbox_i64(ptr %t8896)
%t8899 = call ptr @resid_list_get(ptr %p0, i64 6)
%t8900 = call i64 @resid_unbox_i64(ptr %t8899)
%t8902 = call ptr @resid_list_get(ptr %p0, i64 7)
%t8903 = call i64 @resid_unbox_i64(ptr %t8902)
%t8905 = call ptr @resid_list_get(ptr %p0, i64 8)
%t8906 = call i64 @resid_unbox_i64(ptr %t8905)
%t8908 = call ptr @resid_list_get(ptr %p0, i64 9)
%t8909 = call i64 @resid_unbox_i64(ptr %t8908)
%t8911 = call ptr @resid_list_get(ptr %p0, i64 10)
%t8912 = call i64 @resid_unbox_i64(ptr %t8911)
%t8914 = call ptr @resid_list_get(ptr %p0, i64 11)
%t8915 = call i64 @resid_unbox_i64(ptr %t8914)
%t8917 = call ptr @resid_list_get(ptr %p0, i64 13)
%t8918 = call i64 @resid_unbox_i64(ptr %t8917)
%t8920 = call ptr @resid_list_get(ptr %p0, i64 14)
%t8921 = call i64 @resid_unbox_i64(ptr %t8920)
%t8923 = call ptr @resid_list_get(ptr %p0, i64 15)
%t8924 = call i64 @resid_unbox_i64(ptr %t8923)
%t8926 = call ptr @__m____________lib_chachag_resid__cg_core__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 10, i64 %t8882, i64 %t8885, i64 %t8888, i64 %t8891, i64 %t8894, i64 %t8897, i64 %t8900, i64 %t8903, i64 %t8906, i64 %t8909, i64 %t8912, i64 %t8915, i64 %p1, i64 %t8918, i64 %t8921, i64 %t8924)
ret ptr %t8926
}
define ptr @__m____________lib_chachag_resid__cg_ser__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8929, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8940, %tco.s0 ]
%t8927 = icmp sge i64 %p1, 64
br i1 %t8927, label %L973, label %L975
L973:
%t8928 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8928)
ret ptr %t8928
L975:
%t8929 = add nsw i64 %p1, 1
%t8930 = sdiv i64 %p1, 4
%t8931 = call ptr @resid_list_get_v(ptr %p0, i64 %t8930, ptr %p0.ld, i64 %p0.ln)
%t8932 = call i64 @resid_unbox_i64(ptr %t8931)
%t8934 = srem i64 %p1, 4
%t8935 = mul nsw i64 %t8934, 8
%t8936 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8932, i64 %t8935)
%t8937 = call ptr @resid_box_i64(i64 %t8936)
%t8940 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8937)
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t8943, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi ptr [ %p5.in, %entry ], [ %t8962, %tco.s0 ]
%t8942 = icmp sge i64 %p3, %p4
br i1 %t8942, label %L976, label %L978
L976:
ret ptr %p5
L978:
%t8943 = add nsw i64 %p3, 1
%t8944 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %p3)
%t8945 = extractvalue {i64, i1} %t8944, 0
%t8946 = extractvalue {i64, i1} %t8944, 1
%t8947 = zext i1 %t8946 to i8
call void @resid_overflow_check(i8 %t8947)
%t8948 = call ptr @resid_list_get_v(ptr %p1, i64 %t8945, ptr %p1.ld, i64 %p1.ln)
%t8949 = call i64 @resid_unbox_i64(ptr %t8948)
%t8951 = sdiv i64 %p3, 4
%t8952 = call ptr @resid_list_get_v(ptr %p0, i64 %t8951, ptr %p0.ld, i64 %p0.ln)
%t8953 = call i64 @resid_unbox_i64(ptr %t8952)
%t8955 = srem i64 %p3, 4
%t8956 = mul nsw i64 %t8955, 8
%t8957 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8953, i64 %t8956)
%t8958 = call i64 @__m____________lib_word_resid__bi_xor(i64 %t8949, i64 %t8957)
%t8959 = call ptr @resid_box_i64(i64 %t8958)
%t8962 = call ptr @resid_listbuf_push(ptr %p5, ptr %t8959)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m____________lib_chachag_resid__pg_reduce__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8964 = sext i256 1361129467683753853853498429727072845823 to i512
%t8965 = call i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %t8964)
%t8966 = call i512 @__m____________lib_word_resid__pi_shr(i512 %p0, i64 130)
%t8967 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t8966, i512 5)
%t8968 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8965, i512 %t8967)
%t8969 = sext i256 1361129467683753853853498429727072845823 to i512
%t8970 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8968, i512 %t8969)
%t8971 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t8968, i64 130)
%t8972 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t8971, i512 5)
%t8973 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8970, i512 %t8972)
%t8974 = sext i256 1361129467683753853853498429727072845819 to i512
%t8975 = call i512 @__m____________lib_word_resid__pi_sub(i512 %t8973, i512 %t8974)
%t8976 = call i512 @__m____________lib_word_resid__pi_sign(i512 %t8975)
%t8977 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8973, i512 %t8976)
%t8978 = sext i64 -1 to i512
%t8979 = call i512 @__m____________lib_word_resid__pi_xor(i512 %t8976, i512 %t8978)
%t8980 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8975, i512 %t8979)
%t8981 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8977, i512 %t8980)
ret i512 %t8981
}
define i64 @__m____________lib_sha256g_resid__g_word_at__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8982 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t8983 = extractvalue {i64, i1} %t8982, 0
%t8984 = extractvalue {i64, i1} %t8982, 1
%t8985 = zext i1 %t8984 to i8
call void @resid_overflow_check(i8 %t8985)
%t8986 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t8983)
%t8987 = extractvalue {i64, i1} %t8986, 0
%t8988 = extractvalue {i64, i1} %t8986, 1
%t8989 = zext i1 %t8988 to i8
call void @resid_overflow_check(i8 %t8989)
%t8990 = call ptr @resid_list_get(ptr %p0, i64 %t8987)
%t8991 = call i64 @resid_unbox_i64(ptr %t8990)
%t8993 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t8991)
%t8994 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8993, i64 24)
%t8995 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t8987, i64 1)
%t8996 = extractvalue {i64, i1} %t8995, 0
%t8997 = extractvalue {i64, i1} %t8995, 1
%t8998 = zext i1 %t8997 to i8
call void @resid_overflow_check(i8 %t8998)
%t8999 = call ptr @resid_list_get(ptr %p0, i64 %t8996)
%t9000 = call i64 @resid_unbox_i64(ptr %t8999)
%t9002 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9000)
%t9003 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9002, i64 16)
%t9004 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8994, i64 %t9003)
%t9005 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t8987, i64 2)
%t9006 = extractvalue {i64, i1} %t9005, 0
%t9007 = extractvalue {i64, i1} %t9005, 1
%t9008 = zext i1 %t9007 to i8
call void @resid_overflow_check(i8 %t9008)
%t9009 = call ptr @resid_list_get(ptr %p0, i64 %t9006)
%t9010 = call i64 @resid_unbox_i64(ptr %t9009)
%t9012 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9010)
%t9013 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9012, i64 8)
%t9014 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t8987, i64 3)
%t9015 = extractvalue {i64, i1} %t9014, 0
%t9016 = extractvalue {i64, i1} %t9014, 1
%t9017 = zext i1 %t9016 to i8
call void @resid_overflow_check(i8 %t9017)
%t9018 = call ptr @resid_list_get(ptr %p0, i64 %t9015)
%t9019 = call i64 @resid_unbox_i64(ptr %t9018)
%t9021 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9019)
%t9022 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9013, i64 %t9021)
%t9023 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9004, i64 %t9022)
ret i64 %t9023
}
define i64 @__m____________lib_sha256g_resid__g_ssig1__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9024 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 17)
%t9025 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 19)
%t9026 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9024, i64 %t9025)
%t9027 = call i64 @__m____________lib_word_resid__wi_shr(i64 %p0, i64 10)
%t9028 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9026, i64 %t9027)
ret i64 %t9028
}
define i64 @__m____________lib_sha256g_resid__g_ssig0__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9029 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 7)
%t9030 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 18)
%t9031 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9029, i64 %t9030)
%t9032 = call i64 @__m____________lib_word_resid__wi_shr(i64 %p0, i64 3)
%t9033 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9031, i64 %t9032)
ret i64 %t9033
}
define i64 @b64g_sextet__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9034 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 65, i64 90)
%t9035 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 97, i64 122)
%t9036 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 48, i64 57)
%t9037 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 43, i64 43)
%t9038 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 47, i64 47)
%t9039 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9034)
%t9040 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 -65)
%t9041 = call i64 @__m____________lib_word_resid__wi_and(i64 %t9039, i64 %t9040)
%t9042 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9035)
%t9043 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 -71)
%t9044 = call i64 @__m____________lib_word_resid__wi_and(i64 %t9042, i64 %t9043)
%t9045 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9041, i64 %t9044)
%t9046 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9036)
%t9047 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 4)
%t9048 = call i64 @__m____________lib_word_resid__wi_and(i64 %t9046, i64 %t9047)
%t9049 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9037)
%t9050 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t9049, i64 62)
%t9051 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9038)
%t9052 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t9051, i64 63)
%t9053 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9050, i64 %t9052)
%t9054 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9048, i64 %t9053)
%t9055 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9034, i64 %t9035)
%t9056 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9037, i64 %t9038)
%t9057 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9036, i64 %t9056)
%t9058 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9055, i64 %t9057)
%t9059 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9045, i64 %t9054)
%t9060 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t9059, i64 63)
%t9061 = call i64 @__m____________lib_word_resid__wi_xork(i64 %t9058, i64 1)
%t9062 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9061, i64 8)
%t9063 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9060, i64 %t9062)
ret i64 %t9063
}
define ptr @__m____________lib_sha512g_resid__g5_lift_state__g_UInt_64__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9064 = call ptr @resid_gmalloc(i64 64)
%t9065 = call ptr @resid_list_get(ptr %p0, i64 0)
%t9066 = call i64 @resid_unbox_i64(ptr %t9065)
%t9068 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9066)
%t9064.f0 = getelementptr i8, ptr %t9064, i64 0
store i64 %t9068, ptr %t9064.f0, align 8
%t9069 = call ptr @resid_list_get(ptr %p0, i64 1)
%t9070 = call i64 @resid_unbox_i64(ptr %t9069)
%t9072 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9070)
%t9064.f1 = getelementptr i8, ptr %t9064, i64 8
store i64 %t9072, ptr %t9064.f1, align 8
%t9073 = call ptr @resid_list_get(ptr %p0, i64 2)
%t9074 = call i64 @resid_unbox_i64(ptr %t9073)
%t9076 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9074)
%t9064.f2 = getelementptr i8, ptr %t9064, i64 16
store i64 %t9076, ptr %t9064.f2, align 8
%t9077 = call ptr @resid_list_get(ptr %p0, i64 3)
%t9078 = call i64 @resid_unbox_i64(ptr %t9077)
%t9080 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9078)
%t9064.f3 = getelementptr i8, ptr %t9064, i64 24
store i64 %t9080, ptr %t9064.f3, align 8
%t9081 = call ptr @resid_list_get(ptr %p0, i64 4)
%t9082 = call i64 @resid_unbox_i64(ptr %t9081)
%t9084 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9082)
%t9064.f4 = getelementptr i8, ptr %t9064, i64 32
store i64 %t9084, ptr %t9064.f4, align 8
%t9085 = call ptr @resid_list_get(ptr %p0, i64 5)
%t9086 = call i64 @resid_unbox_i64(ptr %t9085)
%t9088 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9086)
%t9064.f5 = getelementptr i8, ptr %t9064, i64 40
store i64 %t9088, ptr %t9064.f5, align 8
%t9089 = call ptr @resid_list_get(ptr %p0, i64 6)
%t9090 = call i64 @resid_unbox_i64(ptr %t9089)
%t9092 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9090)
%t9064.f6 = getelementptr i8, ptr %t9064, i64 48
store i64 %t9092, ptr %t9064.f6, align 8
%t9093 = call ptr @resid_list_get(ptr %p0, i64 7)
%t9094 = call i64 @resid_unbox_i64(ptr %t9093)
%t9096 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9094)
%t9064.f7 = getelementptr i8, ptr %t9064, i64 56
store i64 %t9096, ptr %t9064.f7, align 8
ret ptr %t9064
}
define ptr @sha512g_blocks__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9099, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t9097 = icmp sge i64 %p1, %p2
br i1 %t9097, label %L979, label %L981
L979:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L981:
%t9098 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 128)
%t9099 = extractvalue {i64, i1} %t9098, 0
%t9100 = extractvalue {i64, i1} %t9098, 1
%t9101 = zext i1 %t9100 to i8
call void @resid_overflow_check(i8 %t9101)
%t9102 = call ptr @sha512g_block__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %p3)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %t9102, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t9102, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_sha512g_resid__g5_out__g_UInt_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9106, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t9116, %tco.s0 ]
%t9104 = icmp sge i64 %p2, %p1
br i1 %t9104, label %L982, label %L984
L982:
%t9105 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty9105)
ret ptr %t9105
L984:
%t9106 = add nsw i64 %p2, 1
%t9107 = sdiv i64 %p2, 8
%t9108 = call i64 @__m____________lib_sha512g_resid__g5_state_word__g_UInt_64__Int_64_(ptr %p0, i64 %t9107)
%t9109 = srem i64 %p2, 8
%t9110 = mul nsw i64 %t9109, 8
%t9111 = sub nsw i64 56, %t9110
%t9112 = call i64 @__m____________lib_word_resid__di_byte(i64 %t9108, i64 %t9111)
%t9113 = call ptr @resid_box_i64(i64 %t9112)
%t9116 = call ptr @resid_listbuf_push(ptr %p3, ptr %t9113)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9118 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t9119 = call i64 @resid_unbox_i64(ptr %t9118)
%t9121 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9119)
%t9122 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t9123 = extractvalue {i64, i1} %t9122, 0
%t9124 = extractvalue {i64, i1} %t9122, 1
%t9125 = zext i1 %t9124 to i8
call void @resid_overflow_check(i8 %t9125)
%t9126 = call ptr @resid_list_get(ptr %p0, i64 %t9123)
%t9127 = call i64 @resid_unbox_i64(ptr %t9126)
%t9129 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9127)
%t9130 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9129, i64 8)
%t9131 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9121, i64 %t9130)
%t9132 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t9133 = extractvalue {i64, i1} %t9132, 0
%t9134 = extractvalue {i64, i1} %t9132, 1
%t9135 = zext i1 %t9134 to i8
call void @resid_overflow_check(i8 %t9135)
%t9136 = call ptr @resid_list_get(ptr %p0, i64 %t9133)
%t9137 = call i64 @resid_unbox_i64(ptr %t9136)
%t9139 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9137)
%t9140 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9139, i64 16)
%t9141 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 3)
%t9142 = extractvalue {i64, i1} %t9141, 0
%t9143 = extractvalue {i64, i1} %t9141, 1
%t9144 = zext i1 %t9143 to i8
call void @resid_overflow_check(i8 %t9144)
%t9145 = call ptr @resid_list_get(ptr %p0, i64 %t9142)
%t9146 = call i64 @resid_unbox_i64(ptr %t9145)
%t9148 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9146)
%t9149 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9148, i64 24)
%t9150 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9140, i64 %t9149)
%t9151 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9131, i64 %t9150)
ret i64 %t9151
}
define ptr @__m____________lib_chachag_resid__cg_core__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9214 = alloca [16 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9362, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9319, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t9331, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t9343, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t9355, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %t9360, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t9324, %tco.s0.k ]
%p9 = phi i64 [ %p9.in, %entry ], [ %t9336, %tco.s0.k ]
%p10 = phi i64 [ %p10.in, %entry ], [ %t9348, %tco.s0.k ]
%p11 = phi i64 [ %p11.in, %entry ], [ %t9346, %tco.s0.k ]
%p12 = phi i64 [ %p12.in, %entry ], [ %t9358, %tco.s0.k ]
%p13 = phi i64 [ %p13.in, %entry ], [ %t9322, %tco.s0.k ]
%p14 = phi i64 [ %p14.in, %entry ], [ %t9334, %tco.s0.k ]
%p15 = phi i64 [ %p15.in, %entry ], [ %t9333, %tco.s0.k ]
%p16 = phi i64 [ %p16.in, %entry ], [ %t9345, %tco.s0.k ]
%p17 = phi i64 [ %p17.in, %entry ], [ %t9357, %tco.s0.k ]
%p18 = phi i64 [ %p18.in, %entry ], [ %t9321, %tco.s0.k ]
%t9152 = icmp eq i64 %p2, 0
br i1 %t9152, label %L985, label %L987
L985:
%t9153 = call ptr @resid_list_get_v(ptr %p0, i64 0, ptr %p0.ld, i64 %p0.ln)
%t9154 = call i64 @resid_unbox_i64(ptr %t9153)
%t9156 = call i64 @__m____________lib_word_resid__wi_add(i64 %p3, i64 %t9154)
%t9157 = call ptr @resid_list_get_v(ptr %p0, i64 1, ptr %p0.ld, i64 %p0.ln)
%t9158 = call i64 @resid_unbox_i64(ptr %t9157)
%t9160 = call i64 @__m____________lib_word_resid__wi_add(i64 %p4, i64 %t9158)
%t9161 = call ptr @resid_list_get_v(ptr %p0, i64 2, ptr %p0.ld, i64 %p0.ln)
%t9162 = call i64 @resid_unbox_i64(ptr %t9161)
%t9164 = call i64 @__m____________lib_word_resid__wi_add(i64 %p5, i64 %t9162)
%t9165 = call ptr @resid_list_get_v(ptr %p0, i64 3, ptr %p0.ld, i64 %p0.ln)
%t9166 = call i64 @resid_unbox_i64(ptr %t9165)
%t9168 = call i64 @__m____________lib_word_resid__wi_add(i64 %p6, i64 %t9166)
%t9169 = call ptr @resid_list_get_v(ptr %p0, i64 4, ptr %p0.ld, i64 %p0.ln)
%t9170 = call i64 @resid_unbox_i64(ptr %t9169)
%t9172 = call i64 @__m____________lib_word_resid__wi_add(i64 %p7, i64 %t9170)
%t9173 = call ptr @resid_list_get_v(ptr %p0, i64 5, ptr %p0.ld, i64 %p0.ln)
%t9174 = call i64 @resid_unbox_i64(ptr %t9173)
%t9176 = call i64 @__m____________lib_word_resid__wi_add(i64 %p8, i64 %t9174)
%t9177 = call ptr @resid_list_get_v(ptr %p0, i64 6, ptr %p0.ld, i64 %p0.ln)
%t9178 = call i64 @resid_unbox_i64(ptr %t9177)
%t9180 = call i64 @__m____________lib_word_resid__wi_add(i64 %p9, i64 %t9178)
%t9181 = call ptr @resid_list_get_v(ptr %p0, i64 7, ptr %p0.ld, i64 %p0.ln)
%t9182 = call i64 @resid_unbox_i64(ptr %t9181)
%t9184 = call i64 @__m____________lib_word_resid__wi_add(i64 %p10, i64 %t9182)
%t9185 = call ptr @resid_list_get_v(ptr %p0, i64 8, ptr %p0.ld, i64 %p0.ln)
%t9186 = call i64 @resid_unbox_i64(ptr %t9185)
%t9188 = call i64 @__m____________lib_word_resid__wi_add(i64 %p11, i64 %t9186)
%t9189 = call ptr @resid_list_get_v(ptr %p0, i64 9, ptr %p0.ld, i64 %p0.ln)
%t9190 = call i64 @resid_unbox_i64(ptr %t9189)
%t9192 = call i64 @__m____________lib_word_resid__wi_add(i64 %p12, i64 %t9190)
%t9193 = call ptr @resid_list_get_v(ptr %p0, i64 10, ptr %p0.ld, i64 %p0.ln)
%t9194 = call i64 @resid_unbox_i64(ptr %t9193)
%t9196 = call i64 @__m____________lib_word_resid__wi_add(i64 %p13, i64 %t9194)
%t9197 = call ptr @resid_list_get_v(ptr %p0, i64 11, ptr %p0.ld, i64 %p0.ln)
%t9198 = call i64 @resid_unbox_i64(ptr %t9197)
%t9200 = call i64 @__m____________lib_word_resid__wi_add(i64 %p14, i64 %t9198)
%t9201 = call i64 @__m____________lib_word_resid__wi_add(i64 %p15, i64 %p1)
%t9202 = call ptr @resid_list_get_v(ptr %p0, i64 13, ptr %p0.ld, i64 %p0.ln)
%t9203 = call i64 @resid_unbox_i64(ptr %t9202)
%t9205 = call i64 @__m____________lib_word_resid__wi_add(i64 %p16, i64 %t9203)
%t9206 = call ptr @resid_list_get_v(ptr %p0, i64 14, ptr %p0.ld, i64 %p0.ln)
%t9207 = call i64 @resid_unbox_i64(ptr %t9206)
%t9209 = call i64 @__m____________lib_word_resid__wi_add(i64 %p17, i64 %t9207)
%t9210 = call ptr @resid_list_get_v(ptr %p0, i64 15, ptr %p0.ld, i64 %p0.ln)
%t9211 = call i64 @resid_unbox_i64(ptr %t9210)
%t9213 = call i64 @__m____________lib_word_resid__wi_add(i64 %p18, i64 %t9211)
%t9216 = call ptr @resid_box_i64(i64 %t9156)
%t9218 = getelementptr i8, ptr %t9214, i64 0
store ptr %t9216, ptr %t9218
%t9219 = call ptr @resid_box_i64(i64 %t9160)
%t9221 = getelementptr i8, ptr %t9214, i64 8
store ptr %t9219, ptr %t9221
%t9222 = call ptr @resid_box_i64(i64 %t9164)
%t9224 = getelementptr i8, ptr %t9214, i64 16
store ptr %t9222, ptr %t9224
%t9225 = call ptr @resid_box_i64(i64 %t9168)
%t9227 = getelementptr i8, ptr %t9214, i64 24
store ptr %t9225, ptr %t9227
%t9228 = call ptr @resid_box_i64(i64 %t9172)
%t9230 = getelementptr i8, ptr %t9214, i64 32
store ptr %t9228, ptr %t9230
%t9231 = call ptr @resid_box_i64(i64 %t9176)
%t9233 = getelementptr i8, ptr %t9214, i64 40
store ptr %t9231, ptr %t9233
%t9234 = call ptr @resid_box_i64(i64 %t9180)
%t9236 = getelementptr i8, ptr %t9214, i64 48
store ptr %t9234, ptr %t9236
%t9237 = call ptr @resid_box_i64(i64 %t9184)
%t9239 = getelementptr i8, ptr %t9214, i64 56
store ptr %t9237, ptr %t9239
%t9240 = call ptr @resid_box_i64(i64 %t9188)
%t9242 = getelementptr i8, ptr %t9214, i64 64
store ptr %t9240, ptr %t9242
%t9243 = call ptr @resid_box_i64(i64 %t9192)
%t9245 = getelementptr i8, ptr %t9214, i64 72
store ptr %t9243, ptr %t9245
%t9246 = call ptr @resid_box_i64(i64 %t9196)
%t9248 = getelementptr i8, ptr %t9214, i64 80
store ptr %t9246, ptr %t9248
%t9249 = call ptr @resid_box_i64(i64 %t9200)
%t9251 = getelementptr i8, ptr %t9214, i64 88
store ptr %t9249, ptr %t9251
%t9252 = call ptr @resid_box_i64(i64 %t9201)
%t9254 = getelementptr i8, ptr %t9214, i64 96
store ptr %t9252, ptr %t9254
%t9255 = call ptr @resid_box_i64(i64 %t9205)
%t9257 = getelementptr i8, ptr %t9214, i64 104
store ptr %t9255, ptr %t9257
%t9258 = call ptr @resid_box_i64(i64 %t9209)
%t9260 = getelementptr i8, ptr %t9214, i64 112
store ptr %t9258, ptr %t9260
%t9261 = call ptr @resid_box_i64(i64 %t9213)
%t9263 = getelementptr i8, ptr %t9214, i64 120
store ptr %t9261, ptr %t9263
%t9264 = call ptr @resid_list_new(i64 16, ptr %t9214, ptr @.lty9214)
%lr.cx124 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz124 = icmp eq ptr %lr.cx124, null
br i1 %lr.lz124, label %lr.x124.k, label %lr.x124.m
lr.x124.k:
ret ptr %t9264
lr.x124.m:
%lr.ret124 = call ptr @resid_mv_list(ptr %t9264, ptr %lr.cx124)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret124
L987:
%t9265 = call i64 @__m____________lib_word_resid__wi_add(i64 %p3, i64 %p7)
%t9266 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p15, i64 %t9265)
%t9267 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9266, i64 16)
%t9268 = call i64 @__m____________lib_word_resid__wi_add(i64 %p11, i64 %t9267)
%t9269 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p7, i64 %t9268)
%t9270 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9269, i64 20)
%t9271 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9265, i64 %t9270)
%t9272 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9267, i64 %t9271)
%t9273 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9272, i64 24)
%t9274 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9268, i64 %t9273)
%t9275 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9270, i64 %t9274)
%t9276 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9275, i64 25)
%t9277 = call i64 @__m____________lib_word_resid__wi_add(i64 %p4, i64 %p8)
%t9278 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p16, i64 %t9277)
%t9279 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9278, i64 16)
%t9280 = call i64 @__m____________lib_word_resid__wi_add(i64 %p12, i64 %t9279)
%t9281 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p8, i64 %t9280)
%t9282 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9281, i64 20)
%t9283 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9277, i64 %t9282)
%t9284 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9279, i64 %t9283)
%t9285 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9284, i64 24)
%t9286 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9280, i64 %t9285)
%t9287 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9282, i64 %t9286)
%t9288 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9287, i64 25)
%t9289 = call i64 @__m____________lib_word_resid__wi_add(i64 %p5, i64 %p9)
%t9290 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p17, i64 %t9289)
%t9291 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9290, i64 16)
%t9292 = call i64 @__m____________lib_word_resid__wi_add(i64 %p13, i64 %t9291)
%t9293 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p9, i64 %t9292)
%t9294 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9293, i64 20)
%t9295 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9289, i64 %t9294)
%t9296 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9291, i64 %t9295)
%t9297 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9296, i64 24)
%t9298 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9292, i64 %t9297)
%t9299 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9294, i64 %t9298)
%t9300 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9299, i64 25)
%t9301 = call i64 @__m____________lib_word_resid__wi_add(i64 %p6, i64 %p10)
%t9302 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p18, i64 %t9301)
%t9303 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9302, i64 16)
%t9304 = call i64 @__m____________lib_word_resid__wi_add(i64 %p14, i64 %t9303)
%t9305 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p10, i64 %t9304)
%t9306 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9305, i64 20)
%t9307 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9301, i64 %t9306)
%t9308 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9303, i64 %t9307)
%t9309 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9308, i64 24)
%t9310 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9304, i64 %t9309)
%t9311 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9306, i64 %t9310)
%t9312 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9311, i64 25)
%t9313 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9271, i64 %t9288)
%t9314 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9309, i64 %t9313)
%t9315 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9314, i64 16)
%t9316 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9298, i64 %t9315)
%t9317 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9288, i64 %t9316)
%t9318 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9317, i64 20)
%t9319 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9313, i64 %t9318)
%t9320 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9315, i64 %t9319)
%t9321 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9320, i64 24)
%t9322 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9316, i64 %t9321)
%t9323 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9318, i64 %t9322)
%t9324 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9323, i64 25)
%t9325 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9283, i64 %t9300)
%t9326 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9273, i64 %t9325)
%t9327 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9326, i64 16)
%t9328 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9310, i64 %t9327)
%t9329 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9300, i64 %t9328)
%t9330 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9329, i64 20)
%t9331 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9325, i64 %t9330)
%t9332 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9327, i64 %t9331)
%t9333 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9332, i64 24)
%t9334 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9328, i64 %t9333)
%t9335 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9330, i64 %t9334)
%t9336 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9335, i64 25)
%t9337 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9295, i64 %t9312)
%t9338 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9285, i64 %t9337)
%t9339 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9338, i64 16)
%t9340 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9274, i64 %t9339)
%t9341 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9312, i64 %t9340)
%t9342 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9341, i64 20)
%t9343 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9337, i64 %t9342)
%t9344 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9339, i64 %t9343)
%t9345 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9344, i64 24)
%t9346 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9340, i64 %t9345)
%t9347 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9342, i64 %t9346)
%t9348 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9347, i64 25)
%t9349 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9307, i64 %t9276)
%t9350 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9297, i64 %t9349)
%t9351 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9350, i64 16)
%t9352 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9286, i64 %t9351)
%t9353 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9276, i64 %t9352)
%t9354 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9353, i64 20)
%t9355 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9349, i64 %t9354)
%t9356 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9351, i64 %t9355)
%t9357 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9356, i64 24)
%t9358 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9352, i64 %t9357)
%t9359 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9354, i64 %t9358)
%t9360 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9359, i64 25)
%t9361 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 1)
%t9362 = extractvalue {i64, i1} %t9361, 0
%t9363 = extractvalue {i64, i1} %t9361, 1
%t9364 = zext i1 %t9363 to i8
call void @resid_overflow_check(i8 %t9364)
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
%t9366 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p1)
%t9367 = extractvalue {i64, i1} %t9366, 0
%t9368 = extractvalue {i64, i1} %t9366, 1
%t9369 = zext i1 %t9368 to i8
call void @resid_overflow_check(i8 %t9369)
%t9370 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 %t9367)
%t9371 = call i64 @__m____________lib_word_resid__wi_not(i64 %p0)
%t9372 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t9373 = extractvalue {i64, i1} %t9372, 0
%t9374 = extractvalue {i64, i1} %t9372, 1
%t9375 = zext i1 %t9374 to i8
call void @resid_overflow_check(i8 %t9375)
%t9376 = call i64 @__m____________lib_word_resid__wi_addk(i64 %t9371, i64 %t9373)
%t9377 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9370, i64 %t9376)
%t9378 = call i64 @__m____________lib_word_resid__wi_shr(i64 %t9377, i64 31)
%t9379 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t9378, i64 1)
%t9380 = call i64 @__m____________lib_word_resid__wi_xork(i64 %t9379, i64 1)
ret i64 %t9380
}
define i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9381 = call i64 @__m____________lib_word_resid__wi_not(i64 %p0)
%t9382 = call i64 @__m____________lib_word_resid__wi_addk(i64 %t9381, i64 1)
ret i64 %t9382
}
define ptr @sha512g_block__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9383 = add i64 4794697086780616226, 0
%t9384 = add i64 %t9383, 0
%t9385 = add i64 %t9384, 0
%t9386 = icmp ne i64 %t9385, %t9383
%t9387 = icmp slt i64 4794697086780616226, 0
%t9388 = or i1 %t9386, %t9387
%t9389 = zext i1 %t9388 to i8
call void @resid_conv_check(i8 %t9389)
%t9390 = add i64 8158064640168781261, 0
%t9391 = add i64 %t9390, 0
%t9392 = add i64 %t9391, 0
%t9393 = icmp ne i64 %t9392, %t9390
%t9394 = icmp slt i64 8158064640168781261, 0
%t9395 = or i1 %t9393, %t9394
%t9396 = zext i1 %t9395 to i8
call void @resid_conv_check(i8 %t9396)
%t9397 = add i128 13096744586834688815, 0
%t9398 = trunc i128 %t9397 to i64
%t9399 = zext i64 %t9398 to i128
%t9400 = icmp ne i128 %t9399, %t9397
%t9401 = icmp slt i128 13096744586834688815, 0
%t9402 = or i1 %t9400, %t9401
%t9403 = zext i1 %t9402 to i8
call void @resid_conv_check(i8 %t9403)
%t9404 = add i128 16840607885511220156, 0
%t9405 = trunc i128 %t9404 to i64
%t9406 = zext i64 %t9405 to i128
%t9407 = icmp ne i128 %t9406, %t9404
%t9408 = icmp slt i128 16840607885511220156, 0
%t9409 = or i1 %t9407, %t9408
%t9410 = zext i1 %t9409 to i8
call void @resid_conv_check(i8 %t9410)
%t9411 = add i64 4131703408338449720, 0
%t9412 = add i64 %t9411, 0
%t9413 = add i64 %t9412, 0
%t9414 = icmp ne i64 %t9413, %t9411
%t9415 = icmp slt i64 4131703408338449720, 0
%t9416 = or i1 %t9414, %t9415
%t9417 = zext i1 %t9416 to i8
call void @resid_conv_check(i8 %t9417)
%t9418 = add i64 6480981068601479193, 0
%t9419 = add i64 %t9418, 0
%t9420 = add i64 %t9419, 0
%t9421 = icmp ne i64 %t9420, %t9418
%t9422 = icmp slt i64 6480981068601479193, 0
%t9423 = or i1 %t9421, %t9422
%t9424 = zext i1 %t9423 to i8
call void @resid_conv_check(i8 %t9424)
%t9425 = add i128 10538285296894168987, 0
%t9426 = trunc i128 %t9425 to i64
%t9427 = zext i64 %t9426 to i128
%t9428 = icmp ne i128 %t9427, %t9425
%t9429 = icmp slt i128 10538285296894168987, 0
%t9430 = or i1 %t9428, %t9429
%t9431 = zext i1 %t9430 to i8
call void @resid_conv_check(i8 %t9431)
%t9432 = add i128 12329834152419229976, 0
%t9433 = trunc i128 %t9432 to i64
%t9434 = zext i64 %t9433 to i128
%t9435 = icmp ne i128 %t9434, %t9432
%t9436 = icmp slt i128 12329834152419229976, 0
%t9437 = or i1 %t9435, %t9436
%t9438 = zext i1 %t9437 to i8
call void @resid_conv_check(i8 %t9438)
%t9439 = add i128 15566598209576043074, 0
%t9440 = trunc i128 %t9439 to i64
%t9441 = zext i64 %t9440 to i128
%t9442 = icmp ne i128 %t9441, %t9439
%t9443 = icmp slt i128 15566598209576043074, 0
%t9444 = or i1 %t9442, %t9443
%t9445 = zext i1 %t9444 to i8
call void @resid_conv_check(i8 %t9445)
%t9446 = add i64 1334009975649890238, 0
%t9447 = add i64 %t9446, 0
%t9448 = add i64 %t9447, 0
%t9449 = icmp ne i64 %t9448, %t9446
%t9450 = icmp slt i64 1334009975649890238, 0
%t9451 = or i1 %t9449, %t9450
%t9452 = zext i1 %t9451 to i8
call void @resid_conv_check(i8 %t9452)
%t9453 = add i64 2608012711638119052, 0
%t9454 = add i64 %t9453, 0
%t9455 = add i64 %t9454, 0
%t9456 = icmp ne i64 %t9455, %t9453
%t9457 = icmp slt i64 2608012711638119052, 0
%t9458 = or i1 %t9456, %t9457
%t9459 = zext i1 %t9458 to i8
call void @resid_conv_check(i8 %t9459)
%t9460 = add i64 6128411473006802146, 0
%t9461 = add i64 %t9460, 0
%t9462 = add i64 %t9461, 0
%t9463 = icmp ne i64 %t9462, %t9460
%t9464 = icmp slt i64 6128411473006802146, 0
%t9465 = or i1 %t9463, %t9464
%t9466 = zext i1 %t9465 to i8
call void @resid_conv_check(i8 %t9466)
%t9467 = add i64 8268148722764581231, 0
%t9468 = add i64 %t9467, 0
%t9469 = add i64 %t9468, 0
%t9470 = icmp ne i64 %t9469, %t9467
%t9471 = icmp slt i64 8268148722764581231, 0
%t9472 = or i1 %t9470, %t9471
%t9473 = zext i1 %t9472 to i8
call void @resid_conv_check(i8 %t9473)
%t9474 = add i128 9286055187155687089, 0
%t9475 = trunc i128 %t9474 to i64
%t9476 = zext i64 %t9475 to i128
%t9477 = icmp ne i128 %t9476, %t9474
%t9478 = icmp slt i128 9286055187155687089, 0
%t9479 = or i1 %t9477, %t9478
%t9480 = zext i1 %t9479 to i8
call void @resid_conv_check(i8 %t9480)
%t9481 = add i128 11230858885718282805, 0
%t9482 = trunc i128 %t9481 to i64
%t9483 = zext i64 %t9482 to i128
%t9484 = icmp ne i128 %t9483, %t9481
%t9485 = icmp slt i128 11230858885718282805, 0
%t9486 = or i1 %t9484, %t9485
%t9487 = zext i1 %t9486 to i8
call void @resid_conv_check(i8 %t9487)
%t9488 = add i128 13951009754708518548, 0
%t9489 = trunc i128 %t9488 to i64
%t9490 = zext i64 %t9489 to i128
%t9491 = icmp ne i128 %t9490, %t9488
%t9492 = icmp slt i128 13951009754708518548, 0
%t9493 = or i1 %t9491, %t9492
%t9494 = zext i1 %t9493 to i8
call void @resid_conv_check(i8 %t9494)
%t9495 = add i128 16472876342353939154, 0
%t9496 = trunc i128 %t9495 to i64
%t9497 = zext i64 %t9496 to i128
%t9498 = icmp ne i128 %t9497, %t9495
%t9499 = icmp slt i128 16472876342353939154, 0
%t9500 = or i1 %t9498, %t9499
%t9501 = zext i1 %t9500 to i8
call void @resid_conv_check(i8 %t9501)
%t9502 = add i128 17275323862435702243, 0
%t9503 = trunc i128 %t9502 to i64
%t9504 = zext i64 %t9503 to i128
%t9505 = icmp ne i128 %t9504, %t9502
%t9506 = icmp slt i128 17275323862435702243, 0
%t9507 = or i1 %t9505, %t9506
%t9508 = zext i1 %t9507 to i8
call void @resid_conv_check(i8 %t9508)
%t9509 = add i64 1135362057144423861, 0
%t9510 = add i64 %t9509, 0
%t9511 = add i64 %t9510, 0
%t9512 = icmp ne i64 %t9511, %t9509
%t9513 = icmp slt i64 1135362057144423861, 0
%t9514 = or i1 %t9512, %t9513
%t9515 = zext i1 %t9514 to i8
call void @resid_conv_check(i8 %t9515)
%t9516 = add i64 2597628984639134821, 0
%t9517 = add i64 %t9516, 0
%t9518 = add i64 %t9517, 0
%t9519 = icmp ne i64 %t9518, %t9516
%t9520 = icmp slt i64 2597628984639134821, 0
%t9521 = or i1 %t9519, %t9520
%t9522 = zext i1 %t9521 to i8
call void @resid_conv_check(i8 %t9522)
%t9523 = add i64 3308224258029322869, 0
%t9524 = add i64 %t9523, 0
%t9525 = add i64 %t9524, 0
%t9526 = icmp ne i64 %t9525, %t9523
%t9527 = icmp slt i64 3308224258029322869, 0
%t9528 = or i1 %t9526, %t9527
%t9529 = zext i1 %t9528 to i8
call void @resid_conv_check(i8 %t9529)
%t9530 = add i64 5365058923640841347, 0
%t9531 = add i64 %t9530, 0
%t9532 = add i64 %t9531, 0
%t9533 = icmp ne i64 %t9532, %t9530
%t9534 = icmp slt i64 5365058923640841347, 0
%t9535 = or i1 %t9533, %t9534
%t9536 = zext i1 %t9535 to i8
call void @resid_conv_check(i8 %t9536)
%t9537 = add i64 6679025012923562964, 0
%t9538 = add i64 %t9537, 0
%t9539 = add i64 %t9538, 0
%t9540 = icmp ne i64 %t9539, %t9537
%t9541 = icmp slt i64 6679025012923562964, 0
%t9542 = or i1 %t9540, %t9541
%t9543 = zext i1 %t9542 to i8
call void @resid_conv_check(i8 %t9543)
%t9544 = add i64 8573033837759648693, 0
%t9545 = add i64 %t9544, 0
%t9546 = add i64 %t9545, 0
%t9547 = icmp ne i64 %t9546, %t9544
%t9548 = icmp slt i64 8573033837759648693, 0
%t9549 = or i1 %t9547, %t9548
%t9550 = zext i1 %t9549 to i8
call void @resid_conv_check(i8 %t9550)
%t9551 = add i128 10970295158949994411, 0
%t9552 = trunc i128 %t9551 to i64
%t9553 = zext i64 %t9552 to i128
%t9554 = icmp ne i128 %t9553, %t9551
%t9555 = icmp slt i128 10970295158949994411, 0
%t9556 = or i1 %t9554, %t9555
%t9557 = zext i1 %t9556 to i8
call void @resid_conv_check(i8 %t9557)
%t9558 = add i128 12119686244451234320, 0
%t9559 = trunc i128 %t9558 to i64
%t9560 = zext i64 %t9559 to i128
%t9561 = icmp ne i128 %t9560, %t9558
%t9562 = icmp slt i128 12119686244451234320, 0
%t9563 = or i1 %t9561, %t9562
%t9564 = zext i1 %t9563 to i8
call void @resid_conv_check(i8 %t9564)
%t9565 = add i128 12683024718118986047, 0
%t9566 = trunc i128 %t9565 to i64
%t9567 = zext i64 %t9566 to i128
%t9568 = icmp ne i128 %t9567, %t9565
%t9569 = icmp slt i128 12683024718118986047, 0
%t9570 = or i1 %t9568, %t9569
%t9571 = zext i1 %t9570 to i8
call void @resid_conv_check(i8 %t9571)
%t9572 = add i128 13788192230050041572, 0
%t9573 = trunc i128 %t9572 to i64
%t9574 = zext i64 %t9573 to i128
%t9575 = icmp ne i128 %t9574, %t9572
%t9576 = icmp slt i128 13788192230050041572, 0
%t9577 = or i1 %t9575, %t9576
%t9578 = zext i1 %t9577 to i8
call void @resid_conv_check(i8 %t9578)
%t9579 = add i128 14330467153632333762, 0
%t9580 = trunc i128 %t9579 to i64
%t9581 = zext i64 %t9580 to i128
%t9582 = icmp ne i128 %t9581, %t9579
%t9583 = icmp slt i128 14330467153632333762, 0
%t9584 = or i1 %t9582, %t9583
%t9585 = zext i1 %t9584 to i8
call void @resid_conv_check(i8 %t9585)
%t9586 = add i128 15395433587784984357, 0
%t9587 = trunc i128 %t9586 to i64
%t9588 = zext i64 %t9587 to i128
%t9589 = icmp ne i128 %t9588, %t9586
%t9590 = icmp slt i128 15395433587784984357, 0
%t9591 = or i1 %t9589, %t9590
%t9592 = zext i1 %t9591 to i8
call void @resid_conv_check(i8 %t9592)
%t9593 = add i64 1452737877330783856, 0
%t9594 = add i64 %t9593, 0
%t9595 = add i64 %t9594, 0
%t9596 = icmp ne i64 %t9595, %t9593
%t9597 = icmp slt i64 1452737877330783856, 0
%t9598 = or i1 %t9596, %t9597
%t9599 = zext i1 %t9598 to i8
call void @resid_conv_check(i8 %t9599)
%t9600 = add i64 2861767655752347644, 0
%t9601 = add i64 %t9600, 0
%t9602 = add i64 %t9601, 0
%t9603 = icmp ne i64 %t9602, %t9600
%t9604 = icmp slt i64 2861767655752347644, 0
%t9605 = or i1 %t9603, %t9604
%t9606 = zext i1 %t9605 to i8
call void @resid_conv_check(i8 %t9606)
%t9607 = add i64 3322285676063803686, 0
%t9608 = add i64 %t9607, 0
%t9609 = add i64 %t9608, 0
%t9610 = icmp ne i64 %t9609, %t9607
%t9611 = icmp slt i64 3322285676063803686, 0
%t9612 = or i1 %t9610, %t9611
%t9613 = zext i1 %t9612 to i8
call void @resid_conv_check(i8 %t9613)
%t9614 = add i64 5560940570517711597, 0
%t9615 = add i64 %t9614, 0
%t9616 = add i64 %t9615, 0
%t9617 = icmp ne i64 %t9616, %t9614
%t9618 = icmp slt i64 5560940570517711597, 0
%t9619 = or i1 %t9617, %t9618
%t9620 = zext i1 %t9619 to i8
call void @resid_conv_check(i8 %t9620)
%t9621 = add i64 5996557281743188959, 0
%t9622 = add i64 %t9621, 0
%t9623 = add i64 %t9622, 0
%t9624 = icmp ne i64 %t9623, %t9621
%t9625 = icmp slt i64 5996557281743188959, 0
%t9626 = or i1 %t9624, %t9625
%t9627 = zext i1 %t9626 to i8
call void @resid_conv_check(i8 %t9627)
%t9628 = add i64 7280758554555802590, 0
%t9629 = add i64 %t9628, 0
%t9630 = add i64 %t9629, 0
%t9631 = icmp ne i64 %t9630, %t9628
%t9632 = icmp slt i64 7280758554555802590, 0
%t9633 = or i1 %t9631, %t9632
%t9634 = zext i1 %t9633 to i8
call void @resid_conv_check(i8 %t9634)
%t9635 = add i64 8532644243296465576, 0
%t9636 = add i64 %t9635, 0
%t9637 = add i64 %t9636, 0
%t9638 = icmp ne i64 %t9637, %t9635
%t9639 = icmp slt i64 8532644243296465576, 0
%t9640 = or i1 %t9638, %t9639
%t9641 = zext i1 %t9640 to i8
call void @resid_conv_check(i8 %t9641)
%t9642 = add i128 9350256976987008742, 0
%t9643 = trunc i128 %t9642 to i64
%t9644 = zext i64 %t9643 to i128
%t9645 = icmp ne i128 %t9644, %t9642
%t9646 = icmp slt i128 9350256976987008742, 0
%t9647 = or i1 %t9645, %t9646
%t9648 = zext i1 %t9647 to i8
call void @resid_conv_check(i8 %t9648)
%t9649 = add i128 10552545826968843579, 0
%t9650 = trunc i128 %t9649 to i64
%t9651 = zext i64 %t9650 to i128
%t9652 = icmp ne i128 %t9651, %t9649
%t9653 = icmp slt i128 10552545826968843579, 0
%t9654 = or i1 %t9652, %t9653
%t9655 = zext i1 %t9654 to i8
call void @resid_conv_check(i8 %t9655)
%t9656 = add i128 11727347734174303076, 0
%t9657 = trunc i128 %t9656 to i64
%t9658 = zext i64 %t9657 to i128
%t9659 = icmp ne i128 %t9658, %t9656
%t9660 = icmp slt i128 11727347734174303076, 0
%t9661 = or i1 %t9659, %t9660
%t9662 = zext i1 %t9661 to i8
call void @resid_conv_check(i8 %t9662)
%t9663 = add i128 12113106623233404929, 0
%t9664 = trunc i128 %t9663 to i64
%t9665 = zext i64 %t9664 to i128
%t9666 = icmp ne i128 %t9665, %t9663
%t9667 = icmp slt i128 12113106623233404929, 0
%t9668 = or i1 %t9666, %t9667
%t9669 = zext i1 %t9668 to i8
call void @resid_conv_check(i8 %t9669)
%t9670 = add i128 14000437183269869457, 0
%t9671 = trunc i128 %t9670 to i64
%t9672 = zext i64 %t9671 to i128
%t9673 = icmp ne i128 %t9672, %t9670
%t9674 = icmp slt i128 14000437183269869457, 0
%t9675 = or i1 %t9673, %t9674
%t9676 = zext i1 %t9675 to i8
call void @resid_conv_check(i8 %t9676)
%t9677 = add i128 14369950271660146224, 0
%t9678 = trunc i128 %t9677 to i64
%t9679 = zext i64 %t9678 to i128
%t9680 = icmp ne i128 %t9679, %t9677
%t9681 = icmp slt i128 14369950271660146224, 0
%t9682 = or i1 %t9680, %t9681
%t9683 = zext i1 %t9682 to i8
call void @resid_conv_check(i8 %t9683)
%t9684 = add i128 15101387698204529176, 0
%t9685 = trunc i128 %t9684 to i64
%t9686 = zext i64 %t9685 to i128
%t9687 = icmp ne i128 %t9686, %t9684
%t9688 = icmp slt i128 15101387698204529176, 0
%t9689 = or i1 %t9687, %t9688
%t9690 = zext i1 %t9689 to i8
call void @resid_conv_check(i8 %t9690)
%t9691 = add i128 15463397548674623760, 0
%t9692 = trunc i128 %t9691 to i64
%t9693 = zext i64 %t9692 to i128
%t9694 = icmp ne i128 %t9693, %t9691
%t9695 = icmp slt i128 15463397548674623760, 0
%t9696 = or i1 %t9694, %t9695
%t9697 = zext i1 %t9696 to i8
call void @resid_conv_check(i8 %t9697)
%t9698 = add i128 17586052441742319658, 0
%t9699 = trunc i128 %t9698 to i64
%t9700 = zext i64 %t9699 to i128
%t9701 = icmp ne i128 %t9700, %t9698
%t9702 = icmp slt i128 17586052441742319658, 0
%t9703 = or i1 %t9701, %t9702
%t9704 = zext i1 %t9703 to i8
call void @resid_conv_check(i8 %t9704)
%t9705 = add i64 1182934255886127544, 0
%t9706 = add i64 %t9705, 0
%t9707 = add i64 %t9706, 0
%t9708 = icmp ne i64 %t9707, %t9705
%t9709 = icmp slt i64 1182934255886127544, 0
%t9710 = or i1 %t9708, %t9709
%t9711 = zext i1 %t9710 to i8
call void @resid_conv_check(i8 %t9711)
%t9712 = add i64 1847814050463011016, 0
%t9713 = add i64 %t9712, 0
%t9714 = add i64 %t9713, 0
%t9715 = icmp ne i64 %t9714, %t9712
%t9716 = icmp slt i64 1847814050463011016, 0
%t9717 = or i1 %t9715, %t9716
%t9718 = zext i1 %t9717 to i8
call void @resid_conv_check(i8 %t9718)
%t9719 = add i64 2177327727835720531, 0
%t9720 = add i64 %t9719, 0
%t9721 = add i64 %t9720, 0
%t9722 = icmp ne i64 %t9721, %t9719
%t9723 = icmp slt i64 2177327727835720531, 0
%t9724 = or i1 %t9722, %t9723
%t9725 = zext i1 %t9724 to i8
call void @resid_conv_check(i8 %t9725)
%t9726 = add i64 2830643537854262169, 0
%t9727 = add i64 %t9726, 0
%t9728 = add i64 %t9727, 0
%t9729 = icmp ne i64 %t9728, %t9726
%t9730 = icmp slt i64 2830643537854262169, 0
%t9731 = or i1 %t9729, %t9730
%t9732 = zext i1 %t9731 to i8
call void @resid_conv_check(i8 %t9732)
%t9733 = add i64 3796741975233480872, 0
%t9734 = add i64 %t9733, 0
%t9735 = add i64 %t9734, 0
%t9736 = icmp ne i64 %t9735, %t9733
%t9737 = icmp slt i64 3796741975233480872, 0
%t9738 = or i1 %t9736, %t9737
%t9739 = zext i1 %t9738 to i8
call void @resid_conv_check(i8 %t9739)
%t9740 = add i64 4115178125766777443, 0
%t9741 = add i64 %t9740, 0
%t9742 = add i64 %t9741, 0
%t9743 = icmp ne i64 %t9742, %t9740
%t9744 = icmp slt i64 4115178125766777443, 0
%t9745 = or i1 %t9743, %t9744
%t9746 = zext i1 %t9745 to i8
call void @resid_conv_check(i8 %t9746)
%t9747 = add i64 5681478168544905931, 0
%t9748 = add i64 %t9747, 0
%t9749 = add i64 %t9748, 0
%t9750 = icmp ne i64 %t9749, %t9747
%t9751 = icmp slt i64 5681478168544905931, 0
%t9752 = or i1 %t9750, %t9751
%t9753 = zext i1 %t9752 to i8
call void @resid_conv_check(i8 %t9753)
%t9754 = add i64 6601373596472566643, 0
%t9755 = add i64 %t9754, 0
%t9756 = add i64 %t9755, 0
%t9757 = icmp ne i64 %t9756, %t9754
%t9758 = icmp slt i64 6601373596472566643, 0
%t9759 = or i1 %t9757, %t9758
%t9760 = zext i1 %t9759 to i8
call void @resid_conv_check(i8 %t9760)
%t9761 = add i64 7507060721942968483, 0
%t9762 = add i64 %t9761, 0
%t9763 = add i64 %t9762, 0
%t9764 = icmp ne i64 %t9763, %t9761
%t9765 = icmp slt i64 7507060721942968483, 0
%t9766 = or i1 %t9764, %t9765
%t9767 = zext i1 %t9766 to i8
call void @resid_conv_check(i8 %t9767)
%t9768 = add i64 8399075790359081724, 0
%t9769 = add i64 %t9768, 0
%t9770 = add i64 %t9769, 0
%t9771 = icmp ne i64 %t9770, %t9768
%t9772 = icmp slt i64 8399075790359081724, 0
%t9773 = or i1 %t9771, %t9772
%t9774 = zext i1 %t9773 to i8
call void @resid_conv_check(i8 %t9774)
%t9775 = add i64 8693463985226723168, 0
%t9776 = add i64 %t9775, 0
%t9777 = add i64 %t9776, 0
%t9778 = icmp ne i64 %t9777, %t9775
%t9779 = icmp slt i64 8693463985226723168, 0
%t9780 = or i1 %t9778, %t9779
%t9781 = zext i1 %t9780 to i8
call void @resid_conv_check(i8 %t9781)
%t9782 = add i128 9568029438360202098, 0
%t9783 = trunc i128 %t9782 to i64
%t9784 = zext i64 %t9783 to i128
%t9785 = icmp ne i128 %t9784, %t9782
%t9786 = icmp slt i128 9568029438360202098, 0
%t9787 = or i1 %t9785, %t9786
%t9788 = zext i1 %t9787 to i8
call void @resid_conv_check(i8 %t9788)
%t9789 = add i128 10144078919501101548, 0
%t9790 = trunc i128 %t9789 to i64
%t9791 = zext i64 %t9790 to i128
%t9792 = icmp ne i128 %t9791, %t9789
%t9793 = icmp slt i128 10144078919501101548, 0
%t9794 = or i1 %t9792, %t9793
%t9795 = zext i1 %t9794 to i8
call void @resid_conv_check(i8 %t9795)
%t9796 = add i128 10430055236837252648, 0
%t9797 = trunc i128 %t9796 to i64
%t9798 = zext i64 %t9797 to i128
%t9799 = icmp ne i128 %t9798, %t9796
%t9800 = icmp slt i128 10430055236837252648, 0
%t9801 = or i1 %t9799, %t9800
%t9802 = zext i1 %t9801 to i8
call void @resid_conv_check(i8 %t9802)
%t9803 = add i128 11840083180663258601, 0
%t9804 = trunc i128 %t9803 to i64
%t9805 = zext i64 %t9804 to i128
%t9806 = icmp ne i128 %t9805, %t9803
%t9807 = icmp slt i128 11840083180663258601, 0
%t9808 = or i1 %t9806, %t9807
%t9809 = zext i1 %t9808 to i8
call void @resid_conv_check(i8 %t9809)
%t9810 = add i128 13761210420658862357, 0
%t9811 = trunc i128 %t9810 to i64
%t9812 = zext i64 %t9811 to i128
%t9813 = icmp ne i128 %t9812, %t9810
%t9814 = icmp slt i128 13761210420658862357, 0
%t9815 = or i1 %t9813, %t9814
%t9816 = zext i1 %t9815 to i8
call void @resid_conv_check(i8 %t9816)
%t9817 = add i128 14299343276471374635, 0
%t9818 = trunc i128 %t9817 to i64
%t9819 = zext i64 %t9818 to i128
%t9820 = icmp ne i128 %t9819, %t9817
%t9821 = icmp slt i128 14299343276471374635, 0
%t9822 = or i1 %t9820, %t9821
%t9823 = zext i1 %t9822 to i8
call void @resid_conv_check(i8 %t9823)
%t9824 = add i128 14566680578165727644, 0
%t9825 = trunc i128 %t9824 to i64
%t9826 = zext i64 %t9825 to i128
%t9827 = icmp ne i128 %t9826, %t9824
%t9828 = icmp slt i128 14566680578165727644, 0
%t9829 = or i1 %t9827, %t9828
%t9830 = zext i1 %t9829 to i8
call void @resid_conv_check(i8 %t9830)
%t9831 = add i128 15097957966210449927, 0
%t9832 = trunc i128 %t9831 to i64
%t9833 = zext i64 %t9832 to i128
%t9834 = icmp ne i128 %t9833, %t9831
%t9835 = icmp slt i128 15097957966210449927, 0
%t9836 = or i1 %t9834, %t9835
%t9837 = zext i1 %t9836 to i8
call void @resid_conv_check(i8 %t9837)
%t9838 = add i128 16922976911328602910, 0
%t9839 = trunc i128 %t9838 to i64
%t9840 = zext i64 %t9839 to i128
%t9841 = icmp ne i128 %t9840, %t9838
%t9842 = icmp slt i128 16922976911328602910, 0
%t9843 = or i1 %t9841, %t9842
%t9844 = zext i1 %t9843 to i8
call void @resid_conv_check(i8 %t9844)
%t9845 = add i128 17689382322260857208, 0
%t9846 = trunc i128 %t9845 to i64
%t9847 = zext i64 %t9846 to i128
%t9848 = icmp ne i128 %t9847, %t9845
%t9849 = icmp slt i128 17689382322260857208, 0
%t9850 = or i1 %t9848, %t9849
%t9851 = zext i1 %t9850 to i8
call void @resid_conv_check(i8 %t9851)
%t9852 = add i64 1242879168328830382, 0
%t9853 = add i64 %t9852, 0
%t9854 = add i64 %t9853, 0
%t9855 = icmp ne i64 %t9854, %t9852
%t9856 = icmp slt i64 1242879168328830382, 0
%t9857 = or i1 %t9855, %t9856
%t9858 = zext i1 %t9857 to i8
call void @resid_conv_check(i8 %t9858)
%t9859 = add i64 1977374033974150939, 0
%t9860 = add i64 %t9859, 0
%t9861 = add i64 %t9860, 0
%t9862 = icmp ne i64 %t9861, %t9859
%t9863 = icmp slt i64 1977374033974150939, 0
%t9864 = or i1 %t9862, %t9863
%t9865 = zext i1 %t9864 to i8
call void @resid_conv_check(i8 %t9865)
%t9866 = add i64 2944078676154940804, 0
%t9867 = add i64 %t9866, 0
%t9868 = add i64 %t9867, 0
%t9869 = icmp ne i64 %t9868, %t9866
%t9870 = icmp slt i64 2944078676154940804, 0
%t9871 = or i1 %t9869, %t9870
%t9872 = zext i1 %t9871 to i8
call void @resid_conv_check(i8 %t9872)
%t9873 = add i64 3659926193048069267, 0
%t9874 = add i64 %t9873, 0
%t9875 = add i64 %t9874, 0
%t9876 = icmp ne i64 %t9875, %t9873
%t9877 = icmp slt i64 3659926193048069267, 0
%t9878 = or i1 %t9876, %t9877
%t9879 = zext i1 %t9878 to i8
call void @resid_conv_check(i8 %t9879)
%t9880 = add i64 4368137639120453308, 0
%t9881 = add i64 %t9880, 0
%t9882 = add i64 %t9881, 0
%t9883 = icmp ne i64 %t9882, %t9880
%t9884 = icmp slt i64 4368137639120453308, 0
%t9885 = or i1 %t9883, %t9884
%t9886 = zext i1 %t9885 to i8
call void @resid_conv_check(i8 %t9886)
%t9887 = add i64 4836135668995329356, 0
%t9888 = add i64 %t9887, 0
%t9889 = add i64 %t9888, 0
%t9890 = icmp ne i64 %t9889, %t9887
%t9891 = icmp slt i64 4836135668995329356, 0
%t9892 = or i1 %t9890, %t9891
%t9893 = zext i1 %t9892 to i8
call void @resid_conv_check(i8 %t9893)
%t9894 = add i64 5532061633213252278, 0
%t9895 = add i64 %t9894, 0
%t9896 = add i64 %t9895, 0
%t9897 = icmp ne i64 %t9896, %t9894
%t9898 = icmp slt i64 5532061633213252278, 0
%t9899 = or i1 %t9897, %t9898
%t9900 = zext i1 %t9899 to i8
call void @resid_conv_check(i8 %t9900)
%t9901 = add i64 6448918945643986474, 0
%t9902 = add i64 %t9901, 0
%t9903 = add i64 %t9902, 0
%t9904 = icmp ne i64 %t9903, %t9901
%t9905 = icmp slt i64 6448918945643986474, 0
%t9906 = or i1 %t9904, %t9905
%t9907 = zext i1 %t9906 to i8
call void @resid_conv_check(i8 %t9907)
%t9908 = add i64 6902733635092675308, 0
%t9909 = add i64 %t9908, 0
%t9910 = add i64 %t9909, 0
%t9911 = icmp ne i64 %t9910, %t9908
%t9912 = icmp slt i64 6902733635092675308, 0
%t9913 = or i1 %t9911, %t9912
%t9914 = zext i1 %t9913 to i8
call void @resid_conv_check(i8 %t9914)
%t9915 = add i64 7801388544844847127, 0
%t9916 = add i64 %t9915, 0
%t9917 = add i64 %t9916, 0
%t9918 = icmp ne i64 %t9917, %t9915
%t9919 = icmp slt i64 7801388544844847127, 0
%t9920 = or i1 %t9918, %t9919
%t9921 = zext i1 %t9920 to i8
call void @resid_conv_check(i8 %t9921)
%t9922 = alloca [80 x ptr]
%t9924 = call ptr @resid_box_i64(i64 %t9384)
%t9926 = getelementptr i8, ptr %t9922, i64 0
store ptr %t9924, ptr %t9926
%t9927 = call ptr @resid_box_i64(i64 %t9391)
%t9929 = getelementptr i8, ptr %t9922, i64 8
store ptr %t9927, ptr %t9929
%t9930 = call ptr @resid_box_i64(i64 %t9398)
%t9932 = getelementptr i8, ptr %t9922, i64 16
store ptr %t9930, ptr %t9932
%t9933 = call ptr @resid_box_i64(i64 %t9405)
%t9935 = getelementptr i8, ptr %t9922, i64 24
store ptr %t9933, ptr %t9935
%t9936 = call ptr @resid_box_i64(i64 %t9412)
%t9938 = getelementptr i8, ptr %t9922, i64 32
store ptr %t9936, ptr %t9938
%t9939 = call ptr @resid_box_i64(i64 %t9419)
%t9941 = getelementptr i8, ptr %t9922, i64 40
store ptr %t9939, ptr %t9941
%t9942 = call ptr @resid_box_i64(i64 %t9426)
%t9944 = getelementptr i8, ptr %t9922, i64 48
store ptr %t9942, ptr %t9944
%t9945 = call ptr @resid_box_i64(i64 %t9433)
%t9947 = getelementptr i8, ptr %t9922, i64 56
store ptr %t9945, ptr %t9947
%t9948 = call ptr @resid_box_i64(i64 %t9440)
%t9950 = getelementptr i8, ptr %t9922, i64 64
store ptr %t9948, ptr %t9950
%t9951 = call ptr @resid_box_i64(i64 %t9447)
%t9953 = getelementptr i8, ptr %t9922, i64 72
store ptr %t9951, ptr %t9953
%t9954 = call ptr @resid_box_i64(i64 %t9454)
%t9956 = getelementptr i8, ptr %t9922, i64 80
store ptr %t9954, ptr %t9956
%t9957 = call ptr @resid_box_i64(i64 %t9461)
%t9959 = getelementptr i8, ptr %t9922, i64 88
store ptr %t9957, ptr %t9959
%t9960 = call ptr @resid_box_i64(i64 %t9468)
%t9962 = getelementptr i8, ptr %t9922, i64 96
store ptr %t9960, ptr %t9962
%t9963 = call ptr @resid_box_i64(i64 %t9475)
%t9965 = getelementptr i8, ptr %t9922, i64 104
store ptr %t9963, ptr %t9965
%t9966 = call ptr @resid_box_i64(i64 %t9482)
%t9968 = getelementptr i8, ptr %t9922, i64 112
store ptr %t9966, ptr %t9968
%t9969 = call ptr @resid_box_i64(i64 %t9489)
%t9971 = getelementptr i8, ptr %t9922, i64 120
store ptr %t9969, ptr %t9971
%t9972 = call ptr @resid_box_i64(i64 %t9496)
%t9974 = getelementptr i8, ptr %t9922, i64 128
store ptr %t9972, ptr %t9974
%t9975 = call ptr @resid_box_i64(i64 %t9503)
%t9977 = getelementptr i8, ptr %t9922, i64 136
store ptr %t9975, ptr %t9977
%t9978 = call ptr @resid_box_i64(i64 %t9510)
%t9980 = getelementptr i8, ptr %t9922, i64 144
store ptr %t9978, ptr %t9980
%t9981 = call ptr @resid_box_i64(i64 %t9517)
%t9983 = getelementptr i8, ptr %t9922, i64 152
store ptr %t9981, ptr %t9983
%t9984 = call ptr @resid_box_i64(i64 %t9524)
%t9986 = getelementptr i8, ptr %t9922, i64 160
store ptr %t9984, ptr %t9986
%t9987 = call ptr @resid_box_i64(i64 %t9531)
%t9989 = getelementptr i8, ptr %t9922, i64 168
store ptr %t9987, ptr %t9989
%t9990 = call ptr @resid_box_i64(i64 %t9538)
%t9992 = getelementptr i8, ptr %t9922, i64 176
store ptr %t9990, ptr %t9992
%t9993 = call ptr @resid_box_i64(i64 %t9545)
%t9995 = getelementptr i8, ptr %t9922, i64 184
store ptr %t9993, ptr %t9995
%t9996 = call ptr @resid_box_i64(i64 %t9552)
%t9998 = getelementptr i8, ptr %t9922, i64 192
store ptr %t9996, ptr %t9998
%t9999 = call ptr @resid_box_i64(i64 %t9559)
%t10001 = getelementptr i8, ptr %t9922, i64 200
store ptr %t9999, ptr %t10001
%t10002 = call ptr @resid_box_i64(i64 %t9566)
%t10004 = getelementptr i8, ptr %t9922, i64 208
store ptr %t10002, ptr %t10004
%t10005 = call ptr @resid_box_i64(i64 %t9573)
%t10007 = getelementptr i8, ptr %t9922, i64 216
store ptr %t10005, ptr %t10007
%t10008 = call ptr @resid_box_i64(i64 %t9580)
%t10010 = getelementptr i8, ptr %t9922, i64 224
store ptr %t10008, ptr %t10010
%t10011 = call ptr @resid_box_i64(i64 %t9587)
%t10013 = getelementptr i8, ptr %t9922, i64 232
store ptr %t10011, ptr %t10013
%t10014 = call ptr @resid_box_i64(i64 489312712824947311)
%t10016 = getelementptr i8, ptr %t9922, i64 240
store ptr %t10014, ptr %t10016
%t10017 = call ptr @resid_box_i64(i64 %t9594)
%t10019 = getelementptr i8, ptr %t9922, i64 248
store ptr %t10017, ptr %t10019
%t10020 = call ptr @resid_box_i64(i64 %t9601)
%t10022 = getelementptr i8, ptr %t9922, i64 256
store ptr %t10020, ptr %t10022
%t10023 = call ptr @resid_box_i64(i64 %t9608)
%t10025 = getelementptr i8, ptr %t9922, i64 264
store ptr %t10023, ptr %t10025
%t10026 = call ptr @resid_box_i64(i64 %t9615)
%t10028 = getelementptr i8, ptr %t9922, i64 272
store ptr %t10026, ptr %t10028
%t10029 = call ptr @resid_box_i64(i64 %t9622)
%t10031 = getelementptr i8, ptr %t9922, i64 280
store ptr %t10029, ptr %t10031
%t10032 = call ptr @resid_box_i64(i64 %t9629)
%t10034 = getelementptr i8, ptr %t9922, i64 288
store ptr %t10032, ptr %t10034
%t10035 = call ptr @resid_box_i64(i64 %t9636)
%t10037 = getelementptr i8, ptr %t9922, i64 296
store ptr %t10035, ptr %t10037
%t10038 = call ptr @resid_box_i64(i64 %t9643)
%t10040 = getelementptr i8, ptr %t9922, i64 304
store ptr %t10038, ptr %t10040
%t10041 = call ptr @resid_box_i64(i64 %t9650)
%t10043 = getelementptr i8, ptr %t9922, i64 312
store ptr %t10041, ptr %t10043
%t10044 = call ptr @resid_box_i64(i64 %t9657)
%t10046 = getelementptr i8, ptr %t9922, i64 320
store ptr %t10044, ptr %t10046
%t10047 = call ptr @resid_box_i64(i64 %t9664)
%t10049 = getelementptr i8, ptr %t9922, i64 328
store ptr %t10047, ptr %t10049
%t10050 = call ptr @resid_box_i64(i64 %t9671)
%t10052 = getelementptr i8, ptr %t9922, i64 336
store ptr %t10050, ptr %t10052
%t10053 = call ptr @resid_box_i64(i64 %t9678)
%t10055 = getelementptr i8, ptr %t9922, i64 344
store ptr %t10053, ptr %t10055
%t10056 = call ptr @resid_box_i64(i64 %t9685)
%t10058 = getelementptr i8, ptr %t9922, i64 352
store ptr %t10056, ptr %t10058
%t10059 = call ptr @resid_box_i64(i64 %t9692)
%t10061 = getelementptr i8, ptr %t9922, i64 360
store ptr %t10059, ptr %t10061
%t10062 = call ptr @resid_box_i64(i64 %t9699)
%t10064 = getelementptr i8, ptr %t9922, i64 368
store ptr %t10062, ptr %t10064
%t10065 = call ptr @resid_box_i64(i64 %t9706)
%t10067 = getelementptr i8, ptr %t9922, i64 376
store ptr %t10065, ptr %t10067
%t10068 = call ptr @resid_box_i64(i64 %t9713)
%t10070 = getelementptr i8, ptr %t9922, i64 384
store ptr %t10068, ptr %t10070
%t10071 = call ptr @resid_box_i64(i64 %t9720)
%t10073 = getelementptr i8, ptr %t9922, i64 392
store ptr %t10071, ptr %t10073
%t10074 = call ptr @resid_box_i64(i64 %t9727)
%t10076 = getelementptr i8, ptr %t9922, i64 400
store ptr %t10074, ptr %t10076
%t10077 = call ptr @resid_box_i64(i64 %t9734)
%t10079 = getelementptr i8, ptr %t9922, i64 408
store ptr %t10077, ptr %t10079
%t10080 = call ptr @resid_box_i64(i64 %t9741)
%t10082 = getelementptr i8, ptr %t9922, i64 416
store ptr %t10080, ptr %t10082
%t10083 = call ptr @resid_box_i64(i64 %t9748)
%t10085 = getelementptr i8, ptr %t9922, i64 424
store ptr %t10083, ptr %t10085
%t10086 = call ptr @resid_box_i64(i64 %t9755)
%t10088 = getelementptr i8, ptr %t9922, i64 432
store ptr %t10086, ptr %t10088
%t10089 = call ptr @resid_box_i64(i64 %t9762)
%t10091 = getelementptr i8, ptr %t9922, i64 440
store ptr %t10089, ptr %t10091
%t10092 = call ptr @resid_box_i64(i64 %t9769)
%t10094 = getelementptr i8, ptr %t9922, i64 448
store ptr %t10092, ptr %t10094
%t10095 = call ptr @resid_box_i64(i64 %t9776)
%t10097 = getelementptr i8, ptr %t9922, i64 456
store ptr %t10095, ptr %t10097
%t10098 = call ptr @resid_box_i64(i64 %t9783)
%t10100 = getelementptr i8, ptr %t9922, i64 464
store ptr %t10098, ptr %t10100
%t10101 = call ptr @resid_box_i64(i64 %t9790)
%t10103 = getelementptr i8, ptr %t9922, i64 472
store ptr %t10101, ptr %t10103
%t10104 = call ptr @resid_box_i64(i64 %t9797)
%t10106 = getelementptr i8, ptr %t9922, i64 480
store ptr %t10104, ptr %t10106
%t10107 = call ptr @resid_box_i64(i64 %t9804)
%t10109 = getelementptr i8, ptr %t9922, i64 488
store ptr %t10107, ptr %t10109
%t10110 = call ptr @resid_box_i64(i64 %t9811)
%t10112 = getelementptr i8, ptr %t9922, i64 496
store ptr %t10110, ptr %t10112
%t10113 = call ptr @resid_box_i64(i64 %t9818)
%t10115 = getelementptr i8, ptr %t9922, i64 504
store ptr %t10113, ptr %t10115
%t10116 = call ptr @resid_box_i64(i64 %t9825)
%t10118 = getelementptr i8, ptr %t9922, i64 512
store ptr %t10116, ptr %t10118
%t10119 = call ptr @resid_box_i64(i64 %t9832)
%t10121 = getelementptr i8, ptr %t9922, i64 520
store ptr %t10119, ptr %t10121
%t10122 = call ptr @resid_box_i64(i64 %t9839)
%t10124 = getelementptr i8, ptr %t9922, i64 528
store ptr %t10122, ptr %t10124
%t10125 = call ptr @resid_box_i64(i64 %t9846)
%t10127 = getelementptr i8, ptr %t9922, i64 536
store ptr %t10125, ptr %t10127
%t10128 = call ptr @resid_box_i64(i64 500013540394364858)
%t10130 = getelementptr i8, ptr %t9922, i64 544
store ptr %t10128, ptr %t10130
%t10131 = call ptr @resid_box_i64(i64 748580250866718886)
%t10133 = getelementptr i8, ptr %t9922, i64 552
store ptr %t10131, ptr %t10133
%t10134 = call ptr @resid_box_i64(i64 %t9853)
%t10136 = getelementptr i8, ptr %t9922, i64 560
store ptr %t10134, ptr %t10136
%t10137 = call ptr @resid_box_i64(i64 %t9860)
%t10139 = getelementptr i8, ptr %t9922, i64 568
store ptr %t10137, ptr %t10139
%t10140 = call ptr @resid_box_i64(i64 %t9867)
%t10142 = getelementptr i8, ptr %t9922, i64 576
store ptr %t10140, ptr %t10142
%t10143 = call ptr @resid_box_i64(i64 %t9874)
%t10145 = getelementptr i8, ptr %t9922, i64 584
store ptr %t10143, ptr %t10145
%t10146 = call ptr @resid_box_i64(i64 %t9881)
%t10148 = getelementptr i8, ptr %t9922, i64 592
store ptr %t10146, ptr %t10148
%t10149 = call ptr @resid_box_i64(i64 %t9888)
%t10151 = getelementptr i8, ptr %t9922, i64 600
store ptr %t10149, ptr %t10151
%t10152 = call ptr @resid_box_i64(i64 %t9895)
%t10154 = getelementptr i8, ptr %t9922, i64 608
store ptr %t10152, ptr %t10154
%t10155 = call ptr @resid_box_i64(i64 %t9902)
%t10157 = getelementptr i8, ptr %t9922, i64 616
store ptr %t10155, ptr %t10157
%t10158 = call ptr @resid_box_i64(i64 %t9909)
%t10160 = getelementptr i8, ptr %t9922, i64 624
store ptr %t10158, ptr %t10160
%t10161 = call ptr @resid_box_i64(i64 %t9916)
%t10163 = getelementptr i8, ptr %t9922, i64 632
store ptr %t10161, ptr %t10163
%t10164 = call ptr @resid_list_new(i64 80, ptr %t9922, ptr @.lty9922)
%t10165 = getelementptr i8, ptr %p2, i64 0
%t10166 = load i64, ptr %t10165, align 8
%t10167 = getelementptr i8, ptr %p2, i64 8
%t10168 = load i64, ptr %t10167, align 8
%t10169 = getelementptr i8, ptr %p2, i64 16
%t10170 = load i64, ptr %t10169, align 8
%t10171 = getelementptr i8, ptr %p2, i64 24
%t10172 = load i64, ptr %t10171, align 8
%t10173 = getelementptr i8, ptr %p2, i64 32
%t10174 = load i64, ptr %t10173, align 8
%t10175 = getelementptr i8, ptr %p2, i64 40
%t10176 = load i64, ptr %t10175, align 8
%t10177 = getelementptr i8, ptr %p2, i64 48
%t10178 = load i64, ptr %t10177, align 8
%t10179 = getelementptr i8, ptr %p2, i64 56
%t10180 = load i64, ptr %t10179, align 8
%t10181 = call ptr @__m____________lib_sha512g_resid__g5_blk__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %t10164, i64 0, ptr %p2, i64 %t10166, i64 %t10168, i64 %t10170, i64 %t10172, i64 %t10174, i64 %t10176, i64 %t10178, i64 %t10180, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret ptr %t10181
}
define i64 @__m____________lib_sha512g_resid__g5_state_word__g_UInt_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10182 = icmp eq i64 %p1, 0
br i1 %t10182, label %L988, label %L989
L988:
%t10183 = getelementptr i8, ptr %p0, i64 0
%t10184 = load i64, ptr %t10183, align 8
br label %L990
L989:
%t10185 = icmp eq i64 %p1, 1
br i1 %t10185, label %L991, label %L992
L991:
%t10186 = getelementptr i8, ptr %p0, i64 8
%t10187 = load i64, ptr %t10186, align 8
br label %L993
L992:
%t10188 = icmp eq i64 %p1, 2
br i1 %t10188, label %L994, label %L995
L994:
%t10189 = getelementptr i8, ptr %p0, i64 16
%t10190 = load i64, ptr %t10189, align 8
br label %L996
L995:
%t10191 = icmp eq i64 %p1, 3
br i1 %t10191, label %L997, label %L998
L997:
%t10192 = getelementptr i8, ptr %p0, i64 24
%t10193 = load i64, ptr %t10192, align 8
br label %L999
L998:
%t10194 = icmp eq i64 %p1, 4
br i1 %t10194, label %L1000, label %L1001
L1000:
%t10195 = getelementptr i8, ptr %p0, i64 32
%t10196 = load i64, ptr %t10195, align 8
br label %L1002
L1001:
%t10197 = icmp eq i64 %p1, 5
br i1 %t10197, label %L1003, label %L1004
L1003:
%t10198 = getelementptr i8, ptr %p0, i64 40
%t10199 = load i64, ptr %t10198, align 8
br label %L1005
L1004:
%t10200 = icmp eq i64 %p1, 6
br i1 %t10200, label %L1006, label %L1007
L1006:
%t10201 = getelementptr i8, ptr %p0, i64 48
%t10202 = load i64, ptr %t10201, align 8
br label %L1008
L1007:
%t10203 = getelementptr i8, ptr %p0, i64 56
%t10204 = load i64, ptr %t10203, align 8
br label %L1008
L1008:
%t10205 = phi i64 [ %t10202, %L1006 ], [ %t10204, %L1007 ]
br label %L1005
L1005:
%t10206 = phi i64 [ %t10199, %L1003 ], [ %t10205, %L1008 ]
br label %L1002
L1002:
%t10207 = phi i64 [ %t10196, %L1000 ], [ %t10206, %L1005 ]
br label %L999
L999:
%t10208 = phi i64 [ %t10193, %L997 ], [ %t10207, %L1002 ]
br label %L996
L996:
%t10209 = phi i64 [ %t10190, %L994 ], [ %t10208, %L999 ]
br label %L993
L993:
%t10210 = phi i64 [ %t10187, %L991 ], [ %t10209, %L996 ]
br label %L990
L990:
%t10211 = phi i64 [ %t10184, %L988 ], [ %t10210, %L993 ]
ret i64 %t10211
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t10251, %tco.s0.k ]
%p4 = phi ptr [ %p4.in, %entry ], [ %p4.ev.tco.s0, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t10252, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %p7, %tco.s0.k ]
%p9 = phi i64 [ %p9.in, %entry ], [ %t10253, %tco.s0.k ]
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
%p28 = phi i64 [ %p28.in, %entry ], [ %t10238, %tco.s0.k ]
%t10212 = icmp sge i64 %p3, 80
br i1 %t10212, label %L1009, label %L1011
L1009:
%t10213 = call ptr @resid_gmalloc(i64 64)
%t10214 = getelementptr i8, ptr %p4, i64 0
%t10215 = load i64, ptr %t10214, align 8
%t10216 = call i64 @__m____________lib_word_resid__di_add(i64 %t10215, i64 %p5)
%t10213.f0 = getelementptr i8, ptr %t10213, i64 0
store i64 %t10216, ptr %t10213.f0, align 8
%t10217 = getelementptr i8, ptr %p4, i64 8
%t10218 = load i64, ptr %t10217, align 8
%t10219 = call i64 @__m____________lib_word_resid__di_add(i64 %t10218, i64 %p6)
%t10213.f1 = getelementptr i8, ptr %t10213, i64 8
store i64 %t10219, ptr %t10213.f1, align 8
%t10220 = getelementptr i8, ptr %p4, i64 16
%t10221 = load i64, ptr %t10220, align 8
%t10222 = call i64 @__m____________lib_word_resid__di_add(i64 %t10221, i64 %p7)
%t10213.f2 = getelementptr i8, ptr %t10213, i64 16
store i64 %t10222, ptr %t10213.f2, align 8
%t10223 = getelementptr i8, ptr %p4, i64 24
%t10224 = load i64, ptr %t10223, align 8
%t10225 = call i64 @__m____________lib_word_resid__di_add(i64 %t10224, i64 %p8)
%t10213.f3 = getelementptr i8, ptr %t10213, i64 24
store i64 %t10225, ptr %t10213.f3, align 8
%t10226 = getelementptr i8, ptr %p4, i64 32
%t10227 = load i64, ptr %t10226, align 8
%t10228 = call i64 @__m____________lib_word_resid__di_add(i64 %t10227, i64 %p9)
%t10213.f4 = getelementptr i8, ptr %t10213, i64 32
store i64 %t10228, ptr %t10213.f4, align 8
%t10229 = getelementptr i8, ptr %p4, i64 40
%t10230 = load i64, ptr %t10229, align 8
%t10231 = call i64 @__m____________lib_word_resid__di_add(i64 %t10230, i64 %p10)
%t10213.f5 = getelementptr i8, ptr %t10213, i64 40
store i64 %t10231, ptr %t10213.f5, align 8
%t10232 = getelementptr i8, ptr %p4, i64 48
%t10233 = load i64, ptr %t10232, align 8
%t10234 = call i64 @__m____________lib_word_resid__di_add(i64 %t10233, i64 %p11)
%t10213.f6 = getelementptr i8, ptr %t10213, i64 48
store i64 %t10234, ptr %t10213.f6, align 8
%t10235 = getelementptr i8, ptr %p4, i64 56
%t10236 = load i64, ptr %t10235, align 8
%t10237 = call i64 @__m____________lib_word_resid__di_add(i64 %t10236, i64 %p12)
%t10213.f7 = getelementptr i8, ptr %t10213, i64 56
store i64 %t10237, ptr %t10213.f7, align 8
%lr.cx79 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz79 = icmp eq ptr %lr.cx79, null
br i1 %lr.lz79, label %lr.x79.k, label %lr.x79.m
lr.x79.k:
ret ptr %t10213
lr.x79.m:
%lr.ret79 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %t10213, ptr %lr.cx79)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret79
L1011:
%t10238 = call i64 @__m____________lib_sha512g_resid__g5_sched__g_Int_64__UInt_64_(ptr %p0, i64 %p1, i64 %p3, i64 %p13, i64 %p14, i64 %p22, i64 %p27)
%t10239 = call i64 @__m____________lib_sha512g_resid__g5_b1__g_UInt_64__Int_64_(i64 %p9)
%t10240 = call i64 @__m____________lib_word_resid__di_add(i64 %p12, i64 %t10239)
%t10241 = call i64 @__m____________lib_sha512g_resid__g5_ch__g_UInt_64__Int_64_(i64 %p9, i64 %p10, i64 %p11)
%t10242 = call i64 @__m____________lib_word_resid__di_add(i64 %t10240, i64 %t10241)
%t10243 = call ptr @resid_list_get_v(ptr %p2, i64 %p3, ptr %p2.ld, i64 %p2.ln)
%t10244 = call i64 @resid_unbox_i64(ptr %t10243)
%t10246 = call i64 @__m____________lib_word_resid__di_addk(i64 %t10242, i64 %t10244)
%t10247 = call i64 @__m____________lib_word_resid__di_add(i64 %t10246, i64 %t10238)
%t10248 = call i64 @__m____________lib_sha512g_resid__g5_b0__g_UInt_64__Int_64_(i64 %p5)
%t10249 = call i64 @__m____________lib_sha512g_resid__g5_maj__g_UInt_64__Int_64_(i64 %p5, i64 %p6, i64 %p7)
%t10250 = call i64 @__m____________lib_word_resid__di_add(i64 %t10248, i64 %t10249)
%t10251 = add nsw i64 %p3, 1
%t10252 = call i64 @__m____________lib_word_resid__di_add(i64 %t10247, i64 %t10250)
%t10253 = call i64 @__m____________lib_word_resid__di_add(i64 %p8, i64 %t10247)
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
%t10255 = icmp slt i64 %p2, 16
br i1 %t10255, label %L1012, label %L1014
L1012:
%t10256 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t10257 = extractvalue {i64, i1} %t10256, 0
%t10258 = extractvalue {i64, i1} %t10256, 1
%t10259 = zext i1 %t10258 to i8
call void @resid_overflow_check(i8 %t10259)
%t10260 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t10257)
%t10261 = extractvalue {i64, i1} %t10260, 0
%t10262 = extractvalue {i64, i1} %t10260, 1
%t10263 = zext i1 %t10262 to i8
call void @resid_overflow_check(i8 %t10263)
%t10264 = call i64 @__m____________lib_sha512g_resid__g5_word_at__g_Int_64__UInt_64_(ptr %p0, i64 %t10261)
ret i64 %t10264
L1014:
%t10265 = call i64 @__m____________lib_sha512g_resid__g5_s1__g_UInt_64__Int_64_(i64 %p6)
%t10266 = call i64 @__m____________lib_word_resid__di_add(i64 %t10265, i64 %p5)
%t10267 = call i64 @__m____________lib_sha512g_resid__g5_s0__g_UInt_64__Int_64_(i64 %p4)
%t10268 = call i64 @__m____________lib_word_resid__di_add(i64 %t10267, i64 %p3)
%t10269 = call i64 @__m____________lib_word_resid__di_add(i64 %t10266, i64 %t10268)
ret i64 %t10269
}
define i64 @__m____________lib_sha512g_resid__g5_b1__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10270 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 14)
%t10271 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 18)
%t10272 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10270, i64 %t10271)
%t10273 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 41)
%t10274 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10272, i64 %t10273)
ret i64 %t10274
}
define i64 @__m____________lib_sha512g_resid__g5_ch__g_UInt_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10275 = call i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p1)
%t10276 = call i64 @__m____________lib_word_resid__di_not(i64 %p0)
%t10277 = call i64 @__m____________lib_word_resid__di_and(i64 %t10276, i64 %p2)
%t10278 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10275, i64 %t10277)
ret i64 %t10278
}
define i64 @__m____________lib_sha512g_resid__g5_b0__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10279 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 28)
%t10280 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 34)
%t10281 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10279, i64 %t10280)
%t10282 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 39)
%t10283 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10281, i64 %t10282)
ret i64 %t10283
}
define i64 @__m____________lib_sha512g_resid__g5_maj__g_UInt_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10284 = call i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p1)
%t10285 = call i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p2)
%t10286 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10284, i64 %t10285)
%t10287 = call i64 @__m____________lib_word_resid__di_and(i64 %p1, i64 %p2)
%t10288 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10286, i64 %t10287)
ret i64 %t10288
}
define i64 @__m____________lib_sha512g_resid__g5_word_at__g_Int_64__UInt_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10289 = call i64 @__m____________lib_sha512g_resid__g5_word_acc__g_Int_64__UInt_64_(ptr %p0, i64 %p1, i64 0, i64 0)
ret i64 %t10289
}
define i64 @__m____________lib_sha512g_resid__g5_s1__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10290 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 19)
%t10291 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 61)
%t10292 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10290, i64 %t10291)
%t10293 = call i64 @__m____________lib_word_resid__di_shr(i64 %p0, i64 6)
%t10294 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10292, i64 %t10293)
ret i64 %t10294
}
define i64 @__m____________lib_sha512g_resid__g5_s0__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10295 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 1)
%t10296 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 8)
%t10297 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10295, i64 %t10296)
%t10298 = call i64 @__m____________lib_word_resid__di_shr(i64 %p0, i64 7)
%t10299 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10297, i64 %t10298)
ret i64 %t10299
}
define i64 @__m____________lib_sha512g_resid__g5_word_acc__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t10310, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t10312, %tco.s0 ]
%t10300 = icmp sge i64 %p2, 8
br i1 %t10300, label %L1015, label %L1017
L1015:
ret i64 %p3
L1017:
%t10301 = call i64 @__m____________lib_word_resid__di_and(i64 %p3, i64 72057594037927935)
%t10302 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p2)
%t10303 = extractvalue {i64, i1} %t10302, 0
%t10304 = extractvalue {i64, i1} %t10302, 1
%t10305 = zext i1 %t10304 to i8
call void @resid_overflow_check(i8 %t10305)
%t10306 = call ptr @resid_list_get_v(ptr %p0, i64 %t10303, ptr %p0.ld, i64 %p0.ln)
%t10307 = call i64 @resid_unbox_i64(ptr %t10306)
%t10309 = call i64 @__m____________lib_word_resid__di_from_byte(i64 %t10307)
%t10310 = add nsw i64 %p2, 1
%t10311 = call i64 @__m____________lib_sha512g_resid__g5_shl8__g_UInt_64__Int_64_(i64 %t10301)
%t10312 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10311, i64 %t10309)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_sha512g_resid__g5_shl8__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10314 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 56)
%t10315 = add i128 18446744073709551360, 0
%t10316 = trunc i128 %t10315 to i64
%t10317 = zext i64 %t10316 to i128
%t10318 = icmp ne i128 %t10317, %t10315
%t10319 = icmp slt i128 18446744073709551360, 0
%t10320 = or i1 %t10318, %t10319
%t10321 = zext i1 %t10320 to i8
call void @resid_conv_check(i8 %t10321)
%t10322 = call i64 @__m____________lib_word_resid__di_and(i64 %t10314, i64 %t10316)
ret i64 %t10322
}
define i64 @__m____________lib_bignum_resid__bn_cmp_at__rs45(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 0
}
define ptr @__m____________lib_bignum_resid__bn_sub_at__rs48(ptr %p0, ptr %p1, i64 %p2, i64 %p3, i64 %p4, ptr %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10323 = call ptr @resid_listbuf_finish(ptr %p5, ptr @.lty10323)
ret ptr %t10323
}
define ptr @__m____________lib_bignum_resid__bn_short_at__rs72(ptr %p0, i64 %p1, i64 %p2, i128 %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10324 = call ptr @resid_gmalloc(i64 16)
%t10325 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty10325)
%t10326 = call ptr @__m____________lib_bignum_resid__bn_reverse(ptr %t10325)
%t10327 = call ptr @bn_trim(ptr %t10326)
%t10324.f0 = getelementptr i8, ptr %t10324, i64 0
store ptr %t10327, ptr %t10324.f0, align 8
%t10328 = add i128 %p3, 0
%t10329 = trunc i128 %t10328 to i64
%t10330 = zext i64 %t10329 to i128
%t10331 = icmp ne i128 %t10330, %t10328
%t10332 = icmp eq i8 0, 1
%t10333 = or i1 %t10331, %t10332
%t10334 = zext i1 %t10333 to i8
call void @resid_conv_check(i8 %t10334)
%t10335 = call ptr @bn_from_u64(i64 %t10329)
%t10324.f1 = getelementptr i8, ptr %t10324, i64 8
store ptr %t10335, ptr %t10324.f1, align 8
ret ptr %t10324
}
define ptr @bn_divmod__rs93(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10337 = zext i1 true to i8
call void @resid_assert(i8 %t10337, ptr @.s10336)
%t10338 = alloca [1 x ptr]
%t10340 = call ptr @resid_box_i64(i64 3)
%t10342 = getelementptr i8, ptr %t10338, i64 0
store ptr %t10340, ptr %t10342
%t10343 = call ptr @resid_list_new(i64 1, ptr %t10338, ptr @.lty10338)
%t10344 = call i64 @bn_cmp(ptr %p0, ptr %t10343)
%t10345 = icmp slt i64 %t10344, 0
br i1 %t10345, label %L1018, label %L1020
L1018:
%t10346 = call ptr @resid_gmalloc(i64 16)
%t10347 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyE10347)
%t10346.f0 = getelementptr i8, ptr %t10346, i64 0
store ptr %t10347, ptr %t10346.f0, align 8
%t10346.f1 = getelementptr i8, ptr %t10346, i64 8
store ptr %p0, ptr %t10346.f1, align 8
ret ptr %t10346
L1020:
%t10348 = call ptr @__m____________lib_bignum_resid__bn_divmod_short(ptr %p0, i64 3)
ret ptr %t10348
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
%t10349 = call ptr @resid_gmalloc(i64 16)
%t10350 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty10350)
%t10351 = call ptr @__m____________lib_bignum_resid__bn_reverse(ptr %t10350)
%t10352 = call ptr @bn_trim(ptr %t10351)
%t10349.f0 = getelementptr i8, ptr %t10349, i64 0
store ptr %t10352, ptr %t10349.f0, align 8
%t10353 = add i128 %p3, 0
%t10354 = trunc i128 %t10353 to i64
%t10355 = zext i64 %t10354 to i128
%t10356 = icmp ne i128 %t10355, %t10353
%t10357 = icmp eq i8 0, 1
%t10358 = or i1 %t10356, %t10357
%t10359 = zext i1 %t10358 to i8
call void @resid_conv_check(i8 %t10359)
%t10360 = call ptr @bn_from_u64(i64 %t10354)
%t10349.f1 = getelementptr i8, ptr %t10349, i64 8
store ptr %t10360, ptr %t10349.f1, align 8
ret ptr %t10349
}
define ptr @__m____________lib_sha256g_resid__sha256g_pad_at__rs150(i64 %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10361 = call ptr @resid_box_i64(i64 128)
%t10364 = call ptr @resid_listbuf_push(ptr %p3, ptr %t10361)
%t10365 = musttail call ptr @__m____________lib_sha256g_resid__sha256g_pad_at(i64 %p0, i64 %p1, i64 1, ptr %t10364)
ret ptr %t10365
}
define ptr @length_bytes__rs160(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10368 = alloca [1 x ptr]
%t10366 = ashr i64 %p0, 0
%t10367 = and i64 %t10366, 255
%t10370 = call ptr @resid_box_i64(i64 %t10367)
%t10372 = getelementptr i8, ptr %t10368, i64 0
store ptr %t10370, ptr %t10372
%t10373 = call ptr @resid_list_new(i64 1, ptr %t10368, ptr @.lty10368)
%t10374 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10373)
%t10375 = musttail call ptr @length_bytes(i64 %p0, i64 -1, ptr %t10374)
ret ptr %t10375
}
define ptr @length_bytes__rs159(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10378 = alloca [1 x ptr]
%t10376 = ashr i64 %p0, 8
%t10377 = and i64 %t10376, 255
%t10380 = call ptr @resid_box_i64(i64 %t10377)
%t10382 = getelementptr i8, ptr %t10378, i64 0
store ptr %t10380, ptr %t10382
%t10383 = call ptr @resid_list_new(i64 1, ptr %t10378, ptr @.lty10378)
%t10384 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10383)
%t10385 = musttail call ptr @length_bytes__rs160(i64 %p0, i64 0, ptr %t10384)
ret ptr %t10385
}
define ptr @length_bytes__rs158(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10388 = alloca [1 x ptr]
%t10386 = ashr i64 %p0, 16
%t10387 = and i64 %t10386, 255
%t10390 = call ptr @resid_box_i64(i64 %t10387)
%t10392 = getelementptr i8, ptr %t10388, i64 0
store ptr %t10390, ptr %t10392
%t10393 = call ptr @resid_list_new(i64 1, ptr %t10388, ptr @.lty10388)
%t10394 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10393)
%t10395 = musttail call ptr @length_bytes__rs159(i64 %p0, i64 1, ptr %t10394)
ret ptr %t10395
}
define ptr @length_bytes__rs157(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10398 = alloca [1 x ptr]
%t10396 = ashr i64 %p0, 24
%t10397 = and i64 %t10396, 255
%t10400 = call ptr @resid_box_i64(i64 %t10397)
%t10402 = getelementptr i8, ptr %t10398, i64 0
store ptr %t10400, ptr %t10402
%t10403 = call ptr @resid_list_new(i64 1, ptr %t10398, ptr @.lty10398)
%t10404 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10403)
%t10405 = musttail call ptr @length_bytes__rs158(i64 %p0, i64 2, ptr %t10404)
ret ptr %t10405
}
define ptr @length_bytes__rs156(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10408 = alloca [1 x ptr]
%t10406 = ashr i64 %p0, 32
%t10407 = and i64 %t10406, 255
%t10410 = call ptr @resid_box_i64(i64 %t10407)
%t10412 = getelementptr i8, ptr %t10408, i64 0
store ptr %t10410, ptr %t10412
%t10413 = call ptr @resid_list_new(i64 1, ptr %t10408, ptr @.lty10408)
%t10414 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10413)
%t10415 = musttail call ptr @length_bytes__rs157(i64 %p0, i64 3, ptr %t10414)
ret ptr %t10415
}
define ptr @length_bytes__rs155(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10418 = alloca [1 x ptr]
%t10416 = ashr i64 %p0, 40
%t10417 = and i64 %t10416, 255
%t10420 = call ptr @resid_box_i64(i64 %t10417)
%t10422 = getelementptr i8, ptr %t10418, i64 0
store ptr %t10420, ptr %t10422
%t10423 = call ptr @resid_list_new(i64 1, ptr %t10418, ptr @.lty10418)
%t10424 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10423)
%t10425 = musttail call ptr @length_bytes__rs156(i64 %p0, i64 4, ptr %t10424)
ret ptr %t10425
}
define ptr @length_bytes__rs154(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10428 = alloca [1 x ptr]
%t10426 = ashr i64 %p0, 48
%t10427 = and i64 %t10426, 255
%t10430 = call ptr @resid_box_i64(i64 %t10427)
%t10432 = getelementptr i8, ptr %t10428, i64 0
store ptr %t10430, ptr %t10432
%t10433 = call ptr @resid_list_new(i64 1, ptr %t10428, ptr @.lty10428)
%t10434 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10433)
%t10435 = musttail call ptr @length_bytes__rs155(i64 %p0, i64 5, ptr %t10434)
ret ptr %t10435
}
define ptr @length_bytes__rs153(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10438 = alloca [1 x ptr]
%t10436 = ashr i64 %p0, 56
%t10437 = and i64 %t10436, 255
%t10440 = call ptr @resid_box_i64(i64 %t10437)
%t10442 = getelementptr i8, ptr %t10438, i64 0
store ptr %t10440, ptr %t10442
%t10443 = call ptr @resid_list_new(i64 1, ptr %t10438, ptr @.lty10438)
%t10444 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10443)
%t10445 = musttail call ptr @length_bytes__rs154(i64 %p0, i64 6, ptr %t10444)
ret ptr %t10445
}
define ptr @sha_hw_words__rs181(i256 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10446 = lshr i256 %p0, 0
%t10447 = and i256 %t10446, 4294967295
%t10448 = trunc i256 %t10447 to i64
%t10449 = call ptr @resid_box_i64(i64 %t10448)
%t10452 = call ptr @resid_listbuf_push(ptr %p2, ptr %t10449)
%t10453 = call ptr @sha_hw_words(i256 %p0, i64 1, ptr %t10452)
ret ptr %t10453
}
define i64 @sched_w__rs191(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10454 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 0)
ret i64 %t10454
}
define i64 @sched_w__rs193(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10455 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 1)
ret i64 %t10455
}
define i64 @sched_w__rs195(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10456 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 2)
ret i64 %t10456
}
define i64 @sched_w__rs198(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10457 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 3)
ret i64 %t10457
}
define i64 @sched_w__rs201(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10458 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 4)
ret i64 %t10458
}
define i64 @sched_w__rs204(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10459 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 5)
ret i64 %t10459
}
define i64 @sched_w__rs207(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10460 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 6)
ret i64 %t10460
}
define i64 @sched_w__rs210(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10461 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 7)
ret i64 %t10461
}
define ptr @sha_blk__rs209(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10462 = call i64 @sched_w__rs210(ptr %p0, i64 %p1, i64 7, i64 0, i64 0, i64 %p21, i64 %p26)
%t10463 = call i64 @bsig1(i64 %p8)
%t10464 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10463)
%t10465 = extractvalue {i64, i1} %t10464, 0
%t10466 = extractvalue {i64, i1} %t10464, 1
%t10467 = zext i1 %t10466 to i8
call void @resid_overflow_check(i8 %t10467)
%t10468 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10469 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10465, i64 %t10468)
%t10470 = extractvalue {i64, i1} %t10469, 0
%t10471 = extractvalue {i64, i1} %t10469, 1
%t10472 = zext i1 %t10471 to i8
call void @resid_overflow_check(i8 %t10472)
%t10473 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10470, i64 -1424204075)
%t10474 = extractvalue {i64, i1} %t10473, 0
%t10475 = extractvalue {i64, i1} %t10473, 1
%t10476 = zext i1 %t10475 to i8
call void @resid_overflow_check(i8 %t10476)
%t10477 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10474, i64 %t10462)
%t10478 = extractvalue {i64, i1} %t10477, 0
%t10479 = extractvalue {i64, i1} %t10477, 1
%t10480 = zext i1 %t10479 to i8
call void @resid_overflow_check(i8 %t10480)
%t10481 = and i64 %t10478, 4294967295
%t10482 = call i64 @bsig0(i64 %p4)
%t10483 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10484 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10482, i64 %t10483)
%t10485 = extractvalue {i64, i1} %t10484, 0
%t10486 = extractvalue {i64, i1} %t10484, 1
%t10487 = zext i1 %t10486 to i8
call void @resid_overflow_check(i8 %t10487)
%t10488 = and i64 %t10485, 4294967295
%t10489 = add nsw i64 %t10481, %t10488
%t10490 = and i64 %t10489, 4294967295
%t10491 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10481)
%t10492 = extractvalue {i64, i1} %t10491, 0
%t10493 = extractvalue {i64, i1} %t10491, 1
%t10494 = zext i1 %t10493 to i8
call void @resid_overflow_check(i8 %t10494)
%t10495 = and i64 %t10492, 4294967295
%t10496 = musttail call ptr @sha_blk(ptr %p0, i64 %p1, i64 8, ptr %p3, i64 %t10490, i64 %p4, i64 %p5, i64 %p6, i64 %t10495, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10462)
ret ptr %t10496
}
define ptr @sha_blk__rs206(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10497 = call i64 @sched_w__rs207(ptr %p0, i64 %p1, i64 6, i64 0, i64 0, i64 0, i64 %p26)
%t10498 = call i64 @bsig1(i64 %p8)
%t10499 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10498)
%t10500 = extractvalue {i64, i1} %t10499, 0
%t10501 = extractvalue {i64, i1} %t10499, 1
%t10502 = zext i1 %t10501 to i8
call void @resid_overflow_check(i8 %t10502)
%t10503 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10504 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10500, i64 %t10503)
%t10505 = extractvalue {i64, i1} %t10504, 0
%t10506 = extractvalue {i64, i1} %t10504, 1
%t10507 = zext i1 %t10506 to i8
call void @resid_overflow_check(i8 %t10507)
%t10508 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10505, i64 -1841331548)
%t10509 = extractvalue {i64, i1} %t10508, 0
%t10510 = extractvalue {i64, i1} %t10508, 1
%t10511 = zext i1 %t10510 to i8
call void @resid_overflow_check(i8 %t10511)
%t10512 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10509, i64 %t10497)
%t10513 = extractvalue {i64, i1} %t10512, 0
%t10514 = extractvalue {i64, i1} %t10512, 1
%t10515 = zext i1 %t10514 to i8
call void @resid_overflow_check(i8 %t10515)
%t10516 = and i64 %t10513, 4294967295
%t10517 = call i64 @bsig0(i64 %p4)
%t10518 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10519 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10517, i64 %t10518)
%t10520 = extractvalue {i64, i1} %t10519, 0
%t10521 = extractvalue {i64, i1} %t10519, 1
%t10522 = zext i1 %t10521 to i8
call void @resid_overflow_check(i8 %t10522)
%t10523 = and i64 %t10520, 4294967295
%t10524 = add nsw i64 %t10516, %t10523
%t10525 = and i64 %t10524, 4294967295
%t10526 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10516)
%t10527 = extractvalue {i64, i1} %t10526, 0
%t10528 = extractvalue {i64, i1} %t10526, 1
%t10529 = zext i1 %t10528 to i8
call void @resid_overflow_check(i8 %t10529)
%t10530 = and i64 %t10527, 4294967295
%t10531 = musttail call ptr @sha_blk__rs209(ptr %p0, i64 %p1, i64 7, ptr %p3, i64 %t10525, i64 %p4, i64 %p5, i64 %p6, i64 %t10530, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10497)
ret ptr %t10531
}
define ptr @sha_blk__rs203(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10532 = call i64 @sched_w__rs204(ptr %p0, i64 %p1, i64 5, i64 0, i64 0, i64 0, i64 %p26)
%t10533 = call i64 @bsig1(i64 %p8)
%t10534 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10533)
%t10535 = extractvalue {i64, i1} %t10534, 0
%t10536 = extractvalue {i64, i1} %t10534, 1
%t10537 = zext i1 %t10536 to i8
call void @resid_overflow_check(i8 %t10537)
%t10538 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10539 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10535, i64 %t10538)
%t10540 = extractvalue {i64, i1} %t10539, 0
%t10541 = extractvalue {i64, i1} %t10539, 1
%t10542 = zext i1 %t10541 to i8
call void @resid_overflow_check(i8 %t10542)
%t10543 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10540, i64 1508970993)
%t10544 = extractvalue {i64, i1} %t10543, 0
%t10545 = extractvalue {i64, i1} %t10543, 1
%t10546 = zext i1 %t10545 to i8
call void @resid_overflow_check(i8 %t10546)
%t10547 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10544, i64 %t10532)
%t10548 = extractvalue {i64, i1} %t10547, 0
%t10549 = extractvalue {i64, i1} %t10547, 1
%t10550 = zext i1 %t10549 to i8
call void @resid_overflow_check(i8 %t10550)
%t10551 = and i64 %t10548, 4294967295
%t10552 = call i64 @bsig0(i64 %p4)
%t10553 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10554 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10552, i64 %t10553)
%t10555 = extractvalue {i64, i1} %t10554, 0
%t10556 = extractvalue {i64, i1} %t10554, 1
%t10557 = zext i1 %t10556 to i8
call void @resid_overflow_check(i8 %t10557)
%t10558 = and i64 %t10555, 4294967295
%t10559 = add nsw i64 %t10551, %t10558
%t10560 = and i64 %t10559, 4294967295
%t10561 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10551)
%t10562 = extractvalue {i64, i1} %t10561, 0
%t10563 = extractvalue {i64, i1} %t10561, 1
%t10564 = zext i1 %t10563 to i8
call void @resid_overflow_check(i8 %t10564)
%t10565 = and i64 %t10562, 4294967295
%t10566 = musttail call ptr @sha_blk__rs206(ptr %p0, i64 %p1, i64 6, ptr %p3, i64 %t10560, i64 %p4, i64 %p5, i64 %p6, i64 %t10565, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10532)
ret ptr %t10566
}
define ptr @sha_blk__rs200(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10567 = call i64 @sched_w__rs201(ptr %p0, i64 %p1, i64 4, i64 0, i64 0, i64 0, i64 %p26)
%t10568 = call i64 @bsig1(i64 %p8)
%t10569 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10568)
%t10570 = extractvalue {i64, i1} %t10569, 0
%t10571 = extractvalue {i64, i1} %t10569, 1
%t10572 = zext i1 %t10571 to i8
call void @resid_overflow_check(i8 %t10572)
%t10573 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10574 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10570, i64 %t10573)
%t10575 = extractvalue {i64, i1} %t10574, 0
%t10576 = extractvalue {i64, i1} %t10574, 1
%t10577 = zext i1 %t10576 to i8
call void @resid_overflow_check(i8 %t10577)
%t10578 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10575, i64 961987163)
%t10579 = extractvalue {i64, i1} %t10578, 0
%t10580 = extractvalue {i64, i1} %t10578, 1
%t10581 = zext i1 %t10580 to i8
call void @resid_overflow_check(i8 %t10581)
%t10582 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10579, i64 %t10567)
%t10583 = extractvalue {i64, i1} %t10582, 0
%t10584 = extractvalue {i64, i1} %t10582, 1
%t10585 = zext i1 %t10584 to i8
call void @resid_overflow_check(i8 %t10585)
%t10586 = and i64 %t10583, 4294967295
%t10587 = call i64 @bsig0(i64 %p4)
%t10588 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10589 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10587, i64 %t10588)
%t10590 = extractvalue {i64, i1} %t10589, 0
%t10591 = extractvalue {i64, i1} %t10589, 1
%t10592 = zext i1 %t10591 to i8
call void @resid_overflow_check(i8 %t10592)
%t10593 = and i64 %t10590, 4294967295
%t10594 = add nsw i64 %t10586, %t10593
%t10595 = and i64 %t10594, 4294967295
%t10596 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10586)
%t10597 = extractvalue {i64, i1} %t10596, 0
%t10598 = extractvalue {i64, i1} %t10596, 1
%t10599 = zext i1 %t10598 to i8
call void @resid_overflow_check(i8 %t10599)
%t10600 = and i64 %t10597, 4294967295
%t10601 = musttail call ptr @sha_blk__rs203(ptr %p0, i64 %p1, i64 5, ptr %p3, i64 %t10595, i64 %p4, i64 %p5, i64 %p6, i64 %t10600, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10567)
ret ptr %t10601
}
define ptr @sha_blk__rs197(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10602 = call i64 @sched_w__rs198(ptr %p0, i64 %p1, i64 3, i64 0, i64 0, i64 0, i64 %p26)
%t10603 = call i64 @bsig1(i64 %p8)
%t10604 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10603)
%t10605 = extractvalue {i64, i1} %t10604, 0
%t10606 = extractvalue {i64, i1} %t10604, 1
%t10607 = zext i1 %t10606 to i8
call void @resid_overflow_check(i8 %t10607)
%t10608 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10609 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10605, i64 %t10608)
%t10610 = extractvalue {i64, i1} %t10609, 0
%t10611 = extractvalue {i64, i1} %t10609, 1
%t10612 = zext i1 %t10611 to i8
call void @resid_overflow_check(i8 %t10612)
%t10613 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10610, i64 -373957723)
%t10614 = extractvalue {i64, i1} %t10613, 0
%t10615 = extractvalue {i64, i1} %t10613, 1
%t10616 = zext i1 %t10615 to i8
call void @resid_overflow_check(i8 %t10616)
%t10617 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10614, i64 %t10602)
%t10618 = extractvalue {i64, i1} %t10617, 0
%t10619 = extractvalue {i64, i1} %t10617, 1
%t10620 = zext i1 %t10619 to i8
call void @resid_overflow_check(i8 %t10620)
%t10621 = and i64 %t10618, 4294967295
%t10622 = call i64 @bsig0(i64 %p4)
%t10623 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10624 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10622, i64 %t10623)
%t10625 = extractvalue {i64, i1} %t10624, 0
%t10626 = extractvalue {i64, i1} %t10624, 1
%t10627 = zext i1 %t10626 to i8
call void @resid_overflow_check(i8 %t10627)
%t10628 = and i64 %t10625, 4294967295
%t10629 = add nsw i64 %t10621, %t10628
%t10630 = and i64 %t10629, 4294967295
%t10631 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10621)
%t10632 = extractvalue {i64, i1} %t10631, 0
%t10633 = extractvalue {i64, i1} %t10631, 1
%t10634 = zext i1 %t10633 to i8
call void @resid_overflow_check(i8 %t10634)
%t10635 = and i64 %t10632, 4294967295
%t10636 = musttail call ptr @sha_blk__rs200(ptr %p0, i64 %p1, i64 4, ptr %p3, i64 %t10630, i64 %p4, i64 %p5, i64 %p6, i64 %t10635, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p25, i64 %p26, i64 %p27, i64 %t10602)
ret ptr %t10636
}
define ptr @sha_blk__rs194(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10637 = call i64 @sched_w__rs195(ptr %p0, i64 %p1, i64 2, i64 0, i64 0, i64 0, i64 %p26)
%t10638 = call i64 @bsig1(i64 %p8)
%t10639 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10638)
%t10640 = extractvalue {i64, i1} %t10639, 0
%t10641 = extractvalue {i64, i1} %t10639, 1
%t10642 = zext i1 %t10641 to i8
call void @resid_overflow_check(i8 %t10642)
%t10643 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10644 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10640, i64 %t10643)
%t10645 = extractvalue {i64, i1} %t10644, 0
%t10646 = extractvalue {i64, i1} %t10644, 1
%t10647 = zext i1 %t10646 to i8
call void @resid_overflow_check(i8 %t10647)
%t10648 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10645, i64 -1245643825)
%t10649 = extractvalue {i64, i1} %t10648, 0
%t10650 = extractvalue {i64, i1} %t10648, 1
%t10651 = zext i1 %t10650 to i8
call void @resid_overflow_check(i8 %t10651)
%t10652 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10649, i64 %t10637)
%t10653 = extractvalue {i64, i1} %t10652, 0
%t10654 = extractvalue {i64, i1} %t10652, 1
%t10655 = zext i1 %t10654 to i8
call void @resid_overflow_check(i8 %t10655)
%t10656 = and i64 %t10653, 4294967295
%t10657 = call i64 @bsig0(i64 %p4)
%t10658 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10659 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10657, i64 %t10658)
%t10660 = extractvalue {i64, i1} %t10659, 0
%t10661 = extractvalue {i64, i1} %t10659, 1
%t10662 = zext i1 %t10661 to i8
call void @resid_overflow_check(i8 %t10662)
%t10663 = and i64 %t10660, 4294967295
%t10664 = add nsw i64 %t10656, %t10663
%t10665 = and i64 %t10664, 4294967295
%t10666 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10656)
%t10667 = extractvalue {i64, i1} %t10666, 0
%t10668 = extractvalue {i64, i1} %t10666, 1
%t10669 = zext i1 %t10668 to i8
call void @resid_overflow_check(i8 %t10669)
%t10670 = and i64 %t10667, 4294967295
%t10671 = musttail call ptr @sha_blk__rs197(ptr %p0, i64 %p1, i64 3, ptr %p3, i64 %t10665, i64 %p4, i64 %p5, i64 %p6, i64 %t10670, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p26, i64 %p27, i64 %t10637)
ret ptr %t10671
}
define ptr @sha_blk__rs192(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10672 = call i64 @sched_w__rs193(ptr %p0, i64 %p1, i64 1, i64 0, i64 0, i64 0, i64 0)
%t10673 = call i64 @bsig1(i64 %p8)
%t10674 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10673)
%t10675 = extractvalue {i64, i1} %t10674, 0
%t10676 = extractvalue {i64, i1} %t10674, 1
%t10677 = zext i1 %t10676 to i8
call void @resid_overflow_check(i8 %t10677)
%t10678 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10679 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10675, i64 %t10678)
%t10680 = extractvalue {i64, i1} %t10679, 0
%t10681 = extractvalue {i64, i1} %t10679, 1
%t10682 = zext i1 %t10681 to i8
call void @resid_overflow_check(i8 %t10682)
%t10683 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10680, i64 1899447441)
%t10684 = extractvalue {i64, i1} %t10683, 0
%t10685 = extractvalue {i64, i1} %t10683, 1
%t10686 = zext i1 %t10685 to i8
call void @resid_overflow_check(i8 %t10686)
%t10687 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10684, i64 %t10672)
%t10688 = extractvalue {i64, i1} %t10687, 0
%t10689 = extractvalue {i64, i1} %t10687, 1
%t10690 = zext i1 %t10689 to i8
call void @resid_overflow_check(i8 %t10690)
%t10691 = and i64 %t10688, 4294967295
%t10692 = call i64 @bsig0(i64 %p4)
%t10693 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10694 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10692, i64 %t10693)
%t10695 = extractvalue {i64, i1} %t10694, 0
%t10696 = extractvalue {i64, i1} %t10694, 1
%t10697 = zext i1 %t10696 to i8
call void @resid_overflow_check(i8 %t10697)
%t10698 = and i64 %t10695, 4294967295
%t10699 = add nsw i64 %t10691, %t10698
%t10700 = and i64 %t10699, 4294967295
%t10701 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10691)
%t10702 = extractvalue {i64, i1} %t10701, 0
%t10703 = extractvalue {i64, i1} %t10701, 1
%t10704 = zext i1 %t10703 to i8
call void @resid_overflow_check(i8 %t10704)
%t10705 = and i64 %t10702, 4294967295
%t10706 = musttail call ptr @sha_blk__rs194(ptr %p0, i64 %p1, i64 2, ptr %p3, i64 %t10700, i64 %p4, i64 %p5, i64 %p6, i64 %t10705, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p27, i64 %t10672)
ret ptr %t10706
}
define ptr @sha_blk__rs190(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10707 = call i64 @sched_w__rs191(ptr %p0, i64 %p1, i64 0, i64 0, i64 0, i64 0, i64 0)
%t10708 = call i64 @bsig1(i64 %p8)
%t10709 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10708)
%t10710 = extractvalue {i64, i1} %t10709, 0
%t10711 = extractvalue {i64, i1} %t10709, 1
%t10712 = zext i1 %t10711 to i8
call void @resid_overflow_check(i8 %t10712)
%t10713 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10714 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10710, i64 %t10713)
%t10715 = extractvalue {i64, i1} %t10714, 0
%t10716 = extractvalue {i64, i1} %t10714, 1
%t10717 = zext i1 %t10716 to i8
call void @resid_overflow_check(i8 %t10717)
%t10718 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10715, i64 1116352408)
%t10719 = extractvalue {i64, i1} %t10718, 0
%t10720 = extractvalue {i64, i1} %t10718, 1
%t10721 = zext i1 %t10720 to i8
call void @resid_overflow_check(i8 %t10721)
%t10722 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10719, i64 %t10707)
%t10723 = extractvalue {i64, i1} %t10722, 0
%t10724 = extractvalue {i64, i1} %t10722, 1
%t10725 = zext i1 %t10724 to i8
call void @resid_overflow_check(i8 %t10725)
%t10726 = and i64 %t10723, 4294967295
%t10727 = call i64 @bsig0(i64 %p4)
%t10728 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10729 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10727, i64 %t10728)
%t10730 = extractvalue {i64, i1} %t10729, 0
%t10731 = extractvalue {i64, i1} %t10729, 1
%t10732 = zext i1 %t10731 to i8
call void @resid_overflow_check(i8 %t10732)
%t10733 = and i64 %t10730, 4294967295
%t10734 = add nsw i64 %t10726, %t10733
%t10735 = and i64 %t10734, 4294967295
%t10736 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10726)
%t10737 = extractvalue {i64, i1} %t10736, 0
%t10738 = extractvalue {i64, i1} %t10736, 1
%t10739 = zext i1 %t10738 to i8
call void @resid_overflow_check(i8 %t10739)
%t10740 = and i64 %t10737, 4294967295
%t10741 = musttail call ptr @sha_blk__rs192(ptr %p0, i64 %p1, i64 1, ptr %p3, i64 %t10735, i64 %p4, i64 %p5, i64 %p6, i64 %t10740, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %t10707)
ret ptr %t10741
}
define ptr @hex_state__rs235(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10742 = call ptr @resid_list_get(ptr %p0, i64 1)
%t10743 = call i64 @resid_unbox_i64(ptr %t10742)
%t10745 = call ptr @hex_word(i64 %t10743)
%t10746 = call ptr @resid_str_concat(ptr %p2, ptr %t10745)
%t10747 = musttail call ptr @hex_state(ptr %p0, i64 2, ptr %t10746)
ret ptr %t10747
}
define ptr @hex_state__rs234(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10749 = call ptr @resid_list_get(ptr %p0, i64 0)
%t10750 = call i64 @resid_unbox_i64(ptr %t10749)
%t10752 = call ptr @hex_word(i64 %t10750)
%t10753 = call ptr @resid_str_concat(ptr @.s10748, ptr %t10752)
%t10754 = musttail call ptr @hex_state__rs235(ptr %p0, i64 1, ptr %t10753)
ret ptr %t10754
}
define ptr @wtb_inner__rs236(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10756 = alloca [1 x ptr]
%t10755 = call i64 @word_byte(ptr %p0, i64 %p1, i64 0)
%t10758 = call ptr @resid_box_i64(i64 %t10755)
%t10760 = getelementptr i8, ptr %t10756, i64 0
store ptr %t10758, ptr %t10760
%t10761 = call ptr @resid_list_new(i64 1, ptr %t10756, ptr @.lty10756)
%t10762 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t10761)
%t10763 = musttail call ptr @wtb_inner(ptr %p0, i64 %p1, i64 1, ptr %t10762)
ret ptr %t10763
}
define ptr @wtb_inner__rs239(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10765 = alloca [1 x ptr]
%t10764 = call i64 @word_byte(ptr %p0, i64 0, i64 0)
%t10767 = call ptr @resid_box_i64(i64 %t10764)
%t10769 = getelementptr i8, ptr %t10765, i64 0
store ptr %t10767, ptr %t10769
%t10770 = call ptr @resid_list_new(i64 1, ptr %t10765, ptr @.lty10765)
%t10771 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t10770)
%t10772 = musttail call ptr @wtb_inner(ptr %p0, i64 0, i64 1, ptr %t10771)
ret ptr %t10772
}
define ptr @wtb_outer__rs238(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10773 = call ptr @wtb_inner__rs239(ptr %p0, i64 0, i64 0, ptr %p2)
%t10774 = musttail call ptr @wtb_outer(ptr %p0, i64 1, ptr %t10773)
ret ptr %t10774
}
define i64 @pick__rs269(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p2
}
define ptr @w64__rs272(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10775 = and i64 %p1, 4294967295
%t10776 = alloca [2 x ptr]
%t10778 = call ptr @resid_box_i64(i64 0)
%t10780 = getelementptr i8, ptr %t10776, i64 0
store ptr %t10778, ptr %t10780
%t10781 = call ptr @resid_box_i64(i64 %t10775)
%t10783 = getelementptr i8, ptr %t10776, i64 8
store ptr %t10781, ptr %t10783
%t10784 = call ptr @resid_list_new(i64 2, ptr %t10776, ptr @.lty10776)
ret ptr %t10784
}
define i64 @shr_big__rs276(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10785 = ashr i64 %p0, 56
ret i64 %t10785
}
define i64 @shr_big__rs275(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10786 = ashr i64 %p0, 32
%t10787 = musttail call i64 @shr_big__rs276(i64 %t10786, i64 56)
ret i64 %t10787
}
define i64 @shr_big__rs274(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10788 = ashr i64 %p0, 32
%t10789 = musttail call i64 @shr_big__rs275(i64 %t10788, i64 88)
ret i64 %t10789
}
define i64 @shr_big__rs280(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10790 = ashr i64 %p0, 48
ret i64 %t10790
}
define i64 @shr_big__rs279(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10791 = ashr i64 %p0, 32
%t10792 = musttail call i64 @shr_big__rs280(i64 %t10791, i64 48)
ret i64 %t10792
}
define i64 @shr_big__rs278(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10793 = ashr i64 %p0, 32
%t10794 = musttail call i64 @shr_big__rs279(i64 %t10793, i64 80)
ret i64 %t10794
}
define i64 @shr_big__rs283(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10795 = ashr i64 %p0, 32
%t10796 = musttail call i64 @shr_big(i64 %t10795, i64 40)
ret i64 %t10796
}
define i64 @shr_big__rs282(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10797 = ashr i64 %p0, 32
%t10798 = musttail call i64 @shr_big__rs283(i64 %t10797, i64 72)
ret i64 %t10798
}
define ptr @len512_bytes__rs288(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10801 = alloca [1 x ptr]
%t10799 = call i64 @shr_big(i64 %p1, i64 64)
%t10800 = and i64 %t10799, 255
%t10803 = call ptr @resid_box_i64(i64 %t10800)
%t10805 = getelementptr i8, ptr %t10801, i64 0
store ptr %t10803, ptr %t10805
%t10806 = call ptr @resid_list_new(i64 1, ptr %t10801, ptr @.lty10801)
%t10807 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10806)
%t10808 = musttail call ptr @len512_bytes(ptr %t10807, i64 %p1, i64 7)
ret ptr %t10808
}
define ptr @len512_bytes__rs287(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10811 = alloca [1 x ptr]
%t10809 = call i64 @shr_big__rs283(i64 %p1, i64 72)
%t10810 = and i64 %t10809, 255
%t10813 = call ptr @resid_box_i64(i64 %t10810)
%t10815 = getelementptr i8, ptr %t10811, i64 0
store ptr %t10813, ptr %t10815
%t10816 = call ptr @resid_list_new(i64 1, ptr %t10811, ptr @.lty10811)
%t10817 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10816)
%t10818 = musttail call ptr @len512_bytes__rs288(ptr %t10817, i64 %p1, i64 8)
ret ptr %t10818
}
define ptr @len512_bytes__rs286(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10821 = alloca [1 x ptr]
%t10819 = call i64 @shr_big__rs279(i64 %p1, i64 80)
%t10820 = and i64 %t10819, 255
%t10823 = call ptr @resid_box_i64(i64 %t10820)
%t10825 = getelementptr i8, ptr %t10821, i64 0
store ptr %t10823, ptr %t10825
%t10826 = call ptr @resid_list_new(i64 1, ptr %t10821, ptr @.lty10821)
%t10827 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10826)
%t10828 = musttail call ptr @len512_bytes__rs287(ptr %t10827, i64 %p1, i64 9)
ret ptr %t10828
}
define ptr @len512_bytes__rs285(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10831 = alloca [1 x ptr]
%t10829 = call i64 @shr_big__rs275(i64 %p1, i64 88)
%t10830 = and i64 %t10829, 255
%t10833 = call ptr @resid_box_i64(i64 %t10830)
%t10835 = getelementptr i8, ptr %t10831, i64 0
store ptr %t10833, ptr %t10835
%t10836 = call ptr @resid_list_new(i64 1, ptr %t10831, ptr @.lty10831)
%t10837 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10836)
%t10838 = musttail call ptr @len512_bytes__rs286(ptr %t10837, i64 %p1, i64 10)
ret ptr %t10838
}
define ptr @len512_bytes__rs284(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10841 = alloca [1 x ptr]
%t10839 = call i64 @shr_big(i64 %p1, i64 96)
%t10840 = and i64 %t10839, 255
%t10843 = call ptr @resid_box_i64(i64 %t10840)
%t10845 = getelementptr i8, ptr %t10841, i64 0
store ptr %t10843, ptr %t10845
%t10846 = call ptr @resid_list_new(i64 1, ptr %t10841, ptr @.lty10841)
%t10847 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10846)
%t10848 = musttail call ptr @len512_bytes__rs285(ptr %t10847, i64 %p1, i64 11)
ret ptr %t10848
}
define ptr @len512_bytes__rs281(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10851 = alloca [1 x ptr]
%t10849 = call i64 @shr_big__rs282(i64 %p1, i64 104)
%t10850 = and i64 %t10849, 255
%t10853 = call ptr @resid_box_i64(i64 %t10850)
%t10855 = getelementptr i8, ptr %t10851, i64 0
store ptr %t10853, ptr %t10855
%t10856 = call ptr @resid_list_new(i64 1, ptr %t10851, ptr @.lty10851)
%t10857 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10856)
%t10858 = musttail call ptr @len512_bytes__rs284(ptr %t10857, i64 %p1, i64 12)
ret ptr %t10858
}
define ptr @len512_bytes__rs277(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10861 = alloca [1 x ptr]
%t10859 = call i64 @shr_big__rs278(i64 %p1, i64 112)
%t10860 = and i64 %t10859, 255
%t10863 = call ptr @resid_box_i64(i64 %t10860)
%t10865 = getelementptr i8, ptr %t10861, i64 0
store ptr %t10863, ptr %t10865
%t10866 = call ptr @resid_list_new(i64 1, ptr %t10861, ptr @.lty10861)
%t10867 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10866)
%t10868 = musttail call ptr @len512_bytes__rs281(ptr %t10867, i64 %p1, i64 13)
ret ptr %t10868
}
define ptr @len512_bytes__rs273(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10871 = alloca [1 x ptr]
%t10869 = call i64 @shr_big__rs274(i64 %p1, i64 120)
%t10870 = and i64 %t10869, 255
%t10873 = call ptr @resid_box_i64(i64 %t10870)
%t10875 = getelementptr i8, ptr %t10871, i64 0
store ptr %t10873, ptr %t10875
%t10876 = call ptr @resid_list_new(i64 1, ptr %t10871, ptr @.lty10871)
%t10877 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10876)
%t10878 = musttail call ptr @len512_bytes__rs277(ptr %t10877, i64 %p1, i64 14)
ret ptr %t10878
}
define ptr @mw512_acc__rs289(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10879 = call ptr @mw512(ptr %p0, i64 %p1, i64 0)
%t10880 = call ptr @resid_list_freeze(ptr %t10879)
%t10881 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t10880)
%t10882 = musttail call ptr @mw512_acc(ptr %p0, i64 %p1, i64 1, ptr %t10881)
ret ptr %t10882
}
define ptr @w64_rotr__rs291(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10883 = musttail call ptr @w64_rotr_small(ptr %p0, i64 1)
ret ptr %t10883
}
define ptr @w64_rotr__rs293(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10884 = musttail call ptr @w64_rotr_small(ptr %p0, i64 8)
ret ptr %t10884
}
define ptr @w64_shr__rs295(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10885 = musttail call ptr @w64_shr_small(ptr %p0, i64 7)
ret ptr %t10885
}
define ptr @w64_rotr__rs297(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10886 = musttail call ptr @w64_rotr_small(ptr %p0, i64 19)
ret ptr %t10886
}
define ptr @w64_rotr__rs299(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10887 = call i64 @w64_lo(ptr %p0)
%t10888 = call i64 @w64_hi(ptr %p0)
%t10889 = call ptr @w64(i64 %t10887, i64 %t10888)
%t10890 = musttail call ptr @w64_rotr_small(ptr %t10889, i64 29)
ret ptr %t10890
}
define ptr @w64_shr__rs301(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10891 = musttail call ptr @w64_shr_small(ptr %p0, i64 6)
ret ptr %t10891
}
define ptr @w64_rotr__rs303(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10892 = musttail call ptr @w64_rotr_small(ptr %p0, i64 28)
ret ptr %t10892
}
define ptr @w64_rotr__rs305(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10893 = call i64 @w64_lo(ptr %p0)
%t10894 = call i64 @w64_hi(ptr %p0)
%t10895 = call ptr @w64(i64 %t10893, i64 %t10894)
%t10896 = musttail call ptr @w64_rotr_small(ptr %t10895, i64 2)
ret ptr %t10896
}
define ptr @w64_rotr__rs307(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10897 = call i64 @w64_lo(ptr %p0)
%t10898 = call i64 @w64_hi(ptr %p0)
%t10899 = call ptr @w64(i64 %t10897, i64 %t10898)
%t10900 = musttail call ptr @w64_rotr_small(ptr %t10899, i64 7)
ret ptr %t10900
}
define ptr @w64_rotr__rs309(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10901 = musttail call ptr @w64_rotr_small(ptr %p0, i64 14)
ret ptr %t10901
}
define i64 @fw_hi__rs312(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10902 = call ptr @resid_list_get(ptr %p0, i64 0)
%t10903 = call i64 @resid_unbox_i64(ptr %t10902)
ret i64 %t10903
}
define i64 @fw_lo__rs313(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10905 = call ptr @resid_list_get(ptr %p0, i64 1)
%t10906 = call i64 @resid_unbox_i64(ptr %t10905)
ret i64 %t10906
}
define i64 @fw_hi__rs315(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10908 = call ptr @resid_list_get(ptr %p0, i64 2)
%t10909 = call i64 @resid_unbox_i64(ptr %t10908)
ret i64 %t10909
}
define i64 @fw_lo__rs316(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10911 = call ptr @resid_list_get(ptr %p0, i64 3)
%t10912 = call i64 @resid_unbox_i64(ptr %t10911)
ret i64 %t10912
}
define i64 @fw_hi__rs318(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10914 = call ptr @resid_list_get(ptr %p0, i64 4)
%t10915 = call i64 @resid_unbox_i64(ptr %t10914)
ret i64 %t10915
}
define i64 @fw_lo__rs319(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10917 = call ptr @resid_list_get(ptr %p0, i64 5)
%t10918 = call i64 @resid_unbox_i64(ptr %t10917)
ret i64 %t10918
}
define i64 @fw_hi__rs321(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10920 = call ptr @resid_list_get(ptr %p0, i64 6)
%t10921 = call i64 @resid_unbox_i64(ptr %t10920)
ret i64 %t10921
}
define i64 @fw_lo__rs322(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10923 = call ptr @resid_list_get(ptr %p0, i64 7)
%t10924 = call i64 @resid_unbox_i64(ptr %t10923)
ret i64 %t10924
}
define i64 @fw_hi__rs324(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10926 = call ptr @resid_list_get(ptr %p0, i64 8)
%t10927 = call i64 @resid_unbox_i64(ptr %t10926)
ret i64 %t10927
}
define i64 @fw_lo__rs325(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10929 = call ptr @resid_list_get(ptr %p0, i64 9)
%t10930 = call i64 @resid_unbox_i64(ptr %t10929)
ret i64 %t10930
}
define i64 @fw_hi__rs327(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10932 = call ptr @resid_list_get(ptr %p0, i64 10)
%t10933 = call i64 @resid_unbox_i64(ptr %t10932)
ret i64 %t10933
}
define i64 @fw_lo__rs328(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10935 = call ptr @resid_list_get(ptr %p0, i64 11)
%t10936 = call i64 @resid_unbox_i64(ptr %t10935)
ret i64 %t10936
}
define i64 @fw_hi__rs330(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10938 = call ptr @resid_list_get(ptr %p0, i64 12)
%t10939 = call i64 @resid_unbox_i64(ptr %t10938)
ret i64 %t10939
}
define i64 @fw_lo__rs331(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10941 = call ptr @resid_list_get(ptr %p0, i64 13)
%t10942 = call i64 @resid_unbox_i64(ptr %t10941)
ret i64 %t10942
}
define i64 @fw_hi__rs333(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10944 = call ptr @resid_list_get(ptr %p0, i64 14)
%t10945 = call i64 @resid_unbox_i64(ptr %t10944)
ret i64 %t10945
}
define i64 @fw_lo__rs334(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10947 = call ptr @resid_list_get(ptr %p0, i64 15)
%t10948 = call i64 @resid_unbox_i64(ptr %t10947)
ret i64 %t10948
}
define ptr @sha512_rounds_flat__rs337(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10950 = call ptr @sha512_round_flat(ptr %p0, ptr %p1, i64 0)
%t10951 = musttail call ptr @sha512_rounds_flat(ptr %t10950, ptr %p1, i64 1)
ret ptr %t10951
}
define ptr @add_st_acc__rs341(ptr %p0, ptr %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10952 = call ptr @add_st_word(ptr %p0, ptr %p1, i64 0)
%t10953 = call ptr @resid_list_freeze(ptr %t10952)
%t10954 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t10953)
%t10955 = musttail call ptr @add_st_acc(ptr %p0, ptr %p1, i64 1, ptr %t10954)
ret ptr %t10955
}
define i64 @w64_bytes__rs351(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10956 = add nsw i64 %p1, 0
%t10957 = call ptr @resid_list_get(ptr %p0, i64 %t10956)
%t10958 = call i64 @resid_unbox_i64(ptr %t10957)
%t10960 = and i64 %t10958, 255
%t10961 = or i64 0, %t10960
%t10962 = musttail call i64 @w64_bytes(ptr %p0, i64 %p1, i64 1, i64 %t10961)
ret i64 %t10962
}
define i64 @sched64__rs354(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10963 = call i64 @word64_at(ptr %p0, i64 %p1, i64 0)
ret i64 %t10963
}
define i64 @sched64__rs357(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10964 = call i64 @word64_at(ptr %p0, i64 %p1, i64 1)
ret i64 %t10964
}
define i64 @sched64__rs360(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10965 = call i64 @word64_at(ptr %p0, i64 %p1, i64 2)
ret i64 %t10965
}
define i64 @sched64__rs363(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10966 = call i64 @word64_at(ptr %p0, i64 %p1, i64 3)
ret i64 %t10966
}
define i64 @sched64__rs366(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10967 = call i64 @word64_at(ptr %p0, i64 %p1, i64 4)
ret i64 %t10967
}
define i64 @sched64__rs369(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10968 = call i64 @word64_at(ptr %p0, i64 %p1, i64 5)
ret i64 %t10968
}
define i64 @sched64__rs372(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10969 = call i64 @word64_at(ptr %p0, i64 %p1, i64 6)
ret i64 %t10969
}
define i64 @sched64__rs375(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10970 = call i64 @word64_at(ptr %p0, i64 %p1, i64 7)
ret i64 %t10970
}
define ptr @be64_push__rs387(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10971 = lshr i64 %p0, 56
%t10972 = and i64 %t10971, 255
%t10973 = call ptr @resid_box_i64(i64 %t10972)
%t10976 = call ptr @resid_listbuf_push(ptr %p2, ptr %t10973)
%t10977 = musttail call ptr @be64_push(i64 %p0, i64 1, ptr %t10976)
ret ptr %t10977
}
define ptr @cbe_ascii(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10978 = call ptr @resid_sacc_from(ptr %p2)
%t10979 = musttail call ptr @cbe_ascii__sacc(ptr %p0, i64 %p1, ptr %t10978)
ret ptr %t10979
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
@.lty1165 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1165 = private global ptr null
@.lcd1165 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1198 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1198 = private global ptr null
@.lcd1198 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1212 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1212 = private global ptr null
@.lcd1212 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1242 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1242 = private global ptr null
@.lcd1242 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1261 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1261 = private global ptr null
@.lcd1261 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1270 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty1313 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1313 = private global ptr null
@.lcd1313 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1320 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1320 = private global ptr null
@.lcd1320 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1324 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1324 = private global ptr null
@.lcd1324 = private unnamed_addr constant [1 x i64] [i64 3]
@.lty1334 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1334 = private global ptr null
@.lcd1334 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1338 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1338 = private global ptr null
@.lcd1338 = private unnamed_addr constant [302 x i64] [i64 3, i64 5, i64 7, i64 11, i64 13, i64 17, i64 19, i64 23, i64 29, i64 31, i64 37, i64 41, i64 43, i64 47, i64 53, i64 59, i64 61, i64 67, i64 71, i64 73, i64 79, i64 83, i64 89, i64 97, i64 101, i64 103, i64 107, i64 109, i64 113, i64 127, i64 131, i64 137, i64 139, i64 149, i64 151, i64 157, i64 163, i64 167, i64 173, i64 179, i64 181, i64 191, i64 193, i64 197, i64 199, i64 211, i64 223, i64 227, i64 229, i64 233, i64 239, i64 241, i64 251, i64 257, i64 263, i64 269, i64 271, i64 277, i64 281, i64 283, i64 293, i64 307, i64 311, i64 313, i64 317, i64 331, i64 337, i64 347, i64 349, i64 353, i64 359, i64 367, i64 373, i64 379, i64 383, i64 389, i64 397, i64 401, i64 409, i64 419, i64 421, i64 431, i64 433, i64 439, i64 443, i64 449, i64 457, i64 461, i64 463, i64 467, i64 479, i64 487, i64 491, i64 499, i64 503, i64 509, i64 521, i64 523, i64 541, i64 547, i64 557, i64 563, i64 569, i64 571, i64 577, i64 587, i64 593, i64 599, i64 601, i64 607, i64 613, i64 617, i64 619, i64 631, i64 641, i64 643, i64 647, i64 653, i64 659, i64 661, i64 673, i64 677, i64 683, i64 691, i64 701, i64 709, i64 719, i64 727, i64 733, i64 739, i64 743, i64 751, i64 757, i64 761, i64 769, i64 773, i64 787, i64 797, i64 809, i64 811, i64 821, i64 823, i64 827, i64 829, i64 839, i64 853, i64 857, i64 859, i64 863, i64 877, i64 881, i64 883, i64 887, i64 907, i64 911, i64 919, i64 929, i64 937, i64 941, i64 947, i64 953, i64 967, i64 971, i64 977, i64 983, i64 991, i64 997, i64 1009, i64 1013, i64 1019, i64 1021, i64 1031, i64 1033, i64 1039, i64 1049, i64 1051, i64 1061, i64 1063, i64 1069, i64 1087, i64 1091, i64 1093, i64 1097, i64 1103, i64 1109, i64 1117, i64 1123, i64 1129, i64 1151, i64 1153, i64 1163, i64 1171, i64 1181, i64 1187, i64 1193, i64 1201, i64 1213, i64 1217, i64 1223, i64 1229, i64 1231, i64 1237, i64 1249, i64 1259, i64 1277, i64 1279, i64 1283, i64 1289, i64 1291, i64 1297, i64 1301, i64 1303, i64 1307, i64 1319, i64 1321, i64 1327, i64 1361, i64 1367, i64 1373, i64 1381, i64 1399, i64 1409, i64 1423, i64 1427, i64 1429, i64 1433, i64 1439, i64 1447, i64 1451, i64 1453, i64 1459, i64 1471, i64 1481, i64 1483, i64 1487, i64 1489, i64 1493, i64 1499, i64 1511, i64 1523, i64 1531, i64 1543, i64 1549, i64 1553, i64 1559, i64 1567, i64 1571, i64 1579, i64 1583, i64 1597, i64 1601, i64 1607, i64 1609, i64 1613, i64 1619, i64 1621, i64 1627, i64 1637, i64 1657, i64 1663, i64 1667, i64 1669, i64 1693, i64 1697, i64 1699, i64 1709, i64 1721, i64 1723, i64 1733, i64 1741, i64 1747, i64 1753, i64 1759, i64 1777, i64 1783, i64 1787, i64 1789, i64 1801, i64 1811, i64 1823, i64 1831, i64 1847, i64 1861, i64 1867, i64 1871, i64 1873, i64 1877, i64 1879, i64 1889, i64 1901, i64 1907, i64 1913, i64 1931, i64 1933, i64 1949, i64 1951, i64 1973, i64 1979, i64 1987, i64 1993, i64 1997, i64 1999]
@.lty1342 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1342 = private global ptr null
@.lcd1342 = private unnamed_addr constant [302 x i64] [i64 3, i64 5, i64 7, i64 11, i64 13, i64 17, i64 19, i64 23, i64 29, i64 31, i64 37, i64 41, i64 43, i64 47, i64 53, i64 59, i64 61, i64 67, i64 71, i64 73, i64 79, i64 83, i64 89, i64 97, i64 101, i64 103, i64 107, i64 109, i64 113, i64 127, i64 131, i64 137, i64 139, i64 149, i64 151, i64 157, i64 163, i64 167, i64 173, i64 179, i64 181, i64 191, i64 193, i64 197, i64 199, i64 211, i64 223, i64 227, i64 229, i64 233, i64 239, i64 241, i64 251, i64 257, i64 263, i64 269, i64 271, i64 277, i64 281, i64 283, i64 293, i64 307, i64 311, i64 313, i64 317, i64 331, i64 337, i64 347, i64 349, i64 353, i64 359, i64 367, i64 373, i64 379, i64 383, i64 389, i64 397, i64 401, i64 409, i64 419, i64 421, i64 431, i64 433, i64 439, i64 443, i64 449, i64 457, i64 461, i64 463, i64 467, i64 479, i64 487, i64 491, i64 499, i64 503, i64 509, i64 521, i64 523, i64 541, i64 547, i64 557, i64 563, i64 569, i64 571, i64 577, i64 587, i64 593, i64 599, i64 601, i64 607, i64 613, i64 617, i64 619, i64 631, i64 641, i64 643, i64 647, i64 653, i64 659, i64 661, i64 673, i64 677, i64 683, i64 691, i64 701, i64 709, i64 719, i64 727, i64 733, i64 739, i64 743, i64 751, i64 757, i64 761, i64 769, i64 773, i64 787, i64 797, i64 809, i64 811, i64 821, i64 823, i64 827, i64 829, i64 839, i64 853, i64 857, i64 859, i64 863, i64 877, i64 881, i64 883, i64 887, i64 907, i64 911, i64 919, i64 929, i64 937, i64 941, i64 947, i64 953, i64 967, i64 971, i64 977, i64 983, i64 991, i64 997, i64 1009, i64 1013, i64 1019, i64 1021, i64 1031, i64 1033, i64 1039, i64 1049, i64 1051, i64 1061, i64 1063, i64 1069, i64 1087, i64 1091, i64 1093, i64 1097, i64 1103, i64 1109, i64 1117, i64 1123, i64 1129, i64 1151, i64 1153, i64 1163, i64 1171, i64 1181, i64 1187, i64 1193, i64 1201, i64 1213, i64 1217, i64 1223, i64 1229, i64 1231, i64 1237, i64 1249, i64 1259, i64 1277, i64 1279, i64 1283, i64 1289, i64 1291, i64 1297, i64 1301, i64 1303, i64 1307, i64 1319, i64 1321, i64 1327, i64 1361, i64 1367, i64 1373, i64 1381, i64 1399, i64 1409, i64 1423, i64 1427, i64 1429, i64 1433, i64 1439, i64 1447, i64 1451, i64 1453, i64 1459, i64 1471, i64 1481, i64 1483, i64 1487, i64 1489, i64 1493, i64 1499, i64 1511, i64 1523, i64 1531, i64 1543, i64 1549, i64 1553, i64 1559, i64 1567, i64 1571, i64 1579, i64 1583, i64 1597, i64 1601, i64 1607, i64 1609, i64 1613, i64 1619, i64 1621, i64 1627, i64 1637, i64 1657, i64 1663, i64 1667, i64 1669, i64 1693, i64 1697, i64 1699, i64 1709, i64 1721, i64 1723, i64 1733, i64 1741, i64 1747, i64 1753, i64 1759, i64 1777, i64 1783, i64 1787, i64 1789, i64 1801, i64 1811, i64 1823, i64 1831, i64 1847, i64 1861, i64 1867, i64 1871, i64 1873, i64 1877, i64 1879, i64 1889, i64 1901, i64 1907, i64 1913, i64 1931, i64 1933, i64 1949, i64 1951, i64 1973, i64 1979, i64 1987, i64 1993, i64 1997, i64 1999]
@.lty1346 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty1358 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty1369 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1441 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1441 = private global ptr null
@.lcd1441 = private unnamed_addr constant [1 x i64] [i64 2]
@.lty1443 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1443 = private global ptr null
@.lcd1443 = private unnamed_addr constant [1 x i64] [i64 3]
@.lty1445 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1445 = private global ptr null
@.lcd1445 = private unnamed_addr constant [1 x i64] [i64 5]
@.lty1447 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1447 = private global ptr null
@.lcd1447 = private unnamed_addr constant [1 x i64] [i64 7]
@.lty1449 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1449 = private global ptr null
@.lcd1449 = private unnamed_addr constant [1 x i64] [i64 11]
@.lty1451 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1451 = private global ptr null
@.lcd1451 = private unnamed_addr constant [1 x i64] [i64 13]
@.lty1453 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1453 = private global ptr null
@.lcd1453 = private unnamed_addr constant [1 x i64] [i64 17]
@.lty1455 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1455 = private global ptr null
@.lcd1455 = private unnamed_addr constant [1 x i64] [i64 19]
@.lty1457 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1457 = private global ptr null
@.lcd1457 = private unnamed_addr constant [1 x i64] [i64 23]
@.lty1459 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1459 = private global ptr null
@.lcd1459 = private unnamed_addr constant [1 x i64] [i64 29]
@.lty1461 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1461 = private global ptr null
@.lcd1461 = private unnamed_addr constant [1 x i64] [i64 31]
@.lty1463 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1463 = private global ptr null
@.lcd1463 = private unnamed_addr constant [1 x i64] [i64 37]
@.lty1465 = private unnamed_addr constant [20 x i8] c"List(List(Int(64)))\00"
@.oty1505 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox1505 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty1505}, align 16
@.lty1518 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1528 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1528 = private global ptr null
@.lcd1528 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1532 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1532 = private global ptr null
@.lcd1532 = private unnamed_addr constant [1 x i64] [i64 2]
@.lty1534 = private unnamed_addr constant [20 x i8] c"List(List(Int(64)))\00"
@.lty1542 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1542 = private global ptr null
@.lcd1542 = private unnamed_addr constant [1 x i64] [i64 2]
@.lty1544 = private unnamed_addr constant [20 x i8] c"List(List(Int(64)))\00"
@.lty1553 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1559 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1565 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1571 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1577 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1583 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1589 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1595 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1601 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1607 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1613 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1619 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1625 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.lty1667 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1673 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1679 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1685 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1691 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1697 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1703 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1709 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1715 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1721 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1727 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1733 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1739 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.oty1780 = private unnamed_addr constant [23 x i8] c"Option(List(UInt(64)))\00"
@.lty1795 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1818 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.oty1844 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox1844 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty1844}, align 16
@.oty1855 = private unnamed_addr constant [23 x i8] c"Option(List(UInt(64)))\00"
@.lty1867 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty1885 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1885 = private global ptr null
@.lcd1885 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1945 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty2376 = private unnamed_addr constant [14 x i8] c"List(UInt(8))\00"
@.lty2583 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
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
@.lty2760 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc2760 = private global ptr null
@.lcd2760 = private unnamed_addr constant [64 x i64] [i64 1116352408, i64 1899447441, i64 3049323471, i64 3921009573, i64 961987163, i64 1508970993, i64 2453635748, i64 2870763221, i64 3624381080, i64 310598401, i64 607225278, i64 1426881987, i64 1925078388, i64 2162078206, i64 2614888103, i64 3248222580, i64 3835390401, i64 4022224774, i64 264347078, i64 604807628, i64 770255983, i64 1249150122, i64 1555081692, i64 1996064986, i64 2554220882, i64 2821834349, i64 2952996808, i64 3210313671, i64 3336571891, i64 3584528711, i64 113926993, i64 338241895, i64 666307205, i64 773529912, i64 1294757372, i64 1396182291, i64 1695183700, i64 1986661051, i64 2177026350, i64 2456956037, i64 2730485921, i64 2820302411, i64 3259730800, i64 3345764771, i64 3516065817, i64 3600352804, i64 4094571909, i64 275423344, i64 430227734, i64 506948616, i64 659060556, i64 883997877, i64 958139571, i64 1322822218, i64 1537002063, i64 1747873779, i64 1955562222, i64 2024104815, i64 2227730452, i64 2361852424, i64 2428436474, i64 2756734187, i64 3204031479, i64 3329325298]
@.lty2785 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2837 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc2837 = private global ptr null
@.lcd2837 = private unnamed_addr constant [8 x i64] [i64 1779033703, i64 3144134277, i64 1013904242, i64 2773480762, i64 1359893119, i64 2600822924, i64 528734635, i64 1541459225]
@.lty2840 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2864 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc2864 = private global ptr null
@.lcd2864 = private unnamed_addr constant [64 x i64] [i64 1116352408, i64 1899447441, i64 -1245643825, i64 -373957723, i64 961987163, i64 1508970993, i64 -1841331548, i64 -1424204075, i64 -670586216, i64 310598401, i64 607225278, i64 1426881987, i64 1925078388, i64 -2132889090, i64 -1680079193, i64 -1046744716, i64 -459576895, i64 -272742522, i64 264347078, i64 604807628, i64 770255983, i64 1249150122, i64 1555081692, i64 1996064986, i64 -1740746414, i64 -1473132947, i64 -1341970488, i64 -1084653625, i64 -958395405, i64 -710438585, i64 113926993, i64 338241895, i64 666307205, i64 773529912, i64 1294757372, i64 1396182291, i64 1695183700, i64 1986661051, i64 -2117940946, i64 -1838011259, i64 -1564481375, i64 -1474664885, i64 -1035236496, i64 -949202525, i64 -778901479, i64 -694614492, i64 -200395387, i64 275423344, i64 430227734, i64 506948616, i64 659060556, i64 883997877, i64 958139571, i64 1322822218, i64 1537002063, i64 1747873779, i64 1955562222, i64 2024104815, i64 -2067236844, i64 -1933114872, i64 -1866530822, i64 -1538233109, i64 -1090935817, i64 -965641998]
@.lty2935 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2956 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2970 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc2970 = private global ptr null
@.lcd2970 = private unnamed_addr constant [1 x i64] [i64 0]
@.lty2985 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2995 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc2995 = private global ptr null
@.lcd2995 = private unnamed_addr constant [1 x i64] [i64 128]
@.lty3046 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3055 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3110 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3127 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3135 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3222 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3272 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3385 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
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
@.lty3540 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3678 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3781 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3791 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc3791 = private global ptr null
@.lcd3791 = private unnamed_addr constant [1 x i64] [i64 128]
@.lty3814 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc3814 = private global ptr null
@.lcd3814 = private unnamed_addr constant [8 x i64] [i64 1779033703, i64 -1150833019, i64 1013904242, i64 -1521486534, i64 1359893119, i64 -1694144372, i64 528734635, i64 1541459225]
@.lty3817 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.s3823 = private unnamed_addr constant [1 x i8] c"\00"
@.lty3843 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3856 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3862 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc3862 = private global ptr null
@.lcd3862 = private unnamed_addr constant [8 x i64] [i64 1779033703, i64 -1150833019, i64 1013904242, i64 -1521486534, i64 1359893119, i64 -1694144372, i64 528734635, i64 1541459225]
@.s3881 = private unnamed_addr constant [1 x i8] c"\00"
@.lty3888 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3911 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3925 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3931 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3943 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3959 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3969 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3972 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.s4059 = private unnamed_addr constant [2 x i8] c"+\00"
@.s4060 = private unnamed_addr constant [2 x i8] c"/\00"
@.lty4148 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4211 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4243 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4262 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty4265 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty4267 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty4270 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty4277 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4290 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty4292 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.s4306 = private unnamed_addr constant [64 x i8] c"random: getrandom failed, and there is no randomness without it\00"
@.lty4309 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4309 = private global ptr null
@.lcd4309 = private unnamed_addr constant [4 x i64] [i64 0, i64 0, i64 0, i64 32]
@.lty4325 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4344 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4468 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4468 = private global ptr null
@.lcd4468 = private unnamed_addr constant [160 x i64] [i64 1116352408, i64 3609767458, i64 1899447441, i64 602891725, i64 3049323471, i64 3964484399, i64 3921009573, i64 2173295548, i64 961987163, i64 4081628472, i64 1508970993, i64 3053834265, i64 2453635748, i64 2937671579, i64 2870763221, i64 3664609560, i64 3624381080, i64 2734883394, i64 310598401, i64 1164996542, i64 607225278, i64 1323610764, i64 1426881987, i64 3590304994, i64 1925078388, i64 4068182383, i64 2162078206, i64 991336113, i64 2614888103, i64 633803317, i64 3248222580, i64 3479774868, i64 3835390401, i64 2666613458, i64 4022224774, i64 944711139, i64 264347078, i64 2341262773, i64 604807628, i64 2007800933, i64 770255983, i64 1495990901, i64 1249150122, i64 1856431235, i64 1555081692, i64 3175218132, i64 1996064986, i64 2198950837, i64 2554220882, i64 3999719339, i64 2821834349, i64 766784016, i64 2952996808, i64 2566594879, i64 3210313671, i64 3203337956, i64 3336571891, i64 1034457026, i64 3584528711, i64 2466948901, i64 113926993, i64 3758326383, i64 338241895, i64 168717936, i64 666307205, i64 1188179964, i64 773529912, i64 1546045734, i64 1294757372, i64 1522805485, i64 1396182291, i64 2643833823, i64 1695183700, i64 2343527390, i64 1986661051, i64 1014477480, i64 2177026350, i64 1206759142, i64 2456956037, i64 344077627, i64 2730485921, i64 1290863460, i64 2820302411, i64 3158454273, i64 3259730800, i64 3505952657, i64 3345764771, i64 106217008, i64 3516065817, i64 3606008344, i64 3600352804, i64 1432725776, i64 4094571909, i64 1467031594, i64 275423344, i64 851169720, i64 430227734, i64 3100823752, i64 506948616, i64 1363258195, i64 659060556, i64 3750685593, i64 883997877, i64 3785050280, i64 958139571, i64 3318307427, i64 1322822218, i64 3812723403, i64 1537002063, i64 2003034995, i64 1747873779, i64 3602036899, i64 1955562222, i64 1575990012, i64 2024104815, i64 1125592928, i64 2227730452, i64 2716904306, i64 2361852424, i64 442776044, i64 2428436474, i64 593698344, i64 2756734187, i64 3733110249, i64 3204031479, i64 2999351573, i64 3329325298, i64 3815920427, i64 3391569614, i64 3928383900, i64 3515267271, i64 566280711, i64 3940187606, i64 3454069534, i64 4118630271, i64 4000239992, i64 116418474, i64 1914138554, i64 174292421, i64 2731055270, i64 289380356, i64 3203993006, i64 460393269, i64 320620315, i64 685471733, i64 587496836, i64 852142971, i64 1086792851, i64 1017036298, i64 365543100, i64 1126000580, i64 2618297676, i64 1288033470, i64 3409855158, i64 1501505948, i64 4234509866, i64 1607167915, i64 987167468, i64 1816402316, i64 1246189591]
@.lty4477 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4477 = private global ptr null
@.lcd4477 = private unnamed_addr constant [160 x i64] [i64 1116352408, i64 3609767458, i64 1899447441, i64 602891725, i64 3049323471, i64 3964484399, i64 3921009573, i64 2173295548, i64 961987163, i64 4081628472, i64 1508970993, i64 3053834265, i64 2453635748, i64 2937671579, i64 2870763221, i64 3664609560, i64 3624381080, i64 2734883394, i64 310598401, i64 1164996542, i64 607225278, i64 1323610764, i64 1426881987, i64 3590304994, i64 1925078388, i64 4068182383, i64 2162078206, i64 991336113, i64 2614888103, i64 633803317, i64 3248222580, i64 3479774868, i64 3835390401, i64 2666613458, i64 4022224774, i64 944711139, i64 264347078, i64 2341262773, i64 604807628, i64 2007800933, i64 770255983, i64 1495990901, i64 1249150122, i64 1856431235, i64 1555081692, i64 3175218132, i64 1996064986, i64 2198950837, i64 2554220882, i64 3999719339, i64 2821834349, i64 766784016, i64 2952996808, i64 2566594879, i64 3210313671, i64 3203337956, i64 3336571891, i64 1034457026, i64 3584528711, i64 2466948901, i64 113926993, i64 3758326383, i64 338241895, i64 168717936, i64 666307205, i64 1188179964, i64 773529912, i64 1546045734, i64 1294757372, i64 1522805485, i64 1396182291, i64 2643833823, i64 1695183700, i64 2343527390, i64 1986661051, i64 1014477480, i64 2177026350, i64 1206759142, i64 2456956037, i64 344077627, i64 2730485921, i64 1290863460, i64 2820302411, i64 3158454273, i64 3259730800, i64 3505952657, i64 3345764771, i64 106217008, i64 3516065817, i64 3606008344, i64 3600352804, i64 1432725776, i64 4094571909, i64 1467031594, i64 275423344, i64 851169720, i64 430227734, i64 3100823752, i64 506948616, i64 1363258195, i64 659060556, i64 3750685593, i64 883997877, i64 3785050280, i64 958139571, i64 3318307427, i64 1322822218, i64 3812723403, i64 1537002063, i64 2003034995, i64 1747873779, i64 3602036899, i64 1955562222, i64 1575990012, i64 2024104815, i64 1125592928, i64 2227730452, i64 2716904306, i64 2361852424, i64 442776044, i64 2428436474, i64 593698344, i64 2756734187, i64 3733110249, i64 3204031479, i64 2999351573, i64 3329325298, i64 3815920427, i64 3391569614, i64 3928383900, i64 3515267271, i64 566280711, i64 3940187606, i64 3454069534, i64 4118630271, i64 4000239992, i64 116418474, i64 1914138554, i64 174292421, i64 2731055270, i64 289380356, i64 3203993006, i64 460393269, i64 320620315, i64 685471733, i64 587496836, i64 852142971, i64 1086792851, i64 1017036298, i64 365543100, i64 1126000580, i64 2618297676, i64 1288033470, i64 3409855158, i64 1501505948, i64 4234509866, i64 1607167915, i64 987167468, i64 1816402316, i64 1246189591]
@.lty4491 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4491 = private global ptr null
@.lcd4491 = private unnamed_addr constant [16 x i64] [i64 1779033703, i64 3144134277, i64 1013904242, i64 2773480762, i64 1359893119, i64 2600822924, i64 528734635, i64 1541459225, i64 4089235720, i64 2227873595, i64 4271175723, i64 1595750129, i64 2917565137, i64 725511199, i64 4215389547, i64 327033209]
@.lty4500 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4507 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4517 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4517 = private global ptr null
@.lcd4517 = private unnamed_addr constant [1 x i64] [i64 128]
@.lty4543 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4626 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4641 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty4731 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4738 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4748 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4748 = private global ptr null
@.lcd4748 = private unnamed_addr constant [16 x i64] [i64 1779033703, i64 4089235720, i64 3144134277, i64 2227873595, i64 1013904242, i64 4271175723, i64 2773480762, i64 1595750129, i64 1359893119, i64 2917565137, i64 2600822924, i64 725511199, i64 528734635, i64 4215389547, i64 1541459225, i64 327033209]
@.lty4853 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4937 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
declare void @llvm.trap()
define linkonce_odr i512 @e.sha512(i512 %s, i512 %lo, i512 %hi) "probe-stack"="inline-asm" {
entry:
  call void @llvm.trap()
  ret i512 %s
}
@.lty5413 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5431 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc5431 = private global ptr null
@.lcd5431 = private unnamed_addr constant [1 x i64] [i64 128]
@.lty5455 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5462 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5469 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5476 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5485 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty5564 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5607 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5655 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5699 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty5774 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5814 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5834 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc5834 = private global ptr null
@.lcd5834 = private unnamed_addr constant [5 x i64] [i64 1732584193, i64 4023233417, i64 2562383102, i64 271733878, i64 3285377520]
@.lty5837 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty6379 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6678 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6761 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6808 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6867 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6924 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6943 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty7210 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7218 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7252 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty7271 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7282 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7292 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7304 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7314 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7323 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB7399 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty7492 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB7500 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty7503 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7503 = private global ptr null
@.lcd7503 = private unnamed_addr constant [12 x i64] [i64 132, i64 106, i64 83, i64 105, i64 103, i64 110, i64 97, i64 116, i64 117, i64 114, i64 101, i64 49]
@.lty7506 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty7512 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7512 = private global ptr null
@.lcd7512 = private unnamed_addr constant [4 x i64] [i64 162, i64 1, i64 39, i64 4]
@.ltyB7515 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.s7517 = private unnamed_addr constant [1 x i8] c"\00"
@.s7527 = private unnamed_addr constant [1 x i8] c"\00"
@.s7534 = private unnamed_addr constant [1 x i8] c"\00"
@.s7539 = private unnamed_addr constant [1 x i8] c"\00"
@.s7546 = private unnamed_addr constant [1 x i8] c"\00"
@.s7565 = private unnamed_addr constant [1 x i8] c"\00"
@.s7592 = private unnamed_addr constant [1 x i8] c"\00"
@.s7628 = private unnamed_addr constant [21 x i8] c"cose: missing tag 18\00"
@.s7646 = private unnamed_addr constant [24 x i8] c"cose: expected array(4)\00"
@.s7654 = private unnamed_addr constant [27 x i8] c"cose: bad protected header\00"
@.s7672 = private unnamed_addr constant [37 x i8] c"cose: expected empty unprotected map\00"
@.s7680 = private unnamed_addr constant [18 x i8] c"cose: bad payload\00"
@.s7694 = private unnamed_addr constant [20 x i8] c"cose: bad signature\00"
@.s7697 = private unnamed_addr constant [1 x i8] c"\00"
@.lty7716 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty7718 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7718 = private global ptr null
@.lcd7718 = private unnamed_addr constant [10 x i64] [i64 131, i64 104, i64 69, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48]
@.lty7722 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7722 = private global ptr null
@.lcd7722 = private unnamed_addr constant [4 x i64] [i64 161, i64 1, i64 24, i64 24]
@.lty7724 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7724 = private global ptr null
@.lcd7724 = private unnamed_addr constant [25 x i64] [i64 114, i64 101, i64 115, i64 105, i64 100, i64 47, i64 99, i64 111, i64 115, i64 101, i64 47, i64 101, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48, i64 47, i64 110, i64 111, i64 110, i64 99, i64 101]
@.lty7735 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7735 = private global ptr null
@.lcd7735 = private unnamed_addr constant [16 x i64] [i64 131, i64 104, i64 69, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48, i64 68, i64 161, i64 1, i64 24, i64 24, i64 64]
@.lty7739 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7739 = private global ptr null
@.lcd7739 = private unnamed_addr constant [9 x i64] [i64 208, i64 131, i64 68, i64 161, i64 1, i64 24, i64 24, i64 161, i64 5]
@.ltyB7743 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.s7772 = private unnamed_addr constant [21 x i8] c"cose: missing tag 16\00"
@.s7790 = private unnamed_addr constant [24 x i8] c"cose: expected array(3)\00"
@.s7798 = private unnamed_addr constant [27 x i8] c"cose: bad protected header\00"
@.s7816 = private unnamed_addr constant [34 x i8] c"cose: expected unprotected map(1)\00"
@.s7834 = private unnamed_addr constant [24 x i8] c"cose: expected iv key 5\00"
@.s7848 = private unnamed_addr constant [26 x i8] c"cose: iv must be 12 bytes\00"
@.s7862 = private unnamed_addr constant [21 x i8] c"cose: bad ciphertext\00"
@.s7875 = private unnamed_addr constant [28 x i8] c"cose: authentication failed\00"
@.s7885 = private unnamed_addr constant [1 x i8] c"\00"
@.lty7900 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.s7907 = private unnamed_addr constant [4 x i8] c"mul\00"
@.s7911 = private unnamed_addr constant [4 x i8] c"mod\00"
@.s7916 = private unnamed_addr constant [7 x i8] c"modmul\00"
@.s7920 = private unnamed_addr constant [4 x i8] c"inv\00"
@.lty7931 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.s7934 = private unnamed_addr constant [4 x i8] c"gcd\00"
@.s7938 = private unnamed_addr constant [4 x i8] c"shr\00"
@.lty7944 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.lty7962 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7962 = private global ptr null
@.lcd7962 = private unnamed_addr constant [1 x i64] [i64 12345]
@.lty7965 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7965 = private global ptr null
@.lcd7965 = private unnamed_addr constant [1 x i64] [i64 999]
@resid.cap.main = unnamed_addr constant [5 x i8] c"args\00"
@resid.cap.main.1 = unnamed_addr constant [5 x i8] c"args\00"
@resid.cap.main.2 = unnamed_addr constant [5 x i8] c"args\00"
@.ltyB8028 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty8243 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.oty8276 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox8276 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty8276}, align 16
@.oty8297 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox8297 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty8297}, align 16
@.oty8300 = private unnamed_addr constant [18 x i8] c"Option(List(Int))\00"
@.lty8336 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8381 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8460 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8554 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty8588 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8680 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8721 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB8759 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty8760 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8766 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8766 = private global ptr null
@.lcd8766 = private unnamed_addr constant [1 x i64] [i64 0]
@.lty8808 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8830 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8928 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9105 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9214 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9922 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10323 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10325 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.s10336 = private unnamed_addr constant [28 x i8] c"bn_divmod: division by zero\00"
@.lty10338 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.ltyE10347 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10350 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10368 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10378 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10388 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10398 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10408 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10418 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10428 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10438 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.s10748 = private unnamed_addr constant [1 x i8] c"\00"
@.lty10756 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10765 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10776 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10801 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10811 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10821 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10831 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10841 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10851 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10861 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10871 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
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
