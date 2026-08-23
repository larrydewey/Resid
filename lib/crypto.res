// crypto.res — SHA-256 written in pure Resid (self-hosted cryptography).
//
// Implements FIPS 180-4. Input is treated as a byte sequence of codepoints —
// exact for ASCII inputs; binary/UTF-8 byte semantics arrive with Bytes-type
// integration (later milestone).
//
// No mutation: every loop is tail recursion; every update rebuilds the list.
// 32-bit semantics come from masking with 0xFFFFFFFF after each add. Lists
// carry a dummy seed at index 0 so no empty-list literal is ever built.

// ─── Bit helpers ────────────────────────────────────────────────

pub Int mask32(Int x) {
    return x & 4294967295;
}

pub Int rotr(Int x, Int n) {
    Int r = (x >> n) | (x << (32 - n));
    return r & 4294967295;
}

pub Int not32(Int x) {
    return (x ^ 4294967295) & 4294967295;
}

// ─── Round constants (FIPS 180-4 §4.2.2) ────────────────────────

pub Int k_at(Int i) {
        List(Int) ks = [
        1116352408, 1899447441, -1245643825, -373957723,
        961987163, 1508970993, -1841331548, -1424204075,
        -670586216, 310598401, 607225278, 1426881987,
        1925078388, -2132889090, -1680079193, -1046744716,
        -459576895, -272742522, 264347078, 604807628,
        770255983, 1249150122, 1555081692, 1996064986,
        -1740746414, -1473132947, -1341970488, -1084653625,
        -958395405, -710438585, 113926993, 338241895,
        666307205, 773529912, 1294757372, 1396182291,
        1695183700, 1986661051, -2117940946, -1838011259,
        -1564481375, -1474664885, -1035236496, -949202525,
        -778901479, -694614492, -200395387, 275423344,
        430227734, 506948616, 659060556, 883997877,
        958139571, 1322822218, 1537002063, 1747873779,
        1955562222, 2024104815, -2067236844, -1933114872,
        -1866530822, -1538233109, -1090935817, -965641998
    ];
    return ks[i];
}

// ─── Message bytes and padding ──────────────────────────────────

pub List(Int) msg_bytes(Str msg, Int i, List(Int) acc) {
    if (i >= str_len(msg)) {
        return acc;
    }
    Int cp = str_char_at(msg, i);
    List(Int) acc2 = acc.concat([cp]);
    Int ni = i + 1;
    return msg_bytes(msg, ni, acc2);
}

// Seeded with one dummy element (index 0); real bytes start at index 1.
pub List(Int) bytes_of(Str msg) {
    List(Int) seeded = [0];
    return msg_bytes(msg, 0, seeded);
}

pub List(Int) zeros_l(List(Int) acc, Int count) {
    if (count <= 0) { return acc; }
    List(Int) acc2 = acc.concat([0]);
    Int c2 = count - 1;
    return zeros_l(acc2, c2);
}

pub List(Int) length_bytes(Int bits, Int shift, List(Int) acc) {
    if (shift < 0) {
        return acc;
    }
    Int sh = shift * 8;
    Int byte = (bits >> sh) & 255;
    List(Int) acc2 = acc.concat([byte]);
    Int ns = shift - 1;
    return length_bytes(bits, ns, acc2);
}

pub List(Int) pad_bytes(List(Int) msg) {
    // msg is seeded: real byte count is len-1.
    Int l = msg.len() - 1;
    List(Int) p = msg.concat([128]);
    Int l9 = l + 9;
    Int blocks = (l9 + 63) / 64;
    Int total = blocks * 64;
    Int zcount = total - l9;
    List(Int) p2 = zeros_l(p, zcount);
    Int bits = l * 8;
    return length_bytes(bits, 7, p2);
}

// ─── Block words ────────────────────────────────────────────────

pub List(Int) bw_acc(List(Int) m, Int base, Int j, List(Int) acc) {
    if (j >= 16) { return acc; }
    Int off = base + (j * 4);
    Int b0i = off + 1;
    Int o1 = off + 2;
    Int o2 = off + 3;
    Int o3 = off + 4;
    Int b0 = m[b0i];
    Int b1 = m[o1];
    Int b2 = m[o2];
    Int b3 = m[o3];
    Int sh0 = b0 << 24;
    Int sh1 = b1 << 16;
    Int sh2 = b2 << 8;
    Int or01 = sh0 | sh1;
    Int or012 = or01 | sh2;
    Int wv = (or012 | b3) & 4294967295;
    List(Int) acc2 = acc.concat([wv]);
    Int nj = j + 1;
    return bw_acc(m, base, nj, acc2);
}

pub List(Int) block_words(List(Int) m, Int base) {
    List(Int) seeded = [0];
    return bw_acc(m, base, 0, seeded);
}

