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

    // The server is the compiler itself: `residc lsp` (compiler/lsp.resid).
    const configuredPath = config.get<string>('compilerPath', '').trim();
    const compiler = configuredPath || findCompiler();
    output.appendLine(`Starting the Resid language server: ${compiler} lsp`);

    const serverOptions: ServerOptions = {
        command: compiler,
        args: ['lsp'],
        transport: TransportKind.stdio
    };

    const clientOptions: LanguageClientOptions = {
        documentSelector: [{ scheme: 'file', language: 'resid' }],
        outputChannelName: 'Resid LSP',
        traceOutputChannel: output
    };

    client = new LanguageClient(
        'resid',
        'Resid Language Server',
        serverOptions,
        clientOptions
    );

    client.start().catch((error: unknown) => {
        output.appendLine(`Failed to start the Resid language server: ${error instanceof Error ? error.message : String(error)}`);
        output.show(true);
    });
    context.subscriptions.push(client);
}

// A workspace that is the Resid repository has its own compiler; otherwise
// `residc` on PATH.
function findCompiler(): string {
    for (const folder of vscode.workspace.workspaceFolders ?? []) {
        const candidate = path.join(folder.uri.fsPath, 'build', 'boot', 'stage2.bin');
        if (fs.existsSync(candidate)) {
            return candidate;
        }
    }
    return 'residc';
}

export function deactivate(): Thenable<void> | undefined {
    if (!client) {
        return undefined;
    }
    return client.stop();
}