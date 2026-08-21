// M6c: self-hosted driver — lex → parse → typecheck → codegen → clang.
// Fuses the bootstrap lexer (shared), the M6a checker (ck_* prefixed),
// and the M6b fused parse→IR emitter into one pipeline driven by argv.

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

type Funcs = { names: List(Str), pts: List(Str), pns: List(Str), rets: List(Str) };

Funcs funcs_empty() {
    return Funcs { names: [], pts: [], pns: [], rets: [] };
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
    if (ty == "Str") { return "ptr"; }
    return "";
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
    Tok t = lex_tok(s, pos);
    if (t.text == ")") { return t.pos; }
    return close_paren(s, t.pos);
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
    if (t.text == "type" || t.text == "import") {
        Int end = skip_decl(s, t.pos, 0);
        return collect_sigs_at(s, end, fs);
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
                Funcs fs2 = Funcs { names: n2, pts: p2, pns: q2, rets: r2 };
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

Str bin_op(Str op) {
    if (op == "+") { return "add"; }
    if (op == "-") { return "sub"; }
    if (op == "*") { return "mul"; }
    if (op == "/") { return "sdiv"; }
    if (op == "%") { return "srem"; }
    if (op == "<<") { return "shl"; }
    if (op == ">>") { return "lshr"; }
    if (op == "<") { return "icmp slt"; }
    if (op == "<=") { return "icmp sle"; }
    if (op == ">") { return "icmp sgt"; }
    if (op == ">=") { return "icmp sge"; }
    if (op == "==") { return "icmp eq"; }
    if (op == "!=") { return "icmp ne"; }
    if (op == "&&") { return "and"; }
    if (op == "||") { return "or"; }
    if (op == "&") { return "and"; }
    if (op == "|") { return "or"; }
    if (op == "^") { return "xor"; }
    return "";
}

Bool bin_makes_bool(Str op) {
    if (op == "<") { return true; }
    if (op == "<=") { return true; }
    if (op == ">") { return true; }
    if (op == ">=") { return true; }
    if (op == "==") { return true; }
    if (op == "!=") { return true; }
    if (op == "&&") { return true; }
    if (op == "||") { return true; }
    return false;
}

Str esc_ll(Str s, Int i, Str acc) {
    if (i >= str_len_1(s)) { return acc; }
    Int c = str_char_at(s, i);
    Int k = i + 1;
    if (c == 92) { return esc_ll(s, k, acc + str_from_code(92) + "5C"); }
    if (c == 34) { return esc_ll(s, k, acc + str_from_code(92) + "22"); }
    if (c == 10) { return esc_ll(s, k, acc + str_from_code(92) + "0A"); }
    if (c == 9) { return esc_ll(s, k, acc + str_from_code(92) + "09"); }
    return esc_ll(s, k, acc + str_slice(s, i, k));
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
    Str acc2 = acc + sep + v.ty + " " + v.val;
    Int c2 = count + 1;
    Tok comma = lex_tok(s, v.pos);
    GT cs = GT { pos: comma.pos, val: acc2, ty: "", cnt: c2, err: "", glines: v.glines, lines: v.lines, tmp: v.tmp, lbl: v.lbl };
    if (comma.text == ",") {
        return cg_args(s, comma.pos, acc2, c2, env, fs, cs);
    }
    return cs;
}

GT cg_call(Str s, Int pos, Str name, List(Str) env, Funcs fs, GT c) {
    Tok t = lex_tok(s, pos);
    if (t.text == ")") {
        Int t1 = c.tmp + 1;
        Str reg = "%t" + IntToString(t1);
        Str line = reg + " = call i64 @" + name + "()";
        List(Str) lc0 = c.lines;
        List(Str) cl = lc0.concat([line]);
        return GT { pos: t.pos, val: reg, ty: "i64", cnt: 0, err: "", glines: c.glines, lines: cl, tmp: t1, lbl: c.lbl };
    }
    GT a = cg_args(s, pos, "", 0, env, fs, c);
    if (a.err != "") { return a; }
    Int idx = fn_index(fs, name);
    if (idx < 0) {
        return gt_err("unknown function " + name, a);
    }
    List(Str) rts = fs.rets;
    Str rty = ll_ty(rts[idx]);
    if (rty == "") {
        return gt_err("unsupported return type for " + name, a);
    }
    Int t1 = a.tmp + 1;
    Str reg = "%t" + IntToString(t1);
    Str line = reg + " = call " + rty + " @" + name + "(" + a.val + ")";
    List(Str) la0 = a.lines;
    List(Str) cl2 = la0.concat([line]);
    return GT { pos: a.pos, val: reg, ty: rty, cnt: a.cnt, err: "", glines: a.glines, lines: cl2, tmp: t1, lbl: a.lbl };
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
        return GT { pos: t.pos, val: t.text, ty: "i64", cnt: 0, err: "", glines: c.glines, lines: c.lines, tmp: c.tmp, lbl: c.lbl };
    }
    if (t.kind == "str") {
        Int t1 = c.tmp + 1;
        Str nm = "@.s" + IntToString(t1);
        Int tl = str_len_1(t.text);
        Int te = tl - 1;
        Str inner = str_slice(t.text, 1, te);
        Str body = esc_ll(inner, 0, "");
        Int bl = str_len_1(body);
        Int n1 = bl + 1;
        Str g = nm + " = private unnamed_addr constant [" + IntToString(n1) + " x i8] c\"" + body + "\\00\"";
        List(Str) gg0 = c.glines;
        List(Str) gl = gg0.concat([g]);
        return GT { pos: t.pos, val: nm, ty: "ptr", cnt: 0, err: "", glines: gl, lines: c.lines, tmp: t1, lbl: c.lbl };
    }
    if (t.text == "true" || t.text == "false") {
        return GT { pos: t.pos, val: t.text, ty: "i1", cnt: 0, err: "", glines: c.glines, lines: c.lines, tmp: c.tmp, lbl: c.lbl };
    }
    if (t.kind == "ident") {
        if (t.text == "println" || t.text == "print") {
            Tok t2 = lex_tok(s, t.pos);
            if (t2.text == "(") {
                return cg_print(s, t2.pos, t.text, env, fs, c);
            }
        }
        Tok t2 = lex_tok(s, t.pos);
        if (t2.text == "(") {
            return cg_call(s, t2.pos, t.text, env, fs, c);
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
    if (t.text == "-") {
        GT e = cg_unary(s, t.pos, env, fs, c);
        if (e.err != "") { return e; }
        Int t1 = e.tmp + 1;
        Str reg = "%t" + IntToString(t1);
        Str line = reg + " = sub i64 0, " + e.val;
        List(Str) le0 = e.lines;
        List(Str) nl2 = le0.concat([line]);
        return GT { pos: e.pos, val: reg, ty: "i64", cnt: 0, err: "", glines: e.glines, lines: nl2, tmp: t1, lbl: e.lbl };
    }
    return gt_err("unexpected token " + t.text, c);
}

GT cg_unary(Str s, Int pos, List(Str) env, Funcs fs, GT c) {
    return cg_primary(s, pos, env, fs, c);
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
    Int t1 = more.tmp + 1;
    Str reg = "%t" + IntToString(t1);
    Str op = bin_op(t.text);
    Str line = reg + " = " + op + " " + lhs.ty + " " + lhs.val + ", " + more.val;
    Str rty = if (bin_makes_bool(t.text)) { "i1" } else { "i64" };
    List(Str) lm0 = more.lines;
    List(Str) bl = lm0.concat([line]);
    GT out = GT { pos: more.pos, val: reg, ty: rty, cnt: 0, err: "", glines: more.glines, lines: bl, tmp: t1, lbl: more.lbl };
    return cg_bin_rest(s, out, min_prec, env, fs);
}

GT cg_expr(Str s, Int pos, List(Str) env, Funcs fs, GT c) {
    GT lhs = cg_unary(s, pos, env, fs, c);
    return cg_bin_rest(s, lhs, 1, env, fs);
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
        Str rn = "ret " + v.ty + " " + v.val;
        List(Str) lv0 = v.lines;
        List(Str) base = if (in_main) { lv0.concat([tr]) } else { lv0 };
        List(Str) lns = if (in_main) { base.concat([rl]) } else { base.concat([rn]) };
        Int ut = if (in_main) { t1 } else { v.tmp };
        return ST { pos: semi.pos, dead: true, err: "", env: env, glines: v.glines, hlines: g.hlines, lines: lns, tmp: ut, lbl: g.lbl };
    }
    if (t.text == "_") {
        Tok eq = lex_tok(s, t.pos);
        GT v = cg_expr(s, eq.pos, env, fs, gt_of_st(g));
        if (v.err != "") { return st_err(v.err, g); }
        Tok semi = lex_tok(s, v.pos);
        return ST { pos: semi.pos, dead: g.dead, err: "", env: env, glines: v.glines, hlines: g.hlines, lines: v.lines, tmp: v.tmp, lbl: g.lbl };
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
                if (ll_ty(pty.ty) == "") {
                    return st_err("unsupported bind type " + pty.ty, g);
                }
                GT v = cg_expr(s, t3.pos, env, fs, gt_of_st(g));
                if (v.err != "") { return st_err(v.err, g); }
                Tok semi = lex_tok(s, v.pos);
                Str ent = t2.text + ":" + v.val + ":" + v.ty;
                List(Str) env2 = env_add(env, ent);
                return ST { pos: semi.pos, dead: g.dead, err: "", env: env2, glines: v.glines, hlines: g.hlines, lines: v.lines, tmp: v.tmp, lbl: g.lbl };
            }
        }
        if (t2.text == "(") {
            PRes pty = parse_type(s, pos);
            if (pty.err == "") {
                Tok name = lex_tok(s, pty.pos);
                Tok eq = lex_tok(s, name.pos);
                if (eq.text == "=") {
                    if (ll_ty(pty.ty) == "") {
                        return st_err("unsupported bind type " + pty.ty, g);
                    }
                    GT v = cg_expr(s, eq.pos, env, fs, gt_of_st(g));
                    if (v.err != "") { return st_err(v.err, g); }
                    Tok semi = lex_tok(s, v.pos);
                    Str ent = name.text + ":" + v.val + ":" + v.ty;
                    List(Str) env2 = env_add(env, ent);
                    return ST { pos: semi.pos, dead: g.dead, err: "", env: env2, glines: v.glines, hlines: g.hlines, lines: v.lines, tmp: v.tmp, lbl: g.lbl };
                }
            }
        }
    }
    GT v = cg_expr(s, pos, env, fs, gt_of_st(g));
    if (v.err != "") { return st_err(v.err, g); }
    Tok semi = lex_tok(s, v.pos);
    return ST { pos: semi.pos, dead: g.dead, err: "", env: env, glines: v.glines, hlines: g.hlines, lines: v.lines, tmp: v.tmp, lbl: g.lbl };
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
    if (cond.ty != "i1") { return st_err("if condition must be Bool", g); }
    Tok close = lex_tok(s, cond.pos);
    Int l1 = g.lbl + 1;
    Int l2 = g.lbl + 2;
    Int l3 = g.lbl + 3;
    Str lt = "L" + IntToString(l1);
    Str le = "L" + IntToString(l2);
    Str ld = "L" + IntToString(l3);
    Str br1 = "br i1 " + cond.val + ", label %" + lt + ", label %" + le;
    Tok brace = lex_tok(s, close.pos);
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
        return st_err("if requires else", g);
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
    return ST { pos: ge.pos, dead: both, err: "", env: env, glines: ge.glines, hlines: ge.hlines, lines: lns4, tmp: ge.tmp, lbl: l3 };
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
    Str acc2 = acc + ", " + ty + " " + nm;
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
    if (ll_ty(pty.ty) != "i64") { return st_err("for-in var must be Int", g); }
    Tok name = lex_tok(s, pty.pos);
    Tok inkw = lex_tok(s, name.pos);
    if (inkw.text != "in") { return st_err("expected in", g); }
    GT a = cg_expr(s, inkw.pos, env, fs, gt_of_st(g));
    if (a.err != "") { return st_err(a.err, g); }
    Tok op = lex_tok(s, a.pos);
    if (op.text != ".." && op.text != "..=") { return st_err("expected range", g); }
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
    Str lent = name.text + ":" + kreg + ":i64";
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
    Str ent = nl[i] + ":%p" + IntToString(i) + ":" + ll_ty(tyl[i]);
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
    if (t.text == "type" || t.text == "import") {
        Int end = skip_decl(s, t.pos, 0);
        return pg_next(s, end, fs, g);
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

Bool str_has_prefix(Str s, Str p) {
    Int ns = str_len(s);
    Int np = str_len(p);
    if (np > ns) { return false; }
    Str head = str_slice(s, 0, np);
    if (head == p) { return true; }
    return false;
}

Str ck_env_lookup_at(List(Str) env, Str name, Int i) {
    Int n = env.len();
    if (i >= n) { return ""; }
    Str e = env[i];
    Int ci = str_find_char(e, 58, 0);
    if (ci >= 0) {
        Str en = str_slice(e, 0, ci);
        if (en == name) {
            Int m = str_len(e);
            Int ci2 = ci + 1;
            return str_slice(e, ci2, m);
        }
    }
    Int k = i + 1;
    return ck_env_lookup_at(env, name, k);
}

Str ck_env_lookup(List(Str) env, Str name) {
    return ck_env_lookup_at(env, name, 0);
}

List(Str) ck_env_add(List(Str) env, Str name, Str ty) {
    return env.concat([name + ":" + ty]);
}

// ─── Function signature table ──────────────────────────────────

type Sigs = { names: List(Str), pts: List(Str), rets: List(Str), stn: List(Str), stf: List(Str) };

Sigs sigs_empty() {
    return Sigs { names: [], pts: [], rets: [], stn: [], stf: [] };
}

Int ck_fn_index_at(Sigs f, Str name, Int i) {
    List(Str) nms = f.names;
    Int n = nms.len();
    if (i >= n) { return -1; }
    if (f.names[i] == name) { return i; }
    Int k = i + 1;
    return ck_fn_index_at(f, name, k);
}

Int ck_fn_index(Sigs f, Str name) {
    return ck_fn_index_at(f, name, 0);
}

Int struct_index_at(Sigs f, Str ty, Int i) {
    List(Str) sn = f.stn;
    Int n = sn.len();
    if (i >= n) { return -1; }
    if (f.stn[i] == ty) { return i; }
    Int k = i + 1;
    return struct_index_at(f, ty, k);
}

Int struct_index(Sigs f, Str ty) {
    return struct_index_at(f, ty, 0);
}

Str field_type_in(Str fields, Str field, Int pos) {
    Tok f = lex_tok(fields, pos);
    if (f.kind == "eof") { return ""; }
    if (f.kind != "ident") { return ""; }
    Tok colon = lex_tok(fields, f.pos);
    PRes ty = parse_type(fields, colon.pos);
    if (ty.err != "") { return ""; }
    if (f.text == field) { return ty.ty; }
    Tok comma = lex_tok(fields, ty.pos);
    if (comma.text == ",") { return field_type_in(fields, field, comma.pos); }
    return "";
}

Str struct_field_type(Sigs f, Str ty, Str field) {
    Int idx = struct_index(f, ty);
    if (idx < 0) { return ""; }
    return field_type_in(f.stf[idx], field, 0);
}

Str collect_field_str(Str s, Int pos) {
    Tok f = lex_tok(s, pos);
    if (f.text == "}") { return ""; }
    Tok colon = lex_tok(s, f.pos);
    PRes ty = parse_type(s, colon.pos);
    Tok comma = lex_tok(s, ty.pos);
    if (comma.text == ",") {
        Str rest = collect_field_str(s, comma.pos);
        if (rest == "") { return f.text + ":" + ty.ty; }
        return f.text + ":" + ty.ty + "," + rest;
    }
    return f.text + ":" + ty.ty;
}

// ─── Type parsing ───────────────────────────────────────────────

type ERes = { pos: Int, ty: Str, err: Str };

ERes check_struct_lit_rest(Str s, Int pos, Str ty, List(Str) env, Sigs fs) {
    Tok f = lex_tok(s, pos);
    if (f.text == "}") {
        return ERes { pos: f.pos, ty: ty, err: "" };
    }
    if (f.kind != "ident") {
        return ERes { pos: f.pos, ty: "", err: "expected field name in struct literal" };
    }
    Tok colon = lex_tok(s, f.pos);
    if (colon.text != ":") {
        return ERes { pos: colon.pos, ty: "", err: "expected : in struct literal" };
    }
    ERes v = check_expr(s, colon.pos, env, fs);
    if (v.err != "") { return v; }
    Str ft = struct_field_type(fs, ty, f.text);
    if (ft == "") {
        Str msg = "unknown field " + f.text + " in " + ty;
        return ERes { pos: f.pos, ty: "", err: msg };
    }
    Bool vempty = v.ty == "List(Unknown)";
    if (!vempty && v.ty != ft) {
        Str msg = "field " + f.text + ": expected " + ft + ", got " + v.ty;
        return ERes { pos: v.pos, ty: "", err: msg };
    }
    Tok t = lex_tok(s, v.pos);
    if (t.text == ",") {
        return check_struct_lit_rest(s, t.pos, ty, env, fs);
    }
    if (t.text == "}") {
        return ERes { pos: t.pos, ty: ty, err: "" };
    }
    return ERes { pos: t.pos, ty: "", err: "expected , or } in struct literal" };
}

ERes check_struct_lit(Str s, Int pos, Str ty, List(Str) env, Sigs fs) {
    return check_struct_lit_rest(s, pos, ty, env, fs);
}

Bool is_bin_op(Str op) {
    if (op == "+") { return true; }
    if (op == "-") { return true; }
    if (op == "*") { return true; }
    if (op == "/") { return true; }
    if (op == "%") { return true; }
    if (op == "<") { return true; }
    if (op == "<=") { return true; }
    if (op == ">") { return true; }
    if (op == ">=") { return true; }
    if (op == "==") { return true; }
    if (op == "!=") { return true; }
    if (op == "&&") { return true; }
    if (op == "||") { return true; }
    return false;
}

Bool is_num(Str t) {
    if (t == "Int") { return true; }
    if (t == "Float") { return true; }
    return false;
}

Str bin_type(Str op, Str a, Str b) {
    if (op == "..") { return "Range"; }
    if (op == "..=") { return "Range"; }
    if (op == "==") {
        if (a == b) { return "Bool"; }
        return "ERR";
    }
    if (op == "!=") {
        if (a == b) { return "Bool"; }
        return "ERR";
    }
    if (op == "<") {
        if (is_num(a)) {
            if (is_num(b)) { return "Bool"; }
        }
        return "ERR";
    }
    if (op == "<=") {
        if (is_num(a)) {
            if (is_num(b)) { return "Bool"; }
        }
        return "ERR";
    }
    if (op == ">") {
        if (is_num(a)) {
            if (is_num(b)) { return "Bool"; }
        }
        return "ERR";
    }
    if (op == ">=") {
        if (is_num(a)) {
            if (is_num(b)) { return "Bool"; }
        }
        return "ERR";
    }
    if (op == "&&") {
        if (a == "Bool") {
            if (b == "Bool") { return "Bool"; }
        }
        return "ERR";
    }
    if (op == "||") {
        if (a == "Bool") {
            if (b == "Bool") { return "Bool"; }
        }
        return "ERR";
    }
    if (op == "+") {
        if (is_num(a)) {
            if (is_num(b)) { return a; }
        }
        if (a == "Str") {
            if (b == "Str") { return "Str"; }
        }
        return "ERR";
    }
    if (is_num(a)) {
        if (is_num(b)) { return a; }
    }
    return "ERR";
}

Str inner_of(Str t) {
    // "List(X)" -> "X"
    Str head = "List(";
    Int h = str_len(head);
    if (str_has_prefix(t, head)) {
        Int n = str_len(t);
        Int inner_len = n - h - 1;
        Int hn = h + inner_len;
        return str_slice(t, h, hn);
    }
    return t;
}

Bool is_list_type(Str t) {
    return str_has_prefix(t, "List(");
}

ERes check_builtin(Str name, Str argtys, Int argc, Int pos) {
    if (name == "println") {
        if (argc == 1) {
            if (argtys == "Str") { return ERes { pos: pos, ty: "Bool", err: "" }; }
            return ERes { pos: pos, ty: "", err: "println expects Str, got " + argtys };
        }
        return ERes { pos: pos, ty: "", err: "println expects 1 argument" };
    }
    if (name == "print") {
        if (argc == 1) {
            if (argtys == "Str") { return ERes { pos: pos, ty: "Bool", err: "" }; }
            return ERes { pos: pos, ty: "", err: "print expects Str, got " + argtys };
        }
        return ERes { pos: pos, ty: "", err: "print expects 1 argument" };
    }
    if (name == "IntToString") {
        if (argc == 1) {
            if (argtys == "Int") { return ERes { pos: pos, ty: "Str", err: "" }; }
            return ERes { pos: pos, ty: "", err: "IntToString expects Int, got " + argtys };
        }
        return ERes { pos: pos, ty: "", err: "IntToString expects 1 argument" };
    }
    if (name == "UIntToString") {
        if (argc == 1) {
            if (argtys == "Int") { return ERes { pos: pos, ty: "Str", err: "" }; }
            return ERes { pos: pos, ty: "", err: "UIntToString expects UInt, got " + argtys };
        }
        return ERes { pos: pos, ty: "", err: "UIntToString expects 1 argument" };
    }
    if (name == "FloatToString") {
        if (argc == 1) {
            if (argtys == "Float") { return ERes { pos: pos, ty: "Str", err: "" }; }
            return ERes { pos: pos, ty: "", err: "FloatToString expects Float, got " + argtys };
        }
        return ERes { pos: pos, ty: "", err: "FloatToString expects 1 argument" };
    }
    if (name == "BoolToString") {
        if (argc == 1) {
            if (argtys == "Bool") { return ERes { pos: pos, ty: "Str", err: "" }; }
            return ERes { pos: pos, ty: "", err: "BoolToString expects Bool, got " + argtys };
        }
        return ERes { pos: pos, ty: "", err: "BoolToString expects 1 argument" };
    }
    if (name == "ToString") {
        if (argc == 1) { return ERes { pos: pos, ty: "Str", err: "" }; }
        return ERes { pos: pos, ty: "", err: "ToString expects 1 argument" };
    }
    if (name == "str_len") {
        if (argc == 1) {
            if (argtys == "Str") { return ERes { pos: pos, ty: "Int", err: "" }; }
            return ERes { pos: pos, ty: "", err: "str_len expects Str, got " + argtys };
        }
        return ERes { pos: pos, ty: "", err: "str_len expects 1 argument" };
    }
    if (name == "str_char_at") {
        if (argtys == "Str,Int") { return ERes { pos: pos, ty: "Int", err: "" }; }
        return ERes { pos: pos, ty: "", err: "str_char_at expects (Str, Int), got (" + argtys + ")" };
    }
    if (name == "str_from_code") {
        if (argtys == "Int") { return ERes { pos: pos, ty: "Str", err: "" }; }
        return ERes { pos: pos, ty: "", err: "str_from_code expects Int, got " + argtys };
    }
    if (name == "str_slice") {
        if (argtys == "Str,Int,Int") { return ERes { pos: pos, ty: "Str", err: "" }; }
        return ERes { pos: pos, ty: "", err: "str_slice expects (Str, Int, Int), got (" + argtys + ")" };
    }
    return ERes { pos: pos, ty: "", err: "unknown function " + name };
}

ERes finish_call(Str s, Int pos, Str name, Str argtys, Int argc, List(Str) env, Sigs fs) {
    Int idx = ck_fn_index(fs, name);
    if (idx >= 0) {
        Str pts = fs.pts[idx];
        if (pts == argtys) {
            return ERes { pos: pos, ty: fs.rets[idx], err: "" };
        }
        Str msg = "call " + name + " expects (" + pts + "), got (" + argtys + ")";
        return ERes { pos: pos, ty: "", err: msg };
    }
    return check_builtin(name, argtys, argc, pos);
}

type ARes = { pos: Int, tys: Str, count: Int, err: Str };

ARes collect_args(Str s, Int pos, Str acc, Int count, List(Str) env, Sigs fs) {
    ERes a = check_expr(s, pos, env, fs);
    if (a.err != "") {
        return ARes { pos: a.pos, tys: acc, count: count, err: a.err };
    }
    Str sep = if (acc != "") { "," } else { "" };
    Str acc3 = acc + sep + a.ty;
    Tok t = lex_tok(s, a.pos);
    if (t.text == ",") {
        Int c2 = count + 1;
        return collect_args(s, t.pos, acc3, c2, env, fs);
    }
    Int c2 = count + 1;
    return ARes { pos: t.pos, tys: acc3, count: c2, err: "" };
}

ERes check_call(Str s, Int pos, Str name, List(Str) env, Sigs fs) {
    Tok t = lex_tok(s, pos);
    if (t.text == ")") {
        return finish_call(s, t.pos, name, "", 0, env, fs);
    }
    ARes a = collect_args(s, pos, "", 0, env, fs);
    if (a.err != "") {
        return ERes { pos: a.pos, ty: "", err: a.err };
    }
    return finish_call(s, a.pos, name, a.tys, a.count, env, fs);
}

ERes check_list_lit_rest(Str s, Int pos, Str elem, List(Str) env, Sigs fs) {
    ERes e = check_expr(s, pos, env, fs);
    if (e.err != "") { return e; }
    Str elem2 = if (elem == "") { e.ty } else { elem };
    if (elem != "" && elem != e.ty) {
        Str msg = "list element type mismatch: " + elem + " vs " + e.ty;
        return ERes { pos: e.pos, ty: "", err: msg };
    }
    Tok t = lex_tok(s, e.pos);
    if (t.text == ",") {
        return check_list_lit_rest(s, t.pos, elem2, env, fs);
    }
    Str ty = "List(" + elem2 + ")";
    return ERes { pos: t.pos, ty: ty, err: "" };
}

ERes check_list_lit(Str s, Int pos, List(Str) env, Sigs fs) {
    Tok t = lex_tok(s, pos);
    if (t.text == "]") {
        return ERes { pos: t.pos, ty: "List(Unknown)", err: "" };
    }
    return check_list_lit_rest(s, pos, "", env, fs);
}

ERes check_postfix(Str s, ERes base, List(Str) env, Sigs fs) {
    Tok t = lex_tok(s, base.pos);
    if (t.text == "[") {
        Tok t2 = lex_tok(s, t.pos);
        if (t2.text == "..") {
            ERes end = check_expr(s, t2.pos, env, fs);
            if (end.err != "") { return end; }
            Tok close = lex_tok(s, end.pos);
            ERes out = ERes { pos: close.pos, ty: base.ty, err: "" };
            return check_postfix(s, out, env, fs);
        }
        ERes idx = check_expr(s, t.pos, env, fs);
        if (idx.err != "") { return idx; }
        Tok close = lex_tok(s, idx.pos);
        if (is_list_type(base.ty)) {
            Str elem = inner_of(base.ty);
            ERes out = ERes { pos: close.pos, ty: elem, err: "" };
            return check_postfix(s, out, env, fs);
        }
        Str msg = "cannot index " + base.ty;
        return ERes { pos: close.pos, ty: "", err: msg };
    }
    if (t.text == ".") {
        Tok f = lex_tok(s, t.pos);
        Tok p = lex_tok(s, f.pos);
        if (p.text == "(") {
            if (f.text == "len") {
                Tok close = lex_tok(s, p.pos);
                if (close.text != ")") {
                    return ERes { pos: close.pos, ty: "", err: ".len() takes no arguments" };
                }
                ERes out = ERes { pos: close.pos, ty: "Int", err: "" };
                return check_postfix(s, out, env, fs);
            }
            if (f.text == "concat") {
                ERes arg = check_expr(s, p.pos, env, fs);
                if (arg.err != "") { return arg; }
                Tok close = lex_tok(s, arg.pos);
                ERes out = ERes { pos: close.pos, ty: base.ty, err: "" };
                return check_postfix(s, out, env, fs);
            }
            Str msg = "unsupported method " + f.text;
            return ERes { pos: p.pos, ty: "", err: msg };
        }
        Str fty = struct_field_type(fs, base.ty, f.text);
        if (fty == "") {
            Str msg = "field " + f.text + " not found in " + base.ty;
            return ERes { pos: f.pos, ty: "", err: msg };
        }
        ERes out = ERes { pos: f.pos, ty: fty, err: "" };
        return check_postfix(s, out, env, fs);
    }
    return base;
}

ERes check_primary(Str s, Int pos, List(Str) env, Sigs fs) {
    Tok t = lex_tok(s, pos);
    if (t.kind == "int") {
        return ERes { pos: t.pos, ty: "Int", err: "" };
    }
    if (t.kind == "float") {
        return ERes { pos: t.pos, ty: "Float", err: "" };
    }
    if (t.kind == "str") {
        return ERes { pos: t.pos, ty: "Str", err: "" };
    }
    if (t.kind == "raw") {
        return ERes { pos: t.pos, ty: "Str", err: "" };
    }
    if (t.kind == "fstring") {
        return ERes { pos: t.pos, ty: "Str", err: "" };
    }
    if (t.kind == "char") {
        return ERes { pos: t.pos, ty: "Str", err: "" };
    }
    if (t.text == "true") {
        return ERes { pos: t.pos, ty: "Bool", err: "" };
    }
    if (t.text == "false") {
        return ERes { pos: t.pos, ty: "Bool", err: "" };
    }
    if (t.text == "if") {
        Tok open = lex_tok(s, t.pos);
        ERes cond = check_expr(s, open.pos, env, fs);
        if (cond.err != "") { return cond; }
        if (cond.ty != "Bool") {
            Str msg = "if condition must be Bool, got " + cond.ty;
            return ERes { pos: cond.pos, ty: "", err: msg };
        }
        Tok cpar = lex_tok(s, cond.pos);
        Tok brace = lex_tok(s, cpar.pos);
        ERes then_e = check_expr(s, brace.pos, env, fs);
        if (then_e.err != "") { return then_e; }
        Tok close = lex_tok(s, then_e.pos);
        if (close.text != "}") {
            return ERes { pos: close.pos, ty: "", err: "expected } in if expression" };
        }
        Tok kw = lex_tok(s, close.pos);
        if (kw.text != "else") {
            return ERes { pos: kw.pos, ty: "", err: "if expression requires else" };
        }
        Tok brace2 = lex_tok(s, kw.pos);
        ERes else_e = check_expr(s, brace2.pos, env, fs);
        if (else_e.err != "") { return else_e; }
        if (then_e.ty != else_e.ty) {
            Str msg = "if branches differ: " + then_e.ty + " vs " + else_e.ty;
            return ERes { pos: else_e.pos, ty: "", err: msg };
        }
        Tok close2 = lex_tok(s, else_e.pos);
        return ERes { pos: close2.pos, ty: then_e.ty, err: "" };
    }
    if (t.kind == "ident") {
        Tok t2 = lex_tok(s, t.pos);
        if (t2.text == "(") {
            return check_call(s, t2.pos, t.text, env, fs);
        }
        if (t2.text == "{") {
            return check_struct_lit(s, t2.pos, t.text, env, fs);
        }
        if (t2.text == ".") {
            Bool is_prov0 = t.text == "environment" || t.text == "filesystem" || t.text == "args" || t.text == "process";
            Str shadow = ck_env_lookup(env, t.text);
            Bool is_prov = if (shadow == "") { is_prov0 } else { false };
            if (is_prov) {
                Tok m = lex_tok(s, t2.pos);
                Tok p = lex_tok(s, m.pos);
                if (p.text == "(") {
                    Tok p0 = lex_tok(s, p.pos);
                    if (p0.text == ")") {
                        if (t.text == "args") {
                            if (m.text == "count") { return ERes { pos: p0.pos, ty: "Int", err: "" }; }
                        }
                        if (t.text == "git") {
                            if (m.text == "branch") { return ERes { pos: p0.pos, ty: "Str", err: "" }; }
                        }
                        Str msg0 = "unknown provider method " + t.text + "." + m.text;
                        return ERes { pos: p0.pos, ty: "", err: msg0 };
                    }
                    ARes a = collect_args(s, p.pos, "", 0, env, fs);
                    if (a.err != "") {
                        return ERes { pos: a.pos, ty: "", err: a.err };
                    }
                    if (t.text == "environment") {
                        if (m.text == "get") { return ERes { pos: a.pos, ty: "Str", err: "" }; }
                    }
                    if (t.text == "filesystem") {
                        if (m.text == "read_all") { return ERes { pos: a.pos, ty: "Str", err: "" }; }
                        if (m.text == "write_all") { return ERes { pos: a.pos, ty: "Bool", err: "" }; }
                    }
                    if (t.text == "args") {
                        if (m.text == "count") { return ERes { pos: a.pos, ty: "Int", err: "" }; }
                        if (m.text == "get") { return ERes { pos: a.pos, ty: "Str", err: "" }; }
                    }
                    if (t.text == "process") {
                        if (m.text == "run") { return ERes { pos: a.pos, ty: "Int", err: "" }; }
                    }
                    Str msg = "unknown provider method " + t.text + "." + m.text;
                    return ERes { pos: a.pos, ty: "", err: msg };
                }
                Str msg2 = "expected ( after provider method";
                return ERes { pos: m.pos, ty: "", err: msg2 };
            }
        }
        Str ty = ck_env_lookup(env, t.text);
        if (ty == "") {
            Str msg = "undefined variable " + t.text;
            return ERes { pos: t.pos, ty: "", err: msg };
        }
        return ERes { pos: t.pos, ty: ty, err: "" };
    }
    if (t.text == "(") {
        ERes e = check_expr(s, t.pos, env, fs);
        if (e.err != "") { return e; }
        Tok close = lex_tok(s, e.pos);
        return ERes { pos: close.pos, ty: e.ty, err: "" };
    }
    if (t.text == "[") {
        return check_list_lit(s, t.pos, env, fs);
    }
    Str msg = "unexpected token " + t.text;
    return ERes { pos: t.pos, ty: "", err: msg };
}

ERes check_unary(Str s, Int pos, List(Str) env, Sigs fs) {
    Tok t = lex_tok(s, pos);
    if (t.text == "-") {
        ERes inner = check_unary(s, t.pos, env, fs);
        if (inner.err != "") { return inner; }
        if (is_num(inner.ty)) {
            return ERes { pos: inner.pos, ty: inner.ty, err: "" };
        }
        Str msg = "unary - requires a number, got " + inner.ty;
        return ERes { pos: inner.pos, ty: "", err: msg };
    }
    if (t.text == "+") {
        ERes inner = check_unary(s, t.pos, env, fs);
        if (inner.err != "") { return inner; }
        if (is_num(inner.ty)) {
            return ERes { pos: inner.pos, ty: inner.ty, err: "" };
        }
        Str msg = "unary + requires a number, got " + inner.ty;
        return ERes { pos: inner.pos, ty: "", err: msg };
    }
    if (t.text == "!") {
        ERes inner = check_unary(s, t.pos, env, fs);
        if (inner.err != "") { return inner; }
        if (inner.ty == "Bool") {
            return ERes { pos: inner.pos, ty: "Bool", err: "" };
        }
        Str msg = "! requires Bool, got " + inner.ty;
        return ERes { pos: inner.pos, ty: "", err: msg };
    }
    ERes p = check_primary(s, pos, env, fs);
    if (p.err != "") { return p; }
    return check_postfix(s, p, env, fs);
}

Int ck_op_prec(Str op) {
    if (op == "..") { return 1; }
    if (op == "..=") { return 1; }
    if (op == "||") { return 2; }
    if (op == "&&") { return 3; }
    if (op == "==") { return 4; }
    if (op == "!=") { return 4; }
    if (op == "<") { return 5; }
    if (op == "<=") { return 5; }
    if (op == ">") { return 5; }
    if (op == ">=") { return 5; }
    if (op == "+") { return 6; }
    if (op == "-") { return 6; }
    if (op == "*") { return 7; }
    if (op == "/") { return 7; }
    if (op == "%") { return 7; }
    return 0;
}

ERes check_bin_rest(Str s, ERes lhs, Int min_prec, List(Str) env, Sigs fs) {
    Tok t = lex_tok(s, lhs.pos);
    Str op = t.text;
    Int prec = ck_op_prec(op);
    if (prec == 0 || prec < min_prec) {
        return lhs;
    }
    ERes rhs = check_unary(s, t.pos, env, fs);
    if (rhs.err != "") { return rhs; }
    Bool right_assoc = op == ".." || op == "..=";
    Int pm = prec + 1;
    Int next_min = if (right_assoc) { prec } else { pm };
    ERes rhs2 = check_bin_rest(s, rhs, next_min, env, fs);
    Str bt = bin_type(op, lhs.ty, rhs2.ty);
    if (bt == "ERR") {
        Str msg = "operator " + op + " between " + lhs.ty + " and " + rhs2.ty;
        return ERes { pos: rhs2.pos, ty: "", err: msg };
    }
    ERes r = ERes { pos: rhs2.pos, ty: bt, err: "" };
    return check_bin_rest(s, r, min_prec, env, fs);
}

ERes check_expr(Str s, Int pos, List(Str) env, Sigs fs) {
    ERes u = check_unary(s, pos, env, fs);
    if (u.err != "") { return u; }
    return check_bin_rest(s, u, 1, env, fs);
}

// ─── Statement checking ─────────────────────────────────────────

type SRes = { pos: Int, err: Str, env: List(Str) };

SRes check_block_rest(Str s, Int pos, List(Str) env, Sigs fs, Str ret) {
    Tok t = lex_tok(s, pos);
    if (t.text == "}") {
        return SRes { pos: t.pos, err: "", env: env };
    }
    SRes st = check_stmt(s, pos, env, fs, ret);
    if (st.err != "") {
        return SRes { pos: st.pos, err: st.err, env: env };
    }
    return check_block_rest(s, st.pos, st.env, fs, ret);
}

SRes check_block(Str s, Int pos, List(Str) env, Sigs fs, Str ret) {
    Tok t = lex_tok(s, pos);
    Tok end = lex_tok(s, t.pos);
    if (end.text == "}") {
        return SRes { pos: end.pos, err: "", env: env };
    }
    return check_block_rest(s, t.pos, env, fs, ret);
}

SRes check_if(Str s, Int pos, List(Str) env, Sigs fs, Str ret) {
    Tok open = lex_tok(s, pos);
    ERes cond = check_expr(s, open.pos, env, fs);
    if (cond.err != "") {
        return SRes { pos: cond.pos, err: cond.err, env: env };
    }
    if (cond.ty != "Bool") {
        Str msg = "if condition must be Bool, got " + cond.ty;
        return SRes { pos: cond.pos, err: msg, env: env };
    }
    Tok close = lex_tok(s, cond.pos);
    SRes then = check_stmt(s, close.pos, env, fs, ret);
    if (then.err != "") { return then; }
    Tok t = lex_tok(s, then.pos);
    if (t.text == "else") {
        SRes other = check_stmt(s, t.pos, env, fs, ret);
        if (other.err != "") { return other; }
        return SRes { pos: other.pos, err: "", env: env };
    }
    return SRes { pos: then.pos, err: "", env: env };
}

SRes check_while(Str s, Int pos, List(Str) env, Sigs fs, Str ret) {
    Tok open = lex_tok(s, pos);
    ERes cond = check_expr(s, open.pos, env, fs);
    if (cond.err != "") {
        return SRes { pos: cond.pos, err: cond.err, env: env };
    }
    if (cond.ty != "Bool") {
        Str msg = "while condition must be Bool, got " + cond.ty;
        return SRes { pos: cond.pos, err: msg, env: env };
    }
    Tok close = lex_tok(s, cond.pos);
    SRes body = check_stmt(s, close.pos, env, fs, ret);
    if (body.err != "") { return body; }
    return SRes { pos: body.pos, err: "", env: env };
}

SRes check_for(Str s, Int pos, List(Str) env, Sigs fs, Str ret) {
    Tok open = lex_tok(s, pos);
    Tok ty = lex_tok(s, open.pos);
    Tok nm = lex_tok(s, ty.pos);
    Tok in_kw = lex_tok(s, nm.pos);
    if (in_kw.text != "in") {
        return SRes { pos: in_kw.pos, err: "expected `in` in for statement", env: env };
    }
    ERes col = check_expr(s, in_kw.pos, env, fs);
    if (col.err != "") {
        return SRes { pos: col.pos, err: col.err, env: env };
    }
    Bool is_range = col.ty == "Range";
    Bool is_list = is_list_type(col.ty);
    Bool iterable = is_range || is_list;
    if (!iterable) {
        Str msg = "for-in over non-iterable " + col.ty;
        return SRes { pos: col.pos, err: msg, env: env };
    }
    Tok close = lex_tok(s, col.pos);
    List(Str) env2 = ck_env_add(env, nm.text, ty.text);
    SRes body = check_stmt(s, close.pos, env2, fs, ret);
    if (body.err != "") { return body; }
    return SRes { pos: body.pos, err: "", env: env };
}

SRes check_bind(Str s, Int pos, Str ty, Str name, List(Str) env, Sigs fs, Str ret) {
    ERes v = check_expr(s, pos, env, fs);
    if (v.err != "") {
        return SRes { pos: v.pos, err: v.err, env: env };
    }
    if (v.ty != ty) {
        Bool vempty = v.ty == "List(Unknown)";
        Bool listty = str_has_prefix(ty, "List(");
        Bool coerce = vempty && listty;
        if (!coerce) {
            Str msg = "binding " + name + ": expected " + ty + ", got " + v.ty;
            return SRes { pos: v.pos, err: msg, env: env };
        }
    }
    Tok semi = lex_tok(s, v.pos);
    List(Str) env2 = ck_env_add(env, name, ty);
    return SRes { pos: semi.pos, err: "", env: env2 };
}

SRes check_stmt(Str s, Int pos, List(Str) env, Sigs fs, Str ret) {
    Tok t = lex_tok(s, pos);
    if (t.text == "return") {
        Tok e = lex_tok(s, t.pos);
        if (e.text == ";") {
            if (ret == "") {
                return SRes { pos: e.pos, err: "", env: env };
            }
            Str msg = "return without a value in a " + ret + " function";
            return SRes { pos: e.pos, err: msg, env: env };
        }
        ERes v = check_expr(s, t.pos, env, fs);
        if (v.err != "") {
            return SRes { pos: v.pos, err: v.err, env: env };
        }
        if (v.ty != ret) {
            Str msg = "return type " + v.ty + " does not match " + ret;
            return SRes { pos: v.pos, err: msg, env: env };
        }
        Tok semi = lex_tok(s, v.pos);
        return SRes { pos: semi.pos, err: "", env: env };
    }
    if (t.text == "break") {
        Tok semi = lex_tok(s, t.pos);
        return SRes { pos: semi.pos, err: "", env: env };
    }
    if (t.text == "continue") {
        Tok semi = lex_tok(s, t.pos);
        return SRes { pos: semi.pos, err: "", env: env };
    }
    if (t.text == "if") {
        return check_if(s, t.pos, env, fs, ret);
    }
    if (t.text == "while") {
        return check_while(s, t.pos, env, fs, ret);
    }
    if (t.text == "for") {
        return check_for(s, t.pos, env, fs, ret);
    }
    if (t.text == "{") {
        return check_block(s, pos, env, fs, ret);
    }
    if (t.kind == "ident") {
        if (t.text == "_") {
            Tok eq = lex_tok(s, t.pos);
            if (eq.text == "=") {
                ERes v = check_expr(s, eq.pos, env, fs);
                if (v.err != "") {
                    return SRes { pos: v.pos, err: v.err, env: env };
                }
                Tok semi = lex_tok(s, v.pos);
                return SRes { pos: semi.pos, err: "", env: env };
            }
        }
        Tok t2 = lex_tok(s, t.pos);
        if (t2.kind == "ident") {
            Tok t3 = lex_tok(s, t2.pos);
            if (t3.text == "=") {
                return check_bind(s, t3.pos, t.text, t2.text, env, fs, ret);
            }
        }
        if (t2.text == "(") {
            PRes ty = parse_type(s, pos);
            if (ty.err == "") {
                Tok name = lex_tok(s, ty.pos);
                Tok eq = lex_tok(s, name.pos);
                if (eq.text == "=") {
                    return check_bind(s, eq.pos, ty.ty, name.text, env, fs, ret);
                }
            }
        }
    }
    ERes e = check_expr(s, pos, env, fs);
    if (e.err != "") {
        return SRes { pos: e.pos, err: e.err, env: env };
    }
    Tok semi = lex_tok(s, e.pos);
    return SRes { pos: semi.pos, err: "", env: env };
}

// ─── Function checking ──────────────────────────────────────────

type DRes = { pos: Int, err: Str, name: Str };

SRes check_params(Str s, Int pos, Str fname, Str rty, List(Str) env, Sigs fs) {
    PRes pty = parse_type(s, pos);
    if (pty.err != "") {
        return SRes { pos: pty.pos, err: pty.err, env: env };
    }
    Tok pname = lex_tok(s, pty.pos);
    if (pname.kind != "ident") {
        return SRes { pos: pname.pos, err: "expected parameter name", env: env };
    }
    List(Str) env2 = ck_env_add(env, pname.text, pty.ty);
    Tok t = lex_tok(s, pname.pos);
    if (t.text == ",") {
        return check_params(s, t.pos, fname, rty, env2, fs);
    }
    SRes body = check_block(s, t.pos, env2, fs, rty);
    if (body.err != "") {
        return SRes { pos: body.pos, err: body.err, env: env2 };
    }
    return SRes { pos: body.pos, err: "", env: env2 };
}

DRes check_func(Str s, Int pos, Sigs fs) {
    PRes rty = parse_type(s, pos);
    if (rty.err != "") {
        return DRes { pos: rty.pos, err: rty.err, name: "" };
    }
    Tok name = lex_tok(s, rty.pos);
    if (name.kind != "ident") {
        return DRes { pos: name.pos, err: "expected function name", name: "" };
    }
    Tok open = lex_tok(s, name.pos);
    Tok first = lex_tok(s, open.pos);
    List(Str) env0 = [];
    if (first.text == ")") {
        SRes body = check_block(s, first.pos, env0, fs, rty.ty);
        if (body.err != "") {
            return DRes { pos: body.pos, err: body.err, name: name.text };
        }
        return DRes { pos: body.pos, err: "", name: name.text };
    }
    SRes body = check_params(s, open.pos, name.text, rty.ty, env0, fs);
    if (body.err != "") {
        return DRes { pos: body.pos, err: body.err, name: name.text };
    }
    return DRes { pos: body.pos, err: "", name: name.text };
}

// ─── Program walk ───────────────────────────────────────────────

Int ck_skip_decl(Str s, Int pos, Int depth) {
    Tok t = lex_tok(s, pos);
    if (t.kind == "eof") { return t.pos; }
    if (t.text == "{") {
        Int d = depth + 1;
        return ck_skip_decl(s, t.pos, d);
    }
    if (t.text == "}") {
        if (depth <= 1) { return t.pos; }
        Int d = depth - 1;
        return ck_skip_decl(s, t.pos, d);
    }
    if (t.text == ";") {
        if (depth == 0) { return t.pos; }
        return ck_skip_decl(s, t.pos, depth);
    }
    return ck_skip_decl(s, t.pos, depth);
}

Str ck_collect_ptypes(Str s, Int pos, Str acc) {
    Tok t = lex_tok(s, pos);
    if (t.text == ")") { return acc; }
    PRes pty = parse_type(s, pos);
    Tok pn = lex_tok(s, pty.pos);
    Tok t2 = lex_tok(s, pn.pos);
    if (t2.text == ",") {
        Str sep = if (acc != "") { "," } else { "" };
        Str acc3 = acc + sep + pty.ty;
        return ck_collect_ptypes(s, t2.pos, acc3);
    }
    Str sep2 = if (acc != "") { "," } else { "" };
    return acc + sep2 + pty.ty;
}

Sigs ck_collect_sigs_at(Str s, Int pos, Sigs fs) {
    Tok t = lex_tok(s, pos);
    if (t.kind == "eof") { return fs; }
    if (t.text == "type") {
        Tok tname = lex_tok(s, t.pos);
        Tok teq = lex_tok(s, tname.pos);
        Tok tbrace = lex_tok(s, teq.pos);
        Int end = ck_skip_decl(s, t.pos, 0);
        if (tbrace.text == "{") {
            Str fstr = collect_field_str(s, tbrace.pos);
            List(Str) sn1 = fs.stn;
            List(Str) sf1 = fs.stf;
            List(Str) sn2 = sn1.concat([tname.text]);
            List(Str) sf2 = sf1.concat([fstr]);
            Sigs fsx = Sigs { names: fs.names, pts: fs.pts, rets: fs.rets, stn: sn2, stf: sf2 };
            return ck_collect_sigs_at(s, end, fsx);
        }
        return ck_collect_sigs_at(s, end, fs);
    }
    if (t.text == "import") {
        Int end = ck_skip_decl(s, t.pos, 0);
        return ck_collect_sigs_at(s, end, fs);
    }
    if (t.text == "pub") {
        Tok t2 = lex_tok(s, t.pos);
        return ck_collect_sigs_at(s, t2.pos, fs);
    }
    if (t.kind == "ident") {
        PRes rty = parse_type(s, pos);
        if (rty.err != "") {
            return ck_collect_sigs_at(s, rty.pos, fs);
        }
        Tok name = lex_tok(s, rty.pos);
        Tok open = lex_tok(s, name.pos);
        Str pts = ck_collect_ptypes(s, open.pos, "");
        Int end = skip_body(s, t2_pos_after_open(s, open));
        List(Str) n1 = fs.names;
        List(Str) p1 = fs.pts;
        List(Str) r1 = fs.rets;
        List(Str) names2 = n1.concat([name.text]);
        List(Str) pts2 = p1.concat([pts]);
        List(Str) rets2 = r1.concat([rty.ty]);
        Sigs fs2 = Sigs { names: names2, pts: pts2, rets: rets2, stn: fs.stn, stf: fs.stf };
        return ck_collect_sigs_at(s, end, fs2);
    }
    return ck_collect_sigs_at(s, t.pos, fs);
}

Int t2_pos_after_open(Str s, Tok open) {
    return open.pos;
}

Sigs ck_collect_sigs(Str s) {
    return ck_collect_sigs_at(s, 0, sigs_empty());
}

Int ck_check_program(Str s, Int pos, Sigs fs) {
    Tok t = lex_tok(s, pos);
    if (t.kind == "eof") {
        return 0;
    }
    if (t.text == "type") {
        Int end = ck_skip_decl(s, t.pos, 0);
        return ck_check_program(s, end, fs);
    }
    if (t.text == "import") {
        Int end = ck_skip_decl(s, t.pos, 0);
        return ck_check_program(s, end, fs);
    }
    if (t.text == "pub") {
        Tok t2 = lex_tok(s, t.pos);
        return ck_check_program(s, t2.pos, fs);
    }
    if (t.text == ";") {
        return ck_check_program(s, t.pos, fs);
    }
    if (t.kind == "ident") {
        DRes d = check_func(s, pos, fs);
        if (d.err != "") {
            println("type error: " + d.err);
            return 1;
        }
        return ck_check_program(s, d.pos, fs);
    }
    println("type error: unexpected declaration");
    return 1;
}

// ─── Driver: typecheck → codegen → clang ──────────────────────

Str pick_opt(Int i, Str flag, Str acc) {
    if (i <= 1) { return acc; }
    Str a = args.get(i);
    Int ip = i + 1;
    Str nxt = args.get(ip);
    Str acc2 = if (a == flag) { nxt } else { acc };
    Int k = i - 1;
    return pick_opt(k, flag, acc2);
}

Int main() {
    Int argc = args.count();
    if (argc < 2) {
        println("usage: driver <source.res> [-o out] [-rt resid_rt.c]");
        return 1;
    }
    Str path = args.get(1);
    Str out = pick_opt(argc, "-o", "a.out");
    Str rtc = pick_opt(argc, "-rt", "crates/residc/resid_rt.c");
    Str src = filesystem.read_all(path);
    Sigs sg = ck_collect_sigs(src);
    Int tc = ck_check_program(src, 0, sg);
    if (tc != 0) { return tc; }
    Funcs fs = collect_sigs(src);
    List(Str) header = ["declare i32 @printf(ptr, ...)", "declare i32 @puts(ptr)", "@.fmt.p = private unnamed_addr constant [3 x i8] c\"%s\\00\""];
    PG g0 = PG { pos: 0, err: "", glines: [], hlines: [], lines: header, tmp: 0, lbl: 0 };
    PG res = pg_next(src, 0, fs, g0);
    if (res.err != "") {
        println("codegen error: " + res.err);
        return 1;
    }
    List(Str) ol = res.lines;
    List(Str) mid = ol.concat(res.hlines);
    List(Str) all = mid.concat(res.glines);
    Str doc = join_lines(all, 0, "");
    Str ll = out + ".ll";
    filesystem.write_all(ll, doc);
    Str cmd = "clang " + ll + " " + rtc + " -Wno-override-module -pthread -o " + out;
    Int rc = process.run(cmd);
    if (rc != 0) {
        println("clang failed");
        return 1;
    }
    println("wrote " + out);
    return 0;
}
