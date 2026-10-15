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
br label %LSL1189
LSL1189:
br i1 %t1188, label %LSR1189, label %LSJ1189
LSR1189:
%t1190 = call i64 @resid_list_len(ptr %p2)
%t1191 = icmp sle i64 %t1190, 64
br label %LSJ1189
LSJ1189:
%t1192 = phi i1 [ false, %LSL1189 ], [ %t1191, %LSR1189 ]
br label %LSL1193
LSL1193:
br i1 %t1192, label %LSR1193, label %LSJ1193
LSR1193:
%t1195 = call ptr @resid_list_const_i64(ptr @.lc1194, i64 1, ptr @.lcd1194, ptr @.lty1194)
%t1196 = call i64 @bn_cmp(ptr %p2, ptr %t1195)
%t1197 = icmp sgt i64 %t1196, 0
br label %LSJ1193
LSJ1193:
%t1198 = phi i1 [ false, %LSL1193 ], [ %t1197, %LSR1193 ]
br i1 %t1198, label %L193, label %L195
L193:
%t1199 = call i64 @resid_list_len(ptr %p1)
%t1200 = icmp eq i64 %t1199, 0
br i1 %t1200, label %L196, label %L198
L196:
%t1202 = call ptr @resid_list_const_i64(ptr @.lc1201, i64 1, ptr @.lcd1201, ptr @.lty1201)
%t1203 = call ptr @bn_mod(ptr %t1202, ptr %p2)
ret ptr %t1203
L198:
%t1204 = call ptr @bn_mod(ptr %p0, ptr %p2)
%t1205 = call i64 @resid_list_len(ptr %p2)
%t1206 = mul nsw i64 %t1205, 64
%t1207 = call ptr @__m____________lib_bignum_resid__bn_native_exp(ptr %t1204, ptr %p1, ptr %p2, i64 %t1206)
ret ptr %t1207
L195:
%t1208 = call i1 @bn_is_odd(ptr %p2)
br i1 %t1208, label %L199, label %L201
L199:
%t1209 = call ptr @bn_mont_new(ptr %p2)
%t1210 = call ptr @bn_mod(ptr %p0, ptr %p2)
%t1211 = musttail call ptr @bn_modexp_mont(ptr %t1209, ptr %t1210, ptr %p1)
ret ptr %t1211
L201:
%t1212 = call ptr @bn_mod(ptr %p0, ptr %p2)
%t1213 = call i64 @bn_bit_len(ptr %p1)
%t1214 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t1213, i64 1)
%t1215 = extractvalue {i64, i1} %t1214, 0
%t1216 = extractvalue {i64, i1} %t1214, 1
%t1217 = zext i1 %t1216 to i8
call void @resid_overflow_check(i8 %t1217)
%t1219 = call ptr @resid_list_const_i64(ptr @.lc1218, i64 1, ptr @.lcd1218, ptr @.lty1218)
%t1220 = call ptr @bn_mod(ptr %t1219, ptr %p2)
%t1221 = call ptr @__m____________lib_bignum_resid__bn_modexp_plain(ptr %t1212, ptr %p1, ptr %p2, i64 %t1215, ptr %t1220)
ret ptr %t1221
}
define ptr @__m____________lib_bignum_resid__bn_modexp_plain(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1224, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t1229, %tco.s0 ]
%t1222 = icmp slt i64 %p3, 0
br i1 %t1222, label %L202, label %L204
L202:
ret ptr %p4
L204:
%t1223 = call ptr @bn_modmul(ptr %p4, ptr %p4, ptr %p2)
%t1224 = sub nsw i64 %p3, 1
%t1225 = call i64 @bn_bit(ptr %p1, i64 %p3)
%t1226 = icmp eq i64 %t1225, 1
br i1 %t1226, label %L205, label %L206
L205:
%t1227 = call ptr @bn_modmul(ptr %t1223, ptr %p0, ptr %p2)
%t1228 = call ptr @resid_list_freeze(ptr %t1227)
br label %L207
L206:
br label %L207
L207:
%t1229 = phi ptr [ %t1228, %L205 ], [ %t1223, %L206 ]
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @bn_miller_rabin(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1231 = call ptr @bn_mont_new(ptr %p0)
%t1233 = call ptr @resid_list_const_i64(ptr @.lc1232, i64 1, ptr @.lcd1232, ptr @.lty1232)
%t1234 = call ptr @bn_sub(ptr %p0, ptr %t1233)
%t1235 = call i64 @__m____________lib_bignum_resid__bn_trailing_zeros(ptr %t1234, i64 0)
%t1236 = call ptr @bn_shr(ptr %t1234, i64 %t1235)
%t1237 = call i1 @__m____________lib_bignum_resid__bn_mr_each(ptr %t1231, ptr %t1234, ptr %t1236, i64 %t1235, ptr %p1, i64 0)
ret i1 %t1237
}
define i64 @__m____________lib_bignum_resid__bn_trailing_zeros(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1245, %tco.s0 ]
%t1238 = call i64 @bn_bit(ptr %p0, i64 %p1)
%t1239 = icmp eq i64 %t1238, 1
br label %LSL1240
LSL1240:
br i1 %t1239, label %LSJ1240, label %LSR1240
LSR1240:
%t1241 = call i64 @bn_bit_len(ptr %p0)
%t1242 = icmp sgt i64 %p1, %t1241
br label %LSJ1240
LSJ1240:
%t1243 = phi i1 [ true, %LSL1240 ], [ %t1242, %LSR1240 ]
br i1 %t1243, label %L208, label %L210
L208:
ret i64 %p1
L210:
%t1244 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t1245 = extractvalue {i64, i1} %t1244, 0
%t1246 = extractvalue {i64, i1} %t1244, 1
%t1247 = zext i1 %t1246 to i8
call void @resid_overflow_check(i8 %t1247)
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
%p5 = phi i64 [ %p5.in, %entry ], [ %t1256, %tco.s0.k ]
%t1249 = call i64 @resid_list_len(ptr %p4)
%t1250 = icmp sge i64 %p5, %t1249
br i1 %t1250, label %L211, label %L213
L211:
call void @resid_scope_pop(i64 %lml)
ret i1 true
L213:
%t1251 = call ptr @resid_list_get_v(ptr %p4, i64 %p5, ptr %p4.ld, i64 %p4.ln)
%t1254 = call i1 @__m____________lib_bignum_resid__bn_mr_witness(ptr %p0, ptr %p1, ptr %p2, i64 %p3, ptr %t1251)
%t1255 = xor i1 %t1254, true
br i1 %t1255, label %L214, label %L216
L214:
call void @resid_scope_pop(i64 %lml)
ret i1 false
L216:
%t1256 = add nsw i64 %p5, 1
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
%t1258 = getelementptr i8, ptr %p0, i64 0
%t1259 = load ptr, ptr %t1258, align 8
%t1260 = call ptr @bn_mod(ptr %p4, ptr %t1259)
%t1261 = call ptr @bn_modexp_mont(ptr %p0, ptr %t1260, ptr %p2)
%t1263 = call ptr @resid_list_const_i64(ptr @.lc1262, i64 1, ptr @.lcd1262, ptr @.lty1262)
%t1264 = call i64 @bn_cmp(ptr %t1261, ptr %t1263)
%t1265 = icmp eq i64 %t1264, 0
br label %LSL1266
LSL1266:
br i1 %t1265, label %LSJ1266, label %LSR1266
LSR1266:
%t1267 = call i64 @bn_cmp(ptr %t1261, ptr %p1)
%t1268 = icmp eq i64 %t1267, 0
br label %LSJ1266
LSJ1266:
%t1269 = phi i1 [ true, %LSL1266 ], [ %t1268, %LSR1266 ]
br i1 %t1269, label %L217, label %L219
L217:
ret i1 true
L219:
%t1270 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p3, i64 1)
%t1271 = extractvalue {i64, i1} %t1270, 0
%t1272 = extractvalue {i64, i1} %t1270, 1
%t1273 = zext i1 %t1272 to i8
call void @resid_overflow_check(i8 %t1273)
%t1274 = call i1 @__m____________lib_bignum_resid__bn_mr_square(ptr %p0, ptr %p1, ptr %t1261, i64 %t1271)
ret i1 %t1274
}
define i1 @__m____________lib_bignum_resid__bn_mr_square(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t1278, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1285, %tco.s0 ]
%t1275 = icmp sle i64 %p3, 0
br i1 %t1275, label %L220, label %L222
L220:
ret i1 false
L222:
%t1276 = getelementptr i8, ptr %p0, i64 0
%t1277 = load ptr, ptr %t1276, align 8
%t1278 = call ptr @bn_modmul(ptr %p2, ptr %p2, ptr %t1277)
%t1279 = call i64 @bn_cmp(ptr %t1278, ptr %p1)
%t1280 = icmp eq i64 %t1279, 0
br i1 %t1280, label %L223, label %L225
L223:
ret i1 true
L225:
%t1282 = call ptr @resid_list_const_i64(ptr @.lc1281, i64 1, ptr @.lcd1281, ptr @.lty1281)
%t1283 = call i64 @bn_cmp(ptr %t1278, ptr %t1282)
%t1284 = icmp eq i64 %t1283, 0
br i1 %t1284, label %L226, label %L228
L226:
ret i1 false
L228:
%t1285 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_small_primes(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1287 = call ptr @resid_listbuf_new()
%t1288 = call ptr @__m____________lib_bignum_resid__bn_sp_from(i64 %p0, i64 3, ptr %t1287)
ret ptr %t1288
}
define ptr @__m____________lib_bignum_resid__bn_sp_from(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1298, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t1296, %tco.s0 ]
%t1289 = icmp sgt i64 %p1, %p0
br i1 %t1289, label %L229, label %L231
L229:
%t1290 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty1290)
ret ptr %t1290
L231:
%t1291 = call i1 @__m____________lib_bignum_resid__bn_sp_is_prime(i64 %p1, i64 3)
br i1 %t1291, label %L232, label %L233
L232:
%t1292 = call ptr @resid_box_i64(i64 %p1)
%t1295 = call ptr @resid_listbuf_push(ptr %p2, ptr %t1292)
br label %L234
L233:
br label %L234
L234:
%t1296 = phi ptr [ %t1295, %L232 ], [ %p2, %L233 ]
%t1297 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t1298 = extractvalue {i64, i1} %t1297, 0
%t1299 = extractvalue {i64, i1} %t1297, 1
%t1300 = zext i1 %t1299 to i8
call void @resid_overflow_check(i8 %t1300)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @__m____________lib_bignum_resid__bn_sp_is_prime(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1317, %tco.s0 ]
%t1302 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 %p1)
%t1303 = extractvalue {i64, i1} %t1302, 0
%t1304 = extractvalue {i64, i1} %t1302, 1
%t1305 = zext i1 %t1304 to i8
call void @resid_overflow_check(i8 %t1305)
%t1306 = icmp sgt i64 %t1303, %p0
br i1 %t1306, label %L235, label %L237
L235:
ret i1 true
L237:
%t1307 = icmp eq i64 %p1, 0
%t1308 = zext i1 %t1307 to i8
call void @resid_div_check(i8 %t1308)
%t1309 = icmp eq i64 %p1, -1
%t1310 = icmp eq i64 %p0, -9223372036854775808
%t1311 = and i1 %t1309, %t1310
%t1312 = select i1 %t1309, i64 1, i64 %p1
%t1313 = srem i64 %p0, %t1312
%t1315 = icmp eq i64 %t1313, 0
br i1 %t1315, label %L238, label %L240
L238:
ret i1 false
L240:
%t1316 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t1317 = extractvalue {i64, i1} %t1316, 0
%t1318 = extractvalue {i64, i1} %t1316, 1
%t1319 = zext i1 %t1318 to i8
call void @resid_overflow_check(i8 %t1319)
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
%t1321 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 1)
%t1322 = extractvalue {i64, i1} %t1321, 0
%t1323 = extractvalue {i64, i1} %t1321, 1
%t1324 = zext i1 %t1323 to i8
call void @resid_overflow_check(i8 %t1324)
%t1325 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t1322, i64 7)
%t1326 = extractvalue {i64, i1} %t1325, 0
%t1327 = extractvalue {i64, i1} %t1325, 1
%t1328 = zext i1 %t1327 to i8
call void @resid_overflow_check(i8 %t1328)
%t1329 = sdiv i64 %t1326, 8
%t1330 = call ptr @resid_listbuf_new()
%t1331 = call ptr @__m____________lib_bignum_resid__bn_take_int(ptr %p0, i64 %t1329, i64 0, ptr %t1330)
%t1332 = call ptr @bn_from_be(ptr %t1331)
%t1334 = call ptr @resid_list_const_i64(ptr @.lc1333, i64 1, ptr @.lcd1333, ptr @.lty1333)
%t1335 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 1)
%t1336 = extractvalue {i64, i1} %t1335, 0
%t1337 = extractvalue {i64, i1} %t1335, 1
%t1338 = zext i1 %t1337 to i8
call void @resid_overflow_check(i8 %t1338)
%t1339 = call ptr @bn_shl(ptr %t1334, i64 %t1336)
%t1341 = call ptr @resid_list_const_i64(ptr @.lc1340, i64 1, ptr @.lcd1340, ptr @.lty1340)
%t1342 = call ptr @bn_sub(ptr %t1339, ptr %t1341)
%t1343 = call ptr @bn_and(ptr %t1332, ptr %t1342)
%t1345 = call ptr @resid_list_const_i64(ptr @.lc1344, i64 1, ptr @.lcd1344, ptr @.lty1344)
%t1346 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 3)
%t1347 = extractvalue {i64, i1} %t1346, 0
%t1348 = extractvalue {i64, i1} %t1346, 1
%t1349 = zext i1 %t1348 to i8
call void @resid_overflow_check(i8 %t1349)
%t1350 = call ptr @bn_shl(ptr %t1345, i64 %t1347)
%t1351 = call ptr @resid_list_freeze(ptr %t1350)
%t1352 = call ptr @bn_or(ptr %t1343, ptr %t1351)
%t1353 = call ptr @resid_list_freeze(ptr %t1352)
%t1355 = call ptr @resid_list_const_i64(ptr @.lc1354, i64 1, ptr @.lcd1354, ptr @.lty1354)
%t1356 = call ptr @bn_or(ptr %t1353, ptr %t1355)
%t1357 = call ptr @resid_list_freeze(ptr %t1356)
%t1359 = call ptr @resid_list_const_i64(ptr @.lc1358, i64 302, ptr @.lcd1358, ptr @.lty1358)
%t1360 = call ptr @resid_listbuf_new()
%t1361 = call ptr @__m____________lib_bignum_resid__bn_residues(ptr %t1357, ptr %t1359, i64 0, ptr %t1360)
%t1363 = call ptr @resid_list_const_i64(ptr @.lc1362, i64 302, ptr @.lcd1362, ptr @.lty1362)
%t1364 = call ptr @__m____________lib_bignum_resid__bn_safe_search(ptr %t1357, ptr %t1363, ptr %t1361, i64 0)
ret ptr %t1364
}
define ptr @__m____________lib_bignum_resid__bn_take_int(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1367, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t1374, %tco.s0 ]
%t1365 = icmp sge i64 %p2, %p1
br i1 %t1365, label %L241, label %L243
L241:
%t1366 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty1366)
ret ptr %t1366
L243:
%t1367 = add nsw i64 %p2, 1
%t1368 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t1369 = call i64 @resid_unbox_i64(ptr %t1368)
%t1371 = call ptr @resid_box_i64(i64 %t1369)
%t1374 = call ptr @resid_listbuf_push(ptr %p3, ptr %t1371)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_bignum_resid__bn_residues(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1389 = alloca [1 x ptr]
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1396, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t1413, %tco.s0 ]
%t1376 = call i64 @resid_list_len(ptr %p1)
%t1377 = icmp sge i64 %p2, %t1376
br i1 %t1377, label %L244, label %L246
L244:
%t1378 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty1378)
ret ptr %t1378
L246:
%t1379 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t1380 = call i64 @resid_unbox_i64(ptr %t1379)
%t1382 = add i64 %t1380, 0
%t1383 = add i64 %t1382, 0
%t1384 = add i64 %t1383, 0
%t1385 = icmp ne i64 %t1384, %t1382
%t1386 = icmp slt i64 %t1380, 0
%t1387 = or i1 %t1385, %t1386
%t1388 = zext i1 %t1387 to i8
call void @resid_conv_check(i8 %t1388)
%t1391 = call ptr @resid_box_i64(i64 %t1383)
%t1393 = getelementptr i8, ptr %t1389, i64 0
store ptr %t1391, ptr %t1393
%t1394 = call ptr @resid_list_new(i64 1, ptr %t1389, ptr @.lty1389)
%t1395 = call ptr @bn_mod(ptr %p0, ptr %t1394)
%t1396 = add nsw i64 %p2, 1
%t1397 = call i64 @resid_list_len(ptr %t1395)
%t1398 = icmp eq i64 %t1397, 0
br i1 %t1398, label %L247, label %L248
L247:
br label %L249
L248:
%t1399 = call ptr @resid_list_get(ptr %t1395, i64 0)
%t1400 = call i64 @resid_unbox_i64(ptr %t1399)
%t1402 = add i64 %t1400, 0
%t1403 = add i64 %t1402, 0
%t1404 = add i64 %t1403, 0
%t1405 = icmp ne i64 %t1404, %t1402
%t1406 = icmp slt i64 %t1403, 0
%t1407 = or i1 %t1405, %t1406
%t1408 = zext i1 %t1407 to i8
call void @resid_conv_check(i8 %t1408)
br label %L249
L249:
%t1409 = phi i64 [ 0, %L247 ], [ %t1403, %L248 ]
%t1410 = call ptr @resid_box_i64(i64 %t1409)
%t1413 = call ptr @resid_listbuf_push(ptr %p3, ptr %t1410)
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t1459, %tco.s0 ]
%t1415 = call i64 @resid_list_len(ptr %p0)
%t1416 = icmp sge i64 %p3, %t1415
br i1 %t1416, label %L250, label %L252
L250:
ret i1 true
L252:
%t1417 = call ptr @resid_list_get_v(ptr %p0, i64 %p3, ptr %p0.ld, i64 %p0.ln)
%t1418 = call i64 @resid_unbox_i64(ptr %t1417)
%t1420 = call ptr @resid_list_get_v(ptr %p1, i64 %p3, ptr %p1.ld, i64 %p1.ln)
%t1421 = call i64 @resid_unbox_i64(ptr %t1420)
%t1423 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p2)
%t1424 = extractvalue {i64, i1} %t1423, 0
%t1425 = extractvalue {i64, i1} %t1423, 1
%t1426 = zext i1 %t1425 to i8
call void @resid_overflow_check(i8 %t1426)
%t1427 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t1421, i64 %t1424)
%t1428 = extractvalue {i64, i1} %t1427, 0
%t1429 = extractvalue {i64, i1} %t1427, 1
%t1430 = zext i1 %t1429 to i8
call void @resid_overflow_check(i8 %t1430)
%t1431 = icmp eq i64 %t1418, 0
%t1432 = zext i1 %t1431 to i8
call void @resid_div_check(i8 %t1432)
%t1433 = icmp eq i64 %t1418, -1
%t1434 = icmp eq i64 %t1428, -9223372036854775808
%t1435 = and i1 %t1433, %t1434
%t1436 = select i1 %t1433, i64 1, i64 %t1418
%t1437 = srem i64 %t1428, %t1436
%t1439 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %t1437)
%t1440 = extractvalue {i64, i1} %t1439, 0
%t1441 = extractvalue {i64, i1} %t1439, 1
%t1442 = zext i1 %t1441 to i8
call void @resid_overflow_check(i8 %t1442)
%t1443 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t1440, i64 1)
%t1444 = extractvalue {i64, i1} %t1443, 0
%t1445 = extractvalue {i64, i1} %t1443, 1
%t1446 = zext i1 %t1445 to i8
call void @resid_overflow_check(i8 %t1446)
%t1447 = icmp eq i64 %t1418, 0
%t1448 = zext i1 %t1447 to i8
call void @resid_div_check(i8 %t1448)
%t1449 = icmp eq i64 %t1418, -1
%t1450 = icmp eq i64 %t1444, -9223372036854775808
%t1451 = and i1 %t1449, %t1450
%t1452 = select i1 %t1449, i64 1, i64 %t1418
%t1453 = srem i64 %t1444, %t1452
%t1455 = icmp eq i64 %t1437, 0
br label %LSL1456
LSL1456:
br i1 %t1455, label %LSJ1456, label %LSR1456
LSR1456:
%t1457 = icmp eq i64 %t1453, 0
br label %LSJ1456
LSJ1456:
%t1458 = phi i1 [ true, %LSL1456 ], [ %t1457, %LSR1456 ]
br i1 %t1458, label %L253, label %L255
L253:
ret i1 false
L255:
%t1459 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_mr_bases() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1462 = call ptr @resid_list_const_i64(ptr @.lc1461, i64 1, ptr @.lcd1461, ptr @.lty1461)
%t1464 = call ptr @resid_list_const_i64(ptr @.lc1463, i64 1, ptr @.lcd1463, ptr @.lty1463)
%t1466 = call ptr @resid_list_const_i64(ptr @.lc1465, i64 1, ptr @.lcd1465, ptr @.lty1465)
%t1468 = call ptr @resid_list_const_i64(ptr @.lc1467, i64 1, ptr @.lcd1467, ptr @.lty1467)
%t1470 = call ptr @resid_list_const_i64(ptr @.lc1469, i64 1, ptr @.lcd1469, ptr @.lty1469)
%t1472 = call ptr @resid_list_const_i64(ptr @.lc1471, i64 1, ptr @.lcd1471, ptr @.lty1471)
%t1474 = call ptr @resid_list_const_i64(ptr @.lc1473, i64 1, ptr @.lcd1473, ptr @.lty1473)
%t1476 = call ptr @resid_list_const_i64(ptr @.lc1475, i64 1, ptr @.lcd1475, ptr @.lty1475)
%t1478 = call ptr @resid_list_const_i64(ptr @.lc1477, i64 1, ptr @.lcd1477, ptr @.lty1477)
%t1480 = call ptr @resid_list_const_i64(ptr @.lc1479, i64 1, ptr @.lcd1479, ptr @.lty1479)
%t1482 = call ptr @resid_list_const_i64(ptr @.lc1481, i64 1, ptr @.lcd1481, ptr @.lty1481)
%t1484 = call ptr @resid_list_const_i64(ptr @.lc1483, i64 1, ptr @.lcd1483, ptr @.lty1483)
%t1485 = alloca [12 x ptr]
%t1489 = getelementptr i8, ptr %t1485, i64 0
store ptr %t1462, ptr %t1489
%t1492 = getelementptr i8, ptr %t1485, i64 8
store ptr %t1464, ptr %t1492
%t1495 = getelementptr i8, ptr %t1485, i64 16
store ptr %t1466, ptr %t1495
%t1498 = getelementptr i8, ptr %t1485, i64 24
store ptr %t1468, ptr %t1498
%t1501 = getelementptr i8, ptr %t1485, i64 32
store ptr %t1470, ptr %t1501
%t1504 = getelementptr i8, ptr %t1485, i64 40
store ptr %t1472, ptr %t1504
%t1507 = getelementptr i8, ptr %t1485, i64 48
store ptr %t1474, ptr %t1507
%t1510 = getelementptr i8, ptr %t1485, i64 56
store ptr %t1476, ptr %t1510
%t1513 = getelementptr i8, ptr %t1485, i64 64
store ptr %t1478, ptr %t1513
%t1516 = getelementptr i8, ptr %t1485, i64 72
store ptr %t1480, ptr %t1516
%t1519 = getelementptr i8, ptr %t1485, i64 80
store ptr %t1482, ptr %t1519
%t1522 = getelementptr i8, ptr %t1485, i64 88
store ptr %t1484, ptr %t1522
%t1523 = call ptr @resid_list_new(i64 12, ptr %t1485, ptr @.lty1485)
ret ptr %t1523
}
define ptr @__m____________lib_bignum_resid__bn_safe_search(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1538 = alloca [1 x ptr]
%t1554 = alloca [1 x ptr]
%t1564 = alloca [1 x ptr]
%t1573 = alloca [1 x ptr]
%t1579 = alloca [1 x ptr]
%t1585 = alloca [1 x ptr]
%t1591 = alloca [1 x ptr]
%t1597 = alloca [1 x ptr]
%t1603 = alloca [1 x ptr]
%t1609 = alloca [1 x ptr]
%t1615 = alloca [1 x ptr]
%t1621 = alloca [1 x ptr]
%t1627 = alloca [1 x ptr]
%t1633 = alloca [1 x ptr]
%t1639 = alloca [1 x ptr]
%t1645 = alloca [12 x ptr]
%t1687 = alloca [1 x ptr]
%t1693 = alloca [1 x ptr]
%t1699 = alloca [1 x ptr]
%t1705 = alloca [1 x ptr]
%t1711 = alloca [1 x ptr]
%t1717 = alloca [1 x ptr]
%t1723 = alloca [1 x ptr]
%t1729 = alloca [1 x ptr]
%t1735 = alloca [1 x ptr]
%t1741 = alloca [1 x ptr]
%t1747 = alloca [1 x ptr]
%t1753 = alloca [1 x ptr]
%t1759 = alloca [12 x ptr]
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t1803, %tco.s0 ]
%t1524 = icmp sge i64 %p3, 2048
br i1 %t1524, label %L256, label %L258
L256:
ret ptr @.nbox1525
L258:
%t1526 = call i1 @__m____________lib_bignum_resid__bn_sieve_ok(ptr %p1, ptr %p2, i64 %p3, i64 0)
br i1 %t1526, label %L259, label %L261
L259:
%t1527 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p3)
%t1528 = extractvalue {i64, i1} %t1527, 0
%t1529 = extractvalue {i64, i1} %t1527, 1
%t1530 = zext i1 %t1529 to i8
call void @resid_overflow_check(i8 %t1530)
%t1531 = add i64 %t1528, 0
%t1532 = add i64 %t1531, 0
%t1533 = add i64 %t1532, 0
%t1534 = icmp ne i64 %t1533, %t1531
%t1535 = icmp slt i64 %t1528, 0
%t1536 = or i1 %t1534, %t1535
%t1537 = zext i1 %t1536 to i8
call void @resid_conv_check(i8 %t1537)
%t1540 = call ptr @resid_box_i64(i64 %t1532)
%t1542 = getelementptr i8, ptr %t1538, i64 0
store ptr %t1540, ptr %t1542
%t1543 = call ptr @resid_list_new(i64 1, ptr %t1538, ptr @.lty1538)
%t1544 = call ptr @bn_add(ptr %p0, ptr %t1543)
%t1545 = call ptr @resid_list_freeze(ptr %t1544)
%t1546 = call ptr @bn_shl(ptr %t1545, i64 1)
%t1547 = call ptr @resid_list_freeze(ptr %t1546)
%t1549 = call ptr @resid_list_const_i64(ptr @.lc1548, i64 1, ptr @.lcd1548, ptr @.lty1548)
%t1550 = call ptr @bn_add(ptr %t1547, ptr %t1549)
%t1551 = call ptr @resid_list_freeze(ptr %t1550)
%t1553 = call ptr @resid_list_const_i64(ptr @.lc1552, i64 1, ptr @.lcd1552, ptr @.lty1552)
%t1558 = getelementptr i8, ptr %t1554, i64 0
store ptr %t1553, ptr %t1558
%t1559 = call ptr @resid_list_new(i64 1, ptr %t1554, ptr @.lty1554)
%t1560 = call i1 @bn_miller_rabin(ptr %t1545, ptr %t1559)
br label %LSL1561
LSL1561:
br i1 %t1560, label %LSR1561, label %LSJ1561
LSR1561:
%t1563 = call ptr @resid_list_const_i64(ptr @.lc1562, i64 1, ptr @.lcd1562, ptr @.lty1562)
%t1568 = getelementptr i8, ptr %t1564, i64 0
store ptr %t1563, ptr %t1568
%t1569 = call ptr @resid_list_new(i64 1, ptr %t1564, ptr @.lty1564)
%t1570 = call i1 @bn_miller_rabin(ptr %t1551, ptr %t1569)
br label %LSJ1561
LSJ1561:
%t1571 = phi i1 [ false, %LSL1561 ], [ %t1570, %LSR1561 ]
br label %LSL1572
LSL1572:
br i1 %t1571, label %LSR1572, label %LSJ1572
LSR1572:
%t1575 = call ptr @resid_box_i64(i64 2)
%t1577 = getelementptr i8, ptr %t1573, i64 0
store ptr %t1575, ptr %t1577
%t1578 = call ptr @resid_list_new(i64 1, ptr %t1573, ptr @.lty1573)
%t1581 = call ptr @resid_box_i64(i64 3)
%t1583 = getelementptr i8, ptr %t1579, i64 0
store ptr %t1581, ptr %t1583
%t1584 = call ptr @resid_list_new(i64 1, ptr %t1579, ptr @.lty1579)
%t1587 = call ptr @resid_box_i64(i64 5)
%t1589 = getelementptr i8, ptr %t1585, i64 0
store ptr %t1587, ptr %t1589
%t1590 = call ptr @resid_list_new(i64 1, ptr %t1585, ptr @.lty1585)
%t1593 = call ptr @resid_box_i64(i64 7)
%t1595 = getelementptr i8, ptr %t1591, i64 0
store ptr %t1593, ptr %t1595
%t1596 = call ptr @resid_list_new(i64 1, ptr %t1591, ptr @.lty1591)
%t1599 = call ptr @resid_box_i64(i64 11)
%t1601 = getelementptr i8, ptr %t1597, i64 0
store ptr %t1599, ptr %t1601
%t1602 = call ptr @resid_list_new(i64 1, ptr %t1597, ptr @.lty1597)
%t1605 = call ptr @resid_box_i64(i64 13)
%t1607 = getelementptr i8, ptr %t1603, i64 0
store ptr %t1605, ptr %t1607
%t1608 = call ptr @resid_list_new(i64 1, ptr %t1603, ptr @.lty1603)
%t1611 = call ptr @resid_box_i64(i64 17)
%t1613 = getelementptr i8, ptr %t1609, i64 0
store ptr %t1611, ptr %t1613
%t1614 = call ptr @resid_list_new(i64 1, ptr %t1609, ptr @.lty1609)
%t1617 = call ptr @resid_box_i64(i64 19)
%t1619 = getelementptr i8, ptr %t1615, i64 0
store ptr %t1617, ptr %t1619
%t1620 = call ptr @resid_list_new(i64 1, ptr %t1615, ptr @.lty1615)
%t1623 = call ptr @resid_box_i64(i64 23)
%t1625 = getelementptr i8, ptr %t1621, i64 0
store ptr %t1623, ptr %t1625
%t1626 = call ptr @resid_list_new(i64 1, ptr %t1621, ptr @.lty1621)
%t1629 = call ptr @resid_box_i64(i64 29)
%t1631 = getelementptr i8, ptr %t1627, i64 0
store ptr %t1629, ptr %t1631
%t1632 = call ptr @resid_list_new(i64 1, ptr %t1627, ptr @.lty1627)
%t1635 = call ptr @resid_box_i64(i64 31)
%t1637 = getelementptr i8, ptr %t1633, i64 0
store ptr %t1635, ptr %t1637
%t1638 = call ptr @resid_list_new(i64 1, ptr %t1633, ptr @.lty1633)
%t1641 = call ptr @resid_box_i64(i64 37)
%t1643 = getelementptr i8, ptr %t1639, i64 0
store ptr %t1641, ptr %t1643
%t1644 = call ptr @resid_list_new(i64 1, ptr %t1639, ptr @.lty1639)
%t1649 = getelementptr i8, ptr %t1645, i64 0
store ptr %t1578, ptr %t1649
%t1652 = getelementptr i8, ptr %t1645, i64 8
store ptr %t1584, ptr %t1652
%t1655 = getelementptr i8, ptr %t1645, i64 16
store ptr %t1590, ptr %t1655
%t1658 = getelementptr i8, ptr %t1645, i64 24
store ptr %t1596, ptr %t1658
%t1661 = getelementptr i8, ptr %t1645, i64 32
store ptr %t1602, ptr %t1661
%t1664 = getelementptr i8, ptr %t1645, i64 40
store ptr %t1608, ptr %t1664
%t1667 = getelementptr i8, ptr %t1645, i64 48
store ptr %t1614, ptr %t1667
%t1670 = getelementptr i8, ptr %t1645, i64 56
store ptr %t1620, ptr %t1670
%t1673 = getelementptr i8, ptr %t1645, i64 64
store ptr %t1626, ptr %t1673
%t1676 = getelementptr i8, ptr %t1645, i64 72
store ptr %t1632, ptr %t1676
%t1679 = getelementptr i8, ptr %t1645, i64 80
store ptr %t1638, ptr %t1679
%t1682 = getelementptr i8, ptr %t1645, i64 88
store ptr %t1644, ptr %t1682
%t1683 = call ptr @resid_list_new(i64 12, ptr %t1645, ptr @.lty1645)
%t1684 = call i1 @bn_miller_rabin(ptr %t1545, ptr %t1683)
br label %LSJ1572
LSJ1572:
%t1685 = phi i1 [ false, %LSL1572 ], [ %t1684, %LSR1572 ]
br label %LSL1686
LSL1686:
br i1 %t1685, label %LSR1686, label %LSJ1686
LSR1686:
%t1689 = call ptr @resid_box_i64(i64 2)
%t1691 = getelementptr i8, ptr %t1687, i64 0
store ptr %t1689, ptr %t1691
%t1692 = call ptr @resid_list_new(i64 1, ptr %t1687, ptr @.lty1687)
%t1695 = call ptr @resid_box_i64(i64 3)
%t1697 = getelementptr i8, ptr %t1693, i64 0
store ptr %t1695, ptr %t1697
%t1698 = call ptr @resid_list_new(i64 1, ptr %t1693, ptr @.lty1693)
%t1701 = call ptr @resid_box_i64(i64 5)
%t1703 = getelementptr i8, ptr %t1699, i64 0
store ptr %t1701, ptr %t1703
%t1704 = call ptr @resid_list_new(i64 1, ptr %t1699, ptr @.lty1699)
%t1707 = call ptr @resid_box_i64(i64 7)
%t1709 = getelementptr i8, ptr %t1705, i64 0
store ptr %t1707, ptr %t1709
%t1710 = call ptr @resid_list_new(i64 1, ptr %t1705, ptr @.lty1705)
%t1713 = call ptr @resid_box_i64(i64 11)
%t1715 = getelementptr i8, ptr %t1711, i64 0
store ptr %t1713, ptr %t1715
%t1716 = call ptr @resid_list_new(i64 1, ptr %t1711, ptr @.lty1711)
%t1719 = call ptr @resid_box_i64(i64 13)
%t1721 = getelementptr i8, ptr %t1717, i64 0
store ptr %t1719, ptr %t1721
%t1722 = call ptr @resid_list_new(i64 1, ptr %t1717, ptr @.lty1717)
%t1725 = call ptr @resid_box_i64(i64 17)
%t1727 = getelementptr i8, ptr %t1723, i64 0
store ptr %t1725, ptr %t1727
%t1728 = call ptr @resid_list_new(i64 1, ptr %t1723, ptr @.lty1723)
%t1731 = call ptr @resid_box_i64(i64 19)
%t1733 = getelementptr i8, ptr %t1729, i64 0
store ptr %t1731, ptr %t1733
%t1734 = call ptr @resid_list_new(i64 1, ptr %t1729, ptr @.lty1729)
%t1737 = call ptr @resid_box_i64(i64 23)
%t1739 = getelementptr i8, ptr %t1735, i64 0
store ptr %t1737, ptr %t1739
%t1740 = call ptr @resid_list_new(i64 1, ptr %t1735, ptr @.lty1735)
%t1743 = call ptr @resid_box_i64(i64 29)
%t1745 = getelementptr i8, ptr %t1741, i64 0
store ptr %t1743, ptr %t1745
%t1746 = call ptr @resid_list_new(i64 1, ptr %t1741, ptr @.lty1741)
%t1749 = call ptr @resid_box_i64(i64 31)
%t1751 = getelementptr i8, ptr %t1747, i64 0
store ptr %t1749, ptr %t1751
%t1752 = call ptr @resid_list_new(i64 1, ptr %t1747, ptr @.lty1747)
%t1755 = call ptr @resid_box_i64(i64 37)
%t1757 = getelementptr i8, ptr %t1753, i64 0
store ptr %t1755, ptr %t1757
%t1758 = call ptr @resid_list_new(i64 1, ptr %t1753, ptr @.lty1753)
%t1763 = getelementptr i8, ptr %t1759, i64 0
store ptr %t1692, ptr %t1763
%t1766 = getelementptr i8, ptr %t1759, i64 8
store ptr %t1698, ptr %t1766
%t1769 = getelementptr i8, ptr %t1759, i64 16
store ptr %t1704, ptr %t1769
%t1772 = getelementptr i8, ptr %t1759, i64 24
store ptr %t1710, ptr %t1772
%t1775 = getelementptr i8, ptr %t1759, i64 32
store ptr %t1716, ptr %t1775
%t1778 = getelementptr i8, ptr %t1759, i64 40
store ptr %t1722, ptr %t1778
%t1781 = getelementptr i8, ptr %t1759, i64 48
store ptr %t1728, ptr %t1781
%t1784 = getelementptr i8, ptr %t1759, i64 56
store ptr %t1734, ptr %t1784
%t1787 = getelementptr i8, ptr %t1759, i64 64
store ptr %t1740, ptr %t1787
%t1790 = getelementptr i8, ptr %t1759, i64 72
store ptr %t1746, ptr %t1790
%t1793 = getelementptr i8, ptr %t1759, i64 80
store ptr %t1752, ptr %t1793
%t1796 = getelementptr i8, ptr %t1759, i64 88
store ptr %t1758, ptr %t1796
%t1797 = call ptr @resid_list_new(i64 12, ptr %t1759, ptr @.lty1759)
%t1798 = call i1 @bn_miller_rabin(ptr %t1551, ptr %t1797)
br label %LSJ1686
LSJ1686:
%t1799 = phi i1 [ false, %LSL1686 ], [ %t1798, %LSR1686 ]
br i1 %t1799, label %L262, label %L264
L262:
%t1802 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty1800)
%t1801 = getelementptr {i32, i32, ptr}, ptr %t1802, i32 1
store ptr %t1551, ptr %t1801
ret ptr %t1802
L264:
br label %L261
L261:
%t1803 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_and(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1805 = call i64 @resid_list_len(ptr %p0)
%t1806 = call i64 @resid_list_len(ptr %p1)
%t1807 = icmp slt i64 %t1805, %t1806
br i1 %t1807, label %L265, label %L266
L265:
%t1808 = call i64 @resid_list_len(ptr %p0)
br label %L267
L266:
%t1809 = call i64 @resid_list_len(ptr %p1)
br label %L267
L267:
%t1810 = phi i64 [ %t1808, %L265 ], [ %t1809, %L266 ]
%t1811 = call ptr @resid_listbuf_new()
%t1812 = call ptr @__m____________lib_bignum_resid__bn_and_at(ptr %p0, ptr %p1, i64 0, i64 %t1810, ptr %t1811)
%t1813 = call ptr @bn_trim(ptr %t1812)
ret ptr %t1813
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t1816, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t1827, %tco.s0 ]
%t1814 = icmp sge i64 %p2, %p3
br i1 %t1814, label %L268, label %L270
L268:
%t1815 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty1815)
ret ptr %t1815
L270:
%t1816 = add nsw i64 %p2, 1
%t1817 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t1818 = call i64 @resid_unbox_i64(ptr %t1817)
%t1820 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t1821 = call i64 @resid_unbox_i64(ptr %t1820)
%t1823 = and i64 %t1818, %t1821
%t1824 = call ptr @resid_box_i64(i64 %t1823)
%t1827 = call ptr @resid_listbuf_push(ptr %p4, ptr %t1824)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_or(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1829 = call i64 @resid_list_len(ptr %p0)
%t1830 = call i64 @resid_list_len(ptr %p1)
%t1831 = icmp sgt i64 %t1829, %t1830
br i1 %t1831, label %L271, label %L272
L271:
%t1832 = call i64 @resid_list_len(ptr %p0)
br label %L273
L272:
%t1833 = call i64 @resid_list_len(ptr %p1)
br label %L273
L273:
%t1834 = phi i64 [ %t1832, %L271 ], [ %t1833, %L272 ]
%t1835 = call ptr @resid_listbuf_new()
%t1836 = call ptr @__m____________lib_bignum_resid__bn_or_at(ptr %p0, ptr %p1, i64 0, i64 %t1834, ptr %t1835)
ret ptr %t1836
}
define ptr @__m____________lib_bignum_resid__bn_or_at(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1839, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t1846, %tco.s0 ]
%t1837 = icmp sge i64 %p2, %p3
br i1 %t1837, label %L274, label %L276
L274:
%t1838 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty1838)
ret ptr %t1838
L276:
%t1839 = add nsw i64 %p2, 1
%t1840 = call i64 @__m____________lib_bignum_resid__bn_get(ptr %p0, i64 %p2)
%t1841 = call i64 @__m____________lib_bignum_resid__bn_get(ptr %p1, i64 %p2)
%t1842 = or i64 %t1840, %t1841
%t1843 = call ptr @resid_box_i64(i64 %t1842)
%t1846 = call ptr @resid_listbuf_push(ptr %p4, ptr %t1843)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bn_safe_prime_stream(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1848 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 1)
%t1849 = extractvalue {i64, i1} %t1848, 0
%t1850 = extractvalue {i64, i1} %t1848, 1
%t1851 = zext i1 %t1850 to i8
call void @resid_overflow_check(i8 %t1851)
%t1852 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t1849, i64 7)
%t1853 = extractvalue {i64, i1} %t1852, 0
%t1854 = extractvalue {i64, i1} %t1852, 1
%t1855 = zext i1 %t1854 to i8
call void @resid_overflow_check(i8 %t1855)
%t1856 = sdiv i64 %t1853, 8
%t1857 = call ptr @__m____________lib_bignum_resid__bn_sps_from(ptr %p0, i64 %p1, i64 %t1856, i64 0)
ret ptr %t1857
}
define ptr @__m____________lib_bignum_resid__bn_sps_from(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1858 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %p2)
%t1859 = extractvalue {i64, i1} %t1858, 0
%t1860 = extractvalue {i64, i1} %t1858, 1
%t1861 = zext i1 %t1860 to i8
call void @resid_overflow_check(i8 %t1861)
%t1862 = call i64 @resid_list_len(ptr %p0)
%t1863 = icmp sgt i64 %t1859, %t1862
br i1 %t1863, label %L277, label %L279
L277:
ret ptr @.nbox1864
L279:
%t1865 = call ptr @bn_slice_int(ptr %p0, i64 %p3, i64 %p2)
%t1866 = call ptr @resid_list_freeze(ptr %t1865)
%t1867 = call ptr @bn_safe_prime(ptr %t1866, i64 %p1)
%t1868 = getelementptr {i32, i32, ptr}, ptr %t1867, i32 0, i32 0
%t1869w = load i32, ptr %t1868
%t1869 = sext i32 %t1869w to i64
%t1870 = icmp eq i64 %t1869, 1
br i1 %t1870, label %L280, label %L281
L280:
%t1871 = getelementptr {i32, i32, ptr}, ptr %t1867, i32 1
%t1872 = getelementptr i8, ptr %t1871, i64 0
%t1873 = getelementptr ptr, ptr %t1872, i32 0
%t1874 = load ptr, ptr %t1873
%t1877 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty1875)
%t1876 = getelementptr {i32, i32, ptr}, ptr %t1877, i32 1
store ptr %t1874, ptr %t1876
br label %L282
L281:
%t1878 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %p2)
%t1879 = extractvalue {i64, i1} %t1878, 0
%t1880 = extractvalue {i64, i1} %t1878, 1
%t1881 = zext i1 %t1880 to i8
call void @resid_overflow_check(i8 %t1881)
%t1882 = call ptr @__m____________lib_bignum_resid__bn_sps_from(ptr %p0, i64 %p1, i64 %p2, i64 %t1879)
br label %L282
L282:
%t1883 = phi ptr [ %t1877, %L280 ], [ %t1882, %L281 ]
ret ptr %t1883
}
define ptr @bn_slice_int(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1884 = call ptr @resid_listbuf_new()
%t1885 = call ptr @__m____________lib_bignum_resid__bn_slice_at(ptr %p0, i64 %p1, i64 %p2, i64 0, ptr %t1884)
ret ptr %t1885
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t1888, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t1899, %tco.s0 ]
%t1886 = icmp sge i64 %p3, %p2
br i1 %t1886, label %L283, label %L285
L283:
%t1887 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty1887)
ret ptr %t1887
L285:
%t1888 = add nsw i64 %p3, 1
%t1889 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p3)
%t1890 = extractvalue {i64, i1} %t1889, 0
%t1891 = extractvalue {i64, i1} %t1889, 1
%t1892 = zext i1 %t1891 to i8
call void @resid_overflow_check(i8 %t1892)
%t1893 = call ptr @resid_list_get_v(ptr %p0, i64 %t1890, ptr %p0.ld, i64 %p0.ln)
%t1894 = call i64 @resid_unbox_i64(ptr %t1893)
%t1896 = call ptr @resid_box_i64(i64 %t1894)
%t1899 = call ptr @resid_listbuf_push(ptr %p4, ptr %t1896)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @bn_jacobi(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1901 = call ptr @bn_mod(ptr %p0, ptr %p1)
%t1902 = call i64 @__m____________lib_bignum_resid__bn_jac(ptr %t1901, ptr %p1, i64 1)
ret i64 %t1902
}
define i64 @__m____________lib_bignum_resid__bn_jac(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %t1925, %tco.s0 ], [ %t1944, %tco.s1 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p0, %tco.s1 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t1924, %tco.s0 ], [ %t1943, %tco.s1 ]
%t1903 = call i64 @resid_list_len(ptr %p0)
%t1904 = icmp eq i64 %t1903, 0
br i1 %t1904, label %L286, label %L288
L286:
%t1906 = call ptr @resid_list_const_i64(ptr @.lc1905, i64 1, ptr @.lcd1905, ptr @.lty1905)
%t1907 = call i64 @bn_cmp(ptr %p1, ptr %t1906)
%t1908 = icmp eq i64 %t1907, 0
br i1 %t1908, label %L289, label %L290
L289:
br label %L291
L290:
br label %L291
L291:
%t1909 = phi i64 [ %p2, %L289 ], [ 0, %L290 ]
ret i64 %t1909
L288:
%t1910 = call i1 @bn_is_odd(ptr %p0)
%t1911 = xor i1 %t1910, true
br i1 %t1911, label %L292, label %L294
L292:
%t1912 = call ptr @resid_list_get(ptr %p1, i64 0)
%t1913 = call i64 @resid_unbox_i64(ptr %t1912)
%t1915 = and i64 %t1913, 7
%t1916 = icmp eq i64 %t1915, 3
br label %LSL1917
LSL1917:
br i1 %t1916, label %LSJ1917, label %LSR1917
LSR1917:
%t1918 = icmp eq i64 %t1915, 5
br label %LSJ1917
LSJ1917:
%t1919 = phi i1 [ true, %LSL1917 ], [ %t1918, %LSR1917 ]
br i1 %t1919, label %L295, label %L296
L295:
%t1920 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p2)
%t1921 = extractvalue {i64, i1} %t1920, 0
%t1922 = extractvalue {i64, i1} %t1920, 1
%t1923 = zext i1 %t1922 to i8
call void @resid_overflow_check(i8 %t1923)
br label %L297
L296:
br label %L297
L297:
%t1924 = phi i64 [ %t1921, %L295 ], [ %p2, %L296 ]
%t1925 = call ptr @bn_shr(ptr %p0, i64 1)
br label %tco.s0
tco.s0:
br label %tco.head
L294:
%t1927 = call ptr @resid_list_get(ptr %p0, i64 0)
%t1928 = call i64 @resid_unbox_i64(ptr %t1927)
%t1930 = and i64 %t1928, 3
%t1931 = icmp eq i64 %t1930, 3
br label %LSL1932
LSL1932:
br i1 %t1931, label %LSR1932, label %LSJ1932
LSR1932:
%t1933 = call ptr @resid_list_get(ptr %p1, i64 0)
%t1934 = call i64 @resid_unbox_i64(ptr %t1933)
%t1936 = and i64 %t1934, 3
%t1937 = icmp eq i64 %t1936, 3
br label %LSJ1932
LSJ1932:
%t1938 = phi i1 [ false, %LSL1932 ], [ %t1937, %LSR1932 ]
br i1 %t1938, label %L298, label %L299
L298:
%t1939 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p2)
%t1940 = extractvalue {i64, i1} %t1939, 0
%t1941 = extractvalue {i64, i1} %t1939, 1
%t1942 = zext i1 %t1941 to i8
call void @resid_overflow_check(i8 %t1942)
br label %L300
L299:
br label %L300
L300:
%t1943 = phi i64 [ %t1940, %L298 ], [ %p2, %L299 ]
%t1944 = call ptr @bn_mod(ptr %p1, ptr %p0)
br label %tco.s1
tco.s1:
br label %tco.head
}
define i4224 @__m____________lib_bignum_resid__bw_mask() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1946 = zext i64 2048 to i4224
%t1947 = icmp uge i4224 %t1946, 4224
%t1948 = add i4224 %t1946, 0
%t1949 = shl i4224 1, %t1948
%t1950 = select i1 %t1947, i4224 0, i4224 %t1949
%t1951 = call {i4224, i1} @llvm.usub.with.overflow.i4224(i4224 %t1950, i4224 1)
%t1952 = extractvalue {i4224, i1} %t1951, 0
%t1953 = extractvalue {i4224, i1} %t1951, 1
%t1954 = zext i1 %t1953 to i8
call void @resid_overflow_check(i8 %t1954)
ret i4224 %t1952
}
define i4224 @__m____________lib_bignum_resid__bw_of(ptr %p0.in, i64 %p1.in, i4224 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t1956, %tco.s0 ]
%p2 = phi i4224 [ %p2.in, %entry ], [ %t1962, %tco.s0 ]
%t1955 = icmp slt i64 %p1, 0
br i1 %t1955, label %L301, label %L303
L301:
ret i4224 %p2
L303:
%t1956 = sub nsw i64 %p1, 1
%t1957 = shl i4224 %p2, 64
%t1958 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t1959 = call i64 @resid_unbox_i64(ptr %t1958)
%t1961 = zext i64 %t1959 to i4224
%t1962 = or i4224 %t1957, %t1961
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t1982, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t1989, %tco.s0 ]
%t1964 = icmp sge i64 %p2, %p1
br i1 %t1964, label %L304, label %L306
L304:
%t1965 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty1965)
%t1966 = call ptr @bn_trim(ptr %t1965)
ret ptr %t1966
L306:
%t1967 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 64, i64 %p2)
%t1968 = extractvalue {i64, i1} %t1967, 0
%t1969 = extractvalue {i64, i1} %t1967, 1
%t1970 = zext i1 %t1969 to i8
call void @resid_overflow_check(i8 %t1970)
%t1971 = sext i64 %t1968 to i4224
%t1972 = add i4224 %t1971, 0
%t1973 = add i4224 %t1972, 0
%t1974 = icmp ne i4224 %t1973, %t1971
%t1975 = icmp slt i64 %t1968, 0
%t1976 = or i1 %t1974, %t1975
%t1977 = zext i1 %t1976 to i8
call void @resid_conv_check(i8 %t1977)
%t1978 = icmp uge i4224 %t1972, 4224
%t1979 = add i4224 %t1972, 0
%t1980 = lshr i4224 %p0, %t1979
%t1981 = select i1 %t1978, i4224 0, i4224 %t1980
%t1982 = add nsw i64 %p2, 1
%t1983 = sext i128 18446744073709551615 to i4224
%t1984 = and i4224 %t1981, %t1983
%t1985 = trunc i4224 %t1984 to i64
%t1986 = call ptr @resid_box_i64(i64 %t1985)
%t1989 = call ptr @resid_listbuf_push(ptr %p3, ptr %t1986)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i4224 @__m____________lib_bignum_resid__bw_ninv(i4224 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1991 = call i4224 @__m____________lib_bignum_resid__bw_mask()
%t1992 = and i4224 %p0, %t1991
%t1993 = and i4224 %p0, %t1991
%t1994 = call i4224 @__m____________lib_bignum_resid__bw_newton(i4224 %t1992, i4224 %t1993, i64 0, i4224 %t1991)
%t1995 = zext i64 2048 to i4224
%t1996 = icmp uge i4224 %t1995, 4224
%t1997 = add i4224 %t1995, 0
%t1998 = shl i4224 1, %t1997
%t1999 = select i1 %t1996, i4224 0, i4224 %t1998
%t2000 = call {i4224, i1} @llvm.usub.with.overflow.i4224(i4224 %t1999, i4224 %t1994)
%t2001 = extractvalue {i4224, i1} %t2000, 0
%t2002 = extractvalue {i4224, i1} %t2000, 1
%t2003 = zext i1 %t2002 to i8
call void @resid_overflow_check(i8 %t2003)
%t2004 = and i4224 %t2001, %t1991
ret i4224 %t2004
}
define i4224 @__m____________lib_bignum_resid__bw_newton(i4224 %p0.in, i4224 %p1.in, i64 %p2.in, i4224 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i4224 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i4224 [ %p1.in, %entry ], [ %t2023, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2024, %tco.s0 ]
%p3 = phi i4224 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t2005 = icmp sge i64 %p2, 10
br i1 %t2005, label %L307, label %L309
L307:
ret i4224 %p1
L309:
%t2006 = mul i4224 %p0, %p1
%t2007 = and i4224 %t2006, %p3
%t2008 = zext i64 2048 to i4224
%t2009 = icmp uge i4224 %t2008, 4224
%t2010 = add i4224 %t2008, 0
%t2011 = shl i4224 1, %t2010
%t2012 = select i1 %t2009, i4224 0, i4224 %t2011
%t2013 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2012, i4224 2)
%t2014 = extractvalue {i4224, i1} %t2013, 0
%t2015 = extractvalue {i4224, i1} %t2013, 1
%t2016 = zext i1 %t2015 to i8
call void @resid_overflow_check(i8 %t2016)
%t2017 = call {i4224, i1} @llvm.usub.with.overflow.i4224(i4224 %t2014, i4224 %t2007)
%t2018 = extractvalue {i4224, i1} %t2017, 0
%t2019 = extractvalue {i4224, i1} %t2017, 1
%t2020 = zext i1 %t2019 to i8
call void @resid_overflow_check(i8 %t2020)
%t2021 = and i4224 %t2018, %p3
%t2022 = mul i4224 %p1, %t2021
%t2023 = and i4224 %t2022, %p3
%t2024 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define i4224 @__m____________lib_bignum_resid__bw_double(i4224 %p0.in, i4224 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i4224 [ %p0.in, %entry ], [ %t2033, %tco.s0 ]
%p1 = phi i4224 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2034, %tco.s0 ]
%t2026 = icmp sle i64 %p2, 0
br i1 %t2026, label %L310, label %L312
L310:
ret i4224 %p0
L312:
%t2027 = shl i4224 %p0, 1
%t2028 = icmp uge i4224 %t2027, %p1
br i1 %t2028, label %L313, label %L314
L313:
%t2029 = call {i4224, i1} @llvm.usub.with.overflow.i4224(i4224 %t2027, i4224 %p1)
%t2030 = extractvalue {i4224, i1} %t2029, 0
%t2031 = extractvalue {i4224, i1} %t2029, 1
%t2032 = zext i1 %t2031 to i8
call void @resid_overflow_check(i8 %t2032)
br label %L315
L314:
br label %L315
L315:
%t2033 = phi i4224 [ %t2030, %L313 ], [ %t2027, %L314 ]
%t2034 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define i4224 @__m____________lib_bignum_resid__bw_mm1(i4224 %p0, i4224 %p1, i4224 %p2, i4224 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2036 = call i4224 @__m____________lib_bignum_resid__bw_mask()
%t2037 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %p0, i4224 %p1)
%t2038 = extractvalue {i4224, i1} %t2037, 0
%t2039 = extractvalue {i4224, i1} %t2037, 1
%t2040 = zext i1 %t2039 to i8
call void @resid_overflow_check(i8 %t2040)
%t2041 = and i4224 %t2038, %t2036
%t2042 = mul i4224 %t2041, %p3
%t2043 = and i4224 %t2042, %t2036
%t2044 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2043, i4224 %p2)
%t2045 = extractvalue {i4224, i1} %t2044, 0
%t2046 = extractvalue {i4224, i1} %t2044, 1
%t2047 = zext i1 %t2046 to i8
call void @resid_overflow_check(i8 %t2047)
%t2048 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2038, i4224 %t2045)
%t2049 = extractvalue {i4224, i1} %t2048, 0
%t2050 = extractvalue {i4224, i1} %t2048, 1
%t2051 = zext i1 %t2050 to i8
call void @resid_overflow_check(i8 %t2051)
%t2052 = zext i64 2048 to i4224
%t2053 = icmp uge i4224 %t2052, 4224
%t2054 = add i4224 %t2052, 0
%t2055 = lshr i4224 %t2049, %t2054
%t2056 = select i1 %t2053, i4224 0, i4224 %t2055
%t2057 = icmp uge i4224 %t2056, %p2
br i1 %t2057, label %L316, label %L317
L316:
%t2058 = call {i4224, i1} @llvm.usub.with.overflow.i4224(i4224 %t2056, i4224 %p2)
%t2059 = extractvalue {i4224, i1} %t2058, 0
%t2060 = extractvalue {i4224, i1} %t2058, 1
%t2061 = zext i1 %t2060 to i8
call void @resid_overflow_check(i8 %t2061)
br label %L318
L317:
br label %L318
L318:
%t2062 = phi i4224 [ %t2059, %L316 ], [ %t2056, %L317 ]
ret i4224 %t2062
}
define i4224 @__m____________lib_bignum_resid__bw_mm2(i4224 %p0, i4224 %p1, i4224 %p2, i4224 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2063 = call i4224 @__m____________lib_bignum_resid__bw_mask()
%t2064 = and i4224 %p0, %t2063
%t2065 = zext i64 2048 to i4224
%t2066 = icmp uge i4224 %t2065, 4224
%t2067 = add i4224 %t2065, 0
%t2068 = lshr i4224 %p0, %t2067
%t2069 = select i1 %t2066, i4224 0, i4224 %t2068
%t2070 = and i4224 %p1, %t2063
%t2071 = zext i64 2048 to i4224
%t2072 = icmp uge i4224 %t2071, 4224
%t2073 = add i4224 %t2071, 0
%t2074 = lshr i4224 %p1, %t2073
%t2075 = select i1 %t2072, i4224 0, i4224 %t2074
%t2076 = and i4224 %p2, %t2063
%t2077 = zext i64 2048 to i4224
%t2078 = icmp uge i4224 %t2077, 4224
%t2079 = add i4224 %t2077, 0
%t2080 = lshr i4224 %p2, %t2079
%t2081 = select i1 %t2078, i4224 0, i4224 %t2080
%t2082 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2064, i4224 %t2070)
%t2083 = extractvalue {i4224, i1} %t2082, 0
%t2084 = extractvalue {i4224, i1} %t2082, 1
%t2085 = zext i1 %t2084 to i8
call void @resid_overflow_check(i8 %t2085)
%t2086 = and i4224 %t2083, %t2063
%t2087 = zext i64 2048 to i4224
%t2088 = icmp uge i4224 %t2087, 4224
%t2089 = add i4224 %t2087, 0
%t2090 = lshr i4224 %t2083, %t2089
%t2091 = select i1 %t2088, i4224 0, i4224 %t2090
%t2092 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2069, i4224 %t2070)
%t2093 = extractvalue {i4224, i1} %t2092, 0
%t2094 = extractvalue {i4224, i1} %t2092, 1
%t2095 = zext i1 %t2094 to i8
call void @resid_overflow_check(i8 %t2095)
%t2096 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2093, i4224 %t2091)
%t2097 = extractvalue {i4224, i1} %t2096, 0
%t2098 = extractvalue {i4224, i1} %t2096, 1
%t2099 = zext i1 %t2098 to i8
call void @resid_overflow_check(i8 %t2099)
%t2100 = and i4224 %t2097, %t2063
%t2101 = zext i64 2048 to i4224
%t2102 = icmp uge i4224 %t2101, 4224
%t2103 = add i4224 %t2101, 0
%t2104 = lshr i4224 %t2097, %t2103
%t2105 = select i1 %t2102, i4224 0, i4224 %t2104
%t2106 = mul i4224 %t2086, %p3
%t2107 = and i4224 %t2106, %t2063
%t2108 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2107, i4224 %t2076)
%t2109 = extractvalue {i4224, i1} %t2108, 0
%t2110 = extractvalue {i4224, i1} %t2108, 1
%t2111 = zext i1 %t2110 to i8
call void @resid_overflow_check(i8 %t2111)
%t2112 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2086, i4224 %t2109)
%t2113 = extractvalue {i4224, i1} %t2112, 0
%t2114 = extractvalue {i4224, i1} %t2112, 1
%t2115 = zext i1 %t2114 to i8
call void @resid_overflow_check(i8 %t2115)
%t2116 = zext i64 2048 to i4224
%t2117 = icmp uge i4224 %t2116, 4224
%t2118 = add i4224 %t2116, 0
%t2119 = lshr i4224 %t2113, %t2118
%t2120 = select i1 %t2117, i4224 0, i4224 %t2119
%t2121 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2107, i4224 %t2081)
%t2122 = extractvalue {i4224, i1} %t2121, 0
%t2123 = extractvalue {i4224, i1} %t2121, 1
%t2124 = zext i1 %t2123 to i8
call void @resid_overflow_check(i8 %t2124)
%t2125 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2100, i4224 %t2122)
%t2126 = extractvalue {i4224, i1} %t2125, 0
%t2127 = extractvalue {i4224, i1} %t2125, 1
%t2128 = zext i1 %t2127 to i8
call void @resid_overflow_check(i8 %t2128)
%t2129 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2126, i4224 %t2120)
%t2130 = extractvalue {i4224, i1} %t2129, 0
%t2131 = extractvalue {i4224, i1} %t2129, 1
%t2132 = zext i1 %t2131 to i8
call void @resid_overflow_check(i8 %t2132)
%t2133 = and i4224 %t2130, %t2063
%t2134 = zext i64 2048 to i4224
%t2135 = icmp uge i4224 %t2134, 4224
%t2136 = add i4224 %t2134, 0
%t2137 = lshr i4224 %t2130, %t2136
%t2138 = select i1 %t2135, i4224 0, i4224 %t2137
%t2139 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2105, i4224 %t2138)
%t2140 = extractvalue {i4224, i1} %t2139, 0
%t2141 = extractvalue {i4224, i1} %t2139, 1
%t2142 = zext i1 %t2141 to i8
call void @resid_overflow_check(i8 %t2142)
%t2143 = and i4224 %t2140, %t2063
%t2144 = zext i64 2048 to i4224
%t2145 = icmp uge i4224 %t2144, 4224
%t2146 = add i4224 %t2144, 0
%t2147 = lshr i4224 %t2140, %t2146
%t2148 = select i1 %t2145, i4224 0, i4224 %t2147
%t2149 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2064, i4224 %t2075)
%t2150 = extractvalue {i4224, i1} %t2149, 0
%t2151 = extractvalue {i4224, i1} %t2149, 1
%t2152 = zext i1 %t2151 to i8
call void @resid_overflow_check(i8 %t2152)
%t2153 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2133, i4224 %t2150)
%t2154 = extractvalue {i4224, i1} %t2153, 0
%t2155 = extractvalue {i4224, i1} %t2153, 1
%t2156 = zext i1 %t2155 to i8
call void @resid_overflow_check(i8 %t2156)
%t2157 = and i4224 %t2154, %t2063
%t2158 = zext i64 2048 to i4224
%t2159 = icmp uge i4224 %t2158, 4224
%t2160 = add i4224 %t2158, 0
%t2161 = lshr i4224 %t2154, %t2160
%t2162 = select i1 %t2159, i4224 0, i4224 %t2161
%t2163 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2069, i4224 %t2075)
%t2164 = extractvalue {i4224, i1} %t2163, 0
%t2165 = extractvalue {i4224, i1} %t2163, 1
%t2166 = zext i1 %t2165 to i8
call void @resid_overflow_check(i8 %t2166)
%t2167 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2143, i4224 %t2164)
%t2168 = extractvalue {i4224, i1} %t2167, 0
%t2169 = extractvalue {i4224, i1} %t2167, 1
%t2170 = zext i1 %t2169 to i8
call void @resid_overflow_check(i8 %t2170)
%t2171 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2168, i4224 %t2162)
%t2172 = extractvalue {i4224, i1} %t2171, 0
%t2173 = extractvalue {i4224, i1} %t2171, 1
%t2174 = zext i1 %t2173 to i8
call void @resid_overflow_check(i8 %t2174)
%t2175 = and i4224 %t2172, %t2063
%t2176 = zext i64 2048 to i4224
%t2177 = icmp uge i4224 %t2176, 4224
%t2178 = add i4224 %t2176, 0
%t2179 = lshr i4224 %t2172, %t2178
%t2180 = select i1 %t2177, i4224 0, i4224 %t2179
%t2181 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2148, i4224 %t2180)
%t2182 = extractvalue {i4224, i1} %t2181, 0
%t2183 = extractvalue {i4224, i1} %t2181, 1
%t2184 = zext i1 %t2183 to i8
call void @resid_overflow_check(i8 %t2184)
%t2185 = and i4224 %t2182, %t2063
%t2186 = zext i64 2048 to i4224
%t2187 = icmp uge i4224 %t2186, 4224
%t2188 = add i4224 %t2186, 0
%t2189 = lshr i4224 %t2182, %t2188
%t2190 = select i1 %t2187, i4224 0, i4224 %t2189
%t2191 = mul i4224 %t2157, %p3
%t2192 = and i4224 %t2191, %t2063
%t2193 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2192, i4224 %t2076)
%t2194 = extractvalue {i4224, i1} %t2193, 0
%t2195 = extractvalue {i4224, i1} %t2193, 1
%t2196 = zext i1 %t2195 to i8
call void @resid_overflow_check(i8 %t2196)
%t2197 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2157, i4224 %t2194)
%t2198 = extractvalue {i4224, i1} %t2197, 0
%t2199 = extractvalue {i4224, i1} %t2197, 1
%t2200 = zext i1 %t2199 to i8
call void @resid_overflow_check(i8 %t2200)
%t2201 = zext i64 2048 to i4224
%t2202 = icmp uge i4224 %t2201, 4224
%t2203 = add i4224 %t2201, 0
%t2204 = lshr i4224 %t2198, %t2203
%t2205 = select i1 %t2202, i4224 0, i4224 %t2204
%t2206 = call {i4224, i1} @llvm.umul.with.overflow.i4224(i4224 %t2192, i4224 %t2081)
%t2207 = extractvalue {i4224, i1} %t2206, 0
%t2208 = extractvalue {i4224, i1} %t2206, 1
%t2209 = zext i1 %t2208 to i8
call void @resid_overflow_check(i8 %t2209)
%t2210 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2175, i4224 %t2207)
%t2211 = extractvalue {i4224, i1} %t2210, 0
%t2212 = extractvalue {i4224, i1} %t2210, 1
%t2213 = zext i1 %t2212 to i8
call void @resid_overflow_check(i8 %t2213)
%t2214 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2211, i4224 %t2205)
%t2215 = extractvalue {i4224, i1} %t2214, 0
%t2216 = extractvalue {i4224, i1} %t2214, 1
%t2217 = zext i1 %t2216 to i8
call void @resid_overflow_check(i8 %t2217)
%t2218 = and i4224 %t2215, %t2063
%t2219 = zext i64 2048 to i4224
%t2220 = icmp uge i4224 %t2219, 4224
%t2221 = add i4224 %t2219, 0
%t2222 = lshr i4224 %t2215, %t2221
%t2223 = select i1 %t2220, i4224 0, i4224 %t2222
%t2224 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2185, i4224 %t2223)
%t2225 = extractvalue {i4224, i1} %t2224, 0
%t2226 = extractvalue {i4224, i1} %t2224, 1
%t2227 = zext i1 %t2226 to i8
call void @resid_overflow_check(i8 %t2227)
%t2228 = and i4224 %t2225, %t2063
%t2229 = zext i64 2048 to i4224
%t2230 = icmp uge i4224 %t2229, 4224
%t2231 = add i4224 %t2229, 0
%t2232 = lshr i4224 %t2225, %t2231
%t2233 = select i1 %t2230, i4224 0, i4224 %t2232
%t2234 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2190, i4224 %t2233)
%t2235 = extractvalue {i4224, i1} %t2234, 0
%t2236 = extractvalue {i4224, i1} %t2234, 1
%t2237 = zext i1 %t2236 to i8
call void @resid_overflow_check(i8 %t2237)
%t2238 = zext i64 2048 to i4224
%t2239 = icmp uge i4224 %t2238, 4224
%t2240 = add i4224 %t2238, 0
%t2241 = shl i4224 %t2228, %t2240
%t2242 = select i1 %t2239, i4224 0, i4224 %t2241
%t2243 = or i4224 %t2218, %t2242
%t2244 = zext i64 4096 to i4224
%t2245 = icmp uge i4224 %t2244, 4224
%t2246 = add i4224 %t2244, 0
%t2247 = shl i4224 1, %t2246
%t2248 = select i1 %t2245, i4224 0, i4224 %t2247
%t2249 = icmp ne i4224 %t2235, 0
br i1 %t2249, label %L319, label %L320
L319:
%t2250 = call {i4224, i1} @llvm.uadd.with.overflow.i4224(i4224 %t2243, i4224 %t2248)
%t2251 = extractvalue {i4224, i1} %t2250, 0
%t2252 = extractvalue {i4224, i1} %t2250, 1
%t2253 = zext i1 %t2252 to i8
call void @resid_overflow_check(i8 %t2253)
%t2254 = call {i4224, i1} @llvm.usub.with.overflow.i4224(i4224 %t2251, i4224 %p2)
%t2255 = extractvalue {i4224, i1} %t2254, 0
%t2256 = extractvalue {i4224, i1} %t2254, 1
%t2257 = zext i1 %t2256 to i8
call void @resid_overflow_check(i8 %t2257)
br label %L321
L320:
%t2258 = icmp uge i4224 %t2243, %p2
br i1 %t2258, label %L322, label %L323
L322:
%t2259 = call {i4224, i1} @llvm.usub.with.overflow.i4224(i4224 %t2243, i4224 %p2)
%t2260 = extractvalue {i4224, i1} %t2259, 0
%t2261 = extractvalue {i4224, i1} %t2259, 1
%t2262 = zext i1 %t2261 to i8
call void @resid_overflow_check(i8 %t2262)
br label %L324
L323:
br label %L324
L324:
%t2263 = phi i4224 [ %t2260, %L322 ], [ %t2243, %L323 ]
br label %L321
L321:
%t2264 = phi i4224 [ %t2255, %L319 ], [ %t2263, %L324 ]
ret i4224 %t2264
}
define i4224 @__m____________lib_bignum_resid__bw_mul(i1 %p0, i4224 %p1, i4224 %p2, i4224 %p3, i4224 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br i1 %p0, label %L325, label %L326
L325:
%t2265 = call i4224 @__m____________lib_bignum_resid__bw_mm2(i4224 %p1, i4224 %p2, i4224 %p3, i4224 %p4)
br label %L327
L326:
%t2266 = call i4224 @__m____________lib_bignum_resid__bw_mm1(i4224 %p1, i4224 %p2, i4224 %p3, i4224 %p4)
br label %L327
L327:
%t2267 = phi i4224 [ %t2265, %L325 ], [ %t2266, %L326 ]
ret i4224 %t2267
}
define i4224 @__m____________lib_bignum_resid__bw_exp(i1 %p0.in, i4224 %p1.in, ptr %p2.in, i64 %p3.in, i4224 %p4.in, i4224 %p5.in, i4224 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i1 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i4224 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t2274, %tco.s0 ]
%p4 = phi i4224 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i4224 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%p6 = phi i4224 [ %p6.in, %entry ], [ %t2273, %tco.s0 ]
%t2268 = icmp slt i64 %p3, 0
br i1 %t2268, label %L328, label %L330
L328:
ret i4224 %p6
L330:
%t2269 = call i4224 @__m____________lib_bignum_resid__bw_mul(i1 %p0, i4224 %p6, i4224 %p6, i4224 %p4, i4224 %p5)
%t2270 = call i64 @bn_bit(ptr %p2, i64 %p3)
%t2271 = icmp eq i64 %t2270, 1
br i1 %t2271, label %L331, label %L332
L331:
%t2272 = call i4224 @__m____________lib_bignum_resid__bw_mul(i1 %p0, i4224 %t2269, i4224 %p1, i4224 %p4, i4224 %p5)
br label %L333
L332:
br label %L333
L333:
%t2273 = phi i4224 [ %t2272, %L331 ], [ %t2269, %L332 ]
%t2274 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_bignum_resid__bn_native_exp(ptr %p0, ptr %p1, ptr %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2276 = icmp sgt i64 %p3, 2048
br i1 %t2276, label %L334, label %L335
L334:
br label %L336
L335:
br label %L336
L336:
%t2277 = phi i64 [ 4096, %L334 ], [ 2048, %L335 ]
%t2278 = call i64 @resid_list_len(ptr %p2)
%t2279 = sub nsw i64 %t2278, 1
%t2280 = sext i64 0 to i4224
%t2281 = call i4224 @__m____________lib_bignum_resid__bw_of(ptr %p2, i64 %t2279, i4224 %t2280)
%t2282 = call i4224 @__m____________lib_bignum_resid__bw_ninv(i4224 %t2281)
%t2283 = sext i64 1 to i4224
%t2284 = call i4224 @__m____________lib_bignum_resid__bw_double(i4224 %t2283, i4224 %t2281, i64 %t2277)
%t2285 = call i4224 @__m____________lib_bignum_resid__bw_double(i4224 %t2284, i4224 %t2281, i64 %t2277)
%t2286 = call i64 @resid_list_len(ptr %p0)
%t2287 = sub nsw i64 %t2286, 1
%t2288 = sext i64 0 to i4224
%t2289 = call i4224 @__m____________lib_bignum_resid__bw_of(ptr %p0, i64 %t2287, i4224 %t2288)
%t2290 = call i4224 @__m____________lib_bignum_resid__bw_mul(i1 %t2276, i4224 %t2289, i4224 %t2285, i4224 %t2281, i4224 %t2282)
%t2291 = call i64 @bn_bit_len(ptr %p1)
%t2292 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t2291, i64 1)
%t2293 = extractvalue {i64, i1} %t2292, 0
%t2294 = extractvalue {i64, i1} %t2292, 1
%t2295 = zext i1 %t2294 to i8
call void @resid_overflow_check(i8 %t2295)
%t2296 = call i4224 @__m____________lib_bignum_resid__bw_exp(i1 %t2276, i4224 %t2290, ptr %p1, i64 %t2293, i4224 %t2281, i4224 %t2282, i4224 %t2284)
%t2297 = sext i64 1 to i4224
%t2298 = call i4224 @__m____________lib_bignum_resid__bw_mul(i1 %t2276, i4224 %t2296, i4224 %t2297, i4224 %t2281, i4224 %t2282)
%t2299 = call i64 @resid_list_len(ptr %p2)
%t2300 = call ptr @resid_listbuf_new()
%t2301 = call ptr @__m____________lib_bignum_resid__bw_to(i4224 %t2298, i64 %t2299, i64 0, ptr %t2300)
ret ptr %t2301
}
define i64 @__m____________lib_word_resid__wi_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2302 = xor i64 %p0, %p1
ret i64 %t2302
}
define i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2303 = and i64 %p0, %p1
ret i64 %t2303
}
define i64 @__m____________lib_word_resid__wi_or(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2304 = or i64 %p0, %p1
ret i64 %t2304
}
define i64 @__m____________lib_word_resid__wi_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2305 = call i64 @wrapping_add(i64 %p0, i64 %p1)
%t2306 = and i64 %t2305, 4294967295
ret i64 %t2306
}
define i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2307 = call i64 @wrapping_add(i64 %p0, i64 %p1)
%t2308 = and i64 %t2307, 4294967295
ret i64 %t2308
}
define i64 @__m____________lib_word_resid__wi_xork(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2309 = xor i64 %p0, %p1
ret i64 %t2309
}
define i64 @__m____________lib_word_resid__wi_andk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2310 = and i64 %p0, %p1
ret i64 %t2310
}
define i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2311 = icmp uge i64 %p1, 64
%t2312 = add i64 %p1, 0
%t2313 = select i1 %t2311, i64 63, i64 %t2312
%t2314 = ashr i64 %p0, %t2313
%t2315 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t2316 = extractvalue {i64, i1} %t2315, 0
%t2317 = extractvalue {i64, i1} %t2315, 1
%t2318 = zext i1 %t2317 to i8
call void @resid_overflow_check(i8 %t2318)
%t2319 = icmp uge i64 %t2316, 64
%t2320 = add i64 %t2316, 0
%t2321 = shl i64 %p0, %t2320
%t2322 = select i1 %t2319, i64 0, i64 %t2321
%t2323 = or i64 %t2314, %t2322
%t2324 = and i64 %t2323, 4294967295
ret i64 %t2324
}
define i64 @__m____________lib_word_resid__wi_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2325 = icmp uge i64 %p1, 64
%t2326 = add i64 %p1, 0
%t2327 = select i1 %t2325, i64 63, i64 %t2326
%t2328 = ashr i64 %p0, %t2327
ret i64 %t2328
}
define i64 @__m____________lib_word_resid__wi_shl(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2329 = icmp uge i64 %p1, 64
%t2330 = add i64 %p1, 0
%t2331 = shl i64 %p0, %t2330
%t2332 = select i1 %t2329, i64 0, i64 %t2331
%t2333 = and i64 %t2332, 4294967295
ret i64 %t2333
}
define i64 @__m____________lib_word_resid__wi_not(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2334 = xor i64 %p0, 4294967295
%t2335 = and i64 %t2334, 4294967295
ret i64 %t2335
}
define i64 @__m____________lib_word_resid__wi_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i64 @__m____________lib_word_resid__wi_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2336 = and i64 %p0, 255
ret i64 %t2336
}
define i64 @__m____________lib_word_resid__wi_byte(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2337 = icmp uge i64 %p1, 64
%t2338 = add i64 %p1, 0
%t2339 = select i1 %t2337, i64 63, i64 %t2338
%t2340 = ashr i64 %p0, %t2339
%t2341 = and i64 %t2340, 255
ret i64 %t2341
}
define i64 @__m____________lib_word_resid__bi_xork(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2342 = xor i64 %p0, %p1
ret i64 %t2342
}
define i64 @__m____________lib_word_resid__bi_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2343 = xor i64 %p0, %p1
ret i64 %t2343
}
define i64 @__m____________lib_word_resid__bi_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i32 @__m____________lib_word_resid__ws_xor(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2344 = xor i32 %p0, %p1
ret i32 %t2344
}
define i32 @__m____________lib_word_resid__ws_and(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2345 = and i32 %p0, %p1
ret i32 %t2345
}
define i32 @__m____________lib_word_resid__ws_or(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2346 = or i32 %p0, %p1
ret i32 %t2346
}
define i32 @__m____________lib_word_resid__ws_add(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2347 = add i32 %p0, %p1
ret i32 %t2347
}
define i32 @__m____________lib_word_resid__ws_addk(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2348 = trunc i64 %p1 to i32
%t2349 = add i32 %p0, %t2348
ret i32 %t2349
}
define i32 @__m____________lib_word_resid__ws_xork(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2350 = trunc i64 %p1 to i32
%t2351 = xor i32 %p0, %t2350
ret i32 %t2351
}
define i32 @__m____________lib_word_resid__ws_andk(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2352 = trunc i64 %p1 to i32
%t2353 = and i32 %p0, %t2352
ret i32 %t2353
}
define i32 @__m____________lib_word_resid__ws_rotr(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2354 = trunc i64 %p1 to i32
%t2355 = icmp uge i32 %t2354, 32
%t2356 = add i32 %t2354, 0
%t2357 = lshr i32 %p0, %t2356
%t2358 = select i1 %t2355, i32 0, i32 %t2357
%t2359 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t2360 = extractvalue {i64, i1} %t2359, 0
%t2361 = extractvalue {i64, i1} %t2359, 1
%t2362 = zext i1 %t2361 to i8
call void @resid_overflow_check(i8 %t2362)
%t2363 = trunc i64 %t2360 to i32
%t2364 = icmp uge i32 %t2363, 32
%t2365 = add i32 %t2363, 0
%t2366 = shl i32 %p0, %t2365
%t2367 = select i1 %t2364, i32 0, i32 %t2366
%t2368 = or i32 %t2358, %t2367
ret i32 %t2368
}
define i32 @__m____________lib_word_resid__ws_shr(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2369 = trunc i64 %p1 to i32
%t2370 = icmp uge i32 %t2369, 32
%t2371 = add i32 %t2369, 0
%t2372 = lshr i32 %p0, %t2371
%t2373 = select i1 %t2370, i32 0, i32 %t2372
ret i32 %t2373
}
define i32 @__m____________lib_word_resid__ws_shl(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2374 = trunc i64 %p1 to i32
%t2375 = icmp uge i32 %t2374, 32
%t2376 = add i32 %t2374, 0
%t2377 = shl i32 %p0, %t2376
%t2378 = select i1 %t2375, i32 0, i32 %t2377
ret i32 %t2378
}
define i32 @__m____________lib_word_resid__ws_not(i32 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2379 = xor i32 %p0, 4294967295
ret i32 %t2379
}
define i32 @__m____________lib_word_resid__ws_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2380 = trunc i64 %p0 to i32
ret i32 %t2380
}
define i32 @__m____________lib_word_resid__ws_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2381 = zext i8 %p0 to i32
ret i32 %t2381
}
define i8 @__m____________lib_word_resid__ws_byte(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2382 = trunc i64 %p1 to i32
%t2383 = icmp uge i32 %t2382, 32
%t2384 = add i32 %t2382, 0
%t2385 = lshr i32 %p0, %t2384
%t2386 = select i1 %t2383, i32 0, i32 %t2385
%t2387 = trunc i32 %t2386 to i8
ret i8 %t2387
}
define i8 @__m____________lib_word_resid__bs_xork(i8 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2388 = trunc i64 %p1 to i8
%t2389 = xor i8 %p0, %t2388
ret i8 %t2389
}
define i8 @__m____________lib_word_resid__bs_xor(i8 %p0, i8 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2390 = xor i8 %p0, %p1
ret i8 %t2390
}
define i8 @__m____________lib_word_resid__bs_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2391 = trunc i64 %p0 to i8
ret i8 %t2391
}
define ptr @secret_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2392 = call ptr @resid_listbuf_new()
%t2393 = call ptr @__m____________lib_word_resid__secret_bytes_at(ptr %p0, i64 0, ptr %t2392)
ret ptr %t2393
}
define ptr @__m____________lib_word_resid__secret_bytes_at(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2397, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t2405, %tco.s0 ]
%t2394 = call i64 @resid_list_len(ptr %p0)
%t2395 = icmp sge i64 %p1, %t2394
br i1 %t2395, label %L337, label %L339
L337:
%t2396 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty2396)
ret ptr %t2396
L339:
%t2397 = add nsw i64 %p1, 1
%t2398 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t2399 = call i64 @resid_unbox_i64(ptr %t2398)
%t2401 = trunc i64 %t2399 to i8
%t2403 = zext i8 %t2401 to i64
%t2402 = call ptr @resid_box_i64(i64 %t2403)
%t2405 = call ptr @resid_listbuf_push(ptr %p2, ptr %t2402)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_word_resid__di_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2407 = xor i64 %p0, %p1
ret i64 %t2407
}
define i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2408 = and i64 %p0, %p1
ret i64 %t2408
}
define i64 @__m____________lib_word_resid__di_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2409 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2409
}
define i64 @__m____________lib_word_resid__di_addk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2410 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2410
}
define i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2411 = add i64 %p1, 0
%t2412 = add i64 %t2411, 0
%t2413 = add i64 %t2412, 0
%t2414 = icmp ne i64 %t2413, %t2411
%t2415 = icmp slt i64 %p1, 0
%t2416 = or i1 %t2414, %t2415
%t2417 = zext i1 %t2416 to i8
call void @resid_conv_check(i8 %t2417)
%t2418 = icmp uge i64 %t2412, 64
%t2419 = add i64 %t2412, 0
%t2420 = lshr i64 %p0, %t2419
%t2421 = select i1 %t2418, i64 0, i64 %t2420
%t2422 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 64, i64 %p1)
%t2423 = extractvalue {i64, i1} %t2422, 0
%t2424 = extractvalue {i64, i1} %t2422, 1
%t2425 = zext i1 %t2424 to i8
call void @resid_overflow_check(i8 %t2425)
%t2426 = add i64 %t2423, 0
%t2427 = add i64 %t2426, 0
%t2428 = add i64 %t2427, 0
%t2429 = icmp ne i64 %t2428, %t2426
%t2430 = icmp slt i64 %t2423, 0
%t2431 = or i1 %t2429, %t2430
%t2432 = zext i1 %t2431 to i8
call void @resid_conv_check(i8 %t2432)
%t2433 = icmp uge i64 %t2427, 64
%t2434 = add i64 %t2427, 0
%t2435 = shl i64 %p0, %t2434
%t2436 = select i1 %t2433, i64 0, i64 %t2435
%t2437 = or i64 %t2421, %t2436
ret i64 %t2437
}
define i64 @__m____________lib_word_resid__di_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
ret i64 %t2448
}
define i64 @__m____________lib_word_resid__di_not(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2449 = add i128 18446744073709551615, 0
%t2450 = trunc i128 %t2449 to i64
%t2451 = zext i64 %t2450 to i128
%t2452 = icmp ne i128 %t2451, %t2449
%t2453 = icmp slt i128 18446744073709551615, 0
%t2454 = or i1 %t2452, %t2453
%t2455 = zext i1 %t2454 to i8
call void @resid_conv_check(i8 %t2455)
%t2456 = xor i64 %p0, %t2450
ret i64 %t2456
}
define i64 @__m____________lib_word_resid__di_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i64 @__m____________lib_word_resid__di_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2457 = and i64 %p0, 255
ret i64 %t2457
}
define i64 @__m____________lib_word_resid__di_byte(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2458 = add i64 %p1, 0
%t2459 = add i64 %t2458, 0
%t2460 = add i64 %t2459, 0
%t2461 = icmp ne i64 %t2460, %t2458
%t2462 = icmp slt i64 %p1, 0
%t2463 = or i1 %t2461, %t2462
%t2464 = zext i1 %t2463 to i8
call void @resid_conv_check(i8 %t2464)
%t2465 = icmp uge i64 %t2459, 64
%t2466 = add i64 %t2459, 0
%t2467 = lshr i64 %p0, %t2466
%t2468 = select i1 %t2465, i64 0, i64 %t2467
%t2469 = and i64 %t2468, 255
ret i64 %t2469
}
define i64 @__m____________lib_word_resid__ds_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2470 = xor i64 %p0, %p1
ret i64 %t2470
}
define i64 @__m____________lib_word_resid__ds_and(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2471 = and i64 %p0, %p1
ret i64 %t2471
}
define i64 @__m____________lib_word_resid__ds_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2472 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2472
}
define i64 @__m____________lib_word_resid__ds_addk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2473 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2473
}
define i64 @__m____________lib_word_resid__ds_rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2474 = add i64 %p1, 0
%t2475 = add i64 %t2474, 0
%t2476 = add i64 %t2475, 0
%t2477 = icmp ne i64 %t2476, %t2474
%t2478 = icmp slt i64 %p1, 0
%t2479 = or i1 %t2477, %t2478
%t2480 = zext i1 %t2479 to i8
call void @resid_conv_check(i8 %t2480)
%t2481 = icmp uge i64 %t2475, 64
%t2482 = add i64 %t2475, 0
%t2483 = lshr i64 %p0, %t2482
%t2484 = select i1 %t2481, i64 0, i64 %t2483
%t2485 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 64, i64 %p1)
%t2486 = extractvalue {i64, i1} %t2485, 0
%t2487 = extractvalue {i64, i1} %t2485, 1
%t2488 = zext i1 %t2487 to i8
call void @resid_overflow_check(i8 %t2488)
%t2489 = add i64 %t2486, 0
%t2490 = add i64 %t2489, 0
%t2491 = add i64 %t2490, 0
%t2492 = icmp ne i64 %t2491, %t2489
%t2493 = icmp slt i64 %t2486, 0
%t2494 = or i1 %t2492, %t2493
%t2495 = zext i1 %t2494 to i8
call void @resid_conv_check(i8 %t2495)
%t2496 = icmp uge i64 %t2490, 64
%t2497 = add i64 %t2490, 0
%t2498 = shl i64 %p0, %t2497
%t2499 = select i1 %t2496, i64 0, i64 %t2498
%t2500 = or i64 %t2484, %t2499
ret i64 %t2500
}
define i64 @__m____________lib_word_resid__ds_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
ret i64 %t2511
}
define i64 @__m____________lib_word_resid__ds_not(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2512 = add i128 18446744073709551615, 0
%t2513 = trunc i128 %t2512 to i64
%t2514 = zext i64 %t2513 to i128
%t2515 = icmp ne i128 %t2514, %t2512
%t2516 = icmp slt i128 18446744073709551615, 0
%t2517 = or i1 %t2515, %t2516
%t2518 = zext i1 %t2517 to i8
call void @resid_conv_check(i8 %t2518)
%t2519 = xor i64 %p0, %t2513
ret i64 %t2519
}
define i64 @__m____________lib_word_resid__ds_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i64 @__m____________lib_word_resid__ds_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2520 = zext i8 %p0 to i64
ret i64 %t2520
}
define i8 @__m____________lib_word_resid__ds_byte(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2521 = add i64 %p1, 0
%t2522 = add i64 %t2521, 0
%t2523 = add i64 %t2522, 0
%t2524 = icmp ne i64 %t2523, %t2521
%t2525 = icmp slt i64 %p1, 0
%t2526 = or i1 %t2524, %t2525
%t2527 = zext i1 %t2526 to i8
call void @resid_conv_check(i8 %t2527)
%t2528 = icmp uge i64 %t2522, 64
%t2529 = add i64 %t2522, 0
%t2530 = lshr i64 %p0, %t2529
%t2531 = select i1 %t2528, i64 0, i64 %t2530
%t2532 = trunc i64 %t2531 to i8
ret i8 %t2532
}
define i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2533 = add i512 %p0, %p1
ret i512 %t2533
}
define i512 @__m____________lib_word_resid__pi_sub(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2534 = sub i512 %p0, %p1
ret i512 %t2534
}
define i512 @__m____________lib_word_resid__pi_mul(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2535 = mul i512 %p0, %p1
ret i512 %t2535
}
define i512 @__m____________lib_word_resid__pi_mul256(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2536 = trunc i512 %p0 to i256
%t2537 = zext i256 %t2536 to i512
%t2538 = trunc i512 %p1 to i256
%t2539 = zext i256 %t2538 to i512
%t2540 = mul i512 %t2537, %t2539
ret i512 %t2540
}
define i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2541 = and i512 %p0, %p1
ret i512 %t2541
}
define i512 @__m____________lib_word_resid__pi_or(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2542 = or i512 %p0, %p1
ret i512 %t2542
}
define i512 @__m____________lib_word_resid__pi_xor(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2543 = xor i512 %p0, %p1
ret i512 %t2543
}
define i512 @__m____________lib_word_resid__pi_shl(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2544 = sext i64 %p1 to i512
%t2545 = icmp uge i512 %t2544, 512
%t2546 = add i512 %t2544, 0
%t2547 = shl i512 %p0, %t2546
%t2548 = select i1 %t2545, i512 0, i512 %t2547
ret i512 %t2548
}
define i512 @__m____________lib_word_resid__pi_shr(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2549 = sext i64 %p1 to i512
%t2550 = icmp uge i512 %t2549, 512
%t2551 = add i512 %t2549, 0
%t2552 = select i1 %t2550, i512 511, i512 %t2551
%t2553 = ashr i512 %p0, %t2552
ret i512 %t2553
}
define i512 @__m____________lib_word_resid__pi_sign(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2554 = ashr i512 %p0, 511
%t2555 = trunc i512 %t2554 to i64
%t2556 = call i64 asm "", "=r,0"(i64 %t2555)
%t2557 = sext i64 %t2556 to i512
ret i512 %t2557
}
define i512 @__m____________lib_word_resid__pi_lift(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i512 %p0
}
define i512 @__m____________lib_word_resid__pi_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2558 = and i64 %p0, 255
%t2559 = sext i64 %t2558 to i512
ret i512 %t2559
}
define i64 @__m____________lib_word_resid__pi_byte(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2560 = sext i64 %p1 to i512
%t2561 = icmp uge i512 %t2560, 512
%t2562 = add i512 %t2560, 0
%t2563 = select i1 %t2561, i512 511, i512 %t2562
%t2564 = ashr i512 %p0, %t2563
%t2565 = and i512 %t2564, 255
%t2566 = trunc i512 %t2565 to i64
ret i64 %t2566
}
define i512 @__m____________lib_word_resid__ps_add(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2567 = add i512 %p0, %p1
ret i512 %t2567
}
define i512 @__m____________lib_word_resid__ps_sub(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2568 = sub i512 %p0, %p1
ret i512 %t2568
}
define i512 @__m____________lib_word_resid__ps_mul(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2569 = mul i512 %p0, %p1
ret i512 %t2569
}
define i512 @__m____________lib_word_resid__ps_mul256(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2570 = trunc i512 %p0 to i256
%t2571 = zext i256 %t2570 to i512
%t2572 = trunc i512 %p1 to i256
%t2573 = zext i256 %t2572 to i512
%t2574 = mul i512 %t2571, %t2573
ret i512 %t2574
}
define i512 @__m____________lib_word_resid__ps_and(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2575 = and i512 %p0, %p1
ret i512 %t2575
}
define i512 @__m____________lib_word_resid__ps_or(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2576 = or i512 %p0, %p1
ret i512 %t2576
}
define i512 @__m____________lib_word_resid__ps_xor(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2577 = xor i512 %p0, %p1
ret i512 %t2577
}
define i512 @__m____________lib_word_resid__ps_shl(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2578 = sext i64 %p1 to i512
%t2579 = icmp uge i512 %t2578, 512
%t2580 = add i512 %t2578, 0
%t2581 = shl i512 %p0, %t2580
%t2582 = select i1 %t2579, i512 0, i512 %t2581
ret i512 %t2582
}
define i512 @__m____________lib_word_resid__ps_shr(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2583 = sext i64 %p1 to i512
%t2584 = icmp uge i512 %t2583, 512
%t2585 = add i512 %t2583, 0
%t2586 = select i1 %t2584, i512 511, i512 %t2585
%t2587 = ashr i512 %p0, %t2586
ret i512 %t2587
}
define i512 @__m____________lib_word_resid__ps_sign(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2588 = ashr i512 %p0, 511
%t2589 = trunc i512 %t2588 to i64
%t2590 = call i64 asm "", "=r,0"(i64 %t2589)
%t2591 = sext i64 %t2590 to i512
ret i512 %t2591
}
define i512 @__m____________lib_word_resid__ps_lift(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i512 %p0
}
define i512 @__m____________lib_word_resid__ps_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2592 = zext i8 %p0 to i512
ret i512 %t2592
}
define i8 @__m____________lib_word_resid__ps_byte(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2593 = sext i64 %p1 to i512
%t2594 = icmp uge i512 %t2593, 512
%t2595 = add i512 %t2593, 0
%t2596 = select i1 %t2594, i512 511, i512 %t2595
%t2597 = ashr i512 %p0, %t2596
%t2598 = trunc i512 %t2597 to i8
ret i8 %t2598
}
define ptr @__m____________lib_word_resid__wi_publish(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret ptr %p0
}
define ptr @__m____________lib_word_resid__ws_publish(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
call void @resid_cap_check(ptr @.declassify.cap)
%t2599 = call ptr @resid_listbuf_new()
%t2600 = call ptr @__m____________lib_word_resid__ws_widen(ptr %p0, i64 0, ptr %t2599)
ret ptr %t2600
}
define ptr @__m____________lib_word_resid__ws_widen(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2608 = alloca [17 x i8], align 16 ; fixed
%t2609 = alloca [48 x i8], align 16 ; fixed
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2604, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t2622, %tco.s0 ]
%t2601 = call i64 @resid_list_len(ptr %p0)
%t2602 = icmp sge i64 %p1, %t2601
br i1 %t2602, label %L340, label %L342
L340:
%t2603 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty2603)
ret ptr %t2603
L342:
%t2604 = add nsw i64 %p1, 1
%t2605 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t2607 = call i64 @resid_unbox_i64(ptr %t2605)
%t2606 = trunc i64 %t2607 to i8
store i8 %t2606, ptr %t2608
%t2610 = ptrtoint ptr %t2608 to i64
store i64 1296236546, ptr %t2609
%t2611 = getelementptr i64, ptr %t2609, i64 1
store i64 %t2610, ptr %t2611
%t2612 = getelementptr i64, ptr %t2609, i64 2
store i64 1, ptr %t2612
%t2613 = getelementptr i64, ptr %t2609, i64 3
store i64 0, ptr %t2613
%t2614 = getelementptr i64, ptr %t2609, i64 4
store i64 0, ptr %t2614
%t2615 = getelementptr i64, ptr %t2609, i64 5
store i64 0, ptr %t2615
%t2616 = call i64 asm sideeffect "rolq $$3, %rdi ; rolq $$13, %rdi ; rolq $$61, %rdi ; rolq $$51, %rdi ; xchgq %rbx, %rbx", "={dx},{ax},0,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(ptr %t2609, i64 0)
%t2617 = load i8, ptr %t2608
%t2618 = zext i8 %t2617 to i64
%t2619 = call ptr @resid_box_i64(i64 %t2618)
%t2622 = call ptr @resid_listbuf_push(ptr %p2, ptr %t2619)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i128 @__m____________lib_word_resid__xi_xor(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2624 = xor i128 %p0, %p1
ret i128 %t2624
}
define i128 @__m____________lib_word_resid__xi_and(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2625 = and i128 %p0, %p1
ret i128 %t2625
}
define i128 @__m____________lib_word_resid__xi_or(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2626 = or i128 %p0, %p1
ret i128 %t2626
}
define i128 @__m____________lib_word_resid__xi_shl(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2627 = sext i64 %p1 to i128
%t2628 = add i128 %t2627, 0
%t2629 = add i128 %t2628, 0
%t2630 = icmp ne i128 %t2629, %t2627
%t2631 = icmp slt i64 %p1, 0
%t2632 = or i1 %t2630, %t2631
%t2633 = zext i1 %t2632 to i8
call void @resid_conv_check(i8 %t2633)
%t2634 = icmp uge i128 %t2628, 128
%t2635 = add i128 %t2628, 0
%t2636 = shl i128 %p0, %t2635
%t2637 = select i1 %t2634, i128 0, i128 %t2636
ret i128 %t2637
}
define i128 @__m____________lib_word_resid__xi_shr(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2638 = sext i64 %p1 to i128
%t2639 = add i128 %t2638, 0
%t2640 = add i128 %t2639, 0
%t2641 = icmp ne i128 %t2640, %t2638
%t2642 = icmp slt i64 %p1, 0
%t2643 = or i1 %t2641, %t2642
%t2644 = zext i1 %t2643 to i8
call void @resid_conv_check(i8 %t2644)
%t2645 = icmp uge i128 %t2639, 128
%t2646 = add i128 %t2639, 0
%t2647 = lshr i128 %p0, %t2646
%t2648 = select i1 %t2645, i128 0, i128 %t2647
ret i128 %t2648
}
define i128 @__m____________lib_word_resid__xi_lift(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i128 %p0
}
define i128 @__m____________lib_word_resid__xi_from_word(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2649 = and i64 %p0, 4294967295
%t2650 = zext i64 %t2649 to i128
ret i128 %t2650
}
define i64 @__m____________lib_word_resid__xi_word(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2651 = sext i64 %p1 to i128
%t2652 = add i128 %t2651, 0
%t2653 = add i128 %t2652, 0
%t2654 = icmp ne i128 %t2653, %t2651
%t2655 = icmp slt i64 %p1, 0
%t2656 = or i1 %t2654, %t2655
%t2657 = zext i1 %t2656 to i8
call void @resid_conv_check(i8 %t2657)
%t2658 = icmp uge i128 %t2652, 128
%t2659 = add i128 %t2652, 0
%t2660 = lshr i128 %p0, %t2659
%t2661 = select i1 %t2658, i128 0, i128 %t2660
%t2662 = and i128 %t2661, 4294967295
%t2663 = trunc i128 %t2662 to i64
ret i64 %t2663
}
define i128 @__m____________lib_word_resid__xi_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2664 = and i64 %p0, 255
%t2665 = zext i64 %t2664 to i128
ret i128 %t2665
}
define i64 @__m____________lib_word_resid__xi_byte(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2666 = sext i64 %p1 to i128
%t2667 = add i128 %t2666, 0
%t2668 = add i128 %t2667, 0
%t2669 = icmp ne i128 %t2668, %t2666
%t2670 = icmp slt i64 %p1, 0
%t2671 = or i1 %t2669, %t2670
%t2672 = zext i1 %t2671 to i8
call void @resid_conv_check(i8 %t2672)
%t2673 = icmp uge i128 %t2667, 128
%t2674 = add i128 %t2667, 0
%t2675 = lshr i128 %p0, %t2674
%t2676 = select i1 %t2673, i128 0, i128 %t2675
%t2677 = and i128 %t2676, 255
%t2678 = trunc i128 %t2677 to i64
ret i64 %t2678
}
define i128 @__m____________lib_word_resid__xi_bit(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2679 = sext i64 %p1 to i128
%t2680 = add i128 %t2679, 0
%t2681 = add i128 %t2680, 0
%t2682 = icmp ne i128 %t2681, %t2679
%t2683 = icmp slt i64 %p1, 0
%t2684 = or i1 %t2682, %t2683
%t2685 = zext i1 %t2684 to i8
call void @resid_conv_check(i8 %t2685)
%t2686 = icmp uge i128 %t2680, 128
%t2687 = add i128 %t2680, 0
%t2688 = lshr i128 %p0, %t2687
%t2689 = select i1 %t2686, i128 0, i128 %t2688
%t2690 = and i128 %t2689, 1
%t2691 = trunc i128 %t2690 to i64
%t2692 = call i64 asm "", "=r,0"(i64 %t2691)
%t2693 = sext i64 %t2692 to i128
%t2694 = sub i128 0, %t2693
ret i128 %t2694
}
define i128 @__m____________lib_word_resid__xi_aes_round(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2695 = bitcast i128 %p0 to <2 x i64>
%t2696 = bitcast i128 %p1 to <2 x i64>
%t2697 = call <2 x i64> @llvm.x86.aesni.aesenc(<2 x i64> %t2695, <2 x i64> %t2696)
%t2698 = bitcast <2 x i64> %t2697 to i128
ret i128 %t2698
}
define i128 @__m____________lib_word_resid__xi_aes_last(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2699 = bitcast i128 %p0 to <2 x i64>
%t2700 = bitcast i128 %p1 to <2 x i64>
%t2701 = call <2 x i64> @llvm.x86.aesni.aesenclast(<2 x i64> %t2699, <2 x i64> %t2700)
%t2702 = bitcast <2 x i64> %t2701 to i128
ret i128 %t2702
}
define i128 @__m____________lib_word_resid__xi_clmul(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2703 = call i128 @e.gf128(i128 %p0, i128 %p1)
ret i128 %t2703
}
define i128 @__m____________lib_word_resid__xs_xor(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2704 = xor i128 %p0, %p1
ret i128 %t2704
}
define i128 @__m____________lib_word_resid__xs_and(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2705 = and i128 %p0, %p1
ret i128 %t2705
}
define i128 @__m____________lib_word_resid__xs_or(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2706 = or i128 %p0, %p1
ret i128 %t2706
}
define i128 @__m____________lib_word_resid__xs_shl(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2707 = sext i64 %p1 to i128
%t2708 = add i128 %t2707, 0
%t2709 = add i128 %t2708, 0
%t2710 = icmp ne i128 %t2709, %t2707
%t2711 = icmp slt i64 %p1, 0
%t2712 = or i1 %t2710, %t2711
%t2713 = zext i1 %t2712 to i8
call void @resid_conv_check(i8 %t2713)
%t2714 = icmp uge i128 %t2708, 128
%t2715 = add i128 %t2708, 0
%t2716 = shl i128 %p0, %t2715
%t2717 = select i1 %t2714, i128 0, i128 %t2716
ret i128 %t2717
}
define i128 @__m____________lib_word_resid__xs_shr(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2718 = sext i64 %p1 to i128
%t2719 = add i128 %t2718, 0
%t2720 = add i128 %t2719, 0
%t2721 = icmp ne i128 %t2720, %t2718
%t2722 = icmp slt i64 %p1, 0
%t2723 = or i1 %t2721, %t2722
%t2724 = zext i1 %t2723 to i8
call void @resid_conv_check(i8 %t2724)
%t2725 = icmp uge i128 %t2719, 128
%t2726 = add i128 %t2719, 0
%t2727 = lshr i128 %p0, %t2726
%t2728 = select i1 %t2725, i128 0, i128 %t2727
ret i128 %t2728
}
define i128 @__m____________lib_word_resid__xs_lift(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i128 %p0
}
define i128 @__m____________lib_word_resid__xs_from_word(i32 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2729 = zext i32 %p0 to i128
ret i128 %t2729
}
define i32 @__m____________lib_word_resid__xs_word(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2730 = sext i64 %p1 to i128
%t2731 = add i128 %t2730, 0
%t2732 = add i128 %t2731, 0
%t2733 = icmp ne i128 %t2732, %t2730
%t2734 = icmp slt i64 %p1, 0
%t2735 = or i1 %t2733, %t2734
%t2736 = zext i1 %t2735 to i8
call void @resid_conv_check(i8 %t2736)
%t2737 = icmp uge i128 %t2731, 128
%t2738 = add i128 %t2731, 0
%t2739 = lshr i128 %p0, %t2738
%t2740 = select i1 %t2737, i128 0, i128 %t2739
%t2741 = trunc i128 %t2740 to i32
ret i32 %t2741
}
define i128 @__m____________lib_word_resid__xs_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2742 = zext i8 %p0 to i128
ret i128 %t2742
}
define i8 @__m____________lib_word_resid__xs_byte(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2743 = sext i64 %p1 to i128
%t2744 = add i128 %t2743, 0
%t2745 = add i128 %t2744, 0
%t2746 = icmp ne i128 %t2745, %t2743
%t2747 = icmp slt i64 %p1, 0
%t2748 = or i1 %t2746, %t2747
%t2749 = zext i1 %t2748 to i8
call void @resid_conv_check(i8 %t2749)
%t2750 = icmp uge i128 %t2744, 128
%t2751 = add i128 %t2744, 0
%t2752 = lshr i128 %p0, %t2751
%t2753 = select i1 %t2750, i128 0, i128 %t2752
%t2754 = trunc i128 %t2753 to i8
ret i8 %t2754
}
define i128 @__m____________lib_word_resid__xs_bit(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2755 = sext i64 %p1 to i128
%t2756 = add i128 %t2755, 0
%t2757 = add i128 %t2756, 0
%t2758 = icmp ne i128 %t2757, %t2755
%t2759 = icmp slt i64 %p1, 0
%t2760 = or i1 %t2758, %t2759
%t2761 = zext i1 %t2760 to i8
call void @resid_conv_check(i8 %t2761)
%t2762 = icmp uge i128 %t2756, 128
%t2763 = add i128 %t2756, 0
%t2764 = lshr i128 %p0, %t2763
%t2765 = select i1 %t2762, i128 0, i128 %t2764
%t2766 = and i128 %t2765, 1
%t2767 = trunc i128 %t2766 to i64
%t2768 = call i64 asm "", "=r,0"(i64 %t2767)
%t2769 = sext i64 %t2768 to i128
%t2770 = sub i128 0, %t2769
ret i128 %t2770
}
define i128 @__m____________lib_word_resid__xs_aes_round(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2771 = bitcast i128 %p0 to <2 x i64>
%t2772 = bitcast i128 %p1 to <2 x i64>
%t2773 = call <2 x i64> @llvm.x86.aesni.aesenc(<2 x i64> %t2771, <2 x i64> %t2772)
%t2774 = bitcast <2 x i64> %t2773 to i128
ret i128 %t2774
}
define i128 @__m____________lib_word_resid__xs_aes_last(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2775 = bitcast i128 %p0 to <2 x i64>
%t2776 = bitcast i128 %p1 to <2 x i64>
%t2777 = call <2 x i64> @llvm.x86.aesni.aesenclast(<2 x i64> %t2775, <2 x i64> %t2776)
%t2778 = bitcast <2 x i64> %t2777 to i128
ret i128 %t2778
}
define i128 @__m____________lib_word_resid__xs_clmul(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2779 = call i128 @e.gf128(i128 %p0, i128 %p1)
ret i128 %t2779
}
define i64 @__m____________lib_sha256g_resid__sha2k(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2781 = call ptr @resid_list_const_i64(ptr @.lc2780, i64 64, ptr @.lcd2780, ptr @.lty2780)
%t2782 = call ptr @resid_list_get(ptr %t2781, i64 %p0)
%t2783 = call i64 @resid_unbox_i64(ptr %t2782)
ret i64 %t2783
}
define ptr @sha256g_pad(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2785 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p0, i64 9)
%t2786 = extractvalue {i64, i1} %t2785, 0
%t2787 = extractvalue {i64, i1} %t2785, 1
%t2788 = zext i1 %t2787 to i8
call void @resid_overflow_check(i8 %t2788)
%t2789 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t2786, i64 63)
%t2790 = extractvalue {i64, i1} %t2789, 0
%t2791 = extractvalue {i64, i1} %t2789, 1
%t2792 = zext i1 %t2791 to i8
call void @resid_overflow_check(i8 %t2792)
%t2793 = sdiv i64 %t2790, 64
%t2794 = mul nsw i64 %t2793, 64
%t2795 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t2794, i64 %p0)
%t2796 = extractvalue {i64, i1} %t2795, 0
%t2797 = extractvalue {i64, i1} %t2795, 1
%t2798 = zext i1 %t2797 to i8
call void @resid_overflow_check(i8 %t2798)
%t2799 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t2796, i64 9)
%t2800 = extractvalue {i64, i1} %t2799, 0
%t2801 = extractvalue {i64, i1} %t2799, 1
%t2802 = zext i1 %t2801 to i8
call void @resid_overflow_check(i8 %t2802)
%t2803 = call ptr @resid_listbuf_new()
%t2804 = call ptr @__m____________lib_sha256g_resid__sha256g_pad_at__rs150(i64 %p0, i64 %t2800, i64 0, ptr %t2803)
%t2805 = call ptr @resid_listbuf_finish(ptr %t2804, ptr @.lty2805)
ret ptr %t2805
}
define ptr @__m____________lib_sha256g_resid__sha256g_pad_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ], [ %p0, %tco.s2 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ], [ %p1, %tco.s2 ]
%p2 = phi i64 [ %p2.in, %entry ], [ 1, %tco.s0 ], [ %t2814, %tco.s1 ], [ %t2840, %tco.s2 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t2810, %tco.s0 ], [ %t2820, %tco.s1 ], [ %t2855, %tco.s2 ]
%t2806 = icmp eq i64 %p2, 0
br i1 %t2806, label %L343, label %L345
L343:
%t2807 = call ptr @resid_box_i64(i64 128)
%t2810 = call ptr @resid_listbuf_push(ptr %p3, ptr %t2807)
br label %tco.s0
tco.s0:
br label %tco.head
L345:
%t2812 = icmp sle i64 %p2, %p1
br i1 %t2812, label %L346, label %L348
L346:
%t2813 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t2814 = extractvalue {i64, i1} %t2813, 0
%t2815 = extractvalue {i64, i1} %t2813, 1
%t2816 = zext i1 %t2815 to i8
call void @resid_overflow_check(i8 %t2816)
%t2817 = call ptr @resid_box_i64(i64 0)
%t2820 = call ptr @resid_listbuf_push(ptr %p3, ptr %t2817)
br label %tco.s1
tco.s1:
br label %tco.head
L348:
%t2822 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 8)
%t2823 = extractvalue {i64, i1} %t2822, 0
%t2824 = extractvalue {i64, i1} %t2822, 1
%t2825 = zext i1 %t2824 to i8
call void @resid_overflow_check(i8 %t2825)
%t2826 = icmp sle i64 %p2, %t2823
br i1 %t2826, label %L349, label %L351
L349:
%t2827 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 8)
%t2828 = extractvalue {i64, i1} %t2827, 0
%t2829 = extractvalue {i64, i1} %t2827, 1
%t2830 = zext i1 %t2829 to i8
call void @resid_overflow_check(i8 %t2830)
%t2831 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t2828, i64 %p2)
%t2832 = extractvalue {i64, i1} %t2831, 0
%t2833 = extractvalue {i64, i1} %t2831, 1
%t2834 = zext i1 %t2833 to i8
call void @resid_overflow_check(i8 %t2834)
%t2835 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t2832, i64 8)
%t2836 = extractvalue {i64, i1} %t2835, 0
%t2837 = extractvalue {i64, i1} %t2835, 1
%t2838 = zext i1 %t2837 to i8
call void @resid_overflow_check(i8 %t2838)
%t2839 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t2840 = extractvalue {i64, i1} %t2839, 0
%t2841 = extractvalue {i64, i1} %t2839, 1
%t2842 = zext i1 %t2841 to i8
call void @resid_overflow_check(i8 %t2842)
%t2843 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p0, i64 8)
%t2844 = extractvalue {i64, i1} %t2843, 0
%t2845 = extractvalue {i64, i1} %t2843, 1
%t2846 = zext i1 %t2845 to i8
call void @resid_overflow_check(i8 %t2846)
%t2847 = icmp uge i64 %t2836, 64
%t2848 = add i64 %t2836, 0
%t2849 = select i1 %t2847, i64 63, i64 %t2848
%t2850 = ashr i64 %t2844, %t2849
%t2851 = and i64 %t2850, 255
%t2852 = call ptr @resid_box_i64(i64 %t2851)
%t2855 = call ptr @resid_listbuf_push(ptr %p3, ptr %t2852)
br label %tco.s2
tco.s2:
br label %tco.head
L351:
ret ptr %p3
}
define ptr @sha256g_iv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2858 = call ptr @resid_list_const_i64(ptr @.lc2857, i64 8, ptr @.lcd2857, ptr @.lty2857)
ret ptr %t2858
}
define ptr @__m____________lib_sha256g_resid__sha256g_zeros(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2861, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t2865, %tco.s0 ]
%t2859 = icmp sge i64 %p1, %p0
br i1 %t2859, label %L352, label %L354
L352:
%t2860 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty2860)
ret ptr %t2860
L354:
%t2861 = add nsw i64 %p1, 1
%t2862 = call ptr @resid_box_i64(i64 0)
%t2865 = call ptr @resid_listbuf_push(ptr %p2, ptr %t2862)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @mask32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2867 = and i64 %p0, 4294967295
ret i64 %t2867
}
define i64 @rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2868 = icmp uge i64 %p1, 64
%t2869 = add i64 %p1, 0
%t2870 = select i1 %t2868, i64 63, i64 %t2869
%t2871 = ashr i64 %p0, %t2870
%t2872 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t2873 = extractvalue {i64, i1} %t2872, 0
%t2874 = extractvalue {i64, i1} %t2872, 1
%t2875 = zext i1 %t2874 to i8
call void @resid_overflow_check(i8 %t2875)
%t2876 = icmp uge i64 %t2873, 64
%t2877 = add i64 %t2873, 0
%t2878 = shl i64 %p0, %t2877
%t2879 = select i1 %t2876, i64 0, i64 %t2878
%t2880 = or i64 %t2871, %t2879
%t2881 = and i64 %t2880, 4294967295
ret i64 %t2881
}
define i64 @not32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2882 = xor i64 %p0, 4294967295
%t2883 = and i64 %t2882, 4294967295
ret i64 %t2883
}
define i64 @k_at(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2885 = call ptr @resid_list_const_i64(ptr @.lc2884, i64 64, ptr @.lcd2884, ptr @.lty2884)
%t2886 = call ptr @resid_list_get(ptr %t2885, i64 %p0)
%t2887 = call i64 @resid_unbox_i64(ptr %t2886)
ret i64 %t2887
}
define ptr @utf8_push_cp(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2889 = icmp slt i64 %p0, 128
br i1 %t2889, label %L355, label %L357
L355:
%t2890 = call ptr @resid_box_i64(i64 %p0)
%t2893 = call ptr @resid_listbuf_push(ptr %p1, ptr %t2890)
ret ptr %t2893
L357:
%t2894 = icmp slt i64 %p0, 2048
br i1 %t2894, label %L358, label %L360
L358:
%t2895 = ashr i64 %p0, 6
%t2896 = or i64 192, %t2895
%t2897 = call ptr @resid_box_i64(i64 %t2896)
%t2900 = call ptr @resid_listbuf_push(ptr %p1, ptr %t2897)
%t2901 = and i64 %p0, 63
%t2902 = or i64 128, %t2901
%t2903 = call ptr @resid_box_i64(i64 %t2902)
%t2906 = call ptr @resid_listbuf_push(ptr %t2900, ptr %t2903)
ret ptr %t2906
L360:
%t2907 = icmp slt i64 %p0, 65536
br i1 %t2907, label %L361, label %L363
L361:
%t2908 = ashr i64 %p0, 12
%t2909 = or i64 224, %t2908
%t2910 = call ptr @resid_box_i64(i64 %t2909)
%t2913 = call ptr @resid_listbuf_push(ptr %p1, ptr %t2910)
%t2914 = ashr i64 %p0, 6
%t2915 = and i64 %t2914, 63
%t2916 = or i64 128, %t2915
%t2917 = call ptr @resid_box_i64(i64 %t2916)
%t2920 = call ptr @resid_listbuf_push(ptr %t2913, ptr %t2917)
%t2921 = and i64 %p0, 63
%t2922 = or i64 128, %t2921
%t2923 = call ptr @resid_box_i64(i64 %t2922)
%t2926 = call ptr @resid_listbuf_push(ptr %t2920, ptr %t2923)
ret ptr %t2926
L363:
%t2927 = ashr i64 %p0, 18
%t2928 = or i64 240, %t2927
%t2929 = call ptr @resid_box_i64(i64 %t2928)
%t2932 = call ptr @resid_listbuf_push(ptr %p1, ptr %t2929)
%t2933 = ashr i64 %p0, 12
%t2934 = and i64 %t2933, 63
%t2935 = or i64 128, %t2934
%t2936 = call ptr @resid_box_i64(i64 %t2935)
%t2939 = call ptr @resid_listbuf_push(ptr %t2932, ptr %t2936)
%t2940 = ashr i64 %p0, 6
%t2941 = and i64 %t2940, 63
%t2942 = or i64 128, %t2941
%t2943 = call ptr @resid_box_i64(i64 %t2942)
%t2946 = call ptr @resid_listbuf_push(ptr %t2939, ptr %t2943)
%t2947 = and i64 %p0, 63
%t2948 = or i64 128, %t2947
%t2949 = call ptr @resid_box_i64(i64 %t2948)
%t2952 = call ptr @resid_listbuf_push(ptr %t2946, ptr %t2949)
ret ptr %t2952
}
define ptr @utf8_run(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2956, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t2958, %tco.s0 ]
%t2953 = call i64 @str_len(ptr %p0)
%t2954 = icmp sge i64 %p1, %t2953
br i1 %t2954, label %L364, label %L366
L364:
%t2955 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty2955)
ret ptr %t2955
L366:
%t2956 = add nsw i64 %p1, 1
%t2957 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t2958 = call ptr @utf8_push_cp(i64 %t2957, ptr %p2)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @msg_bytes(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2960 = call ptr @resid_listbuf_new()
%t2961 = call ptr @utf8_run(ptr %p0, i64 %p1, ptr %t2960)
%t2962 = call ptr @resid_list_freeze(ptr %t2961)
%t2963 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t2962)
ret ptr %t2963
}
define ptr @bytes_of(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2964 = call ptr @resid_listbuf_new()
%t2965 = call ptr @utf8_run(ptr %p0, i64 0, ptr %t2964)
ret ptr %t2965
}
define i1 @str_is_ascii(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2970, %tco.s0 ]
%t2966 = call i64 @str_len(ptr %p0)
%t2967 = icmp sge i64 %p1, %t2966
br i1 %t2967, label %L367, label %L369
L367:
ret i1 true
L369:
%t2968 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t2969 = icmp sge i64 %t2968, 128
br i1 %t2969, label %L370, label %L372
L370:
ret i1 false
L372:
%t2970 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @slice_seed(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2976 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2984, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t2987, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t2972 = icmp sle i64 %p2, 0
br i1 %t2972, label %L373, label %L375
L373:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p3
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L375:
%t2973 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t2974 = call i64 @resid_unbox_i64(ptr %t2973)
%t2978 = call ptr @resid_box_i64(i64 %t2974)
%t2980 = getelementptr i8, ptr %t2976, i64 0
store ptr %t2978, ptr %t2980
%t2981 = call ptr @resid_list_new(i64 1, ptr %t2976, ptr @.lty2976)
%t2982 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t2981)
%t2983 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t2984 = extractvalue {i64, i1} %t2983, 0
%t2985 = extractvalue {i64, i1} %t2983, 1
%t2986 = zext i1 %t2985 to i8
call void @resid_overflow_check(i8 %t2986)
%t2987 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t2982, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t2982, %tco.s0 ]
br label %tco.head
}
define ptr @zeros_l(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t2993, %tco.s0.k ]
%t2989 = icmp sle i64 %p1, 0
br i1 %t2989, label %L376, label %L378
L376:
%lr.cx9 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz9 = icmp eq ptr %lr.cx9, null
br i1 %lr.lz9, label %lr.x9.k, label %lr.x9.m
lr.x9.k:
ret ptr %p0
lr.x9.m:
%lr.ret9 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx9)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret9
L378:
%t2991 = call ptr @resid_list_const_i64(ptr @.lc2990, i64 1, ptr @.lcd2990, ptr @.lty2990)
%t2992 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t2991)
%t2993 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t2992, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t2992, %tco.s0 ]
br label %tco.head
}
define ptr @length_bytes(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3005 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3012, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t2995 = icmp slt i64 %p1, 0
br i1 %t2995, label %L379, label %L381
L379:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p2
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L381:
%t2996 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t2997 = extractvalue {i64, i1} %t2996, 0
%t2998 = extractvalue {i64, i1} %t2996, 1
%t2999 = zext i1 %t2998 to i8
call void @resid_overflow_check(i8 %t2999)
%t3000 = icmp uge i64 %t2997, 64
%t3001 = add i64 %t2997, 0
%t3002 = select i1 %t3000, i64 63, i64 %t3001
%t3003 = ashr i64 %p0, %t3002
%t3004 = and i64 %t3003, 255
%t3007 = call ptr @resid_box_i64(i64 %t3004)
%t3009 = getelementptr i8, ptr %t3005, i64 0
store ptr %t3007, ptr %t3009
%t3010 = call ptr @resid_list_new(i64 1, ptr %t3005, ptr @.lty3005)
%t3011 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t3010)
%t3012 = sub nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t3011, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t3011, %tco.s0 ]
br label %tco.head
}
define ptr @pad_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3014 = call i64 @resid_list_len(ptr %p0)
%t3016 = call ptr @resid_list_const_i64(ptr @.lc3015, i64 1, ptr @.lcd3015, ptr @.lty3015)
%t3017 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t3016)
%t3018 = add nsw i64 %t3014, 9
%t3019 = add nsw i64 %t3018, 63
%t3020 = sdiv i64 %t3019, 64
%t3021 = mul nsw i64 %t3020, 64
%t3022 = sub nsw i64 %t3021, %t3018
%t3023 = call ptr @zeros_l(ptr %t3017, i64 %t3022)
%t3024 = mul nsw i64 %t3014, 8
%t3025 = call ptr @length_bytes__rs153(i64 %t3024, i64 7, ptr %t3023)
ret ptr %t3025
}
define ptr @bw_acc(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3066 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3073, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3026 = icmp sge i64 %p2, 16
br i1 %t3026, label %L382, label %L384
L382:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p3
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L384:
%t3027 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t3028 = extractvalue {i64, i1} %t3027, 0
%t3029 = extractvalue {i64, i1} %t3027, 1
%t3030 = zext i1 %t3029 to i8
call void @resid_overflow_check(i8 %t3030)
%t3031 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t3028)
%t3032 = extractvalue {i64, i1} %t3031, 0
%t3033 = extractvalue {i64, i1} %t3031, 1
%t3034 = zext i1 %t3033 to i8
call void @resid_overflow_check(i8 %t3034)
%t3035 = call ptr @resid_list_get_v(ptr %p0, i64 %t3032, ptr %p0.ld, i64 %p0.ln)
%t3036 = call i64 @resid_unbox_i64(ptr %t3035)
%t3038 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3032, i64 1)
%t3039 = extractvalue {i64, i1} %t3038, 0
%t3040 = extractvalue {i64, i1} %t3038, 1
%t3041 = zext i1 %t3040 to i8
call void @resid_overflow_check(i8 %t3041)
%t3042 = call ptr @resid_list_get_v(ptr %p0, i64 %t3039, ptr %p0.ld, i64 %p0.ln)
%t3043 = call i64 @resid_unbox_i64(ptr %t3042)
%t3045 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3032, i64 2)
%t3046 = extractvalue {i64, i1} %t3045, 0
%t3047 = extractvalue {i64, i1} %t3045, 1
%t3048 = zext i1 %t3047 to i8
call void @resid_overflow_check(i8 %t3048)
%t3049 = call ptr @resid_list_get_v(ptr %p0, i64 %t3046, ptr %p0.ld, i64 %p0.ln)
%t3050 = call i64 @resid_unbox_i64(ptr %t3049)
%t3052 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3032, i64 3)
%t3053 = extractvalue {i64, i1} %t3052, 0
%t3054 = extractvalue {i64, i1} %t3052, 1
%t3055 = zext i1 %t3054 to i8
call void @resid_overflow_check(i8 %t3055)
%t3056 = call ptr @resid_list_get_v(ptr %p0, i64 %t3053, ptr %p0.ld, i64 %p0.ln)
%t3057 = call i64 @resid_unbox_i64(ptr %t3056)
%t3059 = shl i64 %t3036, 24
%t3060 = shl i64 %t3043, 16
%t3061 = shl i64 %t3050, 8
%t3062 = or i64 %t3059, %t3060
%t3063 = or i64 %t3062, %t3061
%t3064 = or i64 %t3063, %t3057
%t3065 = and i64 %t3064, 4294967295
%t3068 = call ptr @resid_box_i64(i64 %t3065)
%t3070 = getelementptr i8, ptr %t3066, i64 0
store ptr %t3068, ptr %t3070
%t3071 = call ptr @resid_list_new(i64 1, ptr %t3066, ptr @.lty3066)
%t3072 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3071)
%t3073 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3072, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3072, %tco.s0 ]
br label %tco.head
}
define ptr @block_words(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3076 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3075)
%t3077 = call ptr @bw_acc(ptr %p0, i64 %p1, i64 0, ptr %t3076)
ret ptr %t3077
}
define ptr @ext_w(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3130 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3137, %tco.s0.k ]
%t3078 = icmp sge i64 %p1, 64
br i1 %t3078, label %L385, label %L387
L385:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p0
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L387:
%t3079 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 15)
%t3080 = extractvalue {i64, i1} %t3079, 0
%t3081 = extractvalue {i64, i1} %t3079, 1
%t3082 = zext i1 %t3081 to i8
call void @resid_overflow_check(i8 %t3082)
%t3083 = call ptr @resid_list_get(ptr %p0, i64 %t3080)
%t3084 = call i64 @resid_unbox_i64(ptr %t3083)
%t3086 = call i64 @rotr(i64 %t3084, i64 7)
%t3087 = call i64 @rotr(i64 %t3084, i64 18)
%t3088 = ashr i64 %t3084, 3
%t3089 = xor i64 %t3086, %t3087
%t3090 = xor i64 %t3089, %t3088
%t3091 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 2)
%t3092 = extractvalue {i64, i1} %t3091, 0
%t3093 = extractvalue {i64, i1} %t3091, 1
%t3094 = zext i1 %t3093 to i8
call void @resid_overflow_check(i8 %t3094)
%t3095 = call ptr @resid_list_get(ptr %p0, i64 %t3092)
%t3096 = call i64 @resid_unbox_i64(ptr %t3095)
%t3098 = call i64 @rotr(i64 %t3096, i64 17)
%t3099 = call i64 @rotr(i64 %t3096, i64 19)
%t3100 = ashr i64 %t3096, 10
%t3101 = xor i64 %t3098, %t3099
%t3102 = xor i64 %t3101, %t3100
%t3103 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 16)
%t3104 = extractvalue {i64, i1} %t3103, 0
%t3105 = extractvalue {i64, i1} %t3103, 1
%t3106 = zext i1 %t3105 to i8
call void @resid_overflow_check(i8 %t3106)
%t3107 = call ptr @resid_list_get(ptr %p0, i64 %t3104)
%t3108 = call i64 @resid_unbox_i64(ptr %t3107)
%t3110 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3108, i64 %t3090)
%t3111 = extractvalue {i64, i1} %t3110, 0
%t3112 = extractvalue {i64, i1} %t3110, 1
%t3113 = zext i1 %t3112 to i8
call void @resid_overflow_check(i8 %t3113)
%t3114 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 7)
%t3115 = extractvalue {i64, i1} %t3114, 0
%t3116 = extractvalue {i64, i1} %t3114, 1
%t3117 = zext i1 %t3116 to i8
call void @resid_overflow_check(i8 %t3117)
%t3118 = call ptr @resid_list_get(ptr %p0, i64 %t3115)
%t3119 = call i64 @resid_unbox_i64(ptr %t3118)
%t3121 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3119, i64 %t3102)
%t3122 = extractvalue {i64, i1} %t3121, 0
%t3123 = extractvalue {i64, i1} %t3121, 1
%t3124 = zext i1 %t3123 to i8
call void @resid_overflow_check(i8 %t3124)
%t3125 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3111, i64 %t3122)
%t3126 = extractvalue {i64, i1} %t3125, 0
%t3127 = extractvalue {i64, i1} %t3125, 1
%t3128 = zext i1 %t3127 to i8
call void @resid_overflow_check(i8 %t3128)
%t3129 = and i64 %t3126, 4294967295
%t3132 = call ptr @resid_box_i64(i64 %t3129)
%t3134 = getelementptr i8, ptr %t3130, i64 0
store ptr %t3132, ptr %t3134
%t3135 = call ptr @resid_list_new(i64 1, ptr %t3130, ptr @.lty3130)
%t3136 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t3135)
%t3137 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t3136, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t3136, %tco.s0 ]
br label %tco.head
}
define i64 @pick(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3139 = icmp eq i64 %p3, %p1
br i1 %t3139, label %L388, label %L390
L388:
ret i64 %p2
L390:
%t3140 = call ptr @resid_list_get(ptr %p0, i64 %p3)
%t3141 = call i64 @resid_unbox_i64(ptr %t3140)
ret i64 %t3141
}
define ptr @ls_build(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3143 = icmp sgt i64 %p3, 0
br i1 %t3143, label %L391, label %L393
L391:
%t3144 = sub nsw i64 %p3, 1
%t3145 = call ptr @ls_build(ptr %p0, i64 %p1, i64 %p2, i64 %t3144)
%t3146 = call i64 @pick(ptr %p0, i64 %p1, i64 %p2, i64 %p3)
%t3147 = alloca [1 x ptr]
%t3149 = call ptr @resid_box_i64(i64 %t3146)
%t3151 = getelementptr i8, ptr %t3147, i64 0
store ptr %t3149, ptr %t3151
%t3152 = call ptr @resid_list_new(i64 1, ptr %t3147, ptr @.lty3147)
%t3153 = call ptr @resid_list_concat_own(ptr %t3145, i8 1, ptr %t3152)
ret ptr %t3153
L393:
%t3154 = call i64 @pick(ptr %p0, i64 %p1, i64 %p2, i64 0)
%t3155 = alloca [1 x ptr]
%t3157 = call ptr @resid_box_i64(i64 %t3154)
%t3159 = getelementptr i8, ptr %t3155, i64 0
store ptr %t3157, ptr %t3159
%t3160 = call ptr @resid_list_new(i64 1, ptr %t3155, ptr @.lty3155)
ret ptr %t3160
}
define ptr @ls_set(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3161 = call i64 @resid_list_len(ptr %p0)
%t3162 = sub nsw i64 %t3161, 1
%t3163 = call ptr @ls_build(ptr %p0, i64 %p1, i64 %p2, i64 %t3162)
ret ptr %t3163
}
define i64 @ch_of(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3164 = call i64 @not32(i64 %p0)
%t3165 = and i64 %p0, %p1
%t3166 = and i64 %t3164, %p2
%t3167 = xor i64 %t3165, %t3166
ret i64 %t3167
}
define ptr @sha_round(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3168 = call ptr @resid_list_get(ptr %p0, i64 0)
%t3169 = call i64 @resid_unbox_i64(ptr %t3168)
%t3171 = call ptr @resid_list_get(ptr %p0, i64 1)
%t3172 = call i64 @resid_unbox_i64(ptr %t3171)
%t3174 = call ptr @resid_list_get(ptr %p0, i64 2)
%t3175 = call i64 @resid_unbox_i64(ptr %t3174)
%t3177 = call ptr @resid_list_get(ptr %p0, i64 3)
%t3178 = call i64 @resid_unbox_i64(ptr %t3177)
%t3180 = call ptr @resid_list_get(ptr %p0, i64 4)
%t3181 = call i64 @resid_unbox_i64(ptr %t3180)
%t3183 = call ptr @resid_list_get(ptr %p0, i64 5)
%t3184 = call i64 @resid_unbox_i64(ptr %t3183)
%t3186 = call ptr @resid_list_get(ptr %p0, i64 6)
%t3187 = call i64 @resid_unbox_i64(ptr %t3186)
%t3189 = call ptr @resid_list_get(ptr %p0, i64 7)
%t3190 = call i64 @resid_unbox_i64(ptr %t3189)
%t3192 = call ptr @resid_list_get(ptr %p1, i64 %p2)
%t3193 = call i64 @resid_unbox_i64(ptr %t3192)
%t3195 = call i64 @resid_scope_push()
%t3196 = call i64 @k_at(i64 %p2)
call void @resid_scope_pop(i64 %t3195)
%t3197 = call i64 @rotr(i64 %t3181, i64 6)
%t3198 = call i64 @rotr(i64 %t3181, i64 11)
%t3199 = call i64 @rotr(i64 %t3181, i64 25)
%t3200 = xor i64 %t3197, %t3198
%t3201 = xor i64 %t3200, %t3199
%t3202 = call i64 @ch_of(i64 %t3181, i64 %t3184, i64 %t3187)
%t3203 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3190, i64 %t3201)
%t3204 = extractvalue {i64, i1} %t3203, 0
%t3205 = extractvalue {i64, i1} %t3203, 1
%t3206 = zext i1 %t3205 to i8
call void @resid_overflow_check(i8 %t3206)
%t3207 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3204, i64 %t3202)
%t3208 = extractvalue {i64, i1} %t3207, 0
%t3209 = extractvalue {i64, i1} %t3207, 1
%t3210 = zext i1 %t3209 to i8
call void @resid_overflow_check(i8 %t3210)
%t3211 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3208, i64 %t3196)
%t3212 = extractvalue {i64, i1} %t3211, 0
%t3213 = extractvalue {i64, i1} %t3211, 1
%t3214 = zext i1 %t3213 to i8
call void @resid_overflow_check(i8 %t3214)
%t3215 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3212, i64 %t3193)
%t3216 = extractvalue {i64, i1} %t3215, 0
%t3217 = extractvalue {i64, i1} %t3215, 1
%t3218 = zext i1 %t3217 to i8
call void @resid_overflow_check(i8 %t3218)
%t3219 = and i64 %t3216, 4294967295
%t3220 = call i64 @rotr(i64 %t3169, i64 2)
%t3221 = call i64 @rotr(i64 %t3169, i64 13)
%t3222 = call i64 @rotr(i64 %t3169, i64 22)
%t3223 = xor i64 %t3220, %t3221
%t3224 = xor i64 %t3223, %t3222
%t3225 = and i64 %t3169, %t3172
%t3226 = and i64 %t3169, %t3175
%t3227 = and i64 %t3172, %t3175
%t3228 = xor i64 %t3225, %t3226
%t3229 = xor i64 %t3228, %t3227
%t3230 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3224, i64 %t3229)
%t3231 = extractvalue {i64, i1} %t3230, 0
%t3232 = extractvalue {i64, i1} %t3230, 1
%t3233 = zext i1 %t3232 to i8
call void @resid_overflow_check(i8 %t3233)
%t3234 = and i64 %t3231, 4294967295
%t3235 = add nsw i64 %t3219, %t3234
%t3236 = and i64 %t3235, 4294967295
%t3237 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3178, i64 %t3219)
%t3238 = extractvalue {i64, i1} %t3237, 0
%t3239 = extractvalue {i64, i1} %t3237, 1
%t3240 = zext i1 %t3239 to i8
call void @resid_overflow_check(i8 %t3240)
%t3241 = and i64 %t3238, 4294967295
%t3242 = alloca [8 x ptr]
%t3244 = call ptr @resid_box_i64(i64 %t3236)
%t3246 = getelementptr i8, ptr %t3242, i64 0
store ptr %t3244, ptr %t3246
%t3247 = call ptr @resid_box_i64(i64 %t3169)
%t3249 = getelementptr i8, ptr %t3242, i64 8
store ptr %t3247, ptr %t3249
%t3250 = call ptr @resid_box_i64(i64 %t3172)
%t3252 = getelementptr i8, ptr %t3242, i64 16
store ptr %t3250, ptr %t3252
%t3253 = call ptr @resid_box_i64(i64 %t3175)
%t3255 = getelementptr i8, ptr %t3242, i64 24
store ptr %t3253, ptr %t3255
%t3256 = call ptr @resid_box_i64(i64 %t3241)
%t3258 = getelementptr i8, ptr %t3242, i64 32
store ptr %t3256, ptr %t3258
%t3259 = call ptr @resid_box_i64(i64 %t3181)
%t3261 = getelementptr i8, ptr %t3242, i64 40
store ptr %t3259, ptr %t3261
%t3262 = call ptr @resid_box_i64(i64 %t3184)
%t3264 = getelementptr i8, ptr %t3242, i64 48
store ptr %t3262, ptr %t3264
%t3265 = call ptr @resid_box_i64(i64 %t3187)
%t3267 = getelementptr i8, ptr %t3242, i64 56
store ptr %t3265, ptr %t3267
%t3268 = call ptr @resid_list_new(i64 8, ptr %t3242, ptr @.lty3242)
ret ptr %t3268
}
define ptr @sha_rounds(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3271, %tco.s0.k ]
%t3269 = icmp sge i64 %p2, 64
br i1 %t3269, label %L394, label %L396
L394:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p0
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L396:
%t3270 = call ptr @sha_round(ptr %p0, ptr %p1, i64 %p2)
%t3271 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t3270, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t3270, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
br label %tco.head
}
define i64 @add_w(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3273 = call ptr @resid_list_get(ptr %p0, i64 %p2)
%t3274 = call i64 @resid_unbox_i64(ptr %t3273)
%t3276 = call ptr @resid_list_get(ptr %p1, i64 %p2)
%t3277 = call i64 @resid_unbox_i64(ptr %t3276)
%t3279 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3274, i64 %t3277)
%t3280 = extractvalue {i64, i1} %t3279, 0
%t3281 = extractvalue {i64, i1} %t3279, 1
%t3282 = zext i1 %t3281 to i8
call void @resid_overflow_check(i8 %t3282)
%t3283 = and i64 %t3280, 4294967295
ret i64 %t3283
}
define ptr @add_h(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3284 = call i64 @add_w(ptr %p0, ptr %p1, i64 0)
%t3285 = call i64 @add_w(ptr %p0, ptr %p1, i64 1)
%t3286 = call i64 @add_w(ptr %p0, ptr %p1, i64 2)
%t3287 = call i64 @add_w(ptr %p0, ptr %p1, i64 3)
%t3288 = call i64 @add_w(ptr %p0, ptr %p1, i64 4)
%t3289 = call i64 @add_w(ptr %p0, ptr %p1, i64 5)
%t3290 = call i64 @add_w(ptr %p0, ptr %p1, i64 6)
%t3291 = call i64 @add_w(ptr %p0, ptr %p1, i64 7)
%t3292 = alloca [8 x ptr]
%t3294 = call ptr @resid_box_i64(i64 %t3284)
%t3296 = getelementptr i8, ptr %t3292, i64 0
store ptr %t3294, ptr %t3296
%t3297 = call ptr @resid_box_i64(i64 %t3285)
%t3299 = getelementptr i8, ptr %t3292, i64 8
store ptr %t3297, ptr %t3299
%t3300 = call ptr @resid_box_i64(i64 %t3286)
%t3302 = getelementptr i8, ptr %t3292, i64 16
store ptr %t3300, ptr %t3302
%t3303 = call ptr @resid_box_i64(i64 %t3287)
%t3305 = getelementptr i8, ptr %t3292, i64 24
store ptr %t3303, ptr %t3305
%t3306 = call ptr @resid_box_i64(i64 %t3288)
%t3308 = getelementptr i8, ptr %t3292, i64 32
store ptr %t3306, ptr %t3308
%t3309 = call ptr @resid_box_i64(i64 %t3289)
%t3311 = getelementptr i8, ptr %t3292, i64 40
store ptr %t3309, ptr %t3311
%t3312 = call ptr @resid_box_i64(i64 %t3290)
%t3314 = getelementptr i8, ptr %t3292, i64 48
store ptr %t3312, ptr %t3314
%t3315 = call ptr @resid_box_i64(i64 %t3291)
%t3317 = getelementptr i8, ptr %t3292, i64 56
store ptr %t3315, ptr %t3317
%t3318 = call ptr @resid_list_new(i64 8, ptr %t3292, ptr @.lty3292)
ret ptr %t3318
}
define ptr @digest_block(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3319 = musttail call ptr @sha256g_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
ret ptr %t3319
}
define i64 @word_at_list(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3320 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t3321 = extractvalue {i64, i1} %t3320, 0
%t3322 = extractvalue {i64, i1} %t3320, 1
%t3323 = zext i1 %t3322 to i8
call void @resid_overflow_check(i8 %t3323)
%t3324 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t3321)
%t3325 = extractvalue {i64, i1} %t3324, 0
%t3326 = extractvalue {i64, i1} %t3324, 1
%t3327 = zext i1 %t3326 to i8
call void @resid_overflow_check(i8 %t3327)
%t3328 = call ptr @resid_list_get(ptr %p0, i64 %t3325)
%t3329 = call i64 @resid_unbox_i64(ptr %t3328)
%t3331 = and i64 %t3329, 255
%t3332 = shl i64 %t3331, 24
%t3333 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3325, i64 1)
%t3334 = extractvalue {i64, i1} %t3333, 0
%t3335 = extractvalue {i64, i1} %t3333, 1
%t3336 = zext i1 %t3335 to i8
call void @resid_overflow_check(i8 %t3336)
%t3337 = call ptr @resid_list_get(ptr %p0, i64 %t3334)
%t3338 = call i64 @resid_unbox_i64(ptr %t3337)
%t3340 = and i64 %t3338, 255
%t3341 = shl i64 %t3340, 16
%t3342 = or i64 %t3332, %t3341
%t3343 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3325, i64 2)
%t3344 = extractvalue {i64, i1} %t3343, 0
%t3345 = extractvalue {i64, i1} %t3343, 1
%t3346 = zext i1 %t3345 to i8
call void @resid_overflow_check(i8 %t3346)
%t3347 = call ptr @resid_list_get(ptr %p0, i64 %t3344)
%t3348 = call i64 @resid_unbox_i64(ptr %t3347)
%t3350 = and i64 %t3348, 255
%t3351 = shl i64 %t3350, 8
%t3352 = or i64 %t3342, %t3351
%t3353 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3325, i64 3)
%t3354 = extractvalue {i64, i1} %t3353, 0
%t3355 = extractvalue {i64, i1} %t3353, 1
%t3356 = zext i1 %t3355 to i8
call void @resid_overflow_check(i8 %t3356)
%t3357 = call ptr @resid_list_get(ptr %p0, i64 %t3354)
%t3358 = call i64 @resid_unbox_i64(ptr %t3357)
%t3360 = and i64 %t3358, 255
%t3361 = or i64 %t3352, %t3360
%t3362 = and i64 %t3361, 4294967295
ret i64 %t3362
}
define ptr @digest_blocks(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3370, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3363 = icmp sge i64 %p1, %p2
br i1 %t3363, label %L397, label %L399
L397:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L399:
%t3364 = call i8 @resid_cpu_has_sha256()
%t3365 = icmp ne i8 %t3364, 0
br i1 %t3365, label %L400, label %L402
L400:
%t3366 = call i256 @sha_hw_state(ptr %p3, i64 0, i256 0)
%t3367 = call ptr @sha_hw_blocks(ptr %p0, i64 %p1, i64 %p2, i256 %t3366)
%lr.cx19 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz19 = icmp eq ptr %lr.cx19, null
br i1 %lr.lz19, label %lr.x19.k, label %lr.x19.m
lr.x19.k:
ret ptr %t3367
lr.x19.m:
%lr.ret19 = call ptr @resid_mv_list(ptr %t3367, ptr %lr.cx19)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret19
L402:
%t3368 = call ptr @digest_block(ptr %p0, i64 %p1, ptr %p3)
%t3369 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t3370 = extractvalue {i64, i1} %t3369, 0
%t3371 = extractvalue {i64, i1} %t3369, 1
%t3372 = zext i1 %t3371 to i8
call void @resid_overflow_check(i8 %t3372)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3368, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3368, %tco.s0 ]
br label %tco.head
}
define i256 @sha_hw_state(ptr %p0.in, i64 %p1.in, i256 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3375, %tco.s0 ]
%p2 = phi i256 [ %p2.in, %entry ], [ %t3402, %tco.s0 ]
%t3374 = icmp sge i64 %p1, 8
br i1 %t3374, label %L403, label %L405
L403:
ret i256 %p2
L405:
%t3375 = add nsw i64 %p1, 1
%t3376 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3377 = call i64 @resid_unbox_i64(ptr %t3376)
%t3379 = and i64 %t3377, 4294967295
%t3380 = sext i64 %t3379 to i256
%t3381 = add i256 %t3380, 0
%t3382 = add i256 %t3381, 0
%t3383 = icmp ne i256 %t3382, %t3380
%t3384 = icmp slt i64 %t3379, 0
%t3385 = or i1 %t3383, %t3384
%t3386 = zext i1 %t3385 to i8
call void @resid_conv_check(i8 %t3386)
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
%t3400 = shl i256 %t3381, %t3399
%t3401 = select i1 %t3398, i256 0, i256 %t3400
%t3402 = or i256 %p2, %t3401
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @sha_hw_words(i256 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i256 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3406, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t3427, %tco.s0 ]
%t3404 = icmp sge i64 %p1, 8
br i1 %t3404, label %L406, label %L408
L406:
%t3405 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty3405)
ret ptr %t3405
L408:
%t3406 = add nsw i64 %p1, 1
%t3407 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 32, i64 %p1)
%t3408 = extractvalue {i64, i1} %t3407, 0
%t3409 = extractvalue {i64, i1} %t3407, 1
%t3410 = zext i1 %t3409 to i8
call void @resid_overflow_check(i8 %t3410)
%t3411 = sext i64 %t3408 to i256
%t3412 = add i256 %t3411, 0
%t3413 = add i256 %t3412, 0
%t3414 = icmp ne i256 %t3413, %t3411
%t3415 = icmp slt i64 %t3408, 0
%t3416 = or i1 %t3414, %t3415
%t3417 = zext i1 %t3416 to i8
call void @resid_conv_check(i8 %t3417)
%t3418 = icmp uge i256 %t3412, 256
%t3419 = add i256 %t3412, 0
%t3420 = lshr i256 %p0, %t3419
%t3421 = select i1 %t3418, i256 0, i256 %t3420
%t3422 = and i256 %t3421, 4294967295
%t3423 = trunc i256 %t3422 to i64
%t3424 = call ptr @resid_box_i64(i64 %t3423)
%t3427 = call ptr @resid_listbuf_push(ptr %p2, ptr %t3424)
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t3430, %tco.s0 ]
%p3 = phi i512 [ %p3.in, %entry ], [ %t3454, %tco.s0 ]
%t3429 = icmp sge i64 %p2, 16
br i1 %t3429, label %L409, label %L411
L409:
ret i512 %p3
L411:
%t3430 = add nsw i64 %p2, 1
%t3431 = call i64 @word_at_list(ptr %p0, i64 %p1, i64 %p2)
%t3432 = sext i64 %t3431 to i512
%t3433 = add i512 %t3432, 0
%t3434 = add i512 %t3433, 0
%t3435 = icmp ne i512 %t3434, %t3432
%t3436 = icmp slt i64 %t3431, 0
%t3437 = or i1 %t3435, %t3436
%t3438 = zext i1 %t3437 to i8
call void @resid_conv_check(i8 %t3438)
%t3439 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 32, i64 %p2)
%t3440 = extractvalue {i64, i1} %t3439, 0
%t3441 = extractvalue {i64, i1} %t3439, 1
%t3442 = zext i1 %t3441 to i8
call void @resid_overflow_check(i8 %t3442)
%t3443 = sext i64 %t3440 to i512
%t3444 = add i512 %t3443, 0
%t3445 = add i512 %t3444, 0
%t3446 = icmp ne i512 %t3445, %t3443
%t3447 = icmp slt i64 %t3440, 0
%t3448 = or i1 %t3446, %t3447
%t3449 = zext i1 %t3448 to i8
call void @resid_conv_check(i8 %t3449)
%t3450 = icmp uge i512 %t3444, 512
%t3451 = add i512 %t3444, 0
%t3452 = shl i512 %t3433, %t3451
%t3453 = select i1 %t3450, i512 0, i512 %t3452
%t3454 = or i512 %p3, %t3453
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t3457, %tco.s0 ]
%p3 = phi i512 [ %p3.in, %entry ], [ %t3481, %tco.s0 ]
%t3456 = icmp sge i64 %p2, 16
br i1 %t3456, label %L412, label %L414
L412:
ret i512 %p3
L414:
%t3457 = add nsw i64 %p2, 1
%t3458 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 %p2)
%t3459 = sext i64 %t3458 to i512
%t3460 = add i512 %t3459, 0
%t3461 = add i512 %t3460, 0
%t3462 = icmp ne i512 %t3461, %t3459
%t3463 = icmp slt i64 %t3458, 0
%t3464 = or i1 %t3462, %t3463
%t3465 = zext i1 %t3464 to i8
call void @resid_conv_check(i8 %t3465)
%t3466 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 32, i64 %p2)
%t3467 = extractvalue {i64, i1} %t3466, 0
%t3468 = extractvalue {i64, i1} %t3466, 1
%t3469 = zext i1 %t3468 to i8
call void @resid_overflow_check(i8 %t3469)
%t3470 = sext i64 %t3467 to i512
%t3471 = add i512 %t3470, 0
%t3472 = add i512 %t3471, 0
%t3473 = icmp ne i512 %t3472, %t3470
%t3474 = icmp slt i64 %t3467, 0
%t3475 = or i1 %t3473, %t3474
%t3476 = zext i1 %t3475 to i8
call void @resid_conv_check(i8 %t3476)
%t3477 = icmp uge i512 %t3471, 512
%t3478 = add i512 %t3471, 0
%t3479 = shl i512 %t3460, %t3478
%t3480 = select i1 %t3477, i512 0, i512 %t3479
%t3481 = or i512 %p3, %t3480
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t3487, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi i256 [ %p3.in, %entry ], [ %t3491, %tco.s0.k ]
%t3483 = icmp sge i64 %p1, %p2
br i1 %t3483, label %L415, label %L417
L415:
%t3484 = call ptr @resid_listbuf_new()
%t3485 = call ptr @sha_hw_words__rs181(i256 %p3, i64 0, ptr %t3484)
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %t3485
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %t3485, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L417:
%t3486 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t3487 = extractvalue {i64, i1} %t3486, 0
%t3488 = extractvalue {i64, i1} %t3486, 1
%t3489 = zext i1 %t3488 to i8
call void @resid_overflow_check(i8 %t3489)
%t3490 = call i512 @sha_hw_block(ptr %p0, i64 %p1, i64 0, i512 0)
%t3491 = call i256 @e.sha256(i256 %p3, i512 %t3490)
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t3497, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi i256 [ %p3.in, %entry ], [ %t3501, %tco.s0.k ]
%t3493 = icmp sge i64 %p1, %p2
br i1 %t3493, label %L418, label %L420
L418:
%t3494 = call ptr @resid_listbuf_new()
%t3495 = call ptr @sha_hw_words__rs181(i256 %p3, i64 0, ptr %t3494)
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %t3495
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %t3495, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L420:
%t3496 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t3497 = extractvalue {i64, i1} %t3496, 0
%t3498 = extractvalue {i64, i1} %t3496, 1
%t3499 = zext i1 %t3498 to i8
call void @resid_overflow_check(i8 %t3499)
%t3500 = call i512 @sha_hw_block_str(ptr %p0, i64 %p1, i64 0, i512 0)
%t3501 = call i256 @e.sha256(i256 %p3, i512 %t3500)
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
%t3503 = icmp slt i64 %p0, 10
br i1 %t3503, label %L421, label %L423
L421:
%t3504 = add nsw i64 %p0, 48
%t3505 = musttail call ptr @str_from_code(i64 %t3504)
ret ptr %t3505
L423:
%t3506 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p0, i64 87)
%t3507 = extractvalue {i64, i1} %t3506, 0
%t3508 = extractvalue {i64, i1} %t3506, 1
%t3509 = zext i1 %t3508 to i8
call void @resid_overflow_check(i8 %t3509)
%t3510 = musttail call ptr @str_from_code(i64 %t3507)
ret ptr %t3510
}
define ptr @hex_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3511 = ashr i64 %p0, 4
%t3512 = call ptr @hex_digit(i64 %t3511)
%t3513 = and i64 %p0, 15
%t3514 = call ptr @hex_digit(i64 %t3513)
%t3515 = call ptr @resid_str_concat(ptr %t3512, ptr %t3514)
ret ptr %t3515
}
define ptr @hex_word(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3516 = ashr i64 %p0, 24
%t3517 = call ptr @hex_byte(i64 %t3516)
%t3518 = and i64 %p0, 16711680
%t3519 = ashr i64 %t3518, 16
%t3520 = call ptr @hex_byte(i64 %t3519)
%t3521 = call ptr @resid_str_concat(ptr %t3517, ptr %t3520)
%t3522 = and i64 %p0, 65280
%t3523 = ashr i64 %t3522, 8
%t3524 = call ptr @hex_byte(i64 %t3523)
%t3525 = call ptr @resid_str_concat(ptr %t3521, ptr %t3524)
%t3526 = and i64 %p0, 255
%t3527 = call ptr @hex_byte(i64 %t3526)
%t3528 = call ptr @resid_str_concat(ptr %t3525, ptr %t3527)
ret ptr %t3528
}
define ptr @hex_state(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3535, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t3534, %tco.s0 ]
%t3529 = icmp sge i64 %p1, 8
br i1 %t3529, label %L424, label %L426
L424:
ret ptr %p2
L426:
%t3530 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3531 = call i64 @resid_unbox_i64(ptr %t3530)
%t3533 = call ptr @hex_word(i64 %t3531)
%t3534 = call ptr @resid_str_concat(ptr %p2, ptr %t3533)
%t3535 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @bw_acc_str(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3560 = alloca [1 x ptr]
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3567, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3537 = icmp sge i64 %p2, 16
br i1 %t3537, label %L427, label %L429
L427:
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %p3
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L429:
%t3538 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t3539 = extractvalue {i64, i1} %t3538, 0
%t3540 = extractvalue {i64, i1} %t3538, 1
%t3541 = zext i1 %t3540 to i8
call void @resid_overflow_check(i8 %t3541)
%t3542 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t3539)
%t3543 = extractvalue {i64, i1} %t3542, 0
%t3544 = extractvalue {i64, i1} %t3542, 1
%t3545 = zext i1 %t3544 to i8
call void @resid_overflow_check(i8 %t3545)
%t3546 = call i64 @resid_char_at_n(ptr %p0, i64 %t3543, i64 %p0.alen)
%t3547 = add nsw i64 %t3543, 1
%t3548 = call i64 @resid_char_at_n(ptr %p0, i64 %t3547, i64 %p0.alen)
%t3549 = add nsw i64 %t3543, 2
%t3550 = call i64 @resid_char_at_n(ptr %p0, i64 %t3549, i64 %p0.alen)
%t3551 = add nsw i64 %t3543, 3
%t3552 = call i64 @resid_char_at_n(ptr %p0, i64 %t3551, i64 %p0.alen)
%t3553 = shl i64 %t3546, 24
%t3554 = shl i64 %t3548, 16
%t3555 = shl i64 %t3550, 8
%t3556 = or i64 %t3553, %t3554
%t3557 = or i64 %t3556, %t3555
%t3558 = or i64 %t3557, %t3552
%t3559 = and i64 %t3558, 4294967295
%t3562 = call ptr @resid_box_i64(i64 %t3559)
%t3564 = getelementptr i8, ptr %t3560, i64 0
store ptr %t3562, ptr %t3564
%t3565 = call ptr @resid_list_new(i64 1, ptr %t3560, ptr @.lty3560)
%t3566 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3565)
%t3567 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3566, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3566, %tco.s0 ]
br label %tco.head
}
define i64 @word_at_str(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3569 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t3570 = extractvalue {i64, i1} %t3569, 0
%t3571 = extractvalue {i64, i1} %t3569, 1
%t3572 = zext i1 %t3571 to i8
call void @resid_overflow_check(i8 %t3572)
%t3573 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t3570)
%t3574 = extractvalue {i64, i1} %t3573, 0
%t3575 = extractvalue {i64, i1} %t3573, 1
%t3576 = zext i1 %t3575 to i8
call void @resid_overflow_check(i8 %t3576)
%t3577 = call i64 @str_char_at(ptr %p0, i64 %t3574)
%t3578 = add nsw i64 %t3574, 1
%t3579 = call i64 @str_char_at(ptr %p0, i64 %t3578)
%t3580 = add nsw i64 %t3574, 2
%t3581 = call i64 @str_char_at(ptr %p0, i64 %t3580)
%t3582 = add nsw i64 %t3574, 3
%t3583 = call i64 @str_char_at(ptr %p0, i64 %t3582)
%t3584 = shl i64 %t3577, 24
%t3585 = shl i64 %t3579, 16
%t3586 = shl i64 %t3581, 8
%t3587 = or i64 %t3584, %t3585
%t3588 = or i64 %t3587, %t3586
%t3589 = or i64 %t3588, %t3583
%t3590 = and i64 %t3589, 4294967295
ret i64 %t3590
}
define i64 @ssig0(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3591 = call i64 @rotr(i64 %p0, i64 7)
%t3592 = call i64 @rotr(i64 %p0, i64 18)
%t3593 = ashr i64 %p0, 3
%t3594 = xor i64 %t3591, %t3592
%t3595 = xor i64 %t3594, %t3593
ret i64 %t3595
}
define i64 @ssig1(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3596 = call i64 @rotr(i64 %p0, i64 17)
%t3597 = call i64 @rotr(i64 %p0, i64 19)
%t3598 = ashr i64 %p0, 10
%t3599 = xor i64 %t3596, %t3597
%t3600 = xor i64 %t3599, %t3598
ret i64 %t3600
}
define i64 @bsig0(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3601 = call i64 @rotr(i64 %p0, i64 2)
%t3602 = call i64 @rotr(i64 %p0, i64 13)
%t3603 = call i64 @rotr(i64 %p0, i64 22)
%t3604 = xor i64 %t3601, %t3602
%t3605 = xor i64 %t3604, %t3603
ret i64 %t3605
}
define i64 @bsig1(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3606 = call i64 @rotr(i64 %p0, i64 6)
%t3607 = call i64 @rotr(i64 %p0, i64 11)
%t3608 = call i64 @rotr(i64 %p0, i64 25)
%t3609 = xor i64 %t3606, %t3607
%t3610 = xor i64 %t3609, %t3608
ret i64 %t3610
}
define i64 @maj_of(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3611 = and i64 %p0, %p1
%t3612 = and i64 %p0, %p2
%t3613 = and i64 %p1, %p2
%t3614 = xor i64 %t3611, %t3612
%t3615 = xor i64 %t3614, %t3613
ret i64 %t3615
}
define i64 @sched_w(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3616 = icmp slt i64 %p2, 16
br i1 %t3616, label %L430, label %L432
L430:
%t3617 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 %p2)
ret i64 %t3617
L432:
%t3618 = call i64 @ssig1(i64 %p6)
%t3619 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3618, i64 %p5)
%t3620 = extractvalue {i64, i1} %t3619, 0
%t3621 = extractvalue {i64, i1} %t3619, 1
%t3622 = zext i1 %t3621 to i8
call void @resid_overflow_check(i8 %t3622)
%t3623 = call i64 @ssig0(i64 %p4)
%t3624 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3623, i64 %p3)
%t3625 = extractvalue {i64, i1} %t3624, 0
%t3626 = extractvalue {i64, i1} %t3624, 1
%t3627 = zext i1 %t3626 to i8
call void @resid_overflow_check(i8 %t3627)
%t3628 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3620, i64 %t3625)
%t3629 = extractvalue {i64, i1} %t3628, 0
%t3630 = extractvalue {i64, i1} %t3628, 1
%t3631 = zext i1 %t3630 to i8
call void @resid_overflow_check(i8 %t3631)
%t3632 = and i64 %t3629, 4294967295
ret i64 %t3632
}
define ptr @sha_blk(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in, i64 %p19.in, i64 %p20.in, i64 %p21.in, i64 %p22.in, i64 %p23.in, i64 %p24.in, i64 %p25.in, i64 %p26.in, i64 %p27.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3698 = alloca [8 x ptr]
%p3.ld = call ptr @resid_list_vdata(ptr %p3.in)
%p3.ln = call i64 @resid_list_vlen(ptr %p3.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3761, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t3755, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t3760, %tco.s0.k ]
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
%p27 = phi i64 [ %p27.in, %entry ], [ %t3725, %tco.s0.k ]
%t3633 = icmp sge i64 %p2, 64
br i1 %t3633, label %L433, label %L435
L433:
%t3634 = call ptr @resid_list_get_v(ptr %p3, i64 0, ptr %p3.ld, i64 %p3.ln)
%t3635 = call i64 @resid_unbox_i64(ptr %t3634)
%t3637 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3635, i64 %p4)
%t3638 = extractvalue {i64, i1} %t3637, 0
%t3639 = extractvalue {i64, i1} %t3637, 1
%t3640 = zext i1 %t3639 to i8
call void @resid_overflow_check(i8 %t3640)
%t3641 = and i64 %t3638, 4294967295
%t3642 = call ptr @resid_list_get_v(ptr %p3, i64 1, ptr %p3.ld, i64 %p3.ln)
%t3643 = call i64 @resid_unbox_i64(ptr %t3642)
%t3645 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3643, i64 %p5)
%t3646 = extractvalue {i64, i1} %t3645, 0
%t3647 = extractvalue {i64, i1} %t3645, 1
%t3648 = zext i1 %t3647 to i8
call void @resid_overflow_check(i8 %t3648)
%t3649 = and i64 %t3646, 4294967295
%t3650 = call ptr @resid_list_get_v(ptr %p3, i64 2, ptr %p3.ld, i64 %p3.ln)
%t3651 = call i64 @resid_unbox_i64(ptr %t3650)
%t3653 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3651, i64 %p6)
%t3654 = extractvalue {i64, i1} %t3653, 0
%t3655 = extractvalue {i64, i1} %t3653, 1
%t3656 = zext i1 %t3655 to i8
call void @resid_overflow_check(i8 %t3656)
%t3657 = and i64 %t3654, 4294967295
%t3658 = call ptr @resid_list_get_v(ptr %p3, i64 3, ptr %p3.ld, i64 %p3.ln)
%t3659 = call i64 @resid_unbox_i64(ptr %t3658)
%t3661 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3659, i64 %p7)
%t3662 = extractvalue {i64, i1} %t3661, 0
%t3663 = extractvalue {i64, i1} %t3661, 1
%t3664 = zext i1 %t3663 to i8
call void @resid_overflow_check(i8 %t3664)
%t3665 = and i64 %t3662, 4294967295
%t3666 = call ptr @resid_list_get_v(ptr %p3, i64 4, ptr %p3.ld, i64 %p3.ln)
%t3667 = call i64 @resid_unbox_i64(ptr %t3666)
%t3669 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3667, i64 %p8)
%t3670 = extractvalue {i64, i1} %t3669, 0
%t3671 = extractvalue {i64, i1} %t3669, 1
%t3672 = zext i1 %t3671 to i8
call void @resid_overflow_check(i8 %t3672)
%t3673 = and i64 %t3670, 4294967295
%t3674 = call ptr @resid_list_get_v(ptr %p3, i64 5, ptr %p3.ld, i64 %p3.ln)
%t3675 = call i64 @resid_unbox_i64(ptr %t3674)
%t3677 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3675, i64 %p9)
%t3678 = extractvalue {i64, i1} %t3677, 0
%t3679 = extractvalue {i64, i1} %t3677, 1
%t3680 = zext i1 %t3679 to i8
call void @resid_overflow_check(i8 %t3680)
%t3681 = and i64 %t3678, 4294967295
%t3682 = call ptr @resid_list_get_v(ptr %p3, i64 6, ptr %p3.ld, i64 %p3.ln)
%t3683 = call i64 @resid_unbox_i64(ptr %t3682)
%t3685 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3683, i64 %p10)
%t3686 = extractvalue {i64, i1} %t3685, 0
%t3687 = extractvalue {i64, i1} %t3685, 1
%t3688 = zext i1 %t3687 to i8
call void @resid_overflow_check(i8 %t3688)
%t3689 = and i64 %t3686, 4294967295
%t3690 = call ptr @resid_list_get_v(ptr %p3, i64 7, ptr %p3.ld, i64 %p3.ln)
%t3691 = call i64 @resid_unbox_i64(ptr %t3690)
%t3693 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3691, i64 %p11)
%t3694 = extractvalue {i64, i1} %t3693, 0
%t3695 = extractvalue {i64, i1} %t3693, 1
%t3696 = zext i1 %t3695 to i8
call void @resid_overflow_check(i8 %t3696)
%t3697 = and i64 %t3694, 4294967295
%t3700 = call ptr @resid_box_i64(i64 %t3641)
%t3702 = getelementptr i8, ptr %t3698, i64 0
store ptr %t3700, ptr %t3702
%t3703 = call ptr @resid_box_i64(i64 %t3649)
%t3705 = getelementptr i8, ptr %t3698, i64 8
store ptr %t3703, ptr %t3705
%t3706 = call ptr @resid_box_i64(i64 %t3657)
%t3708 = getelementptr i8, ptr %t3698, i64 16
store ptr %t3706, ptr %t3708
%t3709 = call ptr @resid_box_i64(i64 %t3665)
%t3711 = getelementptr i8, ptr %t3698, i64 24
store ptr %t3709, ptr %t3711
%t3712 = call ptr @resid_box_i64(i64 %t3673)
%t3714 = getelementptr i8, ptr %t3698, i64 32
store ptr %t3712, ptr %t3714
%t3715 = call ptr @resid_box_i64(i64 %t3681)
%t3717 = getelementptr i8, ptr %t3698, i64 40
store ptr %t3715, ptr %t3717
%t3718 = call ptr @resid_box_i64(i64 %t3689)
%t3720 = getelementptr i8, ptr %t3698, i64 48
store ptr %t3718, ptr %t3720
%t3721 = call ptr @resid_box_i64(i64 %t3697)
%t3723 = getelementptr i8, ptr %t3698, i64 56
store ptr %t3721, ptr %t3723
%t3724 = call ptr @resid_list_new(i64 8, ptr %t3698, ptr @.lty3698)
%lr.cx127 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz127 = icmp eq ptr %lr.cx127, null
br i1 %lr.lz127, label %lr.x127.k, label %lr.x127.m
lr.x127.k:
ret ptr %t3724
lr.x127.m:
%lr.ret127 = call ptr @resid_mv_list(ptr %t3724, ptr %lr.cx127)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret127
L435:
%t3725 = call i64 @sched_w(ptr %p0, i64 %p1, i64 %p2, i64 %p12, i64 %p13, i64 %p21, i64 %p26)
%t3726 = call i64 @bsig1(i64 %p8)
%t3727 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t3726)
%t3728 = extractvalue {i64, i1} %t3727, 0
%t3729 = extractvalue {i64, i1} %t3727, 1
%t3730 = zext i1 %t3729 to i8
call void @resid_overflow_check(i8 %t3730)
%t3731 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t3732 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3728, i64 %t3731)
%t3733 = extractvalue {i64, i1} %t3732, 0
%t3734 = extractvalue {i64, i1} %t3732, 1
%t3735 = zext i1 %t3734 to i8
call void @resid_overflow_check(i8 %t3735)
%t3736 = call i64 @resid_scope_push()
%t3737 = call i64 @k_at(i64 %p2)
%t3738 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3733, i64 %t3737)
%t3739 = extractvalue {i64, i1} %t3738, 0
%t3740 = extractvalue {i64, i1} %t3738, 1
%t3741 = zext i1 %t3740 to i8
call void @resid_overflow_check(i8 %t3741)
call void @resid_scope_pop(i64 %t3736)
%t3742 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3739, i64 %t3725)
%t3743 = extractvalue {i64, i1} %t3742, 0
%t3744 = extractvalue {i64, i1} %t3742, 1
%t3745 = zext i1 %t3744 to i8
call void @resid_overflow_check(i8 %t3745)
%t3746 = and i64 %t3743, 4294967295
%t3747 = call i64 @bsig0(i64 %p4)
%t3748 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t3749 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t3747, i64 %t3748)
%t3750 = extractvalue {i64, i1} %t3749, 0
%t3751 = extractvalue {i64, i1} %t3749, 1
%t3752 = zext i1 %t3751 to i8
call void @resid_overflow_check(i8 %t3752)
%t3753 = and i64 %t3750, 4294967295
%t3754 = add nsw i64 %t3746, %t3753
%t3755 = and i64 %t3754, 4294967295
%t3756 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t3746)
%t3757 = extractvalue {i64, i1} %t3756, 0
%t3758 = extractvalue {i64, i1} %t3756, 1
%t3759 = zext i1 %t3758 to i8
call void @resid_overflow_check(i8 %t3759)
%t3760 = and i64 %t3757, 4294967295
%t3761 = add nsw i64 %p2, 1
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
%t3763 = call ptr @resid_list_get(ptr %p2, i64 0)
%t3764 = call i64 @resid_unbox_i64(ptr %t3763)
%t3766 = call ptr @resid_list_get(ptr %p2, i64 1)
%t3767 = call i64 @resid_unbox_i64(ptr %t3766)
%t3769 = call ptr @resid_list_get(ptr %p2, i64 2)
%t3770 = call i64 @resid_unbox_i64(ptr %t3769)
%t3772 = call ptr @resid_list_get(ptr %p2, i64 3)
%t3773 = call i64 @resid_unbox_i64(ptr %t3772)
%t3775 = call ptr @resid_list_get(ptr %p2, i64 4)
%t3776 = call i64 @resid_unbox_i64(ptr %t3775)
%t3778 = call ptr @resid_list_get(ptr %p2, i64 5)
%t3779 = call i64 @resid_unbox_i64(ptr %t3778)
%t3781 = call ptr @resid_list_get(ptr %p2, i64 6)
%t3782 = call i64 @resid_unbox_i64(ptr %t3781)
%t3784 = call ptr @resid_list_get(ptr %p2, i64 7)
%t3785 = call i64 @resid_unbox_i64(ptr %t3784)
%t3787 = call ptr @sha_blk__rs190(ptr %p0, i64 %p1, i64 0, ptr %p2, i64 %t3764, i64 %t3767, i64 %t3770, i64 %t3773, i64 %t3776, i64 %t3779, i64 %t3782, i64 %t3785, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret ptr %t3787
}
define ptr @digest_blocks_str(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3795, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3788 = icmp sge i64 %p1, %p2
br i1 %t3788, label %L436, label %L438
L436:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L438:
%t3789 = call i8 @resid_cpu_has_sha256()
%t3790 = icmp ne i8 %t3789, 0
br i1 %t3790, label %L439, label %L441
L439:
%t3791 = call i256 @sha_hw_state(ptr %p3, i64 0, i256 0)
%t3792 = call ptr @sha_hw_blocks_str(ptr %p0, i64 %p1, i64 %p2, i256 %t3791)
%lr.cx19 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz19 = icmp eq ptr %lr.cx19, null
br i1 %lr.lz19, label %lr.x19.k, label %lr.x19.m
lr.x19.k:
ret ptr %t3792
lr.x19.m:
%lr.ret19 = call ptr @resid_mv_list(ptr %t3792, ptr %lr.cx19)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret19
L441:
%t3793 = call ptr @digest_block_str(ptr %p0, i64 %p1, ptr %p3)
%t3794 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t3795 = extractvalue {i64, i1} %t3794, 0
%t3796 = extractvalue {i64, i1} %t3794, 1
%t3797 = zext i1 %t3796 to i8
call void @resid_overflow_check(i8 %t3797)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3793, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3793, %tco.s0 ]
br label %tco.head
}
define ptr @str_bytes_range(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3801 = alloca [1 x ptr]
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3808, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3799 = icmp sge i64 %p1, %p2
br i1 %t3799, label %L442, label %L444
L442:
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %p3
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L444:
%t3800 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t3803 = call ptr @resid_box_i64(i64 %t3800)
%t3805 = getelementptr i8, ptr %t3801, i64 0
store ptr %t3803, ptr %t3805
%t3806 = call ptr @resid_list_new(i64 1, ptr %t3801, ptr @.lty3801)
%t3807 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3806)
%t3808 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3807, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3807, %tco.s0 ]
br label %tco.head
}
define ptr @pad_tail(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3810 = call i64 @resid_list_len(ptr %p0)
%t3812 = call ptr @resid_list_const_i64(ptr @.lc3811, i64 1, ptr @.lcd3811, ptr @.lty3811)
%t3813 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t3812)
%t3814 = add nsw i64 %t3810, 9
%t3815 = add nsw i64 %t3814, 63
%t3816 = sdiv i64 %t3815, 64
%t3817 = mul nsw i64 %t3816, 64
%t3818 = sub nsw i64 %t3817, %t3814
%t3819 = call ptr @zeros_l(ptr %t3813, i64 %t3818)
%t3820 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t3821 = extractvalue {i64, i1} %t3820, 0
%t3822 = extractvalue {i64, i1} %t3820, 1
%t3823 = zext i1 %t3822 to i8
call void @resid_overflow_check(i8 %t3823)
%t3824 = call ptr @length_bytes__rs153(i64 %t3821, i64 7, ptr %t3819)
ret ptr %t3824
}
define ptr @sha256(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3825 = call i1 @str_is_ascii(ptr %p0, i64 0)
%t3826 = xor i1 %t3825, true
br i1 %t3826, label %L445, label %L447
L445:
%t3827 = call ptr @bytes_of(ptr %p0)
%t3828 = call ptr @sha256_bytes(ptr %t3827)
%t3829 = musttail call ptr @hex_encode(ptr %t3828)
ret ptr %t3829
L447:
%t3830 = musttail call ptr @__m____________lib_crypto_resid__sha256_ascii(ptr %p0)
ret ptr %t3830
}
define ptr @__m____________lib_crypto_resid__sha256_ascii(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3831 = call i64 @str_len(ptr %p0)
%t3832 = sdiv i64 %t3831, 64
%t3833 = mul nsw i64 %t3832, 64
%t3835 = call ptr @resid_list_const_i64(ptr @.lc3834, i64 8, ptr @.lcd3834, ptr @.lty3834)
%t3836 = call ptr @digest_blocks_str(ptr %p0, i64 0, i64 %t3833, ptr %t3835)
%t3838 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3837)
%t3839 = call ptr @str_bytes_range(ptr %p0, i64 %t3833, i64 %t3831, ptr %t3838)
%t3840 = call ptr @pad_tail(ptr %t3839, i64 %t3831)
%t3841 = call i64 @resid_list_len(ptr %t3840)
%t3842 = call ptr @digest_blocks(ptr %t3840, i64 0, i64 %t3841, ptr %t3836)
%t3844 = call ptr @hex_state__rs234(ptr %t3842, i64 0, ptr @.s3843)
ret ptr %t3844
}
define i64 @word_byte(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3845 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 3, i64 %p2)
%t3846 = extractvalue {i64, i1} %t3845, 0
%t3847 = extractvalue {i64, i1} %t3845, 1
%t3848 = zext i1 %t3847 to i8
call void @resid_overflow_check(i8 %t3848)
%t3849 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t3846, i64 8)
%t3850 = extractvalue {i64, i1} %t3849, 0
%t3851 = extractvalue {i64, i1} %t3849, 1
%t3852 = zext i1 %t3851 to i8
call void @resid_overflow_check(i8 %t3852)
%t3853 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t3854 = call i64 @resid_unbox_i64(ptr %t3853)
%t3856 = icmp uge i64 %t3850, 64
%t3857 = add i64 %t3850, 0
%t3858 = select i1 %t3856, i64 63, i64 %t3857
%t3859 = ashr i64 %t3854, %t3858
%t3860 = and i64 %t3859, 255
ret i64 %t3860
}
define ptr @wtb_inner(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3863 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3870, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3861 = icmp sgt i64 %p2, 3
br i1 %t3861, label %L448, label %L450
L448:
%lr.cx12 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz12 = icmp eq ptr %lr.cx12, null
br i1 %lr.lz12, label %lr.x12.k, label %lr.x12.m
lr.x12.k:
ret ptr %p3
lr.x12.m:
%lr.ret12 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx12)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret12
L450:
%t3862 = call i64 @word_byte(ptr %p0, i64 %p1, i64 %p2)
%t3865 = call ptr @resid_box_i64(i64 %t3862)
%t3867 = getelementptr i8, ptr %t3863, i64 0
store ptr %t3865, ptr %t3867
%t3868 = call ptr @resid_list_new(i64 1, ptr %t3863, ptr @.lty3863)
%t3869 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3868)
%t3870 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3869, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3869, %tco.s0 ]
br label %tco.head
}
define ptr @wtb_outer(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3874, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t3872 = icmp sgt i64 %p1, 7
br i1 %t3872, label %L451, label %L453
L451:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p2
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L453:
%t3873 = call ptr @wtb_inner__rs236(ptr %p0, i64 %p1, i64 0, ptr %p2)
%t3874 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t3873, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t3873, %tco.s0 ]
br label %tco.head
}
define ptr @words_to_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3877 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3876)
%t3878 = call ptr @wtb_outer__rs238(ptr %p0, i64 0, ptr %t3877)
ret ptr %t3878
}
define ptr @sha256_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3879 = call i64 @resid_list_len(ptr %p0)
%t3880 = sdiv i64 %t3879, 64
%t3881 = mul nsw i64 %t3880, 64
%t3883 = call ptr @resid_list_const_i64(ptr @.lc3882, i64 8, ptr @.lcd3882, ptr @.lty3882)
%t3884 = call ptr @digest_blocks(ptr %p0, i64 0, i64 %t3881, ptr %t3883)
%t3885 = call i64 @resid_list_len(ptr %p0)
%t3886 = call ptr @resid_list_slice(ptr %p0, i64 %t3881, i64 %t3885)
%t3888 = call ptr @pad_tail(ptr %t3886, i64 %t3879)
%t3889 = call i64 @resid_list_len(ptr %t3888)
%t3890 = call ptr @digest_blocks(ptr %t3888, i64 0, i64 %t3889, ptr %t3884)
%t3891 = musttail call ptr @words_to_bytes(ptr %t3890)
ret ptr %t3891
}
define ptr @hex_range(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3898, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t3897, %tco.s0 ]
%t3892 = icmp sge i64 %p1, %p2
br i1 %t3892, label %L454, label %L456
L454:
ret ptr %p3
L456:
%t3893 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3894 = call i64 @resid_unbox_i64(ptr %t3893)
%t3896 = call ptr @hex_byte(i64 %t3894)
%t3897 = call ptr @resid_str_concat(ptr %p3, ptr %t3896)
%t3898 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @hex_encode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3900 = call i64 @resid_list_len(ptr %p0)
%t3902 = call ptr @hex_range(ptr %p0, i64 0, i64 %t3900, ptr @.s3901)
ret ptr %t3902
}
define ptr @__m____________lib_crypto_resid__sc_acc(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3908 = alloca [1 x ptr]
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3915, %tco.s0.k ]
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
%t3905 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t3906 = call i64 @resid_unbox_i64(ptr %t3905)
%t3910 = call ptr @resid_box_i64(i64 %t3906)
%t3912 = getelementptr i8, ptr %t3908, i64 0
store ptr %t3910, ptr %t3912
%t3913 = call ptr @resid_list_new(i64 1, ptr %t3908, ptr @.lty3908)
%t3914 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3913)
%t3915 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3914, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3914, %tco.s0 ]
br label %tco.head
}
define ptr @sconcat(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3917 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %p1)
ret ptr %t3917
}
define i64 @byte_at_or0(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3918 = call i64 @resid_list_len(ptr %p0)
%t3919 = icmp slt i64 %p1, %t3918
br i1 %t3919, label %L460, label %L462
L460:
%t3920 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t3921 = call i64 @resid_unbox_i64(ptr %t3920)
ret i64 %t3921
L462:
ret i64 0
}
define ptr @xor_lists(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3931 = alloca [1 x ptr]
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t3938, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t3923 = call i64 @resid_list_len(ptr %p1)
%t3924 = icmp sge i64 %p2, %t3923
br i1 %t3924, label %L463, label %L465
L463:
%lr.cx15 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz15 = icmp eq ptr %lr.cx15, null
br i1 %lr.lz15, label %lr.x15.k, label %lr.x15.m
lr.x15.k:
ret ptr %p3
lr.x15.m:
%lr.ret15 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx15)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret15
L465:
%t3925 = call i64 @byte_at_or0(ptr %p0, i64 %p2)
%t3926 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t3927 = call i64 @resid_unbox_i64(ptr %t3926)
%t3929 = xor i64 %t3925, %t3927
%t3930 = and i64 %t3929, 255
%t3933 = call ptr @resid_box_i64(i64 %t3930)
%t3935 = getelementptr i8, ptr %t3931, i64 0
store ptr %t3933, ptr %t3935
%t3936 = call ptr @resid_list_new(i64 1, ptr %t3931, ptr @.lty3931)
%t3937 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t3936)
%t3938 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t3937, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t3937, %tco.s0 ]
br label %tco.head
}
define ptr @key_block(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3940 = call i64 @resid_list_len(ptr %p0)
%t3941 = icmp sgt i64 %t3940, 64
br i1 %t3941, label %L466, label %L468
L466:
%t3942 = call ptr @sha256_bytes(ptr %p0)
%t3943 = call i64 @resid_list_len(ptr %t3942)
%t3944 = sub nsw i64 64, %t3943
%t3946 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3945)
%t3947 = call ptr @zeros_l(ptr %t3946, i64 %t3944)
%t3948 = call ptr @resid_list_freeze(ptr %t3947)
%t3949 = call ptr @sconcat(ptr %t3942, ptr %t3948)
ret ptr %t3949
L468:
%t3950 = sub nsw i64 64, %t3940
%t3952 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3951)
%t3953 = call ptr @zeros_l(ptr %t3952, i64 %t3950)
%t3954 = call ptr @resid_list_freeze(ptr %t3953)
%t3955 = call ptr @sconcat(ptr %p0, ptr %t3954)
ret ptr %t3955
}
define ptr @map_ipad(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3963 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3970, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t3956 = call i64 @resid_list_len(ptr %p0)
%t3957 = icmp sge i64 %p1, %t3956
br i1 %t3957, label %L469, label %L471
L469:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p2
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L471:
%t3958 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3959 = call i64 @resid_unbox_i64(ptr %t3958)
%t3961 = xor i64 %t3959, 54
%t3962 = and i64 %t3961, 255
%t3965 = call ptr @resid_box_i64(i64 %t3962)
%t3967 = getelementptr i8, ptr %t3963, i64 0
store ptr %t3965, ptr %t3967
%t3968 = call ptr @resid_list_new(i64 1, ptr %t3963, ptr @.lty3963)
%t3969 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t3968)
%t3970 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t3969, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t3969, %tco.s0 ]
br label %tco.head
}
define ptr @map_opad(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3979 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t3986, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t3972 = call i64 @resid_list_len(ptr %p0)
%t3973 = icmp sge i64 %p1, %t3972
br i1 %t3973, label %L472, label %L474
L472:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p2
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L474:
%t3974 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t3975 = call i64 @resid_unbox_i64(ptr %t3974)
%t3977 = xor i64 %t3975, 92
%t3978 = and i64 %t3977, 255
%t3981 = call ptr @resid_box_i64(i64 %t3978)
%t3983 = getelementptr i8, ptr %t3979, i64 0
store ptr %t3981, ptr %t3983
%t3984 = call ptr @resid_list_new(i64 1, ptr %t3979, ptr @.lty3979)
%t3985 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t3984)
%t3986 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t3985, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t3985, %tco.s0 ]
br label %tco.head
}
define ptr @hmac_sha256_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t3988 = call ptr @key_block(ptr %p0)
%t3990 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3989)
%t3991 = call ptr @map_ipad(ptr %t3988, i64 0, ptr %t3990)
%t3993 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty3992)
%t3994 = call ptr @map_opad(ptr %t3988, i64 0, ptr %t3993)
%t3995 = call ptr @sconcat(ptr %t3991, ptr %p1)
%t3996 = call ptr @sha256_bytes(ptr %t3995)
%t3997 = call ptr @resid_list_freeze(ptr %t3996)
%t3998 = call ptr @sconcat(ptr %t3994, ptr %t3997)
%t3999 = call ptr @sha256_bytes(ptr %t3998)
ret ptr %t3999
}
define i1 @ct_equal(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4004 = alloca [24 x i8], align 16 ; fixed
%t4005 = alloca [48 x i8], align 16 ; fixed
%t4000 = call i64 @resid_list_len(ptr %p0)
%t4001 = call i64 @resid_list_len(ptr %p1)
%t4002 = icmp ne i64 %t4000, %t4001
br i1 %t4002, label %L475, label %L477
L475:
ret i1 false
L477:
%t4003 = call i64 @ct_acc(ptr %p0, ptr %p1, i64 0, i64 0)
store i64 %t4003, ptr %t4004
%t4006 = ptrtoint ptr %t4004 to i64
store i64 1296236546, ptr %t4005
%t4007 = getelementptr i64, ptr %t4005, i64 1
store i64 %t4006, ptr %t4007
%t4008 = getelementptr i64, ptr %t4005, i64 2
store i64 8, ptr %t4008
%t4009 = getelementptr i64, ptr %t4005, i64 3
store i64 0, ptr %t4009
%t4010 = getelementptr i64, ptr %t4005, i64 4
store i64 0, ptr %t4010
%t4011 = getelementptr i64, ptr %t4005, i64 5
store i64 0, ptr %t4011
%t4012 = call i64 asm sideeffect "rolq $$3, %rdi ; rolq $$13, %rdi ; rolq $$61, %rdi ; rolq $$51, %rdi ; xchgq %rbx, %rbx", "={dx},{ax},0,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(ptr %t4005, i64 0)
%t4013 = load i64, ptr %t4004
%t4014 = icmp eq i64 %t4013, 0
ret i1 %t4014
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4025, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t4024, %tco.s0 ]
%t4015 = call i64 @resid_list_len(ptr %p0)
%t4016 = icmp sge i64 %p2, %t4015
br i1 %t4016, label %L478, label %L480
L478:
ret i64 %p3
L480:
%t4017 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t4018 = call i64 @resid_unbox_i64(ptr %t4017)
%t4020 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t4021 = call i64 @resid_unbox_i64(ptr %t4020)
%t4023 = xor i64 %t4018, %t4021
%t4024 = or i64 %p3, %t4023
%t4025 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @ct_eq(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
call void @resid_cap_check(ptr @.declassify.cap)
%t4044 = alloca [20 x i8], align 16 ; fixed
%t4045 = alloca [48 x i8], align 16 ; fixed
%t4027 = call i64 @resid_list_len(ptr %p0)
%t4028 = call i64 @resid_list_len(ptr %p1)
%t4029 = icmp ne i64 %t4027, %t4028
br i1 %t4029, label %L481, label %L483
L481:
ret i1 false
L483:
%t4030 = call i64 @resid_list_len(ptr %p0)
%t4031 = icmp eq i64 %t4030, 0
br i1 %t4031, label %L484, label %L486
L484:
ret i1 true
L486:
%t4032 = call ptr @resid_list_get(ptr %p0, i64 0)
%t4034 = call i64 @resid_unbox_i64(ptr %t4032)
%t4033 = trunc i64 %t4034 to i8
%t4035 = call ptr @resid_list_get(ptr %p1, i64 0)
%t4037 = call i64 @resid_unbox_i64(ptr %t4035)
%t4036 = trunc i64 %t4037 to i8
%t4038 = xor i8 %t4033, %t4036
%t4039 = call i8 @__m____________lib_crypto_resid__ct_eq_acc(ptr %p0, ptr %p1, i64 1, i8 %t4038)
%t4040 = zext i8 %t4039 to i32
%t4041 = sub i32 0, %t4040
%t4042 = or i32 %t4040, %t4041
%t4043 = lshr i32 %t4042, 31
store i32 %t4043, ptr %t4044
%t4046 = ptrtoint ptr %t4044 to i64
store i64 1296236546, ptr %t4045
%t4047 = getelementptr i64, ptr %t4045, i64 1
store i64 %t4046, ptr %t4047
%t4048 = getelementptr i64, ptr %t4045, i64 2
store i64 4, ptr %t4048
%t4049 = getelementptr i64, ptr %t4045, i64 3
store i64 0, ptr %t4049
%t4050 = getelementptr i64, ptr %t4045, i64 4
store i64 0, ptr %t4050
%t4051 = getelementptr i64, ptr %t4045, i64 5
store i64 0, ptr %t4051
%t4052 = call i64 asm sideeffect "rolq $$3, %rdi ; rolq $$13, %rdi ; rolq $$61, %rdi ; rolq $$51, %rdi ; xchgq %rbx, %rbx", "={dx},{ax},0,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(ptr %t4045, i64 0)
%t4053 = load i32, ptr %t4044
%t4054 = icmp eq i32 %t4053, 0
ret i1 %t4054
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4057, %tco.s0 ]
%p3 = phi i8 [ %p3.in, %entry ], [ %t4065, %tco.s0 ]
%t4055 = call i64 @resid_list_len(ptr %p0)
%t4056 = icmp sge i64 %p2, %t4055
br i1 %t4056, label %L487, label %L489
L487:
ret i8 %p3
L489:
%t4057 = add nsw i64 %p2, 1
%t4058 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t4060 = call i64 @resid_unbox_i64(ptr %t4058)
%t4059 = trunc i64 %t4060 to i8
%t4061 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t4063 = call i64 @resid_unbox_i64(ptr %t4061)
%t4062 = trunc i64 %t4063 to i8
%t4064 = xor i8 %t4059, %t4062
%t4065 = or i8 %p3, %t4064
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @__m____________lib_crypto_resid__ct_same_pub(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4067 = musttail call i1 @ct_equal(ptr %p0, ptr %p1)
ret i1 %t4067
}
define i1 @__m____________lib_crypto_resid__ct_same_secret(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4068 = musttail call i1 @ct_eq(ptr %p0, ptr %p1)
ret i1 %t4068
}
define ptr @b64_char(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4069 = icmp slt i64 %p0, 26
br i1 %t4069, label %L490, label %L492
L490:
%t4070 = add nsw i64 %p0, 65
%t4071 = musttail call ptr @str_from_code(i64 %t4070)
ret ptr %t4071
L492:
%t4072 = icmp slt i64 %p0, 52
br i1 %t4072, label %L493, label %L495
L493:
%t4073 = add nsw i64 %p0, 71
%t4074 = musttail call ptr @str_from_code(i64 %t4073)
ret ptr %t4074
L495:
%t4075 = icmp slt i64 %p0, 62
br i1 %t4075, label %L496, label %L498
L496:
%t4076 = sub nsw i64 %p0, 4
%t4077 = musttail call ptr @str_from_code(i64 %t4076)
ret ptr %t4077
L498:
%t4078 = icmp eq i64 %p0, 62
br i1 %t4078, label %L499, label %L501
L499:
ret ptr @.s4079
L501:
ret ptr @.s4080
}
define ptr @base64_encode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4081 = call i64 @resid_list_len(ptr %p0)
%t4082x = insertvalue {ptr,ptr} zeroinitializer, ptr null, 0
%t4082 = insertvalue {ptr,ptr} %t4082x, ptr null, 1
%t4083 = call {ptr,ptr} @b64_enc(ptr %p0, i64 0, i64 %t4081, {ptr,ptr} %t4082)
%t4084b = extractvalue {ptr,ptr} %t4083, 0
%t4084l = extractvalue {ptr,ptr} %t4083, 1
%t4084 = call ptr @resid_sb2_finish(ptr %t4084b, ptr %t4084l)
ret ptr %t4084
}
define i64 @__m____________lib_crypto_resid__b64_code(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4085 = icmp slt i64 %p0, 26
br i1 %t4085, label %L502, label %L504
L502:
%t4086 = add nsw i64 %p0, 65
ret i64 %t4086
L504:
%t4087 = icmp slt i64 %p0, 52
br i1 %t4087, label %L505, label %L507
L505:
%t4088 = add nsw i64 %p0, 71
ret i64 %t4088
L507:
%t4089 = icmp slt i64 %p0, 62
br i1 %t4089, label %L508, label %L510
L508:
%t4090 = sub nsw i64 %p0, 4
ret i64 %t4090
L510:
%t4091 = icmp eq i64 %p0, 62
br i1 %t4091, label %L511, label %L512
L511:
br label %L513
L512:
br label %L513
L513:
%t4092 = phi i64 [ 43, %L511 ], [ 47, %L512 ]
ret i64 %t4092
}
define {ptr,ptr} @b64_enc(ptr %p0.in, i64 %p1.in, i64 %p2.in, {ptr,ptr} %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4140, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi {ptr,ptr} [ %p3.in, %entry ], [ %t4138, %tco.s0 ]
%t4093 = icmp sge i64 %p1, %p2
br i1 %t4093, label %L514, label %L516
L514:
ret {ptr,ptr} %p3
L516:
%t4094 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 %p1)
%t4095 = extractvalue {i64, i1} %t4094, 0
%t4096 = extractvalue {i64, i1} %t4094, 1
%t4097 = zext i1 %t4096 to i8
call void @resid_overflow_check(i8 %t4097)
%t4098 = icmp sgt i64 %t4095, 1
br i1 %t4098, label %L517, label %L518
L517:
%t4099 = add nsw i64 %p1, 1
%t4100 = call ptr @resid_list_get_v(ptr %p0, i64 %t4099, ptr %p0.ld, i64 %p0.ln)
%t4101 = call i64 @resid_unbox_i64(ptr %t4100)
br label %L519
L518:
br label %L519
L519:
%t4103 = phi i64 [ %t4101, %L517 ], [ 0, %L518 ]
%t4104 = icmp sgt i64 %t4095, 2
br i1 %t4104, label %L520, label %L521
L520:
%t4105 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t4106 = extractvalue {i64, i1} %t4105, 0
%t4107 = extractvalue {i64, i1} %t4105, 1
%t4108 = zext i1 %t4107 to i8
call void @resid_overflow_check(i8 %t4108)
%t4109 = call ptr @resid_list_get_v(ptr %p0, i64 %t4106, ptr %p0.ld, i64 %p0.ln)
%t4110 = call i64 @resid_unbox_i64(ptr %t4109)
br label %L522
L521:
br label %L522
L522:
%t4112 = phi i64 [ %t4110, %L520 ], [ 0, %L521 ]
%t4113 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t4114 = call i64 @resid_unbox_i64(ptr %t4113)
%t4116 = shl i64 %t4114, 16
%t4117 = shl i64 %t4103, 8
%t4118 = or i64 %t4116, %t4117
%t4119 = or i64 %t4118, %t4112
%t4120 = ashr i64 %t4119, 18
%t4121 = and i64 %t4120, 63
%t4122 = call i64 @__m____________lib_crypto_resid__b64_code(i64 %t4121)
%t4123b = extractvalue {ptr,ptr} %p3, 0
%t4123l = extractvalue {ptr,ptr} %p3, 1
%t4123a = icmp ult i64 %t4122, 128
%t4123r = icmp ult ptr %t4123b, %t4123l
%t4123k = and i1 %t4123a, %t4123r
br i1 %t4123k, label %L523, label %L524
L523:
%t4123v = trunc i64 %t4122 to i8
store i8 %t4123v, ptr %t4123b, align 1
%t4123q = getelementptr i8, ptr %t4123b, i64 1
%t4123f = insertvalue {ptr,ptr} %p3, ptr %t4123q, 0
br label %L525
L524:
%t4123nb = call ptr @resid_sb2_push_cp(ptr %t4123b, ptr %t4123l, i64 %t4122)
%t4123nl = call ptr @resid_sb2_lim()
%t4123sx = insertvalue {ptr,ptr} zeroinitializer, ptr %t4123nb, 0
%t4123s = insertvalue {ptr,ptr} %t4123sx, ptr %t4123nl, 1
br label %L525
L525:
%t4123 = phi {ptr,ptr} [ %t4123f, %L523 ], [ %t4123s, %L524 ]
%t4124 = ashr i64 %t4119, 12
%t4125 = and i64 %t4124, 63
%t4126 = call i64 @__m____________lib_crypto_resid__b64_code(i64 %t4125)
%t4127b = extractvalue {ptr,ptr} %t4123, 0
%t4127l = extractvalue {ptr,ptr} %t4123, 1
%t4127a = icmp ult i64 %t4126, 128
%t4127r = icmp ult ptr %t4127b, %t4127l
%t4127k = and i1 %t4127a, %t4127r
br i1 %t4127k, label %L526, label %L527
L526:
%t4127v = trunc i64 %t4126 to i8
store i8 %t4127v, ptr %t4127b, align 1
%t4127q = getelementptr i8, ptr %t4127b, i64 1
%t4127f = insertvalue {ptr,ptr} %t4123, ptr %t4127q, 0
br label %L528
L527:
%t4127nb = call ptr @resid_sb2_push_cp(ptr %t4127b, ptr %t4127l, i64 %t4126)
%t4127nl = call ptr @resid_sb2_lim()
%t4127sx = insertvalue {ptr,ptr} zeroinitializer, ptr %t4127nb, 0
%t4127s = insertvalue {ptr,ptr} %t4127sx, ptr %t4127nl, 1
br label %L528
L528:
%t4127 = phi {ptr,ptr} [ %t4127f, %L526 ], [ %t4127s, %L527 ]
%t4128 = icmp sgt i64 %t4095, 1
br i1 %t4128, label %L529, label %L530
L529:
%t4129 = ashr i64 %t4119, 6
%t4130 = and i64 %t4129, 63
%t4131 = call i64 @__m____________lib_crypto_resid__b64_code(i64 %t4130)
br label %L531
L530:
br label %L531
L531:
%t4132 = phi i64 [ %t4131, %L529 ], [ 61, %L530 ]
%t4133b = extractvalue {ptr,ptr} %t4127, 0
%t4133l = extractvalue {ptr,ptr} %t4127, 1
%t4133a = icmp ult i64 %t4132, 128
%t4133r = icmp ult ptr %t4133b, %t4133l
%t4133k = and i1 %t4133a, %t4133r
br i1 %t4133k, label %L532, label %L533
L532:
%t4133v = trunc i64 %t4132 to i8
store i8 %t4133v, ptr %t4133b, align 1
%t4133q = getelementptr i8, ptr %t4133b, i64 1
%t4133f = insertvalue {ptr,ptr} %t4127, ptr %t4133q, 0
br label %L534
L533:
%t4133nb = call ptr @resid_sb2_push_cp(ptr %t4133b, ptr %t4133l, i64 %t4132)
%t4133nl = call ptr @resid_sb2_lim()
%t4133sx = insertvalue {ptr,ptr} zeroinitializer, ptr %t4133nb, 0
%t4133s = insertvalue {ptr,ptr} %t4133sx, ptr %t4133nl, 1
br label %L534
L534:
%t4133 = phi {ptr,ptr} [ %t4133f, %L532 ], [ %t4133s, %L533 ]
%t4134 = icmp sgt i64 %t4095, 2
br i1 %t4134, label %L535, label %L536
L535:
%t4135 = and i64 %t4119, 63
%t4136 = call i64 @__m____________lib_crypto_resid__b64_code(i64 %t4135)
br label %L537
L536:
br label %L537
L537:
%t4137 = phi i64 [ %t4136, %L535 ], [ 61, %L536 ]
%t4138b = extractvalue {ptr,ptr} %t4133, 0
%t4138l = extractvalue {ptr,ptr} %t4133, 1
%t4138a = icmp ult i64 %t4137, 128
%t4138r = icmp ult ptr %t4138b, %t4138l
%t4138k = and i1 %t4138a, %t4138r
br i1 %t4138k, label %L538, label %L539
L538:
%t4138v = trunc i64 %t4137 to i8
store i8 %t4138v, ptr %t4138b, align 1
%t4138q = getelementptr i8, ptr %t4138b, i64 1
%t4138f = insertvalue {ptr,ptr} %t4133, ptr %t4138q, 0
br label %L540
L539:
%t4138nb = call ptr @resid_sb2_push_cp(ptr %t4138b, ptr %t4138l, i64 %t4137)
%t4138nl = call ptr @resid_sb2_lim()
%t4138sx = insertvalue {ptr,ptr} zeroinitializer, ptr %t4138nb, 0
%t4138s = insertvalue {ptr,ptr} %t4138sx, ptr %t4138nl, 1
br label %L540
L540:
%t4138 = phi {ptr,ptr} [ %t4138f, %L538 ], [ %t4138s, %L539 ]
%t4139 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 3)
%t4140 = extractvalue {i64, i1} %t4139, 0
%t4141 = extractvalue {i64, i1} %t4139, 1
%t4142 = zext i1 %t4141 to i8
call void @resid_overflow_check(i8 %t4142)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @base64_decode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4144 = call i64 @str_len(ptr %p0)
%t4145 = call ptr @resid_listbuf_new()
%t4146 = call ptr @__m____________lib_crypto_resid__b64_strip(ptr %p0, i64 0, i64 %t4144, ptr %t4145)
%t4147 = call i64 @resid_list_len(ptr %t4146)
%t4148 = call i64 @__m____________lib_crypto_resid__b64_pads(ptr %t4146, i64 %t4147, i64 0)
%t4149 = call i64 @resid_list_len(ptr %t4146)
%t4150 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t4149, i64 %t4148)
%t4151 = extractvalue {i64, i1} %t4150, 0
%t4152 = extractvalue {i64, i1} %t4150, 1
%t4153 = zext i1 %t4152 to i8
call void @resid_overflow_check(i8 %t4153)
%t4154 = call ptr @resid_list_slice(ptr %t4146, i64 0, i64 %t4151)
%t4156 = call ptr @base64g_decode__g_Int_64__Int_64_(ptr %t4154, i64 %t4148)
ret ptr %t4156
}
define i1 @__m____________lib_crypto_resid__b64_is_space(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4157 = icmp eq i64 %p0, 32
br label %LSL4158
LSL4158:
br i1 %t4157, label %LSJ4158, label %LSR4158
LSR4158:
%t4159 = icmp eq i64 %p0, 9
br label %LSJ4158
LSJ4158:
%t4160 = phi i1 [ true, %LSL4158 ], [ %t4159, %LSR4158 ]
br label %LSL4161
LSL4161:
br i1 %t4160, label %LSJ4161, label %LSR4161
LSR4161:
%t4162 = icmp eq i64 %p0, 10
br label %LSJ4161
LSJ4161:
%t4163 = phi i1 [ true, %LSL4161 ], [ %t4162, %LSR4161 ]
br label %LSL4164
LSL4164:
br i1 %t4163, label %LSJ4164, label %LSR4164
LSR4164:
%t4165 = icmp eq i64 %p0, 13
br label %LSJ4164
LSJ4164:
%t4166 = phi i1 [ true, %LSL4164 ], [ %t4165, %LSR4164 ]
br i1 %t4166, label %L541, label %L543
L541:
ret i1 true
L543:
ret i1 false
}
define ptr @__m____________lib_crypto_resid__b64_strip(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4181, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t4180, %tco.s0 ]
%t4167 = icmp sge i64 %p1, %p2
br i1 %t4167, label %L544, label %L546
L544:
%t4168 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty4168)
ret ptr %t4168
L546:
%t4169 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t4170 = call i1 @__m____________lib_crypto_resid__b64_is_space(i64 %t4169)
br i1 %t4170, label %L547, label %L548
L547:
br label %L549
L548:
%t4171 = icmp sgt i64 %t4169, 127
br label %LSL4172
LSL4172:
br i1 %t4171, label %LSJ4172, label %LSR4172
LSR4172:
%t4173 = icmp slt i64 %t4169, 0
br label %LSJ4172
LSJ4172:
%t4174 = phi i1 [ true, %LSL4172 ], [ %t4173, %LSR4172 ]
br i1 %t4174, label %L550, label %L551
L550:
br label %L552
L551:
br label %L552
L552:
%t4175 = phi i64 [ 0, %L550 ], [ %t4169, %L551 ]
%t4176 = call ptr @resid_box_i64(i64 %t4175)
%t4179 = call ptr @resid_listbuf_push(ptr %p3, ptr %t4176)
br label %L549
L549:
%t4180 = phi ptr [ %p3, %L547 ], [ %t4179, %L552 ]
%t4181 = add nsw i64 %p1, 1
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4203, %tco.s0 ]
%t4183 = icmp sge i64 %p2, 2
br label %LSL4184
LSL4184:
br i1 %t4183, label %LSJ4184, label %LSR4184
LSR4184:
%t4185 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 %p2)
%t4186 = extractvalue {i64, i1} %t4185, 0
%t4187 = extractvalue {i64, i1} %t4185, 1
%t4188 = zext i1 %t4187 to i8
call void @resid_overflow_check(i8 %t4188)
%t4189 = icmp sle i64 %t4186, 0
br label %LSJ4184
LSJ4184:
%t4190 = phi i1 [ true, %LSL4184 ], [ %t4189, %LSR4184 ]
br i1 %t4190, label %L553, label %L555
L553:
ret i64 %p2
L555:
%t4191 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 %p2)
%t4192 = extractvalue {i64, i1} %t4191, 0
%t4193 = extractvalue {i64, i1} %t4191, 1
%t4194 = zext i1 %t4193 to i8
call void @resid_overflow_check(i8 %t4194)
%t4195 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t4192, i64 1)
%t4196 = extractvalue {i64, i1} %t4195, 0
%t4197 = extractvalue {i64, i1} %t4195, 1
%t4198 = zext i1 %t4197 to i8
call void @resid_overflow_check(i8 %t4198)
%t4199 = call ptr @resid_list_get_v(ptr %p0, i64 %t4196, ptr %p0.ld, i64 %p0.ln)
%t4200 = call i64 @resid_unbox_i64(ptr %t4199)
%t4202 = icmp ne i64 %t4200, 61
br i1 %t4202, label %L556, label %L558
L556:
ret i64 %p2
L558:
%t4203 = add nsw i64 %p2, 1
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4209, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t4205 = icmp sle i64 %p2, 0
br i1 %t4205, label %L559, label %L561
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
%t4206 = call ptr @hmac_sha256_bytes(ptr %p1, ptr %p0)
%t4207 = call ptr @resid_list_freeze(ptr %t4206)
%t4208 = call ptr @pbkdf2_xor_acc(ptr %p3, ptr %t4207, i64 0)
%t4209 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4207, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t4208, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4207, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t4208, %tco.s0 ]
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
%p2 = phi i64 [ %p2.in, %entry ], [ %t4222, %tco.s0.k ]
%t4211 = call i64 @resid_list_len(ptr %p1)
%t4212 = icmp sge i64 %p2, %t4211
br i1 %t4212, label %L562, label %L564
L562:
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %p0
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L564:
%t4213 = call ptr @resid_list_get(ptr %p0, i64 %p2)
%t4214 = call i64 @resid_unbox_i64(ptr %t4213)
%t4216 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t4217 = call i64 @resid_unbox_i64(ptr %t4216)
%t4219 = xor i64 %t4214, %t4217
%t4220 = and i64 %t4219, 255
%t4221 = call ptr @ls_set(ptr %p0, i64 %p2, i64 %t4220)
%t4222 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4221, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4221, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
br label %tco.head
}
define ptr @pbkdf2_hmac_sha256(ptr %p0, ptr %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4224 = and i64 %p3, 255
%t4225 = ashr i64 %p3, 8
%t4226 = and i64 %t4225, 255
%t4227 = ashr i64 %p3, 16
%t4228 = and i64 %t4227, 255
%t4229 = ashr i64 %p3, 24
%t4230 = and i64 %t4229, 255
%t4231 = alloca [4 x ptr]
%t4233 = call ptr @resid_box_i64(i64 %t4230)
%t4235 = getelementptr i8, ptr %t4231, i64 0
store ptr %t4233, ptr %t4235
%t4236 = call ptr @resid_box_i64(i64 %t4228)
%t4238 = getelementptr i8, ptr %t4231, i64 8
store ptr %t4236, ptr %t4238
%t4239 = call ptr @resid_box_i64(i64 %t4226)
%t4241 = getelementptr i8, ptr %t4231, i64 16
store ptr %t4239, ptr %t4241
%t4242 = call ptr @resid_box_i64(i64 %t4224)
%t4244 = getelementptr i8, ptr %t4231, i64 24
store ptr %t4242, ptr %t4244
%t4245 = call ptr @resid_list_new(i64 4, ptr %t4231, ptr @.lty4231)
%t4246 = call ptr @sconcat(ptr %p1, ptr %t4245)
%t4247 = call ptr @resid_list_freeze(ptr %t4246)
%t4248 = call ptr @hmac_sha256_bytes(ptr %p0, ptr %t4247)
%t4249 = call ptr @resid_list_freeze(ptr %t4248)
%t4250 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 1)
%t4251 = extractvalue {i64, i1} %t4250, 0
%t4252 = extractvalue {i64, i1} %t4250, 1
%t4253 = zext i1 %t4252 to i8
call void @resid_overflow_check(i8 %t4253)
%t4254 = call ptr @pbkdf2_f(ptr %t4249, ptr %p0, i64 %t4251, ptr %t4249)
ret ptr %t4254
}
define ptr @hkdf_extract(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4255 = musttail call ptr @hmac_sha256_bytes(ptr %p0, ptr %p1)
ret ptr %t4255
}
define i64 @hkdf_rounds(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4256 = sdiv i64 %p0, 32
%t4257 = srem i64 %p0, 32
%t4258 = icmp ne i64 %t4257, 0
br i1 %t4258, label %L565, label %L567
L565:
%t4259 = add nsw i64 %t4256, 1
ret i64 %t4259
L567:
ret i64 %t4256
}
define ptr @hkdf_exp_acc(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4263 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4274, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0.k ]
%p4 = phi ptr [ %p4.in, %entry ], [ %p4.ev.tco.s0, %tco.s0.k ]
%p5 = phi ptr [ %p5.in, %entry ], [ %p5.ev.tco.s0, %tco.s0.k ]
%t4260 = icmp sgt i64 %p2, %p3
br i1 %t4260, label %L568, label %L570
L568:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p5
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p5, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L570:
%t4261 = call ptr @sconcat(ptr %p4, ptr %p1)
%t4262 = call ptr @resid_list_freeze(ptr %t4261)
%t4265 = call ptr @resid_box_i64(i64 %p2)
%t4267 = getelementptr i8, ptr %t4263, i64 0
store ptr %t4265, ptr %t4267
%t4269e = load ptr, ptr %t4263
%t4269 = call ptr @resid_list_push(ptr %t4262, ptr %t4269e)
%t4270 = call ptr @hmac_sha256_bytes(ptr %p0, ptr %t4269)
%t4271 = call ptr @resid_list_freeze(ptr %t4270)
%t4272 = call ptr @sconcat(ptr %p5, ptr %t4271)
%t4273 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t4274 = extractvalue {i64, i1} %t4273, 0
%t4275 = extractvalue {i64, i1} %t4273, 1
%t4276 = zext i1 %t4275 to i8
call void @resid_overflow_check(i8 %t4276)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p4.e.tco.s0 = call ptr @resid_mv_list(ptr %t4271, ptr %lr.cx.tco.s0)
%p5.e.tco.s0 = call ptr @resid_mv_list(ptr %t4272, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p4.ev.tco.s0 = phi ptr [ %p4.e.tco.s0, %tco.s0.c ], [ %t4271, %tco.s0 ]
%p5.ev.tco.s0 = phi ptr [ %p5.e.tco.s0, %tco.s0.c ], [ %t4272, %tco.s0 ]
br label %tco.head
}
define ptr @hkdf_expand(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4278 = icmp slt i64 %p2, 0
br label %LSL4279
LSL4279:
br i1 %t4278, label %LSJ4279, label %LSR4279
LSR4279:
%t4280 = icmp sgt i64 %p2, 8160
br label %LSJ4279
LSJ4279:
%t4281 = phi i1 [ true, %LSL4279 ], [ %t4280, %LSR4279 ]
br i1 %t4281, label %L571, label %L573
L571:
%t4283 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4282)
ret ptr %t4283
L573:
%t4284 = call i64 @hkdf_rounds(i64 %p2)
%t4286 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4285)
%t4288 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4287)
%t4289 = call ptr @hkdf_exp_acc(ptr %p0, ptr %p1, i64 1, i64 %t4284, ptr %t4286, ptr %t4288)
%t4291 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4290)
%t4292 = call ptr @hkdf_take(ptr %t4289, i64 0, i64 %p2, ptr %t4291)
ret ptr %t4292
}
define ptr @hkdf_take(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4297 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4304, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t4293 = icmp sge i64 %p1, %p2
br i1 %t4293, label %L574, label %L576
L574:
%lr.cx14 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz14 = icmp eq ptr %lr.cx14, null
br i1 %lr.lz14, label %lr.x14.k, label %lr.x14.m
lr.x14.k:
ret ptr %p3
lr.x14.m:
%lr.ret14 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx14)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret14
L576:
%t4294 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t4295 = call i64 @resid_unbox_i64(ptr %t4294)
%t4299 = call ptr @resid_box_i64(i64 %t4295)
%t4301 = getelementptr i8, ptr %t4297, i64 0
store ptr %t4299, ptr %t4301
%t4302 = call ptr @resid_list_new(i64 1, ptr %t4297, ptr @.lty4297)
%t4303 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t4302)
%t4304 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t4303, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t4303, %tco.s0 ]
br label %tco.head
}
define ptr @hkdf_sha256(ptr %p0, ptr %p1, ptr %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4306 = call ptr @hkdf_extract(ptr %p0, ptr %p1)
%t4307 = call ptr @resid_list_freeze(ptr %t4306)
%t4308 = call ptr @hkdf_expand(ptr %t4307, ptr %p2, i64 %p3)
ret ptr %t4308
}
define ptr @random_bytes(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4309 = icmp sle i64 %p0, 0
br i1 %t4309, label %L577, label %L579
L577:
%t4311 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4310)
ret ptr %t4311
L579:
%t4313 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4312)
%t4314 = call ptr @__m____________lib_crypto_resid__rand_blocks(i64 %p0, ptr %t4313)
ret ptr %t4314
}
define ptr @__m____________lib_crypto_resid__rand_blocks(i64 %p0.in, ptr %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%t4315 = call i64 @resid_list_len(ptr %p1)
%t4316 = icmp sge i64 %t4315, %p0
br i1 %t4316, label %L580, label %L582
L580:
%t4317 = call ptr @resid_list_slice(ptr %p1, i64 0, i64 %p0)
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %t4317
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %t4317, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L582:
%t4319 = call ptr @__m____________lib_crypto_resid__rand_block()
%t4320 = call ptr @resid_list_freeze(ptr %t4319)
%t4321 = call ptr @resid_list_concat_own(ptr %p1, i8 1, ptr %t4320)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %t4321, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %t4321, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_crypto_resid__rand_block() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4323 = call ptr @resid_random_os(i64 32)
%t4324 = call i64 @resid_list_len(ptr %t4323)
%t4325 = icmp eq i64 %t4324, 32
%t4327 = zext i1 %t4325 to i8
call void @resid_assert(i8 %t4327, ptr @.s4326)
%t4328 = call ptr @resid_random_cpu(i64 32)
%t4330 = call ptr @resid_list_const_i64(ptr @.lc4329, i64 4, ptr @.lcd4329, ptr @.lty4329)
%t4331 = call ptr @resid_list_concat(ptr %t4330, ptr %t4323)
%t4332 = call i64 @resid_list_len(ptr %t4328)
%t4333 = call ptr @__m____________lib_crypto_resid__rand_u32(i64 %t4332)
%t4334 = call ptr @resid_list_freeze(ptr %t4333)
%t4335 = call ptr @resid_list_concat(ptr %t4331, ptr %t4334)
%t4336 = call ptr @resid_list_concat(ptr %t4335, ptr %t4328)
%t4337 = call ptr @sha512_bytes(ptr %t4336)
ret ptr %t4337
}
define ptr @__m____________lib_crypto_resid__rand_u32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4338 = ashr i64 %p0, 24
%t4339 = and i64 %t4338, 255
%t4340 = ashr i64 %p0, 16
%t4341 = and i64 %t4340, 255
%t4342 = ashr i64 %p0, 8
%t4343 = and i64 %t4342, 255
%t4344 = and i64 %p0, 255
%t4345 = alloca [4 x ptr]
%t4347 = call ptr @resid_box_i64(i64 %t4339)
%t4349 = getelementptr i8, ptr %t4345, i64 0
store ptr %t4347, ptr %t4349
%t4350 = call ptr @resid_box_i64(i64 %t4341)
%t4352 = getelementptr i8, ptr %t4345, i64 8
store ptr %t4350, ptr %t4352
%t4353 = call ptr @resid_box_i64(i64 %t4343)
%t4355 = getelementptr i8, ptr %t4345, i64 16
store ptr %t4353, ptr %t4355
%t4356 = call ptr @resid_box_i64(i64 %t4344)
%t4358 = getelementptr i8, ptr %t4345, i64 24
store ptr %t4356, ptr %t4358
%t4359 = call ptr @resid_list_new(i64 4, ptr %t4345, ptr @.lty4345)
ret ptr %t4359
}
define ptr @random_hex(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4360 = call ptr @random_bytes(i64 %p0)
%t4361 = call ptr @hex_encode(ptr %t4360)
ret ptr %t4361
}
define ptr @w64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4362 = and i64 %p0, 4294967295
%t4363 = and i64 %p1, 4294967295
%t4364 = alloca [2 x ptr]
%t4366 = call ptr @resid_box_i64(i64 %t4362)
%t4368 = getelementptr i8, ptr %t4364, i64 0
store ptr %t4366, ptr %t4368
%t4369 = call ptr @resid_box_i64(i64 %t4363)
%t4371 = getelementptr i8, ptr %t4364, i64 8
store ptr %t4369, ptr %t4371
%t4372 = call ptr @resid_list_new(i64 2, ptr %t4364, ptr @.lty4364)
ret ptr %t4372
}
define i64 @w64_hi(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4373 = call ptr @resid_list_get(ptr %p0, i64 0)
%t4374 = musttail call i64 @resid_unbox_i64(ptr %t4373)
ret i64 %t4374
}
define i64 @w64_lo(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4376 = call ptr @resid_list_get(ptr %p0, i64 1)
%t4377 = musttail call i64 @resid_unbox_i64(ptr %t4376)
ret i64 %t4377
}
define ptr @w64_add(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4379 = call i64 @w64_lo(ptr %p0)
%t4380 = call i64 @w64_lo(ptr %p1)
%t4381 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4379, i64 %t4380)
%t4382 = extractvalue {i64, i1} %t4381, 0
%t4383 = extractvalue {i64, i1} %t4381, 1
%t4384 = zext i1 %t4383 to i8
call void @resid_overflow_check(i8 %t4384)
%t4385 = and i64 %t4382, 4294967295
%t4386 = ashr i64 %t4382, 32
%t4387 = call i64 @w64_hi(ptr %p0)
%t4388 = call i64 @w64_hi(ptr %p1)
%t4389 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4387, i64 %t4388)
%t4390 = extractvalue {i64, i1} %t4389, 0
%t4391 = extractvalue {i64, i1} %t4389, 1
%t4392 = zext i1 %t4391 to i8
call void @resid_overflow_check(i8 %t4392)
%t4393 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4390, i64 %t4386)
%t4394 = extractvalue {i64, i1} %t4393, 0
%t4395 = extractvalue {i64, i1} %t4393, 1
%t4396 = zext i1 %t4395 to i8
call void @resid_overflow_check(i8 %t4396)
%t4397 = call ptr @w64(i64 %t4394, i64 %t4385)
ret ptr %t4397
}
define ptr @w64_xor(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4398 = call i64 @w64_hi(ptr %p0)
%t4399 = call i64 @w64_hi(ptr %p1)
%t4400 = xor i64 %t4398, %t4399
%t4401 = call i64 @w64_lo(ptr %p0)
%t4402 = call i64 @w64_lo(ptr %p1)
%t4403 = xor i64 %t4401, %t4402
%t4404 = call ptr @w64(i64 %t4400, i64 %t4403)
ret ptr %t4404
}
define ptr @w64_and(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4405 = call i64 @w64_hi(ptr %p0)
%t4406 = call i64 @w64_hi(ptr %p1)
%t4407 = and i64 %t4405, %t4406
%t4408 = call i64 @w64_lo(ptr %p0)
%t4409 = call i64 @w64_lo(ptr %p1)
%t4410 = and i64 %t4408, %t4409
%t4411 = call ptr @w64(i64 %t4407, i64 %t4410)
ret ptr %t4411
}
define ptr @w64_not(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4412 = call i64 @w64_hi(ptr %p0)
%t4413 = xor i64 %t4412, 4294967295
%t4414 = and i64 %t4413, 4294967295
%t4415 = call i64 @w64_lo(ptr %p0)
%t4416 = xor i64 %t4415, 4294967295
%t4417 = and i64 %t4416, 4294967295
%t4418 = call ptr @w64(i64 %t4414, i64 %t4417)
ret ptr %t4418
}
define ptr @w64_zext(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4419 = call i64 @w64_lo(ptr %p0)
%t4420 = call ptr @w64__rs272(i64 0, i64 %t4419)
ret ptr %t4420
}
define ptr @w64_rotr_small(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4421 = call i64 @w64_hi(ptr %p0)
%t4422 = call i64 @w64_lo(ptr %p0)
%t4423 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t4424 = extractvalue {i64, i1} %t4423, 0
%t4425 = extractvalue {i64, i1} %t4423, 1
%t4426 = zext i1 %t4425 to i8
call void @resid_overflow_check(i8 %t4426)
%t4427 = icmp uge i64 %p1, 64
%t4428 = add i64 %p1, 0
%t4429 = select i1 %t4427, i64 63, i64 %t4428
%t4430 = ashr i64 %t4421, %t4429
%t4431 = icmp uge i64 %t4424, 64
%t4432 = add i64 %t4424, 0
%t4433 = shl i64 %t4422, %t4432
%t4434 = select i1 %t4431, i64 0, i64 %t4433
%t4435 = or i64 %t4430, %t4434
%t4436 = icmp uge i64 %p1, 64
%t4437 = add i64 %p1, 0
%t4438 = select i1 %t4436, i64 63, i64 %t4437
%t4439 = ashr i64 %t4422, %t4438
%t4440 = icmp uge i64 %t4424, 64
%t4441 = add i64 %t4424, 0
%t4442 = shl i64 %t4421, %t4441
%t4443 = select i1 %t4440, i64 0, i64 %t4442
%t4444 = or i64 %t4439, %t4443
%t4445 = call ptr @w64(i64 %t4435, i64 %t4444)
ret ptr %t4445
}
define ptr @w64_rotr(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4446 = icmp eq i64 %p1, 0
br i1 %t4446, label %L583, label %L585
L583:
ret ptr %p0
L585:
%t4447 = icmp eq i64 %p1, 32
br i1 %t4447, label %L586, label %L588
L586:
%t4448 = call i64 @w64_lo(ptr %p0)
%t4449 = call i64 @w64_hi(ptr %p0)
%t4450 = call ptr @w64(i64 %t4448, i64 %t4449)
ret ptr %t4450
L588:
%t4451 = icmp sgt i64 %p1, 32
br i1 %t4451, label %L589, label %L591
L589:
%t4452 = sub nsw i64 %p1, 32
%t4453 = call i64 @w64_lo(ptr %p0)
%t4454 = call i64 @w64_hi(ptr %p0)
%t4455 = call ptr @w64(i64 %t4453, i64 %t4454)
%t4456 = musttail call ptr @w64_rotr_small(ptr %t4455, i64 %t4452)
ret ptr %t4456
L591:
%t4457 = musttail call ptr @w64_rotr_small(ptr %p0, i64 %p1)
ret ptr %t4457
}
define ptr @w64_shr_small(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4458 = call i64 @w64_hi(ptr %p0)
%t4459 = call i64 @w64_lo(ptr %p0)
%t4460 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t4461 = extractvalue {i64, i1} %t4460, 0
%t4462 = extractvalue {i64, i1} %t4460, 1
%t4463 = zext i1 %t4462 to i8
call void @resid_overflow_check(i8 %t4463)
%t4464 = icmp uge i64 %p1, 64
%t4465 = add i64 %p1, 0
%t4466 = select i1 %t4464, i64 63, i64 %t4465
%t4467 = ashr i64 %t4459, %t4466
%t4468 = icmp uge i64 %t4461, 64
%t4469 = add i64 %t4461, 0
%t4470 = shl i64 %t4458, %t4469
%t4471 = select i1 %t4468, i64 0, i64 %t4470
%t4472 = or i64 %t4467, %t4471
%t4473 = icmp uge i64 %p1, 64
%t4474 = add i64 %p1, 0
%t4475 = select i1 %t4473, i64 63, i64 %t4474
%t4476 = ashr i64 %t4458, %t4475
%t4477 = call ptr @w64(i64 %t4476, i64 %t4472)
ret ptr %t4477
}
define ptr @w64_shr(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4478 = icmp eq i64 %p1, 0
br i1 %t4478, label %L592, label %L594
L592:
ret ptr %p0
L594:
%t4479 = icmp sge i64 %p1, 32
br i1 %t4479, label %L595, label %L597
L595:
%t4480 = sub nsw i64 %p1, 32
%t4481 = call i64 @w64_hi(ptr %p0)
%t4482 = icmp uge i64 %t4480, 64
%t4483 = add i64 %t4480, 0
%t4484 = select i1 %t4482, i64 63, i64 %t4483
%t4485 = ashr i64 %t4481, %t4484
%t4486 = call ptr @w64__rs272(i64 0, i64 %t4485)
ret ptr %t4486
L597:
%t4487 = musttail call ptr @w64_shr_small(ptr %p0, i64 %p1)
ret ptr %t4487
}
define ptr @k512_limb_at(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4489 = call ptr @resid_list_const_i64(ptr @.lc4488, i64 160, ptr @.lcd4488, ptr @.lty4488)
%t4490 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p0, i64 2)
%t4491 = extractvalue {i64, i1} %t4490, 0
%t4492 = extractvalue {i64, i1} %t4490, 1
%t4493 = zext i1 %t4492 to i8
call void @resid_overflow_check(i8 %t4493)
%t4494 = call ptr @resid_list_get(ptr %t4489, i64 %t4491)
%t4495 = call i64 @resid_unbox_i64(ptr %t4494)
%t4498 = call ptr @resid_list_const_i64(ptr @.lc4497, i64 160, ptr @.lcd4497, ptr @.lty4497)
%t4499 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p0, i64 2)
%t4500 = extractvalue {i64, i1} %t4499, 0
%t4501 = extractvalue {i64, i1} %t4499, 1
%t4502 = zext i1 %t4501 to i8
call void @resid_overflow_check(i8 %t4502)
%t4503 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4500, i64 1)
%t4504 = extractvalue {i64, i1} %t4503, 0
%t4505 = extractvalue {i64, i1} %t4503, 1
%t4506 = zext i1 %t4505 to i8
call void @resid_overflow_check(i8 %t4506)
%t4507 = call ptr @resid_list_get(ptr %t4498, i64 %t4504)
%t4508 = call i64 @resid_unbox_i64(ptr %t4507)
%t4510 = call ptr @w64(i64 %t4495, i64 %t4508)
ret ptr %t4510
}
define ptr @h512_state() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4512 = call ptr @resid_list_const_i64(ptr @.lc4511, i64 16, ptr @.lcd4511, ptr @.lty4511)
ret ptr %t4512
}
define ptr @h512_seed(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4520 = alloca [1 x ptr]
%t4527 = alloca [1 x ptr]
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t4534, %tco.s0.k ]
%t4513 = icmp sge i64 %p3, 8
br i1 %t4513, label %L598, label %L600
L598:
%lr.cx17 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz17 = icmp eq ptr %lr.cx17, null
br i1 %lr.lz17, label %lr.x17.k, label %lr.x17.m
lr.x17.k:
ret ptr %p0
lr.x17.m:
%lr.ret17 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx17)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret17
L600:
%t4514 = call ptr @resid_list_get_v(ptr %p1, i64 %p3, ptr %p1.ld, i64 %p1.ln)
%t4515 = call i64 @resid_unbox_i64(ptr %t4514)
%t4517 = call ptr @resid_list_get_v(ptr %p2, i64 %p3, ptr %p2.ld, i64 %p2.ln)
%t4518 = call i64 @resid_unbox_i64(ptr %t4517)
%t4522 = call ptr @resid_box_i64(i64 %t4515)
%t4524 = getelementptr i8, ptr %t4520, i64 0
store ptr %t4522, ptr %t4524
%t4525 = call ptr @resid_list_new(i64 1, ptr %t4520, ptr @.lty4520)
%t4526 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t4525)
%t4529 = call ptr @resid_box_i64(i64 %t4518)
%t4531 = getelementptr i8, ptr %t4527, i64 0
store ptr %t4529, ptr %t4531
%t4532 = call ptr @resid_list_new(i64 1, ptr %t4527, ptr @.lty4527)
%t4533 = call ptr @resid_list_concat_own(ptr %t4526, i8 1, ptr %t4532)
%t4534 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4533, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4533, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %p2, %tco.s0 ]
br label %tco.head
}
define ptr @pad512(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4536 = call i64 @resid_list_len(ptr %p0)
%t4538 = call ptr @resid_list_const_i64(ptr @.lc4537, i64 1, ptr @.lcd4537, ptr @.lty4537)
%t4539 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t4538)
%t4540 = add nsw i64 %t4536, 17
%t4541 = add nsw i64 %t4540, 127
%t4542 = sdiv i64 %t4541, 128
%t4543 = mul nsw i64 %t4542, 128
%t4544 = sub nsw i64 %t4543, %t4540
%t4545 = call ptr @zeros_l(ptr %t4539, i64 %t4544)
%t4546 = mul nsw i64 %t4536, 8
%t4547 = call ptr @len512_bytes__rs273(ptr %t4545, i64 %t4546, i64 15)
ret ptr %t4547
}
define i64 @shr_big(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t4553, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4554, %tco.s0 ]
%t4548 = icmp sle i64 %p1, 63
br i1 %t4548, label %L601, label %L603
L601:
%t4549 = icmp uge i64 %p1, 64
%t4550 = add i64 %p1, 0
%t4551 = select i1 %t4549, i64 63, i64 %t4550
%t4552 = ashr i64 %p0, %t4551
ret i64 %t4552
L603:
%t4553 = ashr i64 %p0, 32
%t4554 = sub nsw i64 %p1, 32
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @len512_bytes(ptr %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4563 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4570, %tco.s0.k ]
%t4556 = icmp slt i64 %p2, 0
br i1 %t4556, label %L604, label %L606
L604:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p0
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L606:
%t4557 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t4558 = extractvalue {i64, i1} %t4557, 0
%t4559 = extractvalue {i64, i1} %t4557, 1
%t4560 = zext i1 %t4559 to i8
call void @resid_overflow_check(i8 %t4560)
%t4561 = call i64 @shr_big(i64 %p1, i64 %t4558)
%t4562 = and i64 %t4561, 255
%t4565 = call ptr @resid_box_i64(i64 %t4562)
%t4567 = getelementptr i8, ptr %t4563, i64 0
store ptr %t4565, ptr %t4567
%t4568 = call ptr @resid_list_new(i64 1, ptr %t4563, ptr @.lty4563)
%t4569 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t4568)
%t4570 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4569, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4569, %tco.s0 ]
br label %tco.head
}
define ptr @mw512(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4572 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t4573 = extractvalue {i64, i1} %t4572, 0
%t4574 = extractvalue {i64, i1} %t4572, 1
%t4575 = zext i1 %t4574 to i8
call void @resid_overflow_check(i8 %t4575)
%t4576 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t4573)
%t4577 = extractvalue {i64, i1} %t4576, 0
%t4578 = extractvalue {i64, i1} %t4576, 1
%t4579 = zext i1 %t4578 to i8
call void @resid_overflow_check(i8 %t4579)
%t4580 = call ptr @resid_list_get(ptr %p0, i64 %t4577)
%t4581 = call i64 @resid_unbox_i64(ptr %t4580)
%t4583 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4577, i64 1)
%t4584 = extractvalue {i64, i1} %t4583, 0
%t4585 = extractvalue {i64, i1} %t4583, 1
%t4586 = zext i1 %t4585 to i8
call void @resid_overflow_check(i8 %t4586)
%t4587 = call ptr @resid_list_get(ptr %p0, i64 %t4584)
%t4588 = call i64 @resid_unbox_i64(ptr %t4587)
%t4590 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4577, i64 2)
%t4591 = extractvalue {i64, i1} %t4590, 0
%t4592 = extractvalue {i64, i1} %t4590, 1
%t4593 = zext i1 %t4592 to i8
call void @resid_overflow_check(i8 %t4593)
%t4594 = call ptr @resid_list_get(ptr %p0, i64 %t4591)
%t4595 = call i64 @resid_unbox_i64(ptr %t4594)
%t4597 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4577, i64 3)
%t4598 = extractvalue {i64, i1} %t4597, 0
%t4599 = extractvalue {i64, i1} %t4597, 1
%t4600 = zext i1 %t4599 to i8
call void @resid_overflow_check(i8 %t4600)
%t4601 = call ptr @resid_list_get(ptr %p0, i64 %t4598)
%t4602 = call i64 @resid_unbox_i64(ptr %t4601)
%t4604 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4577, i64 4)
%t4605 = extractvalue {i64, i1} %t4604, 0
%t4606 = extractvalue {i64, i1} %t4604, 1
%t4607 = zext i1 %t4606 to i8
call void @resid_overflow_check(i8 %t4607)
%t4608 = call ptr @resid_list_get(ptr %p0, i64 %t4605)
%t4609 = call i64 @resid_unbox_i64(ptr %t4608)
%t4611 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4577, i64 5)
%t4612 = extractvalue {i64, i1} %t4611, 0
%t4613 = extractvalue {i64, i1} %t4611, 1
%t4614 = zext i1 %t4613 to i8
call void @resid_overflow_check(i8 %t4614)
%t4615 = call ptr @resid_list_get(ptr %p0, i64 %t4612)
%t4616 = call i64 @resid_unbox_i64(ptr %t4615)
%t4618 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4577, i64 6)
%t4619 = extractvalue {i64, i1} %t4618, 0
%t4620 = extractvalue {i64, i1} %t4618, 1
%t4621 = zext i1 %t4620 to i8
call void @resid_overflow_check(i8 %t4621)
%t4622 = call ptr @resid_list_get(ptr %p0, i64 %t4619)
%t4623 = call i64 @resid_unbox_i64(ptr %t4622)
%t4625 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4577, i64 7)
%t4626 = extractvalue {i64, i1} %t4625, 0
%t4627 = extractvalue {i64, i1} %t4625, 1
%t4628 = zext i1 %t4627 to i8
call void @resid_overflow_check(i8 %t4628)
%t4629 = call ptr @resid_list_get(ptr %p0, i64 %t4626)
%t4630 = call i64 @resid_unbox_i64(ptr %t4629)
%t4632 = shl i64 %t4581, 24
%t4633 = shl i64 %t4588, 16
%t4634 = shl i64 %t4595, 8
%t4635 = or i64 %t4632, %t4633
%t4636 = or i64 %t4635, %t4634
%t4637 = or i64 %t4636, %t4602
%t4638 = and i64 %t4637, 4294967295
%t4639 = shl i64 %t4609, 24
%t4640 = shl i64 %t4616, 16
%t4641 = shl i64 %t4623, 8
%t4642 = or i64 %t4639, %t4640
%t4643 = or i64 %t4642, %t4641
%t4644 = or i64 %t4643, %t4630
%t4645 = and i64 %t4644, 4294967295
%t4646 = alloca [2 x ptr]
%t4648 = call ptr @resid_box_i64(i64 %t4638)
%t4650 = getelementptr i8, ptr %t4646, i64 0
store ptr %t4648, ptr %t4650
%t4651 = call ptr @resid_box_i64(i64 %t4645)
%t4653 = getelementptr i8, ptr %t4646, i64 8
store ptr %t4651, ptr %t4653
%t4654 = call ptr @resid_list_new(i64 2, ptr %t4646, ptr @.lty4646)
ret ptr %t4654
}
define ptr @mw512_acc(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4659, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t4655 = icmp sge i64 %p2, 16
br i1 %t4655, label %L607, label %L609
L607:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L609:
%t4656 = call ptr @mw512(ptr %p0, i64 %p1, i64 %p2)
%t4657 = call ptr @resid_list_freeze(ptr %t4656)
%t4658 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t4657)
%t4659 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t4658, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t4658, %tco.s0 ]
br label %tco.head
}
define ptr @msg_words512(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4662 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4661)
%t4663 = call ptr @mw512_acc__rs289(ptr %p0, i64 %p1, i64 0, ptr %t4662)
ret ptr %t4663
}
define i64 @fw_hi(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4664 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4665 = extractvalue {i64, i1} %t4664, 0
%t4666 = extractvalue {i64, i1} %t4664, 1
%t4667 = zext i1 %t4666 to i8
call void @resid_overflow_check(i8 %t4667)
%t4668 = call ptr @resid_list_get(ptr %p0, i64 %t4665)
%t4669 = call i64 @resid_unbox_i64(ptr %t4668)
ret i64 %t4669
}
define i64 @fw_lo(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4671 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4672 = extractvalue {i64, i1} %t4671, 0
%t4673 = extractvalue {i64, i1} %t4671, 1
%t4674 = zext i1 %t4673 to i8
call void @resid_overflow_check(i8 %t4674)
%t4675 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4672, i64 1)
%t4676 = extractvalue {i64, i1} %t4675, 0
%t4677 = extractvalue {i64, i1} %t4675, 1
%t4678 = zext i1 %t4677 to i8
call void @resid_overflow_check(i8 %t4678)
%t4679 = call ptr @resid_list_get(ptr %p0, i64 %t4676)
%t4680 = call i64 @resid_unbox_i64(ptr %t4679)
ret i64 %t4680
}
define ptr @fw_pair(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4682 = call i64 @fw_hi(ptr %p0, i64 %p1)
%t4683 = call i64 @fw_lo(ptr %p0, i64 %p1)
%t4684 = call ptr @w64(i64 %t4682, i64 %t4683)
ret ptr %t4684
}
define i64 @ch64_of(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4685 = call i64 @not32(i64 %p0)
%t4686 = and i64 %p0, %p1
%t4687 = and i64 %t4685, %p2
%t4688 = xor i64 %t4686, %t4687
ret i64 %t4688
}
define ptr @hex_byte_at(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4689 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t4690 = call i64 @resid_unbox_i64(ptr %t4689)
%t4692 = and i64 %t4690, 255
%t4693 = ashr i64 %t4692, 4
%t4694 = and i64 %t4693, 15
%t4695 = call ptr @hex_digit(i64 %t4694)
%t4696 = and i64 %t4692, 15
%t4697 = call ptr @hex_digit(i64 %t4696)
%t4698 = call ptr @resid_str_concat(ptr %t4695, ptr %t4697)
ret ptr %t4698
}
define ptr @sig0(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4699 = call ptr @w64_rotr__rs291(ptr %p0, i64 1)
%t4700 = call ptr @w64_rotr__rs293(ptr %p0, i64 8)
%t4701 = call ptr @w64_shr__rs295(ptr %p0, i64 7)
%t4702 = call ptr @w64_xor(ptr %t4699, ptr %t4700)
%t4703 = call ptr @w64_xor(ptr %t4702, ptr %t4701)
ret ptr %t4703
}
define ptr @sig1(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4704 = call ptr @w64_rotr__rs297(ptr %p0, i64 19)
%t4705 = call ptr @w64_rotr__rs299(ptr %p0, i64 61)
%t4706 = call ptr @w64_shr__rs301(ptr %p0, i64 6)
%t4707 = call ptr @w64_xor(ptr %t4704, ptr %t4705)
%t4708 = call ptr @w64_xor(ptr %t4707, ptr %t4706)
ret ptr %t4708
}
define ptr @big_sig0(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4709 = call ptr @w64_rotr__rs303(ptr %p0, i64 28)
%t4710 = call ptr @w64_rotr__rs305(ptr %p0, i64 34)
%t4711 = call ptr @w64_rotr__rs307(ptr %p0, i64 39)
%t4712 = call ptr @w64_xor(ptr %t4709, ptr %t4710)
%t4713 = call ptr @w64_xor(ptr %t4712, ptr %t4711)
ret ptr %t4713
}
define ptr @big_sig1(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4714 = call ptr @w64_rotr__rs309(ptr %p0, i64 14)
%t4715 = call ptr @w64_rotr(ptr %p0, i64 18)
%t4716 = call ptr @w64_rotr(ptr %p0, i64 41)
%t4717 = call ptr @w64_xor(ptr %t4714, ptr %t4715)
%t4718 = call ptr @w64_xor(ptr %t4717, ptr %t4716)
ret ptr %t4718
}
define ptr @maj64(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4719 = call ptr @w64_and(ptr %p0, ptr %p1)
%t4720 = call ptr @w64_and(ptr %p0, ptr %p2)
%t4721 = call ptr @w64_and(ptr %p1, ptr %p2)
%t4722 = call ptr @w64_xor(ptr %t4719, ptr %t4720)
%t4723 = call ptr @w64_xor(ptr %t4722, ptr %t4721)
ret ptr %t4723
}
define ptr @ext512_flat(ptr %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4751 = alloca [1 x ptr]
%t4758 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4766, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%t4724 = icmp sge i64 %p1, %p2
br i1 %t4724, label %L610, label %L612
L610:
%lr.cx12 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz12 = icmp eq ptr %lr.cx12, null
br i1 %lr.lz12, label %lr.x12.k, label %lr.x12.m
lr.x12.k:
ret ptr %p0
lr.x12.m:
%lr.ret12 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx12)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret12
L612:
%t4725 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 15)
%t4726 = extractvalue {i64, i1} %t4725, 0
%t4727 = extractvalue {i64, i1} %t4725, 1
%t4728 = zext i1 %t4727 to i8
call void @resid_overflow_check(i8 %t4728)
%t4729 = call ptr @fw_pair(ptr %p0, i64 %t4726)
%t4730 = call ptr @sig0(ptr %t4729)
%t4731 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 2)
%t4732 = extractvalue {i64, i1} %t4731, 0
%t4733 = extractvalue {i64, i1} %t4731, 1
%t4734 = zext i1 %t4733 to i8
call void @resid_overflow_check(i8 %t4734)
%t4735 = call ptr @fw_pair(ptr %p0, i64 %t4732)
%t4736 = call ptr @sig1(ptr %t4735)
%t4737 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 16)
%t4738 = extractvalue {i64, i1} %t4737, 0
%t4739 = extractvalue {i64, i1} %t4737, 1
%t4740 = zext i1 %t4739 to i8
call void @resid_overflow_check(i8 %t4740)
%t4741 = call ptr @fw_pair(ptr %p0, i64 %t4738)
%t4742 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p1, i64 7)
%t4743 = extractvalue {i64, i1} %t4742, 0
%t4744 = extractvalue {i64, i1} %t4742, 1
%t4745 = zext i1 %t4744 to i8
call void @resid_overflow_check(i8 %t4745)
%t4746 = call ptr @fw_pair(ptr %p0, i64 %t4743)
%t4747 = call ptr @w64_add(ptr %t4741, ptr %t4730)
%t4748 = call ptr @w64_add(ptr %t4746, ptr %t4736)
%t4749 = call ptr @w64_add(ptr %t4747, ptr %t4748)
%t4750 = call i64 @w64_hi(ptr %t4749)
%t4753 = call ptr @resid_box_i64(i64 %t4750)
%t4755 = getelementptr i8, ptr %t4751, i64 0
store ptr %t4753, ptr %t4755
%t4756 = call ptr @resid_list_new(i64 1, ptr %t4751, ptr @.lty4751)
%t4757 = call i64 @w64_lo(ptr %t4749)
%t4760 = call ptr @resid_box_i64(i64 %t4757)
%t4762 = getelementptr i8, ptr %t4758, i64 0
store ptr %t4760, ptr %t4762
%t4763 = call ptr @resid_list_new(i64 1, ptr %t4758, ptr @.lty4758)
%t4764 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t4756)
%t4765 = call ptr @resid_list_concat_own(ptr %t4764, i8 1, ptr %t4763)
%t4766 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4765, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4765, %tco.s0 ]
br label %tco.head
}
define ptr @state512_init() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4769 = call ptr @resid_list_const_i64(ptr @.lc4768, i64 16, ptr @.lcd4768, ptr @.lty4768)
ret ptr %t4769
}
define ptr @st_set(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4770 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4771 = extractvalue {i64, i1} %t4770, 0
%t4772 = extractvalue {i64, i1} %t4770, 1
%t4773 = zext i1 %t4772 to i8
call void @resid_overflow_check(i8 %t4773)
%t4774 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4771, i64 1)
%t4775 = extractvalue {i64, i1} %t4774, 0
%t4776 = extractvalue {i64, i1} %t4774, 1
%t4777 = zext i1 %t4776 to i8
call void @resid_overflow_check(i8 %t4777)
%t4778 = call i64 @w64_hi(ptr %p2)
%t4779 = call ptr @ls_set(ptr %p0, i64 %t4771, i64 %t4778)
%t4780 = call i64 @w64_lo(ptr %p2)
%t4781 = call ptr @ls_set(ptr %t4779, i64 %t4775, i64 %t4780)
ret ptr %t4781
}
define i64 @st_hi(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4782 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4783 = extractvalue {i64, i1} %t4782, 0
%t4784 = extractvalue {i64, i1} %t4782, 1
%t4785 = zext i1 %t4784 to i8
call void @resid_overflow_check(i8 %t4785)
%t4786 = call ptr @resid_list_get(ptr %p0, i64 %t4783)
%t4787 = call i64 @resid_unbox_i64(ptr %t4786)
ret i64 %t4787
}
define i64 @st_lo(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4789 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 2)
%t4790 = extractvalue {i64, i1} %t4789, 0
%t4791 = extractvalue {i64, i1} %t4789, 1
%t4792 = zext i1 %t4791 to i8
call void @resid_overflow_check(i8 %t4792)
%t4793 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4790, i64 1)
%t4794 = extractvalue {i64, i1} %t4793, 0
%t4795 = extractvalue {i64, i1} %t4793, 1
%t4796 = zext i1 %t4795 to i8
call void @resid_overflow_check(i8 %t4796)
%t4797 = call ptr @resid_list_get(ptr %p0, i64 %t4794)
%t4798 = call i64 @resid_unbox_i64(ptr %t4797)
ret i64 %t4798
}
define ptr @sha512_round_flat(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4800 = call ptr @fw_pair(ptr %p0, i64 0)
%t4801 = call ptr @fw_pair(ptr %p0, i64 1)
%t4802 = call ptr @fw_pair(ptr %p0, i64 2)
%t4803 = call ptr @fw_pair(ptr %p0, i64 3)
%t4804 = call ptr @fw_pair(ptr %p0, i64 4)
%t4805 = call ptr @resid_list_freeze(ptr %t4804)
%t4806 = call ptr @fw_pair(ptr %p0, i64 5)
%t4807 = call ptr @fw_pair(ptr %p0, i64 6)
%t4808 = call ptr @fw_pair(ptr %p0, i64 7)
%t4809 = call ptr @fw_pair(ptr %p1, i64 %p2)
%t4810 = call ptr @k512_limb_at(i64 %p2)
%t4811 = call ptr @big_sig1(ptr %t4805)
%t4812 = call ptr @w64_not(ptr %t4805)
%t4813 = call ptr @w64_and(ptr %t4805, ptr %t4806)
%t4814 = call ptr @w64_and(ptr %t4812, ptr %t4807)
%t4815 = call ptr @w64_xor(ptr %t4813, ptr %t4814)
%t4816 = call ptr @w64_add(ptr %t4808, ptr %t4811)
%t4817 = call ptr @w64_add(ptr %t4816, ptr %t4815)
%t4818 = call ptr @w64_add(ptr %t4817, ptr %t4810)
%t4819 = call ptr @w64_add(ptr %t4818, ptr %t4809)
%t4820 = call ptr @big_sig0(ptr %t4800)
%t4821 = call ptr @maj64(ptr %t4800, ptr %t4801, ptr %t4802)
%t4822 = call ptr @w64_add(ptr %t4820, ptr %t4821)
%t4823 = call ptr @w64_add(ptr %t4819, ptr %t4822)
%t4824 = call ptr @w64_add(ptr %t4803, ptr %t4819)
%t4825 = call ptr @resid_list_get(ptr %t4823, i64 0)
%t4826 = call i64 @resid_unbox_i64(ptr %t4825)
%t4828 = call ptr @resid_list_get(ptr %t4823, i64 1)
%t4829 = call i64 @resid_unbox_i64(ptr %t4828)
%t4831 = call ptr @resid_list_get(ptr %t4800, i64 0)
%t4832 = call i64 @resid_unbox_i64(ptr %t4831)
%t4834 = call ptr @resid_list_get(ptr %t4800, i64 1)
%t4835 = call i64 @resid_unbox_i64(ptr %t4834)
%t4837 = call ptr @resid_list_get(ptr %t4801, i64 0)
%t4838 = call i64 @resid_unbox_i64(ptr %t4837)
%t4840 = call ptr @resid_list_get(ptr %t4801, i64 1)
%t4841 = call i64 @resid_unbox_i64(ptr %t4840)
%t4843 = call ptr @resid_list_get(ptr %t4802, i64 0)
%t4844 = call i64 @resid_unbox_i64(ptr %t4843)
%t4846 = call ptr @resid_list_get(ptr %t4802, i64 1)
%t4847 = call i64 @resid_unbox_i64(ptr %t4846)
%t4849 = call ptr @resid_list_get(ptr %t4824, i64 0)
%t4850 = call i64 @resid_unbox_i64(ptr %t4849)
%t4852 = call ptr @resid_list_get(ptr %t4824, i64 1)
%t4853 = call i64 @resid_unbox_i64(ptr %t4852)
%t4855 = call ptr @resid_list_get(ptr %t4805, i64 0)
%t4856 = call i64 @resid_unbox_i64(ptr %t4855)
%t4858 = call ptr @resid_list_get(ptr %t4805, i64 1)
%t4859 = call i64 @resid_unbox_i64(ptr %t4858)
%t4861 = call ptr @resid_list_get(ptr %t4806, i64 0)
%t4862 = call i64 @resid_unbox_i64(ptr %t4861)
%t4864 = call ptr @resid_list_get(ptr %t4806, i64 1)
%t4865 = call i64 @resid_unbox_i64(ptr %t4864)
%t4867 = call ptr @resid_list_get(ptr %t4807, i64 0)
%t4868 = call i64 @resid_unbox_i64(ptr %t4867)
%t4870 = call ptr @resid_list_get(ptr %t4807, i64 1)
%t4871 = call i64 @resid_unbox_i64(ptr %t4870)
%t4873 = alloca [16 x ptr]
%t4875 = call ptr @resid_box_i64(i64 %t4826)
%t4877 = getelementptr i8, ptr %t4873, i64 0
store ptr %t4875, ptr %t4877
%t4878 = call ptr @resid_box_i64(i64 %t4829)
%t4880 = getelementptr i8, ptr %t4873, i64 8
store ptr %t4878, ptr %t4880
%t4881 = call ptr @resid_box_i64(i64 %t4832)
%t4883 = getelementptr i8, ptr %t4873, i64 16
store ptr %t4881, ptr %t4883
%t4884 = call ptr @resid_box_i64(i64 %t4835)
%t4886 = getelementptr i8, ptr %t4873, i64 24
store ptr %t4884, ptr %t4886
%t4887 = call ptr @resid_box_i64(i64 %t4838)
%t4889 = getelementptr i8, ptr %t4873, i64 32
store ptr %t4887, ptr %t4889
%t4890 = call ptr @resid_box_i64(i64 %t4841)
%t4892 = getelementptr i8, ptr %t4873, i64 40
store ptr %t4890, ptr %t4892
%t4893 = call ptr @resid_box_i64(i64 %t4844)
%t4895 = getelementptr i8, ptr %t4873, i64 48
store ptr %t4893, ptr %t4895
%t4896 = call ptr @resid_box_i64(i64 %t4847)
%t4898 = getelementptr i8, ptr %t4873, i64 56
store ptr %t4896, ptr %t4898
%t4899 = call ptr @resid_box_i64(i64 %t4850)
%t4901 = getelementptr i8, ptr %t4873, i64 64
store ptr %t4899, ptr %t4901
%t4902 = call ptr @resid_box_i64(i64 %t4853)
%t4904 = getelementptr i8, ptr %t4873, i64 72
store ptr %t4902, ptr %t4904
%t4905 = call ptr @resid_box_i64(i64 %t4856)
%t4907 = getelementptr i8, ptr %t4873, i64 80
store ptr %t4905, ptr %t4907
%t4908 = call ptr @resid_box_i64(i64 %t4859)
%t4910 = getelementptr i8, ptr %t4873, i64 88
store ptr %t4908, ptr %t4910
%t4911 = call ptr @resid_box_i64(i64 %t4862)
%t4913 = getelementptr i8, ptr %t4873, i64 96
store ptr %t4911, ptr %t4913
%t4914 = call ptr @resid_box_i64(i64 %t4865)
%t4916 = getelementptr i8, ptr %t4873, i64 104
store ptr %t4914, ptr %t4916
%t4917 = call ptr @resid_box_i64(i64 %t4868)
%t4919 = getelementptr i8, ptr %t4873, i64 112
store ptr %t4917, ptr %t4919
%t4920 = call ptr @resid_box_i64(i64 %t4871)
%t4922 = getelementptr i8, ptr %t4873, i64 120
store ptr %t4920, ptr %t4922
%t4923 = call ptr @resid_list_new(i64 16, ptr %t4873, ptr @.lty4873)
ret ptr %t4923
}
define ptr @sha512_rounds_flat(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4926, %tco.s0.k ]
%t4924 = icmp sge i64 %p2, 80
br i1 %t4924, label %L613, label %L615
L613:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p0
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L615:
%t4925 = call ptr @sha512_round_flat(ptr %p0, ptr %p1, i64 %p2)
%t4926 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %t4925, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %t4925, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
br label %tco.head
}
define ptr @add_st_word(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4928 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 2)
%t4929 = extractvalue {i64, i1} %t4928, 0
%t4930 = extractvalue {i64, i1} %t4928, 1
%t4931 = zext i1 %t4930 to i8
call void @resid_overflow_check(i8 %t4931)
%t4932 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t4929, i64 1)
%t4933 = extractvalue {i64, i1} %t4932, 0
%t4934 = extractvalue {i64, i1} %t4932, 1
%t4935 = zext i1 %t4934 to i8
call void @resid_overflow_check(i8 %t4935)
%t4936 = call ptr @resid_list_get(ptr %p0, i64 %t4929)
%t4937 = call i64 @resid_unbox_i64(ptr %t4936)
%t4939 = call ptr @resid_list_get(ptr %p0, i64 %t4933)
%t4940 = call i64 @resid_unbox_i64(ptr %t4939)
%t4942 = call ptr @w64(i64 %t4937, i64 %t4940)
%t4943 = call ptr @resid_list_get(ptr %p1, i64 %t4929)
%t4944 = call i64 @resid_unbox_i64(ptr %t4943)
%t4946 = call ptr @resid_list_get(ptr %p1, i64 %t4933)
%t4947 = call i64 @resid_unbox_i64(ptr %t4946)
%t4949 = call ptr @w64(i64 %t4944, i64 %t4947)
%t4950 = call ptr @w64_add(ptr %t4942, ptr %t4949)
ret ptr %t4950
}
define ptr @add_st_acc(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t4952, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t4951 = icmp sge i64 %p2, 8
br i1 %t4951, label %L616, label %L618
L616:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L618:
%t4952 = add nsw i64 %p2, 1
%t4953 = call ptr @add_st_word(ptr %p0, ptr %p1, i64 %p2)
%t4954 = call ptr @resid_list_freeze(ptr %t4953)
%t4955 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t4954)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t4955, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t4955, %tco.s0 ]
br label %tco.head
}
define ptr @add_st(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4958 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty4957)
%t4959 = call ptr @add_st_acc(ptr %p0, ptr %p1, i64 %p2, ptr %t4958)
ret ptr %t4959
}
define ptr @digest_block512f(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4960 = call ptr @msg_words512(ptr %p0, i64 %p1)
%t4961 = call ptr @ext512_flat(ptr %t4960, i64 16, i64 80)
%t4962 = call ptr @sha512_rounds_flat__rs337(ptr %p2, ptr %t4961, i64 0)
%t4963 = call ptr @add_st(ptr %p2, ptr %t4962, i64 0)
ret ptr %t4963
}
define ptr @digest_blocks512f(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4967, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t4964 = icmp sge i64 %p1, %p2
br i1 %t4964, label %L619, label %L621
L619:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L621:
%t4965 = call ptr @digest_block512f(ptr %p0, i64 %p1, ptr %p3)
%t4966 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 128)
%t4967 = extractvalue {i64, i1} %t4966, 0
%t4968 = extractvalue {i64, i1} %t4966, 1
%t4969 = zext i1 %t4968 to i8
call void @resid_overflow_check(i8 %t4969)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t4965, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t4965, %tco.s0 ]
br label %tco.head
}
define ptr @hex_range_b(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t4975, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t4973, %tco.s0 ]
%t4971 = icmp sgt i64 %p1, %p2
br i1 %t4971, label %L622, label %L624
L622:
ret ptr %p3
L624:
%t4972 = call ptr @hex_byte_at(ptr %p0, i64 %p1)
%t4973 = call ptr @resid_str_concat(ptr %p3, ptr %t4972)
%t4974 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t4975 = extractvalue {i64, i1} %t4974, 0
%t4976 = extractvalue {i64, i1} %t4974, 1
%t4977 = zext i1 %t4976 to i8
call void @resid_overflow_check(i8 %t4977)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @r64(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4979 = add i64 %p1, 0
%t4980 = add i64 %t4979, 0
%t4981 = add i64 %t4980, 0
%t4982 = icmp ne i64 %t4981, %t4979
%t4983 = icmp slt i64 %p1, 0
%t4984 = or i1 %t4982, %t4983
%t4985 = zext i1 %t4984 to i8
call void @resid_conv_check(i8 %t4985)
%t4986 = icmp uge i64 %t4980, 64
%t4987 = add i64 %t4980, 0
%t4988 = lshr i64 %p0, %t4987
%t4989 = select i1 %t4986, i64 0, i64 %t4988
%t4990 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 64, i64 %p1)
%t4991 = extractvalue {i64, i1} %t4990, 0
%t4992 = extractvalue {i64, i1} %t4990, 1
%t4993 = zext i1 %t4992 to i8
call void @resid_overflow_check(i8 %t4993)
%t4994 = add i64 %t4991, 0
%t4995 = add i64 %t4994, 0
%t4996 = add i64 %t4995, 0
%t4997 = icmp ne i64 %t4996, %t4994
%t4998 = icmp slt i64 %t4991, 0
%t4999 = or i1 %t4997, %t4998
%t5000 = zext i1 %t4999 to i8
call void @resid_conv_check(i8 %t5000)
%t5001 = icmp uge i64 %t4995, 64
%t5002 = add i64 %t4995, 0
%t5003 = shl i64 %p0, %t5002
%t5004 = select i1 %t5001, i64 0, i64 %t5003
%t5005 = or i64 %t4989, %t5004
ret i64 %t5005
}
define i64 @bs0_64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5006 = call i64 @r64(i64 %p0, i64 28)
%t5007 = call i64 @r64(i64 %p0, i64 34)
%t5008 = xor i64 %t5006, %t5007
%t5009 = call i64 @r64(i64 %p0, i64 39)
%t5010 = xor i64 %t5008, %t5009
ret i64 %t5010
}
define i64 @bs1_64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5011 = call i64 @r64(i64 %p0, i64 14)
%t5012 = call i64 @r64(i64 %p0, i64 18)
%t5013 = xor i64 %t5011, %t5012
%t5014 = call i64 @r64(i64 %p0, i64 41)
%t5015 = xor i64 %t5013, %t5014
ret i64 %t5015
}
define i64 @ss0_64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5016 = call i64 @r64(i64 %p0, i64 1)
%t5017 = call i64 @r64(i64 %p0, i64 8)
%t5018 = xor i64 %t5016, %t5017
%t5019 = lshr i64 %p0, 7
%t5020 = xor i64 %t5018, %t5019
ret i64 %t5020
}
define i64 @ss1_64(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5021 = call i64 @r64(i64 %p0, i64 19)
%t5022 = call i64 @r64(i64 %p0, i64 61)
%t5023 = xor i64 %t5021, %t5022
%t5024 = lshr i64 %p0, 6
%t5025 = xor i64 %t5023, %t5024
ret i64 %t5025
}
define i64 @k512_u(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5026 = call ptr @k512_limb_at(i64 %p0)
%t5027 = call ptr @resid_list_get(ptr %t5026, i64 0)
%t5028 = call i64 @resid_unbox_i64(ptr %t5027)
%t5030 = add i64 %t5028, 0
%t5031 = add i64 %t5030, 0
%t5032 = add i64 %t5031, 0
%t5033 = icmp ne i64 %t5032, %t5030
%t5034 = icmp slt i64 %t5028, 0
%t5035 = or i1 %t5033, %t5034
%t5036 = zext i1 %t5035 to i8
call void @resid_conv_check(i8 %t5036)
%t5037 = shl i64 %t5031, 32
%t5038 = call ptr @resid_list_get(ptr %t5026, i64 1)
%t5039 = call i64 @resid_unbox_i64(ptr %t5038)
%t5041 = add i64 %t5039, 0
%t5042 = add i64 %t5041, 0
%t5043 = add i64 %t5042, 0
%t5044 = icmp ne i64 %t5043, %t5041
%t5045 = icmp slt i64 %t5039, 0
%t5046 = or i1 %t5044, %t5045
%t5047 = zext i1 %t5046 to i8
call void @resid_conv_check(i8 %t5047)
%t5048 = or i64 %t5037, %t5042
ret i64 %t5048
}
define i64 @word64_at(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5049 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t5050 = extractvalue {i64, i1} %t5049, 0
%t5051 = extractvalue {i64, i1} %t5049, 1
%t5052 = zext i1 %t5051 to i8
call void @resid_overflow_check(i8 %t5052)
%t5053 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t5050)
%t5054 = extractvalue {i64, i1} %t5053, 0
%t5055 = extractvalue {i64, i1} %t5053, 1
%t5056 = zext i1 %t5055 to i8
call void @resid_overflow_check(i8 %t5056)
%t5057 = call i64 @w64_bytes__rs351(ptr %p0, i64 %t5054, i64 0, i64 0)
ret i64 %t5057
}
define i64 @w64_bytes(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5059, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t5069, %tco.s0 ]
%t5058 = icmp sge i64 %p2, 8
br i1 %t5058, label %L625, label %L627
L625:
ret i64 %p3
L627:
%t5059 = add nsw i64 %p2, 1
%t5060 = shl i64 %p3, 8
%t5061 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p2)
%t5062 = extractvalue {i64, i1} %t5061, 0
%t5063 = extractvalue {i64, i1} %t5061, 1
%t5064 = zext i1 %t5063 to i8
call void @resid_overflow_check(i8 %t5064)
%t5065 = call ptr @resid_list_get_v(ptr %p0, i64 %t5062, ptr %p0.ld, i64 %p0.ln)
%t5066 = call i64 @resid_unbox_i64(ptr %t5065)
%t5068 = and i64 %t5066, 255
%t5069 = or i64 %t5060, %t5068
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @sched64(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5071 = icmp slt i64 %p2, 16
br i1 %t5071, label %L628, label %L630
L628:
%t5072 = call i64 @word64_at(ptr %p0, i64 %p1, i64 %p2)
ret i64 %t5072
L630:
%t5073 = call i64 @ss1_64(i64 %p6)
%t5074 = call i64 @wrapping_uadd(i64 %t5073, i64 %p5)
%t5075 = call i64 @ss0_64(i64 %p4)
%t5076 = call i64 @wrapping_uadd(i64 %t5075, i64 %p3)
%t5077 = call i64 @wrapping_uadd(i64 %t5074, i64 %t5076)
ret i64 %t5077
}
define ptr @sha512_blk(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in, i64 %p19.in, i64 %p20.in, i64 %p21.in, i64 %p22.in, i64 %p23.in, i64 %p24.in, i64 %p25.in, i64 %p26.in, i64 %p27.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5123, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t5124, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t5125, %tco.s0.k ]
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
%p27 = phi i64 [ %p27.in, %entry ], [ %t5104, %tco.s0.k ]
%t5078 = icmp sge i64 %p2, 80
br i1 %t5078, label %L631, label %L633
L631:
%t5079 = call ptr @resid_gmalloc(i64 64)
%t5080 = getelementptr i8, ptr %p3, i64 0
%t5081 = load i64, ptr %t5080, align 8
%t5082 = call i64 @wrapping_uadd(i64 %t5081, i64 %p4)
%t5079.f0 = getelementptr i8, ptr %t5079, i64 0
store i64 %t5082, ptr %t5079.f0, align 8
%t5083 = getelementptr i8, ptr %p3, i64 8
%t5084 = load i64, ptr %t5083, align 8
%t5085 = call i64 @wrapping_uadd(i64 %t5084, i64 %p5)
%t5079.f1 = getelementptr i8, ptr %t5079, i64 8
store i64 %t5085, ptr %t5079.f1, align 8
%t5086 = getelementptr i8, ptr %p3, i64 16
%t5087 = load i64, ptr %t5086, align 8
%t5088 = call i64 @wrapping_uadd(i64 %t5087, i64 %p6)
%t5079.f2 = getelementptr i8, ptr %t5079, i64 16
store i64 %t5088, ptr %t5079.f2, align 8
%t5089 = getelementptr i8, ptr %p3, i64 24
%t5090 = load i64, ptr %t5089, align 8
%t5091 = call i64 @wrapping_uadd(i64 %t5090, i64 %p7)
%t5079.f3 = getelementptr i8, ptr %t5079, i64 24
store i64 %t5091, ptr %t5079.f3, align 8
%t5092 = getelementptr i8, ptr %p3, i64 32
%t5093 = load i64, ptr %t5092, align 8
%t5094 = call i64 @wrapping_uadd(i64 %t5093, i64 %p8)
%t5079.f4 = getelementptr i8, ptr %t5079, i64 32
store i64 %t5094, ptr %t5079.f4, align 8
%t5095 = getelementptr i8, ptr %p3, i64 40
%t5096 = load i64, ptr %t5095, align 8
%t5097 = call i64 @wrapping_uadd(i64 %t5096, i64 %p9)
%t5079.f5 = getelementptr i8, ptr %t5079, i64 40
store i64 %t5097, ptr %t5079.f5, align 8
%t5098 = getelementptr i8, ptr %p3, i64 48
%t5099 = load i64, ptr %t5098, align 8
%t5100 = call i64 @wrapping_uadd(i64 %t5099, i64 %p10)
%t5079.f6 = getelementptr i8, ptr %t5079, i64 48
store i64 %t5100, ptr %t5079.f6, align 8
%t5101 = getelementptr i8, ptr %p3, i64 56
%t5102 = load i64, ptr %t5101, align 8
%t5103 = call i64 @wrapping_uadd(i64 %t5102, i64 %p11)
%t5079.f7 = getelementptr i8, ptr %t5079, i64 56
store i64 %t5103, ptr %t5079.f7, align 8
%lr.cx76 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz76 = icmp eq ptr %lr.cx76, null
br i1 %lr.lz76, label %lr.x76.k, label %lr.x76.m
lr.x76.k:
ret ptr %t5079
lr.x76.m:
%lr.ret76 = call ptr @"resid.rec.evac.W512"(ptr %t5079, ptr %lr.cx76)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret76
L633:
%t5104 = call i64 @sched64(ptr %p0, i64 %p1, i64 %p2, i64 %p12, i64 %p13, i64 %p21, i64 %p26)
%t5105 = and i64 %p8, %p9
%t5106 = xor i64 %p8, -1
%t5107 = and i64 %t5106, %p10
%t5108 = xor i64 %t5105, %t5107
%t5109 = call i64 @resid_scope_push()
%t5110 = call i64 @bs1_64(i64 %p8)
%t5111 = call i64 @wrapping_uadd(i64 %p11, i64 %t5110)
%t5112 = call i64 @k512_u(i64 %p2)
%t5113 = call i64 @wrapping_uadd(i64 %t5108, i64 %t5112)
%t5114 = call i64 @wrapping_uadd(i64 %t5111, i64 %t5113)
%t5115 = call i64 @wrapping_uadd(i64 %t5114, i64 %t5104)
call void @resid_scope_pop(i64 %t5109)
%t5116 = call i64 @bs0_64(i64 %p4)
%t5117 = and i64 %p4, %p5
%t5118 = and i64 %p4, %p6
%t5119 = xor i64 %t5117, %t5118
%t5120 = and i64 %p5, %p6
%t5121 = xor i64 %t5119, %t5120
%t5122 = call i64 @wrapping_uadd(i64 %t5116, i64 %t5121)
%t5123 = add nsw i64 %p2, 1
%t5124 = call i64 @wrapping_uadd(i64 %t5115, i64 %t5122)
%t5125 = call i64 @wrapping_uadd(i64 %p7, i64 %t5115)
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t5133, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t5127 = icmp sge i64 %p1, %p2
br i1 %t5127, label %L634, label %L636
L634:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @"resid.rec.evac.W512"(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L636:
%t5128 = call i8 @resid_cpu_has_sha512()
%t5129 = icmp ne i8 %t5128, 0
br i1 %t5129, label %L637, label %L639
L637:
%t5130 = call i512 @sha512_hw_state(ptr %p3)
%t5131 = call ptr @sha512_hw_blocks(ptr %p0, i64 %p1, i64 %p2, i512 %t5130)
%lr.cx19 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz19 = icmp eq ptr %lr.cx19, null
br i1 %lr.lz19, label %lr.x19.k, label %lr.x19.m
lr.x19.k:
ret ptr %t5131
lr.x19.m:
%lr.ret19 = call ptr @"resid.rec.evac.W512"(ptr %t5131, ptr %lr.cx19)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret19
L639:
%t5132 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 128)
%t5133 = extractvalue {i64, i1} %t5132, 0
%t5134 = extractvalue {i64, i1} %t5132, 1
%t5135 = zext i1 %t5134 to i8
call void @resid_overflow_check(i8 %t5135)
%t5136 = getelementptr i8, ptr %p3, i64 0
%t5137 = load i64, ptr %t5136, align 8
%t5138 = getelementptr i8, ptr %p3, i64 8
%t5139 = load i64, ptr %t5138, align 8
%t5140 = getelementptr i8, ptr %p3, i64 16
%t5141 = load i64, ptr %t5140, align 8
%t5142 = getelementptr i8, ptr %p3, i64 24
%t5143 = load i64, ptr %t5142, align 8
%t5144 = getelementptr i8, ptr %p3, i64 32
%t5145 = load i64, ptr %t5144, align 8
%t5146 = getelementptr i8, ptr %p3, i64 40
%t5147 = load i64, ptr %t5146, align 8
%t5148 = getelementptr i8, ptr %p3, i64 48
%t5149 = load i64, ptr %t5148, align 8
%t5150 = getelementptr i8, ptr %p3, i64 56
%t5151 = load i64, ptr %t5150, align 8
%t5152 = call ptr @sha512_blk(ptr %p0, i64 %p1, i64 0, ptr %p3, i64 %t5137, i64 %t5139, i64 %t5141, i64 %t5143, i64 %t5145, i64 %t5147, i64 %t5149, i64 %t5151, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @"resid.rec.evac.W512"(ptr %t5152, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t5152, %tco.s0 ]
br label %tco.head
}
define i512 @sha512_hw_state(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5154 = getelementptr i8, ptr %p0, i64 0
%t5155 = load i64, ptr %t5154, align 8
%t5156 = zext i64 %t5155 to i512
%t5157 = getelementptr i8, ptr %p0, i64 8
%t5158 = load i64, ptr %t5157, align 8
%t5159 = zext i64 %t5158 to i512
%t5160 = shl i512 %t5159, 64
%t5161 = or i512 %t5156, %t5160
%t5162 = getelementptr i8, ptr %p0, i64 16
%t5163 = load i64, ptr %t5162, align 8
%t5164 = zext i64 %t5163 to i512
%t5165 = shl i512 %t5164, 128
%t5166 = or i512 %t5161, %t5165
%t5167 = getelementptr i8, ptr %p0, i64 24
%t5168 = load i64, ptr %t5167, align 8
%t5169 = zext i64 %t5168 to i512
%t5170 = shl i512 %t5169, 192
%t5171 = or i512 %t5166, %t5170
%t5172 = getelementptr i8, ptr %p0, i64 32
%t5173 = load i64, ptr %t5172, align 8
%t5174 = zext i64 %t5173 to i512
%t5175 = shl i512 %t5174, 256
%t5176 = or i512 %t5171, %t5175
%t5177 = getelementptr i8, ptr %p0, i64 40
%t5178 = load i64, ptr %t5177, align 8
%t5179 = zext i64 %t5178 to i512
%t5180 = shl i512 %t5179, 320
%t5181 = or i512 %t5176, %t5180
%t5182 = getelementptr i8, ptr %p0, i64 48
%t5183 = load i64, ptr %t5182, align 8
%t5184 = zext i64 %t5183 to i512
%t5185 = shl i512 %t5184, 384
%t5186 = or i512 %t5181, %t5185
%t5187 = getelementptr i8, ptr %p0, i64 56
%t5188 = load i64, ptr %t5187, align 8
%t5189 = zext i64 %t5188 to i512
%t5190 = shl i512 %t5189, 448
%t5191 = or i512 %t5186, %t5190
ret i512 %t5191
}
define i64 @sha512_hw_word(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5192 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 64, i64 %p1)
%t5193 = extractvalue {i64, i1} %t5192, 0
%t5194 = extractvalue {i64, i1} %t5192, 1
%t5195 = zext i1 %t5194 to i8
call void @resid_overflow_check(i8 %t5195)
%t5196 = sext i64 %t5193 to i512
%t5197 = add i512 %t5196, 0
%t5198 = add i512 %t5197, 0
%t5199 = icmp ne i512 %t5198, %t5196
%t5200 = icmp slt i64 %t5193, 0
%t5201 = or i1 %t5199, %t5200
%t5202 = zext i1 %t5201 to i8
call void @resid_conv_check(i8 %t5202)
%t5203 = icmp uge i512 %t5197, 512
%t5204 = add i512 %t5197, 0
%t5205 = lshr i512 %p0, %t5204
%t5206 = select i1 %t5203, i512 0, i512 %t5205
%t5207 = sext i128 18446744073709551615 to i512
%t5208 = add i512 %t5207, 0
%t5209 = add i512 %t5208, 0
%t5210 = icmp ne i512 %t5209, %t5207
%t5211 = icmp slt i128 18446744073709551615, 0
%t5212 = or i1 %t5210, %t5211
%t5213 = zext i1 %t5212 to i8
call void @resid_conv_check(i8 %t5213)
%t5214 = and i512 %t5206, %t5208
%t5215 = add i512 %t5214, 0
%t5216 = trunc i512 %t5215 to i64
%t5217 = zext i64 %t5216 to i512
%t5218 = icmp ne i512 %t5217, %t5215
%t5219 = icmp eq i8 0, 1
%t5220 = or i1 %t5218, %t5219
%t5221 = zext i1 %t5220 to i8
call void @resid_conv_check(i8 %t5221)
ret i64 %t5216
}
define i512 @sha512_hw_block(ptr %p0.in, i64 %p1.in, i64 %p2.in, i512 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5250, %tco.s0 ]
%p3 = phi i512 [ %p3.in, %entry ], [ %t5267, %tco.s0 ]
%t5222 = icmp sge i64 %p2, 8
br i1 %t5222, label %L640, label %L642
L640:
ret i512 %p3
L642:
%t5223 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p2)
%t5224 = extractvalue {i64, i1} %t5223, 0
%t5225 = extractvalue {i64, i1} %t5223, 1
%t5226 = zext i1 %t5225 to i8
call void @resid_overflow_check(i8 %t5226)
%t5227 = call i64 @word_at_list(ptr %p0, i64 %p1, i64 %t5224)
%t5228 = add i64 %t5227, 0
%t5229 = add i64 %t5228, 0
%t5230 = add i64 %t5229, 0
%t5231 = icmp ne i64 %t5230, %t5228
%t5232 = icmp slt i64 %t5227, 0
%t5233 = or i1 %t5231, %t5232
%t5234 = zext i1 %t5233 to i8
call void @resid_conv_check(i8 %t5234)
%t5235 = shl i64 %t5229, 32
%t5236 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p2)
%t5237 = extractvalue {i64, i1} %t5236, 0
%t5238 = extractvalue {i64, i1} %t5236, 1
%t5239 = zext i1 %t5238 to i8
call void @resid_overflow_check(i8 %t5239)
%t5240 = add nsw i64 %t5237, 1
%t5241 = call i64 @word_at_list(ptr %p0, i64 %p1, i64 %t5240)
%t5242 = add i64 %t5241, 0
%t5243 = add i64 %t5242, 0
%t5244 = add i64 %t5243, 0
%t5245 = icmp ne i64 %t5244, %t5242
%t5246 = icmp slt i64 %t5241, 0
%t5247 = or i1 %t5245, %t5246
%t5248 = zext i1 %t5247 to i8
call void @resid_conv_check(i8 %t5248)
%t5249 = or i64 %t5235, %t5243
%t5250 = add nsw i64 %p2, 1
%t5251 = zext i64 %t5249 to i512
%t5252 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 64, i64 %p2)
%t5253 = extractvalue {i64, i1} %t5252, 0
%t5254 = extractvalue {i64, i1} %t5252, 1
%t5255 = zext i1 %t5254 to i8
call void @resid_overflow_check(i8 %t5255)
%t5256 = sext i64 %t5253 to i512
%t5257 = add i512 %t5256, 0
%t5258 = add i512 %t5257, 0
%t5259 = icmp ne i512 %t5258, %t5256
%t5260 = icmp slt i64 %t5253, 0
%t5261 = or i1 %t5259, %t5260
%t5262 = zext i1 %t5261 to i8
call void @resid_conv_check(i8 %t5262)
%t5263 = icmp uge i512 %t5257, 512
%t5264 = add i512 %t5257, 0
%t5265 = shl i512 %t5251, %t5264
%t5266 = select i1 %t5263, i512 0, i512 %t5265
%t5267 = or i512 %p3, %t5266
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t5280, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi i512 [ %p3.in, %entry ], [ %t5289, %tco.s0.k ]
%t5269 = icmp sge i64 %p1, %p2
br i1 %t5269, label %L643, label %L645
L643:
%t5270 = call ptr @resid_gmalloc(i64 64)
%t5271 = call i64 @sha512_hw_word(i512 %p3, i64 0)
%t5270.f0 = getelementptr i8, ptr %t5270, i64 0
store i64 %t5271, ptr %t5270.f0, align 8
%t5272 = call i64 @sha512_hw_word(i512 %p3, i64 1)
%t5270.f1 = getelementptr i8, ptr %t5270, i64 8
store i64 %t5272, ptr %t5270.f1, align 8
%t5273 = call i64 @sha512_hw_word(i512 %p3, i64 2)
%t5270.f2 = getelementptr i8, ptr %t5270, i64 16
store i64 %t5273, ptr %t5270.f2, align 8
%t5274 = call i64 @sha512_hw_word(i512 %p3, i64 3)
%t5270.f3 = getelementptr i8, ptr %t5270, i64 24
store i64 %t5274, ptr %t5270.f3, align 8
%t5275 = call i64 @sha512_hw_word(i512 %p3, i64 4)
%t5270.f4 = getelementptr i8, ptr %t5270, i64 32
store i64 %t5275, ptr %t5270.f4, align 8
%t5276 = call i64 @sha512_hw_word(i512 %p3, i64 5)
%t5270.f5 = getelementptr i8, ptr %t5270, i64 40
store i64 %t5276, ptr %t5270.f5, align 8
%t5277 = call i64 @sha512_hw_word(i512 %p3, i64 6)
%t5270.f6 = getelementptr i8, ptr %t5270, i64 48
store i64 %t5277, ptr %t5270.f6, align 8
%t5278 = call i64 @sha512_hw_word(i512 %p3, i64 7)
%t5270.f7 = getelementptr i8, ptr %t5270, i64 56
store i64 %t5278, ptr %t5270.f7, align 8
%lr.cx36 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz36 = icmp eq ptr %lr.cx36, null
br i1 %lr.lz36, label %lr.x36.k, label %lr.x36.m
lr.x36.k:
ret ptr %t5270
lr.x36.m:
%lr.ret36 = call ptr @"resid.rec.evac.W512"(ptr %t5270, ptr %lr.cx36)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret36
L645:
%t5279 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 128)
%t5280 = extractvalue {i64, i1} %t5279, 0
%t5281 = extractvalue {i64, i1} %t5279, 1
%t5282 = zext i1 %t5281 to i8
call void @resid_overflow_check(i8 %t5282)
%t5283 = call i512 @sha512_hw_block(ptr %p0, i64 %p1, i64 0, i512 0)
%t5284 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t5285 = extractvalue {i64, i1} %t5284, 0
%t5286 = extractvalue {i64, i1} %t5284, 1
%t5287 = zext i1 %t5286 to i8
call void @resid_overflow_check(i8 %t5287)
%t5288 = call i512 @sha512_hw_block(ptr %p0, i64 %t5285, i64 0, i512 0)
%t5289 = call i512 @e.sha512(i512 %p3, i512 %t5283, i512 %t5288)
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
%t5291 = call ptr @resid_gmalloc(i64 64)
%t5292 = add i64 7640891576956012808, 0
%t5293 = add i64 %t5292, 0
%t5294 = add i64 %t5293, 0
%t5295 = icmp ne i64 %t5294, %t5292
%t5296 = icmp slt i64 7640891576956012808, 0
%t5297 = or i1 %t5295, %t5296
%t5298 = zext i1 %t5297 to i8
call void @resid_conv_check(i8 %t5298)
%t5291.f0 = getelementptr i8, ptr %t5291, i64 0
store i64 %t5293, ptr %t5291.f0, align 8
%t5299 = add i128 13503953896175478587, 0
%t5300 = trunc i128 %t5299 to i64
%t5301 = zext i64 %t5300 to i128
%t5302 = icmp ne i128 %t5301, %t5299
%t5303 = icmp slt i128 13503953896175478587, 0
%t5304 = or i1 %t5302, %t5303
%t5305 = zext i1 %t5304 to i8
call void @resid_conv_check(i8 %t5305)
%t5291.f1 = getelementptr i8, ptr %t5291, i64 8
store i64 %t5300, ptr %t5291.f1, align 8
%t5306 = add i64 4354685564936845355, 0
%t5307 = add i64 %t5306, 0
%t5308 = add i64 %t5307, 0
%t5309 = icmp ne i64 %t5308, %t5306
%t5310 = icmp slt i64 4354685564936845355, 0
%t5311 = or i1 %t5309, %t5310
%t5312 = zext i1 %t5311 to i8
call void @resid_conv_check(i8 %t5312)
%t5291.f2 = getelementptr i8, ptr %t5291, i64 16
store i64 %t5307, ptr %t5291.f2, align 8
%t5313 = add i128 11912009170470909681, 0
%t5314 = trunc i128 %t5313 to i64
%t5315 = zext i64 %t5314 to i128
%t5316 = icmp ne i128 %t5315, %t5313
%t5317 = icmp slt i128 11912009170470909681, 0
%t5318 = or i1 %t5316, %t5317
%t5319 = zext i1 %t5318 to i8
call void @resid_conv_check(i8 %t5319)
%t5291.f3 = getelementptr i8, ptr %t5291, i64 24
store i64 %t5314, ptr %t5291.f3, align 8
%t5320 = add i64 5840696475078001361, 0
%t5321 = add i64 %t5320, 0
%t5322 = add i64 %t5321, 0
%t5323 = icmp ne i64 %t5322, %t5320
%t5324 = icmp slt i64 5840696475078001361, 0
%t5325 = or i1 %t5323, %t5324
%t5326 = zext i1 %t5325 to i8
call void @resid_conv_check(i8 %t5326)
%t5291.f4 = getelementptr i8, ptr %t5291, i64 32
store i64 %t5321, ptr %t5291.f4, align 8
%t5327 = add i128 11170449401992604703, 0
%t5328 = trunc i128 %t5327 to i64
%t5329 = zext i64 %t5328 to i128
%t5330 = icmp ne i128 %t5329, %t5327
%t5331 = icmp slt i128 11170449401992604703, 0
%t5332 = or i1 %t5330, %t5331
%t5333 = zext i1 %t5332 to i8
call void @resid_conv_check(i8 %t5333)
%t5291.f5 = getelementptr i8, ptr %t5291, i64 40
store i64 %t5328, ptr %t5291.f5, align 8
%t5334 = add i64 2270897969802886507, 0
%t5335 = add i64 %t5334, 0
%t5336 = add i64 %t5335, 0
%t5337 = icmp ne i64 %t5336, %t5334
%t5338 = icmp slt i64 2270897969802886507, 0
%t5339 = or i1 %t5337, %t5338
%t5340 = zext i1 %t5339 to i8
call void @resid_conv_check(i8 %t5340)
%t5291.f6 = getelementptr i8, ptr %t5291, i64 48
store i64 %t5335, ptr %t5291.f6, align 8
%t5341 = add i64 6620516959819538809, 0
%t5342 = add i64 %t5341, 0
%t5343 = add i64 %t5342, 0
%t5344 = icmp ne i64 %t5343, %t5341
%t5345 = icmp slt i64 6620516959819538809, 0
%t5346 = or i1 %t5344, %t5345
%t5347 = zext i1 %t5346 to i8
call void @resid_conv_check(i8 %t5347)
%t5291.f7 = getelementptr i8, ptr %t5291, i64 56
store i64 %t5342, ptr %t5291.f7, align 8
ret ptr %t5291
}
define i64 @w64u(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5348 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p1)
%t5349 = extractvalue {i64, i1} %t5348, 0
%t5350 = extractvalue {i64, i1} %t5348, 1
%t5351 = zext i1 %t5350 to i8
call void @resid_overflow_check(i8 %t5351)
%t5352 = call ptr @resid_list_get(ptr %p0, i64 %t5349)
%t5353 = call i64 @resid_unbox_i64(ptr %t5352)
%t5355 = add i64 %t5353, 0
%t5356 = add i64 %t5355, 0
%t5357 = add i64 %t5356, 0
%t5358 = icmp ne i64 %t5357, %t5355
%t5359 = icmp slt i64 %t5353, 0
%t5360 = or i1 %t5358, %t5359
%t5361 = zext i1 %t5360 to i8
call void @resid_conv_check(i8 %t5361)
%t5362 = shl i64 %t5356, 32
%t5363 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 2, i64 %p1)
%t5364 = extractvalue {i64, i1} %t5363, 0
%t5365 = extractvalue {i64, i1} %t5363, 1
%t5366 = zext i1 %t5365 to i8
call void @resid_overflow_check(i8 %t5366)
%t5367 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5364, i64 1)
%t5368 = extractvalue {i64, i1} %t5367, 0
%t5369 = extractvalue {i64, i1} %t5367, 1
%t5370 = zext i1 %t5369 to i8
call void @resid_overflow_check(i8 %t5370)
%t5371 = call ptr @resid_list_get(ptr %p0, i64 %t5368)
%t5372 = call i64 @resid_unbox_i64(ptr %t5371)
%t5374 = add i64 %t5372, 0
%t5375 = add i64 %t5374, 0
%t5376 = add i64 %t5375, 0
%t5377 = icmp ne i64 %t5376, %t5374
%t5378 = icmp slt i64 %t5372, 0
%t5379 = or i1 %t5377, %t5378
%t5380 = zext i1 %t5379 to i8
call void @resid_conv_check(i8 %t5380)
%t5381 = or i64 %t5362, %t5375
ret i64 %t5381
}
define ptr @be64_push(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5383, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t5407, %tco.s0 ]
%t5382 = icmp sge i64 %p1, 8
br i1 %t5382, label %L646, label %L648
L646:
ret ptr %p2
L648:
%t5383 = add nsw i64 %p1, 1
%t5384 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t5385 = extractvalue {i64, i1} %t5384, 0
%t5386 = extractvalue {i64, i1} %t5384, 1
%t5387 = zext i1 %t5386 to i8
call void @resid_overflow_check(i8 %t5387)
%t5388 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 56, i64 %t5385)
%t5389 = extractvalue {i64, i1} %t5388, 0
%t5390 = extractvalue {i64, i1} %t5388, 1
%t5391 = zext i1 %t5390 to i8
call void @resid_overflow_check(i8 %t5391)
%t5392 = add i64 %t5389, 0
%t5393 = add i64 %t5392, 0
%t5394 = add i64 %t5393, 0
%t5395 = icmp ne i64 %t5394, %t5392
%t5396 = icmp slt i64 %t5389, 0
%t5397 = or i1 %t5395, %t5396
%t5398 = zext i1 %t5397 to i8
call void @resid_conv_check(i8 %t5398)
%t5399 = icmp uge i64 %t5393, 64
%t5400 = add i64 %t5393, 0
%t5401 = lshr i64 %p0, %t5400
%t5402 = select i1 %t5399, i64 0, i64 %t5401
%t5403 = and i64 %t5402, 255
%t5404 = call ptr @resid_box_i64(i64 %t5403)
%t5407 = call ptr @resid_listbuf_push(ptr %p2, ptr %t5404)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @words64_bytes(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5409 = getelementptr i8, ptr %p0, i64 24
%t5410 = load i64, ptr %t5409, align 8
%t5411 = getelementptr i8, ptr %p0, i64 16
%t5412 = load i64, ptr %t5411, align 8
%t5413 = getelementptr i8, ptr %p0, i64 8
%t5414 = load i64, ptr %t5413, align 8
%t5415 = getelementptr i8, ptr %p0, i64 0
%t5416 = load i64, ptr %t5415, align 8
%t5417 = call ptr @be64_push__rs387(i64 %t5416, i64 0, ptr %p2)
%t5418 = call ptr @be64_push__rs387(i64 %t5414, i64 0, ptr %t5417)
%t5419 = call ptr @be64_push__rs387(i64 %t5412, i64 0, ptr %t5418)
%t5420 = call ptr @be64_push__rs387(i64 %t5410, i64 0, ptr %t5419)
%t5421 = getelementptr i8, ptr %p0, i64 56
%t5422 = load i64, ptr %t5421, align 8
%t5423 = getelementptr i8, ptr %p0, i64 48
%t5424 = load i64, ptr %t5423, align 8
%t5425 = getelementptr i8, ptr %p0, i64 40
%t5426 = load i64, ptr %t5425, align 8
%t5427 = getelementptr i8, ptr %p0, i64 32
%t5428 = load i64, ptr %t5427, align 8
%t5429 = call ptr @be64_push__rs387(i64 %t5428, i64 0, ptr %t5420)
%t5430 = call ptr @be64_push__rs387(i64 %t5426, i64 0, ptr %t5429)
%t5431 = call ptr @be64_push__rs387(i64 %t5424, i64 0, ptr %t5430)
%t5432 = call ptr @be64_push__rs387(i64 %t5422, i64 0, ptr %t5431)
%t5433 = call ptr @resid_listbuf_finish(ptr %t5432, ptr @.lty5433)
ret ptr %t5433
}
define ptr @sha512_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5434 = call i64 @resid_list_len(ptr %p0)
%t5435 = sdiv i64 %t5434, 128
%t5436 = mul nsw i64 %t5435, 128
%t5437 = call ptr @sha512_iv()
%t5438 = call ptr @sha512_blocks(ptr %p0, i64 0, i64 %t5436, ptr %t5437)
%t5439 = call i64 @resid_list_len(ptr %p0)
%t5440 = call ptr @resid_list_slice(ptr %p0, i64 %t5436, i64 %t5439)
%t5442 = call ptr @pad512_tail(ptr %t5440, i64 %t5434)
%t5443 = call i64 @resid_list_len(ptr %t5442)
%t5444 = call ptr @sha512_blocks(ptr %t5442, i64 0, i64 %t5443, ptr %t5438)
%t5445 = call ptr @resid_listbuf_new()
%t5446 = call ptr @words64_bytes(ptr %t5444, i64 0, ptr %t5445)
ret ptr %t5446
}
define ptr @pad512_tail(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5447 = call i64 @resid_list_len(ptr %p0)
%t5448 = add nsw i64 %t5447, 17
%t5449 = add nsw i64 %t5448, 127
%t5450 = sdiv i64 %t5449, 128
%t5452 = call ptr @resid_list_const_i64(ptr @.lc5451, i64 1, ptr @.lcd5451, ptr @.lty5451)
%t5453 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t5452)
%t5454 = mul nsw i64 %t5450, 128
%t5455 = sub nsw i64 %t5454, %t5447
%t5456 = sub nsw i64 %t5455, 17
%t5457 = call ptr @zeros_l(ptr %t5453, i64 %t5456)
%t5458 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t5459 = extractvalue {i64, i1} %t5458, 0
%t5460 = extractvalue {i64, i1} %t5458, 1
%t5461 = zext i1 %t5460 to i8
call void @resid_overflow_check(i8 %t5461)
%t5462 = call ptr @len512_bytes__rs273(ptr %t5457, i64 %t5459, i64 15)
ret ptr %t5462
}
define ptr @limb_bytes_acc(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5475 = alloca [1 x ptr]
%t5482 = alloca [1 x ptr]
%t5489 = alloca [1 x ptr]
%t5496 = alloca [1 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5503, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t5463 = icmp sge i64 %p1, 16
br i1 %t5463, label %L649, label %L651
L649:
%lr.cx16 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz16 = icmp eq ptr %lr.cx16, null
br i1 %lr.lz16, label %lr.x16.k, label %lr.x16.m
lr.x16.k:
ret ptr %p2
lr.x16.m:
%lr.ret16 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx16)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret16
L651:
%t5464 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t5465 = call i64 @resid_unbox_i64(ptr %t5464)
%t5467 = and i64 %t5465, 4294967295
%t5468 = ashr i64 %t5467, 24
%t5469 = and i64 %t5468, 255
%t5470 = ashr i64 %t5467, 16
%t5471 = and i64 %t5470, 255
%t5472 = ashr i64 %t5467, 8
%t5473 = and i64 %t5472, 255
%t5474 = and i64 %t5467, 255
%t5477 = call ptr @resid_box_i64(i64 %t5469)
%t5479 = getelementptr i8, ptr %t5475, i64 0
store ptr %t5477, ptr %t5479
%t5480 = call ptr @resid_list_new(i64 1, ptr %t5475, ptr @.lty5475)
%t5481 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t5480)
%t5484 = call ptr @resid_box_i64(i64 %t5471)
%t5486 = getelementptr i8, ptr %t5482, i64 0
store ptr %t5484, ptr %t5486
%t5487 = call ptr @resid_list_new(i64 1, ptr %t5482, ptr @.lty5482)
%t5488 = call ptr @resid_list_concat_own(ptr %t5481, i8 1, ptr %t5487)
%t5491 = call ptr @resid_box_i64(i64 %t5473)
%t5493 = getelementptr i8, ptr %t5489, i64 0
store ptr %t5491, ptr %t5493
%t5494 = call ptr @resid_list_new(i64 1, ptr %t5489, ptr @.lty5489)
%t5495 = call ptr @resid_list_concat_own(ptr %t5488, i8 1, ptr %t5494)
%t5498 = call ptr @resid_box_i64(i64 %t5474)
%t5500 = getelementptr i8, ptr %t5496, i64 0
store ptr %t5498, ptr %t5500
%t5501 = call ptr @resid_list_new(i64 1, ptr %t5496, ptr @.lty5496)
%t5502 = call ptr @resid_list_concat_own(ptr %t5495, i8 1, ptr %t5501)
%t5503 = add nsw i64 %p1, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t5502, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t5502, %tco.s0 ]
br label %tco.head
}
define ptr @limbs_to_hex_bytes(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5506 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty5505)
%t5507 = call ptr @limb_bytes_acc(ptr %p0, i64 0, ptr %t5506)
ret ptr %t5507
}
define i64 @__m____________lib_crypto_resid__u32mask(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5508 = and i64 %p0, 4294967295
ret i64 %t5508
}
define i64 @__m____________lib_crypto_resid__sha1_rol(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5509 = icmp uge i64 %p1, 64
%t5510 = add i64 %p1, 0
%t5511 = shl i64 %p0, %t5510
%t5512 = select i1 %t5509, i64 0, i64 %t5511
%t5513 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5512)
%t5514 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %p0)
%t5515 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 32, i64 %p1)
%t5516 = extractvalue {i64, i1} %t5515, 0
%t5517 = extractvalue {i64, i1} %t5515, 1
%t5518 = zext i1 %t5517 to i8
call void @resid_overflow_check(i8 %t5518)
%t5519 = icmp uge i64 %t5516, 64
%t5520 = add i64 %t5516, 0
%t5521 = select i1 %t5519, i64 63, i64 %t5520
%t5522 = ashr i64 %t5514, %t5521
%t5523 = or i64 %t5513, %t5522
%t5524 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5523)
ret i64 %t5524
}
define i64 @__m____________lib_crypto_resid__sha1_word(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5525 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t5526 = extractvalue {i64, i1} %t5525, 0
%t5527 = extractvalue {i64, i1} %t5525, 1
%t5528 = zext i1 %t5527 to i8
call void @resid_overflow_check(i8 %t5528)
%t5529 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t5526)
%t5530 = extractvalue {i64, i1} %t5529, 0
%t5531 = extractvalue {i64, i1} %t5529, 1
%t5532 = zext i1 %t5531 to i8
call void @resid_overflow_check(i8 %t5532)
%t5533 = call ptr @resid_list_get(ptr %p0, i64 %t5530)
%t5534 = call i64 @resid_unbox_i64(ptr %t5533)
%t5536 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t5534, i64 256)
%t5537 = extractvalue {i64, i1} %t5536, 0
%t5538 = extractvalue {i64, i1} %t5536, 1
%t5539 = zext i1 %t5538 to i8
call void @resid_overflow_check(i8 %t5539)
%t5540 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5530, i64 1)
%t5541 = extractvalue {i64, i1} %t5540, 0
%t5542 = extractvalue {i64, i1} %t5540, 1
%t5543 = zext i1 %t5542 to i8
call void @resid_overflow_check(i8 %t5543)
%t5544 = call ptr @resid_list_get(ptr %p0, i64 %t5541)
%t5545 = call i64 @resid_unbox_i64(ptr %t5544)
%t5547 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5537, i64 %t5545)
%t5548 = extractvalue {i64, i1} %t5547, 0
%t5549 = extractvalue {i64, i1} %t5547, 1
%t5550 = zext i1 %t5549 to i8
call void @resid_overflow_check(i8 %t5550)
%t5551 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t5548, i64 256)
%t5552 = extractvalue {i64, i1} %t5551, 0
%t5553 = extractvalue {i64, i1} %t5551, 1
%t5554 = zext i1 %t5553 to i8
call void @resid_overflow_check(i8 %t5554)
%t5555 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5530, i64 2)
%t5556 = extractvalue {i64, i1} %t5555, 0
%t5557 = extractvalue {i64, i1} %t5555, 1
%t5558 = zext i1 %t5557 to i8
call void @resid_overflow_check(i8 %t5558)
%t5559 = call ptr @resid_list_get(ptr %p0, i64 %t5556)
%t5560 = call i64 @resid_unbox_i64(ptr %t5559)
%t5562 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5552, i64 %t5560)
%t5563 = extractvalue {i64, i1} %t5562, 0
%t5564 = extractvalue {i64, i1} %t5562, 1
%t5565 = zext i1 %t5564 to i8
call void @resid_overflow_check(i8 %t5565)
%t5566 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t5563, i64 256)
%t5567 = extractvalue {i64, i1} %t5566, 0
%t5568 = extractvalue {i64, i1} %t5566, 1
%t5569 = zext i1 %t5568 to i8
call void @resid_overflow_check(i8 %t5569)
%t5570 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5530, i64 3)
%t5571 = extractvalue {i64, i1} %t5570, 0
%t5572 = extractvalue {i64, i1} %t5570, 1
%t5573 = zext i1 %t5572 to i8
call void @resid_overflow_check(i8 %t5573)
%t5574 = call ptr @resid_list_get(ptr %p0, i64 %t5571)
%t5575 = call i64 @resid_unbox_i64(ptr %t5574)
%t5577 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5567, i64 %t5575)
%t5578 = extractvalue {i64, i1} %t5577, 0
%t5579 = extractvalue {i64, i1} %t5577, 1
%t5580 = zext i1 %t5579 to i8
call void @resid_overflow_check(i8 %t5580)
ret i64 %t5578
}
define ptr @__m____________lib_crypto_resid__sha1_words16(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5584 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5582, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t5581 = icmp sge i64 %p2, 16
br i1 %t5581, label %L652, label %L654
L652:
%lr.cx12 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz12 = icmp eq ptr %lr.cx12, null
br i1 %lr.lz12, label %lr.x12.k, label %lr.x12.m
lr.x12.k:
ret ptr %p3
lr.x12.m:
%lr.ret12 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx12)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret12
L654:
%t5582 = add nsw i64 %p2, 1
%t5583 = call i64 @__m____________lib_crypto_resid__sha1_word(ptr %p0, i64 %p1, i64 %p2)
%t5586 = call ptr @resid_box_i64(i64 %t5583)
%t5588 = getelementptr i8, ptr %t5584, i64 0
store ptr %t5586, ptr %t5588
%t5589 = call ptr @resid_list_new(i64 1, ptr %t5584, ptr @.lty5584)
%t5590 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t5589)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t5590, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t5590, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_crypto_resid__sha1_expand(i64 %p0.in, ptr %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5627 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %t5625, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%t5592 = icmp sge i64 %p0, 80
br i1 %t5592, label %L655, label %L657
L655:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr %p1
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_list(ptr %p1, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L657:
%t5593 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p0, i64 3)
%t5594 = extractvalue {i64, i1} %t5593, 0
%t5595 = extractvalue {i64, i1} %t5593, 1
%t5596 = zext i1 %t5595 to i8
call void @resid_overflow_check(i8 %t5596)
%t5597 = call ptr @resid_list_get(ptr %p1, i64 %t5594)
%t5598 = call i64 @resid_unbox_i64(ptr %t5597)
%t5600 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p0, i64 8)
%t5601 = extractvalue {i64, i1} %t5600, 0
%t5602 = extractvalue {i64, i1} %t5600, 1
%t5603 = zext i1 %t5602 to i8
call void @resid_overflow_check(i8 %t5603)
%t5604 = call ptr @resid_list_get(ptr %p1, i64 %t5601)
%t5605 = call i64 @resid_unbox_i64(ptr %t5604)
%t5607 = xor i64 %t5598, %t5605
%t5608 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p0, i64 14)
%t5609 = extractvalue {i64, i1} %t5608, 0
%t5610 = extractvalue {i64, i1} %t5608, 1
%t5611 = zext i1 %t5610 to i8
call void @resid_overflow_check(i8 %t5611)
%t5612 = call ptr @resid_list_get(ptr %p1, i64 %t5609)
%t5613 = call i64 @resid_unbox_i64(ptr %t5612)
%t5615 = xor i64 %t5607, %t5613
%t5616 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p0, i64 16)
%t5617 = extractvalue {i64, i1} %t5616, 0
%t5618 = extractvalue {i64, i1} %t5616, 1
%t5619 = zext i1 %t5618 to i8
call void @resid_overflow_check(i8 %t5619)
%t5620 = call ptr @resid_list_get(ptr %p1, i64 %t5617)
%t5621 = call i64 @resid_unbox_i64(ptr %t5620)
%t5623 = xor i64 %t5615, %t5621
%t5624 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5623)
%t5625 = add nsw i64 %p0, 1
%t5626 = call i64 @__m____________lib_crypto_resid__sha1_rol(i64 %t5624, i64 1)
%t5629 = call ptr @resid_box_i64(i64 %t5626)
%t5631 = getelementptr i8, ptr %t5627, i64 0
store ptr %t5629, ptr %t5631
%t5632 = call ptr @resid_list_new(i64 1, ptr %t5627, ptr @.lty5627)
%t5633 = call ptr @resid_list_concat_own(ptr %p1, i8 1, ptr %t5632)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p1.e.tco.s0 = call ptr @resid_mv_list(ptr %t5633, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %t5633, %tco.s0 ]
br label %tco.head
}
define i64 @__m____________lib_crypto_resid__sha1_f(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5635 = icmp slt i64 %p0, 20
%t5636 = icmp sge i64 %p0, 20
br label %LSL5637
LSL5637:
br i1 %t5636, label %LSR5637, label %LSJ5637
LSR5637:
%t5638 = icmp slt i64 %p0, 40
br label %LSJ5637
LSJ5637:
%t5639 = phi i1 [ false, %LSL5637 ], [ %t5638, %LSR5637 ]
%t5640 = icmp sge i64 %p0, 40
br label %LSL5641
LSL5641:
br i1 %t5640, label %LSR5641, label %LSJ5641
LSR5641:
%t5642 = icmp slt i64 %p0, 60
br label %LSJ5641
LSJ5641:
%t5643 = phi i1 [ false, %LSL5641 ], [ %t5642, %LSR5641 ]
br i1 %t5635, label %L658, label %L660
L658:
%t5644 = and i64 %p1, %p2
%t5645 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 4294967295, i64 %p1)
%t5646 = extractvalue {i64, i1} %t5645, 0
%t5647 = extractvalue {i64, i1} %t5645, 1
%t5648 = zext i1 %t5647 to i8
call void @resid_overflow_check(i8 %t5648)
%t5649 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5646)
%t5650 = and i64 %t5649, %p3
%t5651 = or i64 %t5644, %t5650
%t5652 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5651)
ret i64 %t5652
L660:
br i1 %t5639, label %L661, label %L663
L661:
%t5653 = xor i64 %p1, %p2
%t5654 = xor i64 %t5653, %p3
%t5655 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5654)
ret i64 %t5655
L663:
br i1 %t5643, label %L664, label %L666
L664:
%t5656 = and i64 %p1, %p2
%t5657 = and i64 %p1, %p3
%t5658 = or i64 %t5656, %t5657
%t5659 = and i64 %p2, %p3
%t5660 = or i64 %t5658, %t5659
%t5661 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5660)
ret i64 %t5661
L666:
%t5662 = xor i64 %p1, %p2
%t5663 = xor i64 %t5662, %p3
%t5664 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5663)
ret i64 %t5664
}
define i64 @__m____________lib_crypto_resid__sha1_k(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5665 = icmp slt i64 %p0, 20
%t5666 = icmp sge i64 %p0, 20
br label %LSL5667
LSL5667:
br i1 %t5666, label %LSR5667, label %LSJ5667
LSR5667:
%t5668 = icmp slt i64 %p0, 40
br label %LSJ5667
LSJ5667:
%t5669 = phi i1 [ false, %LSL5667 ], [ %t5668, %LSR5667 ]
%t5670 = icmp sge i64 %p0, 40
br label %LSL5671
LSL5671:
br i1 %t5670, label %LSR5671, label %LSJ5671
LSR5671:
%t5672 = icmp slt i64 %p0, 60
br label %LSJ5671
LSJ5671:
%t5673 = phi i1 [ false, %LSL5671 ], [ %t5672, %LSR5671 ]
br i1 %t5665, label %L667, label %L669
L667:
ret i64 1518500249
L669:
br i1 %t5669, label %L670, label %L672
L670:
ret i64 1859775393
L672:
br i1 %t5673, label %L673, label %L675
L673:
ret i64 2400959708
L675:
ret i64 3395469782
}
define ptr @__m____________lib_crypto_resid__sha1_rounds(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5675 = alloca [5 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5717, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5715, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p2, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t5716, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%t5674 = icmp sge i64 %p1, 80
br i1 %t5674, label %L676, label %L678
L676:
%t5677 = call ptr @resid_box_i64(i64 %p2)
%t5679 = getelementptr i8, ptr %t5675, i64 0
store ptr %t5677, ptr %t5679
%t5680 = call ptr @resid_box_i64(i64 %p3)
%t5682 = getelementptr i8, ptr %t5675, i64 8
store ptr %t5680, ptr %t5682
%t5683 = call ptr @resid_box_i64(i64 %p4)
%t5685 = getelementptr i8, ptr %t5675, i64 16
store ptr %t5683, ptr %t5685
%t5686 = call ptr @resid_box_i64(i64 %p5)
%t5688 = getelementptr i8, ptr %t5675, i64 24
store ptr %t5686, ptr %t5688
%t5689 = call ptr @resid_box_i64(i64 %p6)
%t5691 = getelementptr i8, ptr %t5675, i64 32
store ptr %t5689, ptr %t5691
%t5692 = call ptr @resid_list_new(i64 5, ptr %t5675, ptr @.lty5675)
%lr.cx33 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz33 = icmp eq ptr %lr.cx33, null
br i1 %lr.lz33, label %lr.x33.k, label %lr.x33.m
lr.x33.k:
ret ptr %t5692
lr.x33.m:
%lr.ret33 = call ptr @resid_mv_list(ptr %t5692, ptr %lr.cx33)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret33
L678:
%t5693 = call i64 @__m____________lib_crypto_resid__sha1_rol(i64 %p2, i64 5)
%t5694 = call i64 @__m____________lib_crypto_resid__sha1_f(i64 %p1, i64 %p3, i64 %p4, i64 %p5)
%t5695 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5693, i64 %t5694)
%t5696 = extractvalue {i64, i1} %t5695, 0
%t5697 = extractvalue {i64, i1} %t5695, 1
%t5698 = zext i1 %t5697 to i8
call void @resid_overflow_check(i8 %t5698)
%t5699 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5696, i64 %p6)
%t5700 = extractvalue {i64, i1} %t5699, 0
%t5701 = extractvalue {i64, i1} %t5699, 1
%t5702 = zext i1 %t5701 to i8
call void @resid_overflow_check(i8 %t5702)
%t5703 = call i64 @__m____________lib_crypto_resid__sha1_k(i64 %p1)
%t5704 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5700, i64 %t5703)
%t5705 = extractvalue {i64, i1} %t5704, 0
%t5706 = extractvalue {i64, i1} %t5704, 1
%t5707 = zext i1 %t5706 to i8
call void @resid_overflow_check(i8 %t5707)
%t5708 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t5709 = call i64 @resid_unbox_i64(ptr %t5708)
%t5711 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5705, i64 %t5709)
%t5712 = extractvalue {i64, i1} %t5711, 0
%t5713 = extractvalue {i64, i1} %t5711, 1
%t5714 = zext i1 %t5713 to i8
call void @resid_overflow_check(i8 %t5714)
%t5715 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5712)
%t5716 = call i64 @__m____________lib_crypto_resid__sha1_rol(i64 %p3, i64 30)
%t5717 = add nsw i64 %p1, 1
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
%t5720 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty5719)
%t5721 = call ptr @__m____________lib_crypto_resid__sha1_words16(ptr %p0, i64 %p1, i64 0, ptr %t5720)
%t5722 = call ptr @__m____________lib_crypto_resid__sha1_expand(i64 16, ptr %t5721)
%t5723 = call ptr @resid_list_get(ptr %p2, i64 0)
%t5724 = call i64 @resid_unbox_i64(ptr %t5723)
%t5726 = call ptr @resid_list_get(ptr %p2, i64 1)
%t5727 = call i64 @resid_unbox_i64(ptr %t5726)
%t5729 = call ptr @resid_list_get(ptr %p2, i64 2)
%t5730 = call i64 @resid_unbox_i64(ptr %t5729)
%t5732 = call ptr @resid_list_get(ptr %p2, i64 3)
%t5733 = call i64 @resid_unbox_i64(ptr %t5732)
%t5735 = call ptr @resid_list_get(ptr %p2, i64 4)
%t5736 = call i64 @resid_unbox_i64(ptr %t5735)
%t5738 = call ptr @__m____________lib_crypto_resid__sha1_rounds(ptr %t5722, i64 0, i64 %t5724, i64 %t5727, i64 %t5730, i64 %t5733, i64 %t5736)
%t5739 = call ptr @resid_list_get(ptr %p2, i64 0)
%t5740 = call i64 @resid_unbox_i64(ptr %t5739)
%t5742 = call ptr @resid_list_get(ptr %t5738, i64 0)
%t5743 = call i64 @resid_unbox_i64(ptr %t5742)
%t5745 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5740, i64 %t5743)
%t5746 = extractvalue {i64, i1} %t5745, 0
%t5747 = extractvalue {i64, i1} %t5745, 1
%t5748 = zext i1 %t5747 to i8
call void @resid_overflow_check(i8 %t5748)
%t5749 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5746)
%t5750 = call ptr @resid_list_get(ptr %p2, i64 1)
%t5751 = call i64 @resid_unbox_i64(ptr %t5750)
%t5753 = call ptr @resid_list_get(ptr %t5738, i64 1)
%t5754 = call i64 @resid_unbox_i64(ptr %t5753)
%t5756 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5751, i64 %t5754)
%t5757 = extractvalue {i64, i1} %t5756, 0
%t5758 = extractvalue {i64, i1} %t5756, 1
%t5759 = zext i1 %t5758 to i8
call void @resid_overflow_check(i8 %t5759)
%t5760 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5757)
%t5761 = call ptr @resid_list_get(ptr %p2, i64 2)
%t5762 = call i64 @resid_unbox_i64(ptr %t5761)
%t5764 = call ptr @resid_list_get(ptr %t5738, i64 2)
%t5765 = call i64 @resid_unbox_i64(ptr %t5764)
%t5767 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5762, i64 %t5765)
%t5768 = extractvalue {i64, i1} %t5767, 0
%t5769 = extractvalue {i64, i1} %t5767, 1
%t5770 = zext i1 %t5769 to i8
call void @resid_overflow_check(i8 %t5770)
%t5771 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5768)
%t5772 = call ptr @resid_list_get(ptr %p2, i64 3)
%t5773 = call i64 @resid_unbox_i64(ptr %t5772)
%t5775 = call ptr @resid_list_get(ptr %t5738, i64 3)
%t5776 = call i64 @resid_unbox_i64(ptr %t5775)
%t5778 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5773, i64 %t5776)
%t5779 = extractvalue {i64, i1} %t5778, 0
%t5780 = extractvalue {i64, i1} %t5778, 1
%t5781 = zext i1 %t5780 to i8
call void @resid_overflow_check(i8 %t5781)
%t5782 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5779)
%t5783 = call ptr @resid_list_get(ptr %p2, i64 4)
%t5784 = call i64 @resid_unbox_i64(ptr %t5783)
%t5786 = call ptr @resid_list_get(ptr %t5738, i64 4)
%t5787 = call i64 @resid_unbox_i64(ptr %t5786)
%t5789 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5784, i64 %t5787)
%t5790 = extractvalue {i64, i1} %t5789, 0
%t5791 = extractvalue {i64, i1} %t5789, 1
%t5792 = zext i1 %t5791 to i8
call void @resid_overflow_check(i8 %t5792)
%t5793 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5790)
%t5794 = alloca [5 x ptr]
%t5796 = call ptr @resid_box_i64(i64 %t5749)
%t5798 = getelementptr i8, ptr %t5794, i64 0
store ptr %t5796, ptr %t5798
%t5799 = call ptr @resid_box_i64(i64 %t5760)
%t5801 = getelementptr i8, ptr %t5794, i64 8
store ptr %t5799, ptr %t5801
%t5802 = call ptr @resid_box_i64(i64 %t5771)
%t5804 = getelementptr i8, ptr %t5794, i64 16
store ptr %t5802, ptr %t5804
%t5805 = call ptr @resid_box_i64(i64 %t5782)
%t5807 = getelementptr i8, ptr %t5794, i64 24
store ptr %t5805, ptr %t5807
%t5808 = call ptr @resid_box_i64(i64 %t5793)
%t5810 = getelementptr i8, ptr %t5794, i64 32
store ptr %t5808, ptr %t5810
%t5811 = call ptr @resid_list_new(i64 5, ptr %t5794, ptr @.lty5794)
ret ptr %t5811
}
define ptr @__m____________lib_crypto_resid__sha1_blocks(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5814, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t5818, %tco.s0.k ]
%t5812 = icmp sge i64 %p4, %p2
br i1 %t5812, label %L679, label %L681
L679:
%lr.cx12 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz12 = icmp eq ptr %lr.cx12, null
br i1 %lr.lz12, label %lr.x12.k, label %lr.x12.m
lr.x12.k:
ret ptr %p3
lr.x12.m:
%lr.ret12 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx12)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret12
L681:
%t5813 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 64)
%t5814 = extractvalue {i64, i1} %t5813, 0
%t5815 = extractvalue {i64, i1} %t5813, 1
%t5816 = zext i1 %t5815 to i8
call void @resid_overflow_check(i8 %t5816)
%t5817 = call ptr @__m____________lib_crypto_resid__sha1_step(ptr %p0, i64 %p1, ptr %p3)
%t5818 = add nsw i64 %p4, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t5817, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t5817, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_crypto_resid__sha1_be_bytes(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5834 = alloca [4 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5833, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t5820 = icmp sge i64 %p1, 5
br i1 %t5820, label %L682, label %L684
L682:
%lr.cx13 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz13 = icmp eq ptr %lr.cx13, null
br i1 %lr.lz13, label %lr.x13.k, label %lr.x13.m
lr.x13.k:
ret ptr %p2
lr.x13.m:
%lr.ret13 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx13)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret13
L684:
%t5821 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t5822 = call i64 @resid_unbox_i64(ptr %t5821)
%t5824 = ashr i64 %t5822, 24
%t5825 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5824)
%t5826 = ashr i64 %t5822, 16
%t5827 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5826)
%t5828 = and i64 %t5827, 255
%t5829 = ashr i64 %t5822, 8
%t5830 = call i64 @__m____________lib_crypto_resid__u32mask(i64 %t5829)
%t5831 = and i64 %t5830, 255
%t5832 = and i64 %t5822, 255
%t5833 = add nsw i64 %p1, 1
%t5836 = call ptr @resid_box_i64(i64 %t5825)
%t5838 = getelementptr i8, ptr %t5834, i64 0
store ptr %t5836, ptr %t5838
%t5839 = call ptr @resid_box_i64(i64 %t5828)
%t5841 = getelementptr i8, ptr %t5834, i64 8
store ptr %t5839, ptr %t5841
%t5842 = call ptr @resid_box_i64(i64 %t5831)
%t5844 = getelementptr i8, ptr %t5834, i64 16
store ptr %t5842, ptr %t5844
%t5845 = call ptr @resid_box_i64(i64 %t5832)
%t5847 = getelementptr i8, ptr %t5834, i64 24
store ptr %t5845, ptr %t5847
%t5848 = call ptr @resid_list_new(i64 4, ptr %t5834, ptr @.lty5834)
%t5849 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t5848)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t5849, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t5849, %tco.s0 ]
br label %tco.head
}
define ptr @sha1_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5851 = call ptr @pad_bytes(ptr %p0)
%t5852 = call i64 @resid_list_len(ptr %t5851)
%t5853 = sdiv i64 %t5852, 64
%t5855 = call ptr @resid_list_const_i64(ptr @.lc5854, i64 5, ptr @.lcd5854, ptr @.lty5854)
%t5856 = call ptr @__m____________lib_crypto_resid__sha1_blocks(ptr %t5851, i64 0, i64 %t5853, ptr %t5855, i64 0)
%t5858 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty5857)
%t5859 = call ptr @__m____________lib_crypto_resid__sha1_be_bytes(ptr %t5856, i64 0, ptr %t5858)
ret ptr %t5859
}
define ptr @__m____________lib_sha512g_resid__sha512g_k() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5860 = add i64 4794697086780616226, 0
%t5861 = add i64 %t5860, 0
%t5862 = add i64 %t5861, 0
%t5863 = icmp ne i64 %t5862, %t5860
%t5864 = icmp slt i64 4794697086780616226, 0
%t5865 = or i1 %t5863, %t5864
%t5866 = zext i1 %t5865 to i8
call void @resid_conv_check(i8 %t5866)
%t5867 = add i64 8158064640168781261, 0
%t5868 = add i64 %t5867, 0
%t5869 = add i64 %t5868, 0
%t5870 = icmp ne i64 %t5869, %t5867
%t5871 = icmp slt i64 8158064640168781261, 0
%t5872 = or i1 %t5870, %t5871
%t5873 = zext i1 %t5872 to i8
call void @resid_conv_check(i8 %t5873)
%t5874 = add i128 13096744586834688815, 0
%t5875 = trunc i128 %t5874 to i64
%t5876 = zext i64 %t5875 to i128
%t5877 = icmp ne i128 %t5876, %t5874
%t5878 = icmp slt i128 13096744586834688815, 0
%t5879 = or i1 %t5877, %t5878
%t5880 = zext i1 %t5879 to i8
call void @resid_conv_check(i8 %t5880)
%t5881 = add i128 16840607885511220156, 0
%t5882 = trunc i128 %t5881 to i64
%t5883 = zext i64 %t5882 to i128
%t5884 = icmp ne i128 %t5883, %t5881
%t5885 = icmp slt i128 16840607885511220156, 0
%t5886 = or i1 %t5884, %t5885
%t5887 = zext i1 %t5886 to i8
call void @resid_conv_check(i8 %t5887)
%t5888 = add i64 4131703408338449720, 0
%t5889 = add i64 %t5888, 0
%t5890 = add i64 %t5889, 0
%t5891 = icmp ne i64 %t5890, %t5888
%t5892 = icmp slt i64 4131703408338449720, 0
%t5893 = or i1 %t5891, %t5892
%t5894 = zext i1 %t5893 to i8
call void @resid_conv_check(i8 %t5894)
%t5895 = add i64 6480981068601479193, 0
%t5896 = add i64 %t5895, 0
%t5897 = add i64 %t5896, 0
%t5898 = icmp ne i64 %t5897, %t5895
%t5899 = icmp slt i64 6480981068601479193, 0
%t5900 = or i1 %t5898, %t5899
%t5901 = zext i1 %t5900 to i8
call void @resid_conv_check(i8 %t5901)
%t5902 = add i128 10538285296894168987, 0
%t5903 = trunc i128 %t5902 to i64
%t5904 = zext i64 %t5903 to i128
%t5905 = icmp ne i128 %t5904, %t5902
%t5906 = icmp slt i128 10538285296894168987, 0
%t5907 = or i1 %t5905, %t5906
%t5908 = zext i1 %t5907 to i8
call void @resid_conv_check(i8 %t5908)
%t5909 = add i128 12329834152419229976, 0
%t5910 = trunc i128 %t5909 to i64
%t5911 = zext i64 %t5910 to i128
%t5912 = icmp ne i128 %t5911, %t5909
%t5913 = icmp slt i128 12329834152419229976, 0
%t5914 = or i1 %t5912, %t5913
%t5915 = zext i1 %t5914 to i8
call void @resid_conv_check(i8 %t5915)
%t5916 = add i128 15566598209576043074, 0
%t5917 = trunc i128 %t5916 to i64
%t5918 = zext i64 %t5917 to i128
%t5919 = icmp ne i128 %t5918, %t5916
%t5920 = icmp slt i128 15566598209576043074, 0
%t5921 = or i1 %t5919, %t5920
%t5922 = zext i1 %t5921 to i8
call void @resid_conv_check(i8 %t5922)
%t5923 = add i64 1334009975649890238, 0
%t5924 = add i64 %t5923, 0
%t5925 = add i64 %t5924, 0
%t5926 = icmp ne i64 %t5925, %t5923
%t5927 = icmp slt i64 1334009975649890238, 0
%t5928 = or i1 %t5926, %t5927
%t5929 = zext i1 %t5928 to i8
call void @resid_conv_check(i8 %t5929)
%t5930 = add i64 2608012711638119052, 0
%t5931 = add i64 %t5930, 0
%t5932 = add i64 %t5931, 0
%t5933 = icmp ne i64 %t5932, %t5930
%t5934 = icmp slt i64 2608012711638119052, 0
%t5935 = or i1 %t5933, %t5934
%t5936 = zext i1 %t5935 to i8
call void @resid_conv_check(i8 %t5936)
%t5937 = add i64 6128411473006802146, 0
%t5938 = add i64 %t5937, 0
%t5939 = add i64 %t5938, 0
%t5940 = icmp ne i64 %t5939, %t5937
%t5941 = icmp slt i64 6128411473006802146, 0
%t5942 = or i1 %t5940, %t5941
%t5943 = zext i1 %t5942 to i8
call void @resid_conv_check(i8 %t5943)
%t5944 = add i64 8268148722764581231, 0
%t5945 = add i64 %t5944, 0
%t5946 = add i64 %t5945, 0
%t5947 = icmp ne i64 %t5946, %t5944
%t5948 = icmp slt i64 8268148722764581231, 0
%t5949 = or i1 %t5947, %t5948
%t5950 = zext i1 %t5949 to i8
call void @resid_conv_check(i8 %t5950)
%t5951 = add i128 9286055187155687089, 0
%t5952 = trunc i128 %t5951 to i64
%t5953 = zext i64 %t5952 to i128
%t5954 = icmp ne i128 %t5953, %t5951
%t5955 = icmp slt i128 9286055187155687089, 0
%t5956 = or i1 %t5954, %t5955
%t5957 = zext i1 %t5956 to i8
call void @resid_conv_check(i8 %t5957)
%t5958 = add i128 11230858885718282805, 0
%t5959 = trunc i128 %t5958 to i64
%t5960 = zext i64 %t5959 to i128
%t5961 = icmp ne i128 %t5960, %t5958
%t5962 = icmp slt i128 11230858885718282805, 0
%t5963 = or i1 %t5961, %t5962
%t5964 = zext i1 %t5963 to i8
call void @resid_conv_check(i8 %t5964)
%t5965 = add i128 13951009754708518548, 0
%t5966 = trunc i128 %t5965 to i64
%t5967 = zext i64 %t5966 to i128
%t5968 = icmp ne i128 %t5967, %t5965
%t5969 = icmp slt i128 13951009754708518548, 0
%t5970 = or i1 %t5968, %t5969
%t5971 = zext i1 %t5970 to i8
call void @resid_conv_check(i8 %t5971)
%t5972 = add i128 16472876342353939154, 0
%t5973 = trunc i128 %t5972 to i64
%t5974 = zext i64 %t5973 to i128
%t5975 = icmp ne i128 %t5974, %t5972
%t5976 = icmp slt i128 16472876342353939154, 0
%t5977 = or i1 %t5975, %t5976
%t5978 = zext i1 %t5977 to i8
call void @resid_conv_check(i8 %t5978)
%t5979 = add i128 17275323862435702243, 0
%t5980 = trunc i128 %t5979 to i64
%t5981 = zext i64 %t5980 to i128
%t5982 = icmp ne i128 %t5981, %t5979
%t5983 = icmp slt i128 17275323862435702243, 0
%t5984 = or i1 %t5982, %t5983
%t5985 = zext i1 %t5984 to i8
call void @resid_conv_check(i8 %t5985)
%t5986 = add i64 1135362057144423861, 0
%t5987 = add i64 %t5986, 0
%t5988 = add i64 %t5987, 0
%t5989 = icmp ne i64 %t5988, %t5986
%t5990 = icmp slt i64 1135362057144423861, 0
%t5991 = or i1 %t5989, %t5990
%t5992 = zext i1 %t5991 to i8
call void @resid_conv_check(i8 %t5992)
%t5993 = add i64 2597628984639134821, 0
%t5994 = add i64 %t5993, 0
%t5995 = add i64 %t5994, 0
%t5996 = icmp ne i64 %t5995, %t5993
%t5997 = icmp slt i64 2597628984639134821, 0
%t5998 = or i1 %t5996, %t5997
%t5999 = zext i1 %t5998 to i8
call void @resid_conv_check(i8 %t5999)
%t6000 = add i64 3308224258029322869, 0
%t6001 = add i64 %t6000, 0
%t6002 = add i64 %t6001, 0
%t6003 = icmp ne i64 %t6002, %t6000
%t6004 = icmp slt i64 3308224258029322869, 0
%t6005 = or i1 %t6003, %t6004
%t6006 = zext i1 %t6005 to i8
call void @resid_conv_check(i8 %t6006)
%t6007 = add i64 5365058923640841347, 0
%t6008 = add i64 %t6007, 0
%t6009 = add i64 %t6008, 0
%t6010 = icmp ne i64 %t6009, %t6007
%t6011 = icmp slt i64 5365058923640841347, 0
%t6012 = or i1 %t6010, %t6011
%t6013 = zext i1 %t6012 to i8
call void @resid_conv_check(i8 %t6013)
%t6014 = add i64 6679025012923562964, 0
%t6015 = add i64 %t6014, 0
%t6016 = add i64 %t6015, 0
%t6017 = icmp ne i64 %t6016, %t6014
%t6018 = icmp slt i64 6679025012923562964, 0
%t6019 = or i1 %t6017, %t6018
%t6020 = zext i1 %t6019 to i8
call void @resid_conv_check(i8 %t6020)
%t6021 = add i64 8573033837759648693, 0
%t6022 = add i64 %t6021, 0
%t6023 = add i64 %t6022, 0
%t6024 = icmp ne i64 %t6023, %t6021
%t6025 = icmp slt i64 8573033837759648693, 0
%t6026 = or i1 %t6024, %t6025
%t6027 = zext i1 %t6026 to i8
call void @resid_conv_check(i8 %t6027)
%t6028 = add i128 10970295158949994411, 0
%t6029 = trunc i128 %t6028 to i64
%t6030 = zext i64 %t6029 to i128
%t6031 = icmp ne i128 %t6030, %t6028
%t6032 = icmp slt i128 10970295158949994411, 0
%t6033 = or i1 %t6031, %t6032
%t6034 = zext i1 %t6033 to i8
call void @resid_conv_check(i8 %t6034)
%t6035 = add i128 12119686244451234320, 0
%t6036 = trunc i128 %t6035 to i64
%t6037 = zext i64 %t6036 to i128
%t6038 = icmp ne i128 %t6037, %t6035
%t6039 = icmp slt i128 12119686244451234320, 0
%t6040 = or i1 %t6038, %t6039
%t6041 = zext i1 %t6040 to i8
call void @resid_conv_check(i8 %t6041)
%t6042 = add i128 12683024718118986047, 0
%t6043 = trunc i128 %t6042 to i64
%t6044 = zext i64 %t6043 to i128
%t6045 = icmp ne i128 %t6044, %t6042
%t6046 = icmp slt i128 12683024718118986047, 0
%t6047 = or i1 %t6045, %t6046
%t6048 = zext i1 %t6047 to i8
call void @resid_conv_check(i8 %t6048)
%t6049 = add i128 13788192230050041572, 0
%t6050 = trunc i128 %t6049 to i64
%t6051 = zext i64 %t6050 to i128
%t6052 = icmp ne i128 %t6051, %t6049
%t6053 = icmp slt i128 13788192230050041572, 0
%t6054 = or i1 %t6052, %t6053
%t6055 = zext i1 %t6054 to i8
call void @resid_conv_check(i8 %t6055)
%t6056 = add i128 14330467153632333762, 0
%t6057 = trunc i128 %t6056 to i64
%t6058 = zext i64 %t6057 to i128
%t6059 = icmp ne i128 %t6058, %t6056
%t6060 = icmp slt i128 14330467153632333762, 0
%t6061 = or i1 %t6059, %t6060
%t6062 = zext i1 %t6061 to i8
call void @resid_conv_check(i8 %t6062)
%t6063 = add i128 15395433587784984357, 0
%t6064 = trunc i128 %t6063 to i64
%t6065 = zext i64 %t6064 to i128
%t6066 = icmp ne i128 %t6065, %t6063
%t6067 = icmp slt i128 15395433587784984357, 0
%t6068 = or i1 %t6066, %t6067
%t6069 = zext i1 %t6068 to i8
call void @resid_conv_check(i8 %t6069)
%t6070 = add i64 1452737877330783856, 0
%t6071 = add i64 %t6070, 0
%t6072 = add i64 %t6071, 0
%t6073 = icmp ne i64 %t6072, %t6070
%t6074 = icmp slt i64 1452737877330783856, 0
%t6075 = or i1 %t6073, %t6074
%t6076 = zext i1 %t6075 to i8
call void @resid_conv_check(i8 %t6076)
%t6077 = add i64 2861767655752347644, 0
%t6078 = add i64 %t6077, 0
%t6079 = add i64 %t6078, 0
%t6080 = icmp ne i64 %t6079, %t6077
%t6081 = icmp slt i64 2861767655752347644, 0
%t6082 = or i1 %t6080, %t6081
%t6083 = zext i1 %t6082 to i8
call void @resid_conv_check(i8 %t6083)
%t6084 = add i64 3322285676063803686, 0
%t6085 = add i64 %t6084, 0
%t6086 = add i64 %t6085, 0
%t6087 = icmp ne i64 %t6086, %t6084
%t6088 = icmp slt i64 3322285676063803686, 0
%t6089 = or i1 %t6087, %t6088
%t6090 = zext i1 %t6089 to i8
call void @resid_conv_check(i8 %t6090)
%t6091 = add i64 5560940570517711597, 0
%t6092 = add i64 %t6091, 0
%t6093 = add i64 %t6092, 0
%t6094 = icmp ne i64 %t6093, %t6091
%t6095 = icmp slt i64 5560940570517711597, 0
%t6096 = or i1 %t6094, %t6095
%t6097 = zext i1 %t6096 to i8
call void @resid_conv_check(i8 %t6097)
%t6098 = add i64 5996557281743188959, 0
%t6099 = add i64 %t6098, 0
%t6100 = add i64 %t6099, 0
%t6101 = icmp ne i64 %t6100, %t6098
%t6102 = icmp slt i64 5996557281743188959, 0
%t6103 = or i1 %t6101, %t6102
%t6104 = zext i1 %t6103 to i8
call void @resid_conv_check(i8 %t6104)
%t6105 = add i64 7280758554555802590, 0
%t6106 = add i64 %t6105, 0
%t6107 = add i64 %t6106, 0
%t6108 = icmp ne i64 %t6107, %t6105
%t6109 = icmp slt i64 7280758554555802590, 0
%t6110 = or i1 %t6108, %t6109
%t6111 = zext i1 %t6110 to i8
call void @resid_conv_check(i8 %t6111)
%t6112 = add i64 8532644243296465576, 0
%t6113 = add i64 %t6112, 0
%t6114 = add i64 %t6113, 0
%t6115 = icmp ne i64 %t6114, %t6112
%t6116 = icmp slt i64 8532644243296465576, 0
%t6117 = or i1 %t6115, %t6116
%t6118 = zext i1 %t6117 to i8
call void @resid_conv_check(i8 %t6118)
%t6119 = add i128 9350256976987008742, 0
%t6120 = trunc i128 %t6119 to i64
%t6121 = zext i64 %t6120 to i128
%t6122 = icmp ne i128 %t6121, %t6119
%t6123 = icmp slt i128 9350256976987008742, 0
%t6124 = or i1 %t6122, %t6123
%t6125 = zext i1 %t6124 to i8
call void @resid_conv_check(i8 %t6125)
%t6126 = add i128 10552545826968843579, 0
%t6127 = trunc i128 %t6126 to i64
%t6128 = zext i64 %t6127 to i128
%t6129 = icmp ne i128 %t6128, %t6126
%t6130 = icmp slt i128 10552545826968843579, 0
%t6131 = or i1 %t6129, %t6130
%t6132 = zext i1 %t6131 to i8
call void @resid_conv_check(i8 %t6132)
%t6133 = add i128 11727347734174303076, 0
%t6134 = trunc i128 %t6133 to i64
%t6135 = zext i64 %t6134 to i128
%t6136 = icmp ne i128 %t6135, %t6133
%t6137 = icmp slt i128 11727347734174303076, 0
%t6138 = or i1 %t6136, %t6137
%t6139 = zext i1 %t6138 to i8
call void @resid_conv_check(i8 %t6139)
%t6140 = add i128 12113106623233404929, 0
%t6141 = trunc i128 %t6140 to i64
%t6142 = zext i64 %t6141 to i128
%t6143 = icmp ne i128 %t6142, %t6140
%t6144 = icmp slt i128 12113106623233404929, 0
%t6145 = or i1 %t6143, %t6144
%t6146 = zext i1 %t6145 to i8
call void @resid_conv_check(i8 %t6146)
%t6147 = add i128 14000437183269869457, 0
%t6148 = trunc i128 %t6147 to i64
%t6149 = zext i64 %t6148 to i128
%t6150 = icmp ne i128 %t6149, %t6147
%t6151 = icmp slt i128 14000437183269869457, 0
%t6152 = or i1 %t6150, %t6151
%t6153 = zext i1 %t6152 to i8
call void @resid_conv_check(i8 %t6153)
%t6154 = add i128 14369950271660146224, 0
%t6155 = trunc i128 %t6154 to i64
%t6156 = zext i64 %t6155 to i128
%t6157 = icmp ne i128 %t6156, %t6154
%t6158 = icmp slt i128 14369950271660146224, 0
%t6159 = or i1 %t6157, %t6158
%t6160 = zext i1 %t6159 to i8
call void @resid_conv_check(i8 %t6160)
%t6161 = add i128 15101387698204529176, 0
%t6162 = trunc i128 %t6161 to i64
%t6163 = zext i64 %t6162 to i128
%t6164 = icmp ne i128 %t6163, %t6161
%t6165 = icmp slt i128 15101387698204529176, 0
%t6166 = or i1 %t6164, %t6165
%t6167 = zext i1 %t6166 to i8
call void @resid_conv_check(i8 %t6167)
%t6168 = add i128 15463397548674623760, 0
%t6169 = trunc i128 %t6168 to i64
%t6170 = zext i64 %t6169 to i128
%t6171 = icmp ne i128 %t6170, %t6168
%t6172 = icmp slt i128 15463397548674623760, 0
%t6173 = or i1 %t6171, %t6172
%t6174 = zext i1 %t6173 to i8
call void @resid_conv_check(i8 %t6174)
%t6175 = add i128 17586052441742319658, 0
%t6176 = trunc i128 %t6175 to i64
%t6177 = zext i64 %t6176 to i128
%t6178 = icmp ne i128 %t6177, %t6175
%t6179 = icmp slt i128 17586052441742319658, 0
%t6180 = or i1 %t6178, %t6179
%t6181 = zext i1 %t6180 to i8
call void @resid_conv_check(i8 %t6181)
%t6182 = add i64 1182934255886127544, 0
%t6183 = add i64 %t6182, 0
%t6184 = add i64 %t6183, 0
%t6185 = icmp ne i64 %t6184, %t6182
%t6186 = icmp slt i64 1182934255886127544, 0
%t6187 = or i1 %t6185, %t6186
%t6188 = zext i1 %t6187 to i8
call void @resid_conv_check(i8 %t6188)
%t6189 = add i64 1847814050463011016, 0
%t6190 = add i64 %t6189, 0
%t6191 = add i64 %t6190, 0
%t6192 = icmp ne i64 %t6191, %t6189
%t6193 = icmp slt i64 1847814050463011016, 0
%t6194 = or i1 %t6192, %t6193
%t6195 = zext i1 %t6194 to i8
call void @resid_conv_check(i8 %t6195)
%t6196 = add i64 2177327727835720531, 0
%t6197 = add i64 %t6196, 0
%t6198 = add i64 %t6197, 0
%t6199 = icmp ne i64 %t6198, %t6196
%t6200 = icmp slt i64 2177327727835720531, 0
%t6201 = or i1 %t6199, %t6200
%t6202 = zext i1 %t6201 to i8
call void @resid_conv_check(i8 %t6202)
%t6203 = add i64 2830643537854262169, 0
%t6204 = add i64 %t6203, 0
%t6205 = add i64 %t6204, 0
%t6206 = icmp ne i64 %t6205, %t6203
%t6207 = icmp slt i64 2830643537854262169, 0
%t6208 = or i1 %t6206, %t6207
%t6209 = zext i1 %t6208 to i8
call void @resid_conv_check(i8 %t6209)
%t6210 = add i64 3796741975233480872, 0
%t6211 = add i64 %t6210, 0
%t6212 = add i64 %t6211, 0
%t6213 = icmp ne i64 %t6212, %t6210
%t6214 = icmp slt i64 3796741975233480872, 0
%t6215 = or i1 %t6213, %t6214
%t6216 = zext i1 %t6215 to i8
call void @resid_conv_check(i8 %t6216)
%t6217 = add i64 4115178125766777443, 0
%t6218 = add i64 %t6217, 0
%t6219 = add i64 %t6218, 0
%t6220 = icmp ne i64 %t6219, %t6217
%t6221 = icmp slt i64 4115178125766777443, 0
%t6222 = or i1 %t6220, %t6221
%t6223 = zext i1 %t6222 to i8
call void @resid_conv_check(i8 %t6223)
%t6224 = add i64 5681478168544905931, 0
%t6225 = add i64 %t6224, 0
%t6226 = add i64 %t6225, 0
%t6227 = icmp ne i64 %t6226, %t6224
%t6228 = icmp slt i64 5681478168544905931, 0
%t6229 = or i1 %t6227, %t6228
%t6230 = zext i1 %t6229 to i8
call void @resid_conv_check(i8 %t6230)
%t6231 = add i64 6601373596472566643, 0
%t6232 = add i64 %t6231, 0
%t6233 = add i64 %t6232, 0
%t6234 = icmp ne i64 %t6233, %t6231
%t6235 = icmp slt i64 6601373596472566643, 0
%t6236 = or i1 %t6234, %t6235
%t6237 = zext i1 %t6236 to i8
call void @resid_conv_check(i8 %t6237)
%t6238 = add i64 7507060721942968483, 0
%t6239 = add i64 %t6238, 0
%t6240 = add i64 %t6239, 0
%t6241 = icmp ne i64 %t6240, %t6238
%t6242 = icmp slt i64 7507060721942968483, 0
%t6243 = or i1 %t6241, %t6242
%t6244 = zext i1 %t6243 to i8
call void @resid_conv_check(i8 %t6244)
%t6245 = add i64 8399075790359081724, 0
%t6246 = add i64 %t6245, 0
%t6247 = add i64 %t6246, 0
%t6248 = icmp ne i64 %t6247, %t6245
%t6249 = icmp slt i64 8399075790359081724, 0
%t6250 = or i1 %t6248, %t6249
%t6251 = zext i1 %t6250 to i8
call void @resid_conv_check(i8 %t6251)
%t6252 = add i64 8693463985226723168, 0
%t6253 = add i64 %t6252, 0
%t6254 = add i64 %t6253, 0
%t6255 = icmp ne i64 %t6254, %t6252
%t6256 = icmp slt i64 8693463985226723168, 0
%t6257 = or i1 %t6255, %t6256
%t6258 = zext i1 %t6257 to i8
call void @resid_conv_check(i8 %t6258)
%t6259 = add i128 9568029438360202098, 0
%t6260 = trunc i128 %t6259 to i64
%t6261 = zext i64 %t6260 to i128
%t6262 = icmp ne i128 %t6261, %t6259
%t6263 = icmp slt i128 9568029438360202098, 0
%t6264 = or i1 %t6262, %t6263
%t6265 = zext i1 %t6264 to i8
call void @resid_conv_check(i8 %t6265)
%t6266 = add i128 10144078919501101548, 0
%t6267 = trunc i128 %t6266 to i64
%t6268 = zext i64 %t6267 to i128
%t6269 = icmp ne i128 %t6268, %t6266
%t6270 = icmp slt i128 10144078919501101548, 0
%t6271 = or i1 %t6269, %t6270
%t6272 = zext i1 %t6271 to i8
call void @resid_conv_check(i8 %t6272)
%t6273 = add i128 10430055236837252648, 0
%t6274 = trunc i128 %t6273 to i64
%t6275 = zext i64 %t6274 to i128
%t6276 = icmp ne i128 %t6275, %t6273
%t6277 = icmp slt i128 10430055236837252648, 0
%t6278 = or i1 %t6276, %t6277
%t6279 = zext i1 %t6278 to i8
call void @resid_conv_check(i8 %t6279)
%t6280 = add i128 11840083180663258601, 0
%t6281 = trunc i128 %t6280 to i64
%t6282 = zext i64 %t6281 to i128
%t6283 = icmp ne i128 %t6282, %t6280
%t6284 = icmp slt i128 11840083180663258601, 0
%t6285 = or i1 %t6283, %t6284
%t6286 = zext i1 %t6285 to i8
call void @resid_conv_check(i8 %t6286)
%t6287 = add i128 13761210420658862357, 0
%t6288 = trunc i128 %t6287 to i64
%t6289 = zext i64 %t6288 to i128
%t6290 = icmp ne i128 %t6289, %t6287
%t6291 = icmp slt i128 13761210420658862357, 0
%t6292 = or i1 %t6290, %t6291
%t6293 = zext i1 %t6292 to i8
call void @resid_conv_check(i8 %t6293)
%t6294 = add i128 14299343276471374635, 0
%t6295 = trunc i128 %t6294 to i64
%t6296 = zext i64 %t6295 to i128
%t6297 = icmp ne i128 %t6296, %t6294
%t6298 = icmp slt i128 14299343276471374635, 0
%t6299 = or i1 %t6297, %t6298
%t6300 = zext i1 %t6299 to i8
call void @resid_conv_check(i8 %t6300)
%t6301 = add i128 14566680578165727644, 0
%t6302 = trunc i128 %t6301 to i64
%t6303 = zext i64 %t6302 to i128
%t6304 = icmp ne i128 %t6303, %t6301
%t6305 = icmp slt i128 14566680578165727644, 0
%t6306 = or i1 %t6304, %t6305
%t6307 = zext i1 %t6306 to i8
call void @resid_conv_check(i8 %t6307)
%t6308 = add i128 15097957966210449927, 0
%t6309 = trunc i128 %t6308 to i64
%t6310 = zext i64 %t6309 to i128
%t6311 = icmp ne i128 %t6310, %t6308
%t6312 = icmp slt i128 15097957966210449927, 0
%t6313 = or i1 %t6311, %t6312
%t6314 = zext i1 %t6313 to i8
call void @resid_conv_check(i8 %t6314)
%t6315 = add i128 16922976911328602910, 0
%t6316 = trunc i128 %t6315 to i64
%t6317 = zext i64 %t6316 to i128
%t6318 = icmp ne i128 %t6317, %t6315
%t6319 = icmp slt i128 16922976911328602910, 0
%t6320 = or i1 %t6318, %t6319
%t6321 = zext i1 %t6320 to i8
call void @resid_conv_check(i8 %t6321)
%t6322 = add i128 17689382322260857208, 0
%t6323 = trunc i128 %t6322 to i64
%t6324 = zext i64 %t6323 to i128
%t6325 = icmp ne i128 %t6324, %t6322
%t6326 = icmp slt i128 17689382322260857208, 0
%t6327 = or i1 %t6325, %t6326
%t6328 = zext i1 %t6327 to i8
call void @resid_conv_check(i8 %t6328)
%t6329 = add i64 1242879168328830382, 0
%t6330 = add i64 %t6329, 0
%t6331 = add i64 %t6330, 0
%t6332 = icmp ne i64 %t6331, %t6329
%t6333 = icmp slt i64 1242879168328830382, 0
%t6334 = or i1 %t6332, %t6333
%t6335 = zext i1 %t6334 to i8
call void @resid_conv_check(i8 %t6335)
%t6336 = add i64 1977374033974150939, 0
%t6337 = add i64 %t6336, 0
%t6338 = add i64 %t6337, 0
%t6339 = icmp ne i64 %t6338, %t6336
%t6340 = icmp slt i64 1977374033974150939, 0
%t6341 = or i1 %t6339, %t6340
%t6342 = zext i1 %t6341 to i8
call void @resid_conv_check(i8 %t6342)
%t6343 = add i64 2944078676154940804, 0
%t6344 = add i64 %t6343, 0
%t6345 = add i64 %t6344, 0
%t6346 = icmp ne i64 %t6345, %t6343
%t6347 = icmp slt i64 2944078676154940804, 0
%t6348 = or i1 %t6346, %t6347
%t6349 = zext i1 %t6348 to i8
call void @resid_conv_check(i8 %t6349)
%t6350 = add i64 3659926193048069267, 0
%t6351 = add i64 %t6350, 0
%t6352 = add i64 %t6351, 0
%t6353 = icmp ne i64 %t6352, %t6350
%t6354 = icmp slt i64 3659926193048069267, 0
%t6355 = or i1 %t6353, %t6354
%t6356 = zext i1 %t6355 to i8
call void @resid_conv_check(i8 %t6356)
%t6357 = add i64 4368137639120453308, 0
%t6358 = add i64 %t6357, 0
%t6359 = add i64 %t6358, 0
%t6360 = icmp ne i64 %t6359, %t6357
%t6361 = icmp slt i64 4368137639120453308, 0
%t6362 = or i1 %t6360, %t6361
%t6363 = zext i1 %t6362 to i8
call void @resid_conv_check(i8 %t6363)
%t6364 = add i64 4836135668995329356, 0
%t6365 = add i64 %t6364, 0
%t6366 = add i64 %t6365, 0
%t6367 = icmp ne i64 %t6366, %t6364
%t6368 = icmp slt i64 4836135668995329356, 0
%t6369 = or i1 %t6367, %t6368
%t6370 = zext i1 %t6369 to i8
call void @resid_conv_check(i8 %t6370)
%t6371 = add i64 5532061633213252278, 0
%t6372 = add i64 %t6371, 0
%t6373 = add i64 %t6372, 0
%t6374 = icmp ne i64 %t6373, %t6371
%t6375 = icmp slt i64 5532061633213252278, 0
%t6376 = or i1 %t6374, %t6375
%t6377 = zext i1 %t6376 to i8
call void @resid_conv_check(i8 %t6377)
%t6378 = add i64 6448918945643986474, 0
%t6379 = add i64 %t6378, 0
%t6380 = add i64 %t6379, 0
%t6381 = icmp ne i64 %t6380, %t6378
%t6382 = icmp slt i64 6448918945643986474, 0
%t6383 = or i1 %t6381, %t6382
%t6384 = zext i1 %t6383 to i8
call void @resid_conv_check(i8 %t6384)
%t6385 = add i64 6902733635092675308, 0
%t6386 = add i64 %t6385, 0
%t6387 = add i64 %t6386, 0
%t6388 = icmp ne i64 %t6387, %t6385
%t6389 = icmp slt i64 6902733635092675308, 0
%t6390 = or i1 %t6388, %t6389
%t6391 = zext i1 %t6390 to i8
call void @resid_conv_check(i8 %t6391)
%t6392 = add i64 7801388544844847127, 0
%t6393 = add i64 %t6392, 0
%t6394 = add i64 %t6393, 0
%t6395 = icmp ne i64 %t6394, %t6392
%t6396 = icmp slt i64 7801388544844847127, 0
%t6397 = or i1 %t6395, %t6396
%t6398 = zext i1 %t6397 to i8
call void @resid_conv_check(i8 %t6398)
%t6399 = alloca [80 x ptr]
%t6401 = call ptr @resid_box_i64(i64 %t5861)
%t6403 = getelementptr i8, ptr %t6399, i64 0
store ptr %t6401, ptr %t6403
%t6404 = call ptr @resid_box_i64(i64 %t5868)
%t6406 = getelementptr i8, ptr %t6399, i64 8
store ptr %t6404, ptr %t6406
%t6407 = call ptr @resid_box_i64(i64 %t5875)
%t6409 = getelementptr i8, ptr %t6399, i64 16
store ptr %t6407, ptr %t6409
%t6410 = call ptr @resid_box_i64(i64 %t5882)
%t6412 = getelementptr i8, ptr %t6399, i64 24
store ptr %t6410, ptr %t6412
%t6413 = call ptr @resid_box_i64(i64 %t5889)
%t6415 = getelementptr i8, ptr %t6399, i64 32
store ptr %t6413, ptr %t6415
%t6416 = call ptr @resid_box_i64(i64 %t5896)
%t6418 = getelementptr i8, ptr %t6399, i64 40
store ptr %t6416, ptr %t6418
%t6419 = call ptr @resid_box_i64(i64 %t5903)
%t6421 = getelementptr i8, ptr %t6399, i64 48
store ptr %t6419, ptr %t6421
%t6422 = call ptr @resid_box_i64(i64 %t5910)
%t6424 = getelementptr i8, ptr %t6399, i64 56
store ptr %t6422, ptr %t6424
%t6425 = call ptr @resid_box_i64(i64 %t5917)
%t6427 = getelementptr i8, ptr %t6399, i64 64
store ptr %t6425, ptr %t6427
%t6428 = call ptr @resid_box_i64(i64 %t5924)
%t6430 = getelementptr i8, ptr %t6399, i64 72
store ptr %t6428, ptr %t6430
%t6431 = call ptr @resid_box_i64(i64 %t5931)
%t6433 = getelementptr i8, ptr %t6399, i64 80
store ptr %t6431, ptr %t6433
%t6434 = call ptr @resid_box_i64(i64 %t5938)
%t6436 = getelementptr i8, ptr %t6399, i64 88
store ptr %t6434, ptr %t6436
%t6437 = call ptr @resid_box_i64(i64 %t5945)
%t6439 = getelementptr i8, ptr %t6399, i64 96
store ptr %t6437, ptr %t6439
%t6440 = call ptr @resid_box_i64(i64 %t5952)
%t6442 = getelementptr i8, ptr %t6399, i64 104
store ptr %t6440, ptr %t6442
%t6443 = call ptr @resid_box_i64(i64 %t5959)
%t6445 = getelementptr i8, ptr %t6399, i64 112
store ptr %t6443, ptr %t6445
%t6446 = call ptr @resid_box_i64(i64 %t5966)
%t6448 = getelementptr i8, ptr %t6399, i64 120
store ptr %t6446, ptr %t6448
%t6449 = call ptr @resid_box_i64(i64 %t5973)
%t6451 = getelementptr i8, ptr %t6399, i64 128
store ptr %t6449, ptr %t6451
%t6452 = call ptr @resid_box_i64(i64 %t5980)
%t6454 = getelementptr i8, ptr %t6399, i64 136
store ptr %t6452, ptr %t6454
%t6455 = call ptr @resid_box_i64(i64 %t5987)
%t6457 = getelementptr i8, ptr %t6399, i64 144
store ptr %t6455, ptr %t6457
%t6458 = call ptr @resid_box_i64(i64 %t5994)
%t6460 = getelementptr i8, ptr %t6399, i64 152
store ptr %t6458, ptr %t6460
%t6461 = call ptr @resid_box_i64(i64 %t6001)
%t6463 = getelementptr i8, ptr %t6399, i64 160
store ptr %t6461, ptr %t6463
%t6464 = call ptr @resid_box_i64(i64 %t6008)
%t6466 = getelementptr i8, ptr %t6399, i64 168
store ptr %t6464, ptr %t6466
%t6467 = call ptr @resid_box_i64(i64 %t6015)
%t6469 = getelementptr i8, ptr %t6399, i64 176
store ptr %t6467, ptr %t6469
%t6470 = call ptr @resid_box_i64(i64 %t6022)
%t6472 = getelementptr i8, ptr %t6399, i64 184
store ptr %t6470, ptr %t6472
%t6473 = call ptr @resid_box_i64(i64 %t6029)
%t6475 = getelementptr i8, ptr %t6399, i64 192
store ptr %t6473, ptr %t6475
%t6476 = call ptr @resid_box_i64(i64 %t6036)
%t6478 = getelementptr i8, ptr %t6399, i64 200
store ptr %t6476, ptr %t6478
%t6479 = call ptr @resid_box_i64(i64 %t6043)
%t6481 = getelementptr i8, ptr %t6399, i64 208
store ptr %t6479, ptr %t6481
%t6482 = call ptr @resid_box_i64(i64 %t6050)
%t6484 = getelementptr i8, ptr %t6399, i64 216
store ptr %t6482, ptr %t6484
%t6485 = call ptr @resid_box_i64(i64 %t6057)
%t6487 = getelementptr i8, ptr %t6399, i64 224
store ptr %t6485, ptr %t6487
%t6488 = call ptr @resid_box_i64(i64 %t6064)
%t6490 = getelementptr i8, ptr %t6399, i64 232
store ptr %t6488, ptr %t6490
%t6491 = call ptr @resid_box_i64(i64 489312712824947311)
%t6493 = getelementptr i8, ptr %t6399, i64 240
store ptr %t6491, ptr %t6493
%t6494 = call ptr @resid_box_i64(i64 %t6071)
%t6496 = getelementptr i8, ptr %t6399, i64 248
store ptr %t6494, ptr %t6496
%t6497 = call ptr @resid_box_i64(i64 %t6078)
%t6499 = getelementptr i8, ptr %t6399, i64 256
store ptr %t6497, ptr %t6499
%t6500 = call ptr @resid_box_i64(i64 %t6085)
%t6502 = getelementptr i8, ptr %t6399, i64 264
store ptr %t6500, ptr %t6502
%t6503 = call ptr @resid_box_i64(i64 %t6092)
%t6505 = getelementptr i8, ptr %t6399, i64 272
store ptr %t6503, ptr %t6505
%t6506 = call ptr @resid_box_i64(i64 %t6099)
%t6508 = getelementptr i8, ptr %t6399, i64 280
store ptr %t6506, ptr %t6508
%t6509 = call ptr @resid_box_i64(i64 %t6106)
%t6511 = getelementptr i8, ptr %t6399, i64 288
store ptr %t6509, ptr %t6511
%t6512 = call ptr @resid_box_i64(i64 %t6113)
%t6514 = getelementptr i8, ptr %t6399, i64 296
store ptr %t6512, ptr %t6514
%t6515 = call ptr @resid_box_i64(i64 %t6120)
%t6517 = getelementptr i8, ptr %t6399, i64 304
store ptr %t6515, ptr %t6517
%t6518 = call ptr @resid_box_i64(i64 %t6127)
%t6520 = getelementptr i8, ptr %t6399, i64 312
store ptr %t6518, ptr %t6520
%t6521 = call ptr @resid_box_i64(i64 %t6134)
%t6523 = getelementptr i8, ptr %t6399, i64 320
store ptr %t6521, ptr %t6523
%t6524 = call ptr @resid_box_i64(i64 %t6141)
%t6526 = getelementptr i8, ptr %t6399, i64 328
store ptr %t6524, ptr %t6526
%t6527 = call ptr @resid_box_i64(i64 %t6148)
%t6529 = getelementptr i8, ptr %t6399, i64 336
store ptr %t6527, ptr %t6529
%t6530 = call ptr @resid_box_i64(i64 %t6155)
%t6532 = getelementptr i8, ptr %t6399, i64 344
store ptr %t6530, ptr %t6532
%t6533 = call ptr @resid_box_i64(i64 %t6162)
%t6535 = getelementptr i8, ptr %t6399, i64 352
store ptr %t6533, ptr %t6535
%t6536 = call ptr @resid_box_i64(i64 %t6169)
%t6538 = getelementptr i8, ptr %t6399, i64 360
store ptr %t6536, ptr %t6538
%t6539 = call ptr @resid_box_i64(i64 %t6176)
%t6541 = getelementptr i8, ptr %t6399, i64 368
store ptr %t6539, ptr %t6541
%t6542 = call ptr @resid_box_i64(i64 %t6183)
%t6544 = getelementptr i8, ptr %t6399, i64 376
store ptr %t6542, ptr %t6544
%t6545 = call ptr @resid_box_i64(i64 %t6190)
%t6547 = getelementptr i8, ptr %t6399, i64 384
store ptr %t6545, ptr %t6547
%t6548 = call ptr @resid_box_i64(i64 %t6197)
%t6550 = getelementptr i8, ptr %t6399, i64 392
store ptr %t6548, ptr %t6550
%t6551 = call ptr @resid_box_i64(i64 %t6204)
%t6553 = getelementptr i8, ptr %t6399, i64 400
store ptr %t6551, ptr %t6553
%t6554 = call ptr @resid_box_i64(i64 %t6211)
%t6556 = getelementptr i8, ptr %t6399, i64 408
store ptr %t6554, ptr %t6556
%t6557 = call ptr @resid_box_i64(i64 %t6218)
%t6559 = getelementptr i8, ptr %t6399, i64 416
store ptr %t6557, ptr %t6559
%t6560 = call ptr @resid_box_i64(i64 %t6225)
%t6562 = getelementptr i8, ptr %t6399, i64 424
store ptr %t6560, ptr %t6562
%t6563 = call ptr @resid_box_i64(i64 %t6232)
%t6565 = getelementptr i8, ptr %t6399, i64 432
store ptr %t6563, ptr %t6565
%t6566 = call ptr @resid_box_i64(i64 %t6239)
%t6568 = getelementptr i8, ptr %t6399, i64 440
store ptr %t6566, ptr %t6568
%t6569 = call ptr @resid_box_i64(i64 %t6246)
%t6571 = getelementptr i8, ptr %t6399, i64 448
store ptr %t6569, ptr %t6571
%t6572 = call ptr @resid_box_i64(i64 %t6253)
%t6574 = getelementptr i8, ptr %t6399, i64 456
store ptr %t6572, ptr %t6574
%t6575 = call ptr @resid_box_i64(i64 %t6260)
%t6577 = getelementptr i8, ptr %t6399, i64 464
store ptr %t6575, ptr %t6577
%t6578 = call ptr @resid_box_i64(i64 %t6267)
%t6580 = getelementptr i8, ptr %t6399, i64 472
store ptr %t6578, ptr %t6580
%t6581 = call ptr @resid_box_i64(i64 %t6274)
%t6583 = getelementptr i8, ptr %t6399, i64 480
store ptr %t6581, ptr %t6583
%t6584 = call ptr @resid_box_i64(i64 %t6281)
%t6586 = getelementptr i8, ptr %t6399, i64 488
store ptr %t6584, ptr %t6586
%t6587 = call ptr @resid_box_i64(i64 %t6288)
%t6589 = getelementptr i8, ptr %t6399, i64 496
store ptr %t6587, ptr %t6589
%t6590 = call ptr @resid_box_i64(i64 %t6295)
%t6592 = getelementptr i8, ptr %t6399, i64 504
store ptr %t6590, ptr %t6592
%t6593 = call ptr @resid_box_i64(i64 %t6302)
%t6595 = getelementptr i8, ptr %t6399, i64 512
store ptr %t6593, ptr %t6595
%t6596 = call ptr @resid_box_i64(i64 %t6309)
%t6598 = getelementptr i8, ptr %t6399, i64 520
store ptr %t6596, ptr %t6598
%t6599 = call ptr @resid_box_i64(i64 %t6316)
%t6601 = getelementptr i8, ptr %t6399, i64 528
store ptr %t6599, ptr %t6601
%t6602 = call ptr @resid_box_i64(i64 %t6323)
%t6604 = getelementptr i8, ptr %t6399, i64 536
store ptr %t6602, ptr %t6604
%t6605 = call ptr @resid_box_i64(i64 500013540394364858)
%t6607 = getelementptr i8, ptr %t6399, i64 544
store ptr %t6605, ptr %t6607
%t6608 = call ptr @resid_box_i64(i64 748580250866718886)
%t6610 = getelementptr i8, ptr %t6399, i64 552
store ptr %t6608, ptr %t6610
%t6611 = call ptr @resid_box_i64(i64 %t6330)
%t6613 = getelementptr i8, ptr %t6399, i64 560
store ptr %t6611, ptr %t6613
%t6614 = call ptr @resid_box_i64(i64 %t6337)
%t6616 = getelementptr i8, ptr %t6399, i64 568
store ptr %t6614, ptr %t6616
%t6617 = call ptr @resid_box_i64(i64 %t6344)
%t6619 = getelementptr i8, ptr %t6399, i64 576
store ptr %t6617, ptr %t6619
%t6620 = call ptr @resid_box_i64(i64 %t6351)
%t6622 = getelementptr i8, ptr %t6399, i64 584
store ptr %t6620, ptr %t6622
%t6623 = call ptr @resid_box_i64(i64 %t6358)
%t6625 = getelementptr i8, ptr %t6399, i64 592
store ptr %t6623, ptr %t6625
%t6626 = call ptr @resid_box_i64(i64 %t6365)
%t6628 = getelementptr i8, ptr %t6399, i64 600
store ptr %t6626, ptr %t6628
%t6629 = call ptr @resid_box_i64(i64 %t6372)
%t6631 = getelementptr i8, ptr %t6399, i64 608
store ptr %t6629, ptr %t6631
%t6632 = call ptr @resid_box_i64(i64 %t6379)
%t6634 = getelementptr i8, ptr %t6399, i64 616
store ptr %t6632, ptr %t6634
%t6635 = call ptr @resid_box_i64(i64 %t6386)
%t6637 = getelementptr i8, ptr %t6399, i64 624
store ptr %t6635, ptr %t6637
%t6638 = call ptr @resid_box_i64(i64 %t6393)
%t6640 = getelementptr i8, ptr %t6399, i64 632
store ptr %t6638, ptr %t6640
%t6641 = call ptr @resid_list_new(i64 80, ptr %t6399, ptr @.lty6399)
ret ptr %t6641
}
define ptr @sha512g_iv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6642 = add i64 7640891576956012808, 0
%t6643 = add i64 %t6642, 0
%t6644 = add i64 %t6643, 0
%t6645 = icmp ne i64 %t6644, %t6642
%t6646 = icmp slt i64 7640891576956012808, 0
%t6647 = or i1 %t6645, %t6646
%t6648 = zext i1 %t6647 to i8
call void @resid_conv_check(i8 %t6648)
%t6649 = add i128 13503953896175478587, 0
%t6650 = trunc i128 %t6649 to i64
%t6651 = zext i64 %t6650 to i128
%t6652 = icmp ne i128 %t6651, %t6649
%t6653 = icmp slt i128 13503953896175478587, 0
%t6654 = or i1 %t6652, %t6653
%t6655 = zext i1 %t6654 to i8
call void @resid_conv_check(i8 %t6655)
%t6656 = add i64 4354685564936845355, 0
%t6657 = add i64 %t6656, 0
%t6658 = add i64 %t6657, 0
%t6659 = icmp ne i64 %t6658, %t6656
%t6660 = icmp slt i64 4354685564936845355, 0
%t6661 = or i1 %t6659, %t6660
%t6662 = zext i1 %t6661 to i8
call void @resid_conv_check(i8 %t6662)
%t6663 = add i128 11912009170470909681, 0
%t6664 = trunc i128 %t6663 to i64
%t6665 = zext i64 %t6664 to i128
%t6666 = icmp ne i128 %t6665, %t6663
%t6667 = icmp slt i128 11912009170470909681, 0
%t6668 = or i1 %t6666, %t6667
%t6669 = zext i1 %t6668 to i8
call void @resid_conv_check(i8 %t6669)
%t6670 = add i64 5840696475078001361, 0
%t6671 = add i64 %t6670, 0
%t6672 = add i64 %t6671, 0
%t6673 = icmp ne i64 %t6672, %t6670
%t6674 = icmp slt i64 5840696475078001361, 0
%t6675 = or i1 %t6673, %t6674
%t6676 = zext i1 %t6675 to i8
call void @resid_conv_check(i8 %t6676)
%t6677 = add i128 11170449401992604703, 0
%t6678 = trunc i128 %t6677 to i64
%t6679 = zext i64 %t6678 to i128
%t6680 = icmp ne i128 %t6679, %t6677
%t6681 = icmp slt i128 11170449401992604703, 0
%t6682 = or i1 %t6680, %t6681
%t6683 = zext i1 %t6682 to i8
call void @resid_conv_check(i8 %t6683)
%t6684 = add i64 2270897969802886507, 0
%t6685 = add i64 %t6684, 0
%t6686 = add i64 %t6685, 0
%t6687 = icmp ne i64 %t6686, %t6684
%t6688 = icmp slt i64 2270897969802886507, 0
%t6689 = or i1 %t6687, %t6688
%t6690 = zext i1 %t6689 to i8
call void @resid_conv_check(i8 %t6690)
%t6691 = add i64 6620516959819538809, 0
%t6692 = add i64 %t6691, 0
%t6693 = add i64 %t6692, 0
%t6694 = icmp ne i64 %t6693, %t6691
%t6695 = icmp slt i64 6620516959819538809, 0
%t6696 = or i1 %t6694, %t6695
%t6697 = zext i1 %t6696 to i8
call void @resid_conv_check(i8 %t6697)
%t6698 = alloca [8 x ptr]
%t6700 = call ptr @resid_box_i64(i64 %t6643)
%t6702 = getelementptr i8, ptr %t6698, i64 0
store ptr %t6700, ptr %t6702
%t6703 = call ptr @resid_box_i64(i64 %t6650)
%t6705 = getelementptr i8, ptr %t6698, i64 8
store ptr %t6703, ptr %t6705
%t6706 = call ptr @resid_box_i64(i64 %t6657)
%t6708 = getelementptr i8, ptr %t6698, i64 16
store ptr %t6706, ptr %t6708
%t6709 = call ptr @resid_box_i64(i64 %t6664)
%t6711 = getelementptr i8, ptr %t6698, i64 24
store ptr %t6709, ptr %t6711
%t6712 = call ptr @resid_box_i64(i64 %t6671)
%t6714 = getelementptr i8, ptr %t6698, i64 32
store ptr %t6712, ptr %t6714
%t6715 = call ptr @resid_box_i64(i64 %t6678)
%t6717 = getelementptr i8, ptr %t6698, i64 40
store ptr %t6715, ptr %t6717
%t6718 = call ptr @resid_box_i64(i64 %t6685)
%t6720 = getelementptr i8, ptr %t6698, i64 48
store ptr %t6718, ptr %t6720
%t6721 = call ptr @resid_box_i64(i64 %t6692)
%t6723 = getelementptr i8, ptr %t6698, i64 56
store ptr %t6721, ptr %t6723
%t6724 = call ptr @resid_list_new(i64 8, ptr %t6698, ptr @.lty6698)
ret ptr %t6724
}
define ptr @sha384g_iv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6725 = add i128 14680500436340154072, 0
%t6726 = trunc i128 %t6725 to i64
%t6727 = zext i64 %t6726 to i128
%t6728 = icmp ne i128 %t6727, %t6725
%t6729 = icmp slt i128 14680500436340154072, 0
%t6730 = or i1 %t6728, %t6729
%t6731 = zext i1 %t6730 to i8
call void @resid_conv_check(i8 %t6731)
%t6732 = add i64 7105036623409894663, 0
%t6733 = add i64 %t6732, 0
%t6734 = add i64 %t6733, 0
%t6735 = icmp ne i64 %t6734, %t6732
%t6736 = icmp slt i64 7105036623409894663, 0
%t6737 = or i1 %t6735, %t6736
%t6738 = zext i1 %t6737 to i8
call void @resid_conv_check(i8 %t6738)
%t6739 = add i128 10473403895298186519, 0
%t6740 = trunc i128 %t6739 to i64
%t6741 = zext i64 %t6740 to i128
%t6742 = icmp ne i128 %t6741, %t6739
%t6743 = icmp slt i128 10473403895298186519, 0
%t6744 = or i1 %t6742, %t6743
%t6745 = zext i1 %t6744 to i8
call void @resid_conv_check(i8 %t6745)
%t6746 = add i64 1526699215303891257, 0
%t6747 = add i64 %t6746, 0
%t6748 = add i64 %t6747, 0
%t6749 = icmp ne i64 %t6748, %t6746
%t6750 = icmp slt i64 1526699215303891257, 0
%t6751 = or i1 %t6749, %t6750
%t6752 = zext i1 %t6751 to i8
call void @resid_conv_check(i8 %t6752)
%t6753 = add i64 7436329637833083697, 0
%t6754 = add i64 %t6753, 0
%t6755 = add i64 %t6754, 0
%t6756 = icmp ne i64 %t6755, %t6753
%t6757 = icmp slt i64 7436329637833083697, 0
%t6758 = or i1 %t6756, %t6757
%t6759 = zext i1 %t6758 to i8
call void @resid_conv_check(i8 %t6759)
%t6760 = add i128 10282925794625328401, 0
%t6761 = trunc i128 %t6760 to i64
%t6762 = zext i64 %t6761 to i128
%t6763 = icmp ne i128 %t6762, %t6760
%t6764 = icmp slt i128 10282925794625328401, 0
%t6765 = or i1 %t6763, %t6764
%t6766 = zext i1 %t6765 to i8
call void @resid_conv_check(i8 %t6766)
%t6767 = add i128 15784041429090275239, 0
%t6768 = trunc i128 %t6767 to i64
%t6769 = zext i64 %t6768 to i128
%t6770 = icmp ne i128 %t6769, %t6767
%t6771 = icmp slt i128 15784041429090275239, 0
%t6772 = or i1 %t6770, %t6771
%t6773 = zext i1 %t6772 to i8
call void @resid_conv_check(i8 %t6773)
%t6774 = add i64 5167115440072839076, 0
%t6775 = add i64 %t6774, 0
%t6776 = add i64 %t6775, 0
%t6777 = icmp ne i64 %t6776, %t6774
%t6778 = icmp slt i64 5167115440072839076, 0
%t6779 = or i1 %t6777, %t6778
%t6780 = zext i1 %t6779 to i8
call void @resid_conv_check(i8 %t6780)
%t6781 = alloca [8 x ptr]
%t6783 = call ptr @resid_box_i64(i64 %t6726)
%t6785 = getelementptr i8, ptr %t6781, i64 0
store ptr %t6783, ptr %t6785
%t6786 = call ptr @resid_box_i64(i64 %t6733)
%t6788 = getelementptr i8, ptr %t6781, i64 8
store ptr %t6786, ptr %t6788
%t6789 = call ptr @resid_box_i64(i64 %t6740)
%t6791 = getelementptr i8, ptr %t6781, i64 16
store ptr %t6789, ptr %t6791
%t6792 = call ptr @resid_box_i64(i64 %t6747)
%t6794 = getelementptr i8, ptr %t6781, i64 24
store ptr %t6792, ptr %t6794
%t6795 = call ptr @resid_box_i64(i64 %t6754)
%t6797 = getelementptr i8, ptr %t6781, i64 32
store ptr %t6795, ptr %t6797
%t6798 = call ptr @resid_box_i64(i64 %t6761)
%t6800 = getelementptr i8, ptr %t6781, i64 40
store ptr %t6798, ptr %t6800
%t6801 = call ptr @resid_box_i64(i64 %t6768)
%t6803 = getelementptr i8, ptr %t6781, i64 48
store ptr %t6801, ptr %t6803
%t6804 = call ptr @resid_box_i64(i64 %t6775)
%t6806 = getelementptr i8, ptr %t6781, i64 56
store ptr %t6804, ptr %t6806
%t6807 = call ptr @resid_list_new(i64 8, ptr %t6781, ptr @.lty6781)
ret ptr %t6807
}
define ptr @sha512g_pad(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6808 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p0, i64 17)
%t6809 = extractvalue {i64, i1} %t6808, 0
%t6810 = extractvalue {i64, i1} %t6808, 1
%t6811 = zext i1 %t6810 to i8
call void @resid_overflow_check(i8 %t6811)
%t6812 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t6809, i64 127)
%t6813 = extractvalue {i64, i1} %t6812, 0
%t6814 = extractvalue {i64, i1} %t6812, 1
%t6815 = zext i1 %t6814 to i8
call void @resid_overflow_check(i8 %t6815)
%t6816 = sdiv i64 %t6813, 128
%t6817 = mul nsw i64 %t6816, 128
%t6818 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t6817, i64 %p0)
%t6819 = extractvalue {i64, i1} %t6818, 0
%t6820 = extractvalue {i64, i1} %t6818, 1
%t6821 = zext i1 %t6820 to i8
call void @resid_overflow_check(i8 %t6821)
%t6822 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t6819, i64 17)
%t6823 = extractvalue {i64, i1} %t6822, 0
%t6824 = extractvalue {i64, i1} %t6822, 1
%t6825 = zext i1 %t6824 to i8
call void @resid_overflow_check(i8 %t6825)
%t6826 = call ptr @resid_listbuf_new()
%t6827 = call ptr @__m____________lib_sha512g_resid__sha512g_pad_at(i64 %p0, i64 %t6823, i64 0, ptr %t6826)
%t6828 = call ptr @resid_listbuf_finish(ptr %t6827, ptr @.lty6828)
ret ptr %t6828
}
define ptr @__m____________lib_sha512g_resid__sha512g_pad_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ], [ %p0, %tco.s2 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ], [ %p1, %tco.s2 ]
%p2 = phi i64 [ %p2.in, %entry ], [ 1, %tco.s0 ], [ %t6841, %tco.s1 ], [ %t6867, %tco.s2 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t6833, %tco.s0 ], [ %t6847, %tco.s1 ], [ %t6884, %tco.s2 ]
%t6829 = icmp eq i64 %p2, 0
br i1 %t6829, label %L685, label %L687
L685:
%t6830 = call ptr @resid_box_i64(i64 128)
%t6833 = call ptr @resid_listbuf_push(ptr %p3, ptr %t6830)
br label %tco.s0
tco.s0:
br label %tco.head
L687:
%t6835 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 8)
%t6836 = extractvalue {i64, i1} %t6835, 0
%t6837 = extractvalue {i64, i1} %t6835, 1
%t6838 = zext i1 %t6837 to i8
call void @resid_overflow_check(i8 %t6838)
%t6839 = icmp sle i64 %p2, %t6836
br i1 %t6839, label %L688, label %L690
L688:
%t6840 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t6841 = extractvalue {i64, i1} %t6840, 0
%t6842 = extractvalue {i64, i1} %t6840, 1
%t6843 = zext i1 %t6842 to i8
call void @resid_overflow_check(i8 %t6843)
%t6844 = call ptr @resid_box_i64(i64 0)
%t6847 = call ptr @resid_listbuf_push(ptr %p3, ptr %t6844)
br label %tco.s1
tco.s1:
br label %tco.head
L690:
%t6849 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 16)
%t6850 = extractvalue {i64, i1} %t6849, 0
%t6851 = extractvalue {i64, i1} %t6849, 1
%t6852 = zext i1 %t6851 to i8
call void @resid_overflow_check(i8 %t6852)
%t6853 = icmp sle i64 %p2, %t6850
br i1 %t6853, label %L691, label %L693
L691:
%t6854 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 16)
%t6855 = extractvalue {i64, i1} %t6854, 0
%t6856 = extractvalue {i64, i1} %t6854, 1
%t6857 = zext i1 %t6856 to i8
call void @resid_overflow_check(i8 %t6857)
%t6858 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t6855, i64 %p2)
%t6859 = extractvalue {i64, i1} %t6858, 0
%t6860 = extractvalue {i64, i1} %t6858, 1
%t6861 = zext i1 %t6860 to i8
call void @resid_overflow_check(i8 %t6861)
%t6862 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t6859, i64 8)
%t6863 = extractvalue {i64, i1} %t6862, 0
%t6864 = extractvalue {i64, i1} %t6862, 1
%t6865 = zext i1 %t6864 to i8
call void @resid_overflow_check(i8 %t6865)
%t6866 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t6867 = extractvalue {i64, i1} %t6866, 0
%t6868 = extractvalue {i64, i1} %t6866, 1
%t6869 = zext i1 %t6868 to i8
call void @resid_overflow_check(i8 %t6869)
%t6870 = icmp sge i64 %t6863, 61
br i1 %t6870, label %L694, label %L695
L694:
br label %L696
L695:
%t6871 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p0, i64 8)
%t6872 = extractvalue {i64, i1} %t6871, 0
%t6873 = extractvalue {i64, i1} %t6871, 1
%t6874 = zext i1 %t6873 to i8
call void @resid_overflow_check(i8 %t6874)
%t6875 = icmp uge i64 %t6863, 64
%t6876 = add i64 %t6863, 0
%t6877 = select i1 %t6875, i64 63, i64 %t6876
%t6878 = ashr i64 %t6872, %t6877
%t6879 = and i64 %t6878, 255
br label %L696
L696:
%t6880 = phi i64 [ 0, %L694 ], [ %t6879, %L695 ]
%t6881 = call ptr @resid_box_i64(i64 %t6880)
%t6884 = call ptr @resid_listbuf_push(ptr %p3, ptr %t6881)
br label %tco.s2
tco.s2:
br label %tco.head
L693:
ret ptr %p3
}
define ptr @__m____________lib_sha512g_resid__sha512g_zero_bytes(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6888, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t6892, %tco.s0 ]
%t6886 = icmp sge i64 %p1, %p0
br i1 %t6886, label %L697, label %L699
L697:
%t6887 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty6887)
ret ptr %t6887
L699:
%t6888 = add nsw i64 %p1, 1
%t6889 = call ptr @resid_box_i64(i64 0)
%t6892 = call ptr @resid_listbuf_push(ptr %p2, ptr %t6889)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @eg_p() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6894 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
ret i512 %t6894
}
define i512 @eg_d() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6895 = sext i256 37095705934669439343138083508754565189542113879843219016388785533085940283555 to i512
ret i512 %t6895
}
define i512 @eg_l() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6896 = sext i256 7237005577332262213973186563042994240857116359379907606001950938285454250989 to i512
ret i512 %t6896
}
define i512 @eg_bx() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6897 = sext i256 15112221349535400772501151409588531511454012693041857206046113283949847762202 to i512
ret i512 %t6897
}
define i512 @eg_by() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6898 = sext i256 46316835694926478169428394003475163141307993866256225615783033603165251855960 to i512
ret i512 %t6898
}
define i512 @__m____________lib_ed25519g_resid__eg_m256() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i512 115792089237316195423570985008687907853269984665640564039457584007913129639935
}
define i512 @__m____________lib_ed25519g_resid__eg_ones() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6899 = sext i64 -1 to i512
ret i512 %t6899
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
%t6900 = call i256 @fe_mul(i256 15112221349535400772501151409588531511454012693041857206046113283949847762202, i256 46316835694926478169428394003475163141307993866256225615783033603165251855960)
ret i256 %t6900
}
define i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6901 = sext i256 %p0 to i512
ret i512 %t6901
}
define i256 @fe_add(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6902 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6903 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t6904 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t6902, i512 %t6903)
%t6905 = trunc i512 %t6904 to i256
ret i256 %t6905
}
define i256 @fe_sub(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6906 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6907 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t6908 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t6906, i512 %t6907)
%t6909 = trunc i512 %t6908 to i256
ret i256 %t6909
}
define i256 @fe_mul(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6910 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6911 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t6912 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t6910, i512 %t6911)
%t6913 = trunc i512 %t6912 to i256
ret i256 %t6913
}
define i256 @fe_sq(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6914 = call i256 @fe_mul(i256 %p0, i256 %p0)
ret i256 %t6914
}
define i256 @fe_inv(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6915 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6916 = call i512 @eg_finv__g_Int_512__Int_64_(i512 %t6915)
%t6917 = trunc i512 %t6916 to i256
ret i256 %t6917
}
define i256 @pow_acc(i256 %p0, i256 %p1, i256 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6918 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t6919 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p1)
%t6920 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p2)
%t6921 = call i512 @eg_fpow__g_Int_512__Int_64_(i512 %t6918, i512 %t6919, i512 %t6920, i64 %p3)
%t6922 = trunc i512 %t6921 to i256
ret i256 %t6922
}
define i256 @bytes_to_int(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6923 = sext i64 0 to i256
%t6924 = call i256 @b2a(ptr %p0, i256 %t6923, i64 31)
ret i256 %t6924
}
define i256 @b2a(ptr %p0.in, i256 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i256 [ %p1.in, %entry ], [ %t6938, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6939, %tco.s0 ]
%t6925 = icmp slt i64 %p2, 0
br i1 %t6925, label %L700, label %L702
L700:
ret i256 %p1
L702:
%t6926 = icmp eq i64 %p2, 31
br i1 %t6926, label %L703, label %L704
L703:
%t6927 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t6928 = call i64 @resid_unbox_i64(ptr %t6927)
%t6930 = and i64 %t6928, 127
br label %L705
L704:
%t6931 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t6932 = call i64 @resid_unbox_i64(ptr %t6931)
%t6934 = and i64 %t6932, 255
br label %L705
L705:
%t6935 = phi i64 [ %t6930, %L703 ], [ %t6934, %L704 ]
%t6936 = shl i256 %p1, 8
%t6937 = sext i64 %t6935 to i256
%t6938 = or i256 %t6936, %t6937
%t6939 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @int_to_bytes(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6941 = call ptr @resid_listbuf_new()
%t6942 = call ptr @__m____________lib_ed25519_resid__itob_acc(i256 %p0, i64 0, ptr %t6941)
ret ptr %t6942
}
define ptr @__m____________lib_ed25519_resid__itob_acc(i256 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i256 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6945, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t6960, %tco.s0 ]
%t6943 = icmp sgt i64 %p1, 31
br i1 %t6943, label %L706, label %L708
L706:
%t6944 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty6944)
ret ptr %t6944
L708:
%t6945 = add nsw i64 %p1, 1
%t6946 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t6947 = extractvalue {i64, i1} %t6946, 0
%t6948 = extractvalue {i64, i1} %t6946, 1
%t6949 = zext i1 %t6948 to i8
call void @resid_overflow_check(i8 %t6949)
%t6950 = sext i64 %t6947 to i256
%t6951 = icmp uge i256 %t6950, 256
%t6952 = add i256 %t6950, 0
%t6953 = select i1 %t6951, i256 255, i256 %t6952
%t6954 = ashr i256 %p0, %t6953
%t6955 = and i256 %t6954, 255
%t6956 = trunc i256 %t6955 to i64
%t6957 = call ptr @resid_box_i64(i64 %t6956)
%t6960 = call ptr @resid_listbuf_push(ptr %p2, ptr %t6957)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @slice_bytes(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6962 = icmp slt i64 %p2, %p1
br i1 %t6962, label %L709, label %L711
L709:
%t6964 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty6963)
ret ptr %t6964
L711:
%t6965 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t6966 = extractvalue {i64, i1} %t6965, 0
%t6967 = extractvalue {i64, i1} %t6965, 1
%t6968 = zext i1 %t6967 to i8
call void @resid_overflow_check(i8 %t6968)
%t6969 = musttail call ptr @resid_list_slice(ptr %p0, i64 %p1, i64 %t6966)
ret ptr %t6969
}
define ptr @concat_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6971 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %p1)
ret ptr %t6971
}
define ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6972 = call ptr @resid_rec_new(i64 256, i8 1)
%t6973 = getelementptr i8, ptr %p0, i64 0
%t6974 = load i256, ptr %t6973, align 8
%t6975 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6974)
%t6972.f0 = getelementptr i8, ptr %t6972, i64 0
store i512 %t6975, ptr %t6972.f0, align 8
%t6976 = getelementptr i8, ptr %p0, i64 32
%t6977 = load i256, ptr %t6976, align 8
%t6978 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6977)
%t6972.f8 = getelementptr i8, ptr %t6972, i64 64
store i512 %t6978, ptr %t6972.f8, align 8
%t6979 = getelementptr i8, ptr %p0, i64 64
%t6980 = load i256, ptr %t6979, align 8
%t6981 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6980)
%t6972.f16 = getelementptr i8, ptr %t6972, i64 128
store i512 %t6981, ptr %t6972.f16, align 8
%t6982 = getelementptr i8, ptr %p0, i64 96
%t6983 = load i256, ptr %t6982, align 8
%t6984 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t6983)
%t6972.f24 = getelementptr i8, ptr %t6972, i64 192
store i512 %t6984, ptr %t6972.f24, align 8
ret ptr %t6972
}
define ptr @__m____________lib_ed25519_resid__ept_n(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6985 = call ptr @resid_gmalloc(i64 128)
%t6986 = getelementptr i8, ptr %p0, i64 0
%t6987 = load i512, ptr %t6986, align 8
%t6988 = trunc i512 %t6987 to i256
%t6985.f0 = getelementptr i8, ptr %t6985, i64 0
store i256 %t6988, ptr %t6985.f0, align 8
%t6989 = getelementptr i8, ptr %p0, i64 64
%t6990 = load i512, ptr %t6989, align 8
%t6991 = trunc i512 %t6990 to i256
%t6985.f4 = getelementptr i8, ptr %t6985, i64 32
store i256 %t6991, ptr %t6985.f4, align 8
%t6992 = getelementptr i8, ptr %p0, i64 128
%t6993 = load i512, ptr %t6992, align 8
%t6994 = trunc i512 %t6993 to i256
%t6985.f8 = getelementptr i8, ptr %t6985, i64 64
store i256 %t6994, ptr %t6985.f8, align 8
%t6995 = getelementptr i8, ptr %p0, i64 192
%t6996 = load i512, ptr %t6995, align 8
%t6997 = trunc i512 %t6996 to i256
%t6985.f12 = getelementptr i8, ptr %t6985, i64 96
store i256 %t6997, ptr %t6985.f12, align 8
ret ptr %t6985
}
define ptr @ept(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6998 = call ptr @resid_gmalloc(i64 128)
%t6998.f0 = getelementptr i8, ptr %t6998, i64 0
store i256 %p0, ptr %t6998.f0, align 8
%t6998.f4 = getelementptr i8, ptr %t6998, i64 32
store i256 %p1, ptr %t6998.f4, align 8
%t6999 = sext i64 1 to i256
%t6998.f8 = getelementptr i8, ptr %t6998, i64 64
store i256 %t6999, ptr %t6998.f8, align 8
%t7000 = call i256 @fe_mul(i256 %p0, i256 %p1)
%t6998.f12 = getelementptr i8, ptr %t6998, i64 96
store i256 %t7000, ptr %t6998.f12, align 8
ret ptr %t6998
}
define ptr @ept_id() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7001 = call ptr @resid_gmalloc(i64 128)
%t7002 = sext i64 0 to i256
%t7001.f0 = getelementptr i8, ptr %t7001, i64 0
store i256 %t7002, ptr %t7001.f0, align 8
%t7003 = sext i64 1 to i256
%t7001.f4 = getelementptr i8, ptr %t7001, i64 32
store i256 %t7003, ptr %t7001.f4, align 8
%t7004 = sext i64 1 to i256
%t7001.f8 = getelementptr i8, ptr %t7001, i64 64
store i256 %t7004, ptr %t7001.f8, align 8
%t7005 = sext i64 0 to i256
%t7001.f12 = getelementptr i8, ptr %t7001, i64 96
store i256 %t7005, ptr %t7001.f12, align 8
ret ptr %t7001
}
define ptr @ept_dbl(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7006 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0)
%t7007 = call ptr @eg_dbl__g_Int_512__Int_64_(ptr %t7006)
%t7008 = musttail call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t7007)
ret ptr %t7008
}
define ptr @ept_add(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7009 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0)
%t7010 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p1)
%t7011 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t7009, ptr %t7010)
%t7012 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t7011)
ret ptr %t7012
}
define ptr @ept_mul(i256 %p0, ptr %p1, ptr %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7013 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t7014 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p1)
call void @resid_rec_share(ptr %t7014)
%t7015 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p2)
call void @resid_rec_share(ptr %t7015)
%t7016 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %t7013, ptr %t7014, ptr %t7015, i64 %p3)
%t7017 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t7016)
ret ptr %t7017
}
define ptr @ept_base_mul(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7018 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t7019 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t7018)
%t7020 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t7019)
ret ptr %t7020
}
define ptr @ept_encode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7021 = call ptr @__m____________lib_ed25519_resid__ept_w(ptr %p0)
%t7022 = musttail call ptr @eg_encode__g_Int_512__Int_64_(ptr %t7021)
ret ptr %t7022
}
define i1 @ept_eq(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7023 = getelementptr i8, ptr %p0, i64 0
%t7024 = load i256, ptr %t7023, align 8
%t7025 = getelementptr i8, ptr %p1, i64 64
%t7026 = load i256, ptr %t7025, align 8
%t7027 = call i256 @fe_mul(i256 %t7024, i256 %t7026)
%t7028 = getelementptr i8, ptr %p1, i64 0
%t7029 = load i256, ptr %t7028, align 8
%t7030 = getelementptr i8, ptr %p0, i64 64
%t7031 = load i256, ptr %t7030, align 8
%t7032 = call i256 @fe_mul(i256 %t7029, i256 %t7031)
%t7033 = icmp eq i256 %t7027, %t7032
br label %LSL7034
LSL7034:
br i1 %t7033, label %LSR7034, label %LSJ7034
LSR7034:
%t7035 = getelementptr i8, ptr %p0, i64 32
%t7036 = load i256, ptr %t7035, align 8
%t7037 = getelementptr i8, ptr %p1, i64 64
%t7038 = load i256, ptr %t7037, align 8
%t7039 = call i256 @fe_mul(i256 %t7036, i256 %t7038)
%t7040 = getelementptr i8, ptr %p1, i64 32
%t7041 = load i256, ptr %t7040, align 8
%t7042 = getelementptr i8, ptr %p0, i64 64
%t7043 = load i256, ptr %t7042, align 8
%t7044 = call i256 @fe_mul(i256 %t7041, i256 %t7043)
%t7045 = icmp eq i256 %t7039, %t7044
br label %LSJ7034
LSJ7034:
%t7046 = phi i1 [ false, %LSL7034 ], [ %t7045, %LSR7034 ]
ret i1 %t7046
}
define ptr @smul_x_acc(i256 %p0, i256 %p1, i256 %p2, i256 %p3, i256 %p4, i256 %p5, i256 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7047 = call ptr @resid_gmalloc(i64 128)
%t7047.f0 = getelementptr i8, ptr %t7047, i64 0
store i256 %p1, ptr %t7047.f0, align 8
%t7047.f4 = getelementptr i8, ptr %t7047, i64 32
store i256 %p2, ptr %t7047.f4, align 8
%t7047.f8 = getelementptr i8, ptr %t7047, i64 64
store i256 %p3, ptr %t7047.f8, align 8
%t7048 = call i256 @fe_mul(i256 %p1, i256 %p2)
%t7049 = call i256 @fe_inv(i256 %p3)
%t7050 = call i256 @fe_mul(i256 %t7048, i256 %t7049)
%t7047.f12 = getelementptr i8, ptr %t7047, i64 96
store i256 %t7050, ptr %t7047.f12, align 8
%t7051 = call ptr @resid_gmalloc(i64 128)
%t7051.f0 = getelementptr i8, ptr %t7051, i64 0
store i256 %p4, ptr %t7051.f0, align 8
%t7051.f4 = getelementptr i8, ptr %t7051, i64 32
store i256 %p5, ptr %t7051.f4, align 8
%t7051.f8 = getelementptr i8, ptr %t7051, i64 64
store i256 %p6, ptr %t7051.f8, align 8
%t7052 = call i256 @fe_mul(i256 %p4, i256 %p5)
%t7053 = call i256 @fe_inv(i256 %p6)
%t7054 = call i256 @fe_mul(i256 %t7052, i256 %t7053)
%t7051.f12 = getelementptr i8, ptr %t7051, i64 96
store i256 %t7054, ptr %t7051.f12, align 8
%t7055 = call ptr @ept_mul(i256 %p0, ptr %t7047, ptr %t7051, i64 %p7)
%t7056 = getelementptr i8, ptr %t7055, i64 0
%t7057 = load i256, ptr %t7056, align 8
%t7058 = getelementptr i8, ptr %t7055, i64 64
%t7059 = load i256, ptr %t7058, align 8
%t7060 = call i256 @fe_inv(i256 %t7059)
%t7061 = call i256 @fe_mul(i256 %t7057, i256 %t7060)
%t7062 = call ptr @int_to_bytes(i256 %t7061)
ret ptr %t7062
}
define i256 @dec_y(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7063 = call i256 @bytes_to_int(ptr %p0)
ret i256 %t7063
}
define i256 @dec_x(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7064 = call i256 @dec_y(ptr %p0)
%t7065 = call i64 @resid_list_len(ptr %p0)
%t7066 = sub nsw i64 %t7065, 1
%t7067 = call ptr @resid_list_get(ptr %p0, i64 %t7066)
%t7068 = call i64 @resid_unbox_i64(ptr %t7067)
%t7070 = ashr i64 %t7068, 7
%t7071 = and i64 %t7070, 1
%t7072 = call i256 @fe_sq(i256 %t7064)
%t7073 = sext i64 1 to i256
%t7074 = call i256 @fe_sub(i256 %t7072, i256 %t7073)
%t7075 = call i256 @fe_mul(i256 37095705934669439343138083508754565189542113879843219016388785533085940283555, i256 %t7072)
%t7076 = sext i64 1 to i256
%t7077 = call i256 @fe_add(i256 %t7075, i256 %t7076)
%t7078 = call i256 @fe_inv(i256 %t7077)
%t7079 = call i256 @fe_mul(i256 %t7074, i256 %t7078)
%t7080 = sext i64 1 to i256
%t7081 = call i256 @pow_acc(i256 %t7080, i256 %t7079, i256 7237005577332262213973186563042994240829374041602535252466099000494570602494, i64 254)
%t7082 = call i256 @fe_sq(i256 %t7081)
%t7083 = icmp eq i256 %t7082, %t7079
br i1 %t7083, label %L712, label %L713
L712:
br label %L714
L713:
%t7084 = call i256 @fe_mul(i256 %t7081, i256 19681161376707505956807079304988542015446066515923890162744021073123829784752)
br label %L714
L714:
%t7085 = phi i256 [ %t7081, %L712 ], [ %t7084, %L713 ]
%t7086 = and i256 %t7085, 1
%t7087 = trunc i256 %t7086 to i64
%t7088 = icmp ne i64 %t7087, %t7071
br i1 %t7088, label %L715, label %L716
L715:
%t7089 = sext i64 0 to i256
%t7090 = call i256 @fe_sub(i256 %t7089, i256 %t7085)
br label %L717
L716:
br label %L717
L717:
%t7091 = phi i256 [ %t7090, %L715 ], [ %t7085, %L716 ]
ret i256 %t7091
}
define i1 @dec_ok(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7092 = call ptr @__m____________lib_ed25519_resid__dec_pt(ptr %p0)
%t7093 = getelementptr i8, ptr %t7092, i64 0
%t7094 = load i1, ptr %t7093, align 8
ret i1 %t7094
}
define ptr @__m____________lib_ed25519_resid__dec_pt(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7095 = call ptr @resid_gmalloc(i64 72)
%t7095.f0 = getelementptr i8, ptr %t7095, i64 0
store i1 false, ptr %t7095.f0, align 8
%t7096 = sext i64 0 to i256
%t7095.f1 = getelementptr i8, ptr %t7095, i64 8
store i256 %t7096, ptr %t7095.f1, align 8
%t7097 = sext i64 0 to i256
%t7095.f5 = getelementptr i8, ptr %t7095, i64 40
store i256 %t7097, ptr %t7095.f5, align 8
%t7098 = call i64 @resid_list_len(ptr %p0)
%t7099 = icmp ne i64 %t7098, 32
br i1 %t7099, label %L718, label %L720
L718:
ret ptr %t7095
L720:
%t7100 = call i256 @dec_y(ptr %p0)
%t7101 = icmp sge i256 %t7100, 57896044618658097711785492504343953926634992332820282019728792003956564819949
br i1 %t7101, label %L721, label %L723
L721:
ret ptr %t7095
L723:
%t7102 = call i256 @dec_x(ptr %p0)
%t7103 = icmp eq i256 %t7102, 0
br label %LSL7104
LSL7104:
br i1 %t7103, label %LSR7104, label %LSJ7104
LSR7104:
%t7105 = call ptr @resid_list_get(ptr %p0, i64 31)
%t7106 = call i64 @resid_unbox_i64(ptr %t7105)
%t7108 = ashr i64 %t7106, 7
%t7109 = and i64 %t7108, 1
%t7110 = icmp eq i64 %t7109, 1
br label %LSJ7104
LSJ7104:
%t7111 = phi i1 [ false, %LSL7104 ], [ %t7110, %LSR7104 ]
br i1 %t7111, label %L724, label %L726
L724:
ret ptr %t7095
L726:
%t7112 = call i256 @fe_sq(i256 %t7102)
%t7113 = call i256 @fe_sq(i256 %t7100)
%t7114 = call ptr @resid_gmalloc(i64 72)
%t7115 = call i256 @fe_sub(i256 %t7113, i256 %t7112)
%t7116 = sext i64 1 to i256
%t7117 = call i256 @fe_mul(i256 %t7112, i256 %t7113)
%t7118 = call i256 @fe_mul(i256 37095705934669439343138083508754565189542113879843219016388785533085940283555, i256 %t7117)
%t7119 = call i256 @fe_add(i256 %t7116, i256 %t7118)
%t7120 = icmp eq i256 %t7115, %t7119
%t7114.f0 = getelementptr i8, ptr %t7114, i64 0
store i1 %t7120, ptr %t7114.f0, align 8
%t7114.f1 = getelementptr i8, ptr %t7114, i64 8
store i256 %t7102, ptr %t7114.f1, align 8
%t7114.f5 = getelementptr i8, ptr %t7114, i64 40
store i256 %t7100, ptr %t7114.f5, align 8
ret ptr %t7114
}
define i256 @mod_l(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7121 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %p0)
%t7122 = trunc i512 %t7121 to i256
ret i256 %t7122
}
define i1 @verify_sig_bytes(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7123 = call i64 @resid_list_len(ptr %p1)
%t7124 = icmp ne i64 %t7123, 64
br label %LSL7125
LSL7125:
br i1 %t7124, label %LSJ7125, label %LSR7125
LSR7125:
%t7126 = call i64 @resid_list_len(ptr %p2)
%t7127 = icmp ne i64 %t7126, 32
br label %LSJ7125
LSJ7125:
%t7128 = phi i1 [ true, %LSL7125 ], [ %t7127, %LSR7125 ]
br i1 %t7128, label %L727, label %L729
L727:
ret i1 false
L729:
%t7129 = call ptr @resid_list_get(ptr %p1, i64 63)
%t7130 = call i64 @resid_unbox_i64(ptr %t7129)
%t7132 = icmp sge i64 %t7130, 128
br i1 %t7132, label %L730, label %L732
L730:
ret i1 false
L732:
%t7133 = call ptr @resid_list_slice(ptr %p1, i64 0, i64 32)
%t7135 = call ptr @resid_list_slice(ptr %p1, i64 32, i64 64)
%t7137 = call i256 @bytes_to_int(ptr %t7135)
%t7138 = icmp sge i256 %t7137, 7237005577332262213973186563042994240857116359379907606001950938285454250989
br i1 %t7138, label %L733, label %L735
L733:
ret i1 false
L735:
%t7139 = call ptr @__m____________lib_ed25519_resid__dec_pt(ptr %p2)
%t7140 = call ptr @__m____________lib_ed25519_resid__dec_pt(ptr %t7133)
%t7141 = getelementptr i8, ptr %t7139, i64 0
%t7142 = load i1, ptr %t7141, align 8
%t7143 = xor i1 %t7142, true
br label %LSL7144
LSL7144:
br i1 %t7143, label %LSJ7144, label %LSR7144
LSR7144:
%t7145 = getelementptr i8, ptr %t7140, i64 0
%t7146 = load i1, ptr %t7145, align 8
%t7147 = xor i1 %t7146, true
br label %LSJ7144
LSJ7144:
%t7148 = phi i1 [ true, %LSL7144 ], [ %t7147, %LSR7144 ]
br i1 %t7148, label %L736, label %L738
L736:
ret i1 false
L738:
%t7149 = getelementptr i8, ptr %t7139, i64 8
%t7150 = load i256, ptr %t7149, align 8
%t7151 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7150)
%t7152 = getelementptr i8, ptr %t7139, i64 40
%t7153 = load i256, ptr %t7152, align 8
%t7154 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7153)
%t7155 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t7151, i512 %t7154)
call void @resid_rec_share(ptr %t7155)
%t7156 = getelementptr i8, ptr %t7140, i64 8
%t7157 = load i256, ptr %t7156, align 8
%t7158 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7157)
%t7159 = getelementptr i8, ptr %t7140, i64 40
%t7160 = load i256, ptr %t7159, align 8
%t7161 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7160)
%t7162 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t7158, i512 %t7161)
%t7163 = call i64 @resid_scope_push()
%t7164 = call ptr @resid_list_concat_own(ptr %t7133, i8 1, ptr %p2)
%t7165 = call ptr @resid_list_concat_own(ptr %t7164, i8 1, ptr %p0)
%t7166 = call ptr @sha512_bytes(ptr %t7165)
%t7167 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t7166)
call void @resid_scope_pop(i64 %t7163)
%t7168 = call ptr @eg_id__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t7168)
%t7169 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %t7137)
%t7170 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t7169)
%t7171 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t7170)
%t7172 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %t7167, ptr %t7155, ptr %t7168, i64 255)
%t7173 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t7172, ptr %t7162)
%t7174 = call ptr @__m____________lib_ed25519_resid__ept_n(ptr %t7173)
%t7175 = call i1 @ept_eq(ptr %t7171, ptr %t7174)
ret i1 %t7175
}
define i1 @verify_sig(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7176 = call ptr @bytes_of(ptr %p0)
%t7177 = call ptr @resid_list_freeze(ptr %t7176)
%t7178 = musttail call i1 @verify_sig_bytes(ptr %t7177, ptr %p1, ptr %p2)
ret i1 %t7178
}
define i256 @clamp_scalar(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7179 = call i512 @__m____________lib_ed25519_resid__fe_w(i256 %p0)
%t7180 = call i512 @eg_clamp__g_Int_512__Int_64_(i512 %t7179)
%t7181 = trunc i512 %t7180 to i256
ret i256 %t7181
}
define ptr @pub_key(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7182 = musttail call ptr @ed25519g_pub__g_Int_64__Int_512__UInt_64_(ptr %p0)
ret ptr %t7182
}
define ptr @sign_msg_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7183 = musttail call ptr @ed25519g_sign__g_Int_64__Int_512__UInt_64_(ptr %p0, ptr %p1)
ret ptr %t7183
}
define ptr @sign_msg(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7184 = call ptr @bytes_of(ptr %p1)
%t7185 = call ptr @resid_list_freeze(ptr %t7184)
%t7186 = musttail call ptr @sign_msg_bytes(ptr %p0, ptr %t7185)
ret ptr %t7186
}
define i64 @__m____________lib_chachag_resid__cg_le32(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7187 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t7188 = call i64 @resid_unbox_i64(ptr %t7187)
%t7190 = and i64 %t7188, 255
%t7191 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t7192 = extractvalue {i64, i1} %t7191, 0
%t7193 = extractvalue {i64, i1} %t7191, 1
%t7194 = zext i1 %t7193 to i8
call void @resid_overflow_check(i8 %t7194)
%t7195 = call ptr @resid_list_get(ptr %p0, i64 %t7192)
%t7196 = call i64 @resid_unbox_i64(ptr %t7195)
%t7198 = and i64 %t7196, 255
%t7199 = shl i64 %t7198, 8
%t7200 = or i64 %t7190, %t7199
%t7201 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t7202 = extractvalue {i64, i1} %t7201, 0
%t7203 = extractvalue {i64, i1} %t7201, 1
%t7204 = zext i1 %t7203 to i8
call void @resid_overflow_check(i8 %t7204)
%t7205 = call ptr @resid_list_get(ptr %p0, i64 %t7202)
%t7206 = call i64 @resid_unbox_i64(ptr %t7205)
%t7208 = and i64 %t7206, 255
%t7209 = shl i64 %t7208, 16
%t7210 = or i64 %t7200, %t7209
%t7211 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 3)
%t7212 = extractvalue {i64, i1} %t7211, 0
%t7213 = extractvalue {i64, i1} %t7211, 1
%t7214 = zext i1 %t7213 to i8
call void @resid_overflow_check(i8 %t7214)
%t7215 = call ptr @resid_list_get(ptr %p0, i64 %t7212)
%t7216 = call i64 @resid_unbox_i64(ptr %t7215)
%t7218 = and i64 %t7216, 255
%t7219 = shl i64 %t7218, 24
%t7220 = or i64 %t7210, %t7219
ret i64 %t7220
}
define i512 @__m____________lib_chachag_resid__pg_m130() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7221 = sext i256 1361129467683753853853498429727072845823 to i512
ret i512 %t7221
}
define i512 @__m____________lib_chachag_resid__pg_p() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7222 = sext i256 1361129467683753853853498429727072845819 to i512
ret i512 %t7222
}
define i512 @__m____________lib_chachag_resid__pg_m128() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7223 = sext i256 340282366920938463463374607431768211455 to i512
ret i512 %t7223
}
define i512 @__m____________lib_chachag_resid__pg_clamp() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7224 = sext i128 21267647620597763993911028882763415551 to i512
ret i512 %t7224
}
define i64 @__m____________lib_chachag_resid__cg_pad16(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7225 = srem i64 %p0, 16
%t7226 = icmp eq i64 %t7225, 0
br i1 %t7226, label %L739, label %L740
L739:
br label %L741
L740:
%t7227 = sub nsw i64 16, %t7225
br label %L741
L741:
%t7228 = phi i64 [ 0, %L739 ], [ %t7227, %L740 ]
ret i64 %t7228
}
define ptr @__m____________lib_chachag_resid__cg_zeros(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7231, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7235, %tco.s0 ]
%t7229 = icmp sge i64 %p1, %p0
br i1 %t7229, label %L742, label %L744
L742:
%t7230 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty7230)
ret ptr %t7230
L744:
%t7231 = add nsw i64 %p1, 1
%t7232 = call ptr @resid_box_i64(i64 0)
%t7235 = call ptr @resid_listbuf_push(ptr %p2, ptr %t7232)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__cg_le64(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7239, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7252, %tco.s0 ]
%t7237 = icmp sge i64 %p1, 8
br i1 %t7237, label %L745, label %L747
L745:
%t7238 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty7238)
ret ptr %t7238
L747:
%t7239 = add nsw i64 %p1, 1
%t7240 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p1)
%t7241 = extractvalue {i64, i1} %t7240, 0
%t7242 = extractvalue {i64, i1} %t7240, 1
%t7243 = zext i1 %t7242 to i8
call void @resid_overflow_check(i8 %t7243)
%t7244 = icmp uge i64 %t7241, 64
%t7245 = add i64 %t7241, 0
%t7246 = select i1 %t7244, i64 63, i64 %t7245
%t7247 = ashr i64 %p0, %t7246
%t7248 = and i64 %t7247, 255
%t7249 = call ptr @resid_box_i64(i64 %t7248)
%t7252 = call ptr @resid_listbuf_push(ptr %p2, ptr %t7249)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @chacha_block(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7254 = musttail call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
ret ptr %t7254
}
define ptr @chacha20_xor(ptr %p0, i64 %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7255 = musttail call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2, ptr %p3)
ret ptr %t7255
}
define ptr @poly1305(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7256 = musttail call ptr @poly1305g__g_Int_64__Int_512_(ptr %p0, ptr %p1)
ret ptr %t7256
}
define ptr @chacha20poly1305_seal(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7257 = musttail call ptr @chacha20poly1305g_seal__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
ret ptr %t7257
}
define i1 @chacha20poly1305_open(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7258 = call ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
%t7259 = getelementptr {i32, i32, ptr}, ptr %t7258, i32 0, i32 0
%t7260w = load i32, ptr %t7259
%t7260 = sext i32 %t7260w to i64
%t7261 = icmp eq i64 %t7260, 1
br i1 %t7261, label %L748, label %L749
L748:
%t7262 = getelementptr {i32, i32, ptr}, ptr %t7258, i32 1
%t7263 = getelementptr i8, ptr %t7262, i64 0
%t7264 = getelementptr ptr, ptr %t7263, i32 0
%t7265 = load ptr, ptr %t7264
br label %L750
L749:
br label %L750
L750:
%t7266 = phi i1 [ true, %L748 ], [ false, %L749 ]
ret i1 %t7266
}
define ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7267 = musttail call ptr @chacha20poly1305g_decrypt__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
ret ptr %t7267
}
define ptr @chacha20poly1305_open_bytes(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7268 = call ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
%t7269 = getelementptr {i32, i32, ptr}, ptr %t7268, i32 0, i32 0
%t7270w = load i32, ptr %t7269
%t7270 = sext i32 %t7270w to i64
%t7271 = icmp eq i64 %t7270, 1
br i1 %t7271, label %L751, label %L752
L752:
%t7273 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty7272)
br label %L753
L751:
%t7274 = getelementptr {i32, i32, ptr}, ptr %t7268, i32 1
%t7275 = getelementptr i8, ptr %t7274, i64 0
%t7276 = getelementptr ptr, ptr %t7275, i32 0
%t7277 = load ptr, ptr %t7276
br label %L753
L753:
%t7278 = phi ptr [ %t7273, %L752 ], [ %t7277, %L751 ]
ret ptr %t7278
}
define ptr @cbe_be(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7291 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7285, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t7279 = icmp sle i64 %p1, 0
br i1 %t7279, label %L754, label %L756
L754:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p2
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L756:
%t7280 = sub nsw i64 %p1, 1
%t7281 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t7280, i64 8)
%t7282 = extractvalue {i64, i1} %t7281, 0
%t7283 = extractvalue {i64, i1} %t7281, 1
%t7284 = zext i1 %t7283 to i8
call void @resid_overflow_check(i8 %t7284)
%t7285 = sub nsw i64 %p1, 1
%t7286 = icmp uge i64 %t7282, 64
%t7287 = add i64 %t7282, 0
%t7288 = select i1 %t7286, i64 63, i64 %t7287
%t7289 = ashr i64 %p0, %t7288
%t7290 = and i64 %t7289, 255
%t7293 = call ptr @resid_box_i64(i64 %t7290)
%t7295 = getelementptr i8, ptr %t7291, i64 0
store ptr %t7293, ptr %t7295
%t7296 = call ptr @resid_list_new(i64 1, ptr %t7291, ptr @.lty7291)
%t7297 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7296)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t7297, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t7297, %tco.s0 ]
br label %tco.head
}
define ptr @cbe_head(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7302 = alloca [1 x ptr]
%t7312 = alloca [2 x ptr]
%t7324 = alloca [1 x ptr]
%t7334 = alloca [1 x ptr]
%t7343 = alloca [1 x ptr]
%t7299 = shl i64 %p0, 5
%t7300 = icmp sle i64 %p1, 23
br i1 %t7300, label %L757, label %L759
L757:
%t7301 = or i64 %t7299, %p1
%t7304 = call ptr @resid_box_i64(i64 %t7301)
%t7306 = getelementptr i8, ptr %t7302, i64 0
store ptr %t7304, ptr %t7306
%t7307 = call ptr @resid_list_new(i64 1, ptr %t7302, ptr @.lty7302)
%t7308 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7307)
ret ptr %t7308
L759:
%t7309 = icmp sle i64 %p1, 255
br i1 %t7309, label %L760, label %L762
L760:
%t7310 = or i64 %t7299, 24
%t7311 = add nsw i64 %p1, 0
%t7314 = call ptr @resid_box_i64(i64 %t7310)
%t7316 = getelementptr i8, ptr %t7312, i64 0
store ptr %t7314, ptr %t7316
%t7317 = call ptr @resid_box_i64(i64 %t7311)
%t7319 = getelementptr i8, ptr %t7312, i64 8
store ptr %t7317, ptr %t7319
%t7320 = call ptr @resid_list_new(i64 2, ptr %t7312, ptr @.lty7312)
%t7321 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7320)
ret ptr %t7321
L762:
%t7322 = icmp sle i64 %p1, 65535
br i1 %t7322, label %L763, label %L765
L763:
%t7323 = or i64 %t7299, 25
%t7326 = call ptr @resid_box_i64(i64 %t7323)
%t7328 = getelementptr i8, ptr %t7324, i64 0
store ptr %t7326, ptr %t7328
%t7329 = call ptr @resid_list_new(i64 1, ptr %t7324, ptr @.lty7324)
%t7330 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7329)
%t7331 = musttail call ptr @cbe_be(i64 %p1, i64 2, ptr %t7330)
ret ptr %t7331
L765:
%t7332 = icmp sle i64 %p1, 4294967295
br i1 %t7332, label %L766, label %L768
L766:
%t7333 = or i64 %t7299, 26
%t7336 = call ptr @resid_box_i64(i64 %t7333)
%t7338 = getelementptr i8, ptr %t7334, i64 0
store ptr %t7336, ptr %t7338
%t7339 = call ptr @resid_list_new(i64 1, ptr %t7334, ptr @.lty7334)
%t7340 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7339)
%t7341 = musttail call ptr @cbe_be(i64 %p1, i64 4, ptr %t7340)
ret ptr %t7341
L768:
%t7342 = or i64 %t7299, 27
%t7345 = call ptr @resid_box_i64(i64 %t7342)
%t7347 = getelementptr i8, ptr %t7343, i64 0
store ptr %t7345, ptr %t7347
%t7348 = call ptr @resid_list_new(i64 1, ptr %t7343, ptr @.lty7343)
%t7349 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t7348)
%t7350 = musttail call ptr @cbe_be(i64 %p1, i64 8, ptr %t7349)
ret ptr %t7350
}
define ptr @cbe_uint(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7351 = call ptr @cbe_head(i64 0, i64 %p0, ptr %p1)
ret ptr %t7351
}
define ptr @cbe_int(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7352 = icmp sge i64 %p0, 0
br i1 %t7352, label %L769, label %L771
L769:
%t7353 = call ptr @cbe_head(i64 0, i64 %p0, ptr %p1)
ret ptr %t7353
L771:
%t7354 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p0)
%t7355 = extractvalue {i64, i1} %t7354, 0
%t7356 = extractvalue {i64, i1} %t7354, 1
%t7357 = zext i1 %t7356 to i8
call void @resid_overflow_check(i8 %t7357)
%t7358 = sub nsw i64 %t7355, 1
%t7359 = call ptr @cbe_head(i64 1, i64 %t7358, ptr %p1)
ret ptr %t7359
}
define ptr @cbe_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7360 = call i64 @resid_list_len(ptr %p0)
%t7361 = call ptr @cbe_head(i64 2, i64 %t7360, ptr %p1)
%t7362 = call ptr @resid_list_concat_own(ptr %t7361, i8 1, ptr %p0)
ret ptr %t7362
}
define ptr @cbe_text(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7363 = call ptr @bytes_of(ptr %p0)
%t7364 = call ptr @resid_list_freeze(ptr %t7363)
%t7365 = call i64 @resid_list_len(ptr %t7364)
%t7366 = call ptr @cbe_head(i64 3, i64 %t7365, ptr %p1)
%t7367 = call ptr @resid_list_concat_own(ptr %t7366, i8 1, ptr %t7364)
ret ptr %t7367
}
define ptr @cbe_array(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7368 = call ptr @cbe_head(i64 4, i64 %p0, ptr %p1)
ret ptr %t7368
}
define ptr @cbe_map(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7369 = call ptr @cbe_head(i64 5, i64 %p0, ptr %p1)
ret ptr %t7369
}
define ptr @cbe_tag(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7370 = call ptr @cbe_head(i64 6, i64 %p0, ptr %p1)
ret ptr %t7370
}
define i64 @cbe_be_read(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7373, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t7376, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t7381, %tco.s0 ]
%t7371 = icmp sle i64 %p2, 0
br i1 %t7371, label %L772, label %L774
L772:
ret i64 %p3
L774:
%t7372 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t7373 = extractvalue {i64, i1} %t7372, 0
%t7374 = extractvalue {i64, i1} %t7372, 1
%t7375 = zext i1 %t7374 to i8
call void @resid_overflow_check(i8 %t7375)
%t7376 = sub nsw i64 %p2, 1
%t7377 = shl i64 %p3, 8
%t7378 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t7379 = call i64 @resid_unbox_i64(ptr %t7378)
%t7381 = or i64 %t7377, %t7379
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @cbe_read_head(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7383 = icmp slt i64 %p1, 0
br label %LSL7384
LSL7384:
br i1 %t7383, label %LSJ7384, label %LSR7384
LSR7384:
%t7385 = call i64 @resid_list_len(ptr %p0)
%t7386 = icmp sge i64 %p1, %t7385
br label %LSJ7384
LSJ7384:
%t7387 = phi i1 [ true, %LSL7384 ], [ %t7386, %LSR7384 ]
br i1 %t7387, label %L775, label %L777
L775:
%t7388 = call ptr @resid_gmalloc(i64 32)
%t7388.f0 = getelementptr i8, ptr %t7388, i64 0
store i1 false, ptr %t7388.f0, align 8
%t7388.f1 = getelementptr i8, ptr %t7388, i64 8
store i64 0, ptr %t7388.f1, align 8
%t7388.f2 = getelementptr i8, ptr %t7388, i64 16
store i64 0, ptr %t7388.f2, align 8
%t7388.f3 = getelementptr i8, ptr %t7388, i64 24
store i64 %p1, ptr %t7388.f3, align 8
ret ptr %t7388
L777:
%t7389 = call ptr @resid_list_get_nc(ptr %p0, i64 %p1)
%t7390 = call i64 @resid_unbox_i64(ptr %t7389)
%t7392 = ashr i64 %t7390, 5
%t7393 = and i64 %t7390, 31
%t7394 = icmp sle i64 %t7393, 23
br i1 %t7394, label %L778, label %L780
L778:
%t7395 = call ptr @resid_gmalloc(i64 32)
%t7395.f0 = getelementptr i8, ptr %t7395, i64 0
store i1 true, ptr %t7395.f0, align 8
%t7395.f1 = getelementptr i8, ptr %t7395, i64 8
store i64 %t7392, ptr %t7395.f1, align 8
%t7395.f2 = getelementptr i8, ptr %t7395, i64 16
store i64 %t7393, ptr %t7395.f2, align 8
%t7396 = add nsw i64 %p1, 1
%t7395.f3 = getelementptr i8, ptr %t7395, i64 24
store i64 %t7396, ptr %t7395.f3, align 8
ret ptr %t7395
L780:
%t7397 = call i64 @cbe_arg_len(i64 %t7393)
%t7398 = icmp eq i64 %t7397, 0
br i1 %t7398, label %L781, label %L783
L781:
%t7399 = call ptr @resid_gmalloc(i64 32)
%t7399.f0 = getelementptr i8, ptr %t7399, i64 0
store i1 false, ptr %t7399.f0, align 8
%t7399.f1 = getelementptr i8, ptr %t7399, i64 8
store i64 %t7392, ptr %t7399.f1, align 8
%t7399.f2 = getelementptr i8, ptr %t7399, i64 16
store i64 0, ptr %t7399.f2, align 8
%t7399.f3 = getelementptr i8, ptr %t7399, i64 24
store i64 %p1, ptr %t7399.f3, align 8
ret ptr %t7399
L783:
%t7400 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t7397)
%t7401 = extractvalue {i64, i1} %t7400, 0
%t7402 = extractvalue {i64, i1} %t7400, 1
%t7403 = zext i1 %t7402 to i8
call void @resid_overflow_check(i8 %t7403)
%t7404 = call i64 @resid_list_len(ptr %p0)
%t7405 = icmp sge i64 %t7401, %t7404
br i1 %t7405, label %L784, label %L786
L784:
%t7406 = call ptr @resid_gmalloc(i64 32)
%t7406.f0 = getelementptr i8, ptr %t7406, i64 0
store i1 false, ptr %t7406.f0, align 8
%t7406.f1 = getelementptr i8, ptr %t7406, i64 8
store i64 %t7392, ptr %t7406.f1, align 8
%t7406.f2 = getelementptr i8, ptr %t7406, i64 16
store i64 0, ptr %t7406.f2, align 8
%t7406.f3 = getelementptr i8, ptr %t7406, i64 24
store i64 %p1, ptr %t7406.f3, align 8
ret ptr %t7406
L786:
%t7407 = call ptr @resid_gmalloc(i64 32)
%t7407.f0 = getelementptr i8, ptr %t7407, i64 0
store i1 true, ptr %t7407.f0, align 8
%t7407.f1 = getelementptr i8, ptr %t7407, i64 8
store i64 %t7392, ptr %t7407.f1, align 8
%t7408 = add nsw i64 %p1, 1
%t7409 = call i64 @cbe_be_read(ptr %p0, i64 %t7408, i64 %t7397, i64 0)
%t7407.f2 = getelementptr i8, ptr %t7407, i64 16
store i64 %t7409, ptr %t7407.f2, align 8
%t7410 = add nsw i64 %p1, 1
%t7411 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7410, i64 %t7397)
%t7412 = extractvalue {i64, i1} %t7411, 0
%t7413 = extractvalue {i64, i1} %t7411, 1
%t7414 = zext i1 %t7413 to i8
call void @resid_overflow_check(i8 %t7414)
%t7407.f3 = getelementptr i8, ptr %t7407, i64 24
store i64 %t7412, ptr %t7407.f3, align 8
ret ptr %t7407
}
define i64 @cbe_arg_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7415 = icmp eq i64 %p0, 24
br i1 %t7415, label %L787, label %L789
L787:
ret i64 1
L789:
%t7416 = icmp eq i64 %p0, 25
br i1 %t7416, label %L790, label %L792
L790:
ret i64 2
L792:
%t7417 = icmp eq i64 %p0, 26
br i1 %t7417, label %L793, label %L795
L793:
ret i64 4
L795:
%t7418 = icmp eq i64 %p0, 27
br i1 %t7418, label %L796, label %L798
L796:
ret i64 8
L798:
ret i64 0
}
define ptr @cbe_read_str(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7419 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB7419)
%t7420 = call ptr @cbe_read_head(ptr %p0, i64 %p1)
%t7421 = getelementptr i8, ptr %t7420, i64 0
%t7422 = load i1, ptr %t7421, align 8
%t7423 = xor i1 %t7422, true
br label %LSL7424
LSL7424:
br i1 %t7423, label %LSJ7424, label %LSR7424
LSR7424:
%t7425 = getelementptr i8, ptr %t7420, i64 8
%t7426 = load i64, ptr %t7425, align 8
%t7427 = icmp ne i64 %t7426, %p2
br label %LSJ7424
LSJ7424:
%t7428 = phi i1 [ true, %LSL7424 ], [ %t7427, %LSR7424 ]
br label %LSL7429
LSL7429:
br i1 %t7428, label %LSJ7429, label %LSR7429
LSR7429:
%t7430 = getelementptr i8, ptr %t7420, i64 16
%t7431 = load i64, ptr %t7430, align 8
%t7432 = icmp slt i64 %t7431, 0
br label %LSJ7429
LSJ7429:
%t7433 = phi i1 [ true, %LSL7429 ], [ %t7432, %LSR7429 ]
br label %LSL7434
LSL7434:
br i1 %t7433, label %LSJ7434, label %LSR7434
LSR7434:
%t7435 = getelementptr i8, ptr %t7420, i64 16
%t7436 = load i64, ptr %t7435, align 8
%t7437 = call i64 @resid_list_len(ptr %p0)
%t7438 = getelementptr i8, ptr %t7420, i64 24
%t7439 = load i64, ptr %t7438, align 8
%t7440 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7437, i64 %t7439)
%t7441 = extractvalue {i64, i1} %t7440, 0
%t7442 = extractvalue {i64, i1} %t7440, 1
%t7443 = zext i1 %t7442 to i8
call void @resid_overflow_check(i8 %t7443)
%t7444 = icmp sgt i64 %t7436, %t7441
br label %LSJ7434
LSJ7434:
%t7445 = phi i1 [ true, %LSL7434 ], [ %t7444, %LSR7434 ]
br i1 %t7445, label %L799, label %L801
L799:
%t7446 = call ptr @resid_gmalloc(i64 24)
%t7446.f0 = getelementptr i8, ptr %t7446, i64 0
store i1 false, ptr %t7446.f0, align 8
%t7446.f1 = getelementptr i8, ptr %t7446, i64 8
store ptr %t7419, ptr %t7446.f1, align 8
%t7446.f2 = getelementptr i8, ptr %t7446, i64 16
store i64 %p1, ptr %t7446.f2, align 8
ret ptr %t7446
L801:
%t7447 = getelementptr i8, ptr %t7420, i64 24
%t7448 = load i64, ptr %t7447, align 8
%t7449 = getelementptr i8, ptr %t7420, i64 16
%t7450 = load i64, ptr %t7449, align 8
%t7451 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7448, i64 %t7450)
%t7452 = extractvalue {i64, i1} %t7451, 0
%t7453 = extractvalue {i64, i1} %t7451, 1
%t7454 = zext i1 %t7453 to i8
call void @resid_overflow_check(i8 %t7454)
%t7455 = call ptr @resid_gmalloc(i64 24)
%t7455.f0 = getelementptr i8, ptr %t7455, i64 0
store i1 true, ptr %t7455.f0, align 8
%t7456 = getelementptr i8, ptr %t7420, i64 24
%t7457 = load i64, ptr %t7456, align 8
%t7458 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7452, i64 1)
%t7459 = extractvalue {i64, i1} %t7458, 0
%t7460 = extractvalue {i64, i1} %t7458, 1
%t7461 = zext i1 %t7460 to i8
call void @resid_overflow_check(i8 %t7461)
%t7462 = call ptr @slice_bytes(ptr %p0, i64 %t7457, i64 %t7459)
%t7455.f1 = getelementptr i8, ptr %t7455, i64 8
store ptr %t7462, ptr %t7455.f1, align 8
%t7455.f2 = getelementptr i8, ptr %t7455, i64 16
store i64 %t7452, ptr %t7455.f2, align 8
ret ptr %t7455
}
define ptr @cbe_ascii__sacc(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7465, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7470, %tco.s0 ]
%t7463 = call i64 @resid_list_len(ptr %p0)
%t7464 = icmp sge i64 %p1, %t7463
br i1 %t7464, label %L802, label %L804
L802:
ret ptr %p2
L804:
%t7465 = add nsw i64 %p1, 1
%t7466 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t7467 = call i64 @resid_unbox_i64(ptr %t7466)
%t7469 = call ptr @str_from_code(i64 %t7467)
%t7470 = call ptr @resid_sacc_append(ptr %p2, ptr %t7469)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @cose_nibble(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7472 = icmp sge i64 %p0, 48
br label %LSL7473
LSL7473:
br i1 %t7472, label %LSR7473, label %LSJ7473
LSR7473:
%t7474 = icmp sle i64 %p0, 57
br label %LSJ7473
LSJ7473:
%t7475 = phi i1 [ false, %LSL7473 ], [ %t7474, %LSR7473 ]
br i1 %t7475, label %L805, label %L807
L805:
%t7476 = sub nsw i64 %p0, 48
ret i64 %t7476
L807:
%t7477 = icmp sge i64 %p0, 97
br label %LSL7478
LSL7478:
br i1 %t7477, label %LSR7478, label %LSJ7478
LSR7478:
%t7479 = icmp sle i64 %p0, 102
br label %LSJ7478
LSJ7478:
%t7480 = phi i1 [ false, %LSL7478 ], [ %t7479, %LSR7478 ]
br i1 %t7480, label %L808, label %L810
L808:
%t7481 = sub nsw i64 %p0, 87
ret i64 %t7481
L810:
%t7482 = icmp sge i64 %p0, 65
br label %LSL7483
LSL7483:
br i1 %t7482, label %LSR7483, label %LSJ7483
LSR7483:
%t7484 = icmp sle i64 %p0, 70
br label %LSJ7483
LSJ7483:
%t7485 = phi i1 [ false, %LSL7483 ], [ %t7484, %LSR7483 ]
br i1 %t7485, label %L811, label %L813
L811:
%t7486 = sub nsw i64 %p0, 55
ret i64 %t7486
L813:
ret i64 0
}
define ptr @cose_hex_acc(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7512 = alloca [1 x ptr]
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7509, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t7487 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t7488 = extractvalue {i64, i1} %t7487, 0
%t7489 = extractvalue {i64, i1} %t7487, 1
%t7490 = zext i1 %t7489 to i8
call void @resid_overflow_check(i8 %t7490)
%t7491 = icmp sge i64 %t7488, %p2
br i1 %t7491, label %L814, label %L816
L814:
%lr.cx18 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz18 = icmp eq ptr %lr.cx18, null
br i1 %lr.lz18, label %lr.x18.k, label %lr.x18.m
lr.x18.k:
ret ptr %p3
lr.x18.m:
%lr.ret18 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx18)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret18
L816:
%t7492 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t7493 = call i64 @cose_nibble(i64 %t7492)
%t7494 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t7493, i64 16)
%t7495 = extractvalue {i64, i1} %t7494, 0
%t7496 = extractvalue {i64, i1} %t7494, 1
%t7497 = zext i1 %t7496 to i8
call void @resid_overflow_check(i8 %t7497)
%t7498 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t7499 = extractvalue {i64, i1} %t7498, 0
%t7500 = extractvalue {i64, i1} %t7498, 1
%t7501 = zext i1 %t7500 to i8
call void @resid_overflow_check(i8 %t7501)
%t7502 = call i64 @resid_char_at_n(ptr %p0, i64 %t7499, i64 %p0.alen)
%t7503 = call i64 @cose_nibble(i64 %t7502)
%t7504 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7495, i64 %t7503)
%t7505 = extractvalue {i64, i1} %t7504, 0
%t7506 = extractvalue {i64, i1} %t7504, 1
%t7507 = zext i1 %t7506 to i8
call void @resid_overflow_check(i8 %t7507)
%t7508 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t7509 = extractvalue {i64, i1} %t7508, 0
%t7510 = extractvalue {i64, i1} %t7508, 1
%t7511 = zext i1 %t7510 to i8
call void @resid_overflow_check(i8 %t7511)
%t7514 = call ptr @resid_box_i64(i64 %t7505)
%t7516 = getelementptr i8, ptr %t7512, i64 0
store ptr %t7514, ptr %t7516
%t7517 = call ptr @resid_list_new(i64 1, ptr %t7512, ptr @.lty7512)
%t7518 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t7517)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t7518, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t7518, %tco.s0 ]
br label %tco.head
}
define ptr @cose_hex_decode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7520 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB7520)
%t7521 = call i64 @str_len(ptr %p0)
%t7522 = call ptr @cose_hex_acc(ptr %p0, i64 0, i64 %t7521, ptr %t7520)
ret ptr %t7522
}
define ptr @cose_sig_structure(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7524 = call ptr @resid_list_const_i64(ptr @.lc7523, i64 12, ptr @.lcd7523, ptr @.lty7523)
%t7525 = call ptr @cbe_bytes(ptr %p0, ptr %t7524)
%t7527 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty7526)
%t7528 = call ptr @cbe_bytes(ptr %t7527, ptr %t7525)
%t7529 = musttail call ptr @cbe_bytes(ptr %p1, ptr %t7528)
ret ptr %t7529
}
define ptr @cose_sign1_protected(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7530 = call ptr @bytes_of(ptr %p0)
%t7531 = call ptr @resid_list_freeze(ptr %t7530)
%t7533 = call ptr @resid_list_const_i64(ptr @.lc7532, i64 4, ptr @.lcd7532, ptr @.lty7532)
%t7534 = call ptr @cbe_bytes(ptr %t7531, ptr %t7533)
ret ptr %t7534
}
define ptr @cose_sign1_err(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7535 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB7535)
%t7536 = call ptr @resid_gmalloc(i64 48)
%t7536.f0 = getelementptr i8, ptr %t7536, i64 0
store i1 false, ptr %t7536.f0, align 8
%t7536.f1 = getelementptr i8, ptr %t7536, i64 8
store ptr %p0, ptr %t7536.f1, align 8
%t7536.f2 = getelementptr i8, ptr %t7536, i64 16
store ptr @.s7537, ptr %t7536.f2, align 8
%t7536.f3 = getelementptr i8, ptr %t7536, i64 24
store ptr %t7535, ptr %t7536.f3, align 8
%t7536.f4 = getelementptr i8, ptr %t7536, i64 32
store ptr %t7535, ptr %t7536.f4, align 8
%t7536.f5 = getelementptr i8, ptr %t7536, i64 40
store ptr %t7535, ptr %t7536.f5, align 8
ret ptr %t7536
}
define ptr @cose_kid_of(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7538 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t7539 = getelementptr i8, ptr %t7538, i64 0
%t7540 = load i1, ptr %t7539, align 8
%t7541 = xor i1 %t7540, true
br label %LSL7542
LSL7542:
br i1 %t7541, label %LSJ7542, label %LSR7542
LSR7542:
%t7543 = getelementptr i8, ptr %t7538, i64 8
%t7544 = load i64, ptr %t7543, align 8
%t7545 = icmp ne i64 %t7544, 5
br label %LSJ7542
LSJ7542:
%t7546 = phi i1 [ true, %LSL7542 ], [ %t7545, %LSR7542 ]
br i1 %t7546, label %L817, label %L819
L817:
ret ptr @.s7547
L819:
%t7548 = getelementptr i8, ptr %t7538, i64 24
%t7549 = load i64, ptr %t7548, align 8
%t7550 = getelementptr i8, ptr %t7538, i64 16
%t7551 = load i64, ptr %t7550, align 8
%t7552 = call ptr @cose_kid_scan(ptr %p0, i64 %t7549, i64 %t7551)
ret ptr %t7552
}
define ptr @cose_kid_scan(ptr %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7631, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t7632, %tco.s0.k ]
%t7553 = icmp sle i64 %p2, 0
br i1 %t7553, label %L820, label %L822
L820:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr @.s7554
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_str(ptr @.s7554, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L822:
%t7555 = call ptr @cbe_read_head(ptr %p0, i64 %p1)
%t7556 = getelementptr i8, ptr %t7555, i64 0
%t7557 = load i1, ptr %t7556, align 8
%t7558 = xor i1 %t7557, true
br i1 %t7558, label %L823, label %L825
L823:
%lr.cx18 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz18 = icmp eq ptr %lr.cx18, null
br i1 %lr.lz18, label %lr.x18.k, label %lr.x18.m
lr.x18.k:
ret ptr @.s7559
lr.x18.m:
%lr.ret18 = call ptr @resid_mv_str(ptr @.s7559, ptr %lr.cx18)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret18
L825:
%t7560 = getelementptr i8, ptr %t7555, i64 24
%t7561 = load i64, ptr %t7560, align 8
%t7562 = call ptr @cbe_read_head(ptr %p0, i64 %t7561)
%t7563 = getelementptr i8, ptr %t7562, i64 0
%t7564 = load i1, ptr %t7563, align 8
%t7565 = xor i1 %t7564, true
br i1 %t7565, label %L826, label %L828
L826:
%lr.cx28 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz28 = icmp eq ptr %lr.cx28, null
br i1 %lr.lz28, label %lr.x28.k, label %lr.x28.m
lr.x28.k:
ret ptr @.s7566
lr.x28.m:
%lr.ret28 = call ptr @resid_mv_str(ptr @.s7566, ptr %lr.cx28)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret28
L828:
%t7567 = getelementptr i8, ptr %t7555, i64 8
%t7568 = load i64, ptr %t7567, align 8
%t7569 = icmp eq i64 %t7568, 0
br label %LSL7570
LSL7570:
br i1 %t7569, label %LSR7570, label %LSJ7570
LSR7570:
%t7571 = getelementptr i8, ptr %t7555, i64 16
%t7572 = load i64, ptr %t7571, align 8
%t7573 = icmp eq i64 %t7572, 4
br label %LSJ7570
LSJ7570:
%t7574 = phi i1 [ false, %LSL7570 ], [ %t7573, %LSR7570 ]
br label %LSL7575
LSL7575:
br i1 %t7574, label %LSR7575, label %LSJ7575
LSR7575:
%t7576 = getelementptr i8, ptr %t7562, i64 8
%t7577 = load i64, ptr %t7576, align 8
%t7578 = icmp eq i64 %t7577, 2
br label %LSJ7575
LSJ7575:
%t7579 = phi i1 [ false, %LSL7575 ], [ %t7578, %LSR7575 ]
br i1 %t7579, label %L829, label %L831
L829:
%t7580 = getelementptr i8, ptr %t7555, i64 24
%t7581 = load i64, ptr %t7580, align 8
%t7582 = call ptr @cbe_read_str(ptr %p0, i64 %t7581, i64 2)
%t7583 = getelementptr i8, ptr %t7582, i64 8
%t7584 = load ptr, ptr %t7583, align 8
%t7586 = call ptr @cbe_ascii(ptr %t7584, i64 0, ptr @.s7585)
%lr.cx61 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz61 = icmp eq ptr %lr.cx61, null
br i1 %lr.lz61, label %lr.x61.k, label %lr.x61.m
lr.x61.k:
ret ptr %t7586
lr.x61.m:
%lr.ret61 = call ptr @resid_mv_str(ptr %t7586, ptr %lr.cx61)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret61
L831:
%t7587 = getelementptr i8, ptr %t7562, i64 8
%t7588 = load i64, ptr %t7587, align 8
%t7589 = icmp eq i64 %t7588, 2
br label %LSL7590
LSL7590:
br i1 %t7589, label %LSJ7590, label %LSR7590
LSR7590:
%t7591 = getelementptr i8, ptr %t7562, i64 8
%t7592 = load i64, ptr %t7591, align 8
%t7593 = icmp eq i64 %t7592, 3
br label %LSJ7590
LSJ7590:
%t7594 = phi i1 [ true, %LSL7590 ], [ %t7593, %LSR7590 ]
br label %LSL7595
LSL7595:
br i1 %t7594, label %LSR7595, label %LSJ7595
LSR7595:
%t7596 = getelementptr i8, ptr %t7562, i64 16
%t7597 = load i64, ptr %t7596, align 8
%t7598 = icmp slt i64 %t7597, 0
br label %LSL7599
LSL7599:
br i1 %t7598, label %LSJ7599, label %LSR7599
LSR7599:
%t7600 = getelementptr i8, ptr %t7562, i64 16
%t7601 = load i64, ptr %t7600, align 8
%t7602 = call i64 @resid_list_len(ptr %p0)
%t7603 = getelementptr i8, ptr %t7562, i64 24
%t7604 = load i64, ptr %t7603, align 8
%t7605 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7602, i64 %t7604)
%t7606 = extractvalue {i64, i1} %t7605, 0
%t7607 = extractvalue {i64, i1} %t7605, 1
%t7608 = zext i1 %t7607 to i8
call void @resid_overflow_check(i8 %t7608)
%t7609 = icmp sgt i64 %t7601, %t7606
br label %LSJ7599
LSJ7599:
%t7610 = phi i1 [ true, %LSL7599 ], [ %t7609, %LSR7599 ]
br label %LSJ7595
LSJ7595:
%t7611 = phi i1 [ false, %LSL7595 ], [ %t7610, %LSJ7599 ]
br i1 %t7611, label %L832, label %L834
L832:
%lr.cx106 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz106 = icmp eq ptr %lr.cx106, null
br i1 %lr.lz106, label %lr.x106.k, label %lr.x106.m
lr.x106.k:
ret ptr @.s7612
lr.x106.m:
%lr.ret106 = call ptr @resid_mv_str(ptr @.s7612, ptr %lr.cx106)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret106
L834:
%t7613 = getelementptr i8, ptr %t7562, i64 8
%t7614 = load i64, ptr %t7613, align 8
%t7615 = icmp eq i64 %t7614, 2
br label %LSL7616
LSL7616:
br i1 %t7615, label %LSJ7616, label %LSR7616
LSR7616:
%t7617 = getelementptr i8, ptr %t7562, i64 8
%t7618 = load i64, ptr %t7617, align 8
%t7619 = icmp eq i64 %t7618, 3
br label %LSJ7616
LSJ7616:
%t7620 = phi i1 [ true, %LSL7616 ], [ %t7619, %LSR7616 ]
br i1 %t7620, label %L835, label %L836
L835:
%t7621 = getelementptr i8, ptr %t7562, i64 24
%t7622 = load i64, ptr %t7621, align 8
%t7623 = getelementptr i8, ptr %t7562, i64 16
%t7624 = load i64, ptr %t7623, align 8
%t7625 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7622, i64 %t7624)
%t7626 = extractvalue {i64, i1} %t7625, 0
%t7627 = extractvalue {i64, i1} %t7625, 1
%t7628 = zext i1 %t7627 to i8
call void @resid_overflow_check(i8 %t7628)
br label %L837
L836:
%t7629 = getelementptr i8, ptr %t7562, i64 24
%t7630 = load i64, ptr %t7629, align 8
br label %L837
L837:
%t7631 = phi i64 [ %t7626, %L835 ], [ %t7630, %L836 ]
%t7632 = sub nsw i64 %p2, 1
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
%t7634 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t7635 = getelementptr i8, ptr %t7634, i64 0
%t7636 = load i1, ptr %t7635, align 8
%t7637 = xor i1 %t7636, true
br label %LSL7638
LSL7638:
br i1 %t7637, label %LSJ7638, label %LSR7638
LSR7638:
%t7639 = getelementptr i8, ptr %t7634, i64 8
%t7640 = load i64, ptr %t7639, align 8
%t7641 = icmp ne i64 %t7640, 6
br label %LSJ7638
LSJ7638:
%t7642 = phi i1 [ true, %LSL7638 ], [ %t7641, %LSR7638 ]
br label %LSL7643
LSL7643:
br i1 %t7642, label %LSJ7643, label %LSR7643
LSR7643:
%t7644 = getelementptr i8, ptr %t7634, i64 16
%t7645 = load i64, ptr %t7644, align 8
%t7646 = icmp ne i64 %t7645, 18
br label %LSJ7643
LSJ7643:
%t7647 = phi i1 [ true, %LSL7643 ], [ %t7646, %LSR7643 ]
br i1 %t7647, label %L838, label %L840
L838:
%t7649 = musttail call ptr @cose_sign1_err(ptr @.s7648)
ret ptr %t7649
L840:
%t7650 = getelementptr i8, ptr %t7634, i64 24
%t7651 = load i64, ptr %t7650, align 8
%t7652 = call ptr @cbe_read_head(ptr %p0, i64 %t7651)
%t7653 = getelementptr i8, ptr %t7652, i64 0
%t7654 = load i1, ptr %t7653, align 8
%t7655 = xor i1 %t7654, true
br label %LSL7656
LSL7656:
br i1 %t7655, label %LSJ7656, label %LSR7656
LSR7656:
%t7657 = getelementptr i8, ptr %t7652, i64 8
%t7658 = load i64, ptr %t7657, align 8
%t7659 = icmp ne i64 %t7658, 4
br label %LSJ7656
LSJ7656:
%t7660 = phi i1 [ true, %LSL7656 ], [ %t7659, %LSR7656 ]
br label %LSL7661
LSL7661:
br i1 %t7660, label %LSJ7661, label %LSR7661
LSR7661:
%t7662 = getelementptr i8, ptr %t7652, i64 16
%t7663 = load i64, ptr %t7662, align 8
%t7664 = icmp ne i64 %t7663, 4
br label %LSJ7661
LSJ7661:
%t7665 = phi i1 [ true, %LSL7661 ], [ %t7664, %LSR7661 ]
br i1 %t7665, label %L841, label %L843
L841:
%t7667 = musttail call ptr @cose_sign1_err(ptr @.s7666)
ret ptr %t7667
L843:
%t7668 = getelementptr i8, ptr %t7652, i64 24
%t7669 = load i64, ptr %t7668, align 8
%t7670 = call ptr @cbe_read_str(ptr %p0, i64 %t7669, i64 2)
%t7671 = getelementptr i8, ptr %t7670, i64 0
%t7672 = load i1, ptr %t7671, align 8
%t7673 = xor i1 %t7672, true
br i1 %t7673, label %L844, label %L846
L844:
%t7675 = musttail call ptr @cose_sign1_err(ptr @.s7674)
ret ptr %t7675
L846:
%t7676 = getelementptr i8, ptr %t7670, i64 16
%t7677 = load i64, ptr %t7676, align 8
%t7678 = call ptr @cbe_read_head(ptr %p0, i64 %t7677)
%t7679 = getelementptr i8, ptr %t7678, i64 0
%t7680 = load i1, ptr %t7679, align 8
%t7681 = xor i1 %t7680, true
br label %LSL7682
LSL7682:
br i1 %t7681, label %LSJ7682, label %LSR7682
LSR7682:
%t7683 = getelementptr i8, ptr %t7678, i64 8
%t7684 = load i64, ptr %t7683, align 8
%t7685 = icmp ne i64 %t7684, 5
br label %LSJ7682
LSJ7682:
%t7686 = phi i1 [ true, %LSL7682 ], [ %t7685, %LSR7682 ]
br label %LSL7687
LSL7687:
br i1 %t7686, label %LSJ7687, label %LSR7687
LSR7687:
%t7688 = getelementptr i8, ptr %t7678, i64 16
%t7689 = load i64, ptr %t7688, align 8
%t7690 = icmp ne i64 %t7689, 0
br label %LSJ7687
LSJ7687:
%t7691 = phi i1 [ true, %LSL7687 ], [ %t7690, %LSR7687 ]
br i1 %t7691, label %L847, label %L849
L847:
%t7693 = musttail call ptr @cose_sign1_err(ptr @.s7692)
ret ptr %t7693
L849:
%t7694 = getelementptr i8, ptr %t7678, i64 24
%t7695 = load i64, ptr %t7694, align 8
%t7696 = call ptr @cbe_read_str(ptr %p0, i64 %t7695, i64 2)
%t7697 = getelementptr i8, ptr %t7696, i64 0
%t7698 = load i1, ptr %t7697, align 8
%t7699 = xor i1 %t7698, true
br i1 %t7699, label %L850, label %L852
L850:
%t7701 = musttail call ptr @cose_sign1_err(ptr @.s7700)
ret ptr %t7701
L852:
%t7702 = getelementptr i8, ptr %t7696, i64 16
%t7703 = load i64, ptr %t7702, align 8
%t7704 = call ptr @cbe_read_str(ptr %p0, i64 %t7703, i64 2)
%t7705 = getelementptr i8, ptr %t7704, i64 0
%t7706 = load i1, ptr %t7705, align 8
%t7707 = xor i1 %t7706, true
br label %LSL7708
LSL7708:
br i1 %t7707, label %LSJ7708, label %LSR7708
LSR7708:
%t7709 = getelementptr i8, ptr %t7704, i64 8
%t7710 = load ptr, ptr %t7709, align 8
%t7711 = call i64 @resid_list_len(ptr %t7710)
%t7712 = icmp ne i64 %t7711, 64
br label %LSJ7708
LSJ7708:
%t7713 = phi i1 [ true, %LSL7708 ], [ %t7712, %LSR7708 ]
br i1 %t7713, label %L853, label %L855
L853:
%t7715 = musttail call ptr @cose_sign1_err(ptr @.s7714)
ret ptr %t7715
L855:
%t7716 = call ptr @resid_gmalloc(i64 48)
%t7716.f0 = getelementptr i8, ptr %t7716, i64 0
store i1 true, ptr %t7716.f0, align 8
%t7716.f1 = getelementptr i8, ptr %t7716, i64 8
store ptr @.s7717, ptr %t7716.f1, align 8
%t7718 = getelementptr i8, ptr %t7670, i64 8
%t7719 = load ptr, ptr %t7718, align 8
%t7720 = call ptr @cose_kid_of(ptr %t7719)
%t7716.f2 = getelementptr i8, ptr %t7716, i64 16
store ptr %t7720, ptr %t7716.f2, align 8
%t7721 = getelementptr i8, ptr %t7670, i64 8
%t7722 = load ptr, ptr %t7721, align 8
%t7716.f3 = getelementptr i8, ptr %t7716, i64 24
store ptr %t7722, ptr %t7716.f3, align 8
%t7723 = getelementptr i8, ptr %t7696, i64 8
%t7724 = load ptr, ptr %t7723, align 8
%t7716.f4 = getelementptr i8, ptr %t7716, i64 32
store ptr %t7724, ptr %t7716.f4, align 8
%t7725 = getelementptr i8, ptr %t7704, i64 8
%t7726 = load ptr, ptr %t7725, align 8
%t7716.f5 = getelementptr i8, ptr %t7716, i64 40
store ptr %t7726, ptr %t7716.f5, align 8
ret ptr %t7716
}
define i1 @cose_sign1_check(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7727 = getelementptr i8, ptr %p0, i64 24
%t7728 = load ptr, ptr %t7727, align 8
%t7729 = getelementptr i8, ptr %p0, i64 32
%t7730 = load ptr, ptr %t7729, align 8
%t7731 = call ptr @cose_sig_structure(ptr %t7728, ptr %t7730)
%t7732 = call ptr @resid_list_freeze(ptr %t7731)
%t7733 = getelementptr i8, ptr %p0, i64 40
%t7734 = load ptr, ptr %t7733, align 8
%t7735 = call i1 @verify_sig_bytes(ptr %t7732, ptr %t7734, ptr %p1)
ret i1 %t7735
}
define ptr @cose_enc_structure(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7737 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty7736)
%t7739 = call ptr @resid_list_const_i64(ptr @.lc7738, i64 10, ptr @.lcd7738, ptr @.lty7738)
%t7740 = call ptr @cbe_bytes(ptr %p0, ptr %t7739)
%t7741 = call ptr @cbe_bytes(ptr %t7737, ptr %t7740)
ret ptr %t7741
}
define ptr @cose_encrypt0_protected() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7743 = call ptr @resid_list_const_i64(ptr @.lc7742, i64 4, ptr @.lcd7742, ptr @.lty7742)
ret ptr %t7743
}
define ptr @cose_encrypt0_nonce(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7745 = call ptr @resid_list_const_i64(ptr @.lc7744, i64 25, ptr @.lcd7744, ptr @.lty7744)
%t7746 = call ptr @resid_list_concat(ptr %t7745, ptr %p0)
%t7747 = call ptr @bytes_of(ptr %p1)
%t7748 = call ptr @resid_list_freeze(ptr %t7747)
%t7749 = call ptr @resid_list_concat_own(ptr %t7746, i8 1, ptr %t7748)
%t7750 = call ptr @resid_list_concat_own(ptr %t7749, i8 1, ptr %p2)
%t7751 = call ptr @sha256_bytes(ptr %t7750)
%t7752 = call ptr @slice_bytes(ptr %t7751, i64 0, i64 11)
ret ptr %t7752
}
define ptr @cose_encrypt0_seal(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7753 = call ptr @cose_encrypt0_nonce(ptr %p1, ptr %p2, ptr %p0)
%t7754 = call ptr @resid_list_freeze(ptr %t7753)
%t7756 = call ptr @resid_list_const_i64(ptr @.lc7755, i64 16, ptr @.lcd7755, ptr @.lty7755)
%t7757 = call ptr @chacha20poly1305_seal(ptr %p1, ptr %t7754, ptr %p0, ptr %t7756)
%t7758 = call ptr @resid_list_freeze(ptr %t7757)
%t7760 = call ptr @resid_list_const_i64(ptr @.lc7759, i64 9, ptr @.lcd7759, ptr @.lty7759)
%t7761 = call ptr @cbe_bytes(ptr %t7754, ptr %t7760)
%t7762 = call ptr @cbe_bytes(ptr %t7758, ptr %t7761)
ret ptr %t7762
}
define ptr @cose_open_err(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7763 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB7763)
%t7764 = call ptr @resid_gmalloc(i64 24)
%t7764.f0 = getelementptr i8, ptr %t7764, i64 0
store i1 false, ptr %t7764.f0, align 8
%t7764.f1 = getelementptr i8, ptr %t7764, i64 8
store ptr %p0, ptr %t7764.f1, align 8
%t7764.f2 = getelementptr i8, ptr %t7764, i64 16
store ptr %t7763, ptr %t7764.f2, align 8
ret ptr %t7764
}
define i1 @cose_is_encrypt0(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7765 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t7766 = getelementptr i8, ptr %t7765, i64 0
%t7767 = load i1, ptr %t7766, align 8
br label %LSL7768
LSL7768:
br i1 %t7767, label %LSR7768, label %LSJ7768
LSR7768:
%t7769 = getelementptr i8, ptr %t7765, i64 8
%t7770 = load i64, ptr %t7769, align 8
%t7771 = icmp eq i64 %t7770, 6
br label %LSJ7768
LSJ7768:
%t7772 = phi i1 [ false, %LSL7768 ], [ %t7771, %LSR7768 ]
br label %LSL7773
LSL7773:
br i1 %t7772, label %LSR7773, label %LSJ7773
LSR7773:
%t7774 = getelementptr i8, ptr %t7765, i64 16
%t7775 = load i64, ptr %t7774, align 8
%t7776 = icmp eq i64 %t7775, 16
br label %LSJ7773
LSJ7773:
%t7777 = phi i1 [ false, %LSL7773 ], [ %t7776, %LSR7773 ]
ret i1 %t7777
}
define ptr @cose_encrypt0_open(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7778 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t7779 = getelementptr i8, ptr %t7778, i64 0
%t7780 = load i1, ptr %t7779, align 8
%t7781 = xor i1 %t7780, true
br label %LSL7782
LSL7782:
br i1 %t7781, label %LSJ7782, label %LSR7782
LSR7782:
%t7783 = getelementptr i8, ptr %t7778, i64 8
%t7784 = load i64, ptr %t7783, align 8
%t7785 = icmp ne i64 %t7784, 6
br label %LSJ7782
LSJ7782:
%t7786 = phi i1 [ true, %LSL7782 ], [ %t7785, %LSR7782 ]
br label %LSL7787
LSL7787:
br i1 %t7786, label %LSJ7787, label %LSR7787
LSR7787:
%t7788 = getelementptr i8, ptr %t7778, i64 16
%t7789 = load i64, ptr %t7788, align 8
%t7790 = icmp ne i64 %t7789, 16
br label %LSJ7787
LSJ7787:
%t7791 = phi i1 [ true, %LSL7787 ], [ %t7790, %LSR7787 ]
br i1 %t7791, label %L856, label %L858
L856:
%t7793 = call ptr @cose_open_err(ptr @.s7792)
ret ptr %t7793
L858:
%t7794 = getelementptr i8, ptr %t7778, i64 24
%t7795 = load i64, ptr %t7794, align 8
%t7796 = call ptr @cbe_read_head(ptr %p0, i64 %t7795)
%t7797 = getelementptr i8, ptr %t7796, i64 0
%t7798 = load i1, ptr %t7797, align 8
%t7799 = xor i1 %t7798, true
br label %LSL7800
LSL7800:
br i1 %t7799, label %LSJ7800, label %LSR7800
LSR7800:
%t7801 = getelementptr i8, ptr %t7796, i64 8
%t7802 = load i64, ptr %t7801, align 8
%t7803 = icmp ne i64 %t7802, 4
br label %LSJ7800
LSJ7800:
%t7804 = phi i1 [ true, %LSL7800 ], [ %t7803, %LSR7800 ]
br label %LSL7805
LSL7805:
br i1 %t7804, label %LSJ7805, label %LSR7805
LSR7805:
%t7806 = getelementptr i8, ptr %t7796, i64 16
%t7807 = load i64, ptr %t7806, align 8
%t7808 = icmp ne i64 %t7807, 3
br label %LSJ7805
LSJ7805:
%t7809 = phi i1 [ true, %LSL7805 ], [ %t7808, %LSR7805 ]
br i1 %t7809, label %L859, label %L861
L859:
%t7811 = call ptr @cose_open_err(ptr @.s7810)
ret ptr %t7811
L861:
%t7812 = getelementptr i8, ptr %t7796, i64 24
%t7813 = load i64, ptr %t7812, align 8
%t7814 = call ptr @cbe_read_str(ptr %p0, i64 %t7813, i64 2)
call void @"resid.rec.freeze.CbeStr"(ptr %t7814)
%t7815 = getelementptr i8, ptr %t7814, i64 0
%t7816 = load i1, ptr %t7815, align 8
%t7817 = xor i1 %t7816, true
br i1 %t7817, label %L862, label %L864
L862:
%t7819 = call ptr @cose_open_err(ptr @.s7818)
ret ptr %t7819
L864:
%t7820 = getelementptr i8, ptr %t7814, i64 16
%t7821 = load i64, ptr %t7820, align 8
%t7822 = call ptr @cbe_read_head(ptr %p0, i64 %t7821)
%t7823 = getelementptr i8, ptr %t7822, i64 0
%t7824 = load i1, ptr %t7823, align 8
%t7825 = xor i1 %t7824, true
br label %LSL7826
LSL7826:
br i1 %t7825, label %LSJ7826, label %LSR7826
LSR7826:
%t7827 = getelementptr i8, ptr %t7822, i64 8
%t7828 = load i64, ptr %t7827, align 8
%t7829 = icmp ne i64 %t7828, 5
br label %LSJ7826
LSJ7826:
%t7830 = phi i1 [ true, %LSL7826 ], [ %t7829, %LSR7826 ]
br label %LSL7831
LSL7831:
br i1 %t7830, label %LSJ7831, label %LSR7831
LSR7831:
%t7832 = getelementptr i8, ptr %t7822, i64 16
%t7833 = load i64, ptr %t7832, align 8
%t7834 = icmp ne i64 %t7833, 1
br label %LSJ7831
LSJ7831:
%t7835 = phi i1 [ true, %LSL7831 ], [ %t7834, %LSR7831 ]
br i1 %t7835, label %L865, label %L867
L865:
%t7837 = call ptr @cose_open_err(ptr @.s7836)
ret ptr %t7837
L867:
%t7838 = getelementptr i8, ptr %t7822, i64 24
%t7839 = load i64, ptr %t7838, align 8
%t7840 = call ptr @cbe_read_head(ptr %p0, i64 %t7839)
%t7841 = getelementptr i8, ptr %t7840, i64 0
%t7842 = load i1, ptr %t7841, align 8
%t7843 = xor i1 %t7842, true
br label %LSL7844
LSL7844:
br i1 %t7843, label %LSJ7844, label %LSR7844
LSR7844:
%t7845 = getelementptr i8, ptr %t7840, i64 8
%t7846 = load i64, ptr %t7845, align 8
%t7847 = icmp ne i64 %t7846, 0
br label %LSJ7844
LSJ7844:
%t7848 = phi i1 [ true, %LSL7844 ], [ %t7847, %LSR7844 ]
br label %LSL7849
LSL7849:
br i1 %t7848, label %LSJ7849, label %LSR7849
LSR7849:
%t7850 = getelementptr i8, ptr %t7840, i64 16
%t7851 = load i64, ptr %t7850, align 8
%t7852 = icmp ne i64 %t7851, 5
br label %LSJ7849
LSJ7849:
%t7853 = phi i1 [ true, %LSL7849 ], [ %t7852, %LSR7849 ]
br i1 %t7853, label %L868, label %L870
L868:
%t7855 = call ptr @cose_open_err(ptr @.s7854)
ret ptr %t7855
L870:
%t7856 = getelementptr i8, ptr %t7840, i64 24
%t7857 = load i64, ptr %t7856, align 8
%t7858 = call ptr @cbe_read_str(ptr %p0, i64 %t7857, i64 2)
%t7859 = getelementptr i8, ptr %t7858, i64 0
%t7860 = load i1, ptr %t7859, align 8
%t7861 = xor i1 %t7860, true
br label %LSL7862
LSL7862:
br i1 %t7861, label %LSJ7862, label %LSR7862
LSR7862:
%t7863 = getelementptr i8, ptr %t7858, i64 8
%t7864 = load ptr, ptr %t7863, align 8
%t7865 = call i64 @resid_list_len(ptr %t7864)
%t7866 = icmp ne i64 %t7865, 12
br label %LSJ7862
LSJ7862:
%t7867 = phi i1 [ true, %LSL7862 ], [ %t7866, %LSR7862 ]
br i1 %t7867, label %L871, label %L873
L871:
%t7869 = call ptr @cose_open_err(ptr @.s7868)
ret ptr %t7869
L873:
%t7870 = getelementptr i8, ptr %t7858, i64 16
%t7871 = load i64, ptr %t7870, align 8
%t7872 = call ptr @cbe_read_str(ptr %p0, i64 %t7871, i64 2)
%t7873 = getelementptr i8, ptr %t7872, i64 0
%t7874 = load i1, ptr %t7873, align 8
%t7875 = xor i1 %t7874, true
br label %LSL7876
LSL7876:
br i1 %t7875, label %LSJ7876, label %LSR7876
LSR7876:
%t7877 = getelementptr i8, ptr %t7872, i64 8
%t7878 = load ptr, ptr %t7877, align 8
%t7879 = call i64 @resid_list_len(ptr %t7878)
%t7880 = icmp slt i64 %t7879, 16
br label %LSJ7876
LSJ7876:
%t7881 = phi i1 [ true, %LSL7876 ], [ %t7880, %LSR7876 ]
br i1 %t7881, label %L874, label %L876
L874:
%t7883 = call ptr @cose_open_err(ptr @.s7882)
ret ptr %t7883
L876:
%t7884 = call i64 @resid_scope_push()
%t7885 = getelementptr i8, ptr %t7858, i64 8
%t7886 = load ptr, ptr %t7885, align 8
%t7887 = getelementptr i8, ptr %t7872, i64 8
%t7888 = load ptr, ptr %t7887, align 8
%t7889 = getelementptr i8, ptr %t7814, i64 8
%t7890 = load ptr, ptr %t7889, align 8
%t7891 = call ptr @cose_enc_structure(ptr %t7890)
%t7892 = call ptr @resid_list_freeze(ptr %t7891)
%t7893 = call i1 @chacha20poly1305_open(ptr %p1, ptr %t7886, ptr %t7888, ptr %t7892)
call void @resid_scope_pop(i64 %t7884)
%t7894 = xor i1 %t7893, true
br i1 %t7894, label %L877, label %L879
L877:
%t7896 = call ptr @cose_open_err(ptr @.s7895)
ret ptr %t7896
L879:
%t7897 = getelementptr i8, ptr %t7872, i64 8
%t7898 = load ptr, ptr %t7897, align 8
%t7899 = getelementptr i8, ptr %t7872, i64 8
%t7900 = load ptr, ptr %t7899, align 8
%t7901 = call i64 @resid_list_len(ptr %t7900)
%t7902 = sub nsw i64 %t7901, 17
%t7903 = call ptr @slice_bytes(ptr %t7898, i64 0, i64 %t7902)
%t7904 = call ptr @resid_gmalloc(i64 24)
%t7904.f0 = getelementptr i8, ptr %t7904, i64 0
store i1 true, ptr %t7904.f0, align 8
%t7904.f1 = getelementptr i8, ptr %t7904, i64 8
store ptr @.s7905, ptr %t7904.f1, align 8
%t7906 = getelementptr i8, ptr %t7858, i64 8
%t7907 = load ptr, ptr %t7906, align 8
%t7908 = call ptr @chacha20_xor(ptr %p1, i64 1, ptr %t7907, ptr %t7903)
%t7904.f2 = getelementptr i8, ptr %t7904, i64 16
store ptr %t7908, ptr %t7904.f2, align 8
ret ptr %t7904
}
define ptr @op(ptr %p0, ptr %p1, ptr %p2, ptr %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7909 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p4, i64 1)
%t7910 = extractvalue {i64, i1} %t7909, 0
%t7911 = extractvalue {i64, i1} %t7909, 1
%t7912 = zext i1 %t7911 to i8
call void @resid_overflow_check(i8 %t7912)
%t7913 = add i64 %t7910, 0
%t7914 = add i64 %t7913, 0
%t7915 = add i64 %t7914, 0
%t7916 = icmp ne i64 %t7915, %t7913
%t7917 = icmp slt i64 %t7910, 0
%t7918 = or i1 %t7916, %t7917
%t7919 = zext i1 %t7918 to i8
call void @resid_conv_check(i8 %t7919)
%t7920 = alloca [1 x ptr]
%t7922 = call ptr @resid_box_i64(i64 %t7914)
%t7924 = getelementptr i8, ptr %t7920, i64 0
store ptr %t7922, ptr %t7924
%t7925 = call ptr @resid_list_new(i64 1, ptr %t7920, ptr @.lty7920)
%t7926 = call ptr @bn_add(ptr %p1, ptr %t7925)
%t7927 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 7, i64 %p4)
%t7928 = extractvalue {i64, i1} %t7927, 0
%t7929 = extractvalue {i64, i1} %t7927, 1
%t7930 = zext i1 %t7929 to i8
call void @resid_overflow_check(i8 %t7930)
%t7931 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7928, i64 3)
%t7932 = extractvalue {i64, i1} %t7931, 0
%t7933 = extractvalue {i64, i1} %t7931, 1
%t7934 = zext i1 %t7933 to i8
call void @resid_overflow_check(i8 %t7934)
%t7935 = add i64 %t7932, 0
%t7936 = add i64 %t7935, 0
%t7937 = add i64 %t7936, 0
%t7938 = icmp ne i64 %t7937, %t7935
%t7939 = icmp slt i64 %t7932, 0
%t7940 = or i1 %t7938, %t7939
%t7941 = zext i1 %t7940 to i8
call void @resid_conv_check(i8 %t7941)
%t7942 = alloca [1 x ptr]
%t7944 = call ptr @resid_box_i64(i64 %t7936)
%t7946 = getelementptr i8, ptr %t7942, i64 0
store ptr %t7944, ptr %t7946
%t7947 = call ptr @resid_list_new(i64 1, ptr %t7942, ptr @.lty7942)
%t7948 = call ptr @bn_add(ptr %p2, ptr %t7947)
%t7949 = call ptr @bn_mul(ptr %t7926, ptr %t7948)
%t7950 = call ptr @bn_mod(ptr %t7949, ptr %p3)
%t7952 = call i8 @resid_str_eq(ptr %p0, ptr @.s7951)
%t7953 = icmp ne i8 %t7952, 0
br i1 %t7953, label %L880, label %L882
L880:
%t7954 = call ptr @bn_mul(ptr %t7950, ptr %p2)
ret ptr %t7954
L882:
%t7956 = call i8 @resid_str_eq(ptr %p0, ptr @.s7955)
%t7957 = icmp ne i8 %t7956, 0
br i1 %t7957, label %L883, label %L885
L883:
%t7958 = call ptr @bn_mul(ptr %t7950, ptr %p2)
%t7959 = call ptr @bn_mod(ptr %t7958, ptr %p3)
ret ptr %t7959
L885:
%t7961 = call i8 @resid_str_eq(ptr %p0, ptr @.s7960)
%t7962 = icmp ne i8 %t7961, 0
br i1 %t7962, label %L886, label %L888
L886:
%t7963 = call ptr @bn_modmul(ptr %t7950, ptr %p2, ptr %p3)
ret ptr %t7963
L888:
%t7965 = call i8 @resid_str_eq(ptr %p0, ptr @.s7964)
%t7966 = icmp ne i8 %t7965, 0
br i1 %t7966, label %L889, label %L891
L889:
%t7967 = call ptr @bn_modinv(ptr %t7950, ptr %p3)
%t7968 = getelementptr {i32, i32, ptr}, ptr %t7967, i32 0, i32 0
%t7969w = load i32, ptr %t7968
%t7969 = sext i32 %t7969w to i64
%t7970 = icmp eq i64 %t7969, 1
br i1 %t7970, label %L892, label %L893
L892:
%t7971 = getelementptr {i32, i32, ptr}, ptr %t7967, i32 1
%t7972 = getelementptr i8, ptr %t7971, i64 0
%t7973 = getelementptr ptr, ptr %t7972, i32 0
%t7974 = load ptr, ptr %t7973
br label %L894
L893:
%t7976 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty7975)
br label %L894
L894:
%t7977 = phi ptr [ %t7974, %L892 ], [ %t7976, %L893 ]
ret ptr %t7977
L891:
%t7979 = call i8 @resid_str_eq(ptr %p0, ptr @.s7978)
%t7980 = icmp ne i8 %t7979, 0
br i1 %t7980, label %L895, label %L897
L895:
%t7981 = call ptr @bn_gcd(ptr %t7950, ptr %p3)
ret ptr %t7981
L897:
%t7983 = call i8 @resid_str_eq(ptr %p0, ptr @.s7982)
%t7984 = icmp ne i8 %t7983, 0
br i1 %t7984, label %L898, label %L900
L898:
%t7985 = call ptr @bn_mul(ptr %t7950, ptr %p2)
%t7986 = call ptr @bn_shr(ptr %t7985, i64 100)
ret ptr %t7986
L900:
ret ptr %t7950
}
define ptr @loop(ptr %p0.in, ptr %p1.in, ptr %p2.in, ptr %p3.in, i64 %p4.in, i64 %p5.in, ptr %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t7989, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p5, %tco.s0 ]
%p6 = phi ptr [ %p6.in, %entry ], [ %t7995, %tco.s0 ]
%t7987 = icmp sge i64 %p4, %p5
br i1 %t7987, label %L901, label %L903
L901:
%t7988 = call ptr @resid_listbuf_finish(ptr %p6, ptr @.lty7988)
ret ptr %t7988
L903:
%t7989 = add nsw i64 %p4, 1
%t7990 = call ptr @op(ptr %p0, ptr %p1, ptr %p2, ptr %p3, i64 %p4)
%t7991 = call ptr @resid_list_freeze(ptr %t7990)
%t7995 = call ptr @resid_listbuf_push(ptr %p6, ptr %t7991)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @run(ptr %p0, ptr %p1, ptr %p2, ptr %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7997 = call ptr @resid_listbuf_new()
%t7998 = call ptr @loop(ptr %p0, ptr %p1, ptr %p2, ptr %p3, i64 0, i64 %p4, ptr %t7997)
%t7999 = call ptr @resid_list_freeze(ptr %t7998)
%t8000 = call i64 @resid_list_len(ptr %t7999)
ret i64 %t8000
}
define i32 @resid_user_main() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
call void @resid_cap_check(ptr @resid.cap.main)
%t8001 = call ptr @resid_args_get(i64 1)
%t8002 = call ptr @cose_hex_decode(ptr %t8001)
%t8003 = call ptr @resid_list_freeze(ptr %t8002)
%t8004 = call ptr @bn_from_be(ptr %t8003)
%t8005 = call ptr @resid_list_freeze(ptr %t8004)
%t8007 = call ptr @resid_list_const_i64(ptr @.lc8006, i64 1, ptr @.lcd8006, ptr @.lty8006)
%t8008 = call ptr @bn_sub(ptr %t8005, ptr %t8007)
%t8010 = call ptr @resid_list_const_i64(ptr @.lc8009, i64 1, ptr @.lcd8009, ptr @.lty8009)
%t8011 = call ptr @bn_sub(ptr %t8005, ptr %t8010)
call void @resid_cap_check(ptr @resid.cap.main.1)
%t8012 = call ptr @resid_args_get(i64 2)
call void @resid_cap_check(ptr @resid.cap.main.2)
%t8013 = call ptr @resid_args_get(i64 3)
%t8014 = call i64 @str_parse_int(ptr %t8013)
%t8015 = call i64 @run(ptr %t8012, ptr %t8008, ptr %t8011, ptr %t8005, i64 %t8014)
%t8016 = srem i64 %t8015, 200
%t8017 = trunc i64 %t8016 to i32
ret i32 %t8017
}
define ptr @sha256g_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8018 = call ptr @resid_list_get(ptr %p2, i64 0)
%t8019 = call i64 @resid_unbox_i64(ptr %t8018)
%t8021 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8019, i64 4294967295)
%t8022 = call ptr @resid_list_get(ptr %p2, i64 1)
%t8023 = call i64 @resid_unbox_i64(ptr %t8022)
%t8025 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8023, i64 4294967295)
%t8026 = call ptr @resid_list_get(ptr %p2, i64 2)
%t8027 = call i64 @resid_unbox_i64(ptr %t8026)
%t8029 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8027, i64 4294967295)
%t8030 = call ptr @resid_list_get(ptr %p2, i64 3)
%t8031 = call i64 @resid_unbox_i64(ptr %t8030)
%t8033 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8031, i64 4294967295)
%t8034 = call ptr @resid_list_get(ptr %p2, i64 4)
%t8035 = call i64 @resid_unbox_i64(ptr %t8034)
%t8037 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8035, i64 4294967295)
%t8038 = call ptr @resid_list_get(ptr %p2, i64 5)
%t8039 = call i64 @resid_unbox_i64(ptr %t8038)
%t8041 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8039, i64 4294967295)
%t8042 = call ptr @resid_list_get(ptr %p2, i64 6)
%t8043 = call i64 @resid_unbox_i64(ptr %t8042)
%t8045 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8043, i64 4294967295)
%t8046 = call ptr @resid_list_get(ptr %p2, i64 7)
%t8047 = call i64 @resid_unbox_i64(ptr %t8046)
%t8049 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8047, i64 4294967295)
%t8050 = call ptr @__m____________lib_sha256g_resid__g_blk__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 0, ptr %p2, i64 %t8021, i64 %t8025, i64 %t8029, i64 %t8033, i64 %t8037, i64 %t8041, i64 %t8045, i64 %t8049, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret ptr %t8050
}
define ptr @base64g_decode__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8051 = call i64 @resid_list_len(ptr %p0)
%t8052 = srem i64 %t8051, 4
%t8053 = icmp sgt i64 %t8051, 0
br label %LSL8054
LSL8054:
br i1 %t8053, label %LSR8054, label %LSJ8054
LSR8054:
%t8055 = icmp eq i64 %t8052, 0
br label %LSL8056
LSL8056:
br i1 %t8055, label %LSR8056, label %LSJ8056
LSR8056:
%t8057 = icmp eq i64 %p1, 0
br label %LSJ8056
LSJ8056:
%t8058 = phi i1 [ false, %LSL8056 ], [ %t8057, %LSR8056 ]
br label %LSL8059
LSL8059:
br i1 %t8058, label %LSJ8059, label %LSR8059
LSR8059:
%t8060 = icmp eq i64 %t8052, 2
br label %LSL8061
LSL8061:
br i1 %t8060, label %LSR8061, label %LSJ8061
LSR8061:
%t8062 = icmp eq i64 %p1, 2
br label %LSJ8061
LSJ8061:
%t8063 = phi i1 [ false, %LSL8061 ], [ %t8062, %LSR8061 ]
br label %LSJ8059
LSJ8059:
%t8064 = phi i1 [ true, %LSL8059 ], [ %t8063, %LSJ8061 ]
br label %LSL8065
LSL8065:
br i1 %t8064, label %LSJ8065, label %LSR8065
LSR8065:
%t8066 = icmp eq i64 %t8052, 3
br label %LSL8067
LSL8067:
br i1 %t8066, label %LSR8067, label %LSJ8067
LSR8067:
%t8068 = icmp eq i64 %p1, 1
br label %LSJ8067
LSJ8067:
%t8069 = phi i1 [ false, %LSL8067 ], [ %t8068, %LSR8067 ]
br label %LSJ8065
LSJ8065:
%t8070 = phi i1 [ true, %LSL8065 ], [ %t8069, %LSJ8067 ]
br label %LSJ8054
LSJ8054:
%t8071 = phi i1 [ false, %LSL8054 ], [ %t8070, %LSJ8065 ]
%t8072 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB8072)
%t8073 = xor i1 %t8071, true
br i1 %t8073, label %L904, label %L906
L904:
ret ptr %t8072
L906:
%t8074 = call ptr @resid_listbuf_new()
%t8075 = call ptr @__m____________lib_crypto_resid__b64g_groups__g_Int_64__Int_64_(ptr %p0, i64 0, i64 0, ptr %t8074)
ret ptr %t8075
}
define i512 @eg_fadd__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8076 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %p1)
%t8077 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8078 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8076, i512 %t8077)
ret i512 %t8078
}
define i512 @eg_fsub__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8079 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8080 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %t8079)
%t8081 = call i512 @__m____________lib_word_resid__pi_sub(i512 %t8080, i512 %p1)
%t8082 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8083 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8081, i512 %t8082)
ret i512 %t8083
}
define i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8084 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %p0, i512 %p1)
%t8085 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8084, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t8086 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t8084, i64 256)
%t8087 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %t8086, i512 38)
%t8088 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8085, i512 %t8087)
%t8089 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8088, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t8090 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t8088, i64 256)
%t8091 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %t8090, i512 38)
%t8092 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8089, i512 %t8091)
%t8093 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8092, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t8094 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t8092, i64 256)
%t8095 = call i512 @__m____________lib_word_resid__pi_mul256(i512 %t8094, i512 38)
%t8096 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8093, i512 %t8095)
%t8097 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8098 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8096, i512 %t8097)
%t8099 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t8100 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8098, i512 %t8099)
ret i512 %t8100
}
define i512 @eg_finv__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8101 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819947 to i512
%t8102 = call i512 @eg_fpow__g_Int_512__Int_64_(i512 1, i512 %p0, i512 %t8101, i64 254)
ret i512 %t8102
}
define i512 @eg_fpow__g_Int_512__Int_64_(i512 %p0.in, i512 %p1.in, i512 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t8112, %tco.s0 ], [ %t8104, %tco.s1 ]
%p1 = phi i512 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i512 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t8113, %tco.s0 ], [ %t8115, %tco.s1 ]
%t8103 = icmp slt i64 %p3, 0
br i1 %t8103, label %L907, label %L909
L907:
ret i512 %p0
L909:
%t8104 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p0)
%t8105 = sext i64 %p3 to i512
%t8106 = icmp uge i512 %t8105, 512
%t8107 = add i512 %t8105, 0
%t8108 = select i1 %t8106, i512 511, i512 %t8107
%t8109 = ashr i512 %p2, %t8108
%t8110 = and i512 %t8109, 1
%t8111 = icmp eq i512 %t8110, 1
br i1 %t8111, label %L910, label %L912
L910:
%t8112 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8104, i512 %p1)
%t8113 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
L912:
%t8115 = sub nsw i64 %p3, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define ptr @eg_dbl__g_Int_512__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8117 = getelementptr i8, ptr %p0, i64 0
%t8118 = load i512, ptr %t8117, align 8
%t8119 = getelementptr i8, ptr %p0, i64 0
%t8120 = load i512, ptr %t8119, align 8
%t8121 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8118, i512 %t8120)
%t8122 = getelementptr i8, ptr %p0, i64 64
%t8123 = load i512, ptr %t8122, align 8
%t8124 = getelementptr i8, ptr %p0, i64 64
%t8125 = load i512, ptr %t8124, align 8
%t8126 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8123, i512 %t8125)
%t8127 = getelementptr i8, ptr %p0, i64 128
%t8128 = load i512, ptr %t8127, align 8
%t8129 = getelementptr i8, ptr %p0, i64 128
%t8130 = load i512, ptr %t8129, align 8
%t8131 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8128, i512 %t8130)
%t8132 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8131, i512 %t8131)
%t8133 = getelementptr i8, ptr %p0, i64 0
%t8134 = load i512, ptr %t8133, align 8
%t8135 = getelementptr i8, ptr %p0, i64 64
%t8136 = load i512, ptr %t8135, align 8
%t8137 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8134, i512 %t8136)
%t8138 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8137, i512 %t8137)
%t8139 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8138, i512 %t8121)
%t8140 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8139, i512 %t8126)
%t8141 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8126, i512 %t8121)
%t8142 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8141, i512 %t8132)
%t8143 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 0, i512 %t8121)
%t8144 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8143, i512 %t8126)
%t8145 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8140, i512 %t8142)
%t8146 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8141, i512 %t8144)
%t8147 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8142, i512 %t8141)
%t8148 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8140, i512 %t8144)
%t8149 = call ptr @resid_rec_reuse_sc(ptr %p0, i64 256)
%t8149.f0 = getelementptr i8, ptr %t8149, i64 0
store i512 %t8145, ptr %t8149.f0, align 8
%t8149.f8 = getelementptr i8, ptr %t8149, i64 64
store i512 %t8146, ptr %t8149.f8, align 8
%t8149.f16 = getelementptr i8, ptr %t8149, i64 128
store i512 %t8147, ptr %t8149.f16, align 8
%t8149.f24 = getelementptr i8, ptr %t8149, i64 192
store i512 %t8148, ptr %t8149.f24, align 8
ret ptr %t8149
}
define ptr @eg_add__g_Int_512__Int_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8150 = getelementptr i8, ptr %p0, i64 64
%t8151 = load i512, ptr %t8150, align 8
%t8152 = getelementptr i8, ptr %p0, i64 0
%t8153 = load i512, ptr %t8152, align 8
%t8154 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8151, i512 %t8153)
%t8155 = getelementptr i8, ptr %p1, i64 64
%t8156 = load i512, ptr %t8155, align 8
%t8157 = getelementptr i8, ptr %p1, i64 0
%t8158 = load i512, ptr %t8157, align 8
%t8159 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8156, i512 %t8158)
%t8160 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8154, i512 %t8159)
%t8161 = getelementptr i8, ptr %p0, i64 64
%t8162 = load i512, ptr %t8161, align 8
%t8163 = getelementptr i8, ptr %p0, i64 0
%t8164 = load i512, ptr %t8163, align 8
%t8165 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8162, i512 %t8164)
%t8166 = getelementptr i8, ptr %p1, i64 64
%t8167 = load i512, ptr %t8166, align 8
%t8168 = getelementptr i8, ptr %p1, i64 0
%t8169 = load i512, ptr %t8168, align 8
%t8170 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8167, i512 %t8169)
%t8171 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8165, i512 %t8170)
%t8172 = getelementptr i8, ptr %p0, i64 192
%t8173 = load i512, ptr %t8172, align 8
%t8174 = getelementptr i8, ptr %p0, i64 192
%t8175 = load i512, ptr %t8174, align 8
%t8176 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8173, i512 %t8175)
%t8177 = sext i256 37095705934669439343138083508754565189542113879843219016388785533085940283555 to i512
%t8178 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8176, i512 %t8177)
%t8179 = getelementptr i8, ptr %p1, i64 192
%t8180 = load i512, ptr %t8179, align 8
%t8181 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8178, i512 %t8180)
%t8182 = getelementptr i8, ptr %p0, i64 128
%t8183 = load i512, ptr %t8182, align 8
%t8184 = getelementptr i8, ptr %p0, i64 128
%t8185 = load i512, ptr %t8184, align 8
%t8186 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8183, i512 %t8185)
%t8187 = getelementptr i8, ptr %p1, i64 128
%t8188 = load i512, ptr %t8187, align 8
%t8189 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8186, i512 %t8188)
%t8190 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8171, i512 %t8160)
%t8191 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t8189, i512 %t8181)
%t8192 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8189, i512 %t8181)
%t8193 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t8171, i512 %t8160)
%t8194 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8190, i512 %t8191)
%t8195 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8192, i512 %t8193)
%t8196 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8191, i512 %t8192)
%t8197 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8190, i512 %t8193)
%t8198 = call ptr @resid_rec_reuse_sc(ptr %p0, i64 256)
%t8198.f0 = getelementptr i8, ptr %t8198, i64 0
store i512 %t8194, ptr %t8198.f0, align 8
%t8198.f8 = getelementptr i8, ptr %t8198, i64 64
store i512 %t8195, ptr %t8198.f8, align 8
%t8198.f16 = getelementptr i8, ptr %t8198, i64 128
store i512 %t8196, ptr %t8198.f16, align 8
%t8198.f24 = getelementptr i8, ptr %t8198, i64 192
store i512 %t8197, ptr %t8198.f24, align 8
ret ptr %t8198
}
define ptr @eg_ladder__g_Int_512__Int_64_(i512 %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t8206, %tco.s0.k ]
%t8199 = icmp slt i64 %p3, 0
br i1 %t8199, label %L913, label %L915
L913:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p2
lr.x11.m:
%lr.ret11 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %p2, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L915:
%t8200 = call ptr @eg_dbl__g_Int_512__Int_64_(ptr %p2)
call void @resid_rec_share(ptr %t8200)
%t8201 = sub nsw i64 511, %p3
%t8202 = call i512 @__m____________lib_word_resid__pi_shl(i512 %p0, i64 %t8201)
%t8203 = call i512 @__m____________lib_word_resid__pi_sign(i512 %t8202)
%t8204 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t8200, ptr %p1)
call void @resid_rec_share(ptr %t8204)
%t8205 = call ptr @__m____________lib_ed25519g_resid__eg_sel__g_Int_512__Int_64_(i512 %t8203, ptr %t8204, ptr %t8200)
call void @resid_rec_share(ptr %t8205)
%t8206 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p1.e.tco.s0 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %p1, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %t8205, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t8205, %tco.s0 ]
br label %tco.head
}
define ptr @eg_base_mul__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8208 = call ptr @eg_base__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t8208)
%t8209 = call ptr @eg_id__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t8209)
%t8210 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %p0, ptr %t8208, ptr %t8209, i64 255)
ret ptr %t8210
}
define ptr @eg_encode__g_Int_512__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8211 = getelementptr i8, ptr %p0, i64 128
%t8212 = load i512, ptr %t8211, align 8
%t8213 = call i512 @eg_finv__g_Int_512__Int_64_(i512 %t8212)
%t8214 = getelementptr i8, ptr %p0, i64 0
%t8215 = load i512, ptr %t8214, align 8
%t8216 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8215, i512 %t8213)
%t8217 = getelementptr i8, ptr %p0, i64 64
%t8218 = load i512, ptr %t8217, align 8
%t8219 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t8218, i512 %t8213)
%t8220 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8216, i512 1)
%t8221 = call i512 @__m____________lib_word_resid__pi_shl(i512 %t8220, i64 255)
%t8222 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8219, i512 %t8221)
%t8223 = call ptr @resid_listbuf_new()
%t8224 = call ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %t8222, i64 32, i64 0, ptr %t8223)
ret ptr %t8224
}
define i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8225 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 32, i64 32, i64 0, i512 0)
%t8226 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 32, i64 0, i512 0)
%t8227 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 0, i512 %t8225, i64 255)
%t8228 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 %t8227, i512 %t8226, i64 255)
ret i512 %t8228
}
define ptr @eg_pt__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8229 = call ptr @resid_rec_new(i64 256, i8 1)
%t8229.f0 = getelementptr i8, ptr %t8229, i64 0
store i512 %p0, ptr %t8229.f0, align 8
%t8229.f8 = getelementptr i8, ptr %t8229, i64 64
store i512 %p1, ptr %t8229.f8, align 8
%t8229.f16 = getelementptr i8, ptr %t8229, i64 128
store i512 1, ptr %t8229.f16, align 8
%t8230 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p1)
%t8229.f24 = getelementptr i8, ptr %t8229, i64 192
store i512 %t8230, ptr %t8229.f24, align 8
ret ptr %t8229
}
define ptr @eg_id__g_Int_512__Int_64_() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8231 = call ptr @resid_rec_new(i64 256, i8 1)
%t8231.f0 = getelementptr i8, ptr %t8231, i64 0
store i512 0, ptr %t8231.f0, align 8
%t8231.f8 = getelementptr i8, ptr %t8231, i64 64
store i512 1, ptr %t8231.f8, align 8
%t8231.f16 = getelementptr i8, ptr %t8231, i64 128
store i512 1, ptr %t8231.f16, align 8
%t8231.f24 = getelementptr i8, ptr %t8231, i64 192
store i512 0, ptr %t8231.f24, align 8
ret ptr %t8231
}
define i512 @eg_clamp__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8232 = sext i256 28948022309329048855892746252171976963317496166410141009864396001978282409976 to i512
%t8233 = call i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %t8232)
%t8234 = sext i256 28948022309329048855892746252171976963317496166410141009864396001978282409984 to i512
%t8235 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8233, i512 %t8234)
ret i512 %t8235
}
define ptr @ed25519g_pub__g_Int_64__Int_512__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8236 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %p0)
%t8237 = call i512 @__m____________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %t8236)
%t8238 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t8237)
%t8239 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t8238)
%t8240 = musttail call ptr @__m____________lib_word_resid__wi_publish(ptr %t8239)
ret ptr %t8240
}
define ptr @ed25519g_sign__g_Int_64__Int_512__UInt_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8241 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %p0)
%t8242 = call i512 @__m____________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %t8241)
%t8243 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t8242)
call void @resid_rec_share(ptr %t8243)
%t8244 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t8243)
%t8245 = call ptr @resid_list_freeze(ptr %t8244)
%t8246 = call ptr @__m____________lib_word_resid__wi_publish(ptr %t8245)
%t8247 = call ptr @resid_list_freeze(ptr %t8246)
%t8248 = call ptr @d_lift_bytes__g_Int_64__UInt_64_(ptr %p1)
%t8249 = call ptr @resid_list_freeze(ptr %t8248)
%t8250 = call i64 @resid_scope_push()
%t8251 = call ptr @resid_list_slice(ptr %t8241, i64 32, i64 64)
%t8253 = call ptr @resid_list_concat(ptr %t8251, ptr %t8249)
%t8254 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %t8253)
%t8255 = call ptr @resid_list_freeze(ptr %t8254)
%t8256 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t8255)
call void @resid_scope_pop(i64 %t8250)
%t8257 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t8256)
call void @resid_rec_share(ptr %t8257)
%t8258 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t8257)
%t8259 = call ptr @resid_list_freeze(ptr %t8258)
%t8260 = call ptr @__m____________lib_word_resid__wi_publish(ptr %t8259)
%t8261 = call ptr @resid_list_freeze(ptr %t8260)
%t8262 = call ptr @resid_listbuf_new()
%t8263 = call i64 @resid_scope_push()
%t8264 = call ptr @resid_list_concat(ptr %t8261, ptr %t8247)
%t8265 = call ptr @resid_list_concat(ptr %t8264, ptr %p1)
%t8266 = call ptr @sha512_bytes(ptr %t8265)
%t8267 = call ptr @resid_list_freeze(ptr %t8266)
%t8268 = call ptr @__m____________lib_ed25519g_resid__eg_lift_bytes__g_Int_64__Int_512_(ptr %t8267, i64 0, ptr %t8262)
%t8269 = call ptr @resid_list_freeze(ptr %t8268)
%t8270 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t8269)
call void @resid_scope_pop(i64 %t8263)
%t8271 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t8270, i512 %t8242)
%t8272 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8271, i512 %t8256)
%t8273 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 0, i512 %t8272, i64 508)
%t8274 = call ptr @resid_listbuf_new()
%t8275 = call ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %t8273, i64 32, i64 0, ptr %t8274)
%t8276 = call ptr @resid_list_freeze(ptr %t8275)
%t8277 = call ptr @__m____________lib_word_resid__wi_publish(ptr %t8276)
%t8278 = call ptr @resid_list_freeze(ptr %t8277)
%t8279 = musttail call ptr @resid_list_concat(ptr %t8261, ptr %t8278)
ret ptr %t8279
}
define ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8280 = call ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
%t8281 = call ptr @__m____________lib_chachag_resid__cg_block_st__g_Int_64__Int_64_(ptr %t8280)
ret ptr %t8281
}
define ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8282 = call ptr @resid_listbuf_new()
%t8283 = call ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
%t8284 = call ptr @resid_list_freeze(ptr %t8283)
%t8285 = and i64 %p1, 4294967295
%t8286 = call ptr @__m____________lib_chachag_resid__cg_xor_run__g_Int_64__Int_64_(ptr %t8284, i64 %t8285, ptr %p3, i64 0, ptr %t8282)
%t8287 = call ptr @resid_listbuf_finish(ptr %t8286, ptr @.lty8287)
ret ptr %t8287
}
define ptr @poly1305g__g_Int_64__Int_512_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8288 = call i512 @__m____________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 16, i64 0, i512 0)
%t8289 = sext i128 21267647620597763993911028882763415551 to i512
%t8290 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8288, i512 %t8289)
%t8291 = call i512 @__m____________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p0, i64 16, i64 16, i64 0, i512 0)
%t8292 = call i512 @__m____________lib_chachag_resid__pg_blocks__g_Int_512__Int_64_(i512 0, ptr %p1, i64 0, i512 %t8290)
%t8293 = call ptr @resid_listbuf_new()
%t8294 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8292, i512 %t8291)
%t8295 = sext i256 340282366920938463463374607431768211455 to i512
%t8296 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8294, i512 %t8295)
%t8297 = call ptr @__m____________lib_chachag_resid__pg_bytes__g_Int_512__Int_64_(i512 %t8296, i64 0, ptr %t8293)
ret ptr %t8297
}
define ptr @chacha20poly1305g_seal__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8298 = call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 0, ptr %p1)
%t8299 = call ptr @resid_list_freeze(ptr %t8298)
%t8300 = call ptr @resid_list_slice(ptr %t8299, i64 0, i64 32)
%t8302 = call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 1, ptr %p1, ptr %p2)
%t8303 = call ptr @resid_list_freeze(ptr %t8302)
%t8304 = call ptr @__m____________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p3, ptr %t8303)
%t8305 = call ptr @resid_list_freeze(ptr %t8304)
%t8306 = call ptr @poly1305g__g_Int_64__Int_512_(ptr %t8300, ptr %t8305)
%t8307 = call ptr @resid_list_freeze(ptr %t8306)
%t8308 = call ptr @resid_list_concat(ptr %t8303, ptr %t8307)
ret ptr %t8308
}
define ptr @chacha20poly1305g_decrypt__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8309 = call i64 @resid_list_len(ptr %p2)
%t8310 = sub nsw i64 %t8309, 16
%t8311 = call i64 @resid_list_len(ptr %p0)
%t8312 = icmp ne i64 %t8311, 32
br label %LSL8313
LSL8313:
br i1 %t8312, label %LSJ8313, label %LSR8313
LSR8313:
%t8314 = call i64 @resid_list_len(ptr %p1)
%t8315 = icmp ne i64 %t8314, 12
br label %LSJ8313
LSJ8313:
%t8316 = phi i1 [ true, %LSL8313 ], [ %t8315, %LSR8313 ]
br label %LSL8317
LSL8317:
br i1 %t8316, label %LSJ8317, label %LSR8317
LSR8317:
%t8318 = icmp slt i64 %t8310, 0
br label %LSJ8317
LSJ8317:
%t8319 = phi i1 [ true, %LSL8317 ], [ %t8318, %LSR8317 ]
br i1 %t8319, label %L916, label %L918
L916:
ret ptr @.nbox8320
L918:
%t8321 = call ptr @resid_listbuf_new()
%t8322 = call ptr @resid_listbuf_new()
%t8323 = call ptr @resid_list_slice(ptr %p2, i64 0, i64 %t8310)
%t8325 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t8323, i64 0, ptr %t8321)
%t8326 = call ptr @resid_list_freeze(ptr %t8325)
%t8327 = call i64 @resid_list_len(ptr %p2)
%t8328 = call ptr @resid_list_slice(ptr %p2, i64 %t8310, i64 %t8327)
%t8330 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t8328, i64 0, ptr %t8322)
%t8331 = call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 0, ptr %p1)
%t8332 = call ptr @resid_list_freeze(ptr %t8331)
%t8333 = call ptr @resid_list_slice(ptr %t8332, i64 0, i64 32)
%t8335 = call ptr @__m____________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p3, ptr %t8326)
%t8336 = call ptr @resid_list_freeze(ptr %t8335)
%t8337 = call ptr @poly1305g__g_Int_64__Int_512_(ptr %t8333, ptr %t8336)
%t8338 = call ptr @resid_list_freeze(ptr %t8337)
%t8339 = call i1 @__m____________lib_crypto_resid__ct_same_pub(ptr %t8338, ptr %t8330)
%t8340 = xor i1 %t8339, true
br i1 %t8340, label %L919, label %L921
L919:
ret ptr @.nbox8341
L921:
%t8342 = call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 1, ptr %p1, ptr %t8326)
%t8343 = call ptr @resid_list_freeze(ptr %t8342)
%t8346 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty8344)
%t8345 = getelementptr {i32, i32, ptr}, ptr %t8346, i32 1
store ptr %t8343, ptr %t8345
ret ptr %t8346
}
define ptr @__m____________lib_sha256g_resid__g_blk__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in, i64 %p19.in, i64 %p20.in, i64 %p21.in, i64 %p22.in, i64 %p23.in, i64 %p24.in, i64 %p25.in, i64 %p26.in, i64 %p27.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8380 = alloca [8 x ptr]
%p3.ld = call ptr @resid_list_vdata(ptr %p3.in)
%p3.ln = call i64 @resid_list_vlen(ptr %p3.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8419, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t8420, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t8421, %tco.s0.k ]
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
%p27 = phi i64 [ %p27.in, %entry ], [ %t8407, %tco.s0.k ]
%t8347 = icmp sge i64 %p2, 64
br i1 %t8347, label %L922, label %L924
L922:
%t8348 = call ptr @resid_list_get_v(ptr %p3, i64 0, ptr %p3.ld, i64 %p3.ln)
%t8349 = call i64 @resid_unbox_i64(ptr %t8348)
%t8351 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8349, i64 %p4)
%t8352 = call ptr @resid_list_get_v(ptr %p3, i64 1, ptr %p3.ld, i64 %p3.ln)
%t8353 = call i64 @resid_unbox_i64(ptr %t8352)
%t8355 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8353, i64 %p5)
%t8356 = call ptr @resid_list_get_v(ptr %p3, i64 2, ptr %p3.ld, i64 %p3.ln)
%t8357 = call i64 @resid_unbox_i64(ptr %t8356)
%t8359 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8357, i64 %p6)
%t8360 = call ptr @resid_list_get_v(ptr %p3, i64 3, ptr %p3.ld, i64 %p3.ln)
%t8361 = call i64 @resid_unbox_i64(ptr %t8360)
%t8363 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8361, i64 %p7)
%t8364 = call ptr @resid_list_get_v(ptr %p3, i64 4, ptr %p3.ld, i64 %p3.ln)
%t8365 = call i64 @resid_unbox_i64(ptr %t8364)
%t8367 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8365, i64 %p8)
%t8368 = call ptr @resid_list_get_v(ptr %p3, i64 5, ptr %p3.ld, i64 %p3.ln)
%t8369 = call i64 @resid_unbox_i64(ptr %t8368)
%t8371 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8369, i64 %p9)
%t8372 = call ptr @resid_list_get_v(ptr %p3, i64 6, ptr %p3.ld, i64 %p3.ln)
%t8373 = call i64 @resid_unbox_i64(ptr %t8372)
%t8375 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8373, i64 %p10)
%t8376 = call ptr @resid_list_get_v(ptr %p3, i64 7, ptr %p3.ld, i64 %p3.ln)
%t8377 = call i64 @resid_unbox_i64(ptr %t8376)
%t8379 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8377, i64 %p11)
%t8382 = call ptr @resid_box_i64(i64 %t8351)
%t8384 = getelementptr i8, ptr %t8380, i64 0
store ptr %t8382, ptr %t8384
%t8385 = call ptr @resid_box_i64(i64 %t8355)
%t8387 = getelementptr i8, ptr %t8380, i64 8
store ptr %t8385, ptr %t8387
%t8388 = call ptr @resid_box_i64(i64 %t8359)
%t8390 = getelementptr i8, ptr %t8380, i64 16
store ptr %t8388, ptr %t8390
%t8391 = call ptr @resid_box_i64(i64 %t8363)
%t8393 = getelementptr i8, ptr %t8380, i64 24
store ptr %t8391, ptr %t8393
%t8394 = call ptr @resid_box_i64(i64 %t8367)
%t8396 = getelementptr i8, ptr %t8380, i64 32
store ptr %t8394, ptr %t8396
%t8397 = call ptr @resid_box_i64(i64 %t8371)
%t8399 = getelementptr i8, ptr %t8380, i64 40
store ptr %t8397, ptr %t8399
%t8400 = call ptr @resid_box_i64(i64 %t8375)
%t8402 = getelementptr i8, ptr %t8380, i64 48
store ptr %t8400, ptr %t8402
%t8403 = call ptr @resid_box_i64(i64 %t8379)
%t8405 = getelementptr i8, ptr %t8380, i64 56
store ptr %t8403, ptr %t8405
%t8406 = call ptr @resid_list_new(i64 8, ptr %t8380, ptr @.lty8380)
%lr.cx87 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz87 = icmp eq ptr %lr.cx87, null
br i1 %lr.lz87, label %lr.x87.k, label %lr.x87.m
lr.x87.k:
ret ptr %t8406
lr.x87.m:
%lr.ret87 = call ptr @resid_mv_list(ptr %t8406, ptr %lr.cx87)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret87
L924:
%t8407 = call i64 @__m____________lib_sha256g_resid__g_sched__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p12, i64 %p13, i64 %p21, i64 %p26)
%t8408 = call i64 @resid_scope_push()
%t8409 = call i64 @__m____________lib_sha256g_resid__g_bsig1__g_Int_64__Int_64_(i64 %p8)
%t8410 = call i64 @__m____________lib_word_resid__wi_add(i64 %p11, i64 %t8409)
%t8411 = call i64 @__m____________lib_sha256g_resid__g_ch__g_Int_64__Int_64_(i64 %p8, i64 %p9, i64 %p10)
%t8412 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8410, i64 %t8411)
%t8413 = call i64 @__m____________lib_sha256g_resid__sha2k(i64 %p2)
%t8414 = call i64 @__m____________lib_word_resid__wi_addk(i64 %t8412, i64 %t8413)
%t8415 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8414, i64 %t8407)
call void @resid_scope_pop(i64 %t8408)
%t8416 = call i64 @__m____________lib_sha256g_resid__g_bsig0__g_Int_64__Int_64_(i64 %p4)
%t8417 = call i64 @__m____________lib_sha256g_resid__g_maj__g_Int_64__Int_64_(i64 %p4, i64 %p5, i64 %p6)
%t8418 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8416, i64 %t8417)
%t8419 = add nsw i64 %p2, 1
%t8420 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8415, i64 %t8418)
%t8421 = call i64 @__m____________lib_word_resid__wi_add(i64 %p7, i64 %t8415)
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
%p1 = phi i64 [ %p1.in, %entry ], [ %t8460, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8459, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t8457, %tco.s0 ]
%t8423 = call i64 @resid_list_len(ptr %p0)
%t8424 = icmp sge i64 %p1, %t8423
br i1 %t8424, label %L925, label %L927
L925:
%t8425 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty8425)
%t8426 = call ptr @__m____________lib_crypto_resid__b64g_finish__g_Int_64__Int_64_(ptr %t8425, i64 %p2)
ret ptr %t8426
L927:
%t8427 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %p1)
%t8428 = add nsw i64 %p1, 1
%t8429 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t8428)
%t8430 = add nsw i64 %p1, 2
%t8431 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t8430)
%t8432 = add nsw i64 %p1, 3
%t8433 = call i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t8432)
%t8434 = call i64 @__m____________lib_crypto_resid__b64g_join__g_Int_64__Int_64_(i64 %t8427, i64 %t8429, i64 %t8431, i64 %t8433)
%t8435 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t8423, i64 %p1)
%t8436 = extractvalue {i64, i1} %t8435, 0
%t8437 = extractvalue {i64, i1} %t8435, 1
%t8438 = zext i1 %t8437 to i8
call void @resid_overflow_check(i8 %t8438)
%t8439 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8434, i64 16)
%t8440 = call ptr @resid_box_i64(i64 %t8439)
%t8443 = call ptr @resid_listbuf_push(ptr %p3, ptr %t8440)
%t8444 = icmp sgt i64 %t8436, 2
br i1 %t8444, label %L928, label %L929
L928:
%t8445 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8434, i64 8)
%t8446 = call ptr @resid_box_i64(i64 %t8445)
%t8449 = call ptr @resid_listbuf_push(ptr %t8443, ptr %t8446)
br label %L930
L929:
br label %L930
L930:
%t8450 = phi ptr [ %t8449, %L928 ], [ %t8443, %L929 ]
%t8451 = icmp sgt i64 %t8436, 3
br i1 %t8451, label %L931, label %L932
L931:
%t8452 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8434, i64 0)
%t8453 = call ptr @resid_box_i64(i64 %t8452)
%t8456 = call ptr @resid_listbuf_push(ptr %t8450, ptr %t8453)
br label %L933
L932:
br label %L933
L933:
%t8457 = phi ptr [ %t8456, %L931 ], [ %t8450, %L932 ]
%t8458 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8434, i64 16777216)
%t8459 = call i64 @__m____________lib_word_resid__wi_or(i64 %p2, i64 %t8458)
%t8460 = add nsw i64 %p1, 4
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8462 = call i512 @__m____________lib_word_resid__pi_sub(i512 %p0, i512 %p1)
%t8463 = call i512 @__m____________lib_word_resid__pi_sign(i512 %t8462)
%t8464 = call i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %t8463)
%t8465 = sext i64 -1 to i512
%t8466 = call i512 @__m____________lib_word_resid__pi_xor(i512 %t8463, i512 %t8465)
%t8467 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8462, i512 %t8466)
%t8468 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8464, i512 %t8467)
ret i512 %t8468
}
define ptr @__m____________lib_ed25519g_resid__eg_sel__g_Int_512__Int_64_(i512 %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8469 = sext i64 -1 to i512
%t8470 = call i512 @__m____________lib_word_resid__pi_xor(i512 %p0, i512 %t8469)
%t8471 = getelementptr i8, ptr %p1, i64 0
%t8472 = load i512, ptr %t8471, align 8
%t8473 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8472, i512 %p0)
%t8474 = getelementptr i8, ptr %p2, i64 0
%t8475 = load i512, ptr %t8474, align 8
%t8476 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8475, i512 %t8470)
%t8477 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8473, i512 %t8476)
%t8478 = getelementptr i8, ptr %p1, i64 64
%t8479 = load i512, ptr %t8478, align 8
%t8480 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8479, i512 %p0)
%t8481 = getelementptr i8, ptr %p2, i64 64
%t8482 = load i512, ptr %t8481, align 8
%t8483 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8482, i512 %t8470)
%t8484 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8480, i512 %t8483)
%t8485 = getelementptr i8, ptr %p1, i64 128
%t8486 = load i512, ptr %t8485, align 8
%t8487 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8486, i512 %p0)
%t8488 = getelementptr i8, ptr %p2, i64 128
%t8489 = load i512, ptr %t8488, align 8
%t8490 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8489, i512 %t8470)
%t8491 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8487, i512 %t8490)
%t8492 = getelementptr i8, ptr %p1, i64 192
%t8493 = load i512, ptr %t8492, align 8
%t8494 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8493, i512 %p0)
%t8495 = getelementptr i8, ptr %p2, i64 192
%t8496 = load i512, ptr %t8495, align 8
%t8497 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8496, i512 %t8470)
%t8498 = call i512 @__m____________lib_word_resid__pi_or(i512 %t8494, i512 %t8497)
%t8499 = call ptr @resid_rec_reuse_sc(ptr %p1, i64 256)
%t8499.f0 = getelementptr i8, ptr %t8499, i64 0
store i512 %t8477, ptr %t8499.f0, align 8
%t8499.f8 = getelementptr i8, ptr %t8499, i64 64
store i512 %t8484, ptr %t8499.f8, align 8
%t8499.f16 = getelementptr i8, ptr %t8499, i64 128
store i512 %t8491, ptr %t8499.f16, align 8
%t8499.f24 = getelementptr i8, ptr %t8499, i64 192
store i512 %t8498, ptr %t8499.f24, align 8
ret ptr %t8499
}
define ptr @eg_base__g_Int_512__Int_64_() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8500 = sext i256 15112221349535400772501151409588531511454012693041857206046113283949847762202 to i512
%t8501 = sext i256 46316835694926478169428394003475163141307993866256225615783033603165251855960 to i512
%t8502 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t8500, i512 %t8501)
ret ptr %t8502
}
define ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8505, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t8514, %tco.s0 ]
%t8503 = icmp sge i64 %p2, %p1
br i1 %t8503, label %L934, label %L936
L934:
%t8504 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty8504)
ret ptr %t8504
L936:
%t8505 = add nsw i64 %p2, 1
%t8506 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p2)
%t8507 = extractvalue {i64, i1} %t8506, 0
%t8508 = extractvalue {i64, i1} %t8506, 1
%t8509 = zext i1 %t8508 to i8
call void @resid_overflow_check(i8 %t8509)
%t8510 = call i64 @__m____________lib_word_resid__pi_byte(i512 %p0, i64 %t8507)
%t8511 = call ptr @resid_box_i64(i64 %t8510)
%t8514 = call ptr @resid_listbuf_push(ptr %p3, ptr %t8511)
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t8517, %tco.s0 ]
%p4 = phi i512 [ %p4.in, %entry ], [ %t8531, %tco.s0 ]
%t8516 = icmp sge i64 %p3, %p2
br i1 %t8516, label %L937, label %L939
L937:
ret i512 %p4
L939:
%t8517 = add nsw i64 %p3, 1
%t8518 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p3)
%t8519 = extractvalue {i64, i1} %t8518, 0
%t8520 = extractvalue {i64, i1} %t8518, 1
%t8521 = zext i1 %t8520 to i8
call void @resid_overflow_check(i8 %t8521)
%t8522 = call ptr @resid_list_get_v(ptr %p0, i64 %t8519, ptr %p0.ld, i64 %p0.ln)
%t8523 = call i64 @resid_unbox_i64(ptr %t8522)
%t8525 = call i512 @__m____________lib_word_resid__pi_from_byte(i64 %t8523)
%t8526 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p3)
%t8527 = extractvalue {i64, i1} %t8526, 0
%t8528 = extractvalue {i64, i1} %t8526, 1
%t8529 = zext i1 %t8528 to i8
call void @resid_overflow_check(i8 %t8529)
%t8530 = call i512 @__m____________lib_word_resid__pi_shl(i512 %t8525, i64 %t8527)
%t8531 = call i512 @__m____________lib_word_resid__pi_or(i512 %p4, i512 %t8530)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @eg_fold_l__g_Int_512__Int_64_(i512 %p0.in, i512 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t8539, %tco.s0 ]
%p1 = phi i512 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8540, %tco.s0 ]
%t8533 = icmp slt i64 %p2, 0
br i1 %t8533, label %L940, label %L942
L940:
ret i512 %p0
L942:
%t8534 = call i512 @__m____________lib_word_resid__pi_shr(i512 %p1, i64 %p2)
%t8535 = call i512 @__m____________lib_word_resid__pi_and(i512 %t8534, i512 1)
%t8536 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %p0)
%t8537 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8536, i512 %t8535)
%t8538 = sext i256 7237005577332262213973186563042994240857116359379907606001950938285454250989 to i512
%t8539 = call i512 @__m____________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t8537, i512 %t8538)
%t8540 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @sha512g__g_Int_64__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8542 = add i64 7640891576956012808, 0
%t8543 = add i64 %t8542, 0
%t8544 = add i64 %t8543, 0
%t8545 = icmp ne i64 %t8544, %t8542
%t8546 = icmp slt i64 7640891576956012808, 0
%t8547 = or i1 %t8545, %t8546
%t8548 = zext i1 %t8547 to i8
call void @resid_conv_check(i8 %t8548)
%t8549 = add i128 13503953896175478587, 0
%t8550 = trunc i128 %t8549 to i64
%t8551 = zext i64 %t8550 to i128
%t8552 = icmp ne i128 %t8551, %t8549
%t8553 = icmp slt i128 13503953896175478587, 0
%t8554 = or i1 %t8552, %t8553
%t8555 = zext i1 %t8554 to i8
call void @resid_conv_check(i8 %t8555)
%t8556 = add i64 4354685564936845355, 0
%t8557 = add i64 %t8556, 0
%t8558 = add i64 %t8557, 0
%t8559 = icmp ne i64 %t8558, %t8556
%t8560 = icmp slt i64 4354685564936845355, 0
%t8561 = or i1 %t8559, %t8560
%t8562 = zext i1 %t8561 to i8
call void @resid_conv_check(i8 %t8562)
%t8563 = add i128 11912009170470909681, 0
%t8564 = trunc i128 %t8563 to i64
%t8565 = zext i64 %t8564 to i128
%t8566 = icmp ne i128 %t8565, %t8563
%t8567 = icmp slt i128 11912009170470909681, 0
%t8568 = or i1 %t8566, %t8567
%t8569 = zext i1 %t8568 to i8
call void @resid_conv_check(i8 %t8569)
%t8570 = add i64 5840696475078001361, 0
%t8571 = add i64 %t8570, 0
%t8572 = add i64 %t8571, 0
%t8573 = icmp ne i64 %t8572, %t8570
%t8574 = icmp slt i64 5840696475078001361, 0
%t8575 = or i1 %t8573, %t8574
%t8576 = zext i1 %t8575 to i8
call void @resid_conv_check(i8 %t8576)
%t8577 = add i128 11170449401992604703, 0
%t8578 = trunc i128 %t8577 to i64
%t8579 = zext i64 %t8578 to i128
%t8580 = icmp ne i128 %t8579, %t8577
%t8581 = icmp slt i128 11170449401992604703, 0
%t8582 = or i1 %t8580, %t8581
%t8583 = zext i1 %t8582 to i8
call void @resid_conv_check(i8 %t8583)
%t8584 = add i64 2270897969802886507, 0
%t8585 = add i64 %t8584, 0
%t8586 = add i64 %t8585, 0
%t8587 = icmp ne i64 %t8586, %t8584
%t8588 = icmp slt i64 2270897969802886507, 0
%t8589 = or i1 %t8587, %t8588
%t8590 = zext i1 %t8589 to i8
call void @resid_conv_check(i8 %t8590)
%t8591 = add i64 6620516959819538809, 0
%t8592 = add i64 %t8591, 0
%t8593 = add i64 %t8592, 0
%t8594 = icmp ne i64 %t8593, %t8591
%t8595 = icmp slt i64 6620516959819538809, 0
%t8596 = or i1 %t8594, %t8595
%t8597 = zext i1 %t8596 to i8
call void @resid_conv_check(i8 %t8597)
%t8598 = alloca [8 x ptr]
%t8600 = call ptr @resid_box_i64(i64 %t8543)
%t8602 = getelementptr i8, ptr %t8598, i64 0
store ptr %t8600, ptr %t8602
%t8603 = call ptr @resid_box_i64(i64 %t8550)
%t8605 = getelementptr i8, ptr %t8598, i64 8
store ptr %t8603, ptr %t8605
%t8606 = call ptr @resid_box_i64(i64 %t8557)
%t8608 = getelementptr i8, ptr %t8598, i64 16
store ptr %t8606, ptr %t8608
%t8609 = call ptr @resid_box_i64(i64 %t8564)
%t8611 = getelementptr i8, ptr %t8598, i64 24
store ptr %t8609, ptr %t8611
%t8612 = call ptr @resid_box_i64(i64 %t8571)
%t8614 = getelementptr i8, ptr %t8598, i64 32
store ptr %t8612, ptr %t8614
%t8615 = call ptr @resid_box_i64(i64 %t8578)
%t8617 = getelementptr i8, ptr %t8598, i64 40
store ptr %t8615, ptr %t8617
%t8618 = call ptr @resid_box_i64(i64 %t8585)
%t8620 = getelementptr i8, ptr %t8598, i64 48
store ptr %t8618, ptr %t8620
%t8621 = call ptr @resid_box_i64(i64 %t8592)
%t8623 = getelementptr i8, ptr %t8598, i64 56
store ptr %t8621, ptr %t8623
%t8624 = call ptr @resid_list_new(i64 8, ptr %t8598, ptr @.lty8598)
%t8625 = call ptr @__m____________lib_sha512g_resid__g5_hash__g_Int_64__UInt_64_(ptr %p0, ptr %t8624, i64 64)
ret ptr %t8625
}
define i512 @__m____________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8626 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 32, i64 0, i512 0)
%t8627 = call i512 @eg_clamp__g_Int_512__Int_64_(i512 %t8626)
ret i512 %t8627
}
define ptr @d_lift_bytes__g_Int_64__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8628 = call ptr @resid_listbuf_new()
%t8629 = call ptr @__m____________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %p0, i64 0, ptr %t8628)
ret ptr %t8629
}
define ptr @__m____________lib_ed25519g_resid__eg_lift_bytes__g_Int_64__Int_512_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8639, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8644, %tco.s0 ]
%t8630 = call i64 @resid_list_len(ptr %p0)
%t8631 = icmp sge i64 %p1, %t8630
br i1 %t8631, label %L943, label %L945
L943:
%t8632 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8632)
ret ptr %t8632
L945:
%t8633 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t8634 = call i64 @resid_unbox_i64(ptr %t8633)
%t8636 = and i64 %t8634, 255
%t8637 = sext i64 %t8636 to i512
%t8638 = call i512 @__m____________lib_word_resid__pi_lift(i512 %t8637)
%t8639 = add nsw i64 %p1, 1
%t8640 = call i64 @__m____________lib_word_resid__pi_byte(i512 %t8638, i64 0)
%t8641 = call ptr @resid_box_i64(i64 %t8640)
%t8644 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8641)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8646 = call i64 @__m____________lib_chachag_resid__cg_le32(ptr %p2, i64 0)
%t8647 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t8646)
%t8648 = call i64 @__m____________lib_chachag_resid__cg_le32(ptr %p2, i64 4)
%t8649 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t8648)
%t8650 = call i64 @__m____________lib_chachag_resid__cg_le32(ptr %p2, i64 8)
%t8651 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t8650)
%t8652 = call ptr @__m____________lib_chachag_resid__cg_state_w__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %t8647, i64 %t8649, i64 %t8651)
ret ptr %t8652
}
define ptr @__m____________lib_chachag_resid__cg_block_st__g_Int_64__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8653 = call ptr @resid_listbuf_new()
%t8654 = call ptr @resid_list_get(ptr %p0, i64 12)
%t8655 = call i64 @resid_unbox_i64(ptr %t8654)
%t8657 = call ptr @__m____________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %t8655)
%t8658 = call ptr @__m____________lib_chachag_resid__cg_ser__g_Int_64__Int_64_(ptr %t8657, i64 0, ptr %t8653)
ret ptr %t8658
}
define ptr @__m____________lib_chachag_resid__cg_xor_run__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8671, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t8673, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t8676, %tco.s0 ]
%t8659 = call i64 @resid_list_len(ptr %p2)
%t8660 = icmp sge i64 %p3, %t8659
br i1 %t8660, label %L946, label %L948
L946:
ret ptr %p4
L948:
%t8661 = call i64 @__m____________lib_word_resid__wi_lift(i64 %p1)
%t8662 = call ptr @__m____________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %t8661)
%t8663 = call i64 @resid_list_len(ptr %p2)
%t8664 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t8663, i64 %p3)
%t8665 = extractvalue {i64, i1} %t8664, 0
%t8666 = extractvalue {i64, i1} %t8664, 1
%t8667 = zext i1 %t8666 to i8
call void @resid_overflow_check(i8 %t8667)
%t8668 = icmp slt i64 %t8665, 64
br i1 %t8668, label %L949, label %L950
L949:
br label %L951
L950:
br label %L951
L951:
%t8669 = phi i64 [ %t8665, %L949 ], [ 64, %L950 ]
%t8670 = call i64 @wrapping_add(i64 %p1, i64 1)
%t8671 = and i64 %t8670, 4294967295
%t8672 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %t8669)
%t8673 = extractvalue {i64, i1} %t8672, 0
%t8674 = extractvalue {i64, i1} %t8672, 1
%t8675 = zext i1 %t8674 to i8
call void @resid_overflow_check(i8 %t8675)
%t8676 = call ptr @__m____________lib_chachag_resid__cg_xor_bytes__g_Int_64__Int_64_(ptr %t8662, ptr %p2, i64 %p3, i64 0, i64 %t8669, ptr %p4)
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t8679, %tco.s0 ]
%p4 = phi i512 [ %p4.in, %entry ], [ %t8693, %tco.s0 ]
%t8678 = icmp sge i64 %p3, %p2
br i1 %t8678, label %L952, label %L954
L952:
ret i512 %p4
L954:
%t8679 = add nsw i64 %p3, 1
%t8680 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p3)
%t8681 = extractvalue {i64, i1} %t8680, 0
%t8682 = extractvalue {i64, i1} %t8680, 1
%t8683 = zext i1 %t8682 to i8
call void @resid_overflow_check(i8 %t8683)
%t8684 = call ptr @resid_list_get_v(ptr %p0, i64 %t8681, ptr %p0.ld, i64 %p0.ln)
%t8685 = call i64 @resid_unbox_i64(ptr %t8684)
%t8687 = call i512 @__m____________lib_word_resid__pi_from_byte(i64 %t8685)
%t8688 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p3)
%t8689 = extractvalue {i64, i1} %t8688, 0
%t8690 = extractvalue {i64, i1} %t8688, 1
%t8691 = zext i1 %t8690 to i8
call void @resid_overflow_check(i8 %t8691)
%t8692 = call i512 @__m____________lib_word_resid__pi_shl(i512 %t8687, i64 %t8689)
%t8693 = call i512 @__m____________lib_word_resid__pi_or(i512 %p4, i512 %t8692)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m____________lib_chachag_resid__pg_blocks__g_Int_512__Int_64_(i512 %p0.in, ptr %p1.in, i64 %p2.in, i512 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t8717, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8719, %tco.s0 ]
%p3 = phi i512 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t8695 = call i64 @resid_list_len(ptr %p1)
%t8696 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t8695, i64 %p2)
%t8697 = extractvalue {i64, i1} %t8696, 0
%t8698 = extractvalue {i64, i1} %t8696, 1
%t8699 = zext i1 %t8698 to i8
call void @resid_overflow_check(i8 %t8699)
%t8700 = icmp sle i64 %t8697, 0
br i1 %t8700, label %L955, label %L957
L955:
ret i512 %p0
L957:
%t8701 = icmp slt i64 %t8697, 16
br i1 %t8701, label %L958, label %L959
L958:
br label %L960
L959:
br label %L960
L960:
%t8702 = phi i64 [ %t8697, %L958 ], [ 16, %L959 ]
%t8703 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t8702, i64 8)
%t8704 = extractvalue {i64, i1} %t8703, 0
%t8705 = extractvalue {i64, i1} %t8703, 1
%t8706 = zext i1 %t8705 to i8
call void @resid_overflow_check(i8 %t8706)
%t8707 = sext i64 %t8704 to i512
%t8708 = icmp uge i512 %t8707, 512
%t8709 = add i512 %t8707, 0
%t8710 = shl i512 1, %t8709
%t8711 = select i1 %t8708, i512 0, i512 %t8710
%t8712 = call i512 @__m____________lib_word_resid__pi_lift(i512 %t8711)
%t8713 = call i512 @__m____________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p1, i64 %p2, i64 %t8702, i64 0, i512 0)
%t8714 = call i512 @__m____________lib_word_resid__pi_add(i512 %t8713, i512 %t8712)
%t8715 = call i512 @__m____________lib_word_resid__pi_add(i512 %p0, i512 %t8714)
%t8716 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t8715, i512 %p3)
%t8717 = call i512 @__m____________lib_chachag_resid__pg_reduce__g_Int_512__Int_64_(i512 %t8716)
%t8718 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %t8702)
%t8719 = extractvalue {i64, i1} %t8718, 0
%t8720 = extractvalue {i64, i1} %t8718, 1
%t8721 = zext i1 %t8720 to i8
call void @resid_overflow_check(i8 %t8721)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__pg_bytes__g_Int_512__Int_64_(i512 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8725, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8734, %tco.s0 ]
%t8723 = icmp sge i64 %p1, 16
br i1 %t8723, label %L961, label %L963
L961:
%t8724 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8724)
ret ptr %t8724
L963:
%t8725 = add nsw i64 %p1, 1
%t8726 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p1)
%t8727 = extractvalue {i64, i1} %t8726, 0
%t8728 = extractvalue {i64, i1} %t8726, 1
%t8729 = zext i1 %t8728 to i8
call void @resid_overflow_check(i8 %t8729)
%t8730 = call i64 @__m____________lib_word_resid__pi_byte(i512 %p0, i64 %t8727)
%t8731 = call ptr @resid_box_i64(i64 %t8730)
%t8734 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8731)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8736 = call i64 @resid_list_len(ptr %p0)
%t8737 = call i64 @__m____________lib_chachag_resid__cg_pad16(i64 %t8736)
%t8738 = call ptr @resid_listbuf_new()
%t8739 = call ptr @__m____________lib_chachag_resid__cg_zeros(i64 %t8737, i64 0, ptr %t8738)
%t8740 = call ptr @resid_list_freeze(ptr %t8739)
%t8741 = call ptr @resid_list_concat(ptr %p0, ptr %t8740)
%t8742 = call i64 @resid_list_len(ptr %p1)
%t8743 = call i64 @__m____________lib_chachag_resid__cg_pad16(i64 %t8742)
%t8744 = call ptr @resid_listbuf_new()
%t8745 = call ptr @__m____________lib_chachag_resid__cg_zeros(i64 %t8743, i64 0, ptr %t8744)
%t8746 = call i64 @resid_list_len(ptr %p0)
%t8747 = call ptr @resid_listbuf_new()
%t8748 = call ptr @__m____________lib_chachag_resid__cg_le64(i64 %t8746, i64 0, ptr %t8747)
%t8749 = call ptr @resid_list_freeze(ptr %t8748)
%t8750 = call ptr @resid_list_concat_own(ptr %t8745, i8 1, ptr %t8749)
%t8751 = call i64 @resid_list_len(ptr %p1)
%t8752 = call ptr @resid_listbuf_new()
%t8753 = call ptr @__m____________lib_chachag_resid__cg_le64(i64 %t8751, i64 0, ptr %t8752)
%t8754 = call ptr @resid_list_freeze(ptr %t8753)
%t8755 = call ptr @resid_list_concat_own(ptr %t8750, i8 1, ptr %t8754)
%t8756 = call ptr @resid_listbuf_new()
%t8757 = call ptr @resid_listbuf_new()
%t8758 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t8741, i64 0, ptr %t8756)
%t8759 = call ptr @resid_list_concat_own(ptr %t8758, i8 1, ptr %p1)
%t8760 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t8755, i64 0, ptr %t8757)
%t8761 = call ptr @resid_list_freeze(ptr %t8760)
%t8762 = call ptr @resid_list_concat_own(ptr %t8759, i8 1, ptr %t8761)
ret ptr %t8762
}
define ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8770, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8774, %tco.s0 ]
%t8763 = call i64 @resid_list_len(ptr %p0)
%t8764 = icmp sge i64 %p1, %t8763
br i1 %t8764, label %L964, label %L966
L964:
%t8765 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8765)
ret ptr %t8765
L966:
%t8766 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t8767 = call i64 @resid_unbox_i64(ptr %t8766)
%t8769 = call i64 @__m____________lib_word_resid__bi_lift(i64 %t8767)
%t8770 = add nsw i64 %p1, 1
%t8771 = call ptr @resid_box_i64(i64 %t8769)
%t8774 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8771)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_sha256g_resid__g_sched__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8776 = icmp slt i64 %p2, 16
br i1 %t8776, label %L967, label %L969
L967:
%t8777 = call i64 @__m____________lib_sha256g_resid__g_word_at__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2)
ret i64 %t8777
L969:
%t8778 = call i64 @__m____________lib_sha256g_resid__g_ssig1__g_Int_64__Int_64_(i64 %p6)
%t8779 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8778, i64 %p5)
%t8780 = call i64 @__m____________lib_sha256g_resid__g_ssig0__g_Int_64__Int_64_(i64 %p4)
%t8781 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8780, i64 %p3)
%t8782 = call i64 @__m____________lib_word_resid__wi_add(i64 %t8779, i64 %t8781)
ret i64 %t8782
}
define i64 @__m____________lib_sha256g_resid__g_bsig1__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8783 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 6)
%t8784 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 11)
%t8785 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8783, i64 %t8784)
%t8786 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 25)
%t8787 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8785, i64 %t8786)
ret i64 %t8787
}
define i64 @__m____________lib_sha256g_resid__g_ch__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8788 = call i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p1)
%t8789 = call i64 @__m____________lib_word_resid__wi_not(i64 %p0)
%t8790 = call i64 @__m____________lib_word_resid__wi_and(i64 %t8789, i64 %p2)
%t8791 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8788, i64 %t8790)
ret i64 %t8791
}
define i64 @__m____________lib_sha256g_resid__g_bsig0__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8792 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 2)
%t8793 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 13)
%t8794 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8792, i64 %t8793)
%t8795 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 22)
%t8796 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8794, i64 %t8795)
ret i64 %t8796
}
define i64 @__m____________lib_sha256g_resid__g_maj__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8797 = call i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p1)
%t8798 = call i64 @__m____________lib_word_resid__wi_and(i64 %p0, i64 %p2)
%t8799 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8797, i64 %t8798)
%t8800 = call i64 @__m____________lib_word_resid__wi_and(i64 %p1, i64 %p2)
%t8801 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t8799, i64 %t8800)
ret i64 %t8801
}
define ptr @__m____________lib_crypto_resid__b64g_finish__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8802 = call i64 @__m____________lib_word_resid__wi_byte(i64 %p1, i64 24)
%t8803 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB8803)
%t8804 = alloca [1 x ptr]
%t8806 = call ptr @resid_box_i64(i64 %t8802)
%t8808 = getelementptr i8, ptr %t8804, i64 0
store ptr %t8806, ptr %t8808
%t8809 = call ptr @resid_list_new(i64 1, ptr %t8804, ptr @.lty8804)
%t8811 = call ptr @resid_list_const_i64(ptr @.lc8810, i64 1, ptr @.lcd8810, ptr @.lty8810)
%t8812 = call i1 @__m____________lib_crypto_resid__ct_same_pub(ptr %t8809, ptr %t8811)
%t8813 = xor i1 %t8812, true
br i1 %t8813, label %L970, label %L972
L970:
ret ptr %t8803
L972:
ret ptr %p0
}
define i64 @__m____________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8814 = call i64 @resid_list_len(ptr %p0)
%t8815 = icmp sge i64 %p1, %t8814
br i1 %t8815, label %L973, label %L975
L973:
ret i64 0
L975:
%t8816 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t8817 = call i64 @resid_unbox_i64(ptr %t8816)
%t8819 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t8817)
%t8820 = call i64 @b64g_sextet__g_Int_64__Int_64_(i64 %t8819)
ret i64 %t8820
}
define i64 @__m____________lib_crypto_resid__b64g_join__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8821 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p0, i64 63)
%t8822 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8821, i64 18)
%t8823 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p1, i64 63)
%t8824 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8823, i64 12)
%t8825 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8822, i64 %t8824)
%t8826 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p2, i64 63)
%t8827 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8826, i64 6)
%t8828 = call i64 @__m____________lib_word_resid__wi_andk(i64 %p3, i64 63)
%t8829 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8827, i64 %t8828)
%t8830 = call i64 @__m____________lib_word_resid__wi_or(i64 %p0, i64 %p1)
%t8831 = call i64 @__m____________lib_word_resid__wi_or(i64 %p2, i64 %p3)
%t8832 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8830, i64 %t8831)
%t8833 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t8832, i64 256)
%t8834 = call i64 @__m____________lib_word_resid__wi_shr(i64 %t8833, i64 8)
%t8835 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t8834, i64 24)
%t8836 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8825, i64 %t8829)
%t8837 = call i64 @__m____________lib_word_resid__wi_or(i64 %t8836, i64 %t8835)
ret i64 %t8837
}
define ptr @__m____________lib_sha512g_resid__g5_hash__g_Int_64__UInt_64_(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8838 = call ptr @resid_listbuf_new()
%t8839 = call ptr @resid_listbuf_new()
%t8840 = call i64 @resid_list_len(ptr %p0)
%t8841 = call ptr @sha512g_pad(i64 %t8840)
%t8842 = call ptr @resid_list_freeze(ptr %t8841)
%t8843 = call ptr @__m____________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %t8842, i64 0, ptr %t8838)
%t8844 = call ptr @resid_list_freeze(ptr %t8843)
%t8845 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t8844)
%t8846 = call ptr @__m____________lib_sha512g_resid__g5_lift_state__g_UInt_64__Int_64_(ptr %p1)
%t8847 = call i64 @resid_list_len(ptr %t8845)
%t8848 = call ptr @sha512g_blocks__g_Int_64__UInt_64_(ptr %t8845, i64 0, i64 %t8847, ptr %t8846)
%t8849 = call ptr @__m____________lib_sha512g_resid__g5_out__g_UInt_64__Int_64_(ptr %t8848, i64 %p2, i64 0, ptr %t8839)
ret ptr %t8849
}
define ptr @__m____________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8857, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8862, %tco.s0 ]
%t8850 = call i64 @resid_list_len(ptr %p0)
%t8851 = icmp sge i64 %p1, %t8850
br i1 %t8851, label %L976, label %L978
L976:
%t8852 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8852)
ret ptr %t8852
L978:
%t8853 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t8854 = call i64 @resid_unbox_i64(ptr %t8853)
%t8856 = call i64 @__m____________lib_word_resid__di_lift(i64 %t8854)
%t8857 = add nsw i64 %p1, 1
%t8858 = call i64 @__m____________lib_word_resid__di_byte(i64 %t8856, i64 0)
%t8859 = call ptr @resid_box_i64(i64 %t8858)
%t8862 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8859)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m____________lib_chachag_resid__cg_state_w__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8864 = and i64 %p1, 4294967295
%t8865 = call i64 @__m____________lib_word_resid__wi_lift(i64 %t8864)
%t8866 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 0)
%t8867 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 4)
%t8868 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 8)
%t8869 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 12)
%t8870 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 16)
%t8871 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 20)
%t8872 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 24)
%t8873 = call i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 28)
%t8874 = alloca [16 x ptr]
%t8876 = call ptr @resid_box_i64(i64 1634760805)
%t8878 = getelementptr i8, ptr %t8874, i64 0
store ptr %t8876, ptr %t8878
%t8879 = call ptr @resid_box_i64(i64 857760878)
%t8881 = getelementptr i8, ptr %t8874, i64 8
store ptr %t8879, ptr %t8881
%t8882 = call ptr @resid_box_i64(i64 2036477234)
%t8884 = getelementptr i8, ptr %t8874, i64 16
store ptr %t8882, ptr %t8884
%t8885 = call ptr @resid_box_i64(i64 1797285236)
%t8887 = getelementptr i8, ptr %t8874, i64 24
store ptr %t8885, ptr %t8887
%t8888 = call ptr @resid_box_i64(i64 %t8866)
%t8890 = getelementptr i8, ptr %t8874, i64 32
store ptr %t8888, ptr %t8890
%t8891 = call ptr @resid_box_i64(i64 %t8867)
%t8893 = getelementptr i8, ptr %t8874, i64 40
store ptr %t8891, ptr %t8893
%t8894 = call ptr @resid_box_i64(i64 %t8868)
%t8896 = getelementptr i8, ptr %t8874, i64 48
store ptr %t8894, ptr %t8896
%t8897 = call ptr @resid_box_i64(i64 %t8869)
%t8899 = getelementptr i8, ptr %t8874, i64 56
store ptr %t8897, ptr %t8899
%t8900 = call ptr @resid_box_i64(i64 %t8870)
%t8902 = getelementptr i8, ptr %t8874, i64 64
store ptr %t8900, ptr %t8902
%t8903 = call ptr @resid_box_i64(i64 %t8871)
%t8905 = getelementptr i8, ptr %t8874, i64 72
store ptr %t8903, ptr %t8905
%t8906 = call ptr @resid_box_i64(i64 %t8872)
%t8908 = getelementptr i8, ptr %t8874, i64 80
store ptr %t8906, ptr %t8908
%t8909 = call ptr @resid_box_i64(i64 %t8873)
%t8911 = getelementptr i8, ptr %t8874, i64 88
store ptr %t8909, ptr %t8911
%t8912 = call ptr @resid_box_i64(i64 %t8865)
%t8914 = getelementptr i8, ptr %t8874, i64 96
store ptr %t8912, ptr %t8914
%t8915 = call ptr @resid_box_i64(i64 %p2)
%t8917 = getelementptr i8, ptr %t8874, i64 104
store ptr %t8915, ptr %t8917
%t8918 = call ptr @resid_box_i64(i64 %p3)
%t8920 = getelementptr i8, ptr %t8874, i64 112
store ptr %t8918, ptr %t8920
%t8921 = call ptr @resid_box_i64(i64 %p4)
%t8923 = getelementptr i8, ptr %t8874, i64 120
store ptr %t8921, ptr %t8923
%t8924 = call ptr @resid_list_new(i64 16, ptr %t8874, ptr @.lty8874)
ret ptr %t8924
}
define ptr @__m____________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8925 = call ptr @resid_list_get(ptr %p0, i64 0)
%t8926 = call i64 @resid_unbox_i64(ptr %t8925)
%t8928 = call ptr @resid_list_get(ptr %p0, i64 1)
%t8929 = call i64 @resid_unbox_i64(ptr %t8928)
%t8931 = call ptr @resid_list_get(ptr %p0, i64 2)
%t8932 = call i64 @resid_unbox_i64(ptr %t8931)
%t8934 = call ptr @resid_list_get(ptr %p0, i64 3)
%t8935 = call i64 @resid_unbox_i64(ptr %t8934)
%t8937 = call ptr @resid_list_get(ptr %p0, i64 4)
%t8938 = call i64 @resid_unbox_i64(ptr %t8937)
%t8940 = call ptr @resid_list_get(ptr %p0, i64 5)
%t8941 = call i64 @resid_unbox_i64(ptr %t8940)
%t8943 = call ptr @resid_list_get(ptr %p0, i64 6)
%t8944 = call i64 @resid_unbox_i64(ptr %t8943)
%t8946 = call ptr @resid_list_get(ptr %p0, i64 7)
%t8947 = call i64 @resid_unbox_i64(ptr %t8946)
%t8949 = call ptr @resid_list_get(ptr %p0, i64 8)
%t8950 = call i64 @resid_unbox_i64(ptr %t8949)
%t8952 = call ptr @resid_list_get(ptr %p0, i64 9)
%t8953 = call i64 @resid_unbox_i64(ptr %t8952)
%t8955 = call ptr @resid_list_get(ptr %p0, i64 10)
%t8956 = call i64 @resid_unbox_i64(ptr %t8955)
%t8958 = call ptr @resid_list_get(ptr %p0, i64 11)
%t8959 = call i64 @resid_unbox_i64(ptr %t8958)
%t8961 = call ptr @resid_list_get(ptr %p0, i64 13)
%t8962 = call i64 @resid_unbox_i64(ptr %t8961)
%t8964 = call ptr @resid_list_get(ptr %p0, i64 14)
%t8965 = call i64 @resid_unbox_i64(ptr %t8964)
%t8967 = call ptr @resid_list_get(ptr %p0, i64 15)
%t8968 = call i64 @resid_unbox_i64(ptr %t8967)
%t8970 = call ptr @__m____________lib_chachag_resid__cg_core__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 10, i64 %t8926, i64 %t8929, i64 %t8932, i64 %t8935, i64 %t8938, i64 %t8941, i64 %t8944, i64 %t8947, i64 %t8950, i64 %t8953, i64 %t8956, i64 %t8959, i64 %p1, i64 %t8962, i64 %t8965, i64 %t8968)
ret ptr %t8970
}
define ptr @__m____________lib_chachag_resid__cg_ser__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8973, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8984, %tco.s0 ]
%t8971 = icmp sge i64 %p1, 64
br i1 %t8971, label %L979, label %L981
L979:
%t8972 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8972)
ret ptr %t8972
L981:
%t8973 = add nsw i64 %p1, 1
%t8974 = sdiv i64 %p1, 4
%t8975 = call ptr @resid_list_get_v(ptr %p0, i64 %t8974, ptr %p0.ld, i64 %p0.ln)
%t8976 = call i64 @resid_unbox_i64(ptr %t8975)
%t8978 = srem i64 %p1, 4
%t8979 = mul nsw i64 %t8978, 8
%t8980 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8976, i64 %t8979)
%t8981 = call ptr @resid_box_i64(i64 %t8980)
%t8984 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8981)
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t8987, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi ptr [ %p5.in, %entry ], [ %t9006, %tco.s0 ]
%t8986 = icmp sge i64 %p3, %p4
br i1 %t8986, label %L982, label %L984
L982:
ret ptr %p5
L984:
%t8987 = add nsw i64 %p3, 1
%t8988 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %p3)
%t8989 = extractvalue {i64, i1} %t8988, 0
%t8990 = extractvalue {i64, i1} %t8988, 1
%t8991 = zext i1 %t8990 to i8
call void @resid_overflow_check(i8 %t8991)
%t8992 = call ptr @resid_list_get_v(ptr %p1, i64 %t8989, ptr %p1.ld, i64 %p1.ln)
%t8993 = call i64 @resid_unbox_i64(ptr %t8992)
%t8995 = sdiv i64 %p3, 4
%t8996 = call ptr @resid_list_get_v(ptr %p0, i64 %t8995, ptr %p0.ld, i64 %p0.ln)
%t8997 = call i64 @resid_unbox_i64(ptr %t8996)
%t8999 = srem i64 %p3, 4
%t9000 = mul nsw i64 %t8999, 8
%t9001 = call i64 @__m____________lib_word_resid__wi_byte(i64 %t8997, i64 %t9000)
%t9002 = call i64 @__m____________lib_word_resid__bi_xor(i64 %t8993, i64 %t9001)
%t9003 = call ptr @resid_box_i64(i64 %t9002)
%t9006 = call ptr @resid_listbuf_push(ptr %p5, ptr %t9003)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m____________lib_chachag_resid__pg_reduce__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9008 = sext i256 1361129467683753853853498429727072845823 to i512
%t9009 = call i512 @__m____________lib_word_resid__pi_and(i512 %p0, i512 %t9008)
%t9010 = call i512 @__m____________lib_word_resid__pi_shr(i512 %p0, i64 130)
%t9011 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t9010, i512 5)
%t9012 = call i512 @__m____________lib_word_resid__pi_add(i512 %t9009, i512 %t9011)
%t9013 = sext i256 1361129467683753853853498429727072845823 to i512
%t9014 = call i512 @__m____________lib_word_resid__pi_and(i512 %t9012, i512 %t9013)
%t9015 = call i512 @__m____________lib_word_resid__pi_shr(i512 %t9012, i64 130)
%t9016 = call i512 @__m____________lib_word_resid__pi_mul(i512 %t9015, i512 5)
%t9017 = call i512 @__m____________lib_word_resid__pi_add(i512 %t9014, i512 %t9016)
%t9018 = sext i256 1361129467683753853853498429727072845819 to i512
%t9019 = call i512 @__m____________lib_word_resid__pi_sub(i512 %t9017, i512 %t9018)
%t9020 = call i512 @__m____________lib_word_resid__pi_sign(i512 %t9019)
%t9021 = call i512 @__m____________lib_word_resid__pi_and(i512 %t9017, i512 %t9020)
%t9022 = sext i64 -1 to i512
%t9023 = call i512 @__m____________lib_word_resid__pi_xor(i512 %t9020, i512 %t9022)
%t9024 = call i512 @__m____________lib_word_resid__pi_and(i512 %t9019, i512 %t9023)
%t9025 = call i512 @__m____________lib_word_resid__pi_or(i512 %t9021, i512 %t9024)
ret i512 %t9025
}
define i64 @__m____________lib_sha256g_resid__g_word_at__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9026 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t9027 = extractvalue {i64, i1} %t9026, 0
%t9028 = extractvalue {i64, i1} %t9026, 1
%t9029 = zext i1 %t9028 to i8
call void @resid_overflow_check(i8 %t9029)
%t9030 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t9027)
%t9031 = extractvalue {i64, i1} %t9030, 0
%t9032 = extractvalue {i64, i1} %t9030, 1
%t9033 = zext i1 %t9032 to i8
call void @resid_overflow_check(i8 %t9033)
%t9034 = call ptr @resid_list_get(ptr %p0, i64 %t9031)
%t9035 = call i64 @resid_unbox_i64(ptr %t9034)
%t9037 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9035)
%t9038 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9037, i64 24)
%t9039 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t9031, i64 1)
%t9040 = extractvalue {i64, i1} %t9039, 0
%t9041 = extractvalue {i64, i1} %t9039, 1
%t9042 = zext i1 %t9041 to i8
call void @resid_overflow_check(i8 %t9042)
%t9043 = call ptr @resid_list_get(ptr %p0, i64 %t9040)
%t9044 = call i64 @resid_unbox_i64(ptr %t9043)
%t9046 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9044)
%t9047 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9046, i64 16)
%t9048 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9038, i64 %t9047)
%t9049 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t9031, i64 2)
%t9050 = extractvalue {i64, i1} %t9049, 0
%t9051 = extractvalue {i64, i1} %t9049, 1
%t9052 = zext i1 %t9051 to i8
call void @resid_overflow_check(i8 %t9052)
%t9053 = call ptr @resid_list_get(ptr %p0, i64 %t9050)
%t9054 = call i64 @resid_unbox_i64(ptr %t9053)
%t9056 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9054)
%t9057 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9056, i64 8)
%t9058 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t9031, i64 3)
%t9059 = extractvalue {i64, i1} %t9058, 0
%t9060 = extractvalue {i64, i1} %t9058, 1
%t9061 = zext i1 %t9060 to i8
call void @resid_overflow_check(i8 %t9061)
%t9062 = call ptr @resid_list_get(ptr %p0, i64 %t9059)
%t9063 = call i64 @resid_unbox_i64(ptr %t9062)
%t9065 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9063)
%t9066 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9057, i64 %t9065)
%t9067 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9048, i64 %t9066)
ret i64 %t9067
}
define i64 @__m____________lib_sha256g_resid__g_ssig1__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9068 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 17)
%t9069 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 19)
%t9070 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9068, i64 %t9069)
%t9071 = call i64 @__m____________lib_word_resid__wi_shr(i64 %p0, i64 10)
%t9072 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9070, i64 %t9071)
ret i64 %t9072
}
define i64 @__m____________lib_sha256g_resid__g_ssig0__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9073 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 7)
%t9074 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %p0, i64 18)
%t9075 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9073, i64 %t9074)
%t9076 = call i64 @__m____________lib_word_resid__wi_shr(i64 %p0, i64 3)
%t9077 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9075, i64 %t9076)
ret i64 %t9077
}
define i64 @b64g_sextet__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9078 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 65, i64 90)
%t9079 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 97, i64 122)
%t9080 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 48, i64 57)
%t9081 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 43, i64 43)
%t9082 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 47, i64 47)
%t9083 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9078)
%t9084 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 -65)
%t9085 = call i64 @__m____________lib_word_resid__wi_and(i64 %t9083, i64 %t9084)
%t9086 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9079)
%t9087 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 -71)
%t9088 = call i64 @__m____________lib_word_resid__wi_and(i64 %t9086, i64 %t9087)
%t9089 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9085, i64 %t9088)
%t9090 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9080)
%t9091 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 4)
%t9092 = call i64 @__m____________lib_word_resid__wi_and(i64 %t9090, i64 %t9091)
%t9093 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9081)
%t9094 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t9093, i64 62)
%t9095 = call i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t9082)
%t9096 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t9095, i64 63)
%t9097 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9094, i64 %t9096)
%t9098 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9092, i64 %t9097)
%t9099 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9078, i64 %t9079)
%t9100 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9081, i64 %t9082)
%t9101 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9080, i64 %t9100)
%t9102 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9099, i64 %t9101)
%t9103 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9089, i64 %t9098)
%t9104 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t9103, i64 63)
%t9105 = call i64 @__m____________lib_word_resid__wi_xork(i64 %t9102, i64 1)
%t9106 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9105, i64 8)
%t9107 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9104, i64 %t9106)
ret i64 %t9107
}
define ptr @__m____________lib_sha512g_resid__g5_lift_state__g_UInt_64__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9108 = call ptr @resid_gmalloc(i64 64)
%t9109 = call ptr @resid_list_get(ptr %p0, i64 0)
%t9110 = call i64 @resid_unbox_i64(ptr %t9109)
%t9112 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9110)
%t9108.f0 = getelementptr i8, ptr %t9108, i64 0
store i64 %t9112, ptr %t9108.f0, align 8
%t9113 = call ptr @resid_list_get(ptr %p0, i64 1)
%t9114 = call i64 @resid_unbox_i64(ptr %t9113)
%t9116 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9114)
%t9108.f1 = getelementptr i8, ptr %t9108, i64 8
store i64 %t9116, ptr %t9108.f1, align 8
%t9117 = call ptr @resid_list_get(ptr %p0, i64 2)
%t9118 = call i64 @resid_unbox_i64(ptr %t9117)
%t9120 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9118)
%t9108.f2 = getelementptr i8, ptr %t9108, i64 16
store i64 %t9120, ptr %t9108.f2, align 8
%t9121 = call ptr @resid_list_get(ptr %p0, i64 3)
%t9122 = call i64 @resid_unbox_i64(ptr %t9121)
%t9124 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9122)
%t9108.f3 = getelementptr i8, ptr %t9108, i64 24
store i64 %t9124, ptr %t9108.f3, align 8
%t9125 = call ptr @resid_list_get(ptr %p0, i64 4)
%t9126 = call i64 @resid_unbox_i64(ptr %t9125)
%t9128 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9126)
%t9108.f4 = getelementptr i8, ptr %t9108, i64 32
store i64 %t9128, ptr %t9108.f4, align 8
%t9129 = call ptr @resid_list_get(ptr %p0, i64 5)
%t9130 = call i64 @resid_unbox_i64(ptr %t9129)
%t9132 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9130)
%t9108.f5 = getelementptr i8, ptr %t9108, i64 40
store i64 %t9132, ptr %t9108.f5, align 8
%t9133 = call ptr @resid_list_get(ptr %p0, i64 6)
%t9134 = call i64 @resid_unbox_i64(ptr %t9133)
%t9136 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9134)
%t9108.f6 = getelementptr i8, ptr %t9108, i64 48
store i64 %t9136, ptr %t9108.f6, align 8
%t9137 = call ptr @resid_list_get(ptr %p0, i64 7)
%t9138 = call i64 @resid_unbox_i64(ptr %t9137)
%t9140 = call i64 @__m____________lib_word_resid__di_lift(i64 %t9138)
%t9108.f7 = getelementptr i8, ptr %t9108, i64 56
store i64 %t9140, ptr %t9108.f7, align 8
ret ptr %t9108
}
define ptr @sha512g_blocks__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9143, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t9141 = icmp sge i64 %p1, %p2
br i1 %t9141, label %L985, label %L987
L985:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L987:
%t9142 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 128)
%t9143 = extractvalue {i64, i1} %t9142, 0
%t9144 = extractvalue {i64, i1} %t9142, 1
%t9145 = zext i1 %t9144 to i8
call void @resid_overflow_check(i8 %t9145)
%t9146 = call ptr @sha512g_block__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %p3)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %t9146, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t9146, %tco.s0 ]
br label %tco.head
}
define ptr @__m____________lib_sha512g_resid__g5_out__g_UInt_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9150, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t9160, %tco.s0 ]
%t9148 = icmp sge i64 %p2, %p1
br i1 %t9148, label %L988, label %L990
L988:
%t9149 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty9149)
ret ptr %t9149
L990:
%t9150 = add nsw i64 %p2, 1
%t9151 = sdiv i64 %p2, 8
%t9152 = call i64 @__m____________lib_sha512g_resid__g5_state_word__g_UInt_64__Int_64_(ptr %p0, i64 %t9151)
%t9153 = srem i64 %p2, 8
%t9154 = mul nsw i64 %t9153, 8
%t9155 = sub nsw i64 56, %t9154
%t9156 = call i64 @__m____________lib_word_resid__di_byte(i64 %t9152, i64 %t9155)
%t9157 = call ptr @resid_box_i64(i64 %t9156)
%t9160 = call ptr @resid_listbuf_push(ptr %p3, ptr %t9157)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9162 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t9163 = call i64 @resid_unbox_i64(ptr %t9162)
%t9165 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9163)
%t9166 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t9167 = extractvalue {i64, i1} %t9166, 0
%t9168 = extractvalue {i64, i1} %t9166, 1
%t9169 = zext i1 %t9168 to i8
call void @resid_overflow_check(i8 %t9169)
%t9170 = call ptr @resid_list_get(ptr %p0, i64 %t9167)
%t9171 = call i64 @resid_unbox_i64(ptr %t9170)
%t9173 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9171)
%t9174 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9173, i64 8)
%t9175 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9165, i64 %t9174)
%t9176 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t9177 = extractvalue {i64, i1} %t9176, 0
%t9178 = extractvalue {i64, i1} %t9176, 1
%t9179 = zext i1 %t9178 to i8
call void @resid_overflow_check(i8 %t9179)
%t9180 = call ptr @resid_list_get(ptr %p0, i64 %t9177)
%t9181 = call i64 @resid_unbox_i64(ptr %t9180)
%t9183 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9181)
%t9184 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9183, i64 16)
%t9185 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 3)
%t9186 = extractvalue {i64, i1} %t9185, 0
%t9187 = extractvalue {i64, i1} %t9185, 1
%t9188 = zext i1 %t9187 to i8
call void @resid_overflow_check(i8 %t9188)
%t9189 = call ptr @resid_list_get(ptr %p0, i64 %t9186)
%t9190 = call i64 @resid_unbox_i64(ptr %t9189)
%t9192 = call i64 @__m____________lib_word_resid__wi_from_byte(i64 %t9190)
%t9193 = call i64 @__m____________lib_word_resid__wi_shl(i64 %t9192, i64 24)
%t9194 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9184, i64 %t9193)
%t9195 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9175, i64 %t9194)
ret i64 %t9195
}
define ptr @__m____________lib_chachag_resid__cg_core__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9258 = alloca [16 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9406, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9363, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t9375, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t9387, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t9399, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %t9404, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t9368, %tco.s0.k ]
%p9 = phi i64 [ %p9.in, %entry ], [ %t9380, %tco.s0.k ]
%p10 = phi i64 [ %p10.in, %entry ], [ %t9392, %tco.s0.k ]
%p11 = phi i64 [ %p11.in, %entry ], [ %t9390, %tco.s0.k ]
%p12 = phi i64 [ %p12.in, %entry ], [ %t9402, %tco.s0.k ]
%p13 = phi i64 [ %p13.in, %entry ], [ %t9366, %tco.s0.k ]
%p14 = phi i64 [ %p14.in, %entry ], [ %t9378, %tco.s0.k ]
%p15 = phi i64 [ %p15.in, %entry ], [ %t9377, %tco.s0.k ]
%p16 = phi i64 [ %p16.in, %entry ], [ %t9389, %tco.s0.k ]
%p17 = phi i64 [ %p17.in, %entry ], [ %t9401, %tco.s0.k ]
%p18 = phi i64 [ %p18.in, %entry ], [ %t9365, %tco.s0.k ]
%t9196 = icmp eq i64 %p2, 0
br i1 %t9196, label %L991, label %L993
L991:
%t9197 = call ptr @resid_list_get_v(ptr %p0, i64 0, ptr %p0.ld, i64 %p0.ln)
%t9198 = call i64 @resid_unbox_i64(ptr %t9197)
%t9200 = call i64 @__m____________lib_word_resid__wi_add(i64 %p3, i64 %t9198)
%t9201 = call ptr @resid_list_get_v(ptr %p0, i64 1, ptr %p0.ld, i64 %p0.ln)
%t9202 = call i64 @resid_unbox_i64(ptr %t9201)
%t9204 = call i64 @__m____________lib_word_resid__wi_add(i64 %p4, i64 %t9202)
%t9205 = call ptr @resid_list_get_v(ptr %p0, i64 2, ptr %p0.ld, i64 %p0.ln)
%t9206 = call i64 @resid_unbox_i64(ptr %t9205)
%t9208 = call i64 @__m____________lib_word_resid__wi_add(i64 %p5, i64 %t9206)
%t9209 = call ptr @resid_list_get_v(ptr %p0, i64 3, ptr %p0.ld, i64 %p0.ln)
%t9210 = call i64 @resid_unbox_i64(ptr %t9209)
%t9212 = call i64 @__m____________lib_word_resid__wi_add(i64 %p6, i64 %t9210)
%t9213 = call ptr @resid_list_get_v(ptr %p0, i64 4, ptr %p0.ld, i64 %p0.ln)
%t9214 = call i64 @resid_unbox_i64(ptr %t9213)
%t9216 = call i64 @__m____________lib_word_resid__wi_add(i64 %p7, i64 %t9214)
%t9217 = call ptr @resid_list_get_v(ptr %p0, i64 5, ptr %p0.ld, i64 %p0.ln)
%t9218 = call i64 @resid_unbox_i64(ptr %t9217)
%t9220 = call i64 @__m____________lib_word_resid__wi_add(i64 %p8, i64 %t9218)
%t9221 = call ptr @resid_list_get_v(ptr %p0, i64 6, ptr %p0.ld, i64 %p0.ln)
%t9222 = call i64 @resid_unbox_i64(ptr %t9221)
%t9224 = call i64 @__m____________lib_word_resid__wi_add(i64 %p9, i64 %t9222)
%t9225 = call ptr @resid_list_get_v(ptr %p0, i64 7, ptr %p0.ld, i64 %p0.ln)
%t9226 = call i64 @resid_unbox_i64(ptr %t9225)
%t9228 = call i64 @__m____________lib_word_resid__wi_add(i64 %p10, i64 %t9226)
%t9229 = call ptr @resid_list_get_v(ptr %p0, i64 8, ptr %p0.ld, i64 %p0.ln)
%t9230 = call i64 @resid_unbox_i64(ptr %t9229)
%t9232 = call i64 @__m____________lib_word_resid__wi_add(i64 %p11, i64 %t9230)
%t9233 = call ptr @resid_list_get_v(ptr %p0, i64 9, ptr %p0.ld, i64 %p0.ln)
%t9234 = call i64 @resid_unbox_i64(ptr %t9233)
%t9236 = call i64 @__m____________lib_word_resid__wi_add(i64 %p12, i64 %t9234)
%t9237 = call ptr @resid_list_get_v(ptr %p0, i64 10, ptr %p0.ld, i64 %p0.ln)
%t9238 = call i64 @resid_unbox_i64(ptr %t9237)
%t9240 = call i64 @__m____________lib_word_resid__wi_add(i64 %p13, i64 %t9238)
%t9241 = call ptr @resid_list_get_v(ptr %p0, i64 11, ptr %p0.ld, i64 %p0.ln)
%t9242 = call i64 @resid_unbox_i64(ptr %t9241)
%t9244 = call i64 @__m____________lib_word_resid__wi_add(i64 %p14, i64 %t9242)
%t9245 = call i64 @__m____________lib_word_resid__wi_add(i64 %p15, i64 %p1)
%t9246 = call ptr @resid_list_get_v(ptr %p0, i64 13, ptr %p0.ld, i64 %p0.ln)
%t9247 = call i64 @resid_unbox_i64(ptr %t9246)
%t9249 = call i64 @__m____________lib_word_resid__wi_add(i64 %p16, i64 %t9247)
%t9250 = call ptr @resid_list_get_v(ptr %p0, i64 14, ptr %p0.ld, i64 %p0.ln)
%t9251 = call i64 @resid_unbox_i64(ptr %t9250)
%t9253 = call i64 @__m____________lib_word_resid__wi_add(i64 %p17, i64 %t9251)
%t9254 = call ptr @resid_list_get_v(ptr %p0, i64 15, ptr %p0.ld, i64 %p0.ln)
%t9255 = call i64 @resid_unbox_i64(ptr %t9254)
%t9257 = call i64 @__m____________lib_word_resid__wi_add(i64 %p18, i64 %t9255)
%t9260 = call ptr @resid_box_i64(i64 %t9200)
%t9262 = getelementptr i8, ptr %t9258, i64 0
store ptr %t9260, ptr %t9262
%t9263 = call ptr @resid_box_i64(i64 %t9204)
%t9265 = getelementptr i8, ptr %t9258, i64 8
store ptr %t9263, ptr %t9265
%t9266 = call ptr @resid_box_i64(i64 %t9208)
%t9268 = getelementptr i8, ptr %t9258, i64 16
store ptr %t9266, ptr %t9268
%t9269 = call ptr @resid_box_i64(i64 %t9212)
%t9271 = getelementptr i8, ptr %t9258, i64 24
store ptr %t9269, ptr %t9271
%t9272 = call ptr @resid_box_i64(i64 %t9216)
%t9274 = getelementptr i8, ptr %t9258, i64 32
store ptr %t9272, ptr %t9274
%t9275 = call ptr @resid_box_i64(i64 %t9220)
%t9277 = getelementptr i8, ptr %t9258, i64 40
store ptr %t9275, ptr %t9277
%t9278 = call ptr @resid_box_i64(i64 %t9224)
%t9280 = getelementptr i8, ptr %t9258, i64 48
store ptr %t9278, ptr %t9280
%t9281 = call ptr @resid_box_i64(i64 %t9228)
%t9283 = getelementptr i8, ptr %t9258, i64 56
store ptr %t9281, ptr %t9283
%t9284 = call ptr @resid_box_i64(i64 %t9232)
%t9286 = getelementptr i8, ptr %t9258, i64 64
store ptr %t9284, ptr %t9286
%t9287 = call ptr @resid_box_i64(i64 %t9236)
%t9289 = getelementptr i8, ptr %t9258, i64 72
store ptr %t9287, ptr %t9289
%t9290 = call ptr @resid_box_i64(i64 %t9240)
%t9292 = getelementptr i8, ptr %t9258, i64 80
store ptr %t9290, ptr %t9292
%t9293 = call ptr @resid_box_i64(i64 %t9244)
%t9295 = getelementptr i8, ptr %t9258, i64 88
store ptr %t9293, ptr %t9295
%t9296 = call ptr @resid_box_i64(i64 %t9245)
%t9298 = getelementptr i8, ptr %t9258, i64 96
store ptr %t9296, ptr %t9298
%t9299 = call ptr @resid_box_i64(i64 %t9249)
%t9301 = getelementptr i8, ptr %t9258, i64 104
store ptr %t9299, ptr %t9301
%t9302 = call ptr @resid_box_i64(i64 %t9253)
%t9304 = getelementptr i8, ptr %t9258, i64 112
store ptr %t9302, ptr %t9304
%t9305 = call ptr @resid_box_i64(i64 %t9257)
%t9307 = getelementptr i8, ptr %t9258, i64 120
store ptr %t9305, ptr %t9307
%t9308 = call ptr @resid_list_new(i64 16, ptr %t9258, ptr @.lty9258)
%lr.cx124 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz124 = icmp eq ptr %lr.cx124, null
br i1 %lr.lz124, label %lr.x124.k, label %lr.x124.m
lr.x124.k:
ret ptr %t9308
lr.x124.m:
%lr.ret124 = call ptr @resid_mv_list(ptr %t9308, ptr %lr.cx124)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret124
L993:
%t9309 = call i64 @__m____________lib_word_resid__wi_add(i64 %p3, i64 %p7)
%t9310 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p15, i64 %t9309)
%t9311 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9310, i64 16)
%t9312 = call i64 @__m____________lib_word_resid__wi_add(i64 %p11, i64 %t9311)
%t9313 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p7, i64 %t9312)
%t9314 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9313, i64 20)
%t9315 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9309, i64 %t9314)
%t9316 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9311, i64 %t9315)
%t9317 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9316, i64 24)
%t9318 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9312, i64 %t9317)
%t9319 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9314, i64 %t9318)
%t9320 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9319, i64 25)
%t9321 = call i64 @__m____________lib_word_resid__wi_add(i64 %p4, i64 %p8)
%t9322 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p16, i64 %t9321)
%t9323 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9322, i64 16)
%t9324 = call i64 @__m____________lib_word_resid__wi_add(i64 %p12, i64 %t9323)
%t9325 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p8, i64 %t9324)
%t9326 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9325, i64 20)
%t9327 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9321, i64 %t9326)
%t9328 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9323, i64 %t9327)
%t9329 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9328, i64 24)
%t9330 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9324, i64 %t9329)
%t9331 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9326, i64 %t9330)
%t9332 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9331, i64 25)
%t9333 = call i64 @__m____________lib_word_resid__wi_add(i64 %p5, i64 %p9)
%t9334 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p17, i64 %t9333)
%t9335 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9334, i64 16)
%t9336 = call i64 @__m____________lib_word_resid__wi_add(i64 %p13, i64 %t9335)
%t9337 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p9, i64 %t9336)
%t9338 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9337, i64 20)
%t9339 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9333, i64 %t9338)
%t9340 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9335, i64 %t9339)
%t9341 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9340, i64 24)
%t9342 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9336, i64 %t9341)
%t9343 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9338, i64 %t9342)
%t9344 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9343, i64 25)
%t9345 = call i64 @__m____________lib_word_resid__wi_add(i64 %p6, i64 %p10)
%t9346 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p18, i64 %t9345)
%t9347 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9346, i64 16)
%t9348 = call i64 @__m____________lib_word_resid__wi_add(i64 %p14, i64 %t9347)
%t9349 = call i64 @__m____________lib_word_resid__wi_xor(i64 %p10, i64 %t9348)
%t9350 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9349, i64 20)
%t9351 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9345, i64 %t9350)
%t9352 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9347, i64 %t9351)
%t9353 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9352, i64 24)
%t9354 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9348, i64 %t9353)
%t9355 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9350, i64 %t9354)
%t9356 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9355, i64 25)
%t9357 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9315, i64 %t9332)
%t9358 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9353, i64 %t9357)
%t9359 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9358, i64 16)
%t9360 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9342, i64 %t9359)
%t9361 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9332, i64 %t9360)
%t9362 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9361, i64 20)
%t9363 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9357, i64 %t9362)
%t9364 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9359, i64 %t9363)
%t9365 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9364, i64 24)
%t9366 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9360, i64 %t9365)
%t9367 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9362, i64 %t9366)
%t9368 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9367, i64 25)
%t9369 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9327, i64 %t9344)
%t9370 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9317, i64 %t9369)
%t9371 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9370, i64 16)
%t9372 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9354, i64 %t9371)
%t9373 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9344, i64 %t9372)
%t9374 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9373, i64 20)
%t9375 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9369, i64 %t9374)
%t9376 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9371, i64 %t9375)
%t9377 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9376, i64 24)
%t9378 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9372, i64 %t9377)
%t9379 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9374, i64 %t9378)
%t9380 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9379, i64 25)
%t9381 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9339, i64 %t9356)
%t9382 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9329, i64 %t9381)
%t9383 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9382, i64 16)
%t9384 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9318, i64 %t9383)
%t9385 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9356, i64 %t9384)
%t9386 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9385, i64 20)
%t9387 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9381, i64 %t9386)
%t9388 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9383, i64 %t9387)
%t9389 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9388, i64 24)
%t9390 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9384, i64 %t9389)
%t9391 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9386, i64 %t9390)
%t9392 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9391, i64 25)
%t9393 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9351, i64 %t9320)
%t9394 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9341, i64 %t9393)
%t9395 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9394, i64 16)
%t9396 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9330, i64 %t9395)
%t9397 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9320, i64 %t9396)
%t9398 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9397, i64 20)
%t9399 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9393, i64 %t9398)
%t9400 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9395, i64 %t9399)
%t9401 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9400, i64 24)
%t9402 = call i64 @__m____________lib_word_resid__wi_add(i64 %t9396, i64 %t9401)
%t9403 = call i64 @__m____________lib_word_resid__wi_xor(i64 %t9398, i64 %t9402)
%t9404 = call i64 @__m____________lib_word_resid__wi_rotr(i64 %t9403, i64 25)
%t9405 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 1)
%t9406 = extractvalue {i64, i1} %t9405, 0
%t9407 = extractvalue {i64, i1} %t9405, 1
%t9408 = zext i1 %t9407 to i8
call void @resid_overflow_check(i8 %t9408)
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
%t9410 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p1)
%t9411 = extractvalue {i64, i1} %t9410, 0
%t9412 = extractvalue {i64, i1} %t9410, 1
%t9413 = zext i1 %t9412 to i8
call void @resid_overflow_check(i8 %t9413)
%t9414 = call i64 @__m____________lib_word_resid__wi_addk(i64 %p0, i64 %t9411)
%t9415 = call i64 @__m____________lib_word_resid__wi_not(i64 %p0)
%t9416 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t9417 = extractvalue {i64, i1} %t9416, 0
%t9418 = extractvalue {i64, i1} %t9416, 1
%t9419 = zext i1 %t9418 to i8
call void @resid_overflow_check(i8 %t9419)
%t9420 = call i64 @__m____________lib_word_resid__wi_addk(i64 %t9415, i64 %t9417)
%t9421 = call i64 @__m____________lib_word_resid__wi_or(i64 %t9414, i64 %t9420)
%t9422 = call i64 @__m____________lib_word_resid__wi_shr(i64 %t9421, i64 31)
%t9423 = call i64 @__m____________lib_word_resid__wi_andk(i64 %t9422, i64 1)
%t9424 = call i64 @__m____________lib_word_resid__wi_xork(i64 %t9423, i64 1)
ret i64 %t9424
}
define i64 @__m____________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9425 = call i64 @__m____________lib_word_resid__wi_not(i64 %p0)
%t9426 = call i64 @__m____________lib_word_resid__wi_addk(i64 %t9425, i64 1)
ret i64 %t9426
}
define ptr @sha512g_block__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9427 = add i64 4794697086780616226, 0
%t9428 = add i64 %t9427, 0
%t9429 = add i64 %t9428, 0
%t9430 = icmp ne i64 %t9429, %t9427
%t9431 = icmp slt i64 4794697086780616226, 0
%t9432 = or i1 %t9430, %t9431
%t9433 = zext i1 %t9432 to i8
call void @resid_conv_check(i8 %t9433)
%t9434 = add i64 8158064640168781261, 0
%t9435 = add i64 %t9434, 0
%t9436 = add i64 %t9435, 0
%t9437 = icmp ne i64 %t9436, %t9434
%t9438 = icmp slt i64 8158064640168781261, 0
%t9439 = or i1 %t9437, %t9438
%t9440 = zext i1 %t9439 to i8
call void @resid_conv_check(i8 %t9440)
%t9441 = add i128 13096744586834688815, 0
%t9442 = trunc i128 %t9441 to i64
%t9443 = zext i64 %t9442 to i128
%t9444 = icmp ne i128 %t9443, %t9441
%t9445 = icmp slt i128 13096744586834688815, 0
%t9446 = or i1 %t9444, %t9445
%t9447 = zext i1 %t9446 to i8
call void @resid_conv_check(i8 %t9447)
%t9448 = add i128 16840607885511220156, 0
%t9449 = trunc i128 %t9448 to i64
%t9450 = zext i64 %t9449 to i128
%t9451 = icmp ne i128 %t9450, %t9448
%t9452 = icmp slt i128 16840607885511220156, 0
%t9453 = or i1 %t9451, %t9452
%t9454 = zext i1 %t9453 to i8
call void @resid_conv_check(i8 %t9454)
%t9455 = add i64 4131703408338449720, 0
%t9456 = add i64 %t9455, 0
%t9457 = add i64 %t9456, 0
%t9458 = icmp ne i64 %t9457, %t9455
%t9459 = icmp slt i64 4131703408338449720, 0
%t9460 = or i1 %t9458, %t9459
%t9461 = zext i1 %t9460 to i8
call void @resid_conv_check(i8 %t9461)
%t9462 = add i64 6480981068601479193, 0
%t9463 = add i64 %t9462, 0
%t9464 = add i64 %t9463, 0
%t9465 = icmp ne i64 %t9464, %t9462
%t9466 = icmp slt i64 6480981068601479193, 0
%t9467 = or i1 %t9465, %t9466
%t9468 = zext i1 %t9467 to i8
call void @resid_conv_check(i8 %t9468)
%t9469 = add i128 10538285296894168987, 0
%t9470 = trunc i128 %t9469 to i64
%t9471 = zext i64 %t9470 to i128
%t9472 = icmp ne i128 %t9471, %t9469
%t9473 = icmp slt i128 10538285296894168987, 0
%t9474 = or i1 %t9472, %t9473
%t9475 = zext i1 %t9474 to i8
call void @resid_conv_check(i8 %t9475)
%t9476 = add i128 12329834152419229976, 0
%t9477 = trunc i128 %t9476 to i64
%t9478 = zext i64 %t9477 to i128
%t9479 = icmp ne i128 %t9478, %t9476
%t9480 = icmp slt i128 12329834152419229976, 0
%t9481 = or i1 %t9479, %t9480
%t9482 = zext i1 %t9481 to i8
call void @resid_conv_check(i8 %t9482)
%t9483 = add i128 15566598209576043074, 0
%t9484 = trunc i128 %t9483 to i64
%t9485 = zext i64 %t9484 to i128
%t9486 = icmp ne i128 %t9485, %t9483
%t9487 = icmp slt i128 15566598209576043074, 0
%t9488 = or i1 %t9486, %t9487
%t9489 = zext i1 %t9488 to i8
call void @resid_conv_check(i8 %t9489)
%t9490 = add i64 1334009975649890238, 0
%t9491 = add i64 %t9490, 0
%t9492 = add i64 %t9491, 0
%t9493 = icmp ne i64 %t9492, %t9490
%t9494 = icmp slt i64 1334009975649890238, 0
%t9495 = or i1 %t9493, %t9494
%t9496 = zext i1 %t9495 to i8
call void @resid_conv_check(i8 %t9496)
%t9497 = add i64 2608012711638119052, 0
%t9498 = add i64 %t9497, 0
%t9499 = add i64 %t9498, 0
%t9500 = icmp ne i64 %t9499, %t9497
%t9501 = icmp slt i64 2608012711638119052, 0
%t9502 = or i1 %t9500, %t9501
%t9503 = zext i1 %t9502 to i8
call void @resid_conv_check(i8 %t9503)
%t9504 = add i64 6128411473006802146, 0
%t9505 = add i64 %t9504, 0
%t9506 = add i64 %t9505, 0
%t9507 = icmp ne i64 %t9506, %t9504
%t9508 = icmp slt i64 6128411473006802146, 0
%t9509 = or i1 %t9507, %t9508
%t9510 = zext i1 %t9509 to i8
call void @resid_conv_check(i8 %t9510)
%t9511 = add i64 8268148722764581231, 0
%t9512 = add i64 %t9511, 0
%t9513 = add i64 %t9512, 0
%t9514 = icmp ne i64 %t9513, %t9511
%t9515 = icmp slt i64 8268148722764581231, 0
%t9516 = or i1 %t9514, %t9515
%t9517 = zext i1 %t9516 to i8
call void @resid_conv_check(i8 %t9517)
%t9518 = add i128 9286055187155687089, 0
%t9519 = trunc i128 %t9518 to i64
%t9520 = zext i64 %t9519 to i128
%t9521 = icmp ne i128 %t9520, %t9518
%t9522 = icmp slt i128 9286055187155687089, 0
%t9523 = or i1 %t9521, %t9522
%t9524 = zext i1 %t9523 to i8
call void @resid_conv_check(i8 %t9524)
%t9525 = add i128 11230858885718282805, 0
%t9526 = trunc i128 %t9525 to i64
%t9527 = zext i64 %t9526 to i128
%t9528 = icmp ne i128 %t9527, %t9525
%t9529 = icmp slt i128 11230858885718282805, 0
%t9530 = or i1 %t9528, %t9529
%t9531 = zext i1 %t9530 to i8
call void @resid_conv_check(i8 %t9531)
%t9532 = add i128 13951009754708518548, 0
%t9533 = trunc i128 %t9532 to i64
%t9534 = zext i64 %t9533 to i128
%t9535 = icmp ne i128 %t9534, %t9532
%t9536 = icmp slt i128 13951009754708518548, 0
%t9537 = or i1 %t9535, %t9536
%t9538 = zext i1 %t9537 to i8
call void @resid_conv_check(i8 %t9538)
%t9539 = add i128 16472876342353939154, 0
%t9540 = trunc i128 %t9539 to i64
%t9541 = zext i64 %t9540 to i128
%t9542 = icmp ne i128 %t9541, %t9539
%t9543 = icmp slt i128 16472876342353939154, 0
%t9544 = or i1 %t9542, %t9543
%t9545 = zext i1 %t9544 to i8
call void @resid_conv_check(i8 %t9545)
%t9546 = add i128 17275323862435702243, 0
%t9547 = trunc i128 %t9546 to i64
%t9548 = zext i64 %t9547 to i128
%t9549 = icmp ne i128 %t9548, %t9546
%t9550 = icmp slt i128 17275323862435702243, 0
%t9551 = or i1 %t9549, %t9550
%t9552 = zext i1 %t9551 to i8
call void @resid_conv_check(i8 %t9552)
%t9553 = add i64 1135362057144423861, 0
%t9554 = add i64 %t9553, 0
%t9555 = add i64 %t9554, 0
%t9556 = icmp ne i64 %t9555, %t9553
%t9557 = icmp slt i64 1135362057144423861, 0
%t9558 = or i1 %t9556, %t9557
%t9559 = zext i1 %t9558 to i8
call void @resid_conv_check(i8 %t9559)
%t9560 = add i64 2597628984639134821, 0
%t9561 = add i64 %t9560, 0
%t9562 = add i64 %t9561, 0
%t9563 = icmp ne i64 %t9562, %t9560
%t9564 = icmp slt i64 2597628984639134821, 0
%t9565 = or i1 %t9563, %t9564
%t9566 = zext i1 %t9565 to i8
call void @resid_conv_check(i8 %t9566)
%t9567 = add i64 3308224258029322869, 0
%t9568 = add i64 %t9567, 0
%t9569 = add i64 %t9568, 0
%t9570 = icmp ne i64 %t9569, %t9567
%t9571 = icmp slt i64 3308224258029322869, 0
%t9572 = or i1 %t9570, %t9571
%t9573 = zext i1 %t9572 to i8
call void @resid_conv_check(i8 %t9573)
%t9574 = add i64 5365058923640841347, 0
%t9575 = add i64 %t9574, 0
%t9576 = add i64 %t9575, 0
%t9577 = icmp ne i64 %t9576, %t9574
%t9578 = icmp slt i64 5365058923640841347, 0
%t9579 = or i1 %t9577, %t9578
%t9580 = zext i1 %t9579 to i8
call void @resid_conv_check(i8 %t9580)
%t9581 = add i64 6679025012923562964, 0
%t9582 = add i64 %t9581, 0
%t9583 = add i64 %t9582, 0
%t9584 = icmp ne i64 %t9583, %t9581
%t9585 = icmp slt i64 6679025012923562964, 0
%t9586 = or i1 %t9584, %t9585
%t9587 = zext i1 %t9586 to i8
call void @resid_conv_check(i8 %t9587)
%t9588 = add i64 8573033837759648693, 0
%t9589 = add i64 %t9588, 0
%t9590 = add i64 %t9589, 0
%t9591 = icmp ne i64 %t9590, %t9588
%t9592 = icmp slt i64 8573033837759648693, 0
%t9593 = or i1 %t9591, %t9592
%t9594 = zext i1 %t9593 to i8
call void @resid_conv_check(i8 %t9594)
%t9595 = add i128 10970295158949994411, 0
%t9596 = trunc i128 %t9595 to i64
%t9597 = zext i64 %t9596 to i128
%t9598 = icmp ne i128 %t9597, %t9595
%t9599 = icmp slt i128 10970295158949994411, 0
%t9600 = or i1 %t9598, %t9599
%t9601 = zext i1 %t9600 to i8
call void @resid_conv_check(i8 %t9601)
%t9602 = add i128 12119686244451234320, 0
%t9603 = trunc i128 %t9602 to i64
%t9604 = zext i64 %t9603 to i128
%t9605 = icmp ne i128 %t9604, %t9602
%t9606 = icmp slt i128 12119686244451234320, 0
%t9607 = or i1 %t9605, %t9606
%t9608 = zext i1 %t9607 to i8
call void @resid_conv_check(i8 %t9608)
%t9609 = add i128 12683024718118986047, 0
%t9610 = trunc i128 %t9609 to i64
%t9611 = zext i64 %t9610 to i128
%t9612 = icmp ne i128 %t9611, %t9609
%t9613 = icmp slt i128 12683024718118986047, 0
%t9614 = or i1 %t9612, %t9613
%t9615 = zext i1 %t9614 to i8
call void @resid_conv_check(i8 %t9615)
%t9616 = add i128 13788192230050041572, 0
%t9617 = trunc i128 %t9616 to i64
%t9618 = zext i64 %t9617 to i128
%t9619 = icmp ne i128 %t9618, %t9616
%t9620 = icmp slt i128 13788192230050041572, 0
%t9621 = or i1 %t9619, %t9620
%t9622 = zext i1 %t9621 to i8
call void @resid_conv_check(i8 %t9622)
%t9623 = add i128 14330467153632333762, 0
%t9624 = trunc i128 %t9623 to i64
%t9625 = zext i64 %t9624 to i128
%t9626 = icmp ne i128 %t9625, %t9623
%t9627 = icmp slt i128 14330467153632333762, 0
%t9628 = or i1 %t9626, %t9627
%t9629 = zext i1 %t9628 to i8
call void @resid_conv_check(i8 %t9629)
%t9630 = add i128 15395433587784984357, 0
%t9631 = trunc i128 %t9630 to i64
%t9632 = zext i64 %t9631 to i128
%t9633 = icmp ne i128 %t9632, %t9630
%t9634 = icmp slt i128 15395433587784984357, 0
%t9635 = or i1 %t9633, %t9634
%t9636 = zext i1 %t9635 to i8
call void @resid_conv_check(i8 %t9636)
%t9637 = add i64 1452737877330783856, 0
%t9638 = add i64 %t9637, 0
%t9639 = add i64 %t9638, 0
%t9640 = icmp ne i64 %t9639, %t9637
%t9641 = icmp slt i64 1452737877330783856, 0
%t9642 = or i1 %t9640, %t9641
%t9643 = zext i1 %t9642 to i8
call void @resid_conv_check(i8 %t9643)
%t9644 = add i64 2861767655752347644, 0
%t9645 = add i64 %t9644, 0
%t9646 = add i64 %t9645, 0
%t9647 = icmp ne i64 %t9646, %t9644
%t9648 = icmp slt i64 2861767655752347644, 0
%t9649 = or i1 %t9647, %t9648
%t9650 = zext i1 %t9649 to i8
call void @resid_conv_check(i8 %t9650)
%t9651 = add i64 3322285676063803686, 0
%t9652 = add i64 %t9651, 0
%t9653 = add i64 %t9652, 0
%t9654 = icmp ne i64 %t9653, %t9651
%t9655 = icmp slt i64 3322285676063803686, 0
%t9656 = or i1 %t9654, %t9655
%t9657 = zext i1 %t9656 to i8
call void @resid_conv_check(i8 %t9657)
%t9658 = add i64 5560940570517711597, 0
%t9659 = add i64 %t9658, 0
%t9660 = add i64 %t9659, 0
%t9661 = icmp ne i64 %t9660, %t9658
%t9662 = icmp slt i64 5560940570517711597, 0
%t9663 = or i1 %t9661, %t9662
%t9664 = zext i1 %t9663 to i8
call void @resid_conv_check(i8 %t9664)
%t9665 = add i64 5996557281743188959, 0
%t9666 = add i64 %t9665, 0
%t9667 = add i64 %t9666, 0
%t9668 = icmp ne i64 %t9667, %t9665
%t9669 = icmp slt i64 5996557281743188959, 0
%t9670 = or i1 %t9668, %t9669
%t9671 = zext i1 %t9670 to i8
call void @resid_conv_check(i8 %t9671)
%t9672 = add i64 7280758554555802590, 0
%t9673 = add i64 %t9672, 0
%t9674 = add i64 %t9673, 0
%t9675 = icmp ne i64 %t9674, %t9672
%t9676 = icmp slt i64 7280758554555802590, 0
%t9677 = or i1 %t9675, %t9676
%t9678 = zext i1 %t9677 to i8
call void @resid_conv_check(i8 %t9678)
%t9679 = add i64 8532644243296465576, 0
%t9680 = add i64 %t9679, 0
%t9681 = add i64 %t9680, 0
%t9682 = icmp ne i64 %t9681, %t9679
%t9683 = icmp slt i64 8532644243296465576, 0
%t9684 = or i1 %t9682, %t9683
%t9685 = zext i1 %t9684 to i8
call void @resid_conv_check(i8 %t9685)
%t9686 = add i128 9350256976987008742, 0
%t9687 = trunc i128 %t9686 to i64
%t9688 = zext i64 %t9687 to i128
%t9689 = icmp ne i128 %t9688, %t9686
%t9690 = icmp slt i128 9350256976987008742, 0
%t9691 = or i1 %t9689, %t9690
%t9692 = zext i1 %t9691 to i8
call void @resid_conv_check(i8 %t9692)
%t9693 = add i128 10552545826968843579, 0
%t9694 = trunc i128 %t9693 to i64
%t9695 = zext i64 %t9694 to i128
%t9696 = icmp ne i128 %t9695, %t9693
%t9697 = icmp slt i128 10552545826968843579, 0
%t9698 = or i1 %t9696, %t9697
%t9699 = zext i1 %t9698 to i8
call void @resid_conv_check(i8 %t9699)
%t9700 = add i128 11727347734174303076, 0
%t9701 = trunc i128 %t9700 to i64
%t9702 = zext i64 %t9701 to i128
%t9703 = icmp ne i128 %t9702, %t9700
%t9704 = icmp slt i128 11727347734174303076, 0
%t9705 = or i1 %t9703, %t9704
%t9706 = zext i1 %t9705 to i8
call void @resid_conv_check(i8 %t9706)
%t9707 = add i128 12113106623233404929, 0
%t9708 = trunc i128 %t9707 to i64
%t9709 = zext i64 %t9708 to i128
%t9710 = icmp ne i128 %t9709, %t9707
%t9711 = icmp slt i128 12113106623233404929, 0
%t9712 = or i1 %t9710, %t9711
%t9713 = zext i1 %t9712 to i8
call void @resid_conv_check(i8 %t9713)
%t9714 = add i128 14000437183269869457, 0
%t9715 = trunc i128 %t9714 to i64
%t9716 = zext i64 %t9715 to i128
%t9717 = icmp ne i128 %t9716, %t9714
%t9718 = icmp slt i128 14000437183269869457, 0
%t9719 = or i1 %t9717, %t9718
%t9720 = zext i1 %t9719 to i8
call void @resid_conv_check(i8 %t9720)
%t9721 = add i128 14369950271660146224, 0
%t9722 = trunc i128 %t9721 to i64
%t9723 = zext i64 %t9722 to i128
%t9724 = icmp ne i128 %t9723, %t9721
%t9725 = icmp slt i128 14369950271660146224, 0
%t9726 = or i1 %t9724, %t9725
%t9727 = zext i1 %t9726 to i8
call void @resid_conv_check(i8 %t9727)
%t9728 = add i128 15101387698204529176, 0
%t9729 = trunc i128 %t9728 to i64
%t9730 = zext i64 %t9729 to i128
%t9731 = icmp ne i128 %t9730, %t9728
%t9732 = icmp slt i128 15101387698204529176, 0
%t9733 = or i1 %t9731, %t9732
%t9734 = zext i1 %t9733 to i8
call void @resid_conv_check(i8 %t9734)
%t9735 = add i128 15463397548674623760, 0
%t9736 = trunc i128 %t9735 to i64
%t9737 = zext i64 %t9736 to i128
%t9738 = icmp ne i128 %t9737, %t9735
%t9739 = icmp slt i128 15463397548674623760, 0
%t9740 = or i1 %t9738, %t9739
%t9741 = zext i1 %t9740 to i8
call void @resid_conv_check(i8 %t9741)
%t9742 = add i128 17586052441742319658, 0
%t9743 = trunc i128 %t9742 to i64
%t9744 = zext i64 %t9743 to i128
%t9745 = icmp ne i128 %t9744, %t9742
%t9746 = icmp slt i128 17586052441742319658, 0
%t9747 = or i1 %t9745, %t9746
%t9748 = zext i1 %t9747 to i8
call void @resid_conv_check(i8 %t9748)
%t9749 = add i64 1182934255886127544, 0
%t9750 = add i64 %t9749, 0
%t9751 = add i64 %t9750, 0
%t9752 = icmp ne i64 %t9751, %t9749
%t9753 = icmp slt i64 1182934255886127544, 0
%t9754 = or i1 %t9752, %t9753
%t9755 = zext i1 %t9754 to i8
call void @resid_conv_check(i8 %t9755)
%t9756 = add i64 1847814050463011016, 0
%t9757 = add i64 %t9756, 0
%t9758 = add i64 %t9757, 0
%t9759 = icmp ne i64 %t9758, %t9756
%t9760 = icmp slt i64 1847814050463011016, 0
%t9761 = or i1 %t9759, %t9760
%t9762 = zext i1 %t9761 to i8
call void @resid_conv_check(i8 %t9762)
%t9763 = add i64 2177327727835720531, 0
%t9764 = add i64 %t9763, 0
%t9765 = add i64 %t9764, 0
%t9766 = icmp ne i64 %t9765, %t9763
%t9767 = icmp slt i64 2177327727835720531, 0
%t9768 = or i1 %t9766, %t9767
%t9769 = zext i1 %t9768 to i8
call void @resid_conv_check(i8 %t9769)
%t9770 = add i64 2830643537854262169, 0
%t9771 = add i64 %t9770, 0
%t9772 = add i64 %t9771, 0
%t9773 = icmp ne i64 %t9772, %t9770
%t9774 = icmp slt i64 2830643537854262169, 0
%t9775 = or i1 %t9773, %t9774
%t9776 = zext i1 %t9775 to i8
call void @resid_conv_check(i8 %t9776)
%t9777 = add i64 3796741975233480872, 0
%t9778 = add i64 %t9777, 0
%t9779 = add i64 %t9778, 0
%t9780 = icmp ne i64 %t9779, %t9777
%t9781 = icmp slt i64 3796741975233480872, 0
%t9782 = or i1 %t9780, %t9781
%t9783 = zext i1 %t9782 to i8
call void @resid_conv_check(i8 %t9783)
%t9784 = add i64 4115178125766777443, 0
%t9785 = add i64 %t9784, 0
%t9786 = add i64 %t9785, 0
%t9787 = icmp ne i64 %t9786, %t9784
%t9788 = icmp slt i64 4115178125766777443, 0
%t9789 = or i1 %t9787, %t9788
%t9790 = zext i1 %t9789 to i8
call void @resid_conv_check(i8 %t9790)
%t9791 = add i64 5681478168544905931, 0
%t9792 = add i64 %t9791, 0
%t9793 = add i64 %t9792, 0
%t9794 = icmp ne i64 %t9793, %t9791
%t9795 = icmp slt i64 5681478168544905931, 0
%t9796 = or i1 %t9794, %t9795
%t9797 = zext i1 %t9796 to i8
call void @resid_conv_check(i8 %t9797)
%t9798 = add i64 6601373596472566643, 0
%t9799 = add i64 %t9798, 0
%t9800 = add i64 %t9799, 0
%t9801 = icmp ne i64 %t9800, %t9798
%t9802 = icmp slt i64 6601373596472566643, 0
%t9803 = or i1 %t9801, %t9802
%t9804 = zext i1 %t9803 to i8
call void @resid_conv_check(i8 %t9804)
%t9805 = add i64 7507060721942968483, 0
%t9806 = add i64 %t9805, 0
%t9807 = add i64 %t9806, 0
%t9808 = icmp ne i64 %t9807, %t9805
%t9809 = icmp slt i64 7507060721942968483, 0
%t9810 = or i1 %t9808, %t9809
%t9811 = zext i1 %t9810 to i8
call void @resid_conv_check(i8 %t9811)
%t9812 = add i64 8399075790359081724, 0
%t9813 = add i64 %t9812, 0
%t9814 = add i64 %t9813, 0
%t9815 = icmp ne i64 %t9814, %t9812
%t9816 = icmp slt i64 8399075790359081724, 0
%t9817 = or i1 %t9815, %t9816
%t9818 = zext i1 %t9817 to i8
call void @resid_conv_check(i8 %t9818)
%t9819 = add i64 8693463985226723168, 0
%t9820 = add i64 %t9819, 0
%t9821 = add i64 %t9820, 0
%t9822 = icmp ne i64 %t9821, %t9819
%t9823 = icmp slt i64 8693463985226723168, 0
%t9824 = or i1 %t9822, %t9823
%t9825 = zext i1 %t9824 to i8
call void @resid_conv_check(i8 %t9825)
%t9826 = add i128 9568029438360202098, 0
%t9827 = trunc i128 %t9826 to i64
%t9828 = zext i64 %t9827 to i128
%t9829 = icmp ne i128 %t9828, %t9826
%t9830 = icmp slt i128 9568029438360202098, 0
%t9831 = or i1 %t9829, %t9830
%t9832 = zext i1 %t9831 to i8
call void @resid_conv_check(i8 %t9832)
%t9833 = add i128 10144078919501101548, 0
%t9834 = trunc i128 %t9833 to i64
%t9835 = zext i64 %t9834 to i128
%t9836 = icmp ne i128 %t9835, %t9833
%t9837 = icmp slt i128 10144078919501101548, 0
%t9838 = or i1 %t9836, %t9837
%t9839 = zext i1 %t9838 to i8
call void @resid_conv_check(i8 %t9839)
%t9840 = add i128 10430055236837252648, 0
%t9841 = trunc i128 %t9840 to i64
%t9842 = zext i64 %t9841 to i128
%t9843 = icmp ne i128 %t9842, %t9840
%t9844 = icmp slt i128 10430055236837252648, 0
%t9845 = or i1 %t9843, %t9844
%t9846 = zext i1 %t9845 to i8
call void @resid_conv_check(i8 %t9846)
%t9847 = add i128 11840083180663258601, 0
%t9848 = trunc i128 %t9847 to i64
%t9849 = zext i64 %t9848 to i128
%t9850 = icmp ne i128 %t9849, %t9847
%t9851 = icmp slt i128 11840083180663258601, 0
%t9852 = or i1 %t9850, %t9851
%t9853 = zext i1 %t9852 to i8
call void @resid_conv_check(i8 %t9853)
%t9854 = add i128 13761210420658862357, 0
%t9855 = trunc i128 %t9854 to i64
%t9856 = zext i64 %t9855 to i128
%t9857 = icmp ne i128 %t9856, %t9854
%t9858 = icmp slt i128 13761210420658862357, 0
%t9859 = or i1 %t9857, %t9858
%t9860 = zext i1 %t9859 to i8
call void @resid_conv_check(i8 %t9860)
%t9861 = add i128 14299343276471374635, 0
%t9862 = trunc i128 %t9861 to i64
%t9863 = zext i64 %t9862 to i128
%t9864 = icmp ne i128 %t9863, %t9861
%t9865 = icmp slt i128 14299343276471374635, 0
%t9866 = or i1 %t9864, %t9865
%t9867 = zext i1 %t9866 to i8
call void @resid_conv_check(i8 %t9867)
%t9868 = add i128 14566680578165727644, 0
%t9869 = trunc i128 %t9868 to i64
%t9870 = zext i64 %t9869 to i128
%t9871 = icmp ne i128 %t9870, %t9868
%t9872 = icmp slt i128 14566680578165727644, 0
%t9873 = or i1 %t9871, %t9872
%t9874 = zext i1 %t9873 to i8
call void @resid_conv_check(i8 %t9874)
%t9875 = add i128 15097957966210449927, 0
%t9876 = trunc i128 %t9875 to i64
%t9877 = zext i64 %t9876 to i128
%t9878 = icmp ne i128 %t9877, %t9875
%t9879 = icmp slt i128 15097957966210449927, 0
%t9880 = or i1 %t9878, %t9879
%t9881 = zext i1 %t9880 to i8
call void @resid_conv_check(i8 %t9881)
%t9882 = add i128 16922976911328602910, 0
%t9883 = trunc i128 %t9882 to i64
%t9884 = zext i64 %t9883 to i128
%t9885 = icmp ne i128 %t9884, %t9882
%t9886 = icmp slt i128 16922976911328602910, 0
%t9887 = or i1 %t9885, %t9886
%t9888 = zext i1 %t9887 to i8
call void @resid_conv_check(i8 %t9888)
%t9889 = add i128 17689382322260857208, 0
%t9890 = trunc i128 %t9889 to i64
%t9891 = zext i64 %t9890 to i128
%t9892 = icmp ne i128 %t9891, %t9889
%t9893 = icmp slt i128 17689382322260857208, 0
%t9894 = or i1 %t9892, %t9893
%t9895 = zext i1 %t9894 to i8
call void @resid_conv_check(i8 %t9895)
%t9896 = add i64 1242879168328830382, 0
%t9897 = add i64 %t9896, 0
%t9898 = add i64 %t9897, 0
%t9899 = icmp ne i64 %t9898, %t9896
%t9900 = icmp slt i64 1242879168328830382, 0
%t9901 = or i1 %t9899, %t9900
%t9902 = zext i1 %t9901 to i8
call void @resid_conv_check(i8 %t9902)
%t9903 = add i64 1977374033974150939, 0
%t9904 = add i64 %t9903, 0
%t9905 = add i64 %t9904, 0
%t9906 = icmp ne i64 %t9905, %t9903
%t9907 = icmp slt i64 1977374033974150939, 0
%t9908 = or i1 %t9906, %t9907
%t9909 = zext i1 %t9908 to i8
call void @resid_conv_check(i8 %t9909)
%t9910 = add i64 2944078676154940804, 0
%t9911 = add i64 %t9910, 0
%t9912 = add i64 %t9911, 0
%t9913 = icmp ne i64 %t9912, %t9910
%t9914 = icmp slt i64 2944078676154940804, 0
%t9915 = or i1 %t9913, %t9914
%t9916 = zext i1 %t9915 to i8
call void @resid_conv_check(i8 %t9916)
%t9917 = add i64 3659926193048069267, 0
%t9918 = add i64 %t9917, 0
%t9919 = add i64 %t9918, 0
%t9920 = icmp ne i64 %t9919, %t9917
%t9921 = icmp slt i64 3659926193048069267, 0
%t9922 = or i1 %t9920, %t9921
%t9923 = zext i1 %t9922 to i8
call void @resid_conv_check(i8 %t9923)
%t9924 = add i64 4368137639120453308, 0
%t9925 = add i64 %t9924, 0
%t9926 = add i64 %t9925, 0
%t9927 = icmp ne i64 %t9926, %t9924
%t9928 = icmp slt i64 4368137639120453308, 0
%t9929 = or i1 %t9927, %t9928
%t9930 = zext i1 %t9929 to i8
call void @resid_conv_check(i8 %t9930)
%t9931 = add i64 4836135668995329356, 0
%t9932 = add i64 %t9931, 0
%t9933 = add i64 %t9932, 0
%t9934 = icmp ne i64 %t9933, %t9931
%t9935 = icmp slt i64 4836135668995329356, 0
%t9936 = or i1 %t9934, %t9935
%t9937 = zext i1 %t9936 to i8
call void @resid_conv_check(i8 %t9937)
%t9938 = add i64 5532061633213252278, 0
%t9939 = add i64 %t9938, 0
%t9940 = add i64 %t9939, 0
%t9941 = icmp ne i64 %t9940, %t9938
%t9942 = icmp slt i64 5532061633213252278, 0
%t9943 = or i1 %t9941, %t9942
%t9944 = zext i1 %t9943 to i8
call void @resid_conv_check(i8 %t9944)
%t9945 = add i64 6448918945643986474, 0
%t9946 = add i64 %t9945, 0
%t9947 = add i64 %t9946, 0
%t9948 = icmp ne i64 %t9947, %t9945
%t9949 = icmp slt i64 6448918945643986474, 0
%t9950 = or i1 %t9948, %t9949
%t9951 = zext i1 %t9950 to i8
call void @resid_conv_check(i8 %t9951)
%t9952 = add i64 6902733635092675308, 0
%t9953 = add i64 %t9952, 0
%t9954 = add i64 %t9953, 0
%t9955 = icmp ne i64 %t9954, %t9952
%t9956 = icmp slt i64 6902733635092675308, 0
%t9957 = or i1 %t9955, %t9956
%t9958 = zext i1 %t9957 to i8
call void @resid_conv_check(i8 %t9958)
%t9959 = add i64 7801388544844847127, 0
%t9960 = add i64 %t9959, 0
%t9961 = add i64 %t9960, 0
%t9962 = icmp ne i64 %t9961, %t9959
%t9963 = icmp slt i64 7801388544844847127, 0
%t9964 = or i1 %t9962, %t9963
%t9965 = zext i1 %t9964 to i8
call void @resid_conv_check(i8 %t9965)
%t9966 = alloca [80 x ptr]
%t9968 = call ptr @resid_box_i64(i64 %t9428)
%t9970 = getelementptr i8, ptr %t9966, i64 0
store ptr %t9968, ptr %t9970
%t9971 = call ptr @resid_box_i64(i64 %t9435)
%t9973 = getelementptr i8, ptr %t9966, i64 8
store ptr %t9971, ptr %t9973
%t9974 = call ptr @resid_box_i64(i64 %t9442)
%t9976 = getelementptr i8, ptr %t9966, i64 16
store ptr %t9974, ptr %t9976
%t9977 = call ptr @resid_box_i64(i64 %t9449)
%t9979 = getelementptr i8, ptr %t9966, i64 24
store ptr %t9977, ptr %t9979
%t9980 = call ptr @resid_box_i64(i64 %t9456)
%t9982 = getelementptr i8, ptr %t9966, i64 32
store ptr %t9980, ptr %t9982
%t9983 = call ptr @resid_box_i64(i64 %t9463)
%t9985 = getelementptr i8, ptr %t9966, i64 40
store ptr %t9983, ptr %t9985
%t9986 = call ptr @resid_box_i64(i64 %t9470)
%t9988 = getelementptr i8, ptr %t9966, i64 48
store ptr %t9986, ptr %t9988
%t9989 = call ptr @resid_box_i64(i64 %t9477)
%t9991 = getelementptr i8, ptr %t9966, i64 56
store ptr %t9989, ptr %t9991
%t9992 = call ptr @resid_box_i64(i64 %t9484)
%t9994 = getelementptr i8, ptr %t9966, i64 64
store ptr %t9992, ptr %t9994
%t9995 = call ptr @resid_box_i64(i64 %t9491)
%t9997 = getelementptr i8, ptr %t9966, i64 72
store ptr %t9995, ptr %t9997
%t9998 = call ptr @resid_box_i64(i64 %t9498)
%t10000 = getelementptr i8, ptr %t9966, i64 80
store ptr %t9998, ptr %t10000
%t10001 = call ptr @resid_box_i64(i64 %t9505)
%t10003 = getelementptr i8, ptr %t9966, i64 88
store ptr %t10001, ptr %t10003
%t10004 = call ptr @resid_box_i64(i64 %t9512)
%t10006 = getelementptr i8, ptr %t9966, i64 96
store ptr %t10004, ptr %t10006
%t10007 = call ptr @resid_box_i64(i64 %t9519)
%t10009 = getelementptr i8, ptr %t9966, i64 104
store ptr %t10007, ptr %t10009
%t10010 = call ptr @resid_box_i64(i64 %t9526)
%t10012 = getelementptr i8, ptr %t9966, i64 112
store ptr %t10010, ptr %t10012
%t10013 = call ptr @resid_box_i64(i64 %t9533)
%t10015 = getelementptr i8, ptr %t9966, i64 120
store ptr %t10013, ptr %t10015
%t10016 = call ptr @resid_box_i64(i64 %t9540)
%t10018 = getelementptr i8, ptr %t9966, i64 128
store ptr %t10016, ptr %t10018
%t10019 = call ptr @resid_box_i64(i64 %t9547)
%t10021 = getelementptr i8, ptr %t9966, i64 136
store ptr %t10019, ptr %t10021
%t10022 = call ptr @resid_box_i64(i64 %t9554)
%t10024 = getelementptr i8, ptr %t9966, i64 144
store ptr %t10022, ptr %t10024
%t10025 = call ptr @resid_box_i64(i64 %t9561)
%t10027 = getelementptr i8, ptr %t9966, i64 152
store ptr %t10025, ptr %t10027
%t10028 = call ptr @resid_box_i64(i64 %t9568)
%t10030 = getelementptr i8, ptr %t9966, i64 160
store ptr %t10028, ptr %t10030
%t10031 = call ptr @resid_box_i64(i64 %t9575)
%t10033 = getelementptr i8, ptr %t9966, i64 168
store ptr %t10031, ptr %t10033
%t10034 = call ptr @resid_box_i64(i64 %t9582)
%t10036 = getelementptr i8, ptr %t9966, i64 176
store ptr %t10034, ptr %t10036
%t10037 = call ptr @resid_box_i64(i64 %t9589)
%t10039 = getelementptr i8, ptr %t9966, i64 184
store ptr %t10037, ptr %t10039
%t10040 = call ptr @resid_box_i64(i64 %t9596)
%t10042 = getelementptr i8, ptr %t9966, i64 192
store ptr %t10040, ptr %t10042
%t10043 = call ptr @resid_box_i64(i64 %t9603)
%t10045 = getelementptr i8, ptr %t9966, i64 200
store ptr %t10043, ptr %t10045
%t10046 = call ptr @resid_box_i64(i64 %t9610)
%t10048 = getelementptr i8, ptr %t9966, i64 208
store ptr %t10046, ptr %t10048
%t10049 = call ptr @resid_box_i64(i64 %t9617)
%t10051 = getelementptr i8, ptr %t9966, i64 216
store ptr %t10049, ptr %t10051
%t10052 = call ptr @resid_box_i64(i64 %t9624)
%t10054 = getelementptr i8, ptr %t9966, i64 224
store ptr %t10052, ptr %t10054
%t10055 = call ptr @resid_box_i64(i64 %t9631)
%t10057 = getelementptr i8, ptr %t9966, i64 232
store ptr %t10055, ptr %t10057
%t10058 = call ptr @resid_box_i64(i64 489312712824947311)
%t10060 = getelementptr i8, ptr %t9966, i64 240
store ptr %t10058, ptr %t10060
%t10061 = call ptr @resid_box_i64(i64 %t9638)
%t10063 = getelementptr i8, ptr %t9966, i64 248
store ptr %t10061, ptr %t10063
%t10064 = call ptr @resid_box_i64(i64 %t9645)
%t10066 = getelementptr i8, ptr %t9966, i64 256
store ptr %t10064, ptr %t10066
%t10067 = call ptr @resid_box_i64(i64 %t9652)
%t10069 = getelementptr i8, ptr %t9966, i64 264
store ptr %t10067, ptr %t10069
%t10070 = call ptr @resid_box_i64(i64 %t9659)
%t10072 = getelementptr i8, ptr %t9966, i64 272
store ptr %t10070, ptr %t10072
%t10073 = call ptr @resid_box_i64(i64 %t9666)
%t10075 = getelementptr i8, ptr %t9966, i64 280
store ptr %t10073, ptr %t10075
%t10076 = call ptr @resid_box_i64(i64 %t9673)
%t10078 = getelementptr i8, ptr %t9966, i64 288
store ptr %t10076, ptr %t10078
%t10079 = call ptr @resid_box_i64(i64 %t9680)
%t10081 = getelementptr i8, ptr %t9966, i64 296
store ptr %t10079, ptr %t10081
%t10082 = call ptr @resid_box_i64(i64 %t9687)
%t10084 = getelementptr i8, ptr %t9966, i64 304
store ptr %t10082, ptr %t10084
%t10085 = call ptr @resid_box_i64(i64 %t9694)
%t10087 = getelementptr i8, ptr %t9966, i64 312
store ptr %t10085, ptr %t10087
%t10088 = call ptr @resid_box_i64(i64 %t9701)
%t10090 = getelementptr i8, ptr %t9966, i64 320
store ptr %t10088, ptr %t10090
%t10091 = call ptr @resid_box_i64(i64 %t9708)
%t10093 = getelementptr i8, ptr %t9966, i64 328
store ptr %t10091, ptr %t10093
%t10094 = call ptr @resid_box_i64(i64 %t9715)
%t10096 = getelementptr i8, ptr %t9966, i64 336
store ptr %t10094, ptr %t10096
%t10097 = call ptr @resid_box_i64(i64 %t9722)
%t10099 = getelementptr i8, ptr %t9966, i64 344
store ptr %t10097, ptr %t10099
%t10100 = call ptr @resid_box_i64(i64 %t9729)
%t10102 = getelementptr i8, ptr %t9966, i64 352
store ptr %t10100, ptr %t10102
%t10103 = call ptr @resid_box_i64(i64 %t9736)
%t10105 = getelementptr i8, ptr %t9966, i64 360
store ptr %t10103, ptr %t10105
%t10106 = call ptr @resid_box_i64(i64 %t9743)
%t10108 = getelementptr i8, ptr %t9966, i64 368
store ptr %t10106, ptr %t10108
%t10109 = call ptr @resid_box_i64(i64 %t9750)
%t10111 = getelementptr i8, ptr %t9966, i64 376
store ptr %t10109, ptr %t10111
%t10112 = call ptr @resid_box_i64(i64 %t9757)
%t10114 = getelementptr i8, ptr %t9966, i64 384
store ptr %t10112, ptr %t10114
%t10115 = call ptr @resid_box_i64(i64 %t9764)
%t10117 = getelementptr i8, ptr %t9966, i64 392
store ptr %t10115, ptr %t10117
%t10118 = call ptr @resid_box_i64(i64 %t9771)
%t10120 = getelementptr i8, ptr %t9966, i64 400
store ptr %t10118, ptr %t10120
%t10121 = call ptr @resid_box_i64(i64 %t9778)
%t10123 = getelementptr i8, ptr %t9966, i64 408
store ptr %t10121, ptr %t10123
%t10124 = call ptr @resid_box_i64(i64 %t9785)
%t10126 = getelementptr i8, ptr %t9966, i64 416
store ptr %t10124, ptr %t10126
%t10127 = call ptr @resid_box_i64(i64 %t9792)
%t10129 = getelementptr i8, ptr %t9966, i64 424
store ptr %t10127, ptr %t10129
%t10130 = call ptr @resid_box_i64(i64 %t9799)
%t10132 = getelementptr i8, ptr %t9966, i64 432
store ptr %t10130, ptr %t10132
%t10133 = call ptr @resid_box_i64(i64 %t9806)
%t10135 = getelementptr i8, ptr %t9966, i64 440
store ptr %t10133, ptr %t10135
%t10136 = call ptr @resid_box_i64(i64 %t9813)
%t10138 = getelementptr i8, ptr %t9966, i64 448
store ptr %t10136, ptr %t10138
%t10139 = call ptr @resid_box_i64(i64 %t9820)
%t10141 = getelementptr i8, ptr %t9966, i64 456
store ptr %t10139, ptr %t10141
%t10142 = call ptr @resid_box_i64(i64 %t9827)
%t10144 = getelementptr i8, ptr %t9966, i64 464
store ptr %t10142, ptr %t10144
%t10145 = call ptr @resid_box_i64(i64 %t9834)
%t10147 = getelementptr i8, ptr %t9966, i64 472
store ptr %t10145, ptr %t10147
%t10148 = call ptr @resid_box_i64(i64 %t9841)
%t10150 = getelementptr i8, ptr %t9966, i64 480
store ptr %t10148, ptr %t10150
%t10151 = call ptr @resid_box_i64(i64 %t9848)
%t10153 = getelementptr i8, ptr %t9966, i64 488
store ptr %t10151, ptr %t10153
%t10154 = call ptr @resid_box_i64(i64 %t9855)
%t10156 = getelementptr i8, ptr %t9966, i64 496
store ptr %t10154, ptr %t10156
%t10157 = call ptr @resid_box_i64(i64 %t9862)
%t10159 = getelementptr i8, ptr %t9966, i64 504
store ptr %t10157, ptr %t10159
%t10160 = call ptr @resid_box_i64(i64 %t9869)
%t10162 = getelementptr i8, ptr %t9966, i64 512
store ptr %t10160, ptr %t10162
%t10163 = call ptr @resid_box_i64(i64 %t9876)
%t10165 = getelementptr i8, ptr %t9966, i64 520
store ptr %t10163, ptr %t10165
%t10166 = call ptr @resid_box_i64(i64 %t9883)
%t10168 = getelementptr i8, ptr %t9966, i64 528
store ptr %t10166, ptr %t10168
%t10169 = call ptr @resid_box_i64(i64 %t9890)
%t10171 = getelementptr i8, ptr %t9966, i64 536
store ptr %t10169, ptr %t10171
%t10172 = call ptr @resid_box_i64(i64 500013540394364858)
%t10174 = getelementptr i8, ptr %t9966, i64 544
store ptr %t10172, ptr %t10174
%t10175 = call ptr @resid_box_i64(i64 748580250866718886)
%t10177 = getelementptr i8, ptr %t9966, i64 552
store ptr %t10175, ptr %t10177
%t10178 = call ptr @resid_box_i64(i64 %t9897)
%t10180 = getelementptr i8, ptr %t9966, i64 560
store ptr %t10178, ptr %t10180
%t10181 = call ptr @resid_box_i64(i64 %t9904)
%t10183 = getelementptr i8, ptr %t9966, i64 568
store ptr %t10181, ptr %t10183
%t10184 = call ptr @resid_box_i64(i64 %t9911)
%t10186 = getelementptr i8, ptr %t9966, i64 576
store ptr %t10184, ptr %t10186
%t10187 = call ptr @resid_box_i64(i64 %t9918)
%t10189 = getelementptr i8, ptr %t9966, i64 584
store ptr %t10187, ptr %t10189
%t10190 = call ptr @resid_box_i64(i64 %t9925)
%t10192 = getelementptr i8, ptr %t9966, i64 592
store ptr %t10190, ptr %t10192
%t10193 = call ptr @resid_box_i64(i64 %t9932)
%t10195 = getelementptr i8, ptr %t9966, i64 600
store ptr %t10193, ptr %t10195
%t10196 = call ptr @resid_box_i64(i64 %t9939)
%t10198 = getelementptr i8, ptr %t9966, i64 608
store ptr %t10196, ptr %t10198
%t10199 = call ptr @resid_box_i64(i64 %t9946)
%t10201 = getelementptr i8, ptr %t9966, i64 616
store ptr %t10199, ptr %t10201
%t10202 = call ptr @resid_box_i64(i64 %t9953)
%t10204 = getelementptr i8, ptr %t9966, i64 624
store ptr %t10202, ptr %t10204
%t10205 = call ptr @resid_box_i64(i64 %t9960)
%t10207 = getelementptr i8, ptr %t9966, i64 632
store ptr %t10205, ptr %t10207
%t10208 = call ptr @resid_list_new(i64 80, ptr %t9966, ptr @.lty9966)
%t10209 = getelementptr i8, ptr %p2, i64 0
%t10210 = load i64, ptr %t10209, align 8
%t10211 = getelementptr i8, ptr %p2, i64 8
%t10212 = load i64, ptr %t10211, align 8
%t10213 = getelementptr i8, ptr %p2, i64 16
%t10214 = load i64, ptr %t10213, align 8
%t10215 = getelementptr i8, ptr %p2, i64 24
%t10216 = load i64, ptr %t10215, align 8
%t10217 = getelementptr i8, ptr %p2, i64 32
%t10218 = load i64, ptr %t10217, align 8
%t10219 = getelementptr i8, ptr %p2, i64 40
%t10220 = load i64, ptr %t10219, align 8
%t10221 = getelementptr i8, ptr %p2, i64 48
%t10222 = load i64, ptr %t10221, align 8
%t10223 = getelementptr i8, ptr %p2, i64 56
%t10224 = load i64, ptr %t10223, align 8
%t10225 = call ptr @__m____________lib_sha512g_resid__g5_blk__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %t10208, i64 0, ptr %p2, i64 %t10210, i64 %t10212, i64 %t10214, i64 %t10216, i64 %t10218, i64 %t10220, i64 %t10222, i64 %t10224, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret ptr %t10225
}
define i64 @__m____________lib_sha512g_resid__g5_state_word__g_UInt_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10226 = icmp eq i64 %p1, 0
br i1 %t10226, label %L994, label %L995
L994:
%t10227 = getelementptr i8, ptr %p0, i64 0
%t10228 = load i64, ptr %t10227, align 8
br label %L996
L995:
%t10229 = icmp eq i64 %p1, 1
br i1 %t10229, label %L997, label %L998
L997:
%t10230 = getelementptr i8, ptr %p0, i64 8
%t10231 = load i64, ptr %t10230, align 8
br label %L999
L998:
%t10232 = icmp eq i64 %p1, 2
br i1 %t10232, label %L1000, label %L1001
L1000:
%t10233 = getelementptr i8, ptr %p0, i64 16
%t10234 = load i64, ptr %t10233, align 8
br label %L1002
L1001:
%t10235 = icmp eq i64 %p1, 3
br i1 %t10235, label %L1003, label %L1004
L1003:
%t10236 = getelementptr i8, ptr %p0, i64 24
%t10237 = load i64, ptr %t10236, align 8
br label %L1005
L1004:
%t10238 = icmp eq i64 %p1, 4
br i1 %t10238, label %L1006, label %L1007
L1006:
%t10239 = getelementptr i8, ptr %p0, i64 32
%t10240 = load i64, ptr %t10239, align 8
br label %L1008
L1007:
%t10241 = icmp eq i64 %p1, 5
br i1 %t10241, label %L1009, label %L1010
L1009:
%t10242 = getelementptr i8, ptr %p0, i64 40
%t10243 = load i64, ptr %t10242, align 8
br label %L1011
L1010:
%t10244 = icmp eq i64 %p1, 6
br i1 %t10244, label %L1012, label %L1013
L1012:
%t10245 = getelementptr i8, ptr %p0, i64 48
%t10246 = load i64, ptr %t10245, align 8
br label %L1014
L1013:
%t10247 = getelementptr i8, ptr %p0, i64 56
%t10248 = load i64, ptr %t10247, align 8
br label %L1014
L1014:
%t10249 = phi i64 [ %t10246, %L1012 ], [ %t10248, %L1013 ]
br label %L1011
L1011:
%t10250 = phi i64 [ %t10243, %L1009 ], [ %t10249, %L1014 ]
br label %L1008
L1008:
%t10251 = phi i64 [ %t10240, %L1006 ], [ %t10250, %L1011 ]
br label %L1005
L1005:
%t10252 = phi i64 [ %t10237, %L1003 ], [ %t10251, %L1008 ]
br label %L1002
L1002:
%t10253 = phi i64 [ %t10234, %L1000 ], [ %t10252, %L1005 ]
br label %L999
L999:
%t10254 = phi i64 [ %t10231, %L997 ], [ %t10253, %L1002 ]
br label %L996
L996:
%t10255 = phi i64 [ %t10228, %L994 ], [ %t10254, %L999 ]
ret i64 %t10255
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t10295, %tco.s0.k ]
%p4 = phi ptr [ %p4.in, %entry ], [ %p4.ev.tco.s0, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t10296, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %p7, %tco.s0.k ]
%p9 = phi i64 [ %p9.in, %entry ], [ %t10297, %tco.s0.k ]
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
%p28 = phi i64 [ %p28.in, %entry ], [ %t10282, %tco.s0.k ]
%t10256 = icmp sge i64 %p3, 80
br i1 %t10256, label %L1015, label %L1017
L1015:
%t10257 = call ptr @resid_gmalloc(i64 64)
%t10258 = getelementptr i8, ptr %p4, i64 0
%t10259 = load i64, ptr %t10258, align 8
%t10260 = call i64 @__m____________lib_word_resid__di_add(i64 %t10259, i64 %p5)
%t10257.f0 = getelementptr i8, ptr %t10257, i64 0
store i64 %t10260, ptr %t10257.f0, align 8
%t10261 = getelementptr i8, ptr %p4, i64 8
%t10262 = load i64, ptr %t10261, align 8
%t10263 = call i64 @__m____________lib_word_resid__di_add(i64 %t10262, i64 %p6)
%t10257.f1 = getelementptr i8, ptr %t10257, i64 8
store i64 %t10263, ptr %t10257.f1, align 8
%t10264 = getelementptr i8, ptr %p4, i64 16
%t10265 = load i64, ptr %t10264, align 8
%t10266 = call i64 @__m____________lib_word_resid__di_add(i64 %t10265, i64 %p7)
%t10257.f2 = getelementptr i8, ptr %t10257, i64 16
store i64 %t10266, ptr %t10257.f2, align 8
%t10267 = getelementptr i8, ptr %p4, i64 24
%t10268 = load i64, ptr %t10267, align 8
%t10269 = call i64 @__m____________lib_word_resid__di_add(i64 %t10268, i64 %p8)
%t10257.f3 = getelementptr i8, ptr %t10257, i64 24
store i64 %t10269, ptr %t10257.f3, align 8
%t10270 = getelementptr i8, ptr %p4, i64 32
%t10271 = load i64, ptr %t10270, align 8
%t10272 = call i64 @__m____________lib_word_resid__di_add(i64 %t10271, i64 %p9)
%t10257.f4 = getelementptr i8, ptr %t10257, i64 32
store i64 %t10272, ptr %t10257.f4, align 8
%t10273 = getelementptr i8, ptr %p4, i64 40
%t10274 = load i64, ptr %t10273, align 8
%t10275 = call i64 @__m____________lib_word_resid__di_add(i64 %t10274, i64 %p10)
%t10257.f5 = getelementptr i8, ptr %t10257, i64 40
store i64 %t10275, ptr %t10257.f5, align 8
%t10276 = getelementptr i8, ptr %p4, i64 48
%t10277 = load i64, ptr %t10276, align 8
%t10278 = call i64 @__m____________lib_word_resid__di_add(i64 %t10277, i64 %p11)
%t10257.f6 = getelementptr i8, ptr %t10257, i64 48
store i64 %t10278, ptr %t10257.f6, align 8
%t10279 = getelementptr i8, ptr %p4, i64 56
%t10280 = load i64, ptr %t10279, align 8
%t10281 = call i64 @__m____________lib_word_resid__di_add(i64 %t10280, i64 %p12)
%t10257.f7 = getelementptr i8, ptr %t10257, i64 56
store i64 %t10281, ptr %t10257.f7, align 8
%lr.cx79 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz79 = icmp eq ptr %lr.cx79, null
br i1 %lr.lz79, label %lr.x79.k, label %lr.x79.m
lr.x79.k:
ret ptr %t10257
lr.x79.m:
%lr.ret79 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %t10257, ptr %lr.cx79)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret79
L1017:
%t10282 = call i64 @__m____________lib_sha512g_resid__g5_sched__g_Int_64__UInt_64_(ptr %p0, i64 %p1, i64 %p3, i64 %p13, i64 %p14, i64 %p22, i64 %p27)
%t10283 = call i64 @__m____________lib_sha512g_resid__g5_b1__g_UInt_64__Int_64_(i64 %p9)
%t10284 = call i64 @__m____________lib_word_resid__di_add(i64 %p12, i64 %t10283)
%t10285 = call i64 @__m____________lib_sha512g_resid__g5_ch__g_UInt_64__Int_64_(i64 %p9, i64 %p10, i64 %p11)
%t10286 = call i64 @__m____________lib_word_resid__di_add(i64 %t10284, i64 %t10285)
%t10287 = call ptr @resid_list_get_v(ptr %p2, i64 %p3, ptr %p2.ld, i64 %p2.ln)
%t10288 = call i64 @resid_unbox_i64(ptr %t10287)
%t10290 = call i64 @__m____________lib_word_resid__di_addk(i64 %t10286, i64 %t10288)
%t10291 = call i64 @__m____________lib_word_resid__di_add(i64 %t10290, i64 %t10282)
%t10292 = call i64 @__m____________lib_sha512g_resid__g5_b0__g_UInt_64__Int_64_(i64 %p5)
%t10293 = call i64 @__m____________lib_sha512g_resid__g5_maj__g_UInt_64__Int_64_(i64 %p5, i64 %p6, i64 %p7)
%t10294 = call i64 @__m____________lib_word_resid__di_add(i64 %t10292, i64 %t10293)
%t10295 = add nsw i64 %p3, 1
%t10296 = call i64 @__m____________lib_word_resid__di_add(i64 %t10291, i64 %t10294)
%t10297 = call i64 @__m____________lib_word_resid__di_add(i64 %p8, i64 %t10291)
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
%t10299 = icmp slt i64 %p2, 16
br i1 %t10299, label %L1018, label %L1020
L1018:
%t10300 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t10301 = extractvalue {i64, i1} %t10300, 0
%t10302 = extractvalue {i64, i1} %t10300, 1
%t10303 = zext i1 %t10302 to i8
call void @resid_overflow_check(i8 %t10303)
%t10304 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t10301)
%t10305 = extractvalue {i64, i1} %t10304, 0
%t10306 = extractvalue {i64, i1} %t10304, 1
%t10307 = zext i1 %t10306 to i8
call void @resid_overflow_check(i8 %t10307)
%t10308 = call i64 @__m____________lib_sha512g_resid__g5_word_at__g_Int_64__UInt_64_(ptr %p0, i64 %t10305)
ret i64 %t10308
L1020:
%t10309 = call i64 @__m____________lib_sha512g_resid__g5_s1__g_UInt_64__Int_64_(i64 %p6)
%t10310 = call i64 @__m____________lib_word_resid__di_add(i64 %t10309, i64 %p5)
%t10311 = call i64 @__m____________lib_sha512g_resid__g5_s0__g_UInt_64__Int_64_(i64 %p4)
%t10312 = call i64 @__m____________lib_word_resid__di_add(i64 %t10311, i64 %p3)
%t10313 = call i64 @__m____________lib_word_resid__di_add(i64 %t10310, i64 %t10312)
ret i64 %t10313
}
define i64 @__m____________lib_sha512g_resid__g5_b1__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10314 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 14)
%t10315 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 18)
%t10316 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10314, i64 %t10315)
%t10317 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 41)
%t10318 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10316, i64 %t10317)
ret i64 %t10318
}
define i64 @__m____________lib_sha512g_resid__g5_ch__g_UInt_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10319 = call i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p1)
%t10320 = call i64 @__m____________lib_word_resid__di_not(i64 %p0)
%t10321 = call i64 @__m____________lib_word_resid__di_and(i64 %t10320, i64 %p2)
%t10322 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10319, i64 %t10321)
ret i64 %t10322
}
define i64 @__m____________lib_sha512g_resid__g5_b0__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10323 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 28)
%t10324 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 34)
%t10325 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10323, i64 %t10324)
%t10326 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 39)
%t10327 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10325, i64 %t10326)
ret i64 %t10327
}
define i64 @__m____________lib_sha512g_resid__g5_maj__g_UInt_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10328 = call i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p1)
%t10329 = call i64 @__m____________lib_word_resid__di_and(i64 %p0, i64 %p2)
%t10330 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10328, i64 %t10329)
%t10331 = call i64 @__m____________lib_word_resid__di_and(i64 %p1, i64 %p2)
%t10332 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10330, i64 %t10331)
ret i64 %t10332
}
define i64 @__m____________lib_sha512g_resid__g5_word_at__g_Int_64__UInt_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10333 = call i64 @__m____________lib_sha512g_resid__g5_word_acc__g_Int_64__UInt_64_(ptr %p0, i64 %p1, i64 0, i64 0)
ret i64 %t10333
}
define i64 @__m____________lib_sha512g_resid__g5_s1__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10334 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 19)
%t10335 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 61)
%t10336 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10334, i64 %t10335)
%t10337 = call i64 @__m____________lib_word_resid__di_shr(i64 %p0, i64 6)
%t10338 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10336, i64 %t10337)
ret i64 %t10338
}
define i64 @__m____________lib_sha512g_resid__g5_s0__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10339 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 1)
%t10340 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 8)
%t10341 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10339, i64 %t10340)
%t10342 = call i64 @__m____________lib_word_resid__di_shr(i64 %p0, i64 7)
%t10343 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10341, i64 %t10342)
ret i64 %t10343
}
define i64 @__m____________lib_sha512g_resid__g5_word_acc__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t10354, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t10356, %tco.s0 ]
%t10344 = icmp sge i64 %p2, 8
br i1 %t10344, label %L1021, label %L1023
L1021:
ret i64 %p3
L1023:
%t10345 = call i64 @__m____________lib_word_resid__di_and(i64 %p3, i64 72057594037927935)
%t10346 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p2)
%t10347 = extractvalue {i64, i1} %t10346, 0
%t10348 = extractvalue {i64, i1} %t10346, 1
%t10349 = zext i1 %t10348 to i8
call void @resid_overflow_check(i8 %t10349)
%t10350 = call ptr @resid_list_get_v(ptr %p0, i64 %t10347, ptr %p0.ld, i64 %p0.ln)
%t10351 = call i64 @resid_unbox_i64(ptr %t10350)
%t10353 = call i64 @__m____________lib_word_resid__di_from_byte(i64 %t10351)
%t10354 = add nsw i64 %p2, 1
%t10355 = call i64 @__m____________lib_sha512g_resid__g5_shl8__g_UInt_64__Int_64_(i64 %t10345)
%t10356 = call i64 @__m____________lib_word_resid__di_xor(i64 %t10355, i64 %t10353)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m____________lib_sha512g_resid__g5_shl8__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10358 = call i64 @__m____________lib_word_resid__di_rotr(i64 %p0, i64 56)
%t10359 = add i128 18446744073709551360, 0
%t10360 = trunc i128 %t10359 to i64
%t10361 = zext i64 %t10360 to i128
%t10362 = icmp ne i128 %t10361, %t10359
%t10363 = icmp slt i128 18446744073709551360, 0
%t10364 = or i1 %t10362, %t10363
%t10365 = zext i1 %t10364 to i8
call void @resid_conv_check(i8 %t10365)
%t10366 = call i64 @__m____________lib_word_resid__di_and(i64 %t10358, i64 %t10360)
ret i64 %t10366
}
define i64 @__m____________lib_bignum_resid__bn_cmp_at__rs45(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 0
}
define ptr @__m____________lib_bignum_resid__bn_sub_at__rs48(ptr %p0, ptr %p1, i64 %p2, i64 %p3, i64 %p4, ptr %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10367 = call ptr @resid_listbuf_finish(ptr %p5, ptr @.lty10367)
ret ptr %t10367
}
define ptr @__m____________lib_bignum_resid__bn_short_at__rs72(ptr %p0, i64 %p1, i64 %p2, i128 %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10368 = call ptr @resid_gmalloc(i64 16)
%t10369 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty10369)
%t10370 = call ptr @__m____________lib_bignum_resid__bn_reverse(ptr %t10369)
%t10371 = call ptr @bn_trim(ptr %t10370)
%t10368.f0 = getelementptr i8, ptr %t10368, i64 0
store ptr %t10371, ptr %t10368.f0, align 8
%t10372 = add i128 %p3, 0
%t10373 = trunc i128 %t10372 to i64
%t10374 = zext i64 %t10373 to i128
%t10375 = icmp ne i128 %t10374, %t10372
%t10376 = icmp eq i8 0, 1
%t10377 = or i1 %t10375, %t10376
%t10378 = zext i1 %t10377 to i8
call void @resid_conv_check(i8 %t10378)
%t10379 = call ptr @bn_from_u64(i64 %t10373)
%t10368.f1 = getelementptr i8, ptr %t10368, i64 8
store ptr %t10379, ptr %t10368.f1, align 8
ret ptr %t10368
}
define ptr @bn_divmod__rs93(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10381 = zext i1 true to i8
call void @resid_assert(i8 %t10381, ptr @.s10380)
%t10382 = alloca [1 x ptr]
%t10384 = call ptr @resid_box_i64(i64 3)
%t10386 = getelementptr i8, ptr %t10382, i64 0
store ptr %t10384, ptr %t10386
%t10387 = call ptr @resid_list_new(i64 1, ptr %t10382, ptr @.lty10382)
%t10388 = call i64 @bn_cmp(ptr %p0, ptr %t10387)
%t10389 = icmp slt i64 %t10388, 0
br i1 %t10389, label %L1024, label %L1026
L1024:
%t10390 = call ptr @resid_gmalloc(i64 16)
%t10391 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyE10391)
%t10390.f0 = getelementptr i8, ptr %t10390, i64 0
store ptr %t10391, ptr %t10390.f0, align 8
%t10390.f1 = getelementptr i8, ptr %t10390, i64 8
store ptr %p0, ptr %t10390.f1, align 8
ret ptr %t10390
L1026:
%t10392 = call ptr @__m____________lib_bignum_resid__bn_divmod_short(ptr %p0, i64 3)
ret ptr %t10392
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
%t10393 = call ptr @resid_gmalloc(i64 16)
%t10394 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty10394)
%t10395 = call ptr @__m____________lib_bignum_resid__bn_reverse(ptr %t10394)
%t10396 = call ptr @bn_trim(ptr %t10395)
%t10393.f0 = getelementptr i8, ptr %t10393, i64 0
store ptr %t10396, ptr %t10393.f0, align 8
%t10397 = add i128 %p3, 0
%t10398 = trunc i128 %t10397 to i64
%t10399 = zext i64 %t10398 to i128
%t10400 = icmp ne i128 %t10399, %t10397
%t10401 = icmp eq i8 0, 1
%t10402 = or i1 %t10400, %t10401
%t10403 = zext i1 %t10402 to i8
call void @resid_conv_check(i8 %t10403)
%t10404 = call ptr @bn_from_u64(i64 %t10398)
%t10393.f1 = getelementptr i8, ptr %t10393, i64 8
store ptr %t10404, ptr %t10393.f1, align 8
ret ptr %t10393
}
define ptr @__m____________lib_sha256g_resid__sha256g_pad_at__rs150(i64 %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10405 = call ptr @resid_box_i64(i64 128)
%t10408 = call ptr @resid_listbuf_push(ptr %p3, ptr %t10405)
%t10409 = musttail call ptr @__m____________lib_sha256g_resid__sha256g_pad_at(i64 %p0, i64 %p1, i64 1, ptr %t10408)
ret ptr %t10409
}
define ptr @length_bytes__rs160(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10412 = alloca [1 x ptr]
%t10410 = ashr i64 %p0, 0
%t10411 = and i64 %t10410, 255
%t10414 = call ptr @resid_box_i64(i64 %t10411)
%t10416 = getelementptr i8, ptr %t10412, i64 0
store ptr %t10414, ptr %t10416
%t10417 = call ptr @resid_list_new(i64 1, ptr %t10412, ptr @.lty10412)
%t10418 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10417)
%t10419 = musttail call ptr @length_bytes(i64 %p0, i64 -1, ptr %t10418)
ret ptr %t10419
}
define ptr @length_bytes__rs159(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10422 = alloca [1 x ptr]
%t10420 = ashr i64 %p0, 8
%t10421 = and i64 %t10420, 255
%t10424 = call ptr @resid_box_i64(i64 %t10421)
%t10426 = getelementptr i8, ptr %t10422, i64 0
store ptr %t10424, ptr %t10426
%t10427 = call ptr @resid_list_new(i64 1, ptr %t10422, ptr @.lty10422)
%t10428 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10427)
%t10429 = musttail call ptr @length_bytes__rs160(i64 %p0, i64 0, ptr %t10428)
ret ptr %t10429
}
define ptr @length_bytes__rs158(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10432 = alloca [1 x ptr]
%t10430 = ashr i64 %p0, 16
%t10431 = and i64 %t10430, 255
%t10434 = call ptr @resid_box_i64(i64 %t10431)
%t10436 = getelementptr i8, ptr %t10432, i64 0
store ptr %t10434, ptr %t10436
%t10437 = call ptr @resid_list_new(i64 1, ptr %t10432, ptr @.lty10432)
%t10438 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10437)
%t10439 = musttail call ptr @length_bytes__rs159(i64 %p0, i64 1, ptr %t10438)
ret ptr %t10439
}
define ptr @length_bytes__rs157(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10442 = alloca [1 x ptr]
%t10440 = ashr i64 %p0, 24
%t10441 = and i64 %t10440, 255
%t10444 = call ptr @resid_box_i64(i64 %t10441)
%t10446 = getelementptr i8, ptr %t10442, i64 0
store ptr %t10444, ptr %t10446
%t10447 = call ptr @resid_list_new(i64 1, ptr %t10442, ptr @.lty10442)
%t10448 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10447)
%t10449 = musttail call ptr @length_bytes__rs158(i64 %p0, i64 2, ptr %t10448)
ret ptr %t10449
}
define ptr @length_bytes__rs156(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10452 = alloca [1 x ptr]
%t10450 = ashr i64 %p0, 32
%t10451 = and i64 %t10450, 255
%t10454 = call ptr @resid_box_i64(i64 %t10451)
%t10456 = getelementptr i8, ptr %t10452, i64 0
store ptr %t10454, ptr %t10456
%t10457 = call ptr @resid_list_new(i64 1, ptr %t10452, ptr @.lty10452)
%t10458 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10457)
%t10459 = musttail call ptr @length_bytes__rs157(i64 %p0, i64 3, ptr %t10458)
ret ptr %t10459
}
define ptr @length_bytes__rs155(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10462 = alloca [1 x ptr]
%t10460 = ashr i64 %p0, 40
%t10461 = and i64 %t10460, 255
%t10464 = call ptr @resid_box_i64(i64 %t10461)
%t10466 = getelementptr i8, ptr %t10462, i64 0
store ptr %t10464, ptr %t10466
%t10467 = call ptr @resid_list_new(i64 1, ptr %t10462, ptr @.lty10462)
%t10468 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10467)
%t10469 = musttail call ptr @length_bytes__rs156(i64 %p0, i64 4, ptr %t10468)
ret ptr %t10469
}
define ptr @length_bytes__rs154(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10472 = alloca [1 x ptr]
%t10470 = ashr i64 %p0, 48
%t10471 = and i64 %t10470, 255
%t10474 = call ptr @resid_box_i64(i64 %t10471)
%t10476 = getelementptr i8, ptr %t10472, i64 0
store ptr %t10474, ptr %t10476
%t10477 = call ptr @resid_list_new(i64 1, ptr %t10472, ptr @.lty10472)
%t10478 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10477)
%t10479 = musttail call ptr @length_bytes__rs155(i64 %p0, i64 5, ptr %t10478)
ret ptr %t10479
}
define ptr @length_bytes__rs153(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10482 = alloca [1 x ptr]
%t10480 = ashr i64 %p0, 56
%t10481 = and i64 %t10480, 255
%t10484 = call ptr @resid_box_i64(i64 %t10481)
%t10486 = getelementptr i8, ptr %t10482, i64 0
store ptr %t10484, ptr %t10486
%t10487 = call ptr @resid_list_new(i64 1, ptr %t10482, ptr @.lty10482)
%t10488 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t10487)
%t10489 = musttail call ptr @length_bytes__rs154(i64 %p0, i64 6, ptr %t10488)
ret ptr %t10489
}
define ptr @sha_hw_words__rs181(i256 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10490 = lshr i256 %p0, 0
%t10491 = and i256 %t10490, 4294967295
%t10492 = trunc i256 %t10491 to i64
%t10493 = call ptr @resid_box_i64(i64 %t10492)
%t10496 = call ptr @resid_listbuf_push(ptr %p2, ptr %t10493)
%t10497 = call ptr @sha_hw_words(i256 %p0, i64 1, ptr %t10496)
ret ptr %t10497
}
define i64 @sched_w__rs191(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10498 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 0)
ret i64 %t10498
}
define i64 @sched_w__rs193(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10499 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 1)
ret i64 %t10499
}
define i64 @sched_w__rs195(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10500 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 2)
ret i64 %t10500
}
define i64 @sched_w__rs198(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10501 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 3)
ret i64 %t10501
}
define i64 @sched_w__rs201(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10502 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 4)
ret i64 %t10502
}
define i64 @sched_w__rs204(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10503 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 5)
ret i64 %t10503
}
define i64 @sched_w__rs207(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10504 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 6)
ret i64 %t10504
}
define i64 @sched_w__rs210(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10505 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 7)
ret i64 %t10505
}
define ptr @sha_blk__rs209(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10506 = call i64 @sched_w__rs210(ptr %p0, i64 %p1, i64 7, i64 0, i64 0, i64 %p21, i64 %p26)
%t10507 = call i64 @bsig1(i64 %p8)
%t10508 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10507)
%t10509 = extractvalue {i64, i1} %t10508, 0
%t10510 = extractvalue {i64, i1} %t10508, 1
%t10511 = zext i1 %t10510 to i8
call void @resid_overflow_check(i8 %t10511)
%t10512 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10513 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10509, i64 %t10512)
%t10514 = extractvalue {i64, i1} %t10513, 0
%t10515 = extractvalue {i64, i1} %t10513, 1
%t10516 = zext i1 %t10515 to i8
call void @resid_overflow_check(i8 %t10516)
%t10517 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10514, i64 -1424204075)
%t10518 = extractvalue {i64, i1} %t10517, 0
%t10519 = extractvalue {i64, i1} %t10517, 1
%t10520 = zext i1 %t10519 to i8
call void @resid_overflow_check(i8 %t10520)
%t10521 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10518, i64 %t10506)
%t10522 = extractvalue {i64, i1} %t10521, 0
%t10523 = extractvalue {i64, i1} %t10521, 1
%t10524 = zext i1 %t10523 to i8
call void @resid_overflow_check(i8 %t10524)
%t10525 = and i64 %t10522, 4294967295
%t10526 = call i64 @bsig0(i64 %p4)
%t10527 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10528 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10526, i64 %t10527)
%t10529 = extractvalue {i64, i1} %t10528, 0
%t10530 = extractvalue {i64, i1} %t10528, 1
%t10531 = zext i1 %t10530 to i8
call void @resid_overflow_check(i8 %t10531)
%t10532 = and i64 %t10529, 4294967295
%t10533 = add nsw i64 %t10525, %t10532
%t10534 = and i64 %t10533, 4294967295
%t10535 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10525)
%t10536 = extractvalue {i64, i1} %t10535, 0
%t10537 = extractvalue {i64, i1} %t10535, 1
%t10538 = zext i1 %t10537 to i8
call void @resid_overflow_check(i8 %t10538)
%t10539 = and i64 %t10536, 4294967295
%t10540 = musttail call ptr @sha_blk(ptr %p0, i64 %p1, i64 8, ptr %p3, i64 %t10534, i64 %p4, i64 %p5, i64 %p6, i64 %t10539, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10506)
ret ptr %t10540
}
define ptr @sha_blk__rs206(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10541 = call i64 @sched_w__rs207(ptr %p0, i64 %p1, i64 6, i64 0, i64 0, i64 0, i64 %p26)
%t10542 = call i64 @bsig1(i64 %p8)
%t10543 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10542)
%t10544 = extractvalue {i64, i1} %t10543, 0
%t10545 = extractvalue {i64, i1} %t10543, 1
%t10546 = zext i1 %t10545 to i8
call void @resid_overflow_check(i8 %t10546)
%t10547 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10548 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10544, i64 %t10547)
%t10549 = extractvalue {i64, i1} %t10548, 0
%t10550 = extractvalue {i64, i1} %t10548, 1
%t10551 = zext i1 %t10550 to i8
call void @resid_overflow_check(i8 %t10551)
%t10552 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10549, i64 -1841331548)
%t10553 = extractvalue {i64, i1} %t10552, 0
%t10554 = extractvalue {i64, i1} %t10552, 1
%t10555 = zext i1 %t10554 to i8
call void @resid_overflow_check(i8 %t10555)
%t10556 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10553, i64 %t10541)
%t10557 = extractvalue {i64, i1} %t10556, 0
%t10558 = extractvalue {i64, i1} %t10556, 1
%t10559 = zext i1 %t10558 to i8
call void @resid_overflow_check(i8 %t10559)
%t10560 = and i64 %t10557, 4294967295
%t10561 = call i64 @bsig0(i64 %p4)
%t10562 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10563 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10561, i64 %t10562)
%t10564 = extractvalue {i64, i1} %t10563, 0
%t10565 = extractvalue {i64, i1} %t10563, 1
%t10566 = zext i1 %t10565 to i8
call void @resid_overflow_check(i8 %t10566)
%t10567 = and i64 %t10564, 4294967295
%t10568 = add nsw i64 %t10560, %t10567
%t10569 = and i64 %t10568, 4294967295
%t10570 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10560)
%t10571 = extractvalue {i64, i1} %t10570, 0
%t10572 = extractvalue {i64, i1} %t10570, 1
%t10573 = zext i1 %t10572 to i8
call void @resid_overflow_check(i8 %t10573)
%t10574 = and i64 %t10571, 4294967295
%t10575 = musttail call ptr @sha_blk__rs209(ptr %p0, i64 %p1, i64 7, ptr %p3, i64 %t10569, i64 %p4, i64 %p5, i64 %p6, i64 %t10574, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10541)
ret ptr %t10575
}
define ptr @sha_blk__rs203(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10576 = call i64 @sched_w__rs204(ptr %p0, i64 %p1, i64 5, i64 0, i64 0, i64 0, i64 %p26)
%t10577 = call i64 @bsig1(i64 %p8)
%t10578 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10577)
%t10579 = extractvalue {i64, i1} %t10578, 0
%t10580 = extractvalue {i64, i1} %t10578, 1
%t10581 = zext i1 %t10580 to i8
call void @resid_overflow_check(i8 %t10581)
%t10582 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10583 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10579, i64 %t10582)
%t10584 = extractvalue {i64, i1} %t10583, 0
%t10585 = extractvalue {i64, i1} %t10583, 1
%t10586 = zext i1 %t10585 to i8
call void @resid_overflow_check(i8 %t10586)
%t10587 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10584, i64 1508970993)
%t10588 = extractvalue {i64, i1} %t10587, 0
%t10589 = extractvalue {i64, i1} %t10587, 1
%t10590 = zext i1 %t10589 to i8
call void @resid_overflow_check(i8 %t10590)
%t10591 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10588, i64 %t10576)
%t10592 = extractvalue {i64, i1} %t10591, 0
%t10593 = extractvalue {i64, i1} %t10591, 1
%t10594 = zext i1 %t10593 to i8
call void @resid_overflow_check(i8 %t10594)
%t10595 = and i64 %t10592, 4294967295
%t10596 = call i64 @bsig0(i64 %p4)
%t10597 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10598 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10596, i64 %t10597)
%t10599 = extractvalue {i64, i1} %t10598, 0
%t10600 = extractvalue {i64, i1} %t10598, 1
%t10601 = zext i1 %t10600 to i8
call void @resid_overflow_check(i8 %t10601)
%t10602 = and i64 %t10599, 4294967295
%t10603 = add nsw i64 %t10595, %t10602
%t10604 = and i64 %t10603, 4294967295
%t10605 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10595)
%t10606 = extractvalue {i64, i1} %t10605, 0
%t10607 = extractvalue {i64, i1} %t10605, 1
%t10608 = zext i1 %t10607 to i8
call void @resid_overflow_check(i8 %t10608)
%t10609 = and i64 %t10606, 4294967295
%t10610 = musttail call ptr @sha_blk__rs206(ptr %p0, i64 %p1, i64 6, ptr %p3, i64 %t10604, i64 %p4, i64 %p5, i64 %p6, i64 %t10609, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10576)
ret ptr %t10610
}
define ptr @sha_blk__rs200(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10611 = call i64 @sched_w__rs201(ptr %p0, i64 %p1, i64 4, i64 0, i64 0, i64 0, i64 %p26)
%t10612 = call i64 @bsig1(i64 %p8)
%t10613 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10612)
%t10614 = extractvalue {i64, i1} %t10613, 0
%t10615 = extractvalue {i64, i1} %t10613, 1
%t10616 = zext i1 %t10615 to i8
call void @resid_overflow_check(i8 %t10616)
%t10617 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10618 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10614, i64 %t10617)
%t10619 = extractvalue {i64, i1} %t10618, 0
%t10620 = extractvalue {i64, i1} %t10618, 1
%t10621 = zext i1 %t10620 to i8
call void @resid_overflow_check(i8 %t10621)
%t10622 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10619, i64 961987163)
%t10623 = extractvalue {i64, i1} %t10622, 0
%t10624 = extractvalue {i64, i1} %t10622, 1
%t10625 = zext i1 %t10624 to i8
call void @resid_overflow_check(i8 %t10625)
%t10626 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10623, i64 %t10611)
%t10627 = extractvalue {i64, i1} %t10626, 0
%t10628 = extractvalue {i64, i1} %t10626, 1
%t10629 = zext i1 %t10628 to i8
call void @resid_overflow_check(i8 %t10629)
%t10630 = and i64 %t10627, 4294967295
%t10631 = call i64 @bsig0(i64 %p4)
%t10632 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10633 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10631, i64 %t10632)
%t10634 = extractvalue {i64, i1} %t10633, 0
%t10635 = extractvalue {i64, i1} %t10633, 1
%t10636 = zext i1 %t10635 to i8
call void @resid_overflow_check(i8 %t10636)
%t10637 = and i64 %t10634, 4294967295
%t10638 = add nsw i64 %t10630, %t10637
%t10639 = and i64 %t10638, 4294967295
%t10640 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10630)
%t10641 = extractvalue {i64, i1} %t10640, 0
%t10642 = extractvalue {i64, i1} %t10640, 1
%t10643 = zext i1 %t10642 to i8
call void @resid_overflow_check(i8 %t10643)
%t10644 = and i64 %t10641, 4294967295
%t10645 = musttail call ptr @sha_blk__rs203(ptr %p0, i64 %p1, i64 5, ptr %p3, i64 %t10639, i64 %p4, i64 %p5, i64 %p6, i64 %t10644, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t10611)
ret ptr %t10645
}
define ptr @sha_blk__rs197(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10646 = call i64 @sched_w__rs198(ptr %p0, i64 %p1, i64 3, i64 0, i64 0, i64 0, i64 %p26)
%t10647 = call i64 @bsig1(i64 %p8)
%t10648 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10647)
%t10649 = extractvalue {i64, i1} %t10648, 0
%t10650 = extractvalue {i64, i1} %t10648, 1
%t10651 = zext i1 %t10650 to i8
call void @resid_overflow_check(i8 %t10651)
%t10652 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10653 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10649, i64 %t10652)
%t10654 = extractvalue {i64, i1} %t10653, 0
%t10655 = extractvalue {i64, i1} %t10653, 1
%t10656 = zext i1 %t10655 to i8
call void @resid_overflow_check(i8 %t10656)
%t10657 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10654, i64 -373957723)
%t10658 = extractvalue {i64, i1} %t10657, 0
%t10659 = extractvalue {i64, i1} %t10657, 1
%t10660 = zext i1 %t10659 to i8
call void @resid_overflow_check(i8 %t10660)
%t10661 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10658, i64 %t10646)
%t10662 = extractvalue {i64, i1} %t10661, 0
%t10663 = extractvalue {i64, i1} %t10661, 1
%t10664 = zext i1 %t10663 to i8
call void @resid_overflow_check(i8 %t10664)
%t10665 = and i64 %t10662, 4294967295
%t10666 = call i64 @bsig0(i64 %p4)
%t10667 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10668 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10666, i64 %t10667)
%t10669 = extractvalue {i64, i1} %t10668, 0
%t10670 = extractvalue {i64, i1} %t10668, 1
%t10671 = zext i1 %t10670 to i8
call void @resid_overflow_check(i8 %t10671)
%t10672 = and i64 %t10669, 4294967295
%t10673 = add nsw i64 %t10665, %t10672
%t10674 = and i64 %t10673, 4294967295
%t10675 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10665)
%t10676 = extractvalue {i64, i1} %t10675, 0
%t10677 = extractvalue {i64, i1} %t10675, 1
%t10678 = zext i1 %t10677 to i8
call void @resid_overflow_check(i8 %t10678)
%t10679 = and i64 %t10676, 4294967295
%t10680 = musttail call ptr @sha_blk__rs200(ptr %p0, i64 %p1, i64 4, ptr %p3, i64 %t10674, i64 %p4, i64 %p5, i64 %p6, i64 %t10679, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p25, i64 %p26, i64 %p27, i64 %t10646)
ret ptr %t10680
}
define ptr @sha_blk__rs194(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10681 = call i64 @sched_w__rs195(ptr %p0, i64 %p1, i64 2, i64 0, i64 0, i64 0, i64 %p26)
%t10682 = call i64 @bsig1(i64 %p8)
%t10683 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10682)
%t10684 = extractvalue {i64, i1} %t10683, 0
%t10685 = extractvalue {i64, i1} %t10683, 1
%t10686 = zext i1 %t10685 to i8
call void @resid_overflow_check(i8 %t10686)
%t10687 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10688 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10684, i64 %t10687)
%t10689 = extractvalue {i64, i1} %t10688, 0
%t10690 = extractvalue {i64, i1} %t10688, 1
%t10691 = zext i1 %t10690 to i8
call void @resid_overflow_check(i8 %t10691)
%t10692 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10689, i64 -1245643825)
%t10693 = extractvalue {i64, i1} %t10692, 0
%t10694 = extractvalue {i64, i1} %t10692, 1
%t10695 = zext i1 %t10694 to i8
call void @resid_overflow_check(i8 %t10695)
%t10696 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10693, i64 %t10681)
%t10697 = extractvalue {i64, i1} %t10696, 0
%t10698 = extractvalue {i64, i1} %t10696, 1
%t10699 = zext i1 %t10698 to i8
call void @resid_overflow_check(i8 %t10699)
%t10700 = and i64 %t10697, 4294967295
%t10701 = call i64 @bsig0(i64 %p4)
%t10702 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10703 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10701, i64 %t10702)
%t10704 = extractvalue {i64, i1} %t10703, 0
%t10705 = extractvalue {i64, i1} %t10703, 1
%t10706 = zext i1 %t10705 to i8
call void @resid_overflow_check(i8 %t10706)
%t10707 = and i64 %t10704, 4294967295
%t10708 = add nsw i64 %t10700, %t10707
%t10709 = and i64 %t10708, 4294967295
%t10710 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10700)
%t10711 = extractvalue {i64, i1} %t10710, 0
%t10712 = extractvalue {i64, i1} %t10710, 1
%t10713 = zext i1 %t10712 to i8
call void @resid_overflow_check(i8 %t10713)
%t10714 = and i64 %t10711, 4294967295
%t10715 = musttail call ptr @sha_blk__rs197(ptr %p0, i64 %p1, i64 3, ptr %p3, i64 %t10709, i64 %p4, i64 %p5, i64 %p6, i64 %t10714, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p26, i64 %p27, i64 %t10681)
ret ptr %t10715
}
define ptr @sha_blk__rs192(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10716 = call i64 @sched_w__rs193(ptr %p0, i64 %p1, i64 1, i64 0, i64 0, i64 0, i64 0)
%t10717 = call i64 @bsig1(i64 %p8)
%t10718 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10717)
%t10719 = extractvalue {i64, i1} %t10718, 0
%t10720 = extractvalue {i64, i1} %t10718, 1
%t10721 = zext i1 %t10720 to i8
call void @resid_overflow_check(i8 %t10721)
%t10722 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10723 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10719, i64 %t10722)
%t10724 = extractvalue {i64, i1} %t10723, 0
%t10725 = extractvalue {i64, i1} %t10723, 1
%t10726 = zext i1 %t10725 to i8
call void @resid_overflow_check(i8 %t10726)
%t10727 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10724, i64 1899447441)
%t10728 = extractvalue {i64, i1} %t10727, 0
%t10729 = extractvalue {i64, i1} %t10727, 1
%t10730 = zext i1 %t10729 to i8
call void @resid_overflow_check(i8 %t10730)
%t10731 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10728, i64 %t10716)
%t10732 = extractvalue {i64, i1} %t10731, 0
%t10733 = extractvalue {i64, i1} %t10731, 1
%t10734 = zext i1 %t10733 to i8
call void @resid_overflow_check(i8 %t10734)
%t10735 = and i64 %t10732, 4294967295
%t10736 = call i64 @bsig0(i64 %p4)
%t10737 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10738 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10736, i64 %t10737)
%t10739 = extractvalue {i64, i1} %t10738, 0
%t10740 = extractvalue {i64, i1} %t10738, 1
%t10741 = zext i1 %t10740 to i8
call void @resid_overflow_check(i8 %t10741)
%t10742 = and i64 %t10739, 4294967295
%t10743 = add nsw i64 %t10735, %t10742
%t10744 = and i64 %t10743, 4294967295
%t10745 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10735)
%t10746 = extractvalue {i64, i1} %t10745, 0
%t10747 = extractvalue {i64, i1} %t10745, 1
%t10748 = zext i1 %t10747 to i8
call void @resid_overflow_check(i8 %t10748)
%t10749 = and i64 %t10746, 4294967295
%t10750 = musttail call ptr @sha_blk__rs194(ptr %p0, i64 %p1, i64 2, ptr %p3, i64 %t10744, i64 %p4, i64 %p5, i64 %p6, i64 %t10749, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p27, i64 %t10716)
ret ptr %t10750
}
define ptr @sha_blk__rs190(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10751 = call i64 @sched_w__rs191(ptr %p0, i64 %p1, i64 0, i64 0, i64 0, i64 0, i64 0)
%t10752 = call i64 @bsig1(i64 %p8)
%t10753 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t10752)
%t10754 = extractvalue {i64, i1} %t10753, 0
%t10755 = extractvalue {i64, i1} %t10753, 1
%t10756 = zext i1 %t10755 to i8
call void @resid_overflow_check(i8 %t10756)
%t10757 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t10758 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10754, i64 %t10757)
%t10759 = extractvalue {i64, i1} %t10758, 0
%t10760 = extractvalue {i64, i1} %t10758, 1
%t10761 = zext i1 %t10760 to i8
call void @resid_overflow_check(i8 %t10761)
%t10762 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10759, i64 1116352408)
%t10763 = extractvalue {i64, i1} %t10762, 0
%t10764 = extractvalue {i64, i1} %t10762, 1
%t10765 = zext i1 %t10764 to i8
call void @resid_overflow_check(i8 %t10765)
%t10766 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10763, i64 %t10751)
%t10767 = extractvalue {i64, i1} %t10766, 0
%t10768 = extractvalue {i64, i1} %t10766, 1
%t10769 = zext i1 %t10768 to i8
call void @resid_overflow_check(i8 %t10769)
%t10770 = and i64 %t10767, 4294967295
%t10771 = call i64 @bsig0(i64 %p4)
%t10772 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t10773 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t10771, i64 %t10772)
%t10774 = extractvalue {i64, i1} %t10773, 0
%t10775 = extractvalue {i64, i1} %t10773, 1
%t10776 = zext i1 %t10775 to i8
call void @resid_overflow_check(i8 %t10776)
%t10777 = and i64 %t10774, 4294967295
%t10778 = add nsw i64 %t10770, %t10777
%t10779 = and i64 %t10778, 4294967295
%t10780 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t10770)
%t10781 = extractvalue {i64, i1} %t10780, 0
%t10782 = extractvalue {i64, i1} %t10780, 1
%t10783 = zext i1 %t10782 to i8
call void @resid_overflow_check(i8 %t10783)
%t10784 = and i64 %t10781, 4294967295
%t10785 = musttail call ptr @sha_blk__rs192(ptr %p0, i64 %p1, i64 1, ptr %p3, i64 %t10779, i64 %p4, i64 %p5, i64 %p6, i64 %t10784, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %t10751)
ret ptr %t10785
}
define ptr @hex_state__rs235(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10786 = call ptr @resid_list_get(ptr %p0, i64 1)
%t10787 = call i64 @resid_unbox_i64(ptr %t10786)
%t10789 = call ptr @hex_word(i64 %t10787)
%t10790 = call ptr @resid_str_concat(ptr %p2, ptr %t10789)
%t10791 = musttail call ptr @hex_state(ptr %p0, i64 2, ptr %t10790)
ret ptr %t10791
}
define ptr @hex_state__rs234(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10793 = call ptr @resid_list_get(ptr %p0, i64 0)
%t10794 = call i64 @resid_unbox_i64(ptr %t10793)
%t10796 = call ptr @hex_word(i64 %t10794)
%t10797 = call ptr @resid_str_concat(ptr @.s10792, ptr %t10796)
%t10798 = musttail call ptr @hex_state__rs235(ptr %p0, i64 1, ptr %t10797)
ret ptr %t10798
}
define ptr @wtb_inner__rs236(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10800 = alloca [1 x ptr]
%t10799 = call i64 @word_byte(ptr %p0, i64 %p1, i64 0)
%t10802 = call ptr @resid_box_i64(i64 %t10799)
%t10804 = getelementptr i8, ptr %t10800, i64 0
store ptr %t10802, ptr %t10804
%t10805 = call ptr @resid_list_new(i64 1, ptr %t10800, ptr @.lty10800)
%t10806 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t10805)
%t10807 = musttail call ptr @wtb_inner(ptr %p0, i64 %p1, i64 1, ptr %t10806)
ret ptr %t10807
}
define ptr @wtb_inner__rs239(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10809 = alloca [1 x ptr]
%t10808 = call i64 @word_byte(ptr %p0, i64 0, i64 0)
%t10811 = call ptr @resid_box_i64(i64 %t10808)
%t10813 = getelementptr i8, ptr %t10809, i64 0
store ptr %t10811, ptr %t10813
%t10814 = call ptr @resid_list_new(i64 1, ptr %t10809, ptr @.lty10809)
%t10815 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t10814)
%t10816 = musttail call ptr @wtb_inner(ptr %p0, i64 0, i64 1, ptr %t10815)
ret ptr %t10816
}
define ptr @wtb_outer__rs238(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10817 = call ptr @wtb_inner__rs239(ptr %p0, i64 0, i64 0, ptr %p2)
%t10818 = musttail call ptr @wtb_outer(ptr %p0, i64 1, ptr %t10817)
ret ptr %t10818
}
define i64 @pick__rs269(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p2
}
define ptr @w64__rs272(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10819 = and i64 %p1, 4294967295
%t10820 = alloca [2 x ptr]
%t10822 = call ptr @resid_box_i64(i64 0)
%t10824 = getelementptr i8, ptr %t10820, i64 0
store ptr %t10822, ptr %t10824
%t10825 = call ptr @resid_box_i64(i64 %t10819)
%t10827 = getelementptr i8, ptr %t10820, i64 8
store ptr %t10825, ptr %t10827
%t10828 = call ptr @resid_list_new(i64 2, ptr %t10820, ptr @.lty10820)
ret ptr %t10828
}
define i64 @shr_big__rs276(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10829 = ashr i64 %p0, 56
ret i64 %t10829
}
define i64 @shr_big__rs275(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10830 = ashr i64 %p0, 32
%t10831 = musttail call i64 @shr_big__rs276(i64 %t10830, i64 56)
ret i64 %t10831
}
define i64 @shr_big__rs274(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10832 = ashr i64 %p0, 32
%t10833 = musttail call i64 @shr_big__rs275(i64 %t10832, i64 88)
ret i64 %t10833
}
define i64 @shr_big__rs280(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10834 = ashr i64 %p0, 48
ret i64 %t10834
}
define i64 @shr_big__rs279(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10835 = ashr i64 %p0, 32
%t10836 = musttail call i64 @shr_big__rs280(i64 %t10835, i64 48)
ret i64 %t10836
}
define i64 @shr_big__rs278(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10837 = ashr i64 %p0, 32
%t10838 = musttail call i64 @shr_big__rs279(i64 %t10837, i64 80)
ret i64 %t10838
}
define i64 @shr_big__rs283(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10839 = ashr i64 %p0, 32
%t10840 = musttail call i64 @shr_big(i64 %t10839, i64 40)
ret i64 %t10840
}
define i64 @shr_big__rs282(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10841 = ashr i64 %p0, 32
%t10842 = musttail call i64 @shr_big__rs283(i64 %t10841, i64 72)
ret i64 %t10842
}
define ptr @len512_bytes__rs288(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10845 = alloca [1 x ptr]
%t10843 = call i64 @shr_big(i64 %p1, i64 64)
%t10844 = and i64 %t10843, 255
%t10847 = call ptr @resid_box_i64(i64 %t10844)
%t10849 = getelementptr i8, ptr %t10845, i64 0
store ptr %t10847, ptr %t10849
%t10850 = call ptr @resid_list_new(i64 1, ptr %t10845, ptr @.lty10845)
%t10851 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10850)
%t10852 = musttail call ptr @len512_bytes(ptr %t10851, i64 %p1, i64 7)
ret ptr %t10852
}
define ptr @len512_bytes__rs287(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10855 = alloca [1 x ptr]
%t10853 = call i64 @shr_big__rs283(i64 %p1, i64 72)
%t10854 = and i64 %t10853, 255
%t10857 = call ptr @resid_box_i64(i64 %t10854)
%t10859 = getelementptr i8, ptr %t10855, i64 0
store ptr %t10857, ptr %t10859
%t10860 = call ptr @resid_list_new(i64 1, ptr %t10855, ptr @.lty10855)
%t10861 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10860)
%t10862 = musttail call ptr @len512_bytes__rs288(ptr %t10861, i64 %p1, i64 8)
ret ptr %t10862
}
define ptr @len512_bytes__rs286(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10865 = alloca [1 x ptr]
%t10863 = call i64 @shr_big__rs279(i64 %p1, i64 80)
%t10864 = and i64 %t10863, 255
%t10867 = call ptr @resid_box_i64(i64 %t10864)
%t10869 = getelementptr i8, ptr %t10865, i64 0
store ptr %t10867, ptr %t10869
%t10870 = call ptr @resid_list_new(i64 1, ptr %t10865, ptr @.lty10865)
%t10871 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10870)
%t10872 = musttail call ptr @len512_bytes__rs287(ptr %t10871, i64 %p1, i64 9)
ret ptr %t10872
}
define ptr @len512_bytes__rs285(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10875 = alloca [1 x ptr]
%t10873 = call i64 @shr_big__rs275(i64 %p1, i64 88)
%t10874 = and i64 %t10873, 255
%t10877 = call ptr @resid_box_i64(i64 %t10874)
%t10879 = getelementptr i8, ptr %t10875, i64 0
store ptr %t10877, ptr %t10879
%t10880 = call ptr @resid_list_new(i64 1, ptr %t10875, ptr @.lty10875)
%t10881 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10880)
%t10882 = musttail call ptr @len512_bytes__rs286(ptr %t10881, i64 %p1, i64 10)
ret ptr %t10882
}
define ptr @len512_bytes__rs284(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10885 = alloca [1 x ptr]
%t10883 = call i64 @shr_big(i64 %p1, i64 96)
%t10884 = and i64 %t10883, 255
%t10887 = call ptr @resid_box_i64(i64 %t10884)
%t10889 = getelementptr i8, ptr %t10885, i64 0
store ptr %t10887, ptr %t10889
%t10890 = call ptr @resid_list_new(i64 1, ptr %t10885, ptr @.lty10885)
%t10891 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10890)
%t10892 = musttail call ptr @len512_bytes__rs285(ptr %t10891, i64 %p1, i64 11)
ret ptr %t10892
}
define ptr @len512_bytes__rs281(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10895 = alloca [1 x ptr]
%t10893 = call i64 @shr_big__rs282(i64 %p1, i64 104)
%t10894 = and i64 %t10893, 255
%t10897 = call ptr @resid_box_i64(i64 %t10894)
%t10899 = getelementptr i8, ptr %t10895, i64 0
store ptr %t10897, ptr %t10899
%t10900 = call ptr @resid_list_new(i64 1, ptr %t10895, ptr @.lty10895)
%t10901 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10900)
%t10902 = musttail call ptr @len512_bytes__rs284(ptr %t10901, i64 %p1, i64 12)
ret ptr %t10902
}
define ptr @len512_bytes__rs277(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10905 = alloca [1 x ptr]
%t10903 = call i64 @shr_big__rs278(i64 %p1, i64 112)
%t10904 = and i64 %t10903, 255
%t10907 = call ptr @resid_box_i64(i64 %t10904)
%t10909 = getelementptr i8, ptr %t10905, i64 0
store ptr %t10907, ptr %t10909
%t10910 = call ptr @resid_list_new(i64 1, ptr %t10905, ptr @.lty10905)
%t10911 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10910)
%t10912 = musttail call ptr @len512_bytes__rs281(ptr %t10911, i64 %p1, i64 13)
ret ptr %t10912
}
define ptr @len512_bytes__rs273(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10915 = alloca [1 x ptr]
%t10913 = call i64 @shr_big__rs274(i64 %p1, i64 120)
%t10914 = and i64 %t10913, 255
%t10917 = call ptr @resid_box_i64(i64 %t10914)
%t10919 = getelementptr i8, ptr %t10915, i64 0
store ptr %t10917, ptr %t10919
%t10920 = call ptr @resid_list_new(i64 1, ptr %t10915, ptr @.lty10915)
%t10921 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t10920)
%t10922 = musttail call ptr @len512_bytes__rs277(ptr %t10921, i64 %p1, i64 14)
ret ptr %t10922
}
define ptr @mw512_acc__rs289(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10923 = call ptr @mw512(ptr %p0, i64 %p1, i64 0)
%t10924 = call ptr @resid_list_freeze(ptr %t10923)
%t10925 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t10924)
%t10926 = musttail call ptr @mw512_acc(ptr %p0, i64 %p1, i64 1, ptr %t10925)
ret ptr %t10926
}
define ptr @w64_rotr__rs291(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10927 = musttail call ptr @w64_rotr_small(ptr %p0, i64 1)
ret ptr %t10927
}
define ptr @w64_rotr__rs293(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10928 = musttail call ptr @w64_rotr_small(ptr %p0, i64 8)
ret ptr %t10928
}
define ptr @w64_shr__rs295(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10929 = musttail call ptr @w64_shr_small(ptr %p0, i64 7)
ret ptr %t10929
}
define ptr @w64_rotr__rs297(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10930 = musttail call ptr @w64_rotr_small(ptr %p0, i64 19)
ret ptr %t10930
}
define ptr @w64_rotr__rs299(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10931 = call i64 @w64_lo(ptr %p0)
%t10932 = call i64 @w64_hi(ptr %p0)
%t10933 = call ptr @w64(i64 %t10931, i64 %t10932)
%t10934 = musttail call ptr @w64_rotr_small(ptr %t10933, i64 29)
ret ptr %t10934
}
define ptr @w64_shr__rs301(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10935 = musttail call ptr @w64_shr_small(ptr %p0, i64 6)
ret ptr %t10935
}
define ptr @w64_rotr__rs303(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10936 = musttail call ptr @w64_rotr_small(ptr %p0, i64 28)
ret ptr %t10936
}
define ptr @w64_rotr__rs305(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10937 = call i64 @w64_lo(ptr %p0)
%t10938 = call i64 @w64_hi(ptr %p0)
%t10939 = call ptr @w64(i64 %t10937, i64 %t10938)
%t10940 = musttail call ptr @w64_rotr_small(ptr %t10939, i64 2)
ret ptr %t10940
}
define ptr @w64_rotr__rs307(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10941 = call i64 @w64_lo(ptr %p0)
%t10942 = call i64 @w64_hi(ptr %p0)
%t10943 = call ptr @w64(i64 %t10941, i64 %t10942)
%t10944 = musttail call ptr @w64_rotr_small(ptr %t10943, i64 7)
ret ptr %t10944
}
define ptr @w64_rotr__rs309(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10945 = musttail call ptr @w64_rotr_small(ptr %p0, i64 14)
ret ptr %t10945
}
define i64 @fw_hi__rs312(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10946 = call ptr @resid_list_get(ptr %p0, i64 0)
%t10947 = call i64 @resid_unbox_i64(ptr %t10946)
ret i64 %t10947
}
define i64 @fw_lo__rs313(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10949 = call ptr @resid_list_get(ptr %p0, i64 1)
%t10950 = call i64 @resid_unbox_i64(ptr %t10949)
ret i64 %t10950
}
define i64 @fw_hi__rs315(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10952 = call ptr @resid_list_get(ptr %p0, i64 2)
%t10953 = call i64 @resid_unbox_i64(ptr %t10952)
ret i64 %t10953
}
define i64 @fw_lo__rs316(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10955 = call ptr @resid_list_get(ptr %p0, i64 3)
%t10956 = call i64 @resid_unbox_i64(ptr %t10955)
ret i64 %t10956
}
define i64 @fw_hi__rs318(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10958 = call ptr @resid_list_get(ptr %p0, i64 4)
%t10959 = call i64 @resid_unbox_i64(ptr %t10958)
ret i64 %t10959
}
define i64 @fw_lo__rs319(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10961 = call ptr @resid_list_get(ptr %p0, i64 5)
%t10962 = call i64 @resid_unbox_i64(ptr %t10961)
ret i64 %t10962
}
define i64 @fw_hi__rs321(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10964 = call ptr @resid_list_get(ptr %p0, i64 6)
%t10965 = call i64 @resid_unbox_i64(ptr %t10964)
ret i64 %t10965
}
define i64 @fw_lo__rs322(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10967 = call ptr @resid_list_get(ptr %p0, i64 7)
%t10968 = call i64 @resid_unbox_i64(ptr %t10967)
ret i64 %t10968
}
define i64 @fw_hi__rs324(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10970 = call ptr @resid_list_get(ptr %p0, i64 8)
%t10971 = call i64 @resid_unbox_i64(ptr %t10970)
ret i64 %t10971
}
define i64 @fw_lo__rs325(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10973 = call ptr @resid_list_get(ptr %p0, i64 9)
%t10974 = call i64 @resid_unbox_i64(ptr %t10973)
ret i64 %t10974
}
define i64 @fw_hi__rs327(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10976 = call ptr @resid_list_get(ptr %p0, i64 10)
%t10977 = call i64 @resid_unbox_i64(ptr %t10976)
ret i64 %t10977
}
define i64 @fw_lo__rs328(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10979 = call ptr @resid_list_get(ptr %p0, i64 11)
%t10980 = call i64 @resid_unbox_i64(ptr %t10979)
ret i64 %t10980
}
define i64 @fw_hi__rs330(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10982 = call ptr @resid_list_get(ptr %p0, i64 12)
%t10983 = call i64 @resid_unbox_i64(ptr %t10982)
ret i64 %t10983
}
define i64 @fw_lo__rs331(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10985 = call ptr @resid_list_get(ptr %p0, i64 13)
%t10986 = call i64 @resid_unbox_i64(ptr %t10985)
ret i64 %t10986
}
define i64 @fw_hi__rs333(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10988 = call ptr @resid_list_get(ptr %p0, i64 14)
%t10989 = call i64 @resid_unbox_i64(ptr %t10988)
ret i64 %t10989
}
define i64 @fw_lo__rs334(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10991 = call ptr @resid_list_get(ptr %p0, i64 15)
%t10992 = call i64 @resid_unbox_i64(ptr %t10991)
ret i64 %t10992
}
define ptr @sha512_rounds_flat__rs337(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10994 = call ptr @sha512_round_flat(ptr %p0, ptr %p1, i64 0)
%t10995 = musttail call ptr @sha512_rounds_flat(ptr %t10994, ptr %p1, i64 1)
ret ptr %t10995
}
define ptr @add_st_acc__rs341(ptr %p0, ptr %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10996 = call ptr @add_st_word(ptr %p0, ptr %p1, i64 0)
%t10997 = call ptr @resid_list_freeze(ptr %t10996)
%t10998 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t10997)
%t10999 = musttail call ptr @add_st_acc(ptr %p0, ptr %p1, i64 1, ptr %t10998)
ret ptr %t10999
}
define i64 @w64_bytes__rs351(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11000 = add nsw i64 %p1, 0
%t11001 = call ptr @resid_list_get(ptr %p0, i64 %t11000)
%t11002 = call i64 @resid_unbox_i64(ptr %t11001)
%t11004 = and i64 %t11002, 255
%t11005 = or i64 0, %t11004
%t11006 = musttail call i64 @w64_bytes(ptr %p0, i64 %p1, i64 1, i64 %t11005)
ret i64 %t11006
}
define i64 @sched64__rs354(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11007 = call i64 @word64_at(ptr %p0, i64 %p1, i64 0)
ret i64 %t11007
}
define i64 @sched64__rs357(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11008 = call i64 @word64_at(ptr %p0, i64 %p1, i64 1)
ret i64 %t11008
}
define i64 @sched64__rs360(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11009 = call i64 @word64_at(ptr %p0, i64 %p1, i64 2)
ret i64 %t11009
}
define i64 @sched64__rs363(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11010 = call i64 @word64_at(ptr %p0, i64 %p1, i64 3)
ret i64 %t11010
}
define i64 @sched64__rs366(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11011 = call i64 @word64_at(ptr %p0, i64 %p1, i64 4)
ret i64 %t11011
}
define i64 @sched64__rs369(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11012 = call i64 @word64_at(ptr %p0, i64 %p1, i64 5)
ret i64 %t11012
}
define i64 @sched64__rs372(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11013 = call i64 @word64_at(ptr %p0, i64 %p1, i64 6)
ret i64 %t11013
}
define i64 @sched64__rs375(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11014 = call i64 @word64_at(ptr %p0, i64 %p1, i64 7)
ret i64 %t11014
}
define ptr @be64_push__rs387(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11015 = lshr i64 %p0, 56
%t11016 = and i64 %t11015, 255
%t11017 = call ptr @resid_box_i64(i64 %t11016)
%t11020 = call ptr @resid_listbuf_push(ptr %p2, ptr %t11017)
%t11021 = musttail call ptr @be64_push(i64 %p0, i64 1, ptr %t11020)
ret ptr %t11021
}
define ptr @cbe_ascii(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11022 = call ptr @resid_sacc_from(ptr %p2)
%t11023 = musttail call ptr @cbe_ascii__sacc(ptr %p0, i64 %p1, ptr %t11022)
ret ptr %t11023
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
@.lty1194 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1194 = private global ptr null
@.lcd1194 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1201 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1201 = private global ptr null
@.lcd1201 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1218 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1218 = private global ptr null
@.lcd1218 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1232 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1232 = private global ptr null
@.lcd1232 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1262 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1262 = private global ptr null
@.lcd1262 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1281 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1281 = private global ptr null
@.lcd1281 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1290 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty1333 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1333 = private global ptr null
@.lcd1333 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1340 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1340 = private global ptr null
@.lcd1340 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1344 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1344 = private global ptr null
@.lcd1344 = private unnamed_addr constant [1 x i64] [i64 3]
@.lty1354 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1354 = private global ptr null
@.lcd1354 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1358 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1358 = private global ptr null
@.lcd1358 = private unnamed_addr constant [302 x i64] [i64 3, i64 5, i64 7, i64 11, i64 13, i64 17, i64 19, i64 23, i64 29, i64 31, i64 37, i64 41, i64 43, i64 47, i64 53, i64 59, i64 61, i64 67, i64 71, i64 73, i64 79, i64 83, i64 89, i64 97, i64 101, i64 103, i64 107, i64 109, i64 113, i64 127, i64 131, i64 137, i64 139, i64 149, i64 151, i64 157, i64 163, i64 167, i64 173, i64 179, i64 181, i64 191, i64 193, i64 197, i64 199, i64 211, i64 223, i64 227, i64 229, i64 233, i64 239, i64 241, i64 251, i64 257, i64 263, i64 269, i64 271, i64 277, i64 281, i64 283, i64 293, i64 307, i64 311, i64 313, i64 317, i64 331, i64 337, i64 347, i64 349, i64 353, i64 359, i64 367, i64 373, i64 379, i64 383, i64 389, i64 397, i64 401, i64 409, i64 419, i64 421, i64 431, i64 433, i64 439, i64 443, i64 449, i64 457, i64 461, i64 463, i64 467, i64 479, i64 487, i64 491, i64 499, i64 503, i64 509, i64 521, i64 523, i64 541, i64 547, i64 557, i64 563, i64 569, i64 571, i64 577, i64 587, i64 593, i64 599, i64 601, i64 607, i64 613, i64 617, i64 619, i64 631, i64 641, i64 643, i64 647, i64 653, i64 659, i64 661, i64 673, i64 677, i64 683, i64 691, i64 701, i64 709, i64 719, i64 727, i64 733, i64 739, i64 743, i64 751, i64 757, i64 761, i64 769, i64 773, i64 787, i64 797, i64 809, i64 811, i64 821, i64 823, i64 827, i64 829, i64 839, i64 853, i64 857, i64 859, i64 863, i64 877, i64 881, i64 883, i64 887, i64 907, i64 911, i64 919, i64 929, i64 937, i64 941, i64 947, i64 953, i64 967, i64 971, i64 977, i64 983, i64 991, i64 997, i64 1009, i64 1013, i64 1019, i64 1021, i64 1031, i64 1033, i64 1039, i64 1049, i64 1051, i64 1061, i64 1063, i64 1069, i64 1087, i64 1091, i64 1093, i64 1097, i64 1103, i64 1109, i64 1117, i64 1123, i64 1129, i64 1151, i64 1153, i64 1163, i64 1171, i64 1181, i64 1187, i64 1193, i64 1201, i64 1213, i64 1217, i64 1223, i64 1229, i64 1231, i64 1237, i64 1249, i64 1259, i64 1277, i64 1279, i64 1283, i64 1289, i64 1291, i64 1297, i64 1301, i64 1303, i64 1307, i64 1319, i64 1321, i64 1327, i64 1361, i64 1367, i64 1373, i64 1381, i64 1399, i64 1409, i64 1423, i64 1427, i64 1429, i64 1433, i64 1439, i64 1447, i64 1451, i64 1453, i64 1459, i64 1471, i64 1481, i64 1483, i64 1487, i64 1489, i64 1493, i64 1499, i64 1511, i64 1523, i64 1531, i64 1543, i64 1549, i64 1553, i64 1559, i64 1567, i64 1571, i64 1579, i64 1583, i64 1597, i64 1601, i64 1607, i64 1609, i64 1613, i64 1619, i64 1621, i64 1627, i64 1637, i64 1657, i64 1663, i64 1667, i64 1669, i64 1693, i64 1697, i64 1699, i64 1709, i64 1721, i64 1723, i64 1733, i64 1741, i64 1747, i64 1753, i64 1759, i64 1777, i64 1783, i64 1787, i64 1789, i64 1801, i64 1811, i64 1823, i64 1831, i64 1847, i64 1861, i64 1867, i64 1871, i64 1873, i64 1877, i64 1879, i64 1889, i64 1901, i64 1907, i64 1913, i64 1931, i64 1933, i64 1949, i64 1951, i64 1973, i64 1979, i64 1987, i64 1993, i64 1997, i64 1999]
@.lty1362 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1362 = private global ptr null
@.lcd1362 = private unnamed_addr constant [302 x i64] [i64 3, i64 5, i64 7, i64 11, i64 13, i64 17, i64 19, i64 23, i64 29, i64 31, i64 37, i64 41, i64 43, i64 47, i64 53, i64 59, i64 61, i64 67, i64 71, i64 73, i64 79, i64 83, i64 89, i64 97, i64 101, i64 103, i64 107, i64 109, i64 113, i64 127, i64 131, i64 137, i64 139, i64 149, i64 151, i64 157, i64 163, i64 167, i64 173, i64 179, i64 181, i64 191, i64 193, i64 197, i64 199, i64 211, i64 223, i64 227, i64 229, i64 233, i64 239, i64 241, i64 251, i64 257, i64 263, i64 269, i64 271, i64 277, i64 281, i64 283, i64 293, i64 307, i64 311, i64 313, i64 317, i64 331, i64 337, i64 347, i64 349, i64 353, i64 359, i64 367, i64 373, i64 379, i64 383, i64 389, i64 397, i64 401, i64 409, i64 419, i64 421, i64 431, i64 433, i64 439, i64 443, i64 449, i64 457, i64 461, i64 463, i64 467, i64 479, i64 487, i64 491, i64 499, i64 503, i64 509, i64 521, i64 523, i64 541, i64 547, i64 557, i64 563, i64 569, i64 571, i64 577, i64 587, i64 593, i64 599, i64 601, i64 607, i64 613, i64 617, i64 619, i64 631, i64 641, i64 643, i64 647, i64 653, i64 659, i64 661, i64 673, i64 677, i64 683, i64 691, i64 701, i64 709, i64 719, i64 727, i64 733, i64 739, i64 743, i64 751, i64 757, i64 761, i64 769, i64 773, i64 787, i64 797, i64 809, i64 811, i64 821, i64 823, i64 827, i64 829, i64 839, i64 853, i64 857, i64 859, i64 863, i64 877, i64 881, i64 883, i64 887, i64 907, i64 911, i64 919, i64 929, i64 937, i64 941, i64 947, i64 953, i64 967, i64 971, i64 977, i64 983, i64 991, i64 997, i64 1009, i64 1013, i64 1019, i64 1021, i64 1031, i64 1033, i64 1039, i64 1049, i64 1051, i64 1061, i64 1063, i64 1069, i64 1087, i64 1091, i64 1093, i64 1097, i64 1103, i64 1109, i64 1117, i64 1123, i64 1129, i64 1151, i64 1153, i64 1163, i64 1171, i64 1181, i64 1187, i64 1193, i64 1201, i64 1213, i64 1217, i64 1223, i64 1229, i64 1231, i64 1237, i64 1249, i64 1259, i64 1277, i64 1279, i64 1283, i64 1289, i64 1291, i64 1297, i64 1301, i64 1303, i64 1307, i64 1319, i64 1321, i64 1327, i64 1361, i64 1367, i64 1373, i64 1381, i64 1399, i64 1409, i64 1423, i64 1427, i64 1429, i64 1433, i64 1439, i64 1447, i64 1451, i64 1453, i64 1459, i64 1471, i64 1481, i64 1483, i64 1487, i64 1489, i64 1493, i64 1499, i64 1511, i64 1523, i64 1531, i64 1543, i64 1549, i64 1553, i64 1559, i64 1567, i64 1571, i64 1579, i64 1583, i64 1597, i64 1601, i64 1607, i64 1609, i64 1613, i64 1619, i64 1621, i64 1627, i64 1637, i64 1657, i64 1663, i64 1667, i64 1669, i64 1693, i64 1697, i64 1699, i64 1709, i64 1721, i64 1723, i64 1733, i64 1741, i64 1747, i64 1753, i64 1759, i64 1777, i64 1783, i64 1787, i64 1789, i64 1801, i64 1811, i64 1823, i64 1831, i64 1847, i64 1861, i64 1867, i64 1871, i64 1873, i64 1877, i64 1879, i64 1889, i64 1901, i64 1907, i64 1913, i64 1931, i64 1933, i64 1949, i64 1951, i64 1973, i64 1979, i64 1987, i64 1993, i64 1997, i64 1999]
@.lty1366 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty1378 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty1389 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1461 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1461 = private global ptr null
@.lcd1461 = private unnamed_addr constant [1 x i64] [i64 2]
@.lty1463 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1463 = private global ptr null
@.lcd1463 = private unnamed_addr constant [1 x i64] [i64 3]
@.lty1465 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1465 = private global ptr null
@.lcd1465 = private unnamed_addr constant [1 x i64] [i64 5]
@.lty1467 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1467 = private global ptr null
@.lcd1467 = private unnamed_addr constant [1 x i64] [i64 7]
@.lty1469 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1469 = private global ptr null
@.lcd1469 = private unnamed_addr constant [1 x i64] [i64 11]
@.lty1471 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1471 = private global ptr null
@.lcd1471 = private unnamed_addr constant [1 x i64] [i64 13]
@.lty1473 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1473 = private global ptr null
@.lcd1473 = private unnamed_addr constant [1 x i64] [i64 17]
@.lty1475 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1475 = private global ptr null
@.lcd1475 = private unnamed_addr constant [1 x i64] [i64 19]
@.lty1477 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1477 = private global ptr null
@.lcd1477 = private unnamed_addr constant [1 x i64] [i64 23]
@.lty1479 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1479 = private global ptr null
@.lcd1479 = private unnamed_addr constant [1 x i64] [i64 29]
@.lty1481 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1481 = private global ptr null
@.lcd1481 = private unnamed_addr constant [1 x i64] [i64 31]
@.lty1483 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1483 = private global ptr null
@.lcd1483 = private unnamed_addr constant [1 x i64] [i64 37]
@.lty1485 = private unnamed_addr constant [20 x i8] c"List(List(Int(64)))\00"
@.oty1525 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox1525 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty1525}, align 16
@.lty1538 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1548 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1548 = private global ptr null
@.lcd1548 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1552 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1552 = private global ptr null
@.lcd1552 = private unnamed_addr constant [1 x i64] [i64 2]
@.lty1554 = private unnamed_addr constant [20 x i8] c"List(List(Int(64)))\00"
@.lty1562 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1562 = private global ptr null
@.lcd1562 = private unnamed_addr constant [1 x i64] [i64 2]
@.lty1564 = private unnamed_addr constant [20 x i8] c"List(List(Int(64)))\00"
@.lty1573 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1579 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1585 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1591 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1597 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1603 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1609 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1615 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1621 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1627 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1633 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1639 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1645 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.lty1687 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1693 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1699 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1705 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1711 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1717 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1723 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1729 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1735 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1741 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1747 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1753 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1759 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.oty1800 = private unnamed_addr constant [23 x i8] c"Option(List(UInt(64)))\00"
@.lty1815 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty1838 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.oty1864 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox1864 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty1864}, align 16
@.oty1875 = private unnamed_addr constant [23 x i8] c"Option(List(UInt(64)))\00"
@.lty1887 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty1905 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc1905 = private global ptr null
@.lcd1905 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty1965 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty2396 = private unnamed_addr constant [14 x i8] c"List(UInt(8))\00"
@.lty2603 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
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
@.lty2780 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc2780 = private global ptr null
@.lcd2780 = private unnamed_addr constant [64 x i64] [i64 1116352408, i64 1899447441, i64 3049323471, i64 3921009573, i64 961987163, i64 1508970993, i64 2453635748, i64 2870763221, i64 3624381080, i64 310598401, i64 607225278, i64 1426881987, i64 1925078388, i64 2162078206, i64 2614888103, i64 3248222580, i64 3835390401, i64 4022224774, i64 264347078, i64 604807628, i64 770255983, i64 1249150122, i64 1555081692, i64 1996064986, i64 2554220882, i64 2821834349, i64 2952996808, i64 3210313671, i64 3336571891, i64 3584528711, i64 113926993, i64 338241895, i64 666307205, i64 773529912, i64 1294757372, i64 1396182291, i64 1695183700, i64 1986661051, i64 2177026350, i64 2456956037, i64 2730485921, i64 2820302411, i64 3259730800, i64 3345764771, i64 3516065817, i64 3600352804, i64 4094571909, i64 275423344, i64 430227734, i64 506948616, i64 659060556, i64 883997877, i64 958139571, i64 1322822218, i64 1537002063, i64 1747873779, i64 1955562222, i64 2024104815, i64 2227730452, i64 2361852424, i64 2428436474, i64 2756734187, i64 3204031479, i64 3329325298]
@.lty2805 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2857 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc2857 = private global ptr null
@.lcd2857 = private unnamed_addr constant [8 x i64] [i64 1779033703, i64 3144134277, i64 1013904242, i64 2773480762, i64 1359893119, i64 2600822924, i64 528734635, i64 1541459225]
@.lty2860 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2884 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc2884 = private global ptr null
@.lcd2884 = private unnamed_addr constant [64 x i64] [i64 1116352408, i64 1899447441, i64 -1245643825, i64 -373957723, i64 961987163, i64 1508970993, i64 -1841331548, i64 -1424204075, i64 -670586216, i64 310598401, i64 607225278, i64 1426881987, i64 1925078388, i64 -2132889090, i64 -1680079193, i64 -1046744716, i64 -459576895, i64 -272742522, i64 264347078, i64 604807628, i64 770255983, i64 1249150122, i64 1555081692, i64 1996064986, i64 -1740746414, i64 -1473132947, i64 -1341970488, i64 -1084653625, i64 -958395405, i64 -710438585, i64 113926993, i64 338241895, i64 666307205, i64 773529912, i64 1294757372, i64 1396182291, i64 1695183700, i64 1986661051, i64 -2117940946, i64 -1838011259, i64 -1564481375, i64 -1474664885, i64 -1035236496, i64 -949202525, i64 -778901479, i64 -694614492, i64 -200395387, i64 275423344, i64 430227734, i64 506948616, i64 659060556, i64 883997877, i64 958139571, i64 1322822218, i64 1537002063, i64 1747873779, i64 1955562222, i64 2024104815, i64 -2067236844, i64 -1933114872, i64 -1866530822, i64 -1538233109, i64 -1090935817, i64 -965641998]
@.lty2955 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2976 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty2990 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc2990 = private global ptr null
@.lcd2990 = private unnamed_addr constant [1 x i64] [i64 0]
@.lty3005 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3015 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc3015 = private global ptr null
@.lcd3015 = private unnamed_addr constant [1 x i64] [i64 128]
@.lty3066 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3075 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3130 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3147 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3155 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3242 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3292 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3405 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
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
@.lty3560 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3698 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3801 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3811 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc3811 = private global ptr null
@.lcd3811 = private unnamed_addr constant [1 x i64] [i64 128]
@.lty3834 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc3834 = private global ptr null
@.lcd3834 = private unnamed_addr constant [8 x i64] [i64 1779033703, i64 -1150833019, i64 1013904242, i64 -1521486534, i64 1359893119, i64 -1694144372, i64 528734635, i64 1541459225]
@.lty3837 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.s3843 = private unnamed_addr constant [1 x i8] c"\00"
@.lty3863 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3876 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3882 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc3882 = private global ptr null
@.lcd3882 = private unnamed_addr constant [8 x i64] [i64 1779033703, i64 -1150833019, i64 1013904242, i64 -1521486534, i64 1359893119, i64 -1694144372, i64 528734635, i64 1541459225]
@.s3901 = private unnamed_addr constant [1 x i8] c"\00"
@.lty3908 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3931 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3945 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3951 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3963 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3979 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty3989 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty3992 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.s4079 = private unnamed_addr constant [2 x i8] c"+\00"
@.s4080 = private unnamed_addr constant [2 x i8] c"/\00"
@.lty4168 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4231 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4263 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4282 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty4285 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty4287 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty4290 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty4297 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4310 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty4312 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.s4326 = private unnamed_addr constant [64 x i8] c"random: getrandom failed, and there is no randomness without it\00"
@.lty4329 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4329 = private global ptr null
@.lcd4329 = private unnamed_addr constant [4 x i64] [i64 0, i64 0, i64 0, i64 32]
@.lty4345 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4364 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4488 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4488 = private global ptr null
@.lcd4488 = private unnamed_addr constant [160 x i64] [i64 1116352408, i64 3609767458, i64 1899447441, i64 602891725, i64 3049323471, i64 3964484399, i64 3921009573, i64 2173295548, i64 961987163, i64 4081628472, i64 1508970993, i64 3053834265, i64 2453635748, i64 2937671579, i64 2870763221, i64 3664609560, i64 3624381080, i64 2734883394, i64 310598401, i64 1164996542, i64 607225278, i64 1323610764, i64 1426881987, i64 3590304994, i64 1925078388, i64 4068182383, i64 2162078206, i64 991336113, i64 2614888103, i64 633803317, i64 3248222580, i64 3479774868, i64 3835390401, i64 2666613458, i64 4022224774, i64 944711139, i64 264347078, i64 2341262773, i64 604807628, i64 2007800933, i64 770255983, i64 1495990901, i64 1249150122, i64 1856431235, i64 1555081692, i64 3175218132, i64 1996064986, i64 2198950837, i64 2554220882, i64 3999719339, i64 2821834349, i64 766784016, i64 2952996808, i64 2566594879, i64 3210313671, i64 3203337956, i64 3336571891, i64 1034457026, i64 3584528711, i64 2466948901, i64 113926993, i64 3758326383, i64 338241895, i64 168717936, i64 666307205, i64 1188179964, i64 773529912, i64 1546045734, i64 1294757372, i64 1522805485, i64 1396182291, i64 2643833823, i64 1695183700, i64 2343527390, i64 1986661051, i64 1014477480, i64 2177026350, i64 1206759142, i64 2456956037, i64 344077627, i64 2730485921, i64 1290863460, i64 2820302411, i64 3158454273, i64 3259730800, i64 3505952657, i64 3345764771, i64 106217008, i64 3516065817, i64 3606008344, i64 3600352804, i64 1432725776, i64 4094571909, i64 1467031594, i64 275423344, i64 851169720, i64 430227734, i64 3100823752, i64 506948616, i64 1363258195, i64 659060556, i64 3750685593, i64 883997877, i64 3785050280, i64 958139571, i64 3318307427, i64 1322822218, i64 3812723403, i64 1537002063, i64 2003034995, i64 1747873779, i64 3602036899, i64 1955562222, i64 1575990012, i64 2024104815, i64 1125592928, i64 2227730452, i64 2716904306, i64 2361852424, i64 442776044, i64 2428436474, i64 593698344, i64 2756734187, i64 3733110249, i64 3204031479, i64 2999351573, i64 3329325298, i64 3815920427, i64 3391569614, i64 3928383900, i64 3515267271, i64 566280711, i64 3940187606, i64 3454069534, i64 4118630271, i64 4000239992, i64 116418474, i64 1914138554, i64 174292421, i64 2731055270, i64 289380356, i64 3203993006, i64 460393269, i64 320620315, i64 685471733, i64 587496836, i64 852142971, i64 1086792851, i64 1017036298, i64 365543100, i64 1126000580, i64 2618297676, i64 1288033470, i64 3409855158, i64 1501505948, i64 4234509866, i64 1607167915, i64 987167468, i64 1816402316, i64 1246189591]
@.lty4497 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4497 = private global ptr null
@.lcd4497 = private unnamed_addr constant [160 x i64] [i64 1116352408, i64 3609767458, i64 1899447441, i64 602891725, i64 3049323471, i64 3964484399, i64 3921009573, i64 2173295548, i64 961987163, i64 4081628472, i64 1508970993, i64 3053834265, i64 2453635748, i64 2937671579, i64 2870763221, i64 3664609560, i64 3624381080, i64 2734883394, i64 310598401, i64 1164996542, i64 607225278, i64 1323610764, i64 1426881987, i64 3590304994, i64 1925078388, i64 4068182383, i64 2162078206, i64 991336113, i64 2614888103, i64 633803317, i64 3248222580, i64 3479774868, i64 3835390401, i64 2666613458, i64 4022224774, i64 944711139, i64 264347078, i64 2341262773, i64 604807628, i64 2007800933, i64 770255983, i64 1495990901, i64 1249150122, i64 1856431235, i64 1555081692, i64 3175218132, i64 1996064986, i64 2198950837, i64 2554220882, i64 3999719339, i64 2821834349, i64 766784016, i64 2952996808, i64 2566594879, i64 3210313671, i64 3203337956, i64 3336571891, i64 1034457026, i64 3584528711, i64 2466948901, i64 113926993, i64 3758326383, i64 338241895, i64 168717936, i64 666307205, i64 1188179964, i64 773529912, i64 1546045734, i64 1294757372, i64 1522805485, i64 1396182291, i64 2643833823, i64 1695183700, i64 2343527390, i64 1986661051, i64 1014477480, i64 2177026350, i64 1206759142, i64 2456956037, i64 344077627, i64 2730485921, i64 1290863460, i64 2820302411, i64 3158454273, i64 3259730800, i64 3505952657, i64 3345764771, i64 106217008, i64 3516065817, i64 3606008344, i64 3600352804, i64 1432725776, i64 4094571909, i64 1467031594, i64 275423344, i64 851169720, i64 430227734, i64 3100823752, i64 506948616, i64 1363258195, i64 659060556, i64 3750685593, i64 883997877, i64 3785050280, i64 958139571, i64 3318307427, i64 1322822218, i64 3812723403, i64 1537002063, i64 2003034995, i64 1747873779, i64 3602036899, i64 1955562222, i64 1575990012, i64 2024104815, i64 1125592928, i64 2227730452, i64 2716904306, i64 2361852424, i64 442776044, i64 2428436474, i64 593698344, i64 2756734187, i64 3733110249, i64 3204031479, i64 2999351573, i64 3329325298, i64 3815920427, i64 3391569614, i64 3928383900, i64 3515267271, i64 566280711, i64 3940187606, i64 3454069534, i64 4118630271, i64 4000239992, i64 116418474, i64 1914138554, i64 174292421, i64 2731055270, i64 289380356, i64 3203993006, i64 460393269, i64 320620315, i64 685471733, i64 587496836, i64 852142971, i64 1086792851, i64 1017036298, i64 365543100, i64 1126000580, i64 2618297676, i64 1288033470, i64 3409855158, i64 1501505948, i64 4234509866, i64 1607167915, i64 987167468, i64 1816402316, i64 1246189591]
@.lty4511 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4511 = private global ptr null
@.lcd4511 = private unnamed_addr constant [16 x i64] [i64 1779033703, i64 3144134277, i64 1013904242, i64 2773480762, i64 1359893119, i64 2600822924, i64 528734635, i64 1541459225, i64 4089235720, i64 2227873595, i64 4271175723, i64 1595750129, i64 2917565137, i64 725511199, i64 4215389547, i64 327033209]
@.lty4520 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4527 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4537 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4537 = private global ptr null
@.lcd4537 = private unnamed_addr constant [1 x i64] [i64 128]
@.lty4563 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4646 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4661 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty4751 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4758 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4768 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc4768 = private global ptr null
@.lcd4768 = private unnamed_addr constant [16 x i64] [i64 1779033703, i64 4089235720, i64 3144134277, i64 2227873595, i64 1013904242, i64 4271175723, i64 2773480762, i64 1595750129, i64 1359893119, i64 2917565137, i64 2600822924, i64 725511199, i64 528734635, i64 4215389547, i64 1541459225, i64 327033209]
@.lty4873 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty4957 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
declare void @llvm.trap()
define linkonce_odr i512 @e.sha512(i512 %s, i512 %lo, i512 %hi) "probe-stack"="inline-asm" {
entry:
  call void @llvm.trap()
  ret i512 %s
}
@.lty5433 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5451 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc5451 = private global ptr null
@.lcd5451 = private unnamed_addr constant [1 x i64] [i64 128]
@.lty5475 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5482 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5489 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5496 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5505 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty5584 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5627 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5675 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5719 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty5794 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5834 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5854 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc5854 = private global ptr null
@.lcd5854 = private unnamed_addr constant [5 x i64] [i64 1732584193, i64 4023233417, i64 2562383102, i64 271733878, i64 3285377520]
@.lty5857 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty6399 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6698 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6781 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6828 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6887 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6944 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6963 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty7230 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7238 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7272 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty7291 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7302 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7312 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7324 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7334 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7343 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB7419 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty7512 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB7520 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty7523 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7523 = private global ptr null
@.lcd7523 = private unnamed_addr constant [12 x i64] [i64 132, i64 106, i64 83, i64 105, i64 103, i64 110, i64 97, i64 116, i64 117, i64 114, i64 101, i64 49]
@.lty7526 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty7532 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7532 = private global ptr null
@.lcd7532 = private unnamed_addr constant [4 x i64] [i64 162, i64 1, i64 39, i64 4]
@.ltyB7535 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.s7537 = private unnamed_addr constant [1 x i8] c"\00"
@.s7547 = private unnamed_addr constant [1 x i8] c"\00"
@.s7554 = private unnamed_addr constant [1 x i8] c"\00"
@.s7559 = private unnamed_addr constant [1 x i8] c"\00"
@.s7566 = private unnamed_addr constant [1 x i8] c"\00"
@.s7585 = private unnamed_addr constant [1 x i8] c"\00"
@.s7612 = private unnamed_addr constant [1 x i8] c"\00"
@.s7648 = private unnamed_addr constant [21 x i8] c"cose: missing tag 18\00"
@.s7666 = private unnamed_addr constant [24 x i8] c"cose: expected array(4)\00"
@.s7674 = private unnamed_addr constant [27 x i8] c"cose: bad protected header\00"
@.s7692 = private unnamed_addr constant [37 x i8] c"cose: expected empty unprotected map\00"
@.s7700 = private unnamed_addr constant [18 x i8] c"cose: bad payload\00"
@.s7714 = private unnamed_addr constant [20 x i8] c"cose: bad signature\00"
@.s7717 = private unnamed_addr constant [1 x i8] c"\00"
@.lty7736 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty7738 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7738 = private global ptr null
@.lcd7738 = private unnamed_addr constant [10 x i64] [i64 131, i64 104, i64 69, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48]
@.lty7742 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7742 = private global ptr null
@.lcd7742 = private unnamed_addr constant [4 x i64] [i64 161, i64 1, i64 24, i64 24]
@.lty7744 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7744 = private global ptr null
@.lcd7744 = private unnamed_addr constant [25 x i64] [i64 114, i64 101, i64 115, i64 105, i64 100, i64 47, i64 99, i64 111, i64 115, i64 101, i64 47, i64 101, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48, i64 47, i64 110, i64 111, i64 110, i64 99, i64 101]
@.lty7755 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7755 = private global ptr null
@.lcd7755 = private unnamed_addr constant [16 x i64] [i64 131, i64 104, i64 69, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48, i64 68, i64 161, i64 1, i64 24, i64 24, i64 64]
@.lty7759 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc7759 = private global ptr null
@.lcd7759 = private unnamed_addr constant [9 x i64] [i64 208, i64 131, i64 68, i64 161, i64 1, i64 24, i64 24, i64 161, i64 5]
@.ltyB7763 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.s7792 = private unnamed_addr constant [21 x i8] c"cose: missing tag 16\00"
@.s7810 = private unnamed_addr constant [24 x i8] c"cose: expected array(3)\00"
@.s7818 = private unnamed_addr constant [27 x i8] c"cose: bad protected header\00"
@.s7836 = private unnamed_addr constant [34 x i8] c"cose: expected unprotected map(1)\00"
@.s7854 = private unnamed_addr constant [24 x i8] c"cose: expected iv key 5\00"
@.s7868 = private unnamed_addr constant [26 x i8] c"cose: iv must be 12 bytes\00"
@.s7882 = private unnamed_addr constant [21 x i8] c"cose: bad ciphertext\00"
@.s7895 = private unnamed_addr constant [28 x i8] c"cose: authentication failed\00"
@.s7905 = private unnamed_addr constant [1 x i8] c"\00"
@.lty7920 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty7942 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.s7951 = private unnamed_addr constant [4 x i8] c"mul\00"
@.s7955 = private unnamed_addr constant [4 x i8] c"mod\00"
@.s7960 = private unnamed_addr constant [7 x i8] c"modmul\00"
@.s7964 = private unnamed_addr constant [4 x i8] c"inv\00"
@.lty7975 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.s7978 = private unnamed_addr constant [4 x i8] c"gcd\00"
@.s7982 = private unnamed_addr constant [4 x i8] c"shr\00"
@.lty7988 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.lty8006 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8006 = private global ptr null
@.lcd8006 = private unnamed_addr constant [1 x i64] [i64 12345]
@.lty8009 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8009 = private global ptr null
@.lcd8009 = private unnamed_addr constant [1 x i64] [i64 999]
@resid.cap.main = unnamed_addr constant [5 x i8] c"args\00"
@resid.cap.main.1 = unnamed_addr constant [5 x i8] c"args\00"
@resid.cap.main.2 = unnamed_addr constant [5 x i8] c"args\00"
@.ltyB8072 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty8287 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.oty8320 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox8320 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty8320}, align 16
@.oty8341 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox8341 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty8341}, align 16
@.oty8344 = private unnamed_addr constant [18 x i8] c"Option(List(Int))\00"
@.lty8380 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8425 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8504 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8598 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty8632 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8724 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8765 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB8803 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty8804 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8810 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8810 = private global ptr null
@.lcd8810 = private unnamed_addr constant [1 x i64] [i64 0]
@.lty8852 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8874 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8972 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9149 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9258 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9966 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10367 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10369 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.s10380 = private unnamed_addr constant [28 x i8] c"bn_divmod: division by zero\00"
@.lty10382 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.ltyE10391 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10394 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty10412 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10422 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10432 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10442 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10452 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10462 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10472 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10482 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.s10792 = private unnamed_addr constant [1 x i8] c"\00"
@.lty10800 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10809 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10820 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10845 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10855 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10865 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10875 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10885 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10895 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10905 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10915 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
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
