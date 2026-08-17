//! Lexer implementation — recursive descent character scanner.

use super::token::*;

/// The lexer: converts source text to token stream.
pub struct Lexer {
    chars: Vec<char>,
    pos: usize,
    file: String,
    line: usize,
    col: usize,
    tokens: TokenStream,
    errors: Vec<LexerError>,
}

impl Lexer {
    /// Create a new lexer for the given source.
    pub fn new(file: impl Into<String>, source: &str) -> Self {
        Self {
            chars: source.chars().collect(),
            pos: 0,
            file: file.into(),
            line: 1,
            col: 1,
            tokens: Vec::new(),
            errors: Vec::new(),
        }
    }

    /// Run the lexer, return tokens and any errors.
    pub fn tokenize(mut self) -> (TokenStream, Vec<LexerError>) {
        self.scan();
        self.tokens.push(Token {
            kind: TokenKind::Eof,
            span: Span {
                file: self.file.clone(),
                line: self.line,
                col_start: self.col,
                col_end: self.col,
            },
        });
        (self.tokens, self.errors)
    }

    fn scan(&mut self) {
        while self.peek().is_some() {
            self.skip_whitespace();
            if self.peek().is_none() {
                break;
            }
            let start = self.span();
            match self.peek().unwrap() {
                '/' => self.scan_comment(start),
                '"' => self.scan_string(start),
                'f' if self.peek_after() == Some('"') => self.scan_fstring(start),
                'r' if self.peek_after() == Some('"') => self.scan_raw_string(start),
                'b' if self.peek_after() == Some('"') => self.scan_byte_string(start),
                '#' => self.scan_hash(start),
                '@' => self.scan_at(start),
                c if c.is_alphabetic() || c == '_' => self.scan_ident_or_keyword(start),
                c if c.is_ascii_digit() => self.scan_number(start),
                c => self.scan_single_char(c, start),
            }
        }
    }

    /// Skip whitespace and newlines.
    fn skip_whitespace(&mut self) {
        while let Some(c) = self.peek() {
            match c {
                ' ' | '\t' | '\r' | '\n' => {
                    self.bump();
                }
                _ => break,
            }
        }
    }

    /// Scan a `//` line comment (skip it). A lone `/` is the division
    /// operator and must be emitted as `Op::Slash`.
    fn scan_comment(&mut self, start: Span) {
        self.bump(); // skip first /
        if self.peek() != Some('/') {
            // Not a comment — it's the division operator.
            self.tokens.push(Token {
                kind: TokenKind::Op(Op::Slash),
                span: start,
            });
            return;
        }
        self.bump(); // skip second /
        // Check for doc comment
        let is_doc = self.peek() == Some('/');
        while let Some(c) = self.peek() {
            if c == '\n' {
                break;
            }
            self.bump();
        }
        if is_doc {
            // We'll collect doc comments via a separate pass or store them
            // For now, skip — doc comments are handled by the parser
        }
    }

    /// Scan a regular string literal with escape processing.
    fn scan_string(&mut self, start: Span) {
        self.bump(); // skip opening "
        let mut value = String::new();
        while let Some(c) = self.peek() {
            if c == '"' {
                self.bump(); // skip closing "
                self.tokens.push(Token {
                    kind: TokenKind::Literal(Literal::Str(StrLit { value })),
                    span: start.clone(),
                });
                return;
            }
            if c == '\\' {
                self.bump(); // skip \
                match self.peek() {
                    Some('"') => {
                        value.push('"');
                        self.bump();
                    }
                    Some('n') => {
                        value.push('\n');
                        self.bump();
                    }
                    Some('t') => {
                        value.push('\t');
                        self.bump();
                    }
                    Some('r') => {
                        value.push('\r');
                        self.bump();
                    }
                    Some('\\') => {
                        value.push('\\');
                        self.bump();
                    }
                    Some('0') => {
                        value.push('\0');
                        self.bump();
                    }
                    Some('u') => {
                        self.bump(); // skip u
                        let mut hex = String::new();
                        for _ in 0..6 {
                            if let Some(c) = self.peek() {
                                hex.push(c);
                                self.bump();
                            }
                        }
                        if let Ok(code) = u32::from_str_radix(&hex, 16) {
                            if let Some(c) = char::from_u32(code) {
                                value.push(c);
                            }
                        }
                    }
                    Some(c) => {
                        value.push('\\');
                        value.push(c);
                        self.bump();
                    }
                    None => {
                        self.errors.push(LexerError {
                            span: start.clone(),
                            message: "unexpected end of string, expected escape sequence".into(),
                        });
                        break;
                    }
                }
            } else {
                value.push(c);
                self.bump();
            }
        }
        self.errors.push(LexerError {
            span: start.clone(),
            message: "unterminated string literal".into(),
        });
    }

