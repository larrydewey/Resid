//! Go to definition provider.

use resid_parser::{Declaration, Expr, ExprKind, FuncDef, Pattern, PatternKind, Stmt, StmtKind};
use tower_lsp::lsp_types::*;

use crate::analysis::AnalyzedFile;

pub fn goto_definition(analyzed: &Option<AnalyzedFile>, position: Position) -> Option<GotoDefinitionResponse> {
    let analyzed = analyzed.as_ref()?;
    let uri = &analyzed.uri;

    // Try to find an expression at the position
    if let Some(expr) = analyzed.find_expr_at(position.line, position.character) {
        return goto_for_expr(analyzed, expr, uri);
    }

    // Try to find a declaration at the position
    if let Some(decl) = analyzed.find_declaration_at(position.line, position.character) {
        return goto_for_decl(analyzed, decl, uri);
    }

    None
}

fn goto_for_expr(analyzed: &AnalyzedFile, expr: &Expr, uri: &Url) -> Option<GotoDefinitionResponse> {
    match &expr.kind {
        ExprKind::Id(id) => {
            let name = &id.0;
            // Check if it's a function
            if analyzed.get_signature(name).is_some() {
                return find_func_definition(analyzed, name, uri);
            }
            // Check if it's a type
            if analyzed.get_type(name).is_some() {
                return find_type_definition(analyzed, name, uri);
            }
            // Check if it's a local variable
            find_local_definition(analyzed, name, uri)
        }
        ExprKind::FieldAccess { target, field } => {
            if let ExprKind::Id(obj_id) = &target.kind {
                let obj_name = &obj_id.0;
                if let Some(ty) = analyzed.get_type(obj_name) {
                    if let Some(field_def) = find_field_definition(analyzed, ty, &field.0) {
                        return Some(GotoDefinitionResponse::Scalar(field_def));
                    }
                }
            }
            None
        }
        _ => None,
    }
}

fn goto_for_decl(analyzed: &AnalyzedFile, decl: &Declaration, uri: &Url) -> Option<GotoDefinitionResponse> {
    match decl {
        Declaration::Function(f) => {
            find_func_definition(analyzed, &f.name.0, uri)
        }
        Declaration::Type(t) => {
            find_type_definition(analyzed, &t.name.0, uri)
        }
        Declaration::Behavior(b) => {
            None
        }
        Declaration::Sandbox(_) => None,
    }
}

fn find_func_definition(analyzed: &AnalyzedFile, name: &str, uri: &Url) -> Option<GotoDefinitionResponse> {
    for decl in &analyzed.unit.declarations {
        if let Declaration::Function(f) = decl {
            if f.name.0 == name {
                return Some(GotoDefinitionResponse::Scalar(Location {
                    uri: analyzed.uri.clone(),
                    range: decl_range(decl),
                }));
            }
        }
    }
    None
}

fn find_type_definition(analyzed: &AnalyzedFile, name: &str, uri: &Url) -> Option<GotoDefinitionResponse> {
    for decl in &analyzed.unit.declarations {
        if let Declaration::Type(t) = decl {
            if t.name.0 == name {
                return Some(GotoDefinitionResponse::Scalar(Location {
                    uri: analyzed.uri.clone(),
                    range: decl_range(decl),
                }));
            }
        }
    }
    None
}

fn find_local_definition(analyzed: &AnalyzedFile, name: &str, uri: &Url) -> Option<GotoDefinitionResponse> {
    // Search in the current function scope
    for decl in &analyzed.unit.declarations {
        if let Declaration::Function(f) = decl {
            // Check parameters
            for param in &f.params {
                if param.name.0 == name {
                    return Some(GotoDefinitionResponse::Scalar(Location {
                        uri: analyzed.uri.clone(),
                        range: decl_range(decl),
                    }));
                }
            }
            // Check local bindings in function body
            if let Some(loc) = find_in_stmts(&f.body.statements, name, uri) {
                return Some(GotoDefinitionResponse::Scalar(loc));
            }
        }
    }
    None
}

fn find_in_stmts(stmts: &[Stmt], name: &str, uri: &Url) -> Option<Location> {
    for stmt in stmts {
        if let Some(loc) = find_in_stmt(stmt, name, uri) {
            return Some(loc);
        }
    }
    None
}

fn find_in_stmt(stmt: &Stmt, name: &str, uri: &Url) -> Option<Location> {
    match &stmt.kind {
        StmtKind::Bind { name: n, .. } if n.0 == name => Some(stmt_location(stmt, uri)),
        StmtKind::Destructure { pattern, .. } => find_in_pattern(pattern, name, uri),
        StmtKind::Expr(e) => find_in_expr(e, name, uri),
        _ => None,
    }
}

