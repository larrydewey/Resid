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

// ─── Environment: List(Str) of "name:type" entries ─────────────

Int str_find_char(Str s, Int c, Int i) {
    Int n = str_len(s);
    if (i >= n) { return -1; }
    Int ch = str_char_at(s, i);
    if (ch == c) { return i; }
    Int k = i + 1;
    return str_find_char(s, c, k);
}

Bool str_has_prefix(Str s, Str p) {
    Int ns = str_len(s);
    Int np = str_len(p);
    if (np > ns) { return false; }
    Str head = str_slice(s, 0, np);
    if (head == p) { return true; }
    return false;
}

Str env_lookup_at(List(Str) env, Str name, Int i) {
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
    return env_lookup_at(env, name, k);
}

Str env_lookup(List(Str) env, Str name) {
    return env_lookup_at(env, name, 0);
}

List(Str) env_add(List(Str) env, Str name, Str ty) {
    return env.concat([name + ":" + ty]);
}

// ─── Function signature table ──────────────────────────────────

type Funcs = { names: List(Str), pts: List(Str), rets: List(Str), stn: List(Str), stf: List(Str) };

Funcs funcs_empty() {
    return Funcs { names: [], pts: [], rets: [], stn: [], stf: [] };
}

Int fn_index_at(Funcs f, Str name, Int i) {
    List(Str) nms = f.names;
    Int n = nms.len();
    if (i >= n) { return -1; }
    if (f.names[i] == name) { return i; }
    Int k = i + 1;
    return fn_index_at(f, name, k);
}

Int fn_index(Funcs f, Str name) {
    return fn_index_at(f, name, 0);
}

Int struct_index_at(Funcs f, Str ty, Int i) {
    List(Str) sn = f.stn;
    Int n = sn.len();
    if (i >= n) { return -1; }
    if (f.stn[i] == ty) { return i; }
    Int k = i + 1;
    return struct_index_at(f, ty, k);
}

