//Const
const NOAH_ARK_CAPACITY = 3;
export var EntryType;
(function (EntryType) {
    EntryType[EntryType["Marker"] = 0] = "Marker";
    EntryType[EntryType["Element"] = 1] = "Element";
})(EntryType || (EntryType = {}));
//List of formatting elements
export class FormattingElementList {
    constructor() {
        this.newest = null;
        this.bookmark = null;
        /** The index of the entries after the last marker; null only while there are at most NOAH_ARK_CAPACITY of them. */
        this.index = null;
        /** The entries by element, except possibly those after the last marker while they are not indexed. */
        this.elementEntries = new Map();
    }
    /** Returns the entry's ark, or null if the entries after the last marker are not indexed. */
    _insertElementEntry(element, token, older) {
        const newer = older === null ? null : older.newer;
        const entry = {
            type: EntryType.Element,
            element,
            token,
            older,
            newer,
            ark: null,
            olderSameTag: null,
            newerSameTag: null,
        };
        if (newer === null) {
            this.newest = entry;
        }
        else {
            newer.older = entry;
        }
        if (older !== null) {
            older.newer = entry;
        }
        return this.index === null ? null : this._addToIndex(this.index, entry);
    }
    _addToIndex(index, entry) {
        const { tagName, attrs } = entry.token;
        // Names are unique and the tokenizer replaces NUL, so the sorted pairs identify the attribute set.
        // Sorting costs O(k log k) comparisons for a tag with k attributes.
        const key = tagName +
            attrs
                .map(({ name, value }) => `\0${name}\0${value}`)
                .sort()
                .join('');
        let ark = index.arks.get(key);
        if (ark === undefined) {
            ark = { entries: [], key };
            index.arks.set(key, ark);
        }
        ark.entries.push(entry);
        entry.ark = ark;
        this.elementEntries.set(entry.element, entry);
        let head = index.tagNames.get(tagName);
        if (head === undefined) {
            head = { olderSameTag: null };
            index.tagNames.set(tagName, head);
        }
        entry.olderSameTag = head.olderSameTag;
        entry.newerSameTag = head;
        if (head.olderSameTag !== null) {
            head.olderSameTag.newerSameTag = entry;
        }
        head.olderSameTag = entry;
        return ark;
    }
    //Mutations
    insertMarker() {
        if (this.index === null) {
            for (let entry = this.newest; entry !== null && entry.type === EntryType.Element; entry = entry.older) {
                this.elementEntries.set(entry.element, entry);
            }
        }
        const marker = {
            type: EntryType.Marker,
            older: this.newest,
            newer: null,
            outerIndex: this.index,
        };
        if (this.newest !== null) {
            this.newest.newer = marker;
        }
        this.newest = marker;
        this.index = null;
    }
    pushElement(element, token) {
        if (this.index === null) {
            let oldest = null;
            let count = 0;
            for (let entry = this.newest; entry !== null && entry.type === EntryType.Element; entry = entry.older) {
                oldest = entry;
                count++;
            }
            if (count >= NOAH_ARK_CAPACITY) {
                this.index = { arks: new Map(), tagNames: new Map() };
                for (let entry = oldest; entry !== null && entry.type === EntryType.Element; entry = entry.newer) {
                    this._addToIndex(this.index, entry);
                }
            }
        }
        const ark = this._insertElementEntry(element, token, this.newest);
        if (ark !== null && ark.entries.length > NOAH_ARK_CAPACITY) {
            this.removeEntry(ark.entries[0]);
        }
    }
    insertElementAfterBookmark(element, token) {
        // Like the formatting element's entry that it replaces, this entry is the newest with its tag name. The bookmark
        // is used once per adoption-agency step and released here, so it does not keep a cleared region reachable.
        const { bookmark } = this;
        this.bookmark = null;
        this._insertElementEntry(element, token, bookmark);
    }
    removeEntry(entry) {
        var _a;
        // An `a` start tag removes its entry even when the adoption agency already has, so skip unlinked entries.
        if (entry.newer === null ? this.newest !== entry : entry.newer.older !== entry) {
            return;
        }
        this.elementEntries.delete(entry.element);
        if (entry.newer === null) {
            this.newest = entry.older;
        }
        else {
            entry.newer.older = entry.older;
        }
        if (entry.older !== null) {
            entry.older.newer = entry.newer;
        }
        if (entry.ark !== null) {
            const { entries, key } = entry.ark;
            entries.splice(entries.indexOf(entry), 1);
            // Entries are removed only after the last marker, so an emptied ark is dropped from the last region's index.
            if (entries.length === 0)
                (_a = this.index) === null || _a === void 0 ? void 0 : _a.arks.delete(key);
        }
        if (entry.newerSameTag !== null) {
            entry.newerSameTag.olderSameTag = entry.olderSameTag;
            if (entry.olderSameTag !== null) {
                entry.olderSameTag.newerSameTag = entry.newerSameTag;
            }
        }
    }
    replaceElement(entry, element) {
        if (this.elementEntries.delete(entry.element)) {
            this.elementEntries.set(element, entry);
        }
        entry.element = element;
    }
    /**
     * Clears the list of formatting elements up to the last marker.
     *
     * @see https://html.spec.whatwg.org/multipage/parsing.html#clear-the-list-of-active-formatting-elements-up-to-the-last-marker
     */
    clearToLastMarker() {
        let marker = this.newest;
        for (; marker !== null && marker.type === EntryType.Element; marker = marker.older) {
            this.elementEntries.delete(marker.element);
        }
        this.newest = marker === null ? null : marker.older;
        this.index = marker === null ? null : marker.outerIndex;
        if (this.newest !== null) {
            this.newest.newer = null;
        }
    }
    //Search
    getElementEntryInScopeWithTagName(tagName) {
        var _a, _b;
        if (this.index !== null) {
            return (_b = (_a = this.index.tagNames.get(tagName)) === null || _a === void 0 ? void 0 : _a.olderSameTag) !== null && _b !== void 0 ? _b : null;
        }
        for (let entry = this.newest; entry !== null && entry.type === EntryType.Element; entry = entry.older) {
            if (entry.token.tagName === tagName) {
                return entry;
            }
        }
        return null;
    }
    getElementEntry(element) {
        if (this.index === null) {
            for (let entry = this.newest; entry !== null && entry.type === EntryType.Element; entry = entry.older) {
                if (entry.element === element) {
                    return entry;
                }
            }
        }
        return this.elementEntries.get(element);
    }
}
