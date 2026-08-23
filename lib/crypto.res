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
