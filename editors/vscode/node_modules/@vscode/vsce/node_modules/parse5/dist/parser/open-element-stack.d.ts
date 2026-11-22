import { TAG_ID as $, NS } from '../common/html.js';
import type { TreeAdapter, TreeAdapterTypeMap } from '../tree-adapters/interface.js';
export interface StackHandler<T extends TreeAdapterTypeMap> {
    onItemPush: (node: T['parentNode'], tid: number, isTop: boolean) => void;
    onItemPop: (node: T['parentNode'], isTop: boolean) => void;
}
/**
 * The stack of open elements. Each element has a slot in `items` and `tagIDs`. Once the stack is `INDEX_DEPTH` deep, it
 * indexes its elements so that the searches the parser repeats per token take constant time: it chains the elements
 * with each key, so that the topmost one is found without a scan, and counts per slot the special elements and scope
 * boundaries at or below it, which tell whether one lies between two slots. Removing an element from the middle then
 * leaves its slot free instead of moving the elements above it; `slotBelow` and `slotAbove` step over free slots, and
 * `depth` counts the open elements.
 */
export declare class OpenElementStack<T extends TreeAdapterTypeMap> {
    private treeAdapter;
    private handler;
    items: T['parentNode'][];
    tagIDs: $[];
    current: T['parentNode'] | undefined;
    /** The slot of the current element. */
    stackTop: number;
    /** The number of open elements. */
    depth: number;
    tmplCount: number;
    currentTagId: number | undefined;
    private indexed;
    /** The slot of the open element below, and above, each open element's slot; -1 for none. */
    private below;
    private above;
    private keys;
    /** The slot of the next lower, and higher, open element with the same key; -1 for none. */
    private keyPrev;
    private keyNext;
    /** The slot of the topmost open element with each key, -1 for none. */
    private keyTops;
    private nameKeys;
    /** Per slot, the open special elements, list item boundaries and scope boundaries at or below it. */
    private specials;
    private listItemBoundaries;
    private scopeBoundaries;
    /** Per slot, the slot of the topmost open HTML element at or below it, or -1. */
    private htmlSlots;
    private formattingSlots;
    get currentTmplContentOrNode(): T['parentNode'];
    constructor(document: T['document'], treeAdapter: TreeAdapter<T>, handler: StackHandler<T>);
    /** The slot of an open element, or -1. */
    _indexOf(element: T['element']): number;
    /** The slot of the open element below the one at `idx`, or -1. */
    slotBelow(idx: number): number;
    /** The slot of the open element above the one at `idx`, or -1. */
    slotAbove(idx: number): number;
    private _isInTemplate;
    private _updateCurrentElement;
    private _nameKey;
    /** Indexes the open elements once the stack is `INDEX_DEPTH` deep. */
    private _indexAll;
    /** Indexes the element at `slot`, above the open element at `belowIdx`. */
    private _index;
    /** Puts the indexed element at `slot` above the one at `belowIdx`, and counts the elements of each class. */
    private _link;
    /** Takes the element at `slot` out of the index, except for the links between slots. */
    private _unindex;
    /** Moves the indexed element at `from` down to the free slot `to`, keeping its key chain in order. */
    private _move;
    /** The slot of the topmost open HTML element with this tag, or -1. */
    indexOfTopmost(tagID: $): number;
    /** The slot of the topmost open HTML element with any of these tags, or -1. */
    indexOfTopmostOf(tagIDs: readonly $[]): number;
    /** The slot of the topmost open element in this namespace with this tag name, or -1. */
    indexOfTopmostByName(ns: NS, tagName: string): number;
    /** The slot of the topmost open HTML element, or -1. */
    indexOfTopmostHtmlElement(): number;
    /** Whether an element of the classes is open above the slot `idx`, on a stack that is not indexed. */
    private _hasAbove;
    /** Whether a special element is open above the slot `idx`. */
    hasSpecialElementAbove(idx: number): boolean;
    /** Whether a special element other than HTML `address`, `div` and `p` is open above the slot `idx`. */
    hasListItemBoundaryAbove(idx: number): boolean;
    push(element: T['element'], tagID: $): void;
    /** Pops the current element without calling the handler. */
    private _popCurrent;
    pop(): void;
    replace(oldElement: T['element'], newElement: T['element']): void;
    /**
     * The adoption agency's last stack step: removes the formatting element at `formattingIdx` and opens `element`
     * directly above the furthest block at `furthestBlockIdx`. On an indexed stack, only formatting elements the agency
     * kept are still open between them; the furthest block, with those directly below it, moves down by one slot, and
     * `element` takes the furthest block's slot. No open element above the furthest block moves, and as all these
     * elements are HTML elements and only the furthest block is special, the counts above it stay the same.
     */
    replaceFormattingElement(formattingIdx: number, furthestBlockIdx: number, element: T['element'], tagID: $): void;
    popUntilTagNamePopped(tagName: $): void;
    shortenToLength(idx: number): void;
    popUntilElementPopped(element: T['element']): void;
    popUntilNumberedHeaderPopped(): void;
    popUntilTableCellPopped(): void;
    popAllUpToHtmlElement(): void;
    clearBackToTableContext(): void;
    clearBackToTableBodyContext(): void;
    clearBackToTableRowContext(): void;
    remove(element: T['element']): void;
    /** Removes the open element at the slot `idx`; on an indexed stack, the elements above it keep their slots. */
    removeAt(idx: number): void;
    tryPeekProperlyNestedBodyElement(): T['element'] | null;
    contains(element: T['element']): boolean;
    getCommonAncestor(element: T['element']): T['element'] | null;
    isRootHtmlElementCurrent(): boolean;
    /**
     * On an indexed stack: whether no element of the `scope` class is open above the slot `target`. A target that is not
     * open is in scope only on a stack without such an element, as a scan from the top would end there.
     */
    private _isInScope;
    /**
     * On a stack that is not indexed: whether an HTML element with the tag, or one of the tags, and if passed the element
     * itself, is open above every element of the `scope` class; true if neither is open.
     */
    private _scanScope;
    /** If `element` is passed, only that element (which has to be a `tagName` element) is looked for. */
    hasInScope(tagName: $, element?: T['element'] | null): boolean;
    hasInListItemScope(tagName: $): boolean;
    hasInButtonScope(tagName: $): boolean;
    hasNumberedHeaderInScope(): boolean;
    hasInTableScope(tagName: $): boolean;
    hasTableBodyContextInTableScope(): boolean;
    hasInSelectScope(tagName: $): boolean;
    generateImpliedEndTags(): void;
    generateImpliedEndTagsThoroughly(): void;
    generateImpliedEndTagsWithExclusion(exclusionId: $): void;
}
