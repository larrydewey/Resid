/// lexer.res — M4 bootstrap milestone: a Resid lexer written in Resid.
///
/// Reads `.resid` source (path from `RESID_LEX_SRC` env var) with the
/// filesystem provider, scans it char-by-char via the string-introspection
/// built-ins, and prints one token per line. This is the first self-hosted
/// compiler stage: a lexer that the (Rust) compiler could later feed directly
/// into a Resid parser.
///
/// Proof: run `RESID_LEX_SRC=examples/hello.res residc examples/lexer.res run`.

// ─── Character classification ──────────────────────────────────

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

// ─── Position helpers (keep widened arithmetic bounded) ────────

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

// ─── Token text helpers ────────────────────────────────────────

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

Int str_len_1(Str s) {
    return str_len(s);
}

// ─── Scanning primitives (return the index AFTER the token) ────

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

// C-style block comment — returns index after the closing `*/`.
Int skip_block_comment(Str s, Int i, Int n) {
    if (i >= n) { return i; }
    Int c = str_char_at(s, i);
    if (c == 42) {  // *
        Int c2 = char_next(s, i);
        if (c2 == 47) {
            Int k = i + 2;
            return k;
        }
    }
    Int k = i + 1;
    return skip_block_comment(s, k, n);
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
        if (c == 48) {
            Int k = i + 1;
            return scan_digits(s, k, n, base);
        }
        if (c == 49) {
            Int k = i + 1;
            return scan_digits(s, k, n, base);
        }
        return i;
    }
    if (base == 8) {
        if (is_oct(c)) {
            Int k = i + 1;
            return scan_digits(s, k, n, base);
        }
        return i;
    }
    if (base == 10) {
        if (is_digit(c)) {
            Int k = i + 1;
            return scan_digits(s, k, n, base);
        }
        return i;
    }
    if (base == 16) {
        if (is_hex(c)) {
            Int k = i + 1;
            return scan_digits(s, k, n, base);
        }
        return i;
    }
    return i;
}

// String literal — handles escapes; returns index after closing quote.
Int scan_string(Str s, Int i, Int n) {
    if (i >= n) { return i; }
    Int c = str_char_at(s, i);
    if (c == 34) {
        Int k = i + 1;
        return k;
    }
    if (c == 92) {
        Int k = i + 1;
        Int m = i + 2;
        return scan_string(s, m, n);
    }
    Int k = i + 1;
    return scan_string(s, k, n);
}

// F-string — tracks brace depth so `}` inside interpolations isn't the end.
Int scan_fstring(Str s, Int i, Int n, Int depth) {
    if (i >= n) { return i; }
    Int c = str_char_at(s, i);
    if (c == 92) {
        Int k = i + 1;
        Int m = i + 2;
        return scan_fstring(s, m, n, depth);
    }
    if (c == 123) {
        Int k = i + 1;
        return scan_fstring(s, k, n, 1);
    }
    if (c == 125) {
        Int k = i + 1;
        return scan_fstring(s, k, n, 0);
    }
    if (c == 34) {
        if (depth == 0) {
            Int k = i + 1;
            return k;
        }
    }
    Int k = i + 1;
    return scan_fstring(s, k, n, depth);
}

// ─── Per-token lexers (print one token, continue) ──────────────

Int lex_ident(Str s, Int pos, Int n) {
    Int end = scan_ident(s, pos, n);
    Str text = str_slice(s, pos, end);
    if (is_keyword(text)) {
        println(f"keyword({text})");
    } else {
        println(f"ident({text})");
    }
    return lex_token(s, end);
}

Int lex_num_hex(Str s, Int pos, Int n) {
    Int k = pos + 2;
    Int end = scan_digits(s, k, n, 16);
    Str text = str_slice(s, pos, end);
    println(f"literal(Int {text})");
    return lex_token(s, end);
}

