---
title: Strings and text
description: Str, f-strings, the string functions, StrBuf, raw and byte strings.
---

`Str` is an immutable UTF-8 string. Lengths, indexes and slices count
**code points**, not bytes.

```resid
Int main() {
    Str s = "héllo, wörld";
    println(f"{str_len(s)} {str_slice(s, 0, 5)} {str_char_at(s, 1)}");
    println(f"{str_to_upper(s)} {str_index_of(s, "w", 0)}");
    List(Str) parts = str_split("a,b,c", ",");
    println(f"{parts} {str_join(parts, "-")}");
    println(str_replace("2026-09-27", "-", "/"));
    return 0;
}
```

```text title="Output"
12 héllo 233
HÉLLO, WÖRLD 7
["a", "b", "c"] a-b-c
2026/09/27
```

The string functions are `str_len`, `str_slice`, `str_char_at` (a code
point, as `Int`), `str_from_code`, `str_index_of`, `str_contains`,
`str_starts_with`, `str_ends_with`, `str_count`, `str_split`, `str_join`,
`str_trim`, `str_to_upper`, `str_to_lower`, `str_replace`, `str_repeat`,
`str_reverse`, `str_is_int`, `str_parse_int`, `str_is_float` and
`str_parse_float`. `+` concatenates and `==` compares.

## f-strings

`f"...{expr}..."` is how any value becomes text. A hole takes a value of
any type:

```resid
type User = { Str name; List(Str) roles; };

Int main() {
    User u = User {.name = "ada", .roles = ["admin", "dev"]};
    Dec price = 12.50m;
    println(f"{u.name} has {u.roles.len()} roles");
    println(f"{u}");
    println(f"{price} {price:.} {1.0 / 3.0} {Some(2)}");
    return 0;
}
```

```text title="Output"
ada has 2 roles
User { name: "ada", roles: ["admin", "dev"] }
12.50000000000000000000000000000000 12.5 0.3333333333333333 Some(2)
```

Numbers print in full (a `Float` prints the shortest text that reads back
as the same value, a `Dec` all its digits; `:.` trims a `Dec`'s trailing
zeros). Lists, maps, records and variants print structurally, strings inside
them quoted. A [`Show` behavior](/Resid/behaviors/show/) replaces the
built-in text for a type.

## Building strings

`s + t` copies both strings. To build a long string from many pieces, use
`StrBuf`, which appends in place:

```resid
StrBuf csv_row(List(Int) xs, Int i, StrBuf acc) {
    if (i >= xs.len()) { return acc; }
    StrBuf a = if (i > 0) { acc.push_char(',') } else { acc };
    return csv_row(xs, i + 1, a.push(f"{xs[i]}"));
}

Int main() {
    println(csv_row([1, 2, 3, 5, 8], 0, StrBuf()).finish());
    return 0;
}
```

```text title="Output"
1,2,3,5,8
```

## Other literals

`r"C:\no\escapes"` is a raw string. `'a'` is a character literal (a code
point `Int`). `b"bytes"` is a byte string (`Bytes`).
