//! Completion provider.

use std::collections::HashSet;

use resid_parser::{Declaration, Expr, ExprKind, FuncDef, Id, Pattern, PatternKind, Stmt, StmtKind};
use resid_type::{FunctionSig, SemType, Signatures, Types};
use tower_lsp::lsp_types::*;

use crate::analysis::AnalyzedFile;

pub fn provide_completions(analyzed: &Option<AnalyzedFile>, position: Position) -> Vec<CompletionItem> {
    let mut items = Vec::new();

    let Some(analyzed) = analyzed else {
        return keywords_completions();
    };

    // Keywords
    items.extend(keywords_completions());

    // Built-in types
    items.extend(builtin_type_completions());

    // Built-in functions
    items.extend(builtin_function_completions());

    // User-defined functions from signatures
    for (name, sig) in &analyzed.signatures {
        items.push(CompletionItem {
            label: name.clone(),
            kind: Some(CompletionItemKind::FUNCTION),
            detail: Some(format_fn_sig(sig)),
            documentation: Some(Documentation::MarkupContent(MarkupContent {
                kind: MarkupKind::Markdown,
                value: format!("```resid\n{}\n```", format_fn_sig(sig)),
            })),
            insert_text: Some(name.clone()),
            insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
            ..Default::default()
        });
    }

    // User-defined types
    for (name, ty) in &analyzed.types {
        items.push(CompletionItem {
            label: name.clone(),
            kind: Some(CompletionItemKind::CLASS),
            detail: Some(format_type(ty)),
            documentation: Some(Documentation::MarkupContent(MarkupContent {
                kind: MarkupKind::Markdown,
                value: format!("```resid\ntype {} = {}\n```", name, format_type(ty)),
            })),
            insert_text: Some(name.clone()),
            insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
            ..Default::default()
        });
    }

    // Local variables in scope
    if let Some(decl) = analyzed.find_declaration_at(position.line, position.character) {
        items.extend(local_variable_completions(decl, position));
    }

    // If we're in an expression context, suggest fields/methods
    if let Some(expr) = analyzed.find_expr_at(position.line, position.character) {
        items.extend(field_completions(&analyzed.types, expr));
    }

    items
}

fn keywords_completions() -> Vec<CompletionItem> {
    let keywords = [
        "if", "else", "while", "for", "in", "match", "return", "break", "continue",
        "with", "spawn", "sandbox", "import", "pub", "type", "as", "rt",
        "let", "mut", "const", "struct", "enum", "fn", "extern",
        "assert", "rt_assert", "known", "rt_known", "comptime_print", "todo", "unimplemented",
        "true", "false", "null",
    ];

    keywords.iter().map(|kw| CompletionItem {
        label: kw.to_string(),
        kind: Some(CompletionItemKind::KEYWORD),
        insert_text: Some(kw.to_string()),
        insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
        ..Default::default()
    }).collect()
}

fn builtin_type_completions() -> Vec<CompletionItem> {
    let types = [
        ("Bool", "Boolean type"),
        ("Int", "Signed integer (Int(8)..Int(512))"),
        ("UInt", "Unsigned integer (UInt(8)..UInt(512))"),
        ("Float", "Floating point (Float(16)..Float(128))"),
        ("Dec", "Decimal (Dec(p))"),
        ("ISize", "Pointer-sized signed integer"),
        ("USize", "Pointer-sized unsigned integer"),
        ("Str", "UTF-8 string"),
        ("Bytes", "Byte string"),
        ("Option", "Optional value"),
        ("Result", "Result type"),
        ("List", "Immutable list"),
        ("Map", "Immutable map"),
        ("Set", "Immutable set"),
        ("Range", "Range type"),
        ("Slice", "Slice view"),
        ("SourceLoc", "Source location"),
        ("File", "File handle"),
    ];

    types.iter().map(|(name, doc)| CompletionItem {
        label: name.to_string(),
        kind: Some(CompletionItemKind::CLASS),
        detail: Some(doc.to_string()),
        documentation: Some(Documentation::String(doc.to_string())),
        insert_text: Some(name.to_string()),
        insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
        ..Default::default()
    }).collect()
}

