import "crypto.res";

// Field elements are Int(256) scalars reduced mod p = 2^255 - 19.
pub Int(256) fe_p() {
    return 57896044618658097711785492504343953926634992332820282019728792003956564819949;
}
pub Int(256) fe_d() {
    return 37095705934669439343138083508754565189542113879843219016388785533085940283555;
}
pub Int(256) fe_sqrtm1() {
    return 19681161376707505956807079304988542015446066515923890162744021073123829784752;
}
// L = group order = (p+3)/8
pub Int(256) fe_l() {
    return 7237005577332262213973186563042994240857116359379907606001950938285454250989;
}
pub Int(256) fe_p58() {
    return 7237005577332262213973186563042994240829374041602535252466099000494570602494;
}
pub Int(256) fe_pm2() {
    return 57896044618658097711785492504343953926634992332820282019728792003956564819947;
}

pub Int(256) cond_sub(Int(256) v) {
    if (v >= fe_p()) {
        Int(256) r = v - fe_p();
        return r;
    }
    return v;
}
pub Int(256) cond_sub2(Int(256) v) {
    Int(256) a = cond_sub(v);
    return cond_sub(a);
}
pub Int(256) cond_sub_l(Int(256) v) {
    if (v >= fe_l()) {
        Int(256) r = v - fe_l();
        return r;
    }
    return v;
}
pub Int(512) cs512(Int(512) v) {
    Int(512) pp = (Int(512)) fe_p();
    if (v >= pp) {
        Int(512) r = v - pp;
        return r;
    }
    return v;
}
pub Int(256) fe_add(Int(256) a, Int(256) b) {
    Int(256) lim = fe_p() - b;
    if (a >= lim) {
        Int(256) r = a - lim;
        return r;
    }
    Int(256) s = a + b;
    return s;
}
pub Int(256) fe_sub(Int(256) a, Int(256) b) {
    if (a >= b) {
        Int(256) r = a - b;
        return r;
    }
    Int(256) pb = fe_p() - b;
    Int(256) s = a + pb;
    return s;
}
pub Int(512) mask512() {
    Int(512) o = 1;
    Int(512) hs = 256;
    return (o << hs) - o;
}
pub Int(256) fe_mul(Int(256) a, Int(256) b) {
    Int(512) aa = (Int(512)) a;
    Int(512) bb = (Int(512)) b;
    Int(512) t = aa * bb;
    Int(512) m = mask512();
    Int(512) lo = t & m;
    Int(512) hs = 256;
    Int(512) hi = t >> hs;
    Int(512) k38 = 38;
    Int(512) r = lo + hi * k38;
    Int(512) lo2 = r & m;
    Int(512) hi2 = r >> hs;
    Int(512) r2 = lo2 + hi2 * k38;
    Int(512) c = r2 >> hs;
    Int(512) r3 = (r2 & m) + c * k38;
    Int(512) q1 = cs512(r3);
    Int(512) q2 = cs512(q1);
    Int(256) v = (Int(256)) q2;
    return cond_sub2(v);
}
pub Int(256) fe_sq(Int(256) a) {
    return fe_mul(a, a);
}
pub Int(256) pow_acc(Int(256) res, Int(256) base, Int(256) e, Int i) {
    if (i < 0) { return res; }
    Int(256) rs = fe_sq(res);
    Int ni = i - 1;
    Int(256) sh = i;
    Int(256) mw = ((e >> sh) & 1);
    Int bit = mw;
    if (bit == 1) {
        Int(256) nr = fe_mul(rs, base);
        return pow_acc(nr, base, e, ni);
    }
    return pow_acc(rs, base, e, ni);
}
pub Int(256) fe_inv(Int(256) a) {
    return pow_acc(1, a, fe_pm2(), 255);
}

