//! Parser implementation — recursive descent + precedence climbing.
//!
//! Implements all EBNF productions from spec §28.
//! Operator precedence per spec §27.

use crate::ast::*;
use resid_lexer::Lexer;
use resid_lexer::{DocComment, *};

/// Trusted external-knowledge providers (spec §32). A `provider.verb(args)`
/// call where the base identifier is one of these parses as a provider call.
pub fn is_provider_name(name: &str) -> bool {
    matches!(name, "filesystem" | "environment" | "git" | "args" | "process")
}

/// Parse error with span.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ParseError {
    pub span: Span,
    pub message: String,
}

impl std::fmt::Display for ParseError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}:{}: {}", self.span.file, self.span.line, self.message)
    }
}

/// The parser.
pub struct Parser {
    tokens: Vec<Token>,
    pos: usize,
    errors: Vec<ParseError>,
}

impl Parser {
    /// Parse a full source file.
    pub fn parse(file: impl Into<String>, source: &str) -> (TranslationUnit, Vec<ParseError>) {
        let (tokens, lexer_errors) = Lexer::new(file, source).tokenize();
        let mut parser = Parser {
            tokens,
            pos: 0,
            errors: lexer_errors
                .into_iter()
                .map(|e| ParseError {
                    span: Span {
                        file: e.span.file,
                        line: e.span.line,
                        col_start: e.span.col_start,
                        col_end: e.span.col_end,
                    },
                    message: e.message,
                })
                .collect(),
        };
        let unit = parser.parse_translation_unit();
        (unit, parser.errors)
    }

    /// Parse a full translation unit.
    fn parse_translation_unit(&mut self) -> TranslationUnit {
        let mut imports = Vec::new();
        let mut declarations = Vec::new();

        while self.peek().is_some() && !self.at_eof() {
            let start_pos = self.pos;

            // Check for doc comments before declaration
            let doc_comments = self.collect_doc_comments();

            // Check for capability annotations
            let mut capabilities = Vec::new();
            while self.peek_is_at() {
                self.bump(); // skip @
                if self.peek_is_keyword(Keyword::Rt) {
                    // @residual — handled elsewhere
                    break;
                }
                let cap = self.parse_capability_annotation();
                capabilities.push(cap);
                // Skip semicolon if present
                if self.peek_is_op(Op::Comma) {
                    self.bump();
                }
            }

            if self.peek_is_keyword(Keyword::Import) {
                imports.push(self.parse_import());
            } else {
                let decl = self.parse_declaration(&doc_comments, &capabilities);
                declarations.push(decl);
            }

            // Consume an optional trailing terminator.
            if self.peek_is_op(Op::Semi) {
                self.bump();
            }

            // Guarantee termination: if parsing consumed nothing, force progress.
            if self.pos == start_pos {
                self.errors.push(ParseError {
                    span: self.current_span(),
                    message: "unexpected token at top level".into(),
                });
                self.bump();
            }
        }

        TranslationUnit {
            imports,
            declarations,
        }
    }

    // ─── Import ─────────────────────────────────────────────────

    fn parse_import(&mut self) -> ImportDecl {
        let span = self.current_span();
        self.bump(); // skip 'import'

        let path = match self.peek() {
            Some(TokenKind::Literal(Literal::Str(s))) => {
                self.bump();
                s.value.clone()
            }
            _ => {
                self.errors.push(ParseError {
                    span: self.current_span(),
                    message: "import: expected string literal".into(),
                });
                String::new()
            }
        };

        let mut names = None;
        let mut alias = None;

        // Optional: (name1, name2) or as Identifier
        if self.peek_is_op(Op::LParen) {
            self.bump();
            let mut n = Vec::new();
            while !self.peek_is_op(Op::RParen) && !self.at_eof() {
                if let Some(TokenKind::Ident(id)) = self.peek() {
                    n.push(Id(id.clone()));
                    self.bump();
                } else {
                    break;
                }
                if self.peek_is_op(Op::Comma) {
                    self.bump();
                }
            }
            if self.peek_is_op(Op::RParen) {
                self.bump();
            }
            names = Some(n);
        } else if self.peek_is_keyword(Keyword::As) {
            self.bump();
            if let Some(TokenKind::Ident(id)) = self.peek() {
                alias = Some(Id(id.clone()));
                self.bump();
            }
        }

        if self.peek_is_op(Op::Equals) {
            self.bump();
        }

        ImportDecl {
            path,
            names,
            alias,
            span,
        }
    }

    // ─── Declarations ───────────────────────────────────────────

    fn parse_declaration(
        &mut self,
        doc_comments: &[String],
        capabilities: &[CapabilityAnnotation],
    ) -> Declaration {
        let span = self.current_span();

        match self.peek() {
            Some(TokenKind::Keyword(Keyword::Type)) => {
                self.bump();
                let name = self
                    .expect_ident("type: expected identifier")
                    .unwrap_or_else(|| Id("__error__".to_string()));
                if self.peek_is_op(Op::LParen) {
                    self.bump();
                    while !self.peek_is_op(Op::RParen) && !self.at_eof() {
                        self.parse_type();
                        if self.peek_is_op(Op::Comma) {
                            self.bump();
                        }
                    }
                    self.expect_op(Op::RParen, "type: expected )");
                }
                self.expect_op(Op::Equals, "type: expected =");
                let body = self.parse_type_body();
                self.expect_op(Op::Semi, "type: expected ;");
                Declaration::Type(TypeDef {
                    name,
                    body,
                    doc_comments: doc_comments.to_vec(),
                    span,
                })
            }
            _ => {
                // Behavior definition: `Ord(Point) = point_cmp;`
                // Distinguished from a function def by `Ident ( … ) =` shape.
                if self.tokens.get(self.pos).map(|t| matches!(t.kind, TokenKind::Ident(_)))
                    == Some(true)
                    && self.behavior_shape_ahead()
                {
                    return Declaration::Behavior(self.parse_behavior(doc_comments, span));
                }
                // Function definition
                Declaration::Function(self.parse_function(doc_comments, capabilities, span))
            }
        }
    }

    /// Lookahead: does an `Ident ( ... ) =` shape start here?
    fn behavior_shape_ahead(&self) -> bool {
        let mut i = self.pos + 1;
        if !self.tokens.get(i).map(|t| matches!(t.kind, TokenKind::Op(Op::LParen))).unwrap_or(false) {
            return false;
        }
        let mut depth = 0usize;
        while i < self.tokens.len() {
            match &self.tokens[i].kind {
                TokenKind::Op(Op::LParen) => depth += 1,
                TokenKind::Op(Op::RParen) => {
                    depth -= 1;
                    if depth == 0 {
                        return self
                            .tokens
                            .get(i + 1)
                            .map(|t| matches!(t.kind, TokenKind::Op(Op::Equals)))
                            .unwrap_or(false);
                    }
                }
                _ => {}
            }
            i += 1;
        }
        false
    }

    fn parse_behavior(
        &mut self,
        _doc_comments: &[String],
        span: Span,
    ) -> BehaviorDef {
        let name = self
            .expect_ident("behavior: expected identifier")
            .unwrap_or_else(|| Id("__error__".to_string()));
        self.expect_op(Op::LParen, "behavior: expected (");
        let mut type_params = Vec::new();
        while !self.peek_is_op(Op::RParen) && !self.at_eof() {
            if let Some(id) = self.expect_ident("behavior: expected type name") {
                type_params.push(id);
            }
            if self.peek_is_op(Op::Comma) {
                self.bump();
            }
        }
        self.expect_op(Op::RParen, "behavior: expected )");
        self.expect_op(Op::Equals, "behavior: expected =");
        // The body names the implementation function (a plain identifier).
        let body_name = self
            .expect_ident("behavior: expected implementation function name")
            .unwrap_or_else(|| Id("__error__".to_string()));
        self.expect_op(Op::Semi, "behavior: expected ;");
        BehaviorDef {
            name,
            type_params,
            body: Expr {
                kind: ExprKind::Id(body_name),
                span: span.clone(),
            },
            span,
        }
    }

    fn parse_function(
        &mut self,
        doc_comments: &[String],
        capabilities: &[CapabilityAnnotation],
        span: Span,
    ) -> FuncDef {
        let pub_ = self.eat_keyword(Keyword::Pub);
        let span = if pub_ { self.current_span() } else { span };

        // Parse return type
        let ret = self.parse_type();

        // Parse function name
        let name = self
            .expect_ident("function: expected identifier")
            .unwrap_or_else(|| Id("__error__".to_string()));

        // Parse parameter list
        self.expect_op(Op::LParen, "function: expected (");
        let mut params = Vec::new();
        while !self.peek_is_op(Op::RParen) && !self.at_eof() {
            params.push(self.parse_param());
            if self.peek_is_op(Op::Comma) {
                self.bump();
            }
        }
        self.expect_op(Op::RParen, "function: expected )");

        // Parse body
        let body = self.parse_block();

        FuncDef {
            pub_,
            name,
            params,
            ret,
            body,
            doc_comments: doc_comments.to_vec(),
            capabilities: capabilities.to_vec(),
            span,
        }
    }

    fn parse_param(&mut self) -> Param {
        let type_ = self.parse_type();
        let name = self
            .expect_ident("parameter: expected identifier")
            .unwrap_or_else(|| Id("__error__".to_string()));
        let mut default = None;
        if self.eat_op(Op::Equals) {
            default = Some(self.parse_expression());
        }
        Param {
            type_,
            name,
            default,
        }
    }

    fn parse_type_body(&mut self) -> TypeBody {
        if self.peek_is_op(Op::LBrace) {
            self.bump();
            let mut fields = Vec::new();
            while !self.peek_is_op(Op::RBrace) && !self.at_eof() {
                let name = self
                    .expect_ident("type: expected field name")
                    .unwrap_or_else(|| Id("__error__".to_string()));
                self.expect_op(Op::Colon, "type: expected :");
                let type_ = self.parse_type();
                fields.push((name, type_));
                if self.peek_is_op(Op::Comma) {
                    self.bump();
                }
            }
            if self.peek_is_op(Op::RBrace) {
                self.bump();
            }
            TypeBody::Product(fields)
        } else if self.peek_is_op(Op::Pipe) || (self.peek_is_op(Op::LBrace)) {
            // Sum type: A | B
            let mut variants = Vec::new();
            loop {
                let name = self
                    .expect_ident("sum type: expected variant name")
                    .unwrap_or_else(|| Id("__error__".to_string()));
                let mut type_param = None;
                if self.peek_is_op(Op::LParen) {
                    self.bump();
                    type_param = Some(self.parse_type());
                    self.expect_op(Op::RParen, "sum type: expected )");
                }
                variants.push(SumVariant { name, type_param });
                if self.peek_is_op(Op::Pipe) {
                    self.bump();
                } else {
                    break;
                }
            }
            TypeBody::Sum(variants)
        } else {
            // Simple type or constraint, OR a sum whose first variant follows '='.
            let type_ = self.parse_type();
            if self.peek_is_op(Op::Pipe) {
                // Sum type written as: Some(T) | None
                let mut variants = Vec::new();
                match type_ {
                    Type::Base { name, params } => {
                        let type_param =
                            params.and_then(|mut p| if p.len() == 1 { p.pop() } else { None });
                        variants.push(SumVariant { name, type_param });
                    }
                    _ => {
                        self.errors.push(ParseError {
                            span: self.current_span(),
                            message: "sum type: expected variant name".into(),
                        });
                    }
                }
                while self.peek_is_op(Op::Pipe) {
                    self.bump();
                    let name = self
                        .expect_ident("sum type: expected variant name")
                        .unwrap_or_else(|| Id("__error__".to_string()));
                    let mut type_param = None;
                    if self.peek_is_op(Op::LParen) {
                        self.bump();
                        type_param = Some(self.parse_type());
                        self.expect_op(Op::RParen, "sum type: expected )");
                    }
                    variants.push(SumVariant { name, type_param });
                }
                TypeBody::Sum(variants)
            } else {
                let mut constraint = None;
                if self.eat_keyword(Keyword::Where) {
                    constraint = Some(self.parse_expression());
                }
                match type_ {
                    Type::Base { name, params: None } if name.0 == "type" => {
                        self.expect_op(Op::Equals, "constraint: expected =");
                        let inner_body = self.parse_type_body();
                        let constraint = constraint.unwrap_or_else(|| Expr {
                            kind: ExprKind::Id(Id("true".to_string())),
                            span: self.current_span(),
                        });
                        TypeBody::Constraint {
                            inner: Box::new(inner_body),
                            constraint,
                        }
                    }
                    Type::Residual(inner) => TypeBody::Residual(inner),
                    _ => TypeBody::Product(Vec::new()),
                }
            }
        }
    }