Int lex_num_bin(Str s, Int pos, Int n) {
    Int k = pos + 2;
    Int end = scan_digits(s, k, n, 2);
    Str text = str_slice(s, pos, end);
    println(f"literal(Int {text})");
    return lex_token(s, end);
}

Int lex_num_oct(Str s, Int pos, Int n) {
    Int k = pos + 2;
    Int end = scan_digits(s, k, n, 8);
    Str text = str_slice(s, pos, end);
    println(f"literal(Int {text})");
    return lex_token(s, end);
}

Int lex_num_dec(Str s, Int pos, Int n) {
    Int end = scan_digits(s, pos, n, 10);
    Int cdot = str_char_at(s, end);
    Int cdot2 = char_next(s, end);
    if (cdot == 46) {
        if (cdot2 != 46) {
            Int k = end + 1;
            Int endf = scan_digits(s, k, n, 10);
            Str text = str_slice(s, pos, endf);
            println(f"literal(Float {text})");
            return lex_token(s, endf);
        }
    }
    Str text = str_slice(s, pos, end);
    println(f"literal(Int {text})");
    return lex_token(s, end);
}

Int lex_number(Str s, Int pos, Int n) {
    Int c = str_char_at(s, pos);
    if (c == 48) {
        Int c2 = char_next(s, pos);
        if (c2 == 120) { return lex_num_hex(s, pos, n); }
        if (c2 == 98) { return lex_num_bin(s, pos, n); }
        if (c2 == 111) { return lex_num_oct(s, pos, n); }
    }
    return lex_num_dec(s, pos, n);
}

Int lex_string(Str s, Int pos, Int n) {
    Int start = pos + 1;
    Int end = scan_string(s, start, n);
    Int a = pos + 1;
    Int b = end - 1;
    Str val = str_slice(s, a, b);
    println(f"literal(Str {val})");
    return lex_token(s, end);
}

Int lex_raw_string(Str s, Int pos, Int n) {
    Int start = pos + 2;
    Int end = scan_string(s, start, n);
    Int a = pos + 2;
    Int b = end - 1;
    Str val = str_slice(s, a, b);
    println(f"raw({val})");
    return lex_token(s, end);
}

Int lex_byte_string(Str s, Int pos, Int n) {
    Int start = pos + 2;
    Int end = scan_string(s, start, n);
    Int a = pos + 2;
    Int b = end - 1;
    Str val = str_slice(s, a, b);
    println(f"bytes({val})");
    return lex_token(s, end);
}

Int lex_fstring(Str s, Int pos, Int n) {
    Int start = pos + 2;
    Int end = scan_fstring(s, start, n, 0);
    Int a = pos + 2;
    Int b = end - 1;
    Str val = str_slice(s, a, b);
    println(f"f-string({val})");
    return lex_token(s, end);
}

Int lex_char(Str s, Int pos, Int n) {
    Int c = str_next_char(s, pos);
    println(f"char({str_from_code(c)})");
    Int k = pos + 3;
    return lex_token(s, k);
}
Int str_next_char(Str s, Int pos) {
    Int k = pos + 1;
    return str_char_at(s, k);
}