pub List(Int) ext_w(List(Int) w, Int i) {
    if (i >= 64) { return w; }
    Int a15 = (i - 15) + 1;
    Int a2v = (i - 2) + 1;
    Int a7 = (i - 7) + 1;
    Int a16 = (i - 16) + 1;
    Int wm15 = w[a15];
    Int r7 = rotr(wm15, 7);
    Int r17 = rotr(wm15, 18);
    Int sr3 = wm15 >> 3;
    Int x1 = r7 ^ r17;
    Int s0 = x1 ^ sr3;
    Int wm2 = w[a2v];
    Int ra = rotr(wm2, 17);
    Int rb = rotr(wm2, 19);
    Int sr10 = wm2 >> 10;
    Int x2 = ra ^ rb;
    Int s1v = x2 ^ sr10;
    Int t1 = w[a16] + s0;
    Int t2 = w[a7] + s1v;
    Int raw = t1 + t2;
    Int nv = raw & 4294967295;
    List(Int) w2 = w.concat([nv]);
    Int ni = i + 1;
    return ext_w(w2, ni);
}

// ─── Working-state updates ──────────────────────────────────────

pub Int pick(List(Int) xs, Int idx, Int val, Int i) {
    if (i == idx) { return val; }
    return xs[i];
}

pub List(Int) ls_build(List(Int) xs, Int idx, Int val, Int i) {
    if (i > 0) {
        Int pi = i - 1;
        List(Int) prev = ls_build(xs, idx, val, pi);
        Int v = pick(xs, idx, val, i);
        List(Int) head = [v];
        return prev.concat(head);
    }
    Int v0 = pick(xs, idx, val, 0);
    return [v0];
}

pub List(Int) ls_set(List(Int) xs, Int idx, Int val) {
    Int last = xs.len() - 1;
    return ls_build(xs, idx, val, last);
}

pub Int ch_of(Int e, Int f, Int g) {
    Int ne = not32(e);
    Int ef = e & f;
    Int ng = ne & g;
    return ef ^ ng;
}

pub List(Int) sha_round(List(Int) hv, List(Int) w, Int i) {
    Int a = hv[0];
    Int b = hv[1];
    Int c = hv[2];
    Int d = hv[3];
    Int e = hv[4];
    Int f = hv[5];
    Int g = hv[6];
    Int hh = hv[7];
    Int wi = w[i + 1];
    Int kk = k_at(i);
    Int re6 = rotr(e, 6);
    Int re11 = rotr(e, 11);
    Int re25 = rotr(e, 25);
    Int x1 = re6 ^ re11;
    Int s1v = x1 ^ re25;
    Int chv = ch_of(e, f, g);
    Int hps1 = hh + s1v;
    Int t1a = hps1 + chv;
    Int t1b = t1a + kk;
    Int t1c = t1b + wi;
    Int t1 = t1c & 4294967295;
    Int ra2 = rotr(a, 2);
    Int ra13 = rotr(a, 13);
    Int ra22 = rotr(a, 22);
    Int x3 = ra2 ^ ra13;
    Int s0v = x3 ^ ra22;
    Int ab = a & b;
    Int ac = a & c;
    Int bc = b & c;
    Int mjraw = ab ^ ac;
    Int mj = mjraw ^ bc;
    Int t2raw = s0v + mj;
    Int t2 = t2raw & 4294967295;
    Int na_raw = t1 + t2;
    Int na = na_raw & 4294967295;
    Int nd_raw = d + t1;
    Int nd = nd_raw & 4294967295;
    List(Int) s1l = ls_set(hv, 0, na);
    List(Int) s2l = ls_set(s1l, 1, a);
    List(Int) s3l = ls_set(s2l, 2, b);
    List(Int) s4l = ls_set(s3l, 3, c);
    List(Int) s5l = ls_set(s4l, 4, nd);
    List(Int) s6l = ls_set(s5l, 5, e);
    List(Int) s7l = ls_set(s6l, 6, f);
    List(Int) s8l = ls_set(s7l, 7, g);
    return s8l;
}

pub List(Int) sha_rounds(List(Int) hv, List(Int) w, Int i) {
    if (i >= 64) { return hv; }
    List(Int) hv2 = sha_round(hv, w, i);
    Int ni = i + 1;
    return sha_rounds(hv2, w, ni);
}

// ─── Compression over all blocks ────────────────────────────────

pub List(Int) add_h(List(Int) h, List(Int) hv, Int i) {
    if (i >= 8) { return h; }
    Int raw = h[i] + hv[i];
    Int sum = raw & 4294967295;
    List(Int) h2 = ls_set(h, i, sum);
    Int ni = i + 1;
    return add_h(h2, hv, ni);
}

pub List(Int) digest_block(List(Int) m, Int base, List(Int) h) {
    List(Int) first16 = block_words(m, base);
    List(Int) w = ext_w(first16, 16);
    List(Int) hv = sha_rounds(h, w, 0);
    return add_h(h, hv, 0);
}

pub List(Int) digest_blocks(List(Int) m, Int pos, Int total, List(Int) h) {
    if (pos >= total) { return h; }
    List(Int) h2 = digest_block(m, pos, h);
    Int npos = pos + 64;
    return digest_blocks(m, npos, total, h2);
}

// ─── Hex output ─────────────────────────────────────────────────

pub Str hex_digit(Int d) {
    if (d < 10) {
        Int c = d + 48;
        return str_from_code(c);
    }
    Int c87 = d + 87;
    return str_from_code(c87);
}

pub Str hex_byte(Int b) {
    Int hi = b >> 4;
    Str hs = hex_digit(hi);
    Int lo = b & 15;
    Str ls = hex_digit(lo);
    return hs + ls;
}