    // ─── Type Parsing ───────────────────────────────────────────

    fn parse_type(&mut self) -> Type {
        // Check for rt Type
        if self.eat_keyword(Keyword::Rt) {
            let inner = Box::new(self.parse_type());
            return Type::Residual(inner);
        }

        // Check for ISize / USize
        if self.peek_is_ident("ISize") {
            self.bump();
            return Type::ISize;
        }
        if self.peek_is_ident("USize") {
            self.bump();
            return Type::USize;
        }

        // Base type with optional params
        let name = self
            .expect_ident("type: expected identifier")
            .unwrap_or_else(|| Id("__error__".to_string()));
        let mut params = None;

        if self.peek_is_op(Op::LParen) {
            self.bump();
            let mut ps = Vec::new();
            while !self.peek_is_op(Op::RParen) && !self.at_eof() {
                // Support numeric literals as type parameters: Int(8), Float(32)
                if let Some(TokenKind::Literal(Literal::Int { value: v, kind: k })) = self.peek() {
                    self.bump();
                    ps.push(Type::Literal(Literal::Int { value: v, kind: k.clone() }));
                } else {
                    ps.push(self.parse_type());
                }
                if self.peek_is_op(Op::Comma) {
                    self.bump();
                }
            }
            self.expect_op(Op::RParen, "type: expected )");
            params = Some(ps);
        }

        Type::Base { name, params }
    }

    // ─── Expression Parsing (Precedence Climbing) ───────────────

    fn parse_expression(&mut self) -> Expr {
        self.parse_expression_with_precedence(1)
    }

    /// Parse an expression, guaranteeing forward progress even on syntax
    /// errors. Used inside element/argument list loops so a failed parse
    /// cannot leave the parser spinning on the same token.
    fn parse_expression_forced(&mut self) -> Expr {
        let start = self.pos;
        let expr = self.parse_expression();
        if self.pos == start {
            self.errors.push(ParseError {
                span: self.current_span(),
                message: "expected expression".into(),
            });
            self.bump();
        }
        expr
    }

    fn parse_expression_with_precedence(&mut self, min_precedence: u8) -> Expr {
        let mut left = self.parse_primary();

        while !self.at_eof() {
            let op_prec = match self.peek() {
                Some(TokenKind::Op(op)) => op.precedence(),
                _ => None,
            };

            match op_prec {
                Some(prec) if prec >= min_precedence => {
                    let op_span = self.current_span();
                    let op = match self.bump() {
                        Some(TokenKind::Op(op)) => op,
                        _ => unreachable!(),
                    };

                    // Handle ternary conditional (precedence 14, right-associative)
                    if op == Op::Question {
                        let then_expr = self.parse_expression_with_precedence(prec + 1);
                        self.expect_op(Op::Colon, "conditional: expected :");
                        let else_expr = self.parse_expression_with_precedence(prec);
                        left = Expr {
                            kind: ExprKind::BinaryOp {
                                op,
                                lhs: Box::new(left),
                                rhs: Box::new(then_expr),
                            },
                            span: op_span.clone(),
                        };
                        // Insert else_expr as another BinaryOp
                        left = Expr {
                            kind: ExprKind::BinaryOp {
                                op: Op::Question,
                                lhs: Box::new(left),
                                rhs: Box::new(else_expr),
                            },
                            span: op_span,
                        };
                        continue;
                    }

                    // Range operators are right-associative; all other binary
                    // operators are left-associative: the right operand is
                    // parsed at prec+1 so equal-precedence ops stay on the left.
                    let rhs_precedence = if op == Op::DotDot || op == Op::DotDotEq {
                        prec
                    } else {
                        prec + 1
                    };

                    let rhs = self.parse_expression_with_precedence(rhs_precedence);

                    // Ranges desugar to `Range` expressions, not binary ops.
                    if op == Op::DotDot || op == Op::DotDotEq {
                        left = Expr {
                            kind: ExprKind::Range {
                                start: Box::new(left),
                                end: Box::new(rhs),
                                closed: op == Op::DotDotEq,
                            },
                            span: op_span,
                        };
                        continue;
                    }

                    left = Expr {
                        kind: ExprKind::BinaryOp {
                            op,
                            lhs: Box::new(left),
                            rhs: Box::new(rhs),
                        },
                        span: op_span,
                    };
                }
                _ => break,
            }
        }

        left
    }