    /// Scan an f-string with interpolation.
    fn scan_fstring(&mut self, start: Span) {
        // Consume 'f' then '"'
        self.bump(); // skip f
        if self.peek() != Some('"') {
            self.errors.push(LexerError {
                span: start.clone(),
                message: "f-string must be followed by a quote".into(),
            });
            return;
        }
        self.bump(); // skip opening "

        let mut parts = Vec::new();
        let mut text_buf = String::new();

        loop {
            match self.peek() {
                None => {
                    // Flush remaining text
                    if !text_buf.is_empty() {
                        parts.push(FStringPart::Text(text_buf));
                    }
                    self.errors.push(LexerError {
                        span: start.clone(),
                        message: "unterminated f-string".into(),
                    });
                    break;
                }
                Some('"') => {
                    // Flush remaining text
                    if !text_buf.is_empty() {
                        parts.push(FStringPart::Text(text_buf));
                    }
                    self.bump(); // skip closing "
                    self.tokens.push(Token {
                        kind: TokenKind::FString(FStringLit { parts }),
                        span: start,
                    });
                    return;
                }
                Some('{') => {
                    // Flush text buffer
                    if !text_buf.is_empty() {
                        parts.push(FStringPart::Text(text_buf));
                        text_buf = String::new();
                    }
                    self.bump(); // skip {
                    // Collect expression text until }
                    let mut expr = String::new();
                    // nesting depth tracking
                    let mut brace_depth = 1;
                    loop {
                        match self.peek() {
                            None => {
                                self.errors.push(LexerError {
                                    span: start.clone(),
                                    message: "unterminated f-string interpolation".into(),
                                });
                                break;
                            }
                            Some('}') => {
                                brace_depth -= 1;
                                if brace_depth == 0 {
                                    self.bump(); // skip }
                                    parts.push(FStringPart::Expr(expr));
                                    break;
                                }
                                expr.push('}');
                                self.bump();
                            }
                            Some('{') => {
                                brace_depth += 1;
                                expr.push('{');
                                self.bump();
                            }
                            Some(c) => {
                                expr.push(c);
                                self.bump();
                            }
                        }
                    }
                }
                Some(c) => {
                    text_buf.push(c);
                    self.bump();
                }
            }
        }
    }

    /// Scan a raw string literal r"..." or r#"..."# (simple form).
    fn scan_raw_string(&mut self, start: Span) {
        // Consume 'r' then '"'
        self.bump(); // skip r
        if self.peek() != Some('"') {
            self.errors.push(LexerError {
                span: start,
                message: "raw string must be followed by a quote".into(),
            });
            return;
        }
        self.bump(); // skip opening "

        let mut value = String::new();
        loop {
            match self.peek() {
                None => {
                    self.errors.push(LexerError {
                        span: start,
                        message: "unterminated raw string".into(),
                    });
                    break;
                }
                Some('"') => {
                    self.bump(); // skip closing "
                    self.tokens.push(Token {
                        kind: TokenKind::Literal(Literal::RawStr(RawStrLit { value })),
                        span: start,
                    });
                    return;
                }
                Some(c) => {
                    value.push(c);
                    self.bump();
                }
            }
        }
    }