fn builtin_function_completions() -> Vec<CompletionItem> {
    let functions = [
        ("wrapping_add", "Wrapping addition"),
        ("wrapping_sub", "Wrapping subtraction"),
        ("wrapping_mul", "Wrapping multiplication"),
        ("wrapping_div", "Wrapping division"),
        ("wrapping_rem", "Wrapping remainder"),
        ("saturating_add", "Saturating addition"),
        ("saturating_sub", "Saturating subtraction"),
        ("saturating_mul", "Saturating multiplication"),
        ("saturating_div", "Saturating division"),
        ("str_len", "String length"),
        ("str_concat", "String concatenation"),
        ("str_substr", "String substring"),
        ("list_len", "List length"),
        ("list_get", "List get"),
        ("map_get", "Map get"),
        ("map_insert", "Map insert"),
        ("map_remove", "Map remove"),
        ("map_contains", "Map contains"),
        ("set_union", "Set union"),
        ("set_intersection", "Set intersection"),
        ("set_difference", "Set difference"),
    ];

    functions.iter().map(|(name, doc)| CompletionItem {
        label: name.to_string(),
        kind: Some(CompletionItemKind::FUNCTION),
        detail: Some(doc.to_string()),
        documentation: Some(Documentation::String(doc.to_string())),
        insert_text: Some(name.to_string()),
        insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
        ..Default::default()
    }).collect()
}

pub fn format_parser_type(ty: &resid_parser::Type) -> String {
    match ty {
        resid_parser::Type::Base { name, params } => {
            if let Some(params) = params {
                format!("{}({})", name.0, params.iter().map(format_parser_type).collect::<Vec<_>>().join(", "))
            } else {
                name.0.clone()
            }
        }
        resid_parser::Type::Refined { base, constraint } => {
            format!("{} [{}]", format_parser_type(base), expr_to_string(constraint))
        }
        resid_parser::Type::Residual(ty) => format!("@residual {}", format_parser_type(ty)),
        resid_parser::Type::ISize => "ISize".to_string(),
        resid_parser::Type::USize => "USize".to_string(),
        resid_parser::Type::Literal(l) => format!("{}", l),
    }
}

fn format_fn_sig(sig: &FunctionSig) -> String {
    let params: Vec<String> = sig.param_names.iter()
        .zip(sig.params.iter())
        .map(|(name, ty)| format!("{}: {}", name, ty))
        .collect();
    format!("fn {}({}) -> {}", sig.name, params.join(", "), sig.ret)
}

fn format_type(ty: &SemType) -> String {
    ty.to_string()
}

fn local_variable_completions(decl: &Declaration, position: Position) -> Vec<CompletionItem> {
    let mut items = Vec::new();
    let mut seen = HashSet::new();

    fn collect_from_pattern(pattern: &Pattern, items: &mut Vec<CompletionItem>, seen: &mut HashSet<String>) {
        match &pattern.kind {
            PatternKind::Bind(id) => {
                if seen.insert(id.0.clone()) {
                    items.push(CompletionItem {
                        label: id.0.clone(),
                        kind: Some(CompletionItemKind::VARIABLE),
                        detail: Some("local variable".to_string()),
                        insert_text: Some(id.0.clone()),
                        insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
                        ..Default::default()
                    });
                }
            }
            PatternKind::Struct { fields, .. } => {
                for (_, p) in fields {
                    collect_from_pattern(p, items, seen);
                }
            }
            PatternKind::Variant { param, .. } => {
                if let Some(p) = param {
                    if seen.insert(p.0.clone()) {
                        items.push(CompletionItem {
                            label: p.0.clone(),
                            kind: Some(CompletionItemKind::VARIABLE),
                            detail: Some("pattern binding".to_string()),
                            insert_text: Some(p.0.clone()),
                            insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
                            ..Default::default()
                        });
                    }
                }
            }
            _ => {}
        }
    }

    match decl {
        Declaration::Function(f) => {
            for param in &f.params {
                if seen.insert(param.name.0.clone()) {
                    items.push(CompletionItem {
                        label: param.name.0.clone(),
                        kind: Some(CompletionItemKind::VARIABLE),
                        detail: Some(format!("parameter: {}", format_parser_type(&param.type_))),
                        insert_text: Some(param.name.0.clone()),
                        insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
                        ..Default::default()
                    });
                }
            }
            for stmt in &f.body.statements {
                collect_from_stmt(stmt, &mut items, &mut seen);
            }
        }
        Declaration::Sandbox(s) => {
            for d in &s.body {
                if let Declaration::Function(f) = d {
                    for stmt in &f.body.statements {
                        collect_from_stmt(stmt, &mut items, &mut seen);
                    }
                }
            }
        }
        _ => {}
    }

    items
}