    fn parse_primary(&mut self) -> Expr {
        let span = self.current_span();

        match self.peek() {
            None => Expr {
                kind: ExprKind::Id(Id("__eof__".to_string())),
                span: self.current_span(),
            },

            // Keywords (true, false, null)
            Some(TokenKind::Keyword(Keyword::True)) => {
                self.bump();
                Expr {
                    kind: ExprKind::Literal(Literal::Bool(true)),
                    span,
                }
            }
            Some(TokenKind::Keyword(Keyword::False)) => {
                self.bump();
                Expr {
                    kind: ExprKind::Literal(Literal::Bool(false)),
                    span,
                }
            }
            Some(TokenKind::Keyword(Keyword::Null)) => {
                self.bump();
                Expr {
                    kind: ExprKind::Literal(Literal::Null),
                    span,
                }
            }
            Some(TokenKind::Keyword(Keyword::Rt)) => {
                self.bump();
                let inner = self.parse_primary();
                Expr {
                    kind: ExprKind::Rt(Box::new(inner)),
                    span,
                }
            }
            Some(TokenKind::AtResidual) => {
                self.bump();
                let type_ = self.parse_type();
                self.expect_op(Op::Equals, "@residual: expected =");
                let inner = self.parse_expression();
                Expr {
                    kind: ExprKind::AtResidual {
                        type_,
                        inner: Box::new(inner),
                    },
                    span,
                }
            }
            Some(TokenKind::Keyword(Keyword::Spawn)) => {
                self.bump();
                self.expect_op(Op::LParen, "spawn: expected (");
                let mut caps = Vec::new();
                while !self.peek_is_op(Op::RParen) && !self.at_eof() {
                    caps.push(self.parse_capability_annotation());
                    if self.peek_is_op(Op::Comma) {
                        self.bump();
                    }
                }
                self.expect_op(Op::RParen, "spawn: expected )");
                let body = self.parse_block();
                Expr {
                    kind: ExprKind::Spawn {
                        capabilities: caps,
                        body,
                    },
                    span,
                }
            }
            Some(TokenKind::Keyword(Keyword::Match)) => {
                self.bump();
                let scrutinee = self.parse_expression();
                self.expect_op(Op::LBrace, "match: expected {");
                let mut arms = Vec::new();
                while !self.peek_is_op(Op::RBrace) && !self.at_eof() {
                    let pat = self.parse_pattern();
                    self.expect_op(Op::FatArrow, "match arm: expected =>");
                    let expr = self.parse_expression_forced();
                    arms.push((pat, expr));
                    if self.peek_is_op(Op::Comma) || self.peek_is_op(Op::Semi) {
                        self.bump();
                    }
                }
                self.expect_op(Op::RBrace, "match: expected }");
                Expr {
                    kind: ExprKind::Match {
                        scrutinee: Box::new(scrutinee),
                        arms,
                    },
                    span,
                }
            }
            Some(TokenKind::Keyword(Keyword::Known)) => {
                self.bump();
                let inner = self.parse_expression();
                Expr {
                    kind: ExprKind::Known(Box::new(inner)),
                    span,
                }
            }
            Some(TokenKind::Keyword(Keyword::RtKnown)) => {
                self.bump();
                let inner = self.parse_expression();
                Expr {
                    kind: ExprKind::RtKnown(Box::new(inner)),
                    span,
                }
            }
            Some(TokenKind::Keyword(Keyword::ComptimePrint)) => {
                self.bump();
                self.expect_op(Op::LParen, "comptime_print: expected (");
                let inner = self.parse_expression();
                self.expect_op(Op::RParen, "comptime_print: expected )");
                Expr {
                    kind: ExprKind::ComptimePrint(Box::new(inner)),
                    span,
                }
            }
            Some(TokenKind::Keyword(Keyword::Todo)) => {
                self.bump();
                self.expect_op(Op::LParen, "todo: expected (");
                let msg = match self.peek() {
                    Some(TokenKind::Literal(Literal::Str(s))) => {
                        self.bump();
                        s.value.clone()
                    }
                    _ => String::from(""),
                };
                self.expect_op(Op::RParen, "todo: expected )");
                Expr {
                    kind: ExprKind::Todo(msg),
                    span,
                }
            }
            Some(TokenKind::Keyword(Keyword::Unimplemented)) => {
                self.bump();
                self.expect_op(Op::LParen, "unimplemented: expected (");
                let msg = match self.peek() {
                    Some(TokenKind::Literal(Literal::Str(s))) => {
                        self.bump();
                        s.value.clone()
                    }
                    _ => String::from(""),
                };
                self.expect_op(Op::RParen, "unimplemented: expected )");
                Expr {
                    kind: ExprKind::Unimplemented(msg),
                    span,
                }
            }
            Some(TokenKind::Keyword(Keyword::If)) => {
                self.bump();
                self.parse_if_expr(span)
            }
            Some(TokenKind::Keyword(Keyword::While)) => {
                self.bump();
                self.parse_while_expr(span)
            }
            Some(TokenKind::Keyword(Keyword::For)) => {
                self.bump();
                self.parse_for_expr(span)
            }

            // Assertions
            Some(TokenKind::Keyword(Keyword::Assert)) => {
                self.bump();
                self.expect_op(Op::LParen, "assert: expected (");
                let cond = self.parse_expression();
                self.expect_op(Op::Comma, "assert: expected ,");
                let message = match self.peek() {
                    Some(TokenKind::Literal(Literal::Str(s))) => {
                        self.bump();
                        Expr {
                            kind: ExprKind::Literal(Literal::Str(s.clone())),
                            span: span.clone(),
                        }
                    }
                    _ => Expr {
                        kind: ExprKind::Id(Id("".to_string())),
                        span: span.clone(),
                    },
                };
                self.expect_op(Op::RParen, "assert: expected )");
                Expr {
                    kind: ExprKind::Assert {
                        cond: Box::new(cond),
                        message: Box::new(message),
                    },
                    span,
                }
            }
            Some(TokenKind::Keyword(Keyword::RtAssert)) => {
                self.bump();
                self.expect_op(Op::LParen, "rt_assert: expected (");
                let cond = self.parse_expression();
                self.expect_op(Op::Comma, "rt_assert: expected ,");
                let message = match self.peek() {
                    Some(TokenKind::Literal(Literal::Str(s))) => {
                        self.bump();
                        Expr {
                            kind: ExprKind::Literal(Literal::Str(s.clone())),
                            span: span.clone(),
                        }
                    }
                    _ => Expr {
                        kind: ExprKind::Id(Id("".to_string())),
                        span: span.clone(),
                    },
                };
                self.expect_op(Op::RParen, "rt_assert: expected )");
                Expr {
                    kind: ExprKind::RtAssert {
                        cond: Box::new(cond),
                        message: Box::new(message),
                    },
                    span,
                }
            }

            // #location
            Some(TokenKind::Op(Op::Location)) => {
                self.bump();
                Expr {
                    kind: ExprKind::Location,
                    span,
                }
            }

            // Discard binding: _ = expression
            Some(TokenKind::Ident(id)) if id == "_" => {
                self.bump();
                self.expect_op(Op::Equals, "discard: expected =");
                let value = self.parse_expression();
                Expr {
                    kind: ExprKind::Discard(Box::new(value)),
                    span,
                }
            }

            // Literals
            Some(TokenKind::Literal(lit)) => {
                self.bump();
                let kind = match lit {
                    resid_lexer::Literal::RawStr(s) => ExprKind::RawString(s.value.clone()),
                    resid_lexer::Literal::ByteStr(s) => ExprKind::ByteString(s.value.clone()),
                    other => ExprKind::Literal(other.clone()),
                };
                Expr { kind, span }
            }

            // F-string
            Some(TokenKind::FString(fs)) => {
                self.bump();
                let parts = fs
                    .parts
                    .iter()
                    .map(|p| match p {
                        resid_lexer::FStringPart::Text(t) => {
                            crate::ast::FStringPart::Text(t.clone())
                        }
                        resid_lexer::FStringPart::Expr(e) => {
                            let (expr, _) = Parser::parse_partial(e);
                            crate::ast::FStringPart::Expr(Box::new(expr))
                        }
                    })
                    .collect();
                Expr {
                    kind: ExprKind::FString(parts),
                    span,
                }
            }

            // Raw string / byte string (prefix operators)
            Some(TokenKind::Op(Op::RawString)) => {
                self.bump();
                if let Some(TokenKind::Literal(Literal::RawStr(s))) = self.peek() {
                    self.bump();
                    Expr {
                        kind: ExprKind::RawString(s.value.clone()),
                        span,
                    }
                } else {
                    Expr {
                        kind: ExprKind::RawString(String::new()),
                        span,
                    }
                }
            }
            Some(TokenKind::Op(Op::ByteString)) => {
                self.bump();
                if let Some(TokenKind::Literal(Literal::ByteStr(s))) = self.peek() {
                    self.bump();
                    Expr {
                        kind: ExprKind::ByteString(s.value.clone()),
                        span,
                    }
                } else {
                    Expr {
                        kind: ExprKind::ByteString(Vec::new()),
                        span,
                    }
                }
            }

            // Cast: (Type) expression
            Some(TokenKind::Op(Op::Cast)) => {
                self.bump();
                let type_ = self.parse_type();
                self.expect_op(Op::RParen, "cast: expected )");
                let operand = self.parse_primary();
                Expr {
                    kind: ExprKind::Cast {
                        type_,
                        operand: Box::new(operand),
                    },
                    span,
                }
            }

            // Unary operators
            Some(TokenKind::Op(op)) if op.is_unary() => {
                self.bump();
                let operand = self.parse_primary();
                Expr {
                    kind: ExprKind::UnaryOp {
                        op,
                        operand: Box::new(operand),
                    },
                    span,
                }
            }

            // With handles
            Some(TokenKind::Keyword(Keyword::With)) => {
                self.bump();
                self.expect_op(Op::LParen, "with: expected (");
                let mut bindings = Vec::new();
                while !self.peek_is_op(Op::RParen) && !self.at_eof() {
                    let type_ = self.parse_type();
                    let name = self
                        .expect_ident("with: expected identifier")
                        .unwrap_or_else(|| Id("__error__".to_string()));
                    self.expect_op(Op::Equals, "with: expected =");
                    let init = self.parse_expression_forced();
                    bindings.push(WithBinding {
                        type_,
                        name,
                        init: Box::new(init),
                    });
                    if self.peek_is_op(Op::Comma) {
                        self.bump();
                    }
                }
                self.expect_op(Op::RParen, "with: expected )");
                let body = self.parse_block();
                Expr {
                    kind: ExprKind::With { bindings, body },
                    span,
                }
            }

            // Cast: (Type) expression  —  or a parenthesized expression.
            Some(TokenKind::Op(Op::LParen)) => {
                if self.paren_is_cast() {
                    self.bump();
                    let type_ = self.parse_type();
                    self.expect_op(Op::RParen, "cast: expected )");
                    let operand = self.parse_primary();
                    Expr {
                        kind: ExprKind::Cast {
                            type_,
                            operand: Box::new(operand),
                        },
                        span,
                    }
                } else {
                    self.bump();
                    let inner = self.parse_expression();
                    self.expect_op(Op::RParen, "expression: expected )");
                    inner
                }
            }

            // Identifier — could be a value, function call, or keyword for value?
            Some(TokenKind::Ident(id)) => {
                self.bump();
                let mut expr = Expr {
                    kind: ExprKind::Id(Id(id.clone())),
                    span: span.clone(),
                };

                // Check for function call
                if self.peek_is_op(Op::LParen) {
                    self.bump();
                    let mut args = Vec::new();
                    while !self.peek_is_op(Op::RParen) && !self.at_eof() {
                        // Named argument: `name = expr`. Detect an identifier
                        // that is followed by `=` and consume it as the name;
                        // otherwise fall through to a full positional argument.
                        let named = match self.peek() {
                            Some(TokenKind::Ident(s))
                                if matches!(
                                    self.tokens.get(self.pos + 1).map(|t| &t.kind),
                                    Some(TokenKind::Op(Op::Equals))
                                ) =>
                            {
                                self.bump();
                                self.bump();
                                Some(Id(s.clone()))
                            }
                            _ => None,
                        };
                        match named {
                            Some(id) => {
                                let arg = self.parse_expression_forced();
                                args.push((Some(id), arg));
                            }
                            None => {
                                let arg = self.parse_expression_forced();
                                args.push((None, arg));
                            }
                        }
                        if self.peek_is_op(Op::Comma) {
                            self.bump();
                        }
                    }
                    self.expect_op(Op::RParen, "call: expected )");
                    expr = Expr {
                        kind: ExprKind::Call {
                            func: Box::new(expr),
                            args,
                        },
                        span: span.clone(),
                    };
                }

                // Check for field access / method call / provider call:
                // expr.field, expr.m(args), provider.verb(args)
                if self.peek_is_op(Op::Dot) {
                    self.bump();
                    let field = self
                        .expect_ident("field access: expected identifier")
                        .unwrap_or_else(|| Id("__error__".to_string()));
                    if self.peek_is_op(Op::LParen) {
                        self.bump();
                        let mut args = Vec::new();
                        while !self.peek_is_op(Op::RParen) && !self.at_eof() {
                            args.push(Box::new(self.parse_expression_forced()));
                            if self.peek_is_op(Op::Comma) {
                                self.bump();
                            }
                        }
                        self.expect_op(Op::RParen, "method call: expected )");
                        // Provider call: `provider.verb(args)` where the base
                        // identifier is a trusted external-knowledge provider
                        // (filesystem, environment, git — spec §32).
                        let provider_name = match &expr.kind {
                            ExprKind::Id(id) => id.0.clone(),
                            _ => String::new(),
                        };
                        if is_provider_name(&provider_name) {
                            expr = Expr {
                                kind: ExprKind::ProviderCall {
                                    provider: Id(provider_name),
                                    verb: field.to_owned(),
                                    args,
                                },
                                span: span.clone(),
                            };
                        } else {
                            expr = Expr {
                                kind: ExprKind::MethodCall {
                                    target: Box::new(expr),
                                    method: field.to_owned(),
                                    args,
                                },
                                span: span.clone(),
                            };
                        }
                    } else {
                        expr = Expr {
                            kind: ExprKind::FieldAccess {
                                target: Box::new(expr),
                                field,
                            },
                            span: span.clone(),
                        };
                    }
                }

                // Check for index/slice: expr[index] or expr[start..end]
                if self.peek_is_op(Op::LBracket) {
                    self.bump();
                    if self.is_range_syntax_in_bracket() {
                        // Slice: expr[start..end]
                        let range = self.parse_range_expr();
                        self.expect_op(Op::RBracket, "slice: expected ]");
                        expr = Expr {
                            kind: ExprKind::Slice {
                                target: Box::new(expr),
                                range: Box::new(range),
                            },
                            span: span.clone(),
                        };
                    } else {
                        // Index: expr[index]
                        let index = self.parse_expression();
                        self.expect_op(Op::RBracket, "index: expected ]");
                        expr = Expr {
                            kind: ExprKind::Index {
                                target: Box::new(expr),
                                index: Box::new(index),
                            },
                            span: span.clone(),
                        };
                    }
                }

                // Check for ? (early return sugar)
                if self.peek_is_op(Op::Question) {
                    self.bump();
                    expr = Expr {
                        kind: ExprKind::EarlyReturn(Box::new(expr)),
                        span: span.clone(),
                    };
                }

                // Check for else { … } (fallback sugar)
                if self.peek_is_keyword(Keyword::Else) {
                    self.bump();
                    let fallback = self.parse_block();
                    expr = Expr {
                        kind: ExprKind::ElseFallback {
                            value: Box::new(expr),
                            fallback,
                        },
                        span: span.clone(),
                    };
                }

                // Check for using = behavior
                if self.peek_is_op(Op::Comma) {
                    self.bump();
                    if self.peek_is_ident("using") {
                        self.bump();
                        self.expect_op(Op::Equals, "using: expected =");
                        let mut behavior = self
                            .expect_ident("using: expected behavior name")
                            .unwrap_or_else(|| Id("__error__".to_string()));
                        // Optional instance parameter: `using = Ord(Point)`.
                        if self.peek_is_op(Op::LParen) {
                            self.bump();
                            let arg = self
                                .expect_ident("using: expected type argument")
                                .unwrap_or_else(|| Id("__error__".to_string()));
                            self.expect_op(Op::RParen, "using: expected )");
                            behavior = Id(format!("{}({})", behavior.0, arg.0));
                        }
                        expr = Expr {
                            kind: ExprKind::Using {
                                value: Box::new(expr),
                                behavior,
                            },
                            span: span.clone(),
                        };
                    }
                }

// Check for struct literal: Name { field: value, ... }
                // Only a `{` followed by a `field :` pair is a struct literal;
                // otherwise the `{` opens a block/match-arms.
                let lbrace_then_field = {
                    let in_bounds = self.pos + 1 < self.tokens.len();
                    in_bounds
                        && matches!(
                            self.tokens.get(self.pos + 1).map(|t| &t.kind),
                            Some(TokenKind::Ident(_))
                        )
                        && matches!(
                            self.tokens.get(self.pos + 2).map(|t| &t.kind),
                            Some(TokenKind::Op(Op::Colon))
                        )
                };
                if self.peek_is_op(Op::LBrace) && lbrace_then_field {
                    self.bump();
                    let mut fields = Vec::new();
                    while !self.peek_is_op(Op::RBrace) && !self.at_eof() {
                        let field_name = self
                            .expect_ident("struct literal: expected field name")
                            .unwrap_or_else(|| Id("__error__".to_string()));
                        self.expect_op(Op::Colon, "struct literal: expected :");
                        let field_value = self.parse_expression_forced();
                        fields.push((field_name, field_value));
                        if self.peek_is_op(Op::Comma) {
                            self.bump();
                        }
                    }
                    self.expect_op(Op::RBrace, "struct literal: expected }");
                    expr = Expr {
                        kind: ExprKind::StructLit { name: Id(id), fields },
                        span: span.clone(),
                    };
                }

                expr
            }

            // List literal
            Some(TokenKind::Op(Op::LBracket)) => {
                self.bump();
                let mut elements = Vec::new();
                while !self.peek_is_op(Op::RBracket) && !self.at_eof() {
                    elements.push(self.parse_expression_forced());
                    if self.peek_is_op(Op::Comma) {
                        self.bump();
                    }
                }
                self.expect_op(Op::RBracket, "list: expected ]");
                Expr {
                    kind: ExprKind::ListLit(elements),
                    span,
                }
            }

            // Map literal
            Some(TokenKind::Op(Op::LBrace)) => {
                // Map: `{ key: value, ... }`. A `{` NOT followed by an
                // identifier + `:` opens a bare block, not a struct literal —
                // struct literals are `Name { … }` with the name outside.
                let is_map = matches!(self.peek(), Some(TokenKind::Ident(_)))
                    && self.peek_after_is_op(Op::Colon);
                if is_map {
                    self.bump(); // {
                    // Map: { key: value, ... }
                    let mut entries = Vec::new();
                    loop {
                        let key = self.parse_expression();
                        self.expect_op(Op::Colon, "map: expected :");
                        let value = self.parse_expression();
                        entries.push((key, value));
                        if self.peek_is_op(Op::Comma) {
                            self.bump();
                        } else {
                            break;
                        }
                    }
                    self.expect_op(Op::RBrace, "map: expected }");
                    Expr {
                        kind: ExprKind::MapLit(entries),
                        span,
                    }
                } else {
                    // Just a block — handled in parse_block
                    self.parse_block_expr()
                }
            }

            _ => {
                self.errors.push(ParseError {
                    span: self.current_span(),
                    message: format!("unexpected token: {:?}", self.peek()),
                });
                Expr {
                    kind: ExprKind::Id(Id("__error__".to_string())),
                    span,
                }
            }
        }
    }

