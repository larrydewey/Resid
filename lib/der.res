// ─── lib/der.res — ASN.1 DER decoder in pure Resid ───────────────────
// Foundation for x509 certificate parsing. Byte lists follow the lib
// convention: index 0 is a dummy seed; data starts at index 1. All
// positions are 1-based data indices matching that layout.
//
// Scope v1: TLV framing (tag class/number, short + long form lengths,
// indefinite length rejected). No signature verification here.

// One parsed DER element.
// tag: identifier octet; cls: 0=universal 1=app 2=context 3=private;
// hdr_len: start-to-content bytes; val_len: content length (-1 malformed).
type DerTlv = { tag: Int, cls: Int, hdr_len: Int, val_len: Int };


pub Int der_cls_of(Int tag) {
    Int sh = tag >> 6;
    return sh & 3;
}

// Long-form length: first octet 0x80|n gives n following big-endian
// octets. Returns -1 for indefinite (0x80) or n > 4 (we cap at 32-bit).
pub Int der_read_len(List(Int) data, Int pos) {
    Int n = data.len() - 1;
    if (pos > n) { return -1; }
    Int b0 = data[pos];
    if (b0 < 128) { return b0; }
    if (b0 == 128) { return -1; }
    Int cnt = b0 - 128;
    if (cnt > 4) { return -1; }
    Int end = pos + cnt;
    if (end > n) { return -1; }
    Int start = pos + 1;
    return der_read_len_acc(data, start, end, 0);
}


pub Int der_read_len_acc(List(Int) data, Int i, Int end, Int acc) {
    if (i > end) { return acc; }
    // Big-endian accumulate: acc = acc*256 + byte.
    Int byte = data[i];
    Int step = acc * 256 + byte;
    Int ni = i + 1;
    return der_read_len_acc(data, ni, end, step);
}

// Parse the element starting at data index `pos`. On malformed input the
// returned val_len is negative.
pub DerTlv der_next(List(Int) data, Int pos) {
    Int n = data.len() - 1;
    if (pos > n) {
        return DerTlv { tag: 0, cls: 0, hdr_len: 0, val_len: -1 };
    }
    Int tag = data[pos];
    Int c = der_cls_of(tag);
    Int p1 = pos + 1;
    Int len = der_read_len(data, p1);
    if (len < 0) {
        return DerTlv { tag: tag, cls: c, hdr_len: 0, val_len: -1 };
    }
    // Total header: identifier octet + length field.
    Int lflen = der_hdr_len(data, p1);
    Int hlen = lflen + 1;
    return DerTlv { tag: tag, cls: c, hdr_len: hlen, val_len: len };
}

// Bytes consumed by the length field at `pos` (which holds the first
// length octet). 1 for short form; 1+cnt for long form.
pub Int der_hdr_len(List(Int) data, Int pos) {
    Int b0 = data[pos];
    if (b0 < 128) { return 1; }
    Int cnt = b0 - 128;
    Int r = cnt + 1;
    return r;
}

// Universal tag numbers used by x509.
pub Int der_tag_integer() { return 2; }
pub Int der_tag_bit_string() { return 3; }
pub Int der_tag_octet_string() { return 4; }
pub Int der_tag_null() { return 5; }
pub Int der_tag_oid() { return 6; }
pub Int der_tag_sequence() { return 16; }
pub Int der_tag_set() { return 17; }

// True when the element at `pos` is a universal SEQUENCE/SET and well-formed.
pub Bool der_is_seq(List(Int) data, Int pos, Int want_tag) {
    DerTlv t = der_next(data, pos);
    if (t.val_len < 0) { return false; }
    if (t.cls != 0) { return false; }
    Int low = t.tag & 31;
    return low == want_tag;
}

// Content start (first value byte index) for the element at `pos`:
// one identifier octet plus the length field.
pub Int der_content_pos(List(Int) data, Int pos) {
    Int p1 = pos + 1;
    Int lh = der_hdr_len(data, p1);
    Int r = p1 + lh;
    return r;
}

// Slice out the content bytes of the element at `pos` as a fresh seeded list.
pub List(Int) der_content(List(Int) data, Int pos) {
    DerTlv t = der_next(data, pos);
    Int start = pos + t.hdr_len;
    Int stop = start + t.val_len - 1;
    return der_slice_seeded(data, start, stop);
}


pub List(Int) der_slice_seeded(List(Int) data, Int start, Int stop) {
    List(Int) out = [0];
    return der_slice_acc(data, start, stop, start, out);
}


pub List(Int) der_slice_acc(List(Int) data, Int start, Int stop, Int i, List(Int) acc) {
    if (i > stop) { return acc; }
    Int b = data[i];
    List(Int) acc2 = acc.concat([b]);
    Int ni = i + 1;
    return der_slice_acc(data, start, stop, ni, acc2);
}

// ─── Value decoders ──────────────────────────────────────────────────

// Decode a DER INTEGER's content (big-endian, two's complement) assuming
// it is non-negative and fits in 62 bits (serials we care about are small
// enough after trimming; big serials return -1).
pub Int der_int_value(List(Int) data, Int pos) {
    List(Int) c = der_content(data, pos);
    Int n = c.len() - 1;
    if (n == 0 || n > 8) { return -1; }
    Int b1 = c[1];
    if (b1 >= 128) { return -1; }
    return der_int_acc(c, 2, n, b1);
}


pub Int der_int_acc(List(Int) c, Int i, Int n, Int acc) {
    if (i > n) { return acc; }
    Int byte = c[i];
    Int step = acc * 256 + byte;
    Int ni = i + 1;
    return der_int_acc(c, ni, n, step);
}

// ─── OID rendering ───────────────────────────────────────────────────
// Base-128 varint arcs; high bit = continuation. acc carries the dotted
// string so far, accv the in-progress varint value.
pub Str oid_rest(List(Int) c, Int i, Int n, Str acc, Int accv, Bool inarc) {
    if (i > n) {
        if (inarc) {
            Str s = IntToString(accv);
            return acc + "." + s;
        }
        return acc;
    }
    Int byte = c[i];
    Int cont = byte & 128;
    Int low = byte - cont;
    Int v = accv * 128 + low;
    Int ni = i + 1;
    if (cont > 0) {
        return oid_rest(c, ni, n, acc, v, true);
    }
    Str arc = IntToString(v);
    Str joined = acc + "." + arc;
    return oid_rest(c, ni, n, joined, 0, false);
}

// Render an OBJECT IDENTIFIER content as dotted decimal "1.2.840....".
// First byte encodes arcs 1 and 2 (assumed < 80, covering all common OIDs).
pub Str der_oid_str(List(Int) data, Int pos) {
    List(Int) c = der_content(data, pos);
    Int n = c.len() - 1;
    if (n == 0) { return ""; }
    Int b0 = c[1];
    Int second = b0 - 40;
    Int second2 = if (second < 0) { 0 } else { second };
    Str head = "1." + IntToString(second2);
    return oid_rest(c, 2, n, head, 0, false);
}