// ── seeded little-endian bytes <-> wide ints ──
pub Int top7(Int i, Int raw) {
    if (i == 32) {
        Int masked = raw & 127;
        return masked;
    }
    return raw;
}
pub Int(256) b2a(List(Int) b, Int(256) v, Int i) {
    if (i < 1) { return v; }
    Int(256) raw = (Int(256)) top7(i, b[i]);
    Int(256) t = v * 256;
    Int(256) v2 = t + raw;
    Int ni = i - 1;
    return b2a(b, v2, ni);
}
pub Int(256) bytes_to_int(List(Int) b) {
    return b2a(b, 0, 32);
}
pub List(Int) itob_acc(Int(256) v, Int i, List(Int) acc) {
    if (i > 31) { return acc; }
    Int(256) sh = i * 8;
    Int(256) mw = ((v >> sh) & 255);
    Int b = mw;
    List(Int) acc2 = acc.concat([b]);
    Int ni = i + 1;
    return itob_acc(v, ni, acc2);
}
pub List(Int) int_to_bytes(Int(256) v) {
    return itob_acc(v, 0, [0]);
}
pub List(Int) slice_acc(List(Int) b, Int i, Int end, List(Int) acc) {
    if (i > end) { return acc; }
    Int j = i + 1;
    List(Int) acc2 = acc.concat([b[j]]);
    Int ni = i + 1;
    return slice_acc(b, ni, end, acc2);
}
pub List(Int) slice_bytes(List(Int) b, Int start, Int end) {
    return slice_acc(b, start, end, [0]);
}

