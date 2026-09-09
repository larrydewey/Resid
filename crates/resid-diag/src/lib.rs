//! `resid-diag` — shared diagnostic infrastructure (rustc-grade error
//! reporting).
//!
//! The Resid pitch is maximal authorized reduction of first-class knowledge;
//! the error channel is where that knowledge reaches the programmer. This
//! crate gives every pipeline phase (lexer, parser, type checker, codegen)
//! a common diagnostic surface:
//!
//! - a stable **error code** per rule (rustc-style `error[E0301]: …`);
//! - a **primary span** with a caret that underlines the offending token
//!   range and an optional inline label (`value is 5`);
//! - **secondary labels** (span pairs, borrowck-style) — two places shown
//!   together when an error spans sites (declaration vs. use);
//! - `note:` / `help:` long-form prose;
//! - a rustc-flavored **source snippet renderer** with gutters, carets and
//!   optional ANSI color.
//!
//! Rendering is line-based: spans carry `file:line:col` (no byte offsets),
//! so the renderer reads the source line by line number. When a span is
//! unknown or the file is unreadable the diagnostic degrades gracefully to
//! a plain `error[E0001]: message` header.
//!
//! Error-code catalog (assign here, use in callers):
//!
//! | Code | Rule |
//! |------|------|
//! | E0001 | type check (generic default) |
//! | E0010 | lexer |
//! | E0020 | parser / import resolution |
//! | E0301 | §12 constraint discharge failure |
//! | E0211 | §21 callee `@requires` exceeds caller's effective ceiling |
//! | E0212 | §21 call requires cap missing from sandbox ceiling |
//! | E0213 | §21 unknown capability mode keyword |
//! | E0214 | §19 spawn declares cap exceeding parent ceiling (child ≤ parent) |
//! | E0215 | §19 spawn-region callee not granted by the child's CapEnv |
//! | E0216 | §21 handle-entry / File-method provenance violation |
//! | E0217 | §21 write verb under read-only grant |
//! | E0218 | §21 provider call not granted by the region's cap set |

use resid_lexer::token::Span;

/// An unknown span (line 0 / empty file) renders header-only.
pub fn unknown_span() -> Span {
    Span {
        file: String::new(),
        line: 0,
        col_start: 0,
        col_end: 0,
    }
}

/// Diagnostic severity.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Severity {
    Error,
    Warning,
    Note,
    Help,
}

impl Severity {
    /// rustc-style label used in the header and `= label:` lines.
    pub fn label(self) -> &'static str {
        match self {
            Severity::Error => "error",
            Severity::Warning => "warning",
            Severity::Note => "note",
            Severity::Help => "help",
        }
    }
}

/// A secondary span with a message (rustc "label" / span-pair half).
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Label {
    pub span: Span,
    pub message: String,
}

/// A single diagnostic. Build with [`Diag::error`], enrich with the fluent
/// builders, then [`Diag::render`] with a source loader.
#[derive(Debug, Clone)]
pub struct Diag {
    pub code: &'static str,
    pub severity: Severity,
    pub message: String,
    /// Unknown spans (`line == 0` / `<unknown>`) render header-only.
    pub span: Span,
    /// Text printed beside the primary caret (rustc `^^^ label`).
    pub primary_label: Option<String>,
    /// Secondary spans rendered as their own snippet blocks.
    pub labels: Vec<Label>,
    pub notes: Vec<String>,
    pub help: Option<String>,
}

impl Diag {
    /// A new diagnostic with primary span.
    pub fn error(code: &'static str, message: impl Into<String>, span: Span) -> Diag {
        Diag {
            code,
            severity: Severity::Error,
            message: message.into(),
            span,
            primary_label: None,
            labels: Vec::new(),
            notes: Vec::new(),
            help: None,
        }
    }

    /// A new diagnostic without a usable span (renders header-only).
    pub fn error_unknown(code: &'static str, message: impl Into<String>) -> Diag {
        Diag::error(code, message, unknown_span())
    }

    /// Attach a caret label to the primary span.
    pub fn primary_label(mut self, msg: impl Into<String>) -> Diag {
        self.primary_label = Some(msg.into());
        self
    }