    fn parse_range_expr(&mut self) -> RangeExpr {
        let start = if !self.peek_is_op(Op::DotDot) && !self.peek_is_op(Op::DotDotEq) {
            // Parse the start bound at a precedence above the range operator
            // (prec 1) so `xs[1..4]` doesn't greedily consume `1..4` as a
            // full Range expression.
            Some(self.parse_expression_with_precedence(2))
        } else {
            None
        };
        let closed = if self.peek_is_op(Op::DotDotEq) {
            self.bump();
            true
        } else if self.peek_is_op(Op::DotDot) {
            self.bump();
            false
        } else {
            false
        };
        let end = if !self.peek_is_op(Op::RBracket) && !self.at_eof() {
            Some(self.parse_expression())
        } else {
            None
        };
        RangeExpr { start, end, closed }
    }

    fn parse_pattern(&mut self) -> Pattern {
        let span = self.current_span();
        match self.peek() {
            Some(TokenKind::Ident(id)) if id == "_" => {
                self.bump();
                Pattern {
                    kind: PatternKind::Wildcard,
                    span,
                }
            }
            Some(TokenKind::Ident(id)) => {
                self.bump();
                let id = id.clone();
                // Check for Variant(param) — e.g., Some(x)
                if self.peek_is_op(Op::LParen) {
                    self.bump();
                    let param = if !self.peek_is_op(Op::RParen) {
                        let p = self.expect_ident("pattern: expected identifier");
                        self.expect_op(Op::RParen, "pattern: expected )");
                        p
                    } else {
                        self.bump();
                        None
                    };
                    Pattern {
                        kind: PatternKind::Variant {
                            name: Id(id),
                            param,
                        },
                        span,
                    }
                } else {
                    // Could be struct: Name { ... }
                    if self.peek_is_op(Op::LBrace) {
                        self.bump();
                        let mut fields = Vec::new();
                        while !self.peek_is_op(Op::RBrace) && !self.at_eof() {
                            let field_name = self
                                .expect_ident("struct pattern: expected identifier")
                                .unwrap_or_else(|| Id("__error__".to_string()));
                            let field_pat = if self.peek_is_op(Op::Colon) {
                                self.bump();
                                self.parse_pattern()
                            } else {
                                Pattern {
                                    kind: PatternKind::Bind(field_name.clone()),
                                    span: self.current_span(),
                                }
                            };
                            fields.push((field_name, field_pat));
                            if self.peek_is_op(Op::Comma) {
                                self.bump();
                            }
                        }
                        self.expect_op(Op::RBrace, "struct pattern: expected }");
                        Pattern {
                            kind: PatternKind::Struct {
                                name: Id(id),
                                fields,
                            },
                            span,
                        }
                    } else {
                        Pattern {
                            kind: PatternKind::Bind(Id(id)),
                            span,
                        }
                    }
                }
            }
            Some(TokenKind::Literal(Literal::Int { value, kind })) => {
                self.bump();
                Pattern {
                    kind: PatternKind::Literal(Literal::Int { value, kind: kind }),
                    span,
                }
            }
            Some(TokenKind::Literal(Literal::Bool(b))) => {
                self.bump();
                Pattern {
                    kind: PatternKind::Literal(Literal::Bool(b)),
                    span,
                }
            }
            Some(TokenKind::Literal(Literal::Str(s))) => {
                self.bump();
                Pattern {
                    kind: PatternKind::Literal(Literal::Str(s.clone())),
                    span,
                }
            }
            _ => {
                self.errors.push(ParseError {
                    span: self.current_span(),
                    message: "pattern: expected identifier, literal, or variant".into(),
                });
                self.bump();
                Pattern {
                    kind: PatternKind::Wildcard,
                    span,
                }
            }
        }
    }

    fn parse_if_expr(&mut self, span: Span) -> Expr {
        // if-let: `if (Pattern = expr) { ... }`
        if self.peek_is_op(Op::LParen) && self.paren_let_assignment() {
            return self.parse_if_let_expr(span);
        }
        let cond = self.parse_paren_expr();

        let then_block = if self.peek_is_op(Op::LBrace) {
            self.parse_block()
        } else {
            let expr = self.parse_expression();
            Block {
                statements: vec![Stmt {
                    kind: StmtKind::Expr(Box::new(expr)),
                    span: self.current_span(),
                }],
                ret: None,
                span: self.current_span(),
            }
        };

        let else_block = if self.peek_is_keyword(Keyword::Else) {
            self.bump();
            if self.peek_is_keyword(Keyword::If) {
                // else if → chain
                self.bump();
                let else_expr = self.parse_if_expr(span.clone());
                Some(Box::new(Block {
                    statements: vec![Stmt {
                        kind: StmtKind::Expr(Box::new(else_expr)),
                        span: self.current_span(),
                    }],
                    ret: None,
                    span: self.current_span(),
                }))
            } else if self.peek_is_op(Op::LBrace) {
                Some(Box::new(self.parse_block()))
            } else {
                None
            }
        } else {
            None
        };

        Expr {
            kind: ExprKind::If {
                cond: Box::new(cond),
                then_block: Box::new(then_block),
                else_block,
            },
            span,
        }
    }

    fn parse_while_expr(&mut self, span: Span) -> Expr {
        // while-let: `while (Pattern = expr) { ... }`
        if self.peek_is_op(Op::LParen) && self.paren_let_assignment() {
            return self.parse_while_let_expr(span);
        }
        let cond = self.parse_paren_expr();
        let body = if self.peek_is_op(Op::LBrace) {
            self.parse_block()
        } else {
            let expr = self.parse_expression();
            Block {
                statements: vec![Stmt {
                    kind: StmtKind::Expr(Box::new(expr)),
                    span: self.current_span(),
                }],
                ret: None,
                span: self.current_span(),
            }
        };

        Expr {
            kind: ExprKind::While {
                cond: Box::new(cond),
                body: Box::new(body),
            },
            span,
        }
    }

    /// Look ahead from the current `(` to see whether the parenthesized
    /// condition is a pattern binding `PAT = expr` (if-let / while-let) rather
    /// than an ordinary Boolean condition. Scans to the matching close paren,
    /// skipping nested groups, tracking a single `=` at depth 0.
    fn paren_let_assignment(&self) -> bool {
        if !self.peek_is_op(Op::LParen) {
            return false;
        }
        let mut depth = 0usize;
        for tok in self.tokens.iter().skip(self.pos) {
            match &tok.kind {
                TokenKind::Op(Op::LParen) => depth += 1,
                TokenKind::Op(Op::RParen) => {
                    if depth == 0 {
                        return false;
                    }
                    depth -= 1;
                    if depth == 0 {
                        // Reached the matching close paren without a binding `=`.
                        return false;
                    }
                }
                TokenKind::Op(Op::Equals) if depth == 1 => return true,
                TokenKind::Op(Op::Semi) if depth == 1 => return false,
                _ => {}
            }
        }
        false
    }

    /// Look ahead from the current `(` to determine whether the parenthesized
    /// form is a C-style cast `(Type) expr` (spec §6.7) rather than an ordinary
    /// parenthesized expression. A cast has: `(`, a type name (identifier,
    /// possibly `rt`- or sized/generic-parameterized), `)`, then an expression.
    /// Heuristic: a cast is recognized when `(` is followed immediately by a
    /// type-shaped token run that closes with `)` and is then followed by a
    /// value-starting token (ident, literal, string, `(`, or `[`). Binary
    /// operators or statement terminators after the `)` indicate a plain
    /// parenthesized expression (e.g. `(a + b) * c`, `return (f(x));`).
    fn paren_is_cast(&self) -> bool {
        if !self.peek_is_op(Op::LParen) {
            return false;
        }
        let mut i = self.pos + 1;
        // Optional `rt` residual type marker.
        if matches!(self.tokens.get(i).map(|t| &t.kind), Some(TokenKind::Keyword(Keyword::Rt))) {
            i += 1;
        }
        // ISize / USize (identifier-shaped) or a user/builtin type name.
        if !matches!(self.tokens.get(i).map(|t| &t.kind), Some(TokenKind::Ident(_))) {
            return false;
        }
        i += 1;
        // Optional generic/sized parameters: Int(32), List(Int), Option(Int).
        if matches!(self.tokens.get(i).map(|t| &t.kind), Some(TokenKind::Op(Op::LParen))) {
            i += 1;
            let mut depth = 1usize;
            while i < self.tokens.len() {
                match &self.tokens[i].kind {
                    TokenKind::Op(Op::LParen) => depth += 1,
                    TokenKind::Op(Op::RParen) => {
                        depth -= 1;
                        if depth == 0 {
                            i += 1;
                            break;
                        }
                    }
                    _ => {}
                }
                i += 1;
            }
            if depth != 0 {
                return false;
            }
        }
        // The type run must close with `)`.
        if !matches!(self.tokens.get(i).map(|t| &t.kind), Some(TokenKind::Op(Op::RParen))) {
            return false;
        }
        i += 1;
        // The next token must start a value expression.
        matches!(
            self.tokens.get(i).map(|t| &t.kind),
            Some(TokenKind::Ident(_))
                | Some(TokenKind::Literal(_))
                | Some(TokenKind::FString(_))
                | Some(TokenKind::Op(Op::LParen))
                | Some(TokenKind::Op(Op::LBracket))
        )
    }

    fn parse_if_let_expr(&mut self, span: Span) -> Expr {
        self.expect_op(Op::LParen, "if-let: expected (");
        let pattern = self.parse_pattern();
        self.expect_op(Op::Equals, "if-let: expected =");
        let source = self.parse_expression();
        self.expect_op(Op::RParen, "if-let: expected )");

        let then_block = if self.peek_is_op(Op::LBrace) {
            self.parse_block()
        } else {
            let expr = self.parse_expression();
            Block {
                statements: vec![Stmt {
                    kind: StmtKind::Expr(Box::new(expr)),
                    span: self.current_span(),
                }],
                ret: None,
                span: self.current_span(),
            }
        };

        let else_block = if self.peek_is_keyword(Keyword::Else) {
            self.bump();
            if self.peek_is_op(Op::LBrace) {
                Some(Box::new(self.parse_block()))
            } else {
                let expr = self.parse_expression();
                Some(Box::new(Block {
                    statements: vec![Stmt {
                        kind: StmtKind::Expr(Box::new(expr)),
                        span: self.current_span(),
                    }],
                    ret: None,
                    span: self.current_span(),
                }))
            }
        } else {
            None
        };

        Expr {
            kind: ExprKind::IfLet {
                pattern,
                source: Box::new(source),
                then_block: Box::new(then_block),
                else_block,
            },
            span,
        }
    }

    fn parse_while_let_expr(&mut self, span: Span) -> Expr {
        self.expect_op(Op::LParen, "while-let: expected (");
        let pattern = self.parse_pattern();
        self.expect_op(Op::Equals, "while-let: expected =");
        let source = self.parse_expression();
        self.expect_op(Op::RParen, "while-let: expected )");

        let body = if self.peek_is_op(Op::LBrace) {
            self.parse_block()
        } else {
            let expr = self.parse_expression();
            Block {
                statements: vec![Stmt {
                    kind: StmtKind::Expr(Box::new(expr)),
                    span: self.current_span(),
                }],
                ret: None,
                span: self.current_span(),
            }
        };

        Expr {
            kind: ExprKind::WhileLet {
                pattern,
                source: Box::new(source),
                body: Box::new(body),
            },
            span,
        }
    }

