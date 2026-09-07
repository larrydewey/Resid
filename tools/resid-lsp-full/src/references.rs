//! Find references provider.

use resid_parser::{Declaration, Expr, ExprKind, Pattern, PatternKind, Stmt, StmtKind};
use tower_lsp::lsp_types::*;

use crate::analysis::AnalyzedFile;

pub fn find_references(analyzed: &Option<AnalyzedFile>, position: Position) -> Option<Vec<Location>> {
    let analyzed = analyzed.as_ref()?;

    // Find the symbol at position
    let symbol_name = find_symbol_at(analyzed, position)?;

    let mut locations = Vec::new();

    // Search all declarations
    for decl in &analyzed.unit.declarations {
        collect_references_in_decl(decl, &symbol_name, &analyzed.uri, &mut locations);
    }

    Some(locations)
}

fn find_symbol_at(analyzed: &AnalyzedFile, position: Position) -> Option<String> {
    // Check expression
    if let Some(expr) = analyzed.find_expr_at(position.line, position.character) {
        if let ExprKind::Id(id) = &expr.kind {
            return Some(id.0.clone());
        }
    }

    // Check declaration
    if let Some(decl) = analyzed.find_declaration_at(position.line, position.character) {
        match decl {
            Declaration::Function(f) => return Some(f.name.0.clone()),
            Declaration::Type(t) => return Some(t.name.0.clone()),
            Declaration::Behavior(b) => return Some(b.name.0.clone()),
            Declaration::Sandbox(_) => return Some("sandbox".to_string()),
        }
    }

    None
}

fn collect_references_in_decl(decl: &Declaration, name: &str, uri: &Url, locations: &mut Vec<Location>) {
    match decl {
        Declaration::Function(f) => {
            // Check function name
            if f.name.0 == name {
                locations.push(Location {
                    uri: uri.clone(),
                    range: decl_range(decl),
                });
            }
            // Check parameters
            for param in &f.params {
                if param.name.0 == name {
                    locations.push(Location {
                        uri: uri.clone(),
                        range: decl_range(decl),
                    });
                }
            }
            // Check function body
            for stmt in &f.body.statements {
                collect_references_in_stmt(stmt, name, uri, locations);
            }
        }
        Declaration::Type(t) => {
            if t.name.0 == name {
                locations.push(Location {
                    uri: uri.clone(),
                    range: decl_range(decl),
                });
            }
        }
        Declaration::Behavior(b) => {
            if b.name.0 == name {
                locations.push(Location {
                    uri: uri.clone(),
                    range: decl_range(decl),
                });
            }
        }
        Declaration::Sandbox(s) => {
            for d in &s.body {
                collect_references_in_decl(d, name, uri, locations);
            }
        }
    }
}

fn collect_references_in_stmt(stmt: &Stmt, name: &str, uri: &Url, locations: &mut Vec<Location>) {
    match &stmt.kind {
        StmtKind::Bind { name: n, .. } if n.0 == name => {
            locations.push(Location {
                uri: uri.clone(),
                range: stmt_range(stmt),
            });
        }
        StmtKind::Destructure { pattern, .. } => {
            collect_references_in_pattern(pattern, name, uri, locations);
        }
        StmtKind::Expr(e) => collect_references_in_expr(e, name, uri, locations),
        _ => {}
    }
}