    /// Scan a byte string literal b"...".
    fn scan_byte_string(&mut self, start: Span) {
        // Consume 'b' then '"'
        self.bump(); // skip b
        if self.peek() != Some('"') {
            self.errors.push(LexerError {
                span: start,
                message: "byte string must be followed by a quote".into(),
            });
            return;
        }
        self.bump(); // skip opening "

        let mut value = Vec::new();
        loop {
            match self.peek() {
                None => {
                    self.errors.push(LexerError {
                        span: start,
                        message: "unterminated byte string".into(),
                    });
                    break;
                }
                Some('"') => {
                    self.bump(); // skip closing "
                    self.tokens.push(Token {
                        kind: TokenKind::Literal(Literal::ByteStr(ByteStrLit { value })),
                        span: start,
                    });
                    return;
                }
                Some('\\') => {
                    self.bump(); // skip \
                    match self.peek() {
                        Some('"') => {
                            value.push(b'"');
                            self.bump();
                        }
                        Some('n') => {
                            value.push(b'\n');
                            self.bump();
                        }
                        Some('t') => {
                            value.push(b'\t');
                            self.bump();
                        }
                        Some('r') => {
                            value.push(b'\r');
                            self.bump();
                        }
                        Some('\\') => {
                            value.push(b'\\');
                            self.bump();
                        }
                        Some('0') => {
                            value.push(b'\0');
                            self.bump();
                        }
                        Some(c) => {
                            value.push(b'\\');
                            value.push(c as u8);
                            self.bump();
                        }
                        None => break,
                    }
                }
                Some(c) if (c as u8) < 0x80 => {
                    value.push(c as u8);
                    self.bump();
                }
                Some(c) => {
                    // Non-ASCII byte: push each byte
                    let bytes = c.to_string().into_bytes();
                    for b in bytes {
                        value.push(b);
                    }
                    self.bump();
                }
            }
        }
    }

    /// Scan #location or unknown # token.
    fn scan_hash(&mut self, start: Span) {
        self.bump(); // skip #
        if self.peek() != Some('l') {
            self.errors.push(LexerError {
                span: start,
                message: "expected #location".into(),
            });
            return;
        }
        // Check for "location"
        let keyword = "location";
        let mut keyword_match = true;
        let saved_pos = self.pos;
        let saved_col = self.col;
        for c in keyword.chars() {
            if self.peek() != Some(c) {
                keyword_match = false;
                break;
            }
            self.bump();
        }
        // Check that the next char is not alphanumeric (full match)
        if keyword_match {
            if let Some(c) = self.peek() {
                if c.is_alphanumeric() || c == '_' {
                    keyword_match = false;
                }
            }
        }
        if keyword_match {
            self.tokens.push(Token {
                kind: TokenKind::Op(Op::Location),
                span: start,
            });
        } else {
            // Reset and treat # as unexpected
            self.pos = saved_pos;
            self.col = saved_col;
            self.errors.push(LexerError {
                span: start,
                message: "unexpected character '#', expected #location".into(),
            });
        }
    }

    /// Scan @ or @residual.
    fn scan_at(&mut self, start: Span) {
        self.bump(); // skip @
        if self.peek() == Some('r') {
            let keyword = "residual";
            let mut keyword_match = true;
            for c in keyword.chars() {
                if self.peek() != Some(c) {
                    keyword_match = false;
                    break;
                }
                self.bump();
            }
            if keyword_match {
                if let Some(c) = self.peek() {
                    if c.is_alphanumeric() || c == '_' {
                        keyword_match = false;
                    }
                }
            }
            if keyword_match {
                self.tokens.push(Token {
                    kind: TokenKind::AtResidual,
                    span: start,
                });
                return;
            }
        }
        self.tokens.push(Token {
            kind: TokenKind::At,
            span: start,
        });
    }

    /// Scan an identifier or keyword.
    fn scan_ident_or_keyword(&mut self, start: Span) {
        let mut ident = String::new();
        while let Some(c) = self.peek() {
            if c.is_alphanumeric() || c == '_' {
                ident.push(c);
                self.bump();
            } else {
                break;
            }
        }
        // Check for _discard pattern
        if ident == "_" {
            self.tokens.push(Token {
                kind: TokenKind::Ident(ident),
                span: start,
            });
            return;
        }
        // Check for true/false/null literals first
        match ident.as_str() {
            "true" => {
                self.tokens.push(Token {
                    kind: TokenKind::Keyword(Keyword::True),
                    span: start,
                });
            }
            "false" => {
                self.tokens.push(Token {
                    kind: TokenKind::Keyword(Keyword::False),
                    span: start,
                });
            }
            "null" => {
                self.tokens.push(Token {
                    kind: TokenKind::Keyword(Keyword::Null),
                    span: start,
                });
            }
            _ => {
                // Check if it's a keyword
                if let Some(kw) = Keyword::from_str(&ident) {
                    self.tokens.push(Token {
                        kind: TokenKind::Keyword(kw),
                        span: start,
                    });
                } else {
                    self.tokens.push(Token {
                        kind: TokenKind::Ident(ident),
                        span: start,
                    });
                }
            }
        }
    }