fn collect_from_stmt(stmt: &Stmt, items: &mut Vec<CompletionItem>, seen: &mut HashSet<String>) {
    match &stmt.kind {
        StmtKind::Bind { name, type_, .. } => {
            if seen.insert(name.0.clone()) {
                items.push(CompletionItem {
                    label: name.0.clone(),
                    kind: Some(CompletionItemKind::VARIABLE),
                    detail: type_.as_ref().map(|t| format!(": {}", format_parser_type(t))),
                    insert_text: Some(name.0.clone()),
                    insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
                    ..Default::default()
                });
            }
        }
        StmtKind::Destructure { pattern, .. } => {
            collect_from_pattern(pattern, items, seen);
        }
        StmtKind::Expr(e) => collect_from_expr(e, items, seen),
        _ => {}
    }
}

fn collect_from_expr(expr: &Expr, items: &mut Vec<CompletionItem>, seen: &mut HashSet<String>) {
    match &expr.kind {
        ExprKind::Id(id) => {
            if seen.insert(id.0.clone()) {
                items.push(CompletionItem {
                    label: id.0.clone(),
                    kind: Some(CompletionItemKind::VARIABLE),
                    detail: Some("variable".to_string()),
                    insert_text: Some(id.0.clone()),
                    insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
                    ..Default::default()
                });
            }
        }
        ExprKind::Call { func, args } => {
            collect_from_expr(func, items, seen);
            for (_, arg) in args {
                collect_from_expr(arg, items, seen);
            }
        }
        ExprKind::BinaryOp { lhs, rhs, .. } => {
            collect_from_expr(lhs, items, seen);
            collect_from_expr(rhs, items, seen);
        }
        ExprKind::UnaryOp { operand, .. } => collect_from_expr(operand, items, seen),
        ExprKind::Cast { operand, .. } => collect_from_expr(operand, items, seen),
        ExprKind::Index { target, index } => {
            collect_from_expr(target, items, seen);
            collect_from_expr(index, items, seen);
        }
        ExprKind::FieldAccess { target, .. } => collect_from_expr(target, items, seen),
        ExprKind::MethodCall { target, args, .. } => {
            collect_from_expr(target, items, seen);
            for arg in args {
                collect_from_expr(arg, items, seen);
            }
        }
        ExprKind::If { cond, then_block, else_block, .. } => {
            collect_from_expr(cond, items, seen);
            for s in &then_block.statements {
                collect_from_stmt(s, items, seen);
            }
            if let Some(eb) = else_block {
                for s in &eb.statements {
                    collect_from_stmt(s, items, seen);
                }
            }
        }
        ExprKind::Match { scrutinee, arms } => {
            collect_from_expr(scrutinee, items, seen);
            for (pat, body) in arms {
                collect_from_pattern(pat, items, seen);
                collect_from_expr(body, items, seen);
            }
        }
        ExprKind::For { init, cond, step, body, .. } => {
            if let Some(i) = init {
                collect_from_stmt(i, items, seen);
            }
            collect_from_expr(cond, items, seen);
            if let Some(st) = step {
                collect_from_stmt(st, items, seen);
            }
            for s in &body.statements {
                collect_from_stmt(s, items, seen);
            }
        }
        ExprKind::ForIn { collection, body, .. } => {
            collect_from_expr(collection, items, seen);
            for s in &body.statements {
                collect_from_stmt(s, items, seen);
            }
        }
        ExprKind::While { cond, body } => {
            collect_from_expr(cond, items, seen);
            for s in &body.statements {
                collect_from_stmt(s, items, seen);
            }
        }
        ExprKind::Spawn { body, .. } => {
            for s in &body.statements {
                collect_from_stmt(s, items, seen);
            }
        }
        ExprKind::StructLit { fields, .. } => {
            for (_, e) in fields {
                collect_from_expr(e, items, seen);
            }
        }
        ExprKind::ListLit(elements) => {
            for e in elements {
                collect_from_expr(e, items, seen);
            }
        }
        ExprKind::MapLit(entries) => {
            for (k, v) in entries {
                collect_from_expr(k, items, seen);
                collect_from_expr(v, items, seen);
            }
        }
        ExprKind::SetLit(elements) => {
            for e in elements {
                collect_from_expr(e, items, seen);
            }
        }
        ExprKind::Range { start, end, .. } => {
            collect_from_expr(start, items, seen);
            collect_from_expr(end, items, seen);
        }
        ExprKind::FString(parts) => {
            for part in parts {
                if let resid_parser::FStringPart::Expr(e) = part {
                    collect_from_expr(e, items, seen);
                }
            }
        }
        ExprKind::With { bindings, body } => {
            for b in bindings {
                collect_from_expr(&b.init, items, seen);
            }
            for s in &body.statements {
                collect_from_stmt(s, items, seen);
            }
        }
        ExprKind::IfLet { pattern, source, then_block, else_block, .. } => {
            collect_from_pattern(pattern, items, seen);
            collect_from_expr(source, items, seen);
            for s in &then_block.statements {
                collect_from_stmt(s, items, seen);
            }
            if let Some(eb) = else_block {
                for s in &eb.statements {
                    collect_from_stmt(s, items, seen);
                }
            }
        }
        ExprKind::WhileLet { pattern, source, body } => {
            collect_from_pattern(pattern, items, seen);
            collect_from_expr(source, items, seen);
            for s in &body.statements {
                collect_from_stmt(s, items, seen);
            }
        }
        ExprKind::Destructure { pattern, source } => {
            collect_from_pattern(pattern, items, seen);
            collect_from_expr(source, items, seen);
        }
        ExprKind::Using { value, .. } => collect_from_expr(value, items, seen),
        ExprKind::ProviderCall { args, .. } => {
            for arg in args {
                collect_from_expr(arg, items, seen);
            }
        }
        ExprKind::EarlyReturn(e) => collect_from_expr(e, items, seen),
        ExprKind::ElseFallback { value, fallback } => {
            collect_from_expr(value, items, seen);
            for s in &fallback.statements {
                collect_from_stmt(s, items, seen);
            }
        }
        ExprKind::Slice { target, range } => {
            collect_from_expr(target, items, seen);
            if let Some(start) = &range.start {
                collect_from_expr(start, items, seen);
            }
            if let Some(end) = &range.end {
                collect_from_expr(end, items, seen);
            }
        }
        ExprKind::Rt(e) | ExprKind::Known(e) | ExprKind::RtKnown(e) | ExprKind::ComptimePrint(e) | ExprKind::Discard(e) => collect_from_expr(e, items, seen),
        _ => {}
    }
}

