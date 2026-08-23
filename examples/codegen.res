/// typecheck.res — M6a bootstrap milestone: a Resid type checker written in Resid.
///
/// Reads `.resid` source (path from `RESID_TYPECHECK_SRC` env var), lexes it with
/// the M4 lexer primitives, collects every function signature in a first pass,
/// then re-walks the program checking each function body against a growing
/// environment of parameter/local bindings. On success it prints one `OK <decl>`
/// line per declaration and exits 0; on the first type error it prints
/// `type error: <message>` and exits 1.
///
/// Proof: run `RESID_TYPECHECK_SRC=<file> residc examples/typecheck.res run`.
///
/// Supported subset: primitive types (Int/Float/Bool/Str), `List(T)`, functions
/// with typed params and a return type, bind/discard/return/if-else/while/for-in
/// statements, block statements, unary/binary expressions (incl. Str + Str and
/// `..` ranges), list literals, indexing, slicing, `.len()` / `.concat(...)`,
/// calls to user functions and the numeric/string built-ins. `type` defs and
/// `import` declarations are parsed and skipped (reported OK).

// ─── Character classification (M4 lexer primitives) ────────────

Bool is_ws(Int c) {
    if (c == 32) { return true; }
    if (c == 9) { return true; }
    if (c == 13) { return true; }
    if (c == 10) { return true; }
    return false;
}

Bool is_alpha(Int c) {
    if (c >= 65) {
        if (c <= 90) { return true; }
    }
    if (c >= 97) {
        if (c <= 122) { return true; }
    }
    if (c >= 128) { return true; }
    return false;
}

Bool is_digit(Int c) {
    if (c >= 48) {
        if (c <= 57) { return true; }
    }
    return false;
}

Bool is_alnum(Int c) {
    if (is_alpha(c)) { return true; }
    if (is_digit(c)) { return true; }
    if (c == 95) { return true; }
    return false;
}

Bool is_hex(Int c) {
    if (is_digit(c)) { return true; }
    if (c >= 65) {
        if (c <= 70) { return true; }
    }
    if (c >= 97) {
        if (c <= 102) { return true; }
    }
    return false;
}

Bool is_oct(Int c) {
    if (c >= 48) {
        if (c <= 55) { return true; }
    }
    return false;
}

Int char_at(Str s, Int i) {
    return str_char_at(s, i);
}

Int char_next(Str s, Int i) {
    Int k = i + 1;
    return str_char_at(s, k);
}

Int char_next2(Str s, Int i) {
    Int k = i + 1;
    Int m = i + 2;
    return str_char_at(s, m);
}

Int str_len_1(Str s) {
    return str_len(s);
}

Int skip_ws(Str s, Int i, Int n) {
    if (i >= n) { return i; }
    Int c = str_char_at(s, i);
    if (is_ws(c)) {
        Int k = i + 1;
        return skip_ws(s, k, n);
    }
    return i;
}

Int skip_line_comment(Str s, Int i, Int n) {
    if (i >= n) { return i; }
    Int c = str_char_at(s, i);
    if (c == 10) { return i; }
    Int k = i + 1;
    return skip_line_comment(s, k, n);
}

Int skip_block_comment(Str s, Int i, Int n) {
    if (i >= n) { return i; }
    Int c = str_char_at(s, i);
    if (c == 42) {
        Int c2 = char_next(s, i);
        if (c2 == 47) {
            Int k = i + 2;
            return k;
        }
    }
    Int k = i + 1;
    return skip_block_comment(s, k, n);
}

Int skip_all(Str s, Int i, Int n) {
    Int j = skip_ws(s, i, n);
    if (j >= n) { return j; }
    Int c = char_at(s, j);
    if (c == 47) {
        Int c2 = char_next(s, j);
        if (c2 == 47) {
            Int k = j + 2;
            Int e = skip_line_comment(s, k, n);
            return skip_all(s, e, n);
        }
        if (c2 == 42) {
            Int k = j + 2;
            Int e = skip_block_comment(s, k, n);
            return skip_all(s, e, n);
        }
    }
    return j;
}

Int scan_ident(Str s, Int i, Int n) {
    if (i >= n) { return i; }
    Int c = str_char_at(s, i);
    if (is_alnum(c)) {
        Int k = i + 1;
        return scan_ident(s, k, n);
    }
    return i;
}

Int scan_digits(Str s, Int i, Int n, Int base) {
    if (i >= n) { return i; }
    Int c = str_char_at(s, i);
    if (base == 2) {
        if (c == 48) { Int k = i + 1; return scan_digits(s, k, n, base); }
        if (c == 49) { Int k = i + 1; return scan_digits(s, k, n, base); }
        return i;
    }
    if (base == 8) {
        if (is_oct(c)) { Int k = i + 1; return scan_digits(s, k, n, base); }
        return i;
    }
    if (base == 10) {
        if (is_digit(c)) { Int k = i + 1; return scan_digits(s, k, n, base); }
        return i;
    }
    if (base == 16) {
        if (is_hex(c)) { Int k = i + 1; return scan_digits(s, k, n, base); }
        return i;
    }
    return i;
}

Int scan_string(Str s, Int i, Int n) {
    if (i >= n) { return i; }
    Int c = str_char_at(s, i);
    if (c == 34) {
        Int k = i + 1;
        return k;
    }
    if (c == 92) {
        Int k = i + 2;
        return scan_string(s, k, n);
    }
    Int k = i + 1;
    return scan_string(s, k, n);
}

Int scan_fstring(Str s, Int i, Int n, Int depth) {
    if (i >= n) { return i; }
    Int c = str_char_at(s, i);
    if (c == 92) { Int k = i + 1; Int m = i + 2; return scan_fstring(s, m, n, depth); }
    if (c == 123) { Int k = i + 1; Int d = depth + 1; return scan_fstring(s, k, n, d); }
    if (c == 125) { Int k = i + 1; return scan_fstring(s, k, n, 0); }
    if (c == 34) {
        if (depth == 0) {
            Int k = i + 1;
            return k;
        }
    }
    Int k = i + 1;
    return scan_fstring(s, k, n, depth);
}

// ─── Token model ────────────────────────────────────────────────

type Tok = { pos: Int, text: Str, kind: Str };

Tok lex_op2(Str s, Int pos, Int n) {
    Int c = char_at(s, pos);
    Int c2 = char_next(s, pos);
    Int c3 = char_next2(s, pos);
    if (c == 46) {
        if (c2 == 46) {
            if (c3 == 61) {
                Int k = pos + 3;
                return Tok { pos: k, text: "..=", kind: "op" };
            }
            Int k = pos + 2;
            return Tok { pos: k, text: "..", kind: "op" };
        }
        Int k = pos + 1;
        return Tok { pos: k, text: ".", kind: "op" };
    }
    if (c == 60) {
        if (c2 == 60) {
            Int k = pos + 2;
            return Tok { pos: k, text: "<<", kind: "op" };
        }
        if (c2 == 61) {
            Int k = pos + 2;
            return Tok { pos: k, text: "<=", kind: "op" };
        }
        Int k = pos + 1;
        return Tok { pos: k, text: "<", kind: "op" };
    }
    if (c == 62) {
        if (c2 == 62) {
            Int k = pos + 2;
            return Tok { pos: k, text: ">>", kind: "op" };
        }
        if (c2 == 61) {
            Int k = pos + 2;
            return Tok { pos: k, text: ">=", kind: "op" };
        }
        Int k = pos + 1;
        return Tok { pos: k, text: ">", kind: "op" };
    }
    if (c == 61) {
        if (c2 == 61) {
            Int k = pos + 2;
            return Tok { pos: k, text: "==", kind: "op" };
        }
        if (c2 == 62) {
            Int k = pos + 2;
            return Tok { pos: k, text: "=>", kind: "op" };
        }
        Int k = pos + 1;
        return Tok { pos: k, text: "=", kind: "op" };
    }
    if (c == 33) {
        if (c2 == 61) {
            Int k = pos + 2;
            return Tok { pos: k, text: "!=", kind: "op" };
        }
        Int k = pos + 1;
        return Tok { pos: k, text: "!", kind: "op" };
    }
    if (c == 38) {
        if (c2 == 38) {
            Int k = pos + 2;
            return Tok { pos: k, text: "&&", kind: "op" };
        }
        Int k = pos + 1;
        return Tok { pos: k, text: "&", kind: "op" };
    }
    if (c == 124) {
        if (c2 == 124) {
            Int k = pos + 2;
            return Tok { pos: k, text: "||", kind: "op" };
        }
        Int k = pos + 1;
        return Tok { pos: k, text: "|", kind: "op" };
    }
    if (c == 43) {
        Int k = pos + 1;
        return Tok { pos: k, text: "+", kind: "op" };
    }
    if (c == 45) {
        Int k = pos + 1;
        return Tok { pos: k, text: "-", kind: "op" };
    }
    if (c == 42) {
        Int k = pos + 1;
        return Tok { pos: k, text: "*", kind: "op" };
    }
    if (c == 47) {
        Int k = pos + 1;
        return Tok { pos: k, text: "/", kind: "op" };
    }
    if (c == 37) {
        Int k = pos + 1;
        return Tok { pos: k, text: "%", kind: "op" };
    }
    if (c == 126) {
        Int k = pos + 1;
        return Tok { pos: k, text: "~", kind: "op" };
    }
    if (c == 94) {
        Int k = pos + 1;
        return Tok { pos: k, text: "^", kind: "op" };
    }
    if (c == 63) {
        Int k = pos + 1;
        return Tok { pos: k, text: "?", kind: "op" };
    }
    if (c == 58) {
        Int k = pos + 1;
        return Tok { pos: k, text: ":", kind: "op" };
    }
    if (c == 44) {
        Int k = pos + 1;
        return Tok { pos: k, text: ",", kind: "op" };
    }
    if (c == 59) {
        Int k = pos + 1;
        return Tok { pos: k, text: ";", kind: "op" };
    }
    if (c == 40) {
        Int k = pos + 1;
        return Tok { pos: k, text: "(", kind: "op" };
    }
    if (c == 41) {
        Int k = pos + 1;
        return Tok { pos: k, text: ")", kind: "op" };
    }
    if (c == 123) {
        Int k = pos + 1;
        return Tok { pos: k, text: "{", kind: "op" };
    }
    if (c == 125) {
        Int k = pos + 1;
        return Tok { pos: k, text: "}", kind: "op" };
    }
    if (c == 91) {
        Int k = pos + 1;
        return Tok { pos: k, text: "[", kind: "op" };
    }
    if (c == 93) {
        Int k = pos + 1;
        return Tok { pos: k, text: "]", kind: "op" };
    }
    Int k = pos + 1;
    return Tok { pos: k, text: "", kind: "op" };
}

Tok lex_tok(Str s, Int pos) {
    Int n = str_len_1(s);
    Int j = skip_all(s, pos, n);
    if (j >= n) {
        return Tok { pos: j, text: "", kind: "eof" };
    }
    Int c = char_at(s, j);
    Int c2 = char_next(s, j);
    if (c == 102) {
        if (c2 == 34) {
            Int k = j + 2;
            Int end = scan_fstring(s, k, n, 0);
            Str text = str_slice(s, j, end);
            return Tok { pos: end, text: text, kind: "fstring" };
        }
    }
    if (c == 114) {
        if (c2 == 34) {
            Int k = j + 2;
            Int end = scan_string(s, k, n);
            Str text = str_slice(s, j, end);
            return Tok { pos: end, text: text, kind: "raw" };
        }
    }
    if (c == 98) {
        if (c2 == 34) {
            Int k = j + 2;
            Int end = scan_string(s, k, n);
            Str text = str_slice(s, j, end);
            return Tok { pos: end, text: text, kind: "bytes" };
        }
    }
    if (c == 34) {
        Int k = j + 1;
        Int end = scan_string(s, k, n);
        Str text = str_slice(s, j, end);
        return Tok { pos: end, text: text, kind: "str" };
    }
    if (c == 39) {
        Int k = j + 3;
        Str text = str_slice(s, j, k);
        return Tok { pos: k, text: text, kind: "char" };
    }
    if (is_digit(c)) {
        if (c == 48) {
            if (c2 == 120) {
                Int k = j + 2;
                Int e = scan_digits(s, k, n, 16);
                Str text = str_slice(s, j, e);
                return Tok { pos: e, text: text, kind: "int" };
            }
            if (c2 == 98) {
                Int k = j + 2;
                Int e = scan_digits(s, k, n, 2);
                Str text = str_slice(s, j, e);
                return Tok { pos: e, text: text, kind: "int" };
            }
            if (c2 == 111) {
                Int k = j + 2;
                Int e = scan_digits(s, k, n, 8);
                Str text = str_slice(s, j, e);
                return Tok { pos: e, text: text, kind: "int" };
            }
        }
        Int e = scan_digits(s, j, n, 10);
        Int cdot = char_at(s, e);
        Int cdot2 = char_next(s, e);
        if (cdot == 46) {
            if (cdot2 != 46) {
                Int k = e + 1;
                Int ef = scan_digits(s, k, n, 10);
                Str text = str_slice(s, j, ef);
                return Tok { pos: ef, text: text, kind: "float" };
            }
        }
        Str text = str_slice(s, j, e);
        return Tok { pos: e, text: text, kind: "int" };
    }
    if (is_alpha(c)) {
        Int e = scan_ident(s, j, n);
        Str text = str_slice(s, j, e);
        return Tok { pos: e, text: text, kind: "ident" };
    }
    if (c == 95) {
        Int e = scan_ident(s, j, n);
        Str text = str_slice(s, j, e);
        return Tok { pos: e, text: text, kind: "ident" };
    }
    if (c == 35) {
        Int k = j + 8;
        return Tok { pos: k, text: "#location", kind: "op" };
    }
    if (c == 64) {
        Int k = j + 1;
        return Tok { pos: k, text: "@", kind: "op" };
    }
    return lex_op2(s, j, n);
}
// ─── Shared result types ───────────────────────────────────────

type PRes = { pos: Int, ty: Str, err: Str };