    /// Scan a numeric literal (integer or float).
    fn scan_number(&mut self, start: Span) {
        let first = self.peek().unwrap();

        // Check for hex, binary, octal
        if first == '0' {
            if self.peek_after() == Some('x') {
                // Hex
                self.bump(); // skip 0
                self.bump(); // skip x
                let mut digits = String::new();
                while let Some(c) = self.peek() {
                    if c.is_ascii_hexdigit() {
                        digits.push(c);
                        self.bump();
                    } else {
                        break;
                    }
                }
                if digits.is_empty() {
                    self.errors.push(LexerError {
                        span: start,
                        message: "hex literal must have digits".into(),
                    });
                    return;
                }
                // Try parsing as u128
                let value = u128::from_str_radix(&digits, 16).unwrap_or(u128::MAX);
                self.tokens.push(Token {
                    kind: TokenKind::Literal(Literal::Int {
                        value,
                        kind: IntKind::Hex(digits),
                    }),
                    span: start,
                });
                return;
            }
            if self.peek_after() == Some('b') {
                // Binary
                self.bump(); // skip 0
                self.bump(); // skip b
                let mut digits = String::new();
                while let Some(c) = self.peek() {
                    if c == '0' || c == '1' {
                        digits.push(c);
                        self.bump();
                    } else {
                        break;
                    }
                }
                if digits.is_empty() {
                    self.errors.push(LexerError {
                        span: start,
                        message: "binary literal must have digits".into(),
                    });
                    return;
                }
                let value = u128::from_str_radix(&digits, 2).unwrap_or(u128::MAX);
                self.tokens.push(Token {
                    kind: TokenKind::Literal(Literal::Int {
                        value,
                        kind: IntKind::Binary(digits),
                    }),
                    span: start,
                });
                return;
            }
            if self.peek_after() == Some('o') {
                // Octal
                self.bump(); // skip 0
                self.bump(); // skip o
                let mut digits = String::new();
                while let Some(c) = self.peek() {
                    if ('0'..='7').contains(&c) {
                        digits.push(c);
                        self.bump();
                    } else {
                        break;
                    }
                }
                if digits.is_empty() {
                    self.errors.push(LexerError {
                        span: start,
                        message: "octal literal must have digits".into(),
                    });
                    return;
                }
                let value = u128::from_str_radix(&digits, 8).unwrap_or(u128::MAX);
                self.tokens.push(Token {
                    kind: TokenKind::Literal(Literal::Int {
                        value,
                        kind: IntKind::Octal(digits),
                    }),
                    span: start,
                });
                return;
            }
        }

        // Decimal or float
        let mut digits = String::new();
        while let Some(c) = self.peek() {
            if c.is_ascii_digit() {
                digits.push(c);
                self.bump();
            } else {
                break;
            }
        }

        // Check for float
        if self.peek() == Some('.') && self.peek_after() != Some('.') {
            self.bump(); // skip .
            let mut frac = String::new();
            while let Some(c) = self.peek() {
                if c.is_ascii_digit() {
                    frac.push(c);
                    self.bump();
                } else {
                    break;
                }
            }
            let value = format!("{}.{}", digits, frac);
            self.tokens.push(Token {
                kind: TokenKind::Literal(Literal::Float(FloatLit { value })),
                span: start,
            });
            return;
        }

        // Check for ' to make it a char
        if self.peek() == Some('\'') {
            // Not a char, just an integer — the char syntax is handled differently
            // In Resid, chars are 'a' style — but we already consumed digits
            // So this must be a number followed by a char literal separator
            // Push back and emit number
            self.tokens.push(Token {
                kind: TokenKind::Literal(Literal::Int {
                    value: digits.parse().unwrap_or(u128::MAX),
                    kind: IntKind::Decimal(digits),
                }),
                span: start,
            });
            return;
        }

        let value = digits.parse().unwrap_or(u128::MAX);
        self.tokens.push(Token {
            kind: TokenKind::Literal(Literal::Int {
                value,
                kind: IntKind::Decimal(digits),
            }),
            span: start,
        });
    }

