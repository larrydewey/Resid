//! Document analysis and storage.

use std::collections::HashMap;
use std::path::PathBuf;

use resid_parser::{
    Declaration, Expr, ExprKind, FuncDef, Id, ImportDecl, Pattern, PatternKind, Stmt, StmtKind,
    TranslationUnit, Type, TypeBody, TypeDef,
};
use resid_type::{FunctionSig, SemType, Signatures, TypeError, Types};
use tower_lsp::lsp_types::Url;

#[derive(Debug, Clone)]
pub struct AnalyzedFile {
    pub uri: Url,
    pub text: String,
    pub unit: TranslationUnit,
    pub parse_errors: Vec<resid_parser::ParseError>,
    pub type_errors: Vec<TypeError>,
    pub signatures: Signatures,
    pub types: Types,
}

impl AnalyzedFile {
    pub fn find_declaration_at(&self, line: u32, character: u32) -> Option<&Declaration> {
        let line = line as usize;
        let character = character as usize;
        for decl in &self.unit.declarations {
            if decl.span().line == line + 1
                && decl.span().col_start <= character + 1
                && character + 1 <= decl.span().col_end
            {
                return Some(decl);
            }
        }
        None
    }

    pub fn find_expr_at(&self, line: u32, character: u32) -> Option<&Expr> {
        let line = line as usize;
        let character = character as usize;
        fn find_in_expr(expr: &Expr, line: usize, character: usize) -> Option<&Expr> {
            if expr.span.line == line + 1
                && expr.span.col_start <= character + 1
                && character + 1 <= expr.span.col_end
            {
                match &expr.kind {
                    ExprKind::Call { args, .. } => {
                        for (_, arg) in args {
                            if let Some(found) = find_in_expr(arg, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::BinaryOp { lhs, rhs, .. } => {
                        if let Some(found) = find_in_expr(lhs, line, character) {
                            return Some(found);
                        }
                        if let Some(found) = find_in_expr(rhs, line, character) {
                            return Some(found);
                        }
                    }
                    ExprKind::UnaryOp { operand, .. } => {
                        if let Some(found) = find_in_expr(operand, line, character) {
                            return Some(found);
                        }
                    }
                    ExprKind::Cast { operand, .. } => {
                        if let Some(found) = find_in_expr(operand, line, character) {
                            return Some(found);
                        }
                    }
                    ExprKind::Index { target, index } => {
                        if let Some(found) = find_in_expr(target, line, character) {
                            return Some(found);
                        }
                        if let Some(found) = find_in_expr(index, line, character) {
                            return Some(found);
                        }
                    }
                    ExprKind::FieldAccess { target, .. } => {
                        if let Some(found) = find_in_expr(target, line, character) {
                            return Some(found);
                        }
                    }
                    ExprKind::MethodCall { target, args, .. } => {
                        if let Some(found) = find_in_expr(target, line, character) {
                            return Some(found);
                        }
                        for arg in args {
                            if let Some(found) = find_in_expr(arg, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::If {
                        cond, then_block, else_block, ..
                    } => {
                        if let Some(found) = find_in_expr(cond, line, character) {
                            return Some(found);
                        }
                        for stmt in &then_block.statements {
                            if let Some(found) = find_in_stmt(stmt, line, character) {
                                return Some(found);
                            }
                        }
                        if let Some(eb) = else_block {
                            for stmt in &eb.statements {
                                if let Some(found) = find_in_stmt(stmt, line, character) {
                                    return Some(found);
                                }
                            }
                        }
                    }
                    ExprKind::Match { scrutinee, arms } => {
                        if let Some(found) = find_in_expr(scrutinee, line, character) {
                            return Some(found);
                        }
                        for (pat, guard) in arms {
                            if let Some(found) = find_in_pattern(pat, line, character) {
                                return Some(found);
                            }
                            if let Some(found) = find_in_expr(guard, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::For {
                        init, cond, step, body, ..
                    } => {
                        if let Some(i) = init {
                            if let Some(found) = find_in_stmt(i, line, character) {
                                return Some(found);
                            }
                        }
                        if let Some(found) = find_in_expr(cond, line, character) {
                            return Some(found);
                        }
                        if let Some(st) = step {
                            if let Some(found) = find_in_stmt(st, line, character) {
                                return Some(found);
                            }
                        }
                        for stmt in &body.statements {
                            if let Some(found) = find_in_stmt(stmt, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::ForIn {
                        type_: _, name: _, collection, body, ..
                    } => {
                        if let Some(found) = find_in_expr(collection, line, character) {
                            return Some(found);
                        }
                        for stmt in &body.statements {
                            if let Some(found) = find_in_stmt(stmt, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::While { cond, body } => {
                        if let Some(found) = find_in_expr(cond, line, character) {
                            return Some(found);
                        }
                        for stmt in &body.statements {
                            if let Some(found) = find_in_stmt(stmt, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::Spawn { body, .. } => {
                        for stmt in &body.statements {
                            if let Some(found) = find_in_stmt(stmt, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::StructLit { fields, .. } => {
                        for (_, e) in fields {
                            if let Some(found) = find_in_expr(e, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::ListLit(elements) => {
                        for e in elements {
                            if let Some(found) = find_in_expr(e, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::MapLit(entries) => {
                        for (k, v) in entries {
                            if let Some(found) = find_in_expr(k, line, character) {
                                return Some(found);
                            }
                            if let Some(found) = find_in_expr(v, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::SetLit(elements) => {
                        for e in elements {
                            if let Some(found) = find_in_expr(e, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::Range { start, end, .. } => {
                        if let Some(found) = find_in_expr(start, line, character) {
                            return Some(found);
                        }
                        if let Some(found) = find_in_expr(end, line, character) {
                            return Some(found);
                        }
                    }
                    ExprKind::FString(parts) => {
                        for part in parts {
                            if let resid_parser::FStringPart::Expr(e) = part {
                                if let Some(found) = find_in_expr(e, line, character) {
                                    return Some(found);
                                }
                            }
                        }
                    }
                    ExprKind::With { bindings, body } => {
                        for b in bindings {
                            if let Some(found) = find_in_expr(&b.init, line, character) {
                                return Some(found);
                            }
                        }
                        for stmt in &body.statements {
                            if let Some(found) = find_in_stmt(stmt, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::IfLet { pattern, source, then_block, else_block, .. } => {
                        if let Some(found) = find_in_pattern(pattern, line, character) {
                            return Some(found);
                        }
                        if let Some(found) = find_in_expr(source, line, character) {
                            return Some(found);
                        }
                        for stmt in &then_block.statements {
                            if let Some(found) = find_in_stmt(stmt, line, character) {
                                return Some(found);
                            }
                        }
                        if let Some(eb) = else_block {
                            for stmt in &eb.statements {
                                if let Some(found) = find_in_stmt(stmt, line, character) {
                                    return Some(found);
                                }
                            }
                        }
                    }
                    ExprKind::WhileLet { pattern, source, body } => {
                        if let Some(found) = find_in_pattern(pattern, line, character) {
                            return Some(found);
                        }
                        if let Some(found) = find_in_expr(source, line, character) {
                            return Some(found);
                        }
                        for stmt in &body.statements {
                            if let Some(found) = find_in_stmt(stmt, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::Destructure { pattern, source } => {
                        if let Some(found) = find_in_pattern(pattern, line, character) {
                            return Some(found);
                        }
                        if let Some(found) = find_in_expr(source, line, character) {
                            return Some(found);
                        }
                    }
                    ExprKind::Using { value, .. } => {
                        if let Some(found) = find_in_expr(value, line, character) {
                            return Some(found);
                        }
                    }
                    ExprKind::ProviderCall { args, .. } => {
                        for arg in args {
                            if let Some(found) = find_in_expr(arg, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::EarlyReturn(e) => {
                        if let Some(found) = find_in_expr(e, line, character) {
                            return Some(found);
                        }
                    }
                    ExprKind::ElseFallback { value, fallback } => {
                        if let Some(found) = find_in_expr(value, line, character) {
                            return Some(found);
                        }
                        for stmt in &fallback.statements {
                            if let Some(found) = find_in_stmt(stmt, line, character) {
                                return Some(found);
                            }
                        }
                    }
                    ExprKind::Slice { target, range } => {
                        if let Some(found) = find_in_expr(target, line, character) {
                            return Some(found);
                        }
                        if let Some(found) = find_in_range_expr(range, line, character) {
                            return Some(found);
                        }
                    }
                    ExprKind::Rt(e) | ExprKind::Known(e) | ExprKind::RtKnown(e) | ExprKind::ComptimePrint(e) | ExprKind::Discard(e) => {
                        if let Some(found) = find_in_expr(e, line, character) {
                            return Some(found);
                        }
                    }
                    _ => {}
                }
                return Some(expr);
            }
            None
        }

        fn find_in_range_expr(range: &resid_parser::RangeExpr, line: usize, character: usize) -> Option<&Expr> {
            if let Some(start) = &range.start {
                if let Some(found) = find_in_expr(start, line, character) {
                    return Some(found);
                }
            }
            if let Some(end) = &range.end {
                if let Some(found) = find_in_expr(end, line, character) {
                    return Some(found);
                }
            }
            None
        }

        fn find_in_stmt(stmt: &Stmt, line: usize, character: usize) -> Option<&Expr> {
            match &stmt.kind {
                StmtKind::Bind { value, .. } => find_in_expr(value, line, character),
                StmtKind::Expr(e) => find_in_expr(e, line, character),
                StmtKind::Return(e) => e.as_ref().and_then(|e| find_in_expr(e, line, character)),
                StmtKind::Destructure { pattern, source } => {
                    if let Some(found) = find_in_pattern(pattern, line, character) {
                        return Some(found);
                    }
                    find_in_expr(source, line, character)
                }
                _ => None,
            }
        }

        fn find_in_pattern(pattern: &Pattern, line: usize, character: usize) -> Option<&Expr> {
            match &pattern.kind {
                PatternKind::Struct { fields, .. } => {
                    for (_, p) in fields {
                        if let Some(found) = find_in_pattern(p, line, character) {
                            return Some(found);
                        }
                    }
                }
                PatternKind::Variant { param, .. } => {
                    if let Some(p) = param {
                        // Pattern variant parameter is an Id, not an Expr
                    }
                }
                _ => {}
            }
            None
        }

        for decl in &self.unit.declarations {
            match decl {
                Declaration::Function(f) => {
                    for stmt in &f.body.statements {
                        if let Some(found) = find_in_stmt(stmt, line, character) {
                            return Some(found);
                        }
                    }
                }
                Declaration::Sandbox(s) => {
                    for d in &s.body {
                        match d {
                            Declaration::Function(f) => {
                                for stmt in &f.body.statements {
                                    if let Some(found) = find_in_stmt(stmt, line, character) {
                                        return Some(found);
                                    }
                                }
                            }
                            _ => {}
                        }
                    }
                }
                _ => {}
            }
        }
        None
    }

    pub fn get_signature(&self, name: &str) -> Option<&FunctionSig> {
        self.signatures.get(name)
    }

    pub fn get_type(&self, name: &str) -> Option<&SemType> {
        self.types.get(name)
    }

    pub fn all_signatures(&self) -> &Signatures {
        &self.signatures
    }

    pub fn all_types(&self) -> &Types {
        &self.types
    }
}

// Extension trait for Declaration to get span
trait DeclarationSpan {
    fn span(&self) -> &resid_lexer::token::Span;
}

impl DeclarationSpan for Declaration {
    fn span(&self) -> &resid_lexer::token::Span {
        match self {
            Declaration::Function(f) => &f.span,
            Declaration::Type(t) => &t.span,
            Declaration::Behavior(b) => &b.span,
            Declaration::Sandbox(s) => &s.span,
        }
    }
}

#[derive(Debug)]
pub struct DocumentStore {
    files: HashMap<Url, AnalyzedFile>,
}

impl DocumentStore {
    pub fn new() -> Self {
        Self {
            files: HashMap::new(),
        }
    }

    pub fn insert(&mut self, uri: Url, analyzed: AnalyzedFile) {
        self.files.insert(uri, analyzed);
    }

    pub fn get(&self, uri: &Url) -> Option<&AnalyzedFile> {
        self.files.get(uri)
    }

    pub fn remove(&mut self, uri: &Url) {
        self.files.remove(uri);
    }
}

impl Default for DocumentStore {
    fn default() -> Self {
        Self::new()
    }
}