pub Str hex_word(Int wv) {
    Int b3 = wv >> 24;
    Str p3 = hex_byte(b3);
    Int q2 = wv & 16711680;
    Int b2 = q2 >> 16;
    Str p2s = hex_byte(b2);
    Str p2 = p3 + p2s;
    Int q1 = wv & 65280;
    Int b1 = q1 >> 8;
    Str p1s = hex_byte(b1);
    Str p1 = p2 + p1s;
    Int b0 = wv & 255;
    Str p0s = hex_byte(b0);
    return p1 + p0s;
}

pub Str hex_state(List(Int) h, Int i, Str acc) {
    if (i >= 8) { return acc; }
    Str part = acc + hex_word(h[i]);
    Int ni = i + 1;
    return hex_state(h, ni, part);
}

// ─── Public entry point ─────────────────────────────────────────

pub Str sha256(Str msg) {
    List(Int) h0 = [
        1779033703, -1150833019, 1013904242, -1521486534,
        1359893119, -1694144372, 528734635, 1541459225
    ];
    List(Int) bytes = bytes_of(msg);
    List(Int) padded = pad_bytes(bytes);
    Int total = padded.len() - 1;
    List(Int) hd = digest_blocks(padded, 0, total, h0);
    return hex_state(hd, 0, "");
}

// ─── Byte-level digest core (v2) ────────────────────────────────
// All lists use the seeded convention: index 0 is a dummy, real data
// starts at index 1. Lists can hold zero bytes, unlike Str.

pub List(Int) seeded(List(Int) xs) {
    List(Int) s = [0];
    return s.concat(xs);
}

pub Int word_byte(List(Int) words, Int wi, Int bi) {
    Int sh = (3 - bi) * 8;
    Int b = (words[wi] >> sh) & 255;
    return b;
}

pub List(Int) wtb_inner(List(Int) words, Int wi, Int bi, List(Int) acc) {
    if (bi > 3) { return acc; }
    Int b = word_byte(words, wi, bi);
    List(Int) acc2 = acc.concat([b]);
    Int nbi = bi + 1;
    return wtb_inner(words, wi, nbi, acc2);
}

pub List(Int) wtb_outer(List(Int) words, Int wi, List(Int) acc) {
    if (wi > 7) { return acc; }
    List(Int) acc2 = wtb_inner(words, wi, 0, acc);
    Int nwi = wi + 1;
    return wtb_outer(words, nwi, acc2);
}

// Eight 32-bit words → 32 big-endian bytes, seeded.
pub List(Int) words_to_bytes(List(Int) words) {
    List(Int) all = wtb_outer(words, 0, [0]);
    return all;
}

// SHA-256 over a seeded byte list; returns the 32-byte digest seeded.
pub List(Int) sha256_bytes(List(Int) msg) {
    List(Int) h0 = [
        1779033703, -1150833019, 1013904242, -1521486534,
        1359893119, -1694144372, 528734635, 1541459225,
    ];
    List(Int) padded = pad_bytes(msg);
    Int total = padded.len() - 1;
    List(Int) hd = digest_blocks(padded, 0, total, h0);
    return words_to_bytes(hd);
}

pub Str hex_range(List(Int) bytes, Int i, Int end, Str acc) {
    if (i > end) { return acc; }
    Str part = acc + hex_byte(bytes[i]);
    Int ni = i + 1;
    return hex_range(bytes, ni, end, part);
}

// Hex-encode a seeded byte list (indices 1..len).
pub Str hex_encode(List(Int) bytes) {
    Int end = bytes.len() - 1;
    return hex_range(bytes, 1, end, "");
}

// ─── HMAC-SHA256 (RFC 2104) ─────────────────────────────────────

pub // Concatenate two seeded lists, dropping the second's dummy so exactly one
// seed remains.
List(Int) sc_acc(List(Int) a, List(Int) b, Int i, List(Int) acc) {
    if (i > b.len() - 1) { return acc; }
    List(Int) acc2 = acc.concat([b[i]]);
    Int ni = i + 1;
    return sc_acc(a, b, ni, acc2);
}

pub List(Int) sconcat(List(Int) a, List(Int) b) {
    return sc_acc(a, b, 1, a);
}

pub Int byte_at_or0(List(Int) a, Int i) {
    if (i <= a.len() - 1) { return a[i]; }
    return 0;
}

pub List(Int) xor_lists(List(Int) a, List(Int) b, Int i, List(Int) acc) {
    if (i > b.len() - 1) { return acc; }
    Int av = byte_at_or0(a, i);
    Int x = (av ^ b[i]) & 255;
    List(Int) acc2 = acc.concat([x]);
    Int ni = i + 1;
    return xor_lists(a, b, ni, acc2);
}

pub List(Int) key_block(List(Int) key) {
    Int klen = key.len() - 1;
    if (klen > 64) {
        List(Int) hk = sha256_bytes(key);
        Int padn = 64 - (hk.len() - 1);
        List(Int) zeros = zeros_l([0], padn);
        return sconcat(hk, zeros);
    }
    Int padn = 64 - klen;
    List(Int) zeros = zeros_l([0], padn);
    return sconcat(key, zeros);
}

List(Int) map_xor(List(Int) block, Int f, Int i, List(Int) acc) {
    if (i > block.len() - 1) { return acc; }
    Int v = block[i];
    Int x = f(v);
    List(Int) acc2 = acc.concat([x]);
    Int ni = i + 1;
    return map_xor(block, f, ni, acc2);
}

