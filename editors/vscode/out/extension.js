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
    // The server is the compiler itself: `residc lsp` (compiler/lsp.resid).
    const configuredPath = config.get('compilerPath', '').trim();
    const compiler = configuredPath || findCompiler();
    output.appendLine(`Starting the Resid language server: ${compiler} lsp`);
    const serverOptions = {
        command: compiler,
        args: ['lsp'],
        transport: node_1.TransportKind.stdio
    };
    const clientOptions = {
        documentSelector: [{ scheme: 'file', language: 'resid' }],
        outputChannelName: 'Resid LSP',
        traceOutputChannel: output
    };
    client = new node_1.LanguageClient('resid', 'Resid Language Server', serverOptions, clientOptions);
    client.start().catch((error) => {
        output.appendLine(`Failed to start the Resid language server: ${error instanceof Error ? error.message : String(error)}`);
        output.show(true);
    });
    context.subscriptions.push(client);
}
// A workspace that is the Resid repository has its own compiler; otherwise
// `residc` on PATH.
function findCompiler() {
    for (const folder of vscode.workspace.workspaceFolders ?? []) {
        const candidate = path.join(folder.uri.fsPath, 'build', 'boot', 'stage2.bin');
        if (fs.existsSync(candidate)) {
            return candidate;
        }
    }
    return 'residc';
}
function deactivate() {
    if (!client) {
        return undefined;
    }
    return client.stop();
}
//# sourceMappingURL=extension.js.map