type Funcs = { names: List(Str), pts: List(Str), pns: List(Str), rets: List(Str), stn: List(Str), stf: List(Str) };

Funcs funcs_empty() {
    return Funcs { names: [], pts: [], pns: [], rets: [], stn: [], stf: [] };
}

List(Str) nil_list() {
    Funcs f = funcs_empty();
    return f.names;
}

Int str_find_char(Str s, Int c, Int i) {
    Int n = str_len(s);
    if (i >= n) { return -1; }
    Int ch = str_char_at(s, i);
    if (ch == c) { return i; }
    Int k = i + 1;
    return str_find_char(s, c, k);
}

// ─── Signatures: names, llvm param types, param names, ret types ──

PRes parse_type(Str s, Int pos) {
    Tok t = lex_tok(s, pos);
    if (t.kind != "ident") {
        return PRes { pos: t.pos, ty: "", err: "expected a type name" };
    }
    Tok t2 = lex_tok(s, t.pos);
    if (t2.text == "(") {
        PRes inner = parse_type(s, t2.pos);
        if (inner.err != "") {
            return PRes { pos: inner.pos, ty: "", err: inner.err };
        }
        Tok close = lex_tok(s, inner.pos);
        if (close.text != ")") {
            return PRes { pos: close.pos, ty: "", err: "expected ) in type" };
        }
        Str ty = t.text + "(" + inner.ty + ")";
        return PRes { pos: close.pos, ty: ty, err: "" };
    }
    return PRes { pos: t.pos, ty: t.text, err: "" };
}

Str ll_ty(Str ty) {
    if (ty == "Int") { return "i64"; }
    if (ty == "Bool") { return "i1"; }
    if (ty == "Float") { return "double"; }
    if (ty == "Str") { return "ptr"; }
    return "ptr";
}

Int skip_decl(Str s, Int pos, Int depth) {
    Tok t = lex_tok(s, pos);
    if (t.kind == "eof") { return t.pos; }
    if (t.text == "{") {
        Int d1 = depth + 1;
        return skip_decl(s, t.pos, d1);
    }
    if (t.text == "}") {
        if (depth <= 1) { return t.pos; }
        Int d2 = depth - 1;
        return skip_decl(s, t.pos, d2);
    }
    return skip_decl(s, t.pos, depth);
}

Int skip_body(Str s, Int pos) {
    return skip_decl(s, pos, 0);
}

Int close_paren(Str s, Int pos) {
    return close_paren_d(s, pos, 0);
}

Int close_paren_d(Str s, Int pos, Int depth) {
    Tok t = lex_tok(s, pos);
    if (t.text == "(") {
        Int d1 = depth + 1;
        return close_paren_d(s, t.pos, d1);
    }
    if (t.text == ")") {
        if (depth <= 0) { return t.pos; }
        Int d2 = depth - 1;
        return close_paren_d(s, t.pos, d2);
    }
    if (t.kind == "eof") { return t.pos; }
    return close_paren_d(s, t.pos, depth);
}

Tok skip_close_tok(Str s, Int pos, Int depth) {    Tok t = lex_tok(s, pos);
    if (t.kind == "eof") { return t; }
    if (t.text == "{") {
        Int d1 = depth + 1;
        return skip_close_tok(s, t.pos, d1);
    }
    if (t.text == "}") {
        if (depth <= 1) { return t; }
        Int d2 = depth - 1;
        return skip_close_tok(s, t.pos, d2);
    }
    return skip_close_tok(s, t.pos, depth);
}

Str collect_ptypes(Str s, Int pos, Str acc) {
    PRes pty = parse_type(s, pos);
    if (pty.err != "") { return ""; }
    Str sep = if (acc != "") { ", " } else { "" };
    Str acc2 = acc + sep + pty.ty;
    Tok name = lex_tok(s, pty.pos);
    Tok t = lex_tok(s, name.pos);
    if (t.text == ",") {
        return collect_ptypes(s, t.pos, acc2);
    }
    return acc2;
}

Str collect_pnames(Str s, Int pos, Str acc) {
    PRes pty = parse_type(s, pos);
    if (pty.err != "") { return ""; }
    Tok name = lex_tok(s, pty.pos);
    Str sep = if (acc != "") { "," } else { "" };
    Str acc2 = acc + sep + name.text;
    Tok t = lex_tok(s, name.pos);
    if (t.text == ",") {
        return collect_pnames(s, t.pos, acc2);
    }
    return acc2;
}

Funcs collect_sigs_at(Str s, Int pos, Funcs fs) {
    Tok t = lex_tok(s, pos);
    if (t.kind == "eof") { return fs; }
    if (t.text == "type") {
        Tok tnm = lex_tok(s, t.pos);
        Tok teq = lex_tok(s, tnm.pos);
        Tok tob = lex_tok(s, teq.pos);
        if (tob.text != "{") {
            Int end0 = skip_decl(s, t.pos, 0);
            return collect_sigs_at(s, end0, fs);
        }
        PRes fl = collect_fields_at(s, tob.pos, "");
        if (fl.err != "") {
            return collect_sigs_at(s, fl.pos, fs);
        }
        List(Str) sn0 = fs.stn;
        List(Str) sf0 = fs.stf;
        Funcs fs2 = Funcs { names: fs.names, pts: fs.pts, pns: fs.pns, rets: fs.rets, stn: sn0.concat([tnm.text]), stf: sf0.concat([fl.ty]) };
        return collect_sigs_at(s, fl.pos, fs2);
    }
    if (t.text == "import") {
        Int end = skip_decl(s, t.pos, 0);
        return collect_sigs_at(s, end, fs);
    }
    if (t.text == "pub") {
        // The declaration starts right after `pub`; re-dispatch there.
        Tok nx = lex_tok(s, t.pos);
        if (nx.kind == "ident") {
            PRes prty = parse_type(s, t.pos);
            if (prty.err == "") {
                Tok nname = lex_tok(s, prty.pos);
                Tok nopen = lex_tok(s, nname.pos);
                if (nopen.text == "(") {
                    return collect_sigs_at(s, t.pos, fs);
                }
            }
        }
        Int endp = skip_decl(s, t.pos, 0);
        return collect_sigs_at(s, endp, fs);
    }
    if (t.kind == "ident") {
        PRes rty = parse_type(s, pos);
        if (rty.err == "") {
            Tok name = lex_tok(s, rty.pos);
            Tok open = lex_tok(s, name.pos);
            if (open.text == "(") {
                Tok first = lex_tok(s, open.pos);
                Str pts = collect_ptypes(s, open.pos, "");
                Str pns = collect_pnames(s, open.pos, "");
                List(Str) nm1 = fs.names;
                List(Str) pt1 = fs.pts;
                List(Str) pn1 = fs.pns;
                List(Str) rt1 = fs.rets;
                List(Str) n2 = nm1.concat([name.text]);
                List(Str) p2 = pt1.concat([pts]);
                List(Str) q2 = pn1.concat([pns]);
                List(Str) r2 = rt1.concat([rty.ty]);
                List(Str) sn1 = fs.stn;
                List(Str) sf1 = fs.stf;
                Funcs fs2 = Funcs { names: n2, pts: p2, pns: q2, rets: r2, stn: sn1, stf: sf1 };
                Int end = skip_body(s, open.pos);
                return collect_sigs_at(s, end, fs2);
            }
        }
    }
    return collect_sigs_at(s, t.pos, fs);
}

Funcs collect_sigs(Str s) {
    return collect_sigs_at(s, 0, funcs_empty());
}

// ─── Environment: List(Str) of "name:val:ty" entries ───────────

Str env_lookup_at(List(Str) env, Str name, Int i) {
    if (i >= env.len()) { return ""; }
    Str elem = env[i];
    Int colon = str_find_char(elem, 58, 0);
    Str head = str_slice(elem, 0, colon);
    if (head == name) { return elem; }
    Int k = i + 1;
    return env_lookup_at(env, name, k);
}

Str env_lookup_rev(List(Str) env, Str name, Int i) {
    if (i < 0) { return ""; }
    Str elem = env[i];
    Int c1 = str_find_char(elem, 58, 0);
    Str head = str_slice(elem, 0, c1);
    if (head == name) { return elem; }
    Int k = i - 1;
    return env_lookup_rev(env, name, k);
}

Str env_lookup(List(Str) env, Str name) {
    Int n = env.len();
    Int last = n - 1;
    return env_lookup_rev(env, name, last);
}

List(Str) env_add(List(Str) env, Str entry) {
    return env.concat([entry]);
}
// ─── Expression codegen: threaded register/label state ─────────

type GT = { pos: Int, val: Str, ty: Str, cnt: Int, err: Str, glines: List(Str), lines: List(Str), tmp: Int, lbl: Int };

Int fn_index_at(Funcs f, Str name, Int i) {
    List(Str) ns = f.names;
    Int n = ns.len();
    if (i >= n) { return -1; }
    Str cur = ns[i];
    if (cur == name) { return i; }
    Int k = i + 1;
    return fn_index_at(f, name, k);
}

Int fn_index(Funcs f, Str name) {
    return fn_index_at(f, name, 0);
}

Int struct_index_at(Funcs f, Str name, Int i) {
    List(Str) ns = f.stn;
    Int n = ns.len();
    if (i >= n) { return -1; }
    Str cur = ns[i];
    if (cur == name) { return i; }
    Int k = i + 1;
    return struct_index_at(f, name, k);
}

Int struct_index(Funcs f, Str name) {
    return struct_index_at(f, name, 0);
}

PRes collect_fields_at(Str s, Int pos, Str acc) {
    Tok t = lex_tok(s, pos);
    if (t.text == "}") { return PRes { pos: t.pos, ty: acc, err: "" }; }
    if (t.kind == "eof") { return PRes { pos: t.pos, ty: "", err: "unterminated struct" }; }
    Tok colon = lex_tok(s, t.pos);
    PRes fty = parse_type(s, colon.pos);
    if (fty.err != "") { return fty; }
    Str sep = if (acc == "") { "" } else { "," };
    Str acc2 = acc + sep + t.text + ":" + fty.ty;
    Tok comma = lex_tok(s, fty.pos);
    if (comma.text == ",") { return collect_fields_at(s, comma.pos, acc2); }
    return PRes { pos: comma.pos, ty: acc2, err: "" };
}

Int field_slot_at(Str fields, Str fname, Int i, Int slot) {
    Int fl = str_len_1(fields);
    if (i >= fl) { return -1; }
    Int ce = str_find_char(fields, 44, i);
    Int end = if (ce >= 0) { ce } else { fl };
    Str ent = str_slice(fields, i, end);
    Int co = str_find_char(ent, 58, 0);
    Str nm = str_slice(ent, 0, co);
    Int nxt = end + 1;
    if (nm == fname) { return slot; }
    Int sl1 = slot + 1;
    return field_slot_at(fields, fname, nxt, sl1);
}

Int field_slot(Str fields, Str fname) {
    return field_slot_at(fields, fname, 0, 0);
}

Str field_ty_at(Str fields, Str fname, Int i) {
    Int fl = str_len_1(fields);
    if (i >= fl) { return ""; }
    Int ce = str_find_char(fields, 44, i);
    Int end = if (ce >= 0) { ce } else { fl };
    Str ent = str_slice(fields, i, end);
    Int co = str_find_char(ent, 58, 0);
    Str nm = str_slice(ent, 0, co);
    Int nxt = end + 1;
    if (nm == fname) {
        Int cop = co + 1;
        Int el = str_len_1(ent);
        return str_slice(ent, cop, el);
    }
    return field_ty_at(fields, fname, nxt);
}

Str field_ty(Str fields, Str fname) {
    return field_ty_at(fields, fname, 0);
}

Int struct_nfields(Str fields) {
    if (fields == "") { return 0; }
    Int n = count_seps(fields, 0, ",");
    return n + 1;
}

Str elem_type(Str ty) {
    Int tl = str_len_1(ty);
    Int te = tl - 1;
    return str_slice(ty, 5, te);
}

Int op_prec(Str op) {
    if (op == "*") { return 7; }
    if (op == "/") { return 7; }
    if (op == "%") { return 7; }
    if (op == "+") { return 6; }
    if (op == "-") { return 6; }
    if (op == "<<") { return 5; }
    if (op == ">>") { return 5; }
    if (op == "<") { return 4; }
    if (op == "<=") { return 4; }
    if (op == ">") { return 4; }
    if (op == ">=") { return 4; }
    if (op == "==") { return 3; }
    if (op == "!=") { return 3; }
    if (op == "&") { return 2; }
    if (op == "|") { return 2; }
    if (op == "^") { return 2; }
    if (op == "&&") { return 1; }
    if (op == "||") { return 1; }
    return 0;
}

GT bin_icmp(Str cc, GT l, GT r) {
    Int t1 = r.tmp + 1;
    Str reg = "%t" + IntToString(t1);
    Str line = reg + " = icmp " + cc + " i64 " + l.val + ", " + r.val;
    List(Str) l20 = r.lines;
    List(Str) l2 = l20.concat([line]);
    return GT { pos: r.pos, val: reg, ty: "Bool", cnt: 0, err: "", glines: r.glines, lines: l2, tmp: t1, lbl: r.lbl };
}

GT bin_eq(Str op, GT l, GT r) {
    if (l.ty == "Str") {
        Int t1 = r.tmp + 1;
        Int t2 = r.tmp + 2;
        Str cr = "%t" + IntToString(t1);
        Str reg = "%t" + IntToString(t2);
        Str cc = if (op == "==") { "ne" } else { "eq" };
        List(Str) w0 = r.lines;
        List(Str) w1 = w0.concat([cr + " = call i8 @resid_str_eq(ptr " + l.val + ", ptr " + r.val + ")"]);
        List(Str) w2 = w1.concat([reg + " = icmp " + cc + " i8 " + cr + ", 0"]);
        return GT { pos: r.pos, val: reg, ty: "Bool", cnt: 0, err: "", glines: r.glines, lines: w2, tmp: t2, lbl: r.lbl };
    }
    Str cc2 = if (op == "==") { "eq" } else { "ne" };
    return bin_icmp(cc2, l, r);
}