// Higher-order: Resid has no function values, so dispatch on a tag.
pub List(Int) map_ipad(List(Int) block, Int i, List(Int) acc) {
    if (i > block.len() - 1) { return acc; }
    Int v = block[i];
    Int x = (v ^ 54) & 255;
    List(Int) acc2 = acc.concat([x]);
    Int ni = i + 1;
    return map_ipad(block, ni, acc2);
}

pub List(Int) map_opad(List(Int) block, Int i, List(Int) acc) {
    if (i > block.len() - 1) { return acc; }
    Int v = block[i];
    Int x = (v ^ 92) & 255;
    List(Int) acc2 = acc.concat([x]);
    Int ni = i + 1;
    return map_opad(block, ni, acc2);
}

// HMAC-SHA256 over seeded byte lists; returns the 32-byte MAC seeded.
pub List(Int) hmac_sha256_bytes(List(Int) key, List(Int) msg) {
    List(Int) kb = key_block(key);
    List(Int) ipad_b = map_ipad(kb, 1, [0]);
    List(Int) opad_b = map_opad(kb, 1, [0]);
    List(Int) inner_input = sconcat(ipad_b, msg);
    List(Int) inner = sha256_bytes(inner_input);
    List(Int) outer_input = sconcat(opad_b, inner);
    return sha256_bytes(outer_input);
}


// ─── Constant-time equality ─────────────────────────────────────
// Accumulates the OR of every byte XOR so all byte positions influence
// the final comparison identically. Length mismatch returns false
// immediately (length is not treated as secret).

pub Bool ct_equal(List(Int) a, List(Int) b) {
    if (a.len() != b.len()) { return false; }
    Int d = ct_acc(a, b, 1, 0);
    return d == 0;
}

pub Int ct_acc(List(Int) a, List(Int) b, Int i, Int acc) {
    if (i > a.len() - 1) { return acc; }
    Int x = a[i] ^ b[i];
    Int acc2 = acc | x;
    Int ni = i + 1;
    return ct_acc(a, b, ni, acc2);
}

// ─── Base64 (RFC 4648 standard alphabet, padded) ────────────────

pub Str b64_char(Int v) {
    if (v < 26) {
        Int c = v + 65;
        return str_from_code(c);
    }
    if (v < 52) {
        Int c26 = v + 71;
        return str_from_code(c26);
    }
    if (v < 62) {
        Int c52 = v - 4;
        return str_from_code(c52);
    }
    if (v == 62) { return "+"; }
    return "/";
}

// Hex-encode helper for byte lists is hex_encode; base64 here:
pub Str base64_encode(List(Int) bytes) {
    Int end = bytes.len() - 1;
    return b64_enc(bytes, 1, end, "");
}

pub Str b64_enc(List(Int) bytes, Int i, Int end, Str acc) {
    if (i > end) { return acc; }
    Int rem = (end - i) + 1;
    if (rem >= 3) {
        Int b0 = bytes[i];
        Int o1 = i + 1;
        Int b1 = bytes[o1];
        Int o2 = i + 2;
        Int b2 = bytes[o2];
        Int s16 = b1 << 8;
        Int nraw = (b0 << 16) | s16;
        Int n = nraw | b2;
        Int q6 = (n >> 18) & 63;
        Str c0 = b64_char(q6);
        Int m12 = (n >> 12) & 63;
        Str c1 = b64_char(m12);
        Int m6 = (n >> 6) & 63;
        Str c2 = b64_char(m6);
        Str c3 = b64_char(n & 63);
        Str acc2 = ((acc + c0) + c1) + c2;
        Str acc3 = acc2 + c3;
        Int ni = i + 3;
        return b64_enc(bytes, ni, end, acc3);
    }
    if (rem == 2) {
        Int b0 = bytes[i];
        Int o1 = i + 1;
        Int b1 = bytes[o1];
        Int s8 = b1 << 8;
        Int n = (b0 << 16) | s8;
        Int q6 = (n >> 18) & 63;
        Str c0 = b64_char(q6);
        Int m12 = (n >> 12) & 63;
        Str c1 = b64_char(m12);
        Int m6 = (n >> 6) & 63;
        Str c2 = b64_char(m6);
        Str acc2 = ((acc + c0) + c1) + c2;
        return acc2 + "==";
    }
    Int b0 = bytes[i];
    Int n = b0 << 16;
    Int q6 = (n >> 18) & 63;
    Str c0 = b64_char(q6);
    Int m12 = (n >> 12) & 63;
    Str c1 = b64_char(m12);
    Str acc2 = (acc + c0) + c1;
    return acc2 + "=";
}

// ─── PBKDF2-HMAC-SHA256 (RFC 2898 §5.2) ────────────────────────
// Single output block per call: dklen implicitly 32 bytes.

pub List(Int) pbkdf2_f(List(Int) u_prev, List(Int) pass, Int remaining, List(Int) acc) {
    if (remaining <= 0) { return acc; }
    List(Int) u = hmac_sha256_bytes(pass, u_prev);
    List(Int) acc2 = pbkdf2_xor_acc(acc, u, 1);
    Int rem2 = remaining - 1;
    return pbkdf2_f(u, pass, rem2, acc2);
}

