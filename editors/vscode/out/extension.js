"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = activate;
exports.deactivate = deactivate;
const vscode = __importStar(require("vscode"));
const fs = __importStar(require("fs"));
const path = __importStar(require("path"));
const node_1 = require("vscode-languageclient/node");
let client;
function activate(context) {
    const config = vscode.workspace.getConfiguration('resid');
    const lspEnabled = config.get('lsp.enable', true);
    const output = vscode.window.createOutputChannel('Resid LSP');
    context.subscriptions.push(output);
    if (!lspEnabled) {
        output.appendLine('Resid LSP is disabled by the resid.lsp.enable setting.');
        return;
    }
    const configuredPath = config.get('lsp.serverPath', '').trim();
    const serverPath = configuredPath || findWorkspaceServer();
    if (!serverPath) {
        output.appendLine('Unable to find resid-lsp. Build it with: cargo build -p resid-lsp');
        output.appendLine('Then set resid.lsp.serverPath to the resulting target binary.');
        output.show(true);
        return;
    }
    output.appendLine(`Starting resid-lsp: ${serverPath}`);
    const serverOptions = {
        command: serverPath,
        transport: node_1.TransportKind.stdio,
        options: { env: { ...process.env, RUST_BACKTRACE: '1' } }
    };
    const clientOptions = {
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
    client = new node_1.LanguageClient('resid-lsp', 'Resid LSP', serverOptions, clientOptions);
    client.start().catch((error) => {
        output.appendLine(`Failed to start resid-lsp: ${error instanceof Error ? error.message : String(error)}`);
        output.show(true);
    });
    context.subscriptions.push(client);
}
function findWorkspaceServer() {
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
function deactivate() {
    if (!client) {
        return undefined;
    }
    return client.stop();
}
//# sourceMappingURL=extension.js.map