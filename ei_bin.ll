declare i32 @printf(ptr, ...)
declare i32 @puts(ptr)
@.fmt.p = private unnamed_addr constant [3 x i8] c"%s\00"
declare ptr @malloc(i64)
declare ptr @resid_str_concat(ptr, ptr)
declare i8 @resid_str_eq(ptr, ptr)
declare ptr @resid_fs_read_all(ptr)
declare i8 @resid_fs_write_all(ptr, ptr)
declare i64 @resid_args_count()
declare ptr @resid_args_get(i64)
declare i64 @resid_process_run(ptr)
declare ptr @resid_env_get(ptr)
declare i64 @str_char_at(ptr, i64)
declare ptr @str_from_code(i64)
declare i64 @str_len(ptr)
declare ptr @str_slice(ptr, i64, i64)
declare i64 @resid_crypto_random_byte()
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
declare i64 @abs_i64(i64)
declare i64 @min_i64(i64, i64)
declare i64 @max_i64(i64, i64)
declare i64 @clamp_i64(i64, i64, i64)
declare ptr @bl_sort_i64(ptr)
declare ptr @bl_sort_str(ptr)
declare ptr @bl_sort_f64(ptr)
declare ptr @bl_reverse_i64(ptr)
declare ptr @bl_reverse_str(ptr)
declare ptr @bl_reverse_f64(ptr)
declare i8 @bl_contains_i64(ptr, i64)
declare i8 @bl_contains_str(ptr, ptr)
declare i8 @bl_contains_f64(ptr, double)
declare i64 @bl_sum(ptr)
declare double @bl_sumf(ptr)
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
define ptr @e.itoa(ptr %buf, i64 %v) {
entry:
  %zn = icmp eq i64 %v, 0
  br i1 %zn, label %zero, label %prep
zero:
  %zp = getelementptr i8, ptr %buf, i64 22
  store i8 48, ptr %zp
  ret ptr %zp
prep:
  %neg = icmp slt i64 %v, 0
  %an = sub i64 0, %v
  %mag = select i1 %neg, i64 %an, i64 %v
  br label %loop
loop:
  %cur = phi i64 [ %mag, %prep ], [ %q, %body ]
  %idx = phi i64 [ 22, %prep ], [ %im, %body ]
  %d = srem i64 %cur, 10
  %q = sdiv i64 %cur, 10
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
  ret ptr %pp
wneg:
  %mi = sub i64 %idx, 1
  %mp = getelementptr i8, ptr %buf, i64 %mi
  store i8 45, ptr %mp
  ret ptr %mp
}
define ptr @e.lconcat(ptr %a, ptr %b) {
entry:
  %ca = load i64, ptr %a
  %cb = load i64, ptr %b
  %n = add i64 %ca, %cb
  %nb8 = mul i64 %n, 8
  %bytes = add i64 %nb8, 8
  %nb = call ptr @malloc(i64 %bytes)
  store i64 %n, ptr %nb
  br label %la
la:
  %i1 = phi i64 [ 0, %entry ], [ %i1n, %dopa ]
  %c1 = icmp slt i64 %i1, %ca
  br i1 %c1, label %dopa, label %lb
dopa:
  %o1m = mul i64 %i1, 8
  %o1 = add i64 %o1m, 8
  %pa = getelementptr i8, ptr %a, i64 %o1
  %va = load i64, ptr %pa
  %pbd = getelementptr i8, ptr %nb, i64 %o1
  store i64 %va, ptr %pbd
  %i1n = add i64 %i1, 1
  br label %la
lb:
  %i2 = phi i64 [ 0, %la ], [ %i2n, %dopb ]
  %c2 = icmp slt i64 %i2, %cb
  br i1 %c2, label %dopb, label %done
dopb:
  %o2m = mul i64 %i2, 8
  %o2a = add i64 %o2m, 8
  %cai8 = mul i64 %ca, 8
  %od = add i64 %o2a, %cai8
  %pbs = getelementptr i8, ptr %b, i64 %o2a
  %vb = load i64, ptr %pbs
  %pdd = getelementptr i8, ptr %nb, i64 %od
  store i64 %vb, ptr %pdd
  %i2n = add i64 %i2, 1
  br label %lb
done:
  ret ptr %nb
}
