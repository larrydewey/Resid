import { DOCUMENT_MODE } from '../common/html.js';
/** The position of each name in the attribute lists `adoptAttributes` merged into, kept for the next merge into that list. */
const attrListIndexes = new WeakMap();
export const defaultTreeAdapter = {
    //Node construction
    createDocument() {
        return {
            nodeName: '#document',
            mode: DOCUMENT_MODE.NO_QUIRKS,
            childNodes: [],
        };
    },
    createDocumentFragment() {
        return {
            nodeName: '#document-fragment',
            childNodes: [],
        };
    },
    createElement(tagName, namespaceURI, attrs) {
        return {
            nodeName: tagName,
            tagName,
            attrs,
            namespaceURI,
            childNodes: [],
            parentNode: null,
        };
    },
    createCommentNode(data) {
        return {
            nodeName: '#comment',
            data,
            parentNode: null,
        };
    },
    createTextNode(value) {
        return {
            nodeName: '#text',
            value,
            parentNode: null,
        };
    },
    //Tree mutation
    appendChild(parentNode, newNode) {
        parentNode.childNodes.push(newNode);
        newNode.parentNode = parentNode;
    },
    insertBefore(parentNode, newNode, referenceNode) {
        const { childNodes } = parentNode;
        // The reference is usually the last child (fostered content precedes the table), so check that first.
        const insertionIdx = childNodes[childNodes.length - 1] === referenceNode
            ? childNodes.length - 1
            : childNodes.indexOf(referenceNode);
        childNodes.splice(insertionIdx, 0, newNode);
        newNode.parentNode = parentNode;
    },
    setTemplateContent(templateElement, contentElement) {
        templateElement.content = contentElement;
    },
    getTemplateContent(templateElement) {
        return templateElement.content;
    },
    setDocumentType(document, name, publicId, systemId) {
        const doctypeNode = document.childNodes.find((node) => node.nodeName === '#documentType');
        if (doctypeNode) {
            doctypeNode.name = name;
            doctypeNode.publicId = publicId;
            doctypeNode.systemId = systemId;
        }
        else {
            const node = {
                nodeName: '#documentType',
                name,
                publicId,
                systemId,
                parentNode: null,
            };
            defaultTreeAdapter.appendChild(document, node);
        }
    },
    setDocumentMode(document, mode) {
        document.mode = mode;
    },
    getDocumentMode(document) {
        return document.mode;
    },
    detachNode(node) {
        if (node.parentNode) {
            const { childNodes } = node.parentNode;
            // The parser detaches from the end when it moves children, so check the last child first.
            const idx = childNodes[childNodes.length - 1] === node ? childNodes.length - 1 : childNodes.indexOf(node);
            childNodes.splice(idx, 1);
            node.parentNode = null;
        }
    },
    insertText(parentNode, text) {
        if (parentNode.childNodes.length > 0) {
            const prevNode = parentNode.childNodes[parentNode.childNodes.length - 1];
            if (defaultTreeAdapter.isTextNode(prevNode)) {
                prevNode.value += text;
                return;
            }
        }
        defaultTreeAdapter.appendChild(parentNode, defaultTreeAdapter.createTextNode(text));
    },
    insertTextBefore(parentNode, text, referenceNode) {
        const { childNodes } = parentNode;
        const referenceIdx = childNodes[childNodes.length - 1] === referenceNode
            ? childNodes.length - 1
            : childNodes.indexOf(referenceNode);
        const prevNode = childNodes[referenceIdx - 1];
        if (prevNode && defaultTreeAdapter.isTextNode(prevNode)) {
            prevNode.value += text;
        }
        else {
            defaultTreeAdapter.insertBefore(parentNode, defaultTreeAdapter.createTextNode(text), referenceNode);
        }
    },
    /**
     * Keeps the recipient's names between merges as a map from name to position. The map is rebuilt when the list changed
     * length or has a repeated name, or when a merged name it holds no longer names the entry at that position. A name that
     * other code gives an existing entry between two merges is missed otherwise, and merging it appends it a second time.
     */
    adoptAttributes(recipient, attrs) {
        // Merging a list into itself adds nothing: every name is already present.
        if (attrs.length === 0 || attrs === recipient.attrs)
            return;
        const cached = attrListIndexes.get(recipient.attrs);
        const isIndexed = (cached === null || cached === void 0 ? void 0 : cached.size) === recipient.attrs.length &&
            attrs.every(({ name }) => {
                var _a;
                const index = cached.get(name);
                return index === undefined || ((_a = recipient.attrs[index]) === null || _a === void 0 ? void 0 : _a.name) === name;
            });
        const recipientAttrsMap = isIndexed ? cached : new Map();
        if (!isIndexed) {
            for (let i = 0; i < recipient.attrs.length; i++) {
                const attr = recipient.attrs[i];
                // A sparse list is indexed again on every merge, as its size never matches its length.
                if (attr !== undefined)
                    recipientAttrsMap.set(attr.name, i);
            }
            attrListIndexes.set(recipient.attrs, recipientAttrsMap);
        }
        const adoptedFrom = recipient.attrs.length;
        for (let j = 0; j < attrs.length; j++) {
            if (!recipientAttrsMap.has(attrs[j].name)) {
                recipient.attrs.push(attrs[j]);
            }
        }
        for (let j = adoptedFrom; j < recipient.attrs.length; j++) {
            recipientAttrsMap.set(recipient.attrs[j].name, j);
        }
        // A list with a repeated name is indexed again on the next merge.
        if (recipientAttrsMap.size !== recipient.attrs.length) {
            attrListIndexes.delete(recipient.attrs);
        }
    },
    //Tree traversing
    getFirstChild(node) {
        return node.childNodes[0];
    },
    getChildNodes(node) {
        return node.childNodes;
    },
    getParentNode(node) {
        return node.parentNode;
    },
    getAttrList(element) {
        return element.attrs;
    },
    //Node data
    getTagName(element) {
        return element.tagName;
    },
    getNamespaceURI(element) {
        return element.namespaceURI;
    },
    getTextNodeContent(textNode) {
        return textNode.value;
    },
    getCommentNodeContent(commentNode) {
        return commentNode.data;
    },
    getDocumentTypeNodeName(doctypeNode) {
        return doctypeNode.name;
    },
    getDocumentTypeNodePublicId(doctypeNode) {
        return doctypeNode.publicId;
    },
    getDocumentTypeNodeSystemId(doctypeNode) {
        return doctypeNode.systemId;
    },
    //Node types
    isTextNode(node) {
        return node.nodeName === '#text';
    },
    isCommentNode(node) {
        return node.nodeName === '#comment';
    },
    isDocumentTypeNode(node) {
        return node.nodeName === '#documentType';
    },
    isElementNode(node) {
        return Object.prototype.hasOwnProperty.call(node, 'tagName');
    },
    // Source code location
    setNodeSourceCodeLocation(node, location) {
        node.sourceCodeLocation = location;
    },
    getNodeSourceCodeLocation(node) {
        return node.sourceCodeLocation;
    },
    updateNodeSourceCodeLocation(node, endLocation) {
        node.sourceCodeLocation = { ...node.sourceCodeLocation, ...endLocation };
    },
};