    fn parse_for_expr(&mut self, span: Span) -> Expr {
        // Check if this is a for-in loop: for (Type name in expr) { body }
        // or a C-style for: for (init; cond; step) { body }
        self.expect_op(Op::LParen, "for: expected (");

        // Look ahead: is it for-in?
        let is_for_in = self.peek_is_type() || self.peek_is_ident("_");

        if is_for_in {
            let type_ = self.parse_type();
            let name = self
                .expect_ident("for-in: expected identifier")
                .unwrap_or_else(|| Id("__error__".to_string()));
            self.expect_keyword(Keyword::In, "for-in: expected in");
            let collection = self.parse_expression();
            self.expect_op(Op::RParen, "for-in: expected )");
            let body = if self.peek_is_op(Op::LBrace) {
                self.parse_block()
            } else {
                let expr = self.parse_expression();
                Block {
                    statements: vec![Stmt {
                        kind: StmtKind::Expr(Box::new(expr)),
                        span: self.current_span(),
                    }],
                    ret: None,
                    span: self.current_span(),
                }
            };
            Expr {
                kind: ExprKind::ForIn {
                    type_,
                    name,
                    collection: Box::new(collection),
                    body: Box::new(body),
                },
                span,
            }
        } else {
            // C-style for loop
            let mut init = None;
            if !self.peek_is_op(Op::Semi) {
                init = Some(self.parse_statement());
            }
            self.expect_op(Op::Semi, "for: expected ;");
            let cond = self.parse_expression();
            self.expect_op(Op::Semi, "for: expected ;");
            let step = if !self.peek_is_op(Op::RParen) {
                Some(self.parse_statement())
            } else {
                None
            };
            self.expect_op(Op::RParen, "for: expected )");
            let body = if self.peek_is_op(Op::LBrace) {
                self.parse_block()
            } else {
                let expr = self.parse_expression();
                Block {
                    statements: vec![Stmt {
                        kind: StmtKind::Expr(Box::new(expr)),
                        span: self.current_span(),
                    }],
                    ret: None,
                    span: self.current_span(),
                }
            };
            Expr {
                kind: ExprKind::For {
                    init,
                    cond: Box::new(cond),
                    step,
                    body: Box::new(body),
                },
                span,
            }
        }
    }

    fn parse_paren_expr(&mut self) -> Expr {
        self.expect_op(Op::LParen, "expression: expected (");
        let expr = self.parse_expression();
        self.expect_op(Op::RParen, "expression: expected )");
        expr
    }

    fn parse_block(&mut self) -> Block {
        let span = self.current_span();
        self.expect_op(Op::LBrace, "block: expected {");

        let mut statements = Vec::new();
        let mut ret = None;

        while !self.peek_is_op(Op::RBrace) && !self.at_eof() {
            let start_pos = self.pos;
            let stmt = self.parse_statement();
            match stmt.kind {
                StmtKind::Return(opt) => {
                    ret = opt;
                }
                _ => {
                    statements.push(stmt);
                }
            }
            // Consume an optional statement terminator.
            if self.peek_is_op(Op::Semi) {
                self.bump();
            }
            // Guarantee termination even on unexpected tokens.
            if self.pos == start_pos {
                self.errors.push(ParseError {
                    span: self.current_span(),
                    message: "unexpected token in block".into(),
                });
                self.bump();
            }
        }

        self.expect_op(Op::RBrace, "block: expected }");

        Block {
            statements,
            ret,
            span,
        }
    }

    fn parse_block_expr(&mut self) -> Expr {
        let block = self.parse_block();
        Expr {
            kind: ExprKind::Discard(Box::new(Expr {
                kind: ExprKind::Id(Id("__block__".to_string())),
                span: block.span.clone(),
            })),
            span: block.span,
        }
    }

    fn parse_statement(&mut self) -> Stmt {
        let span = self.current_span();

        match self.peek() {
            // Return
            Some(TokenKind::Keyword(Keyword::Return)) => {
                self.bump();
                let expr = if !self.at_eof()
                    && !self.peek_is_op(Op::RBrace)
                    && !self.peek_is_op(Op::Equals)
                {
                    Some(self.parse_expression())
                } else {
                    None
                };
                if self.peek_is_op(Op::Equals) {
                    self.bump();
                }
                Stmt {
                    kind: StmtKind::Return(expr.map(Box::new)),
                    span,
                }
            }

            // Break
            Some(TokenKind::Keyword(Keyword::Break)) => {
                self.bump();
                if self.peek_is_op(Op::Equals) {
                    self.bump();
                }
                Stmt {
                    kind: StmtKind::Break,
                    span,
                }
            }

            // Continue
            Some(TokenKind::Keyword(Keyword::Continue)) => {
                self.bump();
                if self.peek_is_op(Op::Equals) {
                    self.bump();
                }
                Stmt {
                    kind: StmtKind::Continue,
                    span,
                }
            }

            // @residual Type name = expr  (spec §9: residual binding)
            Some(TokenKind::AtResidual) => {
                self.bump();
                let type_ = self.parse_type();
                let name = self
                    .expect_ident("@residual: expected binding name")
                    .unwrap_or_else(|| Id("__error__".to_string()));
                self.expect_op(Op::Equals, "@residual: expected =");
                let value = self.parse_expression();
                Stmt {
                    kind: StmtKind::Bind {
                        type_: Some(type_.clone()),
                        name,
                        value: Box::new(Expr {
                            kind: ExprKind::AtResidual {
                                type_,
                                inner: Box::new(value),
                            },
                            span: self.current_span(),
                        }),
                    },
                    span,
                }
            }

            // Destructuring: Pattern = expression
            Some(TokenKind::Ident(id)) => {
                // Bare discard: `_ = expression;`
                if id == "_" {
                    self.bump();
                    self.expect_op(Op::Equals, "discard: expected =");
                    let value = self.parse_expression();
                    return Stmt {
                        kind: StmtKind::Discard(Box::new(value)),
                        span,
                    };
                }
                if !self.looks_like_binding() {
                    // Leading ident is a plain expression (call/field/etc.),
                    // not the start of `Type name = …` or `Pattern = …`.
                    let expr = self.parse_expression();
                    return Stmt {
                        kind: StmtKind::Expr(Box::new(expr)),
                        span,
                    };
                }
                // Save position to check if this is a binding or expression
                let saved_pos = self.pos;
                let first_type = self.parse_type();
                let second_id = if self.peek_is_ident("") {
                    None
                } else {
                    self.expect_ident("statement: expected identifier or =")
                };

                match second_id {
                    Some(name) => {
                        // Could be: Type name = expr  OR  Pattern = expr
                        if self.peek_is_op(Op::Equals) {
                            // A bare `_` target is a destructure/discard; any
                            // named target — even with a parameterized type
                            // like `List(Int) xs` or `Option(Int) mx` — is a
                            // typed binding.
                            let is_pattern = name.0 == "_";

                            if is_pattern {
                                // Destructuring: Pattern = expression
                                let pattern = Pattern {
                                    kind: PatternKind::Bind(name),
                                    span: self.current_span(),
                                };
                                self.bump(); // skip =
                                let source = self.parse_expression();
                                Stmt {
                                    kind: StmtKind::Destructure {
                                        pattern,
                                        source: Box::new(source),
                                    },
                                    span,
                                }
                            } else {
                                // Regular binding: Type name = expression
                                self.bump(); // skip =
                                let value = self.parse_expression();
                                Stmt {
                                    kind: StmtKind::Bind {
                                        type_: Some(first_type),
                                        name,
                                        value: Box::new(value),
                                    },
                                    span,
                                }
                            }
                        } else {
                            // Expression statement
                            let expr = Expr {
                                kind: ExprKind::Id(name),
                                span: self.current_span(),
                            };
                            Stmt {
                                kind: StmtKind::Expr(Box::new(expr)),
                                span,
                            }
                        }
                    }
                    None => {
                        // No second identifier: either a pattern
                        // destructuring (`Some(v) = expr`, `Point { x } = p`)
                        // or a plain parenthesized expression statement.
                        if self.peek_is_op(Op::LBrace) {
                            // Struct pattern: Name { fieldPattern, ... } = expr
                            let name = match &first_type {
                                Type::Base { name, params: None } => name.clone(),
                                _ => Id("__error__".to_string()),
                            };
                            self.bump();
                            let mut fields = Vec::new();
                            while !self.peek_is_op(Op::RBrace) && !self.at_eof() {
                                let field_name = self
                                    .expect_ident("struct pattern: expected field name")
                                    .unwrap_or_else(|| Id("__name__".to_string()));
                                let field_pat = if self.peek_is_op(Op::Colon) {
                                    self.bump();
                                    self.parse_pattern()
                                } else {
                                    // `name` shorthand for `name: name`.
                                    Pattern {
                                        kind: PatternKind::Bind(field_name.clone()),
                                        span: self.current_span(),
                                    }
                                };
                                fields.push((field_name, field_pat));
                                if self.peek_is_op(Op::Comma) {
                                    self.bump();
                                }
                            }
                            self.expect_op(Op::RBrace, "struct pattern: expected }");
                            self.expect_op(Op::Equals, "destructure: expected =");
                            let source = self.parse_expression();
                            let pattern = Pattern {
                                kind: PatternKind::Struct { name, fields },
                                span: self.current_span(),
                            };
                            Stmt {
                                kind: StmtKind::Destructure {
                                    pattern,
                                    source: Box::new(source),
                                },
                                span,
                            }
                        } else if self.peek_is_op(Op::Equals)
                            && matches!(
                                &first_type,
                                Type::Base {
                                    params: Some(_),
                                    ..
                                }
                            )
                        {
                            // Variant pattern: `Some(v) = expr`
                            let name = match &first_type {
                                Type::Base { name, .. } => name.clone(),
                                _ => Id("__error__".to_string()),
                            };
                            let param = match &first_type {
                                Type::Base { params: Some(ps), .. } if ps.len() == 1 => {
                                    ps[0].head_name().map(Id)
                                }
                                _ => None,
                            };
                            self.bump(); // skip =
                            let source = self.parse_expression();
                            let pattern = Pattern {
                                kind: PatternKind::Variant { name, param },
                                span: self.current_span(),
                            };
                            Stmt {
                                kind: StmtKind::Destructure {
                                    pattern,
                                    source: Box::new(source),
                                },
                                span,
                            }
                        } else {
                            // Restore and parse as an expression.
                            self.pos = saved_pos;
                            let expr = self.parse_expression();
                            Stmt {
                                kind: StmtKind::Expr(Box::new(expr)),
                                span,
                            }
                        }
                    }
                }
            }

            Some(TokenKind::Keyword(Keyword::While)) => {
                self.bump();
                let expr = self.parse_while_expr(span.clone());
                Stmt {
                    kind: StmtKind::Expr(Box::new(expr)),
                    span,
                }
            }

            Some(TokenKind::Keyword(Keyword::If)) => {
                self.bump();
                let expr = self.parse_if_expr(span.clone());
                Stmt {
                    kind: StmtKind::Expr(Box::new(expr)),
                    span,
                }
            }

            Some(TokenKind::Keyword(Keyword::For)) => {
                self.bump();
                let expr = self.parse_for_expr(span.clone());
                Stmt {
                    kind: StmtKind::Expr(Box::new(expr)),
                    span,
                }
            }

            _ => {
                // Expression statement
                let expr = self.parse_expression();
                Stmt {
                    kind: StmtKind::Expr(Box::new(expr)),
                    span,
                }
            }
        }
    }

    fn parse_capability_annotation(&mut self) -> CapabilityAnnotation {
        let name = self
            .expect_ident("capability: expected identifier")
            .unwrap_or_else(|| Id("__error__".to_string()));
        let mut params = Vec::new();
        if self.peek_is_op(Op::LParen) {
            self.bump();
            while !self.peek_is_op(Op::RParen) && !self.at_eof() {
                params.push(self.parse_expression_forced());
                if self.peek_is_op(Op::Comma) {
                    self.bump();
                }
            }
            self.expect_op(Op::RParen, "capability: expected )");
        }
        CapabilityAnnotation { name, params }
    }

    fn collect_doc_comments(&mut self) -> Vec<String> {
        let mut comments = Vec::new();
        while let Some(TokenKind::DocComment(dc)) = self.peek() {
            let comment = match dc {
                DocComment::Line(s) => s.clone(),
                DocComment::Block(s) => s.clone(),
            };
            self.bump();
            comments.push(comment);
        }
        comments
    }

    // ─── Helpers ────────────────────────────────────────────────

    fn peek(&self) -> Option<TokenKind> {
        self.tokens.get(self.pos).map(|t| t.kind.clone())
    }

    fn peek_after(&self) -> Option<TokenKind> {
        self.tokens.get(self.pos + 1).map(|t| t.kind.clone())
    }

    fn peek_after_is_op(&self, op: Op) -> bool {
        self.peek_after() == Some(TokenKind::Op(op))
    }

    fn bump(&mut self) -> Option<TokenKind> {
        if self.pos < self.tokens.len() {
            let kind = self.tokens[self.pos].kind.clone();
            self.pos += 1;
            Some(kind)
        } else {
            None
        }
    }

    fn at_eof(&self) -> bool {
        self.pos >= self.tokens.len()
            || matches!(
                self.tokens.get(self.pos).map(|t| &t.kind),
                Some(TokenKind::Eof)
            )
    }

