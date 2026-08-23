// ─── lib/x509.res — x509 TBS structure walker (pure Resid) ───────────
// Builds on lib/der.res. Input: a DER certificate as a seeded byte
// list (index 0 dummy; data starts at index 1). Extracts tbsCertificate
// fields: serial, signature-alg OID, issuer/subject RDN strings,
// validity times, and SPKI algorithm OID. No signature verification.
//
// Gotcha compliance: every function pub, definitions precede uses, no
// inline arithmetic as call arguments (bind temps first).

import "der.res";

// ─── Position helpers ────────────────────────────────────────────────

// Index just past the element at pos. -1 on malformed input.
pub Int x509_skip_tlv(List(Int) data, Int pos) {
    DerTlv t = der_next(data, pos);
    if (t.val_len < 0) { return -1; }
    Int e = pos + t.hdr_len;
    Int r = e + t.val_len;
    return r;
}

// Position of the tbsCertificate element inside the outer Certificate
// SEQUENCE.
pub Int x509_tbs_pos(List(Int) cert) {
    return der_content_pos(cert, 1);
}

// Start of the TBS field run: content of tbsCertificate.
pub Int x509_body_pos(List(Int) cert) {
    Int tbs = x509_tbs_pos(cert);
    return der_content_pos(cert, tbs);
}

// Skip the optional [0] EXPLICIT version element at the head of TBS.
pub Int x509_after_version(List(Int) cert) {
    Int body = x509_body_pos(cert);
    DerTlv t = der_next(cert, body);
    if (t.cls != 2) { return body; }
    Int e = body + t.hdr_len;
    Int r = e + t.val_len;
    return r;
}

pub Int x509_serial_pos(List(Int) cert) {
    return x509_after_version(cert);
}

pub Int x509_sigalg_pos(List(Int) cert) {
    Int p0 = x509_serial_pos(cert);
    return x509_skip_tlv(cert, p0);
}

pub Int x509_issuer_pos(List(Int) cert) {
    Int p0 = x509_sigalg_pos(cert);
    return x509_skip_tlv(cert, p0);
}

pub Int x509_validity_pos(List(Int) cert) {
    Int p0 = x509_issuer_pos(cert);
    return x509_skip_tlv(cert, p0);
}

pub Int x509_subject_pos(List(Int) cert) {
    Int p0 = x509_validity_pos(cert);
    return x509_skip_tlv(cert, p0);
}

pub Int x509_spki_pos(List(Int) cert) {
    Int p0 = x509_subject_pos(cert);
    return x509_skip_tlv(cert, p0);
}

// ─── Field accessors ─────────────────────────────────────────────────

pub Int x509_serial(List(Int) cert) {
    Int p = x509_serial_pos(cert);
    return der_int_value(cert, p);
}

pub Str x509_sigalg_oid(List(Int) cert) {
    Int p = x509_sigalg_pos(cert);
    Int cs = der_content_pos(cert, p);
    return der_oid_str(cert, cs);
}

pub Str x509_spki_alg_oid(List(Int) cert) {
    Int sp = x509_spki_pos(cert);
    Int algseq = der_content_pos(cert, sp);
    Int oidp = der_content_pos(cert, algseq);
    return der_oid_str(cert, oidp);
}

// First UTCTime/GeneralizedTime inside the validity SEQUENCE.
pub Str x509_not_before(List(Int) cert) {
    Int vp = x509_validity_pos(cert);
    Int cs = der_content_pos(cert, vp);
    return der_str_value(cert, cs);
}

pub Str x509_not_after(List(Int) cert) {
    Int vp = x509_validity_pos(cert);
    Int first = der_content_pos(cert, vp);
    Int second = x509_skip_tlv(cert, first);
    return der_str_value(cert, second);
}

// ─── String decoding ─────────────────────────────────────────────────

pub Str der_str_acc(List(Int) c, Int i, Int n, Str acc) {
    if (i > n) { return acc; }
    Int b = c[i];
    Str acc2 = acc + str_from_code(b);
    Int ni = i + 1;
    return der_str_acc(c, ni, n, acc2);
}

// Decode a PrintableString/UTF8String/IA5String element's content.
pub Str der_str_value(List(Int) data, Int pos) {
    List(Int) c = der_content(data, pos);
    Int n = c.len() - 1;
    return der_str_acc(c, 1, n, "");
}

// ─── Name rendering ──────────────────────────────────────────────────

// Well-known OIDs → short names; unknown OIDs pass through as-is.
pub Str oid_short(Str oid) {
    if (oid == "2.5.4.3") { return "CN"; }
    if (oid == "2.5.4.6") { return "C"; }
    if (oid == "2.5.4.7") { return "L"; }
    if (oid == "2.5.4.8") { return "ST"; }
    if (oid == "2.5.4.10") { return "O"; }
    if (oid == "2.5.4.11") { return "OU"; }
    if (oid == "2.5.4.5") { return "serialNumber"; }
    if (oid == "1.2.840.113549.1.9.1") { return "emailAddress"; }
    return oid;
}

// Render one RDN: SET { SEQ { OID, value } } → "CN=Resid Test CA".
pub Str x509_rdn_str(List(Int) data, Int setpos) {
    Int seqpos = der_content_pos(data, setpos);
    Int attrpos = der_content_pos(data, seqpos);
    Str oid = der_oid_str(data, attrpos);
    Int valpos = x509_skip_tlv(data, attrpos);
    Str val = der_str_value(data, valpos);
    Str nm = oid_short(oid);
    return nm + "=" + val;
}

pub Str x509_name_acc(List(Int) data, Int pos, Int end, Str acc, Bool first) {
    if (pos < 0 || pos >= end) { return acc; }
    Str rdn = x509_rdn_str(data, pos);
    Str joined = if (first) { rdn } else { acc + "," + rdn };
    Int np = x509_skip_tlv(data, pos);
    return x509_name_acc(data, np, end, joined, false);
}

// Name ::= SEQUENCE OF SET — render as comma-joined RDNs.
pub Str x509_name_str(List(Int) data, Int pos) {
    DerTlv t = der_next(data, pos);
    if (t.val_len < 0) { return ""; }
    Int s = pos + t.hdr_len;
    Int e = s + t.val_len;
    return x509_name_acc(data, s, e, "", true);
}

pub Str x509_issuer_str(List(Int) cert) {
    Int p = x509_issuer_pos(cert);
    return x509_name_str(cert, p);
}

pub Str x509_subject_str(List(Int) cert) {
    Int p = x509_subject_pos(cert);
    return x509_name_str(cert, p);
}
