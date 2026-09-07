//! Hover provider.

use resid_parser::{Declaration, Expr, ExprKind, FuncDef, TypeDef};
use resid_type::SemType;
use tower_lsp::lsp_types::*;

use crate::analysis::AnalyzedFile;
use crate::completions::format_parser_type;

pub async fn provide_hover(analyzed: &Option<AnalyzedFile>, position: Position) -> Option<Hover> {
    let analyzed = analyzed.as_ref()?;

    // Try to find an expression at the position
    if let Some(expr) = analyzed.find_expr_at(position.line, position.character) {
        return hover_for_expr(analyzed, expr).await;
    }

    // Try to find a declaration at the position
    if let Some(decl) = analyzed.find_declaration_at(position.line, position.character) {
        return hover_for_decl(analyzed, decl).await;
    }

    None
}

async fn hover_for_expr(analyzed: &AnalyzedFile, expr: &Expr) -> Option<Hover> {
    let mut contents = Vec::new();

    // Try to infer the type
    // For now, just show the expression kind
    contents.push(format!("**Expression:** `{}`", expr_kind_name(&expr.kind)));

    // If it's a variable, show its type from signatures
    if let ExprKind::Id(id) = &expr.kind {
        let name = &id.0;
        if let Some(sig) = analyzed.get_signature(name) {
            contents.push(format!("\n**Function:** `{}`", format_fn_sig(sig)));
        }
        if let Some(ty) = analyzed.get_type(name) {
            contents.push(format!("\n**Type:** `{}`", ty));
        }
    }

    // If it's a field access, show field type
    if let ExprKind::FieldAccess { target, field } = &expr.kind {
        if let ExprKind::Id(obj_id) = &target.kind {
            let obj_name = &obj_id.0;
            if let Some(ty) = analyzed.get_type(obj_name) {
                if let Some(field_ty) = struct_field_type(ty, &field.0) {
                    contents.push(format!("\n**Field Type:** `{}`", field_ty));
                }
            }
        }
    }

    Some(Hover {
        contents: HoverContents::Markup(MarkupContent {
            kind: MarkupKind::Markdown,
            value: contents.join("\n\n"),
        }),
        range: Some(expr_range(expr)),
    })
}

async fn hover_for_decl(analyzed: &AnalyzedFile, decl: &Declaration) -> Option<Hover> {
    let mut contents = Vec::new();

    match decl {
        Declaration::Function(f) => {
            contents.push(format!("**Function:** `{}`", f.name.0));
            contents.push(format!("\n```resid\nfn {}({} ) -> ...\n```", f.name.0, f.params.iter()
                .map(|p| format!("{}: {}", p.name.0, format_parser_type(&p.type_)))
                .collect::<Vec<_>>().join(", ")));
        }
        Declaration::Type(t) => {
            contents.push(format!("**Type:** `{}`", t.name.0));
            contents.push(format!("\n```resid\ntype {} = ...\n```", t.name.0));
        }
        Declaration::Behavior(b) => {
            contents.push(format!("**Behavior:** `{}`", b.name.0));
        }
        Declaration::Sandbox(s) => {
            contents.push("**Sandbox**".to_string());
            contents.push(format!("\nCapabilities: {}", s.capabilities.len()));
        }
    }

    Some(Hover {
        contents: HoverContents::Markup(MarkupContent {
            kind: MarkupKind::Markdown,
            value: contents.join("\n\n"),
        }),
        range: Some(decl_range(decl)),
    })
}

fn expr_kind_name(kind: &ExprKind) -> &'static str {
    match kind {
        ExprKind::Id(_) => "Identifier",
        ExprKind::Literal(_) => "Literal",
        ExprKind::Location => "Location",
        ExprKind::BinaryOp { .. } => "BinaryOp",
        ExprKind::UnaryOp { .. } => "UnaryOp",
        ExprKind::Cast { .. } => "Cast",
        ExprKind::Call { .. } => "Call",
        ExprKind::Rt(_) => "Rt",
        ExprKind::AtResidual { .. } => "AtResidual",
        ExprKind::If { .. } => "If",
        ExprKind::While { .. } => "While",
        ExprKind::ForIn { .. } => "ForIn",
        ExprKind::Match { .. } => "Match",
        ExprKind::StructLit { .. } => "StructLit",
        ExprKind::ListLit(_) => "ListLit",
        ExprKind::MapLit(_) => "MapLit",
        ExprKind::SetLit(_) => "SetLit",
        ExprKind::Range { .. } => "Range",
        ExprKind::FString(_) => "FString",
        ExprKind::RawString(_) => "RawString",
        ExprKind::ByteString(_) => "ByteString",
        ExprKind::FieldAccess { .. } => "FieldAccess",
        ExprKind::Index { .. } => "Index",
        ExprKind::Slice { .. } => "Slice",
        ExprKind::MethodCall { .. } => "MethodCall",
        ExprKind::EarlyReturn(_) => "EarlyReturn",
        ExprKind::ElseFallback { .. } => "ElseFallback",
        ExprKind::Destructure { .. } => "Destructure",
        ExprKind::IfLet { .. } => "IfLet",
        ExprKind::WhileLet { .. } => "WhileLet",
        ExprKind::With { .. } => "With",
        ExprKind::Using { .. } => "Using",
        ExprKind::ProviderCall { .. } => "ProviderCall",
        ExprKind::Discard(_) => "Discard",
        _ => "Expression",
    }
}

fn format_fn_sig(sig: &resid_type::FunctionSig) -> String {
    let params: Vec<String> = sig.param_names.iter().zip(&sig.params)
        .map(|(name, ty)| format!("{}: {}", name, ty))
        .collect();
    format!("fn {}({}) -> {}", sig.name, params.join(", "), sig.ret)
}

fn struct_field_type(ty: &SemType, field: &str) -> Option<SemType> {
    match ty {
        SemType::Struct { fields, .. } => fields.iter().find(|(n, _)| n == field).map(|(_, t)| t.clone()),
        _ => None,
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