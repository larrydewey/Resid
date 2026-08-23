/// parser.res — M5 bootstrap milestone: a Resid parser written in Resid.
///
/// Reads `.resid` source (path from `RESID_PARSER_SRC` env var) with the
/// filesystem provider, scans it char-by-char via the string-introspection
/// built-ins (reusing the M4 lexer primitives), and recursively descends into
/// the grammar — building a printed S-expression AST as it goes. Position is
/// threaded through a `{ pos, ast }` struct because Resid bindings are
/// immutable; lookahead is free because token scanning is pure.
///
/// Proof: run `RESID_PARSER_SRC=examples/hello.res residc examples/parser.res run`.

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

// ─── Whitespace / comment skipping ─────────────────────────────

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
    Int c = str_char_at(s, j);
    if (c == 47) {  // /
        Int c2 = char_next(s, j);
        if (c2 == 47) {
            Int k = j + 2;
            return skip_all(s, skip_line_comment(s, k, n), n);
        }
        if (c2 == 42) {
            Int k = j + 2;
            return skip_all(s, skip_block_comment(s, k, n), n);
        }
    }
    return j;
}

// ─── Scanner (character → token text) ──────────────────────────

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
    if (c == 34) { Int k = i + 1; return k; }
    if (c == 92) { Int k = i + 1; Int m = i + 2; return scan_string(s, m, n); }
    Int k = i + 1;
    return scan_string(s, k, n);
}

Int scan_fstring(Str s, Int i, Int n, Int depth) {
    if (i >= n) { return i; }
    Int c = str_char_at(s, i);
    if (c == 92) { Int k = i + 1; Int m = i + 2; return scan_fstring(s, m, n, depth); }
    if (c == 123) { Int k = i + 1; return scan_fstring(s, k, n, 1); }
    if (c == 125) { Int k = i + 1; return scan_fstring(s, k, n, 0); }
    if (c == 34) {
        if (depth == 0) { Int k = i + 1; return k; }
    }
    Int k = i + 1;
    return scan_fstring(s, k, n, depth);
}

// A token: text plus where the scan left off (pos = index after the token).
// kind: "ident" | "keyword" | "int" | "float" | "str" | "raw" | "bytes" |
//       "fstring" | "char" | "op" | "eof"
type Tok = { pos: Int, text: Str, kind: Str };

Tok lex_op2(Str s, Int pos, Int n) {
    Int c = char_at(s, pos);
    Int c2 = char_next(s, pos);
    Int c3 = char_next2(s, pos);
    if (c == 46) {  // .
        if (c2 == 46) {
            if (c3 == 61) { Int k = pos + 3; return Tok { pos: k, text: "..=", kind: "op" }; }
            Int k = pos + 2;
            return Tok { pos: k, text: "..", kind: "op" };
        }
        Int k = pos + 1;
        return Tok { pos: k, text: ".", kind: "op" };
    }
    if (c == 60) {  // <
        if (c2 == 60) { Int k = pos + 2; return Tok { pos: k, text: "<<", kind: "op" }; }
        if (c2 == 61) { Int k = pos + 2; return Tok { pos: k, text: "<=", kind: "op" }; }
        Int k = pos + 1;
        return Tok { pos: k, text: "<", kind: "op" };
    }
    if (c == 62) {  // >
        if (c2 == 62) { Int k = pos + 2; return Tok { pos: k, text: ">>", kind: "op" }; }
        if (c2 == 61) { Int k = pos + 2; return Tok { pos: k, text: ">=", kind: "op" }; }
        Int k = pos + 1;
        return Tok { pos: k, text: ">", kind: "op" };
    }
    if (c == 61) {  // =
        if (c2 == 61) { Int k = pos + 2; return Tok { pos: k, text: "==", kind: "op" }; }
        if (c2 == 62) { Int k = pos + 2; return Tok { pos: k, text: "=>", kind: "op" }; }
        Int k = pos + 1;
        return Tok { pos: k, text: "=", kind: "op" };
    }
    if (c == 33) {  // !
        if (c2 == 61) { Int k = pos + 2; return Tok { pos: k, text: "!=", kind: "op" }; }
        Int k = pos + 1;
        return Tok { pos: k, text: "!", kind: "op" };
    }
    if (c == 38) {  // &
        if (c2 == 38) { Int k = pos + 2; return Tok { pos: k, text: "&&", kind: "op" }; }
        Int k = pos + 1;
        return Tok { pos: k, text: "&", kind: "op" };
    }
    if (c == 124) {  // |
        if (c2 == 124) { Int k = pos + 2; return Tok { pos: k, text: "||", kind: "op" }; }
        Int k = pos + 1;
        return Tok { pos: k, text: "|", kind: "op" };
    }
    Int k = pos + 1;
    return Tok { pos: k, text: str_from_code(c), kind: "op" };
}