pub List(Int) pbkdf2_xor_acc(List(Int) acc, List(Int) u, Int i) {
    if (i > u.len() - 1) { return acc; }
    Int nv = (acc[i] ^ u[i]) & 255;
    List(Int) acc2 = ls_set(acc, i, nv);
    Int ni = i + 1;
    return pbkdf2_xor_acc(acc2, u, ni);
}

pub List(Int) pbkdf2_hmac_sha256(List(Int) pass, List(Int) salt, Int iters, Int block_index) {
    Int b3 = block_index & 255;
    Int b2 = (block_index >> 8) & 255;
    Int b1 = (block_index >> 16) & 255;
    Int b0 = (block_index >> 24) & 255;
    List(Int) idx_raw = [b0, b1, b2, b3];
    List(Int) idx = seeded(idx_raw);
    List(Int) salt_idx = sconcat(salt, idx);
    List(Int) u1 = hmac_sha256_bytes(pass, salt_idx);
    Int rem = iters - 1;
    return pbkdf2_f(u1, pass, rem, u1);
}

// ─── Secure randomness (OS entropy via runtime hook) ────────────
// The single C boundary in the library: entropy must come from the OS.
// Everything above this line is pure Resid.

pub List(Int) rand_acc(List(Int) acc, Int n, Int i) {
    if (i > n) { return acc; }
    Int b = resid_crypto_random_byte();
    List(Int) acc2 = acc.concat([b]);
    Int ni = i + 1;
    return rand_acc(acc2, n, ni);
}

// n cryptographically random bytes, seeded list.
pub List(Int) random_bytes(Int n) {
    List(Int) seeded0 = [0];
    return rand_acc(seeded0, n, 1);
}

pub Str random_hex(Int nbytes) {
    return hex_encode(random_bytes(nbytes));
}

// ─── SHA-512 (FIPS 180-4 §6.4) — 32-bit limb pairs ─────────────
// A 64-bit word is a seeded triple [0, hi, lo] of 32-bit limbs, so every
// value stays within plain Int and both compiler pipelines agree.

pub List(Int) w64(Int hi, Int lo) {
    Int him = hi & 4294967295;
    Int lom = lo & 4294967295;
    return [0, him, lom];
}

pub Int w64_hi(List(Int) x) {
    return x[1];
}

pub Int w64_lo(List(Int) x) {
    return x[2];
}

pub List(Int) w64_add(List(Int) a, List(Int) b) {
    Int al = w64_lo(a);
    Int bl = w64_lo(b);
    Int loraw = al + bl;
    Int lo = loraw & 4294967295;
    Int carry = loraw >> 32;
    Int hi = (w64_hi(a) + w64_hi(b)) + carry;
    return w64(hi, lo);
}
pub List(Int) w64_xor(List(Int) a, List(Int) b) {
    return w64(w64_hi(a) ^ w64_hi(b), w64_lo(a) ^ w64_lo(b));
}

pub List(Int) w64_and(List(Int) a, List(Int) b) {
    return w64(w64_hi(a) & w64_hi(b), w64_lo(a) & w64_lo(b));
}

pub List(Int) w64_not(List(Int) a) {
    Int hi = (w64_hi(a) ^ 4294967295) & 4294967295;
    Int lo = (w64_lo(a) ^ 4294967295) & 4294967295;
    return w64(hi, lo);
}

pub List(Int) w64_zext(List(Int) lo32) {
    return w64(0, w64_lo(lo32));
}

// Rotate right by n < 32.
pub List(Int) w64_rotr_small(List(Int) x, Int n) {
    Int hi = w64_hi(x);
    Int lo = w64_lo(x);
    Int inv = 32 - n;
    Int nh_raw = (hi >> n) | (lo << inv);
    Int nl_raw = (lo >> n) | (hi << inv);
    return w64(nh_raw, nl_raw);
}

pub List(Int) w64_rotr(List(Int) x, Int n) {
    if (n == 0) { return x; }
    if (n == 32) {
        return w64(w64_lo(x), w64_hi(x));
    }
    if (n > 32) {
        Int nn = n - 32;
        List(Int) swapped = w64(w64_lo(x), w64_hi(x));
        return w64_rotr_small(swapped, nn);
    }
    return w64_rotr_small(x, n);
}

// Logical shift right by n < 32 (result fits: high half shifts in zeros).
pub List(Int) w64_shr_small(List(Int) x, Int n) {
    Int hi = w64_hi(x);
    Int lo = w64_lo(x);
    Int inv = 32 - n;
    Int nl_raw = (lo >> n) | (hi << inv);
    Int nh_raw = hi >> n;
    return w64(nh_raw, nl_raw);
}

pub List(Int) w64_shr(List(Int) x, Int n) {
    if (n == 0) { return x; }
    if (n >= 32) {
        Int rest = n - 32;
        return w64(0, w64_hi(x) >> rest);
    }
    return w64_shr_small(x, n);
}

