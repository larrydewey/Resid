//! Token types for the Resid language.

use std::fmt;

/// Source span tracking position in source file.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Span {
    pub file: String,
    pub line: usize,
    pub col_start: usize,
    pub col_end: usize,
}

impl fmt::Display for Span {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}:{}:{}", self.file, self.line, self.col_start)
    }
}

/// All keyword tokens.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum Keyword {
    Import,
    Pub,
    Type,
    As,
    With,
    Rt,
    Match,
    If,
    Else,
    While,
    For,
    Return,
    Break,
    Continue,
    Spawn,
    Known,
    RtKnown,
    ComptimePrint,
    Todo,
    Unimplemented,
    True,
    False,
    Null,
    Where,
    Assert,
    RtAssert,
    In,
}

impl Keyword {
    pub fn as_str(self) -> &'static str {
        match self {
            Self::Import => "import",
            Self::Pub => "pub",
            Self::Type => "type",
            Self::As => "as",
            Self::With => "with",
            Self::Rt => "rt",
            Self::Match => "match",
            Self::If => "if",
            Self::Else => "else",
            Self::While => "while",
            Self::For => "for",
            Self::Return => "return",
            Self::Break => "break",
            Self::Continue => "continue",
            Self::Spawn => "spawn",
            Self::Known => "known",
            Self::RtKnown => "rt_known",
            Self::ComptimePrint => "comptime_print",
            Self::Todo => "todo",
            Self::Unimplemented => "unimplemented",
            Self::True => "true",
            Self::False => "false",
            Self::Null => "null",
            Self::Where => "where",
            Self::Assert => "assert",
            Self::RtAssert => "rt_assert",
            Self::In => "in",
        }
    }

    pub fn from_str(s: &str) -> Option<Self> {
        match s {
            "import" => Some(Self::Import),
            "pub" => Some(Self::Pub),
            "type" => Some(Self::Type),
            "as" => Some(Self::As),
            "with" => Some(Self::With),
            "rt" => Some(Self::Rt),
            "match" => Some(Self::Match),
            "if" => Some(Self::If),
            "else" => Some(Self::Else),
            "while" => Some(Self::While),
            "for" => Some(Self::For),
            "return" => Some(Self::Return),
            "break" => Some(Self::Break),
            "continue" => Some(Self::Continue),
            "spawn" => Some(Self::Spawn),
            "known" => Some(Self::Known),
            "rt_known" => Some(Self::RtKnown),
            "comptime_print" => Some(Self::ComptimePrint),
            "todo" => Some(Self::Todo),
            "unimplemented" => Some(Self::Unimplemented),
            "true" => Some(Self::True),
            "false" => Some(Self::False),
            "null" => Some(Self::Null),
            "where" => Some(Self::Where),
            "assert" => Some(Self::Assert),
            "rt_assert" => Some(Self::RtAssert),
            "in" => Some(Self::In),
            _ => None,
        }
    }
}

/// All operator tokens.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum Op {
    /// +
    Plus,
    /// -
    Minus,
    /// *
    Star,
    /// /
    Slash,
    /// %
    Percent,
    /// !
    Not,
    /// ~
    Tilde,
    /// <<
    ShiftLeft,
    /// >>
    ShiftRight,
    /// <
    Less,
    /// <=
    LessEq,
    /// >
    Greater,
    /// >=
    GreaterEq,
    /// ==
    EqEq,
    /// !=
    Ne,
    /// &
    Amp,
    /// ^
    Caret,
    /// |
    Pipe,
    /// &&
    AndAnd,
    /// ||
    OrOr,
    /// ?
    Question,
    /// :
    Colon,
    /// =
    Equals,
    /// ,
    Comma,
    /// .
    Dot,
    /// ;
    Semi,
    /// (
    LParen,
    /// )
    RParen,
    /// {
    LBrace,
    /// }
    RBrace,
    /// [
    LBracket,
    /// ]
    RBracket,
    /// =>
    FatArrow,
    /// ..
    DotDot,
    /// ..=
    DotDotEq,
    /// @
    At,
    /// (Type) cast
    Cast,
    /// f-string prefix
    FString,
    /// raw string prefix
    RawString,
    /// byte string prefix
    ByteString,
    /// #location
    Location,
}

