fn main() {
    let src = std::fs::read_to_string("examples/codegen.resid").unwrap();
    let (unit, errs) = resid_parser::Parser::parse("codegen.resid", &src);
    if !errs.is_empty() {
        eprintln!("parse errors: {:?}", &errs[..errs.len().min(5)]);
        return;
    }
    let info = resid_type::analyze_ownership(&unit);
    // Walk every function, every Id/FieldAccess occurrence, count recognized sites.
    let mut count = 0usize;
    let mut by_fn: std::collections::HashMap<String, usize> = std::collections::HashMap::new();
    for decl in &unit.declarations {
        if let resid_parser::Declaration::Function(f) = decl {
            let mut c = 0usize;
            walk_block(&f.body, &info, &mut c);
            if c > 0 {
                by_fn.insert(f.name.0.clone(), c);
            }
            count += c;
        }
    }
    println!("total recognized last-unique-use sites: {count}");
    let mut v: Vec<_> = by_fn.into_iter().collect();
    v.sort_by(|a, b| b.1.cmp(&a.1));
    for (name, c) in v.iter().take(30) {
        println!("{name}: {c}");
    }
}

fn walk_block(block: &resid_parser::Block, info: &resid_type::OwnershipInfo, count: &mut usize) {
    for stmt in &block.statements {
        walk_stmt(stmt, info, count);
    }
    if let Some(ret) = &block.ret {
        walk_expr(ret, info, count);
    }
}
fn walk_stmt(stmt: &resid_parser::Stmt, info: &resid_type::OwnershipInfo, count: &mut usize) {
    use resid_parser::StmtKind::*;
    match &stmt.kind {
        Bind { value, .. } => walk_expr(value, info, count),
        Discard(e) | Expr(e) => walk_expr(e, info, count),
        Return(Some(e)) => walk_expr(e, info, count),
        Return(None) | Break | Continue => {}
        Destructure { source, .. } => walk_expr(source, info, count),
    }
}
fn walk_expr(e: &resid_parser::Expr, info: &resid_type::OwnershipInfo, count: &mut usize) {
    if info.is_last_unique_use(e) {
        *count += 1;
    }
    each_child(e, info, count);
}
fn each_child(e: &resid_parser::Expr, info: &resid_type::OwnershipInfo, count: &mut usize) {
    use resid_parser::ExprKind::*;
    match &e.kind {
        Id(_) | Literal(_) | Location | RawString(_) | ByteString(_) | Todo(_) | Unimplemented(_) => {}
        BinaryOp { lhs, rhs, .. } => { walk_expr(lhs, info, count); walk_expr(rhs, info, count); }
        UnaryOp { operand, .. } | Cast { operand, .. } => walk_expr(operand, info, count),
        Call { func, args } => { walk_expr(func, info, count); for (_, a) in args { walk_expr(a, info, count); } }
        Rt(inner) | AtResidual { inner, .. } => walk_expr(inner, info, count),
        If { cond, then_block, else_block } => {
            walk_expr(cond, info, count);
            walk_block(then_block, info, count);
            if let Some(eb) = else_block { walk_block(eb, info, count); }
        }
        While { cond, body } => { walk_expr(cond, info, count); walk_block(body, info, count); }
        ForIn { collection, body, .. } => { walk_expr(collection, info, count); walk_block(body, info, count); }
        Match { scrutinee, arms } => { walk_expr(scrutinee, info, count); for (_, e) in arms { walk_expr(e, info, count); } }
        For { init, cond, step, body } => {
            if let Some(s) = init { walk_stmt(s, info, count); }
            walk_expr(cond, info, count);
            if let Some(s) = step { walk_stmt(s, info, count); }
            walk_block(body, info, count);
        }
        Spawn { body, .. } => walk_block(body, info, count),
        Assert { cond, message } | RtAssert { cond, message } => { walk_expr(cond, info, count); walk_expr(message, info, count); }
        Known(inner) | RtKnown(inner) | ComptimePrint(inner) => walk_expr(inner, info, count),
        StructLit { fields, .. } => { for (_, v) in fields { walk_expr(v, info, count); } }
        ListLit(elems) | SetLit(elems) => { for e in elems { walk_expr(e, info, count); } }
        MapLit(entries) => { for (k, v) in entries { walk_expr(k, info, count); walk_expr(v, info, count); } }
        Range { start, end, .. } => { walk_expr(start, info, count); walk_expr(end, info, count); }
        FString(parts) => { for p in parts { if let resid_parser::FStringPart::Expr(e) = p { walk_expr(e, info, count); } } }
        FieldAccess { target, .. } => walk_expr(target, info, count),
        Index { target, index } => { walk_expr(target, info, count); walk_expr(index, info, count); }
        Slice { target, range } => { walk_expr(target, info, count); if let Some(s) = &range.start { walk_expr(s, info, count); } if let Some(en) = &range.end { walk_expr(en, info, count); } }
        MethodCall { target, args, .. } => { walk_expr(target, info, count); for a in args { walk_expr(a, info, count); } }
        EarlyReturn(inner) => walk_expr(inner, info, count),
        ElseFallback { value, fallback } => { walk_expr(value, info, count); walk_block(fallback, info, count); }
        Destructure { source, .. } => walk_expr(source, info, count),
        IfLet { source, then_block, else_block, .. } => {
            walk_expr(source, info, count);
            walk_block(then_block, info, count);
            if let Some(eb) = else_block { walk_block(eb, info, count); }
        }
        WhileLet { source, body, .. } => { walk_expr(source, info, count); walk_block(body, info, count); }
        Using { value, .. } => walk_expr(value, info, count),
        With { bindings, body } => { for b in bindings { walk_expr(&b.init, info, count); } walk_block(body, info, count); }
        ProviderCall { args, .. } => { for a in args { walk_expr(a, info, count); } }
        Discard(inner) => walk_expr(inner, info, count),
    }
}
