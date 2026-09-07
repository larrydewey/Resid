//! Diagnostics publishing.

use std::collections::HashMap;

use resid_parser::ParseError;
use resid_type::TypeError;
use tower_lsp::lsp_types::*;
use tower_lsp::Client;

use crate::analysis::AnalyzedFile;

pub async fn publish_diagnostics(client: &Client, analyzed: &AnalyzedFile) {
    let mut diagnostics = Vec::new();

    // Parse errors
    for err in &analyzed.parse_errors {
        diagnostics.push(Diagnostic {
            range: Range {
                start: Position {
                    line: err.span.line.saturating_sub(1) as u32,
                    character: err.span.col_start.saturating_sub(1) as u32,
                },
                end: Position {
                    line: err.span.line.saturating_sub(1) as u32,
                    character: err.span.col_end.saturating_sub(1) as u32,
                },
            },
            severity: Some(DiagnosticSeverity::ERROR),
            code: None,
            code_description: None,
            source: Some("resid-parser".to_string()),
            message: err.message.clone(),
            related_information: None,
            tags: None,
            data: None,
        });
    }

    // Type errors
    for err in &analyzed.type_errors {
        let span = &err.span;
        let (start_line, start_col, end_line, end_col) = (
            span.line.saturating_sub(1) as u32,
            span.col_start.saturating_sub(1) as u32,
            span.line.saturating_sub(1) as u32,
            span.col_end.saturating_sub(1) as u32,
        );

        diagnostics.push(Diagnostic {
            range: Range {
                start: Position { line: start_line, character: start_col },
                end: Position { line: end_line, character: end_col },
            },
            severity: Some(DiagnosticSeverity::ERROR),
            code: None,
            code_description: None,
            source: Some("resid-type".to_string()),
            message: err.message.clone(),
            related_information: None,
            tags: None,
            data: None,
        });
    }

    // Group by URI and publish
    let uri = &analyzed.uri;
    client.publish_diagnostics(uri.clone(), diagnostics, None).await;
}