pub List(Int) k512_limb_at(Int i) {
    List(Int) ks = [
        1116352408, 3609767458, 1899447441, 602891725,
        3049323471, 3964484399, 3921009573, 2173295548,
        961987163, 4081628472, 1508970993, 3053834265,
        2453635748, 2937671579, 2870763221, 3664609560,
        3624381080, 2734883394, 310598401, 1164996542,
        607225278, 1323610764, 1426881987, 3590304994,
        1925078388, 4068182383, 2162078206, 991336113,
        2614888103, 633803317, 3248222580, 3479774868,
        3835390401, 2666613458, 4022224774, 944711139,
        264347078, 2341262773, 604807628, 2007800933,
        770255983, 1495990901, 1249150122, 1856431235,
        1555081692, 3175218132, 1996064986, 2198950837,
        2554220882, 3999719339, 2821834349, 766784016,
        2952996808, 2566594879, 3210313671, 3203337956,
        3336571891, 1034457026, 3584528711, 2466948901,
        113926993, 3758326383, 338241895, 168717936,
        666307205, 1188179964, 773529912, 1546045734,
        1294757372, 1522805485, 1396182291, 2643833823,
        1695183700, 2343527390, 1986661051, 1014477480,
        2177026350, 1206759142, 2456956037, 344077627,
        2730485921, 1290863460, 2820302411, 3158454273,
        3259730800, 3505952657, 3345764771, 106217008,
        3516065817, 3606008344, 3600352804, 1432725776,
        4094571909, 1467031594, 275423344, 851169720,
        430227734, 3100823752, 506948616, 1363258195,
        659060556, 3750685593, 883997877, 3785050280,
        958139571, 3318307427, 1322822218, 3812723403,
        1537002063, 2003034995, 1747873779, 3602036899,
        1955562222, 1575990012, 2024104815, 1125592928,
        2227730452, 2716904306, 2361852424, 442776044,
        2428436474, 593698344, 2756734187, 3733110249,
        3204031479, 2999351573, 3329325298, 3815920427,
        3391569614, 3928383900, 3515267271, 566280711,
        3940187606, 3454069534, 4118630271, 4000239992,
        116418474, 1914138554, 174292421, 2731055270,
        289380356, 3203993006, 460393269, 320620315,
        685471733, 587496836, 852142971, 1086792851,
        1017036298, 365543100, 1126000580, 2618297676,
        1288033470, 3409855158, 1501505948, 4234509866,
        1607167915, 987167468, 1816402316, 1246189591,
    ];
    Int hi = ks[i * 2];
    Int lo = ks[(i * 2) + 1];
    return w64(hi, lo);
}

// ─── SHA-512 padding and message words ─────────────────────────

pub List(Int) h512_state() {
    List(Int) his = [
        1779033703,
        3144134277,
        1013904242,
        2773480762,
        1359893119,
        2600822924,
        528734635,
        1541459225,
    ];
    List(Int) los = [
        4089235720,
        2227873595,
        4271175723,
        1595750129,
        2917565137,
        725511199,
        4215389547,
        327033209,
    ];
    List(Int) base1 = zeros_l([0], 0);
    List(Int) with_hi = base1.concat(his);
    return with_hi.concat(los);
}

pub List(Int) h512_seed(List(Int) acc, List(Int) his, List(Int) los, Int i) {
    if (i > 7) { return acc; }
    Int hi = his[i];
    Int lo = los[i];
    List(Int) acc2 = acc.concat([hi]);
    List(Int) acc3 = acc2.concat([lo]);
    Int ni = i + 1;
    return h512_seed(acc3, his, los, ni);
}

pub List(Int) pad512(List(Int) msg) {
    Int l = msg.len() - 1;
    List(Int) p = msg.concat([128]);
    Int l17 = l + 17;
    Int blocks = (l17 + 127) / 128;
    Int total = blocks * 128;
    Int zc = total - l17;
    List(Int) p2 = zeros_l(p, zc);
    Int bits = l * 8;
    return len512_bytes(p2, bits, 15);
}

// Shift right by any count (x86 shifts wrap the count mod 64, so step down).
pub Int shr_big(Int v, Int s) {
    if (s <= 63) { return v >> s; }
    Int half = v >> 32;
    Int rest = s - 32;
    return shr_big(half, rest);
}

pub List(Int) len512_bytes(List(Int) acc, Int bits, Int shift) {
    if (shift < 0) { return acc; }
    Int sh = shift * 8;
    Int byte = shr_big(bits, sh) & 255;
    List(Int) acc2 = acc.concat([byte]);
    Int ns = shift - 1;
    return len512_bytes(acc2, bits, ns);
}

// Word i (big-endian, 8 bytes at real offset base+i*8) as a pair.
pub List(Int) mw512(List(Int) m, Int base, Int i) {
    Int off = (base + (i * 8)) + 1;
    Int b0 = m[off];
    Int o1 = off + 1;
    Int b1 = m[o1];
    Int o2 = off + 2;
    Int b2 = m[o2];
    Int o3 = off + 3;
    Int b3 = m[o3];
    Int o4 = off + 4;
    Int b4 = m[o4];
    Int o5 = off + 5;
    Int b5 = m[o5];
    Int o6 = off + 6;
    Int b6 = m[o6];
    Int o7 = off + 7;
    Int b7 = m[o7];
    Int s0 = b0 << 24;
    Int s1v = b1 << 16;
    Int s2v = b2 << 8;
    Int hiraw = ((s0 | s1v) | s2v) | b3;
    Int hi = hiraw & 4294967295;
    Int s4 = b4 << 24;
    Int s5 = b5 << 16;
    Int s6 = b6 << 8;
    Int loraw = ((s4 | s5) | s6) | b7;
    Int lo = loraw & 4294967295;
    return [hi, lo];
}