// ── point coordinate formulas (extended coords, a = -1) ──
pub Int(256) dbl_x(Int(256) x, Int(256) y, Int(256) z) {
    Int(256) a = fe_sq(x);
    Int(256) b = fe_sq(y);
    Int(256) zsq = fe_sq(z);
    Int(256) c = fe_add(zsq, zsq);
    Int(256) xy = fe_add(x, y);
    Int(256) xys = fe_sq(xy);
    Int(256) e = fe_sub(fe_sub(xys, a), b);
    Int(256) g = fe_sub(b, a);
    Int(256) f = fe_sub(g, c);
    return fe_mul(e, f);
}
pub Int(256) dbl_y(Int(256) x, Int(256) y, Int(256) z) {
    Int(256) a = fe_sq(x);
    Int(256) b = fe_sq(y);
    Int(256) zsq = fe_sq(z);
    Int(256) c = fe_add(zsq, zsq);
    Int(256) xy = fe_add(x, y);
    Int(256) xys = fe_sq(xy);
    Int(256) e = fe_sub(fe_sub(xys, a), b);
    Int(256) dd = fe_sub(0, a);
    Int(256) g = fe_add(dd, b);
    Int(256) f = fe_sub(g, c);
    Int(256) h = fe_sub(dd, b);
    return fe_mul(g, h);
}
pub Int(256) dbl_z(Int(256) x, Int(256) y, Int(256) z) {
    Int(256) a = fe_sq(x);
    Int(256) b = fe_sq(y);
    Int(256) zsq = fe_sq(z);
    Int(256) c = fe_add(zsq, zsq);
    Int(256) g = fe_sub(b, a);
    Int(256) f = fe_sub(g, c);
    return fe_mul(f, g);
}
pub Int(256) add_t1(Int(256) x1, Int(256) y1, Int(256) z1) {
    Int(256) zi = fe_inv(z1);
    return fe_mul(x1, fe_mul(y1, zi));
}
pub Int(256) add_x(Int(256) x1, Int(256) y1, Int(256) z1, Int(256) x2, Int(256) y2, Int(256) z2) {
    Int(256) t1 = add_t1(x1, y1, z1);
    Int(256) t2 = add_t1(x2, y2, z2);
    Int(256) a0 = fe_sub(y1, x1);
    Int(256) b0 = fe_add(y1, x1);
    Int(256) a2 = fe_sub(y2, x2);
    Int(256) b2 = fe_add(y2, x2);
    Int(256) a = fe_mul(a0, a2);
    Int(256) b = fe_mul(b0, b2);
    Int(256) t12 = fe_add(t1, t1);
    Int(256) c0 = fe_mul(t12, fe_d());
    Int(256) c = fe_mul(c0, t2);
    Int(256) z12 = fe_add(z1, z1);
    Int(256) dd = fe_mul(z12, z2);
    Int(256) e = fe_sub(b, a);
    Int(256) f = fe_sub(dd, c);
    return fe_mul(e, f);
}
pub Int(256) add_y(Int(256) x1, Int(256) y1, Int(256) z1, Int(256) x2, Int(256) y2, Int(256) z2) {
    Int(256) t1 = add_t1(x1, y1, z1);
    Int(256) t2 = add_t1(x2, y2, z2);
    Int(256) a0 = fe_sub(y1, x1);
    Int(256) b0 = fe_add(y1, x1);
    Int(256) a2 = fe_sub(y2, x2);
    Int(256) b2 = fe_add(y2, x2);
    Int(256) a = fe_mul(a0, a2);
    Int(256) b = fe_mul(b0, b2);
    Int(256) t12 = fe_add(t1, t1);
    Int(256) c0 = fe_mul(t12, fe_d());
    Int(256) c = fe_mul(c0, t2);
    Int(256) z12 = fe_add(z1, z1);
    Int(256) dd = fe_mul(z12, z2);
    Int(256) g = fe_add(dd, c);
    Int(256) h = fe_add(b, a);
    return fe_mul(g, h);
}
pub Int(256) add_z(Int(256) x1, Int(256) y1, Int(256) z1, Int(256) x2, Int(256) y2, Int(256) z2) {
    Int(256) t1 = add_t1(x1, y1, z1);
    Int(256) t2 = add_t1(x2, y2, z2);
    Int(256) a0 = fe_sub(y1, x1);
    Int(256) b0 = fe_add(y1, x1);
    Int(256) a2 = fe_sub(y2, x2);
    Int(256) b2 = fe_add(y2, x2);
    Int(256) a = fe_mul(a0, a2);
    Int(256) b = fe_mul(b0, b2);
    Int(256) t12 = fe_add(t1, t1);
    Int(256) c0 = fe_mul(t12, fe_d());
    Int(256) c = fe_mul(c0, t2);
    Int(256) z12 = fe_add(z1, z1);
    Int(256) dd = fe_mul(z12, z2);
    Int(256) f = fe_sub(dd, c);
    Int(256) g = fe_add(dd, c);
    return fe_mul(f, g);
}
// ── scalar mult returning affine X or Y (recomputes internally) ──
pub List(Int) smul_x_acc(Int(256) k, Int(256) qx, Int(256) qy, Int(256) qz, Int(256) rx, Int(256) ry, Int(256) rz, Int i) {
    if (i < 0) {
        Int(256) zi = fe_inv(rz);
        return int_to_bytes(fe_mul(rx, zi));
    }
    Int ni = i - 1;
    Int(256) sh = i;
    Int(256) mw = ((k >> sh) & 1);
    Int bit = mw;
    Int(256) dxv = dbl_x(rx, ry, rz);
    Int(256) dyv = dbl_y(rx, ry, rz);
    Int(256) dzv = dbl_z(rx, ry, rz);
    if (bit == 1) {
        Int(256) nx = add_x(dxv, dyv, dzv, qx, qy, qz);
        Int(256) ny = add_y(dxv, dyv, dzv, qx, qy, qz);
        Int(256) nz = add_z(dxv, dyv, dzv, qx, qy, qz);
        return smul_x_acc(k, qx, qy, qz, nx, ny, nz, ni);
    }
    return smul_x_acc(k, qx, qy, qz, dxv, dyv, dzv, ni);
}
pub List(Int) smul_y_acc(Int(256) k, Int(256) qx, Int(256) qy, Int(256) qz, Int(256) rx, Int(256) ry, Int(256) rz, Int i) {
    if (i < 0) {
        Int(256) zi = fe_inv(rz);
        return int_to_bytes(fe_mul(ry, zi));
    }
    Int ni = i - 1;
    Int(256) sh = i;
    Int(256) mw = ((k >> sh) & 1);
    Int bit = mw;
    Int(256) dxv = dbl_x(rx, ry, rz);
    Int(256) dyv = dbl_y(rx, ry, rz);
    Int(256) dzv = dbl_z(rx, ry, rz);
    if (bit == 1) {
        Int(256) nx = add_x(dxv, dyv, dzv, qx, qy, qz);
        Int(256) ny = add_y(dxv, dyv, dzv, qx, qy, qz);
        Int(256) nz = add_z(dxv, dyv, dzv, qx, qy, qz);
        return smul_y_acc(k, qx, qy, qz, nx, ny, nz, ni);
    }
    return smul_y_acc(k, qx, qy, qz, dxv, dyv, dzv, ni);
}
// base point
pub Int(256) fe_bx() {
    return 15112221349535400772501151409588531511454012693041857206046113283949847762202;
}
pub Int(256) fe_by() {
    return 46316835694926478169428394003475163141307993866256225615783033603165251855960;
}
pub Int(256) fe_bt() {
    return fe_mul(fe_bx(), fe_by());
}