    fn current_span(&self) -> Span {
        match self.tokens.get(self.pos) {
            Some(t) => Span {
                file: t.span.file.clone(),
                line: t.span.line,
                col_start: t.span.col_start,
                col_end: t.span.col_end,
            },
            None => Span {
                file: String::new(),
                line: 0,
                col_start: 0,
                col_end: 0,
            },
        }
    }

    fn peek_is_keyword(&self, kw: Keyword) -> bool {
        self.peek() == Some(TokenKind::Keyword(kw))
    }

    fn eat_keyword(&mut self, kw: Keyword) -> bool {
        if self.peek_is_keyword(kw) {
            self.bump();
            true
        } else {
            false
        }
    }

    fn peek_is_op(&self, op: Op) -> bool {
        self.peek() == Some(TokenKind::Op(op))
    }

    fn eat_op(&mut self, op: Op) -> bool {
        if self.peek_is_op(op) {
            self.bump();
            true
        } else {
            false
        }
    }

    fn expect_op(&mut self, op: Op, msg: &str) -> bool {
        if self.eat_op(op) {
            true
        } else {
            self.errors.push(ParseError {
                span: self.current_span(),
                message: format!("{}: expected '{}'", msg, Self::op_to_str(op)),
            });
            false
        }
    }

    /// Lookahead: check if the next tokens in brackets form range syntax.
    /// Detects: `..end`, `..=end`, `start..end`, `start..=end`, or `..` alone.
    fn is_range_syntax_in_bracket(&self) -> bool {
        match self.peek() {
            // `..end` or `..=end` — range operator at start
            Some(TokenKind::Op(Op::DotDotEq)) => true,
            Some(TokenKind::Op(Op::DotDot)) => true,
            // `start..end` or `start..=end` — need to peek past first token
            _ => {
                if self.peek().is_some() {
                    // Skip past the first token (identifier, literal, parenthesized expr, etc.)
                    let mut p = self.pos + 1;
                    while p < self.tokens.len() {
                        match &self.tokens[p].kind {
                            TokenKind::Op(Op::DotDotEq) | TokenKind::Op(Op::DotDot) => {
                                return true;
                            }
                            TokenKind::Op(Op::RParen) | TokenKind::Op(Op::RBracket) | TokenKind::Eof => {
                                // Hit a closing bracket without a range operator
                                return false;
                            }
                            _ => p += 1,
                        }
                    }
                }
                false
            }
        }
    }

    fn expect_keyword(&mut self, kw: Keyword, msg: &str) -> bool {
        if self.eat_keyword(kw) {
            true
        } else {
            self.errors.push(ParseError {
                span: self.current_span(),
                message: format!("{}: expected '{}'", msg, kw.as_str()),
            });
            false
        }
    }

    fn peek_is_ident(&self, ident: &str) -> bool {
        match self.peek() {
            Some(TokenKind::Ident(s)) => s == ident,
            _ => ident.is_empty(), // empty string matches anything (internal use)
        }
    }

    fn peek_is_type(&self) -> bool {
        match self.peek() {
            Some(TokenKind::Ident(s)) => {
                // Known type names
                matches!(
                    s.as_str(),
                    "Int"
                        | "UInt"
                        | "Float"
                        | "ISize"
                        | "USize"
                        | "Bool"
                        | "Str"
                        | "Bytes"
                        | "Option"
                        | "Result"
                        | "List"
                        | "Map"
                        | "Set"
                        | "SourceLoc"
                        | "RegionError"
                        | "Null"
                        | "Void"
                        | "Handle"
                        | "rt"
                ) || Keyword::from_str(s.as_str()).is_none() // not a keyword
            }
            Some(TokenKind::Keyword(kw)) => {
                !matches!(kw, Keyword::Import | Keyword::Pub | Keyword::Type)
            }
            _ => false,
        }
    }

    fn peek_is_at(&self) -> bool {
        self.peek() == Some(TokenKind::At)
    }

    /// Look ahead from a leading identifier to decide whether a statement is a
    /// binding (`Type name = …` / `Pattern = …`) or a plain expression
    /// statement. After the leading ident, a binding continues with an
    /// identifier and `=` (possibly after a balanced `(...)` type/pattern
    /// group); a plain expression continues directly with `(`, `.`, an
    /// operator, etc.
    fn looks_like_binding(&self) -> bool {
        let toks = &self.tokens;
        if self.pos + 1 >= toks.len() {
            return false;
        }
        let mut i = self.pos + 1;
        // Skip a balanced `(...)` section (parameterized type / pattern).
        if matches!(toks[i].kind, TokenKind::Op(Op::LParen)) {
            let mut depth = 0usize;
            loop {
                if i >= toks.len() {
                    return false;
                }
                let this = toks[i].kind.clone();
                i += 1;
                match this {
                    TokenKind::Op(Op::LParen) => depth += 1,
                    TokenKind::Op(Op::RParen) => {
                        if depth == 1 {
                            break;
                        }
                        depth -= 1;
                    }
                    _ => {}
                }
            }
        }
        // Skip a balanced `{ ... }` section (struct pattern / literal).
        if matches!(toks.get(i).map(|t| &t.kind), Some(TokenKind::Op(Op::LBrace))) {
            let mut depth = 0usize;
            loop {
                if i >= toks.len() {
                    return false;
                }
                let this = toks[i].kind.clone();
                i += 1;
                match this {
                    TokenKind::Op(Op::LBrace) => depth += 1,
                    TokenKind::Op(Op::RBrace) => {
                        if depth == 1 {
                            break;
                        }
                        depth -= 1;
                    }
                    _ => {}
                }
            }
        }
        i < toks.len()
            && matches!(
                toks[i].kind,
                TokenKind::Keyword(Keyword::True)
                    | TokenKind::Ident(_)
                    | TokenKind::Op(Op::Equals)
            )
    }

    fn expect_ident(&mut self, msg: &str) -> Option<Id> {
        match self.bump() {
            Some(TokenKind::Ident(s)) => Some(Id(s)),
            Some(TokenKind::Keyword(kw)) => {
                self.errors.push(ParseError {
                    span: self.current_span(),
                    message: format!(
                        "{}: expected identifier, found keyword '{}'",
                        msg,
                        kw.as_str()
                    ),
                });
                Some(Id(kw.as_str().to_string()))
            }
            _ => {
                self.errors.push(ParseError {
                    span: self.current_span(),
                    message: format!("{}: expected identifier", msg),
                });
                None
            }
        }
    }

    fn op_to_str(op: Op) -> &'static str {
        match op {
            Op::Plus => "+",
            Op::Minus => "-",
            Op::Star => "*",
            Op::Slash => "/",
            Op::Percent => "%",
            Op::Not => "!",
            Op::Tilde => "~",
            Op::ShiftLeft => "<<",
            Op::ShiftRight => ">>",
            Op::Less => "<",
            Op::LessEq => "<=",
            Op::Greater => ">",
            Op::GreaterEq => ">=",
            Op::EqEq => "==",
            Op::Ne => "!=",
            Op::Amp => "&",
            Op::Caret => "^",
            Op::Pipe => "|",
            Op::AndAnd => "&&",
            Op::OrOr => "||",
            Op::Question => "?",
            Op::Colon => ":",
            Op::Equals => "=",
            Op::Comma => ",",
            Op::Dot => ".",
            Op::Semi => ";",
            Op::LParen => "(",
            Op::RParen => ")",
            Op::LBrace => "{",
            Op::RBrace => "}",
            Op::LBracket => "[",
            Op::RBracket => "]",
            Op::FatArrow => "=>",
            Op::DotDot => "..",
            Op::DotDotEq => "..=",
            Op::At => "@",
            Op::Cast => "(Type)",
            Op::FString => "f\"",
            Op::RawString => "r\"",
            Op::ByteString => "b\"",
            Op::Location => "#location",
        }
    }

    /// Parse a partial expression from a string (for f-string interpolation).
    fn parse_partial(s: &str) -> (Expr, Vec<ParseError>) {
        let mut parser = Parser {
            tokens: Vec::new(),
            pos: 0,
            errors: Vec::new(),
        };
        // Lex the partial expression
        let (tokens, _) = Lexer::new("fstring", s).tokenize();
        parser.tokens = tokens;
        let expr = parser.parse_expression();
        (expr, parser.errors)
    }
}

// ─── Type helpers ─────────────────────────────────────────────────

