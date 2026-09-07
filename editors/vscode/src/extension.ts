import * as vscode from 'vscode';
import { LanguageClient, LanguageClientOptions, ServerOptions, TransportKind } from 'vscode-languageclient/node';

let client: LanguageClient;

export function activate(context: vscode.ExtensionContext) {
    const config = vscode.workspace.getConfiguration('resid');
    const lspEnabled = config.get<boolean>('lsp.enable', true);
    
    if (!lspEnabled) {
        return;
    }

    const serverPath = config.get<string>('lsp.serverPath', 'resid-lsp');
    
    const serverOptions: ServerOptions = {
        command: serverPath,
        transport: TransportKind.stdio,
        options: { env: { ...process.env, RUST_BACKTRACE: '1' } }
    };

    const clientOptions: LanguageClientOptions = {
        documentSelector: [
            { scheme: 'file', language: 'resid' },
            { scheme: 'file', language: 'resid-manifest' }
        ],
        synchronize: {
            fileEvents: vscode.workspace.createFileSystemWatcher('**/*.resid-notes.cbor')
        },
        initializationOptions: {}
    };

    client = new LanguageClient(
        'resid-lsp',
        'Resid LSP',
        serverOptions,
        clientOptions
    );

    client.start();
    context.subscriptions.push(client);
}

export function deactivate(): Thenable<void> | undefined {
    if (!client) {
        return undefined;
    }
    return client.stop();
}