fn collect_references_in_expr(expr: &Expr, name: &str, uri: &Url, locations: &mut Vec<Location>) {
    match &expr.kind {
        ExprKind::Id(id) if id.0 == name => {
            locations.push(Location {
                uri: uri.clone(),
                range: expr_range(expr),
            });
        }
        ExprKind::Call { func, args } => {
            collect_references_in_expr(func, name, uri, locations);
            for (_, arg) in args {
                collect_references_in_expr(arg, name, uri, locations);
            }
        }
        ExprKind::BinaryOp { lhs, rhs, .. } => {
            collect_references_in_expr(lhs, name, uri, locations);
            collect_references_in_expr(rhs, name, uri, locations);
        }
        ExprKind::UnaryOp { operand, .. } => collect_references_in_expr(operand, name, uri, locations),
        ExprKind::Cast { operand, .. } => collect_references_in_expr(operand, name, uri, locations),
        ExprKind::Index { target, index } => {
            collect_references_in_expr(target, name, uri, locations);
            collect_references_in_expr(index, name, uri, locations);
        }
        ExprKind::FieldAccess { target, .. } => collect_references_in_expr(target, name, uri, locations),
        ExprKind::MethodCall { target, args, .. } => {
            collect_references_in_expr(target, name, uri, locations);
            for arg in args {
                collect_references_in_expr(arg, name, uri, locations);
            }
        }
        ExprKind::If { cond, then_block, else_block, .. } => {
            collect_references_in_expr(cond, name, uri, locations);
            for s in &then_block.statements {
                collect_references_in_stmt(s, name, uri, locations);
            }
            if let Some(eb) = else_block {
                for s in &eb.statements {
                    collect_references_in_stmt(s, name, uri, locations);
                }
            }
        }
        ExprKind::Match { scrutinee, arms } => {
            collect_references_in_expr(scrutinee, name, uri, locations);
            for (pat, body) in arms {
                collect_references_in_pattern(pat, name, uri, locations);
                collect_references_in_expr(body, name, uri, locations);
            }
        }
        ExprKind::For { init, cond, step, body, .. } => {
            if let Some(i) = init {
                collect_references_in_stmt(i, name, uri, locations);
            }
            collect_references_in_expr(cond, name, uri, locations);
            if let Some(st) = step {
                collect_references_in_stmt(st, name, uri, locations);
            }
            for s in &body.statements {
                collect_references_in_stmt(s, name, uri, locations);
            }
        }
        ExprKind::ForIn { collection, body, .. } => {
            collect_references_in_expr(collection, name, uri, locations);
            for s in &body.statements {
                collect_references_in_stmt(s, name, uri, locations);
            }
        }
        ExprKind::While { cond, body } => {
            collect_references_in_expr(cond, name, uri, locations);
            for s in &body.statements {
                collect_references_in_stmt(s, name, uri, locations);
            }
        }
        ExprKind::Spawn { body, .. } => {
            for s in &body.statements {
                collect_references_in_stmt(s, name, uri, locations);
            }
        }
        ExprKind::StructLit { fields, .. } => {
            for (_, e) in fields {
                collect_references_in_expr(e, name, uri, locations);
            }
        }
        ExprKind::ListLit(elements) => {
            for e in elements {
                collect_references_in_expr(e, name, uri, locations);
            }
        }
        ExprKind::MapLit(entries) => {
            for (k, v) in entries {
                collect_references_in_expr(k, name, uri, locations);
                collect_references_in_expr(v, name, uri, locations);
            }
        }
        ExprKind::SetLit(elements) => {
            for e in elements {
                collect_references_in_expr(e, name, uri, locations);
            }
        }
        ExprKind::Range { start, end, .. } => {
            collect_references_in_expr(start, name, uri, locations);
            collect_references_in_expr(end, name, uri, locations);
        }
        ExprKind::FString(parts) => {
            for part in parts {
                if let resid_parser::FStringPart::Expr(e) = part {
                    collect_references_in_expr(e, name, uri, locations);
                }
            }
        }
        ExprKind::With { bindings, body } => {
            for b in bindings {
                collect_references_in_expr(&b.init, name, uri, locations);
            }
            for s in &body.statements {
                collect_references_in_stmt(s, name, uri, locations);
            }
        }
        ExprKind::IfLet { pattern, source, then_block, else_block, .. } => {
            collect_references_in_pattern(pattern, name, uri, locations);
            collect_references_in_expr(source, name, uri, locations);
            for s in &then_block.statements {
                collect_references_in_stmt(s, name, uri, locations);
            }
            if let Some(eb) = else_block {
                for s in &eb.statements {
                    collect_references_in_stmt(s, name, uri, locations);
                }
            }
        }
        ExprKind::WhileLet { pattern, source, body } => {
            collect_references_in_pattern(pattern, name, uri, locations);
            collect_references_in_expr(source, name, uri, locations);
            for s in &body.statements {
                collect_references_in_stmt(s, name, uri, locations);
            }
        }
        ExprKind::Destructure { pattern, source } => {
            collect_references_in_pattern(pattern, name, uri, locations);
            collect_references_in_expr(source, name, uri, locations);
        }
        ExprKind::Using { value, .. } => collect_references_in_expr(value, name, uri, locations),
        ExprKind::ProviderCall { args, .. } => {
            for arg in args {
                collect_references_in_expr(arg, name, uri, locations);
            }
        }
        ExprKind::EarlyReturn(e) => collect_references_in_expr(e, name, uri, locations),
        ExprKind::ElseFallback { value, fallback } => {
            collect_references_in_expr(value, name, uri, locations);
            for s in &fallback.statements {
                collect_references_in_stmt(s, name, uri, locations);
            }
        }
        ExprKind::Slice { target, range } => {
            collect_references_in_expr(target, name, uri, locations);
            if let Some(start) = &range.start {
                collect_references_in_expr(start, name, uri, locations);
            }
            if let Some(end) = &range.end {
                collect_references_in_expr(end, name, uri, locations);
            }
        }
        ExprKind::Rt(e) | ExprKind::Known(e) | ExprKind::RtKnown(e) | ExprKind::ComptimePrint(e) | ExprKind::Discard(e) => collect_references_in_expr(e, name, uri, locations),
        _ => {}
    }
}