// ── decode public keys / R ──
pub Int(256) dec_adjust(Int(256) x, Int(256) chk) {
    if (chk != 1) {
        return fe_mul(x, fe_sqrtm1());
    }
    return x;
}
pub Int(256) dec_parity(Int(256) x, Int sign) {
    Int par = x & 1;
    if (par != sign) {
        return fe_sub(0, x);
    }
    return x;
}
pub Int(256) dec_y(List(Int) bs) {
    return bytes_to_int(bs);
}
pub List(Int) ccat(List(Int) b, Int i, List(Int) acc) {
    if (i >= b.len()) { return acc; }
    List(Int) acc2 = acc.concat([b[i]]);
    Int ni = i + 1;
    return ccat(b, ni, acc2);
}
pub List(Int) concat_bytes(List(Int) a, List(Int) b) {
    return ccat(b, 1, a);
}
pub Int(256) dec_x(List(Int) bs) {
    Int(256) y = dec_y(bs);
    Int ln = bs.len();
    Int li = ln - 1;
    Int last = bs[li];
    Int sign = (last >> 7) & 1;
    Int(256) y2 = fe_sq(y);
    Int(256) u = fe_sub(y2, 1);
    Int(256) dy = fe_mul(fe_d(), y2);
    Int(256) v = fe_add(dy, 1);
    Int(256) winv = fe_mul(u, fe_inv(v));
    Int(256) x0 = pow_acc(1, winv, fe_p58(), 254);
    Int(256) chk = fe_mul(fe_sq(x0), winv);
    Int(256) x1 = dec_adjust(x0, chk);
    return dec_parity(x1, sign);
}

