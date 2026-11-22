import { TAG_NAMES as $, NS, hasUnescapedText } from '../common/html.js';
import { escapeText, escapeAttribute } from 'entities/escape';
import { defaultTreeAdapter } from '../tree-adapters/default.js';
// Sets
const VOID_ELEMENTS = new Set([
    $.AREA,
    $.BASE,
    $.BASEFONT,
    $.BGSOUND,
    $.BR,
    $.COL,
    $.EMBED,
    $.FRAME,
    $.HR,
    $.IMG,
    $.INPUT,
    $.KEYGEN,
    $.LINK,
    $.META,
    $.PARAM,
    $.SOURCE,
    $.TRACK,
    $.WBR,
]);
function isVoidElement(node, options) {
    return (options.treeAdapter.isElementNode(node) &&
        options.treeAdapter.getNamespaceURI(node) === NS.HTML &&
        VOID_ELEMENTS.has(options.treeAdapter.getTagName(node)));
}
const defaultOpts = { treeAdapter: defaultTreeAdapter, scriptingEnabled: true };
/**
 * Serializes an AST node to an HTML string.
 *
 * @example
 *
 * ```js
 * const parse5 = require('parse5');
 *
 * const document = parse5.parse('<!DOCTYPE html><html><head></head><body>Hi there!</body></html>');
 *
 * // Serializes a document.
 * const html = parse5.serialize(document);
 *
 * // Serializes the <html> element content.
 * const str = parse5.serialize(document.childNodes[1]);
 *
 * console.log(str); //> '<head></head><body>Hi there!</body>'
 * ```
 *
 * @param node Node to serialize.
 * @param options Serialization options.
 */
export function serialize(node, options) {
    var _a;
    const opts = { ...defaultOpts, ...options };
    if (isVoidElement(node, opts)) {
        return '';
    }
    const { treeAdapter } = opts;
    // A template's children are those of its content fragment.
    const container = treeAdapter.isElementNode(node) &&
        treeAdapter.getTagName(node) === $.TEMPLATE &&
        treeAdapter.getNamespaceURI(node) === NS.HTML
        ? treeAdapter.getTemplateContent(node)
        : node;
    return serializeNodes((_a = treeAdapter.getChildNodes(container)) !== null && _a !== void 0 ? _a : [], opts);
}
/**
 * Serializes an AST element node to an HTML string, including the element node.
 *
 * @example
 *
 * ```js
 * const parse5 = require('parse5');
 *
 * const document = parse5.parseFragment('<div>Hello, <b>world</b>!</div>');
 *
 * // Serializes the <div> element.
 * const str = parse5.serializeOuter(document.childNodes[0]);
 *
 * console.log(str); //> '<div>Hello, <b>world</b>!</div>'
 * ```
 *
 * @param node Node to serialize.
 * @param options Serialization options.
 */
export function serializeOuter(node, options) {
    const opts = { ...defaultOpts, ...options };
    return serializeNodes([node], opts);
}
function serializeNodes(nodes, options) {
    var _a;
    const { treeAdapter } = options;
    // The depth of the tree is not bounded, so the open elements (their
    // remaining siblings and end tags) are kept on explicit stacks.
    const stack = [];
    let html = '';
    let index = 0;
    for (;;) {
        if (index < nodes.length) {
            const node = nodes[index++];
            if (treeAdapter.isElementNode(node)) {
                const tn = treeAdapter.getTagName(node);
                html += `<${tn}${serializeAttributes(node, options)}>`;
                const isHtml = treeAdapter.getNamespaceURI(node) === NS.HTML;
                if (!(isHtml && VOID_ELEMENTS.has(tn))) {
                    stack.push({ nodes, index, endTag: `</${tn}>` });
                    nodes =
                        (_a = treeAdapter.getChildNodes(isHtml && tn === $.TEMPLATE ? treeAdapter.getTemplateContent(node) : node)) !== null && _a !== void 0 ? _a : [];
                    index = 0;
                }
            }
            else if (treeAdapter.isTextNode(node)) {
                html += serializeTextNode(node, options);
            }
            else if (treeAdapter.isCommentNode(node)) {
                html += serializeCommentNode(node, options);
            }
            else if (treeAdapter.isDocumentTypeNode(node)) {
                html += serializeDocumentTypeNode(node, options);
            }
        }
        else {
            const parent = stack.pop();
            if (!parent) {
                return html;
            }
            html += parent.endTag;
            ({ nodes, index } = parent);
        }
    }
}
function serializeAttributes(node, { treeAdapter }) {
    let html = '';
    for (const attr of treeAdapter.getAttrList(node)) {
        html += ' ';
        if (attr.namespace) {
            switch (attr.namespace) {
                case NS.XML: {
                    html += `xml:${attr.name}`;
                    break;
                }
                case NS.XMLNS: {
                    if (attr.name !== 'xmlns') {
                        html += 'xmlns:';
                    }
                    html += attr.name;
                    break;
                }
                case NS.XLINK: {
                    html += `xlink:${attr.name}`;
                    break;
                }
                default: {
                    html += `${attr.prefix}:${attr.name}`;
                }
            }
        }
        else {
            html += attr.name;
        }
        html += `="${escapeAttribute(attr.value)}"`;
    }
    return html;
}
function serializeTextNode(node, options) {
    const { treeAdapter } = options;
    const content = treeAdapter.getTextNodeContent(node);
    const parent = treeAdapter.getParentNode(node);
    const parentTn = parent && treeAdapter.isElementNode(parent) && treeAdapter.getTagName(parent);
    return parentTn &&
        treeAdapter.getNamespaceURI(parent) === NS.HTML &&
        hasUnescapedText(parentTn, options.scriptingEnabled)
        ? content
        : escapeText(content);
}
function serializeCommentNode(node, { treeAdapter }) {
    return `<!--${treeAdapter.getCommentNodeContent(node)}-->`;
}
function serializeDocumentTypeNode(node, { treeAdapter }) {
    return `<!DOCTYPE ${treeAdapter.getDocumentTypeNodeName(node)}>`;
}