    /// Scan single-character punctuation/operators.
    fn scan_single_char(&mut self, c: char, start: Span) {
        // Peek ahead for two-char operators
        let two_char = self.peek_n(2);

        // Check two-char operators first
        if let Some("<<") = two_char.as_deref() {
            self.bump();
            self.bump();
            self.tokens.push(Token {
                kind: TokenKind::Op(Op::ShiftLeft),
                span: start,
            });
            return;
        }
        if let Some(">>") = two_char.as_deref() {
            self.bump();
            self.bump();
            self.tokens.push(Token {
                kind: TokenKind::Op(Op::ShiftRight),
                span: start,
            });
            return;
        }
        if let Some("<=") = two_char.as_deref() {
            self.bump();
            self.bump();
            self.tokens.push(Token {
                kind: TokenKind::Op(Op::LessEq),
                span: start,
            });
            return;
        }
        if let Some(">=") = two_char.as_deref() {
            self.bump();
            self.bump();
            self.tokens.push(Token {
                kind: TokenKind::Op(Op::GreaterEq),
                span: start,
            });
            return;
        }
        if let Some("==") = two_char.as_deref() {
            self.bump();
            self.bump();
            self.tokens.push(Token {
                kind: TokenKind::Op(Op::EqEq),
                span: start,
            });
            return;
        }
        if let Some("!=") = two_char.as_deref() {
            self.bump();
            self.bump();
            self.tokens.push(Token {
                kind: TokenKind::Op(Op::Ne),
                span: start,
            });
            return;
        }
        if let Some("&&") = two_char.as_deref() {
            self.bump();
            self.bump();
            self.tokens.push(Token {
                kind: TokenKind::Op(Op::AndAnd),
                span: start,
            });
            return;
        }
        if let Some("||") = two_char.as_deref() {
            self.bump();
            self.bump();
            self.tokens.push(Token {
                kind: TokenKind::Op(Op::OrOr),
                span: start,
            });
            return;
        }
        if let Some("=>") = two_char.as_deref() {
            self.bump();
            self.bump();
            self.tokens.push(Token {
                kind: TokenKind::Op(Op::FatArrow),
                span: start,
            });
            return;
        }
        if let Some("..=") = two_char.as_deref() {
            self.bump();
            self.bump();
            self.bump();
            self.tokens.push(Token {
                kind: TokenKind::Op(Op::DotDotEq),
                span: start,
            });
            return;
        }

        // Single char operators
        match c {
            '+' => self.emit_op(Op::Plus, start),
            '-' => self.emit_op(Op::Minus, start),
            '*' => self.emit_op(Op::Star, start),
            '/' => self.emit_op(Op::Slash, start),
            '%' => self.emit_op(Op::Percent, start),
            '!' => self.emit_op(Op::Not, start),
            '~' => self.emit_op(Op::Tilde, start),
            '<' => self.emit_op(Op::Less, start),
            '>' => self.emit_op(Op::Greater, start),
            '&' => self.emit_op(Op::Amp, start),
            '^' => self.emit_op(Op::Caret, start),
            '|' => self.emit_op(Op::Pipe, start),
            '?' => self.emit_op(Op::Question, start),
            ':' => self.emit_op(Op::Colon, start),
            '=' => self.emit_op(Op::Equals, start),
            ',' => self.emit_op(Op::Comma, start),
            ';' => self.emit_op(Op::Semi, start),
            '.' => {
                // Check for ..= (closed range) or .. (range)
                if self.peek_n(3).as_deref() == Some("..=") {
                    self.bump();
                    self.bump();
                    self.bump();
                    self.tokens.push(Token {
                        kind: TokenKind::Op(Op::DotDotEq),
                        span: start,
                    });
                } else if self.peek_after() == Some('.') {
                    self.bump(); // skip first .
                    self.bump(); // skip second .
                    self.tokens.push(Token {
                        kind: TokenKind::Op(Op::DotDot),
                        span: start,
                    });
                } else {
                    self.emit_op(Op::Dot, start);
                }
            }
            '(' => self.emit_op(Op::LParen, start),
            ')' => self.emit_op(Op::RParen, start),
            '{' => self.emit_op(Op::LBrace, start),
            '}' => self.emit_op(Op::RBrace, start),
            '[' => self.emit_op(Op::LBracket, start),
            ']' => self.emit_op(Op::RBracket, start),
            '\'' => self.scan_char(start),
            _ => {
                self.errors.push(LexerError {
                    span: start,
                    message: format!("unexpected character '{}'", c),
                });
                self.bump();
            }
        }
    }

