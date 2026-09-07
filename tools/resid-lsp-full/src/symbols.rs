//! Document symbols provider (outline).

use resid_parser::{Declaration, Expr, ExprKind, FuncDef, TypeBody, TypeDef};
use tower_lsp::lsp_types::*;

use crate::analysis::AnalyzedFile;
use crate::completions::{format_parser_type, expr_to_string};

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

pub fn document_symbols(analyzed: &Option<AnalyzedFile>) -> Option<DocumentSymbolResponse> {
    let analyzed = analyzed.as_ref()?;
    let mut symbols = Vec::new();

    for decl in &analyzed.unit.declarations {
        if let Some(sym) = symbol_from_decl(decl) {
            symbols.push(sym);
        }
    }

    Some(DocumentSymbolResponse::Nested(symbols))
}

fn symbol_from_decl(decl: &Declaration) -> Option<DocumentSymbol> {
    match decl {
        Declaration::Function(f) => Some(DocumentSymbol {
            name: f.name.0.clone(),
            detail: Some(format_fn_detail(f)),
            kind: SymbolKind::FUNCTION,
            tags: None,
            deprecated: Some(false),
            range: decl_range(decl),
            selection_range: decl_selection_range(decl),
            children: Some(function_children(f)),
        }),
        Declaration::Type(t) => Some(DocumentSymbol {
            name: t.name.0.clone(),
            detail: Some(type_detail(t)),
            kind: SymbolKind::CLASS,
            tags: None,
            deprecated: Some(false),
            range: decl_range(decl),
            selection_range: decl_selection_range(decl),
            children: Some(type_children(t)),
        }),
        Declaration::Behavior(b) => Some(DocumentSymbol {
            name: b.name.0.clone(),
            detail: Some("behavior".to_string()),
            kind: SymbolKind::INTERFACE,
            tags: None,
            deprecated: Some(false),
            range: decl_range(decl),
            selection_range: decl_selection_range(decl),
            children: None,
        }),
        Declaration::Sandbox(s) => Some(DocumentSymbol {
            name: "sandbox".to_string(),
            detail: Some(format!("capabilities: {}", s.capabilities.len())),
            kind: SymbolKind::MODULE,
            tags: None,
            deprecated: Some(false),
            range: decl_range(decl),
            selection_range: decl_selection_range(decl),
            children: Some(
                s.body
                    .iter()
                    .filter_map(symbol_from_decl)
                    .collect(),
            ),
        }),
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

fn decl_selection_range(decl: &Declaration) -> Range {
    decl_range(decl)
}

fn format_fn_detail(f: &FuncDef) -> String {
    let params: Vec<String> = f.params.iter()
        .map(|p| format!("{}: {}", p.name.0, format_parser_type(&p.type_)))
        .collect();
    format!("fn ({}) -> {}", params.join(", "), format_parser_type(&f.ret))
}

fn function_children(f: &FuncDef) -> Vec<DocumentSymbol> {
    let mut children = Vec::new();

    // Parameters
    for param in &f.params {
        children.push(DocumentSymbol {
            name: param.name.0.clone(),
            detail: Some(format!("parameter: {}", format_parser_type(&param.type_))),
            kind: SymbolKind::VARIABLE,
            tags: None,
            deprecated: Some(false),
            range: Range::default(),
            selection_range: Range::default(),
            children: None,
        });
    }

    // Local bindings in body (only Bind statements)
    for stmt in &f.body.statements {
        if let resid_parser::StmtKind::Bind { name, type_, .. } = &stmt.kind {
            children.push(DocumentSymbol {
                name: name.0.clone(),
                detail: type_.as_ref().map(|t| format!(": {}", format_parser_type(t))),
                kind: SymbolKind::VARIABLE,
                tags: None,
                deprecated: Some(false),
                range: Range::default(),
                selection_range: Range::default(),
                children: None,
            });
        }
    }

    children
}


fn type_detail(t: &TypeDef) -> String {
    match &t.body {
        TypeBody::Product(fields) => {
            format!("struct {{ {} }}", fields.iter().map(|(n, ty)| format!("{}: {}", n.0, format_parser_type(ty))).collect::<Vec<_>>().join(", "))
        }
        TypeBody::Sum(variants) => {
            format!("enum {{ {} }}", variants.iter().map(|v| {
                if let Some(ty) = &v.type_param {
                    format!("{}({})", v.name.0, format_parser_type(ty))
                } else {
                    v.name.0.clone()
                }
            }).collect::<Vec<_>>().join(", "))
        }
        TypeBody::Base(ty) => format!("= {}", format_parser_type(ty)),
        TypeBody::Constraint { inner, constraint } => format!("{} [{}]", format_parser_type(inner), expr_to_string(constraint)),
        TypeBody::Residual(ty) => format!("@residual {}", format_parser_type(ty)),
    }
}

fn type_children(t: &TypeDef) -> Vec<DocumentSymbol> {
    let mut children = Vec::new();

    match &t.body {
        TypeBody::Product(fields) => {
            for (name, ty) in fields {
                children.push(DocumentSymbol {
                    name: name.0.clone(),
                    detail: Some(format!("field: {}", format_parser_type(ty))),
                    kind: SymbolKind::FIELD,
                    tags: None,
                    deprecated: Some(false),
                    range: Range::default(),
                    selection_range: Range::default(),
                    children: None,
                });
            }
        }
        TypeBody::Sum(variants) => {
            for v in variants {
                children.push(DocumentSymbol {
                    name: v.name.0.clone(),
                    detail: v.type_param.as_ref().map(|p| format!("payload: {}", format_parser_type(p))),
                    kind: SymbolKind::ENUM_MEMBER,
                    tags: None,
                    deprecated: Some(false),
                    range: Range::default(),
                    selection_range: Range::default(),
                    children: None,
                });
            }
        }
        _ => {}
    }

    children
}