impl Type {
    /// The identifier a type annotation builds on (its head name), if any.
    fn head_name(&self) -> Option<String> {
        match self {
            Type::Base { name, .. } => Some(name.0.clone()),
            Type::Residual(inner) => inner.head_name(),
            _ => None,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_simple_function() {
        let src = r#"
Int main() {
    return 0;
}
"#;
        let (unit, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
        assert_eq!(unit.declarations.len(), 1);
    }

    #[test]
    fn test_binding() {
        let src = r#"
Int main() {
    Int x = 42;
}
"#;
        let (_, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
    }

    #[test]
    fn test_residual_binding() {
        let src = r#"
Int main() {
    @residual Int x = 42;
}
"#;
        let (unit, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
        let func = match &unit.declarations[0] {
            Declaration::Function(f) => f,
            _ => panic!("expected a function"),
        };
        let stmt = &func.body.statements[0];
        match &stmt.kind {
            StmtKind::Bind { name, value, .. } => {
                assert_eq!(name.0, "x");
                assert!(matches!(value.kind, ExprKind::AtResidual { .. }));
            }
            other => panic!("expected a binding, got {other:?}"),
        }
    }

    #[test]
    fn test_function_with_params() {
        let src = r#"
Int add(Int a, Int b) {
    return a + b;
}
"#;
        let (_, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
    }

    #[test]
    fn test_if_expr() {
        let src = r#"
Int main() {
    Int x = if (true) { 1 } else { 2 };
}
"#;
        let (_, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
    }

    #[test]
    fn test_match() {
        let src = r#"
Int main() {
    match Some(42) {
        Some(x) => x,
        None    => 0
    }
}
"#;
        let (_, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
    }

    #[test]
    fn test_match_arms_semicolons() {
        let src = r#"
Int main() {
    match Some(42) {
        Some(x) => x;
        None    => 0;
    }
}
"#;
        let (_, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
    }

    #[test]
    fn test_match_mixed_separators() {
        let src = r#"
Int main() {
    match Some(42) {
        Some(x) => x,
        None    => 0;
    }
}
"#;
        let (_, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
    }

    #[test]
    fn test_list_literal() {
        let src = r#"
Int main() {
    [1, 2, 3]
}
"#;
        let (_, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
    }

    #[test]
    fn test_fstring() {
        let src = r#"
Int main() {
    f"hello {name}"
}
"#;
        let (_, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
    }

    #[test]
    fn test_import() {
        let src = r#"
import "math.resid";
import "math.resid" (sin, cos);
import "math.resid" as M;
"#;
        let (unit, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
        assert_eq!(unit.imports.len(), 3);
    }

    #[test]
    fn test_type_def() {
        let src = r#"
type Point = { x: Int, y: Int };
type Option(T) = Some(T) | None;
"#;
        let (_, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
    }

    #[test]
    fn test_ranges() {
        let src = r#"
Int main() {
    0..10;
    0..=5
}
"#;
        let (_, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
    }

    #[test]
    fn test_range_desugars_to_range_expr() {
        // `a..b` and `a..=b` must become ExprKind::Range, not a binary DotDot.
        let src = "Int main() {\n    1..3;\n    1..=3\n}\n";
        let (unit, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);

        let decl = &unit.declarations[0];
        let body = match decl {
            crate::Declaration::Function(f) => &f.body.statements,
            other => panic!("expected function, got {other:?}"),
        };
        let kinds: Vec<&ExprKind> = body
            .iter()
            .filter_map(|s| match &s.kind {
                crate::StmtKind::Expr(e) => Some(&e.kind),
                _ => None,
            })
            .collect();
        assert_eq!(kinds.len(), 2);
        let closeds: Vec<bool> = kinds
            .iter()
            .map(|k| match k {
                ExprKind::Range { closed, .. } => *closed,
                other => panic!("expected ExprKind::Range, got {other:?}"),
            })
            .collect();
        assert_eq!(closeds, vec![false, true]);
    }

    #[test]
    fn test_range_closed_and_open() {
        let src = r#"
Int main() {
    for (Int i in 0..3) {
        i;
    }
    for (Int j in 0..=2) {
        j;
    }
}
"#;
        let (unit, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
        let decl = &unit.declarations[0];
        let body = match decl {
            Declaration::Function(f) => &f.body.statements,
            _ => panic!("expected function"),
        };
        let ranges: Vec<bool> = body
            .iter()
            .filter_map(|s| match &s.kind {
                crate::StmtKind::Expr(e) => match &e.kind {
                    ExprKind::ForIn { collection, .. } => match &collection.kind {
                        ExprKind::Range { closed, .. } => Some(*closed),
                        other => panic!("expected Range collection, got {other:?}"),
                    },
                    other => panic!("expected ForIn, got {other:?}"),
                },
                _ => None,
            })
            .collect();
        assert_eq!(ranges, vec![false, true]);
    }

    #[test]
    fn test_slice_syntax_parses_as_slice() {
        // `xs[1..4]`, `xs[..4]`, `xs[1..]`, and `xs[..]` must parse as
        // ExprKind::Slice (not Index + Range).
        for src in [
            "Int main() { List(Int) xs = [1]; Slice(Int) s = xs[1..4]; return 0; }\n",
            "Int main() { List(Int) xs = [1]; Slice(Int) s = xs[..4]; return 0; }\n",
            "Int main() { List(Int) xs = [1]; Slice(Int) s = xs[1..]; return 0; }\n",
            "Int main() { List(Int) xs = [1]; Slice(Int) s = xs[..]; return 0; }\n",
            "Int main() { List(Int) xs = [1]; Slice(Int) s = xs[0..=3]; return 0; }\n",
        ] {
            let (unit, errors) = Parser::parse("slice.resid", src);
            assert!(errors.is_empty(), "Errors: {errors:?} for {src}");
            let decl = &unit.declarations[0];
            let body = match decl {
                Declaration::Function(f) => &f.body.statements,
                other => panic!("expected function, got {other:?}"),
            };
            let has_slice = body.iter().any(|s| match &s.kind {
                crate::StmtKind::Expr(e) => matches!(e.kind, ExprKind::Slice { .. }),
                crate::StmtKind::Bind { value, .. } => {
                    matches!(value.kind, ExprKind::Slice { .. })
                }
                _ => false,
            });
            assert!(has_slice, "expected ExprKind::Slice for {src}");
        }
    }

    #[test]
    fn test_if_let_parses_as_if_let() {
        let src = r#"
Int main() {
    if (Some(x) = opt) {
        x;
    } else {
        println("none");
    }
    while (Some(y) = it) {
        y;
    }
    return 0;
}
type Opt(T) = Some(T) | None;
"#;
        let (unit, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "Errors: {:?}", errors);
        let decl = &unit.declarations[0];
        let body = match decl {
            Declaration::Function(f) => &f.body.statements,
            _ => panic!("expected function"),
        };
        let kinds: Vec<&ExprKind> = body
            .iter()
            .filter_map(|s| match &s.kind {
                crate::StmtKind::Expr(e) => Some(&e.kind),
                _ => None,
            })
            .collect();
        assert_eq!(kinds.len(), 2);
        assert!(
            matches!(kinds[0], ExprKind::IfLet { pattern, source, .. }
                if matches!(pattern.kind, PatternKind::Variant { ref name, .. } if name.0 == "Some")
                    && matches!(source.kind, ExprKind::Id(ref id) if id.0 == "opt")),
            "first stmt not if-let: {:?}",
            kinds[0]
        );
        assert!(
            matches!(kinds[1], ExprKind::WhileLet { .. }),
            "second stmt not while-let: {:?}",
            kinds[1]
        );
    }

    #[test]
    fn parse_provider_call() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { filesystem.read(\"x\"); }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Expr(expr) => match &expr.kind {
                        ExprKind::ProviderCall { provider, verb, args } => {
                            assert_eq!(provider.0, "filesystem");
                            assert_eq!(verb.0, "read");
                            assert_eq!(args.len(), 1);
                        }
                        _ => panic!("expected ProviderCall, got {:?}", expr.kind),
                    },
                    _ => panic!("expected expr stmt, got {:?}", stmt.kind),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_method_call() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { obj.method(1, 2); }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Expr(expr) => match &expr.kind {
                        ExprKind::MethodCall { target, method, args } => {
                            match &target.kind {
                                ExprKind::Id(id) => assert_eq!(id.0, "obj"),
                                _ => panic!("expected Id, got {:?}", target.kind),
                            }
                            assert_eq!(method.0, "method");
                            assert_eq!(args.len(), 2);
                        }
                        _ => panic!("expected MethodCall, got {:?}", expr.kind),
                    },
                    _ => panic!("expected expr stmt, got {:?}", stmt.kind),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_field_access() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { obj.field; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Expr(expr) => match &expr.kind {
                        ExprKind::FieldAccess { target, field } => {
                            match &target.kind {
                                ExprKind::Id(id) => assert_eq!(id.0, "obj"),
                                _ => panic!("expected Id, got {:?}", target.kind),
                            }
                            assert_eq!(field.0, "field");
                        }
                        _ => panic!("expected FieldAccess, got {:?}", expr.kind),
                    },
                    _ => panic!("expected expr stmt, got {:?}", stmt.kind),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_nested_provider_call() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { filesystem.read(1, 2).method(); }");
        assert!(errors.len() >= 1, "expected parse error for chained postfix");
    }

    #[test]
    fn parse_field_access_then_method() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { obj.field.method(); }");
        assert!(errors.len() >= 1, "expected parse error for chained postfix");
    }

    #[test]
    fn parse_provider_call_with_string_arg() {
        let (result, errors) = Parser::parse("test.resid", r#"Int f() { filesystem.read("hello"); }"#);
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Expr(expr) => match &expr.kind {
                        ExprKind::ProviderCall { provider, verb, args } => {
                            assert_eq!(provider.0, "filesystem");
                            assert_eq!(verb.0, "read");
                            assert_eq!(args.len(), 1);
                            match &args[0].kind {
                                ExprKind::Literal(Literal::Str(s)) => assert_eq!(s.value, "hello"),
                                _ => panic!("expected string literal, got {:?}", args[0].kind),
                            }
                        }
                        _ => panic!("expected ProviderCall, got {:?}", expr.kind),
                    },
                    _ => panic!("expected expr stmt, got {:?}", stmt.kind),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_method_call_on_integer() {
        // 42.method() parses without error (42. is float literal, method() is separate expr)
        let (_result, errors) = Parser::parse("test.resid", "Int f() { 42.method(); }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    // ─── Additional parser tests ─────────────────────────────────

    #[test]
    fn parse_float_literal() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Float x = 3.14; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Bind { value, .. } => {
                        match &value.kind {
                            ExprKind::Literal(Literal::Float(fl)) => {
                                assert_eq!(fl.value, "3.14");
                            }
                            other => panic!("expected float literal, got {:?}", other),
                        }
                    }
                    other => panic!("expected bind, got {:?}", other),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_hex_int() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Int x = 0xff; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Bind { value, .. } => {
                        match &value.kind {
                            ExprKind::Literal(Literal::Int { kind, .. }) => {
                                assert!(matches!(kind, IntKind::Hex(_)));
                            }
                            other => panic!("expected int literal, got {:?}", other),
                        }
                    }
                    _ => panic!("expected bind"),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_binary_int() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Int x = 0b1010; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Bind { value, .. } => {
                        match &value.kind {
                            ExprKind::Literal(Literal::Int { kind, .. }) => {
                                assert!(matches!(kind, IntKind::Binary(_)));
                            }
                            other => panic!("expected int literal, got {:?}", other),
                        }
                    }
                    _ => panic!("expected bind"),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_octal_int() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Int x = 0o77; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Bind { value, .. } => {
                        match &value.kind {
                            ExprKind::Literal(Literal::Int { kind, .. }) => {
                                assert!(matches!(kind, IntKind::Octal(_)));
                            }
                            other => panic!("expected int literal, got {:?}", other),
                        }
                    }
                    _ => panic!("expected bind"),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_byte_string() {
        let (result, errors) = Parser::parse("test.resid", r#"Int f() { Bytes b = b"hello"; }"#);
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Bind { value, .. } => {
                        match &value.kind {
                            ExprKind::ByteString(bytes) => {
                                assert_eq!(bytes, b"hello");
                            }
                            other => panic!("expected byte string, got {:?}", other),
                        }
                    }
                    _ => panic!("expected bind"),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_raw_string() {
        let (result, errors) = Parser::parse("test.resid", r#"Int f() { Str s = r"C:\path"; }"#);
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Bind { value, .. } => {
                        match &value.kind {
                            ExprKind::RawString(s) => {
                                assert_eq!(s, "C:\\path");
                            }
                            other => panic!("expected raw string, got {:?}", other),
                        }
                    }
                    _ => panic!("expected bind"),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_location() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { SourceLoc l = #location; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Bind { value, .. } => {
                        match &value.kind {
                            ExprKind::Location => {}
                            other => panic!("expected Location, got {:?}", other),
                        }
                    }
                    _ => panic!("expected bind"),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_fstring_text_only() {
        let (result, errors) = Parser::parse("test.resid", r#"Int f() { Str s = f"hello"; }"#);
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Bind { value, .. } => {
                        match &value.kind {
                            ExprKind::FString(parts) => {
                                assert_eq!(parts.len(), 1);
                                match &parts[0] {
                                    crate::ast::FStringPart::Text(t) => assert_eq!(t.as_str(), "hello"),
                                    _ => panic!("expected text part"),
                                }
                            }
                            other => panic!("expected f-string, got {:?}", other),
                        }
                    }
                    _ => panic!("expected bind"),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_fstring_with_interpolation() {
        let (result, errors) = Parser::parse(
            "test.resid",
            r#"Int f() { Str name = "world"; println(f"hello {name}"); }"#,
        );
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_range_half_open() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Int r = 0..10; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Bind { value, .. } => {
                        match &value.kind {
                            ExprKind::Range { start, end, closed } => {
                                assert!(!closed);
                                match &start.kind {
                                    ExprKind::Literal(Literal::Int { value, .. }) => assert_eq!(*value, 0),
                                    _ => panic!("expected int literal start"),
                                }
                                match &end.kind {
                                    ExprKind::Literal(Literal::Int { value, .. }) => assert_eq!(*value, 10),
                                    _ => panic!("expected int literal end"),
                                }
                            }
                            other => panic!("expected Range, got {:?}", other),
                        }
                    }
                    _ => panic!("expected bind"),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_range_inclusive() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Int r = 0..=5; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Bind { value, .. } => {
                        match &value.kind {
                            ExprKind::Range { closed, .. } => {
                                assert!(*closed);
                            }
                            other => panic!("expected Range, got {:?}", other),
                        }
                    }
                    _ => panic!("expected bind"),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_slice_from_list() {
        let (result, errors) =
            Parser::parse("test.resid", "Int f() { List(Int) xs = [1,2,3]; List(Int) s = xs[1..3]; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_slice_partial_open_end() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Int x = xs[3..]; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_slice_partial_open_start() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Int x = xs[..3]; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_slice_open_both() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Int x = xs[..]; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_slice_inclusive() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Int x = xs[0..=3]; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_list_lit() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { List(Int) xs = [1, 2, 3]; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Bind { value, .. } => {
                        match &value.kind {
                            ExprKind::ListLit(elems) => {
                                assert_eq!(elems.len(), 3);
                            }
                            other => panic!("expected ListLit, got {:?}", other),
                        }
                    }
                    _ => panic!("expected bind"),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_struct_lit() {
        let (result, errors) =
            Parser::parse("test.resid", "Int f() { Point p = Point { x: 1, y: 2 }; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_if_let_some() {
        let (result, errors) =
            Parser::parse("test.resid", "Int f() { if (Some(n) = x) { return n; } }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Expr(expr) => match &expr.kind {
                        ExprKind::IfLet { pattern, .. } => {
                            match &pattern.kind {
                                PatternKind::Variant { name, param } => {
                                    assert_eq!(name.0, "Some");
                                    assert!(param.is_some());
                                }
                                _ => panic!("expected variant pattern"),
                            }
                        }
                        _ => panic!("expected IfLet"),
                    },
                    _ => panic!("expected expr stmt"),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_while_let() {
        let (result, errors) = Parser::parse(
            "test.resid",
            "Int f() { while (Some(n) = source) { n; } }",
        );
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_for_in_range() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { for (Int i in 0..10) { i; } }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Expr(expr) => match &expr.kind {
                        ExprKind::ForIn { type_, name, collection, .. } => {
                            match type_ {
                                Type::Base { name: n, .. } => assert_eq!(n.0, "Int"),
                                _ => panic!("expected Type::Base"),
                            }
                            assert_eq!(name.0, "i");
                            match &collection.kind {
                                ExprKind::Range { .. } => {}
                                _ => panic!("expected range collection"),
                            }
                        }
                        _ => panic!("expected ForIn"),
                    },
                    _ => panic!("expected expr stmt"),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_for_in_list() {
        let (result, errors) =
            Parser::parse("test.resid", "Int f() { for (Int x in [1,2,3]) { x; } }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_match() {
        let (result, errors) = Parser::parse(
            "test.resid",
            "Int f() { return match x { Some(n) => n, None => 0 }; }",
        );
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_destructure() {
        let (result, errors) =
            Parser::parse("test.resid", "Int f() { Int { x, y } = p; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_discard() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { _ = 42; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        match &result.declarations[0] {
            Declaration::Function(f) => {
                let stmt = &f.body.statements[0];
                match &stmt.kind {
                    StmtKind::Discard(expr) => {
                        match &expr.kind {
                            ExprKind::Literal(Literal::Int { value, .. }) => assert_eq!(*value, 42),
                            _ => panic!("expected int literal in discard"),
                        }
                    }
                    other => panic!("expected Discard, got {:?}", other),
                }
            }
            _ => panic!("expected function"),
        }
    }

    #[test]
    fn parse_assert() {
        let (result, errors) =
            Parser::parse("test.resid", r#"Int f() { assert(1 == 1, "ok"); }"#);
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_rt_assert() {
        let (result, errors) =
            Parser::parse("test.resid", r#"Int f() { rt_assert(1 == 1, "ok"); }"#);
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_known() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { known(1 == 1); }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_rt_known() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { rt_known(1 == 1); }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_todo() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { todo(\"not done\"); }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_unimplemented() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { unimplemented(\"not done\"); }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_comptime_print() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { comptime_print(42); }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_at_residual() {
        let (result, errors) =
            Parser::parse("test.resid", "Int f() { @residual Int x = 42; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_at_residual_float() {
        let (result, errors) =
            Parser::parse("test.resid", "Int f() { @residual Float x = 3.14; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_rt_expression() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Int x = rt 42; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_early_return() {
        let (result, errors) =
            Parser::parse("test.resid", "Option(Int) f() { return x?; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_else_fallback() {
        let (result, errors) =
            Parser::parse("test.resid", "Int f() { Int y = x else { 0 }; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_with_binding() {
        let (result, errors) =
            Parser::parse("test.resid", "Int f() { with (File h = open(\"path\")) { h; } }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_cast() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Int(32) x = (Int(32))y; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_index() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { return xs[0]; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_function_with_defaults() {
        let (result, errors) =
            Parser::parse("test.resid", "Int f(Int x = 1, Int y = 2) { return x + y; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_named_args() {
        let (result, errors) =
            Parser::parse("test.resid", "Int f() { return add(a = 1, b = 2); }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_bool_literal_true() {
        let (result, errors) = Parser::parse("test.resid", "Bool f() { return true; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_bool_literal_false() {
        let (result, errors) = Parser::parse("test.resid", "Bool f() { return false; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_type_def() {
        let (result, errors) =
            Parser::parse("test.resid", "type Point = { x: Int, y: Int };");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_pub_function() {
        let (result, errors) =
            Parser::parse("test.resid", "pub Int f() { return 42; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_nested_block() {
        let (result, errors) =
            Parser::parse("test.resid", "Int f() { { Int x = 1; { Int y = 2; return x + y; } } }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_empty_function() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { return 0; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_multiple_declarations() {
        let (result, errors) = Parser::parse(
            "test.resid",
            "Int f() { return 1; }\nInt g() { return 2; }",
        );
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
        assert_eq!(result.declarations.len(), 2, "expected 2 declarations");
    }

    #[test]
    fn parse_char_literal() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Char c = 'a'; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_null_literal() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Null n = null; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_ternary_like_if() {
        let (result, errors) = Parser::parse(
            "test.resid",
            "Int f() { Bool c = true; return if (c) { 1 } else { 0 }; }",
        );
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_while_with_break() {
        let (result, errors) = Parser::parse(
            "test.resid",
            "Int f() { while (true) { break; } return 0; }",
        );
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_while_with_continue() {
        let (result, errors) = Parser::parse(
            "test.resid",
            "Int f() { while (true) { continue; } return 0; }",
        );
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_if_without_else() {
        let (result, errors) =
            Parser::parse("test.resid", "Int f() { if (true) { return 1; } return 0; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_type_param_int32() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Int(32) x = 42; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_type_param_float32() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { Float(32) x = 3.14; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_type_param_uint8() {
        let (result, errors) = Parser::parse("test.resid", "Int f() { UInt(8) x = 255; }");
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_complex_fstring() {
        let (result, errors) = Parser::parse(
            "test.resid",
            r#"Int f() { Str s = f"count = {n}, name = {name}, pi = {pi}"; }"#,
        );
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_string_with_escapes() {
        let (result, errors) =
            Parser::parse("test.resid", r#"Int f() { Str s = "hello\nworld\t!"; }"#);
        assert_eq!(errors.len(), 0, "parse errors: {:?}", errors);
    }

    #[test]
    fn parse_mismatched_braces() {
        let (_result, errors) = Parser::parse("test.resid", "Int f() { return 1; }");
        assert_eq!(errors.len(), 0, "should parse fine");
        let (_result2, errors2) = Parser::parse("test.resid", "Int f() { return 1;");
        assert!(errors2.len() >= 1, "expected error for mismatched braces");
    }

    /// Extract the single expression statement from `Int main() { EXPR }`.
    fn parse_single_expr(src: &str) -> ExprKind {
        let (unit, errors) = Parser::parse("test.resid", src);
        assert!(errors.is_empty(), "parse errors: {errors:?}");
        let body = match &unit.declarations[0] {
            crate::Declaration::Function(f) => &f.body.statements,
            other => panic!("expected function, got {other:?}"),
        };
        let exprs: Vec<&ExprKind> = body
            .iter()
            .filter_map(|s| match &s.kind {
                crate::StmtKind::Expr(e) => Some(&e.kind),
                _ => None,
            })
            .collect();
        assert_eq!(exprs.len(), 1, "expected one expr statement");
        exprs[0].clone()
    }

    #[test]
    fn parse_behavior_def_and_using_instance() {
        let src = concat!(
            "type Point = { x: Int, y: Int };\n",
            "Int by_y(Point a, Point b) { return 0; }\n",
            "Ord(Point) = by_y;\n",
            "Int main() {\n",
            "    List(Point) ps = [];\n",
            "    List(Point) s = sort(ps, using = Ord(Point));\n",
            "    return 0;\n",
            "}\n"
        );
        let (unit, errs) = Parser::parse("t.resid", src);
        assert!(errs.is_empty(), "{errs:?}");
        let beh = unit
            .declarations
            .iter()
            .find_map(|d| match d {
                Declaration::Behavior(b) => Some(b),
                _ => None,
            })
            .expect("behavior declaration parsed");
        assert_eq!(beh.name.0, "Ord");
        assert_eq!(beh.type_params.len(), 1);
        assert_eq!(beh.type_params[0].0, "Point");
        match &beh.body.kind {
            ExprKind::Id(id) => assert_eq!(id.0, "by_y"),
            other => panic!("body must name the impl fn, got {other:?}"),
        }
        // The sort call's argument is wrapped in Using with instance text.
        let mut found_using = false;
        for decl in &unit.declarations {
            if let Declaration::Function(f) = decl {
                for stmt in &f.body.statements {
                    if let StmtKind::Bind { value, .. } = &stmt.kind {
                        if let ExprKind::Call { func, args } = &value.kind {
                            if matches!(&func.kind, ExprKind::Id(id) if id.0 == "sort") {
                                assert_eq!(args.len(), 1);
                                match &args[0].1.kind {
                                    ExprKind::Using { behavior, .. } => {
                                        assert_eq!(behavior.0, "Ord(Point)");
                                        found_using = true;
                                    }
                                    other => panic!("arg must be Using, got {other:?}"),
                                }
                            }
                        }
                    }
                }
            }
        }
        assert!(found_using, "using clause must wrap the sort argument");
    }

    #[test]
    fn parse_precedence_mul_over_add() {
        // 2 + 3 * 4 → 2 + (3 * 4): multiplicative binds tighter than additive.
        let e = parse_single_expr("Int main() { 2 + 3 * 4; }");
        match &e {
            ExprKind::BinaryOp { op, lhs, rhs } => {
                assert_eq!(*op, Op::Plus);
                assert!(matches!(lhs.kind, ExprKind::Literal(_)), "lhs = 2");
                match &rhs.kind {
                    ExprKind::BinaryOp { op, .. } => assert_eq!(*op, Op::Star),
                    other => panic!("rhs must be 3 * 4, got {other:?}"),
                }
            }
            other => panic!("expected top-level Plus, got {other:?}"),
        }
    }

    #[test]
    fn parse_precedence_eq_over_and() {
        // a == b && c → (a == b) && c: equality binds tighter than logical AND.
        let e = parse_single_expr("Int main() { a == b && c; }");
        match &e {
            ExprKind::BinaryOp { op, lhs, rhs } => {
                assert_eq!(*op, Op::AndAnd);
                match &lhs.kind {
                    ExprKind::BinaryOp { op, .. } => assert_eq!(*op, Op::EqEq),
                    other => panic!("lhs must be a == b, got {other:?}"),
                }
                assert!(matches!(rhs.kind, ExprKind::Id(_)), "rhs = c");
            }
            other => panic!("expected top-level AndAnd, got {other:?}"),
        }
    }

    #[test]
    fn parse_associativity_left_for_sub() {
        // 10 - 3 - 2 → (10 - 3) - 2: additive is left-associative.
        let e = parse_single_expr("Int main() { 10 - 3 - 2; }");
        match &e {
            ExprKind::BinaryOp { op, lhs, rhs } => {
                assert_eq!(*op, Op::Minus);
                match &lhs.kind {
                    ExprKind::BinaryOp { op, .. } => assert_eq!(*op, Op::Minus),
                    other => panic!("lhs must be 10 - 3, got {other:?}"),
                }
                assert!(matches!(rhs.kind, ExprKind::Literal(_)), "rhs = 2");
            }
            other => panic!("expected top-level Minus, got {other:?}"),
        }
    }

    #[test]
    fn parse_associativity_left_for_div() {
        // 8 / 4 / 2 → (8 / 4) / 2: multiplicative is left-associative.
        let e = parse_single_expr("Int main() { 8 / 4 / 2; }");
        match &e {
            ExprKind::BinaryOp { op, lhs, rhs } => {
                assert_eq!(*op, Op::Slash);
                match &lhs.kind {
                    ExprKind::BinaryOp { op, .. } => assert_eq!(*op, Op::Slash),
                    other => panic!("lhs must be 8 / 4, got {other:?}"),
                }
                assert!(matches!(rhs.kind, ExprKind::Literal(_)), "rhs = 2");
            }
            other => panic!("expected top-level Slash, got {other:?}"),
        }
    }

    #[test]
    fn parse_associativity_right_for_range() {
        // 1..2..3 nests right: 1..(2..3).
        let e = parse_single_expr("Int main() { 1..2..3; }");
        match &e {
            ExprKind::Range { start, end, .. } => {
                assert!(matches!(start.kind, ExprKind::Literal(_)), "start = 1");
                match &end.kind {
                    ExprKind::Range { .. } => {}
                    other => panic!("end must be 2..3, got {other:?}"),
                }
            }
            other => panic!("expected Range, got {other:?}"),
        }
    }
}

#[test]
fn bootstrap_sources_parse_clean() {
    let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    for name in ["typecheck.resid", "lexer.resid", "parser.resid"] {
        let src = std::fs::read_to_string(root.join("examples").join(name)).unwrap();
        let (unit, errors) = Parser::parse(name, &src);
        assert!(
            errors.is_empty(),
            "{name}: parse errors: {:?}",
            errors.iter().take(5).collect::<Vec<_>>()
        );
        assert!(!unit.declarations.is_empty(), "{name}: no declarations");
    }
}