fn collect_from_pattern(pattern: &Pattern, items: &mut Vec<CompletionItem>, seen: &mut HashSet<String>) {
    match &pattern.kind {
        PatternKind::Bind(id) => {
            if seen.insert(id.0.clone()) {
                items.push(CompletionItem {
                    label: id.0.clone(),
                    kind: Some(CompletionItemKind::VARIABLE),
                    detail: Some("pattern binding".to_string()),
                    insert_text: Some(id.0.clone()),
                    insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
                    ..Default::default()
                });
            }
        }
        PatternKind::Struct { fields, .. } => {
            for (_, p) in fields {
                collect_from_pattern(p, items, seen);
            }
        }
        PatternKind::Variant { param, .. } => {
            if let Some(p) = param {
                if seen.insert(p.0.clone()) {
                    items.push(CompletionItem {
                        label: p.0.clone(),
                        kind: Some(CompletionItemKind::VARIABLE),
                        detail: Some("pattern binding".to_string()),
                        insert_text: Some(p.0.clone()),
                        insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
                        ..Default::default()
                    });
                }
            }
        }
        _ => {}
    }
}

fn field_completions(types: &Types, expr: &Expr) -> Vec<CompletionItem> {
    let mut items = Vec::new();

    // Try to infer the type of the expression
    // For now, just check if it's a variable and look up its type
    if let ExprKind::Id(id) = &expr.kind {
        if let Some(ty) = types.get(&id.0) {
            items.extend(struct_field_completions(ty));
        }
    }

    items
}