impl Op {
    /// Parse operator from a string slice.
    pub fn from_str(s: &str) -> Option<Self> {
        match s {
            "+" => Some(Self::Plus),
            "-" => Some(Self::Minus),
            "*" => Some(Self::Star),
            "/" => Some(Self::Slash),
            "%" => Some(Self::Percent),
            "!" => Some(Self::Not),
            "~" => Some(Self::Tilde),
            "<<" => Some(Self::ShiftLeft),
            ">>" => Some(Self::ShiftRight),
            "<" => Some(Self::Less),
            "<=" => Some(Self::LessEq),
            ">" => Some(Self::Greater),
            ">=" => Some(Self::GreaterEq),
            "==" => Some(Self::EqEq),
            "!=" => Some(Self::Ne),
            "&" => Some(Self::Amp),
            "^" => Some(Self::Caret),
            "|" => Some(Self::Pipe),
            "&&" => Some(Self::AndAnd),
            "||" => Some(Self::OrOr),
            "?" => Some(Self::Question),
            ":" => Some(Self::Colon),
            "=" => Some(Self::Equals),
            "," => Some(Self::Comma),
            "." => Some(Self::Dot),
            ";" => Some(Self::Semi),
            "(" => Some(Self::LParen),
            ")" => Some(Self::RParen),
            "{" => Some(Self::LBrace),
            "}" => Some(Self::RBrace),
            "[" => Some(Self::LBracket),
            "]" => Some(Self::RBracket),
            "=>" => Some(Self::FatArrow),
            ".." => Some(Self::DotDot),
            "..=" => Some(Self::DotDotEq),
            "@" => Some(Self::At),
            _ => None,
        }
    }

    /// Check if this is an infix operator (for precedence climbing).
    pub fn is_infix(self) -> bool {
        matches!(
            self,
            Self::Plus
                | Self::Minus
                | Self::Star
                | Self::Slash
                | Self::Percent
                | Self::ShiftLeft
                | Self::ShiftRight
                | Self::Less
                | Self::LessEq
                | Self::Greater
                | Self::GreaterEq
                | Self::EqEq
                | Self::Ne
                | Self::Amp
                | Self::Caret
                | Self::Pipe
                | Self::AndAnd
                | Self::OrOr
                | Self::Question  // conditional
                | Self::DotDot   // range
                | Self::DotDotEq // closed range
        )
    }

    /// Check if this is a unary operator.
    pub fn is_unary(self) -> bool {
        matches!(
            self,
            Self::Plus
                | Self::Minus
                | Self::Not
                | Self::Tilde
                | Self::Cast
                | Self::FString
                | Self::RawString
                | Self::ByteString
                | Self::Location
        )
    }

    /// Get precedence level (higher = binds tighter). Per spec §27 the levels
    /// are 1 (Primary, tightest) … 14 (using, loosest); we invert so the
    /// climbing algorithm sees higher numbers as tighter.
    pub fn precedence(self) -> Option<u8> {
        match self {
            // spec level 3 → highest binary precedence
            Self::Star | Self::Slash | Self::Percent => Some(12), // multiplicative
            Self::Plus | Self::Minus => Some(11),                 // additive
            Self::ShiftLeft | Self::ShiftRight => Some(10),       // shift
            Self::Less | Self::LessEq | Self::Greater | Self::GreaterEq => Some(9), // relational
            Self::EqEq | Self::Ne => Some(8), // equality
            Self::Amp => Some(7),             // bitwise AND
            Self::Caret => Some(6),           // bitwise XOR
            Self::Pipe => Some(5),            // bitwise OR
            Self::AndAnd => Some(4),          // logical AND
            Self::OrOr => Some(3),            // logical OR
            Self::Question => Some(2),        // conditional
            Self::DotDot | Self::DotDotEq => Some(1), // range
            _ => None,
        }
    }
}

/// Integer literal variants. Digits are stored as strings so literals wider
/// than `u128` survive lexing without silent truncation.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum IntKind {
    Decimal(String),
    Hex(String),    // 0x prefix
    Binary(String), // 0b prefix
    Octal(String),  // 0o prefix
}

impl IntKind {
    /// The digit string without any radix prefix.
    pub fn digits(&self) -> &str {
        match self {
            IntKind::Decimal(s) | IntKind::Hex(s) | IntKind::Binary(s) | IntKind::Octal(s) => s,
        }
    }

    /// The radix the digit string is written in.
    pub fn radix(&self) -> u32 {
        match self {
            IntKind::Decimal(_) => 10,
            IntKind::Hex(_) => 16,
            IntKind::Binary(_) => 2,
            IntKind::Octal(_) => 8,
        }
    }

    /// The source spelling, e.g. `42`, `0xFF`, `0b1010`, `0o77`.
    pub fn source_str(&self) -> String {
        match self {
            IntKind::Decimal(s) => s.clone(),
            IntKind::Hex(s) => format!("0x{s}"),
            IntKind::Binary(s) => format!("0b{s}"),
            IntKind::Octal(s) => format!("0o{s}"),
        }
    }

    /// The number of bits needed to hold this literal's magnitude. Computed
    /// from the digit string so values beyond `u128` report a true width.
    pub fn required_bits(&self) -> u16 {
        match self {
            IntKind::Binary(s) => s.trim_start_matches('0').len() as u16,
            IntKind::Octal(s) => (s.trim_start_matches('0').len() as u16) * 3,
            IntKind::Hex(s) => (s.trim_start_matches('0').len() as u16) * 4,
            IntKind::Decimal(s) => {
                let s = s.trim_start_matches('0');
                if s.is_empty() {
                    return 1; // zero
                }
                // Find the smallest k such that the value < 2^k, by comparing
                // the decimal string against 2^k written in decimal.
                let mut pow = String::from("1");
                for k in 1u16..=512 {
                    pow = dec_double(&pow);
                    if dec_lt(s, &pow) {
                        return k;
                    }
                }
                512
            }
        }
    }