GT bin_arith(Str ins, GT l, GT r) {
    Int t1 = r.tmp + 1;
    Str reg = "%t" + IntToString(t1);
    Str line = reg + " = " + ins + " i64 " + l.val + ", " + r.val;
    List(Str) l20 = r.lines;
    List(Str) l2 = l20.concat([line]);
    return GT { pos: r.pos, val: reg, ty: "Int", cnt: 0, err: "", glines: r.glines, lines: l2, tmp: t1, lbl: r.lbl };
}

GT bin_logic(Str ins, GT l, GT r) {
    Int t1 = r.tmp + 1;
    Str reg = "%t" + IntToString(t1);
    Str line = reg + " = " + ins + " i1 " + l.val + ", " + r.val;
    List(Str) l20 = r.lines;
    List(Str) l2 = l20.concat([line]);
    return GT { pos: r.pos, val: reg, ty: "Bool", cnt: 0, err: "", glines: r.glines, lines: l2, tmp: t1, lbl: r.lbl };
}

GT bin_apply(Str op, GT l, GT r) {
    if (op == "+") {
        if (l.ty == "Str") {
            Int t1 = r.tmp + 1;
            Str reg = "%t" + IntToString(t1);
            Str line = reg + " = call ptr @resid_str_concat(ptr " + l.val + ", ptr " + r.val + ")";
            List(Str) l20 = r.lines;
            List(Str) l2 = l20.concat([line]);
            return GT { pos: r.pos, val: reg, ty: "Str", cnt: 0, err: "", glines: r.glines, lines: l2, tmp: t1, lbl: r.lbl };
        }
        return bin_arith("add", l, r);
    }
    if (op == "-") { return bin_arith("sub", l, r); }
    if (op == "*") { return bin_arith("mul", l, r); }
    if (op == "/") { return bin_arith("sdiv", l, r); }
    if (op == "%") { return bin_arith("srem", l, r); }
    if (op == "<<") { return bin_arith("shl", l, r); }
    if (op == ">>") { return bin_arith("lshr", l, r); }
    if (op == "&") {
        if (l.ty == "Bool") { return bin_logic("and", l, r); }
        return bin_arith("and", l, r);
    }
    if (op == "|") {
        if (l.ty == "Bool") { return bin_logic("or", l, r); }
        return bin_arith("or", l, r);
    }
    if (op == "^") {
        if (l.ty == "Bool") { return bin_logic("xor", l, r); }
        return bin_arith("xor", l, r);
    }
    if (op == "&&") { return bin_logic("and", l, r); }
    if (op == "||") { return bin_logic("or", l, r); }
    if (op == "<") { return bin_icmp("slt", l, r); }
    if (op == "<=") { return bin_icmp("sle", l, r); }
    if (op == ">") { return bin_icmp("sgt", l, r); }
    if (op == ">=") { return bin_icmp("sge", l, r); }
    if (op == "==") { return bin_eq(op, l, r); }
    if (op == "!=") { return bin_eq(op, l, r); }
    return gt_err("unsupported operator " + op, r);
}

Int dec_esc(Int c) {
    if (c == 110) { return 10; }
    if (c == 116) { return 9; }
    if (c == 114) { return 13; }
    if (c == 48) { return 0; }
    return c;
}

Str ir_esc(Int ch) {
    if (ch == 34) { return str_from_code(92) + "22"; }
    if (ch == 92) { return str_from_code(92) + "5C"; }
    if (ch == 10) { return str_from_code(92) + "0A"; }
    if (ch == 9) { return str_from_code(92) + "09"; }
    if (ch == 13) { return str_from_code(92) + "0D"; }
    return str_from_code(ch);
}

Int ll_bytes(Str s, Int i, Int acc) {
    Int n = str_len_1(s);
    if (i >= n) { return acc; }
    Int c = char_at(s, i);
    if (c == 92) {
        Int k = i + 3;
        Int a = acc + 1;
        return ll_bytes(s, k, a);
    }
    Int k2 = i + 1;
    Int a2 = acc + 1;
    return ll_bytes(s, k2, a2);
}

Str esc_ll(Str s, Int i, Str acc) {
    if (i >= str_len_1(s)) { return acc; }
    Int c = str_char_at(s, i);
    Int k = i + 1;
    if (c == 92) {
        Int n = str_char_at(s, k);
        Int k2 = k + 1;
        return esc_ll(s, k2, acc + ir_esc(dec_esc(n)));
    }
    return esc_ll(s, k, acc + ir_esc(c));
}

GT gt_err(Str msg, GT c) {
    return GT { pos: c.pos, val: "", ty: "", cnt: 0, err: msg, glines: c.glines, lines: c.lines, tmp: c.tmp, lbl: c.lbl };
}

GT cg_args(Str s, Int pos, Str acc, Int count, List(Str) env, Funcs fs, GT c) {
    Tok t = lex_tok(s, pos);
    if (t.text == ")") {
        return GT { pos: t.pos, val: acc, ty: "", cnt: count, err: "", glines: c.glines, lines: c.lines, tmp: c.tmp, lbl: c.lbl };
    }
    GT v = cg_expr(s, pos, env, fs, c);
    if (v.err != "") { return v; }
    Str sep = if (acc != "") { ", " } else { "" };
    Str acc2 = acc + sep + ll_ty(v.ty) + " " + v.val;
    Int c2 = count + 1;
    Tok comma = lex_tok(s, v.pos);
    GT cs = GT { pos: comma.pos, val: acc2, ty: "", cnt: c2, err: "", glines: v.glines, lines: v.lines, tmp: v.tmp, lbl: v.lbl };
    if (comma.text == ",") {
        return cg_args(s, comma.pos, acc2, c2, env, fs, cs);
    }
    return cs;
}

GT cg_externb2(Str s, Int pos, Str sym, Str aty1, Str aty2, List(Str) env, Funcs fs, GT c) {
    GT a = cg_expr(s, pos, env, fs, c);
    if (a.err != "") { return a; }
    Tok cm = lex_tok(s, a.pos);
    if (cm.text != ",") { return gt_err("expected , in call to " + sym, a); }
    GT b = cg_expr(s, cm.pos, env, fs, a);
    if (b.err != "") { return b; }
    Tok cp = lex_tok(s, b.pos);
    if (cp.text != ")") { return gt_err("expected ) in call to " + sym, b); }
    Int t1 = b.tmp + 1;
    Int t2 = b.tmp + 2;
    Str cr = "%t" + IntToString(t1);
    Str reg = "%t" + IntToString(t2);
    Str cl = cr + " = call i8 @" + sym + "(" + ll_ty(aty1) + " " + a.val + ", " + ll_ty(aty2) + " " + b.val + ")";
    Str nl = reg + " = icmp ne i8 " + cr + ", 0";
    List(Str) w0 = b.lines;
    List(Str) w1 = w0.concat([cl]);
    List(Str) w2 = w1.concat([nl]);
    return GT { pos: cp.pos, val: reg, ty: "Bool", cnt: 0, err: "", glines: b.glines, lines: w2, tmp: t2, lbl: b.lbl };
}

Bool cg_arith_family(Str name) {
    if (str_starts_with(name, "checked_")) { return true; }
    if (str_starts_with(name, "wrapping_")) { return true; }
    if (str_starts_with(name, "saturating_")) { return true; }
    return false;
}
GT cg_call(Str s, Int pos, Str name, List(Str) env, Funcs fs, GT c) {
    Tok t = lex_tok(s, pos);
    if (t.text == ")") {
        Int idx0 = fn_index(fs, name);
        if (idx0 < 0) { return gt_err("unknown function " + name, c); }
        List(Str) rts0 = fs.rets;
        Str rraw0 = rts0[idx0];
        Int t1 = c.tmp + 1;
        Str reg = "%t" + IntToString(t1);
        Str line = reg + " = call " + ll_ty(rraw0) + " @" + name + "()";
        List(Str) lc0 = c.lines;
        List(Str) cl = lc0.concat([line]);
        return GT { pos: t.pos, val: reg, ty: rraw0, cnt: 0, err: "", glines: c.glines, lines: cl, tmp: t1, lbl: c.lbl };
    }
    GT a = cg_args(s, pos, "", 0, env, fs, c);
    if (a.err != "") { return a; }
    Int idx = fn_index(fs, name);
    if (idx < 0) {
        if (cg_arith_family(name)) {
            Int t1 = a.tmp + 1;
            Str reg = "%t" + IntToString(t1);
            Str line = reg + " = call i64 @" + name + "(" + a.val + ")";
            List(Str) l20 = a.lines;
            List(Str) l2 = l20.concat([line]);
            return GT { pos: a.pos, val: reg, ty: "Int", cnt: 0, err: "", glines: a.glines, lines: l2, tmp: t1, lbl: a.lbl };
        }
        return gt_err("unknown function " + name, a);
    }
    List(Str) rts = fs.rets;
    Str rraw = rts[idx];
    Str rty = ll_ty(rraw);
    Int t1 = a.tmp + 1;
    Str reg = "%t" + IntToString(t1);
    Str line = reg + " = call " + rty + " @" + name + "(" + a.val + ")";
    List(Str) la0 = a.lines;
    List(Str) cl2 = la0.concat([line]);
    return GT { pos: a.pos, val: reg, ty: rraw, cnt: a.cnt, err: "", glines: a.glines, lines: cl2, tmp: t1, lbl: a.lbl };
}

GT cg_print(Str s, Int pos, Str name, List(Str) env, Funcs fs, GT c) {
    Tok open = lex_tok(s, pos);
    GT v = cg_expr(s, pos, env, fs, c);
    if (v.err != "") { return v; }
    Tok close = lex_tok(s, v.pos);
    Str line = if (name == "println") { "call i32 @puts(ptr " + v.val + ")" } else { "call i32 (ptr, ...) @printf(ptr @.fmt.p, ptr " + v.val + ")" };
    List(Str) lp0 = v.lines;
    List(Str) pl = lp0.concat([line]);
    return GT { pos: close.pos, val: "", ty: "", cnt: 1, err: "", glines: v.glines, lines: pl, tmp: v.tmp, lbl: v.lbl };
}