fn struct_field_completions(ty: &SemType) -> Vec<CompletionItem> {
    let mut items = Vec::new();

    match ty {
        SemType::Struct { fields, .. } => {
            for (name, field_ty) in fields {
                items.push(CompletionItem {
                    label: name.clone(),
                    kind: Some(CompletionItemKind::FIELD),
                    detail: Some(format!("field: {}", field_ty)),
                    insert_text: Some(name.clone()),
                    insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
                    ..Default::default()
                });
            }
        }
        SemType::Sum { variants, .. } => {
            for (name, payload) in variants {
                let kind = if payload.is_some() {
                    CompletionItemKind::ENUM_MEMBER
                } else {
                    CompletionItemKind::CONSTANT
                };
                items.push(CompletionItem {
                    label: name.clone(),
                    kind: Some(kind),
                    detail: payload.as_ref().map(|p| format!("payload: {}", p)),
                    insert_text: Some(name.clone()),
                    insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
                    ..Default::default()
                });
            }
        }
        SemType::List(elem) => {
            items.push(CompletionItem {
                label: "len".to_string(),
                kind: Some(CompletionItemKind::METHOD),
                detail: Some(format!("fn() -> USize")),
                insert_text: Some("len()".to_string()),
                insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
                ..Default::default()
            });
            items.push(CompletionItem {
                label: "get".to_string(),
                kind: Some(CompletionItemKind::METHOD),
                detail: Some(format!("fn(USize) -> Option<{}>", elem)),
                insert_text: Some("get(".to_string()),
                insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
                ..Default::default()
            });
        }
        SemType::Map(k, v) => {
            items.push(CompletionItem {
                label: "get".to_string(),
                kind: Some(CompletionItemKind::METHOD),
                detail: Some(format!("fn({}) -> Option<{}>", k, v)),
                insert_text: Some("get(".to_string()),
                insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
                ..Default::default()
            });
            items.push(CompletionItem {
                label: "insert".to_string(),
                kind: Some(CompletionItemKind::METHOD),
                detail: Some(format!("fn({}, {}) -> Map<{}, {}>", k, v, k, v)),
                insert_text: Some("insert(".to_string()),
                insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
                ..Default::default()
            });
        }
        SemType::Set(elem) => {
            items.push(CompletionItem {
                label: "contains".to_string(),
                kind: Some(CompletionItemKind::METHOD),
                detail: Some(format!("fn({}) -> Bool", elem)),
                insert_text: Some("contains(".to_string()),
                insert_text_format: Some(InsertTextFormat::PLAIN_TEXT),
                ..Default::default()
            });
        }
        _ => {}
    }

    items
}