// Flat limb list: [seed, w0hi, w0lo, w1hi, w1lo, ...] for words 0..15.
pub List(Int) mw512_acc(List(Int) m, Int base, Int i, List(Int) acc) {
    if (i >= 16) { return acc; }
    List(Int) pair = mw512(m, base, i);
    List(Int) acc2 = acc.concat(pair);
    Int ni = i + 1;
    return mw512_acc(m, base, ni, acc2);
}

pub List(Int) msg_words512(List(Int) m, Int base) {
    List(Int) seeded0 = [0];
    return mw512_acc(m, base, 0, seeded0);
}

// Word i's limbs live at flat indices 2i+1 and 2i+2.
pub Int fw_hi(List(Int) flat, Int i) {
    Int idx = (i * 2) + 1;
    return flat[idx];
}

pub Int fw_lo(List(Int) flat, Int i) {
    Int idx = (i * 2) + 2;
    return flat[idx];
}

pub List(Int) fw_pair(List(Int) flat, Int i) {
    return w64(fw_hi(flat, i), fw_lo(flat, i));
}


pub Int ch64_of(Int e, Int f, Int g) {
    Int ne = not32(e);
    Int ef = e & f;
    Int ng = ne & g;
    return ef ^ ng;
}

pub Str hex_byte_at(List(Int) bytes, Int i) {
    Int b = bytes[i] & 255;
    Str hs = hex_digit((b >> 4) & 15);
    Str ls = hex_digit(b & 15);
    return hs + ls;
}

pub List(Int) sig0(List(Int) x) {
    List(Int) r1 = w64_rotr(x, 1);
    List(Int) r8 = w64_rotr(x, 8);
    List(Int) s7v = w64_shr(x, 7);
    List(Int) x1 = w64_xor(r1, r8);
    return w64_xor(x1, s7v);
}

pub List(Int) sig1(List(Int) x) {
    List(Int) r19 = w64_rotr(x, 19);
    List(Int) r61 = w64_rotr(x, 61);
    List(Int) s6v = w64_shr(x, 6);
    List(Int) x1 = w64_xor(r19, r61);
    return w64_xor(x1, s6v);
}

pub List(Int) big_sig0(List(Int) x) {
    List(Int) r28 = w64_rotr(x, 28);
    List(Int) r34 = w64_rotr(x, 34);
    List(Int) r39 = w64_rotr(x, 39);
    List(Int) x1 = w64_xor(r28, r34);
    return w64_xor(x1, r39);
}

pub List(Int) big_sig1(List(Int) x) {
    List(Int) r14 = w64_rotr(x, 14);
    List(Int) r18 = w64_rotr(x, 18);
    List(Int) r41 = w64_rotr(x, 41);
    List(Int) x1 = w64_xor(r14, r18);
    return w64_xor(x1, r41);
}

pub List(Int) maj64(List(Int) a, List(Int) b, List(Int) c) {
    List(Int) ab = w64_and(a, b);
    List(Int) ac = w64_and(a, c);
    List(Int) bc = w64_and(b, c);
    List(Int) x1 = w64_xor(ab, ac);
    return w64_xor(x1, bc);
}

pub List(Int) ext512_flat(List(Int) w, Int i, Int count) {
    if (i >= count) { return w; }

    Int im15 = i - 15;
    List(Int) wm15 = fw_pair(w, im15);
    List(Int) s0v = sig0(wm15);
    Int im2 = i - 2;
    List(Int) wm2 = fw_pair(w, im2);
    List(Int) s1v = sig1(wm2);
    Int im16 = i - 16;
    List(Int) wa16 = fw_pair(w, im16);
    Int im7 = i - 7;
    List(Int) wa7 = fw_pair(w, im7);
    List(Int) t1 = w64_add(wa16, s0v);
    List(Int) t2 = w64_add(wa7, s1v);
    List(Int) nw = w64_add(t1, t2);
    List(Int) hi1 = [w64_hi(nw)];
    List(Int) lo1 = [w64_lo(nw)];
    List(Int) acc2 = w.concat(hi1);
    List(Int) acc3 = acc2.concat(lo1);
    Int ni = i + 1;
    List(Int) rec = ext512_flat(acc3, ni, count);
    return rec;
}

pub List(Int) state512_init() {
    List(Int) iv_limbs = [
        1779033703,
        4089235720,
        3144134277,
        2227873595,
        1013904242,
        4271175723,
        2773480762,
        1595750129,
        1359893119,
        2917565137,
        2600822924,
        725511199,
        528734635,
        4215389547,
        1541459225,
        327033209,
    ];
    List(Int) base1 = zeros_l([0], 0);
    return base1.concat(iv_limbs);
}

pub List(Int) st_set(List(Int) st, Int word_idx, List(Int) pair) {
    Int hi_i = (word_idx * 2) + 1;
    Int lo_i = hi_i + 1;
    List(Int) s1 = ls_set(st, hi_i, w64_hi(pair));
    List(Int) s2 = ls_set(s1, lo_i, w64_lo(pair));
    return s2;
}

