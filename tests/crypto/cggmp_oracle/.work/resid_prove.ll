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
define i128 @__m_________lib_bignum_resid__bn_base() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i128 18446744073709551616
}
define i64 @__m_________lib_bignum_resid__bn_top(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t11 = call i64 @__m_________lib_bignum_resid__bn_top(ptr %p0, i64 %t10)
%t12 = call i64 @resid_list_len(ptr %p0)
%t13 = icmp eq i64 %t11, %t12
br i1 %t13, label %L7, label %L9
L7:
ret ptr %p0
L9:
%t14 = call ptr @resid_listbuf_new()
%t15 = call ptr @__m_________lib_bignum_resid__bn_take(ptr %p0, i64 %t11, i64 0, ptr %t14)
ret ptr %t15
}
define ptr @__m_________lib_bignum_resid__bn_take(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t60 = call i64 @__m_________lib_bignum_resid__bn_cmp_at(ptr %p0, ptr %p1, i64 %t59)
ret i64 %t60
}
define i64 @__m_________lib_bignum_resid__bn_cmp_at(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t88 = call ptr @__m_________lib_bignum_resid__bn_be_at(ptr %p0, i64 %t86, i64 0, ptr %t87)
ret ptr %t88
}
define ptr @__m_________lib_bignum_resid__bn_be_at(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t134 = call ptr @__m_________lib_bignum_resid__bn_from_be_at(ptr %p0, i64 %t132, i64 0, ptr %t133)
%t135 = musttail call ptr @bn_trim(ptr %t134)
ret ptr %t135
}
define ptr @__m_________lib_bignum_resid__bn_from_be_at(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t139 = call i64 @__m_________lib_bignum_resid__bn_limb_be(ptr %p0, i64 %p2, i64 0, i64 0)
%t140 = call ptr @resid_box_i64(i64 %t139)
%t143 = call ptr @resid_listbuf_push(ptr %p3, ptr %t140)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m_________lib_bignum_resid__bn_limb_be(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i64 @__m_________lib_bignum_resid__bn_limb_bits(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t208 = call i64 @__m_________lib_bignum_resid__bn_limb_bits(i64 %t206, i64 0)
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
%t252 = call ptr @__m_________lib_bignum_resid__bn_shl_at(ptr %p0, i64 %t246, i64 %t247, i64 0, i64 %t250, ptr %t251)
%t253 = call ptr @bn_trim(ptr %t252)
ret ptr %t253
}
define ptr @__m_________lib_bignum_resid__bn_shl_at(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t260 = call i64 @__m_________lib_bignum_resid__bn_get(ptr %p0, i64 %t257)
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
%t269 = call i64 @__m_________lib_bignum_resid__bn_get(ptr %p0, i64 %t266)
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
define i64 @__m_________lib_bignum_resid__bn_get(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t322 = call ptr @__m_________lib_bignum_resid__bn_shr_at(ptr %p0, i64 %t313, i64 %t314, i64 0, i64 %t320, ptr %t321)
%t323 = call ptr @bn_trim(ptr %t322)
ret ptr %t323
}
define ptr @__m_________lib_bignum_resid__bn_shr_at(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t330 = call i64 @__m_________lib_bignum_resid__bn_get(ptr %p0, i64 %t327)
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
%t339 = call i64 @__m_________lib_bignum_resid__bn_get(ptr %p0, i64 %t336)
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
%t382 = call ptr @__m_________lib_bignum_resid__bn_add_at(ptr %p0, ptr %p1, i64 0, i64 %t380, i64 0, ptr %t381)
ret ptr %t382
}
define ptr @__m_________lib_bignum_resid__bn_add_at(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t392 = call i64 @__m_________lib_bignum_resid__bn_get(ptr %p0, i64 %p2)
%t393 = zext i64 %t392 to i128
%t394 = call i64 @__m_________lib_bignum_resid__bn_get(ptr %p1, i64 %p2)
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
%t426 = call ptr @__m_________lib_bignum_resid__bn_sub_at(ptr %p0, ptr %p1, i64 0, i64 %t424, i64 0, ptr %t425)
%t427 = call ptr @bn_trim(ptr %t426)
ret ptr %t427
}
define ptr @__m_________lib_bignum_resid__bn_sub_at(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t437 = call i64 @__m_________lib_bignum_resid__bn_get(ptr %p0, i64 %p2)
%t438 = zext i64 %t437 to i128
%t439 = call {i128, i1} @llvm.uadd.with.overflow.i128(i128 %t431, i128 %t438)
%t440 = extractvalue {i128, i1} %t439, 0
%t441 = extractvalue {i128, i1} %t439, 1
%t442 = zext i1 %t441 to i8
call void @resid_overflow_check(i8 %t442)
%t443 = call i64 @__m_________lib_bignum_resid__bn_get(ptr %p1, i64 %p2)
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
%t477 = call ptr @__m_________lib_bignum_resid__bn_mul_cols(ptr %p0, ptr %p1, i64 0, i64 %t474, i256 %t475, ptr %t476)
%t478 = call ptr @bn_trim(ptr %t477)
ret ptr %t478
}
define ptr @__m_________lib_bignum_resid__bn_mul_cols(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i256 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t501 = call i256 @__m_________lib_bignum_resid__bn_col(ptr %p0, ptr %p1, i64 %p2, i64 %t494, i64 %t500, i256 %p4)
%t502 = add nsw i64 %p2, 1
%t503 = lshr i256 %t501, 64
%t504 = trunc i256 %t501 to i64
%t505 = call ptr @resid_box_i64(i64 %t504)
%t508 = call ptr @resid_listbuf_push(ptr %p5, ptr %t505)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i256 @__m_________lib_bignum_resid__bn_col(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i256 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t550 = call ptr @__m_________lib_bignum_resid__bn_divmod_short(ptr %p0, i64 %t548)
ret ptr %t550
L114:
%t551 = call i64 @resid_list_len(ptr %p1)
%t552 = sub nsw i64 %t551, 1
%t553 = call ptr @resid_list_get(ptr %p1, i64 %t552)
%t554 = call i64 @resid_unbox_i64(ptr %t553)
%t556 = call i64 @__m_________lib_bignum_resid__bn_limb_bits(i64 %t554, i64 0)
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
%t575 = call ptr @__m_________lib_bignum_resid__bn_div_loop(ptr %t569, ptr %t561, i64 %t570, i64 %t573, ptr %t574)
%t576 = call ptr @resid_gmalloc(i64 16)
%t577 = getelementptr i8, ptr %t575, i64 8
%t578 = load ptr, ptr %t577, align 8
%t579 = call ptr @bn_trim(ptr %t578)
%t576.f0 = getelementptr i8, ptr %t576, i64 0
store ptr %t579, ptr %t576.f0, align 8
%t580 = getelementptr i8, ptr %t575, i64 0
%t581 = load ptr, ptr %t580, align 8
%t582 = call ptr @resid_listbuf_new()
%t583 = call ptr @__m_________lib_bignum_resid__bn_take(ptr %t581, i64 %t570, i64 0, ptr %t582)
%t584 = call ptr @bn_trim(ptr %t583)
%t585 = call ptr @bn_shr(ptr %t584, i64 %t558)
%t576.f1 = getelementptr i8, ptr %t576, i64 8
store ptr %t585, ptr %t576.f1, align 8
ret ptr %t576
}
define ptr @__m_________lib_bignum_resid__bn_div_loop(ptr %p0, ptr %p1, i64 %p2, i64 %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t586 = call ptr @__m_________lib_bignum_resid__bn_div_step(ptr %p0, ptr %p1, i64 %p2, i64 %p3, i64 %p3, ptr %p4)
ret ptr %t586
}
define ptr @__m_________lib_bignum_resid__bn_div_step(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t590 = call ptr @__m_________lib_bignum_resid__bn_reverse(ptr %t589)
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
%t656 = call i128 @__m_________lib_bignum_resid__bn_qfix(i128 %t627, i128 %t633, i128 %t620, i128 %t643, i128 %t655)
%t657 = sext i64 0 to i128
%t658 = call ptr @__m_________lib_bignum_resid__bn_mulsub(ptr %p0, ptr %p1, i128 %t656, i64 %p4, i64 0, i128 %t657, i64 0, i64 %p2)
%t659 = getelementptr i8, ptr %t658, i64 0
%t660 = load ptr, ptr %t659, align 8
%t661 = getelementptr i8, ptr %t658, i64 8
%t662 = load i64, ptr %t661, align 8
%t663 = icmp eq i64 %t662, 0
br i1 %t663, label %L121, label %L122
L121:
br label %L123
L122:
%t664 = call ptr @__m_________lib_bignum_resid__bn_addback(ptr %t660, ptr %p1, i64 %p4, i64 0, i64 0, i64 %p2)
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
define ptr @__m_________lib_bignum_resid__bn_reverse(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t694 = call i64 @resid_list_len(ptr %p0)
%t695 = sub nsw i64 %t694, 1
%t696 = call ptr @resid_listbuf_new()
%t697 = call ptr @__m_________lib_bignum_resid__bn_rev_at(ptr %p0, i64 %t695, ptr %t696)
ret ptr %t697
}
define ptr @__m_________lib_bignum_resid__bn_rev_at(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i128 @__m_________lib_bignum_resid__bn_qfix(i128 %p0.in, i128 %p1.in, i128 %p2.in, i128 %p3.in, i128 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define ptr @__m_________lib_bignum_resid__bn_mulsub(ptr %p0.in, ptr %p1.in, i128 %p2.in, i64 %p3.in, i64 %p4.in, i128 %p5.in, i64 %p6.in, i64 %p7.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define ptr @__m_________lib_bignum_resid__bn_addback(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define ptr @__m_________lib_bignum_resid__bn_divmod_short(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t925 = call i64 @resid_list_len(ptr %p0)
%t926 = sub nsw i64 %t925, 1
%t927 = sext i64 0 to i128
%t928 = call ptr @resid_listbuf_new()
%t929 = call ptr @__m_________lib_bignum_resid__bn_short_at(ptr %p0, i64 %p1, i64 %t926, i128 %t927, ptr %t928)
ret ptr %t929
}
define ptr @__m_________lib_bignum_resid__bn_short_at(ptr %p0.in, i64 %p1.in, i64 %p2.in, i128 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t933 = call ptr @__m_________lib_bignum_resid__bn_reverse(ptr %t932)
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
%t1017 = call ptr @__m_________lib_bignum_resid__bn_inv_loop(ptr %p1, ptr %t1009, ptr %t1014, ptr %t1016, ptr %p1)
ret ptr %t1017
}
define ptr @__m_________lib_bignum_resid__bn_inv_loop(ptr %p0.in, ptr %p1.in, ptr %p2.in, ptr %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define ptr @__m_________lib_bignum_resid__bn_neg_inv(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1038 = call ptr @resid_list_const_i64(ptr @.lc1037, i64 1, ptr @.lcd1037, ptr @.lty1037)
%t1039 = call ptr @__m_________lib_bignum_resid__bn_newton(ptr %p0, i64 %p1, ptr %t1038, i64 1)
%t1041 = call ptr @resid_list_const_i64(ptr @.lc1040, i64 1, ptr @.lcd1040, ptr @.lty1040)
%t1042 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 64, i64 %p1)
%t1043 = extractvalue {i64, i1} %t1042, 0
%t1044 = extractvalue {i64, i1} %t1042, 1
%t1045 = zext i1 %t1044 to i8
call void @resid_overflow_check(i8 %t1045)
%t1046 = call ptr @bn_shl(ptr %t1041, i64 %t1043)
%t1047 = call ptr @__m_________lib_bignum_resid__bn_low(ptr %t1039, i64 %p1)
%t1048 = call ptr @bn_sub(ptr %t1046, ptr %t1047)
%t1049 = musttail call ptr @__m_________lib_bignum_resid__bn_low(ptr %t1048, i64 %p1)
ret ptr %t1049
}
define ptr @__m_________lib_bignum_resid__bn_newton(ptr %p0.in, i64 %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t1056 = call ptr @__m_________lib_bignum_resid__bn_low(ptr %t1055, i64 %p1)
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
%t1068 = call ptr @__m_________lib_bignum_resid__bn_low(ptr %t1067, i64 %p1)
%t1069 = call ptr @bn_mul(ptr %p2, ptr %t1068)
%t1070 = call ptr @__m_________lib_bignum_resid__bn_low(ptr %t1069, i64 %p1)
%t1071 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p3, i64 2)
%t1072 = extractvalue {i64, i1} %t1071, 0
%t1073 = extractvalue {i64, i1} %t1071, 1
%t1074 = zext i1 %t1073 to i8
call void @resid_overflow_check(i8 %t1074)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m_________lib_bignum_resid__bn_low(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1076 = call i64 @resid_list_len(ptr %p0)
%t1077 = icmp sle i64 %t1076, %p1
br i1 %t1077, label %L172, label %L174
L172:
ret ptr %p0
L174:
%t1078 = call ptr @resid_listbuf_new()
%t1079 = call ptr @__m_________lib_bignum_resid__bn_take(ptr %p0, i64 %p1, i64 0, ptr %t1078)
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
%t1097 = call ptr @__m_________lib_bignum_resid__bn_neg_inv(ptr %p0, i64 %t1090)
%t1096.f2 = getelementptr i8, ptr %t1096, i64 16
store ptr %t1097, ptr %t1096.f2, align 8
%t1096.f3 = getelementptr i8, ptr %t1096, i64 24
store ptr %t1095, ptr %t1096.f3, align 8
ret ptr %t1096
}
define ptr @__m_________lib_bignum_resid__bn_redc(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1098 = getelementptr i8, ptr %p0, i64 8
%t1099 = load i64, ptr %t1098, align 8
%t1100 = call ptr @__m_________lib_bignum_resid__bn_low(ptr %p1, i64 %t1099)
%t1101 = getelementptr i8, ptr %p0, i64 16
%t1102 = load ptr, ptr %t1101, align 8
%t1103 = call ptr @bn_mul(ptr %t1100, ptr %t1102)
%t1104 = getelementptr i8, ptr %p0, i64 8
%t1105 = load i64, ptr %t1104, align 8
%t1106 = call ptr @__m_________lib_bignum_resid__bn_low(ptr %t1103, i64 %t1105)
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
define ptr @__m_________lib_bignum_resid__bn_mont_mul(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1127 = call ptr @bn_mul(ptr %p1, ptr %p2)
%t1128 = call ptr @resid_list_freeze(ptr %t1127)
%t1129 = call ptr @__m_________lib_bignum_resid__bn_redc(ptr %p0, ptr %t1128)
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
%t1148 = call ptr @__m_________lib_bignum_resid__bn_native_exp(ptr %p1, ptr %p2, ptr %t1141, i64 %t1145)
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
%t1160 = call ptr @__m_________lib_bignum_resid__bn_native_exp(ptr %p1, ptr %p2, ptr %t1153, i64 %t1157)
ret ptr %t1160
L186:
%t1161 = musttail call ptr @__m_________lib_bignum_resid__bn_modexp_lists(ptr %p0, ptr %p1, ptr %p2)
ret ptr %t1161
}
define ptr @__m_________lib_bignum_resid__bn_modexp_lists(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1162 = getelementptr i8, ptr %p0, i64 24
%t1163 = load ptr, ptr %t1162, align 8
%t1164 = call ptr @__m_________lib_bignum_resid__bn_mont_mul(ptr %p0, ptr %p1, ptr %t1163)
%t1166 = call ptr @resid_list_const_i64(ptr @.lc1165, i64 1, ptr @.lcd1165, ptr @.lty1165)
%t1167 = getelementptr i8, ptr %p0, i64 24
%t1168 = load ptr, ptr %t1167, align 8
%t1169 = call ptr @__m_________lib_bignum_resid__bn_mont_mul(ptr %p0, ptr %t1166, ptr %t1168)
%t1170 = call ptr @resid_list_freeze(ptr %t1169)
%t1171 = call i64 @bn_bit_len(ptr %p2)
%t1172 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t1171, i64 1)
%t1173 = extractvalue {i64, i1} %t1172, 0
%t1174 = extractvalue {i64, i1} %t1172, 1
%t1175 = zext i1 %t1174 to i8
call void @resid_overflow_check(i8 %t1175)
%t1176 = call ptr @__m_________lib_bignum_resid__bn_exp_bits(ptr %p0, ptr %t1164, ptr %p2, i64 %t1173, ptr %t1170)
%t1177 = call ptr @resid_list_freeze(ptr %t1176)
%t1178 = call ptr @__m_________lib_bignum_resid__bn_redc(ptr %p0, ptr %t1177)
ret ptr %t1178
}
define ptr @__m_________lib_bignum_resid__bn_exp_bits(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t1180 = call ptr @__m_________lib_bignum_resid__bn_mont_mul(ptr %p0, ptr %p4, ptr %p4)
%t1181 = call i64 @bn_bit(ptr %p2, i64 %p3)
%t1182 = icmp eq i64 %t1181, 1
br i1 %t1182, label %L190, label %L191
L190:
%t1183 = call ptr @__m_________lib_bignum_resid__bn_mont_mul(ptr %p0, ptr %t1180, ptr %p1)
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
%t1201 = call ptr @__m_________lib_bignum_resid__bn_modexp_plain(ptr %t1192, ptr %p1, ptr %p2, i64 %t1195, ptr %t1200)
ret ptr %t1201
}
define ptr @__m_________lib_bignum_resid__bn_modexp_plain(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t1215 = call i64 @__m_________lib_bignum_resid__bn_trailing_zeros(ptr %t1214, i64 0)
%t1216 = call ptr @bn_shr(ptr %t1214, i64 %t1215)
%t1217 = call i1 @__m_________lib_bignum_resid__bn_mr_each(ptr %t1211, ptr %t1214, ptr %t1216, i64 %t1215, ptr %p1, i64 0)
ret i1 %t1217
}
define i64 @__m_________lib_bignum_resid__bn_trailing_zeros(ptr %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i1 @__m_________lib_bignum_resid__bn_mr_each(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t1234 = call i1 @__m_________lib_bignum_resid__bn_mr_witness(ptr %p0, ptr %p1, ptr %p2, i64 %p3, ptr %t1231)
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
define i1 @__m_________lib_bignum_resid__bn_mr_witness(ptr %p0, ptr %p1, ptr %p2, i64 %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t1254 = call i1 @__m_________lib_bignum_resid__bn_mr_square(ptr %p0, ptr %p1, ptr %t1241, i64 %t1251)
ret i1 %t1254
}
define i1 @__m_________lib_bignum_resid__bn_mr_square(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t1268 = call ptr @__m_________lib_bignum_resid__bn_sp_from(i64 %p0, i64 3, ptr %t1267)
ret ptr %t1268
}
define ptr @__m_________lib_bignum_resid__bn_sp_from(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t1271 = call i1 @__m_________lib_bignum_resid__bn_sp_is_prime(i64 %p1, i64 3)
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
define i1 @__m_________lib_bignum_resid__bn_sp_is_prime(i64 %p0.in, i64 %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i64 @__m_________lib_bignum_resid__bn_safe_window() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t1311 = call ptr @__m_________lib_bignum_resid__bn_take_int(ptr %p0, i64 %t1309, i64 0, ptr %t1310)
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
%t1341 = call ptr @__m_________lib_bignum_resid__bn_residues(ptr %t1337, ptr %t1339, i64 0, ptr %t1340)
%t1343 = call ptr @resid_list_const_i64(ptr @.lc1342, i64 302, ptr @.lcd1342, ptr @.lty1342)
%t1344 = call ptr @__m_________lib_bignum_resid__bn_safe_search(ptr %t1337, ptr %t1343, ptr %t1341, i64 0)
ret ptr %t1344
}
define ptr @__m_________lib_bignum_resid__bn_take_int(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define ptr @__m_________lib_bignum_resid__bn_residues(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i1 @__m_________lib_bignum_resid__bn_sieve_ok(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define ptr @__m_________lib_bignum_resid__bn_safe_search(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t1506 = call i1 @__m_________lib_bignum_resid__bn_sieve_ok(ptr %p1, ptr %p2, i64 %p3, i64 0)
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
%t1792 = call ptr @__m_________lib_bignum_resid__bn_and_at(ptr %p0, ptr %p1, i64 0, i64 %t1790, ptr %t1791)
%t1793 = call ptr @bn_trim(ptr %t1792)
ret ptr %t1793
}
define ptr @__m_________lib_bignum_resid__bn_and_at(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t1816 = call ptr @__m_________lib_bignum_resid__bn_or_at(ptr %p0, ptr %p1, i64 0, i64 %t1814, ptr %t1815)
ret ptr %t1816
}
define ptr @__m_________lib_bignum_resid__bn_or_at(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t1820 = call i64 @__m_________lib_bignum_resid__bn_get(ptr %p0, i64 %p2)
%t1821 = call i64 @__m_________lib_bignum_resid__bn_get(ptr %p1, i64 %p2)
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
%t1837 = call ptr @__m_________lib_bignum_resid__bn_sps_from(ptr %p0, i64 %p1, i64 %t1836, i64 0)
ret ptr %t1837
}
define ptr @__m_________lib_bignum_resid__bn_sps_from(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t1862 = call ptr @__m_________lib_bignum_resid__bn_sps_from(ptr %p0, i64 %p1, i64 %p2, i64 %t1859)
br label %L276
L276:
%t1863 = phi ptr [ %t1857, %L274 ], [ %t1862, %L275 ]
ret ptr %t1863
}
define ptr @bn_slice_int(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1864 = call ptr @resid_listbuf_new()
%t1865 = call ptr @__m_________lib_bignum_resid__bn_slice_at(ptr %p0, i64 %p1, i64 %p2, i64 0, ptr %t1864)
ret ptr %t1865
}
define ptr @__m_________lib_bignum_resid__bn_slice_at(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t1882 = call i64 @__m_________lib_bignum_resid__bn_jac(ptr %t1881, ptr %p1, i64 1)
ret i64 %t1882
}
define i64 @__m_________lib_bignum_resid__bn_jac(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i4224 @__m_________lib_bignum_resid__bw_mask() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i4224 @__m_________lib_bignum_resid__bw_of(ptr %p0.in, i64 %p1.in, i4224 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define ptr @__m_________lib_bignum_resid__bw_to(i4224 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i4224 @__m_________lib_bignum_resid__bw_ninv(i4224 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t1971 = call i4224 @__m_________lib_bignum_resid__bw_mask()
%t1972 = and i4224 %p0, %t1971
%t1973 = and i4224 %p0, %t1971
%t1974 = call i4224 @__m_________lib_bignum_resid__bw_newton(i4224 %t1972, i4224 %t1973, i64 0, i4224 %t1971)
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
define i4224 @__m_________lib_bignum_resid__bw_newton(i4224 %p0.in, i4224 %p1.in, i64 %p2.in, i4224 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i4224 @__m_________lib_bignum_resid__bw_double(i4224 %p0.in, i4224 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i4224 @__m_________lib_bignum_resid__bw_mm1(i4224 %p0, i4224 %p1, i4224 %p2, i4224 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2016 = call i4224 @__m_________lib_bignum_resid__bw_mask()
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
define i4224 @__m_________lib_bignum_resid__bw_mm2(i4224 %p0, i4224 %p1, i4224 %p2, i4224 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2043 = call i4224 @__m_________lib_bignum_resid__bw_mask()
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
define i4224 @__m_________lib_bignum_resid__bw_mul(i1 %p0, i4224 %p1, i4224 %p2, i4224 %p3, i4224 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br i1 %p0, label %L319, label %L320
L319:
%t2245 = call i4224 @__m_________lib_bignum_resid__bw_mm2(i4224 %p1, i4224 %p2, i4224 %p3, i4224 %p4)
br label %L321
L320:
%t2246 = call i4224 @__m_________lib_bignum_resid__bw_mm1(i4224 %p1, i4224 %p2, i4224 %p3, i4224 %p4)
br label %L321
L321:
%t2247 = phi i4224 [ %t2245, %L319 ], [ %t2246, %L320 ]
ret i4224 %t2247
}
define i4224 @__m_________lib_bignum_resid__bw_exp(i1 %p0.in, i4224 %p1.in, ptr %p2.in, i64 %p3.in, i4224 %p4.in, i4224 %p5.in, i4224 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t2249 = call i4224 @__m_________lib_bignum_resid__bw_mul(i1 %p0, i4224 %p6, i4224 %p6, i4224 %p4, i4224 %p5)
%t2250 = call i64 @bn_bit(ptr %p2, i64 %p3)
%t2251 = icmp eq i64 %t2250, 1
br i1 %t2251, label %L325, label %L326
L325:
%t2252 = call i4224 @__m_________lib_bignum_resid__bw_mul(i1 %p0, i4224 %t2249, i4224 %p1, i4224 %p4, i4224 %p5)
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
define ptr @__m_________lib_bignum_resid__bn_native_exp(ptr %p0, ptr %p1, ptr %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t2261 = call i4224 @__m_________lib_bignum_resid__bw_of(ptr %p2, i64 %t2259, i4224 %t2260)
%t2262 = call i4224 @__m_________lib_bignum_resid__bw_ninv(i4224 %t2261)
%t2263 = sext i64 1 to i4224
%t2264 = call i4224 @__m_________lib_bignum_resid__bw_double(i4224 %t2263, i4224 %t2261, i64 %t2257)
%t2265 = call i4224 @__m_________lib_bignum_resid__bw_double(i4224 %t2264, i4224 %t2261, i64 %t2257)
%t2266 = call i64 @resid_list_len(ptr %p0)
%t2267 = sub nsw i64 %t2266, 1
%t2268 = sext i64 0 to i4224
%t2269 = call i4224 @__m_________lib_bignum_resid__bw_of(ptr %p0, i64 %t2267, i4224 %t2268)
%t2270 = call i4224 @__m_________lib_bignum_resid__bw_mul(i1 %t2256, i4224 %t2269, i4224 %t2265, i4224 %t2261, i4224 %t2262)
%t2271 = call i64 @bn_bit_len(ptr %p1)
%t2272 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t2271, i64 1)
%t2273 = extractvalue {i64, i1} %t2272, 0
%t2274 = extractvalue {i64, i1} %t2272, 1
%t2275 = zext i1 %t2274 to i8
call void @resid_overflow_check(i8 %t2275)
%t2276 = call i4224 @__m_________lib_bignum_resid__bw_exp(i1 %t2256, i4224 %t2270, ptr %p1, i64 %t2273, i4224 %t2261, i4224 %t2262, i4224 %t2264)
%t2277 = sext i64 1 to i4224
%t2278 = call i4224 @__m_________lib_bignum_resid__bw_mul(i1 %t2256, i4224 %t2276, i4224 %t2277, i4224 %t2261, i4224 %t2262)
%t2279 = call i64 @resid_list_len(ptr %p2)
%t2280 = call ptr @resid_listbuf_new()
%t2281 = call ptr @__m_________lib_bignum_resid__bw_to(i4224 %t2278, i64 %t2279, i64 0, ptr %t2280)
ret ptr %t2281
}
define i64 @__m_________lib_word_resid__wi_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2282 = xor i64 %p0, %p1
ret i64 %t2282
}
define i64 @__m_________lib_word_resid__wi_and(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2283 = and i64 %p0, %p1
ret i64 %t2283
}
define i64 @__m_________lib_word_resid__wi_or(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2284 = or i64 %p0, %p1
ret i64 %t2284
}
define i64 @__m_________lib_word_resid__wi_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2285 = call i64 @wrapping_add(i64 %p0, i64 %p1)
%t2286 = and i64 %t2285, 4294967295
ret i64 %t2286
}
define i64 @__m_________lib_word_resid__wi_addk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2287 = call i64 @wrapping_add(i64 %p0, i64 %p1)
%t2288 = and i64 %t2287, 4294967295
ret i64 %t2288
}
define i64 @__m_________lib_word_resid__wi_xork(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2289 = xor i64 %p0, %p1
ret i64 %t2289
}
define i64 @__m_________lib_word_resid__wi_andk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2290 = and i64 %p0, %p1
ret i64 %t2290
}
define i64 @__m_________lib_word_resid__wi_rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i64 @__m_________lib_word_resid__wi_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2305 = icmp uge i64 %p1, 64
%t2306 = add i64 %p1, 0
%t2307 = select i1 %t2305, i64 63, i64 %t2306
%t2308 = ashr i64 %p0, %t2307
ret i64 %t2308
}
define i64 @__m_________lib_word_resid__wi_shl(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2309 = icmp uge i64 %p1, 64
%t2310 = add i64 %p1, 0
%t2311 = shl i64 %p0, %t2310
%t2312 = select i1 %t2309, i64 0, i64 %t2311
%t2313 = and i64 %t2312, 4294967295
ret i64 %t2313
}
define i64 @__m_________lib_word_resid__wi_not(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2314 = xor i64 %p0, 4294967295
%t2315 = and i64 %t2314, 4294967295
ret i64 %t2315
}
define i64 @__m_________lib_word_resid__wi_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i64 @__m_________lib_word_resid__wi_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2316 = and i64 %p0, 255
ret i64 %t2316
}
define i64 @__m_________lib_word_resid__wi_byte(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2317 = icmp uge i64 %p1, 64
%t2318 = add i64 %p1, 0
%t2319 = select i1 %t2317, i64 63, i64 %t2318
%t2320 = ashr i64 %p0, %t2319
%t2321 = and i64 %t2320, 255
ret i64 %t2321
}
define i64 @__m_________lib_word_resid__bi_xork(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2322 = xor i64 %p0, %p1
ret i64 %t2322
}
define i64 @__m_________lib_word_resid__bi_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2323 = xor i64 %p0, %p1
ret i64 %t2323
}
define i64 @__m_________lib_word_resid__bi_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i32 @__m_________lib_word_resid__ws_xor(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2324 = xor i32 %p0, %p1
ret i32 %t2324
}
define i32 @__m_________lib_word_resid__ws_and(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2325 = and i32 %p0, %p1
ret i32 %t2325
}
define i32 @__m_________lib_word_resid__ws_or(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2326 = or i32 %p0, %p1
ret i32 %t2326
}
define i32 @__m_________lib_word_resid__ws_add(i32 %p0, i32 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2327 = add i32 %p0, %p1
ret i32 %t2327
}
define i32 @__m_________lib_word_resid__ws_addk(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2328 = trunc i64 %p1 to i32
%t2329 = add i32 %p0, %t2328
ret i32 %t2329
}
define i32 @__m_________lib_word_resid__ws_xork(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2330 = trunc i64 %p1 to i32
%t2331 = xor i32 %p0, %t2330
ret i32 %t2331
}
define i32 @__m_________lib_word_resid__ws_andk(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2332 = trunc i64 %p1 to i32
%t2333 = and i32 %p0, %t2332
ret i32 %t2333
}
define i32 @__m_________lib_word_resid__ws_rotr(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i32 @__m_________lib_word_resid__ws_shr(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2349 = trunc i64 %p1 to i32
%t2350 = icmp uge i32 %t2349, 32
%t2351 = add i32 %t2349, 0
%t2352 = lshr i32 %p0, %t2351
%t2353 = select i1 %t2350, i32 0, i32 %t2352
ret i32 %t2353
}
define i32 @__m_________lib_word_resid__ws_shl(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2354 = trunc i64 %p1 to i32
%t2355 = icmp uge i32 %t2354, 32
%t2356 = add i32 %t2354, 0
%t2357 = shl i32 %p0, %t2356
%t2358 = select i1 %t2355, i32 0, i32 %t2357
ret i32 %t2358
}
define i32 @__m_________lib_word_resid__ws_not(i32 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2359 = xor i32 %p0, 4294967295
ret i32 %t2359
}
define i32 @__m_________lib_word_resid__ws_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2360 = trunc i64 %p0 to i32
ret i32 %t2360
}
define i32 @__m_________lib_word_resid__ws_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2361 = zext i8 %p0 to i32
ret i32 %t2361
}
define i8 @__m_________lib_word_resid__ws_byte(i32 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2362 = trunc i64 %p1 to i32
%t2363 = icmp uge i32 %t2362, 32
%t2364 = add i32 %t2362, 0
%t2365 = lshr i32 %p0, %t2364
%t2366 = select i1 %t2363, i32 0, i32 %t2365
%t2367 = trunc i32 %t2366 to i8
ret i8 %t2367
}
define i8 @__m_________lib_word_resid__bs_xork(i8 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2368 = trunc i64 %p1 to i8
%t2369 = xor i8 %p0, %t2368
ret i8 %t2369
}
define i8 @__m_________lib_word_resid__bs_xor(i8 %p0, i8 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2370 = xor i8 %p0, %p1
ret i8 %t2370
}
define i8 @__m_________lib_word_resid__bs_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2371 = trunc i64 %p0 to i8
ret i8 %t2371
}
define ptr @secret_bytes(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2372 = call ptr @resid_listbuf_new()
%t2373 = call ptr @__m_________lib_word_resid__secret_bytes_at(ptr %p0, i64 0, ptr %t2372)
ret ptr %t2373
}
define ptr @__m_________lib_word_resid__secret_bytes_at(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i64 @__m_________lib_word_resid__di_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2387 = xor i64 %p0, %p1
ret i64 %t2387
}
define i64 @__m_________lib_word_resid__di_and(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2388 = and i64 %p0, %p1
ret i64 %t2388
}
define i64 @__m_________lib_word_resid__di_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2389 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2389
}
define i64 @__m_________lib_word_resid__di_addk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2390 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2390
}
define i64 @__m_________lib_word_resid__di_rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i64 @__m_________lib_word_resid__di_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i64 @__m_________lib_word_resid__di_not(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i64 @__m_________lib_word_resid__di_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i64 @__m_________lib_word_resid__di_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2437 = and i64 %p0, 255
ret i64 %t2437
}
define i64 @__m_________lib_word_resid__di_byte(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i64 @__m_________lib_word_resid__ds_xor(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2450 = xor i64 %p0, %p1
ret i64 %t2450
}
define i64 @__m_________lib_word_resid__ds_and(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2451 = and i64 %p0, %p1
ret i64 %t2451
}
define i64 @__m_________lib_word_resid__ds_add(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2452 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2452
}
define i64 @__m_________lib_word_resid__ds_addk(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2453 = musttail call i64 @wrapping_uadd(i64 %p0, i64 %p1)
ret i64 %t2453
}
define i64 @__m_________lib_word_resid__ds_rotr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i64 @__m_________lib_word_resid__ds_shr(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i64 @__m_________lib_word_resid__ds_not(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i64 @__m_________lib_word_resid__ds_lift(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p0
}
define i64 @__m_________lib_word_resid__ds_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2500 = zext i8 %p0 to i64
ret i64 %t2500
}
define i8 @__m_________lib_word_resid__ds_byte(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i512 @__m_________lib_word_resid__pi_add(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2513 = add i512 %p0, %p1
ret i512 %t2513
}
define i512 @__m_________lib_word_resid__pi_sub(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2514 = sub i512 %p0, %p1
ret i512 %t2514
}
define i512 @__m_________lib_word_resid__pi_mul(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2515 = mul i512 %p0, %p1
ret i512 %t2515
}
define i512 @__m_________lib_word_resid__pi_mul256(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2516 = trunc i512 %p0 to i256
%t2517 = zext i256 %t2516 to i512
%t2518 = trunc i512 %p1 to i256
%t2519 = zext i256 %t2518 to i512
%t2520 = mul i512 %t2517, %t2519
ret i512 %t2520
}
define i512 @__m_________lib_word_resid__pi_and(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2521 = and i512 %p0, %p1
ret i512 %t2521
}
define i512 @__m_________lib_word_resid__pi_or(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2522 = or i512 %p0, %p1
ret i512 %t2522
}
define i512 @__m_________lib_word_resid__pi_xor(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2523 = xor i512 %p0, %p1
ret i512 %t2523
}
define i512 @__m_________lib_word_resid__pi_shl(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2524 = sext i64 %p1 to i512
%t2525 = icmp uge i512 %t2524, 512
%t2526 = add i512 %t2524, 0
%t2527 = shl i512 %p0, %t2526
%t2528 = select i1 %t2525, i512 0, i512 %t2527
ret i512 %t2528
}
define i512 @__m_________lib_word_resid__pi_shr(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2529 = sext i64 %p1 to i512
%t2530 = icmp uge i512 %t2529, 512
%t2531 = add i512 %t2529, 0
%t2532 = select i1 %t2530, i512 511, i512 %t2531
%t2533 = ashr i512 %p0, %t2532
ret i512 %t2533
}
define i512 @__m_________lib_word_resid__pi_sign(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2534 = ashr i512 %p0, 511
%t2535 = trunc i512 %t2534 to i64
%t2536 = call i64 asm "", "=r,0"(i64 %t2535)
%t2537 = sext i64 %t2536 to i512
ret i512 %t2537
}
define i512 @__m_________lib_word_resid__pi_lift(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i512 %p0
}
define i512 @__m_________lib_word_resid__pi_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2538 = and i64 %p0, 255
%t2539 = sext i64 %t2538 to i512
ret i512 %t2539
}
define i64 @__m_________lib_word_resid__pi_byte(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i512 @__m_________lib_word_resid__ps_add(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2547 = add i512 %p0, %p1
ret i512 %t2547
}
define i512 @__m_________lib_word_resid__ps_sub(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2548 = sub i512 %p0, %p1
ret i512 %t2548
}
define i512 @__m_________lib_word_resid__ps_mul(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2549 = mul i512 %p0, %p1
ret i512 %t2549
}
define i512 @__m_________lib_word_resid__ps_mul256(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2550 = trunc i512 %p0 to i256
%t2551 = zext i256 %t2550 to i512
%t2552 = trunc i512 %p1 to i256
%t2553 = zext i256 %t2552 to i512
%t2554 = mul i512 %t2551, %t2553
ret i512 %t2554
}
define i512 @__m_________lib_word_resid__ps_and(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2555 = and i512 %p0, %p1
ret i512 %t2555
}
define i512 @__m_________lib_word_resid__ps_or(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2556 = or i512 %p0, %p1
ret i512 %t2556
}
define i512 @__m_________lib_word_resid__ps_xor(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2557 = xor i512 %p0, %p1
ret i512 %t2557
}
define i512 @__m_________lib_word_resid__ps_shl(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2558 = sext i64 %p1 to i512
%t2559 = icmp uge i512 %t2558, 512
%t2560 = add i512 %t2558, 0
%t2561 = shl i512 %p0, %t2560
%t2562 = select i1 %t2559, i512 0, i512 %t2561
ret i512 %t2562
}
define i512 @__m_________lib_word_resid__ps_shr(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2563 = sext i64 %p1 to i512
%t2564 = icmp uge i512 %t2563, 512
%t2565 = add i512 %t2563, 0
%t2566 = select i1 %t2564, i512 511, i512 %t2565
%t2567 = ashr i512 %p0, %t2566
ret i512 %t2567
}
define i512 @__m_________lib_word_resid__ps_sign(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2568 = ashr i512 %p0, 511
%t2569 = trunc i512 %t2568 to i64
%t2570 = call i64 asm "", "=r,0"(i64 %t2569)
%t2571 = sext i64 %t2570 to i512
ret i512 %t2571
}
define i512 @__m_________lib_word_resid__ps_lift(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i512 %p0
}
define i512 @__m_________lib_word_resid__ps_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2572 = zext i8 %p0 to i512
ret i512 %t2572
}
define i8 @__m_________lib_word_resid__ps_byte(i512 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2573 = sext i64 %p1 to i512
%t2574 = icmp uge i512 %t2573, 512
%t2575 = add i512 %t2573, 0
%t2576 = select i1 %t2574, i512 511, i512 %t2575
%t2577 = ashr i512 %p0, %t2576
%t2578 = trunc i512 %t2577 to i8
ret i8 %t2578
}
define ptr @__m_________lib_word_resid__wi_publish(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret ptr %p0
}
define ptr @__m_________lib_word_resid__ws_publish(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
call void @resid_cap_check(ptr @.declassify.cap)
%t2579 = call ptr @resid_listbuf_new()
%t2580 = call ptr @__m_________lib_word_resid__ws_widen(ptr %p0, i64 0, ptr %t2579)
ret ptr %t2580
}
define ptr @__m_________lib_word_resid__ws_widen(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i128 @__m_________lib_word_resid__xi_xor(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2604 = xor i128 %p0, %p1
ret i128 %t2604
}
define i128 @__m_________lib_word_resid__xi_and(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2605 = and i128 %p0, %p1
ret i128 %t2605
}
define i128 @__m_________lib_word_resid__xi_or(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2606 = or i128 %p0, %p1
ret i128 %t2606
}
define i128 @__m_________lib_word_resid__xi_shl(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i128 @__m_________lib_word_resid__xi_shr(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i128 @__m_________lib_word_resid__xi_lift(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i128 %p0
}
define i128 @__m_________lib_word_resid__xi_from_word(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2629 = and i64 %p0, 4294967295
%t2630 = zext i64 %t2629 to i128
ret i128 %t2630
}
define i64 @__m_________lib_word_resid__xi_word(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i128 @__m_________lib_word_resid__xi_from_byte(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2644 = and i64 %p0, 255
%t2645 = zext i64 %t2644 to i128
ret i128 %t2645
}
define i64 @__m_________lib_word_resid__xi_byte(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i128 @__m_________lib_word_resid__xi_bit(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i128 @__m_________lib_word_resid__xi_aes_round(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2675 = bitcast i128 %p0 to <2 x i64>
%t2676 = bitcast i128 %p1 to <2 x i64>
%t2677 = call <2 x i64> @llvm.x86.aesni.aesenc(<2 x i64> %t2675, <2 x i64> %t2676)
%t2678 = bitcast <2 x i64> %t2677 to i128
ret i128 %t2678
}
define i128 @__m_________lib_word_resid__xi_aes_last(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2679 = bitcast i128 %p0 to <2 x i64>
%t2680 = bitcast i128 %p1 to <2 x i64>
%t2681 = call <2 x i64> @llvm.x86.aesni.aesenclast(<2 x i64> %t2679, <2 x i64> %t2680)
%t2682 = bitcast <2 x i64> %t2681 to i128
ret i128 %t2682
}
define i128 @__m_________lib_word_resid__xi_clmul(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2683 = call i128 @e.gf128(i128 %p0, i128 %p1)
ret i128 %t2683
}
define i128 @__m_________lib_word_resid__xs_xor(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2684 = xor i128 %p0, %p1
ret i128 %t2684
}
define i128 @__m_________lib_word_resid__xs_and(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2685 = and i128 %p0, %p1
ret i128 %t2685
}
define i128 @__m_________lib_word_resid__xs_or(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2686 = or i128 %p0, %p1
ret i128 %t2686
}
define i128 @__m_________lib_word_resid__xs_shl(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i128 @__m_________lib_word_resid__xs_shr(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i128 @__m_________lib_word_resid__xs_lift(i128 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i128 %p0
}
define i128 @__m_________lib_word_resid__xs_from_word(i32 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2709 = zext i32 %p0 to i128
ret i128 %t2709
}
define i32 @__m_________lib_word_resid__xs_word(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i128 @__m_________lib_word_resid__xs_from_byte(i8 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2722 = zext i8 %p0 to i128
ret i128 %t2722
}
define i8 @__m_________lib_word_resid__xs_byte(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i128 @__m_________lib_word_resid__xs_bit(i128 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i128 @__m_________lib_word_resid__xs_aes_round(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2751 = bitcast i128 %p0 to <2 x i64>
%t2752 = bitcast i128 %p1 to <2 x i64>
%t2753 = call <2 x i64> @llvm.x86.aesni.aesenc(<2 x i64> %t2751, <2 x i64> %t2752)
%t2754 = bitcast <2 x i64> %t2753 to i128
ret i128 %t2754
}
define i128 @__m_________lib_word_resid__xs_aes_last(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2755 = bitcast i128 %p0 to <2 x i64>
%t2756 = bitcast i128 %p1 to <2 x i64>
%t2757 = call <2 x i64> @llvm.x86.aesni.aesenclast(<2 x i64> %t2755, <2 x i64> %t2756)
%t2758 = bitcast <2 x i64> %t2757 to i128
ret i128 %t2758
}
define i128 @__m_________lib_word_resid__xs_clmul(i128 %p0, i128 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t2759 = call i128 @e.gf128(i128 %p0, i128 %p1)
ret i128 %t2759
}
define i64 @__m_________lib_sha256g_resid__sha2k(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t2784 = call ptr @__m_________lib_sha256g_resid__sha256g_pad_at__rs150(i64 %p0, i64 %t2780, i64 0, ptr %t2783)
%t2785 = call ptr @resid_listbuf_finish(ptr %t2784, ptr @.lty2785)
ret ptr %t2785
}
define ptr @__m_________lib_sha256g_resid__sha256g_pad_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define ptr @__m_________lib_sha256g_resid__sha256g_zeros(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t3810 = musttail call ptr @__m_________lib_crypto_resid__sha256_ascii(ptr %p0)
ret ptr %t3810
}
define ptr @__m_________lib_crypto_resid__sha256_ascii(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define ptr @__m_________lib_crypto_resid__sc_acc(ptr %p0.in, ptr %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t4019 = call i8 @__m_________lib_crypto_resid__ct_eq_acc(ptr %p0, ptr %p1, i64 1, i8 %t4018)
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
define i8 @__m_________lib_crypto_resid__ct_eq_acc(ptr %p0.in, ptr %p1.in, i64 %p2.in, i8 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i1 @__m_________lib_crypto_resid__ct_same_pub(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t4047 = musttail call i1 @ct_equal(ptr %p0, ptr %p1)
ret i1 %t4047
}
define i1 @__m_________lib_crypto_resid__ct_same_secret(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i64 @__m_________lib_crypto_resid__b64_code(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t4102 = call i64 @__m_________lib_crypto_resid__b64_code(i64 %t4101)
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
%t4106 = call i64 @__m_________lib_crypto_resid__b64_code(i64 %t4105)
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
%t4111 = call i64 @__m_________lib_crypto_resid__b64_code(i64 %t4110)
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
%t4116 = call i64 @__m_________lib_crypto_resid__b64_code(i64 %t4115)
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
%t4126 = call ptr @__m_________lib_crypto_resid__b64_strip(ptr %p0, i64 0, i64 %t4124, ptr %t4125)
%t4127 = call i64 @resid_list_len(ptr %t4126)
%t4128 = call i64 @__m_________lib_crypto_resid__b64_pads(ptr %t4126, i64 %t4127, i64 0)
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
define i1 @__m_________lib_crypto_resid__b64_is_space(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define ptr @__m_________lib_crypto_resid__b64_strip(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t4150 = call i1 @__m_________lib_crypto_resid__b64_is_space(i64 %t4149)
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
define i64 @__m_________lib_crypto_resid__b64_pads(ptr %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t4294 = call ptr @__m_________lib_crypto_resid__rand_blocks(i64 %p0, ptr %t4293)
ret ptr %t4294
}
define ptr @__m_________lib_crypto_resid__rand_blocks(i64 %p0.in, ptr %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t4299 = call ptr @__m_________lib_crypto_resid__rand_block()
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
define ptr @__m_________lib_crypto_resid__rand_block() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t4313 = call ptr @__m_________lib_crypto_resid__rand_u32(i64 %t4312)
%t4314 = call ptr @resid_list_freeze(ptr %t4313)
%t4315 = call ptr @resid_list_concat(ptr %t4311, ptr %t4314)
%t4316 = call ptr @resid_list_concat(ptr %t4315, ptr %t4308)
%t4317 = call ptr @sha512_bytes(ptr %t4316)
ret ptr %t4317
}
define ptr @__m_________lib_crypto_resid__rand_u32(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define i64 @__m_________lib_crypto_resid__u32mask(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5488 = and i64 %p0, 4294967295
ret i64 %t5488
}
define i64 @__m_________lib_crypto_resid__sha1_rol(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5489 = icmp uge i64 %p1, 64
%t5490 = add i64 %p1, 0
%t5491 = shl i64 %p0, %t5490
%t5492 = select i1 %t5489, i64 0, i64 %t5491
%t5493 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5492)
%t5494 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %p0)
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
%t5504 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5503)
ret i64 %t5504
}
define i64 @__m_________lib_crypto_resid__sha1_word(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define ptr @__m_________lib_crypto_resid__sha1_words16(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t5563 = call i64 @__m_________lib_crypto_resid__sha1_word(ptr %p0, i64 %p1, i64 %p2)
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
define ptr @__m_________lib_crypto_resid__sha1_expand(i64 %p0.in, ptr %p1.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t5604 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5603)
%t5605 = add nsw i64 %p0, 1
%t5606 = call i64 @__m_________lib_crypto_resid__sha1_rol(i64 %t5604, i64 1)
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
define i64 @__m_________lib_crypto_resid__sha1_f(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t5629 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5626)
%t5630 = and i64 %t5629, %p3
%t5631 = or i64 %t5624, %t5630
%t5632 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5631)
ret i64 %t5632
L654:
br i1 %t5619, label %L655, label %L657
L655:
%t5633 = xor i64 %p1, %p2
%t5634 = xor i64 %t5633, %p3
%t5635 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5634)
ret i64 %t5635
L657:
br i1 %t5623, label %L658, label %L660
L658:
%t5636 = and i64 %p1, %p2
%t5637 = and i64 %p1, %p3
%t5638 = or i64 %t5636, %t5637
%t5639 = and i64 %p2, %p3
%t5640 = or i64 %t5638, %t5639
%t5641 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5640)
ret i64 %t5641
L660:
%t5642 = xor i64 %p1, %p2
%t5643 = xor i64 %t5642, %p3
%t5644 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5643)
ret i64 %t5644
}
define i64 @__m_________lib_crypto_resid__sha1_k(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
define ptr @__m_________lib_crypto_resid__sha1_rounds(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t5673 = call i64 @__m_________lib_crypto_resid__sha1_rol(i64 %p2, i64 5)
%t5674 = call i64 @__m_________lib_crypto_resid__sha1_f(i64 %p1, i64 %p3, i64 %p4, i64 %p5)
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
%t5683 = call i64 @__m_________lib_crypto_resid__sha1_k(i64 %p1)
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
%t5695 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5692)
%t5696 = call i64 @__m_________lib_crypto_resid__sha1_rol(i64 %p3, i64 30)
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
define ptr @__m_________lib_crypto_resid__sha1_step(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5700 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty5699)
%t5701 = call ptr @__m_________lib_crypto_resid__sha1_words16(ptr %p0, i64 %p1, i64 0, ptr %t5700)
%t5702 = call ptr @__m_________lib_crypto_resid__sha1_expand(i64 16, ptr %t5701)
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
%t5718 = call ptr @__m_________lib_crypto_resid__sha1_rounds(ptr %t5702, i64 0, i64 %t5704, i64 %t5707, i64 %t5710, i64 %t5713, i64 %t5716)
%t5719 = call ptr @resid_list_get(ptr %p2, i64 0)
%t5720 = call i64 @resid_unbox_i64(ptr %t5719)
%t5722 = call ptr @resid_list_get(ptr %t5718, i64 0)
%t5723 = call i64 @resid_unbox_i64(ptr %t5722)
%t5725 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5720, i64 %t5723)
%t5726 = extractvalue {i64, i1} %t5725, 0
%t5727 = extractvalue {i64, i1} %t5725, 1
%t5728 = zext i1 %t5727 to i8
call void @resid_overflow_check(i8 %t5728)
%t5729 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5726)
%t5730 = call ptr @resid_list_get(ptr %p2, i64 1)
%t5731 = call i64 @resid_unbox_i64(ptr %t5730)
%t5733 = call ptr @resid_list_get(ptr %t5718, i64 1)
%t5734 = call i64 @resid_unbox_i64(ptr %t5733)
%t5736 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5731, i64 %t5734)
%t5737 = extractvalue {i64, i1} %t5736, 0
%t5738 = extractvalue {i64, i1} %t5736, 1
%t5739 = zext i1 %t5738 to i8
call void @resid_overflow_check(i8 %t5739)
%t5740 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5737)
%t5741 = call ptr @resid_list_get(ptr %p2, i64 2)
%t5742 = call i64 @resid_unbox_i64(ptr %t5741)
%t5744 = call ptr @resid_list_get(ptr %t5718, i64 2)
%t5745 = call i64 @resid_unbox_i64(ptr %t5744)
%t5747 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5742, i64 %t5745)
%t5748 = extractvalue {i64, i1} %t5747, 0
%t5749 = extractvalue {i64, i1} %t5747, 1
%t5750 = zext i1 %t5749 to i8
call void @resid_overflow_check(i8 %t5750)
%t5751 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5748)
%t5752 = call ptr @resid_list_get(ptr %p2, i64 3)
%t5753 = call i64 @resid_unbox_i64(ptr %t5752)
%t5755 = call ptr @resid_list_get(ptr %t5718, i64 3)
%t5756 = call i64 @resid_unbox_i64(ptr %t5755)
%t5758 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5753, i64 %t5756)
%t5759 = extractvalue {i64, i1} %t5758, 0
%t5760 = extractvalue {i64, i1} %t5758, 1
%t5761 = zext i1 %t5760 to i8
call void @resid_overflow_check(i8 %t5761)
%t5762 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5759)
%t5763 = call ptr @resid_list_get(ptr %p2, i64 4)
%t5764 = call i64 @resid_unbox_i64(ptr %t5763)
%t5766 = call ptr @resid_list_get(ptr %t5718, i64 4)
%t5767 = call i64 @resid_unbox_i64(ptr %t5766)
%t5769 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t5764, i64 %t5767)
%t5770 = extractvalue {i64, i1} %t5769, 0
%t5771 = extractvalue {i64, i1} %t5769, 1
%t5772 = zext i1 %t5771 to i8
call void @resid_overflow_check(i8 %t5772)
%t5773 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5770)
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
define ptr @__m_________lib_crypto_resid__sha1_blocks(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t5797 = call ptr @__m_________lib_crypto_resid__sha1_step(ptr %p0, i64 %p1, ptr %p3)
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
define ptr @__m_________lib_crypto_resid__sha1_be_bytes(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%t5805 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5804)
%t5806 = ashr i64 %t5802, 16
%t5807 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5806)
%t5808 = and i64 %t5807, 255
%t5809 = ashr i64 %t5802, 8
%t5810 = call i64 @__m_________lib_crypto_resid__u32mask(i64 %t5809)
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
%t5836 = call ptr @__m_________lib_crypto_resid__sha1_blocks(ptr %t5831, i64 0, i64 %t5833, ptr %t5835, i64 0)
%t5838 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty5837)
%t5839 = call ptr @__m_________lib_crypto_resid__sha1_be_bytes(ptr %t5836, i64 0, ptr %t5838)
ret ptr %t5839
}
define ptr @tr_new() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5840 = call ptr @resid_rec_new(i64 8, i8 1)
%t5842 = call ptr @resid_list_const_i64(ptr @.lc5841, i64 9, ptr @.lcd5841, ptr @.lty5841)
%t5843 = alloca [1 x ptr]
%t5847 = getelementptr i8, ptr %t5843, i64 0
store ptr %t5842, ptr %t5847
%t5848 = call ptr @resid_list_new(i64 1, ptr %t5843, ptr @.lty5843)
%t5840.f0 = getelementptr i8, ptr %t5840, i64 0
store ptr %t5848, ptr %t5840.f0, align 8
ret ptr %t5840
}
define ptr @__m_________lib_cggmp_hash_resid__tr_u64be(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5849 = ashr i64 %p0, 24
%t5850 = and i64 %t5849, 255
%t5851 = ashr i64 %p0, 16
%t5852 = and i64 %t5851, 255
%t5853 = ashr i64 %p0, 8
%t5854 = and i64 %t5853, 255
%t5855 = and i64 %p0, 255
%t5856 = alloca [8 x ptr]
%t5858 = call ptr @resid_box_i64(i64 0)
%t5860 = getelementptr i8, ptr %t5856, i64 0
store ptr %t5858, ptr %t5860
%t5861 = call ptr @resid_box_i64(i64 0)
%t5863 = getelementptr i8, ptr %t5856, i64 8
store ptr %t5861, ptr %t5863
%t5864 = call ptr @resid_box_i64(i64 0)
%t5866 = getelementptr i8, ptr %t5856, i64 16
store ptr %t5864, ptr %t5866
%t5867 = call ptr @resid_box_i64(i64 0)
%t5869 = getelementptr i8, ptr %t5856, i64 24
store ptr %t5867, ptr %t5869
%t5870 = call ptr @resid_box_i64(i64 %t5850)
%t5872 = getelementptr i8, ptr %t5856, i64 32
store ptr %t5870, ptr %t5872
%t5873 = call ptr @resid_box_i64(i64 %t5852)
%t5875 = getelementptr i8, ptr %t5856, i64 40
store ptr %t5873, ptr %t5875
%t5876 = call ptr @resid_box_i64(i64 %t5854)
%t5878 = getelementptr i8, ptr %t5856, i64 48
store ptr %t5876, ptr %t5878
%t5879 = call ptr @resid_box_i64(i64 %t5855)
%t5881 = getelementptr i8, ptr %t5856, i64 56
store ptr %t5879, ptr %t5881
%t5882 = call ptr @resid_list_new(i64 8, ptr %t5856, ptr @.lty5856)
ret ptr %t5882
}
define ptr @__m_________lib_cggmp_hash_resid__tr_frame(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5883 = call ptr @bytes_of(ptr %p0)
%t5884 = call ptr @resid_listbuf_new()
%t5885 = call ptr @resid_box_i64(i64 40)
%t5888 = call ptr @resid_listbuf_push(ptr %t5884, ptr %t5885)
%t5889 = call i64 @resid_list_len(ptr %t5883)
%t5890 = call ptr @__m_________lib_cggmp_hash_resid__tr_u64be(i64 %t5889)
%t5891 = call ptr @resid_list_freeze(ptr %t5890)
%t5892 = call ptr @__m_________lib_cggmp_hash_resid__tr_cat(ptr %t5888, ptr %t5891)
%t5893 = call ptr @__m_________lib_cggmp_hash_resid__tr_cat(ptr %t5892, ptr %t5883)
%t5894 = call i64 @resid_list_len(ptr %p1)
%t5895 = call ptr @__m_________lib_cggmp_hash_resid__tr_u64be(i64 %t5894)
%t5896 = call ptr @resid_list_freeze(ptr %t5895)
%t5897 = call ptr @__m_________lib_cggmp_hash_resid__tr_cat(ptr %t5893, ptr %t5896)
%t5898 = call ptr @__m_________lib_cggmp_hash_resid__tr_cat(ptr %t5897, ptr %p1)
%t5899 = call ptr @resid_box_i64(i64 41)
%t5902 = call ptr @resid_listbuf_push(ptr %t5898, ptr %t5899)
%t5903 = musttail call ptr @resid_listbuf_finish(ptr %t5902, ptr @.lty5903)
ret ptr %t5903
}
define ptr @__m_________lib_cggmp_hash_resid__tr_cat(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5904 = call ptr @__m_________lib_cggmp_hash_resid__tr_cat_at(ptr %p0, ptr %p1, i64 0)
ret ptr %t5904
}
define ptr @__m_________lib_cggmp_hash_resid__tr_cat_at(ptr %p0.in, ptr %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %t5913, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t5914, %tco.s0 ]
%t5905 = call i64 @resid_list_len(ptr %p1)
%t5906 = icmp sge i64 %p2, %t5905
br i1 %t5906, label %L679, label %L681
L679:
ret ptr %p0
L681:
%t5907 = call ptr @resid_list_get_v(ptr %p1, i64 %p2, ptr %p1.ld, i64 %p1.ln)
%t5908 = call i64 @resid_unbox_i64(ptr %t5907)
%t5910 = call ptr @resid_box_i64(i64 %t5908)
%t5913 = call ptr @resid_listbuf_push(ptr %p0, ptr %t5910)
%t5914 = add nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @tr_item(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5916 = getelementptr i8, ptr %p0, i64 0
%t5917 = load ptr, ptr %t5916, align 8
%t5918 = call ptr @__m_________lib_cggmp_hash_resid__tr_frame(ptr %p1, ptr %p2)
%t5919 = call ptr @resid_list_freeze(ptr %t5918)
%t5920 = alloca [1 x ptr]
%t5924 = getelementptr i8, ptr %t5920, i64 0
store ptr %t5919, ptr %t5924
%t5926e = load ptr, ptr %t5920
%t5926 = call ptr @resid_list_push(ptr %t5917, ptr %t5926e)
%t5927 = call ptr @resid_rec_reuse(ptr %p0, i64 8)
%t5927.f0 = getelementptr i8, ptr %t5927, i64 0
store ptr %t5926, ptr %t5927.f0, align 8
ret ptr %t5927
}
define ptr @tr_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5929 = call ptr @tr_item(ptr %p0, ptr @.s5928, ptr %p1)
ret ptr %t5929
}
define ptr @tr_nat(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5932 = call ptr @resid_list_const_i64(ptr @.lc5931, i64 1, ptr @.lcd5931, ptr @.lty5931)
%t5933 = call ptr @bn_to_be(ptr %p1, i64 0)
%t5934 = call ptr @resid_list_freeze(ptr %t5933)
%t5935 = call ptr @resid_list_concat(ptr %t5932, ptr %t5934)
%t5936 = call ptr @tr_item(ptr %p0, ptr @.s5930, ptr %t5935)
ret ptr %t5936
}
define ptr @tr_modulus(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5938 = call ptr @bn_to_be(ptr %p1, i64 0)
%t5939 = call ptr @tr_item(ptr %p0, ptr @.s5937, ptr %t5938)
ret ptr %t5939
}
define ptr @__m_________lib_cggmp_hash_resid__tr_flat(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t5943, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t5947, %tco.s0 ]
%t5940 = call i64 @resid_list_len(ptr %p0)
%t5941 = icmp sge i64 %p1, %t5940
br i1 %t5941, label %L682, label %L684
L682:
%t5942 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty5942)
ret ptr %t5942
L684:
%t5943 = add nsw i64 %p1, 1
%t5944 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t5947 = call ptr @__m_________lib_cggmp_hash_resid__tr_cat(ptr %p2, ptr %t5944)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @tr_seed(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5949 = getelementptr i8, ptr %p0, i64 0
%t5950 = load ptr, ptr %t5949, align 8
%t5951 = call ptr @resid_listbuf_new()
%t5952 = call ptr @__m_________lib_cggmp_hash_resid__tr_flat(ptr %t5950, i64 0, ptr %t5951)
%t5953 = musttail call ptr @sha256_bytes(ptr %t5952)
ret ptr %t5953
}
define ptr @tr_stream(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5954 = sdiv i64 %p1, 32
%t5955 = call ptr @resid_listbuf_new()
%t5956 = call ptr @__m_________lib_cggmp_hash_resid__tr_stream_at(ptr %p0, i64 %p1, i64 %p2, i64 %t5954, ptr %t5955)
ret ptr %t5956
}
define ptr @__m_________lib_cggmp_hash_resid__tr_stream_at(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t5974 = alloca [4 x ptr]
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t5992, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t6003, %tco.s0 ]
%t5957 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p3, i64 32)
%t5958 = extractvalue {i64, i1} %t5957, 0
%t5959 = extractvalue {i64, i1} %t5957, 1
%t5960 = zext i1 %t5959 to i8
call void @resid_overflow_check(i8 %t5960)
%t5961 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p2)
%t5962 = extractvalue {i64, i1} %t5961, 0
%t5963 = extractvalue {i64, i1} %t5961, 1
%t5964 = zext i1 %t5963 to i8
call void @resid_overflow_check(i8 %t5964)
%t5965 = icmp sge i64 %t5958, %t5962
br i1 %t5965, label %L685, label %L687
L685:
%t5966 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty5966)
ret ptr %t5966
L687:
%t5967 = ashr i64 %p3, 24
%t5968 = and i64 %t5967, 255
%t5969 = ashr i64 %p3, 16
%t5970 = and i64 %t5969, 255
%t5971 = ashr i64 %p3, 8
%t5972 = and i64 %t5971, 255
%t5973 = and i64 %p3, 255
%t5976 = call ptr @resid_box_i64(i64 %t5968)
%t5978 = getelementptr i8, ptr %t5974, i64 0
store ptr %t5976, ptr %t5978
%t5979 = call ptr @resid_box_i64(i64 %t5970)
%t5981 = getelementptr i8, ptr %t5974, i64 8
store ptr %t5979, ptr %t5981
%t5982 = call ptr @resid_box_i64(i64 %t5972)
%t5984 = getelementptr i8, ptr %t5974, i64 16
store ptr %t5982, ptr %t5984
%t5985 = call ptr @resid_box_i64(i64 %t5973)
%t5987 = getelementptr i8, ptr %t5974, i64 24
store ptr %t5985, ptr %t5987
%t5988 = call ptr @resid_list_new(i64 4, ptr %t5974, ptr @.lty5974)
%t5989 = call ptr @resid_list_concat(ptr %p0, ptr %t5988)
%t5990 = call ptr @sha256_bytes(ptr %t5989)
%t5991 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 1)
%t5992 = extractvalue {i64, i1} %t5991, 0
%t5993 = extractvalue {i64, i1} %t5991, 1
%t5994 = zext i1 %t5993 to i8
call void @resid_overflow_check(i8 %t5994)
%t5995 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p3, i64 32)
%t5996 = extractvalue {i64, i1} %t5995, 0
%t5997 = extractvalue {i64, i1} %t5995, 1
%t5998 = zext i1 %t5997 to i8
call void @resid_overflow_check(i8 %t5998)
%t5999 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p2)
%t6000 = extractvalue {i64, i1} %t5999, 0
%t6001 = extractvalue {i64, i1} %t5999, 1
%t6002 = zext i1 %t6001 to i8
call void @resid_overflow_check(i8 %t6002)
%t6003 = call ptr @__m_________lib_cggmp_hash_resid__tr_cat_range(ptr %p4, ptr %t5990, i64 %t5996, i64 %p1, i64 %t6000)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m_________lib_cggmp_hash_resid__tr_cat_range(ptr %p0, ptr %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6005 = call ptr @__m_________lib_cggmp_hash_resid__tr_cat_range_at(ptr %p0, ptr %p1, i64 %p2, i64 %p3, i64 %p4, i64 0)
ret ptr %t6005
}
define ptr @__m_________lib_cggmp_hash_resid__tr_cat_range_at(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p1.ld = call ptr @resid_list_vdata(ptr %p1.in)
%p1.ln = call i64 @resid_list_vlen(ptr %p1.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %t6023, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t6024, %tco.s0 ]
%t6006 = call i64 @resid_list_len(ptr %p1)
%t6007 = icmp sge i64 %p5, %t6006
br i1 %t6007, label %L688, label %L690
L688:
ret ptr %p0
L690:
%t6008 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %p5)
%t6009 = extractvalue {i64, i1} %t6008, 0
%t6010 = extractvalue {i64, i1} %t6008, 1
%t6011 = zext i1 %t6010 to i8
call void @resid_overflow_check(i8 %t6011)
%t6012 = icmp sge i64 %t6009, %p3
br label %LSL6013
LSL6013:
br i1 %t6012, label %LSR6013, label %LSJ6013
LSR6013:
%t6014 = icmp slt i64 %t6009, %p4
br label %LSJ6013
LSJ6013:
%t6015 = phi i1 [ false, %LSL6013 ], [ %t6014, %LSR6013 ]
br i1 %t6015, label %L691, label %L692
L691:
%t6016 = call ptr @resid_list_get_v(ptr %p1, i64 %p5, ptr %p1.ld, i64 %p1.ln)
%t6017 = call i64 @resid_unbox_i64(ptr %t6016)
%t6019 = call ptr @resid_box_i64(i64 %t6017)
%t6022 = call ptr @resid_listbuf_push(ptr %p0, ptr %t6019)
br label %L693
L692:
br label %L693
L693:
%t6023 = phi ptr [ %t6022, %L691 ], [ %p0, %L692 ]
%t6024 = add nsw i64 %p5, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @tr_sample_modn(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6042, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t6026 = call i64 @bn_bit_len(ptr %p2)
%t6027 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t6026, i64 7)
%t6028 = extractvalue {i64, i1} %t6027, 0
%t6029 = extractvalue {i64, i1} %t6027, 1
%t6030 = zext i1 %t6029 to i8
call void @resid_overflow_check(i8 %t6030)
%t6031 = sdiv i64 %t6028, 8
%t6032 = call ptr @tr_stream(ptr %p0, i64 %p1, i64 %t6031)
%t6033 = call ptr @bn_from_be(ptr %t6032)
%t6034 = call i64 @bn_cmp(ptr %t6033, ptr %p2)
%t6035 = icmp slt i64 %t6034, 0
br i1 %t6035, label %L694, label %L696
L694:
%t6036 = call ptr @resid_gmalloc(i64 16)
%t6036.f0 = getelementptr i8, ptr %t6036, i64 0
store ptr %t6033, ptr %t6036.f0, align 8
%t6037 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t6031)
%t6038 = extractvalue {i64, i1} %t6037, 0
%t6039 = extractvalue {i64, i1} %t6037, 1
%t6040 = zext i1 %t6039 to i8
call void @resid_overflow_check(i8 %t6040)
%t6036.f1 = getelementptr i8, ptr %t6036, i64 8
store i64 %t6038, ptr %t6036.f1, align 8
ret ptr %t6036
L696:
%t6041 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t6031)
%t6042 = extractvalue {i64, i1} %t6041, 0
%t6043 = extractvalue {i64, i1} %t6041, 1
%t6044 = zext i1 %t6043 to i8
call void @resid_overflow_check(i8 %t6044)
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
%t6046 = call i64 @resid_list_len(ptr %p0)
%t6047 = icmp eq i64 %t6046, 0
br label %LSL6048
LSL6048:
br i1 %t6047, label %LSJ6048, label %LSR6048
LSR6048:
%t6049 = call i64 @bn_cmp(ptr %p0, ptr %p1)
%t6050 = icmp sge i64 %t6049, 0
br label %LSJ6048
LSJ6048:
%t6051 = phi i1 [ true, %LSL6048 ], [ %t6050, %LSR6048 ]
br i1 %t6051, label %L697, label %L699
L697:
ret i1 false
L699:
%t6052 = call ptr @bn_gcd(ptr %p0, ptr %p1)
%t6053 = call ptr @resid_list_freeze(ptr %t6052)
%t6055 = call ptr @resid_list_const_i64(ptr @.lc6054, i64 1, ptr @.lcd6054, ptr @.lty6054)
%t6056 = call i64 @bn_cmp(ptr %t6053, ptr %t6055)
%t6057 = icmp eq i64 %t6056, 0
ret i1 %t6057
}
define i1 @pedersen_valid(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6058 = getelementptr i8, ptr %p0, i64 8
%t6059 = load ptr, ptr %t6058, align 8
%t6060 = getelementptr i8, ptr %p0, i64 0
%t6061 = load ptr, ptr %t6060, align 8
%t6062 = call i1 @zk_valid_mod_n(ptr %t6059, ptr %t6061)
br label %LSL6063
LSL6063:
br i1 %t6062, label %LSR6063, label %LSJ6063
LSR6063:
%t6064 = getelementptr i8, ptr %p0, i64 16
%t6065 = load ptr, ptr %t6064, align 8
%t6066 = getelementptr i8, ptr %p0, i64 0
%t6067 = load ptr, ptr %t6066, align 8
%t6068 = call i1 @zk_valid_mod_n(ptr %t6065, ptr %t6067)
br label %LSJ6063
LSJ6063:
%t6069 = phi i1 [ false, %LSL6063 ], [ %t6068, %LSR6063 ]
br label %LSL6070
LSL6070:
br i1 %t6069, label %LSR6070, label %LSJ6070
LSR6070:
%t6071 = getelementptr i8, ptr %p0, i64 8
%t6072 = load ptr, ptr %t6071, align 8
%t6073 = getelementptr i8, ptr %p0, i64 16
%t6074 = load ptr, ptr %t6073, align 8
%t6075 = call i64 @bn_cmp(ptr %t6072, ptr %t6074)
%t6076 = icmp ne i64 %t6075, 0
br label %LSJ6070
LSJ6070:
%t6077 = phi i1 [ false, %LSL6070 ], [ %t6076, %LSR6070 ]
ret i1 %t6077
}
define ptr @tr_pedersen(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6079 = getelementptr i8, ptr %p1, i64 0
%t6080 = load ptr, ptr %t6079, align 8
%t6081 = call ptr @bn_to_be(ptr %t6080, i64 256)
%t6082 = getelementptr i8, ptr %p1, i64 8
%t6083 = load ptr, ptr %t6082, align 8
%t6084 = call ptr @bn_to_be(ptr %t6083, i64 256)
%t6085 = call ptr @resid_list_freeze(ptr %t6084)
%t6086 = call ptr @resid_list_concat_own(ptr %t6081, i8 1, ptr %t6085)
%t6087 = getelementptr i8, ptr %p1, i64 16
%t6088 = load ptr, ptr %t6087, align 8
%t6089 = call ptr @bn_to_be(ptr %t6088, i64 256)
%t6090 = call ptr @resid_list_freeze(ptr %t6089)
%t6091 = call ptr @resid_list_concat_own(ptr %t6086, i8 1, ptr %t6090)
%t6092 = call ptr @tr_item(ptr %p0, ptr @.s6078, ptr %t6091)
ret ptr %t6092
}
define ptr @zk_draw_below(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6121, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t6093 = call i64 @bn_bit_len(ptr %p2)
%t6094 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t6093, i64 7)
%t6095 = extractvalue {i64, i1} %t6094, 0
%t6096 = extractvalue {i64, i1} %t6094, 1
%t6097 = zext i1 %t6096 to i8
call void @resid_overflow_check(i8 %t6097)
%t6098 = sdiv i64 %t6095, 8
%t6099 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t6098)
%t6100 = extractvalue {i64, i1} %t6099, 0
%t6101 = extractvalue {i64, i1} %t6099, 1
%t6102 = zext i1 %t6101 to i8
call void @resid_overflow_check(i8 %t6102)
%t6103 = call i64 @resid_list_len(ptr %p0)
%t6104 = icmp sgt i64 %t6100, %t6103
br i1 %t6104, label %L700, label %L702
L700:
ret ptr @.nbox6105
L702:
%t6106 = call ptr @bn_slice_int(ptr %p0, i64 %p1, i64 %t6098)
%t6107 = call ptr @resid_list_freeze(ptr %t6106)
%t6108 = call ptr @bn_from_be(ptr %t6107)
%t6109 = call ptr @resid_list_freeze(ptr %t6108)
%t6110 = call i64 @bn_cmp(ptr %t6109, ptr %p2)
%t6111 = icmp slt i64 %t6110, 0
br i1 %t6111, label %L703, label %L705
L703:
%t6112 = call ptr @resid_gmalloc(i64 16)
%t6112.f0 = getelementptr i8, ptr %t6112, i64 0
store ptr %t6109, ptr %t6112.f0, align 8
%t6113 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t6098)
%t6114 = extractvalue {i64, i1} %t6113, 0
%t6115 = extractvalue {i64, i1} %t6113, 1
%t6116 = zext i1 %t6115 to i8
call void @resid_overflow_check(i8 %t6116)
%t6112.f1 = getelementptr i8, ptr %t6112, i64 8
store i64 %t6114, ptr %t6112.f1, align 8
%t6119 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty6117)
%t6118 = getelementptr {i32, i32, ptr}, ptr %t6119, i32 1
store ptr %t6112, ptr %t6118
ret ptr %t6119
L705:
%t6120 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t6098)
%t6121 = extractvalue {i64, i1} %t6120, 0
%t6122 = extractvalue {i64, i1} %t6120, 1
%t6123 = zext i1 %t6122 to i8
call void @resid_overflow_check(i8 %t6123)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m_________lib_cggmp_zk_resid__prm_transcript(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p2.ld = call ptr @resid_list_vdata(ptr %p2.in)
%p2.ln = call i64 @resid_list_vlen(ptr %p2.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %t6130, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t6131, %tco.s0 ]
%t6125 = call i64 @resid_list_len(ptr %p2)
%t6126 = icmp sge i64 %p3, %t6125
br i1 %t6126, label %L706, label %L708
L706:
ret ptr %p0
L708:
%t6127 = call ptr @resid_list_get_v(ptr %p2, i64 %p3, ptr %p2.ld, i64 %p2.ln)
%t6130 = call ptr @tr_nat(ptr %p0, ptr %t6127)
%t6131 = add nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m_________lib_cggmp_zk_resid__prm_challenge(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6133 = call ptr @tr_pedersen(ptr %p0, ptr %p1)
call void @"resid.rec.freeze.Transcript"(ptr %t6133)
%t6134 = call ptr @__m_________lib_cggmp_zk_resid__prm_transcript(ptr %t6133, ptr %p1, ptr %p2, i64 0)
call void @"resid.rec.freeze.Transcript"(ptr %t6134)
%t6135 = call ptr @tr_seed(ptr %t6134)
%t6136 = call ptr @resid_list_freeze(ptr %t6135)
%t6137 = call ptr @tr_stream(ptr %t6136, i64 0, i64 80)
ret ptr %t6137
}
define i1 @__m_________lib_cggmp_zk_resid__prm_check_all(ptr %p0.in, ptr %p1.in, ptr %p2.in, ptr %p3.in, i64 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%p4 = phi i64 [ %p4.in, %entry ], [ %t6180, %tco.s0.k ]
%t6138 = icmp sge i64 %p4, 80
br i1 %t6138, label %L709, label %L711
L709:
call void @resid_scope_pop(i64 %lml)
ret i1 true
L711:
%t6139 = getelementptr i8, ptr %p2, i64 0
%t6140 = load ptr, ptr %t6139, align 8
%t6141 = call ptr @resid_list_get(ptr %t6140, i64 %p4)
%t6144 = getelementptr i8, ptr %p2, i64 8
%t6145 = load ptr, ptr %t6144, align 8
%t6146 = call ptr @resid_list_get(ptr %t6145, i64 %p4)
%t6149 = getelementptr i8, ptr %p1, i64 0
%t6150 = load ptr, ptr %t6149, align 8
%t6151 = call i1 @zk_valid_mod_n(ptr %t6141, ptr %t6150)
%t6152 = xor i1 %t6151, true
br label %LSL6153
LSL6153:
br i1 %t6152, label %LSJ6153, label %LSR6153
LSR6153:
%t6154 = getelementptr i8, ptr %p1, i64 0
%t6155 = load ptr, ptr %t6154, align 8
%t6156 = call i1 @zk_valid_mod_n(ptr %t6146, ptr %t6155)
%t6157 = xor i1 %t6156, true
br label %LSJ6153
LSJ6153:
%t6158 = phi i1 [ true, %LSL6153 ], [ %t6157, %LSR6153 ]
br i1 %t6158, label %L712, label %L714
L712:
call void @resid_scope_pop(i64 %lml)
ret i1 false
L714:
%t6160 = call ptr @resid_list_const_i64(ptr @.lc6159, i64 1, ptr @.lcd6159, ptr @.lty6159)
%t6161 = call i64 @bn_cmp(ptr %t6141, ptr %t6160)
%t6162 = icmp eq i64 %t6161, 0
br i1 %t6162, label %L715, label %L717
L715:
call void @resid_scope_pop(i64 %lml)
ret i1 false
L717:
%t6163 = getelementptr i8, ptr %p1, i64 16
%t6164 = load ptr, ptr %t6163, align 8
%t6165 = call ptr @bn_modexp_mont(ptr %p0, ptr %t6164, ptr %t6146)
%t6166 = call ptr @resid_list_get_v(ptr %p3, i64 %p4, ptr %p3.ld, i64 %p3.ln)
%t6167 = call i64 @resid_unbox_i64(ptr %t6166)
%t6169 = and i64 %t6167, 1
%t6170 = icmp eq i64 %t6169, 1
br i1 %t6170, label %L718, label %L719
L718:
%t6171 = getelementptr i8, ptr %p1, i64 8
%t6172 = load ptr, ptr %t6171, align 8
%t6173 = getelementptr i8, ptr %p1, i64 0
%t6174 = load ptr, ptr %t6173, align 8
%t6175 = call ptr @bn_modmul(ptr %t6141, ptr %t6172, ptr %t6174)
%t6176 = call ptr @resid_list_freeze(ptr %t6175)
br label %L720
L719:
br label %L720
L720:
%t6177 = phi ptr [ %t6176, %L718 ], [ %t6141, %L719 ]
%t6178 = call i64 @bn_cmp(ptr %t6165, ptr %t6177)
%t6179 = icmp ne i64 %t6178, 0
br i1 %t6179, label %L721, label %L723
L721:
call void @resid_scope_pop(i64 %lml)
ret i1 false
L723:
%t6180 = add nsw i64 %p4, 1
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
%t6182 = getelementptr i8, ptr %p1, i64 0
%t6183 = load ptr, ptr %t6182, align 8
%t6184 = call i64 @resid_list_len(ptr %t6183)
%t6185 = icmp ne i64 %t6184, 80
br label %LSL6186
LSL6186:
br i1 %t6185, label %LSJ6186, label %LSR6186
LSR6186:
%t6187 = getelementptr i8, ptr %p1, i64 8
%t6188 = load ptr, ptr %t6187, align 8
%t6189 = call i64 @resid_list_len(ptr %t6188)
%t6190 = icmp ne i64 %t6189, 80
br label %LSJ6186
LSJ6186:
%t6191 = phi i1 [ true, %LSL6186 ], [ %t6190, %LSR6186 ]
br i1 %t6191, label %L724, label %L726
L724:
ret i1 false
L726:
%t6192 = getelementptr i8, ptr %p0, i64 0
%t6193 = load ptr, ptr %t6192, align 8
%t6194 = call i1 @bn_is_odd(ptr %t6193)
%t6195 = xor i1 %t6194, true
br label %LSL6196
LSL6196:
br i1 %t6195, label %LSJ6196, label %LSR6196
LSR6196:
%t6197 = call i1 @pedersen_valid(ptr %p0)
%t6198 = xor i1 %t6197, true
br label %LSJ6196
LSJ6196:
%t6199 = phi i1 [ true, %LSL6196 ], [ %t6198, %LSR6196 ]
br i1 %t6199, label %L727, label %L729
L727:
ret i1 false
L729:
%t6200 = getelementptr i8, ptr %p0, i64 0
%t6201 = load ptr, ptr %t6200, align 8
%t6202 = call ptr @bn_mont_new(ptr %t6201)
%t6203 = getelementptr i8, ptr %p1, i64 0
%t6204 = load ptr, ptr %t6203, align 8
%t6205 = call ptr @__m_________lib_cggmp_zk_resid__prm_challenge(ptr %p2, ptr %p0, ptr %t6204)
%t6206 = call i1 @__m_________lib_cggmp_zk_resid__prm_check_all(ptr %t6202, ptr %p0, ptr %p1, ptr %t6205, i64 0)
ret i1 %t6206
}
define ptr @__m_________lib_cggmp_zk_resid__prm_draw_as(ptr %p0, i64 %p1, ptr %p2, i64 %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6207 = icmp sge i64 %p3, 80
br i1 %t6207, label %L730, label %L732
L730:
%t6208 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty6208)
%t6211 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty6209)
%t6210 = getelementptr {i32, i32, ptr}, ptr %t6211, i32 1
store ptr %t6208, ptr %t6210
ret ptr %t6211
L732:
%t6212 = call ptr @zk_draw_below(ptr %p0, i64 %p1, ptr %p2)
%t6213 = getelementptr {i32, i32, ptr}, ptr %t6212, i32 0, i32 0
%t6214w = load i32, ptr %t6213
%t6214 = sext i32 %t6214w to i64
%t6215 = icmp eq i64 %t6214, 1
br i1 %t6215, label %L734, label %L733
L733:
%t6216 = call ptr @__m_________lib_cggmp_zk_resid__zk_drop(ptr %p4)
br label %L735
L734:
%t6217 = getelementptr {i32, i32, ptr}, ptr %t6212, i32 1
%t6218 = getelementptr i8, ptr %t6217, i64 0
%t6219 = getelementptr ptr, ptr %t6218, i32 0
%t6220 = load ptr, ptr %t6219
%t6221 = getelementptr i8, ptr %t6220, i64 8
%t6222 = load i64, ptr %t6221, align 8
%t6223 = add nsw i64 %p3, 1
%t6224 = getelementptr i8, ptr %t6220, i64 0
%t6225 = load ptr, ptr %t6224, align 8
%t6229 = call ptr @resid_listbuf_push(ptr %p4, ptr %t6225)
%t6230 = call ptr @__m_________lib_cggmp_zk_resid__prm_draw_as(ptr %p0, i64 %t6222, ptr %p2, i64 %t6223, ptr %t6229)
br label %L735
L735:
%t6231 = phi ptr [ %t6216, %L733 ], [ %t6230, %L734 ]
ret ptr %t6231
}
define ptr @__m_________lib_cggmp_zk_resid__zk_drop(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6232 = call ptr @resid_listbuf_finish(ptr %p0, ptr @.lty6232)
ret ptr @.nbox6233
}
define ptr @__m_________lib_cggmp_zk_resid__prm_powers(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p2.ld = call ptr @resid_list_vdata(ptr %p2.in)
%p2.ln = call i64 @resid_list_vlen(ptr %p2.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t6237, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t6246, %tco.s0 ]
%t6234 = call i64 @resid_list_len(ptr %p2)
%t6235 = icmp sge i64 %p3, %t6234
br i1 %t6235, label %L736, label %L738
L736:
%t6236 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty6236)
ret ptr %t6236
L738:
%t6237 = add nsw i64 %p3, 1
%t6238 = call ptr @resid_list_get_v(ptr %p2, i64 %p3, ptr %p2.ld, i64 %p2.ln)
%t6241 = call ptr @bn_modexp_mont(ptr %p0, ptr %p1, ptr %t6238)
%t6242 = call ptr @resid_list_freeze(ptr %t6241)
%t6246 = call ptr @resid_listbuf_push(ptr %p4, ptr %t6242)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m_________lib_cggmp_zk_resid__prm_responses(ptr %p0.in, ptr %p1.in, ptr %p2.in, ptr %p3.in, i64 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%p4 = phi i64 [ %p4.in, %entry ], [ %t6267, %tco.s0 ]
%p5 = phi ptr [ %p5.in, %entry ], [ %t6271, %tco.s0 ]
%t6248 = call i64 @resid_list_len(ptr %p0)
%t6249 = icmp sge i64 %p4, %t6248
br i1 %t6249, label %L739, label %L741
L739:
%t6250 = call ptr @resid_listbuf_finish(ptr %p5, ptr @.lty6250)
ret ptr %t6250
L741:
%t6251 = call ptr @resid_list_get_v(ptr %p1, i64 %p4, ptr %p1.ld, i64 %p1.ln)
%t6252 = call i64 @resid_unbox_i64(ptr %t6251)
%t6254 = and i64 %t6252, 1
%t6255 = icmp eq i64 %t6254, 1
br i1 %t6255, label %L742, label %L743
L742:
%t6256 = call ptr @resid_list_get_v(ptr %p0, i64 %p4, ptr %p0.ld, i64 %p0.ln)
%t6259 = call ptr @bn_mod(ptr %p2, ptr %p3)
%t6260 = call ptr @resid_list_freeze(ptr %t6259)
%t6261 = call ptr @bn_modadd(ptr %t6256, ptr %t6260, ptr %p3)
%t6262 = call ptr @resid_list_freeze(ptr %t6261)
br label %L744
L743:
%t6263 = call ptr @resid_list_get_v(ptr %p0, i64 %p4, ptr %p0.ld, i64 %p0.ln)
br label %L744
L744:
%t6266 = phi ptr [ %t6262, %L742 ], [ %t6263, %L743 ]
%t6267 = add nsw i64 %p4, 1
%t6271 = call ptr @resid_listbuf_push(ptr %p5, ptr %t6266)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @prm_prove(ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6273 = call ptr @resid_listbuf_new()
%t6274 = call ptr @__m_________lib_cggmp_zk_resid__prm_draw_as(ptr %p4, i64 0, ptr %p1, i64 0, ptr %t6273)
%t6275 = getelementptr {i32, i32, ptr}, ptr %t6274, i32 0, i32 0
%t6276w = load i32, ptr %t6275
%t6276 = sext i32 %t6276w to i64
%t6277 = icmp eq i64 %t6276, 1
br i1 %t6277, label %L746, label %L745
L745:
br label %L747
L746:
%t6279 = getelementptr {i32, i32, ptr}, ptr %t6274, i32 1
%t6280 = getelementptr i8, ptr %t6279, i64 0
%t6281 = getelementptr ptr, ptr %t6280, i32 0
%t6282 = load ptr, ptr %t6281
%t6283 = call ptr @__m_________lib_cggmp_zk_resid__prm_finish(ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %t6282)
call void @"resid.rec.freeze.PrmProof"(ptr %t6283)
%t6286 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty6284)
%t6285 = getelementptr {i32, i32, ptr}, ptr %t6286, i32 1
store ptr %t6283, ptr %t6285
br label %L747
L747:
%t6287 = phi ptr [ @.nbox6278, %L745 ], [ %t6286, %L746 ]
ret ptr %t6287
}
define ptr @__m_________lib_cggmp_zk_resid__prm_finish(ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6288 = getelementptr i8, ptr %p2, i64 0
%t6289 = load ptr, ptr %t6288, align 8
%t6290 = call ptr @bn_mont_new(ptr %t6289)
%t6291 = getelementptr i8, ptr %p2, i64 16
%t6292 = load ptr, ptr %t6291, align 8
%t6293 = call ptr @resid_listbuf_new()
%t6294 = call ptr @__m_________lib_cggmp_zk_resid__prm_powers(ptr %t6290, ptr %t6292, ptr %p4, i64 0, ptr %t6293)
%t6295 = call ptr @__m_________lib_cggmp_zk_resid__prm_challenge(ptr %p3, ptr %p2, ptr %t6294)
%t6296 = call ptr @resid_gmalloc(i64 16)
%t6296.f0 = getelementptr i8, ptr %t6296, i64 0
store ptr %t6294, ptr %t6296.f0, align 8
%t6297 = call ptr @resid_listbuf_new()
%t6298 = call ptr @__m_________lib_cggmp_zk_resid__prm_responses(ptr %p4, ptr %t6295, ptr %p0, ptr %p1, i64 0, ptr %t6297)
%t6296.f1 = getelementptr i8, ptr %t6296, i64 8
store ptr %t6298, ptr %t6296.f1, align 8
ret ptr %t6296
}
define ptr @__m_________lib_cggmp_zk_resid__mod_challenges(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6299 = call ptr @tr_modulus(ptr %p0, ptr %p1)
call void @"resid.rec.freeze.Transcript"(ptr %t6299)
%t6300 = call ptr @tr_nat(ptr %t6299, ptr %p2)
call void @"resid.rec.freeze.Transcript"(ptr %t6300)
%t6301 = call ptr @tr_seed(ptr %t6300)
%t6302 = call ptr @resid_list_freeze(ptr %t6301)
%t6303 = call ptr @resid_listbuf_new()
%t6304 = call ptr @__m_________lib_cggmp_zk_resid__mod_ys(ptr %t6302, ptr %p1, i64 0, i64 0, ptr %t6303)
ret ptr %t6304
}
define ptr @__m_________lib_cggmp_zk_resid__mod_ys(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t6309, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t6310, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t6316, %tco.s0 ]
%t6305 = icmp sge i64 %p3, 80
br i1 %t6305, label %L748, label %L750
L748:
%t6306 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty6306)
ret ptr %t6306
L750:
%t6307 = call ptr @tr_sample_modn(ptr %p0, i64 %p2, ptr %p1)
call void @"resid.rec.freeze.TrSample"(ptr %t6307)
%t6308 = getelementptr i8, ptr %t6307, i64 8
%t6309 = load i64, ptr %t6308, align 8
%t6310 = add nsw i64 %p3, 1
%t6311 = getelementptr i8, ptr %t6307, i64 0
%t6312 = load ptr, ptr %t6311, align 8
%t6316 = call ptr @resid_listbuf_push(ptr %p4, ptr %t6312)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i1 @__m_________lib_cggmp_zk_resid__mod_response_ok(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6318 = getelementptr i8, ptr %p3, i64 16
%t6319 = load ptr, ptr %t6318, align 8
%t6320 = getelementptr i8, ptr %p0, i64 0
%t6321 = load ptr, ptr %t6320, align 8
%t6322 = call i1 @zk_valid_mod_n(ptr %t6319, ptr %t6321)
%t6323 = xor i1 %t6322, true
br label %LSL6324
LSL6324:
br i1 %t6323, label %LSJ6324, label %LSR6324
LSR6324:
%t6325 = getelementptr i8, ptr %p3, i64 24
%t6326 = load ptr, ptr %t6325, align 8
%t6327 = getelementptr i8, ptr %p0, i64 0
%t6328 = load ptr, ptr %t6327, align 8
%t6329 = call i1 @zk_valid_mod_n(ptr %t6326, ptr %t6328)
%t6330 = xor i1 %t6329, true
br label %LSJ6324
LSJ6324:
%t6331 = phi i1 [ true, %LSL6324 ], [ %t6330, %LSR6324 ]
br i1 %t6331, label %L751, label %L753
L751:
ret i1 false
L753:
%t6332 = getelementptr i8, ptr %p3, i64 24
%t6333 = load ptr, ptr %t6332, align 8
%t6334 = getelementptr i8, ptr %p0, i64 0
%t6335 = load ptr, ptr %t6334, align 8
%t6336 = call ptr @bn_modexp_mont(ptr %p0, ptr %t6333, ptr %t6335)
%t6337 = call ptr @resid_list_freeze(ptr %t6336)
%t6338 = getelementptr i8, ptr %p0, i64 0
%t6339 = load ptr, ptr %t6338, align 8
%t6340 = call ptr @bn_mod(ptr %p2, ptr %t6339)
%t6341 = call ptr @resid_list_freeze(ptr %t6340)
%t6342 = call i64 @bn_cmp(ptr %t6337, ptr %t6341)
%t6343 = icmp ne i64 %t6342, 0
br i1 %t6343, label %L754, label %L756
L754:
ret i1 false
L756:
%t6344 = getelementptr i8, ptr %p3, i64 16
%t6345 = load ptr, ptr %t6344, align 8
%t6346 = getelementptr i8, ptr %p3, i64 16
%t6347 = load ptr, ptr %t6346, align 8
%t6348 = getelementptr i8, ptr %p0, i64 0
%t6349 = load ptr, ptr %t6348, align 8
%t6350 = call ptr @bn_modmul(ptr %t6345, ptr %t6347, ptr %t6349)
%t6351 = getelementptr i8, ptr %p0, i64 0
%t6352 = load ptr, ptr %t6351, align 8
%t6353 = call ptr @bn_modmul(ptr %t6350, ptr %t6350, ptr %t6352)
%t6354 = getelementptr i8, ptr %p3, i64 0
%t6355 = load i1, ptr %t6354, align 8
br i1 %t6355, label %L757, label %L758
L757:
%t6357 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty6356)
%t6358 = getelementptr i8, ptr %p0, i64 0
%t6359 = load ptr, ptr %t6358, align 8
%t6360 = call ptr @bn_mod(ptr %p2, ptr %t6359)
%t6361 = call ptr @resid_list_freeze(ptr %t6360)
%t6362 = getelementptr i8, ptr %p0, i64 0
%t6363 = load ptr, ptr %t6362, align 8
%t6364 = call ptr @bn_modsub(ptr %t6357, ptr %t6361, ptr %t6363)
%t6365 = call ptr @resid_list_freeze(ptr %t6364)
br label %L759
L758:
%t6366 = getelementptr i8, ptr %p0, i64 0
%t6367 = load ptr, ptr %t6366, align 8
%t6368 = call ptr @bn_mod(ptr %p2, ptr %t6367)
%t6369 = call ptr @resid_list_freeze(ptr %t6368)
br label %L759
L759:
%t6370 = phi ptr [ %t6365, %L757 ], [ %t6369, %L758 ]
%t6371 = getelementptr i8, ptr %p3, i64 8
%t6372 = load i1, ptr %t6371, align 8
br i1 %t6372, label %L760, label %L761
L760:
%t6373 = getelementptr i8, ptr %p0, i64 0
%t6374 = load ptr, ptr %t6373, align 8
%t6375 = call ptr @bn_modmul(ptr %t6370, ptr %p1, ptr %t6374)
%t6376 = call ptr @resid_list_freeze(ptr %t6375)
br label %L762
L761:
br label %L762
L762:
%t6377 = phi ptr [ %t6376, %L760 ], [ %t6370, %L761 ]
%t6378 = call i64 @bn_cmp(ptr %t6353, ptr %t6377)
%t6379 = icmp eq i64 %t6378, 0
ret i1 %t6379
}
define i1 @__m_________lib_cggmp_zk_resid__mod_check_all(ptr %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p2.ld = call ptr @resid_list_vdata(ptr %p2.in)
%p2.ln = call i64 @resid_list_vlen(ptr %p2.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t6393, %tco.s0.k ]
%t6380 = icmp sge i64 %p3, 80
br i1 %t6380, label %L763, label %L765
L763:
call void @resid_scope_pop(i64 %lml)
ret i1 true
L765:
%t6381 = getelementptr i8, ptr %p1, i64 0
%t6382 = load ptr, ptr %t6381, align 8
%t6383 = call ptr @resid_list_get_v(ptr %p2, i64 %p3, ptr %p2.ld, i64 %p2.ln)
%t6386 = getelementptr i8, ptr %p1, i64 8
%t6387 = load ptr, ptr %t6386, align 8
%t6388 = call ptr @resid_list_get(ptr %t6387, i64 %p3)
%t6391 = call i1 @__m_________lib_cggmp_zk_resid__mod_response_ok(ptr %p0, ptr %t6382, ptr %t6383, ptr %t6388)
%t6392 = xor i1 %t6391, true
br i1 %t6392, label %L766, label %L768
L766:
call void @resid_scope_pop(i64 %lml)
ret i1 false
L768:
%t6393 = add nsw i64 %p3, 1
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
%t6395 = getelementptr i8, ptr %p1, i64 8
%t6396 = load ptr, ptr %t6395, align 8
%t6397 = call i64 @resid_list_len(ptr %t6396)
%t6398 = icmp ne i64 %t6397, 80
br i1 %t6398, label %L769, label %L771
L769:
ret i1 false
L771:
%t6399 = call i1 @bn_is_odd(ptr %p0)
%t6400 = xor i1 %t6399, true
br label %LSL6401
LSL6401:
br i1 %t6400, label %LSJ6401, label %LSR6401
LSR6401:
%t6403 = call ptr @resid_list_const_i64(ptr @.lc6402, i64 1, ptr @.lcd6402, ptr @.lty6402)
%t6404 = call i64 @bn_cmp(ptr %p0, ptr %t6403)
%t6405 = icmp sle i64 %t6404, 0
br label %LSJ6401
LSJ6401:
%t6406 = phi i1 [ true, %LSL6401 ], [ %t6405, %LSR6401 ]
br i1 %t6406, label %L772, label %L774
L772:
ret i1 false
L774:
%t6407 = alloca [1 x ptr]
%t6409 = call ptr @resid_box_i64(i64 2)
%t6411 = getelementptr i8, ptr %t6407, i64 0
store ptr %t6409, ptr %t6411
%t6412 = call ptr @resid_list_new(i64 1, ptr %t6407, ptr @.lty6407)
%t6413 = alloca [1 x ptr]
%t6415 = call ptr @resid_box_i64(i64 3)
%t6417 = getelementptr i8, ptr %t6413, i64 0
store ptr %t6415, ptr %t6417
%t6418 = call ptr @resid_list_new(i64 1, ptr %t6413, ptr @.lty6413)
%t6419 = alloca [1 x ptr]
%t6421 = call ptr @resid_box_i64(i64 5)
%t6423 = getelementptr i8, ptr %t6419, i64 0
store ptr %t6421, ptr %t6423
%t6424 = call ptr @resid_list_new(i64 1, ptr %t6419, ptr @.lty6419)
%t6425 = alloca [1 x ptr]
%t6427 = call ptr @resid_box_i64(i64 7)
%t6429 = getelementptr i8, ptr %t6425, i64 0
store ptr %t6427, ptr %t6429
%t6430 = call ptr @resid_list_new(i64 1, ptr %t6425, ptr @.lty6425)
%t6431 = alloca [1 x ptr]
%t6433 = call ptr @resid_box_i64(i64 11)
%t6435 = getelementptr i8, ptr %t6431, i64 0
store ptr %t6433, ptr %t6435
%t6436 = call ptr @resid_list_new(i64 1, ptr %t6431, ptr @.lty6431)
%t6437 = alloca [1 x ptr]
%t6439 = call ptr @resid_box_i64(i64 13)
%t6441 = getelementptr i8, ptr %t6437, i64 0
store ptr %t6439, ptr %t6441
%t6442 = call ptr @resid_list_new(i64 1, ptr %t6437, ptr @.lty6437)
%t6443 = alloca [1 x ptr]
%t6445 = call ptr @resid_box_i64(i64 17)
%t6447 = getelementptr i8, ptr %t6443, i64 0
store ptr %t6445, ptr %t6447
%t6448 = call ptr @resid_list_new(i64 1, ptr %t6443, ptr @.lty6443)
%t6449 = alloca [1 x ptr]
%t6451 = call ptr @resid_box_i64(i64 19)
%t6453 = getelementptr i8, ptr %t6449, i64 0
store ptr %t6451, ptr %t6453
%t6454 = call ptr @resid_list_new(i64 1, ptr %t6449, ptr @.lty6449)
%t6455 = alloca [1 x ptr]
%t6457 = call ptr @resid_box_i64(i64 23)
%t6459 = getelementptr i8, ptr %t6455, i64 0
store ptr %t6457, ptr %t6459
%t6460 = call ptr @resid_list_new(i64 1, ptr %t6455, ptr @.lty6455)
%t6461 = alloca [1 x ptr]
%t6463 = call ptr @resid_box_i64(i64 29)
%t6465 = getelementptr i8, ptr %t6461, i64 0
store ptr %t6463, ptr %t6465
%t6466 = call ptr @resid_list_new(i64 1, ptr %t6461, ptr @.lty6461)
%t6467 = alloca [1 x ptr]
%t6469 = call ptr @resid_box_i64(i64 31)
%t6471 = getelementptr i8, ptr %t6467, i64 0
store ptr %t6469, ptr %t6471
%t6472 = call ptr @resid_list_new(i64 1, ptr %t6467, ptr @.lty6467)
%t6473 = alloca [1 x ptr]
%t6475 = call ptr @resid_box_i64(i64 37)
%t6477 = getelementptr i8, ptr %t6473, i64 0
store ptr %t6475, ptr %t6477
%t6478 = call ptr @resid_list_new(i64 1, ptr %t6473, ptr @.lty6473)
%t6479 = alloca [12 x ptr]
%t6483 = getelementptr i8, ptr %t6479, i64 0
store ptr %t6412, ptr %t6483
%t6486 = getelementptr i8, ptr %t6479, i64 8
store ptr %t6418, ptr %t6486
%t6489 = getelementptr i8, ptr %t6479, i64 16
store ptr %t6424, ptr %t6489
%t6492 = getelementptr i8, ptr %t6479, i64 24
store ptr %t6430, ptr %t6492
%t6495 = getelementptr i8, ptr %t6479, i64 32
store ptr %t6436, ptr %t6495
%t6498 = getelementptr i8, ptr %t6479, i64 40
store ptr %t6442, ptr %t6498
%t6501 = getelementptr i8, ptr %t6479, i64 48
store ptr %t6448, ptr %t6501
%t6504 = getelementptr i8, ptr %t6479, i64 56
store ptr %t6454, ptr %t6504
%t6507 = getelementptr i8, ptr %t6479, i64 64
store ptr %t6460, ptr %t6507
%t6510 = getelementptr i8, ptr %t6479, i64 72
store ptr %t6466, ptr %t6510
%t6513 = getelementptr i8, ptr %t6479, i64 80
store ptr %t6472, ptr %t6513
%t6516 = getelementptr i8, ptr %t6479, i64 88
store ptr %t6478, ptr %t6516
%t6517 = call ptr @resid_list_new(i64 12, ptr %t6479, ptr @.lty6479)
%t6518 = call i1 @bn_miller_rabin(ptr %p0, ptr %t6517)
br i1 %t6518, label %L775, label %L777
L775:
ret i1 false
L777:
%t6519 = getelementptr i8, ptr %p1, i64 0
%t6520 = load ptr, ptr %t6519, align 8
%t6521 = call i64 @bn_jacobi(ptr %t6520, ptr %p0)
%t6522 = icmp ne i64 %t6521, -1
br i1 %t6522, label %L778, label %L780
L778:
ret i1 false
L780:
%t6523 = getelementptr i8, ptr %p1, i64 0
%t6524 = load ptr, ptr %t6523, align 8
%t6525 = call i1 @zk_valid_mod_n(ptr %t6524, ptr %p0)
%t6526 = xor i1 %t6525, true
br i1 %t6526, label %L781, label %L783
L781:
ret i1 false
L783:
%t6527 = call ptr @bn_mont_new(ptr %p0)
call void @"resid.rec.freeze.BnMont"(ptr %t6527)
%t6528 = getelementptr i8, ptr %p1, i64 0
%t6529 = load ptr, ptr %t6528, align 8
%t6530 = call ptr @__m_________lib_cggmp_zk_resid__mod_challenges(ptr %p2, ptr %p0, ptr %t6529)
%t6531 = call i1 @__m_________lib_cggmp_zk_resid__mod_check_all(ptr %t6527, ptr %p1, ptr %t6530, i64 0)
ret i1 %t6531
}
define i1 @__m_________lib_cggmp_zk_resid__mod_is_qr(ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6532 = call ptr @bn_mod(ptr %p0, ptr %p1)
%t6533 = call ptr @resid_list_freeze(ptr %t6532)
%t6534 = call ptr @bn_modexp(ptr %t6533, ptr %p3, ptr %p1)
%t6535 = call ptr @resid_list_freeze(ptr %t6534)
%t6537 = call ptr @resid_list_const_i64(ptr @.lc6536, i64 1, ptr @.lcd6536, ptr @.lty6536)
%t6538 = call i64 @bn_cmp(ptr %t6535, ptr %t6537)
%t6539 = icmp eq i64 %t6538, 0
br label %LSL6540
LSL6540:
br i1 %t6539, label %LSR6540, label %LSJ6540
LSR6540:
%t6541 = call ptr @bn_mod(ptr %p0, ptr %p2)
%t6542 = call ptr @resid_list_freeze(ptr %t6541)
%t6543 = call ptr @bn_modexp(ptr %t6542, ptr %p4, ptr %p2)
%t6544 = call ptr @resid_list_freeze(ptr %t6543)
%t6546 = call ptr @resid_list_const_i64(ptr @.lc6545, i64 1, ptr @.lcd6545, ptr @.lty6545)
%t6547 = call i64 @bn_cmp(ptr %t6544, ptr %t6546)
%t6548 = icmp eq i64 %t6547, 0
br label %LSJ6540
LSJ6540:
%t6549 = phi i1 [ false, %LSL6540 ], [ %t6548, %LSR6540 ]
ret i1 %t6549
}
define ptr @__m_________lib_cggmp_zk_resid__mod_make_qr(ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %p4, ptr %p5, ptr %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6550 = call ptr @bn_mod(ptr %p0, ptr %p2)
%t6551 = call ptr @resid_list_freeze(ptr %t6550)
%t6552 = call i1 @__m_________lib_cggmp_zk_resid__mod_is_qr(ptr %t6551, ptr %p3, ptr %p4, ptr %p5, ptr %p6)
br i1 %t6552, label %L784, label %L786
L784:
%t6553 = call ptr @resid_gmalloc(i64 24)
%t6553.f0 = getelementptr i8, ptr %t6553, i64 0
store i1 false, ptr %t6553.f0, align 8
%t6553.f1 = getelementptr i8, ptr %t6553, i64 8
store i1 false, ptr %t6553.f1, align 8
%t6553.f2 = getelementptr i8, ptr %t6553, i64 16
store ptr %t6551, ptr %t6553.f2, align 8
ret ptr %t6553
L786:
%t6555 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty6554)
%t6556 = call ptr @bn_modsub(ptr %t6555, ptr %t6551, ptr %p2)
%t6557 = call ptr @resid_list_freeze(ptr %t6556)
%t6558 = call i1 @__m_________lib_cggmp_zk_resid__mod_is_qr(ptr %t6557, ptr %p3, ptr %p4, ptr %p5, ptr %p6)
br i1 %t6558, label %L787, label %L789
L787:
%t6559 = call ptr @resid_gmalloc(i64 24)
%t6559.f0 = getelementptr i8, ptr %t6559, i64 0
store i1 true, ptr %t6559.f0, align 8
%t6559.f1 = getelementptr i8, ptr %t6559, i64 8
store i1 false, ptr %t6559.f1, align 8
%t6559.f2 = getelementptr i8, ptr %t6559, i64 16
store ptr %t6557, ptr %t6559.f2, align 8
ret ptr %t6559
L789:
%t6560 = call ptr @bn_modmul(ptr %t6557, ptr %p1, ptr %p2)
%t6561 = call ptr @resid_list_freeze(ptr %t6560)
%t6562 = call i1 @__m_________lib_cggmp_zk_resid__mod_is_qr(ptr %t6561, ptr %p3, ptr %p4, ptr %p5, ptr %p6)
br i1 %t6562, label %L790, label %L792
L790:
%t6563 = call ptr @resid_gmalloc(i64 24)
%t6563.f0 = getelementptr i8, ptr %t6563, i64 0
store i1 true, ptr %t6563.f0, align 8
%t6563.f1 = getelementptr i8, ptr %t6563, i64 8
store i1 true, ptr %t6563.f1, align 8
%t6563.f2 = getelementptr i8, ptr %t6563, i64 16
store ptr %t6561, ptr %t6563.f2, align 8
ret ptr %t6563
L792:
%t6564 = call ptr @resid_gmalloc(i64 24)
%t6564.f0 = getelementptr i8, ptr %t6564, i64 0
store i1 false, ptr %t6564.f0, align 8
%t6564.f1 = getelementptr i8, ptr %t6564, i64 8
store i1 true, ptr %t6564.f1, align 8
%t6566 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty6565)
%t6567 = call ptr @bn_modsub(ptr %t6566, ptr %t6561, ptr %p2)
%t6564.f2 = getelementptr i8, ptr %t6564, i64 16
store ptr %t6567, ptr %t6564.f2, align 8
ret ptr %t6564
}
define ptr @__m_________lib_cggmp_zk_resid__mod_draw_qnr(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t6592, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%t6568 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 256)
%t6569 = extractvalue {i64, i1} %t6568, 0
%t6570 = extractvalue {i64, i1} %t6568, 1
%t6571 = zext i1 %t6570 to i8
call void @resid_overflow_check(i8 %t6571)
%t6572 = call i64 @resid_list_len(ptr %p0)
%t6573 = icmp sgt i64 %t6569, %t6572
br i1 %t6573, label %L793, label %L795
L793:
ret ptr @.nbox6574
L795:
%t6575 = call ptr @bn_slice_int(ptr %p0, i64 %p1, i64 256)
%t6576 = call ptr @resid_list_freeze(ptr %t6575)
%t6577 = call ptr @bn_from_be(ptr %t6576)
%t6578 = call ptr @resid_list_freeze(ptr %t6577)
%t6579 = call ptr @bn_mod(ptr %t6578, ptr %p2)
%t6580 = call ptr @resid_list_freeze(ptr %t6579)
%t6581 = call i64 @bn_jacobi(ptr %t6580, ptr %p2)
%t6582 = icmp eq i64 %t6581, -1
br i1 %t6582, label %L796, label %L798
L796:
%t6583 = call ptr @resid_gmalloc(i64 16)
%t6583.f0 = getelementptr i8, ptr %t6583, i64 0
store ptr %t6580, ptr %t6583.f0, align 8
%t6584 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 256)
%t6585 = extractvalue {i64, i1} %t6584, 0
%t6586 = extractvalue {i64, i1} %t6584, 1
%t6587 = zext i1 %t6586 to i8
call void @resid_overflow_check(i8 %t6587)
%t6583.f1 = getelementptr i8, ptr %t6583, i64 8
store i64 %t6585, ptr %t6583.f1, align 8
%t6590 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty6588)
%t6589 = getelementptr {i32, i32, ptr}, ptr %t6590, i32 1
store ptr %t6583, ptr %t6589
ret ptr %t6590
L798:
%t6591 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 256)
%t6592 = extractvalue {i64, i1} %t6591, 0
%t6593 = extractvalue {i64, i1} %t6591, 1
%t6594 = zext i1 %t6593 to i8
call void @resid_overflow_check(i8 %t6594)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m_________lib_cggmp_zk_resid__mod_responses(ptr %p0.in, ptr %p1.in, ptr %p2.in, ptr %p3.in, ptr %p4.in, ptr %p5.in, ptr %p6.in, ptr %p7.in, ptr %p8.in, i64 %p9.in, ptr %p10.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%p9 = phi i64 [ %p9.in, %entry ], [ %t6614, %tco.s0 ]
%p10 = phi ptr [ %p10.in, %entry ], [ %t6618, %tco.s0 ]
%t6596 = call i64 @resid_list_len(ptr %p8)
%t6597 = icmp sge i64 %p9, %t6596
br i1 %t6597, label %L799, label %L801
L799:
%t6598 = call ptr @resid_listbuf_finish(ptr %p10, ptr @.lty6598)
ret ptr %t6598
L801:
%t6599 = call ptr @resid_list_get_v(ptr %p8, i64 %p9, ptr %p8.ld, i64 %p8.ln)
%t6602 = call ptr @__m_________lib_cggmp_zk_resid__mod_make_qr(ptr %t6599, ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %p4, ptr %p5)
%t6603 = call ptr @resid_gmalloc(i64 32)
%t6604 = getelementptr i8, ptr %t6602, i64 0
%t6605 = load i1, ptr %t6604, align 8
%t6603.f0 = getelementptr i8, ptr %t6603, i64 0
store i1 %t6605, ptr %t6603.f0, align 8
%t6606 = getelementptr i8, ptr %t6602, i64 8
%t6607 = load i1, ptr %t6606, align 8
%t6603.f1 = getelementptr i8, ptr %t6603, i64 8
store i1 %t6607, ptr %t6603.f1, align 8
%t6608 = getelementptr i8, ptr %t6602, i64 16
%t6609 = load ptr, ptr %t6608, align 8
%t6610 = call ptr @bn_modexp(ptr %t6609, ptr %p6, ptr %p1)
%t6611 = call ptr @resid_list_freeze(ptr %t6610)
%t6603.f2 = getelementptr i8, ptr %t6603, i64 16
store ptr %t6611, ptr %t6603.f2, align 8
%t6612 = call ptr @bn_modexp(ptr %t6599, ptr %p7, ptr %p1)
%t6613 = call ptr @resid_list_freeze(ptr %t6612)
%t6603.f3 = getelementptr i8, ptr %t6603, i64 24
store ptr %t6613, ptr %t6603.f3, align 8
%t6614 = add nsw i64 %p9, 1
%t6618 = call ptr @resid_listbuf_push(ptr %p10, ptr %t6603)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @mod_prove(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6620 = call ptr @bn_mul(ptr %p0, ptr %p1)
%t6621 = call ptr @resid_list_freeze(ptr %t6620)
%t6622 = call ptr @__m_________lib_cggmp_zk_resid__mod_draw_qnr(ptr %p3, i64 0, ptr %t6621)
%t6623 = getelementptr {i32, i32, ptr}, ptr %t6622, i32 0, i32 0
%t6624w = load i32, ptr %t6623
%t6624 = sext i32 %t6624w to i64
%t6625 = icmp eq i64 %t6624, 1
br i1 %t6625, label %L803, label %L802
L802:
br label %L804
L803:
%t6627 = getelementptr {i32, i32, ptr}, ptr %t6622, i32 1
%t6628 = getelementptr i8, ptr %t6627, i64 0
%t6629 = getelementptr ptr, ptr %t6628, i32 0
%t6630 = load ptr, ptr %t6629
%t6631 = getelementptr i8, ptr %t6630, i64 0
%t6632 = load ptr, ptr %t6631, align 8
%t6633 = call ptr @__m_________lib_cggmp_zk_resid__mod_prove_with(ptr %p0, ptr %p1, ptr %t6621, ptr %t6632, ptr %p2)
call void @"resid.rec.freeze.ModProof"(ptr %t6633)
%t6636 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty6634)
%t6635 = getelementptr {i32, i32, ptr}, ptr %t6636, i32 1
store ptr %t6633, ptr %t6635
br label %L804
L804:
%t6637 = phi ptr [ @.nbox6626, %L802 ], [ %t6636, %L803 ]
ret ptr %t6637
}
define ptr @__m_________lib_cggmp_zk_resid__mod_prove_with(ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6639 = call ptr @resid_list_const_i64(ptr @.lc6638, i64 1, ptr @.lcd6638, ptr @.lty6638)
%t6640 = call ptr @bn_sub(ptr %p0, ptr %t6639)
%t6642 = call ptr @resid_list_const_i64(ptr @.lc6641, i64 1, ptr @.lcd6641, ptr @.lty6641)
%t6643 = call ptr @bn_sub(ptr %p1, ptr %t6642)
%t6644 = call ptr @bn_mul(ptr %t6640, ptr %t6643)
%t6646 = call ptr @resid_list_const_i64(ptr @.lc6645, i64 1, ptr @.lcd6645, ptr @.lty6645)
%t6647 = call ptr @bn_add(ptr %t6644, ptr %t6646)
%t6648 = call ptr @bn_shr(ptr %t6647, i64 3)
%t6649 = call ptr @bn_modmul(ptr %t6648, ptr %t6648, ptr %t6644)
%t6650 = call ptr @bn_modinv(ptr %p2, ptr %t6644)
%t6651 = getelementptr {i32, i32, ptr}, ptr %t6650, i32 0, i32 0
%t6652w = load i32, ptr %t6651
%t6652 = sext i32 %t6652w to i64
%t6653 = icmp eq i64 %t6652, 1
br i1 %t6653, label %L805, label %L806
L805:
%t6654 = getelementptr {i32, i32, ptr}, ptr %t6650, i32 1
%t6655 = getelementptr i8, ptr %t6654, i64 0
%t6656 = getelementptr ptr, ptr %t6655, i32 0
%t6657 = load ptr, ptr %t6656
br label %L807
L806:
%t6659 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty6658)
br label %L807
L807:
%t6660 = phi ptr [ %t6657, %L805 ], [ %t6659, %L806 ]
%t6661 = call ptr @__m_________lib_cggmp_zk_resid__mod_challenges(ptr %p4, ptr %p2, ptr %p3)
%t6662 = call ptr @resid_gmalloc(i64 16)
%t6662.f0 = getelementptr i8, ptr %t6662, i64 0
store ptr %p3, ptr %t6662.f0, align 8
%t6663 = call ptr @bn_shr(ptr %p0, i64 1)
%t6664 = call ptr @bn_shr(ptr %p1, i64 1)
%t6665 = call ptr @resid_listbuf_new()
%t6666 = call ptr @__m_________lib_cggmp_zk_resid__mod_responses(ptr %p3, ptr %p2, ptr %p0, ptr %p1, ptr %t6663, ptr %t6664, ptr %t6649, ptr %t6660, ptr %t6661, i64 0, ptr %t6665)
%t6662.f1 = getelementptr i8, ptr %t6662, i64 8
store ptr %t6666, ptr %t6662.f1, align 8
ret ptr %t6662
}
define ptr @zk_draw_unit(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6667 = call ptr @zk_draw_below(ptr %p0, i64 %p1, ptr %p2)
%t6668 = getelementptr {i32, i32, ptr}, ptr %t6667, i32 0, i32 0
%t6669w = load i32, ptr %t6668
%t6669 = sext i32 %t6669w to i64
%t6670 = icmp eq i64 %t6669, 1
br i1 %t6670, label %L809, label %L808
L808:
br label %L810
L809:
%t6672 = getelementptr {i32, i32, ptr}, ptr %t6667, i32 1
%t6673 = getelementptr i8, ptr %t6672, i64 0
%t6674 = getelementptr ptr, ptr %t6673, i32 0
%t6675 = load ptr, ptr %t6674
%t6676 = getelementptr i8, ptr %t6675, i64 0
%t6677 = load ptr, ptr %t6676, align 8
%t6678 = call i1 @zk_valid_mod_n(ptr %t6677, ptr %p2)
br i1 %t6678, label %L811, label %L812
L811:
%t6681 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty6679)
%t6680 = getelementptr {i32, i32, ptr}, ptr %t6681, i32 1
store ptr %t6675, ptr %t6680
br label %L813
L812:
%t6682 = getelementptr i8, ptr %t6675, i64 8
%t6683 = load i64, ptr %t6682, align 8
%t6684 = call ptr @zk_draw_unit(ptr %p0, i64 %t6683, ptr %p2)
br label %L813
L813:
%t6685 = phi ptr [ %t6681, %L811 ], [ %t6684, %L812 ]
br label %L810
L810:
%t6686 = phi ptr [ @.nbox6671, %L808 ], [ %t6685, %L813 ]
ret ptr %t6686
}
define ptr @pedersen_generate(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6687 = call ptr @bn_mul(ptr %p0, ptr %p1)
%t6688 = call ptr @resid_list_freeze(ptr %t6687)
%t6690 = call ptr @resid_list_const_i64(ptr @.lc6689, i64 1, ptr @.lcd6689, ptr @.lty6689)
%t6691 = call ptr @bn_sub(ptr %p0, ptr %t6690)
%t6692 = call ptr @resid_list_freeze(ptr %t6691)
%t6694 = call ptr @resid_list_const_i64(ptr @.lc6693, i64 1, ptr @.lcd6693, ptr @.lty6693)
%t6695 = call ptr @bn_sub(ptr %p1, ptr %t6694)
%t6696 = call ptr @resid_list_freeze(ptr %t6695)
%t6697 = call ptr @bn_mul(ptr %t6692, ptr %t6696)
%t6698 = call ptr @resid_list_freeze(ptr %t6697)
%t6699 = call ptr @zk_draw_below(ptr %p2, i64 0, ptr %t6698)
%t6700 = getelementptr {i32, i32, ptr}, ptr %t6699, i32 0, i32 0
%t6701w = load i32, ptr %t6700
%t6701 = sext i32 %t6701w to i64
%t6702 = icmp eq i64 %t6701, 1
br i1 %t6702, label %L815, label %L814
L814:
br label %L816
L815:
%t6704 = getelementptr {i32, i32, ptr}, ptr %t6699, i32 1
%t6705 = getelementptr i8, ptr %t6704, i64 0
%t6706 = getelementptr ptr, ptr %t6705, i32 0
%t6707 = load ptr, ptr %t6706
%t6708 = getelementptr i8, ptr %t6707, i64 8
%t6709 = load i64, ptr %t6708, align 8
%t6710 = call ptr @zk_draw_unit(ptr %p2, i64 %t6709, ptr %t6688)
%t6711 = getelementptr {i32, i32, ptr}, ptr %t6710, i32 0, i32 0
%t6712w = load i32, ptr %t6711
%t6712 = sext i32 %t6712w to i64
%t6713 = icmp eq i64 %t6712, 1
br i1 %t6713, label %L818, label %L817
L817:
br label %L819
L818:
%t6715 = getelementptr {i32, i32, ptr}, ptr %t6710, i32 1
%t6716 = getelementptr i8, ptr %t6715, i64 0
%t6717 = getelementptr ptr, ptr %t6716, i32 0
%t6718 = load ptr, ptr %t6717
%t6719 = getelementptr i8, ptr %t6707, i64 0
%t6720 = load ptr, ptr %t6719, align 8
%t6721 = getelementptr i8, ptr %t6718, i64 0
%t6722 = load ptr, ptr %t6721, align 8
%t6723 = call ptr @__m_________lib_cggmp_zk_resid__pedersen_from(ptr %t6688, ptr %t6698, ptr %t6720, ptr %t6722)
call void @"resid.rec.freeze.PedersenKey"(ptr %t6723)
%t6726 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty6724)
%t6725 = getelementptr {i32, i32, ptr}, ptr %t6726, i32 1
store ptr %t6723, ptr %t6725
br label %L819
L819:
%t6727 = phi ptr [ @.nbox6714, %L817 ], [ %t6726, %L818 ]
br label %L816
L816:
%t6728 = phi ptr [ @.nbox6703, %L814 ], [ %t6727, %L819 ]
ret ptr %t6728
}
define ptr @__m_________lib_cggmp_zk_resid__pedersen_from(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6729 = call ptr @bn_modmul(ptr %p3, ptr %p3, ptr %p0)
%t6730 = call ptr @resid_gmalloc(i64 24)
%t6731 = call ptr @resid_gmalloc(i64 24)
%t6731.f0 = getelementptr i8, ptr %t6731, i64 0
store ptr %p0, ptr %t6731.f0, align 8
%t6732 = call ptr @bn_modexp(ptr %t6729, ptr %p2, ptr %p0)
%t6731.f1 = getelementptr i8, ptr %t6731, i64 8
store ptr %t6732, ptr %t6731.f1, align 8
%t6731.f2 = getelementptr i8, ptr %t6731, i64 16
store ptr %t6729, ptr %t6731.f2, align 8
%t6730.f0 = getelementptr i8, ptr %t6730, i64 0
store ptr %t6731, ptr %t6730.f0, align 8
%t6730.f1 = getelementptr i8, ptr %t6730, i64 8
store ptr %p2, ptr %t6730.f1, align 8
%t6730.f2 = getelementptr i8, ptr %t6730, i64 16
store ptr %p1, ptr %t6730.f2, align 8
ret ptr %t6730
}
define ptr @__m_________lib_sha512g_resid__sha512g_k() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t6733 = add i64 4794697086780616226, 0
%t6734 = add i64 %t6733, 0
%t6735 = add i64 %t6734, 0
%t6736 = icmp ne i64 %t6735, %t6733
%t6737 = icmp slt i64 4794697086780616226, 0
%t6738 = or i1 %t6736, %t6737
%t6739 = zext i1 %t6738 to i8
call void @resid_conv_check(i8 %t6739)
%t6740 = add i64 8158064640168781261, 0
%t6741 = add i64 %t6740, 0
%t6742 = add i64 %t6741, 0
%t6743 = icmp ne i64 %t6742, %t6740
%t6744 = icmp slt i64 8158064640168781261, 0
%t6745 = or i1 %t6743, %t6744
%t6746 = zext i1 %t6745 to i8
call void @resid_conv_check(i8 %t6746)
%t6747 = add i128 13096744586834688815, 0
%t6748 = trunc i128 %t6747 to i64
%t6749 = zext i64 %t6748 to i128
%t6750 = icmp ne i128 %t6749, %t6747
%t6751 = icmp slt i128 13096744586834688815, 0
%t6752 = or i1 %t6750, %t6751
%t6753 = zext i1 %t6752 to i8
call void @resid_conv_check(i8 %t6753)
%t6754 = add i128 16840607885511220156, 0
%t6755 = trunc i128 %t6754 to i64
%t6756 = zext i64 %t6755 to i128
%t6757 = icmp ne i128 %t6756, %t6754
%t6758 = icmp slt i128 16840607885511220156, 0
%t6759 = or i1 %t6757, %t6758
%t6760 = zext i1 %t6759 to i8
call void @resid_conv_check(i8 %t6760)
%t6761 = add i64 4131703408338449720, 0
%t6762 = add i64 %t6761, 0
%t6763 = add i64 %t6762, 0
%t6764 = icmp ne i64 %t6763, %t6761
%t6765 = icmp slt i64 4131703408338449720, 0
%t6766 = or i1 %t6764, %t6765
%t6767 = zext i1 %t6766 to i8
call void @resid_conv_check(i8 %t6767)
%t6768 = add i64 6480981068601479193, 0
%t6769 = add i64 %t6768, 0
%t6770 = add i64 %t6769, 0
%t6771 = icmp ne i64 %t6770, %t6768
%t6772 = icmp slt i64 6480981068601479193, 0
%t6773 = or i1 %t6771, %t6772
%t6774 = zext i1 %t6773 to i8
call void @resid_conv_check(i8 %t6774)
%t6775 = add i128 10538285296894168987, 0
%t6776 = trunc i128 %t6775 to i64
%t6777 = zext i64 %t6776 to i128
%t6778 = icmp ne i128 %t6777, %t6775
%t6779 = icmp slt i128 10538285296894168987, 0
%t6780 = or i1 %t6778, %t6779
%t6781 = zext i1 %t6780 to i8
call void @resid_conv_check(i8 %t6781)
%t6782 = add i128 12329834152419229976, 0
%t6783 = trunc i128 %t6782 to i64
%t6784 = zext i64 %t6783 to i128
%t6785 = icmp ne i128 %t6784, %t6782
%t6786 = icmp slt i128 12329834152419229976, 0
%t6787 = or i1 %t6785, %t6786
%t6788 = zext i1 %t6787 to i8
call void @resid_conv_check(i8 %t6788)
%t6789 = add i128 15566598209576043074, 0
%t6790 = trunc i128 %t6789 to i64
%t6791 = zext i64 %t6790 to i128
%t6792 = icmp ne i128 %t6791, %t6789
%t6793 = icmp slt i128 15566598209576043074, 0
%t6794 = or i1 %t6792, %t6793
%t6795 = zext i1 %t6794 to i8
call void @resid_conv_check(i8 %t6795)
%t6796 = add i64 1334009975649890238, 0
%t6797 = add i64 %t6796, 0
%t6798 = add i64 %t6797, 0
%t6799 = icmp ne i64 %t6798, %t6796
%t6800 = icmp slt i64 1334009975649890238, 0
%t6801 = or i1 %t6799, %t6800
%t6802 = zext i1 %t6801 to i8
call void @resid_conv_check(i8 %t6802)
%t6803 = add i64 2608012711638119052, 0
%t6804 = add i64 %t6803, 0
%t6805 = add i64 %t6804, 0
%t6806 = icmp ne i64 %t6805, %t6803
%t6807 = icmp slt i64 2608012711638119052, 0
%t6808 = or i1 %t6806, %t6807
%t6809 = zext i1 %t6808 to i8
call void @resid_conv_check(i8 %t6809)
%t6810 = add i64 6128411473006802146, 0
%t6811 = add i64 %t6810, 0
%t6812 = add i64 %t6811, 0
%t6813 = icmp ne i64 %t6812, %t6810
%t6814 = icmp slt i64 6128411473006802146, 0
%t6815 = or i1 %t6813, %t6814
%t6816 = zext i1 %t6815 to i8
call void @resid_conv_check(i8 %t6816)
%t6817 = add i64 8268148722764581231, 0
%t6818 = add i64 %t6817, 0
%t6819 = add i64 %t6818, 0
%t6820 = icmp ne i64 %t6819, %t6817
%t6821 = icmp slt i64 8268148722764581231, 0
%t6822 = or i1 %t6820, %t6821
%t6823 = zext i1 %t6822 to i8
call void @resid_conv_check(i8 %t6823)
%t6824 = add i128 9286055187155687089, 0
%t6825 = trunc i128 %t6824 to i64
%t6826 = zext i64 %t6825 to i128
%t6827 = icmp ne i128 %t6826, %t6824
%t6828 = icmp slt i128 9286055187155687089, 0
%t6829 = or i1 %t6827, %t6828
%t6830 = zext i1 %t6829 to i8
call void @resid_conv_check(i8 %t6830)
%t6831 = add i128 11230858885718282805, 0
%t6832 = trunc i128 %t6831 to i64
%t6833 = zext i64 %t6832 to i128
%t6834 = icmp ne i128 %t6833, %t6831
%t6835 = icmp slt i128 11230858885718282805, 0
%t6836 = or i1 %t6834, %t6835
%t6837 = zext i1 %t6836 to i8
call void @resid_conv_check(i8 %t6837)
%t6838 = add i128 13951009754708518548, 0
%t6839 = trunc i128 %t6838 to i64
%t6840 = zext i64 %t6839 to i128
%t6841 = icmp ne i128 %t6840, %t6838
%t6842 = icmp slt i128 13951009754708518548, 0
%t6843 = or i1 %t6841, %t6842
%t6844 = zext i1 %t6843 to i8
call void @resid_conv_check(i8 %t6844)
%t6845 = add i128 16472876342353939154, 0
%t6846 = trunc i128 %t6845 to i64
%t6847 = zext i64 %t6846 to i128
%t6848 = icmp ne i128 %t6847, %t6845
%t6849 = icmp slt i128 16472876342353939154, 0
%t6850 = or i1 %t6848, %t6849
%t6851 = zext i1 %t6850 to i8
call void @resid_conv_check(i8 %t6851)
%t6852 = add i128 17275323862435702243, 0
%t6853 = trunc i128 %t6852 to i64
%t6854 = zext i64 %t6853 to i128
%t6855 = icmp ne i128 %t6854, %t6852
%t6856 = icmp slt i128 17275323862435702243, 0
%t6857 = or i1 %t6855, %t6856
%t6858 = zext i1 %t6857 to i8
call void @resid_conv_check(i8 %t6858)
%t6859 = add i64 1135362057144423861, 0
%t6860 = add i64 %t6859, 0
%t6861 = add i64 %t6860, 0
%t6862 = icmp ne i64 %t6861, %t6859
%t6863 = icmp slt i64 1135362057144423861, 0
%t6864 = or i1 %t6862, %t6863
%t6865 = zext i1 %t6864 to i8
call void @resid_conv_check(i8 %t6865)
%t6866 = add i64 2597628984639134821, 0
%t6867 = add i64 %t6866, 0
%t6868 = add i64 %t6867, 0
%t6869 = icmp ne i64 %t6868, %t6866
%t6870 = icmp slt i64 2597628984639134821, 0
%t6871 = or i1 %t6869, %t6870
%t6872 = zext i1 %t6871 to i8
call void @resid_conv_check(i8 %t6872)
%t6873 = add i64 3308224258029322869, 0
%t6874 = add i64 %t6873, 0
%t6875 = add i64 %t6874, 0
%t6876 = icmp ne i64 %t6875, %t6873
%t6877 = icmp slt i64 3308224258029322869, 0
%t6878 = or i1 %t6876, %t6877
%t6879 = zext i1 %t6878 to i8
call void @resid_conv_check(i8 %t6879)
%t6880 = add i64 5365058923640841347, 0
%t6881 = add i64 %t6880, 0
%t6882 = add i64 %t6881, 0
%t6883 = icmp ne i64 %t6882, %t6880
%t6884 = icmp slt i64 5365058923640841347, 0
%t6885 = or i1 %t6883, %t6884
%t6886 = zext i1 %t6885 to i8
call void @resid_conv_check(i8 %t6886)
%t6887 = add i64 6679025012923562964, 0
%t6888 = add i64 %t6887, 0
%t6889 = add i64 %t6888, 0
%t6890 = icmp ne i64 %t6889, %t6887
%t6891 = icmp slt i64 6679025012923562964, 0
%t6892 = or i1 %t6890, %t6891
%t6893 = zext i1 %t6892 to i8
call void @resid_conv_check(i8 %t6893)
%t6894 = add i64 8573033837759648693, 0
%t6895 = add i64 %t6894, 0
%t6896 = add i64 %t6895, 0
%t6897 = icmp ne i64 %t6896, %t6894
%t6898 = icmp slt i64 8573033837759648693, 0
%t6899 = or i1 %t6897, %t6898
%t6900 = zext i1 %t6899 to i8
call void @resid_conv_check(i8 %t6900)
%t6901 = add i128 10970295158949994411, 0
%t6902 = trunc i128 %t6901 to i64
%t6903 = zext i64 %t6902 to i128
%t6904 = icmp ne i128 %t6903, %t6901
%t6905 = icmp slt i128 10970295158949994411, 0
%t6906 = or i1 %t6904, %t6905
%t6907 = zext i1 %t6906 to i8
call void @resid_conv_check(i8 %t6907)
%t6908 = add i128 12119686244451234320, 0
%t6909 = trunc i128 %t6908 to i64
%t6910 = zext i64 %t6909 to i128
%t6911 = icmp ne i128 %t6910, %t6908
%t6912 = icmp slt i128 12119686244451234320, 0
%t6913 = or i1 %t6911, %t6912
%t6914 = zext i1 %t6913 to i8
call void @resid_conv_check(i8 %t6914)
%t6915 = add i128 12683024718118986047, 0
%t6916 = trunc i128 %t6915 to i64
%t6917 = zext i64 %t6916 to i128
%t6918 = icmp ne i128 %t6917, %t6915
%t6919 = icmp slt i128 12683024718118986047, 0
%t6920 = or i1 %t6918, %t6919
%t6921 = zext i1 %t6920 to i8
call void @resid_conv_check(i8 %t6921)
%t6922 = add i128 13788192230050041572, 0
%t6923 = trunc i128 %t6922 to i64
%t6924 = zext i64 %t6923 to i128
%t6925 = icmp ne i128 %t6924, %t6922
%t6926 = icmp slt i128 13788192230050041572, 0
%t6927 = or i1 %t6925, %t6926
%t6928 = zext i1 %t6927 to i8
call void @resid_conv_check(i8 %t6928)
%t6929 = add i128 14330467153632333762, 0
%t6930 = trunc i128 %t6929 to i64
%t6931 = zext i64 %t6930 to i128
%t6932 = icmp ne i128 %t6931, %t6929
%t6933 = icmp slt i128 14330467153632333762, 0
%t6934 = or i1 %t6932, %t6933
%t6935 = zext i1 %t6934 to i8
call void @resid_conv_check(i8 %t6935)
%t6936 = add i128 15395433587784984357, 0
%t6937 = trunc i128 %t6936 to i64
%t6938 = zext i64 %t6937 to i128
%t6939 = icmp ne i128 %t6938, %t6936
%t6940 = icmp slt i128 15395433587784984357, 0
%t6941 = or i1 %t6939, %t6940
%t6942 = zext i1 %t6941 to i8
call void @resid_conv_check(i8 %t6942)
%t6943 = add i64 1452737877330783856, 0
%t6944 = add i64 %t6943, 0
%t6945 = add i64 %t6944, 0
%t6946 = icmp ne i64 %t6945, %t6943
%t6947 = icmp slt i64 1452737877330783856, 0
%t6948 = or i1 %t6946, %t6947
%t6949 = zext i1 %t6948 to i8
call void @resid_conv_check(i8 %t6949)
%t6950 = add i64 2861767655752347644, 0
%t6951 = add i64 %t6950, 0
%t6952 = add i64 %t6951, 0
%t6953 = icmp ne i64 %t6952, %t6950
%t6954 = icmp slt i64 2861767655752347644, 0
%t6955 = or i1 %t6953, %t6954
%t6956 = zext i1 %t6955 to i8
call void @resid_conv_check(i8 %t6956)
%t6957 = add i64 3322285676063803686, 0
%t6958 = add i64 %t6957, 0
%t6959 = add i64 %t6958, 0
%t6960 = icmp ne i64 %t6959, %t6957
%t6961 = icmp slt i64 3322285676063803686, 0
%t6962 = or i1 %t6960, %t6961
%t6963 = zext i1 %t6962 to i8
call void @resid_conv_check(i8 %t6963)
%t6964 = add i64 5560940570517711597, 0
%t6965 = add i64 %t6964, 0
%t6966 = add i64 %t6965, 0
%t6967 = icmp ne i64 %t6966, %t6964
%t6968 = icmp slt i64 5560940570517711597, 0
%t6969 = or i1 %t6967, %t6968
%t6970 = zext i1 %t6969 to i8
call void @resid_conv_check(i8 %t6970)
%t6971 = add i64 5996557281743188959, 0
%t6972 = add i64 %t6971, 0
%t6973 = add i64 %t6972, 0
%t6974 = icmp ne i64 %t6973, %t6971
%t6975 = icmp slt i64 5996557281743188959, 0
%t6976 = or i1 %t6974, %t6975
%t6977 = zext i1 %t6976 to i8
call void @resid_conv_check(i8 %t6977)
%t6978 = add i64 7280758554555802590, 0
%t6979 = add i64 %t6978, 0
%t6980 = add i64 %t6979, 0
%t6981 = icmp ne i64 %t6980, %t6978
%t6982 = icmp slt i64 7280758554555802590, 0
%t6983 = or i1 %t6981, %t6982
%t6984 = zext i1 %t6983 to i8
call void @resid_conv_check(i8 %t6984)
%t6985 = add i64 8532644243296465576, 0
%t6986 = add i64 %t6985, 0
%t6987 = add i64 %t6986, 0
%t6988 = icmp ne i64 %t6987, %t6985
%t6989 = icmp slt i64 8532644243296465576, 0
%t6990 = or i1 %t6988, %t6989
%t6991 = zext i1 %t6990 to i8
call void @resid_conv_check(i8 %t6991)
%t6992 = add i128 9350256976987008742, 0
%t6993 = trunc i128 %t6992 to i64
%t6994 = zext i64 %t6993 to i128
%t6995 = icmp ne i128 %t6994, %t6992
%t6996 = icmp slt i128 9350256976987008742, 0
%t6997 = or i1 %t6995, %t6996
%t6998 = zext i1 %t6997 to i8
call void @resid_conv_check(i8 %t6998)
%t6999 = add i128 10552545826968843579, 0
%t7000 = trunc i128 %t6999 to i64
%t7001 = zext i64 %t7000 to i128
%t7002 = icmp ne i128 %t7001, %t6999
%t7003 = icmp slt i128 10552545826968843579, 0
%t7004 = or i1 %t7002, %t7003
%t7005 = zext i1 %t7004 to i8
call void @resid_conv_check(i8 %t7005)
%t7006 = add i128 11727347734174303076, 0
%t7007 = trunc i128 %t7006 to i64
%t7008 = zext i64 %t7007 to i128
%t7009 = icmp ne i128 %t7008, %t7006
%t7010 = icmp slt i128 11727347734174303076, 0
%t7011 = or i1 %t7009, %t7010
%t7012 = zext i1 %t7011 to i8
call void @resid_conv_check(i8 %t7012)
%t7013 = add i128 12113106623233404929, 0
%t7014 = trunc i128 %t7013 to i64
%t7015 = zext i64 %t7014 to i128
%t7016 = icmp ne i128 %t7015, %t7013
%t7017 = icmp slt i128 12113106623233404929, 0
%t7018 = or i1 %t7016, %t7017
%t7019 = zext i1 %t7018 to i8
call void @resid_conv_check(i8 %t7019)
%t7020 = add i128 14000437183269869457, 0
%t7021 = trunc i128 %t7020 to i64
%t7022 = zext i64 %t7021 to i128
%t7023 = icmp ne i128 %t7022, %t7020
%t7024 = icmp slt i128 14000437183269869457, 0
%t7025 = or i1 %t7023, %t7024
%t7026 = zext i1 %t7025 to i8
call void @resid_conv_check(i8 %t7026)
%t7027 = add i128 14369950271660146224, 0
%t7028 = trunc i128 %t7027 to i64
%t7029 = zext i64 %t7028 to i128
%t7030 = icmp ne i128 %t7029, %t7027
%t7031 = icmp slt i128 14369950271660146224, 0
%t7032 = or i1 %t7030, %t7031
%t7033 = zext i1 %t7032 to i8
call void @resid_conv_check(i8 %t7033)
%t7034 = add i128 15101387698204529176, 0
%t7035 = trunc i128 %t7034 to i64
%t7036 = zext i64 %t7035 to i128
%t7037 = icmp ne i128 %t7036, %t7034
%t7038 = icmp slt i128 15101387698204529176, 0
%t7039 = or i1 %t7037, %t7038
%t7040 = zext i1 %t7039 to i8
call void @resid_conv_check(i8 %t7040)
%t7041 = add i128 15463397548674623760, 0
%t7042 = trunc i128 %t7041 to i64
%t7043 = zext i64 %t7042 to i128
%t7044 = icmp ne i128 %t7043, %t7041
%t7045 = icmp slt i128 15463397548674623760, 0
%t7046 = or i1 %t7044, %t7045
%t7047 = zext i1 %t7046 to i8
call void @resid_conv_check(i8 %t7047)
%t7048 = add i128 17586052441742319658, 0
%t7049 = trunc i128 %t7048 to i64
%t7050 = zext i64 %t7049 to i128
%t7051 = icmp ne i128 %t7050, %t7048
%t7052 = icmp slt i128 17586052441742319658, 0
%t7053 = or i1 %t7051, %t7052
%t7054 = zext i1 %t7053 to i8
call void @resid_conv_check(i8 %t7054)
%t7055 = add i64 1182934255886127544, 0
%t7056 = add i64 %t7055, 0
%t7057 = add i64 %t7056, 0
%t7058 = icmp ne i64 %t7057, %t7055
%t7059 = icmp slt i64 1182934255886127544, 0
%t7060 = or i1 %t7058, %t7059
%t7061 = zext i1 %t7060 to i8
call void @resid_conv_check(i8 %t7061)
%t7062 = add i64 1847814050463011016, 0
%t7063 = add i64 %t7062, 0
%t7064 = add i64 %t7063, 0
%t7065 = icmp ne i64 %t7064, %t7062
%t7066 = icmp slt i64 1847814050463011016, 0
%t7067 = or i1 %t7065, %t7066
%t7068 = zext i1 %t7067 to i8
call void @resid_conv_check(i8 %t7068)
%t7069 = add i64 2177327727835720531, 0
%t7070 = add i64 %t7069, 0
%t7071 = add i64 %t7070, 0
%t7072 = icmp ne i64 %t7071, %t7069
%t7073 = icmp slt i64 2177327727835720531, 0
%t7074 = or i1 %t7072, %t7073
%t7075 = zext i1 %t7074 to i8
call void @resid_conv_check(i8 %t7075)
%t7076 = add i64 2830643537854262169, 0
%t7077 = add i64 %t7076, 0
%t7078 = add i64 %t7077, 0
%t7079 = icmp ne i64 %t7078, %t7076
%t7080 = icmp slt i64 2830643537854262169, 0
%t7081 = or i1 %t7079, %t7080
%t7082 = zext i1 %t7081 to i8
call void @resid_conv_check(i8 %t7082)
%t7083 = add i64 3796741975233480872, 0
%t7084 = add i64 %t7083, 0
%t7085 = add i64 %t7084, 0
%t7086 = icmp ne i64 %t7085, %t7083
%t7087 = icmp slt i64 3796741975233480872, 0
%t7088 = or i1 %t7086, %t7087
%t7089 = zext i1 %t7088 to i8
call void @resid_conv_check(i8 %t7089)
%t7090 = add i64 4115178125766777443, 0
%t7091 = add i64 %t7090, 0
%t7092 = add i64 %t7091, 0
%t7093 = icmp ne i64 %t7092, %t7090
%t7094 = icmp slt i64 4115178125766777443, 0
%t7095 = or i1 %t7093, %t7094
%t7096 = zext i1 %t7095 to i8
call void @resid_conv_check(i8 %t7096)
%t7097 = add i64 5681478168544905931, 0
%t7098 = add i64 %t7097, 0
%t7099 = add i64 %t7098, 0
%t7100 = icmp ne i64 %t7099, %t7097
%t7101 = icmp slt i64 5681478168544905931, 0
%t7102 = or i1 %t7100, %t7101
%t7103 = zext i1 %t7102 to i8
call void @resid_conv_check(i8 %t7103)
%t7104 = add i64 6601373596472566643, 0
%t7105 = add i64 %t7104, 0
%t7106 = add i64 %t7105, 0
%t7107 = icmp ne i64 %t7106, %t7104
%t7108 = icmp slt i64 6601373596472566643, 0
%t7109 = or i1 %t7107, %t7108
%t7110 = zext i1 %t7109 to i8
call void @resid_conv_check(i8 %t7110)
%t7111 = add i64 7507060721942968483, 0
%t7112 = add i64 %t7111, 0
%t7113 = add i64 %t7112, 0
%t7114 = icmp ne i64 %t7113, %t7111
%t7115 = icmp slt i64 7507060721942968483, 0
%t7116 = or i1 %t7114, %t7115
%t7117 = zext i1 %t7116 to i8
call void @resid_conv_check(i8 %t7117)
%t7118 = add i64 8399075790359081724, 0
%t7119 = add i64 %t7118, 0
%t7120 = add i64 %t7119, 0
%t7121 = icmp ne i64 %t7120, %t7118
%t7122 = icmp slt i64 8399075790359081724, 0
%t7123 = or i1 %t7121, %t7122
%t7124 = zext i1 %t7123 to i8
call void @resid_conv_check(i8 %t7124)
%t7125 = add i64 8693463985226723168, 0
%t7126 = add i64 %t7125, 0
%t7127 = add i64 %t7126, 0
%t7128 = icmp ne i64 %t7127, %t7125
%t7129 = icmp slt i64 8693463985226723168, 0
%t7130 = or i1 %t7128, %t7129
%t7131 = zext i1 %t7130 to i8
call void @resid_conv_check(i8 %t7131)
%t7132 = add i128 9568029438360202098, 0
%t7133 = trunc i128 %t7132 to i64
%t7134 = zext i64 %t7133 to i128
%t7135 = icmp ne i128 %t7134, %t7132
%t7136 = icmp slt i128 9568029438360202098, 0
%t7137 = or i1 %t7135, %t7136
%t7138 = zext i1 %t7137 to i8
call void @resid_conv_check(i8 %t7138)
%t7139 = add i128 10144078919501101548, 0
%t7140 = trunc i128 %t7139 to i64
%t7141 = zext i64 %t7140 to i128
%t7142 = icmp ne i128 %t7141, %t7139
%t7143 = icmp slt i128 10144078919501101548, 0
%t7144 = or i1 %t7142, %t7143
%t7145 = zext i1 %t7144 to i8
call void @resid_conv_check(i8 %t7145)
%t7146 = add i128 10430055236837252648, 0
%t7147 = trunc i128 %t7146 to i64
%t7148 = zext i64 %t7147 to i128
%t7149 = icmp ne i128 %t7148, %t7146
%t7150 = icmp slt i128 10430055236837252648, 0
%t7151 = or i1 %t7149, %t7150
%t7152 = zext i1 %t7151 to i8
call void @resid_conv_check(i8 %t7152)
%t7153 = add i128 11840083180663258601, 0
%t7154 = trunc i128 %t7153 to i64
%t7155 = zext i64 %t7154 to i128
%t7156 = icmp ne i128 %t7155, %t7153
%t7157 = icmp slt i128 11840083180663258601, 0
%t7158 = or i1 %t7156, %t7157
%t7159 = zext i1 %t7158 to i8
call void @resid_conv_check(i8 %t7159)
%t7160 = add i128 13761210420658862357, 0
%t7161 = trunc i128 %t7160 to i64
%t7162 = zext i64 %t7161 to i128
%t7163 = icmp ne i128 %t7162, %t7160
%t7164 = icmp slt i128 13761210420658862357, 0
%t7165 = or i1 %t7163, %t7164
%t7166 = zext i1 %t7165 to i8
call void @resid_conv_check(i8 %t7166)
%t7167 = add i128 14299343276471374635, 0
%t7168 = trunc i128 %t7167 to i64
%t7169 = zext i64 %t7168 to i128
%t7170 = icmp ne i128 %t7169, %t7167
%t7171 = icmp slt i128 14299343276471374635, 0
%t7172 = or i1 %t7170, %t7171
%t7173 = zext i1 %t7172 to i8
call void @resid_conv_check(i8 %t7173)
%t7174 = add i128 14566680578165727644, 0
%t7175 = trunc i128 %t7174 to i64
%t7176 = zext i64 %t7175 to i128
%t7177 = icmp ne i128 %t7176, %t7174
%t7178 = icmp slt i128 14566680578165727644, 0
%t7179 = or i1 %t7177, %t7178
%t7180 = zext i1 %t7179 to i8
call void @resid_conv_check(i8 %t7180)
%t7181 = add i128 15097957966210449927, 0
%t7182 = trunc i128 %t7181 to i64
%t7183 = zext i64 %t7182 to i128
%t7184 = icmp ne i128 %t7183, %t7181
%t7185 = icmp slt i128 15097957966210449927, 0
%t7186 = or i1 %t7184, %t7185
%t7187 = zext i1 %t7186 to i8
call void @resid_conv_check(i8 %t7187)
%t7188 = add i128 16922976911328602910, 0
%t7189 = trunc i128 %t7188 to i64
%t7190 = zext i64 %t7189 to i128
%t7191 = icmp ne i128 %t7190, %t7188
%t7192 = icmp slt i128 16922976911328602910, 0
%t7193 = or i1 %t7191, %t7192
%t7194 = zext i1 %t7193 to i8
call void @resid_conv_check(i8 %t7194)
%t7195 = add i128 17689382322260857208, 0
%t7196 = trunc i128 %t7195 to i64
%t7197 = zext i64 %t7196 to i128
%t7198 = icmp ne i128 %t7197, %t7195
%t7199 = icmp slt i128 17689382322260857208, 0
%t7200 = or i1 %t7198, %t7199
%t7201 = zext i1 %t7200 to i8
call void @resid_conv_check(i8 %t7201)
%t7202 = add i64 1242879168328830382, 0
%t7203 = add i64 %t7202, 0
%t7204 = add i64 %t7203, 0
%t7205 = icmp ne i64 %t7204, %t7202
%t7206 = icmp slt i64 1242879168328830382, 0
%t7207 = or i1 %t7205, %t7206
%t7208 = zext i1 %t7207 to i8
call void @resid_conv_check(i8 %t7208)
%t7209 = add i64 1977374033974150939, 0
%t7210 = add i64 %t7209, 0
%t7211 = add i64 %t7210, 0
%t7212 = icmp ne i64 %t7211, %t7209
%t7213 = icmp slt i64 1977374033974150939, 0
%t7214 = or i1 %t7212, %t7213
%t7215 = zext i1 %t7214 to i8
call void @resid_conv_check(i8 %t7215)
%t7216 = add i64 2944078676154940804, 0
%t7217 = add i64 %t7216, 0
%t7218 = add i64 %t7217, 0
%t7219 = icmp ne i64 %t7218, %t7216
%t7220 = icmp slt i64 2944078676154940804, 0
%t7221 = or i1 %t7219, %t7220
%t7222 = zext i1 %t7221 to i8
call void @resid_conv_check(i8 %t7222)
%t7223 = add i64 3659926193048069267, 0
%t7224 = add i64 %t7223, 0
%t7225 = add i64 %t7224, 0
%t7226 = icmp ne i64 %t7225, %t7223
%t7227 = icmp slt i64 3659926193048069267, 0
%t7228 = or i1 %t7226, %t7227
%t7229 = zext i1 %t7228 to i8
call void @resid_conv_check(i8 %t7229)
%t7230 = add i64 4368137639120453308, 0
%t7231 = add i64 %t7230, 0
%t7232 = add i64 %t7231, 0
%t7233 = icmp ne i64 %t7232, %t7230
%t7234 = icmp slt i64 4368137639120453308, 0
%t7235 = or i1 %t7233, %t7234
%t7236 = zext i1 %t7235 to i8
call void @resid_conv_check(i8 %t7236)
%t7237 = add i64 4836135668995329356, 0
%t7238 = add i64 %t7237, 0
%t7239 = add i64 %t7238, 0
%t7240 = icmp ne i64 %t7239, %t7237
%t7241 = icmp slt i64 4836135668995329356, 0
%t7242 = or i1 %t7240, %t7241
%t7243 = zext i1 %t7242 to i8
call void @resid_conv_check(i8 %t7243)
%t7244 = add i64 5532061633213252278, 0
%t7245 = add i64 %t7244, 0
%t7246 = add i64 %t7245, 0
%t7247 = icmp ne i64 %t7246, %t7244
%t7248 = icmp slt i64 5532061633213252278, 0
%t7249 = or i1 %t7247, %t7248
%t7250 = zext i1 %t7249 to i8
call void @resid_conv_check(i8 %t7250)
%t7251 = add i64 6448918945643986474, 0
%t7252 = add i64 %t7251, 0
%t7253 = add i64 %t7252, 0
%t7254 = icmp ne i64 %t7253, %t7251
%t7255 = icmp slt i64 6448918945643986474, 0
%t7256 = or i1 %t7254, %t7255
%t7257 = zext i1 %t7256 to i8
call void @resid_conv_check(i8 %t7257)
%t7258 = add i64 6902733635092675308, 0
%t7259 = add i64 %t7258, 0
%t7260 = add i64 %t7259, 0
%t7261 = icmp ne i64 %t7260, %t7258
%t7262 = icmp slt i64 6902733635092675308, 0
%t7263 = or i1 %t7261, %t7262
%t7264 = zext i1 %t7263 to i8
call void @resid_conv_check(i8 %t7264)
%t7265 = add i64 7801388544844847127, 0
%t7266 = add i64 %t7265, 0
%t7267 = add i64 %t7266, 0
%t7268 = icmp ne i64 %t7267, %t7265
%t7269 = icmp slt i64 7801388544844847127, 0
%t7270 = or i1 %t7268, %t7269
%t7271 = zext i1 %t7270 to i8
call void @resid_conv_check(i8 %t7271)
%t7272 = alloca [80 x ptr]
%t7274 = call ptr @resid_box_i64(i64 %t6734)
%t7276 = getelementptr i8, ptr %t7272, i64 0
store ptr %t7274, ptr %t7276
%t7277 = call ptr @resid_box_i64(i64 %t6741)
%t7279 = getelementptr i8, ptr %t7272, i64 8
store ptr %t7277, ptr %t7279
%t7280 = call ptr @resid_box_i64(i64 %t6748)
%t7282 = getelementptr i8, ptr %t7272, i64 16
store ptr %t7280, ptr %t7282
%t7283 = call ptr @resid_box_i64(i64 %t6755)
%t7285 = getelementptr i8, ptr %t7272, i64 24
store ptr %t7283, ptr %t7285
%t7286 = call ptr @resid_box_i64(i64 %t6762)
%t7288 = getelementptr i8, ptr %t7272, i64 32
store ptr %t7286, ptr %t7288
%t7289 = call ptr @resid_box_i64(i64 %t6769)
%t7291 = getelementptr i8, ptr %t7272, i64 40
store ptr %t7289, ptr %t7291
%t7292 = call ptr @resid_box_i64(i64 %t6776)
%t7294 = getelementptr i8, ptr %t7272, i64 48
store ptr %t7292, ptr %t7294
%t7295 = call ptr @resid_box_i64(i64 %t6783)
%t7297 = getelementptr i8, ptr %t7272, i64 56
store ptr %t7295, ptr %t7297
%t7298 = call ptr @resid_box_i64(i64 %t6790)
%t7300 = getelementptr i8, ptr %t7272, i64 64
store ptr %t7298, ptr %t7300
%t7301 = call ptr @resid_box_i64(i64 %t6797)
%t7303 = getelementptr i8, ptr %t7272, i64 72
store ptr %t7301, ptr %t7303
%t7304 = call ptr @resid_box_i64(i64 %t6804)
%t7306 = getelementptr i8, ptr %t7272, i64 80
store ptr %t7304, ptr %t7306
%t7307 = call ptr @resid_box_i64(i64 %t6811)
%t7309 = getelementptr i8, ptr %t7272, i64 88
store ptr %t7307, ptr %t7309
%t7310 = call ptr @resid_box_i64(i64 %t6818)
%t7312 = getelementptr i8, ptr %t7272, i64 96
store ptr %t7310, ptr %t7312
%t7313 = call ptr @resid_box_i64(i64 %t6825)
%t7315 = getelementptr i8, ptr %t7272, i64 104
store ptr %t7313, ptr %t7315
%t7316 = call ptr @resid_box_i64(i64 %t6832)
%t7318 = getelementptr i8, ptr %t7272, i64 112
store ptr %t7316, ptr %t7318
%t7319 = call ptr @resid_box_i64(i64 %t6839)
%t7321 = getelementptr i8, ptr %t7272, i64 120
store ptr %t7319, ptr %t7321
%t7322 = call ptr @resid_box_i64(i64 %t6846)
%t7324 = getelementptr i8, ptr %t7272, i64 128
store ptr %t7322, ptr %t7324
%t7325 = call ptr @resid_box_i64(i64 %t6853)
%t7327 = getelementptr i8, ptr %t7272, i64 136
store ptr %t7325, ptr %t7327
%t7328 = call ptr @resid_box_i64(i64 %t6860)
%t7330 = getelementptr i8, ptr %t7272, i64 144
store ptr %t7328, ptr %t7330
%t7331 = call ptr @resid_box_i64(i64 %t6867)
%t7333 = getelementptr i8, ptr %t7272, i64 152
store ptr %t7331, ptr %t7333
%t7334 = call ptr @resid_box_i64(i64 %t6874)
%t7336 = getelementptr i8, ptr %t7272, i64 160
store ptr %t7334, ptr %t7336
%t7337 = call ptr @resid_box_i64(i64 %t6881)
%t7339 = getelementptr i8, ptr %t7272, i64 168
store ptr %t7337, ptr %t7339
%t7340 = call ptr @resid_box_i64(i64 %t6888)
%t7342 = getelementptr i8, ptr %t7272, i64 176
store ptr %t7340, ptr %t7342
%t7343 = call ptr @resid_box_i64(i64 %t6895)
%t7345 = getelementptr i8, ptr %t7272, i64 184
store ptr %t7343, ptr %t7345
%t7346 = call ptr @resid_box_i64(i64 %t6902)
%t7348 = getelementptr i8, ptr %t7272, i64 192
store ptr %t7346, ptr %t7348
%t7349 = call ptr @resid_box_i64(i64 %t6909)
%t7351 = getelementptr i8, ptr %t7272, i64 200
store ptr %t7349, ptr %t7351
%t7352 = call ptr @resid_box_i64(i64 %t6916)
%t7354 = getelementptr i8, ptr %t7272, i64 208
store ptr %t7352, ptr %t7354
%t7355 = call ptr @resid_box_i64(i64 %t6923)
%t7357 = getelementptr i8, ptr %t7272, i64 216
store ptr %t7355, ptr %t7357
%t7358 = call ptr @resid_box_i64(i64 %t6930)
%t7360 = getelementptr i8, ptr %t7272, i64 224
store ptr %t7358, ptr %t7360
%t7361 = call ptr @resid_box_i64(i64 %t6937)
%t7363 = getelementptr i8, ptr %t7272, i64 232
store ptr %t7361, ptr %t7363
%t7364 = call ptr @resid_box_i64(i64 489312712824947311)
%t7366 = getelementptr i8, ptr %t7272, i64 240
store ptr %t7364, ptr %t7366
%t7367 = call ptr @resid_box_i64(i64 %t6944)
%t7369 = getelementptr i8, ptr %t7272, i64 248
store ptr %t7367, ptr %t7369
%t7370 = call ptr @resid_box_i64(i64 %t6951)
%t7372 = getelementptr i8, ptr %t7272, i64 256
store ptr %t7370, ptr %t7372
%t7373 = call ptr @resid_box_i64(i64 %t6958)
%t7375 = getelementptr i8, ptr %t7272, i64 264
store ptr %t7373, ptr %t7375
%t7376 = call ptr @resid_box_i64(i64 %t6965)
%t7378 = getelementptr i8, ptr %t7272, i64 272
store ptr %t7376, ptr %t7378
%t7379 = call ptr @resid_box_i64(i64 %t6972)
%t7381 = getelementptr i8, ptr %t7272, i64 280
store ptr %t7379, ptr %t7381
%t7382 = call ptr @resid_box_i64(i64 %t6979)
%t7384 = getelementptr i8, ptr %t7272, i64 288
store ptr %t7382, ptr %t7384
%t7385 = call ptr @resid_box_i64(i64 %t6986)
%t7387 = getelementptr i8, ptr %t7272, i64 296
store ptr %t7385, ptr %t7387
%t7388 = call ptr @resid_box_i64(i64 %t6993)
%t7390 = getelementptr i8, ptr %t7272, i64 304
store ptr %t7388, ptr %t7390
%t7391 = call ptr @resid_box_i64(i64 %t7000)
%t7393 = getelementptr i8, ptr %t7272, i64 312
store ptr %t7391, ptr %t7393
%t7394 = call ptr @resid_box_i64(i64 %t7007)
%t7396 = getelementptr i8, ptr %t7272, i64 320
store ptr %t7394, ptr %t7396
%t7397 = call ptr @resid_box_i64(i64 %t7014)
%t7399 = getelementptr i8, ptr %t7272, i64 328
store ptr %t7397, ptr %t7399
%t7400 = call ptr @resid_box_i64(i64 %t7021)
%t7402 = getelementptr i8, ptr %t7272, i64 336
store ptr %t7400, ptr %t7402
%t7403 = call ptr @resid_box_i64(i64 %t7028)
%t7405 = getelementptr i8, ptr %t7272, i64 344
store ptr %t7403, ptr %t7405
%t7406 = call ptr @resid_box_i64(i64 %t7035)
%t7408 = getelementptr i8, ptr %t7272, i64 352
store ptr %t7406, ptr %t7408
%t7409 = call ptr @resid_box_i64(i64 %t7042)
%t7411 = getelementptr i8, ptr %t7272, i64 360
store ptr %t7409, ptr %t7411
%t7412 = call ptr @resid_box_i64(i64 %t7049)
%t7414 = getelementptr i8, ptr %t7272, i64 368
store ptr %t7412, ptr %t7414
%t7415 = call ptr @resid_box_i64(i64 %t7056)
%t7417 = getelementptr i8, ptr %t7272, i64 376
store ptr %t7415, ptr %t7417
%t7418 = call ptr @resid_box_i64(i64 %t7063)
%t7420 = getelementptr i8, ptr %t7272, i64 384
store ptr %t7418, ptr %t7420
%t7421 = call ptr @resid_box_i64(i64 %t7070)
%t7423 = getelementptr i8, ptr %t7272, i64 392
store ptr %t7421, ptr %t7423
%t7424 = call ptr @resid_box_i64(i64 %t7077)
%t7426 = getelementptr i8, ptr %t7272, i64 400
store ptr %t7424, ptr %t7426
%t7427 = call ptr @resid_box_i64(i64 %t7084)
%t7429 = getelementptr i8, ptr %t7272, i64 408
store ptr %t7427, ptr %t7429
%t7430 = call ptr @resid_box_i64(i64 %t7091)
%t7432 = getelementptr i8, ptr %t7272, i64 416
store ptr %t7430, ptr %t7432
%t7433 = call ptr @resid_box_i64(i64 %t7098)
%t7435 = getelementptr i8, ptr %t7272, i64 424
store ptr %t7433, ptr %t7435
%t7436 = call ptr @resid_box_i64(i64 %t7105)
%t7438 = getelementptr i8, ptr %t7272, i64 432
store ptr %t7436, ptr %t7438
%t7439 = call ptr @resid_box_i64(i64 %t7112)
%t7441 = getelementptr i8, ptr %t7272, i64 440
store ptr %t7439, ptr %t7441
%t7442 = call ptr @resid_box_i64(i64 %t7119)
%t7444 = getelementptr i8, ptr %t7272, i64 448
store ptr %t7442, ptr %t7444
%t7445 = call ptr @resid_box_i64(i64 %t7126)
%t7447 = getelementptr i8, ptr %t7272, i64 456
store ptr %t7445, ptr %t7447
%t7448 = call ptr @resid_box_i64(i64 %t7133)
%t7450 = getelementptr i8, ptr %t7272, i64 464
store ptr %t7448, ptr %t7450
%t7451 = call ptr @resid_box_i64(i64 %t7140)
%t7453 = getelementptr i8, ptr %t7272, i64 472
store ptr %t7451, ptr %t7453
%t7454 = call ptr @resid_box_i64(i64 %t7147)
%t7456 = getelementptr i8, ptr %t7272, i64 480
store ptr %t7454, ptr %t7456
%t7457 = call ptr @resid_box_i64(i64 %t7154)
%t7459 = getelementptr i8, ptr %t7272, i64 488
store ptr %t7457, ptr %t7459
%t7460 = call ptr @resid_box_i64(i64 %t7161)
%t7462 = getelementptr i8, ptr %t7272, i64 496
store ptr %t7460, ptr %t7462
%t7463 = call ptr @resid_box_i64(i64 %t7168)
%t7465 = getelementptr i8, ptr %t7272, i64 504
store ptr %t7463, ptr %t7465
%t7466 = call ptr @resid_box_i64(i64 %t7175)
%t7468 = getelementptr i8, ptr %t7272, i64 512
store ptr %t7466, ptr %t7468
%t7469 = call ptr @resid_box_i64(i64 %t7182)
%t7471 = getelementptr i8, ptr %t7272, i64 520
store ptr %t7469, ptr %t7471
%t7472 = call ptr @resid_box_i64(i64 %t7189)
%t7474 = getelementptr i8, ptr %t7272, i64 528
store ptr %t7472, ptr %t7474
%t7475 = call ptr @resid_box_i64(i64 %t7196)
%t7477 = getelementptr i8, ptr %t7272, i64 536
store ptr %t7475, ptr %t7477
%t7478 = call ptr @resid_box_i64(i64 500013540394364858)
%t7480 = getelementptr i8, ptr %t7272, i64 544
store ptr %t7478, ptr %t7480
%t7481 = call ptr @resid_box_i64(i64 748580250866718886)
%t7483 = getelementptr i8, ptr %t7272, i64 552
store ptr %t7481, ptr %t7483
%t7484 = call ptr @resid_box_i64(i64 %t7203)
%t7486 = getelementptr i8, ptr %t7272, i64 560
store ptr %t7484, ptr %t7486
%t7487 = call ptr @resid_box_i64(i64 %t7210)
%t7489 = getelementptr i8, ptr %t7272, i64 568
store ptr %t7487, ptr %t7489
%t7490 = call ptr @resid_box_i64(i64 %t7217)
%t7492 = getelementptr i8, ptr %t7272, i64 576
store ptr %t7490, ptr %t7492
%t7493 = call ptr @resid_box_i64(i64 %t7224)
%t7495 = getelementptr i8, ptr %t7272, i64 584
store ptr %t7493, ptr %t7495
%t7496 = call ptr @resid_box_i64(i64 %t7231)
%t7498 = getelementptr i8, ptr %t7272, i64 592
store ptr %t7496, ptr %t7498
%t7499 = call ptr @resid_box_i64(i64 %t7238)
%t7501 = getelementptr i8, ptr %t7272, i64 600
store ptr %t7499, ptr %t7501
%t7502 = call ptr @resid_box_i64(i64 %t7245)
%t7504 = getelementptr i8, ptr %t7272, i64 608
store ptr %t7502, ptr %t7504
%t7505 = call ptr @resid_box_i64(i64 %t7252)
%t7507 = getelementptr i8, ptr %t7272, i64 616
store ptr %t7505, ptr %t7507
%t7508 = call ptr @resid_box_i64(i64 %t7259)
%t7510 = getelementptr i8, ptr %t7272, i64 624
store ptr %t7508, ptr %t7510
%t7511 = call ptr @resid_box_i64(i64 %t7266)
%t7513 = getelementptr i8, ptr %t7272, i64 632
store ptr %t7511, ptr %t7513
%t7514 = call ptr @resid_list_new(i64 80, ptr %t7272, ptr @.lty7272)
ret ptr %t7514
}
define ptr @sha512g_iv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7515 = add i64 7640891576956012808, 0
%t7516 = add i64 %t7515, 0
%t7517 = add i64 %t7516, 0
%t7518 = icmp ne i64 %t7517, %t7515
%t7519 = icmp slt i64 7640891576956012808, 0
%t7520 = or i1 %t7518, %t7519
%t7521 = zext i1 %t7520 to i8
call void @resid_conv_check(i8 %t7521)
%t7522 = add i128 13503953896175478587, 0
%t7523 = trunc i128 %t7522 to i64
%t7524 = zext i64 %t7523 to i128
%t7525 = icmp ne i128 %t7524, %t7522
%t7526 = icmp slt i128 13503953896175478587, 0
%t7527 = or i1 %t7525, %t7526
%t7528 = zext i1 %t7527 to i8
call void @resid_conv_check(i8 %t7528)
%t7529 = add i64 4354685564936845355, 0
%t7530 = add i64 %t7529, 0
%t7531 = add i64 %t7530, 0
%t7532 = icmp ne i64 %t7531, %t7529
%t7533 = icmp slt i64 4354685564936845355, 0
%t7534 = or i1 %t7532, %t7533
%t7535 = zext i1 %t7534 to i8
call void @resid_conv_check(i8 %t7535)
%t7536 = add i128 11912009170470909681, 0
%t7537 = trunc i128 %t7536 to i64
%t7538 = zext i64 %t7537 to i128
%t7539 = icmp ne i128 %t7538, %t7536
%t7540 = icmp slt i128 11912009170470909681, 0
%t7541 = or i1 %t7539, %t7540
%t7542 = zext i1 %t7541 to i8
call void @resid_conv_check(i8 %t7542)
%t7543 = add i64 5840696475078001361, 0
%t7544 = add i64 %t7543, 0
%t7545 = add i64 %t7544, 0
%t7546 = icmp ne i64 %t7545, %t7543
%t7547 = icmp slt i64 5840696475078001361, 0
%t7548 = or i1 %t7546, %t7547
%t7549 = zext i1 %t7548 to i8
call void @resid_conv_check(i8 %t7549)
%t7550 = add i128 11170449401992604703, 0
%t7551 = trunc i128 %t7550 to i64
%t7552 = zext i64 %t7551 to i128
%t7553 = icmp ne i128 %t7552, %t7550
%t7554 = icmp slt i128 11170449401992604703, 0
%t7555 = or i1 %t7553, %t7554
%t7556 = zext i1 %t7555 to i8
call void @resid_conv_check(i8 %t7556)
%t7557 = add i64 2270897969802886507, 0
%t7558 = add i64 %t7557, 0
%t7559 = add i64 %t7558, 0
%t7560 = icmp ne i64 %t7559, %t7557
%t7561 = icmp slt i64 2270897969802886507, 0
%t7562 = or i1 %t7560, %t7561
%t7563 = zext i1 %t7562 to i8
call void @resid_conv_check(i8 %t7563)
%t7564 = add i64 6620516959819538809, 0
%t7565 = add i64 %t7564, 0
%t7566 = add i64 %t7565, 0
%t7567 = icmp ne i64 %t7566, %t7564
%t7568 = icmp slt i64 6620516959819538809, 0
%t7569 = or i1 %t7567, %t7568
%t7570 = zext i1 %t7569 to i8
call void @resid_conv_check(i8 %t7570)
%t7571 = alloca [8 x ptr]
%t7573 = call ptr @resid_box_i64(i64 %t7516)
%t7575 = getelementptr i8, ptr %t7571, i64 0
store ptr %t7573, ptr %t7575
%t7576 = call ptr @resid_box_i64(i64 %t7523)
%t7578 = getelementptr i8, ptr %t7571, i64 8
store ptr %t7576, ptr %t7578
%t7579 = call ptr @resid_box_i64(i64 %t7530)
%t7581 = getelementptr i8, ptr %t7571, i64 16
store ptr %t7579, ptr %t7581
%t7582 = call ptr @resid_box_i64(i64 %t7537)
%t7584 = getelementptr i8, ptr %t7571, i64 24
store ptr %t7582, ptr %t7584
%t7585 = call ptr @resid_box_i64(i64 %t7544)
%t7587 = getelementptr i8, ptr %t7571, i64 32
store ptr %t7585, ptr %t7587
%t7588 = call ptr @resid_box_i64(i64 %t7551)
%t7590 = getelementptr i8, ptr %t7571, i64 40
store ptr %t7588, ptr %t7590
%t7591 = call ptr @resid_box_i64(i64 %t7558)
%t7593 = getelementptr i8, ptr %t7571, i64 48
store ptr %t7591, ptr %t7593
%t7594 = call ptr @resid_box_i64(i64 %t7565)
%t7596 = getelementptr i8, ptr %t7571, i64 56
store ptr %t7594, ptr %t7596
%t7597 = call ptr @resid_list_new(i64 8, ptr %t7571, ptr @.lty7571)
ret ptr %t7597
}
define ptr @sha384g_iv() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7598 = add i128 14680500436340154072, 0
%t7599 = trunc i128 %t7598 to i64
%t7600 = zext i64 %t7599 to i128
%t7601 = icmp ne i128 %t7600, %t7598
%t7602 = icmp slt i128 14680500436340154072, 0
%t7603 = or i1 %t7601, %t7602
%t7604 = zext i1 %t7603 to i8
call void @resid_conv_check(i8 %t7604)
%t7605 = add i64 7105036623409894663, 0
%t7606 = add i64 %t7605, 0
%t7607 = add i64 %t7606, 0
%t7608 = icmp ne i64 %t7607, %t7605
%t7609 = icmp slt i64 7105036623409894663, 0
%t7610 = or i1 %t7608, %t7609
%t7611 = zext i1 %t7610 to i8
call void @resid_conv_check(i8 %t7611)
%t7612 = add i128 10473403895298186519, 0
%t7613 = trunc i128 %t7612 to i64
%t7614 = zext i64 %t7613 to i128
%t7615 = icmp ne i128 %t7614, %t7612
%t7616 = icmp slt i128 10473403895298186519, 0
%t7617 = or i1 %t7615, %t7616
%t7618 = zext i1 %t7617 to i8
call void @resid_conv_check(i8 %t7618)
%t7619 = add i64 1526699215303891257, 0
%t7620 = add i64 %t7619, 0
%t7621 = add i64 %t7620, 0
%t7622 = icmp ne i64 %t7621, %t7619
%t7623 = icmp slt i64 1526699215303891257, 0
%t7624 = or i1 %t7622, %t7623
%t7625 = zext i1 %t7624 to i8
call void @resid_conv_check(i8 %t7625)
%t7626 = add i64 7436329637833083697, 0
%t7627 = add i64 %t7626, 0
%t7628 = add i64 %t7627, 0
%t7629 = icmp ne i64 %t7628, %t7626
%t7630 = icmp slt i64 7436329637833083697, 0
%t7631 = or i1 %t7629, %t7630
%t7632 = zext i1 %t7631 to i8
call void @resid_conv_check(i8 %t7632)
%t7633 = add i128 10282925794625328401, 0
%t7634 = trunc i128 %t7633 to i64
%t7635 = zext i64 %t7634 to i128
%t7636 = icmp ne i128 %t7635, %t7633
%t7637 = icmp slt i128 10282925794625328401, 0
%t7638 = or i1 %t7636, %t7637
%t7639 = zext i1 %t7638 to i8
call void @resid_conv_check(i8 %t7639)
%t7640 = add i128 15784041429090275239, 0
%t7641 = trunc i128 %t7640 to i64
%t7642 = zext i64 %t7641 to i128
%t7643 = icmp ne i128 %t7642, %t7640
%t7644 = icmp slt i128 15784041429090275239, 0
%t7645 = or i1 %t7643, %t7644
%t7646 = zext i1 %t7645 to i8
call void @resid_conv_check(i8 %t7646)
%t7647 = add i64 5167115440072839076, 0
%t7648 = add i64 %t7647, 0
%t7649 = add i64 %t7648, 0
%t7650 = icmp ne i64 %t7649, %t7647
%t7651 = icmp slt i64 5167115440072839076, 0
%t7652 = or i1 %t7650, %t7651
%t7653 = zext i1 %t7652 to i8
call void @resid_conv_check(i8 %t7653)
%t7654 = alloca [8 x ptr]
%t7656 = call ptr @resid_box_i64(i64 %t7599)
%t7658 = getelementptr i8, ptr %t7654, i64 0
store ptr %t7656, ptr %t7658
%t7659 = call ptr @resid_box_i64(i64 %t7606)
%t7661 = getelementptr i8, ptr %t7654, i64 8
store ptr %t7659, ptr %t7661
%t7662 = call ptr @resid_box_i64(i64 %t7613)
%t7664 = getelementptr i8, ptr %t7654, i64 16
store ptr %t7662, ptr %t7664
%t7665 = call ptr @resid_box_i64(i64 %t7620)
%t7667 = getelementptr i8, ptr %t7654, i64 24
store ptr %t7665, ptr %t7667
%t7668 = call ptr @resid_box_i64(i64 %t7627)
%t7670 = getelementptr i8, ptr %t7654, i64 32
store ptr %t7668, ptr %t7670
%t7671 = call ptr @resid_box_i64(i64 %t7634)
%t7673 = getelementptr i8, ptr %t7654, i64 40
store ptr %t7671, ptr %t7673
%t7674 = call ptr @resid_box_i64(i64 %t7641)
%t7676 = getelementptr i8, ptr %t7654, i64 48
store ptr %t7674, ptr %t7676
%t7677 = call ptr @resid_box_i64(i64 %t7648)
%t7679 = getelementptr i8, ptr %t7654, i64 56
store ptr %t7677, ptr %t7679
%t7680 = call ptr @resid_list_new(i64 8, ptr %t7654, ptr @.lty7654)
ret ptr %t7680
}
define ptr @sha512g_pad(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7681 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p0, i64 17)
%t7682 = extractvalue {i64, i1} %t7681, 0
%t7683 = extractvalue {i64, i1} %t7681, 1
%t7684 = zext i1 %t7683 to i8
call void @resid_overflow_check(i8 %t7684)
%t7685 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t7682, i64 127)
%t7686 = extractvalue {i64, i1} %t7685, 0
%t7687 = extractvalue {i64, i1} %t7685, 1
%t7688 = zext i1 %t7687 to i8
call void @resid_overflow_check(i8 %t7688)
%t7689 = sdiv i64 %t7686, 128
%t7690 = mul nsw i64 %t7689, 128
%t7691 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7690, i64 %p0)
%t7692 = extractvalue {i64, i1} %t7691, 0
%t7693 = extractvalue {i64, i1} %t7691, 1
%t7694 = zext i1 %t7693 to i8
call void @resid_overflow_check(i8 %t7694)
%t7695 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7692, i64 17)
%t7696 = extractvalue {i64, i1} %t7695, 0
%t7697 = extractvalue {i64, i1} %t7695, 1
%t7698 = zext i1 %t7697 to i8
call void @resid_overflow_check(i8 %t7698)
%t7699 = call ptr @resid_listbuf_new()
%t7700 = call ptr @__m_________lib_sha512g_resid__sha512g_pad_at(i64 %p0, i64 %t7696, i64 0, ptr %t7699)
%t7701 = call ptr @resid_listbuf_finish(ptr %t7700, ptr @.lty7701)
ret ptr %t7701
}
define ptr @__m_________lib_sha512g_resid__sha512g_pad_at(i64 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ], [ %p0, %tco.s1 ], [ %p0, %tco.s2 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ], [ %p1, %tco.s2 ]
%p2 = phi i64 [ %p2.in, %entry ], [ 1, %tco.s0 ], [ %t7714, %tco.s1 ], [ %t7740, %tco.s2 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t7706, %tco.s0 ], [ %t7720, %tco.s1 ], [ %t7757, %tco.s2 ]
%t7702 = icmp eq i64 %p2, 0
br i1 %t7702, label %L820, label %L822
L820:
%t7703 = call ptr @resid_box_i64(i64 128)
%t7706 = call ptr @resid_listbuf_push(ptr %p3, ptr %t7703)
br label %tco.s0
tco.s0:
br label %tco.head
L822:
%t7708 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 8)
%t7709 = extractvalue {i64, i1} %t7708, 0
%t7710 = extractvalue {i64, i1} %t7708, 1
%t7711 = zext i1 %t7710 to i8
call void @resid_overflow_check(i8 %t7711)
%t7712 = icmp sle i64 %p2, %t7709
br i1 %t7712, label %L823, label %L825
L823:
%t7713 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t7714 = extractvalue {i64, i1} %t7713, 0
%t7715 = extractvalue {i64, i1} %t7713, 1
%t7716 = zext i1 %t7715 to i8
call void @resid_overflow_check(i8 %t7716)
%t7717 = call ptr @resid_box_i64(i64 0)
%t7720 = call ptr @resid_listbuf_push(ptr %p3, ptr %t7717)
br label %tco.s1
tco.s1:
br label %tco.head
L825:
%t7722 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 16)
%t7723 = extractvalue {i64, i1} %t7722, 0
%t7724 = extractvalue {i64, i1} %t7722, 1
%t7725 = zext i1 %t7724 to i8
call void @resid_overflow_check(i8 %t7725)
%t7726 = icmp sle i64 %p2, %t7723
br i1 %t7726, label %L826, label %L828
L826:
%t7727 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 16)
%t7728 = extractvalue {i64, i1} %t7727, 0
%t7729 = extractvalue {i64, i1} %t7727, 1
%t7730 = zext i1 %t7729 to i8
call void @resid_overflow_check(i8 %t7730)
%t7731 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t7728, i64 %p2)
%t7732 = extractvalue {i64, i1} %t7731, 0
%t7733 = extractvalue {i64, i1} %t7731, 1
%t7734 = zext i1 %t7733 to i8
call void @resid_overflow_check(i8 %t7734)
%t7735 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t7732, i64 8)
%t7736 = extractvalue {i64, i1} %t7735, 0
%t7737 = extractvalue {i64, i1} %t7735, 1
%t7738 = zext i1 %t7737 to i8
call void @resid_overflow_check(i8 %t7738)
%t7739 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t7740 = extractvalue {i64, i1} %t7739, 0
%t7741 = extractvalue {i64, i1} %t7739, 1
%t7742 = zext i1 %t7741 to i8
call void @resid_overflow_check(i8 %t7742)
%t7743 = icmp sge i64 %t7736, 61
br i1 %t7743, label %L829, label %L830
L829:
br label %L831
L830:
%t7744 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p0, i64 8)
%t7745 = extractvalue {i64, i1} %t7744, 0
%t7746 = extractvalue {i64, i1} %t7744, 1
%t7747 = zext i1 %t7746 to i8
call void @resid_overflow_check(i8 %t7747)
%t7748 = icmp uge i64 %t7736, 64
%t7749 = add i64 %t7736, 0
%t7750 = select i1 %t7748, i64 63, i64 %t7749
%t7751 = ashr i64 %t7745, %t7750
%t7752 = and i64 %t7751, 255
br label %L831
L831:
%t7753 = phi i64 [ 0, %L829 ], [ %t7752, %L830 ]
%t7754 = call ptr @resid_box_i64(i64 %t7753)
%t7757 = call ptr @resid_listbuf_push(ptr %p3, ptr %t7754)
br label %tco.s2
tco.s2:
br label %tco.head
L828:
ret ptr %p3
}
define ptr @__m_________lib_sha512g_resid__sha512g_zero_bytes(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7761, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7765, %tco.s0 ]
%t7759 = icmp sge i64 %p1, %p0
br i1 %t7759, label %L832, label %L834
L832:
%t7760 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty7760)
ret ptr %t7760
L834:
%t7761 = add nsw i64 %p1, 1
%t7762 = call ptr @resid_box_i64(i64 0)
%t7765 = call ptr @resid_listbuf_push(ptr %p2, ptr %t7762)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @eg_p() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7767 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
ret i512 %t7767
}
define i512 @eg_d() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7768 = sext i256 37095705934669439343138083508754565189542113879843219016388785533085940283555 to i512
ret i512 %t7768
}
define i512 @eg_l() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7769 = sext i256 7237005577332262213973186563042994240857116359379907606001950938285454250989 to i512
ret i512 %t7769
}
define i512 @eg_bx() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7770 = sext i256 15112221349535400772501151409588531511454012693041857206046113283949847762202 to i512
ret i512 %t7770
}
define i512 @eg_by() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7771 = sext i256 46316835694926478169428394003475163141307993866256225615783033603165251855960 to i512
ret i512 %t7771
}
define i512 @__m_________lib_ed25519g_resid__eg_m256() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i512 115792089237316195423570985008687907853269984665640564039457584007913129639935
}
define i512 @__m_________lib_ed25519g_resid__eg_ones() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7772 = sext i64 -1 to i512
ret i512 %t7772
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
%t7773 = call i256 @fe_mul(i256 15112221349535400772501151409588531511454012693041857206046113283949847762202, i256 46316835694926478169428394003475163141307993866256225615783033603165251855960)
ret i256 %t7773
}
define i512 @__m_________lib_ed25519_resid__fe_w(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7774 = sext i256 %p0 to i512
ret i512 %t7774
}
define i256 @fe_add(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7775 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %p0)
%t7776 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %p1)
%t7777 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t7775, i512 %t7776)
%t7778 = trunc i512 %t7777 to i256
ret i256 %t7778
}
define i256 @fe_sub(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7779 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %p0)
%t7780 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %p1)
%t7781 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t7779, i512 %t7780)
%t7782 = trunc i512 %t7781 to i256
ret i256 %t7782
}
define i256 @fe_mul(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7783 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %p0)
%t7784 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %p1)
%t7785 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t7783, i512 %t7784)
%t7786 = trunc i512 %t7785 to i256
ret i256 %t7786
}
define i256 @fe_sq(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7787 = call i256 @fe_mul(i256 %p0, i256 %p0)
ret i256 %t7787
}
define i256 @fe_inv(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7788 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %p0)
%t7789 = call i512 @eg_finv__g_Int_512__Int_64_(i512 %t7788)
%t7790 = trunc i512 %t7789 to i256
ret i256 %t7790
}
define i256 @pow_acc(i256 %p0, i256 %p1, i256 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7791 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %p0)
%t7792 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %p1)
%t7793 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %p2)
%t7794 = call i512 @eg_fpow__g_Int_512__Int_64_(i512 %t7791, i512 %t7792, i512 %t7793, i64 %p3)
%t7795 = trunc i512 %t7794 to i256
ret i256 %t7795
}
define i256 @bytes_to_int(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7796 = sext i64 0 to i256
%t7797 = call i256 @b2a(ptr %p0, i256 %t7796, i64 31)
ret i256 %t7797
}
define i256 @b2a(ptr %p0.in, i256 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i256 [ %p1.in, %entry ], [ %t7811, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t7812, %tco.s0 ]
%t7798 = icmp slt i64 %p2, 0
br i1 %t7798, label %L835, label %L837
L835:
ret i256 %p1
L837:
%t7799 = icmp eq i64 %p2, 31
br i1 %t7799, label %L838, label %L839
L838:
%t7800 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t7801 = call i64 @resid_unbox_i64(ptr %t7800)
%t7803 = and i64 %t7801, 127
br label %L840
L839:
%t7804 = call ptr @resid_list_get_v(ptr %p0, i64 %p2, ptr %p0.ld, i64 %p0.ln)
%t7805 = call i64 @resid_unbox_i64(ptr %t7804)
%t7807 = and i64 %t7805, 255
br label %L840
L840:
%t7808 = phi i64 [ %t7803, %L838 ], [ %t7807, %L839 ]
%t7809 = shl i256 %p1, 8
%t7810 = sext i64 %t7808 to i256
%t7811 = or i256 %t7809, %t7810
%t7812 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @int_to_bytes(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7814 = call ptr @resid_listbuf_new()
%t7815 = call ptr @__m_________lib_ed25519_resid__itob_acc(i256 %p0, i64 0, ptr %t7814)
ret ptr %t7815
}
define ptr @__m_________lib_ed25519_resid__itob_acc(i256 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i256 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t7818, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t7833, %tco.s0 ]
%t7816 = icmp sgt i64 %p1, 31
br i1 %t7816, label %L841, label %L843
L841:
%t7817 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty7817)
ret ptr %t7817
L843:
%t7818 = add nsw i64 %p1, 1
%t7819 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p1, i64 8)
%t7820 = extractvalue {i64, i1} %t7819, 0
%t7821 = extractvalue {i64, i1} %t7819, 1
%t7822 = zext i1 %t7821 to i8
call void @resid_overflow_check(i8 %t7822)
%t7823 = sext i64 %t7820 to i256
%t7824 = icmp uge i256 %t7823, 256
%t7825 = add i256 %t7823, 0
%t7826 = select i1 %t7824, i256 255, i256 %t7825
%t7827 = ashr i256 %p0, %t7826
%t7828 = and i256 %t7827, 255
%t7829 = trunc i256 %t7828 to i64
%t7830 = call ptr @resid_box_i64(i64 %t7829)
%t7833 = call ptr @resid_listbuf_push(ptr %p2, ptr %t7830)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @slice_bytes(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7835 = icmp slt i64 %p2, %p1
br i1 %t7835, label %L844, label %L846
L844:
%t7837 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty7836)
ret ptr %t7837
L846:
%t7838 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t7839 = extractvalue {i64, i1} %t7838, 0
%t7840 = extractvalue {i64, i1} %t7838, 1
%t7841 = zext i1 %t7840 to i8
call void @resid_overflow_check(i8 %t7841)
%t7842 = musttail call ptr @resid_list_slice(ptr %p0, i64 %p1, i64 %t7839)
ret ptr %t7842
}
define ptr @concat_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7844 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %p1)
ret ptr %t7844
}
define ptr @__m_________lib_ed25519_resid__ept_w(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7845 = call ptr @resid_rec_new(i64 256, i8 1)
%t7846 = getelementptr i8, ptr %p0, i64 0
%t7847 = load i256, ptr %t7846, align 8
%t7848 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %t7847)
%t7845.f0 = getelementptr i8, ptr %t7845, i64 0
store i512 %t7848, ptr %t7845.f0, align 8
%t7849 = getelementptr i8, ptr %p0, i64 32
%t7850 = load i256, ptr %t7849, align 8
%t7851 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %t7850)
%t7845.f8 = getelementptr i8, ptr %t7845, i64 64
store i512 %t7851, ptr %t7845.f8, align 8
%t7852 = getelementptr i8, ptr %p0, i64 64
%t7853 = load i256, ptr %t7852, align 8
%t7854 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %t7853)
%t7845.f16 = getelementptr i8, ptr %t7845, i64 128
store i512 %t7854, ptr %t7845.f16, align 8
%t7855 = getelementptr i8, ptr %p0, i64 96
%t7856 = load i256, ptr %t7855, align 8
%t7857 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %t7856)
%t7845.f24 = getelementptr i8, ptr %t7845, i64 192
store i512 %t7857, ptr %t7845.f24, align 8
ret ptr %t7845
}
define ptr @__m_________lib_ed25519_resid__ept_n(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7858 = call ptr @resid_gmalloc(i64 128)
%t7859 = getelementptr i8, ptr %p0, i64 0
%t7860 = load i512, ptr %t7859, align 8
%t7861 = trunc i512 %t7860 to i256
%t7858.f0 = getelementptr i8, ptr %t7858, i64 0
store i256 %t7861, ptr %t7858.f0, align 8
%t7862 = getelementptr i8, ptr %p0, i64 64
%t7863 = load i512, ptr %t7862, align 8
%t7864 = trunc i512 %t7863 to i256
%t7858.f4 = getelementptr i8, ptr %t7858, i64 32
store i256 %t7864, ptr %t7858.f4, align 8
%t7865 = getelementptr i8, ptr %p0, i64 128
%t7866 = load i512, ptr %t7865, align 8
%t7867 = trunc i512 %t7866 to i256
%t7858.f8 = getelementptr i8, ptr %t7858, i64 64
store i256 %t7867, ptr %t7858.f8, align 8
%t7868 = getelementptr i8, ptr %p0, i64 192
%t7869 = load i512, ptr %t7868, align 8
%t7870 = trunc i512 %t7869 to i256
%t7858.f12 = getelementptr i8, ptr %t7858, i64 96
store i256 %t7870, ptr %t7858.f12, align 8
ret ptr %t7858
}
define ptr @ept(i256 %p0, i256 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7871 = call ptr @resid_gmalloc(i64 128)
%t7871.f0 = getelementptr i8, ptr %t7871, i64 0
store i256 %p0, ptr %t7871.f0, align 8
%t7871.f4 = getelementptr i8, ptr %t7871, i64 32
store i256 %p1, ptr %t7871.f4, align 8
%t7872 = sext i64 1 to i256
%t7871.f8 = getelementptr i8, ptr %t7871, i64 64
store i256 %t7872, ptr %t7871.f8, align 8
%t7873 = call i256 @fe_mul(i256 %p0, i256 %p1)
%t7871.f12 = getelementptr i8, ptr %t7871, i64 96
store i256 %t7873, ptr %t7871.f12, align 8
ret ptr %t7871
}
define ptr @ept_id() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7874 = call ptr @resid_gmalloc(i64 128)
%t7875 = sext i64 0 to i256
%t7874.f0 = getelementptr i8, ptr %t7874, i64 0
store i256 %t7875, ptr %t7874.f0, align 8
%t7876 = sext i64 1 to i256
%t7874.f4 = getelementptr i8, ptr %t7874, i64 32
store i256 %t7876, ptr %t7874.f4, align 8
%t7877 = sext i64 1 to i256
%t7874.f8 = getelementptr i8, ptr %t7874, i64 64
store i256 %t7877, ptr %t7874.f8, align 8
%t7878 = sext i64 0 to i256
%t7874.f12 = getelementptr i8, ptr %t7874, i64 96
store i256 %t7878, ptr %t7874.f12, align 8
ret ptr %t7874
}
define ptr @ept_dbl(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7879 = call ptr @__m_________lib_ed25519_resid__ept_w(ptr %p0)
%t7880 = call ptr @eg_dbl__g_Int_512__Int_64_(ptr %t7879)
%t7881 = musttail call ptr @__m_________lib_ed25519_resid__ept_n(ptr %t7880)
ret ptr %t7881
}
define ptr @ept_add(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7882 = call ptr @__m_________lib_ed25519_resid__ept_w(ptr %p0)
%t7883 = call ptr @__m_________lib_ed25519_resid__ept_w(ptr %p1)
%t7884 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t7882, ptr %t7883)
%t7885 = call ptr @__m_________lib_ed25519_resid__ept_n(ptr %t7884)
ret ptr %t7885
}
define ptr @ept_mul(i256 %p0, ptr %p1, ptr %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7886 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %p0)
%t7887 = call ptr @__m_________lib_ed25519_resid__ept_w(ptr %p1)
call void @resid_rec_share(ptr %t7887)
%t7888 = call ptr @__m_________lib_ed25519_resid__ept_w(ptr %p2)
call void @resid_rec_share(ptr %t7888)
%t7889 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %t7886, ptr %t7887, ptr %t7888, i64 %p3)
%t7890 = call ptr @__m_________lib_ed25519_resid__ept_n(ptr %t7889)
ret ptr %t7890
}
define ptr @ept_base_mul(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7891 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %p0)
%t7892 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t7891)
%t7893 = call ptr @__m_________lib_ed25519_resid__ept_n(ptr %t7892)
ret ptr %t7893
}
define ptr @ept_encode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7894 = call ptr @__m_________lib_ed25519_resid__ept_w(ptr %p0)
%t7895 = musttail call ptr @eg_encode__g_Int_512__Int_64_(ptr %t7894)
ret ptr %t7895
}
define i1 @ept_eq(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7896 = getelementptr i8, ptr %p0, i64 0
%t7897 = load i256, ptr %t7896, align 8
%t7898 = getelementptr i8, ptr %p1, i64 64
%t7899 = load i256, ptr %t7898, align 8
%t7900 = call i256 @fe_mul(i256 %t7897, i256 %t7899)
%t7901 = getelementptr i8, ptr %p1, i64 0
%t7902 = load i256, ptr %t7901, align 8
%t7903 = getelementptr i8, ptr %p0, i64 64
%t7904 = load i256, ptr %t7903, align 8
%t7905 = call i256 @fe_mul(i256 %t7902, i256 %t7904)
%t7906 = icmp eq i256 %t7900, %t7905
br label %LSL7907
LSL7907:
br i1 %t7906, label %LSR7907, label %LSJ7907
LSR7907:
%t7908 = getelementptr i8, ptr %p0, i64 32
%t7909 = load i256, ptr %t7908, align 8
%t7910 = getelementptr i8, ptr %p1, i64 64
%t7911 = load i256, ptr %t7910, align 8
%t7912 = call i256 @fe_mul(i256 %t7909, i256 %t7911)
%t7913 = getelementptr i8, ptr %p1, i64 32
%t7914 = load i256, ptr %t7913, align 8
%t7915 = getelementptr i8, ptr %p0, i64 64
%t7916 = load i256, ptr %t7915, align 8
%t7917 = call i256 @fe_mul(i256 %t7914, i256 %t7916)
%t7918 = icmp eq i256 %t7912, %t7917
br label %LSJ7907
LSJ7907:
%t7919 = phi i1 [ false, %LSL7907 ], [ %t7918, %LSR7907 ]
ret i1 %t7919
}
define ptr @smul_x_acc(i256 %p0, i256 %p1, i256 %p2, i256 %p3, i256 %p4, i256 %p5, i256 %p6, i64 %p7) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7920 = call ptr @resid_gmalloc(i64 128)
%t7920.f0 = getelementptr i8, ptr %t7920, i64 0
store i256 %p1, ptr %t7920.f0, align 8
%t7920.f4 = getelementptr i8, ptr %t7920, i64 32
store i256 %p2, ptr %t7920.f4, align 8
%t7920.f8 = getelementptr i8, ptr %t7920, i64 64
store i256 %p3, ptr %t7920.f8, align 8
%t7921 = call i256 @fe_mul(i256 %p1, i256 %p2)
%t7922 = call i256 @fe_inv(i256 %p3)
%t7923 = call i256 @fe_mul(i256 %t7921, i256 %t7922)
%t7920.f12 = getelementptr i8, ptr %t7920, i64 96
store i256 %t7923, ptr %t7920.f12, align 8
%t7924 = call ptr @resid_gmalloc(i64 128)
%t7924.f0 = getelementptr i8, ptr %t7924, i64 0
store i256 %p4, ptr %t7924.f0, align 8
%t7924.f4 = getelementptr i8, ptr %t7924, i64 32
store i256 %p5, ptr %t7924.f4, align 8
%t7924.f8 = getelementptr i8, ptr %t7924, i64 64
store i256 %p6, ptr %t7924.f8, align 8
%t7925 = call i256 @fe_mul(i256 %p4, i256 %p5)
%t7926 = call i256 @fe_inv(i256 %p6)
%t7927 = call i256 @fe_mul(i256 %t7925, i256 %t7926)
%t7924.f12 = getelementptr i8, ptr %t7924, i64 96
store i256 %t7927, ptr %t7924.f12, align 8
%t7928 = call ptr @ept_mul(i256 %p0, ptr %t7920, ptr %t7924, i64 %p7)
%t7929 = getelementptr i8, ptr %t7928, i64 0
%t7930 = load i256, ptr %t7929, align 8
%t7931 = getelementptr i8, ptr %t7928, i64 64
%t7932 = load i256, ptr %t7931, align 8
%t7933 = call i256 @fe_inv(i256 %t7932)
%t7934 = call i256 @fe_mul(i256 %t7930, i256 %t7933)
%t7935 = call ptr @int_to_bytes(i256 %t7934)
ret ptr %t7935
}
define i256 @dec_y(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7936 = call i256 @bytes_to_int(ptr %p0)
ret i256 %t7936
}
define i256 @dec_x(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7937 = call i256 @dec_y(ptr %p0)
%t7938 = call i64 @resid_list_len(ptr %p0)
%t7939 = sub nsw i64 %t7938, 1
%t7940 = call ptr @resid_list_get(ptr %p0, i64 %t7939)
%t7941 = call i64 @resid_unbox_i64(ptr %t7940)
%t7943 = ashr i64 %t7941, 7
%t7944 = and i64 %t7943, 1
%t7945 = call i256 @fe_sq(i256 %t7937)
%t7946 = sext i64 1 to i256
%t7947 = call i256 @fe_sub(i256 %t7945, i256 %t7946)
%t7948 = call i256 @fe_mul(i256 37095705934669439343138083508754565189542113879843219016388785533085940283555, i256 %t7945)
%t7949 = sext i64 1 to i256
%t7950 = call i256 @fe_add(i256 %t7948, i256 %t7949)
%t7951 = call i256 @fe_inv(i256 %t7950)
%t7952 = call i256 @fe_mul(i256 %t7947, i256 %t7951)
%t7953 = sext i64 1 to i256
%t7954 = call i256 @pow_acc(i256 %t7953, i256 %t7952, i256 7237005577332262213973186563042994240829374041602535252466099000494570602494, i64 254)
%t7955 = call i256 @fe_sq(i256 %t7954)
%t7956 = icmp eq i256 %t7955, %t7952
br i1 %t7956, label %L847, label %L848
L847:
br label %L849
L848:
%t7957 = call i256 @fe_mul(i256 %t7954, i256 19681161376707505956807079304988542015446066515923890162744021073123829784752)
br label %L849
L849:
%t7958 = phi i256 [ %t7954, %L847 ], [ %t7957, %L848 ]
%t7959 = and i256 %t7958, 1
%t7960 = trunc i256 %t7959 to i64
%t7961 = icmp ne i64 %t7960, %t7944
br i1 %t7961, label %L850, label %L851
L850:
%t7962 = sext i64 0 to i256
%t7963 = call i256 @fe_sub(i256 %t7962, i256 %t7958)
br label %L852
L851:
br label %L852
L852:
%t7964 = phi i256 [ %t7963, %L850 ], [ %t7958, %L851 ]
ret i256 %t7964
}
define i1 @dec_ok(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7965 = call ptr @__m_________lib_ed25519_resid__dec_pt(ptr %p0)
%t7966 = getelementptr i8, ptr %t7965, i64 0
%t7967 = load i1, ptr %t7966, align 8
ret i1 %t7967
}
define ptr @__m_________lib_ed25519_resid__dec_pt(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7968 = call ptr @resid_gmalloc(i64 72)
%t7968.f0 = getelementptr i8, ptr %t7968, i64 0
store i1 false, ptr %t7968.f0, align 8
%t7969 = sext i64 0 to i256
%t7968.f1 = getelementptr i8, ptr %t7968, i64 8
store i256 %t7969, ptr %t7968.f1, align 8
%t7970 = sext i64 0 to i256
%t7968.f5 = getelementptr i8, ptr %t7968, i64 40
store i256 %t7970, ptr %t7968.f5, align 8
%t7971 = call i64 @resid_list_len(ptr %p0)
%t7972 = icmp ne i64 %t7971, 32
br i1 %t7972, label %L853, label %L855
L853:
ret ptr %t7968
L855:
%t7973 = call i256 @dec_y(ptr %p0)
%t7974 = icmp sge i256 %t7973, 57896044618658097711785492504343953926634992332820282019728792003956564819949
br i1 %t7974, label %L856, label %L858
L856:
ret ptr %t7968
L858:
%t7975 = call i256 @dec_x(ptr %p0)
%t7976 = icmp eq i256 %t7975, 0
br label %LSL7977
LSL7977:
br i1 %t7976, label %LSR7977, label %LSJ7977
LSR7977:
%t7978 = call ptr @resid_list_get(ptr %p0, i64 31)
%t7979 = call i64 @resid_unbox_i64(ptr %t7978)
%t7981 = ashr i64 %t7979, 7
%t7982 = and i64 %t7981, 1
%t7983 = icmp eq i64 %t7982, 1
br label %LSJ7977
LSJ7977:
%t7984 = phi i1 [ false, %LSL7977 ], [ %t7983, %LSR7977 ]
br i1 %t7984, label %L859, label %L861
L859:
ret ptr %t7968
L861:
%t7985 = call i256 @fe_sq(i256 %t7975)
%t7986 = call i256 @fe_sq(i256 %t7973)
%t7987 = call ptr @resid_gmalloc(i64 72)
%t7988 = call i256 @fe_sub(i256 %t7986, i256 %t7985)
%t7989 = sext i64 1 to i256
%t7990 = call i256 @fe_mul(i256 %t7985, i256 %t7986)
%t7991 = call i256 @fe_mul(i256 37095705934669439343138083508754565189542113879843219016388785533085940283555, i256 %t7990)
%t7992 = call i256 @fe_add(i256 %t7989, i256 %t7991)
%t7993 = icmp eq i256 %t7988, %t7992
%t7987.f0 = getelementptr i8, ptr %t7987, i64 0
store i1 %t7993, ptr %t7987.f0, align 8
%t7987.f1 = getelementptr i8, ptr %t7987, i64 8
store i256 %t7975, ptr %t7987.f1, align 8
%t7987.f5 = getelementptr i8, ptr %t7987, i64 40
store i256 %t7973, ptr %t7987.f5, align 8
ret ptr %t7987
}
define i256 @mod_l(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7994 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %p0)
%t7995 = trunc i512 %t7994 to i256
ret i256 %t7995
}
define i1 @verify_sig_bytes(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t7996 = call i64 @resid_list_len(ptr %p1)
%t7997 = icmp ne i64 %t7996, 64
br label %LSL7998
LSL7998:
br i1 %t7997, label %LSJ7998, label %LSR7998
LSR7998:
%t7999 = call i64 @resid_list_len(ptr %p2)
%t8000 = icmp ne i64 %t7999, 32
br label %LSJ7998
LSJ7998:
%t8001 = phi i1 [ true, %LSL7998 ], [ %t8000, %LSR7998 ]
br i1 %t8001, label %L862, label %L864
L862:
ret i1 false
L864:
%t8002 = call ptr @resid_list_get(ptr %p1, i64 63)
%t8003 = call i64 @resid_unbox_i64(ptr %t8002)
%t8005 = icmp sge i64 %t8003, 128
br i1 %t8005, label %L865, label %L867
L865:
ret i1 false
L867:
%t8006 = call ptr @resid_list_slice(ptr %p1, i64 0, i64 32)
%t8008 = call ptr @resid_list_slice(ptr %p1, i64 32, i64 64)
%t8010 = call i256 @bytes_to_int(ptr %t8008)
%t8011 = icmp sge i256 %t8010, 7237005577332262213973186563042994240857116359379907606001950938285454250989
br i1 %t8011, label %L868, label %L870
L868:
ret i1 false
L870:
%t8012 = call ptr @__m_________lib_ed25519_resid__dec_pt(ptr %p2)
%t8013 = call ptr @__m_________lib_ed25519_resid__dec_pt(ptr %t8006)
%t8014 = getelementptr i8, ptr %t8012, i64 0
%t8015 = load i1, ptr %t8014, align 8
%t8016 = xor i1 %t8015, true
br label %LSL8017
LSL8017:
br i1 %t8016, label %LSJ8017, label %LSR8017
LSR8017:
%t8018 = getelementptr i8, ptr %t8013, i64 0
%t8019 = load i1, ptr %t8018, align 8
%t8020 = xor i1 %t8019, true
br label %LSJ8017
LSJ8017:
%t8021 = phi i1 [ true, %LSL8017 ], [ %t8020, %LSR8017 ]
br i1 %t8021, label %L871, label %L873
L871:
ret i1 false
L873:
%t8022 = getelementptr i8, ptr %t8012, i64 8
%t8023 = load i256, ptr %t8022, align 8
%t8024 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %t8023)
%t8025 = getelementptr i8, ptr %t8012, i64 40
%t8026 = load i256, ptr %t8025, align 8
%t8027 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %t8026)
%t8028 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t8024, i512 %t8027)
call void @resid_rec_share(ptr %t8028)
%t8029 = getelementptr i8, ptr %t8013, i64 8
%t8030 = load i256, ptr %t8029, align 8
%t8031 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %t8030)
%t8032 = getelementptr i8, ptr %t8013, i64 40
%t8033 = load i256, ptr %t8032, align 8
%t8034 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %t8033)
%t8035 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t8031, i512 %t8034)
%t8036 = call i64 @resid_scope_push()
%t8037 = call ptr @resid_list_concat_own(ptr %t8006, i8 1, ptr %p2)
%t8038 = call ptr @resid_list_concat_own(ptr %t8037, i8 1, ptr %p0)
%t8039 = call ptr @sha512_bytes(ptr %t8038)
%t8040 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t8039)
call void @resid_scope_pop(i64 %t8036)
%t8041 = call ptr @eg_id__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t8041)
%t8042 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %t8010)
%t8043 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t8042)
%t8044 = call ptr @__m_________lib_ed25519_resid__ept_n(ptr %t8043)
%t8045 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %t8040, ptr %t8028, ptr %t8041, i64 255)
%t8046 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t8045, ptr %t8035)
%t8047 = call ptr @__m_________lib_ed25519_resid__ept_n(ptr %t8046)
%t8048 = call i1 @ept_eq(ptr %t8044, ptr %t8047)
ret i1 %t8048
}
define i1 @verify_sig(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8049 = call ptr @bytes_of(ptr %p0)
%t8050 = call ptr @resid_list_freeze(ptr %t8049)
%t8051 = musttail call i1 @verify_sig_bytes(ptr %t8050, ptr %p1, ptr %p2)
ret i1 %t8051
}
define i256 @clamp_scalar(i256 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8052 = call i512 @__m_________lib_ed25519_resid__fe_w(i256 %p0)
%t8053 = call i512 @eg_clamp__g_Int_512__Int_64_(i512 %t8052)
%t8054 = trunc i512 %t8053 to i256
ret i256 %t8054
}
define ptr @pub_key(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8055 = musttail call ptr @ed25519g_pub__g_Int_64__Int_512__UInt_64_(ptr %p0)
ret ptr %t8055
}
define ptr @sign_msg_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8056 = musttail call ptr @ed25519g_sign__g_Int_64__Int_512__UInt_64_(ptr %p0, ptr %p1)
ret ptr %t8056
}
define ptr @sign_msg(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8057 = call ptr @bytes_of(ptr %p1)
%t8058 = call ptr @resid_list_freeze(ptr %t8057)
%t8059 = musttail call ptr @sign_msg_bytes(ptr %p0, ptr %t8058)
ret ptr %t8059
}
define i64 @__m_________lib_chachag_resid__cg_le32(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8060 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t8061 = call i64 @resid_unbox_i64(ptr %t8060)
%t8063 = and i64 %t8061, 255
%t8064 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t8065 = extractvalue {i64, i1} %t8064, 0
%t8066 = extractvalue {i64, i1} %t8064, 1
%t8067 = zext i1 %t8066 to i8
call void @resid_overflow_check(i8 %t8067)
%t8068 = call ptr @resid_list_get(ptr %p0, i64 %t8065)
%t8069 = call i64 @resid_unbox_i64(ptr %t8068)
%t8071 = and i64 %t8069, 255
%t8072 = shl i64 %t8071, 8
%t8073 = or i64 %t8063, %t8072
%t8074 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t8075 = extractvalue {i64, i1} %t8074, 0
%t8076 = extractvalue {i64, i1} %t8074, 1
%t8077 = zext i1 %t8076 to i8
call void @resid_overflow_check(i8 %t8077)
%t8078 = call ptr @resid_list_get(ptr %p0, i64 %t8075)
%t8079 = call i64 @resid_unbox_i64(ptr %t8078)
%t8081 = and i64 %t8079, 255
%t8082 = shl i64 %t8081, 16
%t8083 = or i64 %t8073, %t8082
%t8084 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 3)
%t8085 = extractvalue {i64, i1} %t8084, 0
%t8086 = extractvalue {i64, i1} %t8084, 1
%t8087 = zext i1 %t8086 to i8
call void @resid_overflow_check(i8 %t8087)
%t8088 = call ptr @resid_list_get(ptr %p0, i64 %t8085)
%t8089 = call i64 @resid_unbox_i64(ptr %t8088)
%t8091 = and i64 %t8089, 255
%t8092 = shl i64 %t8091, 24
%t8093 = or i64 %t8083, %t8092
ret i64 %t8093
}
define i512 @__m_________lib_chachag_resid__pg_m130() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8094 = sext i256 1361129467683753853853498429727072845823 to i512
ret i512 %t8094
}
define i512 @__m_________lib_chachag_resid__pg_p() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8095 = sext i256 1361129467683753853853498429727072845819 to i512
ret i512 %t8095
}
define i512 @__m_________lib_chachag_resid__pg_m128() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8096 = sext i256 340282366920938463463374607431768211455 to i512
ret i512 %t8096
}
define i512 @__m_________lib_chachag_resid__pg_clamp() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8097 = sext i128 21267647620597763993911028882763415551 to i512
ret i512 %t8097
}
define i64 @__m_________lib_chachag_resid__cg_pad16(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8098 = srem i64 %p0, 16
%t8099 = icmp eq i64 %t8098, 0
br i1 %t8099, label %L874, label %L875
L874:
br label %L876
L875:
%t8100 = sub nsw i64 16, %t8098
br label %L876
L876:
%t8101 = phi i64 [ 0, %L874 ], [ %t8100, %L875 ]
ret i64 %t8101
}
define ptr @__m_________lib_chachag_resid__cg_zeros(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8104, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8108, %tco.s0 ]
%t8102 = icmp sge i64 %p1, %p0
br i1 %t8102, label %L877, label %L879
L877:
%t8103 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8103)
ret ptr %t8103
L879:
%t8104 = add nsw i64 %p1, 1
%t8105 = call ptr @resid_box_i64(i64 0)
%t8108 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8105)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m_________lib_chachag_resid__cg_le64(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8112, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8125, %tco.s0 ]
%t8110 = icmp sge i64 %p1, 8
br i1 %t8110, label %L880, label %L882
L880:
%t8111 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty8111)
ret ptr %t8111
L882:
%t8112 = add nsw i64 %p1, 1
%t8113 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p1)
%t8114 = extractvalue {i64, i1} %t8113, 0
%t8115 = extractvalue {i64, i1} %t8113, 1
%t8116 = zext i1 %t8115 to i8
call void @resid_overflow_check(i8 %t8116)
%t8117 = icmp uge i64 %t8114, 64
%t8118 = add i64 %t8114, 0
%t8119 = select i1 %t8117, i64 63, i64 %t8118
%t8120 = ashr i64 %p0, %t8119
%t8121 = and i64 %t8120, 255
%t8122 = call ptr @resid_box_i64(i64 %t8121)
%t8125 = call ptr @resid_listbuf_push(ptr %p2, ptr %t8122)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @chacha_block(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8127 = musttail call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
ret ptr %t8127
}
define ptr @chacha20_xor(ptr %p0, i64 %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8128 = musttail call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2, ptr %p3)
ret ptr %t8128
}
define ptr @poly1305(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8129 = musttail call ptr @poly1305g__g_Int_64__Int_512_(ptr %p0, ptr %p1)
ret ptr %t8129
}
define ptr @chacha20poly1305_seal(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8130 = musttail call ptr @chacha20poly1305g_seal__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
ret ptr %t8130
}
define i1 @chacha20poly1305_open(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8131 = call ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
%t8132 = getelementptr {i32, i32, ptr}, ptr %t8131, i32 0, i32 0
%t8133w = load i32, ptr %t8132
%t8133 = sext i32 %t8133w to i64
%t8134 = icmp eq i64 %t8133, 1
br i1 %t8134, label %L883, label %L884
L883:
%t8135 = getelementptr {i32, i32, ptr}, ptr %t8131, i32 1
%t8136 = getelementptr i8, ptr %t8135, i64 0
%t8137 = getelementptr ptr, ptr %t8136, i32 0
%t8138 = load ptr, ptr %t8137
br label %L885
L884:
br label %L885
L885:
%t8139 = phi i1 [ true, %L883 ], [ false, %L884 ]
ret i1 %t8139
}
define ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8140 = musttail call ptr @chacha20poly1305g_decrypt__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
ret ptr %t8140
}
define ptr @chacha20poly1305_open_bytes(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8141 = call ptr @chacha20poly1305_decrypt(ptr %p0, ptr %p1, ptr %p2, ptr %p3)
%t8142 = getelementptr {i32, i32, ptr}, ptr %t8141, i32 0, i32 0
%t8143w = load i32, ptr %t8142
%t8143 = sext i32 %t8143w to i64
%t8144 = icmp eq i64 %t8143, 1
br i1 %t8144, label %L886, label %L887
L887:
%t8146 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty8145)
br label %L888
L886:
%t8147 = getelementptr {i32, i32, ptr}, ptr %t8141, i32 1
%t8148 = getelementptr i8, ptr %t8147, i64 0
%t8149 = getelementptr ptr, ptr %t8148, i32 0
%t8150 = load ptr, ptr %t8149
br label %L888
L888:
%t8151 = phi ptr [ %t8146, %L887 ], [ %t8150, %L886 ]
ret ptr %t8151
}
define ptr @cbe_be(i64 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8164 = alloca [1 x ptr]
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i64 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8158, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%t8152 = icmp sle i64 %p1, 0
br i1 %t8152, label %L889, label %L891
L889:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p2
lr.x11.m:
%lr.ret11 = call ptr @resid_mv_list(ptr %p2, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L891:
%t8153 = sub nsw i64 %p1, 1
%t8154 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t8153, i64 8)
%t8155 = extractvalue {i64, i1} %t8154, 0
%t8156 = extractvalue {i64, i1} %t8154, 1
%t8157 = zext i1 %t8156 to i8
call void @resid_overflow_check(i8 %t8157)
%t8158 = sub nsw i64 %p1, 1
%t8159 = icmp uge i64 %t8155, 64
%t8160 = add i64 %t8155, 0
%t8161 = select i1 %t8159, i64 63, i64 %t8160
%t8162 = ashr i64 %p0, %t8161
%t8163 = and i64 %t8162, 255
%t8166 = call ptr @resid_box_i64(i64 %t8163)
%t8168 = getelementptr i8, ptr %t8164, i64 0
store ptr %t8166, ptr %t8168
%t8169 = call ptr @resid_list_new(i64 1, ptr %t8164, ptr @.lty8164)
%t8170 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t8169)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p2.e.tco.s0 = call ptr @resid_mv_list(ptr %t8170, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t8170, %tco.s0 ]
br label %tco.head
}
define ptr @cbe_head(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8175 = alloca [1 x ptr]
%t8185 = alloca [2 x ptr]
%t8197 = alloca [1 x ptr]
%t8207 = alloca [1 x ptr]
%t8216 = alloca [1 x ptr]
%t8172 = shl i64 %p0, 5
%t8173 = icmp sle i64 %p1, 23
br i1 %t8173, label %L892, label %L894
L892:
%t8174 = or i64 %t8172, %p1
%t8177 = call ptr @resid_box_i64(i64 %t8174)
%t8179 = getelementptr i8, ptr %t8175, i64 0
store ptr %t8177, ptr %t8179
%t8180 = call ptr @resid_list_new(i64 1, ptr %t8175, ptr @.lty8175)
%t8181 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t8180)
ret ptr %t8181
L894:
%t8182 = icmp sle i64 %p1, 255
br i1 %t8182, label %L895, label %L897
L895:
%t8183 = or i64 %t8172, 24
%t8184 = add nsw i64 %p1, 0
%t8187 = call ptr @resid_box_i64(i64 %t8183)
%t8189 = getelementptr i8, ptr %t8185, i64 0
store ptr %t8187, ptr %t8189
%t8190 = call ptr @resid_box_i64(i64 %t8184)
%t8192 = getelementptr i8, ptr %t8185, i64 8
store ptr %t8190, ptr %t8192
%t8193 = call ptr @resid_list_new(i64 2, ptr %t8185, ptr @.lty8185)
%t8194 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t8193)
ret ptr %t8194
L897:
%t8195 = icmp sle i64 %p1, 65535
br i1 %t8195, label %L898, label %L900
L898:
%t8196 = or i64 %t8172, 25
%t8199 = call ptr @resid_box_i64(i64 %t8196)
%t8201 = getelementptr i8, ptr %t8197, i64 0
store ptr %t8199, ptr %t8201
%t8202 = call ptr @resid_list_new(i64 1, ptr %t8197, ptr @.lty8197)
%t8203 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t8202)
%t8204 = musttail call ptr @cbe_be(i64 %p1, i64 2, ptr %t8203)
ret ptr %t8204
L900:
%t8205 = icmp sle i64 %p1, 4294967295
br i1 %t8205, label %L901, label %L903
L901:
%t8206 = or i64 %t8172, 26
%t8209 = call ptr @resid_box_i64(i64 %t8206)
%t8211 = getelementptr i8, ptr %t8207, i64 0
store ptr %t8209, ptr %t8211
%t8212 = call ptr @resid_list_new(i64 1, ptr %t8207, ptr @.lty8207)
%t8213 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t8212)
%t8214 = musttail call ptr @cbe_be(i64 %p1, i64 4, ptr %t8213)
ret ptr %t8214
L903:
%t8215 = or i64 %t8172, 27
%t8218 = call ptr @resid_box_i64(i64 %t8215)
%t8220 = getelementptr i8, ptr %t8216, i64 0
store ptr %t8218, ptr %t8220
%t8221 = call ptr @resid_list_new(i64 1, ptr %t8216, ptr @.lty8216)
%t8222 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t8221)
%t8223 = musttail call ptr @cbe_be(i64 %p1, i64 8, ptr %t8222)
ret ptr %t8223
}
define ptr @cbe_uint(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8224 = call ptr @cbe_head(i64 0, i64 %p0, ptr %p1)
ret ptr %t8224
}
define ptr @cbe_int(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8225 = icmp sge i64 %p0, 0
br i1 %t8225, label %L904, label %L906
L904:
%t8226 = call ptr @cbe_head(i64 0, i64 %p0, ptr %p1)
ret ptr %t8226
L906:
%t8227 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p0)
%t8228 = extractvalue {i64, i1} %t8227, 0
%t8229 = extractvalue {i64, i1} %t8227, 1
%t8230 = zext i1 %t8229 to i8
call void @resid_overflow_check(i8 %t8230)
%t8231 = sub nsw i64 %t8228, 1
%t8232 = call ptr @cbe_head(i64 1, i64 %t8231, ptr %p1)
ret ptr %t8232
}
define ptr @cbe_bytes(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8233 = call i64 @resid_list_len(ptr %p0)
%t8234 = call ptr @cbe_head(i64 2, i64 %t8233, ptr %p1)
%t8235 = call ptr @resid_list_concat_own(ptr %t8234, i8 1, ptr %p0)
ret ptr %t8235
}
define ptr @cbe_text(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8236 = call ptr @bytes_of(ptr %p0)
%t8237 = call ptr @resid_list_freeze(ptr %t8236)
%t8238 = call i64 @resid_list_len(ptr %t8237)
%t8239 = call ptr @cbe_head(i64 3, i64 %t8238, ptr %p1)
%t8240 = call ptr @resid_list_concat_own(ptr %t8239, i8 1, ptr %t8237)
ret ptr %t8240
}
define ptr @cbe_array(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8241 = call ptr @cbe_head(i64 4, i64 %p0, ptr %p1)
ret ptr %t8241
}
define ptr @cbe_map(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8242 = call ptr @cbe_head(i64 5, i64 %p0, ptr %p1)
ret ptr %t8242
}
define ptr @cbe_tag(i64 %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8243 = call ptr @cbe_head(i64 6, i64 %p0, ptr %p1)
ret ptr %t8243
}
define i64 @cbe_be_read(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8246, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8249, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t8254, %tco.s0 ]
%t8244 = icmp sle i64 %p2, 0
br i1 %t8244, label %L907, label %L909
L907:
ret i64 %p3
L909:
%t8245 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t8246 = extractvalue {i64, i1} %t8245, 0
%t8247 = extractvalue {i64, i1} %t8245, 1
%t8248 = zext i1 %t8247 to i8
call void @resid_overflow_check(i8 %t8248)
%t8249 = sub nsw i64 %p2, 1
%t8250 = shl i64 %p3, 8
%t8251 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t8252 = call i64 @resid_unbox_i64(ptr %t8251)
%t8254 = or i64 %t8250, %t8252
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @cbe_read_head(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8256 = icmp slt i64 %p1, 0
br label %LSL8257
LSL8257:
br i1 %t8256, label %LSJ8257, label %LSR8257
LSR8257:
%t8258 = call i64 @resid_list_len(ptr %p0)
%t8259 = icmp sge i64 %p1, %t8258
br label %LSJ8257
LSJ8257:
%t8260 = phi i1 [ true, %LSL8257 ], [ %t8259, %LSR8257 ]
br i1 %t8260, label %L910, label %L912
L910:
%t8261 = call ptr @resid_gmalloc(i64 32)
%t8261.f0 = getelementptr i8, ptr %t8261, i64 0
store i1 false, ptr %t8261.f0, align 8
%t8261.f1 = getelementptr i8, ptr %t8261, i64 8
store i64 0, ptr %t8261.f1, align 8
%t8261.f2 = getelementptr i8, ptr %t8261, i64 16
store i64 0, ptr %t8261.f2, align 8
%t8261.f3 = getelementptr i8, ptr %t8261, i64 24
store i64 %p1, ptr %t8261.f3, align 8
ret ptr %t8261
L912:
%t8262 = call ptr @resid_list_get_nc(ptr %p0, i64 %p1)
%t8263 = call i64 @resid_unbox_i64(ptr %t8262)
%t8265 = ashr i64 %t8263, 5
%t8266 = and i64 %t8263, 31
%t8267 = icmp sle i64 %t8266, 23
br i1 %t8267, label %L913, label %L915
L913:
%t8268 = call ptr @resid_gmalloc(i64 32)
%t8268.f0 = getelementptr i8, ptr %t8268, i64 0
store i1 true, ptr %t8268.f0, align 8
%t8268.f1 = getelementptr i8, ptr %t8268, i64 8
store i64 %t8265, ptr %t8268.f1, align 8
%t8268.f2 = getelementptr i8, ptr %t8268, i64 16
store i64 %t8266, ptr %t8268.f2, align 8
%t8269 = add nsw i64 %p1, 1
%t8268.f3 = getelementptr i8, ptr %t8268, i64 24
store i64 %t8269, ptr %t8268.f3, align 8
ret ptr %t8268
L915:
%t8270 = call i64 @cbe_arg_len(i64 %t8266)
%t8271 = icmp eq i64 %t8270, 0
br i1 %t8271, label %L916, label %L918
L916:
%t8272 = call ptr @resid_gmalloc(i64 32)
%t8272.f0 = getelementptr i8, ptr %t8272, i64 0
store i1 false, ptr %t8272.f0, align 8
%t8272.f1 = getelementptr i8, ptr %t8272, i64 8
store i64 %t8265, ptr %t8272.f1, align 8
%t8272.f2 = getelementptr i8, ptr %t8272, i64 16
store i64 0, ptr %t8272.f2, align 8
%t8272.f3 = getelementptr i8, ptr %t8272, i64 24
store i64 %p1, ptr %t8272.f3, align 8
ret ptr %t8272
L918:
%t8273 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t8270)
%t8274 = extractvalue {i64, i1} %t8273, 0
%t8275 = extractvalue {i64, i1} %t8273, 1
%t8276 = zext i1 %t8275 to i8
call void @resid_overflow_check(i8 %t8276)
%t8277 = call i64 @resid_list_len(ptr %p0)
%t8278 = icmp sge i64 %t8274, %t8277
br i1 %t8278, label %L919, label %L921
L919:
%t8279 = call ptr @resid_gmalloc(i64 32)
%t8279.f0 = getelementptr i8, ptr %t8279, i64 0
store i1 false, ptr %t8279.f0, align 8
%t8279.f1 = getelementptr i8, ptr %t8279, i64 8
store i64 %t8265, ptr %t8279.f1, align 8
%t8279.f2 = getelementptr i8, ptr %t8279, i64 16
store i64 0, ptr %t8279.f2, align 8
%t8279.f3 = getelementptr i8, ptr %t8279, i64 24
store i64 %p1, ptr %t8279.f3, align 8
ret ptr %t8279
L921:
%t8280 = call ptr @resid_gmalloc(i64 32)
%t8280.f0 = getelementptr i8, ptr %t8280, i64 0
store i1 true, ptr %t8280.f0, align 8
%t8280.f1 = getelementptr i8, ptr %t8280, i64 8
store i64 %t8265, ptr %t8280.f1, align 8
%t8281 = add nsw i64 %p1, 1
%t8282 = call i64 @cbe_be_read(ptr %p0, i64 %t8281, i64 %t8270, i64 0)
%t8280.f2 = getelementptr i8, ptr %t8280, i64 16
store i64 %t8282, ptr %t8280.f2, align 8
%t8283 = add nsw i64 %p1, 1
%t8284 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t8283, i64 %t8270)
%t8285 = extractvalue {i64, i1} %t8284, 0
%t8286 = extractvalue {i64, i1} %t8284, 1
%t8287 = zext i1 %t8286 to i8
call void @resid_overflow_check(i8 %t8287)
%t8280.f3 = getelementptr i8, ptr %t8280, i64 24
store i64 %t8285, ptr %t8280.f3, align 8
ret ptr %t8280
}
define i64 @cbe_arg_len(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8288 = icmp eq i64 %p0, 24
br i1 %t8288, label %L922, label %L924
L922:
ret i64 1
L924:
%t8289 = icmp eq i64 %p0, 25
br i1 %t8289, label %L925, label %L927
L925:
ret i64 2
L927:
%t8290 = icmp eq i64 %p0, 26
br i1 %t8290, label %L928, label %L930
L928:
ret i64 4
L930:
%t8291 = icmp eq i64 %p0, 27
br i1 %t8291, label %L931, label %L933
L931:
ret i64 8
L933:
ret i64 0
}
define ptr @cbe_read_str(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8292 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB8292)
%t8293 = call ptr @cbe_read_head(ptr %p0, i64 %p1)
%t8294 = getelementptr i8, ptr %t8293, i64 0
%t8295 = load i1, ptr %t8294, align 8
%t8296 = xor i1 %t8295, true
br label %LSL8297
LSL8297:
br i1 %t8296, label %LSJ8297, label %LSR8297
LSR8297:
%t8298 = getelementptr i8, ptr %t8293, i64 8
%t8299 = load i64, ptr %t8298, align 8
%t8300 = icmp ne i64 %t8299, %p2
br label %LSJ8297
LSJ8297:
%t8301 = phi i1 [ true, %LSL8297 ], [ %t8300, %LSR8297 ]
br label %LSL8302
LSL8302:
br i1 %t8301, label %LSJ8302, label %LSR8302
LSR8302:
%t8303 = getelementptr i8, ptr %t8293, i64 16
%t8304 = load i64, ptr %t8303, align 8
%t8305 = icmp slt i64 %t8304, 0
br label %LSJ8302
LSJ8302:
%t8306 = phi i1 [ true, %LSL8302 ], [ %t8305, %LSR8302 ]
br label %LSL8307
LSL8307:
br i1 %t8306, label %LSJ8307, label %LSR8307
LSR8307:
%t8308 = getelementptr i8, ptr %t8293, i64 16
%t8309 = load i64, ptr %t8308, align 8
%t8310 = call i64 @resid_list_len(ptr %p0)
%t8311 = getelementptr i8, ptr %t8293, i64 24
%t8312 = load i64, ptr %t8311, align 8
%t8313 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t8310, i64 %t8312)
%t8314 = extractvalue {i64, i1} %t8313, 0
%t8315 = extractvalue {i64, i1} %t8313, 1
%t8316 = zext i1 %t8315 to i8
call void @resid_overflow_check(i8 %t8316)
%t8317 = icmp sgt i64 %t8309, %t8314
br label %LSJ8307
LSJ8307:
%t8318 = phi i1 [ true, %LSL8307 ], [ %t8317, %LSR8307 ]
br i1 %t8318, label %L934, label %L936
L934:
%t8319 = call ptr @resid_gmalloc(i64 24)
%t8319.f0 = getelementptr i8, ptr %t8319, i64 0
store i1 false, ptr %t8319.f0, align 8
%t8319.f1 = getelementptr i8, ptr %t8319, i64 8
store ptr %t8292, ptr %t8319.f1, align 8
%t8319.f2 = getelementptr i8, ptr %t8319, i64 16
store i64 %p1, ptr %t8319.f2, align 8
ret ptr %t8319
L936:
%t8320 = getelementptr i8, ptr %t8293, i64 24
%t8321 = load i64, ptr %t8320, align 8
%t8322 = getelementptr i8, ptr %t8293, i64 16
%t8323 = load i64, ptr %t8322, align 8
%t8324 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t8321, i64 %t8323)
%t8325 = extractvalue {i64, i1} %t8324, 0
%t8326 = extractvalue {i64, i1} %t8324, 1
%t8327 = zext i1 %t8326 to i8
call void @resid_overflow_check(i8 %t8327)
%t8328 = call ptr @resid_gmalloc(i64 24)
%t8328.f0 = getelementptr i8, ptr %t8328, i64 0
store i1 true, ptr %t8328.f0, align 8
%t8329 = getelementptr i8, ptr %t8293, i64 24
%t8330 = load i64, ptr %t8329, align 8
%t8331 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t8325, i64 1)
%t8332 = extractvalue {i64, i1} %t8331, 0
%t8333 = extractvalue {i64, i1} %t8331, 1
%t8334 = zext i1 %t8333 to i8
call void @resid_overflow_check(i8 %t8334)
%t8335 = call ptr @slice_bytes(ptr %p0, i64 %t8330, i64 %t8332)
%t8328.f1 = getelementptr i8, ptr %t8328, i64 8
store ptr %t8335, ptr %t8328.f1, align 8
%t8328.f2 = getelementptr i8, ptr %t8328, i64 16
store i64 %t8325, ptr %t8328.f2, align 8
ret ptr %t8328
}
define ptr @cbe_ascii__sacc(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8338, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8343, %tco.s0 ]
%t8336 = call i64 @resid_list_len(ptr %p0)
%t8337 = icmp sge i64 %p1, %t8336
br i1 %t8337, label %L937, label %L939
L937:
ret ptr %p2
L939:
%t8338 = add nsw i64 %p1, 1
%t8339 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t8340 = call i64 @resid_unbox_i64(ptr %t8339)
%t8342 = call ptr @str_from_code(i64 %t8340)
%t8343 = call ptr @resid_sacc_append(ptr %p2, ptr %t8342)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @cose_nibble(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8345 = icmp sge i64 %p0, 48
br label %LSL8346
LSL8346:
br i1 %t8345, label %LSR8346, label %LSJ8346
LSR8346:
%t8347 = icmp sle i64 %p0, 57
br label %LSJ8346
LSJ8346:
%t8348 = phi i1 [ false, %LSL8346 ], [ %t8347, %LSR8346 ]
br i1 %t8348, label %L940, label %L942
L940:
%t8349 = sub nsw i64 %p0, 48
ret i64 %t8349
L942:
%t8350 = icmp sge i64 %p0, 97
br label %LSL8351
LSL8351:
br i1 %t8350, label %LSR8351, label %LSJ8351
LSR8351:
%t8352 = icmp sle i64 %p0, 102
br label %LSJ8351
LSJ8351:
%t8353 = phi i1 [ false, %LSL8351 ], [ %t8352, %LSR8351 ]
br i1 %t8353, label %L943, label %L945
L943:
%t8354 = sub nsw i64 %p0, 87
ret i64 %t8354
L945:
%t8355 = icmp sge i64 %p0, 65
br label %LSL8356
LSL8356:
br i1 %t8355, label %LSR8356, label %LSJ8356
LSR8356:
%t8357 = icmp sle i64 %p0, 70
br label %LSJ8356
LSJ8356:
%t8358 = phi i1 [ false, %LSL8356 ], [ %t8357, %LSR8356 ]
br i1 %t8358, label %L946, label %L948
L946:
%t8359 = sub nsw i64 %p0, 55
ret i64 %t8359
L948:
ret i64 0
}
define ptr @cose_hex_acc(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8385 = alloca [1 x ptr]
%p0.alen = call i64 @resid_str_ascii_len(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8382, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t8360 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t8361 = extractvalue {i64, i1} %t8360, 0
%t8362 = extractvalue {i64, i1} %t8360, 1
%t8363 = zext i1 %t8362 to i8
call void @resid_overflow_check(i8 %t8363)
%t8364 = icmp sge i64 %t8361, %p2
br i1 %t8364, label %L949, label %L951
L949:
%lr.cx18 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz18 = icmp eq ptr %lr.cx18, null
br i1 %lr.lz18, label %lr.x18.k, label %lr.x18.m
lr.x18.k:
ret ptr %p3
lr.x18.m:
%lr.ret18 = call ptr @resid_mv_list(ptr %p3, ptr %lr.cx18)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret18
L951:
%t8365 = call i64 @resid_char_at_n(ptr %p0, i64 %p1, i64 %p0.alen)
%t8366 = call i64 @cose_nibble(i64 %t8365)
%t8367 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t8366, i64 16)
%t8368 = extractvalue {i64, i1} %t8367, 0
%t8369 = extractvalue {i64, i1} %t8367, 1
%t8370 = zext i1 %t8369 to i8
call void @resid_overflow_check(i8 %t8370)
%t8371 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t8372 = extractvalue {i64, i1} %t8371, 0
%t8373 = extractvalue {i64, i1} %t8371, 1
%t8374 = zext i1 %t8373 to i8
call void @resid_overflow_check(i8 %t8374)
%t8375 = call i64 @resid_char_at_n(ptr %p0, i64 %t8372, i64 %p0.alen)
%t8376 = call i64 @cose_nibble(i64 %t8375)
%t8377 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t8368, i64 %t8376)
%t8378 = extractvalue {i64, i1} %t8377, 0
%t8379 = extractvalue {i64, i1} %t8377, 1
%t8380 = zext i1 %t8379 to i8
call void @resid_overflow_check(i8 %t8380)
%t8381 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t8382 = extractvalue {i64, i1} %t8381, 0
%t8383 = extractvalue {i64, i1} %t8381, 1
%t8384 = zext i1 %t8383 to i8
call void @resid_overflow_check(i8 %t8384)
%t8387 = call ptr @resid_box_i64(i64 %t8378)
%t8389 = getelementptr i8, ptr %t8385, i64 0
store ptr %t8387, ptr %t8389
%t8390 = call ptr @resid_list_new(i64 1, ptr %t8385, ptr @.lty8385)
%t8391 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t8390)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p3.e.tco.s0 = call ptr @resid_mv_list(ptr %t8391, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t8391, %tco.s0 ]
br label %tco.head
}
define ptr @cose_hex_decode(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8393 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB8393)
%t8394 = call i64 @str_len(ptr %p0)
%t8395 = call ptr @cose_hex_acc(ptr %p0, i64 0, i64 %t8394, ptr %t8393)
ret ptr %t8395
}
define ptr @cose_sig_structure(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8397 = call ptr @resid_list_const_i64(ptr @.lc8396, i64 12, ptr @.lcd8396, ptr @.lty8396)
%t8398 = call ptr @cbe_bytes(ptr %p0, ptr %t8397)
%t8400 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty8399)
%t8401 = call ptr @cbe_bytes(ptr %t8400, ptr %t8398)
%t8402 = musttail call ptr @cbe_bytes(ptr %p1, ptr %t8401)
ret ptr %t8402
}
define ptr @cose_sign1_protected(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8403 = call ptr @bytes_of(ptr %p0)
%t8404 = call ptr @resid_list_freeze(ptr %t8403)
%t8406 = call ptr @resid_list_const_i64(ptr @.lc8405, i64 4, ptr @.lcd8405, ptr @.lty8405)
%t8407 = call ptr @cbe_bytes(ptr %t8404, ptr %t8406)
ret ptr %t8407
}
define ptr @cose_sign1_err(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8408 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB8408)
%t8409 = call ptr @resid_gmalloc(i64 48)
%t8409.f0 = getelementptr i8, ptr %t8409, i64 0
store i1 false, ptr %t8409.f0, align 8
%t8409.f1 = getelementptr i8, ptr %t8409, i64 8
store ptr %p0, ptr %t8409.f1, align 8
%t8409.f2 = getelementptr i8, ptr %t8409, i64 16
store ptr @.s8410, ptr %t8409.f2, align 8
%t8409.f3 = getelementptr i8, ptr %t8409, i64 24
store ptr %t8408, ptr %t8409.f3, align 8
%t8409.f4 = getelementptr i8, ptr %t8409, i64 32
store ptr %t8408, ptr %t8409.f4, align 8
%t8409.f5 = getelementptr i8, ptr %t8409, i64 40
store ptr %t8408, ptr %t8409.f5, align 8
ret ptr %t8409
}
define ptr @cose_kid_of(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8411 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t8412 = getelementptr i8, ptr %t8411, i64 0
%t8413 = load i1, ptr %t8412, align 8
%t8414 = xor i1 %t8413, true
br label %LSL8415
LSL8415:
br i1 %t8414, label %LSJ8415, label %LSR8415
LSR8415:
%t8416 = getelementptr i8, ptr %t8411, i64 8
%t8417 = load i64, ptr %t8416, align 8
%t8418 = icmp ne i64 %t8417, 5
br label %LSJ8415
LSJ8415:
%t8419 = phi i1 [ true, %LSL8415 ], [ %t8418, %LSR8415 ]
br i1 %t8419, label %L952, label %L954
L952:
ret ptr @.s8420
L954:
%t8421 = getelementptr i8, ptr %t8411, i64 24
%t8422 = load i64, ptr %t8421, align 8
%t8423 = getelementptr i8, ptr %t8411, i64 16
%t8424 = load i64, ptr %t8423, align 8
%t8425 = call ptr @cose_kid_scan(ptr %p0, i64 %t8422, i64 %t8424)
ret ptr %t8425
}
define ptr @cose_kid_scan(ptr %p0.in, i64 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8504, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t8505, %tco.s0.k ]
%t8426 = icmp sle i64 %p2, 0
br i1 %t8426, label %L955, label %L957
L955:
%lr.cx10 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz10 = icmp eq ptr %lr.cx10, null
br i1 %lr.lz10, label %lr.x10.k, label %lr.x10.m
lr.x10.k:
ret ptr @.s8427
lr.x10.m:
%lr.ret10 = call ptr @resid_mv_str(ptr @.s8427, ptr %lr.cx10)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret10
L957:
%t8428 = call ptr @cbe_read_head(ptr %p0, i64 %p1)
%t8429 = getelementptr i8, ptr %t8428, i64 0
%t8430 = load i1, ptr %t8429, align 8
%t8431 = xor i1 %t8430, true
br i1 %t8431, label %L958, label %L960
L958:
%lr.cx18 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz18 = icmp eq ptr %lr.cx18, null
br i1 %lr.lz18, label %lr.x18.k, label %lr.x18.m
lr.x18.k:
ret ptr @.s8432
lr.x18.m:
%lr.ret18 = call ptr @resid_mv_str(ptr @.s8432, ptr %lr.cx18)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret18
L960:
%t8433 = getelementptr i8, ptr %t8428, i64 24
%t8434 = load i64, ptr %t8433, align 8
%t8435 = call ptr @cbe_read_head(ptr %p0, i64 %t8434)
%t8436 = getelementptr i8, ptr %t8435, i64 0
%t8437 = load i1, ptr %t8436, align 8
%t8438 = xor i1 %t8437, true
br i1 %t8438, label %L961, label %L963
L961:
%lr.cx28 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz28 = icmp eq ptr %lr.cx28, null
br i1 %lr.lz28, label %lr.x28.k, label %lr.x28.m
lr.x28.k:
ret ptr @.s8439
lr.x28.m:
%lr.ret28 = call ptr @resid_mv_str(ptr @.s8439, ptr %lr.cx28)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret28
L963:
%t8440 = getelementptr i8, ptr %t8428, i64 8
%t8441 = load i64, ptr %t8440, align 8
%t8442 = icmp eq i64 %t8441, 0
br label %LSL8443
LSL8443:
br i1 %t8442, label %LSR8443, label %LSJ8443
LSR8443:
%t8444 = getelementptr i8, ptr %t8428, i64 16
%t8445 = load i64, ptr %t8444, align 8
%t8446 = icmp eq i64 %t8445, 4
br label %LSJ8443
LSJ8443:
%t8447 = phi i1 [ false, %LSL8443 ], [ %t8446, %LSR8443 ]
br label %LSL8448
LSL8448:
br i1 %t8447, label %LSR8448, label %LSJ8448
LSR8448:
%t8449 = getelementptr i8, ptr %t8435, i64 8
%t8450 = load i64, ptr %t8449, align 8
%t8451 = icmp eq i64 %t8450, 2
br label %LSJ8448
LSJ8448:
%t8452 = phi i1 [ false, %LSL8448 ], [ %t8451, %LSR8448 ]
br i1 %t8452, label %L964, label %L966
L964:
%t8453 = getelementptr i8, ptr %t8428, i64 24
%t8454 = load i64, ptr %t8453, align 8
%t8455 = call ptr @cbe_read_str(ptr %p0, i64 %t8454, i64 2)
%t8456 = getelementptr i8, ptr %t8455, i64 8
%t8457 = load ptr, ptr %t8456, align 8
%t8459 = call ptr @cbe_ascii(ptr %t8457, i64 0, ptr @.s8458)
%lr.cx61 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz61 = icmp eq ptr %lr.cx61, null
br i1 %lr.lz61, label %lr.x61.k, label %lr.x61.m
lr.x61.k:
ret ptr %t8459
lr.x61.m:
%lr.ret61 = call ptr @resid_mv_str(ptr %t8459, ptr %lr.cx61)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret61
L966:
%t8460 = getelementptr i8, ptr %t8435, i64 8
%t8461 = load i64, ptr %t8460, align 8
%t8462 = icmp eq i64 %t8461, 2
br label %LSL8463
LSL8463:
br i1 %t8462, label %LSJ8463, label %LSR8463
LSR8463:
%t8464 = getelementptr i8, ptr %t8435, i64 8
%t8465 = load i64, ptr %t8464, align 8
%t8466 = icmp eq i64 %t8465, 3
br label %LSJ8463
LSJ8463:
%t8467 = phi i1 [ true, %LSL8463 ], [ %t8466, %LSR8463 ]
br label %LSL8468
LSL8468:
br i1 %t8467, label %LSR8468, label %LSJ8468
LSR8468:
%t8469 = getelementptr i8, ptr %t8435, i64 16
%t8470 = load i64, ptr %t8469, align 8
%t8471 = icmp slt i64 %t8470, 0
br label %LSL8472
LSL8472:
br i1 %t8471, label %LSJ8472, label %LSR8472
LSR8472:
%t8473 = getelementptr i8, ptr %t8435, i64 16
%t8474 = load i64, ptr %t8473, align 8
%t8475 = call i64 @resid_list_len(ptr %p0)
%t8476 = getelementptr i8, ptr %t8435, i64 24
%t8477 = load i64, ptr %t8476, align 8
%t8478 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t8475, i64 %t8477)
%t8479 = extractvalue {i64, i1} %t8478, 0
%t8480 = extractvalue {i64, i1} %t8478, 1
%t8481 = zext i1 %t8480 to i8
call void @resid_overflow_check(i8 %t8481)
%t8482 = icmp sgt i64 %t8474, %t8479
br label %LSJ8472
LSJ8472:
%t8483 = phi i1 [ true, %LSL8472 ], [ %t8482, %LSR8472 ]
br label %LSJ8468
LSJ8468:
%t8484 = phi i1 [ false, %LSL8468 ], [ %t8483, %LSJ8472 ]
br i1 %t8484, label %L967, label %L969
L967:
%lr.cx106 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz106 = icmp eq ptr %lr.cx106, null
br i1 %lr.lz106, label %lr.x106.k, label %lr.x106.m
lr.x106.k:
ret ptr @.s8485
lr.x106.m:
%lr.ret106 = call ptr @resid_mv_str(ptr @.s8485, ptr %lr.cx106)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret106
L969:
%t8486 = getelementptr i8, ptr %t8435, i64 8
%t8487 = load i64, ptr %t8486, align 8
%t8488 = icmp eq i64 %t8487, 2
br label %LSL8489
LSL8489:
br i1 %t8488, label %LSJ8489, label %LSR8489
LSR8489:
%t8490 = getelementptr i8, ptr %t8435, i64 8
%t8491 = load i64, ptr %t8490, align 8
%t8492 = icmp eq i64 %t8491, 3
br label %LSJ8489
LSJ8489:
%t8493 = phi i1 [ true, %LSL8489 ], [ %t8492, %LSR8489 ]
br i1 %t8493, label %L970, label %L971
L970:
%t8494 = getelementptr i8, ptr %t8435, i64 24
%t8495 = load i64, ptr %t8494, align 8
%t8496 = getelementptr i8, ptr %t8435, i64 16
%t8497 = load i64, ptr %t8496, align 8
%t8498 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t8495, i64 %t8497)
%t8499 = extractvalue {i64, i1} %t8498, 0
%t8500 = extractvalue {i64, i1} %t8498, 1
%t8501 = zext i1 %t8500 to i8
call void @resid_overflow_check(i8 %t8501)
br label %L972
L971:
%t8502 = getelementptr i8, ptr %t8435, i64 24
%t8503 = load i64, ptr %t8502, align 8
br label %L972
L972:
%t8504 = phi i64 [ %t8499, %L970 ], [ %t8503, %L971 ]
%t8505 = sub nsw i64 %p2, 1
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
%t8507 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t8508 = getelementptr i8, ptr %t8507, i64 0
%t8509 = load i1, ptr %t8508, align 8
%t8510 = xor i1 %t8509, true
br label %LSL8511
LSL8511:
br i1 %t8510, label %LSJ8511, label %LSR8511
LSR8511:
%t8512 = getelementptr i8, ptr %t8507, i64 8
%t8513 = load i64, ptr %t8512, align 8
%t8514 = icmp ne i64 %t8513, 6
br label %LSJ8511
LSJ8511:
%t8515 = phi i1 [ true, %LSL8511 ], [ %t8514, %LSR8511 ]
br label %LSL8516
LSL8516:
br i1 %t8515, label %LSJ8516, label %LSR8516
LSR8516:
%t8517 = getelementptr i8, ptr %t8507, i64 16
%t8518 = load i64, ptr %t8517, align 8
%t8519 = icmp ne i64 %t8518, 18
br label %LSJ8516
LSJ8516:
%t8520 = phi i1 [ true, %LSL8516 ], [ %t8519, %LSR8516 ]
br i1 %t8520, label %L973, label %L975
L973:
%t8522 = musttail call ptr @cose_sign1_err(ptr @.s8521)
ret ptr %t8522
L975:
%t8523 = getelementptr i8, ptr %t8507, i64 24
%t8524 = load i64, ptr %t8523, align 8
%t8525 = call ptr @cbe_read_head(ptr %p0, i64 %t8524)
%t8526 = getelementptr i8, ptr %t8525, i64 0
%t8527 = load i1, ptr %t8526, align 8
%t8528 = xor i1 %t8527, true
br label %LSL8529
LSL8529:
br i1 %t8528, label %LSJ8529, label %LSR8529
LSR8529:
%t8530 = getelementptr i8, ptr %t8525, i64 8
%t8531 = load i64, ptr %t8530, align 8
%t8532 = icmp ne i64 %t8531, 4
br label %LSJ8529
LSJ8529:
%t8533 = phi i1 [ true, %LSL8529 ], [ %t8532, %LSR8529 ]
br label %LSL8534
LSL8534:
br i1 %t8533, label %LSJ8534, label %LSR8534
LSR8534:
%t8535 = getelementptr i8, ptr %t8525, i64 16
%t8536 = load i64, ptr %t8535, align 8
%t8537 = icmp ne i64 %t8536, 4
br label %LSJ8534
LSJ8534:
%t8538 = phi i1 [ true, %LSL8534 ], [ %t8537, %LSR8534 ]
br i1 %t8538, label %L976, label %L978
L976:
%t8540 = musttail call ptr @cose_sign1_err(ptr @.s8539)
ret ptr %t8540
L978:
%t8541 = getelementptr i8, ptr %t8525, i64 24
%t8542 = load i64, ptr %t8541, align 8
%t8543 = call ptr @cbe_read_str(ptr %p0, i64 %t8542, i64 2)
%t8544 = getelementptr i8, ptr %t8543, i64 0
%t8545 = load i1, ptr %t8544, align 8
%t8546 = xor i1 %t8545, true
br i1 %t8546, label %L979, label %L981
L979:
%t8548 = musttail call ptr @cose_sign1_err(ptr @.s8547)
ret ptr %t8548
L981:
%t8549 = getelementptr i8, ptr %t8543, i64 16
%t8550 = load i64, ptr %t8549, align 8
%t8551 = call ptr @cbe_read_head(ptr %p0, i64 %t8550)
%t8552 = getelementptr i8, ptr %t8551, i64 0
%t8553 = load i1, ptr %t8552, align 8
%t8554 = xor i1 %t8553, true
br label %LSL8555
LSL8555:
br i1 %t8554, label %LSJ8555, label %LSR8555
LSR8555:
%t8556 = getelementptr i8, ptr %t8551, i64 8
%t8557 = load i64, ptr %t8556, align 8
%t8558 = icmp ne i64 %t8557, 5
br label %LSJ8555
LSJ8555:
%t8559 = phi i1 [ true, %LSL8555 ], [ %t8558, %LSR8555 ]
br label %LSL8560
LSL8560:
br i1 %t8559, label %LSJ8560, label %LSR8560
LSR8560:
%t8561 = getelementptr i8, ptr %t8551, i64 16
%t8562 = load i64, ptr %t8561, align 8
%t8563 = icmp ne i64 %t8562, 0
br label %LSJ8560
LSJ8560:
%t8564 = phi i1 [ true, %LSL8560 ], [ %t8563, %LSR8560 ]
br i1 %t8564, label %L982, label %L984
L982:
%t8566 = musttail call ptr @cose_sign1_err(ptr @.s8565)
ret ptr %t8566
L984:
%t8567 = getelementptr i8, ptr %t8551, i64 24
%t8568 = load i64, ptr %t8567, align 8
%t8569 = call ptr @cbe_read_str(ptr %p0, i64 %t8568, i64 2)
%t8570 = getelementptr i8, ptr %t8569, i64 0
%t8571 = load i1, ptr %t8570, align 8
%t8572 = xor i1 %t8571, true
br i1 %t8572, label %L985, label %L987
L985:
%t8574 = musttail call ptr @cose_sign1_err(ptr @.s8573)
ret ptr %t8574
L987:
%t8575 = getelementptr i8, ptr %t8569, i64 16
%t8576 = load i64, ptr %t8575, align 8
%t8577 = call ptr @cbe_read_str(ptr %p0, i64 %t8576, i64 2)
%t8578 = getelementptr i8, ptr %t8577, i64 0
%t8579 = load i1, ptr %t8578, align 8
%t8580 = xor i1 %t8579, true
br label %LSL8581
LSL8581:
br i1 %t8580, label %LSJ8581, label %LSR8581
LSR8581:
%t8582 = getelementptr i8, ptr %t8577, i64 8
%t8583 = load ptr, ptr %t8582, align 8
%t8584 = call i64 @resid_list_len(ptr %t8583)
%t8585 = icmp ne i64 %t8584, 64
br label %LSJ8581
LSJ8581:
%t8586 = phi i1 [ true, %LSL8581 ], [ %t8585, %LSR8581 ]
br i1 %t8586, label %L988, label %L990
L988:
%t8588 = musttail call ptr @cose_sign1_err(ptr @.s8587)
ret ptr %t8588
L990:
%t8589 = call ptr @resid_gmalloc(i64 48)
%t8589.f0 = getelementptr i8, ptr %t8589, i64 0
store i1 true, ptr %t8589.f0, align 8
%t8589.f1 = getelementptr i8, ptr %t8589, i64 8
store ptr @.s8590, ptr %t8589.f1, align 8
%t8591 = getelementptr i8, ptr %t8543, i64 8
%t8592 = load ptr, ptr %t8591, align 8
%t8593 = call ptr @cose_kid_of(ptr %t8592)
%t8589.f2 = getelementptr i8, ptr %t8589, i64 16
store ptr %t8593, ptr %t8589.f2, align 8
%t8594 = getelementptr i8, ptr %t8543, i64 8
%t8595 = load ptr, ptr %t8594, align 8
%t8589.f3 = getelementptr i8, ptr %t8589, i64 24
store ptr %t8595, ptr %t8589.f3, align 8
%t8596 = getelementptr i8, ptr %t8569, i64 8
%t8597 = load ptr, ptr %t8596, align 8
%t8589.f4 = getelementptr i8, ptr %t8589, i64 32
store ptr %t8597, ptr %t8589.f4, align 8
%t8598 = getelementptr i8, ptr %t8577, i64 8
%t8599 = load ptr, ptr %t8598, align 8
%t8589.f5 = getelementptr i8, ptr %t8589, i64 40
store ptr %t8599, ptr %t8589.f5, align 8
ret ptr %t8589
}
define i1 @cose_sign1_check(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8600 = getelementptr i8, ptr %p0, i64 24
%t8601 = load ptr, ptr %t8600, align 8
%t8602 = getelementptr i8, ptr %p0, i64 32
%t8603 = load ptr, ptr %t8602, align 8
%t8604 = call ptr @cose_sig_structure(ptr %t8601, ptr %t8603)
%t8605 = call ptr @resid_list_freeze(ptr %t8604)
%t8606 = getelementptr i8, ptr %p0, i64 40
%t8607 = load ptr, ptr %t8606, align 8
%t8608 = call i1 @verify_sig_bytes(ptr %t8605, ptr %t8607, ptr %p1)
ret i1 %t8608
}
define ptr @cose_enc_structure(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8610 = call ptr @resid_list_new(i64 0, ptr null, ptr @.lty8609)
%t8612 = call ptr @resid_list_const_i64(ptr @.lc8611, i64 10, ptr @.lcd8611, ptr @.lty8611)
%t8613 = call ptr @cbe_bytes(ptr %p0, ptr %t8612)
%t8614 = call ptr @cbe_bytes(ptr %t8610, ptr %t8613)
ret ptr %t8614
}
define ptr @cose_encrypt0_protected() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8616 = call ptr @resid_list_const_i64(ptr @.lc8615, i64 4, ptr @.lcd8615, ptr @.lty8615)
ret ptr %t8616
}
define ptr @cose_encrypt0_nonce(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8618 = call ptr @resid_list_const_i64(ptr @.lc8617, i64 25, ptr @.lcd8617, ptr @.lty8617)
%t8619 = call ptr @resid_list_concat(ptr %t8618, ptr %p0)
%t8620 = call ptr @bytes_of(ptr %p1)
%t8621 = call ptr @resid_list_freeze(ptr %t8620)
%t8622 = call ptr @resid_list_concat_own(ptr %t8619, i8 1, ptr %t8621)
%t8623 = call ptr @resid_list_concat_own(ptr %t8622, i8 1, ptr %p2)
%t8624 = call ptr @sha256_bytes(ptr %t8623)
%t8625 = call ptr @slice_bytes(ptr %t8624, i64 0, i64 11)
ret ptr %t8625
}
define ptr @cose_encrypt0_seal(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8626 = call ptr @cose_encrypt0_nonce(ptr %p1, ptr %p2, ptr %p0)
%t8627 = call ptr @resid_list_freeze(ptr %t8626)
%t8629 = call ptr @resid_list_const_i64(ptr @.lc8628, i64 16, ptr @.lcd8628, ptr @.lty8628)
%t8630 = call ptr @chacha20poly1305_seal(ptr %p1, ptr %t8627, ptr %p0, ptr %t8629)
%t8631 = call ptr @resid_list_freeze(ptr %t8630)
%t8633 = call ptr @resid_list_const_i64(ptr @.lc8632, i64 9, ptr @.lcd8632, ptr @.lty8632)
%t8634 = call ptr @cbe_bytes(ptr %t8627, ptr %t8633)
%t8635 = call ptr @cbe_bytes(ptr %t8631, ptr %t8634)
ret ptr %t8635
}
define ptr @cose_open_err(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8636 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB8636)
%t8637 = call ptr @resid_gmalloc(i64 24)
%t8637.f0 = getelementptr i8, ptr %t8637, i64 0
store i1 false, ptr %t8637.f0, align 8
%t8637.f1 = getelementptr i8, ptr %t8637, i64 8
store ptr %p0, ptr %t8637.f1, align 8
%t8637.f2 = getelementptr i8, ptr %t8637, i64 16
store ptr %t8636, ptr %t8637.f2, align 8
ret ptr %t8637
}
define i1 @cose_is_encrypt0(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8638 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t8639 = getelementptr i8, ptr %t8638, i64 0
%t8640 = load i1, ptr %t8639, align 8
br label %LSL8641
LSL8641:
br i1 %t8640, label %LSR8641, label %LSJ8641
LSR8641:
%t8642 = getelementptr i8, ptr %t8638, i64 8
%t8643 = load i64, ptr %t8642, align 8
%t8644 = icmp eq i64 %t8643, 6
br label %LSJ8641
LSJ8641:
%t8645 = phi i1 [ false, %LSL8641 ], [ %t8644, %LSR8641 ]
br label %LSL8646
LSL8646:
br i1 %t8645, label %LSR8646, label %LSJ8646
LSR8646:
%t8647 = getelementptr i8, ptr %t8638, i64 16
%t8648 = load i64, ptr %t8647, align 8
%t8649 = icmp eq i64 %t8648, 16
br label %LSJ8646
LSJ8646:
%t8650 = phi i1 [ false, %LSL8646 ], [ %t8649, %LSR8646 ]
ret i1 %t8650
}
define ptr @cose_encrypt0_open(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8651 = call ptr @cbe_read_head(ptr %p0, i64 0)
%t8652 = getelementptr i8, ptr %t8651, i64 0
%t8653 = load i1, ptr %t8652, align 8
%t8654 = xor i1 %t8653, true
br label %LSL8655
LSL8655:
br i1 %t8654, label %LSJ8655, label %LSR8655
LSR8655:
%t8656 = getelementptr i8, ptr %t8651, i64 8
%t8657 = load i64, ptr %t8656, align 8
%t8658 = icmp ne i64 %t8657, 6
br label %LSJ8655
LSJ8655:
%t8659 = phi i1 [ true, %LSL8655 ], [ %t8658, %LSR8655 ]
br label %LSL8660
LSL8660:
br i1 %t8659, label %LSJ8660, label %LSR8660
LSR8660:
%t8661 = getelementptr i8, ptr %t8651, i64 16
%t8662 = load i64, ptr %t8661, align 8
%t8663 = icmp ne i64 %t8662, 16
br label %LSJ8660
LSJ8660:
%t8664 = phi i1 [ true, %LSL8660 ], [ %t8663, %LSR8660 ]
br i1 %t8664, label %L991, label %L993
L991:
%t8666 = call ptr @cose_open_err(ptr @.s8665)
ret ptr %t8666
L993:
%t8667 = getelementptr i8, ptr %t8651, i64 24
%t8668 = load i64, ptr %t8667, align 8
%t8669 = call ptr @cbe_read_head(ptr %p0, i64 %t8668)
%t8670 = getelementptr i8, ptr %t8669, i64 0
%t8671 = load i1, ptr %t8670, align 8
%t8672 = xor i1 %t8671, true
br label %LSL8673
LSL8673:
br i1 %t8672, label %LSJ8673, label %LSR8673
LSR8673:
%t8674 = getelementptr i8, ptr %t8669, i64 8
%t8675 = load i64, ptr %t8674, align 8
%t8676 = icmp ne i64 %t8675, 4
br label %LSJ8673
LSJ8673:
%t8677 = phi i1 [ true, %LSL8673 ], [ %t8676, %LSR8673 ]
br label %LSL8678
LSL8678:
br i1 %t8677, label %LSJ8678, label %LSR8678
LSR8678:
%t8679 = getelementptr i8, ptr %t8669, i64 16
%t8680 = load i64, ptr %t8679, align 8
%t8681 = icmp ne i64 %t8680, 3
br label %LSJ8678
LSJ8678:
%t8682 = phi i1 [ true, %LSL8678 ], [ %t8681, %LSR8678 ]
br i1 %t8682, label %L994, label %L996
L994:
%t8684 = call ptr @cose_open_err(ptr @.s8683)
ret ptr %t8684
L996:
%t8685 = getelementptr i8, ptr %t8669, i64 24
%t8686 = load i64, ptr %t8685, align 8
%t8687 = call ptr @cbe_read_str(ptr %p0, i64 %t8686, i64 2)
call void @"resid.rec.freeze.CbeStr"(ptr %t8687)
%t8688 = getelementptr i8, ptr %t8687, i64 0
%t8689 = load i1, ptr %t8688, align 8
%t8690 = xor i1 %t8689, true
br i1 %t8690, label %L997, label %L999
L997:
%t8692 = call ptr @cose_open_err(ptr @.s8691)
ret ptr %t8692
L999:
%t8693 = getelementptr i8, ptr %t8687, i64 16
%t8694 = load i64, ptr %t8693, align 8
%t8695 = call ptr @cbe_read_head(ptr %p0, i64 %t8694)
%t8696 = getelementptr i8, ptr %t8695, i64 0
%t8697 = load i1, ptr %t8696, align 8
%t8698 = xor i1 %t8697, true
br label %LSL8699
LSL8699:
br i1 %t8698, label %LSJ8699, label %LSR8699
LSR8699:
%t8700 = getelementptr i8, ptr %t8695, i64 8
%t8701 = load i64, ptr %t8700, align 8
%t8702 = icmp ne i64 %t8701, 5
br label %LSJ8699
LSJ8699:
%t8703 = phi i1 [ true, %LSL8699 ], [ %t8702, %LSR8699 ]
br label %LSL8704
LSL8704:
br i1 %t8703, label %LSJ8704, label %LSR8704
LSR8704:
%t8705 = getelementptr i8, ptr %t8695, i64 16
%t8706 = load i64, ptr %t8705, align 8
%t8707 = icmp ne i64 %t8706, 1
br label %LSJ8704
LSJ8704:
%t8708 = phi i1 [ true, %LSL8704 ], [ %t8707, %LSR8704 ]
br i1 %t8708, label %L1000, label %L1002
L1000:
%t8710 = call ptr @cose_open_err(ptr @.s8709)
ret ptr %t8710
L1002:
%t8711 = getelementptr i8, ptr %t8695, i64 24
%t8712 = load i64, ptr %t8711, align 8
%t8713 = call ptr @cbe_read_head(ptr %p0, i64 %t8712)
%t8714 = getelementptr i8, ptr %t8713, i64 0
%t8715 = load i1, ptr %t8714, align 8
%t8716 = xor i1 %t8715, true
br label %LSL8717
LSL8717:
br i1 %t8716, label %LSJ8717, label %LSR8717
LSR8717:
%t8718 = getelementptr i8, ptr %t8713, i64 8
%t8719 = load i64, ptr %t8718, align 8
%t8720 = icmp ne i64 %t8719, 0
br label %LSJ8717
LSJ8717:
%t8721 = phi i1 [ true, %LSL8717 ], [ %t8720, %LSR8717 ]
br label %LSL8722
LSL8722:
br i1 %t8721, label %LSJ8722, label %LSR8722
LSR8722:
%t8723 = getelementptr i8, ptr %t8713, i64 16
%t8724 = load i64, ptr %t8723, align 8
%t8725 = icmp ne i64 %t8724, 5
br label %LSJ8722
LSJ8722:
%t8726 = phi i1 [ true, %LSL8722 ], [ %t8725, %LSR8722 ]
br i1 %t8726, label %L1003, label %L1005
L1003:
%t8728 = call ptr @cose_open_err(ptr @.s8727)
ret ptr %t8728
L1005:
%t8729 = getelementptr i8, ptr %t8713, i64 24
%t8730 = load i64, ptr %t8729, align 8
%t8731 = call ptr @cbe_read_str(ptr %p0, i64 %t8730, i64 2)
%t8732 = getelementptr i8, ptr %t8731, i64 0
%t8733 = load i1, ptr %t8732, align 8
%t8734 = xor i1 %t8733, true
br label %LSL8735
LSL8735:
br i1 %t8734, label %LSJ8735, label %LSR8735
LSR8735:
%t8736 = getelementptr i8, ptr %t8731, i64 8
%t8737 = load ptr, ptr %t8736, align 8
%t8738 = call i64 @resid_list_len(ptr %t8737)
%t8739 = icmp ne i64 %t8738, 12
br label %LSJ8735
LSJ8735:
%t8740 = phi i1 [ true, %LSL8735 ], [ %t8739, %LSR8735 ]
br i1 %t8740, label %L1006, label %L1008
L1006:
%t8742 = call ptr @cose_open_err(ptr @.s8741)
ret ptr %t8742
L1008:
%t8743 = getelementptr i8, ptr %t8731, i64 16
%t8744 = load i64, ptr %t8743, align 8
%t8745 = call ptr @cbe_read_str(ptr %p0, i64 %t8744, i64 2)
%t8746 = getelementptr i8, ptr %t8745, i64 0
%t8747 = load i1, ptr %t8746, align 8
%t8748 = xor i1 %t8747, true
br label %LSL8749
LSL8749:
br i1 %t8748, label %LSJ8749, label %LSR8749
LSR8749:
%t8750 = getelementptr i8, ptr %t8745, i64 8
%t8751 = load ptr, ptr %t8750, align 8
%t8752 = call i64 @resid_list_len(ptr %t8751)
%t8753 = icmp slt i64 %t8752, 16
br label %LSJ8749
LSJ8749:
%t8754 = phi i1 [ true, %LSL8749 ], [ %t8753, %LSR8749 ]
br i1 %t8754, label %L1009, label %L1011
L1009:
%t8756 = call ptr @cose_open_err(ptr @.s8755)
ret ptr %t8756
L1011:
%t8757 = call i64 @resid_scope_push()
%t8758 = getelementptr i8, ptr %t8731, i64 8
%t8759 = load ptr, ptr %t8758, align 8
%t8760 = getelementptr i8, ptr %t8745, i64 8
%t8761 = load ptr, ptr %t8760, align 8
%t8762 = getelementptr i8, ptr %t8687, i64 8
%t8763 = load ptr, ptr %t8762, align 8
%t8764 = call ptr @cose_enc_structure(ptr %t8763)
%t8765 = call ptr @resid_list_freeze(ptr %t8764)
%t8766 = call i1 @chacha20poly1305_open(ptr %p1, ptr %t8759, ptr %t8761, ptr %t8765)
call void @resid_scope_pop(i64 %t8757)
%t8767 = xor i1 %t8766, true
br i1 %t8767, label %L1012, label %L1014
L1012:
%t8769 = call ptr @cose_open_err(ptr @.s8768)
ret ptr %t8769
L1014:
%t8770 = getelementptr i8, ptr %t8745, i64 8
%t8771 = load ptr, ptr %t8770, align 8
%t8772 = getelementptr i8, ptr %t8745, i64 8
%t8773 = load ptr, ptr %t8772, align 8
%t8774 = call i64 @resid_list_len(ptr %t8773)
%t8775 = sub nsw i64 %t8774, 17
%t8776 = call ptr @slice_bytes(ptr %t8771, i64 0, i64 %t8775)
%t8777 = call ptr @resid_gmalloc(i64 24)
%t8777.f0 = getelementptr i8, ptr %t8777, i64 0
store i1 true, ptr %t8777.f0, align 8
%t8777.f1 = getelementptr i8, ptr %t8777, i64 8
store ptr @.s8778, ptr %t8777.f1, align 8
%t8779 = getelementptr i8, ptr %t8731, i64 8
%t8780 = load ptr, ptr %t8779, align 8
%t8781 = call ptr @chacha20_xor(ptr %p1, i64 1, ptr %t8780, ptr %t8776)
%t8777.f2 = getelementptr i8, ptr %t8777, i64 16
store ptr %t8781, ptr %t8777.f2, align 8
ret ptr %t8777
}
define ptr @stream(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
call void @resid_cap_check(ptr @resid.cap.stream)
%t8782 = call ptr @resid_fs_read_all(ptr %p0)
%t8783 = call ptr @str_trim(ptr %t8782)
%t8784 = musttail call ptr @cose_hex_decode(ptr %t8783)
ret ptr %t8784
}
define ptr @h(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8785 = call ptr @bn_to_be(ptr %p0, i64 0)
%t8786 = musttail call ptr @hex_encode(ptr %t8785)
ret ptr %t8786
}
define ptr @join__sacc(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8789, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8803, %tco.s0 ]
%t8787 = call i64 @resid_list_len(ptr %p0)
%t8788 = icmp sge i64 %p1, %t8787
br i1 %t8788, label %L1015, label %L1017
L1015:
ret ptr %p2
L1017:
%t8789 = add nsw i64 %p1, 1
%t8790 = icmp sgt i64 %p1, 0
br i1 %t8790, label %L1018, label %L1019
L1018:
br label %L1020
L1019:
br label %L1020
L1020:
%t8793 = phi ptr [ @.s8791, %L1018 ], [ @.s8792, %L1019 ]
%t8794 = call ptr @resid_sacc_append(ptr %p2, ptr %t8793)
%t8796 = call ptr @resid_sacc_append(ptr %t8794, ptr @.s8795)
%t8797 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t8800 = call ptr @h(ptr %t8797)
%t8801 = call ptr @resid_sacc_append(ptr %t8796, ptr %t8800)
%t8803 = call ptr @resid_sacc_append(ptr %t8801, ptr @.s8802)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @responses__sacc(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t8839, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t8845, %tco.s0 ]
%t8805 = call i64 @resid_list_len(ptr %p0)
%t8806 = icmp sge i64 %p1, %t8805
br i1 %t8806, label %L1021, label %L1023
L1021:
ret ptr %p2
L1023:
%t8807 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t8811 = getelementptr i8, ptr %t8807, i64 0
%t8812 = load i1, ptr %t8811, align 8
br i1 %t8812, label %L1024, label %L1025
L1024:
br label %L1026
L1025:
br label %L1026
L1026:
%t8815 = phi ptr [ @.s8813, %L1024 ], [ @.s8814, %L1025 ]
%t8816 = call ptr @resid_str_concat(ptr @.s8810, ptr %t8815)
%t8818 = call ptr @resid_str_concat(ptr %t8816, ptr @.s8817)
%t8819 = getelementptr i8, ptr %t8807, i64 8
%t8820 = load i1, ptr %t8819, align 8
br i1 %t8820, label %L1027, label %L1028
L1027:
br label %L1029
L1028:
br label %L1029
L1029:
%t8823 = phi ptr [ @.s8821, %L1027 ], [ @.s8822, %L1028 ]
%t8824 = call ptr @resid_str_concat(ptr %t8818, ptr %t8823)
%t8826 = call ptr @resid_str_concat(ptr %t8824, ptr @.s8825)
%t8827 = getelementptr i8, ptr %t8807, i64 16
%t8828 = load ptr, ptr %t8827, align 8
%t8829 = call ptr @h(ptr %t8828)
%t8830 = call ptr @resid_str_concat(ptr %t8826, ptr %t8829)
%t8832 = call ptr @resid_str_concat(ptr %t8830, ptr @.s8831)
%t8833 = getelementptr i8, ptr %t8807, i64 24
%t8834 = load ptr, ptr %t8833, align 8
%t8835 = call ptr @h(ptr %t8834)
%t8836 = call ptr @resid_str_concat(ptr %t8832, ptr %t8835)
%t8838 = call ptr @resid_str_concat(ptr %t8836, ptr @.s8837)
%t8839 = add nsw i64 %p1, 1
%t8840 = icmp sgt i64 %p1, 0
br i1 %t8840, label %L1030, label %L1031
L1030:
br label %L1032
L1031:
br label %L1032
L1032:
%t8843 = phi ptr [ @.s8841, %L1030 ], [ @.s8842, %L1031 ]
%t8844 = call ptr @resid_sacc_append(ptr %p2, ptr %t8843)
%t8845 = call ptr @resid_sacc_append(ptr %t8844, ptr %t8838)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i32 @resid_user_main() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
call void @resid_cap_check(ptr @resid.cap.main)
%t8847 = call ptr @resid_args_get(i64 1)
%t8848 = call ptr @cose_hex_decode(ptr %t8847)
%t8849 = call ptr @resid_list_freeze(ptr %t8848)
%t8850 = call ptr @bn_from_be(ptr %t8849)
%t8851 = call ptr @resid_list_freeze(ptr %t8850)
call void @resid_cap_check(ptr @resid.cap.main.1)
%t8852 = call ptr @resid_args_get(i64 2)
%t8853 = call ptr @cose_hex_decode(ptr %t8852)
%t8854 = call ptr @resid_list_freeze(ptr %t8853)
%t8855 = call ptr @bn_from_be(ptr %t8854)
%t8856 = call ptr @resid_list_freeze(ptr %t8855)
call void @resid_cap_check(ptr @resid.cap.main.2)
%t8857 = call ptr @resid_args_get(i64 3)
%t8858 = call ptr @stream(ptr %t8857)
%t8859 = call ptr @resid_list_freeze(ptr %t8858)
%t8860 = call ptr @pedersen_generate(ptr %t8851, ptr %t8856, ptr %t8859)
%t8861 = getelementptr {i32, i32, ptr}, ptr %t8860, i32 0, i32 0
%t8862w = load i32, ptr %t8861
%t8862 = sext i32 %t8862w to i64
%t8863 = icmp eq i64 %t8862, 1
br i1 %t8863, label %L1034, label %L1033
L1033:
%t8864 = call i64 @fail()
br label %L1035
L1034:
%t8865 = getelementptr {i32, i32, ptr}, ptr %t8860, i32 1
%t8866 = getelementptr i8, ptr %t8865, i64 0
%t8867 = getelementptr ptr, ptr %t8866, i32 0
%t8868 = load ptr, ptr %t8867
call void @resid_cap_check(ptr @resid.cap.main.3)
%t8869 = call ptr @resid_args_get(i64 4)
%t8870 = call ptr @stream(ptr %t8869)
%t8871 = call ptr @resid_list_freeze(ptr %t8870)
call void @resid_cap_check(ptr @resid.cap.main.4)
%t8872 = call ptr @resid_args_get(i64 5)
%t8873 = call ptr @stream(ptr %t8872)
%t8874 = call ptr @resid_list_freeze(ptr %t8873)
%t8875 = call i64 @emit(ptr %t8851, ptr %t8856, ptr %t8868, ptr %t8871, ptr %t8874)
br label %L1035
L1035:
%t8876 = phi i64 [ %t8864, %L1033 ], [ %t8875, %L1034 ]
%t8877 = trunc i64 %t8876 to i32
ret i32 %t8877
}
define i64 @emit(ptr %p0, ptr %p1, ptr %p2, ptr %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8878 = getelementptr i8, ptr %p2, i64 8
%t8879 = load ptr, ptr %t8878, align 8
%t8880 = getelementptr i8, ptr %p2, i64 16
%t8881 = load ptr, ptr %t8880, align 8
%t8882 = getelementptr i8, ptr %p2, i64 0
%t8883 = load ptr, ptr %t8882, align 8
%t8884 = call ptr @tr_new()
call void @"resid.rec.freeze.Transcript"(ptr %t8884)
%t8885 = call ptr @prm_prove(ptr %t8879, ptr %t8881, ptr %t8883, ptr %t8884, ptr %p3)
%t8886 = call ptr @tr_new()
call void @"resid.rec.freeze.Transcript"(ptr %t8886)
%t8887 = call ptr @mod_prove(ptr %p0, ptr %p1, ptr %t8886, ptr %p4)
%t8888 = getelementptr {i32, i32, ptr}, ptr %t8885, i32 0, i32 0
%t8889w = load i32, ptr %t8888
%t8889 = sext i32 %t8889w to i64
%t8890 = icmp eq i64 %t8889, 1
br i1 %t8890, label %L1037, label %L1036
L1036:
%t8891 = call i64 @fail()
br label %L1038
L1037:
%t8892 = getelementptr {i32, i32, ptr}, ptr %t8885, i32 1
%t8893 = getelementptr i8, ptr %t8892, i64 0
%t8894 = getelementptr ptr, ptr %t8893, i32 0
%t8895 = load ptr, ptr %t8894
%t8896 = getelementptr {i32, i32, ptr}, ptr %t8887, i32 0, i32 0
%t8897w = load i32, ptr %t8896
%t8897 = sext i32 %t8897w to i64
%t8898 = icmp eq i64 %t8897, 1
br i1 %t8898, label %L1040, label %L1039
L1039:
%t8899 = call i64 @fail()
br label %L1041
L1040:
%t8900 = getelementptr {i32, i32, ptr}, ptr %t8887, i32 1
%t8901 = getelementptr i8, ptr %t8900, i64 0
%t8902 = getelementptr ptr, ptr %t8901, i32 0
%t8903 = load ptr, ptr %t8902
%t8904 = call i64 @print_both(ptr %p2, ptr %t8895, ptr %t8903)
br label %L1041
L1041:
%t8905 = phi i64 [ %t8899, %L1039 ], [ %t8904, %L1040 ]
br label %L1038
L1038:
%t8906 = phi i64 [ %t8891, %L1036 ], [ %t8905, %L1041 ]
ret i64 %t8906
}
define i64 @fail() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8908 = call i1 @println(ptr @.s8907)
ret i64 1
}
define i64 @print_both(ptr %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8910 = getelementptr i8, ptr %p0, i64 0
%t8911 = load ptr, ptr %t8910, align 8
%t8912 = getelementptr i8, ptr %t8911, i64 0
%t8913 = load ptr, ptr %t8912, align 8
%t8914 = call ptr @h(ptr %t8913)
%t8915 = call ptr @resid_str_concat(ptr @.s8909, ptr %t8914)
%t8917 = call ptr @resid_str_concat(ptr %t8915, ptr @.s8916)
%t8918 = getelementptr i8, ptr %p0, i64 0
%t8919 = load ptr, ptr %t8918, align 8
%t8920 = getelementptr i8, ptr %t8919, i64 8
%t8921 = load ptr, ptr %t8920, align 8
%t8922 = call ptr @h(ptr %t8921)
%t8923 = call ptr @resid_str_concat(ptr %t8917, ptr %t8922)
%t8925 = call ptr @resid_str_concat(ptr %t8923, ptr @.s8924)
%t8926 = getelementptr i8, ptr %p0, i64 0
%t8927 = load ptr, ptr %t8926, align 8
%t8928 = getelementptr i8, ptr %t8927, i64 16
%t8929 = load ptr, ptr %t8928, align 8
%t8930 = call ptr @h(ptr %t8929)
%t8931 = call ptr @resid_str_concat(ptr %t8925, ptr %t8930)
%t8933 = call ptr @resid_str_concat(ptr %t8931, ptr @.s8932)
%t8934 = getelementptr i8, ptr %p1, i64 0
%t8935 = load ptr, ptr %t8934, align 8
%t8937 = call ptr @join(ptr %t8935, i64 0, ptr @.s8936)
%t8938 = call ptr @resid_str_concat(ptr %t8933, ptr %t8937)
%t8940 = call ptr @resid_str_concat(ptr %t8938, ptr @.s8939)
%t8941 = getelementptr i8, ptr %p1, i64 8
%t8942 = load ptr, ptr %t8941, align 8
%t8944 = call ptr @join(ptr %t8942, i64 0, ptr @.s8943)
%t8945 = call ptr @resid_str_concat(ptr %t8940, ptr %t8944)
%t8947 = call ptr @resid_str_concat(ptr %t8945, ptr @.s8946)
%t8948 = call i1 @println(ptr %t8947)
%t8950 = getelementptr i8, ptr %p0, i64 0
%t8951 = load ptr, ptr %t8950, align 8
%t8952 = getelementptr i8, ptr %t8951, i64 0
%t8953 = load ptr, ptr %t8952, align 8
%t8954 = call ptr @h(ptr %t8953)
%t8955 = call ptr @resid_str_concat(ptr @.s8949, ptr %t8954)
%t8957 = call ptr @resid_str_concat(ptr %t8955, ptr @.s8956)
%t8958 = getelementptr i8, ptr %p2, i64 0
%t8959 = load ptr, ptr %t8958, align 8
%t8960 = call ptr @h(ptr %t8959)
%t8961 = call ptr @resid_str_concat(ptr %t8957, ptr %t8960)
%t8963 = call ptr @resid_str_concat(ptr %t8961, ptr @.s8962)
%t8964 = getelementptr i8, ptr %p2, i64 8
%t8965 = load ptr, ptr %t8964, align 8
%t8967 = call ptr @responses(ptr %t8965, i64 0, ptr @.s8966)
%t8968 = call ptr @resid_str_concat(ptr %t8963, ptr %t8967)
%t8970 = call ptr @resid_str_concat(ptr %t8968, ptr @.s8969)
%t8971 = call i1 @println(ptr %t8970)
ret i64 0
}
define ptr @sha256g_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t8972 = call ptr @resid_list_get(ptr %p2, i64 0)
%t8973 = call i64 @resid_unbox_i64(ptr %t8972)
%t8975 = call i64 @__m_________lib_word_resid__wi_andk(i64 %t8973, i64 4294967295)
%t8976 = call ptr @resid_list_get(ptr %p2, i64 1)
%t8977 = call i64 @resid_unbox_i64(ptr %t8976)
%t8979 = call i64 @__m_________lib_word_resid__wi_andk(i64 %t8977, i64 4294967295)
%t8980 = call ptr @resid_list_get(ptr %p2, i64 2)
%t8981 = call i64 @resid_unbox_i64(ptr %t8980)
%t8983 = call i64 @__m_________lib_word_resid__wi_andk(i64 %t8981, i64 4294967295)
%t8984 = call ptr @resid_list_get(ptr %p2, i64 3)
%t8985 = call i64 @resid_unbox_i64(ptr %t8984)
%t8987 = call i64 @__m_________lib_word_resid__wi_andk(i64 %t8985, i64 4294967295)
%t8988 = call ptr @resid_list_get(ptr %p2, i64 4)
%t8989 = call i64 @resid_unbox_i64(ptr %t8988)
%t8991 = call i64 @__m_________lib_word_resid__wi_andk(i64 %t8989, i64 4294967295)
%t8992 = call ptr @resid_list_get(ptr %p2, i64 5)
%t8993 = call i64 @resid_unbox_i64(ptr %t8992)
%t8995 = call i64 @__m_________lib_word_resid__wi_andk(i64 %t8993, i64 4294967295)
%t8996 = call ptr @resid_list_get(ptr %p2, i64 6)
%t8997 = call i64 @resid_unbox_i64(ptr %t8996)
%t8999 = call i64 @__m_________lib_word_resid__wi_andk(i64 %t8997, i64 4294967295)
%t9000 = call ptr @resid_list_get(ptr %p2, i64 7)
%t9001 = call i64 @resid_unbox_i64(ptr %t9000)
%t9003 = call i64 @__m_________lib_word_resid__wi_andk(i64 %t9001, i64 4294967295)
%t9004 = call ptr @__m_________lib_sha256g_resid__g_blk__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 0, ptr %p2, i64 %t8975, i64 %t8979, i64 %t8983, i64 %t8987, i64 %t8991, i64 %t8995, i64 %t8999, i64 %t9003, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret ptr %t9004
}
define ptr @base64g_decode__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9005 = call i64 @resid_list_len(ptr %p0)
%t9006 = srem i64 %t9005, 4
%t9007 = icmp sgt i64 %t9005, 0
br label %LSL9008
LSL9008:
br i1 %t9007, label %LSR9008, label %LSJ9008
LSR9008:
%t9009 = icmp eq i64 %t9006, 0
br label %LSL9010
LSL9010:
br i1 %t9009, label %LSR9010, label %LSJ9010
LSR9010:
%t9011 = icmp eq i64 %p1, 0
br label %LSJ9010
LSJ9010:
%t9012 = phi i1 [ false, %LSL9010 ], [ %t9011, %LSR9010 ]
br label %LSL9013
LSL9013:
br i1 %t9012, label %LSJ9013, label %LSR9013
LSR9013:
%t9014 = icmp eq i64 %t9006, 2
br label %LSL9015
LSL9015:
br i1 %t9014, label %LSR9015, label %LSJ9015
LSR9015:
%t9016 = icmp eq i64 %p1, 2
br label %LSJ9015
LSJ9015:
%t9017 = phi i1 [ false, %LSL9015 ], [ %t9016, %LSR9015 ]
br label %LSJ9013
LSJ9013:
%t9018 = phi i1 [ true, %LSL9013 ], [ %t9017, %LSJ9015 ]
br label %LSL9019
LSL9019:
br i1 %t9018, label %LSJ9019, label %LSR9019
LSR9019:
%t9020 = icmp eq i64 %t9006, 3
br label %LSL9021
LSL9021:
br i1 %t9020, label %LSR9021, label %LSJ9021
LSR9021:
%t9022 = icmp eq i64 %p1, 1
br label %LSJ9021
LSJ9021:
%t9023 = phi i1 [ false, %LSL9021 ], [ %t9022, %LSR9021 ]
br label %LSJ9019
LSJ9019:
%t9024 = phi i1 [ true, %LSL9019 ], [ %t9023, %LSJ9021 ]
br label %LSJ9008
LSJ9008:
%t9025 = phi i1 [ false, %LSL9008 ], [ %t9024, %LSJ9019 ]
%t9026 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB9026)
%t9027 = xor i1 %t9025, true
br i1 %t9027, label %L1042, label %L1044
L1042:
ret ptr %t9026
L1044:
%t9028 = call ptr @resid_listbuf_new()
%t9029 = call ptr @__m_________lib_crypto_resid__b64g_groups__g_Int_64__Int_64_(ptr %p0, i64 0, i64 0, ptr %t9028)
ret ptr %t9029
}
define i512 @eg_fadd__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9030 = call i512 @__m_________lib_word_resid__pi_add(i512 %p0, i512 %p1)
%t9031 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t9032 = call i512 @__m_________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t9030, i512 %t9031)
ret i512 %t9032
}
define i512 @eg_fsub__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9033 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t9034 = call i512 @__m_________lib_word_resid__pi_add(i512 %p0, i512 %t9033)
%t9035 = call i512 @__m_________lib_word_resid__pi_sub(i512 %t9034, i512 %p1)
%t9036 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t9037 = call i512 @__m_________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t9035, i512 %t9036)
ret i512 %t9037
}
define i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9038 = call i512 @__m_________lib_word_resid__pi_mul256(i512 %p0, i512 %p1)
%t9039 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9038, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t9040 = call i512 @__m_________lib_word_resid__pi_shr(i512 %t9038, i64 256)
%t9041 = call i512 @__m_________lib_word_resid__pi_mul256(i512 %t9040, i512 38)
%t9042 = call i512 @__m_________lib_word_resid__pi_add(i512 %t9039, i512 %t9041)
%t9043 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9042, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t9044 = call i512 @__m_________lib_word_resid__pi_shr(i512 %t9042, i64 256)
%t9045 = call i512 @__m_________lib_word_resid__pi_mul256(i512 %t9044, i512 38)
%t9046 = call i512 @__m_________lib_word_resid__pi_add(i512 %t9043, i512 %t9045)
%t9047 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9046, i512 115792089237316195423570985008687907853269984665640564039457584007913129639935)
%t9048 = call i512 @__m_________lib_word_resid__pi_shr(i512 %t9046, i64 256)
%t9049 = call i512 @__m_________lib_word_resid__pi_mul256(i512 %t9048, i512 38)
%t9050 = call i512 @__m_________lib_word_resid__pi_add(i512 %t9047, i512 %t9049)
%t9051 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t9052 = call i512 @__m_________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t9050, i512 %t9051)
%t9053 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819949 to i512
%t9054 = call i512 @__m_________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t9052, i512 %t9053)
ret i512 %t9054
}
define i512 @eg_finv__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9055 = sext i256 57896044618658097711785492504343953926634992332820282019728792003956564819947 to i512
%t9056 = call i512 @eg_fpow__g_Int_512__Int_64_(i512 1, i512 %p0, i512 %t9055, i64 254)
ret i512 %t9056
}
define i512 @eg_fpow__g_Int_512__Int_64_(i512 %p0.in, i512 %p1.in, i512 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t9066, %tco.s0 ], [ %t9058, %tco.s1 ]
%p1 = phi i512 [ %p1.in, %entry ], [ %p1, %tco.s0 ], [ %p1, %tco.s1 ]
%p2 = phi i512 [ %p2.in, %entry ], [ %p2, %tco.s0 ], [ %p2, %tco.s1 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9067, %tco.s0 ], [ %t9069, %tco.s1 ]
%t9057 = icmp slt i64 %p3, 0
br i1 %t9057, label %L1045, label %L1047
L1045:
ret i512 %p0
L1047:
%t9058 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p0)
%t9059 = sext i64 %p3 to i512
%t9060 = icmp uge i512 %t9059, 512
%t9061 = add i512 %t9059, 0
%t9062 = select i1 %t9060, i512 511, i512 %t9061
%t9063 = ashr i512 %p2, %t9062
%t9064 = and i512 %t9063, 1
%t9065 = icmp eq i512 %t9064, 1
br i1 %t9065, label %L1048, label %L1050
L1048:
%t9066 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9058, i512 %p1)
%t9067 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
br label %tco.head
L1050:
%t9069 = sub nsw i64 %p3, 1
br label %tco.s1
tco.s1:
br label %tco.head
}
define ptr @eg_dbl__g_Int_512__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9071 = getelementptr i8, ptr %p0, i64 0
%t9072 = load i512, ptr %t9071, align 8
%t9073 = getelementptr i8, ptr %p0, i64 0
%t9074 = load i512, ptr %t9073, align 8
%t9075 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9072, i512 %t9074)
%t9076 = getelementptr i8, ptr %p0, i64 64
%t9077 = load i512, ptr %t9076, align 8
%t9078 = getelementptr i8, ptr %p0, i64 64
%t9079 = load i512, ptr %t9078, align 8
%t9080 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9077, i512 %t9079)
%t9081 = getelementptr i8, ptr %p0, i64 128
%t9082 = load i512, ptr %t9081, align 8
%t9083 = getelementptr i8, ptr %p0, i64 128
%t9084 = load i512, ptr %t9083, align 8
%t9085 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9082, i512 %t9084)
%t9086 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t9085, i512 %t9085)
%t9087 = getelementptr i8, ptr %p0, i64 0
%t9088 = load i512, ptr %t9087, align 8
%t9089 = getelementptr i8, ptr %p0, i64 64
%t9090 = load i512, ptr %t9089, align 8
%t9091 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t9088, i512 %t9090)
%t9092 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9091, i512 %t9091)
%t9093 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t9092, i512 %t9075)
%t9094 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t9093, i512 %t9080)
%t9095 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t9080, i512 %t9075)
%t9096 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t9095, i512 %t9086)
%t9097 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 0, i512 %t9075)
%t9098 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t9097, i512 %t9080)
%t9099 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9094, i512 %t9096)
%t9100 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9095, i512 %t9098)
%t9101 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9096, i512 %t9095)
%t9102 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9094, i512 %t9098)
%t9103 = call ptr @resid_rec_reuse_sc(ptr %p0, i64 256)
%t9103.f0 = getelementptr i8, ptr %t9103, i64 0
store i512 %t9099, ptr %t9103.f0, align 8
%t9103.f8 = getelementptr i8, ptr %t9103, i64 64
store i512 %t9100, ptr %t9103.f8, align 8
%t9103.f16 = getelementptr i8, ptr %t9103, i64 128
store i512 %t9101, ptr %t9103.f16, align 8
%t9103.f24 = getelementptr i8, ptr %t9103, i64 192
store i512 %t9102, ptr %t9103.f24, align 8
ret ptr %t9103
}
define ptr @eg_add__g_Int_512__Int_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9104 = getelementptr i8, ptr %p0, i64 64
%t9105 = load i512, ptr %t9104, align 8
%t9106 = getelementptr i8, ptr %p0, i64 0
%t9107 = load i512, ptr %t9106, align 8
%t9108 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t9105, i512 %t9107)
%t9109 = getelementptr i8, ptr %p1, i64 64
%t9110 = load i512, ptr %t9109, align 8
%t9111 = getelementptr i8, ptr %p1, i64 0
%t9112 = load i512, ptr %t9111, align 8
%t9113 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t9110, i512 %t9112)
%t9114 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9108, i512 %t9113)
%t9115 = getelementptr i8, ptr %p0, i64 64
%t9116 = load i512, ptr %t9115, align 8
%t9117 = getelementptr i8, ptr %p0, i64 0
%t9118 = load i512, ptr %t9117, align 8
%t9119 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t9116, i512 %t9118)
%t9120 = getelementptr i8, ptr %p1, i64 64
%t9121 = load i512, ptr %t9120, align 8
%t9122 = getelementptr i8, ptr %p1, i64 0
%t9123 = load i512, ptr %t9122, align 8
%t9124 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t9121, i512 %t9123)
%t9125 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9119, i512 %t9124)
%t9126 = getelementptr i8, ptr %p0, i64 192
%t9127 = load i512, ptr %t9126, align 8
%t9128 = getelementptr i8, ptr %p0, i64 192
%t9129 = load i512, ptr %t9128, align 8
%t9130 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t9127, i512 %t9129)
%t9131 = sext i256 37095705934669439343138083508754565189542113879843219016388785533085940283555 to i512
%t9132 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9130, i512 %t9131)
%t9133 = getelementptr i8, ptr %p1, i64 192
%t9134 = load i512, ptr %t9133, align 8
%t9135 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9132, i512 %t9134)
%t9136 = getelementptr i8, ptr %p0, i64 128
%t9137 = load i512, ptr %t9136, align 8
%t9138 = getelementptr i8, ptr %p0, i64 128
%t9139 = load i512, ptr %t9138, align 8
%t9140 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t9137, i512 %t9139)
%t9141 = getelementptr i8, ptr %p1, i64 128
%t9142 = load i512, ptr %t9141, align 8
%t9143 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9140, i512 %t9142)
%t9144 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t9125, i512 %t9114)
%t9145 = call i512 @eg_fsub__g_Int_512__Int_64_(i512 %t9143, i512 %t9135)
%t9146 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t9143, i512 %t9135)
%t9147 = call i512 @eg_fadd__g_Int_512__Int_64_(i512 %t9125, i512 %t9114)
%t9148 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9144, i512 %t9145)
%t9149 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9146, i512 %t9147)
%t9150 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9145, i512 %t9146)
%t9151 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9144, i512 %t9147)
%t9152 = call ptr @resid_rec_reuse_sc(ptr %p0, i64 256)
%t9152.f0 = getelementptr i8, ptr %t9152, i64 0
store i512 %t9148, ptr %t9152.f0, align 8
%t9152.f8 = getelementptr i8, ptr %t9152, i64 64
store i512 %t9149, ptr %t9152.f8, align 8
%t9152.f16 = getelementptr i8, ptr %t9152, i64 128
store i512 %t9150, ptr %t9152.f16, align 8
%t9152.f24 = getelementptr i8, ptr %t9152, i64 192
store i512 %t9151, ptr %t9152.f24, align 8
ret ptr %t9152
}
define ptr @eg_ladder__g_Int_512__Int_64_(i512 %p0.in, ptr %p1.in, ptr %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0.k ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1.ev.tco.s0, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2.ev.tco.s0, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9160, %tco.s0.k ]
%t9153 = icmp slt i64 %p3, 0
br i1 %t9153, label %L1051, label %L1053
L1051:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p2
lr.x11.m:
%lr.ret11 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %p2, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L1053:
%t9154 = call ptr @eg_dbl__g_Int_512__Int_64_(ptr %p2)
call void @resid_rec_share(ptr %t9154)
%t9155 = sub nsw i64 511, %p3
%t9156 = call i512 @__m_________lib_word_resid__pi_shl(i512 %p0, i64 %t9155)
%t9157 = call i512 @__m_________lib_word_resid__pi_sign(i512 %t9156)
%t9158 = call ptr @eg_add__g_Int_512__Int_64_(ptr %t9154, ptr %p1)
call void @resid_rec_share(ptr %t9158)
%t9159 = call ptr @__m_________lib_ed25519g_resid__eg_sel__g_Int_512__Int_64_(i512 %t9157, ptr %t9158, ptr %t9154)
call void @resid_rec_share(ptr %t9159)
%t9160 = sub nsw i64 %p3, 1
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p1.e.tco.s0 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %p1, ptr %lr.cx.tco.s0)
%p2.e.tco.s0 = call ptr @"resid.rec.evac.EgPt(Int(512))"(ptr %t9159, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p1.ev.tco.s0 = phi ptr [ %p1.e.tco.s0, %tco.s0.c ], [ %p1, %tco.s0 ]
%p2.ev.tco.s0 = phi ptr [ %p2.e.tco.s0, %tco.s0.c ], [ %t9159, %tco.s0 ]
br label %tco.head
}
define ptr @eg_base_mul__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9162 = call ptr @eg_base__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t9162)
%t9163 = call ptr @eg_id__g_Int_512__Int_64_()
call void @resid_rec_share(ptr %t9163)
%t9164 = call ptr @eg_ladder__g_Int_512__Int_64_(i512 %p0, ptr %t9162, ptr %t9163, i64 255)
ret ptr %t9164
}
define ptr @eg_encode__g_Int_512__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9165 = getelementptr i8, ptr %p0, i64 128
%t9166 = load i512, ptr %t9165, align 8
%t9167 = call i512 @eg_finv__g_Int_512__Int_64_(i512 %t9166)
%t9168 = getelementptr i8, ptr %p0, i64 0
%t9169 = load i512, ptr %t9168, align 8
%t9170 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9169, i512 %t9167)
%t9171 = getelementptr i8, ptr %p0, i64 64
%t9172 = load i512, ptr %t9171, align 8
%t9173 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %t9172, i512 %t9167)
%t9174 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9170, i512 1)
%t9175 = call i512 @__m_________lib_word_resid__pi_shl(i512 %t9174, i64 255)
%t9176 = call i512 @__m_________lib_word_resid__pi_or(i512 %t9173, i512 %t9175)
%t9177 = call ptr @resid_listbuf_new()
%t9178 = call ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %t9176, i64 32, i64 0, ptr %t9177)
ret ptr %t9178
}
define i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9179 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 32, i64 32, i64 0, i512 0)
%t9180 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 32, i64 0, i512 0)
%t9181 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 0, i512 %t9179, i64 255)
%t9182 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 %t9181, i512 %t9180, i64 255)
ret i512 %t9182
}
define ptr @eg_pt__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9183 = call ptr @resid_rec_new(i64 256, i8 1)
%t9183.f0 = getelementptr i8, ptr %t9183, i64 0
store i512 %p0, ptr %t9183.f0, align 8
%t9183.f8 = getelementptr i8, ptr %t9183, i64 64
store i512 %p1, ptr %t9183.f8, align 8
%t9183.f16 = getelementptr i8, ptr %t9183, i64 128
store i512 1, ptr %t9183.f16, align 8
%t9184 = call i512 @eg_fmul__g_Int_512__Int_64_(i512 %p0, i512 %p1)
%t9183.f24 = getelementptr i8, ptr %t9183, i64 192
store i512 %t9184, ptr %t9183.f24, align 8
ret ptr %t9183
}
define ptr @eg_id__g_Int_512__Int_64_() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9185 = call ptr @resid_rec_new(i64 256, i8 1)
%t9185.f0 = getelementptr i8, ptr %t9185, i64 0
store i512 0, ptr %t9185.f0, align 8
%t9185.f8 = getelementptr i8, ptr %t9185, i64 64
store i512 1, ptr %t9185.f8, align 8
%t9185.f16 = getelementptr i8, ptr %t9185, i64 128
store i512 1, ptr %t9185.f16, align 8
%t9185.f24 = getelementptr i8, ptr %t9185, i64 192
store i512 0, ptr %t9185.f24, align 8
ret ptr %t9185
}
define i512 @eg_clamp__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9186 = sext i256 28948022309329048855892746252171976963317496166410141009864396001978282409976 to i512
%t9187 = call i512 @__m_________lib_word_resid__pi_and(i512 %p0, i512 %t9186)
%t9188 = sext i256 28948022309329048855892746252171976963317496166410141009864396001978282409984 to i512
%t9189 = call i512 @__m_________lib_word_resid__pi_or(i512 %t9187, i512 %t9188)
ret i512 %t9189
}
define ptr @ed25519g_pub__g_Int_64__Int_512__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9190 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %p0)
%t9191 = call i512 @__m_________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %t9190)
%t9192 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t9191)
%t9193 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t9192)
%t9194 = musttail call ptr @__m_________lib_word_resid__wi_publish(ptr %t9193)
ret ptr %t9194
}
define ptr @ed25519g_sign__g_Int_64__Int_512__UInt_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9195 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %p0)
%t9196 = call i512 @__m_________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %t9195)
%t9197 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t9196)
call void @resid_rec_share(ptr %t9197)
%t9198 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t9197)
%t9199 = call ptr @resid_list_freeze(ptr %t9198)
%t9200 = call ptr @__m_________lib_word_resid__wi_publish(ptr %t9199)
%t9201 = call ptr @resid_list_freeze(ptr %t9200)
%t9202 = call ptr @d_lift_bytes__g_Int_64__UInt_64_(ptr %p1)
%t9203 = call ptr @resid_list_freeze(ptr %t9202)
%t9204 = call i64 @resid_scope_push()
%t9205 = call ptr @resid_list_slice(ptr %t9195, i64 32, i64 64)
%t9207 = call ptr @resid_list_concat(ptr %t9205, ptr %t9203)
%t9208 = call ptr @sha512g__g_Int_64__UInt_64_(ptr %t9207)
%t9209 = call ptr @resid_list_freeze(ptr %t9208)
%t9210 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t9209)
call void @resid_scope_pop(i64 %t9204)
%t9211 = call ptr @eg_base_mul__g_Int_512__Int_64_(i512 %t9210)
call void @resid_rec_share(ptr %t9211)
%t9212 = call ptr @eg_encode__g_Int_512__Int_64_(ptr %t9211)
%t9213 = call ptr @resid_list_freeze(ptr %t9212)
%t9214 = call ptr @__m_________lib_word_resid__wi_publish(ptr %t9213)
%t9215 = call ptr @resid_list_freeze(ptr %t9214)
%t9216 = call ptr @resid_listbuf_new()
%t9217 = call i64 @resid_scope_push()
%t9218 = call ptr @resid_list_concat(ptr %t9215, ptr %t9201)
%t9219 = call ptr @resid_list_concat(ptr %t9218, ptr %p1)
%t9220 = call ptr @sha512_bytes(ptr %t9219)
%t9221 = call ptr @resid_list_freeze(ptr %t9220)
%t9222 = call ptr @__m_________lib_ed25519g_resid__eg_lift_bytes__g_Int_64__Int_512_(ptr %t9221, i64 0, ptr %t9216)
%t9223 = call ptr @resid_list_freeze(ptr %t9222)
%t9224 = call i512 @eg_digest_mod_l__g_Int_64__Int_512_(ptr %t9223)
call void @resid_scope_pop(i64 %t9217)
%t9225 = call i512 @__m_________lib_word_resid__pi_mul(i512 %t9224, i512 %t9196)
%t9226 = call i512 @__m_________lib_word_resid__pi_add(i512 %t9225, i512 %t9210)
%t9227 = call i512 @eg_fold_l__g_Int_512__Int_64_(i512 0, i512 %t9226, i64 508)
%t9228 = call ptr @resid_listbuf_new()
%t9229 = call ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %t9227, i64 32, i64 0, ptr %t9228)
%t9230 = call ptr @resid_list_freeze(ptr %t9229)
%t9231 = call ptr @__m_________lib_word_resid__wi_publish(ptr %t9230)
%t9232 = call ptr @resid_list_freeze(ptr %t9231)
%t9233 = musttail call ptr @resid_list_concat(ptr %t9215, ptr %t9232)
ret ptr %t9233
}
define ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9234 = call ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
%t9235 = call ptr @__m_________lib_chachag_resid__cg_block_st__g_Int_64__Int_64_(ptr %t9234)
ret ptr %t9235
}
define ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9236 = call ptr @resid_listbuf_new()
%t9237 = call ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2)
%t9238 = call ptr @resid_list_freeze(ptr %t9237)
%t9239 = and i64 %p1, 4294967295
%t9240 = call ptr @__m_________lib_chachag_resid__cg_xor_run__g_Int_64__Int_64_(ptr %t9238, i64 %t9239, ptr %p3, i64 0, ptr %t9236)
%t9241 = call ptr @resid_listbuf_finish(ptr %t9240, ptr @.lty9241)
ret ptr %t9241
}
define ptr @poly1305g__g_Int_64__Int_512_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9242 = call i512 @__m_________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 16, i64 0, i512 0)
%t9243 = sext i128 21267647620597763993911028882763415551 to i512
%t9244 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9242, i512 %t9243)
%t9245 = call i512 @__m_________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p0, i64 16, i64 16, i64 0, i512 0)
%t9246 = call i512 @__m_________lib_chachag_resid__pg_blocks__g_Int_512__Int_64_(i512 0, ptr %p1, i64 0, i512 %t9244)
%t9247 = call ptr @resid_listbuf_new()
%t9248 = call i512 @__m_________lib_word_resid__pi_add(i512 %t9246, i512 %t9245)
%t9249 = sext i256 340282366920938463463374607431768211455 to i512
%t9250 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9248, i512 %t9249)
%t9251 = call ptr @__m_________lib_chachag_resid__pg_bytes__g_Int_512__Int_64_(i512 %t9250, i64 0, ptr %t9247)
ret ptr %t9251
}
define ptr @chacha20poly1305g_seal__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9252 = call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 0, ptr %p1)
%t9253 = call ptr @resid_list_freeze(ptr %t9252)
%t9254 = call ptr @resid_list_slice(ptr %t9253, i64 0, i64 32)
%t9256 = call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 1, ptr %p1, ptr %p2)
%t9257 = call ptr @resid_list_freeze(ptr %t9256)
%t9258 = call ptr @__m_________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p3, ptr %t9257)
%t9259 = call ptr @resid_list_freeze(ptr %t9258)
%t9260 = call ptr @poly1305g__g_Int_64__Int_512_(ptr %t9254, ptr %t9259)
%t9261 = call ptr @resid_list_freeze(ptr %t9260)
%t9262 = call ptr @resid_list_concat(ptr %t9257, ptr %t9261)
ret ptr %t9262
}
define ptr @chacha20poly1305g_decrypt__g_Int_64__Int_64__Int_512_(ptr %p0, ptr %p1, ptr %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9263 = call i64 @resid_list_len(ptr %p2)
%t9264 = sub nsw i64 %t9263, 16
%t9265 = call i64 @resid_list_len(ptr %p0)
%t9266 = icmp ne i64 %t9265, 32
br label %LSL9267
LSL9267:
br i1 %t9266, label %LSJ9267, label %LSR9267
LSR9267:
%t9268 = call i64 @resid_list_len(ptr %p1)
%t9269 = icmp ne i64 %t9268, 12
br label %LSJ9267
LSJ9267:
%t9270 = phi i1 [ true, %LSL9267 ], [ %t9269, %LSR9267 ]
br label %LSL9271
LSL9271:
br i1 %t9270, label %LSJ9271, label %LSR9271
LSR9271:
%t9272 = icmp slt i64 %t9264, 0
br label %LSJ9271
LSJ9271:
%t9273 = phi i1 [ true, %LSL9271 ], [ %t9272, %LSR9271 ]
br i1 %t9273, label %L1054, label %L1056
L1054:
ret ptr @.nbox9274
L1056:
%t9275 = call ptr @resid_listbuf_new()
%t9276 = call ptr @resid_listbuf_new()
%t9277 = call ptr @resid_list_slice(ptr %p2, i64 0, i64 %t9264)
%t9279 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t9277, i64 0, ptr %t9275)
%t9280 = call ptr @resid_list_freeze(ptr %t9279)
%t9281 = call i64 @resid_list_len(ptr %p2)
%t9282 = call ptr @resid_list_slice(ptr %p2, i64 %t9264, i64 %t9281)
%t9284 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t9282, i64 0, ptr %t9276)
%t9285 = call ptr @chachag_block__g_Int_64__Int_64_(ptr %p0, i64 0, ptr %p1)
%t9286 = call ptr @resid_list_freeze(ptr %t9285)
%t9287 = call ptr @resid_list_slice(ptr %t9286, i64 0, i64 32)
%t9289 = call ptr @__m_________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p3, ptr %t9280)
%t9290 = call ptr @resid_list_freeze(ptr %t9289)
%t9291 = call ptr @poly1305g__g_Int_64__Int_512_(ptr %t9287, ptr %t9290)
%t9292 = call ptr @resid_list_freeze(ptr %t9291)
%t9293 = call i1 @__m_________lib_crypto_resid__ct_same_pub(ptr %t9292, ptr %t9284)
%t9294 = xor i1 %t9293, true
br i1 %t9294, label %L1057, label %L1059
L1057:
ret ptr @.nbox9295
L1059:
%t9296 = call ptr @chachag_xor__g_Int_64__Int_64_(ptr %p0, i64 1, ptr %p1, ptr %t9280)
%t9297 = call ptr @resid_list_freeze(ptr %t9296)
%t9300 = call ptr @resid_box_alloc(i64 1, i64 1, ptr @.oty9298)
%t9299 = getelementptr {i32, i32, ptr}, ptr %t9300, i32 1
store ptr %t9297, ptr %t9299
ret ptr %t9300
}
define ptr @__m_________lib_sha256g_resid__g_blk__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in, i64 %p19.in, i64 %p20.in, i64 %p21.in, i64 %p22.in, i64 %p23.in, i64 %p24.in, i64 %p25.in, i64 %p26.in, i64 %p27.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9334 = alloca [8 x ptr]
%p3.ld = call ptr @resid_list_vdata(ptr %p3.in)
%p3.ln = call i64 @resid_list_vlen(ptr %p3.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9373, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t9374, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %p4, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t9375, %tco.s0.k ]
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
%p27 = phi i64 [ %p27.in, %entry ], [ %t9361, %tco.s0.k ]
%t9301 = icmp sge i64 %p2, 64
br i1 %t9301, label %L1060, label %L1062
L1060:
%t9302 = call ptr @resid_list_get_v(ptr %p3, i64 0, ptr %p3.ld, i64 %p3.ln)
%t9303 = call i64 @resid_unbox_i64(ptr %t9302)
%t9305 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9303, i64 %p4)
%t9306 = call ptr @resid_list_get_v(ptr %p3, i64 1, ptr %p3.ld, i64 %p3.ln)
%t9307 = call i64 @resid_unbox_i64(ptr %t9306)
%t9309 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9307, i64 %p5)
%t9310 = call ptr @resid_list_get_v(ptr %p3, i64 2, ptr %p3.ld, i64 %p3.ln)
%t9311 = call i64 @resid_unbox_i64(ptr %t9310)
%t9313 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9311, i64 %p6)
%t9314 = call ptr @resid_list_get_v(ptr %p3, i64 3, ptr %p3.ld, i64 %p3.ln)
%t9315 = call i64 @resid_unbox_i64(ptr %t9314)
%t9317 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9315, i64 %p7)
%t9318 = call ptr @resid_list_get_v(ptr %p3, i64 4, ptr %p3.ld, i64 %p3.ln)
%t9319 = call i64 @resid_unbox_i64(ptr %t9318)
%t9321 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9319, i64 %p8)
%t9322 = call ptr @resid_list_get_v(ptr %p3, i64 5, ptr %p3.ld, i64 %p3.ln)
%t9323 = call i64 @resid_unbox_i64(ptr %t9322)
%t9325 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9323, i64 %p9)
%t9326 = call ptr @resid_list_get_v(ptr %p3, i64 6, ptr %p3.ld, i64 %p3.ln)
%t9327 = call i64 @resid_unbox_i64(ptr %t9326)
%t9329 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9327, i64 %p10)
%t9330 = call ptr @resid_list_get_v(ptr %p3, i64 7, ptr %p3.ld, i64 %p3.ln)
%t9331 = call i64 @resid_unbox_i64(ptr %t9330)
%t9333 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9331, i64 %p11)
%t9336 = call ptr @resid_box_i64(i64 %t9305)
%t9338 = getelementptr i8, ptr %t9334, i64 0
store ptr %t9336, ptr %t9338
%t9339 = call ptr @resid_box_i64(i64 %t9309)
%t9341 = getelementptr i8, ptr %t9334, i64 8
store ptr %t9339, ptr %t9341
%t9342 = call ptr @resid_box_i64(i64 %t9313)
%t9344 = getelementptr i8, ptr %t9334, i64 16
store ptr %t9342, ptr %t9344
%t9345 = call ptr @resid_box_i64(i64 %t9317)
%t9347 = getelementptr i8, ptr %t9334, i64 24
store ptr %t9345, ptr %t9347
%t9348 = call ptr @resid_box_i64(i64 %t9321)
%t9350 = getelementptr i8, ptr %t9334, i64 32
store ptr %t9348, ptr %t9350
%t9351 = call ptr @resid_box_i64(i64 %t9325)
%t9353 = getelementptr i8, ptr %t9334, i64 40
store ptr %t9351, ptr %t9353
%t9354 = call ptr @resid_box_i64(i64 %t9329)
%t9356 = getelementptr i8, ptr %t9334, i64 48
store ptr %t9354, ptr %t9356
%t9357 = call ptr @resid_box_i64(i64 %t9333)
%t9359 = getelementptr i8, ptr %t9334, i64 56
store ptr %t9357, ptr %t9359
%t9360 = call ptr @resid_list_new(i64 8, ptr %t9334, ptr @.lty9334)
%lr.cx87 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz87 = icmp eq ptr %lr.cx87, null
br i1 %lr.lz87, label %lr.x87.k, label %lr.x87.m
lr.x87.k:
ret ptr %t9360
lr.x87.m:
%lr.ret87 = call ptr @resid_mv_list(ptr %t9360, ptr %lr.cx87)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret87
L1062:
%t9361 = call i64 @__m_________lib_sha256g_resid__g_sched__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p12, i64 %p13, i64 %p21, i64 %p26)
%t9362 = call i64 @resid_scope_push()
%t9363 = call i64 @__m_________lib_sha256g_resid__g_bsig1__g_Int_64__Int_64_(i64 %p8)
%t9364 = call i64 @__m_________lib_word_resid__wi_add(i64 %p11, i64 %t9363)
%t9365 = call i64 @__m_________lib_sha256g_resid__g_ch__g_Int_64__Int_64_(i64 %p8, i64 %p9, i64 %p10)
%t9366 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9364, i64 %t9365)
%t9367 = call i64 @__m_________lib_sha256g_resid__sha2k(i64 %p2)
%t9368 = call i64 @__m_________lib_word_resid__wi_addk(i64 %t9366, i64 %t9367)
%t9369 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9368, i64 %t9361)
call void @resid_scope_pop(i64 %t9362)
%t9370 = call i64 @__m_________lib_sha256g_resid__g_bsig0__g_Int_64__Int_64_(i64 %p4)
%t9371 = call i64 @__m_________lib_sha256g_resid__g_maj__g_Int_64__Int_64_(i64 %p4, i64 %p5, i64 %p6)
%t9372 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9370, i64 %t9371)
%t9373 = add nsw i64 %p2, 1
%t9374 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9369, i64 %t9372)
%t9375 = call i64 @__m_________lib_word_resid__wi_add(i64 %p7, i64 %t9369)
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
define ptr @__m_________lib_crypto_resid__b64g_groups__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9414, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9413, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t9411, %tco.s0 ]
%t9377 = call i64 @resid_list_len(ptr %p0)
%t9378 = icmp sge i64 %p1, %t9377
br i1 %t9378, label %L1063, label %L1065
L1063:
%t9379 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty9379)
%t9380 = call ptr @__m_________lib_crypto_resid__b64g_finish__g_Int_64__Int_64_(ptr %t9379, i64 %p2)
ret ptr %t9380
L1065:
%t9381 = call i64 @__m_________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %p1)
%t9382 = add nsw i64 %p1, 1
%t9383 = call i64 @__m_________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t9382)
%t9384 = add nsw i64 %p1, 2
%t9385 = call i64 @__m_________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t9384)
%t9386 = add nsw i64 %p1, 3
%t9387 = call i64 @__m_________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %t9386)
%t9388 = call i64 @__m_________lib_crypto_resid__b64g_join__g_Int_64__Int_64_(i64 %t9381, i64 %t9383, i64 %t9385, i64 %t9387)
%t9389 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t9377, i64 %p1)
%t9390 = extractvalue {i64, i1} %t9389, 0
%t9391 = extractvalue {i64, i1} %t9389, 1
%t9392 = zext i1 %t9391 to i8
call void @resid_overflow_check(i8 %t9392)
%t9393 = call i64 @__m_________lib_word_resid__wi_byte(i64 %t9388, i64 16)
%t9394 = call ptr @resid_box_i64(i64 %t9393)
%t9397 = call ptr @resid_listbuf_push(ptr %p3, ptr %t9394)
%t9398 = icmp sgt i64 %t9390, 2
br i1 %t9398, label %L1066, label %L1067
L1066:
%t9399 = call i64 @__m_________lib_word_resid__wi_byte(i64 %t9388, i64 8)
%t9400 = call ptr @resid_box_i64(i64 %t9399)
%t9403 = call ptr @resid_listbuf_push(ptr %t9397, ptr %t9400)
br label %L1068
L1067:
br label %L1068
L1068:
%t9404 = phi ptr [ %t9403, %L1066 ], [ %t9397, %L1067 ]
%t9405 = icmp sgt i64 %t9390, 3
br i1 %t9405, label %L1069, label %L1070
L1069:
%t9406 = call i64 @__m_________lib_word_resid__wi_byte(i64 %t9388, i64 0)
%t9407 = call ptr @resid_box_i64(i64 %t9406)
%t9410 = call ptr @resid_listbuf_push(ptr %t9404, ptr %t9407)
br label %L1071
L1070:
br label %L1071
L1071:
%t9411 = phi ptr [ %t9410, %L1069 ], [ %t9404, %L1070 ]
%t9412 = call i64 @__m_________lib_word_resid__wi_andk(i64 %t9388, i64 16777216)
%t9413 = call i64 @__m_________lib_word_resid__wi_or(i64 %p2, i64 %t9412)
%t9414 = add nsw i64 %p1, 4
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m_________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %p0, i512 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9416 = call i512 @__m_________lib_word_resid__pi_sub(i512 %p0, i512 %p1)
%t9417 = call i512 @__m_________lib_word_resid__pi_sign(i512 %t9416)
%t9418 = call i512 @__m_________lib_word_resid__pi_and(i512 %p0, i512 %t9417)
%t9419 = sext i64 -1 to i512
%t9420 = call i512 @__m_________lib_word_resid__pi_xor(i512 %t9417, i512 %t9419)
%t9421 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9416, i512 %t9420)
%t9422 = call i512 @__m_________lib_word_resid__pi_or(i512 %t9418, i512 %t9421)
ret i512 %t9422
}
define ptr @__m_________lib_ed25519g_resid__eg_sel__g_Int_512__Int_64_(i512 %p0, ptr %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9423 = sext i64 -1 to i512
%t9424 = call i512 @__m_________lib_word_resid__pi_xor(i512 %p0, i512 %t9423)
%t9425 = getelementptr i8, ptr %p1, i64 0
%t9426 = load i512, ptr %t9425, align 8
%t9427 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9426, i512 %p0)
%t9428 = getelementptr i8, ptr %p2, i64 0
%t9429 = load i512, ptr %t9428, align 8
%t9430 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9429, i512 %t9424)
%t9431 = call i512 @__m_________lib_word_resid__pi_or(i512 %t9427, i512 %t9430)
%t9432 = getelementptr i8, ptr %p1, i64 64
%t9433 = load i512, ptr %t9432, align 8
%t9434 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9433, i512 %p0)
%t9435 = getelementptr i8, ptr %p2, i64 64
%t9436 = load i512, ptr %t9435, align 8
%t9437 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9436, i512 %t9424)
%t9438 = call i512 @__m_________lib_word_resid__pi_or(i512 %t9434, i512 %t9437)
%t9439 = getelementptr i8, ptr %p1, i64 128
%t9440 = load i512, ptr %t9439, align 8
%t9441 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9440, i512 %p0)
%t9442 = getelementptr i8, ptr %p2, i64 128
%t9443 = load i512, ptr %t9442, align 8
%t9444 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9443, i512 %t9424)
%t9445 = call i512 @__m_________lib_word_resid__pi_or(i512 %t9441, i512 %t9444)
%t9446 = getelementptr i8, ptr %p1, i64 192
%t9447 = load i512, ptr %t9446, align 8
%t9448 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9447, i512 %p0)
%t9449 = getelementptr i8, ptr %p2, i64 192
%t9450 = load i512, ptr %t9449, align 8
%t9451 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9450, i512 %t9424)
%t9452 = call i512 @__m_________lib_word_resid__pi_or(i512 %t9448, i512 %t9451)
%t9453 = call ptr @resid_rec_reuse_sc(ptr %p1, i64 256)
%t9453.f0 = getelementptr i8, ptr %t9453, i64 0
store i512 %t9431, ptr %t9453.f0, align 8
%t9453.f8 = getelementptr i8, ptr %t9453, i64 64
store i512 %t9438, ptr %t9453.f8, align 8
%t9453.f16 = getelementptr i8, ptr %t9453, i64 128
store i512 %t9445, ptr %t9453.f16, align 8
%t9453.f24 = getelementptr i8, ptr %t9453, i64 192
store i512 %t9452, ptr %t9453.f24, align 8
ret ptr %t9453
}
define ptr @eg_base__g_Int_512__Int_64_() "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9454 = sext i256 15112221349535400772501151409588531511454012693041857206046113283949847762202 to i512
%t9455 = sext i256 46316835694926478169428394003475163141307993866256225615783033603165251855960 to i512
%t9456 = call ptr @eg_pt__g_Int_512__Int_64_(i512 %t9454, i512 %t9455)
ret ptr %t9456
}
define ptr @eg_le_bytes__g_Int_512__Int_64_(i512 %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9459, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t9468, %tco.s0 ]
%t9457 = icmp sge i64 %p2, %p1
br i1 %t9457, label %L1072, label %L1074
L1072:
%t9458 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty9458)
ret ptr %t9458
L1074:
%t9459 = add nsw i64 %p2, 1
%t9460 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p2)
%t9461 = extractvalue {i64, i1} %t9460, 0
%t9462 = extractvalue {i64, i1} %t9460, 1
%t9463 = zext i1 %t9462 to i8
call void @resid_overflow_check(i8 %t9463)
%t9464 = call i64 @__m_________lib_word_resid__pi_byte(i512 %p0, i64 %t9461)
%t9465 = call ptr @resid_box_i64(i64 %t9464)
%t9468 = call ptr @resid_listbuf_push(ptr %p3, ptr %t9465)
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t9471, %tco.s0 ]
%p4 = phi i512 [ %p4.in, %entry ], [ %t9485, %tco.s0 ]
%t9470 = icmp sge i64 %p3, %p2
br i1 %t9470, label %L1075, label %L1077
L1075:
ret i512 %p4
L1077:
%t9471 = add nsw i64 %p3, 1
%t9472 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p3)
%t9473 = extractvalue {i64, i1} %t9472, 0
%t9474 = extractvalue {i64, i1} %t9472, 1
%t9475 = zext i1 %t9474 to i8
call void @resid_overflow_check(i8 %t9475)
%t9476 = call ptr @resid_list_get_v(ptr %p0, i64 %t9473, ptr %p0.ld, i64 %p0.ln)
%t9477 = call i64 @resid_unbox_i64(ptr %t9476)
%t9479 = call i512 @__m_________lib_word_resid__pi_from_byte(i64 %t9477)
%t9480 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p3)
%t9481 = extractvalue {i64, i1} %t9480, 0
%t9482 = extractvalue {i64, i1} %t9480, 1
%t9483 = zext i1 %t9482 to i8
call void @resid_overflow_check(i8 %t9483)
%t9484 = call i512 @__m_________lib_word_resid__pi_shl(i512 %t9479, i64 %t9481)
%t9485 = call i512 @__m_________lib_word_resid__pi_or(i512 %p4, i512 %t9484)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @eg_fold_l__g_Int_512__Int_64_(i512 %p0.in, i512 %p1.in, i64 %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t9493, %tco.s0 ]
%p1 = phi i512 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9494, %tco.s0 ]
%t9487 = icmp slt i64 %p2, 0
br i1 %t9487, label %L1078, label %L1080
L1078:
ret i512 %p0
L1080:
%t9488 = call i512 @__m_________lib_word_resid__pi_shr(i512 %p1, i64 %p2)
%t9489 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9488, i512 1)
%t9490 = call i512 @__m_________lib_word_resid__pi_add(i512 %p0, i512 %p0)
%t9491 = call i512 @__m_________lib_word_resid__pi_add(i512 %t9490, i512 %t9489)
%t9492 = sext i256 7237005577332262213973186563042994240857116359379907606001950938285454250989 to i512
%t9493 = call i512 @__m_________lib_ed25519g_resid__eg_csub__g_Int_512__Int_64_(i512 %t9491, i512 %t9492)
%t9494 = sub nsw i64 %p2, 1
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @sha512g__g_Int_64__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9496 = add i64 7640891576956012808, 0
%t9497 = add i64 %t9496, 0
%t9498 = add i64 %t9497, 0
%t9499 = icmp ne i64 %t9498, %t9496
%t9500 = icmp slt i64 7640891576956012808, 0
%t9501 = or i1 %t9499, %t9500
%t9502 = zext i1 %t9501 to i8
call void @resid_conv_check(i8 %t9502)
%t9503 = add i128 13503953896175478587, 0
%t9504 = trunc i128 %t9503 to i64
%t9505 = zext i64 %t9504 to i128
%t9506 = icmp ne i128 %t9505, %t9503
%t9507 = icmp slt i128 13503953896175478587, 0
%t9508 = or i1 %t9506, %t9507
%t9509 = zext i1 %t9508 to i8
call void @resid_conv_check(i8 %t9509)
%t9510 = add i64 4354685564936845355, 0
%t9511 = add i64 %t9510, 0
%t9512 = add i64 %t9511, 0
%t9513 = icmp ne i64 %t9512, %t9510
%t9514 = icmp slt i64 4354685564936845355, 0
%t9515 = or i1 %t9513, %t9514
%t9516 = zext i1 %t9515 to i8
call void @resid_conv_check(i8 %t9516)
%t9517 = add i128 11912009170470909681, 0
%t9518 = trunc i128 %t9517 to i64
%t9519 = zext i64 %t9518 to i128
%t9520 = icmp ne i128 %t9519, %t9517
%t9521 = icmp slt i128 11912009170470909681, 0
%t9522 = or i1 %t9520, %t9521
%t9523 = zext i1 %t9522 to i8
call void @resid_conv_check(i8 %t9523)
%t9524 = add i64 5840696475078001361, 0
%t9525 = add i64 %t9524, 0
%t9526 = add i64 %t9525, 0
%t9527 = icmp ne i64 %t9526, %t9524
%t9528 = icmp slt i64 5840696475078001361, 0
%t9529 = or i1 %t9527, %t9528
%t9530 = zext i1 %t9529 to i8
call void @resid_conv_check(i8 %t9530)
%t9531 = add i128 11170449401992604703, 0
%t9532 = trunc i128 %t9531 to i64
%t9533 = zext i64 %t9532 to i128
%t9534 = icmp ne i128 %t9533, %t9531
%t9535 = icmp slt i128 11170449401992604703, 0
%t9536 = or i1 %t9534, %t9535
%t9537 = zext i1 %t9536 to i8
call void @resid_conv_check(i8 %t9537)
%t9538 = add i64 2270897969802886507, 0
%t9539 = add i64 %t9538, 0
%t9540 = add i64 %t9539, 0
%t9541 = icmp ne i64 %t9540, %t9538
%t9542 = icmp slt i64 2270897969802886507, 0
%t9543 = or i1 %t9541, %t9542
%t9544 = zext i1 %t9543 to i8
call void @resid_conv_check(i8 %t9544)
%t9545 = add i64 6620516959819538809, 0
%t9546 = add i64 %t9545, 0
%t9547 = add i64 %t9546, 0
%t9548 = icmp ne i64 %t9547, %t9545
%t9549 = icmp slt i64 6620516959819538809, 0
%t9550 = or i1 %t9548, %t9549
%t9551 = zext i1 %t9550 to i8
call void @resid_conv_check(i8 %t9551)
%t9552 = alloca [8 x ptr]
%t9554 = call ptr @resid_box_i64(i64 %t9497)
%t9556 = getelementptr i8, ptr %t9552, i64 0
store ptr %t9554, ptr %t9556
%t9557 = call ptr @resid_box_i64(i64 %t9504)
%t9559 = getelementptr i8, ptr %t9552, i64 8
store ptr %t9557, ptr %t9559
%t9560 = call ptr @resid_box_i64(i64 %t9511)
%t9562 = getelementptr i8, ptr %t9552, i64 16
store ptr %t9560, ptr %t9562
%t9563 = call ptr @resid_box_i64(i64 %t9518)
%t9565 = getelementptr i8, ptr %t9552, i64 24
store ptr %t9563, ptr %t9565
%t9566 = call ptr @resid_box_i64(i64 %t9525)
%t9568 = getelementptr i8, ptr %t9552, i64 32
store ptr %t9566, ptr %t9568
%t9569 = call ptr @resid_box_i64(i64 %t9532)
%t9571 = getelementptr i8, ptr %t9552, i64 40
store ptr %t9569, ptr %t9571
%t9572 = call ptr @resid_box_i64(i64 %t9539)
%t9574 = getelementptr i8, ptr %t9552, i64 48
store ptr %t9572, ptr %t9574
%t9575 = call ptr @resid_box_i64(i64 %t9546)
%t9577 = getelementptr i8, ptr %t9552, i64 56
store ptr %t9575, ptr %t9577
%t9578 = call ptr @resid_list_new(i64 8, ptr %t9552, ptr @.lty9552)
%t9579 = call ptr @__m_________lib_sha512g_resid__g5_hash__g_Int_64__UInt_64_(ptr %p0, ptr %t9578, i64 64)
ret ptr %t9579
}
define i512 @__m_________lib_ed25519g_resid__eg_scalar__g_Int_64__Int_512_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9580 = call i512 @eg_le__g_Int_64__Int_512_(ptr %p0, i64 0, i64 32, i64 0, i512 0)
%t9581 = call i512 @eg_clamp__g_Int_512__Int_64_(i512 %t9580)
ret i512 %t9581
}
define ptr @d_lift_bytes__g_Int_64__UInt_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9582 = call ptr @resid_listbuf_new()
%t9583 = call ptr @__m_________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %p0, i64 0, ptr %t9582)
ret ptr %t9583
}
define ptr @__m_________lib_ed25519g_resid__eg_lift_bytes__g_Int_64__Int_512_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9593, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t9598, %tco.s0 ]
%t9584 = call i64 @resid_list_len(ptr %p0)
%t9585 = icmp sge i64 %p1, %t9584
br i1 %t9585, label %L1081, label %L1083
L1081:
%t9586 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty9586)
ret ptr %t9586
L1083:
%t9587 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t9588 = call i64 @resid_unbox_i64(ptr %t9587)
%t9590 = and i64 %t9588, 255
%t9591 = sext i64 %t9590 to i512
%t9592 = call i512 @__m_________lib_word_resid__pi_lift(i512 %t9591)
%t9593 = add nsw i64 %p1, 1
%t9594 = call i64 @__m_________lib_word_resid__pi_byte(i512 %t9592, i64 0)
%t9595 = call ptr @resid_box_i64(i64 %t9594)
%t9598 = call ptr @resid_listbuf_push(ptr %p2, ptr %t9595)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @chachag_state__g_Int_64__Int_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9600 = call i64 @__m_________lib_chachag_resid__cg_le32(ptr %p2, i64 0)
%t9601 = call i64 @__m_________lib_word_resid__wi_lift(i64 %t9600)
%t9602 = call i64 @__m_________lib_chachag_resid__cg_le32(ptr %p2, i64 4)
%t9603 = call i64 @__m_________lib_word_resid__wi_lift(i64 %t9602)
%t9604 = call i64 @__m_________lib_chachag_resid__cg_le32(ptr %p2, i64 8)
%t9605 = call i64 @__m_________lib_word_resid__wi_lift(i64 %t9604)
%t9606 = call ptr @__m_________lib_chachag_resid__cg_state_w__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %t9601, i64 %t9603, i64 %t9605)
ret ptr %t9606
}
define ptr @__m_________lib_chachag_resid__cg_block_st__g_Int_64__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9607 = call ptr @resid_listbuf_new()
%t9608 = call ptr @resid_list_get(ptr %p0, i64 12)
%t9609 = call i64 @resid_unbox_i64(ptr %t9608)
%t9611 = call ptr @__m_________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %t9609)
%t9612 = call ptr @__m_________lib_chachag_resid__cg_ser__g_Int_64__Int_64_(ptr %t9611, i64 0, ptr %t9607)
ret ptr %t9612
}
define ptr @__m_________lib_chachag_resid__cg_xor_run__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9625, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9627, %tco.s0 ]
%p4 = phi ptr [ %p4.in, %entry ], [ %t9630, %tco.s0 ]
%t9613 = call i64 @resid_list_len(ptr %p2)
%t9614 = icmp sge i64 %p3, %t9613
br i1 %t9614, label %L1084, label %L1086
L1084:
ret ptr %p4
L1086:
%t9615 = call i64 @__m_________lib_word_resid__wi_lift(i64 %p1)
%t9616 = call ptr @__m_________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %t9615)
%t9617 = call i64 @resid_list_len(ptr %p2)
%t9618 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t9617, i64 %p3)
%t9619 = extractvalue {i64, i1} %t9618, 0
%t9620 = extractvalue {i64, i1} %t9618, 1
%t9621 = zext i1 %t9620 to i8
call void @resid_overflow_check(i8 %t9621)
%t9622 = icmp slt i64 %t9619, 64
br i1 %t9622, label %L1087, label %L1088
L1087:
br label %L1089
L1088:
br label %L1089
L1089:
%t9623 = phi i64 [ %t9619, %L1087 ], [ 64, %L1088 ]
%t9624 = call i64 @wrapping_add(i64 %p1, i64 1)
%t9625 = and i64 %t9624, 4294967295
%t9626 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p3, i64 %t9623)
%t9627 = extractvalue {i64, i1} %t9626, 0
%t9628 = extractvalue {i64, i1} %t9626, 1
%t9629 = zext i1 %t9628 to i8
call void @resid_overflow_check(i8 %t9629)
%t9630 = call ptr @__m_________lib_chachag_resid__cg_xor_bytes__g_Int_64__Int_64_(ptr %t9616, ptr %p2, i64 %p3, i64 0, i64 %t9623, ptr %p4)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m_________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i512 %p4.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t9633, %tco.s0 ]
%p4 = phi i512 [ %p4.in, %entry ], [ %t9647, %tco.s0 ]
%t9632 = icmp sge i64 %p3, %p2
br i1 %t9632, label %L1090, label %L1092
L1090:
ret i512 %p4
L1092:
%t9633 = add nsw i64 %p3, 1
%t9634 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p3)
%t9635 = extractvalue {i64, i1} %t9634, 0
%t9636 = extractvalue {i64, i1} %t9634, 1
%t9637 = zext i1 %t9636 to i8
call void @resid_overflow_check(i8 %t9637)
%t9638 = call ptr @resid_list_get_v(ptr %p0, i64 %t9635, ptr %p0.ld, i64 %p0.ln)
%t9639 = call i64 @resid_unbox_i64(ptr %t9638)
%t9641 = call i512 @__m_________lib_word_resid__pi_from_byte(i64 %t9639)
%t9642 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p3)
%t9643 = extractvalue {i64, i1} %t9642, 0
%t9644 = extractvalue {i64, i1} %t9642, 1
%t9645 = zext i1 %t9644 to i8
call void @resid_overflow_check(i8 %t9645)
%t9646 = call i512 @__m_________lib_word_resid__pi_shl(i512 %t9641, i64 %t9643)
%t9647 = call i512 @__m_________lib_word_resid__pi_or(i512 %p4, i512 %t9646)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m_________lib_chachag_resid__pg_blocks__g_Int_512__Int_64_(i512 %p0.in, ptr %p1.in, i64 %p2.in, i512 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %t9671, %tco.s0 ]
%p1 = phi ptr [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t9673, %tco.s0 ]
%p3 = phi i512 [ %p3.in, %entry ], [ %p3, %tco.s0 ]
%t9649 = call i64 @resid_list_len(ptr %p1)
%t9650 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %t9649, i64 %p2)
%t9651 = extractvalue {i64, i1} %t9650, 0
%t9652 = extractvalue {i64, i1} %t9650, 1
%t9653 = zext i1 %t9652 to i8
call void @resid_overflow_check(i8 %t9653)
%t9654 = icmp sle i64 %t9651, 0
br i1 %t9654, label %L1093, label %L1095
L1093:
ret i512 %p0
L1095:
%t9655 = icmp slt i64 %t9651, 16
br i1 %t9655, label %L1096, label %L1097
L1096:
br label %L1098
L1097:
br label %L1098
L1098:
%t9656 = phi i64 [ %t9651, %L1096 ], [ 16, %L1097 ]
%t9657 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %t9656, i64 8)
%t9658 = extractvalue {i64, i1} %t9657, 0
%t9659 = extractvalue {i64, i1} %t9657, 1
%t9660 = zext i1 %t9659 to i8
call void @resid_overflow_check(i8 %t9660)
%t9661 = sext i64 %t9658 to i512
%t9662 = icmp uge i512 %t9661, 512
%t9663 = add i512 %t9661, 0
%t9664 = shl i512 1, %t9663
%t9665 = select i1 %t9662, i512 0, i512 %t9664
%t9666 = call i512 @__m_________lib_word_resid__pi_lift(i512 %t9665)
%t9667 = call i512 @__m_________lib_chachag_resid__pg_le__g_Int_64__Int_512_(ptr %p1, i64 %p2, i64 %t9656, i64 0, i512 0)
%t9668 = call i512 @__m_________lib_word_resid__pi_add(i512 %t9667, i512 %t9666)
%t9669 = call i512 @__m_________lib_word_resid__pi_add(i512 %p0, i512 %t9668)
%t9670 = call i512 @__m_________lib_word_resid__pi_mul(i512 %t9669, i512 %p3)
%t9671 = call i512 @__m_________lib_chachag_resid__pg_reduce__g_Int_512__Int_64_(i512 %t9670)
%t9672 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %t9656)
%t9673 = extractvalue {i64, i1} %t9672, 0
%t9674 = extractvalue {i64, i1} %t9672, 1
%t9675 = zext i1 %t9674 to i8
call void @resid_overflow_check(i8 %t9675)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m_________lib_chachag_resid__pg_bytes__g_Int_512__Int_64_(i512 %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi i512 [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9679, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t9688, %tco.s0 ]
%t9677 = icmp sge i64 %p1, 16
br i1 %t9677, label %L1099, label %L1101
L1099:
%t9678 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty9678)
ret ptr %t9678
L1101:
%t9679 = add nsw i64 %p1, 1
%t9680 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 8, i64 %p1)
%t9681 = extractvalue {i64, i1} %t9680, 0
%t9682 = extractvalue {i64, i1} %t9680, 1
%t9683 = zext i1 %t9682 to i8
call void @resid_overflow_check(i8 %t9683)
%t9684 = call i64 @__m_________lib_word_resid__pi_byte(i512 %p0, i64 %t9681)
%t9685 = call ptr @resid_box_i64(i64 %t9684)
%t9688 = call ptr @resid_listbuf_push(ptr %p2, ptr %t9685)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m_________lib_chachag_resid__cg_mac_input__g_Int_64__Int_64_(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9690 = call i64 @resid_list_len(ptr %p0)
%t9691 = call i64 @__m_________lib_chachag_resid__cg_pad16(i64 %t9690)
%t9692 = call ptr @resid_listbuf_new()
%t9693 = call ptr @__m_________lib_chachag_resid__cg_zeros(i64 %t9691, i64 0, ptr %t9692)
%t9694 = call ptr @resid_list_freeze(ptr %t9693)
%t9695 = call ptr @resid_list_concat(ptr %p0, ptr %t9694)
%t9696 = call i64 @resid_list_len(ptr %p1)
%t9697 = call i64 @__m_________lib_chachag_resid__cg_pad16(i64 %t9696)
%t9698 = call ptr @resid_listbuf_new()
%t9699 = call ptr @__m_________lib_chachag_resid__cg_zeros(i64 %t9697, i64 0, ptr %t9698)
%t9700 = call i64 @resid_list_len(ptr %p0)
%t9701 = call ptr @resid_listbuf_new()
%t9702 = call ptr @__m_________lib_chachag_resid__cg_le64(i64 %t9700, i64 0, ptr %t9701)
%t9703 = call ptr @resid_list_freeze(ptr %t9702)
%t9704 = call ptr @resid_list_concat_own(ptr %t9699, i8 1, ptr %t9703)
%t9705 = call i64 @resid_list_len(ptr %p1)
%t9706 = call ptr @resid_listbuf_new()
%t9707 = call ptr @__m_________lib_chachag_resid__cg_le64(i64 %t9705, i64 0, ptr %t9706)
%t9708 = call ptr @resid_list_freeze(ptr %t9707)
%t9709 = call ptr @resid_list_concat_own(ptr %t9704, i8 1, ptr %t9708)
%t9710 = call ptr @resid_listbuf_new()
%t9711 = call ptr @resid_listbuf_new()
%t9712 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t9695, i64 0, ptr %t9710)
%t9713 = call ptr @resid_list_concat_own(ptr %t9712, i8 1, ptr %p1)
%t9714 = call ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %t9709, i64 0, ptr %t9711)
%t9715 = call ptr @resid_list_freeze(ptr %t9714)
%t9716 = call ptr @resid_list_concat_own(ptr %t9713, i8 1, ptr %t9715)
ret ptr %t9716
}
define ptr @w_lift_bytes__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9724, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t9728, %tco.s0 ]
%t9717 = call i64 @resid_list_len(ptr %p0)
%t9718 = icmp sge i64 %p1, %t9717
br i1 %t9718, label %L1102, label %L1104
L1102:
%t9719 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty9719)
ret ptr %t9719
L1104:
%t9720 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t9721 = call i64 @resid_unbox_i64(ptr %t9720)
%t9723 = call i64 @__m_________lib_word_resid__bi_lift(i64 %t9721)
%t9724 = add nsw i64 %p1, 1
%t9725 = call ptr @resid_box_i64(i64 %t9723)
%t9728 = call ptr @resid_listbuf_push(ptr %p2, ptr %t9725)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m_________lib_sha256g_resid__g_sched__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9730 = icmp slt i64 %p2, 16
br i1 %t9730, label %L1105, label %L1107
L1105:
%t9731 = call i64 @__m_________lib_sha256g_resid__g_word_at__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2)
ret i64 %t9731
L1107:
%t9732 = call i64 @__m_________lib_sha256g_resid__g_ssig1__g_Int_64__Int_64_(i64 %p6)
%t9733 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9732, i64 %p5)
%t9734 = call i64 @__m_________lib_sha256g_resid__g_ssig0__g_Int_64__Int_64_(i64 %p4)
%t9735 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9734, i64 %p3)
%t9736 = call i64 @__m_________lib_word_resid__wi_add(i64 %t9733, i64 %t9735)
ret i64 %t9736
}
define i64 @__m_________lib_sha256g_resid__g_bsig1__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9737 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %p0, i64 6)
%t9738 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %p0, i64 11)
%t9739 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t9737, i64 %t9738)
%t9740 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %p0, i64 25)
%t9741 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t9739, i64 %t9740)
ret i64 %t9741
}
define i64 @__m_________lib_sha256g_resid__g_ch__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9742 = call i64 @__m_________lib_word_resid__wi_and(i64 %p0, i64 %p1)
%t9743 = call i64 @__m_________lib_word_resid__wi_not(i64 %p0)
%t9744 = call i64 @__m_________lib_word_resid__wi_and(i64 %t9743, i64 %p2)
%t9745 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t9742, i64 %t9744)
ret i64 %t9745
}
define i64 @__m_________lib_sha256g_resid__g_bsig0__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9746 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %p0, i64 2)
%t9747 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %p0, i64 13)
%t9748 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t9746, i64 %t9747)
%t9749 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %p0, i64 22)
%t9750 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t9748, i64 %t9749)
ret i64 %t9750
}
define i64 @__m_________lib_sha256g_resid__g_maj__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9751 = call i64 @__m_________lib_word_resid__wi_and(i64 %p0, i64 %p1)
%t9752 = call i64 @__m_________lib_word_resid__wi_and(i64 %p0, i64 %p2)
%t9753 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t9751, i64 %t9752)
%t9754 = call i64 @__m_________lib_word_resid__wi_and(i64 %p1, i64 %p2)
%t9755 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t9753, i64 %t9754)
ret i64 %t9755
}
define ptr @__m_________lib_crypto_resid__b64g_finish__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9756 = call i64 @__m_________lib_word_resid__wi_byte(i64 %p1, i64 24)
%t9757 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyB9757)
%t9758 = alloca [1 x ptr]
%t9760 = call ptr @resid_box_i64(i64 %t9756)
%t9762 = getelementptr i8, ptr %t9758, i64 0
store ptr %t9760, ptr %t9762
%t9763 = call ptr @resid_list_new(i64 1, ptr %t9758, ptr @.lty9758)
%t9765 = call ptr @resid_list_const_i64(ptr @.lc9764, i64 1, ptr @.lcd9764, ptr @.lty9764)
%t9766 = call i1 @__m_________lib_crypto_resid__ct_same_pub(ptr %t9763, ptr %t9765)
%t9767 = xor i1 %t9766, true
br i1 %t9767, label %L1108, label %L1110
L1108:
ret ptr %t9757
L1110:
ret ptr %p0
}
define i64 @__m_________lib_crypto_resid__b64g_at__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9768 = call i64 @resid_list_len(ptr %p0)
%t9769 = icmp sge i64 %p1, %t9768
br i1 %t9769, label %L1111, label %L1113
L1111:
ret i64 0
L1113:
%t9770 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t9771 = call i64 @resid_unbox_i64(ptr %t9770)
%t9773 = call i64 @__m_________lib_word_resid__wi_from_byte(i64 %t9771)
%t9774 = call i64 @b64g_sextet__g_Int_64__Int_64_(i64 %t9773)
ret i64 %t9774
}
define i64 @__m_________lib_crypto_resid__b64g_join__g_Int_64__Int_64_(i64 %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9775 = call i64 @__m_________lib_word_resid__wi_andk(i64 %p0, i64 63)
%t9776 = call i64 @__m_________lib_word_resid__wi_shl(i64 %t9775, i64 18)
%t9777 = call i64 @__m_________lib_word_resid__wi_andk(i64 %p1, i64 63)
%t9778 = call i64 @__m_________lib_word_resid__wi_shl(i64 %t9777, i64 12)
%t9779 = call i64 @__m_________lib_word_resid__wi_or(i64 %t9776, i64 %t9778)
%t9780 = call i64 @__m_________lib_word_resid__wi_andk(i64 %p2, i64 63)
%t9781 = call i64 @__m_________lib_word_resid__wi_shl(i64 %t9780, i64 6)
%t9782 = call i64 @__m_________lib_word_resid__wi_andk(i64 %p3, i64 63)
%t9783 = call i64 @__m_________lib_word_resid__wi_or(i64 %t9781, i64 %t9782)
%t9784 = call i64 @__m_________lib_word_resid__wi_or(i64 %p0, i64 %p1)
%t9785 = call i64 @__m_________lib_word_resid__wi_or(i64 %p2, i64 %p3)
%t9786 = call i64 @__m_________lib_word_resid__wi_or(i64 %t9784, i64 %t9785)
%t9787 = call i64 @__m_________lib_word_resid__wi_andk(i64 %t9786, i64 256)
%t9788 = call i64 @__m_________lib_word_resid__wi_shr(i64 %t9787, i64 8)
%t9789 = call i64 @__m_________lib_word_resid__wi_shl(i64 %t9788, i64 24)
%t9790 = call i64 @__m_________lib_word_resid__wi_or(i64 %t9779, i64 %t9783)
%t9791 = call i64 @__m_________lib_word_resid__wi_or(i64 %t9790, i64 %t9789)
ret i64 %t9791
}
define ptr @__m_________lib_sha512g_resid__g5_hash__g_Int_64__UInt_64_(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9792 = call ptr @resid_listbuf_new()
%t9793 = call ptr @resid_listbuf_new()
%t9794 = call i64 @resid_list_len(ptr %p0)
%t9795 = call ptr @sha512g_pad(i64 %t9794)
%t9796 = call ptr @resid_list_freeze(ptr %t9795)
%t9797 = call ptr @__m_________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %t9796, i64 0, ptr %t9792)
%t9798 = call ptr @resid_list_freeze(ptr %t9797)
%t9799 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t9798)
%t9800 = call ptr @__m_________lib_sha512g_resid__g5_lift_state__g_UInt_64__Int_64_(ptr %p1)
%t9801 = call i64 @resid_list_len(ptr %t9799)
%t9802 = call ptr @sha512g_blocks__g_Int_64__UInt_64_(ptr %t9799, i64 0, i64 %t9801, ptr %t9800)
%t9803 = call ptr @__m_________lib_sha512g_resid__g5_out__g_UInt_64__Int_64_(ptr %t9802, i64 %p2, i64 0, ptr %t9793)
ret ptr %t9803
}
define ptr @__m_________lib_sha512g_resid__g5_lift_bytes__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9811, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t9816, %tco.s0 ]
%t9804 = call i64 @resid_list_len(ptr %p0)
%t9805 = icmp sge i64 %p1, %t9804
br i1 %t9805, label %L1114, label %L1116
L1114:
%t9806 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty9806)
ret ptr %t9806
L1116:
%t9807 = call ptr @resid_list_get_v(ptr %p0, i64 %p1, ptr %p0.ld, i64 %p0.ln)
%t9808 = call i64 @resid_unbox_i64(ptr %t9807)
%t9810 = call i64 @__m_________lib_word_resid__di_lift(i64 %t9808)
%t9811 = add nsw i64 %p1, 1
%t9812 = call i64 @__m_________lib_word_resid__di_byte(i64 %t9810, i64 0)
%t9813 = call ptr @resid_box_i64(i64 %t9812)
%t9816 = call ptr @resid_listbuf_push(ptr %p2, ptr %t9813)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m_________lib_chachag_resid__cg_state_w__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9818 = and i64 %p1, 4294967295
%t9819 = call i64 @__m_________lib_word_resid__wi_lift(i64 %t9818)
%t9820 = call i64 @__m_________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 0)
%t9821 = call i64 @__m_________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 4)
%t9822 = call i64 @__m_________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 8)
%t9823 = call i64 @__m_________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 12)
%t9824 = call i64 @__m_________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 16)
%t9825 = call i64 @__m_________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 20)
%t9826 = call i64 @__m_________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 24)
%t9827 = call i64 @__m_________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 28)
%t9828 = alloca [16 x ptr]
%t9830 = call ptr @resid_box_i64(i64 1634760805)
%t9832 = getelementptr i8, ptr %t9828, i64 0
store ptr %t9830, ptr %t9832
%t9833 = call ptr @resid_box_i64(i64 857760878)
%t9835 = getelementptr i8, ptr %t9828, i64 8
store ptr %t9833, ptr %t9835
%t9836 = call ptr @resid_box_i64(i64 2036477234)
%t9838 = getelementptr i8, ptr %t9828, i64 16
store ptr %t9836, ptr %t9838
%t9839 = call ptr @resid_box_i64(i64 1797285236)
%t9841 = getelementptr i8, ptr %t9828, i64 24
store ptr %t9839, ptr %t9841
%t9842 = call ptr @resid_box_i64(i64 %t9820)
%t9844 = getelementptr i8, ptr %t9828, i64 32
store ptr %t9842, ptr %t9844
%t9845 = call ptr @resid_box_i64(i64 %t9821)
%t9847 = getelementptr i8, ptr %t9828, i64 40
store ptr %t9845, ptr %t9847
%t9848 = call ptr @resid_box_i64(i64 %t9822)
%t9850 = getelementptr i8, ptr %t9828, i64 48
store ptr %t9848, ptr %t9850
%t9851 = call ptr @resid_box_i64(i64 %t9823)
%t9853 = getelementptr i8, ptr %t9828, i64 56
store ptr %t9851, ptr %t9853
%t9854 = call ptr @resid_box_i64(i64 %t9824)
%t9856 = getelementptr i8, ptr %t9828, i64 64
store ptr %t9854, ptr %t9856
%t9857 = call ptr @resid_box_i64(i64 %t9825)
%t9859 = getelementptr i8, ptr %t9828, i64 72
store ptr %t9857, ptr %t9859
%t9860 = call ptr @resid_box_i64(i64 %t9826)
%t9862 = getelementptr i8, ptr %t9828, i64 80
store ptr %t9860, ptr %t9862
%t9863 = call ptr @resid_box_i64(i64 %t9827)
%t9865 = getelementptr i8, ptr %t9828, i64 88
store ptr %t9863, ptr %t9865
%t9866 = call ptr @resid_box_i64(i64 %t9819)
%t9868 = getelementptr i8, ptr %t9828, i64 96
store ptr %t9866, ptr %t9868
%t9869 = call ptr @resid_box_i64(i64 %p2)
%t9871 = getelementptr i8, ptr %t9828, i64 104
store ptr %t9869, ptr %t9871
%t9872 = call ptr @resid_box_i64(i64 %p3)
%t9874 = getelementptr i8, ptr %t9828, i64 112
store ptr %t9872, ptr %t9874
%t9875 = call ptr @resid_box_i64(i64 %p4)
%t9877 = getelementptr i8, ptr %t9828, i64 120
store ptr %t9875, ptr %t9877
%t9878 = call ptr @resid_list_new(i64 16, ptr %t9828, ptr @.lty9828)
ret ptr %t9878
}
define ptr @__m_________lib_chachag_resid__cg_words__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9879 = call ptr @resid_list_get(ptr %p0, i64 0)
%t9880 = call i64 @resid_unbox_i64(ptr %t9879)
%t9882 = call ptr @resid_list_get(ptr %p0, i64 1)
%t9883 = call i64 @resid_unbox_i64(ptr %t9882)
%t9885 = call ptr @resid_list_get(ptr %p0, i64 2)
%t9886 = call i64 @resid_unbox_i64(ptr %t9885)
%t9888 = call ptr @resid_list_get(ptr %p0, i64 3)
%t9889 = call i64 @resid_unbox_i64(ptr %t9888)
%t9891 = call ptr @resid_list_get(ptr %p0, i64 4)
%t9892 = call i64 @resid_unbox_i64(ptr %t9891)
%t9894 = call ptr @resid_list_get(ptr %p0, i64 5)
%t9895 = call i64 @resid_unbox_i64(ptr %t9894)
%t9897 = call ptr @resid_list_get(ptr %p0, i64 6)
%t9898 = call i64 @resid_unbox_i64(ptr %t9897)
%t9900 = call ptr @resid_list_get(ptr %p0, i64 7)
%t9901 = call i64 @resid_unbox_i64(ptr %t9900)
%t9903 = call ptr @resid_list_get(ptr %p0, i64 8)
%t9904 = call i64 @resid_unbox_i64(ptr %t9903)
%t9906 = call ptr @resid_list_get(ptr %p0, i64 9)
%t9907 = call i64 @resid_unbox_i64(ptr %t9906)
%t9909 = call ptr @resid_list_get(ptr %p0, i64 10)
%t9910 = call i64 @resid_unbox_i64(ptr %t9909)
%t9912 = call ptr @resid_list_get(ptr %p0, i64 11)
%t9913 = call i64 @resid_unbox_i64(ptr %t9912)
%t9915 = call ptr @resid_list_get(ptr %p0, i64 13)
%t9916 = call i64 @resid_unbox_i64(ptr %t9915)
%t9918 = call ptr @resid_list_get(ptr %p0, i64 14)
%t9919 = call i64 @resid_unbox_i64(ptr %t9918)
%t9921 = call ptr @resid_list_get(ptr %p0, i64 15)
%t9922 = call i64 @resid_unbox_i64(ptr %t9921)
%t9924 = call ptr @__m_________lib_chachag_resid__cg_core__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 10, i64 %t9880, i64 %t9883, i64 %t9886, i64 %t9889, i64 %t9892, i64 %t9895, i64 %t9898, i64 %t9901, i64 %t9904, i64 %t9907, i64 %t9910, i64 %t9913, i64 %p1, i64 %t9916, i64 %t9919, i64 %t9922)
ret ptr %t9924
}
define ptr @__m_________lib_chachag_resid__cg_ser__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t9927, %tco.s0 ]
%p2 = phi ptr [ %p2.in, %entry ], [ %t9938, %tco.s0 ]
%t9925 = icmp sge i64 %p1, 64
br i1 %t9925, label %L1117, label %L1119
L1117:
%t9926 = call ptr @resid_listbuf_finish(ptr %p2, ptr @.lty9926)
ret ptr %t9926
L1119:
%t9927 = add nsw i64 %p1, 1
%t9928 = sdiv i64 %p1, 4
%t9929 = call ptr @resid_list_get_v(ptr %p0, i64 %t9928, ptr %p0.ld, i64 %p0.ln)
%t9930 = call i64 @resid_unbox_i64(ptr %t9929)
%t9932 = srem i64 %p1, 4
%t9933 = mul nsw i64 %t9932, 8
%t9934 = call i64 @__m_________lib_word_resid__wi_byte(i64 %t9930, i64 %t9933)
%t9935 = call ptr @resid_box_i64(i64 %t9934)
%t9938 = call ptr @resid_listbuf_push(ptr %p2, ptr %t9935)
br label %tco.s0
tco.s0:
br label %tco.head
}
define ptr @__m_________lib_chachag_resid__cg_xor_bytes__g_Int_64__Int_64_(ptr %p0.in, ptr %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, ptr %p5.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
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
%p3 = phi i64 [ %p3.in, %entry ], [ %t9941, %tco.s0 ]
%p4 = phi i64 [ %p4.in, %entry ], [ %p4, %tco.s0 ]
%p5 = phi ptr [ %p5.in, %entry ], [ %t9960, %tco.s0 ]
%t9940 = icmp sge i64 %p3, %p4
br i1 %t9940, label %L1120, label %L1122
L1120:
ret ptr %p5
L1122:
%t9941 = add nsw i64 %p3, 1
%t9942 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 %p3)
%t9943 = extractvalue {i64, i1} %t9942, 0
%t9944 = extractvalue {i64, i1} %t9942, 1
%t9945 = zext i1 %t9944 to i8
call void @resid_overflow_check(i8 %t9945)
%t9946 = call ptr @resid_list_get_v(ptr %p1, i64 %t9943, ptr %p1.ld, i64 %p1.ln)
%t9947 = call i64 @resid_unbox_i64(ptr %t9946)
%t9949 = sdiv i64 %p3, 4
%t9950 = call ptr @resid_list_get_v(ptr %p0, i64 %t9949, ptr %p0.ld, i64 %p0.ln)
%t9951 = call i64 @resid_unbox_i64(ptr %t9950)
%t9953 = srem i64 %p3, 4
%t9954 = mul nsw i64 %t9953, 8
%t9955 = call i64 @__m_________lib_word_resid__wi_byte(i64 %t9951, i64 %t9954)
%t9956 = call i64 @__m_________lib_word_resid__bi_xor(i64 %t9947, i64 %t9955)
%t9957 = call ptr @resid_box_i64(i64 %t9956)
%t9960 = call ptr @resid_listbuf_push(ptr %p5, ptr %t9957)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i512 @__m_________lib_chachag_resid__pg_reduce__g_Int_512__Int_64_(i512 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9962 = sext i256 1361129467683753853853498429727072845823 to i512
%t9963 = call i512 @__m_________lib_word_resid__pi_and(i512 %p0, i512 %t9962)
%t9964 = call i512 @__m_________lib_word_resid__pi_shr(i512 %p0, i64 130)
%t9965 = call i512 @__m_________lib_word_resid__pi_mul(i512 %t9964, i512 5)
%t9966 = call i512 @__m_________lib_word_resid__pi_add(i512 %t9963, i512 %t9965)
%t9967 = sext i256 1361129467683753853853498429727072845823 to i512
%t9968 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9966, i512 %t9967)
%t9969 = call i512 @__m_________lib_word_resid__pi_shr(i512 %t9966, i64 130)
%t9970 = call i512 @__m_________lib_word_resid__pi_mul(i512 %t9969, i512 5)
%t9971 = call i512 @__m_________lib_word_resid__pi_add(i512 %t9968, i512 %t9970)
%t9972 = sext i256 1361129467683753853853498429727072845819 to i512
%t9973 = call i512 @__m_________lib_word_resid__pi_sub(i512 %t9971, i512 %t9972)
%t9974 = call i512 @__m_________lib_word_resid__pi_sign(i512 %t9973)
%t9975 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9971, i512 %t9974)
%t9976 = sext i64 -1 to i512
%t9977 = call i512 @__m_________lib_word_resid__pi_xor(i512 %t9974, i512 %t9976)
%t9978 = call i512 @__m_________lib_word_resid__pi_and(i512 %t9973, i512 %t9977)
%t9979 = call i512 @__m_________lib_word_resid__pi_or(i512 %t9975, i512 %t9978)
ret i512 %t9979
}
define i64 @__m_________lib_sha256g_resid__g_word_at__g_Int_64__Int_64_(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t9980 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 4)
%t9981 = extractvalue {i64, i1} %t9980, 0
%t9982 = extractvalue {i64, i1} %t9980, 1
%t9983 = zext i1 %t9982 to i8
call void @resid_overflow_check(i8 %t9983)
%t9984 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t9981)
%t9985 = extractvalue {i64, i1} %t9984, 0
%t9986 = extractvalue {i64, i1} %t9984, 1
%t9987 = zext i1 %t9986 to i8
call void @resid_overflow_check(i8 %t9987)
%t9988 = call ptr @resid_list_get(ptr %p0, i64 %t9985)
%t9989 = call i64 @resid_unbox_i64(ptr %t9988)
%t9991 = call i64 @__m_________lib_word_resid__wi_from_byte(i64 %t9989)
%t9992 = call i64 @__m_________lib_word_resid__wi_shl(i64 %t9991, i64 24)
%t9993 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t9985, i64 1)
%t9994 = extractvalue {i64, i1} %t9993, 0
%t9995 = extractvalue {i64, i1} %t9993, 1
%t9996 = zext i1 %t9995 to i8
call void @resid_overflow_check(i8 %t9996)
%t9997 = call ptr @resid_list_get(ptr %p0, i64 %t9994)
%t9998 = call i64 @resid_unbox_i64(ptr %t9997)
%t10000 = call i64 @__m_________lib_word_resid__wi_from_byte(i64 %t9998)
%t10001 = call i64 @__m_________lib_word_resid__wi_shl(i64 %t10000, i64 16)
%t10002 = call i64 @__m_________lib_word_resid__wi_or(i64 %t9992, i64 %t10001)
%t10003 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t9985, i64 2)
%t10004 = extractvalue {i64, i1} %t10003, 0
%t10005 = extractvalue {i64, i1} %t10003, 1
%t10006 = zext i1 %t10005 to i8
call void @resid_overflow_check(i8 %t10006)
%t10007 = call ptr @resid_list_get(ptr %p0, i64 %t10004)
%t10008 = call i64 @resid_unbox_i64(ptr %t10007)
%t10010 = call i64 @__m_________lib_word_resid__wi_from_byte(i64 %t10008)
%t10011 = call i64 @__m_________lib_word_resid__wi_shl(i64 %t10010, i64 8)
%t10012 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t9985, i64 3)
%t10013 = extractvalue {i64, i1} %t10012, 0
%t10014 = extractvalue {i64, i1} %t10012, 1
%t10015 = zext i1 %t10014 to i8
call void @resid_overflow_check(i8 %t10015)
%t10016 = call ptr @resid_list_get(ptr %p0, i64 %t10013)
%t10017 = call i64 @resid_unbox_i64(ptr %t10016)
%t10019 = call i64 @__m_________lib_word_resid__wi_from_byte(i64 %t10017)
%t10020 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10011, i64 %t10019)
%t10021 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10002, i64 %t10020)
ret i64 %t10021
}
define i64 @__m_________lib_sha256g_resid__g_ssig1__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10022 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %p0, i64 17)
%t10023 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %p0, i64 19)
%t10024 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10022, i64 %t10023)
%t10025 = call i64 @__m_________lib_word_resid__wi_shr(i64 %p0, i64 10)
%t10026 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10024, i64 %t10025)
ret i64 %t10026
}
define i64 @__m_________lib_sha256g_resid__g_ssig0__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10027 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %p0, i64 7)
%t10028 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %p0, i64 18)
%t10029 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10027, i64 %t10028)
%t10030 = call i64 @__m_________lib_word_resid__wi_shr(i64 %p0, i64 3)
%t10031 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10029, i64 %t10030)
ret i64 %t10031
}
define i64 @b64g_sextet__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10032 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 65, i64 90)
%t10033 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 97, i64 122)
%t10034 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 48, i64 57)
%t10035 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 43, i64 43)
%t10036 = call i64 @b64g_in__g_Int_64__Int_64_(i64 %p0, i64 47, i64 47)
%t10037 = call i64 @__m_________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t10032)
%t10038 = call i64 @__m_________lib_word_resid__wi_addk(i64 %p0, i64 -65)
%t10039 = call i64 @__m_________lib_word_resid__wi_and(i64 %t10037, i64 %t10038)
%t10040 = call i64 @__m_________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t10033)
%t10041 = call i64 @__m_________lib_word_resid__wi_addk(i64 %p0, i64 -71)
%t10042 = call i64 @__m_________lib_word_resid__wi_and(i64 %t10040, i64 %t10041)
%t10043 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10039, i64 %t10042)
%t10044 = call i64 @__m_________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t10034)
%t10045 = call i64 @__m_________lib_word_resid__wi_addk(i64 %p0, i64 4)
%t10046 = call i64 @__m_________lib_word_resid__wi_and(i64 %t10044, i64 %t10045)
%t10047 = call i64 @__m_________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t10035)
%t10048 = call i64 @__m_________lib_word_resid__wi_andk(i64 %t10047, i64 62)
%t10049 = call i64 @__m_________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %t10036)
%t10050 = call i64 @__m_________lib_word_resid__wi_andk(i64 %t10049, i64 63)
%t10051 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10048, i64 %t10050)
%t10052 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10046, i64 %t10051)
%t10053 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10032, i64 %t10033)
%t10054 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10035, i64 %t10036)
%t10055 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10034, i64 %t10054)
%t10056 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10053, i64 %t10055)
%t10057 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10043, i64 %t10052)
%t10058 = call i64 @__m_________lib_word_resid__wi_andk(i64 %t10057, i64 63)
%t10059 = call i64 @__m_________lib_word_resid__wi_xork(i64 %t10056, i64 1)
%t10060 = call i64 @__m_________lib_word_resid__wi_shl(i64 %t10059, i64 8)
%t10061 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10058, i64 %t10060)
ret i64 %t10061
}
define ptr @__m_________lib_sha512g_resid__g5_lift_state__g_UInt_64__Int_64_(ptr %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10062 = call ptr @resid_gmalloc(i64 64)
%t10063 = call ptr @resid_list_get(ptr %p0, i64 0)
%t10064 = call i64 @resid_unbox_i64(ptr %t10063)
%t10066 = call i64 @__m_________lib_word_resid__di_lift(i64 %t10064)
%t10062.f0 = getelementptr i8, ptr %t10062, i64 0
store i64 %t10066, ptr %t10062.f0, align 8
%t10067 = call ptr @resid_list_get(ptr %p0, i64 1)
%t10068 = call i64 @resid_unbox_i64(ptr %t10067)
%t10070 = call i64 @__m_________lib_word_resid__di_lift(i64 %t10068)
%t10062.f1 = getelementptr i8, ptr %t10062, i64 8
store i64 %t10070, ptr %t10062.f1, align 8
%t10071 = call ptr @resid_list_get(ptr %p0, i64 2)
%t10072 = call i64 @resid_unbox_i64(ptr %t10071)
%t10074 = call i64 @__m_________lib_word_resid__di_lift(i64 %t10072)
%t10062.f2 = getelementptr i8, ptr %t10062, i64 16
store i64 %t10074, ptr %t10062.f2, align 8
%t10075 = call ptr @resid_list_get(ptr %p0, i64 3)
%t10076 = call i64 @resid_unbox_i64(ptr %t10075)
%t10078 = call i64 @__m_________lib_word_resid__di_lift(i64 %t10076)
%t10062.f3 = getelementptr i8, ptr %t10062, i64 24
store i64 %t10078, ptr %t10062.f3, align 8
%t10079 = call ptr @resid_list_get(ptr %p0, i64 4)
%t10080 = call i64 @resid_unbox_i64(ptr %t10079)
%t10082 = call i64 @__m_________lib_word_resid__di_lift(i64 %t10080)
%t10062.f4 = getelementptr i8, ptr %t10062, i64 32
store i64 %t10082, ptr %t10062.f4, align 8
%t10083 = call ptr @resid_list_get(ptr %p0, i64 5)
%t10084 = call i64 @resid_unbox_i64(ptr %t10083)
%t10086 = call i64 @__m_________lib_word_resid__di_lift(i64 %t10084)
%t10062.f5 = getelementptr i8, ptr %t10062, i64 40
store i64 %t10086, ptr %t10062.f5, align 8
%t10087 = call ptr @resid_list_get(ptr %p0, i64 6)
%t10088 = call i64 @resid_unbox_i64(ptr %t10087)
%t10090 = call i64 @__m_________lib_word_resid__di_lift(i64 %t10088)
%t10062.f6 = getelementptr i8, ptr %t10062, i64 48
store i64 %t10090, ptr %t10062.f6, align 8
%t10091 = call ptr @resid_list_get(ptr %p0, i64 7)
%t10092 = call i64 @resid_unbox_i64(ptr %t10091)
%t10094 = call i64 @__m_________lib_word_resid__di_lift(i64 %t10092)
%t10062.f7 = getelementptr i8, ptr %t10062, i64 56
store i64 %t10094, ptr %t10062.f7, align 8
ret ptr %t10062
}
define ptr @sha512g_blocks__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %t10097, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi ptr [ %p3.in, %entry ], [ %p3.ev.tco.s0, %tco.s0.k ]
%t10095 = icmp sge i64 %p1, %p2
br i1 %t10095, label %L1123, label %L1125
L1123:
%lr.cx11 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz11 = icmp eq ptr %lr.cx11, null
br i1 %lr.lz11, label %lr.x11.k, label %lr.x11.m
lr.x11.k:
ret ptr %p3
lr.x11.m:
%lr.ret11 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %p3, ptr %lr.cx11)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret11
L1125:
%t10096 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 128)
%t10097 = extractvalue {i64, i1} %t10096, 0
%t10098 = extractvalue {i64, i1} %t10096, 1
%t10099 = zext i1 %t10098 to i8
call void @resid_overflow_check(i8 %t10099)
%t10100 = call ptr @sha512g_block__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %p3)
br label %tco.s0
tco.s0:
%lr.due.tco.s0 = call i1 @resid_loop_due(i64 %lml)
br i1 %lr.due.tco.s0, label %tco.s0.c, label %tco.s0.k
tco.s0.c:
%lr.cx.tco.s0 = call ptr @resid_loop_move(i64 %lml, i64 1)
%p0.e.tco.s0 = call ptr @resid_mv_list(ptr %p0, ptr %lr.cx.tco.s0)
%p3.e.tco.s0 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %t10100, ptr %lr.cx.tco.s0)
call ptr @resid_loop_move(i64 %lml, i64 2)
br label %tco.s0.k
tco.s0.k:
%p0.ev.tco.s0 = phi ptr [ %p0.e.tco.s0, %tco.s0.c ], [ %p0, %tco.s0 ]
%p3.ev.tco.s0 = phi ptr [ %p3.e.tco.s0, %tco.s0.c ], [ %t10100, %tco.s0 ]
br label %tco.head
}
define ptr @__m_________lib_sha512g_resid__g5_out__g_UInt_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, ptr %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t10104, %tco.s0 ]
%p3 = phi ptr [ %p3.in, %entry ], [ %t10114, %tco.s0 ]
%t10102 = icmp sge i64 %p2, %p1
br i1 %t10102, label %L1126, label %L1128
L1126:
%t10103 = call ptr @resid_listbuf_finish(ptr %p3, ptr @.lty10103)
ret ptr %t10103
L1128:
%t10104 = add nsw i64 %p2, 1
%t10105 = sdiv i64 %p2, 8
%t10106 = call i64 @__m_________lib_sha512g_resid__g5_state_word__g_UInt_64__Int_64_(ptr %p0, i64 %t10105)
%t10107 = srem i64 %p2, 8
%t10108 = mul nsw i64 %t10107, 8
%t10109 = sub nsw i64 56, %t10108
%t10110 = call i64 @__m_________lib_word_resid__di_byte(i64 %t10106, i64 %t10109)
%t10111 = call ptr @resid_box_i64(i64 %t10110)
%t10114 = call ptr @resid_listbuf_push(ptr %p3, ptr %t10111)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m_________lib_chachag_resid__cg_key_word__g_Int_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10116 = call ptr @resid_list_get(ptr %p0, i64 %p1)
%t10117 = call i64 @resid_unbox_i64(ptr %t10116)
%t10119 = call i64 @__m_________lib_word_resid__wi_from_byte(i64 %t10117)
%t10120 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 1)
%t10121 = extractvalue {i64, i1} %t10120, 0
%t10122 = extractvalue {i64, i1} %t10120, 1
%t10123 = zext i1 %t10122 to i8
call void @resid_overflow_check(i8 %t10123)
%t10124 = call ptr @resid_list_get(ptr %p0, i64 %t10121)
%t10125 = call i64 @resid_unbox_i64(ptr %t10124)
%t10127 = call i64 @__m_________lib_word_resid__wi_from_byte(i64 %t10125)
%t10128 = call i64 @__m_________lib_word_resid__wi_shl(i64 %t10127, i64 8)
%t10129 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10119, i64 %t10128)
%t10130 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 2)
%t10131 = extractvalue {i64, i1} %t10130, 0
%t10132 = extractvalue {i64, i1} %t10130, 1
%t10133 = zext i1 %t10132 to i8
call void @resid_overflow_check(i8 %t10133)
%t10134 = call ptr @resid_list_get(ptr %p0, i64 %t10131)
%t10135 = call i64 @resid_unbox_i64(ptr %t10134)
%t10137 = call i64 @__m_________lib_word_resid__wi_from_byte(i64 %t10135)
%t10138 = call i64 @__m_________lib_word_resid__wi_shl(i64 %t10137, i64 16)
%t10139 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 3)
%t10140 = extractvalue {i64, i1} %t10139, 0
%t10141 = extractvalue {i64, i1} %t10139, 1
%t10142 = zext i1 %t10141 to i8
call void @resid_overflow_check(i8 %t10142)
%t10143 = call ptr @resid_list_get(ptr %p0, i64 %t10140)
%t10144 = call i64 @resid_unbox_i64(ptr %t10143)
%t10146 = call i64 @__m_________lib_word_resid__wi_from_byte(i64 %t10144)
%t10147 = call i64 @__m_________lib_word_resid__wi_shl(i64 %t10146, i64 24)
%t10148 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10138, i64 %t10147)
%t10149 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10129, i64 %t10148)
ret i64 %t10149
}
define ptr @__m_________lib_chachag_resid__cg_core__g_Int_64__Int_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in, i64 %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10212 = alloca [16 x ptr]
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t10360, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t10317, %tco.s0.k ]
%p4 = phi i64 [ %p4.in, %entry ], [ %t10329, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t10341, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %t10353, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %t10358, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %t10322, %tco.s0.k ]
%p9 = phi i64 [ %p9.in, %entry ], [ %t10334, %tco.s0.k ]
%p10 = phi i64 [ %p10.in, %entry ], [ %t10346, %tco.s0.k ]
%p11 = phi i64 [ %p11.in, %entry ], [ %t10344, %tco.s0.k ]
%p12 = phi i64 [ %p12.in, %entry ], [ %t10356, %tco.s0.k ]
%p13 = phi i64 [ %p13.in, %entry ], [ %t10320, %tco.s0.k ]
%p14 = phi i64 [ %p14.in, %entry ], [ %t10332, %tco.s0.k ]
%p15 = phi i64 [ %p15.in, %entry ], [ %t10331, %tco.s0.k ]
%p16 = phi i64 [ %p16.in, %entry ], [ %t10343, %tco.s0.k ]
%p17 = phi i64 [ %p17.in, %entry ], [ %t10355, %tco.s0.k ]
%p18 = phi i64 [ %p18.in, %entry ], [ %t10319, %tco.s0.k ]
%t10150 = icmp eq i64 %p2, 0
br i1 %t10150, label %L1129, label %L1131
L1129:
%t10151 = call ptr @resid_list_get_v(ptr %p0, i64 0, ptr %p0.ld, i64 %p0.ln)
%t10152 = call i64 @resid_unbox_i64(ptr %t10151)
%t10154 = call i64 @__m_________lib_word_resid__wi_add(i64 %p3, i64 %t10152)
%t10155 = call ptr @resid_list_get_v(ptr %p0, i64 1, ptr %p0.ld, i64 %p0.ln)
%t10156 = call i64 @resid_unbox_i64(ptr %t10155)
%t10158 = call i64 @__m_________lib_word_resid__wi_add(i64 %p4, i64 %t10156)
%t10159 = call ptr @resid_list_get_v(ptr %p0, i64 2, ptr %p0.ld, i64 %p0.ln)
%t10160 = call i64 @resid_unbox_i64(ptr %t10159)
%t10162 = call i64 @__m_________lib_word_resid__wi_add(i64 %p5, i64 %t10160)
%t10163 = call ptr @resid_list_get_v(ptr %p0, i64 3, ptr %p0.ld, i64 %p0.ln)
%t10164 = call i64 @resid_unbox_i64(ptr %t10163)
%t10166 = call i64 @__m_________lib_word_resid__wi_add(i64 %p6, i64 %t10164)
%t10167 = call ptr @resid_list_get_v(ptr %p0, i64 4, ptr %p0.ld, i64 %p0.ln)
%t10168 = call i64 @resid_unbox_i64(ptr %t10167)
%t10170 = call i64 @__m_________lib_word_resid__wi_add(i64 %p7, i64 %t10168)
%t10171 = call ptr @resid_list_get_v(ptr %p0, i64 5, ptr %p0.ld, i64 %p0.ln)
%t10172 = call i64 @resid_unbox_i64(ptr %t10171)
%t10174 = call i64 @__m_________lib_word_resid__wi_add(i64 %p8, i64 %t10172)
%t10175 = call ptr @resid_list_get_v(ptr %p0, i64 6, ptr %p0.ld, i64 %p0.ln)
%t10176 = call i64 @resid_unbox_i64(ptr %t10175)
%t10178 = call i64 @__m_________lib_word_resid__wi_add(i64 %p9, i64 %t10176)
%t10179 = call ptr @resid_list_get_v(ptr %p0, i64 7, ptr %p0.ld, i64 %p0.ln)
%t10180 = call i64 @resid_unbox_i64(ptr %t10179)
%t10182 = call i64 @__m_________lib_word_resid__wi_add(i64 %p10, i64 %t10180)
%t10183 = call ptr @resid_list_get_v(ptr %p0, i64 8, ptr %p0.ld, i64 %p0.ln)
%t10184 = call i64 @resid_unbox_i64(ptr %t10183)
%t10186 = call i64 @__m_________lib_word_resid__wi_add(i64 %p11, i64 %t10184)
%t10187 = call ptr @resid_list_get_v(ptr %p0, i64 9, ptr %p0.ld, i64 %p0.ln)
%t10188 = call i64 @resid_unbox_i64(ptr %t10187)
%t10190 = call i64 @__m_________lib_word_resid__wi_add(i64 %p12, i64 %t10188)
%t10191 = call ptr @resid_list_get_v(ptr %p0, i64 10, ptr %p0.ld, i64 %p0.ln)
%t10192 = call i64 @resid_unbox_i64(ptr %t10191)
%t10194 = call i64 @__m_________lib_word_resid__wi_add(i64 %p13, i64 %t10192)
%t10195 = call ptr @resid_list_get_v(ptr %p0, i64 11, ptr %p0.ld, i64 %p0.ln)
%t10196 = call i64 @resid_unbox_i64(ptr %t10195)
%t10198 = call i64 @__m_________lib_word_resid__wi_add(i64 %p14, i64 %t10196)
%t10199 = call i64 @__m_________lib_word_resid__wi_add(i64 %p15, i64 %p1)
%t10200 = call ptr @resid_list_get_v(ptr %p0, i64 13, ptr %p0.ld, i64 %p0.ln)
%t10201 = call i64 @resid_unbox_i64(ptr %t10200)
%t10203 = call i64 @__m_________lib_word_resid__wi_add(i64 %p16, i64 %t10201)
%t10204 = call ptr @resid_list_get_v(ptr %p0, i64 14, ptr %p0.ld, i64 %p0.ln)
%t10205 = call i64 @resid_unbox_i64(ptr %t10204)
%t10207 = call i64 @__m_________lib_word_resid__wi_add(i64 %p17, i64 %t10205)
%t10208 = call ptr @resid_list_get_v(ptr %p0, i64 15, ptr %p0.ld, i64 %p0.ln)
%t10209 = call i64 @resid_unbox_i64(ptr %t10208)
%t10211 = call i64 @__m_________lib_word_resid__wi_add(i64 %p18, i64 %t10209)
%t10214 = call ptr @resid_box_i64(i64 %t10154)
%t10216 = getelementptr i8, ptr %t10212, i64 0
store ptr %t10214, ptr %t10216
%t10217 = call ptr @resid_box_i64(i64 %t10158)
%t10219 = getelementptr i8, ptr %t10212, i64 8
store ptr %t10217, ptr %t10219
%t10220 = call ptr @resid_box_i64(i64 %t10162)
%t10222 = getelementptr i8, ptr %t10212, i64 16
store ptr %t10220, ptr %t10222
%t10223 = call ptr @resid_box_i64(i64 %t10166)
%t10225 = getelementptr i8, ptr %t10212, i64 24
store ptr %t10223, ptr %t10225
%t10226 = call ptr @resid_box_i64(i64 %t10170)
%t10228 = getelementptr i8, ptr %t10212, i64 32
store ptr %t10226, ptr %t10228
%t10229 = call ptr @resid_box_i64(i64 %t10174)
%t10231 = getelementptr i8, ptr %t10212, i64 40
store ptr %t10229, ptr %t10231
%t10232 = call ptr @resid_box_i64(i64 %t10178)
%t10234 = getelementptr i8, ptr %t10212, i64 48
store ptr %t10232, ptr %t10234
%t10235 = call ptr @resid_box_i64(i64 %t10182)
%t10237 = getelementptr i8, ptr %t10212, i64 56
store ptr %t10235, ptr %t10237
%t10238 = call ptr @resid_box_i64(i64 %t10186)
%t10240 = getelementptr i8, ptr %t10212, i64 64
store ptr %t10238, ptr %t10240
%t10241 = call ptr @resid_box_i64(i64 %t10190)
%t10243 = getelementptr i8, ptr %t10212, i64 72
store ptr %t10241, ptr %t10243
%t10244 = call ptr @resid_box_i64(i64 %t10194)
%t10246 = getelementptr i8, ptr %t10212, i64 80
store ptr %t10244, ptr %t10246
%t10247 = call ptr @resid_box_i64(i64 %t10198)
%t10249 = getelementptr i8, ptr %t10212, i64 88
store ptr %t10247, ptr %t10249
%t10250 = call ptr @resid_box_i64(i64 %t10199)
%t10252 = getelementptr i8, ptr %t10212, i64 96
store ptr %t10250, ptr %t10252
%t10253 = call ptr @resid_box_i64(i64 %t10203)
%t10255 = getelementptr i8, ptr %t10212, i64 104
store ptr %t10253, ptr %t10255
%t10256 = call ptr @resid_box_i64(i64 %t10207)
%t10258 = getelementptr i8, ptr %t10212, i64 112
store ptr %t10256, ptr %t10258
%t10259 = call ptr @resid_box_i64(i64 %t10211)
%t10261 = getelementptr i8, ptr %t10212, i64 120
store ptr %t10259, ptr %t10261
%t10262 = call ptr @resid_list_new(i64 16, ptr %t10212, ptr @.lty10212)
%lr.cx124 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz124 = icmp eq ptr %lr.cx124, null
br i1 %lr.lz124, label %lr.x124.k, label %lr.x124.m
lr.x124.k:
ret ptr %t10262
lr.x124.m:
%lr.ret124 = call ptr @resid_mv_list(ptr %t10262, ptr %lr.cx124)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret124
L1131:
%t10263 = call i64 @__m_________lib_word_resid__wi_add(i64 %p3, i64 %p7)
%t10264 = call i64 @__m_________lib_word_resid__wi_xor(i64 %p15, i64 %t10263)
%t10265 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10264, i64 16)
%t10266 = call i64 @__m_________lib_word_resid__wi_add(i64 %p11, i64 %t10265)
%t10267 = call i64 @__m_________lib_word_resid__wi_xor(i64 %p7, i64 %t10266)
%t10268 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10267, i64 20)
%t10269 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10263, i64 %t10268)
%t10270 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10265, i64 %t10269)
%t10271 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10270, i64 24)
%t10272 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10266, i64 %t10271)
%t10273 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10268, i64 %t10272)
%t10274 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10273, i64 25)
%t10275 = call i64 @__m_________lib_word_resid__wi_add(i64 %p4, i64 %p8)
%t10276 = call i64 @__m_________lib_word_resid__wi_xor(i64 %p16, i64 %t10275)
%t10277 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10276, i64 16)
%t10278 = call i64 @__m_________lib_word_resid__wi_add(i64 %p12, i64 %t10277)
%t10279 = call i64 @__m_________lib_word_resid__wi_xor(i64 %p8, i64 %t10278)
%t10280 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10279, i64 20)
%t10281 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10275, i64 %t10280)
%t10282 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10277, i64 %t10281)
%t10283 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10282, i64 24)
%t10284 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10278, i64 %t10283)
%t10285 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10280, i64 %t10284)
%t10286 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10285, i64 25)
%t10287 = call i64 @__m_________lib_word_resid__wi_add(i64 %p5, i64 %p9)
%t10288 = call i64 @__m_________lib_word_resid__wi_xor(i64 %p17, i64 %t10287)
%t10289 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10288, i64 16)
%t10290 = call i64 @__m_________lib_word_resid__wi_add(i64 %p13, i64 %t10289)
%t10291 = call i64 @__m_________lib_word_resid__wi_xor(i64 %p9, i64 %t10290)
%t10292 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10291, i64 20)
%t10293 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10287, i64 %t10292)
%t10294 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10289, i64 %t10293)
%t10295 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10294, i64 24)
%t10296 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10290, i64 %t10295)
%t10297 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10292, i64 %t10296)
%t10298 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10297, i64 25)
%t10299 = call i64 @__m_________lib_word_resid__wi_add(i64 %p6, i64 %p10)
%t10300 = call i64 @__m_________lib_word_resid__wi_xor(i64 %p18, i64 %t10299)
%t10301 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10300, i64 16)
%t10302 = call i64 @__m_________lib_word_resid__wi_add(i64 %p14, i64 %t10301)
%t10303 = call i64 @__m_________lib_word_resid__wi_xor(i64 %p10, i64 %t10302)
%t10304 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10303, i64 20)
%t10305 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10299, i64 %t10304)
%t10306 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10301, i64 %t10305)
%t10307 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10306, i64 24)
%t10308 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10302, i64 %t10307)
%t10309 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10304, i64 %t10308)
%t10310 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10309, i64 25)
%t10311 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10269, i64 %t10286)
%t10312 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10307, i64 %t10311)
%t10313 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10312, i64 16)
%t10314 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10296, i64 %t10313)
%t10315 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10286, i64 %t10314)
%t10316 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10315, i64 20)
%t10317 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10311, i64 %t10316)
%t10318 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10313, i64 %t10317)
%t10319 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10318, i64 24)
%t10320 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10314, i64 %t10319)
%t10321 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10316, i64 %t10320)
%t10322 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10321, i64 25)
%t10323 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10281, i64 %t10298)
%t10324 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10271, i64 %t10323)
%t10325 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10324, i64 16)
%t10326 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10308, i64 %t10325)
%t10327 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10298, i64 %t10326)
%t10328 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10327, i64 20)
%t10329 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10323, i64 %t10328)
%t10330 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10325, i64 %t10329)
%t10331 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10330, i64 24)
%t10332 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10326, i64 %t10331)
%t10333 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10328, i64 %t10332)
%t10334 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10333, i64 25)
%t10335 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10293, i64 %t10310)
%t10336 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10283, i64 %t10335)
%t10337 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10336, i64 16)
%t10338 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10272, i64 %t10337)
%t10339 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10310, i64 %t10338)
%t10340 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10339, i64 20)
%t10341 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10335, i64 %t10340)
%t10342 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10337, i64 %t10341)
%t10343 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10342, i64 24)
%t10344 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10338, i64 %t10343)
%t10345 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10340, i64 %t10344)
%t10346 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10345, i64 25)
%t10347 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10305, i64 %t10274)
%t10348 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10295, i64 %t10347)
%t10349 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10348, i64 16)
%t10350 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10284, i64 %t10349)
%t10351 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10274, i64 %t10350)
%t10352 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10351, i64 20)
%t10353 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10347, i64 %t10352)
%t10354 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10349, i64 %t10353)
%t10355 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10354, i64 24)
%t10356 = call i64 @__m_________lib_word_resid__wi_add(i64 %t10350, i64 %t10355)
%t10357 = call i64 @__m_________lib_word_resid__wi_xor(i64 %t10352, i64 %t10356)
%t10358 = call i64 @__m_________lib_word_resid__wi_rotr(i64 %t10357, i64 25)
%t10359 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %p2, i64 1)
%t10360 = extractvalue {i64, i1} %t10359, 0
%t10361 = extractvalue {i64, i1} %t10359, 1
%t10362 = zext i1 %t10361 to i8
call void @resid_overflow_check(i8 %t10362)
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
%t10364 = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 0, i64 %p1)
%t10365 = extractvalue {i64, i1} %t10364, 0
%t10366 = extractvalue {i64, i1} %t10364, 1
%t10367 = zext i1 %t10366 to i8
call void @resid_overflow_check(i8 %t10367)
%t10368 = call i64 @__m_________lib_word_resid__wi_addk(i64 %p0, i64 %t10365)
%t10369 = call i64 @__m_________lib_word_resid__wi_not(i64 %p0)
%t10370 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p2, i64 1)
%t10371 = extractvalue {i64, i1} %t10370, 0
%t10372 = extractvalue {i64, i1} %t10370, 1
%t10373 = zext i1 %t10372 to i8
call void @resid_overflow_check(i8 %t10373)
%t10374 = call i64 @__m_________lib_word_resid__wi_addk(i64 %t10369, i64 %t10371)
%t10375 = call i64 @__m_________lib_word_resid__wi_or(i64 %t10368, i64 %t10374)
%t10376 = call i64 @__m_________lib_word_resid__wi_shr(i64 %t10375, i64 31)
%t10377 = call i64 @__m_________lib_word_resid__wi_andk(i64 %t10376, i64 1)
%t10378 = call i64 @__m_________lib_word_resid__wi_xork(i64 %t10377, i64 1)
ret i64 %t10378
}
define i64 @__m_________lib_crypto_resid__b64g_mask__g_Int_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10379 = call i64 @__m_________lib_word_resid__wi_not(i64 %p0)
%t10380 = call i64 @__m_________lib_word_resid__wi_addk(i64 %t10379, i64 1)
ret i64 %t10380
}
define ptr @sha512g_block__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t10381 = add i64 4794697086780616226, 0
%t10382 = add i64 %t10381, 0
%t10383 = add i64 %t10382, 0
%t10384 = icmp ne i64 %t10383, %t10381
%t10385 = icmp slt i64 4794697086780616226, 0
%t10386 = or i1 %t10384, %t10385
%t10387 = zext i1 %t10386 to i8
call void @resid_conv_check(i8 %t10387)
%t10388 = add i64 8158064640168781261, 0
%t10389 = add i64 %t10388, 0
%t10390 = add i64 %t10389, 0
%t10391 = icmp ne i64 %t10390, %t10388
%t10392 = icmp slt i64 8158064640168781261, 0
%t10393 = or i1 %t10391, %t10392
%t10394 = zext i1 %t10393 to i8
call void @resid_conv_check(i8 %t10394)
%t10395 = add i128 13096744586834688815, 0
%t10396 = trunc i128 %t10395 to i64
%t10397 = zext i64 %t10396 to i128
%t10398 = icmp ne i128 %t10397, %t10395
%t10399 = icmp slt i128 13096744586834688815, 0
%t10400 = or i1 %t10398, %t10399
%t10401 = zext i1 %t10400 to i8
call void @resid_conv_check(i8 %t10401)
%t10402 = add i128 16840607885511220156, 0
%t10403 = trunc i128 %t10402 to i64
%t10404 = zext i64 %t10403 to i128
%t10405 = icmp ne i128 %t10404, %t10402
%t10406 = icmp slt i128 16840607885511220156, 0
%t10407 = or i1 %t10405, %t10406
%t10408 = zext i1 %t10407 to i8
call void @resid_conv_check(i8 %t10408)
%t10409 = add i64 4131703408338449720, 0
%t10410 = add i64 %t10409, 0
%t10411 = add i64 %t10410, 0
%t10412 = icmp ne i64 %t10411, %t10409
%t10413 = icmp slt i64 4131703408338449720, 0
%t10414 = or i1 %t10412, %t10413
%t10415 = zext i1 %t10414 to i8
call void @resid_conv_check(i8 %t10415)
%t10416 = add i64 6480981068601479193, 0
%t10417 = add i64 %t10416, 0
%t10418 = add i64 %t10417, 0
%t10419 = icmp ne i64 %t10418, %t10416
%t10420 = icmp slt i64 6480981068601479193, 0
%t10421 = or i1 %t10419, %t10420
%t10422 = zext i1 %t10421 to i8
call void @resid_conv_check(i8 %t10422)
%t10423 = add i128 10538285296894168987, 0
%t10424 = trunc i128 %t10423 to i64
%t10425 = zext i64 %t10424 to i128
%t10426 = icmp ne i128 %t10425, %t10423
%t10427 = icmp slt i128 10538285296894168987, 0
%t10428 = or i1 %t10426, %t10427
%t10429 = zext i1 %t10428 to i8
call void @resid_conv_check(i8 %t10429)
%t10430 = add i128 12329834152419229976, 0
%t10431 = trunc i128 %t10430 to i64
%t10432 = zext i64 %t10431 to i128
%t10433 = icmp ne i128 %t10432, %t10430
%t10434 = icmp slt i128 12329834152419229976, 0
%t10435 = or i1 %t10433, %t10434
%t10436 = zext i1 %t10435 to i8
call void @resid_conv_check(i8 %t10436)
%t10437 = add i128 15566598209576043074, 0
%t10438 = trunc i128 %t10437 to i64
%t10439 = zext i64 %t10438 to i128
%t10440 = icmp ne i128 %t10439, %t10437
%t10441 = icmp slt i128 15566598209576043074, 0
%t10442 = or i1 %t10440, %t10441
%t10443 = zext i1 %t10442 to i8
call void @resid_conv_check(i8 %t10443)
%t10444 = add i64 1334009975649890238, 0
%t10445 = add i64 %t10444, 0
%t10446 = add i64 %t10445, 0
%t10447 = icmp ne i64 %t10446, %t10444
%t10448 = icmp slt i64 1334009975649890238, 0
%t10449 = or i1 %t10447, %t10448
%t10450 = zext i1 %t10449 to i8
call void @resid_conv_check(i8 %t10450)
%t10451 = add i64 2608012711638119052, 0
%t10452 = add i64 %t10451, 0
%t10453 = add i64 %t10452, 0
%t10454 = icmp ne i64 %t10453, %t10451
%t10455 = icmp slt i64 2608012711638119052, 0
%t10456 = or i1 %t10454, %t10455
%t10457 = zext i1 %t10456 to i8
call void @resid_conv_check(i8 %t10457)
%t10458 = add i64 6128411473006802146, 0
%t10459 = add i64 %t10458, 0
%t10460 = add i64 %t10459, 0
%t10461 = icmp ne i64 %t10460, %t10458
%t10462 = icmp slt i64 6128411473006802146, 0
%t10463 = or i1 %t10461, %t10462
%t10464 = zext i1 %t10463 to i8
call void @resid_conv_check(i8 %t10464)
%t10465 = add i64 8268148722764581231, 0
%t10466 = add i64 %t10465, 0
%t10467 = add i64 %t10466, 0
%t10468 = icmp ne i64 %t10467, %t10465
%t10469 = icmp slt i64 8268148722764581231, 0
%t10470 = or i1 %t10468, %t10469
%t10471 = zext i1 %t10470 to i8
call void @resid_conv_check(i8 %t10471)
%t10472 = add i128 9286055187155687089, 0
%t10473 = trunc i128 %t10472 to i64
%t10474 = zext i64 %t10473 to i128
%t10475 = icmp ne i128 %t10474, %t10472
%t10476 = icmp slt i128 9286055187155687089, 0
%t10477 = or i1 %t10475, %t10476
%t10478 = zext i1 %t10477 to i8
call void @resid_conv_check(i8 %t10478)
%t10479 = add i128 11230858885718282805, 0
%t10480 = trunc i128 %t10479 to i64
%t10481 = zext i64 %t10480 to i128
%t10482 = icmp ne i128 %t10481, %t10479
%t10483 = icmp slt i128 11230858885718282805, 0
%t10484 = or i1 %t10482, %t10483
%t10485 = zext i1 %t10484 to i8
call void @resid_conv_check(i8 %t10485)
%t10486 = add i128 13951009754708518548, 0
%t10487 = trunc i128 %t10486 to i64
%t10488 = zext i64 %t10487 to i128
%t10489 = icmp ne i128 %t10488, %t10486
%t10490 = icmp slt i128 13951009754708518548, 0
%t10491 = or i1 %t10489, %t10490
%t10492 = zext i1 %t10491 to i8
call void @resid_conv_check(i8 %t10492)
%t10493 = add i128 16472876342353939154, 0
%t10494 = trunc i128 %t10493 to i64
%t10495 = zext i64 %t10494 to i128
%t10496 = icmp ne i128 %t10495, %t10493
%t10497 = icmp slt i128 16472876342353939154, 0
%t10498 = or i1 %t10496, %t10497
%t10499 = zext i1 %t10498 to i8
call void @resid_conv_check(i8 %t10499)
%t10500 = add i128 17275323862435702243, 0
%t10501 = trunc i128 %t10500 to i64
%t10502 = zext i64 %t10501 to i128
%t10503 = icmp ne i128 %t10502, %t10500
%t10504 = icmp slt i128 17275323862435702243, 0
%t10505 = or i1 %t10503, %t10504
%t10506 = zext i1 %t10505 to i8
call void @resid_conv_check(i8 %t10506)
%t10507 = add i64 1135362057144423861, 0
%t10508 = add i64 %t10507, 0
%t10509 = add i64 %t10508, 0
%t10510 = icmp ne i64 %t10509, %t10507
%t10511 = icmp slt i64 1135362057144423861, 0
%t10512 = or i1 %t10510, %t10511
%t10513 = zext i1 %t10512 to i8
call void @resid_conv_check(i8 %t10513)
%t10514 = add i64 2597628984639134821, 0
%t10515 = add i64 %t10514, 0
%t10516 = add i64 %t10515, 0
%t10517 = icmp ne i64 %t10516, %t10514
%t10518 = icmp slt i64 2597628984639134821, 0
%t10519 = or i1 %t10517, %t10518
%t10520 = zext i1 %t10519 to i8
call void @resid_conv_check(i8 %t10520)
%t10521 = add i64 3308224258029322869, 0
%t10522 = add i64 %t10521, 0
%t10523 = add i64 %t10522, 0
%t10524 = icmp ne i64 %t10523, %t10521
%t10525 = icmp slt i64 3308224258029322869, 0
%t10526 = or i1 %t10524, %t10525
%t10527 = zext i1 %t10526 to i8
call void @resid_conv_check(i8 %t10527)
%t10528 = add i64 5365058923640841347, 0
%t10529 = add i64 %t10528, 0
%t10530 = add i64 %t10529, 0
%t10531 = icmp ne i64 %t10530, %t10528
%t10532 = icmp slt i64 5365058923640841347, 0
%t10533 = or i1 %t10531, %t10532
%t10534 = zext i1 %t10533 to i8
call void @resid_conv_check(i8 %t10534)
%t10535 = add i64 6679025012923562964, 0
%t10536 = add i64 %t10535, 0
%t10537 = add i64 %t10536, 0
%t10538 = icmp ne i64 %t10537, %t10535
%t10539 = icmp slt i64 6679025012923562964, 0
%t10540 = or i1 %t10538, %t10539
%t10541 = zext i1 %t10540 to i8
call void @resid_conv_check(i8 %t10541)
%t10542 = add i64 8573033837759648693, 0
%t10543 = add i64 %t10542, 0
%t10544 = add i64 %t10543, 0
%t10545 = icmp ne i64 %t10544, %t10542
%t10546 = icmp slt i64 8573033837759648693, 0
%t10547 = or i1 %t10545, %t10546
%t10548 = zext i1 %t10547 to i8
call void @resid_conv_check(i8 %t10548)
%t10549 = add i128 10970295158949994411, 0
%t10550 = trunc i128 %t10549 to i64
%t10551 = zext i64 %t10550 to i128
%t10552 = icmp ne i128 %t10551, %t10549
%t10553 = icmp slt i128 10970295158949994411, 0
%t10554 = or i1 %t10552, %t10553
%t10555 = zext i1 %t10554 to i8
call void @resid_conv_check(i8 %t10555)
%t10556 = add i128 12119686244451234320, 0
%t10557 = trunc i128 %t10556 to i64
%t10558 = zext i64 %t10557 to i128
%t10559 = icmp ne i128 %t10558, %t10556
%t10560 = icmp slt i128 12119686244451234320, 0
%t10561 = or i1 %t10559, %t10560
%t10562 = zext i1 %t10561 to i8
call void @resid_conv_check(i8 %t10562)
%t10563 = add i128 12683024718118986047, 0
%t10564 = trunc i128 %t10563 to i64
%t10565 = zext i64 %t10564 to i128
%t10566 = icmp ne i128 %t10565, %t10563
%t10567 = icmp slt i128 12683024718118986047, 0
%t10568 = or i1 %t10566, %t10567
%t10569 = zext i1 %t10568 to i8
call void @resid_conv_check(i8 %t10569)
%t10570 = add i128 13788192230050041572, 0
%t10571 = trunc i128 %t10570 to i64
%t10572 = zext i64 %t10571 to i128
%t10573 = icmp ne i128 %t10572, %t10570
%t10574 = icmp slt i128 13788192230050041572, 0
%t10575 = or i1 %t10573, %t10574
%t10576 = zext i1 %t10575 to i8
call void @resid_conv_check(i8 %t10576)
%t10577 = add i128 14330467153632333762, 0
%t10578 = trunc i128 %t10577 to i64
%t10579 = zext i64 %t10578 to i128
%t10580 = icmp ne i128 %t10579, %t10577
%t10581 = icmp slt i128 14330467153632333762, 0
%t10582 = or i1 %t10580, %t10581
%t10583 = zext i1 %t10582 to i8
call void @resid_conv_check(i8 %t10583)
%t10584 = add i128 15395433587784984357, 0
%t10585 = trunc i128 %t10584 to i64
%t10586 = zext i64 %t10585 to i128
%t10587 = icmp ne i128 %t10586, %t10584
%t10588 = icmp slt i128 15395433587784984357, 0
%t10589 = or i1 %t10587, %t10588
%t10590 = zext i1 %t10589 to i8
call void @resid_conv_check(i8 %t10590)
%t10591 = add i64 1452737877330783856, 0
%t10592 = add i64 %t10591, 0
%t10593 = add i64 %t10592, 0
%t10594 = icmp ne i64 %t10593, %t10591
%t10595 = icmp slt i64 1452737877330783856, 0
%t10596 = or i1 %t10594, %t10595
%t10597 = zext i1 %t10596 to i8
call void @resid_conv_check(i8 %t10597)
%t10598 = add i64 2861767655752347644, 0
%t10599 = add i64 %t10598, 0
%t10600 = add i64 %t10599, 0
%t10601 = icmp ne i64 %t10600, %t10598
%t10602 = icmp slt i64 2861767655752347644, 0
%t10603 = or i1 %t10601, %t10602
%t10604 = zext i1 %t10603 to i8
call void @resid_conv_check(i8 %t10604)
%t10605 = add i64 3322285676063803686, 0
%t10606 = add i64 %t10605, 0
%t10607 = add i64 %t10606, 0
%t10608 = icmp ne i64 %t10607, %t10605
%t10609 = icmp slt i64 3322285676063803686, 0
%t10610 = or i1 %t10608, %t10609
%t10611 = zext i1 %t10610 to i8
call void @resid_conv_check(i8 %t10611)
%t10612 = add i64 5560940570517711597, 0
%t10613 = add i64 %t10612, 0
%t10614 = add i64 %t10613, 0
%t10615 = icmp ne i64 %t10614, %t10612
%t10616 = icmp slt i64 5560940570517711597, 0
%t10617 = or i1 %t10615, %t10616
%t10618 = zext i1 %t10617 to i8
call void @resid_conv_check(i8 %t10618)
%t10619 = add i64 5996557281743188959, 0
%t10620 = add i64 %t10619, 0
%t10621 = add i64 %t10620, 0
%t10622 = icmp ne i64 %t10621, %t10619
%t10623 = icmp slt i64 5996557281743188959, 0
%t10624 = or i1 %t10622, %t10623
%t10625 = zext i1 %t10624 to i8
call void @resid_conv_check(i8 %t10625)
%t10626 = add i64 7280758554555802590, 0
%t10627 = add i64 %t10626, 0
%t10628 = add i64 %t10627, 0
%t10629 = icmp ne i64 %t10628, %t10626
%t10630 = icmp slt i64 7280758554555802590, 0
%t10631 = or i1 %t10629, %t10630
%t10632 = zext i1 %t10631 to i8
call void @resid_conv_check(i8 %t10632)
%t10633 = add i64 8532644243296465576, 0
%t10634 = add i64 %t10633, 0
%t10635 = add i64 %t10634, 0
%t10636 = icmp ne i64 %t10635, %t10633
%t10637 = icmp slt i64 8532644243296465576, 0
%t10638 = or i1 %t10636, %t10637
%t10639 = zext i1 %t10638 to i8
call void @resid_conv_check(i8 %t10639)
%t10640 = add i128 9350256976987008742, 0
%t10641 = trunc i128 %t10640 to i64
%t10642 = zext i64 %t10641 to i128
%t10643 = icmp ne i128 %t10642, %t10640
%t10644 = icmp slt i128 9350256976987008742, 0
%t10645 = or i1 %t10643, %t10644
%t10646 = zext i1 %t10645 to i8
call void @resid_conv_check(i8 %t10646)
%t10647 = add i128 10552545826968843579, 0
%t10648 = trunc i128 %t10647 to i64
%t10649 = zext i64 %t10648 to i128
%t10650 = icmp ne i128 %t10649, %t10647
%t10651 = icmp slt i128 10552545826968843579, 0
%t10652 = or i1 %t10650, %t10651
%t10653 = zext i1 %t10652 to i8
call void @resid_conv_check(i8 %t10653)
%t10654 = add i128 11727347734174303076, 0
%t10655 = trunc i128 %t10654 to i64
%t10656 = zext i64 %t10655 to i128
%t10657 = icmp ne i128 %t10656, %t10654
%t10658 = icmp slt i128 11727347734174303076, 0
%t10659 = or i1 %t10657, %t10658
%t10660 = zext i1 %t10659 to i8
call void @resid_conv_check(i8 %t10660)
%t10661 = add i128 12113106623233404929, 0
%t10662 = trunc i128 %t10661 to i64
%t10663 = zext i64 %t10662 to i128
%t10664 = icmp ne i128 %t10663, %t10661
%t10665 = icmp slt i128 12113106623233404929, 0
%t10666 = or i1 %t10664, %t10665
%t10667 = zext i1 %t10666 to i8
call void @resid_conv_check(i8 %t10667)
%t10668 = add i128 14000437183269869457, 0
%t10669 = trunc i128 %t10668 to i64
%t10670 = zext i64 %t10669 to i128
%t10671 = icmp ne i128 %t10670, %t10668
%t10672 = icmp slt i128 14000437183269869457, 0
%t10673 = or i1 %t10671, %t10672
%t10674 = zext i1 %t10673 to i8
call void @resid_conv_check(i8 %t10674)
%t10675 = add i128 14369950271660146224, 0
%t10676 = trunc i128 %t10675 to i64
%t10677 = zext i64 %t10676 to i128
%t10678 = icmp ne i128 %t10677, %t10675
%t10679 = icmp slt i128 14369950271660146224, 0
%t10680 = or i1 %t10678, %t10679
%t10681 = zext i1 %t10680 to i8
call void @resid_conv_check(i8 %t10681)
%t10682 = add i128 15101387698204529176, 0
%t10683 = trunc i128 %t10682 to i64
%t10684 = zext i64 %t10683 to i128
%t10685 = icmp ne i128 %t10684, %t10682
%t10686 = icmp slt i128 15101387698204529176, 0
%t10687 = or i1 %t10685, %t10686
%t10688 = zext i1 %t10687 to i8
call void @resid_conv_check(i8 %t10688)
%t10689 = add i128 15463397548674623760, 0
%t10690 = trunc i128 %t10689 to i64
%t10691 = zext i64 %t10690 to i128
%t10692 = icmp ne i128 %t10691, %t10689
%t10693 = icmp slt i128 15463397548674623760, 0
%t10694 = or i1 %t10692, %t10693
%t10695 = zext i1 %t10694 to i8
call void @resid_conv_check(i8 %t10695)
%t10696 = add i128 17586052441742319658, 0
%t10697 = trunc i128 %t10696 to i64
%t10698 = zext i64 %t10697 to i128
%t10699 = icmp ne i128 %t10698, %t10696
%t10700 = icmp slt i128 17586052441742319658, 0
%t10701 = or i1 %t10699, %t10700
%t10702 = zext i1 %t10701 to i8
call void @resid_conv_check(i8 %t10702)
%t10703 = add i64 1182934255886127544, 0
%t10704 = add i64 %t10703, 0
%t10705 = add i64 %t10704, 0
%t10706 = icmp ne i64 %t10705, %t10703
%t10707 = icmp slt i64 1182934255886127544, 0
%t10708 = or i1 %t10706, %t10707
%t10709 = zext i1 %t10708 to i8
call void @resid_conv_check(i8 %t10709)
%t10710 = add i64 1847814050463011016, 0
%t10711 = add i64 %t10710, 0
%t10712 = add i64 %t10711, 0
%t10713 = icmp ne i64 %t10712, %t10710
%t10714 = icmp slt i64 1847814050463011016, 0
%t10715 = or i1 %t10713, %t10714
%t10716 = zext i1 %t10715 to i8
call void @resid_conv_check(i8 %t10716)
%t10717 = add i64 2177327727835720531, 0
%t10718 = add i64 %t10717, 0
%t10719 = add i64 %t10718, 0
%t10720 = icmp ne i64 %t10719, %t10717
%t10721 = icmp slt i64 2177327727835720531, 0
%t10722 = or i1 %t10720, %t10721
%t10723 = zext i1 %t10722 to i8
call void @resid_conv_check(i8 %t10723)
%t10724 = add i64 2830643537854262169, 0
%t10725 = add i64 %t10724, 0
%t10726 = add i64 %t10725, 0
%t10727 = icmp ne i64 %t10726, %t10724
%t10728 = icmp slt i64 2830643537854262169, 0
%t10729 = or i1 %t10727, %t10728
%t10730 = zext i1 %t10729 to i8
call void @resid_conv_check(i8 %t10730)
%t10731 = add i64 3796741975233480872, 0
%t10732 = add i64 %t10731, 0
%t10733 = add i64 %t10732, 0
%t10734 = icmp ne i64 %t10733, %t10731
%t10735 = icmp slt i64 3796741975233480872, 0
%t10736 = or i1 %t10734, %t10735
%t10737 = zext i1 %t10736 to i8
call void @resid_conv_check(i8 %t10737)
%t10738 = add i64 4115178125766777443, 0
%t10739 = add i64 %t10738, 0
%t10740 = add i64 %t10739, 0
%t10741 = icmp ne i64 %t10740, %t10738
%t10742 = icmp slt i64 4115178125766777443, 0
%t10743 = or i1 %t10741, %t10742
%t10744 = zext i1 %t10743 to i8
call void @resid_conv_check(i8 %t10744)
%t10745 = add i64 5681478168544905931, 0
%t10746 = add i64 %t10745, 0
%t10747 = add i64 %t10746, 0
%t10748 = icmp ne i64 %t10747, %t10745
%t10749 = icmp slt i64 5681478168544905931, 0
%t10750 = or i1 %t10748, %t10749
%t10751 = zext i1 %t10750 to i8
call void @resid_conv_check(i8 %t10751)
%t10752 = add i64 6601373596472566643, 0
%t10753 = add i64 %t10752, 0
%t10754 = add i64 %t10753, 0
%t10755 = icmp ne i64 %t10754, %t10752
%t10756 = icmp slt i64 6601373596472566643, 0
%t10757 = or i1 %t10755, %t10756
%t10758 = zext i1 %t10757 to i8
call void @resid_conv_check(i8 %t10758)
%t10759 = add i64 7507060721942968483, 0
%t10760 = add i64 %t10759, 0
%t10761 = add i64 %t10760, 0
%t10762 = icmp ne i64 %t10761, %t10759
%t10763 = icmp slt i64 7507060721942968483, 0
%t10764 = or i1 %t10762, %t10763
%t10765 = zext i1 %t10764 to i8
call void @resid_conv_check(i8 %t10765)
%t10766 = add i64 8399075790359081724, 0
%t10767 = add i64 %t10766, 0
%t10768 = add i64 %t10767, 0
%t10769 = icmp ne i64 %t10768, %t10766
%t10770 = icmp slt i64 8399075790359081724, 0
%t10771 = or i1 %t10769, %t10770
%t10772 = zext i1 %t10771 to i8
call void @resid_conv_check(i8 %t10772)
%t10773 = add i64 8693463985226723168, 0
%t10774 = add i64 %t10773, 0
%t10775 = add i64 %t10774, 0
%t10776 = icmp ne i64 %t10775, %t10773
%t10777 = icmp slt i64 8693463985226723168, 0
%t10778 = or i1 %t10776, %t10777
%t10779 = zext i1 %t10778 to i8
call void @resid_conv_check(i8 %t10779)
%t10780 = add i128 9568029438360202098, 0
%t10781 = trunc i128 %t10780 to i64
%t10782 = zext i64 %t10781 to i128
%t10783 = icmp ne i128 %t10782, %t10780
%t10784 = icmp slt i128 9568029438360202098, 0
%t10785 = or i1 %t10783, %t10784
%t10786 = zext i1 %t10785 to i8
call void @resid_conv_check(i8 %t10786)
%t10787 = add i128 10144078919501101548, 0
%t10788 = trunc i128 %t10787 to i64
%t10789 = zext i64 %t10788 to i128
%t10790 = icmp ne i128 %t10789, %t10787
%t10791 = icmp slt i128 10144078919501101548, 0
%t10792 = or i1 %t10790, %t10791
%t10793 = zext i1 %t10792 to i8
call void @resid_conv_check(i8 %t10793)
%t10794 = add i128 10430055236837252648, 0
%t10795 = trunc i128 %t10794 to i64
%t10796 = zext i64 %t10795 to i128
%t10797 = icmp ne i128 %t10796, %t10794
%t10798 = icmp slt i128 10430055236837252648, 0
%t10799 = or i1 %t10797, %t10798
%t10800 = zext i1 %t10799 to i8
call void @resid_conv_check(i8 %t10800)
%t10801 = add i128 11840083180663258601, 0
%t10802 = trunc i128 %t10801 to i64
%t10803 = zext i64 %t10802 to i128
%t10804 = icmp ne i128 %t10803, %t10801
%t10805 = icmp slt i128 11840083180663258601, 0
%t10806 = or i1 %t10804, %t10805
%t10807 = zext i1 %t10806 to i8
call void @resid_conv_check(i8 %t10807)
%t10808 = add i128 13761210420658862357, 0
%t10809 = trunc i128 %t10808 to i64
%t10810 = zext i64 %t10809 to i128
%t10811 = icmp ne i128 %t10810, %t10808
%t10812 = icmp slt i128 13761210420658862357, 0
%t10813 = or i1 %t10811, %t10812
%t10814 = zext i1 %t10813 to i8
call void @resid_conv_check(i8 %t10814)
%t10815 = add i128 14299343276471374635, 0
%t10816 = trunc i128 %t10815 to i64
%t10817 = zext i64 %t10816 to i128
%t10818 = icmp ne i128 %t10817, %t10815
%t10819 = icmp slt i128 14299343276471374635, 0
%t10820 = or i1 %t10818, %t10819
%t10821 = zext i1 %t10820 to i8
call void @resid_conv_check(i8 %t10821)
%t10822 = add i128 14566680578165727644, 0
%t10823 = trunc i128 %t10822 to i64
%t10824 = zext i64 %t10823 to i128
%t10825 = icmp ne i128 %t10824, %t10822
%t10826 = icmp slt i128 14566680578165727644, 0
%t10827 = or i1 %t10825, %t10826
%t10828 = zext i1 %t10827 to i8
call void @resid_conv_check(i8 %t10828)
%t10829 = add i128 15097957966210449927, 0
%t10830 = trunc i128 %t10829 to i64
%t10831 = zext i64 %t10830 to i128
%t10832 = icmp ne i128 %t10831, %t10829
%t10833 = icmp slt i128 15097957966210449927, 0
%t10834 = or i1 %t10832, %t10833
%t10835 = zext i1 %t10834 to i8
call void @resid_conv_check(i8 %t10835)
%t10836 = add i128 16922976911328602910, 0
%t10837 = trunc i128 %t10836 to i64
%t10838 = zext i64 %t10837 to i128
%t10839 = icmp ne i128 %t10838, %t10836
%t10840 = icmp slt i128 16922976911328602910, 0
%t10841 = or i1 %t10839, %t10840
%t10842 = zext i1 %t10841 to i8
call void @resid_conv_check(i8 %t10842)
%t10843 = add i128 17689382322260857208, 0
%t10844 = trunc i128 %t10843 to i64
%t10845 = zext i64 %t10844 to i128
%t10846 = icmp ne i128 %t10845, %t10843
%t10847 = icmp slt i128 17689382322260857208, 0
%t10848 = or i1 %t10846, %t10847
%t10849 = zext i1 %t10848 to i8
call void @resid_conv_check(i8 %t10849)
%t10850 = add i64 1242879168328830382, 0
%t10851 = add i64 %t10850, 0
%t10852 = add i64 %t10851, 0
%t10853 = icmp ne i64 %t10852, %t10850
%t10854 = icmp slt i64 1242879168328830382, 0
%t10855 = or i1 %t10853, %t10854
%t10856 = zext i1 %t10855 to i8
call void @resid_conv_check(i8 %t10856)
%t10857 = add i64 1977374033974150939, 0
%t10858 = add i64 %t10857, 0
%t10859 = add i64 %t10858, 0
%t10860 = icmp ne i64 %t10859, %t10857
%t10861 = icmp slt i64 1977374033974150939, 0
%t10862 = or i1 %t10860, %t10861
%t10863 = zext i1 %t10862 to i8
call void @resid_conv_check(i8 %t10863)
%t10864 = add i64 2944078676154940804, 0
%t10865 = add i64 %t10864, 0
%t10866 = add i64 %t10865, 0
%t10867 = icmp ne i64 %t10866, %t10864
%t10868 = icmp slt i64 2944078676154940804, 0
%t10869 = or i1 %t10867, %t10868
%t10870 = zext i1 %t10869 to i8
call void @resid_conv_check(i8 %t10870)
%t10871 = add i64 3659926193048069267, 0
%t10872 = add i64 %t10871, 0
%t10873 = add i64 %t10872, 0
%t10874 = icmp ne i64 %t10873, %t10871
%t10875 = icmp slt i64 3659926193048069267, 0
%t10876 = or i1 %t10874, %t10875
%t10877 = zext i1 %t10876 to i8
call void @resid_conv_check(i8 %t10877)
%t10878 = add i64 4368137639120453308, 0
%t10879 = add i64 %t10878, 0
%t10880 = add i64 %t10879, 0
%t10881 = icmp ne i64 %t10880, %t10878
%t10882 = icmp slt i64 4368137639120453308, 0
%t10883 = or i1 %t10881, %t10882
%t10884 = zext i1 %t10883 to i8
call void @resid_conv_check(i8 %t10884)
%t10885 = add i64 4836135668995329356, 0
%t10886 = add i64 %t10885, 0
%t10887 = add i64 %t10886, 0
%t10888 = icmp ne i64 %t10887, %t10885
%t10889 = icmp slt i64 4836135668995329356, 0
%t10890 = or i1 %t10888, %t10889
%t10891 = zext i1 %t10890 to i8
call void @resid_conv_check(i8 %t10891)
%t10892 = add i64 5532061633213252278, 0
%t10893 = add i64 %t10892, 0
%t10894 = add i64 %t10893, 0
%t10895 = icmp ne i64 %t10894, %t10892
%t10896 = icmp slt i64 5532061633213252278, 0
%t10897 = or i1 %t10895, %t10896
%t10898 = zext i1 %t10897 to i8
call void @resid_conv_check(i8 %t10898)
%t10899 = add i64 6448918945643986474, 0
%t10900 = add i64 %t10899, 0
%t10901 = add i64 %t10900, 0
%t10902 = icmp ne i64 %t10901, %t10899
%t10903 = icmp slt i64 6448918945643986474, 0
%t10904 = or i1 %t10902, %t10903
%t10905 = zext i1 %t10904 to i8
call void @resid_conv_check(i8 %t10905)
%t10906 = add i64 6902733635092675308, 0
%t10907 = add i64 %t10906, 0
%t10908 = add i64 %t10907, 0
%t10909 = icmp ne i64 %t10908, %t10906
%t10910 = icmp slt i64 6902733635092675308, 0
%t10911 = or i1 %t10909, %t10910
%t10912 = zext i1 %t10911 to i8
call void @resid_conv_check(i8 %t10912)
%t10913 = add i64 7801388544844847127, 0
%t10914 = add i64 %t10913, 0
%t10915 = add i64 %t10914, 0
%t10916 = icmp ne i64 %t10915, %t10913
%t10917 = icmp slt i64 7801388544844847127, 0
%t10918 = or i1 %t10916, %t10917
%t10919 = zext i1 %t10918 to i8
call void @resid_conv_check(i8 %t10919)
%t10920 = alloca [80 x ptr]
%t10922 = call ptr @resid_box_i64(i64 %t10382)
%t10924 = getelementptr i8, ptr %t10920, i64 0
store ptr %t10922, ptr %t10924
%t10925 = call ptr @resid_box_i64(i64 %t10389)
%t10927 = getelementptr i8, ptr %t10920, i64 8
store ptr %t10925, ptr %t10927
%t10928 = call ptr @resid_box_i64(i64 %t10396)
%t10930 = getelementptr i8, ptr %t10920, i64 16
store ptr %t10928, ptr %t10930
%t10931 = call ptr @resid_box_i64(i64 %t10403)
%t10933 = getelementptr i8, ptr %t10920, i64 24
store ptr %t10931, ptr %t10933
%t10934 = call ptr @resid_box_i64(i64 %t10410)
%t10936 = getelementptr i8, ptr %t10920, i64 32
store ptr %t10934, ptr %t10936
%t10937 = call ptr @resid_box_i64(i64 %t10417)
%t10939 = getelementptr i8, ptr %t10920, i64 40
store ptr %t10937, ptr %t10939
%t10940 = call ptr @resid_box_i64(i64 %t10424)
%t10942 = getelementptr i8, ptr %t10920, i64 48
store ptr %t10940, ptr %t10942
%t10943 = call ptr @resid_box_i64(i64 %t10431)
%t10945 = getelementptr i8, ptr %t10920, i64 56
store ptr %t10943, ptr %t10945
%t10946 = call ptr @resid_box_i64(i64 %t10438)
%t10948 = getelementptr i8, ptr %t10920, i64 64
store ptr %t10946, ptr %t10948
%t10949 = call ptr @resid_box_i64(i64 %t10445)
%t10951 = getelementptr i8, ptr %t10920, i64 72
store ptr %t10949, ptr %t10951
%t10952 = call ptr @resid_box_i64(i64 %t10452)
%t10954 = getelementptr i8, ptr %t10920, i64 80
store ptr %t10952, ptr %t10954
%t10955 = call ptr @resid_box_i64(i64 %t10459)
%t10957 = getelementptr i8, ptr %t10920, i64 88
store ptr %t10955, ptr %t10957
%t10958 = call ptr @resid_box_i64(i64 %t10466)
%t10960 = getelementptr i8, ptr %t10920, i64 96
store ptr %t10958, ptr %t10960
%t10961 = call ptr @resid_box_i64(i64 %t10473)
%t10963 = getelementptr i8, ptr %t10920, i64 104
store ptr %t10961, ptr %t10963
%t10964 = call ptr @resid_box_i64(i64 %t10480)
%t10966 = getelementptr i8, ptr %t10920, i64 112
store ptr %t10964, ptr %t10966
%t10967 = call ptr @resid_box_i64(i64 %t10487)
%t10969 = getelementptr i8, ptr %t10920, i64 120
store ptr %t10967, ptr %t10969
%t10970 = call ptr @resid_box_i64(i64 %t10494)
%t10972 = getelementptr i8, ptr %t10920, i64 128
store ptr %t10970, ptr %t10972
%t10973 = call ptr @resid_box_i64(i64 %t10501)
%t10975 = getelementptr i8, ptr %t10920, i64 136
store ptr %t10973, ptr %t10975
%t10976 = call ptr @resid_box_i64(i64 %t10508)
%t10978 = getelementptr i8, ptr %t10920, i64 144
store ptr %t10976, ptr %t10978
%t10979 = call ptr @resid_box_i64(i64 %t10515)
%t10981 = getelementptr i8, ptr %t10920, i64 152
store ptr %t10979, ptr %t10981
%t10982 = call ptr @resid_box_i64(i64 %t10522)
%t10984 = getelementptr i8, ptr %t10920, i64 160
store ptr %t10982, ptr %t10984
%t10985 = call ptr @resid_box_i64(i64 %t10529)
%t10987 = getelementptr i8, ptr %t10920, i64 168
store ptr %t10985, ptr %t10987
%t10988 = call ptr @resid_box_i64(i64 %t10536)
%t10990 = getelementptr i8, ptr %t10920, i64 176
store ptr %t10988, ptr %t10990
%t10991 = call ptr @resid_box_i64(i64 %t10543)
%t10993 = getelementptr i8, ptr %t10920, i64 184
store ptr %t10991, ptr %t10993
%t10994 = call ptr @resid_box_i64(i64 %t10550)
%t10996 = getelementptr i8, ptr %t10920, i64 192
store ptr %t10994, ptr %t10996
%t10997 = call ptr @resid_box_i64(i64 %t10557)
%t10999 = getelementptr i8, ptr %t10920, i64 200
store ptr %t10997, ptr %t10999
%t11000 = call ptr @resid_box_i64(i64 %t10564)
%t11002 = getelementptr i8, ptr %t10920, i64 208
store ptr %t11000, ptr %t11002
%t11003 = call ptr @resid_box_i64(i64 %t10571)
%t11005 = getelementptr i8, ptr %t10920, i64 216
store ptr %t11003, ptr %t11005
%t11006 = call ptr @resid_box_i64(i64 %t10578)
%t11008 = getelementptr i8, ptr %t10920, i64 224
store ptr %t11006, ptr %t11008
%t11009 = call ptr @resid_box_i64(i64 %t10585)
%t11011 = getelementptr i8, ptr %t10920, i64 232
store ptr %t11009, ptr %t11011
%t11012 = call ptr @resid_box_i64(i64 489312712824947311)
%t11014 = getelementptr i8, ptr %t10920, i64 240
store ptr %t11012, ptr %t11014
%t11015 = call ptr @resid_box_i64(i64 %t10592)
%t11017 = getelementptr i8, ptr %t10920, i64 248
store ptr %t11015, ptr %t11017
%t11018 = call ptr @resid_box_i64(i64 %t10599)
%t11020 = getelementptr i8, ptr %t10920, i64 256
store ptr %t11018, ptr %t11020
%t11021 = call ptr @resid_box_i64(i64 %t10606)
%t11023 = getelementptr i8, ptr %t10920, i64 264
store ptr %t11021, ptr %t11023
%t11024 = call ptr @resid_box_i64(i64 %t10613)
%t11026 = getelementptr i8, ptr %t10920, i64 272
store ptr %t11024, ptr %t11026
%t11027 = call ptr @resid_box_i64(i64 %t10620)
%t11029 = getelementptr i8, ptr %t10920, i64 280
store ptr %t11027, ptr %t11029
%t11030 = call ptr @resid_box_i64(i64 %t10627)
%t11032 = getelementptr i8, ptr %t10920, i64 288
store ptr %t11030, ptr %t11032
%t11033 = call ptr @resid_box_i64(i64 %t10634)
%t11035 = getelementptr i8, ptr %t10920, i64 296
store ptr %t11033, ptr %t11035
%t11036 = call ptr @resid_box_i64(i64 %t10641)
%t11038 = getelementptr i8, ptr %t10920, i64 304
store ptr %t11036, ptr %t11038
%t11039 = call ptr @resid_box_i64(i64 %t10648)
%t11041 = getelementptr i8, ptr %t10920, i64 312
store ptr %t11039, ptr %t11041
%t11042 = call ptr @resid_box_i64(i64 %t10655)
%t11044 = getelementptr i8, ptr %t10920, i64 320
store ptr %t11042, ptr %t11044
%t11045 = call ptr @resid_box_i64(i64 %t10662)
%t11047 = getelementptr i8, ptr %t10920, i64 328
store ptr %t11045, ptr %t11047
%t11048 = call ptr @resid_box_i64(i64 %t10669)
%t11050 = getelementptr i8, ptr %t10920, i64 336
store ptr %t11048, ptr %t11050
%t11051 = call ptr @resid_box_i64(i64 %t10676)
%t11053 = getelementptr i8, ptr %t10920, i64 344
store ptr %t11051, ptr %t11053
%t11054 = call ptr @resid_box_i64(i64 %t10683)
%t11056 = getelementptr i8, ptr %t10920, i64 352
store ptr %t11054, ptr %t11056
%t11057 = call ptr @resid_box_i64(i64 %t10690)
%t11059 = getelementptr i8, ptr %t10920, i64 360
store ptr %t11057, ptr %t11059
%t11060 = call ptr @resid_box_i64(i64 %t10697)
%t11062 = getelementptr i8, ptr %t10920, i64 368
store ptr %t11060, ptr %t11062
%t11063 = call ptr @resid_box_i64(i64 %t10704)
%t11065 = getelementptr i8, ptr %t10920, i64 376
store ptr %t11063, ptr %t11065
%t11066 = call ptr @resid_box_i64(i64 %t10711)
%t11068 = getelementptr i8, ptr %t10920, i64 384
store ptr %t11066, ptr %t11068
%t11069 = call ptr @resid_box_i64(i64 %t10718)
%t11071 = getelementptr i8, ptr %t10920, i64 392
store ptr %t11069, ptr %t11071
%t11072 = call ptr @resid_box_i64(i64 %t10725)
%t11074 = getelementptr i8, ptr %t10920, i64 400
store ptr %t11072, ptr %t11074
%t11075 = call ptr @resid_box_i64(i64 %t10732)
%t11077 = getelementptr i8, ptr %t10920, i64 408
store ptr %t11075, ptr %t11077
%t11078 = call ptr @resid_box_i64(i64 %t10739)
%t11080 = getelementptr i8, ptr %t10920, i64 416
store ptr %t11078, ptr %t11080
%t11081 = call ptr @resid_box_i64(i64 %t10746)
%t11083 = getelementptr i8, ptr %t10920, i64 424
store ptr %t11081, ptr %t11083
%t11084 = call ptr @resid_box_i64(i64 %t10753)
%t11086 = getelementptr i8, ptr %t10920, i64 432
store ptr %t11084, ptr %t11086
%t11087 = call ptr @resid_box_i64(i64 %t10760)
%t11089 = getelementptr i8, ptr %t10920, i64 440
store ptr %t11087, ptr %t11089
%t11090 = call ptr @resid_box_i64(i64 %t10767)
%t11092 = getelementptr i8, ptr %t10920, i64 448
store ptr %t11090, ptr %t11092
%t11093 = call ptr @resid_box_i64(i64 %t10774)
%t11095 = getelementptr i8, ptr %t10920, i64 456
store ptr %t11093, ptr %t11095
%t11096 = call ptr @resid_box_i64(i64 %t10781)
%t11098 = getelementptr i8, ptr %t10920, i64 464
store ptr %t11096, ptr %t11098
%t11099 = call ptr @resid_box_i64(i64 %t10788)
%t11101 = getelementptr i8, ptr %t10920, i64 472
store ptr %t11099, ptr %t11101
%t11102 = call ptr @resid_box_i64(i64 %t10795)
%t11104 = getelementptr i8, ptr %t10920, i64 480
store ptr %t11102, ptr %t11104
%t11105 = call ptr @resid_box_i64(i64 %t10802)
%t11107 = getelementptr i8, ptr %t10920, i64 488
store ptr %t11105, ptr %t11107
%t11108 = call ptr @resid_box_i64(i64 %t10809)
%t11110 = getelementptr i8, ptr %t10920, i64 496
store ptr %t11108, ptr %t11110
%t11111 = call ptr @resid_box_i64(i64 %t10816)
%t11113 = getelementptr i8, ptr %t10920, i64 504
store ptr %t11111, ptr %t11113
%t11114 = call ptr @resid_box_i64(i64 %t10823)
%t11116 = getelementptr i8, ptr %t10920, i64 512
store ptr %t11114, ptr %t11116
%t11117 = call ptr @resid_box_i64(i64 %t10830)
%t11119 = getelementptr i8, ptr %t10920, i64 520
store ptr %t11117, ptr %t11119
%t11120 = call ptr @resid_box_i64(i64 %t10837)
%t11122 = getelementptr i8, ptr %t10920, i64 528
store ptr %t11120, ptr %t11122
%t11123 = call ptr @resid_box_i64(i64 %t10844)
%t11125 = getelementptr i8, ptr %t10920, i64 536
store ptr %t11123, ptr %t11125
%t11126 = call ptr @resid_box_i64(i64 500013540394364858)
%t11128 = getelementptr i8, ptr %t10920, i64 544
store ptr %t11126, ptr %t11128
%t11129 = call ptr @resid_box_i64(i64 748580250866718886)
%t11131 = getelementptr i8, ptr %t10920, i64 552
store ptr %t11129, ptr %t11131
%t11132 = call ptr @resid_box_i64(i64 %t10851)
%t11134 = getelementptr i8, ptr %t10920, i64 560
store ptr %t11132, ptr %t11134
%t11135 = call ptr @resid_box_i64(i64 %t10858)
%t11137 = getelementptr i8, ptr %t10920, i64 568
store ptr %t11135, ptr %t11137
%t11138 = call ptr @resid_box_i64(i64 %t10865)
%t11140 = getelementptr i8, ptr %t10920, i64 576
store ptr %t11138, ptr %t11140
%t11141 = call ptr @resid_box_i64(i64 %t10872)
%t11143 = getelementptr i8, ptr %t10920, i64 584
store ptr %t11141, ptr %t11143
%t11144 = call ptr @resid_box_i64(i64 %t10879)
%t11146 = getelementptr i8, ptr %t10920, i64 592
store ptr %t11144, ptr %t11146
%t11147 = call ptr @resid_box_i64(i64 %t10886)
%t11149 = getelementptr i8, ptr %t10920, i64 600
store ptr %t11147, ptr %t11149
%t11150 = call ptr @resid_box_i64(i64 %t10893)
%t11152 = getelementptr i8, ptr %t10920, i64 608
store ptr %t11150, ptr %t11152
%t11153 = call ptr @resid_box_i64(i64 %t10900)
%t11155 = getelementptr i8, ptr %t10920, i64 616
store ptr %t11153, ptr %t11155
%t11156 = call ptr @resid_box_i64(i64 %t10907)
%t11158 = getelementptr i8, ptr %t10920, i64 624
store ptr %t11156, ptr %t11158
%t11159 = call ptr @resid_box_i64(i64 %t10914)
%t11161 = getelementptr i8, ptr %t10920, i64 632
store ptr %t11159, ptr %t11161
%t11162 = call ptr @resid_list_new(i64 80, ptr %t10920, ptr @.lty10920)
%t11163 = getelementptr i8, ptr %p2, i64 0
%t11164 = load i64, ptr %t11163, align 8
%t11165 = getelementptr i8, ptr %p2, i64 8
%t11166 = load i64, ptr %t11165, align 8
%t11167 = getelementptr i8, ptr %p2, i64 16
%t11168 = load i64, ptr %t11167, align 8
%t11169 = getelementptr i8, ptr %p2, i64 24
%t11170 = load i64, ptr %t11169, align 8
%t11171 = getelementptr i8, ptr %p2, i64 32
%t11172 = load i64, ptr %t11171, align 8
%t11173 = getelementptr i8, ptr %p2, i64 40
%t11174 = load i64, ptr %t11173, align 8
%t11175 = getelementptr i8, ptr %p2, i64 48
%t11176 = load i64, ptr %t11175, align 8
%t11177 = getelementptr i8, ptr %p2, i64 56
%t11178 = load i64, ptr %t11177, align 8
%t11179 = call ptr @__m_________lib_sha512g_resid__g5_blk__g_Int_64__UInt_64_(ptr %p0, i64 %p1, ptr %t11162, i64 0, ptr %p2, i64 %t11164, i64 %t11166, i64 %t11168, i64 %t11170, i64 %t11172, i64 %t11174, i64 %t11176, i64 %t11178, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0)
ret ptr %t11179
}
define i64 @__m_________lib_sha512g_resid__g5_state_word__g_UInt_64__Int_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11180 = icmp eq i64 %p1, 0
br i1 %t11180, label %L1132, label %L1133
L1132:
%t11181 = getelementptr i8, ptr %p0, i64 0
%t11182 = load i64, ptr %t11181, align 8
br label %L1134
L1133:
%t11183 = icmp eq i64 %p1, 1
br i1 %t11183, label %L1135, label %L1136
L1135:
%t11184 = getelementptr i8, ptr %p0, i64 8
%t11185 = load i64, ptr %t11184, align 8
br label %L1137
L1136:
%t11186 = icmp eq i64 %p1, 2
br i1 %t11186, label %L1138, label %L1139
L1138:
%t11187 = getelementptr i8, ptr %p0, i64 16
%t11188 = load i64, ptr %t11187, align 8
br label %L1140
L1139:
%t11189 = icmp eq i64 %p1, 3
br i1 %t11189, label %L1141, label %L1142
L1141:
%t11190 = getelementptr i8, ptr %p0, i64 24
%t11191 = load i64, ptr %t11190, align 8
br label %L1143
L1142:
%t11192 = icmp eq i64 %p1, 4
br i1 %t11192, label %L1144, label %L1145
L1144:
%t11193 = getelementptr i8, ptr %p0, i64 32
%t11194 = load i64, ptr %t11193, align 8
br label %L1146
L1145:
%t11195 = icmp eq i64 %p1, 5
br i1 %t11195, label %L1147, label %L1148
L1147:
%t11196 = getelementptr i8, ptr %p0, i64 40
%t11197 = load i64, ptr %t11196, align 8
br label %L1149
L1148:
%t11198 = icmp eq i64 %p1, 6
br i1 %t11198, label %L1150, label %L1151
L1150:
%t11199 = getelementptr i8, ptr %p0, i64 48
%t11200 = load i64, ptr %t11199, align 8
br label %L1152
L1151:
%t11201 = getelementptr i8, ptr %p0, i64 56
%t11202 = load i64, ptr %t11201, align 8
br label %L1152
L1152:
%t11203 = phi i64 [ %t11200, %L1150 ], [ %t11202, %L1151 ]
br label %L1149
L1149:
%t11204 = phi i64 [ %t11197, %L1147 ], [ %t11203, %L1152 ]
br label %L1146
L1146:
%t11205 = phi i64 [ %t11194, %L1144 ], [ %t11204, %L1149 ]
br label %L1143
L1143:
%t11206 = phi i64 [ %t11191, %L1141 ], [ %t11205, %L1146 ]
br label %L1140
L1140:
%t11207 = phi i64 [ %t11188, %L1138 ], [ %t11206, %L1143 ]
br label %L1137
L1137:
%t11208 = phi i64 [ %t11185, %L1135 ], [ %t11207, %L1140 ]
br label %L1134
L1134:
%t11209 = phi i64 [ %t11182, %L1132 ], [ %t11208, %L1137 ]
ret i64 %t11209
}
define ptr @__m_________lib_sha512g_resid__g5_blk__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, ptr %p2.in, i64 %p3.in, ptr %p4.in, i64 %p5.in, i64 %p6.in, i64 %p7.in, i64 %p8.in, i64 %p9.in, i64 %p10.in, i64 %p11.in, i64 %p12.in, i64 %p13.in, i64 %p14.in, i64 %p15.in, i64 %p16.in, i64 %p17.in, i64 %p18.in, i64 %p19.in, i64 %p20.in, i64 %p21.in, i64 %p22.in, i64 %p23.in, i64 %p24.in, i64 %p25.in, i64 %p26.in, i64 %p27.in, i64 %p28.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p2.ld = call ptr @resid_list_vdata(ptr %p2.in)
%p2.ln = call i64 @resid_list_vlen(ptr %p2.in)
%lml = call i64 @resid_loop_enter()
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0.ev.tco.s0, %tco.s0.k ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0.k ]
%p2 = phi ptr [ %p2.in, %entry ], [ %p2, %tco.s0.k ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t11249, %tco.s0.k ]
%p4 = phi ptr [ %p4.in, %entry ], [ %p4.ev.tco.s0, %tco.s0.k ]
%p5 = phi i64 [ %p5.in, %entry ], [ %t11250, %tco.s0.k ]
%p6 = phi i64 [ %p6.in, %entry ], [ %p5, %tco.s0.k ]
%p7 = phi i64 [ %p7.in, %entry ], [ %p6, %tco.s0.k ]
%p8 = phi i64 [ %p8.in, %entry ], [ %p7, %tco.s0.k ]
%p9 = phi i64 [ %p9.in, %entry ], [ %t11251, %tco.s0.k ]
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
%p28 = phi i64 [ %p28.in, %entry ], [ %t11236, %tco.s0.k ]
%t11210 = icmp sge i64 %p3, 80
br i1 %t11210, label %L1153, label %L1155
L1153:
%t11211 = call ptr @resid_gmalloc(i64 64)
%t11212 = getelementptr i8, ptr %p4, i64 0
%t11213 = load i64, ptr %t11212, align 8
%t11214 = call i64 @__m_________lib_word_resid__di_add(i64 %t11213, i64 %p5)
%t11211.f0 = getelementptr i8, ptr %t11211, i64 0
store i64 %t11214, ptr %t11211.f0, align 8
%t11215 = getelementptr i8, ptr %p4, i64 8
%t11216 = load i64, ptr %t11215, align 8
%t11217 = call i64 @__m_________lib_word_resid__di_add(i64 %t11216, i64 %p6)
%t11211.f1 = getelementptr i8, ptr %t11211, i64 8
store i64 %t11217, ptr %t11211.f1, align 8
%t11218 = getelementptr i8, ptr %p4, i64 16
%t11219 = load i64, ptr %t11218, align 8
%t11220 = call i64 @__m_________lib_word_resid__di_add(i64 %t11219, i64 %p7)
%t11211.f2 = getelementptr i8, ptr %t11211, i64 16
store i64 %t11220, ptr %t11211.f2, align 8
%t11221 = getelementptr i8, ptr %p4, i64 24
%t11222 = load i64, ptr %t11221, align 8
%t11223 = call i64 @__m_________lib_word_resid__di_add(i64 %t11222, i64 %p8)
%t11211.f3 = getelementptr i8, ptr %t11211, i64 24
store i64 %t11223, ptr %t11211.f3, align 8
%t11224 = getelementptr i8, ptr %p4, i64 32
%t11225 = load i64, ptr %t11224, align 8
%t11226 = call i64 @__m_________lib_word_resid__di_add(i64 %t11225, i64 %p9)
%t11211.f4 = getelementptr i8, ptr %t11211, i64 32
store i64 %t11226, ptr %t11211.f4, align 8
%t11227 = getelementptr i8, ptr %p4, i64 40
%t11228 = load i64, ptr %t11227, align 8
%t11229 = call i64 @__m_________lib_word_resid__di_add(i64 %t11228, i64 %p10)
%t11211.f5 = getelementptr i8, ptr %t11211, i64 40
store i64 %t11229, ptr %t11211.f5, align 8
%t11230 = getelementptr i8, ptr %p4, i64 48
%t11231 = load i64, ptr %t11230, align 8
%t11232 = call i64 @__m_________lib_word_resid__di_add(i64 %t11231, i64 %p11)
%t11211.f6 = getelementptr i8, ptr %t11211, i64 48
store i64 %t11232, ptr %t11211.f6, align 8
%t11233 = getelementptr i8, ptr %p4, i64 56
%t11234 = load i64, ptr %t11233, align 8
%t11235 = call i64 @__m_________lib_word_resid__di_add(i64 %t11234, i64 %p12)
%t11211.f7 = getelementptr i8, ptr %t11211, i64 56
store i64 %t11235, ptr %t11211.f7, align 8
%lr.cx79 = call ptr @resid_loop_exit(i64 %lml, i64 1)
%lr.lz79 = icmp eq ptr %lr.cx79, null
br i1 %lr.lz79, label %lr.x79.k, label %lr.x79.m
lr.x79.k:
ret ptr %t11211
lr.x79.m:
%lr.ret79 = call ptr @"resid.rec.evac.H8(UInt(64))"(ptr %t11211, ptr %lr.cx79)
call ptr @resid_loop_exit(i64 %lml, i64 2)
ret ptr %lr.ret79
L1155:
%t11236 = call i64 @__m_________lib_sha512g_resid__g5_sched__g_Int_64__UInt_64_(ptr %p0, i64 %p1, i64 %p3, i64 %p13, i64 %p14, i64 %p22, i64 %p27)
%t11237 = call i64 @__m_________lib_sha512g_resid__g5_b1__g_UInt_64__Int_64_(i64 %p9)
%t11238 = call i64 @__m_________lib_word_resid__di_add(i64 %p12, i64 %t11237)
%t11239 = call i64 @__m_________lib_sha512g_resid__g5_ch__g_UInt_64__Int_64_(i64 %p9, i64 %p10, i64 %p11)
%t11240 = call i64 @__m_________lib_word_resid__di_add(i64 %t11238, i64 %t11239)
%t11241 = call ptr @resid_list_get_v(ptr %p2, i64 %p3, ptr %p2.ld, i64 %p2.ln)
%t11242 = call i64 @resid_unbox_i64(ptr %t11241)
%t11244 = call i64 @__m_________lib_word_resid__di_addk(i64 %t11240, i64 %t11242)
%t11245 = call i64 @__m_________lib_word_resid__di_add(i64 %t11244, i64 %t11236)
%t11246 = call i64 @__m_________lib_sha512g_resid__g5_b0__g_UInt_64__Int_64_(i64 %p5)
%t11247 = call i64 @__m_________lib_sha512g_resid__g5_maj__g_UInt_64__Int_64_(i64 %p5, i64 %p6, i64 %p7)
%t11248 = call i64 @__m_________lib_word_resid__di_add(i64 %t11246, i64 %t11247)
%t11249 = add nsw i64 %p3, 1
%t11250 = call i64 @__m_________lib_word_resid__di_add(i64 %t11245, i64 %t11248)
%t11251 = call i64 @__m_________lib_word_resid__di_add(i64 %p8, i64 %t11245)
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
define i64 @__m_________lib_sha512g_resid__g5_sched__g_Int_64__UInt_64_(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11253 = icmp slt i64 %p2, 16
br i1 %t11253, label %L1156, label %L1158
L1156:
%t11254 = call {i64, i1} @llvm.smul.with.overflow.i64(i64 %p2, i64 8)
%t11255 = extractvalue {i64, i1} %t11254, 0
%t11256 = extractvalue {i64, i1} %t11254, 1
%t11257 = zext i1 %t11256 to i8
call void @resid_overflow_check(i8 %t11257)
%t11258 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %t11255)
%t11259 = extractvalue {i64, i1} %t11258, 0
%t11260 = extractvalue {i64, i1} %t11258, 1
%t11261 = zext i1 %t11260 to i8
call void @resid_overflow_check(i8 %t11261)
%t11262 = call i64 @__m_________lib_sha512g_resid__g5_word_at__g_Int_64__UInt_64_(ptr %p0, i64 %t11259)
ret i64 %t11262
L1158:
%t11263 = call i64 @__m_________lib_sha512g_resid__g5_s1__g_UInt_64__Int_64_(i64 %p6)
%t11264 = call i64 @__m_________lib_word_resid__di_add(i64 %t11263, i64 %p5)
%t11265 = call i64 @__m_________lib_sha512g_resid__g5_s0__g_UInt_64__Int_64_(i64 %p4)
%t11266 = call i64 @__m_________lib_word_resid__di_add(i64 %t11265, i64 %p3)
%t11267 = call i64 @__m_________lib_word_resid__di_add(i64 %t11264, i64 %t11266)
ret i64 %t11267
}
define i64 @__m_________lib_sha512g_resid__g5_b1__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11268 = call i64 @__m_________lib_word_resid__di_rotr(i64 %p0, i64 14)
%t11269 = call i64 @__m_________lib_word_resid__di_rotr(i64 %p0, i64 18)
%t11270 = call i64 @__m_________lib_word_resid__di_xor(i64 %t11268, i64 %t11269)
%t11271 = call i64 @__m_________lib_word_resid__di_rotr(i64 %p0, i64 41)
%t11272 = call i64 @__m_________lib_word_resid__di_xor(i64 %t11270, i64 %t11271)
ret i64 %t11272
}
define i64 @__m_________lib_sha512g_resid__g5_ch__g_UInt_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11273 = call i64 @__m_________lib_word_resid__di_and(i64 %p0, i64 %p1)
%t11274 = call i64 @__m_________lib_word_resid__di_not(i64 %p0)
%t11275 = call i64 @__m_________lib_word_resid__di_and(i64 %t11274, i64 %p2)
%t11276 = call i64 @__m_________lib_word_resid__di_xor(i64 %t11273, i64 %t11275)
ret i64 %t11276
}
define i64 @__m_________lib_sha512g_resid__g5_b0__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11277 = call i64 @__m_________lib_word_resid__di_rotr(i64 %p0, i64 28)
%t11278 = call i64 @__m_________lib_word_resid__di_rotr(i64 %p0, i64 34)
%t11279 = call i64 @__m_________lib_word_resid__di_xor(i64 %t11277, i64 %t11278)
%t11280 = call i64 @__m_________lib_word_resid__di_rotr(i64 %p0, i64 39)
%t11281 = call i64 @__m_________lib_word_resid__di_xor(i64 %t11279, i64 %t11280)
ret i64 %t11281
}
define i64 @__m_________lib_sha512g_resid__g5_maj__g_UInt_64__Int_64_(i64 %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11282 = call i64 @__m_________lib_word_resid__di_and(i64 %p0, i64 %p1)
%t11283 = call i64 @__m_________lib_word_resid__di_and(i64 %p0, i64 %p2)
%t11284 = call i64 @__m_________lib_word_resid__di_xor(i64 %t11282, i64 %t11283)
%t11285 = call i64 @__m_________lib_word_resid__di_and(i64 %p1, i64 %p2)
%t11286 = call i64 @__m_________lib_word_resid__di_xor(i64 %t11284, i64 %t11285)
ret i64 %t11286
}
define i64 @__m_________lib_sha512g_resid__g5_word_at__g_Int_64__UInt_64_(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11287 = call i64 @__m_________lib_sha512g_resid__g5_word_acc__g_Int_64__UInt_64_(ptr %p0, i64 %p1, i64 0, i64 0)
ret i64 %t11287
}
define i64 @__m_________lib_sha512g_resid__g5_s1__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11288 = call i64 @__m_________lib_word_resid__di_rotr(i64 %p0, i64 19)
%t11289 = call i64 @__m_________lib_word_resid__di_rotr(i64 %p0, i64 61)
%t11290 = call i64 @__m_________lib_word_resid__di_xor(i64 %t11288, i64 %t11289)
%t11291 = call i64 @__m_________lib_word_resid__di_shr(i64 %p0, i64 6)
%t11292 = call i64 @__m_________lib_word_resid__di_xor(i64 %t11290, i64 %t11291)
ret i64 %t11292
}
define i64 @__m_________lib_sha512g_resid__g5_s0__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11293 = call i64 @__m_________lib_word_resid__di_rotr(i64 %p0, i64 1)
%t11294 = call i64 @__m_________lib_word_resid__di_rotr(i64 %p0, i64 8)
%t11295 = call i64 @__m_________lib_word_resid__di_xor(i64 %t11293, i64 %t11294)
%t11296 = call i64 @__m_________lib_word_resid__di_shr(i64 %p0, i64 7)
%t11297 = call i64 @__m_________lib_word_resid__di_xor(i64 %t11295, i64 %t11296)
ret i64 %t11297
}
define i64 @__m_________lib_sha512g_resid__g5_word_acc__g_Int_64__UInt_64_(ptr %p0.in, i64 %p1.in, i64 %p2.in, i64 %p3.in) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%p0.ld = call ptr @resid_list_vdata(ptr %p0.in)
%p0.ln = call i64 @resid_list_vlen(ptr %p0.in)
br label %tco.head
tco.head:
%p0 = phi ptr [ %p0.in, %entry ], [ %p0, %tco.s0 ]
%p1 = phi i64 [ %p1.in, %entry ], [ %p1, %tco.s0 ]
%p2 = phi i64 [ %p2.in, %entry ], [ %t11308, %tco.s0 ]
%p3 = phi i64 [ %p3.in, %entry ], [ %t11310, %tco.s0 ]
%t11298 = icmp sge i64 %p2, 8
br i1 %t11298, label %L1159, label %L1161
L1159:
ret i64 %p3
L1161:
%t11299 = call i64 @__m_________lib_word_resid__di_and(i64 %p3, i64 72057594037927935)
%t11300 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p1, i64 %p2)
%t11301 = extractvalue {i64, i1} %t11300, 0
%t11302 = extractvalue {i64, i1} %t11300, 1
%t11303 = zext i1 %t11302 to i8
call void @resid_overflow_check(i8 %t11303)
%t11304 = call ptr @resid_list_get_v(ptr %p0, i64 %t11301, ptr %p0.ld, i64 %p0.ln)
%t11305 = call i64 @resid_unbox_i64(ptr %t11304)
%t11307 = call i64 @__m_________lib_word_resid__di_from_byte(i64 %t11305)
%t11308 = add nsw i64 %p2, 1
%t11309 = call i64 @__m_________lib_sha512g_resid__g5_shl8__g_UInt_64__Int_64_(i64 %t11299)
%t11310 = call i64 @__m_________lib_word_resid__di_xor(i64 %t11309, i64 %t11307)
br label %tco.s0
tco.s0:
br label %tco.head
}
define i64 @__m_________lib_sha512g_resid__g5_shl8__g_UInt_64__Int_64_(i64 %p0) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11312 = call i64 @__m_________lib_word_resid__di_rotr(i64 %p0, i64 56)
%t11313 = add i128 18446744073709551360, 0
%t11314 = trunc i128 %t11313 to i64
%t11315 = zext i64 %t11314 to i128
%t11316 = icmp ne i128 %t11315, %t11313
%t11317 = icmp slt i128 18446744073709551360, 0
%t11318 = or i1 %t11316, %t11317
%t11319 = zext i1 %t11318 to i8
call void @resid_conv_check(i8 %t11319)
%t11320 = call i64 @__m_________lib_word_resid__di_and(i64 %t11312, i64 %t11314)
ret i64 %t11320
}
define i64 @__m_________lib_bignum_resid__bn_cmp_at__rs45(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 0
}
define ptr @__m_________lib_bignum_resid__bn_sub_at__rs48(ptr %p0, ptr %p1, i64 %p2, i64 %p3, i64 %p4, ptr %p5) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11321 = call ptr @resid_listbuf_finish(ptr %p5, ptr @.lty11321)
ret ptr %t11321
}
define ptr @__m_________lib_bignum_resid__bn_short_at__rs72(ptr %p0, i64 %p1, i64 %p2, i128 %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11322 = call ptr @resid_gmalloc(i64 16)
%t11323 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty11323)
%t11324 = call ptr @__m_________lib_bignum_resid__bn_reverse(ptr %t11323)
%t11325 = call ptr @bn_trim(ptr %t11324)
%t11322.f0 = getelementptr i8, ptr %t11322, i64 0
store ptr %t11325, ptr %t11322.f0, align 8
%t11326 = add i128 %p3, 0
%t11327 = trunc i128 %t11326 to i64
%t11328 = zext i64 %t11327 to i128
%t11329 = icmp ne i128 %t11328, %t11326
%t11330 = icmp eq i8 0, 1
%t11331 = or i1 %t11329, %t11330
%t11332 = zext i1 %t11331 to i8
call void @resid_conv_check(i8 %t11332)
%t11333 = call ptr @bn_from_u64(i64 %t11327)
%t11322.f1 = getelementptr i8, ptr %t11322, i64 8
store ptr %t11333, ptr %t11322.f1, align 8
ret ptr %t11322
}
define ptr @bn_divmod__rs93(ptr %p0, ptr %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11335 = zext i1 true to i8
call void @resid_assert(i8 %t11335, ptr @.s11334)
%t11336 = alloca [1 x ptr]
%t11338 = call ptr @resid_box_i64(i64 3)
%t11340 = getelementptr i8, ptr %t11336, i64 0
store ptr %t11338, ptr %t11340
%t11341 = call ptr @resid_list_new(i64 1, ptr %t11336, ptr @.lty11336)
%t11342 = call i64 @bn_cmp(ptr %p0, ptr %t11341)
%t11343 = icmp slt i64 %t11342, 0
br i1 %t11343, label %L1162, label %L1164
L1162:
%t11344 = call ptr @resid_gmalloc(i64 16)
%t11345 = call ptr @resid_list_new(i64 0, ptr null, ptr @.ltyE11345)
%t11344.f0 = getelementptr i8, ptr %t11344, i64 0
store ptr %t11345, ptr %t11344.f0, align 8
%t11344.f1 = getelementptr i8, ptr %t11344, i64 8
store ptr %p0, ptr %t11344.f1, align 8
ret ptr %t11344
L1164:
%t11346 = call ptr @__m_________lib_bignum_resid__bn_divmod_short(ptr %p0, i64 3)
ret ptr %t11346
}
define i64 @__m_________lib_bignum_resid__bn_get__rs106(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 0
}
define i64 @__m_________lib_bignum_resid__bn_cmp_at__rs116(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 0
}
define ptr @__m_________lib_bignum_resid__bn_short_at__rs119(ptr %p0, i64 %p1, i64 %p2, i128 %p3, ptr %p4) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11347 = call ptr @resid_gmalloc(i64 16)
%t11348 = call ptr @resid_listbuf_finish(ptr %p4, ptr @.lty11348)
%t11349 = call ptr @__m_________lib_bignum_resid__bn_reverse(ptr %t11348)
%t11350 = call ptr @bn_trim(ptr %t11349)
%t11347.f0 = getelementptr i8, ptr %t11347, i64 0
store ptr %t11350, ptr %t11347.f0, align 8
%t11351 = add i128 %p3, 0
%t11352 = trunc i128 %t11351 to i64
%t11353 = zext i64 %t11352 to i128
%t11354 = icmp ne i128 %t11353, %t11351
%t11355 = icmp eq i8 0, 1
%t11356 = or i1 %t11354, %t11355
%t11357 = zext i1 %t11356 to i8
call void @resid_conv_check(i8 %t11357)
%t11358 = call ptr @bn_from_u64(i64 %t11352)
%t11347.f1 = getelementptr i8, ptr %t11347, i64 8
store ptr %t11358, ptr %t11347.f1, align 8
ret ptr %t11347
}
define ptr @__m_________lib_sha256g_resid__sha256g_pad_at__rs150(i64 %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11359 = call ptr @resid_box_i64(i64 128)
%t11362 = call ptr @resid_listbuf_push(ptr %p3, ptr %t11359)
%t11363 = musttail call ptr @__m_________lib_sha256g_resid__sha256g_pad_at(i64 %p0, i64 %p1, i64 1, ptr %t11362)
ret ptr %t11363
}
define ptr @length_bytes__rs160(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11366 = alloca [1 x ptr]
%t11364 = ashr i64 %p0, 0
%t11365 = and i64 %t11364, 255
%t11368 = call ptr @resid_box_i64(i64 %t11365)
%t11370 = getelementptr i8, ptr %t11366, i64 0
store ptr %t11368, ptr %t11370
%t11371 = call ptr @resid_list_new(i64 1, ptr %t11366, ptr @.lty11366)
%t11372 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t11371)
%t11373 = musttail call ptr @length_bytes(i64 %p0, i64 -1, ptr %t11372)
ret ptr %t11373
}
define ptr @length_bytes__rs159(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11376 = alloca [1 x ptr]
%t11374 = ashr i64 %p0, 8
%t11375 = and i64 %t11374, 255
%t11378 = call ptr @resid_box_i64(i64 %t11375)
%t11380 = getelementptr i8, ptr %t11376, i64 0
store ptr %t11378, ptr %t11380
%t11381 = call ptr @resid_list_new(i64 1, ptr %t11376, ptr @.lty11376)
%t11382 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t11381)
%t11383 = musttail call ptr @length_bytes__rs160(i64 %p0, i64 0, ptr %t11382)
ret ptr %t11383
}
define ptr @length_bytes__rs158(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11386 = alloca [1 x ptr]
%t11384 = ashr i64 %p0, 16
%t11385 = and i64 %t11384, 255
%t11388 = call ptr @resid_box_i64(i64 %t11385)
%t11390 = getelementptr i8, ptr %t11386, i64 0
store ptr %t11388, ptr %t11390
%t11391 = call ptr @resid_list_new(i64 1, ptr %t11386, ptr @.lty11386)
%t11392 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t11391)
%t11393 = musttail call ptr @length_bytes__rs159(i64 %p0, i64 1, ptr %t11392)
ret ptr %t11393
}
define ptr @length_bytes__rs157(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11396 = alloca [1 x ptr]
%t11394 = ashr i64 %p0, 24
%t11395 = and i64 %t11394, 255
%t11398 = call ptr @resid_box_i64(i64 %t11395)
%t11400 = getelementptr i8, ptr %t11396, i64 0
store ptr %t11398, ptr %t11400
%t11401 = call ptr @resid_list_new(i64 1, ptr %t11396, ptr @.lty11396)
%t11402 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t11401)
%t11403 = musttail call ptr @length_bytes__rs158(i64 %p0, i64 2, ptr %t11402)
ret ptr %t11403
}
define ptr @length_bytes__rs156(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11406 = alloca [1 x ptr]
%t11404 = ashr i64 %p0, 32
%t11405 = and i64 %t11404, 255
%t11408 = call ptr @resid_box_i64(i64 %t11405)
%t11410 = getelementptr i8, ptr %t11406, i64 0
store ptr %t11408, ptr %t11410
%t11411 = call ptr @resid_list_new(i64 1, ptr %t11406, ptr @.lty11406)
%t11412 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t11411)
%t11413 = musttail call ptr @length_bytes__rs157(i64 %p0, i64 3, ptr %t11412)
ret ptr %t11413
}
define ptr @length_bytes__rs155(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11416 = alloca [1 x ptr]
%t11414 = ashr i64 %p0, 40
%t11415 = and i64 %t11414, 255
%t11418 = call ptr @resid_box_i64(i64 %t11415)
%t11420 = getelementptr i8, ptr %t11416, i64 0
store ptr %t11418, ptr %t11420
%t11421 = call ptr @resid_list_new(i64 1, ptr %t11416, ptr @.lty11416)
%t11422 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t11421)
%t11423 = musttail call ptr @length_bytes__rs156(i64 %p0, i64 4, ptr %t11422)
ret ptr %t11423
}
define ptr @length_bytes__rs154(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11426 = alloca [1 x ptr]
%t11424 = ashr i64 %p0, 48
%t11425 = and i64 %t11424, 255
%t11428 = call ptr @resid_box_i64(i64 %t11425)
%t11430 = getelementptr i8, ptr %t11426, i64 0
store ptr %t11428, ptr %t11430
%t11431 = call ptr @resid_list_new(i64 1, ptr %t11426, ptr @.lty11426)
%t11432 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t11431)
%t11433 = musttail call ptr @length_bytes__rs155(i64 %p0, i64 5, ptr %t11432)
ret ptr %t11433
}
define ptr @length_bytes__rs153(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11436 = alloca [1 x ptr]
%t11434 = ashr i64 %p0, 56
%t11435 = and i64 %t11434, 255
%t11438 = call ptr @resid_box_i64(i64 %t11435)
%t11440 = getelementptr i8, ptr %t11436, i64 0
store ptr %t11438, ptr %t11440
%t11441 = call ptr @resid_list_new(i64 1, ptr %t11436, ptr @.lty11436)
%t11442 = call ptr @resid_list_concat_own(ptr %p2, i8 1, ptr %t11441)
%t11443 = musttail call ptr @length_bytes__rs154(i64 %p0, i64 6, ptr %t11442)
ret ptr %t11443
}
define ptr @sha_hw_words__rs181(i256 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11444 = lshr i256 %p0, 0
%t11445 = and i256 %t11444, 4294967295
%t11446 = trunc i256 %t11445 to i64
%t11447 = call ptr @resid_box_i64(i64 %t11446)
%t11450 = call ptr @resid_listbuf_push(ptr %p2, ptr %t11447)
%t11451 = call ptr @sha_hw_words(i256 %p0, i64 1, ptr %t11450)
ret ptr %t11451
}
define i64 @sched_w__rs191(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11452 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 0)
ret i64 %t11452
}
define i64 @sched_w__rs193(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11453 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 1)
ret i64 %t11453
}
define i64 @sched_w__rs195(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11454 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 2)
ret i64 %t11454
}
define i64 @sched_w__rs198(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11455 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 3)
ret i64 %t11455
}
define i64 @sched_w__rs201(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11456 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 4)
ret i64 %t11456
}
define i64 @sched_w__rs204(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11457 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 5)
ret i64 %t11457
}
define i64 @sched_w__rs207(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11458 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 6)
ret i64 %t11458
}
define i64 @sched_w__rs210(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11459 = call i64 @word_at_str(ptr %p0, i64 %p1, i64 7)
ret i64 %t11459
}
define ptr @sha_blk__rs209(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11460 = call i64 @sched_w__rs210(ptr %p0, i64 %p1, i64 7, i64 0, i64 0, i64 %p21, i64 %p26)
%t11461 = call i64 @bsig1(i64 %p8)
%t11462 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t11461)
%t11463 = extractvalue {i64, i1} %t11462, 0
%t11464 = extractvalue {i64, i1} %t11462, 1
%t11465 = zext i1 %t11464 to i8
call void @resid_overflow_check(i8 %t11465)
%t11466 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t11467 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11463, i64 %t11466)
%t11468 = extractvalue {i64, i1} %t11467, 0
%t11469 = extractvalue {i64, i1} %t11467, 1
%t11470 = zext i1 %t11469 to i8
call void @resid_overflow_check(i8 %t11470)
%t11471 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11468, i64 -1424204075)
%t11472 = extractvalue {i64, i1} %t11471, 0
%t11473 = extractvalue {i64, i1} %t11471, 1
%t11474 = zext i1 %t11473 to i8
call void @resid_overflow_check(i8 %t11474)
%t11475 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11472, i64 %t11460)
%t11476 = extractvalue {i64, i1} %t11475, 0
%t11477 = extractvalue {i64, i1} %t11475, 1
%t11478 = zext i1 %t11477 to i8
call void @resid_overflow_check(i8 %t11478)
%t11479 = and i64 %t11476, 4294967295
%t11480 = call i64 @bsig0(i64 %p4)
%t11481 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t11482 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11480, i64 %t11481)
%t11483 = extractvalue {i64, i1} %t11482, 0
%t11484 = extractvalue {i64, i1} %t11482, 1
%t11485 = zext i1 %t11484 to i8
call void @resid_overflow_check(i8 %t11485)
%t11486 = and i64 %t11483, 4294967295
%t11487 = add nsw i64 %t11479, %t11486
%t11488 = and i64 %t11487, 4294967295
%t11489 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t11479)
%t11490 = extractvalue {i64, i1} %t11489, 0
%t11491 = extractvalue {i64, i1} %t11489, 1
%t11492 = zext i1 %t11491 to i8
call void @resid_overflow_check(i8 %t11492)
%t11493 = and i64 %t11490, 4294967295
%t11494 = musttail call ptr @sha_blk(ptr %p0, i64 %p1, i64 8, ptr %p3, i64 %t11488, i64 %p4, i64 %p5, i64 %p6, i64 %t11493, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t11460)
ret ptr %t11494
}
define ptr @sha_blk__rs206(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11495 = call i64 @sched_w__rs207(ptr %p0, i64 %p1, i64 6, i64 0, i64 0, i64 0, i64 %p26)
%t11496 = call i64 @bsig1(i64 %p8)
%t11497 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t11496)
%t11498 = extractvalue {i64, i1} %t11497, 0
%t11499 = extractvalue {i64, i1} %t11497, 1
%t11500 = zext i1 %t11499 to i8
call void @resid_overflow_check(i8 %t11500)
%t11501 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t11502 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11498, i64 %t11501)
%t11503 = extractvalue {i64, i1} %t11502, 0
%t11504 = extractvalue {i64, i1} %t11502, 1
%t11505 = zext i1 %t11504 to i8
call void @resid_overflow_check(i8 %t11505)
%t11506 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11503, i64 -1841331548)
%t11507 = extractvalue {i64, i1} %t11506, 0
%t11508 = extractvalue {i64, i1} %t11506, 1
%t11509 = zext i1 %t11508 to i8
call void @resid_overflow_check(i8 %t11509)
%t11510 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11507, i64 %t11495)
%t11511 = extractvalue {i64, i1} %t11510, 0
%t11512 = extractvalue {i64, i1} %t11510, 1
%t11513 = zext i1 %t11512 to i8
call void @resid_overflow_check(i8 %t11513)
%t11514 = and i64 %t11511, 4294967295
%t11515 = call i64 @bsig0(i64 %p4)
%t11516 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t11517 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11515, i64 %t11516)
%t11518 = extractvalue {i64, i1} %t11517, 0
%t11519 = extractvalue {i64, i1} %t11517, 1
%t11520 = zext i1 %t11519 to i8
call void @resid_overflow_check(i8 %t11520)
%t11521 = and i64 %t11518, 4294967295
%t11522 = add nsw i64 %t11514, %t11521
%t11523 = and i64 %t11522, 4294967295
%t11524 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t11514)
%t11525 = extractvalue {i64, i1} %t11524, 0
%t11526 = extractvalue {i64, i1} %t11524, 1
%t11527 = zext i1 %t11526 to i8
call void @resid_overflow_check(i8 %t11527)
%t11528 = and i64 %t11525, 4294967295
%t11529 = musttail call ptr @sha_blk__rs209(ptr %p0, i64 %p1, i64 7, ptr %p3, i64 %t11523, i64 %p4, i64 %p5, i64 %p6, i64 %t11528, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t11495)
ret ptr %t11529
}
define ptr @sha_blk__rs203(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11530 = call i64 @sched_w__rs204(ptr %p0, i64 %p1, i64 5, i64 0, i64 0, i64 0, i64 %p26)
%t11531 = call i64 @bsig1(i64 %p8)
%t11532 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t11531)
%t11533 = extractvalue {i64, i1} %t11532, 0
%t11534 = extractvalue {i64, i1} %t11532, 1
%t11535 = zext i1 %t11534 to i8
call void @resid_overflow_check(i8 %t11535)
%t11536 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t11537 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11533, i64 %t11536)
%t11538 = extractvalue {i64, i1} %t11537, 0
%t11539 = extractvalue {i64, i1} %t11537, 1
%t11540 = zext i1 %t11539 to i8
call void @resid_overflow_check(i8 %t11540)
%t11541 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11538, i64 1508970993)
%t11542 = extractvalue {i64, i1} %t11541, 0
%t11543 = extractvalue {i64, i1} %t11541, 1
%t11544 = zext i1 %t11543 to i8
call void @resid_overflow_check(i8 %t11544)
%t11545 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11542, i64 %t11530)
%t11546 = extractvalue {i64, i1} %t11545, 0
%t11547 = extractvalue {i64, i1} %t11545, 1
%t11548 = zext i1 %t11547 to i8
call void @resid_overflow_check(i8 %t11548)
%t11549 = and i64 %t11546, 4294967295
%t11550 = call i64 @bsig0(i64 %p4)
%t11551 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t11552 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11550, i64 %t11551)
%t11553 = extractvalue {i64, i1} %t11552, 0
%t11554 = extractvalue {i64, i1} %t11552, 1
%t11555 = zext i1 %t11554 to i8
call void @resid_overflow_check(i8 %t11555)
%t11556 = and i64 %t11553, 4294967295
%t11557 = add nsw i64 %t11549, %t11556
%t11558 = and i64 %t11557, 4294967295
%t11559 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t11549)
%t11560 = extractvalue {i64, i1} %t11559, 0
%t11561 = extractvalue {i64, i1} %t11559, 1
%t11562 = zext i1 %t11561 to i8
call void @resid_overflow_check(i8 %t11562)
%t11563 = and i64 %t11560, 4294967295
%t11564 = musttail call ptr @sha_blk__rs206(ptr %p0, i64 %p1, i64 6, ptr %p3, i64 %t11558, i64 %p4, i64 %p5, i64 %p6, i64 %t11563, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t11530)
ret ptr %t11564
}
define ptr @sha_blk__rs200(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11565 = call i64 @sched_w__rs201(ptr %p0, i64 %p1, i64 4, i64 0, i64 0, i64 0, i64 %p26)
%t11566 = call i64 @bsig1(i64 %p8)
%t11567 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t11566)
%t11568 = extractvalue {i64, i1} %t11567, 0
%t11569 = extractvalue {i64, i1} %t11567, 1
%t11570 = zext i1 %t11569 to i8
call void @resid_overflow_check(i8 %t11570)
%t11571 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t11572 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11568, i64 %t11571)
%t11573 = extractvalue {i64, i1} %t11572, 0
%t11574 = extractvalue {i64, i1} %t11572, 1
%t11575 = zext i1 %t11574 to i8
call void @resid_overflow_check(i8 %t11575)
%t11576 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11573, i64 961987163)
%t11577 = extractvalue {i64, i1} %t11576, 0
%t11578 = extractvalue {i64, i1} %t11576, 1
%t11579 = zext i1 %t11578 to i8
call void @resid_overflow_check(i8 %t11579)
%t11580 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11577, i64 %t11565)
%t11581 = extractvalue {i64, i1} %t11580, 0
%t11582 = extractvalue {i64, i1} %t11580, 1
%t11583 = zext i1 %t11582 to i8
call void @resid_overflow_check(i8 %t11583)
%t11584 = and i64 %t11581, 4294967295
%t11585 = call i64 @bsig0(i64 %p4)
%t11586 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t11587 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11585, i64 %t11586)
%t11588 = extractvalue {i64, i1} %t11587, 0
%t11589 = extractvalue {i64, i1} %t11587, 1
%t11590 = zext i1 %t11589 to i8
call void @resid_overflow_check(i8 %t11590)
%t11591 = and i64 %t11588, 4294967295
%t11592 = add nsw i64 %t11584, %t11591
%t11593 = and i64 %t11592, 4294967295
%t11594 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t11584)
%t11595 = extractvalue {i64, i1} %t11594, 0
%t11596 = extractvalue {i64, i1} %t11594, 1
%t11597 = zext i1 %t11596 to i8
call void @resid_overflow_check(i8 %t11597)
%t11598 = and i64 %t11595, 4294967295
%t11599 = musttail call ptr @sha_blk__rs203(ptr %p0, i64 %p1, i64 5, ptr %p3, i64 %t11593, i64 %p4, i64 %p5, i64 %p6, i64 %t11598, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p24, i64 %p25, i64 %p26, i64 %p27, i64 %t11565)
ret ptr %t11599
}
define ptr @sha_blk__rs197(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11600 = call i64 @sched_w__rs198(ptr %p0, i64 %p1, i64 3, i64 0, i64 0, i64 0, i64 %p26)
%t11601 = call i64 @bsig1(i64 %p8)
%t11602 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t11601)
%t11603 = extractvalue {i64, i1} %t11602, 0
%t11604 = extractvalue {i64, i1} %t11602, 1
%t11605 = zext i1 %t11604 to i8
call void @resid_overflow_check(i8 %t11605)
%t11606 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t11607 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11603, i64 %t11606)
%t11608 = extractvalue {i64, i1} %t11607, 0
%t11609 = extractvalue {i64, i1} %t11607, 1
%t11610 = zext i1 %t11609 to i8
call void @resid_overflow_check(i8 %t11610)
%t11611 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11608, i64 -373957723)
%t11612 = extractvalue {i64, i1} %t11611, 0
%t11613 = extractvalue {i64, i1} %t11611, 1
%t11614 = zext i1 %t11613 to i8
call void @resid_overflow_check(i8 %t11614)
%t11615 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11612, i64 %t11600)
%t11616 = extractvalue {i64, i1} %t11615, 0
%t11617 = extractvalue {i64, i1} %t11615, 1
%t11618 = zext i1 %t11617 to i8
call void @resid_overflow_check(i8 %t11618)
%t11619 = and i64 %t11616, 4294967295
%t11620 = call i64 @bsig0(i64 %p4)
%t11621 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t11622 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11620, i64 %t11621)
%t11623 = extractvalue {i64, i1} %t11622, 0
%t11624 = extractvalue {i64, i1} %t11622, 1
%t11625 = zext i1 %t11624 to i8
call void @resid_overflow_check(i8 %t11625)
%t11626 = and i64 %t11623, 4294967295
%t11627 = add nsw i64 %t11619, %t11626
%t11628 = and i64 %t11627, 4294967295
%t11629 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t11619)
%t11630 = extractvalue {i64, i1} %t11629, 0
%t11631 = extractvalue {i64, i1} %t11629, 1
%t11632 = zext i1 %t11631 to i8
call void @resid_overflow_check(i8 %t11632)
%t11633 = and i64 %t11630, 4294967295
%t11634 = musttail call ptr @sha_blk__rs200(ptr %p0, i64 %p1, i64 4, ptr %p3, i64 %t11628, i64 %p4, i64 %p5, i64 %p6, i64 %t11633, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p25, i64 %p26, i64 %p27, i64 %t11600)
ret ptr %t11634
}
define ptr @sha_blk__rs194(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11635 = call i64 @sched_w__rs195(ptr %p0, i64 %p1, i64 2, i64 0, i64 0, i64 0, i64 %p26)
%t11636 = call i64 @bsig1(i64 %p8)
%t11637 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t11636)
%t11638 = extractvalue {i64, i1} %t11637, 0
%t11639 = extractvalue {i64, i1} %t11637, 1
%t11640 = zext i1 %t11639 to i8
call void @resid_overflow_check(i8 %t11640)
%t11641 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t11642 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11638, i64 %t11641)
%t11643 = extractvalue {i64, i1} %t11642, 0
%t11644 = extractvalue {i64, i1} %t11642, 1
%t11645 = zext i1 %t11644 to i8
call void @resid_overflow_check(i8 %t11645)
%t11646 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11643, i64 -1245643825)
%t11647 = extractvalue {i64, i1} %t11646, 0
%t11648 = extractvalue {i64, i1} %t11646, 1
%t11649 = zext i1 %t11648 to i8
call void @resid_overflow_check(i8 %t11649)
%t11650 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11647, i64 %t11635)
%t11651 = extractvalue {i64, i1} %t11650, 0
%t11652 = extractvalue {i64, i1} %t11650, 1
%t11653 = zext i1 %t11652 to i8
call void @resid_overflow_check(i8 %t11653)
%t11654 = and i64 %t11651, 4294967295
%t11655 = call i64 @bsig0(i64 %p4)
%t11656 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t11657 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11655, i64 %t11656)
%t11658 = extractvalue {i64, i1} %t11657, 0
%t11659 = extractvalue {i64, i1} %t11657, 1
%t11660 = zext i1 %t11659 to i8
call void @resid_overflow_check(i8 %t11660)
%t11661 = and i64 %t11658, 4294967295
%t11662 = add nsw i64 %t11654, %t11661
%t11663 = and i64 %t11662, 4294967295
%t11664 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t11654)
%t11665 = extractvalue {i64, i1} %t11664, 0
%t11666 = extractvalue {i64, i1} %t11664, 1
%t11667 = zext i1 %t11666 to i8
call void @resid_overflow_check(i8 %t11667)
%t11668 = and i64 %t11665, 4294967295
%t11669 = musttail call ptr @sha_blk__rs197(ptr %p0, i64 %p1, i64 3, ptr %p3, i64 %t11663, i64 %p4, i64 %p5, i64 %p6, i64 %t11668, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p26, i64 %p27, i64 %t11635)
ret ptr %t11669
}
define ptr @sha_blk__rs192(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11670 = call i64 @sched_w__rs193(ptr %p0, i64 %p1, i64 1, i64 0, i64 0, i64 0, i64 0)
%t11671 = call i64 @bsig1(i64 %p8)
%t11672 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t11671)
%t11673 = extractvalue {i64, i1} %t11672, 0
%t11674 = extractvalue {i64, i1} %t11672, 1
%t11675 = zext i1 %t11674 to i8
call void @resid_overflow_check(i8 %t11675)
%t11676 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t11677 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11673, i64 %t11676)
%t11678 = extractvalue {i64, i1} %t11677, 0
%t11679 = extractvalue {i64, i1} %t11677, 1
%t11680 = zext i1 %t11679 to i8
call void @resid_overflow_check(i8 %t11680)
%t11681 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11678, i64 1899447441)
%t11682 = extractvalue {i64, i1} %t11681, 0
%t11683 = extractvalue {i64, i1} %t11681, 1
%t11684 = zext i1 %t11683 to i8
call void @resid_overflow_check(i8 %t11684)
%t11685 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11682, i64 %t11670)
%t11686 = extractvalue {i64, i1} %t11685, 0
%t11687 = extractvalue {i64, i1} %t11685, 1
%t11688 = zext i1 %t11687 to i8
call void @resid_overflow_check(i8 %t11688)
%t11689 = and i64 %t11686, 4294967295
%t11690 = call i64 @bsig0(i64 %p4)
%t11691 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t11692 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11690, i64 %t11691)
%t11693 = extractvalue {i64, i1} %t11692, 0
%t11694 = extractvalue {i64, i1} %t11692, 1
%t11695 = zext i1 %t11694 to i8
call void @resid_overflow_check(i8 %t11695)
%t11696 = and i64 %t11693, 4294967295
%t11697 = add nsw i64 %t11689, %t11696
%t11698 = and i64 %t11697, 4294967295
%t11699 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t11689)
%t11700 = extractvalue {i64, i1} %t11699, 0
%t11701 = extractvalue {i64, i1} %t11699, 1
%t11702 = zext i1 %t11701 to i8
call void @resid_overflow_check(i8 %t11702)
%t11703 = and i64 %t11700, 4294967295
%t11704 = musttail call ptr @sha_blk__rs194(ptr %p0, i64 %p1, i64 2, ptr %p3, i64 %t11698, i64 %p4, i64 %p5, i64 %p6, i64 %t11703, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %p27, i64 %t11670)
ret ptr %t11704
}
define ptr @sha_blk__rs190(ptr %p0, i64 %p1, i64 %p2, ptr %p3, i64 %p4, i64 %p5, i64 %p6, i64 %p7, i64 %p8, i64 %p9, i64 %p10, i64 %p11, i64 %p12, i64 %p13, i64 %p14, i64 %p15, i64 %p16, i64 %p17, i64 %p18, i64 %p19, i64 %p20, i64 %p21, i64 %p22, i64 %p23, i64 %p24, i64 %p25, i64 %p26, i64 %p27) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11705 = call i64 @sched_w__rs191(ptr %p0, i64 %p1, i64 0, i64 0, i64 0, i64 0, i64 0)
%t11706 = call i64 @bsig1(i64 %p8)
%t11707 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p11, i64 %t11706)
%t11708 = extractvalue {i64, i1} %t11707, 0
%t11709 = extractvalue {i64, i1} %t11707, 1
%t11710 = zext i1 %t11709 to i8
call void @resid_overflow_check(i8 %t11710)
%t11711 = call i64 @ch_of(i64 %p8, i64 %p9, i64 %p10)
%t11712 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11708, i64 %t11711)
%t11713 = extractvalue {i64, i1} %t11712, 0
%t11714 = extractvalue {i64, i1} %t11712, 1
%t11715 = zext i1 %t11714 to i8
call void @resid_overflow_check(i8 %t11715)
%t11716 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11713, i64 1116352408)
%t11717 = extractvalue {i64, i1} %t11716, 0
%t11718 = extractvalue {i64, i1} %t11716, 1
%t11719 = zext i1 %t11718 to i8
call void @resid_overflow_check(i8 %t11719)
%t11720 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11717, i64 %t11705)
%t11721 = extractvalue {i64, i1} %t11720, 0
%t11722 = extractvalue {i64, i1} %t11720, 1
%t11723 = zext i1 %t11722 to i8
call void @resid_overflow_check(i8 %t11723)
%t11724 = and i64 %t11721, 4294967295
%t11725 = call i64 @bsig0(i64 %p4)
%t11726 = call i64 @maj_of(i64 %p4, i64 %p5, i64 %p6)
%t11727 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %t11725, i64 %t11726)
%t11728 = extractvalue {i64, i1} %t11727, 0
%t11729 = extractvalue {i64, i1} %t11727, 1
%t11730 = zext i1 %t11729 to i8
call void @resid_overflow_check(i8 %t11730)
%t11731 = and i64 %t11728, 4294967295
%t11732 = add nsw i64 %t11724, %t11731
%t11733 = and i64 %t11732, 4294967295
%t11734 = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %p7, i64 %t11724)
%t11735 = extractvalue {i64, i1} %t11734, 0
%t11736 = extractvalue {i64, i1} %t11734, 1
%t11737 = zext i1 %t11736 to i8
call void @resid_overflow_check(i8 %t11737)
%t11738 = and i64 %t11735, 4294967295
%t11739 = musttail call ptr @sha_blk__rs192(ptr %p0, i64 %p1, i64 1, ptr %p3, i64 %t11733, i64 %p4, i64 %p5, i64 %p6, i64 %t11738, i64 %p8, i64 %p9, i64 %p10, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 %t11705)
ret ptr %t11739
}
define ptr @hex_state__rs235(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11740 = call ptr @resid_list_get(ptr %p0, i64 1)
%t11741 = call i64 @resid_unbox_i64(ptr %t11740)
%t11743 = call ptr @hex_word(i64 %t11741)
%t11744 = call ptr @resid_str_concat(ptr %p2, ptr %t11743)
%t11745 = musttail call ptr @hex_state(ptr %p0, i64 2, ptr %t11744)
ret ptr %t11745
}
define ptr @hex_state__rs234(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11747 = call ptr @resid_list_get(ptr %p0, i64 0)
%t11748 = call i64 @resid_unbox_i64(ptr %t11747)
%t11750 = call ptr @hex_word(i64 %t11748)
%t11751 = call ptr @resid_str_concat(ptr @.s11746, ptr %t11750)
%t11752 = musttail call ptr @hex_state__rs235(ptr %p0, i64 1, ptr %t11751)
ret ptr %t11752
}
define ptr @wtb_inner__rs236(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11754 = alloca [1 x ptr]
%t11753 = call i64 @word_byte(ptr %p0, i64 %p1, i64 0)
%t11756 = call ptr @resid_box_i64(i64 %t11753)
%t11758 = getelementptr i8, ptr %t11754, i64 0
store ptr %t11756, ptr %t11758
%t11759 = call ptr @resid_list_new(i64 1, ptr %t11754, ptr @.lty11754)
%t11760 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t11759)
%t11761 = musttail call ptr @wtb_inner(ptr %p0, i64 %p1, i64 1, ptr %t11760)
ret ptr %t11761
}
define ptr @wtb_inner__rs239(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11763 = alloca [1 x ptr]
%t11762 = call i64 @word_byte(ptr %p0, i64 0, i64 0)
%t11765 = call ptr @resid_box_i64(i64 %t11762)
%t11767 = getelementptr i8, ptr %t11763, i64 0
store ptr %t11765, ptr %t11767
%t11768 = call ptr @resid_list_new(i64 1, ptr %t11763, ptr @.lty11763)
%t11769 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t11768)
%t11770 = musttail call ptr @wtb_inner(ptr %p0, i64 0, i64 1, ptr %t11769)
ret ptr %t11770
}
define ptr @wtb_outer__rs238(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11771 = call ptr @wtb_inner__rs239(ptr %p0, i64 0, i64 0, ptr %p2)
%t11772 = musttail call ptr @wtb_outer(ptr %p0, i64 1, ptr %t11771)
ret ptr %t11772
}
define i64 @pick__rs269(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
ret i64 %p2
}
define ptr @w64__rs272(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11773 = and i64 %p1, 4294967295
%t11774 = alloca [2 x ptr]
%t11776 = call ptr @resid_box_i64(i64 0)
%t11778 = getelementptr i8, ptr %t11774, i64 0
store ptr %t11776, ptr %t11778
%t11779 = call ptr @resid_box_i64(i64 %t11773)
%t11781 = getelementptr i8, ptr %t11774, i64 8
store ptr %t11779, ptr %t11781
%t11782 = call ptr @resid_list_new(i64 2, ptr %t11774, ptr @.lty11774)
ret ptr %t11782
}
define i64 @shr_big__rs276(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11783 = ashr i64 %p0, 56
ret i64 %t11783
}
define i64 @shr_big__rs275(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11784 = ashr i64 %p0, 32
%t11785 = musttail call i64 @shr_big__rs276(i64 %t11784, i64 56)
ret i64 %t11785
}
define i64 @shr_big__rs274(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11786 = ashr i64 %p0, 32
%t11787 = musttail call i64 @shr_big__rs275(i64 %t11786, i64 88)
ret i64 %t11787
}
define i64 @shr_big__rs280(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11788 = ashr i64 %p0, 48
ret i64 %t11788
}
define i64 @shr_big__rs279(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11789 = ashr i64 %p0, 32
%t11790 = musttail call i64 @shr_big__rs280(i64 %t11789, i64 48)
ret i64 %t11790
}
define i64 @shr_big__rs278(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11791 = ashr i64 %p0, 32
%t11792 = musttail call i64 @shr_big__rs279(i64 %t11791, i64 80)
ret i64 %t11792
}
define i64 @shr_big__rs283(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11793 = ashr i64 %p0, 32
%t11794 = musttail call i64 @shr_big(i64 %t11793, i64 40)
ret i64 %t11794
}
define i64 @shr_big__rs282(i64 %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11795 = ashr i64 %p0, 32
%t11796 = musttail call i64 @shr_big__rs283(i64 %t11795, i64 72)
ret i64 %t11796
}
define ptr @len512_bytes__rs288(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11799 = alloca [1 x ptr]
%t11797 = call i64 @shr_big(i64 %p1, i64 64)
%t11798 = and i64 %t11797, 255
%t11801 = call ptr @resid_box_i64(i64 %t11798)
%t11803 = getelementptr i8, ptr %t11799, i64 0
store ptr %t11801, ptr %t11803
%t11804 = call ptr @resid_list_new(i64 1, ptr %t11799, ptr @.lty11799)
%t11805 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11804)
%t11806 = musttail call ptr @len512_bytes(ptr %t11805, i64 %p1, i64 7)
ret ptr %t11806
}
define ptr @len512_bytes__rs287(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11809 = alloca [1 x ptr]
%t11807 = call i64 @shr_big__rs283(i64 %p1, i64 72)
%t11808 = and i64 %t11807, 255
%t11811 = call ptr @resid_box_i64(i64 %t11808)
%t11813 = getelementptr i8, ptr %t11809, i64 0
store ptr %t11811, ptr %t11813
%t11814 = call ptr @resid_list_new(i64 1, ptr %t11809, ptr @.lty11809)
%t11815 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11814)
%t11816 = musttail call ptr @len512_bytes__rs288(ptr %t11815, i64 %p1, i64 8)
ret ptr %t11816
}
define ptr @len512_bytes__rs286(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11819 = alloca [1 x ptr]
%t11817 = call i64 @shr_big__rs279(i64 %p1, i64 80)
%t11818 = and i64 %t11817, 255
%t11821 = call ptr @resid_box_i64(i64 %t11818)
%t11823 = getelementptr i8, ptr %t11819, i64 0
store ptr %t11821, ptr %t11823
%t11824 = call ptr @resid_list_new(i64 1, ptr %t11819, ptr @.lty11819)
%t11825 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11824)
%t11826 = musttail call ptr @len512_bytes__rs287(ptr %t11825, i64 %p1, i64 9)
ret ptr %t11826
}
define ptr @len512_bytes__rs285(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11829 = alloca [1 x ptr]
%t11827 = call i64 @shr_big__rs275(i64 %p1, i64 88)
%t11828 = and i64 %t11827, 255
%t11831 = call ptr @resid_box_i64(i64 %t11828)
%t11833 = getelementptr i8, ptr %t11829, i64 0
store ptr %t11831, ptr %t11833
%t11834 = call ptr @resid_list_new(i64 1, ptr %t11829, ptr @.lty11829)
%t11835 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11834)
%t11836 = musttail call ptr @len512_bytes__rs286(ptr %t11835, i64 %p1, i64 10)
ret ptr %t11836
}
define ptr @len512_bytes__rs284(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11839 = alloca [1 x ptr]
%t11837 = call i64 @shr_big(i64 %p1, i64 96)
%t11838 = and i64 %t11837, 255
%t11841 = call ptr @resid_box_i64(i64 %t11838)
%t11843 = getelementptr i8, ptr %t11839, i64 0
store ptr %t11841, ptr %t11843
%t11844 = call ptr @resid_list_new(i64 1, ptr %t11839, ptr @.lty11839)
%t11845 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11844)
%t11846 = musttail call ptr @len512_bytes__rs285(ptr %t11845, i64 %p1, i64 11)
ret ptr %t11846
}
define ptr @len512_bytes__rs281(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11849 = alloca [1 x ptr]
%t11847 = call i64 @shr_big__rs282(i64 %p1, i64 104)
%t11848 = and i64 %t11847, 255
%t11851 = call ptr @resid_box_i64(i64 %t11848)
%t11853 = getelementptr i8, ptr %t11849, i64 0
store ptr %t11851, ptr %t11853
%t11854 = call ptr @resid_list_new(i64 1, ptr %t11849, ptr @.lty11849)
%t11855 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11854)
%t11856 = musttail call ptr @len512_bytes__rs284(ptr %t11855, i64 %p1, i64 12)
ret ptr %t11856
}
define ptr @len512_bytes__rs277(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11859 = alloca [1 x ptr]
%t11857 = call i64 @shr_big__rs278(i64 %p1, i64 112)
%t11858 = and i64 %t11857, 255
%t11861 = call ptr @resid_box_i64(i64 %t11858)
%t11863 = getelementptr i8, ptr %t11859, i64 0
store ptr %t11861, ptr %t11863
%t11864 = call ptr @resid_list_new(i64 1, ptr %t11859, ptr @.lty11859)
%t11865 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11864)
%t11866 = musttail call ptr @len512_bytes__rs281(ptr %t11865, i64 %p1, i64 13)
ret ptr %t11866
}
define ptr @len512_bytes__rs273(ptr %p0, i64 %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11869 = alloca [1 x ptr]
%t11867 = call i64 @shr_big__rs274(i64 %p1, i64 120)
%t11868 = and i64 %t11867, 255
%t11871 = call ptr @resid_box_i64(i64 %t11868)
%t11873 = getelementptr i8, ptr %t11869, i64 0
store ptr %t11871, ptr %t11873
%t11874 = call ptr @resid_list_new(i64 1, ptr %t11869, ptr @.lty11869)
%t11875 = call ptr @resid_list_concat_own(ptr %p0, i8 1, ptr %t11874)
%t11876 = musttail call ptr @len512_bytes__rs277(ptr %t11875, i64 %p1, i64 14)
ret ptr %t11876
}
define ptr @mw512_acc__rs289(ptr %p0, i64 %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11877 = call ptr @mw512(ptr %p0, i64 %p1, i64 0)
%t11878 = call ptr @resid_list_freeze(ptr %t11877)
%t11879 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t11878)
%t11880 = musttail call ptr @mw512_acc(ptr %p0, i64 %p1, i64 1, ptr %t11879)
ret ptr %t11880
}
define ptr @w64_rotr__rs291(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11881 = musttail call ptr @w64_rotr_small(ptr %p0, i64 1)
ret ptr %t11881
}
define ptr @w64_rotr__rs293(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11882 = musttail call ptr @w64_rotr_small(ptr %p0, i64 8)
ret ptr %t11882
}
define ptr @w64_shr__rs295(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11883 = musttail call ptr @w64_shr_small(ptr %p0, i64 7)
ret ptr %t11883
}
define ptr @w64_rotr__rs297(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11884 = musttail call ptr @w64_rotr_small(ptr %p0, i64 19)
ret ptr %t11884
}
define ptr @w64_rotr__rs299(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11885 = call i64 @w64_lo(ptr %p0)
%t11886 = call i64 @w64_hi(ptr %p0)
%t11887 = call ptr @w64(i64 %t11885, i64 %t11886)
%t11888 = musttail call ptr @w64_rotr_small(ptr %t11887, i64 29)
ret ptr %t11888
}
define ptr @w64_shr__rs301(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11889 = musttail call ptr @w64_shr_small(ptr %p0, i64 6)
ret ptr %t11889
}
define ptr @w64_rotr__rs303(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11890 = musttail call ptr @w64_rotr_small(ptr %p0, i64 28)
ret ptr %t11890
}
define ptr @w64_rotr__rs305(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11891 = call i64 @w64_lo(ptr %p0)
%t11892 = call i64 @w64_hi(ptr %p0)
%t11893 = call ptr @w64(i64 %t11891, i64 %t11892)
%t11894 = musttail call ptr @w64_rotr_small(ptr %t11893, i64 2)
ret ptr %t11894
}
define ptr @w64_rotr__rs307(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11895 = call i64 @w64_lo(ptr %p0)
%t11896 = call i64 @w64_hi(ptr %p0)
%t11897 = call ptr @w64(i64 %t11895, i64 %t11896)
%t11898 = musttail call ptr @w64_rotr_small(ptr %t11897, i64 7)
ret ptr %t11898
}
define ptr @w64_rotr__rs309(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11899 = musttail call ptr @w64_rotr_small(ptr %p0, i64 14)
ret ptr %t11899
}
define i64 @fw_hi__rs312(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11900 = call ptr @resid_list_get(ptr %p0, i64 0)
%t11901 = call i64 @resid_unbox_i64(ptr %t11900)
ret i64 %t11901
}
define i64 @fw_lo__rs313(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11903 = call ptr @resid_list_get(ptr %p0, i64 1)
%t11904 = call i64 @resid_unbox_i64(ptr %t11903)
ret i64 %t11904
}
define i64 @fw_hi__rs315(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11906 = call ptr @resid_list_get(ptr %p0, i64 2)
%t11907 = call i64 @resid_unbox_i64(ptr %t11906)
ret i64 %t11907
}
define i64 @fw_lo__rs316(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11909 = call ptr @resid_list_get(ptr %p0, i64 3)
%t11910 = call i64 @resid_unbox_i64(ptr %t11909)
ret i64 %t11910
}
define i64 @fw_hi__rs318(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11912 = call ptr @resid_list_get(ptr %p0, i64 4)
%t11913 = call i64 @resid_unbox_i64(ptr %t11912)
ret i64 %t11913
}
define i64 @fw_lo__rs319(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11915 = call ptr @resid_list_get(ptr %p0, i64 5)
%t11916 = call i64 @resid_unbox_i64(ptr %t11915)
ret i64 %t11916
}
define i64 @fw_hi__rs321(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11918 = call ptr @resid_list_get(ptr %p0, i64 6)
%t11919 = call i64 @resid_unbox_i64(ptr %t11918)
ret i64 %t11919
}
define i64 @fw_lo__rs322(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11921 = call ptr @resid_list_get(ptr %p0, i64 7)
%t11922 = call i64 @resid_unbox_i64(ptr %t11921)
ret i64 %t11922
}
define i64 @fw_hi__rs324(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11924 = call ptr @resid_list_get(ptr %p0, i64 8)
%t11925 = call i64 @resid_unbox_i64(ptr %t11924)
ret i64 %t11925
}
define i64 @fw_lo__rs325(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11927 = call ptr @resid_list_get(ptr %p0, i64 9)
%t11928 = call i64 @resid_unbox_i64(ptr %t11927)
ret i64 %t11928
}
define i64 @fw_hi__rs327(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11930 = call ptr @resid_list_get(ptr %p0, i64 10)
%t11931 = call i64 @resid_unbox_i64(ptr %t11930)
ret i64 %t11931
}
define i64 @fw_lo__rs328(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11933 = call ptr @resid_list_get(ptr %p0, i64 11)
%t11934 = call i64 @resid_unbox_i64(ptr %t11933)
ret i64 %t11934
}
define i64 @fw_hi__rs330(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11936 = call ptr @resid_list_get(ptr %p0, i64 12)
%t11937 = call i64 @resid_unbox_i64(ptr %t11936)
ret i64 %t11937
}
define i64 @fw_lo__rs331(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11939 = call ptr @resid_list_get(ptr %p0, i64 13)
%t11940 = call i64 @resid_unbox_i64(ptr %t11939)
ret i64 %t11940
}
define i64 @fw_hi__rs333(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11942 = call ptr @resid_list_get(ptr %p0, i64 14)
%t11943 = call i64 @resid_unbox_i64(ptr %t11942)
ret i64 %t11943
}
define i64 @fw_lo__rs334(ptr %p0, i64 %p1) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11945 = call ptr @resid_list_get(ptr %p0, i64 15)
%t11946 = call i64 @resid_unbox_i64(ptr %t11945)
ret i64 %t11946
}
define ptr @sha512_rounds_flat__rs337(ptr %p0, ptr %p1, i64 %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11948 = call ptr @sha512_round_flat(ptr %p0, ptr %p1, i64 0)
%t11949 = musttail call ptr @sha512_rounds_flat(ptr %t11948, ptr %p1, i64 1)
ret ptr %t11949
}
define ptr @add_st_acc__rs341(ptr %p0, ptr %p1, i64 %p2, ptr %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11950 = call ptr @add_st_word(ptr %p0, ptr %p1, i64 0)
%t11951 = call ptr @resid_list_freeze(ptr %t11950)
%t11952 = call ptr @resid_list_concat_own(ptr %p3, i8 1, ptr %t11951)
%t11953 = musttail call ptr @add_st_acc(ptr %p0, ptr %p1, i64 1, ptr %t11952)
ret ptr %t11953
}
define i64 @w64_bytes__rs351(ptr %p0, i64 %p1, i64 %p2, i64 %p3) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11954 = add nsw i64 %p1, 0
%t11955 = call ptr @resid_list_get(ptr %p0, i64 %t11954)
%t11956 = call i64 @resid_unbox_i64(ptr %t11955)
%t11958 = and i64 %t11956, 255
%t11959 = or i64 0, %t11958
%t11960 = musttail call i64 @w64_bytes(ptr %p0, i64 %p1, i64 1, i64 %t11959)
ret i64 %t11960
}
define i64 @sched64__rs354(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11961 = call i64 @word64_at(ptr %p0, i64 %p1, i64 0)
ret i64 %t11961
}
define i64 @sched64__rs357(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11962 = call i64 @word64_at(ptr %p0, i64 %p1, i64 1)
ret i64 %t11962
}
define i64 @sched64__rs360(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11963 = call i64 @word64_at(ptr %p0, i64 %p1, i64 2)
ret i64 %t11963
}
define i64 @sched64__rs363(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11964 = call i64 @word64_at(ptr %p0, i64 %p1, i64 3)
ret i64 %t11964
}
define i64 @sched64__rs366(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11965 = call i64 @word64_at(ptr %p0, i64 %p1, i64 4)
ret i64 %t11965
}
define i64 @sched64__rs369(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11966 = call i64 @word64_at(ptr %p0, i64 %p1, i64 5)
ret i64 %t11966
}
define i64 @sched64__rs372(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11967 = call i64 @word64_at(ptr %p0, i64 %p1, i64 6)
ret i64 %t11967
}
define i64 @sched64__rs375(ptr %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11968 = call i64 @word64_at(ptr %p0, i64 %p1, i64 7)
ret i64 %t11968
}
define ptr @be64_push__rs387(i64 %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11969 = lshr i64 %p0, 56
%t11970 = and i64 %t11969, 255
%t11971 = call ptr @resid_box_i64(i64 %t11970)
%t11974 = call ptr @resid_listbuf_push(ptr %p2, ptr %t11971)
%t11975 = musttail call ptr @be64_push(i64 %p0, i64 1, ptr %t11974)
ret ptr %t11975
}
define ptr @cbe_ascii(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11976 = call ptr @resid_sacc_from(ptr %p2)
%t11977 = musttail call ptr @cbe_ascii__sacc(ptr %p0, i64 %p1, ptr %t11976)
ret ptr %t11977
}
define ptr @join(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11978 = call ptr @resid_sacc_from(ptr %p2)
%t11979 = musttail call ptr @join__sacc(ptr %p0, i64 %p1, ptr %t11978)
ret ptr %t11979
}
define ptr @responses(ptr %p0, i64 %p1, ptr %p2) "target-features"="+aes,+sse2,+ssse3,+sse4.1" "probe-stack"="inline-asm" {
entry:
%t11980 = call ptr @resid_sacc_from(ptr %p2)
%t11981 = musttail call ptr @responses__sacc(ptr %p0, i64 %p1, ptr %t11980)
ret ptr %t11981
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
@.lty5841 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc5841 = private global ptr null
@.lcd5841 = private unnamed_addr constant [9 x i64] [i64 67, i64 77, i64 80, i64 45, i64 66, i64 76, i64 65, i64 75, i64 69]
@.lty5843 = private unnamed_addr constant [20 x i8] c"List(List(Int(64)))\00"
@.lty5856 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5903 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5920 = private unnamed_addr constant [20 x i8] c"List(List(Int(64)))\00"
@.s5928 = private unnamed_addr constant [7 x i8] c"[]byte\00"
@.s5930 = private unnamed_addr constant [8 x i8] c"big.Int\00"
@.lty5931 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc5931 = private global ptr null
@.lcd5931 = private unnamed_addr constant [1 x i64] [i64 2]
@.s5937 = private unnamed_addr constant [18 x i8] c"*saferith.Modulus\00"
@.lty5942 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5966 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty5974 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty6054 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6054 = private global ptr null
@.lcd6054 = private unnamed_addr constant [1 x i64] [i64 1]
@.s6078 = private unnamed_addr constant [20 x i8] c"Pedersen Parameters\00"
@.oty6105 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox6105 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty6105}, align 16
@.oty6117 = private unnamed_addr constant [15 x i8] c"Option(ZkDraw)\00"
@.lty6159 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6159 = private global ptr null
@.lcd6159 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty6208 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.oty6209 = private unnamed_addr constant [29 x i8] c"Option(List(List(UInt(64))))\00"
@.lty6232 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.oty6233 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox6233 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty6233}, align 16
@.lty6236 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.lty6250 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.oty6278 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox6278 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty6278}, align 16
@.oty6284 = private unnamed_addr constant [17 x i8] c"Option(PrmProof)\00"
@.lty6306 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.lty6356 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty6402 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6402 = private global ptr null
@.lcd6402 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty6407 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6413 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6419 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6425 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6431 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6437 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6443 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6449 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6455 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6461 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6467 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6473 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty6479 = private unnamed_addr constant [21 x i8] c"List(List(UInt(64)))\00"
@.lty6536 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6536 = private global ptr null
@.lcd6536 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty6545 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6545 = private global ptr null
@.lcd6545 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty6554 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty6565 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.oty6574 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox6574 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty6574}, align 16
@.oty6588 = private unnamed_addr constant [15 x i8] c"Option(ZkDraw)\00"
@.lty6598 = private unnamed_addr constant [18 x i8] c"List(ModResponse)\00"
@.oty6626 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox6626 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty6626}, align 16
@.oty6634 = private unnamed_addr constant [17 x i8] c"Option(ModProof)\00"
@.lty6638 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6638 = private global ptr null
@.lcd6638 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty6641 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6641 = private global ptr null
@.lcd6641 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty6645 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6645 = private global ptr null
@.lcd6645 = private unnamed_addr constant [1 x i64] [i64 4]
@.lty6658 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.oty6671 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox6671 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty6671}, align 16
@.oty6679 = private unnamed_addr constant [15 x i8] c"Option(ZkDraw)\00"
@.lty6689 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6689 = private global ptr null
@.lcd6689 = private unnamed_addr constant [1 x i64] [i64 1]
@.lty6693 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc6693 = private global ptr null
@.lcd6693 = private unnamed_addr constant [1 x i64] [i64 1]
@.oty6703 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox6703 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty6703}, align 16
@.oty6714 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox6714 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty6714}, align 16
@.oty6724 = private unnamed_addr constant [20 x i8] c"Option(PedersenKey)\00"
@.lty7272 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty7571 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty7654 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty7701 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7760 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7817 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty7836 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty8103 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8111 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8145 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty8164 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8175 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8185 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8197 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8207 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty8216 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB8292 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty8385 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB8393 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty8396 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8396 = private global ptr null
@.lcd8396 = private unnamed_addr constant [12 x i64] [i64 132, i64 106, i64 83, i64 105, i64 103, i64 110, i64 97, i64 116, i64 117, i64 114, i64 101, i64 49]
@.lty8399 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty8405 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8405 = private global ptr null
@.lcd8405 = private unnamed_addr constant [4 x i64] [i64 162, i64 1, i64 39, i64 4]
@.ltyB8408 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.s8410 = private unnamed_addr constant [1 x i8] c"\00"
@.s8420 = private unnamed_addr constant [1 x i8] c"\00"
@.s8427 = private unnamed_addr constant [1 x i8] c"\00"
@.s8432 = private unnamed_addr constant [1 x i8] c"\00"
@.s8439 = private unnamed_addr constant [1 x i8] c"\00"
@.s8458 = private unnamed_addr constant [1 x i8] c"\00"
@.s8485 = private unnamed_addr constant [1 x i8] c"\00"
@.s8521 = private unnamed_addr constant [21 x i8] c"cose: missing tag 18\00"
@.s8539 = private unnamed_addr constant [24 x i8] c"cose: expected array(4)\00"
@.s8547 = private unnamed_addr constant [27 x i8] c"cose: bad protected header\00"
@.s8565 = private unnamed_addr constant [37 x i8] c"cose: expected empty unprotected map\00"
@.s8573 = private unnamed_addr constant [18 x i8] c"cose: bad payload\00"
@.s8587 = private unnamed_addr constant [20 x i8] c"cose: bad signature\00"
@.s8590 = private unnamed_addr constant [1 x i8] c"\00"
@.lty8609 = private unnamed_addr constant [14 x i8] c"List(Unknown)\00"
@.lty8611 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8611 = private global ptr null
@.lcd8611 = private unnamed_addr constant [10 x i64] [i64 131, i64 104, i64 69, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48]
@.lty8615 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8615 = private global ptr null
@.lcd8615 = private unnamed_addr constant [4 x i64] [i64 161, i64 1, i64 24, i64 24]
@.lty8617 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8617 = private global ptr null
@.lcd8617 = private unnamed_addr constant [25 x i64] [i64 114, i64 101, i64 115, i64 105, i64 100, i64 47, i64 99, i64 111, i64 115, i64 101, i64 47, i64 101, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48, i64 47, i64 110, i64 111, i64 110, i64 99, i64 101]
@.lty8628 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8628 = private global ptr null
@.lcd8628 = private unnamed_addr constant [16 x i64] [i64 131, i64 104, i64 69, i64 110, i64 99, i64 114, i64 121, i64 112, i64 116, i64 48, i64 68, i64 161, i64 1, i64 24, i64 24, i64 64]
@.lty8632 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc8632 = private global ptr null
@.lcd8632 = private unnamed_addr constant [9 x i64] [i64 208, i64 131, i64 68, i64 161, i64 1, i64 24, i64 24, i64 161, i64 5]
@.ltyB8636 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.s8665 = private unnamed_addr constant [21 x i8] c"cose: missing tag 16\00"
@.s8683 = private unnamed_addr constant [24 x i8] c"cose: expected array(3)\00"
@.s8691 = private unnamed_addr constant [27 x i8] c"cose: bad protected header\00"
@.s8709 = private unnamed_addr constant [34 x i8] c"cose: expected unprotected map(1)\00"
@.s8727 = private unnamed_addr constant [24 x i8] c"cose: expected iv key 5\00"
@.s8741 = private unnamed_addr constant [26 x i8] c"cose: iv must be 12 bytes\00"
@.s8755 = private unnamed_addr constant [21 x i8] c"cose: bad ciphertext\00"
@.s8768 = private unnamed_addr constant [28 x i8] c"cose: authentication failed\00"
@.s8778 = private unnamed_addr constant [1 x i8] c"\00"
@resid.cap.stream = unnamed_addr constant [11 x i8] c"filesystem\00"
@.s8791 = private unnamed_addr constant [2 x i8] c",\00"
@.s8792 = private unnamed_addr constant [1 x i8] c"\00"
@.s8795 = private unnamed_addr constant [2 x i8] c"\22\00"
@.s8802 = private unnamed_addr constant [2 x i8] c"\22\00"
@.s8810 = private unnamed_addr constant [6 x i8] c"{\22A\22:\00"
@.s8813 = private unnamed_addr constant [5 x i8] c"true\00"
@.s8814 = private unnamed_addr constant [6 x i8] c"false\00"
@.s8817 = private unnamed_addr constant [6 x i8] c",\22B\22:\00"
@.s8821 = private unnamed_addr constant [5 x i8] c"true\00"
@.s8822 = private unnamed_addr constant [6 x i8] c"false\00"
@.s8825 = private unnamed_addr constant [7 x i8] c",\22X\22:\22\00"
@.s8831 = private unnamed_addr constant [8 x i8] c"\22,\22Z\22:\22\00"
@.s8837 = private unnamed_addr constant [3 x i8] c"\22}\00"
@.s8841 = private unnamed_addr constant [2 x i8] c",\00"
@.s8842 = private unnamed_addr constant [1 x i8] c"\00"
@resid.cap.main = unnamed_addr constant [5 x i8] c"args\00"
@resid.cap.main.1 = unnamed_addr constant [5 x i8] c"args\00"
@resid.cap.main.2 = unnamed_addr constant [5 x i8] c"args\00"
@resid.cap.main.3 = unnamed_addr constant [5 x i8] c"args\00"
@resid.cap.main.4 = unnamed_addr constant [5 x i8] c"args\00"
@.s8907 = private unnamed_addr constant [37 x i8] c"error: a random stream was too short\00"
@.s8909 = private unnamed_addr constant [14 x i8] c"{\22prm\22:{\22N\22:\22\00"
@.s8916 = private unnamed_addr constant [8 x i8] c"\22,\22S\22:\22\00"
@.s8924 = private unnamed_addr constant [8 x i8] c"\22,\22T\22:\22\00"
@.s8932 = private unnamed_addr constant [9 x i8] c"\22,\22As\22:[\00"
@.s8936 = private unnamed_addr constant [1 x i8] c"\00"
@.s8939 = private unnamed_addr constant [9 x i8] c"],\22Zs\22:[\00"
@.s8943 = private unnamed_addr constant [1 x i8] c"\00"
@.s8946 = private unnamed_addr constant [4 x i8] c"]},\00"
@.s8949 = private unnamed_addr constant [13 x i8] c"\22mod\22:{\22N\22:\22\00"
@.s8956 = private unnamed_addr constant [8 x i8] c"\22,\22W\22:\22\00"
@.s8962 = private unnamed_addr constant [16 x i8] c"\22,\22Responses\22:[\00"
@.s8966 = private unnamed_addr constant [1 x i8] c"\00"
@.s8969 = private unnamed_addr constant [4 x i8] c"]}}\00"
@.ltyB9026 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty9241 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.oty9274 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox9274 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty9274}, align 16
@.oty9295 = private unnamed_addr constant [10 x i8] c"Option(_)\00"
@.nbox9295 = private constant {i32, i32, ptr} {i32 2, i32 0, ptr @.oty9295}, align 16
@.oty9298 = private unnamed_addr constant [18 x i8] c"Option(List(Int))\00"
@.lty9334 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9379 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9458 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9552 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty9586 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9678 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9719 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.ltyB9757 = private unnamed_addr constant [10 x i8] c"List(Int)\00"
@.lty9758 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9764 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lc9764 = private global ptr null
@.lcd9764 = private unnamed_addr constant [1 x i64] [i64 0]
@.lty9806 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9828 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty9926 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10103 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10212 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty10920 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty11321 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty11323 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.s11334 = private unnamed_addr constant [28 x i8] c"bn_divmod: division by zero\00"
@.lty11336 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.ltyE11345 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty11348 = private unnamed_addr constant [15 x i8] c"List(UInt(64))\00"
@.lty11366 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11376 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11386 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11396 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11406 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11416 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11426 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11436 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.s11746 = private unnamed_addr constant [1 x i8] c"\00"
@.lty11754 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11763 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11774 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11799 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11809 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11819 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11829 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11839 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11849 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11859 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
@.lty11869 = private unnamed_addr constant [14 x i8] c"List(Int(64))\00"
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