// ── W = [h]A + R, returned as affine ratios E/G (=X/Z), H/F (=Y/Z) ──
pub List(Int) wmul_wx(Int(256) h, Int(256) ax, Int(256) ay, Int(256) az, Int(256) bx2, Int(256) by2, Int(256) bz2, Int(256) rx, Int(256) ry, Int(256) rz, Int i) {
    if (i < 0) {
        Int(256) nx = add_x(rx, ry, rz, bx2, by2, bz2);
        Int(256) nz2 = add_z(rx, ry, rz, bx2, by2, bz2);
        Int(256) nzi = fe_inv(nz2);
        return int_to_bytes(fe_mul(nx, nzi));
    }
    Int ni = i - 1;
    Int(256) sh = i;
    Int(256) mw = ((h >> sh) & 1);
    Int bit = mw;
    Int(256) dxv = dbl_x(rx, ry, rz);
    Int(256) dyv = dbl_y(rx, ry, rz);
    Int(256) dzv = dbl_z(rx, ry, rz);
    if (bit == 1) {
        Int(256) nx = add_x(dxv, dyv, dzv, ax, ay, az);
        Int(256) ny = add_y(dxv, dyv, dzv, ax, ay, az);
        Int(256) nz = add_z(dxv, dyv, dzv, ax, ay, az);
        return wmul_wx(h, ax, ay, az, bx2, by2, bz2, nx, ny, nz, ni);
    }
    return wmul_wx(h, ax, ay, az, bx2, by2, bz2, dxv, dyv, dzv, ni);
}
pub List(Int) wmul_wy(Int(256) h, Int(256) ax, Int(256) ay, Int(256) az, Int(256) bx2, Int(256) by2, Int(256) bz2, Int(256) rx, Int(256) ry, Int(256) rz, Int i) {
    if (i < 0) {
        Int(256) t1 = add_t1(rx, ry, rz);
        Int(256) t2 = add_t1(bx2, by2, bz2);
        Int(256) a0 = fe_sub(ry, rx);
        Int(256) b0 = fe_add(ry, rx);
        Int(256) a2 = fe_sub(by2, bx2);
        Int(256) bb2 = fe_add(by2, bx2);
        Int(256) a = fe_mul(a0, a2);
        Int(256) b = fe_mul(b0, bb2);
        Int(256) t12 = fe_add(t1, t1);
        Int(256) c0 = fe_mul(t12, fe_d());
        Int(256) c = fe_mul(c0, t2);
        Int(256) z12 = fe_add(rz, rz);
        Int(256) dd = fe_mul(z12, bz2);
        Int(256) f = fe_sub(dd, c);
        Int(256) hh = fe_add(b, a);
        Int(256) fi = fe_inv(f);
        return int_to_bytes(fe_mul(hh, fi));
    }
    Int ni = i - 1;
    Int(256) sh = i;
    Int(256) mw = ((h >> sh) & 1);
    Int bit = mw;
    Int(256) dxv = dbl_x(rx, ry, rz);
    Int(256) dyv = dbl_y(rx, ry, rz);
    Int(256) dzv = dbl_z(rx, ry, rz);
    if (bit == 1) {
        Int(256) nx = add_x(dxv, dyv, dzv, ax, ay, az);
        Int(256) ny = add_y(dxv, dyv, dzv, ax, ay, az);
        Int(256) nz = add_z(dxv, dyv, dzv, ax, ay, az);
        return wmul_wy(h, ax, ay, az, bx2, by2, bz2, nx, ny, nz, ni);
    }
    return wmul_wy(h, ax, ay, az, bx2, by2, bz2, dxv, dyv, dzv, ni);
}
// ── h = SHA-512(R||A||M) mod L ──
pub Int(256) modl_acc(List(Int) dig, Int(256) v, Int j) {
    if (j < 0) { return v; }
    Int nb = j >> 3;
    Int sh8 = nb * 8;
    Int rem = j - sh8;
    Int idx = nb + 1;
    Int byte = dig[idx];
    Int bit = ((byte >> rem) & 1);
    Int(256) v2 = v * 2;
    Int(256) v3 = v2 + bit;
    Int(256) v4 = cond_sub_l(v3);
    Int ni = j - 1;
    return modl_acc(dig, v4, ni);
}
pub Int(256) mod_l(List(Int) dig) {
    return modl_acc(dig, 0, 511);
}

// ── Ed25519 verification ──
pub Bool verify_sig(Str msg, List(Int) sig, List(Int) pubk) {
    List(Int) rb = slice_bytes(sig, 0, 31);
    List(Int) sbB = slice_bytes(sig, 32, 63);
    Int(256) sv = bytes_to_int(sbB);
    if (sv >= fe_l()) {
        return false;
    }
    Int(256) ax = dec_x(pubk);
    Int(256) ay = dec_y(pubk);
    Int(256) az = 1;
    Int(256) at = fe_mul(ax, ay);
    Int(256) rx = dec_x(rb);
    Int(256) ry = dec_y(rb);
    Int(256) rz = 1;
    Int(256) rw = fe_mul(rx, ry);
    List(Int) mb = bytes_of(msg);
    List(Int) rp = concat_bytes(rb, pubk);
    List(Int) rap = concat_bytes(rp, mb);
    List(Int) dig = sha512_bytes(rap);
    Int(256) hv = mod_l(dig);
    Int(256) bxv = fe_bx();
    Int(256) byv = fe_by();
    Int(256) bz = 1;
    Int(256) btv = fe_bt();
    Int(256) iz = 1;
    Int(256) ix = 0;
    Int(256) oy = 1;
    Int(256) sx = bytes_to_int(smul_x_acc(sv, bxv, byv, bz, ix, oy, iz, 255));
    Int(256) sy = bytes_to_int(smul_y_acc(sv, bxv, byv, bz, ix, oy, iz, 255));
    Int(256) wx = bytes_to_int(wmul_wx(hv, ax, ay, az, rx, ry, rz, ix, oy, iz, 255));
    Int(256) wy = bytes_to_int(wmul_wy(hv, ax, ay, az, rx, ry, rz, ix, oy, iz, 255));
    if (sx != wx) {
        return false;
    }
    if (sy != wy) {
        return false;
    }
    return true;
}