GT cg_primary(Str s, Int pos, List(Str) env, Funcs fs, GT c) {
    Tok t = lex_tok(s, pos);
    if (t.kind == "int") {
        return GT { pos: t.pos, val: t.text, ty: "Int", cnt: 0, err: "", glines: c.glines, lines: c.lines, tmp: c.tmp, lbl: c.lbl };
    }
    if (t.kind == "str") {
        Int t1 = c.tmp + 1;
        Str nm = "@.s" + IntToString(t1);
        Int tl = str_len_1(t.text);
        Int te = tl - 1;
        Str inner = str_slice(t.text, 1, te);
        Str body = esc_ll(inner, 0, "");
        Int bl = ll_bytes(body, 0, 0);
        Int n1 = bl + 1;
        Str g = nm + " = private unnamed_addr constant [" + IntToString(n1) + " x i8] c\"" + body + "\\00\"";
        List(Str) gg0 = c.glines;
        List(Str) gl = gg0.concat([g]);
        return GT { pos: t.pos, val: nm, ty: "Str", cnt: 0, err: "", glines: gl, lines: c.lines, tmp: t1, lbl: c.lbl };
    }
    if (t.text == "true" || t.text == "false") {
        return GT { pos: t.pos, val: t.text, ty: "Bool", cnt: 0, err: "", glines: c.glines, lines: c.lines, tmp: c.tmp, lbl: c.lbl };
    }
    if (t.kind == "fstring") {
        return cg_fstring(s, t, env, fs, c);
    }
    if (t.text == "if") {
        return cg_ifexpr(s, t.pos, env, fs, c);
    }
    if (t.kind == "ident") {
        if (t.text == "println" || t.text == "print") {
            Tok tp0 = lex_tok(s, t.pos);
            if (tp0.text == "(") {
                return cg_print(s, tp0.pos, t.text, env, fs, c);
            }
        }
        Tok t2 = lex_tok(s, t.pos);
        if (t2.text == "{") {
            Int si0 = struct_index(fs, t.text);
            if (si0 >= 0) {
                return cg_struct_lit(s, t2.pos, t.text, env, fs, c);
            }
        }
        if (t2.text == "(") {
            if (t.text == "str_char_at") {
                return cg_extern2(s, t2.pos, "str_char_at", "Str", "Int", "Int", env, fs, c);
            }
            if (t.text == "str_from_code") {
                return cg_extern1(s, t2.pos, "str_from_code", "Int", "Str", env, fs, c);
            }
            if (t.text == "str_len") {
                return cg_extern1(s, t2.pos, "str_len", "Str", "Int", env, fs, c);
            }
            if (t.text == "str_slice") {
                return cg_extern3(s, t2.pos, "str_slice", "Str", "Int", "Int", "Str", env, fs, c);
            }
            if (t.text == "IntToString") {
                GT v = cg_expr(s, t2.pos, env, fs, c);
                if (v.err != "") { return v; }
                Tok cpit = lex_tok(s, v.pos);
                if (cpit.text != ")") { return gt_err("expected ) in IntToString", v); }
                Int ti1 = v.tmp + 1;
                Int ti2 = v.tmp + 2;
                Str buf = "%t" + IntToString(ti1);
                Str reg = "%t" + IntToString(ti2);
                List(Str) x0 = v.lines;
                List(Str) x1 = x0.concat([buf + " = alloca [24 x i8]"]);
                List(Str) x2 = x1.concat([reg + " = call ptr @e.itoa(ptr " + buf + ", i64 " + v.val + ")"]);
                return GT { pos: cpit.pos, val: reg, ty: "Str", cnt: 0, err: "", glines: v.glines, lines: x2, tmp: ti2, lbl: v.lbl };
            }
            if (t.text == "resid_crypto_random_byte") {
                GT a0 = cg_expr(s, t2.pos, env, fs, c);
                if (a0.err != "") { return a0; }
                Tok cpr = lex_tok(s, a0.pos);
                if (cpr.text != ")") { return gt_err("expected ) in resid_crypto_random_byte", a0); }
                Int tr1 = a0.tmp + 1;
                Str rreg = "%t" + IntToString(tr1);
                List(Str) rl0 = a0.lines;
                List(Str) rl1 = rl0.concat([rreg + " = call i64 @resid_crypto_random_byte()"]);
                return GT { pos: cpr.pos, val: rreg, ty: "Int", cnt: 0, err: "", glines: a0.glines, lines: rl1, tmp: tr1, lbl: a0.lbl };
            }
            if (t.text == "str_trim") {
                return cg_extern1(s, t2.pos, "str_trim", "Str", "Str", env, fs, c);
            }
            if (t.text == "str_to_lower") {
                return cg_extern1(s, t2.pos, "str_to_lower", "Str", "Str", env, fs, c);
            }
            if (t.text == "str_to_upper") {
                return cg_extern1(s, t2.pos, "str_to_upper", "Str", "Str", env, fs, c);
            }
            if (t.text == "str_reverse") {
                return cg_extern1(s, t2.pos, "str_reverse", "Str", "Str", env, fs, c);
            }
            if (t.text == "str_contains") {
                return cg_externb2(s, t2.pos, "str_contains", "Str", "Str", env, fs, c);
            }
            if (t.text == "str_starts_with") {
                return cg_externb2(s, t2.pos, "str_starts_with", "Str", "Str", env, fs, c);
            }
            if (t.text == "str_ends_with") {
                return cg_externb2(s, t2.pos, "str_ends_with", "Str", "Str", env, fs, c);
            }
            if (t.text == "str_repeat") {
                return cg_extern2(s, t2.pos, "str_repeat", "Str", "Int", "Str", env, fs, c);
            }
            if (t.text == "str_replace") {
                return cg_extern3(s, t2.pos, "str_replace", "Str", "Str", "Str", "Str", env, fs, c);
            }
            if (t.text == "str_split") {
                return cg_extern2(s, t2.pos, "bl_str_split", "Str", "Str", "List(Str)", env, fs, c);
            }
            if (t.text == "str_join") {
                return cg_extern2(s, t2.pos, "bl_str_join", "List(Str)", "Str", "Str", env, fs, c);
            }
            if (t.text == "str_is_int") {
                return cg_externb1(s, t2.pos, "str_is_int", "Str", env, fs, c);
            }
            if (t.text == "str_parse_int") {
                return cg_extern1(s, t2.pos, "str_parse_int", "Str", "Int", env, fs, c);
            }
            if (t.text == "str_is_float") {
                return cg_externb1(s, t2.pos, "str_is_float", "Str", env, fs, c);
            }
            if (t.text == "str_parse_float") {
                return cg_extern1(s, t2.pos, "str_parse_float", "Str", "Float", env, fs, c);
            }
            if (t.text == "str_count") {
                return cg_extern2(s, t2.pos, "str_count", "Str", "Str", "Int", env, fs, c);
            }
            if (t.text == "abs_i64") {
                return cg_extern1(s, t2.pos, "abs_i64", "Int", "Int", env, fs, c);
            }
            if (t.text == "min_i64") {
                return cg_extern2(s, t2.pos, "min_i64", "Int", "Int", "Int", env, fs, c);
            }
            if (t.text == "max_i64") {
                return cg_extern2(s, t2.pos, "max_i64", "Int", "Int", "Int", env, fs, c);
            }
            if (t.text == "clamp_i64") {
                return cg_extern3(s, t2.pos, "clamp_i64", "Int", "Int", "Int", "Int", env, fs, c);
            }
            if (t.text == "list_sort_ints") {
                return cg_extern1(s, t2.pos, "bl_sort_i64", "List(Int)", "List(Int)", env, fs, c);
            }
            if (t.text == "list_sort_strs") {
                return cg_extern1(s, t2.pos, "bl_sort_str", "List(Str)", "List(Str)", env, fs, c);
            }
            if (t.text == "list_sort_floats") {
                return cg_extern1(s, t2.pos, "bl_sort_f64", "List(Float)", "List(Float)", env, fs, c);
            }
            if (t.text == "list_reverse_ints") {
                return cg_extern1(s, t2.pos, "bl_reverse_i64", "List(Int)", "List(Int)", env, fs, c);
            }
            if (t.text == "list_reverse_strs") {
                return cg_extern1(s, t2.pos, "bl_reverse_str", "List(Str)", "List(Str)", env, fs, c);
            }
            if (t.text == "list_reverse_floats") {
                return cg_extern1(s, t2.pos, "bl_reverse_f64", "List(Float)", "List(Float)", env, fs, c);
            }
            if (t.text == "list_contains_int") {
                return cg_externb2(s, t2.pos, "bl_contains_i64", "List(Int)", "Int", env, fs, c);
            }
            if (t.text == "list_contains_str") {
                return cg_externb2(s, t2.pos, "bl_contains_str", "List(Str)", "Str", env, fs, c);
            }
            if (t.text == "list_contains_float") {
                return cg_externb2(s, t2.pos, "bl_contains_f64", "List(Float)", "Float", env, fs, c);
            }
            if (t.text == "list_sum") {
                return cg_extern1(s, t2.pos, "bl_sum", "List(Int)", "Int", env, fs, c);
            }
            if (t.text == "list_sumf") {
                return cg_extern1(s, t2.pos, "bl_sumf", "List(Float)", "Float", env, fs, c);
            }
            return cg_call(s, t2.pos, t.text, env, fs, c);
        }
        if (t2.text == ".") {
            if (t.text == "args" || t.text == "filesystem" || t.text == "process" || t.text == "environment" || t.text == "git") {
                Str shadow = env_lookup(env, t.text);
                if (shadow == "") {
                    return cg_provider(s, t2.pos, t.text, env, fs, c);
                }
            }
        }
        Str ent = env_lookup(env, t.text);
        if (ent == "") {
            return gt_err("undefined variable " + t.text, c);
        }
        Int c1 = str_find_char(ent, 58, 0);
        Int c1p = c1 + 1;
        Int c2 = str_find_char(ent, 58, c1p);
        Int c2p = c2 + 1;
        Int el = str_len_1(ent);
        Str val = str_slice(ent, c1p, c2);
        Str ty = str_slice(ent, c2p, el);
        return GT { pos: t.pos, val: val, ty: ty, cnt: 0, err: "", glines: c.glines, lines: c.lines, tmp: c.tmp, lbl: c.lbl };
    }
    if (t.text == "(") {
        GT e = cg_expr(s, t.pos, env, fs, c);
        if (e.err != "") { return e; }
        Tok close = lex_tok(s, e.pos);
        return GT { pos: close.pos, val: e.val, ty: e.ty, cnt: 0, err: "", glines: e.glines, lines: e.lines, tmp: e.tmp, lbl: e.lbl };
    }
    if (t.text == "[") {
        GT e0 = cg_expr(s, t.pos, env, fs, c);
        if (e0.err != "") { return e0; }
        return lst_more(s, e0.pos, e0.ty, 1, [e0.val], env, fs, e0);
    }
    if (t.text == "!") {
        GT e = cg_unary(s, t.pos, env, fs, c);
        if (e.err != "") { return e; }
        Int t1 = e.tmp + 1;
        Str reg = "%t" + IntToString(t1);
        Str line = reg + " = xor i1 " + e.val + ", true";
        List(Str) nl0 = e.lines;
        List(Str) nl2 = nl0.concat([line]);
        return GT { pos: e.pos, val: reg, ty: "Bool", cnt: 0, err: "", glines: e.glines, lines: nl2, tmp: t1, lbl: e.lbl };
    }
    if (t.text == "-") {
        GT e = cg_unary(s, t.pos, env, fs, c);
        if (e.err != "") { return e; }
        Int t1 = e.tmp + 1;
        Str reg = "%t" + IntToString(t1);
        Str line = reg + " = sub i64 0, " + e.val;
        List(Str) le0 = e.lines;
        List(Str) nl2 = le0.concat([line]);
        return GT { pos: e.pos, val: reg, ty: "Int", cnt: 0, err: "", glines: e.glines, lines: nl2, tmp: t1, lbl: e.lbl };
    }
    return gt_err("unexpected token " + t.text, c);
}

GT cg_unary(Str s, Int pos, List(Str) env, Funcs fs, GT c) {
    GT b = cg_primary(s, pos, env, fs, c);
    if (b.err != "") { return b; }
    return cg_postfix(s, b, env, fs);
}

GT cg_postfix(Str s, GT base, List(Str) env, Funcs fs) {
    Tok t = lex_tok(s, base.pos);
    if (t.text == ".") {
        Tok fld = lex_tok(s, t.pos);
        Tok lp = lex_tok(s, fld.pos);
        if (lp.text == "(") {
            if (fld.text == "len") {
                Tok rp = lex_tok(s, lp.pos);
                Int t1 = base.tmp + 1;
                Str reg = "%t" + IntToString(t1);
                Str line = reg + " = load i64, ptr " + base.val;
                List(Str) l20 = base.lines;
                List(Str) l2 = l20.concat([line]);
                GT b2 = GT { pos: rp.pos, val: reg, ty: "Int", cnt: 0, err: "", glines: base.glines, lines: l2, tmp: t1, lbl: base.lbl };
                return cg_postfix(s, b2, env, fs);
            }
            if (fld.text == "concat") {
                GT arg = cg_expr(s, lp.pos, env, fs, base);
                if (arg.err != "") { return arg; }
                Tok rp2 = lex_tok(s, arg.pos);
                Int t2 = arg.tmp + 1;
                Str reg2 = "%t" + IntToString(t2);
                Str line2 = reg2 + " = call ptr @e.lconcat(ptr " + base.val + ", ptr " + arg.val + ")";
                List(Str) l30 = arg.lines;
                List(Str) l3 = l30.concat([line2]);
                GT b3 = GT { pos: rp2.pos, val: reg2, ty: base.ty, cnt: 0, err: "", glines: arg.glines, lines: l3, tmp: t2, lbl: arg.lbl };
                return cg_postfix(s, b3, env, fs);
            }
            return gt_err("unsupported method " + fld.text, base);
        }
        Int si = struct_index(fs, base.ty);
        if (si < 0) { return gt_err("field access on non-struct " + base.ty, base); }
        List(Str) stfl = fs.stf;
        Str fields = stfl[si];
        Int slot = field_slot(fields, fld.text);
        if (slot < 0) { return gt_err("unknown field " + fld.text, base); }
        Str fty = field_ty(fields, fld.text);
        Int off = slot * 8;
        Int t1 = base.tmp + 1;
        Int t2 = base.tmp + 2;
        Str gp = "%t" + IntToString(t1);
        Str ld = "%t" + IntToString(t2);
        Str g1 = gp + " = getelementptr i8, ptr " + base.val + ", i64 " + IntToString(off);
        Str g2 = ld + " = load " + ll_ty(fty) + ", ptr " + gp;
        List(Str) l40 = base.lines;
        List(Str) l4 = l40.concat([g1]);
        List(Str) l5 = l4.concat([g2]);
        GT b4 = GT { pos: fld.pos, val: ld, ty: fty, cnt: 0, err: "", glines: base.glines, lines: l5, tmp: t2, lbl: base.lbl };
        return cg_postfix(s, b4, env, fs);
    }
    if (t.text == "[") {
        Int pp = str_find_char(base.ty, 40, 0);
        if (pp < 0) { return gt_err("indexing non-list " + base.ty, base); }
        Str ety = elem_type(base.ty);
        GT ix = cg_expr(s, t.pos, env, fs, base);
        if (ix.err != "") { return ix; }
        Tok close = lex_tok(s, ix.pos);
        Int t1 = ix.tmp + 1;
        Int t2 = ix.tmp + 2;
        Int t3 = ix.tmp + 3;
        Str om = "%t" + IntToString(t1);
        Str oa = "%t" + IntToString(t2);
        Str gp = "%t" + IntToString(t3);
        Int t4 = ix.tmp + 4;
        Str ld = "%t" + IntToString(t4);
        List(Str) l0 = ix.lines;
        List(Str) l1 = l0.concat([om + " = mul i64 8, " + ix.val]);
        List(Str) l2 = l1.concat([oa + " = add i64 " + om + ", 8"]);
        List(Str) l3 = l2.concat([gp + " = getelementptr i8, ptr " + base.val + ", i64 " + oa]);
        List(Str) l4 = l3.concat([ld + " = load " + ll_ty(ety) + ", ptr " + gp]);
        GT b5 = GT { pos: close.pos, val: ld, ty: ety, cnt: 0, err: "", glines: ix.glines, lines: l4, tmp: t4, lbl: ix.lbl };
        return cg_postfix(s, b5, env, fs);
    }
    return base;
}

GT cg_bin_rest(Str s, GT lhs, Int min_prec, List(Str) env, Funcs fs) {
    Tok t = lex_tok(s, lhs.pos);
    Int p = op_prec(t.text);
    if (p < min_prec || p == 0) { return lhs; }
    GT rhs = cg_unary(s, t.pos, env, fs, lhs);
    if (rhs.err != "") { return rhs; }
    Int next = p + 1;
    GT joined = GT { pos: rhs.pos, val: rhs.val, ty: rhs.ty, cnt: rhs.cnt, err: "", glines: rhs.glines, lines: rhs.lines, tmp: rhs.tmp, lbl: rhs.lbl };
    GT more = cg_bin_rest(s, joined, next, env, fs);
    if (more.err != "") { return more; }
    GT applied = bin_apply(t.text, lhs, more);
    return cg_bin_rest(s, applied, min_prec, env, fs);
}

GT cg_expr(Str s, Int pos, List(Str) env, Funcs fs, GT c) {
    GT lhs = cg_unary(s, pos, env, fs, c);
    return cg_bin_rest(s, lhs, 1, env, fs);
}

Str p_sym(Str pname, Str meth) {
    if (pname == "args") {
        if (meth == "count") { return "resid_args_count"; }
        if (meth == "get") { return "resid_args_get"; }
    }
    if (pname == "filesystem") {
        if (meth == "read_all") { return "resid_fs_read_all"; }
        if (meth == "write_all") { return "resid_fs_write_all"; }
    }
    if (pname == "process") {
        if (meth == "run") { return "resid_process_run"; }
    }
    if (pname == "environment") {
        if (meth == "get") { return "resid_env_get"; }
    }
    return "";
}