pub fn expr_to_string(expr: &Expr) -> String {
    match &expr.kind {
        ExprKind::Id(id) => id.0.clone(),
        ExprKind::Literal(l) => format!("{}", l),
        ExprKind::Location => "#location".to_string(),
        ExprKind::BinaryOp { op, lhs, rhs } => format!("{} {:?} {}", expr_to_string(lhs), op, expr_to_string(rhs)),
        ExprKind::UnaryOp { op, operand } => format!("{:?}{}", op, expr_to_string(operand)),
        ExprKind::Cast { type_, operand } => format!("({:?}) {}", type_, expr_to_string(operand)),
        ExprKind::Call { func, args } => {
            let args_str: Vec<String> = args.iter().map(|(name, arg)| {
                if let Some(n) = name {
                    format!("{}: {}", n.0, expr_to_string(arg))
                } else {
                    expr_to_string(arg)
                }
            }).collect::<Vec<_>>();
            format!("{}({})", expr_to_string(func), args_str.join(", "))
        }
        ExprKind::Rt(e) => format!("rt {}", expr_to_string(e)),
        ExprKind::AtResidual { type_, inner } => format!("@residual {:?} {}", type_, expr_to_string(inner)),
        ExprKind::If { cond, then_block, else_block } => {
            let else_str = else_block.as_ref().map(|b| format!(" else {}", block_to_string(b))).unwrap_or_default();
            format!("if {} {}{}", expr_to_string(cond), block_to_string(then_block), else_str)
        }
        ExprKind::While { cond, body } => format!("while {} {}", expr_to_string(cond), block_to_string(body)),
        ExprKind::ForIn { type_, name, collection, body } => format!("for {}: {:?} in {} {}", name.0, type_, expr_to_string(collection), block_to_string(body)),
        ExprKind::Match { scrutinee, arms: _ } => format!("match {} {{ ... }}", expr_to_string(scrutinee)),
        ExprKind::For { init, cond, step, body } => format!("for {} {} {} {}", 
            init.as_ref().map(|s| stmt_to_string(s)).unwrap_or_default(),
            expr_to_string(cond),
            step.as_ref().map(|s| stmt_to_string(s)).unwrap_or_default(),
            block_to_string(body)),
        ExprKind::Spawn { capabilities, body } => format!("spawn {:?} {}", capabilities, block_to_string(body)),
        ExprKind::Assert { cond, message } => format!("assert {} {}", expr_to_string(cond), expr_to_string(message)),
        ExprKind::RtAssert { cond, message } => format!("rt_assert {} {}", expr_to_string(cond), expr_to_string(message)),
        ExprKind::Known(e) => format!("known {}", expr_to_string(e)),
        ExprKind::RtKnown(e) => format!("rt_known {}", expr_to_string(e)),
        ExprKind::ComptimePrint(e) => format!("comptime_print {}", expr_to_string(e)),
        ExprKind::Todo(s) => format!("todo(\"{}\")", s),
        ExprKind::Unimplemented(s) => format!("unimplemented(\"{}\")", s),
        ExprKind::StructLit { name, fields: _ } => format!("{} {{ ... }}", name.0),
        ExprKind::ListLit(elements) => {
            let elems: Vec<String> = elements.iter().map(|e| expr_to_string(e)).collect();
            format!("[{}]", elems.join(", "))
        }
        ExprKind::MapLit(entries) => {
            let pairs: Vec<String> = entries.iter().map(|(k, v)| format!("{}: {}", expr_to_string(k), expr_to_string(v))).collect();
            format!("{{{}}}", pairs.join(", "))
        }
        ExprKind::SetLit(elements) => {
            let elems: Vec<String> = elements.iter().map(|e| expr_to_string(e)).collect();
            format!("{{{}}}", elems.join(", "))
        }
        ExprKind::Range { start, end, closed } => format!("{}{}{}", expr_to_string(start), if *closed { "..=" } else { ".." }, expr_to_string(end)),
        ExprKind::FString(parts) => {
            let parts_str: Vec<String> = parts.iter().map(|p| match p { 
                resid_parser::FStringPart::Text(t) => t.clone(), 
                resid_parser::FStringPart::Expr(e) => format!("{{{}}}", expr_to_string(e)) 
            }).collect();
            format!("\"{}\"", parts_str.join(""))
        }
        ExprKind::RawString(s) => format!("r\"{}\"", s),
        ExprKind::ByteString(bytes) => format!("b\"{:?}\"", bytes),
        ExprKind::FieldAccess { target, field } => format!("{}.{}", expr_to_string(target), field.0),
        ExprKind::Index { target, index } => format!("{}[{}]", expr_to_string(target), expr_to_string(index)),
        ExprKind::Slice { target, range } => format!("{}[{}]", expr_to_string(target), range_to_string(range)),
        ExprKind::MethodCall { target, method, args } => {
            let args_str: Vec<String> = args.iter().map(|e| expr_to_string(e)).collect();
            format!("{}.{}({})", expr_to_string(target), method.0, args_str.join(", "))
        }
        ExprKind::EarlyReturn(e) => format!("return? {}", expr_to_string(e)),
        ExprKind::ElseFallback { value, fallback } => format!("{} else {}", expr_to_string(value), block_to_string(fallback)),
        ExprKind::Destructure { pattern, source } => format!("let {} = {}", pattern_to_string(pattern), expr_to_string(source)),
        ExprKind::IfLet { pattern, source, then_block, else_block } => format!("if let {} = {} {}{}", pattern_to_string(pattern), expr_to_string(source), block_to_string(then_block), else_block.as_ref().map(|b| format!(" else {}", block_to_string(b))).unwrap_or_default()),
        ExprKind::WhileLet { pattern, source, body } => format!("while let {} = {} {}", pattern_to_string(pattern), expr_to_string(source), block_to_string(body)),
        ExprKind::With { bindings, body } => {
            let binds: Vec<String> = bindings.iter().map(|b| format!("{} = {}", b.name.0, expr_to_string(&b.init))).collect();
            format!("with {} {}", binds.join(", "), block_to_string(body))
        }
        ExprKind::Using { value, behavior } => format!("using {} as {}", expr_to_string(value), behavior.0),
        ExprKind::ProviderCall { provider, verb, args } => {
            let args_str: Vec<String> = args.iter().map(|e| expr_to_string(e)).collect();
            format!("{}.{}({})", provider.0, verb.0, args_str.join(", "))
        }
        ExprKind::Discard(e) => format!("_ = {}", expr_to_string(e)),
    }
}