    /// The literal as an unsigned magnitude, if it fits in a u128 (used by the
    /// value-level code paths; wide literals return `None`).
    pub fn as_u128(&self) -> Option<u128> {
        u128::from_str_radix(self.digits(), self.radix()).ok()
    }
}

/// Multiply a decimal digit string by two.
fn dec_double(s: &str) -> String {
    let mut carry = 0u8;
    let mut out: Vec<char> = Vec::with_capacity(s.len() + 1);
    for ch in s.chars().rev() {
        let d = (ch as u8 - b'0') * 2 + carry;
        out.push((b'0' + (d % 10)) as char);
        carry = d / 10;
    }
    if carry > 0 {
        out.push((b'0' + carry) as char);
    }
    out.iter().rev().collect()
}

/// True if the decimal magnitude `a` (no leading zeros) is strictly less than
/// the decimal magnitude `b`.
fn dec_lt(a: &str, b: &str) -> bool {
    if a.len() != b.len() {
        return a.len() < b.len();
    }
    a < b
}

/// Float literal.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FloatLit {
    pub value: String, // stored as string for full precision
}

/// Decimal literal (spec §6.6a): `digits × 10^exp`. Digits are carried
/// verbatim — never round-tripped through binary. Examples: `1.5m` →
/// digits "15", exp -1; `5m` → digits "5", exp 0.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct DecLit {
    pub digits: String,
    pub exp: i32,
}

impl fmt::Display for DecLit {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let d = if self.digits.is_empty() {
            "0"
        } else {
            self.digits.as_str()
        };
        let e = self.exp;
        if e >= 0 {
            return write!(f, "{}m", d);
        }
        let frac = (-e) as usize;
        let sign = if let Some(stripped) = d.strip_prefix('-') {
            write!(f, "-")?;
            stripped
        } else {
            d
        };
        if frac >= sign.len() {
            write!(f, "0.{}{}m", "0".repeat(frac - sign.len()), sign)
        } else {
            let (int, frac) = sign.split_at(sign.len() - frac);
            write!(f, "{}.{}m", int, frac)
        }
    }
}

/// String literal (processed, escapes resolved).
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct StrLit {
    pub value: String,
}

/// Raw string literal (no escape processing).
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RawStrLit {
    pub value: String,
}

/// Byte string literal.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ByteStrLit {
    pub value: Vec<u8>,
}

/// F-string interpolation parts.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FStringLit {
    pub parts: Vec<FStringPart>,
}

/// A single part of an f-string (text or interpolated expression).
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum FStringPart {
    Text(String),
    Expr(String), // expression text (parsed later)
}

/// Literal variants.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Literal {
    Int { value: u128, kind: IntKind },
    Float(FloatLit),
    Dec(DecLit),
    Char(char),
    Str(StrLit),
    RawStr(RawStrLit),
    ByteStr(ByteStrLit),
    Bool(bool),
    Null,
}

impl fmt::Display for Literal {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Int { kind, .. } => write!(f, "{}", kind.source_str()),
            Self::Float(lit) => write!(f, "{}", lit.value),
            Self::Dec(lit) => write!(f, "{lit}"),
            Self::Char(c) => write!(f, "'{c}'"),
            Self::Str(lit) => write!(f, "\"{}\"", lit.value),
            Self::RawStr(lit) => write!(f, "r\"{}\"", lit.value),
            Self::ByteStr(lit) => write!(f, "b\"{}\"", String::from_utf8_lossy(&lit.value)),
            Self::Bool(b) => write!(f, "{b}"),
            Self::Null => write!(f, "null"),
        }
    }
}

/// Doc comment variant.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum DocComment {
    /// /// ... style
    Line(String),
    /// /** ... */ style
    Block(String),
}

/// The complete token type.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum TokenKind {
    Keyword(Keyword),
    Ident(String),
    Literal(Literal),
    FString(FStringLit),
    Op(Op),
    DocComment(DocComment),
    At,         // @ (standalone annotation)
    AtResidual, // @residual
    Eof,
}

impl fmt::Display for TokenKind {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Keyword(k) => write!(f, "keyword({})", k.as_str()),
            Self::Ident(s) => write!(f, "ident({})", s),
            Self::Literal(l) => write!(f, "literal({l})"),
            Self::FString(_) => write!(f, "f-string"),
            Self::Op(op) => write!(f, "op({:?})", op),
            Self::DocComment(_) => write!(f, "doc-comment"),
            Self::At => write!(f, "@"),
            Self::AtResidual => write!(f, "@residual"),
            Self::Eof => write!(f, "EOF"),
        }
    }
}

/// A token with its span.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Token {
    pub kind: TokenKind,
    pub span: Span,
}

/// Error type for lexer failures.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct LexerError {
    pub span: Span,
    pub message: String,
}

impl fmt::Display for LexerError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}: {}", self.span, self.message)
    }
}

/// Token stream — owned vector of tokens.
pub type TokenStream = Vec<Token>;