Str p_rty(Str pname, Str meth) {
    if (pname == "args") {
        if (meth == "count") { return "Int"; }
        if (meth == "get") { return "Str"; }
    }
    if (pname == "filesystem") {
        if (meth == "read_all") { return "Str"; }
        if (meth == "write_all") { return "Bool"; }
    }
    if (pname == "process") {
        if (meth == "run") { return "Int"; }
    }
    if (pname == "environment") {
        if (meth == "get") { return "Str"; }
    }
    return "";
}

Int p_nargs(Str pname, Str meth) {
    if (pname == "args") {
        if (meth == "get") { return 1; }
    }
    if (pname == "filesystem") {
        if (meth == "read_all") { return 1; }
        if (meth == "write_all") { return 2; }
    }
    if (pname == "process") {
        if (meth == "run") { return 1; }
    }
    if (pname == "environment") {
        if (meth == "get") { return 1; }
    }
    return 0;
}

GT cg_provider(Str s, Int pos, Str pname, List(Str) env, Funcs fs, GT c) {
    Tok m = lex_tok(s, pos);
    Tok lp = lex_tok(s, m.pos);
    if (lp.text != "(") { return gt_err("expected ( in provider call", c); }
    Str sym = p_sym(pname, m.text);
    Str rty = p_rty(pname, m.text);
    Int nargs = p_nargs(pname, m.text);
    if (sym == "") { return gt_err("unsupported provider call " + pname + "." + m.text, c); }
    if (nargs == 0) {
        Tok cp = lex_tok(s, lp.pos);
        if (cp.text != ")") { return gt_err("unexpected provider args", c); }
        Int t1 = c.tmp + 1;
        Str reg = "%t" + IntToString(t1);
        Str line = reg + " = call " + ll_ty(rty) + " @" + sym + "()";
        List(Str) l20 = c.lines;
        List(Str) l2 = l20.concat([line]);
        return GT { pos: cp.pos, val: reg, ty: rty, cnt: 0, err: "", glines: c.glines, lines: l2, tmp: t1, lbl: c.lbl };
    }
    GT a1 = cg_expr(s, lp.pos, env, fs, c);
    if (a1.err != "") { return a1; }
    if (nargs == 1) {
        Tok cp1 = lex_tok(s, a1.pos);
        if (cp1.text != ")") { return gt_err("expected ) in provider call", a1); }
        Int tb = a1.tmp + 1;
        Str regb = "%t" + IntToString(tb);
        Str lineb = regb + " = call " + ll_ty(rty) + " @" + sym + "(" + ll_ty(a1.ty) + " " + a1.val + ")";
        List(Str) lb0 = a1.lines;
        List(Str) lb1 = lb0.concat([lineb]);
        return GT { pos: cp1.pos, val: regb, ty: rty, cnt: 0, err: "", glines: a1.glines, lines: lb1, tmp: tb, lbl: a1.lbl };
    }
    Tok cm = lex_tok(s, a1.pos);
    if (cm.text != ",") { return gt_err("expected , in provider call", a1); }
    GT a2 = cg_expr(s, cm.pos, env, fs, a1);
    if (a2.err != "") { return a2; }
    Tok cp2 = lex_tok(s, a2.pos);
    if (cp2.text != ")") { return gt_err("expected ) in provider call", a2); }
    Int tc = a2.tmp + 1;
    Str regc = "%t" + IntToString(tc);
    Str linec = regc + " = call " + ll_ty(rty) + " @" + sym + "(" + ll_ty(a1.ty) + " " + a1.val + ", " + ll_ty(a2.ty) + " " + a2.val + ")";
    List(Str) lc0 = a2.lines;
    List(Str) lc1 = lc0.concat([linec]);
    return GT { pos: cp2.pos, val: regc, ty: rty, cnt: 0, err: "", glines: a2.glines, lines: lc1, tmp: tc, lbl: a2.lbl };
}

GT cg_extern1(Str s, Int pos, Str sym, Str aty, Str rty, List(Str) env, Funcs fs, GT c) {
    GT a = cg_expr(s, pos, env, fs, c);
    if (a.err != "") { return a; }
    Tok cp = lex_tok(s, a.pos);
    if (cp.text != ")") { return gt_err("expected ) in call to " + sym, a); }
    Int t1 = a.tmp + 1;
    Str reg = "%t" + IntToString(t1);
    Str line = reg + " = call " + ll_ty(rty) + " @" + sym + "(" + ll_ty(aty) + " " + a.val + ")";
    List(Str) l20 = a.lines;
    List(Str) l2 = l20.concat([line]);
    return GT { pos: cp.pos, val: reg, ty: rty, cnt: 0, err: "", glines: a.glines, lines: l2, tmp: t1, lbl: a.lbl };
}

GT cg_externb1(Str s, Int pos, Str sym, Str aty, List(Str) env, Funcs fs, GT c) {
    GT a = cg_expr(s, pos, env, fs, c);
    if (a.err != "") { return a; }
    Tok cp = lex_tok(s, a.pos);
    if (cp.text != ")") { return gt_err("expected ) in call to " + sym, a); }
    Int t1 = a.tmp + 1;
    Int t2 = a.tmp + 2;
    Str cr = "%t" + IntToString(t1);
    Str reg = "%t" + IntToString(t2);
    Str cl = cr + " = call i8 @" + sym + "(" + ll_ty(aty) + " " + a.val + ")";
    Str nl = reg + " = icmp ne i8 " + cr + ", 0";
    List(Str) l20 = a.lines;
    List(Str) l2 = l20.concat([cl]);
    List(Str) l3 = l2.concat([nl]);
    return GT { pos: cp.pos, val: reg, ty: "Bool", cnt: 0, err: "", glines: a.glines, lines: l3, tmp: t2, lbl: a.lbl };
}

GT cg_extern2(Str s, Int pos, Str sym, Str aty1, Str aty2, Str rty, List(Str) env, Funcs fs, GT c) {
    GT a = cg_expr(s, pos, env, fs, c);
    if (a.err != "") { return a; }
    Tok cm = lex_tok(s, a.pos);
    if (cm.text != ",") { return gt_err("expected , in call to " + sym, a); }
    GT b = cg_expr(s, cm.pos, env, fs, a);
    if (b.err != "") { return b; }
    Tok cp = lex_tok(s, b.pos);
    if (cp.text != ")") { return gt_err("expected ) in call to " + sym, b); }
    Int t1 = b.tmp + 1;
    Str reg = "%t" + IntToString(t1);
    Str line = reg + " = call " + ll_ty(rty) + " @" + sym + "(" + ll_ty(aty1) + " " + a.val + ", " + ll_ty(aty2) + " " + b.val + ")";
    List(Str) l20 = b.lines;
    List(Str) l2 = l20.concat([line]);
    return GT { pos: cp.pos, val: reg, ty: rty, cnt: 0, err: "", glines: b.glines, lines: l2, tmp: t1, lbl: b.lbl };
}

GT cg_extern3(Str s, Int pos, Str sym, Str aty1, Str aty2, Str aty3, Str rty, List(Str) env, Funcs fs, GT c) {
    GT a = cg_expr(s, pos, env, fs, c);
    if (a.err != "") { return a; }
    Tok cm = lex_tok(s, a.pos);
    if (cm.text != ",") { return gt_err("expected , in call to " + sym, a); }
    GT b = cg_expr(s, cm.pos, env, fs, a);
    if (b.err != "") { return b; }
    Tok cm2 = lex_tok(s, b.pos);
    if (cm2.text != ",") { return gt_err("expected , in call to " + sym, b); }
    GT d = cg_expr(s, cm2.pos, env, fs, b);
    if (d.err != "") { return d; }
    Tok cp = lex_tok(s, d.pos);
    if (cp.text != ")") { return gt_err("expected ) in call to " + sym, d); }
    Int t1 = d.tmp + 1;
    Str reg = "%t" + IntToString(t1);
    Str line = reg + " = call " + ll_ty(rty) + " @" + sym + "(" + ll_ty(aty1) + " " + a.val + ", " + ll_ty(aty2) + " " + b.val + ", " + ll_ty(aty3) + " " + d.val + ")";
    List(Str) l20 = d.lines;
    List(Str) l2 = l20.concat([line]);
    return GT { pos: cp.pos, val: reg, ty: rty, cnt: 0, err: "", glines: d.glines, lines: l2, tmp: t1, lbl: d.lbl };
}

GT csl_value(Str s, Int pos, Str fty, List(Str) env, Funcs fs, GT c) {
    Tok v1 = lex_tok(s, pos);
    Tok v2 = lex_tok(s, v1.pos);
    if (v1.text == "[" && v2.text == "]") {
        Int te = c.tmp + 1;
        Str re = "%t" + IntToString(te);
        List(Str) q0 = c.lines;
        List(Str) q1 = q0.concat([re + " = call ptr @malloc(i64 8)"]);
        List(Str) q2 = q1.concat(["store i64 0, ptr " + re]);
        return GT { pos: v2.pos, val: re, ty: fty, cnt: 0, err: "", glines: c.glines, lines: q2, tmp: te, lbl: c.lbl };
    }
    return cg_expr(s, pos, env, fs, c);
}

GT csl_field(Str s, Int pos, Str fields, Str sname, Str reg, List(Str) env, Funcs fs, GT c) {
    Tok t = lex_tok(s, pos);
    if (t.text == "}") {
        return GT { pos: t.pos, val: reg, ty: sname, cnt: 0, err: "", glines: c.glines, lines: c.lines, tmp: c.tmp, lbl: c.lbl };
    }
    Tok colon = lex_tok(s, t.pos);
    if (colon.text != ":") { return gt_err("expected : in struct literal", c); }
    Int slot = field_slot(fields, t.text);
    if (slot < 0) { return gt_err("unknown field " + t.text, c); }
    Str fty = field_ty(fields, t.text);
    Int off = slot * 8;
    GT v = csl_value(s, colon.pos, fty, env, fs, c);
    if (v.err != "") { return v; }
    Str sr = reg + ".f" + IntToString(slot);
    Str g1 = sr + " = getelementptr i8, ptr " + reg + ", i64 " + IntToString(off);
    Str g2 = "store " + ll_ty(v.ty) + " " + v.val + ", ptr " + sr;
    List(Str) u0 = v.lines;
    List(Str) u1 = u0.concat([g1]);
    List(Str) u2 = u1.concat([g2]);
    GT stored = GT { pos: v.pos, val: reg, ty: sname, cnt: 0, err: "", glines: v.glines, lines: u2, tmp: v.tmp, lbl: v.lbl };
    Tok sep = lex_tok(s, v.pos);
    if (sep.text == ",") {
        return csl_field(s, sep.pos, fields, sname, reg, env, fs, stored);
    }
    if (sep.text == "}") {
        return GT { pos: sep.pos, val: reg, ty: sname, cnt: 0, err: "", glines: stored.glines, lines: stored.lines, tmp: stored.tmp, lbl: stored.lbl };
    }
    return gt_err("expected , or } in struct literal", stored);
}

GT cg_struct_lit(Str s, Int pos, Str sname, List(Str) env, Funcs fs, GT c) {
    Int si = struct_index(fs, sname);
    if (si < 0) { return gt_err("unknown struct " + sname, c); }
    List(Str) stfl = fs.stf;
    Str fields = stfl[si];
    Int nf = struct_nfields(fields);
    Int nb = nf * 8;
    Int t1 = c.tmp + 1;
    Str reg = "%t" + IntToString(t1);
    List(Str) l0 = c.lines;
    List(Str) l1 = l0.concat([reg + " = call ptr @malloc(i64 " + IntToString(nb) + ")"]);
    GT c1 = GT { pos: pos, val: reg, ty: sname, cnt: 0, err: "", glines: c.glines, lines: l1, tmp: t1, lbl: c.lbl };
    return csl_field(s, pos, fields, sname, reg, env, fs, c1);
}

List(Str) lst_stores(List(Str) vals, Str reg, Str ety, Int i, List(Str) acc) {
    if (i >= vals.len()) { return acc; }
    Int off = i * 8 + 8;
    Str en = reg + ".e" + IntToString(i);
    Str gp = en + " = getelementptr i8, ptr " + reg + ", i64 " + IntToString(off);
    Str st = "store " + ll_ty(ety) + " " + vals[i] + ", ptr " + en;
    List(Str) a2 = acc.concat([gp]);
    List(Str) a3 = a2.concat([st]);
    Int k = i + 1;
    return lst_stores(vals, reg, ety, k, a3);
}

GT lst_emit(Str ety, Int n, List(Str) vals, Int pos, GT c) {
    Int nb = n * 8 + 8;
    Int t1 = c.tmp + 1;
    Str reg = "%t" + IntToString(t1);
    List(Str) l0 = c.lines;
    List(Str) l1 = l0.concat([reg + " = call ptr @malloc(i64 " + IntToString(nb) + ")"]);
    List(Str) l2 = l1.concat(["store i64 " + IntToString(n) + ", ptr " + reg]);
    List(Str) l3 = lst_stores(vals, reg, ety, 0, l2);
    return GT { pos: pos, val: reg, ty: "List(" + ety + ")", cnt: 0, err: "", glines: c.glines, lines: l3, tmp: t1, lbl: c.lbl };
}

GT lst_more(Str s, Int pos, Str ety, Int n, List(Str) vals, List(Str) env, Funcs fs, GT c) {
    Tok t = lex_tok(s, pos);
    if (t.text == ",") { return lst_elems(s, t.pos, ety, n, vals, env, fs, c); }
    if (t.text == "]") { return lst_emit(ety, n, vals, t.pos, c); }
    return gt_err("expected , or ] in list literal", c);
}

GT lst_elems(Str s, Int pos, Str ety, Int n, List(Str) vals, List(Str) env, Funcs fs, GT c) {
    Tok t = lex_tok(s, pos);
    if (t.text == "]") { return gt_err("unexpected ] in list literal", c); }
    GT v = cg_expr(s, pos, env, fs, c);
    if (v.err != "") { return v; }
    if (v.ty != ety) { return gt_err("mixed list element types", v); }
    List(Str) vals2 = vals.concat([v.val]);
    Int n2 = n + 1;
    return lst_more(s, v.pos, ety, n2, vals2, env, fs, v);
}

