//! `resid-graph` — call-graph extraction for Resid programs (spec §37).
//!
//! Parses a translation unit (resolving imports) and reports, per function,
//! which functions it calls. Output formats: text tree (default) and DOT.

use std::collections::{BTreeMap, BTreeSet};
use std::path::Path;

use resid_parser::{Declaration, Expr, ExprKind, TranslationUnit};

/// caller → set of callees.
pub type CallGraph = BTreeMap<String, BTreeSet<String>>;

/// Build the call graph of a resolved unit.
pub fn call_graph(unit: &TranslationUnit) -> CallGraph {
    let mut graph = CallGraph::new();
    let mut defined: BTreeSet<String> = BTreeSet::new();
    for d in &unit.declarations {
        if let Declaration::Function(f) = d {
            defined.insert(f.name.0.clone());
        }
    }
    for d in &unit.declarations {
        if let Declaration::Function(f) = d {
            let mut callees = BTreeSet::new();
            for s in &f.body.statements {
                collect_stmt(s, &mut callees);
            }
            if let Some(tail) = &f.body.ret {
                collect_expr(tail, &mut callees);
            }
            // Only report edges to functions defined in this unit; extern
            // built-ins are not nodes. Direct recursion shows as a self-edge.
            callees.retain(|c| defined.contains(c));
            graph.insert(f.name.0.clone(), callees);
        }
    }
    graph
}

fn collect_stmt(s: &resid_parser::Stmt, out: &mut BTreeSet<String>) {
    match &s.kind {
        resid_parser::StmtKind::Bind { value, .. } => collect_expr(value, out),
        resid_parser::StmtKind::Discard(e) => collect_expr(e, out),
        resid_parser::StmtKind::Destructure { source, .. } => collect_expr(source, out),
        resid_parser::StmtKind::Expr(e) => collect_expr(e, out),
        resid_parser::StmtKind::Return(Some(e)) => collect_expr(e, out),
        _ => {}
    }
}

fn collect_expr(e: &Expr, out: &mut BTreeSet<String>) {
    match &e.kind {
        ExprKind::Call { func, args } => {
            if let ExprKind::Id(id) = &func.kind {
                out.insert(id.0.clone());
            } else {
                collect_expr(func, out);
            }
            for (_, a) in args {
                collect_expr(a, out);
            }
        }
        ExprKind::MethodCall { target, args, .. } => {
            collect_expr(target, out);
            for a in args {
                collect_expr(a, out);
            }
        }
        ExprKind::BinaryOp { lhs, rhs, .. } => {
            collect_expr(lhs, out);
            collect_expr(rhs, out);
        }
        ExprKind::UnaryOp { operand, .. } => collect_expr(operand, out),
        ExprKind::Cast { operand, .. } => collect_expr(operand, out),
        ExprKind::FieldAccess { target, .. } | ExprKind::Index { target, .. } => {
            collect_expr(target, out)
        }
        ExprKind::ListLit(elems) => {
            for e in elems {
                collect_expr(e, out);
            }
        }
        ExprKind::StructLit { fields, .. } => {
            for (_, v) in fields {
                collect_expr(v, out);
            }
        }
        ExprKind::Range { start, end, .. } => {
            collect_expr(start, out);
            collect_expr(end, out);
        }
        ExprKind::FString(parts) => {
            for p in parts {
                if let resid_parser::FStringPart::Expr(x) = p {
                    collect_expr(x, out);
                }
            }
        }
        ExprKind::If { cond, then_block, else_block } => {
            collect_expr(cond, out);
            collect_block(then_block, out);
            if let Some(eb) = else_block {
                collect_block(eb, out);
            }
        }
        ExprKind::While { cond, body } => {
            collect_expr(cond, out);
            collect_block(body, out);
        }
        ExprKind::ForIn { collection, body, .. } => {
            collect_expr(collection, out);
            collect_block(body, out);
        }
        ExprKind::Match { scrutinee, arms } => {
            collect_expr(scrutinee, out);
            for (_, e) in arms {
                collect_expr(e, out);
            }
        }
        _ => {}
    }
}

fn collect_block(b: &resid_parser::Block, out: &mut BTreeSet<String>) {
    for s in &b.statements {
        collect_stmt(s, out);
    }
    if let Some(tail) = &b.ret {
        collect_expr(tail, out);
    }
}

/// Load a file (with imports resolved) and build its call graph.
pub fn graph_of_file(path: &Path) -> Result<CallGraph, String> {
    let unit = resid_parser::resolve_unit(path).map_err(|e| e.to_string())?;
    Ok(call_graph(&unit))
}

/// Render the graph as an indented text tree.
pub fn to_text(graph: &CallGraph) -> String {
    let mut out = String::new();
    for (caller, callees) in graph {
        out.push_str(&format!("{caller}\n"));
        if callees.is_empty() {
            out.push_str("  (no calls)\n");
        }
        for c in callees {
            out.push_str(&format!("  → {c}\n"));
        }
    }
    out
}

/// Render the graph as a Graphviz DOT digraph.
pub fn to_dot(graph: &CallGraph) -> String {
    let mut out = String::from("digraph calls {\n    rankdir=LR;\n");
    for caller in graph.keys() {
        out.push_str(&format!("    \"{}\";\n", dot_id(caller)));
    }
    for (caller, callees) in graph {
        for c in callees {
            out.push_str(&format!(
                "    \"{}\" -> \"{}\";\n",
                dot_id(caller),
                dot_id(c)
            ));
        }
    }
    out.push_str("}\n");
    out
}

/// DOT identifiers with dots (aliased imports like `U.f`) need quoting —
/// we always quote, so just escape embedded quotes.
fn dot_id(name: &str) -> String {
    name.replace('"', "\\\"")
}