Int struct_index(Funcs f, Str ty) {
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

Str struct_field_type(Funcs f, Str ty, Str field) {
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

type PRes = { pos: Int, ty: Str, err: Str };

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

// ─── Expression checking ────────────────────────────────────────

type ERes = { pos: Int, ty: Str, err: Str };

ERes check_struct_lit_rest(Str s, Int pos, Str ty, List(Str) env, Funcs fs) {
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

ERes check_struct_lit(Str s, Int pos, Str ty, List(Str) env, Funcs fs) {
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

ERes finish_call(Str s, Int pos, Str name, Str argtys, Int argc, List(Str) env, Funcs fs) {
    Int idx = fn_index(fs, name);
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

ARes collect_args(Str s, Int pos, Str acc, Int count, List(Str) env, Funcs fs) {
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

ERes check_call(Str s, Int pos, Str name, List(Str) env, Funcs fs) {
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

ERes check_list_lit_rest(Str s, Int pos, Str elem, List(Str) env, Funcs fs) {
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

ERes check_list_lit(Str s, Int pos, List(Str) env, Funcs fs) {
    Tok t = lex_tok(s, pos);
    if (t.text == "]") {
        return ERes { pos: t.pos, ty: "List(Unknown)", err: "" };
    }
    return check_list_lit_rest(s, pos, "", env, fs);
}

ERes check_postfix(Str s, ERes base, List(Str) env, Funcs fs) {
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

ERes check_primary(Str s, Int pos, List(Str) env, Funcs fs) {
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
            Str shadow = env_lookup(env, t.text);
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
        Str ty = env_lookup(env, t.text);
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

ERes check_unary(Str s, Int pos, List(Str) env, Funcs fs) {
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

Int op_prec(Str op) {
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

ERes check_bin_rest(Str s, ERes lhs, Int min_prec, List(Str) env, Funcs fs) {
    Tok t = lex_tok(s, lhs.pos);
    Str op = t.text;
    Int prec = op_prec(op);
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

ERes check_expr(Str s, Int pos, List(Str) env, Funcs fs) {
    ERes u = check_unary(s, pos, env, fs);
    if (u.err != "") { return u; }
    return check_bin_rest(s, u, 1, env, fs);
}

// ─── Statement checking ─────────────────────────────────────────

type SRes = { pos: Int, err: Str, env: List(Str) };

SRes check_block_rest(Str s, Int pos, List(Str) env, Funcs fs, Str ret) {
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

SRes check_block(Str s, Int pos, List(Str) env, Funcs fs, Str ret) {
    Tok t = lex_tok(s, pos);
    Tok end = lex_tok(s, t.pos);
    if (end.text == "}") {
        return SRes { pos: end.pos, err: "", env: env };
    }
    return check_block_rest(s, t.pos, env, fs, ret);
}

SRes check_if(Str s, Int pos, List(Str) env, Funcs fs, Str ret) {
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

SRes check_while(Str s, Int pos, List(Str) env, Funcs fs, Str ret) {
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

SRes check_for(Str s, Int pos, List(Str) env, Funcs fs, Str ret) {
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
    List(Str) env2 = env_add(env, nm.text, ty.text);
    SRes body = check_stmt(s, close.pos, env2, fs, ret);
    if (body.err != "") { return body; }
    return SRes { pos: body.pos, err: "", env: env };
}

SRes check_bind(Str s, Int pos, Str ty, Str name, List(Str) env, Funcs fs, Str ret) {
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
    List(Str) env2 = env_add(env, name, ty);
    return SRes { pos: semi.pos, err: "", env: env2 };
}

SRes check_stmt(Str s, Int pos, List(Str) env, Funcs fs, Str ret) {
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

SRes check_params(Str s, Int pos, Str fname, Str rty, List(Str) env, Funcs fs) {
    PRes pty = parse_type(s, pos);
    if (pty.err != "") {
        return SRes { pos: pty.pos, err: pty.err, env: env };
    }
    Tok pname = lex_tok(s, pty.pos);
    if (pname.kind != "ident") {
        return SRes { pos: pname.pos, err: "expected parameter name", env: env };
    }
    List(Str) env2 = env_add(env, pname.text, pty.ty);
    Tok t = lex_tok(s, pname.pos);
    if (t.text == ",") {
        return check_params(s, t.pos, fname, rty, env2, fs);
    }
    SRes body = check_block(s, t.pos, env2, fs, rty);
    if (body.err != "") {
        return SRes { pos: body.pos, err: body.err, env: env2 };
    }
    println("OK func " + fname);
    return SRes { pos: body.pos, err: "", env: env2 };
}

DRes check_func(Str s, Int pos, Funcs fs) {
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
        println("OK func " + name.text);
        return DRes { pos: body.pos, err: "", name: name.text };
    }
    SRes body = check_params(s, open.pos, name.text, rty.ty, env0, fs);
    if (body.err != "") {
        return DRes { pos: body.pos, err: body.err, name: name.text };
    }
    return DRes { pos: body.pos, err: "", name: name.text };
}

// ─── Program walk ───────────────────────────────────────────────

Int skip_decl(Str s, Int pos, Int depth) {
    Tok t = lex_tok(s, pos);
    if (t.kind == "eof") { return t.pos; }
    if (t.text == "{") {
        Int d = depth + 1;
        return skip_decl(s, t.pos, d);
    }
    if (t.text == "}") {
        if (depth <= 1) { return t.pos; }
        Int d = depth - 1;
        return skip_decl(s, t.pos, d);
    }
    if (t.text == ";") {
        if (depth == 0) { return t.pos; }
        return skip_decl(s, t.pos, depth);
    }
    return skip_decl(s, t.pos, depth);
}

Int skip_body(Str s, Int pos) {
    return skip_decl(s, pos, 0);
}

Str collect_ptypes(Str s, Int pos, Str acc) {
    Tok t = lex_tok(s, pos);
    if (t.text == ")") { return acc; }
    PRes pty = parse_type(s, pos);
    Tok pn = lex_tok(s, pty.pos);
    Tok t2 = lex_tok(s, pn.pos);
    if (t2.text == ",") {
        Str sep = if (acc != "") { "," } else { "" };
        Str acc3 = acc + sep + pty.ty;
        return collect_ptypes(s, t2.pos, acc3);
    }
    Str sep2 = if (acc != "") { "," } else { "" };
    return acc + sep2 + pty.ty;
}

Funcs collect_sigs_at(Str s, Int pos, Funcs fs) {
    Tok t = lex_tok(s, pos);
    if (t.kind == "eof") { return fs; }
    if (t.text == "type") {
        Tok tname = lex_tok(s, t.pos);
        Tok teq = lex_tok(s, tname.pos);
        Tok tbrace = lex_tok(s, teq.pos);
        Int end = skip_decl(s, t.pos, 0);
        if (tbrace.text == "{") {
            Str fstr = collect_field_str(s, tbrace.pos);
            List(Str) sn1 = fs.stn;
            List(Str) sf1 = fs.stf;
            List(Str) sn2 = sn1.concat([tname.text]);
            List(Str) sf2 = sf1.concat([fstr]);
            Funcs fsx = Funcs { names: fs.names, pts: fs.pts, rets: fs.rets, stn: sn2, stf: sf2 };
            return collect_sigs_at(s, end, fsx);
        }
        return collect_sigs_at(s, end, fs);
    }
    if (t.text == "import") {
        Int end = skip_decl(s, t.pos, 0);
        return collect_sigs_at(s, end, fs);
    }
    if (t.text == "pub") {
        Tok t2 = lex_tok(s, t.pos);
        return collect_sigs_at(s, t2.pos, fs);
    }
    if (t.kind == "ident") {
        PRes rty = parse_type(s, pos);
        if (rty.err != "") {
            return collect_sigs_at(s, rty.pos, fs);
        }
        Tok name = lex_tok(s, rty.pos);
        Tok open = lex_tok(s, name.pos);
        Str pts = collect_ptypes(s, open.pos, "");
        Int end = skip_body(s, t2_pos_after_open(s, open));
        List(Str) n1 = fs.names;
        List(Str) p1 = fs.pts;
        List(Str) r1 = fs.rets;
        List(Str) names2 = n1.concat([name.text]);
        List(Str) pts2 = p1.concat([pts]);
        List(Str) rets2 = r1.concat([rty.ty]);
        Funcs fs2 = Funcs { names: names2, pts: pts2, rets: rets2, stn: fs.stn, stf: fs.stf };
        return collect_sigs_at(s, end, fs2);
    }
    return collect_sigs_at(s, t.pos, fs);
}

Int t2_pos_after_open(Str s, Tok open) {
    return open.pos;
}

Funcs collect_sigs(Str s) {
    return collect_sigs_at(s, 0, funcs_empty());
}

Str dup_from(List(Str) names, Int i, Int j) {
    Int n = names.len();
    if (i >= n) {
        return "";
    }
    if (j >= i) {
        Int i2 = i + 1;
        return dup_from(names, i2, 0);
    }
    if (names[i] == names[j]) {
        return names[i];
    }
    Int j2 = j + 1;
    return dup_from(names, i, j2);
}

Str first_dup_name(List(Str) names) {
    return dup_from(names, 0, 0);
}

Int check_program(Str s, Int pos, Funcs fs) {
    Tok t = lex_tok(s, pos);
    if (t.kind == "eof") {
        println("typecheck OK");
        return 0;
    }
    if (t.text == "type") {
        Int end = skip_decl(s, t.pos, 0);
        println("OK type def");
        return check_program(s, end, fs);
    }
    if (t.text == "import") {
        Int end = skip_decl(s, t.pos, 0);
        println("OK import");
        return check_program(s, end, fs);
    }
    if (t.text == "pub") {
        Tok t2 = lex_tok(s, t.pos);
        return check_program(s, t2.pos, fs);
    }
    if (t.text == ";") {
        return check_program(s, t.pos, fs);
    }
    if (t.kind == "ident") {
        DRes d = check_func(s, pos, fs);
        if (d.err != "") {
            println("type error: " + d.err);
            return 1;
        }
        return check_program(s, d.pos, fs);
    }
    println("type error: unexpected declaration");
    return 1;
}

Int main() {
    if (args.count() < 2) {
        println("usage: typecheck <source.res>");
        return 1;
    }
    Str path = args.get(1);
    Str src = filesystem.read_all(path);
    Funcs fs = collect_sigs(src);
    Str dup = first_dup_name(fs.names);
    if (dup != "") {
        println("type error: function `" + dup + "` is already defined; duplicate definitions are forbidden");
        return 1;
    }
    return check_program(src, 0, fs);
}