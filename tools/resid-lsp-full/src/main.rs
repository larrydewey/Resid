//! Full Resid LSP server — semantic analysis for the Resid language.
//!
//! Provides:
//! - Parse diagnostics (lexer/parser errors)
//! - Type diagnostics (type checker errors)
//! - Completions (keywords, types, functions, variables, fields)
//! - Go to definition / find references
//! - Document symbols (outline)
//! - Hover (type info, documentation)
//! - Code actions (import suggestions, etc.)

use std::sync::Arc;

use anyhow::Result;
use resid_lexer::Lexer;
use resid_parser::{Parser, TranslationUnit};
use resid_type::{check_program, collect_signatures, collect_types, infer_expr, FunctionSig, SemType, TypeError, Types};
use tower_lsp::jsonrpc::Result as LspResult;
use tower_lsp::lsp_types::*;
use tower_lsp::{Client, LanguageServer, LspService, Server};

mod analysis;
mod capabilities;
mod completions;
mod diagnostics;
mod hover;
mod symbols;
mod references;
mod goto_def;

use analysis::{AnalyzedFile, DocumentStore};
use capabilities::server_capabilities;
use completions::provide_completions;
use diagnostics::publish_diagnostics;
use goto_def::goto_definition;
use hover::provide_hover;
use references::find_references;
use symbols::document_symbols;

#[derive(Debug)]
pub struct ResidLsp {
    client: Client,
    docs: Arc<tokio::sync::RwLock<DocumentStore>>,
}

impl ResidLsp {
    pub fn new(client: Client) -> Self {
        Self {
            client,
            docs: Arc::new(tokio::sync::RwLock::new(DocumentStore::new())),
        }
    }

    async fn analyze(&self, uri: &Url) -> Option<AnalyzedFile> {
        let docs = self.docs.read().await;
        docs.get(uri).cloned()
    }

    async fn reanalyze(&self, uri: &Url, text: &str) -> Result<AnalyzedFile> {
        let file_path = uri.to_file_path().ok();
        let (unit, parse_errors) = Parser::parse(file_path.as_deref().map(|p| p.to_string_lossy().into_owned()).unwrap_or_default(), text);

        let type_errors = check_program(&unit);
        let signatures = collect_signatures(&unit);
        let types = collect_types(&unit);

        let analyzed = AnalyzedFile {
            uri: uri.clone(),
            text: text.to_string(),
            unit,
            parse_errors,
            type_errors,
            signatures,
            types,
        };

        let mut docs = self.docs.write().await;
        docs.insert(uri.clone(), analyzed.clone());

        publish_diagnostics(&self.client, &analyzed).await;

        Ok(analyzed)
    }
}

#[tower_lsp::async_trait]
impl LanguageServer for ResidLsp {
    async fn initialize(&self, _: InitializeParams) -> LspResult<InitializeResult> {
        Ok(InitializeResult {
            capabilities: server_capabilities(),
            server_info: Some(ServerInfo {
                name: "resid-lsp".to_string(),
                version: Some(env!("CARGO_PKG_VERSION").to_string()),
            }),
        })
    }

    async fn initialized(&self, _: InitializedParams) {
        self.client.log_message(MessageType::INFO, "Resid LSP initialized").await;
    }

    async fn shutdown(&self) -> LspResult<()> {
        Ok(())
    }

    async fn did_open(&self, params: DidOpenTextDocumentParams) {
        let _ = self.reanalyze(&params.text_document.uri, &params.text_document.text).await;
    }

    async fn did_change(&self, params: DidChangeTextDocumentParams) {
        let uri = params.text_document.uri;
        if let Some(change) = params.content_changes.into_iter().next() {
            let text = change.text;
            let _ = self.reanalyze(&uri, &text).await;
        }
    }

    async fn did_save(&self, _: DidSaveTextDocumentParams) {
        // Trigger reanalysis on save
    }

    async fn did_close(&self, params: DidCloseTextDocumentParams) {
        let mut docs = self.docs.write().await;
        docs.remove(&params.text_document.uri);
    }

    async fn completion(&self, params: CompletionParams) -> LspResult<Option<CompletionResponse>> {
        let uri = &params.text_document_position.text_document.uri;
        let position = params.text_document_position.position;

        let analyzed = self.analyze(uri).await;
        let completions = provide_completions(&analyzed, position);

        Ok(Some(CompletionResponse::Array(completions)))
    }

    async fn hover(&self, params: HoverParams) -> LspResult<Option<Hover>> {
        let uri = &params.text_document_position_params.text_document.uri;
        let position = params.text_document_position_params.position;

        let analyzed = self.analyze(uri).await;
        Ok(provide_hover(&analyzed, position).await)
    }

    async fn goto_definition(&self, params: GotoDefinitionParams) -> LspResult<Option<GotoDefinitionResponse>> {
        let uri = &params.text_document_position_params.text_document.uri;
        let position = params.text_document_position_params.position;

        let analyzed = self.analyze(uri).await;
        Ok(goto_definition(&analyzed, position))
    }

    async fn references(&self, params: ReferenceParams) -> LspResult<Option<Vec<Location>>> {
        let uri = &params.text_document_position.text_document.uri;
        let position = params.text_document_position.position;

        let analyzed = self.analyze(uri).await;
        Ok(find_references(&analyzed, position))
    }

    async fn document_symbol(&self, params: DocumentSymbolParams) -> LspResult<Option<DocumentSymbolResponse>> {
        let uri = &params.text_document.uri;

        let analyzed = self.analyze(uri).await;
        Ok(document_symbols(&analyzed))
    }

    async fn code_action(&self, params: CodeActionParams) -> LspResult<Option<CodeActionResponse>> {
        // TODO: implement code actions
        Ok(None)
    }
}

fn apply_incremental(old: &str, _new: &str) -> String {
    // For now, just return new text; proper incremental would need diff
    _new.to_string()
}

pub async fn run() -> Result<()> {
    let stdin = tokio::io::stdin();
    let stdout = tokio::io::stdout();

    let (service, socket) = LspService::new(ResidLsp::new);
    Server::new(stdin, stdout, socket).serve(service).await;

    Ok(())
}

#[tokio::main]
async fn main() {
    if let Err(e) = run().await {
        eprintln!("LSP server error: {}", e);
        std::process::exit(1);
    }
}