Tok lex_tok(Str s, Int pos) {
    Int n = str_len_1(s);
    Int j = skip_all(s, pos, n);
    if (j >= n) {
        return Tok { pos: j, text: "", kind: "eof" };
    }
    Int c = char_at(s, j);
    Int c2 = char_next(s, j);
    // string / raw / bytes / f-string prefixes
    if (c == 102) {  // f
        if (c2 == 34) {
            Int k = j + 2;
            Int end = scan_fstring(s, k, n, 0);
            Str text = str_slice(s, j, end);
            return Tok { pos: end, text: text, kind: "fstring" };
        }
    }
    if (c == 114) {  // r
        if (c2 == 34) {
            Int k = j + 2;
            Int end = scan_string(s, k, n);
            Str text = str_slice(s, j, end);
            return Tok { pos: end, text: text, kind: "raw" };
        }
    }
    if (c == 98) {  // b
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
        // number: try float, hex/bin/oct, dec
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
    if (c == 95) {  // _
        Int e = scan_ident(s, j, n);
        Str text = str_slice(s, j, e);
        return Tok { pos: e, text: text, kind: "ident" };
    }
    if (c == 35) {  // #
        Int k = j + 8;
        return Tok { pos: k, text: "#location", kind: "op" };
    }
    if (c == 64) {  // @
        Int k = j + 1;
        return Tok { pos: k, text: "@", kind: "op" };
    }
    return lex_op2(s, j, n);
}

Bool is_keyword(Str s) {
    List(Str) kws = [
        "import", "pub", "type", "as", "with", "rt", "match", "if", "else",
        "while", "for", "return", "break", "continue", "spawn", "known",
        "rt_known", "comptime_print", "todo", "unimplemented", "true",
        "false", "null", "where", "assert", "rt_assert", "in"
    ];
    for (Str k in kws) {
        if (k == s) { return true; }
    }
    return false;
}

// ─── Parse result: next position + printed AST fragment ────────

type PRes = { pos: Int, ast: Str };

// ─── Operator precedence (spec §30) ─────────────────────────────

Int op_prec(Str op) {
    if (op == "*") { return 3; }
    if (op == "/") { return 3; }
    if (op == "%") { return 3; }
    if (op == "+") { return 4; }
    if (op == "-") { return 4; }
    if (op == "<<") { return 5; }
    if (op == ">>") { return 5; }
    if (op == "<") { return 6; }
    if (op == "<=") { return 6; }
    if (op == ">") { return 6; }
    if (op == ">=") { return 6; }
    if (op == "==") { return 7; }
    if (op == "!=") { return 7; }
    if (op == "&") { return 8; }
    if (op == "^") { return 9; }
    if (op == "|") { return 10; }
    if (op == "&&") { return 11; }
    if (op == "||") { return 12; }
    return 0;
}

// ─── Expression parsing (precedence climbing) ──────────────────

PRes parse_primary(Str s, Int pos) {
    Tok t = lex_tok(s, pos);
    if (t.kind == "int") {
        return PRes { pos: t.pos, ast: f"(int {t.text})" };
    }
    if (t.kind == "float") {
        return PRes { pos: t.pos, ast: f"(float {t.text})" };
    }
    if (t.kind == "str") {
        return PRes { pos: t.pos, ast: f"(str {t.text})" };
    }
    if (t.kind == "char") {
        return PRes { pos: t.pos, ast: f"(char {t.text})" };
    }
    if (t.kind == "raw") {
        return PRes { pos: t.pos, ast: f"(raw {t.text})" };
    }
    if (t.kind == "bytes") {
        return PRes { pos: t.pos, ast: f"(bytes {t.text})" };
    }
    if (t.kind == "fstring") {
        return PRes { pos: t.pos, ast: f"(fstring {t.text})" };
    }
    if (t.text == "true") {
        return PRes { pos: t.pos, ast: "(bool true)" };
    }
    if (t.text == "false") {
        return PRes { pos: t.pos, ast: "(bool false)" };
    }
    if (t.text == "match") {
        return parse_match(s, t.pos);
    }
    if (t.kind == "ident") {
        // struct literal? IDENT { fields } — only when `{ ident :` (avoids
        // stealing the match/block brace).
        Tok t2 = lex_tok(s, t.pos);
        if (t2.text == "{") {
            Tok t3 = lex_tok(s, t2.pos);
            Tok t4 = lex_tok(s, t3.pos);
            if (t3.kind == "ident") {
                if (t4.text == ":") {
                    return parse_struct_lit(s, t, t2.pos);
                }
            }
        }
        return PRes { pos: t.pos, ast: f"(id {t.text})" };
    }
    if (t.text == "(") {
        PRes inner = parse_expr(s, t.pos, 1);
        Tok close = lex_tok(s, inner.pos);
        return PRes { pos: close.pos, ast: f"(paren {inner.ast})" };
    }
    if (t.text == "[") {
        return parse_list_lit(s, t.pos);
    }
    if (t.text == "match") {
        return parse_match(s, t.pos);
    }
    if (t.text == "@") {
        Tok t2 = lex_tok(s, t.pos);
        Tok t3 = lex_tok(s, t2.pos);
        PRes inner = parse_expr(s, t3.pos, 1);
        return PRes { pos: inner.pos, ast: f"(residual {inner.ast})" };
    }
    if (t.kind == "eof") {
        return PRes { pos: t.pos, ast: "(err eof)" };
    }
    return PRes { pos: t.pos, ast: f"(err {t.text})" };
}

PRes parse_struct_lit(Str s, Tok name, Int pos) {
    Str acc = f"(struct {name.text}";
    return parse_struct_lit_rest(s, pos, acc);
}

PRes parse_struct_lit_rest(Str s, Int pos, Str acc) {
    Tok t = lex_tok(s, pos);
    if (t.text == "}") {
        return PRes { pos: t.pos, ast: f"{acc})" };
    }
    Tok colon = lex_tok(s, t.pos);
    PRes v = parse_expr(s, colon.pos, 1);
    Tok comma = lex_tok(s, v.pos);
    if (comma.text == ",") {
        return parse_struct_lit_rest(s, comma.pos, f"{acc} ({t.text} {v.ast})");
    }
    return PRes { pos: comma.pos, ast: f"{acc} ({t.text} {v.ast}))" };
}

PRes parse_list_lit(Str s, Int pos) {
    return parse_list_lit_rest(s, pos, "(list");
}

PRes parse_list_lit_rest(Str s, Int pos, Str acc) {
    Tok t = lex_tok(s, pos);
    if (t.text == "]") {
        return PRes { pos: t.pos, ast: f"{acc})" };
    }
    PRes v = parse_expr(s, pos, 1);
    Tok comma = lex_tok(s, v.pos);
    if (comma.text == ",") {
        return parse_list_lit_rest(s, comma.pos, f"{acc} {v.ast}");
    }
    return PRes { pos: comma.pos, ast: f"{acc} {v.ast})" };
}

PRes parse_match(Str s, Int pos) {
    PRes scr = parse_expr(s, pos, 1);
    Tok ob = lex_tok(s, scr.pos);  // {
    return parse_match_arms(s, ob.pos, f"(match {scr.ast}");
}

PRes parse_match_arms(Str s, Int pos, Str acc) {
    Tok first = lex_tok(s, pos);
    if (first.text == "}") {
        return PRes { pos: first.pos, ast: f"{acc})" };
    }
    // pattern is a primary-ish expression: Some(k), None, _, literal, id
    PRes pat = parse_expr(s, pos, 1);
    Tok arrow = lex_tok(s, pat.pos);
    if (arrow.text == "=>") {
        PRes v = parse_expr(s, arrow.pos, 1);
        Tok comma = lex_tok(s, v.pos);
        if (comma.text == ",") {
            return parse_match_arms(s, comma.pos, f"{acc} ({pat.ast} {v.ast})");
        }
        if (comma.text == "}") {
            return PRes { pos: comma.pos, ast: f"{acc} ({pat.ast} {v.ast}))" };
        }
        return PRes { pos: comma.pos, ast: f"{acc} ({pat.ast} {v.ast}))" };
    }
    // no `=>` — bare arm; stop
    return PRes { pos: arrow.pos, ast: f"{acc} ({pat.ast}))" };
}

PRes parse_postfix(Str s, Int pos) {
    PRes base = parse_primary(s, pos);
    return parse_postfix_rest(s, base);
}

PRes parse_postfix_rest(Str s, PRes acc) {
    Tok t = lex_tok(s, acc.pos);
    if (t.text == ".") {
        Tok m = lex_tok(s, t.pos);
        if (m.kind == "ident") {
            Tok t2 = lex_tok(s, m.pos);
            if (t2.text == "(") {
                PRes args = parse_args(s, t2.pos);
                Str ast = f"(call {acc.ast}.{m.text} {args.ast})";
                return parse_postfix_rest(s, PRes { pos: args.pos, ast: ast });
            }
            Str ast = f"(field {acc.ast} {m.text})";
            return parse_postfix_rest(s, PRes { pos: m.pos, ast: ast });
        }
        return acc;
    }
    if (t.text == "[") {
        return parse_index_rest(s, acc, t.pos);
    }
    if (t.text == "(") {
        PRes args = parse_args(s, t.pos);
        Str ast = f"(call {acc.ast} {args.ast})";
        return parse_postfix_rest(s, PRes { pos: args.pos, ast: ast });
    }
    if (t.text == "?") {
        Str ast = f"(unwrap {acc.ast})";
        return parse_postfix_rest(s, PRes { pos: t.pos, ast: ast });
    }
    if (t.text == "..") {
        PRes rhs = parse_expr(s, t.pos, 1);
        Str ast = f"(range {acc.ast} {rhs.ast})";
        return parse_postfix_rest(s, PRes { pos: rhs.pos, ast: ast });
    }
    if (t.text == "..=") {
        PRes rhs = parse_expr(s, t.pos, 1);
        Str ast = f"(range= {acc.ast} {rhs.ast})";
        return parse_postfix_rest(s, PRes { pos: rhs.pos, ast: ast });
    }
    return acc;
}

PRes parse_index_rest(Str s, PRes acc, Int pos) {
    Tok t = lex_tok(s, pos);
    if (t.text == ":") {
        // slice: xs[a..b] — approximate: xs[:b]
        PRes end = parse_expr(s, t.pos, 1);
        Tok close = lex_tok(s, end.pos);
        Str ast = f"(slice {acc.ast} {end.ast})";
        return PRes { pos: close.pos, ast: ast };
    }
    PRes idx = parse_expr(s, pos, 1);
    Tok close = lex_tok(s, idx.pos);
    Str ast2 = f"(index {acc.ast} {idx.ast})";
    return PRes { pos: close.pos, ast: ast2 };
}

PRes parse_args(Str s, Int pos) {
    Tok t = lex_tok(s, pos);
    if (t.text == ")") {
        return PRes { pos: t.pos, ast: "" };
    }
    return parse_args_rest(s, pos, "");
}

PRes parse_args_rest(Str s, Int pos, Str acc) {
    PRes e = parse_expr(s, pos, 1);
    Tok t = lex_tok(s, e.pos);
    if (t.text == ",") {
        return parse_args_rest(s, t.pos, f"{acc} {e.ast}");
    }
    if (t.text == ")") {
        return PRes { pos: t.pos, ast: f"{acc} {e.ast}" };
    }
    return PRes { pos: t.pos, ast: f"{acc} {e.ast}" };
}

PRes parse_unary(Str s, Int pos) {
    Tok t = lex_tok(s, pos);
    if (t.text == "+") {
        PRes inner = parse_unary(s, t.pos);
        return PRes { pos: inner.pos, ast: f"(un + {inner.ast})" };
    }
    if (t.text == "-") {
        PRes inner = parse_unary(s, t.pos);
        return PRes { pos: inner.pos, ast: f"(un - {inner.ast})" };
    }
    if (t.text == "!") {
        PRes inner = parse_unary(s, t.pos);
        return PRes { pos: inner.pos, ast: f"(un ! {inner.ast})" };
    }
    if (t.text == "~") {
        PRes inner = parse_unary(s, t.pos);
        return PRes { pos: inner.pos, ast: f"(un ~ {inner.ast})" };
    }
    return parse_postfix(s, pos);
}

PRes parse_expr(Str s, Int pos, Int minp) {
    PRes lhs = parse_unary(s, pos);
    return parse_bin_rest(s, lhs, minp);
}

PRes parse_bin_rest(Str s, PRes acc, Int minp) {
    Tok t = lex_tok(s, acc.pos);
    Int p = op_prec(t.text);
    if (p < minp) {
        return acc;
    }
    Int q = p + 1;
    PRes rhs = parse_expr(s, t.pos, q);
    Str ast = f"(bin {t.text} {acc.ast} {rhs.ast})";
    return parse_bin_rest(s, PRes { pos: rhs.pos, ast: ast }, minp);
}

// ─── Type parsing ───────────────────────────────────────────────

PRes parse_type(Str s, Int pos) {
    Tok t = lex_tok(s, pos);
    if (t.kind == "ident") {
        Tok t2 = lex_tok(s, t.pos);
        if (t2.text == "(") {
            // generic / width type: List(Int), UInt(8), Option(Str)
            Tok arg = lex_tok(s, t2.pos);
            if (arg.text == ")") {
                return PRes { pos: arg.pos, ast: f"(type {t.text} )" };
            }
            return parse_type_args(s, t, arg.pos, arg.text);
        }
        return PRes { pos: t.pos, ast: f"(type {t.text})" };
    }
    return PRes { pos: t.pos, ast: "(type ?)" };
}

PRes parse_type_args(Str s, Tok name, Int pos, Str acc) {
    Tok t = lex_tok(s, pos);
    if (t.text == ")") {
        return PRes { pos: t.pos, ast: f"(type {name.text} {acc})" };
    }
    if (t.kind == "ident") {
        return parse_type_args(s, name, t.pos, f"{acc} {t.text}");
    }
    if (t.text == ",") {
        return parse_type_args(s, name, t.pos, acc);
    }
    return PRes { pos: t.pos, ast: f"(type {name.text} {acc})" };
}

// ─── Parameter list ─────────────────────────────────────────────

PRes parse_params(Str s, Int pos) {
    Tok t = lex_tok(s, pos);  // consume (
    Tok close = lex_tok(s, t.pos);
    if (close.text == ")") {
        return PRes { pos: close.pos, ast: "" };
    }
    return parse_params_rest(s, t.pos, "");
}

PRes parse_params_rest(Str s, Int pos, Str acc) {
    PRes ty = parse_type(s, pos);
    Tok name = lex_tok(s, ty.pos);
    Str item = f"(param {name.text} {ty.ast})";
    Tok t = lex_tok(s, name.pos);
    if (t.text == "=") {
        // default value
        PRes def = parse_expr(s, t.pos, 1);
        Str item2 = f"(param {name.text} {ty.ast} = {def.ast})";
        Tok t2 = lex_tok(s, def.pos);
        if (t2.text == ",") {
            return parse_params_rest(s, t2.pos, f"{acc} {item2}");
        }
        return PRes { pos: t2.pos, ast: f"{acc} {item2}" };
    }
    if (t.text == ",") {
        return parse_params_rest(s, t.pos, f"{acc} {item}");
    }
    return PRes { pos: t.pos, ast: f"{acc} {item}" };
}

// ─── Statements / blocks ────────────────────────────────────────

PRes parse_block(Str s, Int pos) {
    Tok t = lex_tok(s, pos);  // consume {
    Tok end = lex_tok(s, t.pos);
    if (end.text == "}") {
        return PRes { pos: end.pos, ast: "(block )" };
    }
    return parse_block_rest(s, t.pos, "(block");
}

PRes parse_block_rest(Str s, Int pos, Str acc) {
    Tok t = lex_tok(s, pos);
    if (t.text == "}") {
        return PRes { pos: t.pos, ast: f"{acc})" };
    }
    PRes st = parse_stmt(s, pos);
    return parse_block_rest(s, st.pos, f"{acc} {st.ast}");
}

PRes parse_stmt(Str s, Int pos) {
    Tok t = lex_tok(s, pos);
    if (t.text == "return") {
        Tok e = lex_tok(s, t.pos);
        if (e.text == ";") {
            return PRes { pos: e.pos, ast: "(return)" };
        }
        PRes v = parse_expr(s, t.pos, 1);
        Tok semi = lex_tok(s, v.pos);
        return PRes { pos: semi.pos, ast: f"(return {v.ast})" };
    }
    if (t.text == "break") {
        Tok semi = lex_tok(s, t.pos);
        return PRes { pos: semi.pos, ast: "(break)" };
    }
    if (t.text == "continue") {
        Tok semi = lex_tok(s, t.pos);
        return PRes { pos: semi.pos, ast: "(continue)" };
    }
    if (t.text == "if") {
        return parse_if(s, t.pos);
    }
    if (t.text == "while") {
        Tok open = lex_tok(s, t.pos);
        PRes cond = parse_expr(s, open.pos, 1);
        Tok close = lex_tok(s, cond.pos);
        PRes body = parse_stmt(s, close.pos);
        return PRes { pos: body.pos, ast: f"(while {cond.ast} {body.ast})" };
    }
    if (t.text == "for") {
        Tok open = lex_tok(s, t.pos);
        Tok t2 = lex_tok(s, open.pos);
        if (t2.kind == "ident") {
            // for-in: for (Type name in expr)
            Tok t3 = lex_tok(s, t2.pos);
            if (t3.kind == "ident") {
                Tok in_kw = lex_tok(s, t3.pos);
                if (in_kw.text == "in") {
                    PRes col = parse_expr(s, in_kw.pos, 1);
                    Tok close = lex_tok(s, col.pos);
                    PRes body = parse_stmt(s, close.pos);
                    Str ast = f"(for-in {t2.text} {t3.text} {col.ast} {body.ast})";
                    return PRes { pos: body.pos, ast: ast };
                }
                // C-style for with init/cond/step — approximate: skip
                return PRes { pos: in_kw.pos, ast: f"(for {t2.text} {t3.text})" };
            }
            // for (x ...) — expression loop
            return PRes { pos: t3.pos, ast: f"(for {t2.text})" };
        }
        return PRes { pos: t2.pos, ast: "(for)" };
    }
    if (t.text == "{") {
        return parse_block(s, pos);
    }
    // bind / discard / expression statement
    if (t.kind == "ident") {
        // discard: _ = expr ;
        if (t.text == "_") {
            Tok eq = lex_tok(s, t.pos);
            if (eq.text == "=") {
                PRes v = parse_expr(s, eq.pos, 1);
                Tok semi = lex_tok(s, v.pos);
                return PRes { pos: semi.pos, ast: f"(discard {v.ast})" };
            }
        }
        // Type name = expr; — lookahead: ident then ident then `=`
        Tok t2 = lex_tok(s, t.pos);
        if (t2.kind == "ident") {
            Tok t3 = lex_tok(s, t2.pos);
            if (t3.text == "=") {
                PRes v = parse_expr(s, t3.pos, 1);
                Tok semi = lex_tok(s, v.pos);
                Str ast = f"(bind {t2.text} {t.text} {v.ast})";
                return PRes { pos: semi.pos, ast: ast };
            }
        }
        // Type(args) name = expr; e.g. List(Int) xs = ...
        if (t2.text == "(") {
            PRes ty = parse_type(s, pos);
            Tok name = lex_tok(s, ty.pos);
            if (name.kind == "ident") {
                Tok eq = lex_tok(s, name.pos);
                if (eq.text == "=") {
                    PRes v = parse_expr(s, eq.pos, 1);
                    Tok semi = lex_tok(s, v.pos);
                    Str ast = f"(bind {name.text} {ty.ast} {v.ast})";
                    return PRes { pos: semi.pos, ast: ast };
                }
            }
        }
    }
    // expression statement
    PRes e = parse_expr(s, pos, 1);
    Tok semi = lex_tok(s, e.pos);
    return PRes { pos: semi.pos, ast: f"(expr {e.ast})" };
}

PRes parse_if(Str s, Int pos) {
    Tok open = lex_tok(s, pos);  // consume 'if', then '('
    Tok t2 = lex_tok(s, open.pos);
    // if-let: if (Pattern = expr) — detect ident followed by '('
    if (t2.kind == "ident") {
        Tok t3 = lex_tok(s, t2.pos);
        if (t3.text == "(") {
            // could be Some(x) = expr
            Tok t4 = lex_tok(s, t3.pos);
            Tok t5 = lex_tok(s, t4.pos);
            Tok t6 = lex_tok(s, t5.pos);
            if (t6.text == "=") {
                // if-let Some(x) = expr
                Tok t7 = lex_tok(s, t6.pos);
                PRes src = parse_expr(s, t7.pos, 1);
                Tok close = lex_tok(s, src.pos);
                PRes then = parse_stmt(s, close.pos);
                return PRes { pos: then.pos, ast: f"(if-let {t2.text}({t4.text}) {src.ast} {then.ast})" };
            }
        }
    }
    PRes cond = parse_expr(s, open.pos, 1);
    Tok close = lex_tok(s, cond.pos);
    PRes then = parse_stmt(s, close.pos);
    Tok t = lex_tok(s, then.pos);
    if (t.text == "else") {
        PRes other = parse_stmt(s, t.pos);
        return PRes { pos: other.pos, ast: f"(if {cond.ast} {then.ast} {other.ast})" };
    }
    return PRes { pos: then.pos, ast: f"(if {cond.ast} {then.ast})" };
}

// ─── Declarations ───────────────────────────────────────────────

PRes parse_func(Str s, Int pos) {
    PRes ty = parse_type(s, pos);
    Tok name = lex_tok(s, ty.pos);
    PRes params = parse_params(s, name.pos);
    PRes body = parse_block(s, params.pos);
    Str ast = f"(func {name.text} -> {ty.ast} ({params.ast}) {body.ast})";
    return PRes { pos: body.pos, ast: ast };
}

PRes parse_type_def(Str s, Int pos) {
    Tok kw = lex_tok(s, pos);  // consume 'type'
    Tok name = lex_tok(s, kw.pos);
    Tok eq = lex_tok(s, name.pos);
    // type body: { fields } or sum
    Tok t = lex_tok(s, eq.pos);
    if (t.text == "{") {
        return parse_type_fields(s, f"(type-def {name.text}", t.pos);
    }
    // alias or sum: Type = Int(32) | A | B
    return parse_type_alias_rest(s, t, f"(type-def {name.text}");
}

PRes parse_type_fields(Str s, Str acc, Int pos) {
    Tok t = lex_tok(s, pos);
    if (t.text == "}") {
        Tok semi = lex_tok(s, t.pos);
        return PRes { pos: semi.pos, ast: f"{acc})" };
    }
    Tok colon = lex_tok(s, t.pos);
    PRes fty = parse_type(s, colon.pos);
    Tok comma = lex_tok(s, fty.pos);
    if (comma.text == ",") {
        return parse_type_fields(s, f"{acc} ({t.text} {fty.ast})", comma.pos);
    }
    // comma may be `}` — consume it in the close path
    if (comma.text == "}") {
        Tok semi = lex_tok(s, comma.pos);
        return PRes { pos: semi.pos, ast: f"{acc} ({t.text} {fty.ast}))" };
    }
    return PRes { pos: comma.pos, ast: f"{acc} ({t.text} {fty.ast})" };
}

PRes parse_type_alias_rest(Str s, Tok first, Str acc) {
    Tok t = lex_tok(s, first.pos);
    if (t.text == ";") {
        return PRes { pos: t.pos, ast: f"{acc} {first.text})" };
    }
    if (t.text == "|") {
        Tok v = lex_tok(s, t.pos);
        return parse_type_alias_rest(s, v, f"{acc} {first.text}");
    }
    if (t.kind == "eof") {
        return PRes { pos: t.pos, ast: f"{acc} {first.text})" };
    }
    if (t.text == "(") {
        // variant payload: Circle(Float) — skip to matching `)`
        Tok cur = t;
        return parse_type_payload(s, cur, f"{acc} {first.text}", first);
    }
    // unexpected — stop here, treat rest as unknown
    return PRes { pos: t.pos, ast: f"{acc} {first.text})" };
}

PRes parse_type_payload(Str s, Tok cur, Str acc, Tok first) {
    Tok t = lex_tok(s, cur.pos);
    if (t.text == ")") {
        Tok t2 = lex_tok(s, t.pos);
        if (t2.text == "|") {
            Tok v = lex_tok(s, t2.pos);
            return parse_type_alias_rest(s, v, acc);
        }
        if (t2.text == ";") {
            return PRes { pos: t2.pos, ast: f"{acc})" };
        }
        if (t2.kind == "eof") {
            return PRes { pos: t2.pos, ast: f"{acc})" };
        }
        return PRes { pos: t2.pos, ast: f"{acc})" };
    }
    if (t.kind == "eof") {
        return PRes { pos: t.pos, ast: f"{acc})" };
    }
    return parse_type_payload(s, t, acc, first);
}

PRes parse_decl(Str s, Int pos) {
    Tok t = lex_tok(s, pos);
    if (t.text == "type") {
        return parse_type_def(s, pos);
    }
    if (t.text == "import") {
        return parse_import_rest(s, t, false);
    }
    if (t.text == "pub") {
        Tok t2 = lex_tok(s, t.pos);
        return parse_func(s, t2.pos);
    }
    if (t.kind == "ident") {
        return parse_func(s, pos);
    }
    if (t.kind == "eof") {
        return PRes { pos: t.pos, ast: "(eof)" };
    }
    return PRes { pos: t.pos, ast: f"(unknown {t.text})" };
}

Bool is_semi(Str s, Tok t) {
    if (t.text == ";") { return true; }
    return false;
}

PRes parse_import_rest(Str s, Tok cur, Bool done) {
    if (done) {
        return PRes { pos: cur.pos, ast: "(import)" };
    }
    Tok t = lex_tok(s, cur.pos);
    if (t.text == ";") {
        return PRes { pos: t.pos, ast: "(import)" };
    }
    if (t.kind == "eof") {
        return PRes { pos: t.pos, ast: "(import)" };
    }
    return parse_import_rest(s, t, false);
}

// ─── Program loop ───────────────────────────────────────────────

Int parse_program(Str s, Int pos) {
    Tok t = lex_tok(s, pos);
    if (t.kind == "eof") {
        println("EOF");
        return 0;
    }
    PRes d = parse_decl(s, pos);
    println(d.ast);
    return parse_program(s, d.pos);
}

Int main() {
    if (args.count() < 2) {
        println("usage: parser <source.res>");
        return 1;
    }
    Str path = args.get(1);
    Str src = filesystem.read_all(path);
    return parse_program(src, 0);
}