Int lex_op(Str s, Int pos, Int n) {
    Int c = char_at(s, pos);
    Int c2 = char_next(s, pos);
    Int c3 = char_next2(s, pos);
    if (c == 46) {  // .
        if (c2 == 46) {
            if (c3 == 61) {
                // ..=
                Int end = pos + 3;
                println("op(..=)");
                return lex_token(s, end);
            }
            Int end = pos + 2;
            println("op(..)");
            return lex_token(s, end);
        }
        println("op(.)");
        Int end = pos + 1;
        return lex_token(s, end);
    }
    if (c == 60) {  // <
        if (c2 == 60) { println("op(<<)"); Int end = pos + 2; return lex_token(s, end); }
        if (c2 == 61) { println("op(<=)"); Int end = pos + 2; return lex_token(s, end); }
        println("op(<)");
        Int end = pos + 1;
        return lex_token(s, end);
    }
    if (c == 62) {  // >
        if (c2 == 62) { println("op(>>)"); Int end = pos + 2; return lex_token(s, end); }
        if (c2 == 61) { println("op(>=)"); Int end = pos + 2; return lex_token(s, end); }
        println("op(>)");
        Int end = pos + 1;
        return lex_token(s, end);
    }
    if (c == 61) {  // =
        if (c2 == 61) { println("op(==)"); Int end = pos + 2; return lex_token(s, end); }
        if (c2 == 62) { println("op(=>)"); Int end = pos + 2; return lex_token(s, end); }
        println("op(=)");
        Int end = pos + 1;
        return lex_token(s, end);
    }
    if (c == 33) {  // !
        if (c2 == 61) { println("op(!=)"); Int end = pos + 2; return lex_token(s, end); }
        println("op(!)");
        Int end = pos + 1;
        return lex_token(s, end);
    }
    if (c == 38) {  // &
        if (c2 == 38) { println("op(&&)"); Int end = pos + 2; return lex_token(s, end); }
        println("op(&)");
        Int end = pos + 1;
        return lex_token(s, end);
    }
    if (c == 124) {  // |
        if (c2 == 124) { println("op(||)"); Int end = pos + 2; return lex_token(s, end); }
        println("op(|)");
        Int end = pos + 1;
        return lex_token(s, end);
    }
    if (c == 43) { println("op(+)"); }
    if (c == 45) { println("op(-)"); }
    if (c == 42) { println("op(*)"); }
    if (c == 47) { println("op(/)"); }
    if (c == 37) { println("op(%)"); }
    if (c == 126) { println("op(~)"); }
    if (c == 94) { println("op(^)"); }
    if (c == 63) { println("op(?)"); }
    if (c == 58) { println("op(:)"); }
    if (c == 44) { println("op(,)"); }
    if (c == 59) { println("op(;)"); }
    if (c == 40) { println("op(()"); }
    if (c == 41) { println("op())"); }
    if (c == 123) { println("op({)"); }
    if (c == 125) { println("op(})"); }
    if (c == 91) { println("op([)"); }
    if (c == 93) { println("op(])"); }
    Int end = pos + 1;
    return lex_token(s, end);
}

// ─── Token dispatcher ──────────────────────────────────────────

Int lex_token(Str s, Int pos) {
    Int n = str_len_1(s);
    Int j = skip_ws(s, pos, n);
    if (j >= n) {
        println("EOF");
        return 0;
    }
    Int c = char_at(s, j);
    Int c2 = char_next(s, j);
    if (c == 47) {  // /
        if (c2 == 47) {
            Int k = j + 2;
            return lex_token(s, skip_line_comment(s, k, n));
        }
        if (c2 == 42) {
            Int k = j + 2;
            return lex_token(s, skip_block_comment(s, k, n));
        }
        return lex_op(s, j, n);
    }
    if (c == 102) {  // f
        if (c2 == 34) { return lex_fstring(s, j, n); }
    }
    if (c == 114) {  // r
        if (c2 == 34) { return lex_raw_string(s, j, n); }
    }
    if (c == 98) {  // b
        if (c2 == 34) { return lex_byte_string(s, j, n); }
    }
    if (c == 34) { return lex_string(s, j, n); }
    if (c == 39) { return lex_char(s, j, n); }
    if (c == 35) {  // #
        println("#");
        Int end = j + 8;
        return lex_token(s, end);
    }
    if (c == 64) {  // @
        println("@");
        Int end = j + 1;
        return lex_token(s, end);
    }
    if (is_alpha(c)) { return lex_ident(s, j, n); }
    if (c == 95) { return lex_ident(s, j, n); }  // _
    if (is_digit(c)) { return lex_number(s, j, n); }
    return lex_op(s, j, n);
}

Int main() {
    if (args.count() < 2) {
        println("usage: lex <source.res>");
        return 1;
    }
    Str path = args.get(1);
    Str src = filesystem.read_all(path);
    return lex_token(src, 0);
}