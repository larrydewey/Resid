import type { TagToken } from '../common/token.js';
import type { TreeAdapterTypeMap } from '../tree-adapters/interface.js';
export declare enum EntryType {
    Marker = 0,
    Element = 1
}
interface MarkerEntry<T extends TreeAdapterTypeMap> {
    type: EntryType.Marker;
    older: Entry<T> | null;
    newer: Entry<T> | null;
    /** The index of the entries before this marker. */
    outerIndex: RegionIndex<T> | null;
}
/** The entries with one tag name after one marker are chained from a head, newest first. */
interface SameTagLink<T extends TreeAdapterTypeMap> {
    olderSameTag: ElementEntry<T> | null;
}
export interface ElementEntry<T extends TreeAdapterTypeMap> extends SameTagLink<T> {
    type: EntryType.Element;
    element: T['element'];
    token: TagToken;
    older: Entry<T> | null;
    newer: Entry<T> | null;
    /** The entry's group of entries with the same tag name and attributes; null until indexed. */
    ark: Ark<T> | null;
    /** The next newer entry with the same tag name, or the chain's head; null until indexed. */
    newerSameTag: SameTagLink<T> | null;
}
export type Entry<T extends TreeAdapterTypeMap> = MarkerEntry<T> | ElementEntry<T>;
/** The entries after one marker with one tag name and attributes, oldest first, and their key in the region's arks. */
interface Ark<T extends TreeAdapterTypeMap> {
    entries: ElementEntry<T>[];
    key: string;
}
/** The entries after one marker by tag name and attributes, and the newest of them by tag name. */
interface RegionIndex<T extends TreeAdapterTypeMap> {
    arks: Map<string, Ark<T>>;
    tagNames: Map<string, SameTagLink<T>>;
}
export declare class FormattingElementList<T extends TreeAdapterTypeMap> {
    newest: Entry<T> | null;
    bookmark: Entry<T> | null;
    /** The index of the entries after the last marker; null only while there are at most NOAH_ARK_CAPACITY of them. */
    private index;
    /** The entries by element, except possibly those after the last marker while they are not indexed. */
    private elementEntries;
    /** Returns the entry's ark, or null if the entries after the last marker are not indexed. */
    private _insertElementEntry;
    private _addToIndex;
    insertMarker(): void;
    pushElement(element: T['element'], token: TagToken): void;
    insertElementAfterBookmark(element: T['element'], token: TagToken): void;
    removeEntry(entry: ElementEntry<T>): void;
    replaceElement(entry: ElementEntry<T>, element: T['element']): void;
    /**
     * Clears the list of formatting elements up to the last marker.
     *
     * @see https://html.spec.whatwg.org/multipage/parsing.html#clear-the-list-of-active-formatting-elements-up-to-the-last-marker
     */
    clearToLastMarker(): void;
    getElementEntryInScopeWithTagName(tagName: string): ElementEntry<T> | null;
    getElementEntry(element: T['element']): ElementEntry<T> | undefined;
}
export {};