fn block_to_string(block: &resid_parser::Block) -> String {
    format!("{{ {} }}", block.statements.iter().map(stmt_to_string).collect::<Vec<_>>().join("; "))
}

fn stmt_to_string(stmt: &resid_parser::Stmt) -> String {
    match &stmt.kind {
        resid_parser::StmtKind::Bind { type_, name, value } => format!("let {}: {} = {}", name.0, type_.as_ref().map(|t| format!("{:?}", t)).unwrap_or_default(), expr_to_string(value)),
        resid_parser::StmtKind::Destructure { pattern, source } => format!("let {} = {}", pattern_to_string(pattern), expr_to_string(source)),
        resid_parser::StmtKind::Expr(e) => expr_to_string(e),
        resid_parser::StmtKind::Return(e) => format!("return{}", e.as_ref().map(|e| format!(" {}", expr_to_string(e))).unwrap_or_default()),
        resid_parser::StmtKind::Break => "break".to_string(),
        resid_parser::StmtKind::Continue => "continue".to_string(),
        _ => "<stmt>".to_string(),
    }
}

fn pattern_to_string(pattern: &resid_parser::Pattern) -> String {
    match &pattern.kind {
        resid_parser::PatternKind::Wildcard => "_".to_string(),
        resid_parser::PatternKind::Bind(id) => id.0.clone(),
        resid_parser::PatternKind::Variant { name, param } => {
            if let Some(p) = param {
                format!("{}({})", name.0, p.0)
            } else {
                name.0.clone()
            }
        }
        resid_parser::PatternKind::Literal(l) => format!("{}", l),
        resid_parser::PatternKind::Struct { name, fields } => format!("{} {{ ... }}", name.0),
        _ => "<pat>".to_string(),
    }
}

fn capabilities_to_string(caps: &[resid_parser::CapabilityAnnotation]) -> String {
    caps.iter().map(|c| format!("{}", c.name.0)).collect::<Vec<_>>().join(" ")
}

fn range_to_string(range: &resid_parser::RangeExpr) -> String {
    format!("{}{}{}", 
        range.start.as_ref().map(|e| expr_to_string(e)).unwrap_or_default(),
        if range.closed { "..=" } else { ".." },
        range.end.as_ref().map(|e| expr_to_string(e)).unwrap_or_default())
}
