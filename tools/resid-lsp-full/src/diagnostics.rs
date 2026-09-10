//! Diagnostics publishing.

use std::path::Path;

use resid_notes::ResidualNote;
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

    for note in residual_notes(analyzed) {
        diagnostics.push(Diagnostic {
            range: Range {
                start: Position {
                    line: note.line.saturating_sub(1) as u32,
                    character: note.column as u32,
                },
                end: Position {
                    line: note.line.saturating_sub(1) as u32,
                    character: note.column as u32,
                },
            },
            severity: Some(DiagnosticSeverity::HINT),
            code: Some(NumberOrString::String(note.kind)),
            code_description: None,
            source: Some("resid-lsp".to_string()),
            message: format!("residual `{}`", note.symbol),
            related_information: None,
            tags: None,
            data: None,
        });
    }

    // Group by URI and publish
    let uri = &analyzed.uri;
    client.publish_diagnostics(uri.clone(), diagnostics, None).await;
}

fn residual_notes(analyzed: &AnalyzedFile) -> Vec<ResidualNote> {
    let Some(path) = analyzed.uri.to_file_path().ok() else {
        return Vec::new();
    };
    let Some(directory) = path.parent() else {
        return Vec::new();
    };
    let line_count = analyzed.text.lines().count().max(1) as u64;

    let mut notes = Vec::new();
    let Ok(entries) = std::fs::read_dir(directory) else {
        return notes;
    };
    for entry in entries.flatten() {
        let sidecar = entry.path();
        if !sidecar
            .file_name()
            .is_some_and(|name| name.to_string_lossy().ends_with(".resid-notes.cbor"))
        {
            continue;
        }
        let Ok(bytes) = std::fs::read(&sidecar) else {
            continue;
        };
        let Some(mut sidecar_notes) = resid_notes::from_cbor(&bytes) else {
            continue;
        };
        sidecar_notes.retain(|note| {
            note.line > 0 && note.line <= line_count && note_belongs_to(note, &path)
        });
        notes.extend(sidecar_notes);
    }
    notes
}

fn note_belongs_to(note: &ResidualNote, document: &Path) -> bool {
    if note.file.is_empty() {
        return true;
    }
    let note_path = Path::new(&note.file);
    note_path == document
        || note_path
            .file_name()
            .is_some_and(|name| Some(name) == document.file_name())
}