    /// Attach a secondary span (span pair; rendered as its own snippet).
    pub fn label(mut self, span: Span, msg: impl Into<String>) -> Diag {
        self.labels.push(Label {
            span,
            message: msg.into(),
        });
        self
    }

    /// Attach a `= note:` line.
    pub fn note(mut self, msg: impl Into<String>) -> Diag {
        self.notes.push(msg.into());
        self
    }

    /// Attach a `= help:` line.
    pub fn help(mut self, msg: impl Into<String>) -> Diag {
        self.help = Some(msg.into());
        self
    }

    /// True when the span carries a real source location.
    pub fn span_is_known(&self) -> bool {
        span_is_known(&self.span)
    }

    /// Render the full diagnostic (header + snippet blocks + notes/help).
    /// `load` maps a file path to its source text (the renderer never holds
    /// a global source table). `color` enables ANSI output.
    pub fn render(
        &self,
        load: &dyn Fn(&str) -> Option<String>,
        color: bool,
    ) -> String {
        let c = Color::new(color);
        let mut out = String::new();
        out.push_str(&format!(
            "{}{}[{}]: {}{}\n",
            c.severity(self.severity),
            self.severity.label(),
            self.code,
            c.reset(),
            self.message,
        ));
        if let Some(block) = span_block(&self.span, self.primary_label.as_deref(), load, color) {
            out.push_str(&block);
        }
        for l in &self.labels {
            if let Some(block) = span_block(&l.span, Some(&l.message), load, color) {
                out.push_str(&block);
            }
        }
        for n in &self.notes {
            out.push_str(&format!("  {}= {}{}{}\n", c.note(), "note: ", n, c.reset()));
        }
        if let Some(h) = &self.help {
            out.push_str(&format!("  {}= {}{}{}\n", c.help(), "help: ", h, c.reset()));
        }
        out
    }

    /// Header-only rendering (no source access).
    pub fn render_simple(&self) -> String {
        self.render(&|_| None, false)
    }
}

/// Is this span pointing at real source?
pub fn span_is_known(span: &Span) -> bool {
    span.line > 0 && !span.file.is_empty() && span.file != "<unknown>"
}

/// 1-based line lookup in a source string.
pub fn line_text(source: &str, line: usize) -> Option<&str> {
    if line == 0 {
        return None;
    }
    source.lines().nth(line - 1)
}

/// The caret width for the span: col range (inclusive) when the span was
/// widened, else a point. `col_end >= col_start` normally; clamp defensively.
pub fn caret_width(span: &Span) -> usize {
    if span.col_end >= span.col_start {
        span.col_end - span.col_start + 1
    } else {
        1
    }
    .max(1)
}

/// Render one `┌─ file:line:col` snippet block: gutter line, source line,
/// and a caret row underlining `span`, followed by `label` (if any).
fn span_block(
    span: &Span,
    label: Option<&str>,
    load: &dyn Fn(&str) -> Option<String>,
    color: bool,
) -> Option<String> {
    if !span_is_known(span) {
        return None;
    }
    let source = load(&span.file)?;
    let line_str = line_text(&source, span.line)?;
    // Clamp the caret to the line's length (char-based, not byte-based).
    let line_len = line_str.chars().count();
    let col_start = span.col_start.min(line_len.saturating_add(1));
    let width = caret_width(span).min(line_len.saturating_add(1).saturating_sub(col_start).max(1));
    let gut = if color {
        "\x1b[36m".to_string()
    } else {
        String::new()
    };
    let reset = if color { "\x1b[0m" } else { "" };
    let w = span.line.to_string().len();
    // Arrow into the line: pad to col_start - 1 chars (caret is char- indexed).
    let pad: String = " ".repeat(col_start.saturating_sub(1));
    let carets = "^".repeat(width.max(1));
    let mut out = String::new();
    out.push_str(&format!("{gut}  ┌─{reset} {}:{}:{}\n", span.file, span.line, span.col_start));
    out.push_str(&format!("{gut}  │{reset}\n"));
    let src_line = format!("{}{}", col_align(line_str, col_start), line_suffix(line_str, col_start));
    out.push_str(&format!("{gut}{:>w$} │{reset} {}\n", span.line, src_line));
    let lbl = label.map(|l| format!(" {}", l)).unwrap_or_default();
    out.push_str(&format!(
        "{gut}{:>w$} │{reset} {}{}{}{}\n",
        "",
        pad,
        color_green(&carets, color),
        lbl,
        reset,
    ));
    Some(out)
}

