---
title: Serialization
description: Encoding any type to any format and back, with the standard library's serialization framework and CBOR.
---

The standard library carries a serialization framework in the spirit of
Rust's serde: a type says once how it maps onto a small data model, a
format implements that model once, and any type goes to any format. The
framework is `lib/serial.resid` (with `lib/serial_value.resid` and
`lib/serial_seq.resid`); CBOR (`lib/cbor.resid`) is the one format in the
standard library, and JSON, MessagePack, BSON, TOML and YAML are packages
built on the same framework (see [Formats](/Resid/tools/formats/)).

```text
import "cbor.resid";
import "serial_value.resid";

Int main() {
    Value v = VSeq([VStr("application/x"), VBytes([1, 2, 3])]);
    Result(List(Int), SerialError) b = to_cbor(v);
    List(Int) bytes = match (b) { Ok(x) => x, Err(e) => [] };
    println(cbor_hex(bytes));                       // 826d6170706c69636174696f6e2f7843010203
    Result(Value, SerialError) back = from_cbor(bytes);
    println(match (back) { Ok(x) => f"{x}", Err(e) => error_text(e) });   // ["application/x", b[1, 2, 3]]
    return 0;
}
```

## The pieces

| Piece | Role |
|---|---|
| `Encoder(F)` / `Decoder(F)` | what a **format** can write and read |
| `Encode(T, F)` / `Decode(T, F)` | how a **type** maps onto that protocol, generic in the format `F` |
| `Parsed(T, F)` | a decoded value and the format state after it |
| `SerialError` | an error with a kind, a message and a path (`.items[3].name`); `error_text` shows it |
| `Value` | a format-neutral tree: `to_value`, `from_value`, and decoding any self-describing format into it |
| `Indexed(C, T)` / `Build(C, B, T)` | iterate a sequence in place / build one through its builder |

Values never change, so a format's state is threaded through every call:
each verb takes the state and returns the next one, and `?` carries the
first error out.

## The data model

| Data model | Resid types |
|---|---|
| unit | `UnitVal` (`unit()`) |
| bool | `Bool` |
| integers | `Int`, `UInt(64)`; narrower widths widen and are range-checked on the way back; `Int(128)`, `UInt(128)` |
| float | `Float`, `Float(32)`, `Float(16)` |
| string | `Str`, `Str(N)`, and `Dec(N)` as its decimal text |
| bytes | `Bytes(N)`, or a `List(Int)` written as bytes |
| option | `Option(T)` |
| sequence | `List(T)`, `List(T, N)`, `Set(T)` (sorted) |
| map | `Map(K, V)` (sorted by key) |
| struct | records |
| enum | sum types: unit variants and variants with one payload; `Result(T, E)` |

Fixed-capacity values stream from their own storage and decode into
their own builders, which report overflow as a decode error.

## Instances

An instance for a record is a pair of functions over the protocol's
verbs; `tools/resid-derive` in the
[resid-serial](https://github.com/larrydewey/resid-serial) package
generates them from `//@ serial(...)` annotations (renames, defaults,
skipped fields, flattened fields, internally, adjacently or un-tagged
enums), as serde's derive does.

## CBOR

`lib/cbor.resid` maps the data model onto CBOR (RFC 8949): records as
maps keyed by field name, unit variants as their name, variants with a
payload as one-entry maps, `None` as null, 128-bit integers that do not
fit 64 bits as bignums, floats in the shortest exact width. Encoding is
deterministic; decoding reads definite and indefinite lengths, and a tag
is transparent.

| Call | |
|---|---|
| `to_cbor(x)` | the bytes |
| `from_cbor(bytes)` | one value; trailing bytes are an error |
| `to_cbor_hex(x)`, `from_cbor_hex(text)`, `cbor_hex(bytes)` | hex, for logs and tests |
| `cbor_encoder()`, `cbor_decoder(bytes)`, `cbor_bytes(e)` | the raw states, for a caller threading them itself |
| `cbor_well_formed(bytes, depth)` | whether `bytes` is exactly one item of definite lengths nested at most `depth` deep |

The decoder accepts any nesting and indefinite lengths, so bytes from
outside go through `cbor_well_formed` first: it decides, in one pass that
builds nothing, that every length lies within the input and the nesting
is bounded. `lib/cmw.resid` (RATS CMW, the attestation evidence envelope)
does exactly that.

A program that uses JSON elsewhere and CBOR here writes one set of
instances: the same `Encode`/`Decode` serve both formats.