fn find_in_expr(expr: &Expr, name: &str, uri: &Url) -> Option<Location> {
    match &expr.kind {
        ExprKind::Id(id) if id.0 == name => Some(expr_location(expr, uri)),
        ExprKind::Call { func, args } => {
            if let Some(loc) = find_in_expr(func, name, uri) {
                return Some(loc);
            }
            for (_, arg) in args {
                if let Some(loc) = find_in_expr(arg, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::BinaryOp { lhs, rhs, .. } => {
            find_in_expr(lhs, name, uri).or_else(|| find_in_expr(rhs, name, uri))
        }
        ExprKind::UnaryOp { operand, .. } => find_in_expr(operand, name, uri),
        ExprKind::Cast { operand, .. } => find_in_expr(operand, name, uri),
        ExprKind::Index { target, index } => {
            find_in_expr(target, name, uri).or_else(|| find_in_expr(index, name, uri))
        }
        ExprKind::FieldAccess { target, .. } => find_in_expr(target, name, uri),
        ExprKind::MethodCall { target, args, .. } => {
            if let Some(loc) = find_in_expr(target, name, uri) {
                return Some(loc);
            }
            for arg in args {
                if let Some(loc) = find_in_expr(arg, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::If { cond, then_block, else_block, .. } => {
            if let Some(loc) = find_in_expr(cond, name, uri) {
                return Some(loc);
            }
            for s in &then_block.statements {
                if let Some(loc) = find_in_stmt(s, name, uri) {
                    return Some(loc);
                }
            }
            if let Some(eb) = else_block {
                for s in &eb.statements {
                    if let Some(loc) = find_in_stmt(s, name, uri) {
                        return Some(loc);
                    }
                }
            }
            None
        }
        ExprKind::Match { scrutinee, arms } => {
            if let Some(loc) = find_in_expr(scrutinee, name, uri) {
                return Some(loc);
            }
            for (pat, body) in arms {
                if let Some(loc) = find_in_pattern(pat, name, uri) {
                    return Some(loc);
                }
                if let Some(loc) = find_in_expr(body, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::For { init, cond, step, body, .. } => {
            if let Some(i) = init {
                if let Some(loc) = find_in_stmt(i, name, uri) {
                    return Some(loc);
                }
            }
            if let Some(loc) = find_in_expr(cond, name, uri) {
                return Some(loc);
            }
            if let Some(st) = step {
                if let Some(loc) = find_in_stmt(st, name, uri) {
                    return Some(loc);
                }
            }
            for s in &body.statements {
                if let Some(loc) = find_in_stmt(s, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::ForIn { collection, body, .. } => {
            if let Some(loc) = find_in_expr(collection, name, uri) {
                return Some(loc);
            }
            for s in &body.statements {
                if let Some(loc) = find_in_stmt(s, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::While { cond, body } => {
            if let Some(loc) = find_in_expr(cond, name, uri) {
                return Some(loc);
            }
            for s in &body.statements {
                if let Some(loc) = find_in_stmt(s, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::Spawn { body, .. } => {
            for s in &body.statements {
                if let Some(loc) = find_in_stmt(s, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::StructLit { fields, .. } => {
            for (_, e) in fields {
                if let Some(loc) = find_in_expr(e, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::ListLit(elements) => {
            for e in elements {
                if let Some(loc) = find_in_expr(e, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::MapLit(entries) => {
            for (k, v) in entries {
                if let Some(loc) = find_in_expr(k, name, uri) {
                    return Some(loc);
                }
                if let Some(loc) = find_in_expr(v, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::SetLit(elements) => {
            for e in elements {
                if let Some(loc) = find_in_expr(e, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::Range { start, end, .. } => {
            find_in_expr(start, name, uri).or_else(|| find_in_expr(end, name, uri))
        }
        ExprKind::FString(parts) => {
            for part in parts {
                if let resid_parser::FStringPart::Expr(e) = part {
                    if let Some(loc) = find_in_expr(e, name, uri) {
                        return Some(loc);
                    }
                }
            }
            None
        }
        ExprKind::With { bindings, body } => {
            for b in bindings {
                if let Some(loc) = find_in_expr(&b.init, name, uri) {
                    return Some(loc);
                }
            }
            for s in &body.statements {
                if let Some(loc) = find_in_stmt(s, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::IfLet { pattern, source, then_block, else_block, .. } => {
            if let Some(loc) = find_in_pattern(pattern, name, uri) {
                return Some(loc);
            }
            if let Some(loc) = find_in_expr(source, name, uri) {
                return Some(loc);
            }
            for s in &then_block.statements {
                if let Some(loc) = find_in_stmt(s, name, uri) {
                    return Some(loc);
                }
            }
            if let Some(eb) = else_block {
                for s in &eb.statements {
                    if let Some(loc) = find_in_stmt(s, name, uri) {
                        return Some(loc);
                    }
                }
            }
            None
        }
        ExprKind::WhileLet { pattern, source, body } => {
            if let Some(loc) = find_in_pattern(pattern, name, uri) {
                return Some(loc);
            }
            if let Some(loc) = find_in_expr(source, name, uri) {
                return Some(loc);
            }
            for s in &body.statements {
                if let Some(loc) = find_in_stmt(s, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::Destructure { pattern, source } => {
            if let Some(loc) = find_in_pattern(pattern, name, uri) {
                return Some(loc);
            }
            if let Some(loc) = find_in_expr(source, name, uri) {
                return Some(loc);
            }
            None
        }
        ExprKind::Using { value, .. } => find_in_expr(value, name, uri),
        ExprKind::ProviderCall { args, .. } => {
            for arg in args {
                if let Some(loc) = find_in_expr(arg, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::EarlyReturn(e) => find_in_expr(e, name, uri),
        ExprKind::ElseFallback { value, fallback } => {
            if let Some(loc) = find_in_expr(value, name, uri) {
                return Some(loc);
            }
            for s in &fallback.statements {
                if let Some(loc) = find_in_stmt(s, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::Slice { target, range } => {
            if let Some(loc) = find_in_expr(target, name, uri) {
                return Some(loc);
            }
            if let Some(start) = &range.start {
                if let Some(loc) = find_in_expr(start, name, uri) {
                    return Some(loc);
                }
            }
            if let Some(end) = &range.end {
                if let Some(loc) = find_in_expr(end, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        ExprKind::Rt(e) | ExprKind::Known(e) | ExprKind::RtKnown(e) | ExprKind::ComptimePrint(e) | ExprKind::Discard(e) => find_in_expr(e, name, uri),
        _ => None,
    }
}

fn find_in_pattern(pattern: &Pattern, name: &str, uri: &Url) -> Option<Location> {
    match &pattern.kind {
        PatternKind::Bind(id) if id.0 == name => Some(pattern_location(pattern, uri)),
        PatternKind::Struct { fields, .. } => {
            for (_, p) in fields {
                if let Some(loc) = find_in_pattern(p, name, uri) {
                    return Some(loc);
                }
            }
            None
        }
        PatternKind::Variant { param, .. } => {
            if let Some(p) = param {
                if p.0 == name {
                    return Some(pattern_location(pattern, uri));
                }
            }
            None
        }
        _ => None,
    }
}

fn find_field_definition(analyzed: &AnalyzedFile, ty: &resid_type::SemType, field: &str) -> Option<Location> {
    match ty {
        resid_type::SemType::Struct { fields, .. } => {
            for (fname, _) in fields {
                if fname == field {
                    for decl in &analyzed.unit.declarations {
                        if let Declaration::Type(t) = decl {
                            return Some(Location {
                                uri: analyzed.uri.clone(),
                                range: decl_range(decl),
                            });
                        }
                    }
                }
            }
            None
        }
        _ => None,
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

fn expr_location(expr: &Expr, uri: &Url) -> Location {
    Location {
        uri: uri.clone(),
        range: Range {
            start: Position {
                line: expr.span.line.saturating_sub(1) as u32,
                character: expr.span.col_start.saturating_sub(1) as u32,
            },
            end: Position {
                line: expr.span.line.saturating_sub(1) as u32,
                character: expr.span.col_end.saturating_sub(1) as u32,
            },
        },
    }
}

fn stmt_location(stmt: &Stmt, uri: &Url) -> Location {
    let span = stmt.span();
    Location {
        uri: uri.clone(),
        range: Range {
            start: Position {
                line: span.line.saturating_sub(1) as u32,
                character: span.col_start.saturating_sub(1) as u32,
            },
            end: Position {
                line: span.line.saturating_sub(1) as u32,
                character: span.col_end.saturating_sub(1) as u32,
            },
        },
    }
}

fn pattern_location(pattern: &Pattern, uri: &Url) -> Location {
    let span = pattern.span();
    Location {
        uri: uri.clone(),
        range: Range {
            start: Position {
                line: span.line.saturating_sub(1) as u32,
                character: span.col_start.saturating_sub(1) as u32,
            },
            end: Position {
                line: span.line.saturating_sub(1) as u32,
                character: span.col_end.saturating_sub(1) as u32,
            },
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