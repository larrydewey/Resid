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

    /// Get precedence level (higher = binds tighter). Per spec §27.
    pub fn precedence(self) -> Option<u8> {
        match self {
            Self::Question => Some(14),    // conditional
            Self::Pipe => Some(10),        // bitwise OR
            Self::Caret => Some(9),        // bitwise XOR
            Self::Amp => Some(8),          // bitwise AND
            Self::EqEq | Self::Ne => Some(7), // equality
            Self::Less | Self::LessEq | Self::Greater | Self::GreaterEq => Some(6), // relational
            Self::ShiftLeft | Self::ShiftRight => Some(5), // shift
            Self::Plus | Self::Minus => Some(4), // additive
            Self::Star | Self::Slash | Self::Percent => Some(3), // multiplicative
            Self::AndAnd => Some(11),      // logical AND
            Self::OrOr => Some(12),        // logical OR
            Self::DotDot | Self::DotDotEq => Some(1), // range
            _ => None,
        }
    }
}

/// Integer literal variants.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum IntKind {
    Decimal(u128),
    Hex(String),     // 0x prefix, stored as string for large widths
    Binary(String),  // 0b prefix
    Octal(String),   // 0o prefix
}

/// Float literal.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FloatLit {
    pub value: String,  // stored as string for full precision
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
    Expr(String),  // expression text (parsed later)
}

/// Literal variants.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Literal {
    Int { value: u128, kind: IntKind },
    Float(FloatLit),
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
            Self::Int { value, .. } => write!(f, "{value}"),
            Self::Float(lit) => write!(f, "{}", lit.value),
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
    At,              // @ (standalone annotation)
    AtResidual,      // @residual
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