    /// Scan a character literal 'c'.
    fn scan_char(&mut self, start: Span) {
        self.bump(); // skip opening '
        match self.peek() {
            None => {
                self.errors.push(LexerError {
                    span: start,
                    message: "unterminated character literal".into(),
                });
                return;
            }
            Some('\\') => {
                self.bump(); // skip \
                match self.peek() {
                    Some('"') => {
                        let c = '"';
                        self.bump();
                        if self.peek() != Some('\'') {
                            self.errors.push(LexerError {
                                span: start,
                                message: "unterminated character literal".into(),
                            });
                            return;
                        }
                        self.bump(); // skip closing '
                        self.tokens.push(Token {
                            kind: TokenKind::Literal(Literal::Char(c)),
                            span: start,
                        });
                    }
                    Some('n') => {
                        let c = '\n';
                        self.bump();
                        if self.peek() != Some('\'') {
                            self.errors.push(LexerError {
                                span: start,
                                message: "unterminated character literal".into(),
                            });
                            return;
                        }
                        self.bump();
                        self.tokens.push(Token {
                            kind: TokenKind::Literal(Literal::Char(c)),
                            span: start,
                        });
                    }
                    Some('t') => {
                        let c = '\t';
                        self.bump();
                        if self.peek() != Some('\'') {
                            self.errors.push(LexerError {
                                span: start,
                                message: "unterminated character literal".into(),
                            });
                            return;
                        }
                        self.bump();
                        self.tokens.push(Token {
                            kind: TokenKind::Literal(Literal::Char(c)),
                            span: start,
                        });
                    }
                    Some('\\') => {
                        let c = '\\';
                        self.bump();
                        if self.peek() != Some('\'') {
                            self.errors.push(LexerError {
                                span: start,
                                message: "unterminated character literal".into(),
                            });
                            return;
                        }
                        self.bump();
                        self.tokens.push(Token {
                            kind: TokenKind::Literal(Literal::Char(c)),
                            span: start,
                        });
                    }
                    Some(c) => {
                        self.errors.push(LexerError {
                            span: start,
                            message: format!("unsupported escape '\\{}'", c),
                        });
                        self.bump();
                    }
                    None => {
                        self.errors.push(LexerError {
                            span: start,
                            message: "unterminated character literal".into(),
                        });
                    }
                }
            }
            Some(c) if c != '\'' => {
                self.bump();
                if self.peek() != Some('\'') {
                    self.errors.push(LexerError {
                        span: start,
                        message: "unterminated character literal".into(),
                    });
                    return;
                }
                self.bump();
                self.tokens.push(Token {
                    kind: TokenKind::Literal(Literal::Char(c)),
                    span: start,
                });
            }
            Some('\'') => {
                self.errors.push(LexerError {
                    span: start,
                    message: "empty character literal".into(),
                });
                self.bump();
            }
            _ => {
                self.errors.push(LexerError {
                    span: start,
                    message: "unterminated character literal".into(),
                });
                self.bump();
            }
        }
    }

    /// Emit a single-char operator token.
    fn emit_op(&mut self, op: Op, start: Span) {
        self.bump();
        self.tokens.push(Token {
            kind: TokenKind::Op(op),
            span: start,
        });
    }

    /// Peek at the current character without advancing.
    fn peek(&self) -> Option<char> {
        self.chars.get(self.pos).copied()
    }

    /// Peek at the character after the current one.
    fn peek_after(&self) -> Option<char> {
        self.chars.get(self.pos + 1).copied()
    }

    /// Peek at the next N characters as a string.
    fn peek_n(&self, n: usize) -> Option<String> {
        self.chars
            .get(self.pos..self.pos + n)
            .map(|slice| slice.iter().collect::<String>())
    }

    /// Advance position by one character.
    fn bump(&mut self) {
        if let Some(c) = self.chars.get(self.pos) {
            if *c == '\n' {
                self.line += 1;
                self.col = 1;
            } else {
                self.col += 1;
            }
            self.pos += 1;
        }
    }