fn collect_references_in_pattern(pattern: &Pattern, name: &str, uri: &Url, locations: &mut Vec<Location>) {
    match &pattern.kind {
        PatternKind::Bind(id) if id.0 == name => {
            locations.push(Location {
                uri: uri.clone(),
                range: pattern_range(pattern),
            });
        }
        PatternKind::Struct { fields, .. } => {
            for (_, p) in fields {
                collect_references_in_pattern(p, name, uri, locations);
            }
        }
        PatternKind::Variant { param, .. } => {
            if let Some(p) = param {
                if p.0 == name {
                    locations.push(Location {
                        uri: uri.clone(),
                        range: pattern_range(pattern),
                    });
                }
            }
        }
        _ => {}
    }
}

fn decl_range(decl: &Declaration) -> Range {
    let span = decl.span();
    Range {
        start: Position {
            line: span.line.saturating_sub(1) as u32,
            character: span.col_start.saturating_sub(1) as u32,
        },
        end: Position {
            line: span.line.saturating_sub(1) as u32,
            character: span.col_end.saturating_sub(1) as u32,
        },
    }
}

fn expr_range(expr: &Expr) -> Range {
    Range {
        start: Position {
            line: expr.span.line.saturating_sub(1) as u32,
            character: expr.span.col_start.saturating_sub(1) as u32,
        },
        end: Position {
            line: expr.span.line.saturating_sub(1) as u32,
            character: expr.span.col_end.saturating_sub(1) as u32,
        },
    }
}

fn stmt_range(stmt: &Stmt) -> Range {
    let span = stmt.span();
    Range {
        start: Position {
            line: span.line.saturating_sub(1) as u32,
            character: span.col_start.saturating_sub(1) as u32,
        },
        end: Position {
            line: span.line.saturating_sub(1) as u32,
            character: span.col_end.saturating_sub(1) as u32,
        },
    }
}

fn pattern_range(pattern: &Pattern) -> Range {
    let span = pattern.span();
    Range {
        start: Position {
            line: span.line.saturating_sub(1) as u32,
            character: span.col_start.saturating_sub(1) as u32,
        },
        end: Position {
            line: span.line.saturating_sub(1) as u32,
            character: span.col_end.saturating_sub(1) as u32,
        },
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

// Extension trait for Stmt to get span
trait StmtSpan {
    fn span(&self) -> &resid_lexer::token::Span;
}

impl StmtSpan for Stmt {
    fn span(&self) -> &resid_lexer::token::Span {
        &self.span
    }
}

// Extension trait for Pattern to get span
trait PatternSpan {
    fn span(&self) -> &resid_lexer::token::Span;
}

impl PatternSpan for Pattern {
    fn span(&self) -> &resid_lexer::token::Span {
        &self.span
    }
}