GT cg_ifexpr(Str s, Int pos, List(Str) env, Funcs fs, GT c) {
    Tok open = lex_tok(s, pos);
    GT cond = cg_expr(s, open.pos, env, fs, c);
    if (cond.err != "") { return cond; }
    if (cond.ty != "Bool") { return gt_err("if condition must be Bool", cond); }
    Tok close = lex_tok(s, cond.pos);
    Int l1 = c.lbl + 1;
    Int l2 = c.lbl + 2;
    Int l3 = c.lbl + 3;
    Str lt = "L" + IntToString(l1);
    Str le = "L" + IntToString(l2);
    Str ld = "L" + IntToString(l3);
    Str br1 = "br i1 " + cond.val + ", label %" + lt + ", label %" + le;
    List(Str) a0 = cond.lines;
    List(Str) a1 = a0.concat([br1]);
    List(Str) a2 = a1.concat([lt + ":"]);
    GT ct = GT { pos: close.pos, val: "", ty: "", cnt: 0, err: "", glines: cond.glines, lines: a2, tmp: cond.tmp, lbl: l3 };
    Tok ob = lex_tok(s, close.pos);
    GT tv = cg_expr(s, ob.pos, env, fs, ct);
    if (tv.err != "") { return tv; }
    Tok cb = lex_tok(s, tv.pos);
    if (cb.text != "}") { return gt_err("expected } in if arm", tv); }
    List(Str) b0 = tv.lines;
    List(Str) b1 = b0.concat(["br label %" + ld]);
    Tok kw = lex_tok(s, cb.pos);
    if (kw.text != "else") { return gt_err("if expression requires else", tv); }
    Tok ob2 = lex_tok(s, kw.pos);
    List(Str) b2 = b1.concat([le + ":"]);
    GT ce = GT { pos: ob2.pos, val: "", ty: "", cnt: 0, err: "", glines: tv.glines, lines: b2, tmp: tv.tmp, lbl: l3 };
    GT ev = cg_expr(s, ob2.pos, env, fs, ce);
    if (ev.err != "") { return ev; }
    Tok cb2 = lex_tok(s, ev.pos);
    if (cb2.text != "}") { return gt_err("expected } in else arm", ev); }
    if (ev.ty != tv.ty) { return gt_err("if arms disagree", ev); }
    Int tp = ev.tmp + 1;
    Str pr = "%t" + IntToString(tp);
    Str phi = pr + " = phi " + ll_ty(tv.ty) + " [ " + tv.val + ", %" + lt + " ], [ " + ev.val + ", %" + le + " ]";
    List(Str) d0 = ev.lines;
    List(Str) d05 = d0.concat(["br label %" + ld]);
    List(Str) d1 = d05.concat([ld + ":"]);
    List(Str) d2 = d1.concat([phi]);
    Int lb4 = if (ev.lbl > l3) { ev.lbl } else { l3 };
    return GT { pos: cb2.pos, val: pr, ty: tv.ty, cnt: 0, err: "", glines: ev.glines, lines: d2, tmp: tp, lbl: lb4 };
}

GT fst_emit_global(Str body, Int pos, GT c) {
    Int t1 = c.tmp + 1;
    Str nm = "@.s" + IntToString(t1);
    Int bl = ll_bytes(body, 0, 0);
    Int n1 = bl + 1;
    Str g = nm + " = private unnamed_addr constant [" + IntToString(n1) + " x i8] c\"" + body + str_from_code(92) + "00\"";
    List(Str) l20 = c.glines;
    List(Str) l2 = l20.concat([g]);
    return GT { pos: pos, val: nm, ty: "Str", cnt: 0, err: "", glines: l2, lines: c.lines, tmp: t1, lbl: c.lbl };
}

GT fst_join(GT c, Str pv) {
    if (c.val == "") {
        return GT { pos: c.pos, val: pv, ty: "Str", cnt: 0, err: "", glines: c.glines, lines: c.lines, tmp: c.tmp, lbl: c.lbl };
    }
    Int t1 = c.tmp + 1;
    Str cr = "%t" + IntToString(t1);
    Str cl = cr + " = call ptr @resid_str_concat(ptr " + c.val + ", ptr " + pv + ")";
    List(Str) l20 = c.lines;
    List(Str) l2 = l20.concat([cl]);
    return GT { pos: c.pos, val: cr, ty: "Str", cnt: 0, err: "", glines: c.glines, lines: l2, tmp: t1, lbl: c.lbl };
}

GT fst_literal(Str s, Int i, Int end, Str bodyacc, GT c) {
    if (i >= end) { return fst_emit_global(bodyacc, i, c); }
    Int ch = str_char_at(s, i);
    if (ch == 123 || ch == 34) { return fst_emit_global(bodyacc, i, c); }
    Int k = i + 1;
    if (ch == 92) {
        Int n = str_char_at(s, k);
        Int k2 = k + 1;
        return fst_literal(s, k2, end, bodyacc + ir_esc(dec_esc(n)), c);
    }
    return fst_literal(s, k, end, bodyacc + ir_esc(ch), c);
}

GT fst_tostr(GT v) {
    if (v.ty == "Str") {
        return GT { pos: v.pos, val: v.val, ty: "Str", cnt: 0, err: "", glines: v.glines, lines: v.lines, tmp: v.tmp, lbl: v.lbl };
    }
    if (v.ty == "Int") {
        Int t1 = v.tmp + 1;
        Int t2 = v.tmp + 2;
        Str buf = "%t" + IntToString(t1);
        Str rr = "%t" + IntToString(t2);
        List(Str) x0 = v.lines;
        List(Str) x1 = x0.concat([buf + " = alloca [24 x i8]"]);
        List(Str) x2 = x1.concat([rr + " = call ptr @e.itoa(ptr " + buf + ", i64 " + v.val + ")"]);
        return GT { pos: v.pos, val: rr, ty: "Str", cnt: 0, err: "", glines: v.glines, lines: x2, tmp: t2, lbl: v.lbl };
    }
    return gt_err("unsupported interpolation type " + v.ty, v);
}

GT fst_carr(Str acc, GT c) {
    return GT { pos: c.pos, val: acc, ty: "Str", cnt: 0, err: "", glines: c.glines, lines: c.lines, tmp: c.tmp, lbl: c.lbl };
}

GT fst_scan(Str s, Int i, Int end, Str acc, List(Str) env, Funcs fs, GT c) {
    if (i >= end) {
        if (acc == "") { return fst_emit_global("", i, c); }
        return fst_carr(acc, c);
    }
    Int ch = str_char_at(s, i);
    if (ch == 34) {
        if (acc == "") { return fst_emit_global("", i, c); }
        return fst_carr(acc, c);
    }
    if (ch == 123) {
        Int ip = i + 1;
        Int cbp = str_find_char(s, 125, ip);
        if (cbp < 0) { return gt_err("unterminated interpolation", c); }
        GT cb0 = GT { pos: c.pos, val: "", ty: "Str", cnt: 0, err: "", glines: c.glines, lines: c.lines, tmp: c.tmp, lbl: c.lbl };
        GT v = cg_expr(s, ip, env, fs, cb0);
        if (v.err != "") { return v; }
        GT sv = fst_tostr(v);
        if (sv.err != "") { return sv; }
        Tok chk = lex_tok(s, sv.pos);
        if (chk.text != "}") { return gt_err("bad interpolation", sv); }
        GT carr = fst_carr(acc, sv);
        GT joined = fst_join(carr, sv.val);
        return fst_scan(s, chk.pos, end, joined.val, env, fs, joined);
    }
    GT lit = fst_literal(s, i, end, "", c);
    if (lit.err != "") { return lit; }
    GT carr2 = fst_carr(acc, lit);
    GT joined2 = fst_join(carr2, lit.val);
    return fst_scan(s, lit.pos, end, joined2.val, env, fs, joined2);
}

GT cg_fstring(Str s, Tok t, List(Str) env, Funcs fs, GT c) {
    Int tl = str_len_1(t.text);
    Int start = t.pos - tl;
    Int end = t.pos - 1;
    Int st2 = start + 2;
    GT r = fst_scan(s, st2, end, "", env, fs, c);
    if (r.err != "") { return r; }
    return GT { pos: t.pos, val: r.val, ty: r.ty, cnt: r.cnt, err: "", glines: r.glines, lines: r.lines, tmp: r.tmp, lbl: r.lbl };
}

// ─── Statement codegen ─────────────────────────────────────────

type ST = { pos: Int, dead: Bool, err: Str, env: List(Str), glines: List(Str), hlines: List(Str), lines: List(Str), tmp: Int, lbl: Int };

ST st_err(Str msg, ST g) {
    return ST { pos: g.pos, dead: g.dead, err: msg, env: g.env, glines: g.glines, hlines: g.hlines, lines: g.lines, tmp: g.tmp, lbl: g.lbl };
}

ST sg_stmt(Str s, Int pos, List(Str) env, Funcs fs, Bool in_main, ST g) {
    Tok t = lex_tok(s, pos);
    if (t.text == "}") {
        return ST { pos: t.pos, dead: g.dead, err: "", env: env, glines: g.glines, hlines: g.hlines, lines: g.lines, tmp: g.tmp, lbl: g.lbl };
    }
    if (t.kind == "eof") {
        return st_err("unexpected eof", g);
    }
    if (t.text == "return") {
        Tok e = lex_tok(s, t.pos);
        if (e.text == ";") {
            if (in_main) {
                List(Str) lr0 = g.lines;
                List(Str) rl0 = lr0.concat(["ret i32 0"]);
                return ST { pos: e.pos, dead: true, err: "", env: env, glines: g.glines, hlines: g.hlines, lines: rl0, tmp: g.tmp, lbl: g.lbl };
            }
            return st_err("return without a value", g);
        }
        GT v = cg_expr(s, t.pos, env, fs, gt_of_st(g));
        if (v.err != "") { return st_err(v.err, g); }
        Tok semi = lex_tok(s, v.pos);
        Int t1 = v.tmp + 1;
        Str reg = "%t" + IntToString(t1);
        Str tr = reg + " = trunc i64 " + v.val + " to i32";
        Str rl = "ret i32 " + reg;
        Str rn = "ret " + ll_ty(v.ty) + " " + v.val;
        Bool im = in_main && v.ty == "Int";
        List(Str) lv0 = v.lines;
        List(Str) base = if (im) { lv0.concat([tr]) } else { lv0 };
        List(Str) lns = if (im) { base.concat([rl]) } else { base.concat([rn]) };
        Int ut = if (im) { t1 } else { v.tmp };
        return ST { pos: semi.pos, dead: true, err: "", env: env, glines: v.glines, hlines: g.hlines, lines: lns, tmp: ut, lbl: v.lbl };
    }
    if (t.text == "_") {
        Tok eq = lex_tok(s, t.pos);
        GT v = cg_expr(s, eq.pos, env, fs, gt_of_st(g));
        if (v.err != "") { return st_err(v.err, g); }
        Tok semi = lex_tok(s, v.pos);
        return ST { pos: semi.pos, dead: g.dead, err: "", env: env, glines: v.glines, hlines: g.hlines, lines: v.lines, tmp: v.tmp, lbl: v.lbl };
    }
    if (t.text == "if") {
        return sg_if(s, t.pos, env, fs, in_main, g);
    }
    if (t.text == "for") {
        return sg_for(s, t.pos, env, fs, in_main, g);
    }
    if (t.text == "{") {
        return sg_block(s, pos, env, fs, in_main, g);
    }
    if (t.kind == "ident") {
        Tok t2 = lex_tok(s, t.pos);
        if (t2.kind == "ident") {
            Tok t3 = lex_tok(s, t2.pos);
            if (t3.text == "=") {
                PRes pty = parse_type(s, pos);
                if (pty.err != "") { return st_err(pty.err, g); }
                return sg_bind(s, t3.pos, t2.text, pty.ty, env, fs, g);
            }
        }
        if (t2.text == "(") {
            PRes pty = parse_type(s, pos);
            if (pty.err == "") {
                Tok name = lex_tok(s, pty.pos);
                Tok eq = lex_tok(s, name.pos);
                if (eq.text == "=") {
                    return sg_bind(s, eq.pos, name.text, pty.ty, env, fs, g);
                }
            }
        }
    }
    GT v = cg_expr(s, pos, env, fs, gt_of_st(g));
    if (v.err != "") { return st_err(v.err, g); }
    Tok semi = lex_tok(s, v.pos);
    return ST { pos: semi.pos, dead: g.dead, err: "", env: env, glines: v.glines, hlines: g.hlines, lines: v.lines, tmp: v.tmp, lbl: v.lbl };
}

ST sg_bind(Str s, Int pos, Str name, Str dty, List(Str) env, Funcs fs, ST g) {
    Tok b1 = lex_tok(s, pos);
    Tok b2 = lex_tok(s, b1.pos);
    if (b1.text == "[" && b2.text == "]") {
        Int t1 = g.tmp + 1;
        Str reg = "%t" + IntToString(t1);
        List(Str) z0 = g.lines;
        List(Str) z1 = z0.concat([reg + " = call ptr @malloc(i64 8)"]);
        List(Str) z2 = z1.concat(["store i64 0, ptr " + reg]);
        Str ent = name + ":" + reg + ":" + dty;
        List(Str) env2 = env_add(env, ent);
        Tok bsemi = lex_tok(s, b2.pos);
        Int bpos = if (bsemi.text == ";") { bsemi.pos } else { b2.pos };
        return ST { pos: bpos, dead: g.dead, err: "", env: env2, glines: g.glines, hlines: g.hlines, lines: z2, tmp: t1, lbl: g.lbl };
    }
    GT v = cg_expr(s, pos, env, fs, gt_of_st(g));
    if (v.err != "") { return st_err(v.err, g); }
    Tok semi = lex_tok(s, v.pos);
    Str ent2 = name + ":" + v.val + ":" + v.ty;
    List(Str) env3 = env_add(env, ent2);
    return ST { pos: semi.pos, dead: g.dead, err: "", env: env3, glines: v.glines, hlines: g.hlines, lines: v.lines, tmp: v.tmp, lbl: v.lbl };
}