    /// Create a span from the current position.
    fn span(&self) -> Span {
        Span {
            file: self.file.clone(),
            line: self.line,
            col_start: self.col,
            col_end: self.col,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_simple_tokens() {
        let (tokens, errors) = Lexer::new("test.resid", "Int x = 42;").tokenize();
        assert!(errors.is_empty());
        assert!(tokens.len() >= 5);
    }

    #[test]
    fn test_keywords() {
        let (tokens, errors) = Lexer::new("t.resid", "if else for while").tokenize();
        assert!(errors.is_empty());
        let kinds: Vec<String> = tokens.iter().map(|t| format!("{:?}", t.kind)).collect();
        assert!(kinds.iter().any(|k| k.contains("Keyword(If)")));
        assert!(kinds.iter().any(|k| k.contains("Keyword(Else)")));
        assert!(kinds.iter().any(|k| k.contains("Keyword(For)")));
        assert!(kinds.iter().any(|k| k.contains("Keyword(While)")));
    }

    #[test]
    fn test_operators() {
        let (_, errors) = Lexer::new("t.resid", "+ - * / << >> && ||").tokenize();
        assert!(errors.is_empty());
    }

    #[test]
    fn test_strings() {
        let (_, errors) = Lexer::new("t.resid", r#""hello""#).tokenize();
        assert!(errors.is_empty());
    }

    #[test]
    fn test_fstring() {
        let (tokens, errors) = Lexer::new("t.resid", r#"f"hello {name}""#).tokenize();
        assert!(errors.is_empty());
        assert_eq!(tokens.len(), 2); // FString + Eof
    }

    #[test]
    fn test_int_literals() {
        let (_, errors) = Lexer::new("t.resid", "42 0xFF 0b1010 0o77").tokenize();
        assert!(errors.is_empty());
    }

    #[test]
    fn test_wide_decimal_literal_digits_preserved() {
        // A decimal literal wider than u128 must keep its digits (not truncate).
        let big = "115792089237316195423570985008687907853269984665640564039457584007913129639935";
        let (tokens, errors) = Lexer::new("t.resid", big).tokenize();
        assert!(errors.is_empty(), "lexer errors: {errors:?}");
        let kind = &tokens[0].kind;
        let TokenKind::Literal(Literal::Int { kind, .. }) = kind else {
            panic!("expected int literal, got {kind:?}");
        };
        match kind {
            IntKind::Decimal(digits) => assert_eq!(digits, big),
            other => panic!("expected Decimal, got {other:?}"),
        }
    }

    #[test]
    fn test_location() {
        let (_, errors) = Lexer::new("t.resid", "#location").tokenize();
        assert!(errors.is_empty());
    }

    #[test]
    fn test_raw_string() {
        let (tokens, errors) = Lexer::new("t.resid", r#"r"hello""#).tokenize();
        assert!(errors.is_empty(), "lexer errors: {:?}", errors);
        assert!(!tokens.is_empty());
    }

    #[test]
    fn test_byte_string() {
        let (tokens, errors) = Lexer::new("t.resid", r#"b"hello""#).tokenize();
        assert!(errors.is_empty(), "lexer errors: {:?}", errors);
        assert!(!tokens.is_empty());
    }

    #[test]
    fn test_float_literal() {
        let (tokens, errors) = Lexer::new("t.resid", "3.14 0.0 1e10").tokenize();
        assert!(errors.is_empty(), "lexer errors: {:?}", errors);
        assert!(!tokens.is_empty());
    }

    #[test]
    fn test_bool_literals() {
        let (tokens, errors) = Lexer::new("t.resid", "true false").tokenize();
        assert!(errors.is_empty(), "lexer errors: {:?}", errors);
        let kinds: Vec<String> = tokens.iter().map(|t| format!("{:?}", t.kind)).collect();
        assert!(kinds.iter().any(|k| k.contains("Keyword(True)")));
        assert!(kinds.iter().any(|k| k.contains("Keyword(False)")));
    }

    #[test]
    fn test_char_literal() {
        let (tokens, errors) = Lexer::new("t.resid", "'a'").tokenize();
        assert!(errors.is_empty(), "lexer errors: {:?}", errors);
        assert!(!tokens.is_empty());
    }

    #[test]
    fn test_null_literal() {
        let (tokens, errors) = Lexer::new("t.resid", "null").tokenize();
        assert!(errors.is_empty(), "lexer errors: {:?}", errors);
        let kinds: Vec<String> = tokens.iter().map(|t| format!("{:?}", t.kind)).collect();
        assert!(kinds.iter().any(|k| k.contains("Null")));
    }
}
