import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import { LanguageClient, LanguageClientOptions, ServerOptions, TransportKind } from 'vscode-languageclient/node';

let client: LanguageClient;

export function activate(context: vscode.ExtensionContext) {
    const config = vscode.workspace.getConfiguration('resid');
    const lspEnabled = config.get<boolean>('lsp.enable', true);
    const output = vscode.window.createOutputChannel('Resid LSP');
    context.subscriptions.push(output);
    
    if (!lspEnabled) {
        output.appendLine('Resid LSP is disabled by the resid.lsp.enable setting.');
        return;
    }

    const configuredPath = config.get<string>('lsp.serverPath', '').trim();
    const serverPath = configuredPath || findWorkspaceServer();
    if (!serverPath) {
        output.appendLine('Unable to find resid-lsp. Build it with: cargo build -p resid-lsp');
        output.appendLine('Then set resid.lsp.serverPath to the resulting target binary.');
        output.show(true);
        return;
    }
    output.appendLine(`Starting resid-lsp: ${serverPath}`);
    
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
        initializationOptions: {},
        outputChannelName: 'Resid LSP',
        traceOutputChannel: output
    };

    client = new LanguageClient(
        'resid-lsp',
        'Resid LSP',
        serverOptions,
        clientOptions
    );

    client.start().catch((error: unknown) => {
        output.appendLine(`Failed to start resid-lsp: ${error instanceof Error ? error.message : String(error)}`);
        output.show(true);
    });
    context.subscriptions.push(client);
}

function findWorkspaceServer(): string | undefined {
    for (const folder of vscode.workspace.workspaceFolders ?? []) {
        for (const profile of ['release', 'debug']) {
            const candidate = path.join(folder.uri.fsPath, 'target', profile, process.platform === 'win32' ? 'resid-lsp.exe' : 'resid-lsp');
            if (fs.existsSync(candidate)) {
                return candidate;
            }
        }
    }
    return 'resid-lsp';
}

export function deactivate(): Thenable<void> | undefined {
    if (!client) {
        return undefined;
    }
    return client.stop();
}