ST sg_block(Str s, Int pos, List(Str) env, Funcs fs, Bool in_main, ST g) {
    Tok open = lex_tok(s, pos);
    if (open.text != "{") {
        return st_err("expected {", g);
    }
    ST g1 = ST { pos: open.pos, dead: false, err: "", env: env, glines: g.glines, hlines: g.hlines, lines: g.lines, tmp: g.tmp, lbl: g.lbl };
    ST r = sg_stmts(s, open.pos, env, fs, in_main, g1);
    if (r.err != "") { return r; }
    Tok close0 = lex_tok(s, r.pos);
    Tok close = if (r.dead) { skip_close_tok(s, r.pos, 1) } else { close0 };
    if (close.text != "}") {
        return st_err("expected }", g);
    }
    return ST { pos: close.pos, dead: r.dead, err: "", env: env, glines: r.glines, hlines: r.hlines, lines: r.lines, tmp: r.tmp, lbl: r.lbl };
}

ST sg_stmts(Str s, Int pos, List(Str) env, Funcs fs, Bool in_main, ST g) {
    Tok t = lex_tok(s, pos);
    if (t.text == "}" || t.kind == "eof") {
        return ST { pos: pos, dead: g.dead, err: "", env: env, glines: g.glines, hlines: g.hlines, lines: g.lines, tmp: g.tmp, lbl: g.lbl };
    }
    ST r = sg_stmt(s, pos, env, fs, in_main, g);
    if (r.err != "") { return r; }
    if (r.dead) { return r; }
    return sg_stmts(s, r.pos, r.env, fs, in_main, r);
}

GT gt_of_st(ST g) {
    return GT { pos: g.pos, val: "", ty: "", cnt: 0, err: g.err, glines: g.glines, lines: g.lines, tmp: g.tmp, lbl: g.lbl };
}

ST sg_if(Str s, Int pos, List(Str) env, Funcs fs, Bool in_main, ST g) {
    Tok open = lex_tok(s, pos);
    GT cond = cg_expr(s, open.pos, env, fs, gt_of_st(g));
    if (cond.err != "") { return st_err(cond.err, g); }
    if (cond.ty != "Bool") { return st_err("if condition must be Bool", g); }
    Tok close = lex_tok(s, cond.pos);
    Int l1 = g.lbl + 1;
    Int l2 = g.lbl + 2;
    Int l3 = g.lbl + 3;
    Str lt = "L" + IntToString(l1);
    Str le = "L" + IntToString(l2);
    Str ld = "L" + IntToString(l3);
    Tok brace = lex_tok(s, close.pos);
    Tok endt = skip_close_tok(s, brace.pos, 1);
    Tok kw0 = lex_tok(s, endt.pos);
    Bool haselse = kw0.text == "else";
    Str ftarget = if (haselse) { le } else { ld };
    Str br1 = "br i1 " + cond.val + ", label %" + lt + ", label %" + ftarget;
    List(Str) bc0 = cond.lines;
    List(Str) brl = bc0.concat([br1]);
    List(Str) brl2 = brl.concat([lt + ":"]);
    ST gb = ST { pos: brace.pos, dead: false, err: "", env: env, glines: cond.glines, hlines: g.hlines, lines: brl2, tmp: cond.tmp, lbl: l3 };
    ST gt = sg_block(s, close.pos, env, fs, in_main, gb);
    if (gt.err != "") { return gt; }
    List(Str) lns0 = gt.lines;
    List(Str) lns = if (!gt.dead) { lns0.concat(["br label %" + ld]) } else { lns0 };
    Tok kw = lex_tok(s, gt.pos);
    if (kw.text != "else") {
        List(Str) j0 = lns;
        List(Str) j1 = j0.concat([ld + ":"]);
        Int lb1 = if (gt.lbl > l3) { gt.lbl } else { l3 };
        return ST { pos: gt.pos, dead: false, err: "", env: env, glines: gt.glines, hlines: g.hlines, lines: j1, tmp: gt.tmp, lbl: lb1 };
    }
    List(Str) lns2 = lns.concat([le + ":"]);
    Tok ebrace = lex_tok(s, kw.pos);
    ST ge = sg_block(s, kw.pos, env, fs, in_main, ST { pos: ebrace.pos, dead: false, err: "", env: env, glines: gt.glines, hlines: gt.hlines, lines: lns2, tmp: gt.tmp, lbl: l3 });
    if (ge.err != "") { return ge; }
    List(Str) lns3a = ge.lines;
    List(Str) lns3 = if (!ge.dead) { lns3a.concat(["br label %" + ld]) } else { lns3a };
    Bool both = gt.dead && ge.dead;
    List(Str) lns4a = lns3.concat([ld + ":"]);
    List(Str) lns4 = if (both) { lns4a.concat(["unreachable"]) } else { lns4a };
    Int lb2 = if (gt.lbl > ge.lbl) { gt.lbl } else { ge.lbl };
    Int lb3 = if (lb2 > l3) { lb2 } else { l3 };
    return ST { pos: ge.pos, dead: both, err: "", env: env, glines: ge.glines, hlines: ge.hlines, lines: lns4, tmp: ge.tmp, lbl: lb3 };
}

Str capt_params(List(Str) env, Int i, Str acc) {
    if (i >= env.len()) { return acc; }
    Str elem = env[i];
    Int c1 = str_find_char(elem, 58, 0);
    Int c1p = c1 + 1;
    Int c2 = str_find_char(elem, 58, c1p);
    Int c2p = c2 + 1;
    Int el = str_len_1(elem);
    Str ty = str_slice(elem, c2p, el);
    Str nm = "%e" + IntToString(i);
    Str acc2 = acc + ", " + ll_ty(ty) + " " + nm;
    Int k = i + 1;
    return capt_params(env, k, acc2);
}

Str capt_vals(List(Str) env, Int i, Str acc) {
    if (i >= env.len()) { return acc; }
    Str elem = env[i];
    Int c1 = str_find_char(elem, 58, 0);
    Int c1p = c1 + 1;
    Int c2 = str_find_char(elem, 58, c1p);
    Str val = str_slice(elem, c1p, c2);
    Str acc2 = acc + ", " + val;
    Int k = i + 1;
    return capt_vals(env, k, acc2);
}

List(Str) env_rewrite_at(List(Str) env, Int i, List(Str) acc) {
    if (i >= env.len()) { return acc; }
    Str elem = env[i];
    Int c1 = str_find_char(elem, 58, 0);
    Int c1p = c1 + 1;
    Int c2 = str_find_char(elem, 58, c1p);
    Int c2p = c2 + 1;
    Int el = str_len_1(elem);
    Str head = str_slice(elem, 0, c1);
    Str ty = str_slice(elem, c2p, el);
    Str ent = head + ":%e" + IntToString(i) + ":" + ty;
    Int k = i + 1;
    return env_rewrite_at(env, k, acc.concat([ent]));
}

ST sg_for(Str s, Int pos, List(Str) env, Funcs fs, Bool in_main, ST g) {
    Tok open = lex_tok(s, pos);
    PRes pty = parse_type(s, open.pos);
    if (pty.err != "") { return st_err(pty.err, g); }
    Tok name = lex_tok(s, pty.pos);
    Tok inkw = lex_tok(s, name.pos);
    if (inkw.text != "in") { return st_err("expected in", g); }
    GT a = cg_expr(s, inkw.pos, env, fs, gt_of_st(g));
    if (a.err != "") { return st_err(a.err, g); }
    Tok op = lex_tok(s, a.pos);
    if (op.text != ".." && op.text != "..=") {
        Tok lc = lex_tok(s, a.pos);
        if (lc.text != ")") { return st_err("expected ) after for-in iterable", g); }
        Int lpp = str_find_char(a.ty, 40, 0);
        if (lpp < 0) { return st_err("for-in over non-iterable " + a.ty, g); }
        Int lb2 = g.lbl + 1;
        Int lbod2 = g.lbl + 2;
        Int ld2 = g.lbl + 3;
        Int nlbl2 = g.lbl + 3;
        Str n2s = IntToString(lb2);
        Str LB2 = "LB" + n2s;
        Str LBODY2 = "LBODY" + n2s;
        Str LD2 = "LD" + n2s;
        Str ixa = "%lia." + n2s;
        Str iv = "%liv." + n2s;
        Str iv2 = "%lin." + n2s;
        Str cnt = "%lcnt." + n2s;
        Str cc2 = "%lcc." + n2s;
        Str om2 = "%lom." + n2s;
        Str oa2 = "%loa." + n2s;
        Str gp2 = "%lgp." + n2s;
        Str ev = "%lev." + n2s;
        Str ent2 = name.text + ":" + ev + ":" + pty.ty;
        List(Str) envl = env_add(env, ent2);
        List(Str) f0 = g.lines;
        List(Str) f1 = f0.concat([ixa + " = alloca i64"]);
        List(Str) f2 = f1.concat(["store i64 0, ptr " + ixa]);
        List(Str) f3 = f2.concat(["br label %" + LB2]);
        List(Str) f4 = f3.concat([LB2 + ":"]);
        List(Str) f5 = f4.concat([iv + " = load i64, ptr " + ixa]);
        List(Str) f6 = f5.concat([cnt + " = load i64, ptr " + a.val]);
        List(Str) f7 = f6.concat([cc2 + " = icmp slt i64 " + iv + ", " + cnt]);
        List(Str) f8 = f7.concat(["br i1 " + cc2 + ", label %" + LBODY2 + ", label %" + LD2]);
        List(Str) f9 = f8.concat([LBODY2 + ":"]);
        List(Str) f10 = f9.concat([om2 + " = mul i64 8, " + iv]);
        List(Str) f11 = f10.concat([oa2 + " = add i64 " + om2 + ", 8"]);
        List(Str) f12 = f11.concat([gp2 + " = getelementptr i8, ptr " + a.val + ", i64 " + oa2]);
        List(Str) f13 = f12.concat([ev + " = load " + ll_ty(pty.ty) + ", ptr " + gp2]);
        Tok brace2 = lex_tok(s, lc.pos);
        ST gb2 = ST { pos: brace2.pos, dead: false, err: "", env: envl, glines: a.glines, hlines: g.hlines, lines: f13, tmp: a.tmp, lbl: nlbl2 };
        ST body2 = sg_block(s, lc.pos, envl, fs, in_main, gb2);
        if (body2.err != "") { return body2; }
        List(Str) b20 = body2.lines;
        List(Str) b21 = if (!body2.dead) { b20.concat([iv2 + " = add i64 " + iv + ", 1"]) } else { b20 };
        List(Str) b22 = if (!body2.dead) { b21.concat(["store i64 " + iv2 + ", ptr " + ixa]) } else { b21 };
        List(Str) b23 = if (!body2.dead) { b22.concat(["br label %" + LB2]) } else { b22 };
        List(Str) b24 = b23.concat([LD2 + ":"]);
        return ST { pos: body2.pos, dead: g.dead, err: "", env: env, glines: body2.glines, hlines: body2.hlines, lines: b24, tmp: body2.tmp, lbl: nlbl2 };
    }
    if (pty.ty != "Int") { return st_err("for-in var must be Int", g); }
    GT b = cg_expr(s, op.pos, env, fs, a);
    if (b.err != "") { return st_err(b.err, g); }
    Tok close = lex_tok(s, b.pos);
    Int lb = g.lbl + 1;
    Int lbody = g.lbl + 2;
    Int ld = g.lbl + 3;
    Int newlbl = g.lbl + 3;
    Str lbs = IntToString(lb);
    Str LB = "LB" + lbs;
    Str LBODY = "LBODY" + lbs;
    Str LD = "LD" + lbs;
    Str kreg = "%k" + lbs;
    Str kaddr = "%k.a" + lbs;
    Str k2 = "%k2." + lbs;
    Str lent = name.text + ":" + kreg + ":Int";
    List(Str) env2 = env_add(env, lent);
    Str cmp = if (op.text == "..=") { "icmp sle" } else { "icmp slt" };
    List(Str) go0 = g.lines;
    List(Str) pre = go0.concat([kaddr + " = alloca i64"]);
    List(Str) p2 = pre.concat(["store i64 " + a.val + ", ptr " + kaddr]);
    List(Str) p3 = p2.concat(["br label %" + LB]);
    List(Str) p4 = p3.concat([LB + ":"]);
    List(Str) p5 = p4.concat([kreg + " = load i64, ptr " + kaddr]);
    List(Str) p6 = p5.concat(["%c" + lbs + " = " + cmp + " i64 " + kreg + ", " + b.val]);
    List(Str) p7 = p6.concat(["br i1 %c" + lbs + ", label %" + LBODY + ", label %" + LD]);
    List(Str) p8 = p7.concat([LBODY + ":"]);
    Tok brace1 = lex_tok(s, close.pos);
    ST gb = ST { pos: brace1.pos, dead: false, err: "", env: env2, glines: b.glines, hlines: g.hlines, lines: p8, tmp: b.tmp, lbl: newlbl };
    ST body = sg_block(s, close.pos, env2, fs, in_main, gb);
    if (body.err != "") { return body; }
    List(Str) bo0 = body.lines;
    List(Str) t1 = if (!body.dead) { bo0.concat([k2 + " = add i64 " + kreg + ", 1"]) } else { bo0 };
    List(Str) t2 = if (!body.dead) { t1.concat(["store i64 " + k2 + ", ptr " + kaddr]) } else { t1 };
    List(Str) t3 = if (!body.dead) { t2.concat(["br label %" + LB]) } else { t2 };
    List(Str) t4 = t3.concat([LD + ":"]);
    return ST { pos: body.pos, dead: g.dead, err: "", env: env, glines: body.glines, hlines: body.hlines, lines: t4, tmp: body.tmp, lbl: newlbl };
}

// ─── Program walk ──────────────────────────────────────────────