pub Int st_hi(List(Int) st, Int word_idx) {
    Int hi_i = (word_idx * 2) + 1;
    return st[hi_i];
}

pub Int st_lo(List(Int) st, Int word_idx) {
    Int lo_i = (word_idx * 2) + 2;
    return st[lo_i];
}

pub List(Int) sha512_round_flat(List(Int) st, List(Int) w, Int i) {
    List(Int) a = fw_pair(st, 0);
    List(Int) b = fw_pair(st, 1);
    List(Int) c = fw_pair(st, 2);
    List(Int) d = fw_pair(st, 3);
    List(Int) e = fw_pair(st, 4);
    List(Int) f = fw_pair(st, 5);
    List(Int) g = fw_pair(st, 6);
    List(Int) hh = fw_pair(st, 7);
    List(Int) wi = fw_pair(w, i);
    List(Int) kk = k512_limb_at(i);
    List(Int) S1 = big_sig1(e);
    List(Int) not_e = w64_not(e);
    List(Int) ef = w64_and(e, f);
    List(Int) ng = w64_and(not_e, g);
    List(Int) chv = w64_xor(ef, ng);
    List(Int) ta = w64_add(hh, S1);
    List(Int) tb = w64_add(ta, chv);
    List(Int) tc = w64_add(tb, kk);
    List(Int) td = w64_add(tc, wi);
    List(Int) t1 = td;
    List(Int) S0 = big_sig0(a);
    List(Int) mjv = maj64(a, b, c);
    List(Int) t2 = w64_add(S0, mjv);
    List(Int) na = w64_add(t1, t2);
    List(Int) nd = w64_add(d, t1);
    List(Int) s1l = st_set(st, 0, na);
    List(Int) s2l = st_set(s1l, 1, a);
    List(Int) s3l = st_set(s2l, 2, b);
    List(Int) s4l = st_set(s3l, 3, c);
    List(Int) s5l = st_set(s4l, 4, nd);
    List(Int) s6l = st_set(s5l, 5, e);
    List(Int) s7l = st_set(s6l, 6, f);
    List(Int) s8l = st_set(s7l, 7, g);
    return s8l;
}

pub List(Int) sha512_rounds_flat(List(Int) st, List(Int) w, Int i) {
    if (i >= 80) { return st; }
    List(Int) st2 = sha512_round_flat(st, w, i);
    Int ni = i + 1;
    return sha512_rounds_flat(st2, w, ni);
}

pub List(Int) add_st(List(Int) h, List(Int) hv, Int i) {
    if (i >= 8) { return h; }
    Int hi_i = (i * 2) + 1;
    Int lo_i = hi_i + 1;
    List(Int) hp = w64(h[hi_i], h[lo_i]);
    List(Int) hv_p = w64(hv[hi_i], hv[lo_i]);
    List(Int) sum = w64_add(hp, hv_p);
    List(Int) s1 = ls_set(h, hi_i, w64_hi(sum));
    List(Int) s2 = ls_set(s1, lo_i, w64_lo(sum));
    Int ni = i + 1;
    return add_st(s2, hv, ni);
}

pub List(Int) digest_block512f(List(Int) m, Int base, List(Int) st) {
    List(Int) w16 = msg_words512(m, base);
    List(Int) w = ext512_flat(w16, 16, 80);
    List(Int) hv = sha512_rounds_flat(st, w, 0);
    List(Int) r = add_st(st, hv, 0);
    return r;
}

pub List(Int) digest_blocks512f(List(Int) m, Int pos, Int total, List(Int) st) {
    if (pos >= total) { return st; }
    List(Int) st2 = digest_block512f(m, pos, st);
    Int npos = pos + 128;
    return digest_blocks512f(m, npos, total, st2);
}

pub Str hex_range_b(List(Int) bytes, Int i, Int end, Str acc) {
    if (i > end) { return acc; }
    Str pair = hex_byte_at(bytes, i);
    Str acc2 = acc + pair;
    Int ni = i + 1;
    return hex_range_b(bytes, ni, end, acc2);
}

// SHA-512 of a seeded byte list; returns the 64-byte digest seeded.
pub List(Int) sha512_bytes(List(Int) msg) {
    List(Int) padded = pad512(msg);
    Int total = padded.len() - 1;
    List(Int) st = digest_blocks512f(padded, 0, total, state512_init());
    return limbs_to_hex_bytes(st, 1);
}

// Emit digest as seeded BYTE list for hashing chains.
pub List(Int) limb_bytes_acc(List(Int) st, Int i, List(Int) acc) {
    if (i > 16) { return acc; }
    Int vraw = st[i];
    Int v = vraw & 4294967295;
    Int b0 = (v >> 24) & 255;
    Int b1 = (v >> 16) & 255;
    Int b2 = (v >> 8) & 255;
    Int b3 = v & 255;
    List(Int) acc1 = acc.concat([b0]);
    List(Int) acc2 = acc1.concat([b1]);
    List(Int) acc3 = acc2.concat([b2]);
    List(Int) acc4 = acc3.concat([b3]);
    Int ni = i + 1;
    return limb_bytes_acc(st, ni, acc4);
}

pub List(Int) limbs_to_hex_bytes(List(Int) st, Int seed_unused) {
    List(Int) acc0 = [0];
    return limb_bytes_acc(st, 1, acc0);
}