/// Tab-aware left portion of the source line up to (not including)
/// `col_start`: used to align the leading pad with the real caret column.
fn col_align(line: &str, col_start: usize) -> String {
    line.chars().take(col_start.saturating_sub(1)).collect()
}

/// The remainder of the line from `col_start` (the underlined text region).
fn line_suffix(line: &str, col_start: usize) -> String {
    line.chars().skip(col_start.saturating_sub(1)).collect()
}

fn color_green(s: &str, color: bool) -> String {
    if color {
        format!("\x1b[32m{s}\x1b[0m")
    } else {
        s.to_string()
    }
}

/// ANSI palette helper.
struct Color {
    on: bool,
}

impl Color {
    fn new(on: bool) -> Color {
        Color { on }
    }
    fn reset(&self) -> &'static str {
        if self.on { "\x1b[0m" } else { "" }
    }
    fn severity(&self, sev: Severity) -> &'static str {
        if !self.on {
            return "";
        }
        match sev {
            Severity::Error => "\x1b[1;31m",
            Severity::Warning => "\x1b[1;33m",
            Severity::Note => "\x1b[33m",
            Severity::Help => "\x1b[34m",
        }
    }
    fn note(&self) -> &'static str {
        if self.on { "\x1b[33m" } else { "" }
    }
    fn help(&self) -> &'static str {
        if self.on { "\x1b[34m" } else { "" }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use resid_lexer::token::Span;

    fn fake_load(p: &str) -> Option<String> {
        match p {
            "bad.resid" => Some("Int main() {\n    Str x = 42;\n    return 0;\n}\n".into()),
            _ => None,
        }
    }

    #[test]
    fn renders_rustc_style_header() {
        let d = Diag::error_unknown("E0001", "boom");
        assert_eq!(d.render_simple(), "error[E0001]: boom\n");
    }

    #[test]
    fn renders_snippet_with_caret() {
        let span = Span {
            file: "bad.resid".into(),
            line: 2,
            col_start: 5,
            col_end: 7,
        };
        let d = Diag::error("E0001", "type mismatch: expected Str, found Int", span)
            .primary_label("expected Str");
        let out = d.render(&fake_load, false);
        assert!(out.contains("error[E0001]: type mismatch"), "{out}");
        assert!(out.contains("┌─ bad.resid:2:5"), "{out}");
        assert!(out.contains("2 │     Str x = 42;"), "{out}");
        assert!(out.contains("^^^ expected Str"), "{out}");
    }

    #[test]
    fn renders_secondary_label_span_pair() {
        let a = Span {
            file: "bad.resid".into(),
            line: 2,
            col_start: 5,
            col_end: 9,
        };
        let b = Span {
            file: "bad.resid".into(),
            line: 3,
            col_start: 5,
            col_end: 11,
        };
        let d = Diag::error("E0212", "capability not granted", a)
            .label(b, "call site here")
            .note("the ceiling flows from the enclosing sandbox");
        let out = d.render(&fake_load, false);
        assert!(out.contains("3 │     return 0;"), "{out}");
        assert!(out.contains("^^^^^^^ call site here"), "{out}");
        assert!(out.contains("= note: the ceiling flows from the enclosing sandbox"), "{out}");
    }

    #[test]
    fn unknown_span_degrades_to_header() {
        let d = Diag::error("E0010", "unterminated string", unknown_span());
        assert_eq!(d.render(&fake_load, false), "error[E0010]: unterminated string\n");
    }

    #[test]
    fn line_lookup_ok() {
        assert_eq!(line_text("a\nbb\nccc", 2), Some("bb"));
        assert_eq!(line_text("a", 2), None);
        assert_eq!(line_text("a\n", 0), None);
    }

    #[test]
    fn caret_widths() {
        let p = |c1, c2| Span { file: "f".into(), line: 1, col_start: c1, col_end: c2 };
        assert_eq!(caret_width(&p(5, 7)), 3);
        assert_eq!(caret_width(&p(5, 5)), 1);
        assert_eq!(caret_width(&p(9, 3)), 1);
    }
}