type PG = { pos: Int, err: Str, glines: List(Str), hlines: List(Str), lines: List(Str), tmp: Int, lbl: Int };

Str split_at(Str s, Int i, Str sep) {
    if (i >= str_len_1(s)) { return s; }
    Int sl = str_len_1(sep);
    Int isp = i + sl;
    if (str_slice(s, i, isp) == sep) { return str_slice(s, 0, i); }
    Int k = i + 1;
    return split_at(s, k, sep);
}

List(Str) split_rest(Str s, Str sep) {
    Str first = split_at(s, 0, sep);
    Int fl = str_len_1(first);
    Int sl = str_len_1(sep);
    Int tot = str_len_1(s);
    if (fl + sl > tot) { return [s]; }
    Int fp = fl + sl;
    Str rest = str_slice(s, fp, tot);
    List(Str) one = [first];
    return one.concat(split_rest(rest, sep));
}

Int count_seps(Str s, Int i, Str sep) {
    if (i >= str_len_1(s)) { return 0; }
    Int sl = str_len_1(sep);
    Int isp = i + sl;
    if (str_slice(s, i, isp) == sep) {
        Int k = i + sl;
        Int n = count_seps(s, k, sep);
        Int n1 = n + 1;
        return n1;
    }
    Int k2 = i + 1;
    return count_seps(s, k2, sep);
}

Str param_decl_at(List(Str) tys, Int i, Str acc) {
    if (i >= tys.len()) { return acc; }
    Str ty = ll_ty(tys[i]);
    Str nm = "%p" + IntToString(i);
    Str sep = if (acc != "") { ", " } else { "" };
    Str acc2 = acc + sep + ty + " " + nm;
    Int k = i + 1;
    return param_decl_at(tys, k, acc2);
}

List(Str) build_env_at(List(Str) nl, List(Str) tyl, Int i, List(Str) acc) {
    if (i >= nl.len()) { return acc; }
    Str ent = nl[i] + ":%p" + IntToString(i) + ":" + tyl[i];
    Int k = i + 1;
    return build_env_at(nl, tyl, k, acc.concat([ent]));
}

PG pg_func(Str s, Int pos, Funcs fs, PG g) {
    PRes rty = parse_type(s, pos);
    if (rty.err != "") { return PG { pos: g.pos, err: rty.err, glines: g.glines, hlines: g.hlines, lines: g.lines, tmp: g.tmp, lbl: g.lbl }; }
    Tok name = lex_tok(s, rty.pos);
    Tok open = lex_tok(s, name.pos);
    Tok first = lex_tok(s, open.pos);
    Str pts = collect_ptypes(s, open.pos, "");
    Str pns = collect_pnames(s, open.pos, "");
    Bool is_main = name.text == "main";
    List(Str) tyl = split_rest(pts, ", ");
    Str pd = param_decl_at(tyl, 0, "");
    Str defline = if (is_main) { "define i32 @main() {" } else { "define " + ll_ty(rty.ty) + " @" + name.text + "(" + pd + ") {" };
    List(Str) nl0 = nil_list();
    List(Str) nl1 = split_rest(pns, ",");
    List(Str) nl = if (pns == "") { nl0 } else { nl1 };
    List(Str) env0 = build_env_at(nl, tyl, 0, nil_list());
    List(Str) gl0 = g.lines;
    List(Str) dl = gl0.concat([defline]);
    List(Str) dl2 = dl.concat(["entry:"]);
    Int cp = close_paren(s, open.pos);
    Tok fbrace = lex_tok(s, cp);
    ST gb = ST { pos: fbrace.pos, dead: false, err: "", env: env0, glines: g.glines, hlines: g.hlines, lines: dl2, tmp: g.tmp, lbl: g.lbl };
    ST body = sg_block(s, cp, env0, fs, is_main, gb);
    if (body.err != "") {
        return PG { pos: body.pos, err: body.err, glines: body.glines, hlines: body.hlines, lines: body.lines, tmp: body.tmp, lbl: body.lbl };
    }
    List(Str) lns0 = body.lines;
    List(Str) lns1 = if (!body.dead) { lns0.concat(["ret i32 0"]) } else { lns0 };
    List(Str) lns = lns1.concat(["}"]);
    Int end = skip_body(s, open.pos);
    return pg_next(s, end, fs, PG { pos: end, err: "", glines: body.glines, hlines: body.hlines, lines: lns, tmp: body.tmp, lbl: body.lbl });
}

PG pg_next(Str s, Int pos, Funcs fs, PG g) {
    Tok t = lex_tok(s, pos);
    if (t.kind == "eof") { return g; }
    if (t.text == "pub") {
        // `pub` prefixes a declaration; the decl itself starts at t.pos.
        PRes rty = parse_type(s, t.pos);
        if (rty.err == "") {
            Tok name = lex_tok(s, rty.pos);
            Tok open = lex_tok(s, name.pos);
            if (open.text == "(") {
                return pg_func(s, t.pos, fs, g);
            }
        }
        Int endp = skip_decl(s, t.pos, 0);
        return pg_next(s, endp, fs, g);
    }
    if (t.text == "type" || t.text == "import") {
        Int end = skip_decl(s, t.pos, 0);
        Tok semi = lex_tok(s, end);
        Int e2 = if (semi.text == ";") { semi.pos } else { end };
        return pg_next(s, e2, fs, g);
    }
    if (t.kind == "ident") {
        PRes rty = parse_type(s, pos);
        if (rty.err == "") {
            Tok name = lex_tok(s, rty.pos);
            Tok open = lex_tok(s, name.pos);
            if (open.text == "(") {
                return pg_func(s, pos, fs, g);
            }
        }
    }
    Int end2 = skip_body(s, t.pos);
    return pg_next(s, end2, fs, g);
}

Str join_lines(List(Str) lns, Int i, Str acc) {
    if (i >= lns.len()) { return acc; }
    Str acc2 = acc + lns[i] + "\n";
    Int k = i + 1;
    return join_lines(lns, k, acc2);
}

Str rt_itoa_def() {
    return "define ptr @e.itoa(ptr %buf, i64 %v) {\nentry:\n  %zn = icmp eq i64 %v, 0\n  br i1 %zn, label %zero, label %prep\nzero:\n  %zp = getelementptr i8, ptr %buf, i64 22\n  store i8 48, ptr %zp\n  ret ptr %zp\nprep:\n  %neg = icmp slt i64 %v, 0\n  %an = sub i64 0, %v\n  %mag = select i1 %neg, i64 %an, i64 %v\n  br label %loop\nloop:\n  %cur = phi i64 [ %mag, %prep ], [ %q, %body ]\n  %idx = phi i64 [ 22, %prep ], [ %im, %body ]\n  %d = srem i64 %cur, 10\n  %q = sdiv i64 %cur, 10\n  %ai = add i64 %d, 48\n  %ab = trunc i64 %ai to i8\n  %sp = getelementptr i8, ptr %buf, i64 %idx\n  store i8 %ab, ptr %sp\n  %im = sub i64 %idx, 1\n  %more = icmp ne i64 %q, 0\n  br i1 %more, label %body, label %sig\nbody:\n  br label %loop\nsig:\n  br i1 %neg, label %wneg, label %wpos\nwpos:\n  %pp = getelementptr i8, ptr %buf, i64 %idx\n  ret ptr %pp\nwneg:\n  %mi = sub i64 %idx, 1\n  %mp = getelementptr i8, ptr %buf, i64 %mi\n  store i8 45, ptr %mp\n  ret ptr %mp\n}";
}

Str rt_lconcat_def() {
    return "define ptr @e.lconcat(ptr %a, ptr %b) {\nentry:\n  %ca = load i64, ptr %a\n  %cb = load i64, ptr %b\n  %n = add i64 %ca, %cb\n  %nb8 = mul i64 %n, 8\n  %bytes = add i64 %nb8, 8\n  %nb = call ptr @malloc(i64 %bytes)\n  store i64 %n, ptr %nb\n  br label %la\nla:\n  %i1 = phi i64 [ 0, %entry ], [ %i1n, %dopa ]\n  %c1 = icmp slt i64 %i1, %ca\n  br i1 %c1, label %dopa, label %lb\ndopa:\n  %o1m = mul i64 %i1, 8\n  %o1 = add i64 %o1m, 8\n  %pa = getelementptr i8, ptr %a, i64 %o1\n  %va = load i64, ptr %pa\n  %pbd = getelementptr i8, ptr %nb, i64 %o1\n  store i64 %va, ptr %pbd\n  %i1n = add i64 %i1, 1\n  br label %la\nlb:\n  %i2 = phi i64 [ 0, %la ], [ %i2n, %dopb ]\n  %c2 = icmp slt i64 %i2, %cb\n  br i1 %c2, label %dopb, label %done\ndopb:\n  %o2m = mul i64 %i2, 8\n  %o2a = add i64 %o2m, 8\n  %cai8 = mul i64 %ca, 8\n  %od = add i64 %o2a, %cai8\n  %pbs = getelementptr i8, ptr %b, i64 %o2a\n  %vb = load i64, ptr %pbs\n  %pdd = getelementptr i8, ptr %nb, i64 %od\n  store i64 %vb, ptr %pdd\n  %i2n = add i64 %i2, 1\n  br label %lb\ndone:\n  ret ptr %nb\n}";
}

Str pick_out(Int i, Str acc) {
    if (i <= 0) { return acc; }
    Str a = args.get(i);
    Int ip = i + 1;
    Str nxt = args.get(ip);
    Str acc2 = if (a == "-o") { nxt } else { acc };
    Int k = i - 1;
    return pick_out(k, acc2);
}

Int main() {
    Int argc = args.count();
    if (argc < 2) {
        println("usage: codegen <source.res> [-o out.ll]");
        return 1;
    }
    Str path = args.get(1);
    Int last = argc - 1;
    Str file = pick_out(last, "out.ll");
    Str src = filesystem.read_all(path);
    Funcs fs = collect_sigs(src);
    List(Str) header = ["declare i32 @printf(ptr, ...)", "declare i32 @puts(ptr)", "@.fmt.p = private unnamed_addr constant [3 x i8] c\"%s\\00\"", "declare ptr @malloc(i64)", "declare ptr @resid_str_concat(ptr, ptr)", "declare i8 @resid_str_eq(ptr, ptr)", "declare ptr @resid_fs_read_all(ptr)", "declare i8 @resid_fs_write_all(ptr, ptr)", "declare i64 @resid_args_count()", "declare ptr @resid_args_get(i64)", "declare i64 @resid_process_run(ptr)", "declare ptr @resid_env_get(ptr)", "declare i64 @str_char_at(ptr, i64)", "declare ptr @str_from_code(i64)", "declare i64 @str_len(ptr)", "declare ptr @str_slice(ptr, i64, i64)", "declare i64 @resid_crypto_random_byte()", "declare ptr @str_trim(ptr)", "declare ptr @str_to_lower(ptr)", "declare ptr @str_to_upper(ptr)", "declare ptr @str_reverse(ptr)", "declare i8 @str_contains(ptr, ptr)", "declare i8 @str_starts_with(ptr, ptr)", "declare i8 @str_ends_with(ptr, ptr)", "declare ptr @str_repeat(ptr, i64)", "declare ptr @str_replace(ptr, ptr, ptr)", "declare ptr @bl_str_split(ptr, ptr)", "declare ptr @bl_str_join(ptr, ptr)", "declare i8 @str_is_int(ptr)", "declare i64 @str_parse_int(ptr)", "declare i8 @str_is_float(ptr)", "declare double @str_parse_float(ptr)", "declare i64 @str_count(ptr, ptr)", "declare i64 @abs_i64(i64)", "declare i64 @min_i64(i64, i64)", "declare i64 @max_i64(i64, i64)", "declare i64 @clamp_i64(i64, i64, i64)", "declare ptr @bl_sort_i64(ptr)", "declare ptr @bl_sort_str(ptr)", "declare ptr @bl_sort_f64(ptr)", "declare ptr @bl_reverse_i64(ptr)", "declare ptr @bl_reverse_str(ptr)", "declare ptr @bl_reverse_f64(ptr)", "declare i8 @bl_contains_i64(ptr, i64)", "declare i8 @bl_contains_str(ptr, ptr)", "declare i8 @bl_contains_f64(ptr, double)", "declare i64 @bl_sum(ptr)", "declare double @bl_sumf(ptr)", "declare i64 @checked_add(i64, i64)", "declare i64 @checked_sub(i64, i64)", "declare i64 @checked_mul(i64, i64)", "declare i64 @checked_div(i64, i64)", "declare i64 @checked_uadd(i64, i64)", "declare i64 @checked_usub(i64, i64)", "declare i64 @checked_umul(i64, i64)", "declare i64 @checked_udiv(i64, i64)", "declare i64 @wrapping_add(i64, i64)", "declare i64 @wrapping_sub(i64, i64)", "declare i64 @wrapping_mul(i64, i64)", "declare i64 @wrapping_div(i64, i64)", "declare i64 @wrapping_uadd(i64, i64)", "declare i64 @wrapping_usub(i64, i64)", "declare i64 @wrapping_umul(i64, i64)", "declare i64 @wrapping_udiv(i64, i64)", "declare i64 @saturating_add(i64, i64)", "declare i64 @saturating_sub(i64, i64)", "declare i64 @saturating_mul(i64, i64)", "declare i64 @saturating_uadd(i64, i64)", "declare i64 @saturating_usub(i64, i64)", "declare i64 @saturating_umul(i64, i64)", rt_itoa_def(), rt_lconcat_def()];
    PG g0 = PG { pos: 0, err: "", glines: [], hlines: [], lines: header, tmp: 0, lbl: 0 };
    PG out = pg_next(src, 0, fs, g0);
    if (out.err != "") {
        println("codegen error: " + out.err);
        return 1;
    }
    List(Str) ol = out.lines;
    List(Str) oh = out.hlines;
    List(Str) og = out.glines;
    List(Str) mid = ol.concat(oh);
    List(Str) all = mid.concat(og);
    Str doc = join_lines(all, 0, "");
    filesystem.write_all(file, doc);
    println("wrote " + file);
    return 0;
}
