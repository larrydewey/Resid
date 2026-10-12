---
title: Formats
description: The serialization formats built on the standard library's framework, as packages.
---

The [serialization framework](/Resid/tools/serialization/) is in the
standard library, with CBOR. The other formats are packages, each a
format for the same framework, so a type's `Encode`/`Decode` instances
serve all of them. Name one in `resid.toml` (`[dependencies.resid-json]`
with a `path` or a registry `version`) and import it by package name.

| Package | Format | Entry points |
|---|---|---|
| [resid-json](https://github.com/larrydewey/resid-json) | JSON (RFC 8259) | `to_json(x) -> Result(Str, SerialError)`, `from_json(text)`; `json_encoder()`, `json_decoder(text)` |
| [resid-msgpack](https://github.com/larrydewey/resid-msgpack) | MessagePack | `to_msgpack(x) -> Result(List(Int), SerialError)`, `from_msgpack(bytes)`, `msgpack_to_hex` |
| [resid-bson](https://github.com/larrydewey/resid-bson) | BSON | `to_bson(x)`, `from_bson(bytes)`, `bson_to_hex` |
| [resid-toml](https://github.com/larrydewey/resid-toml) | TOML 1.0 | `to_toml(x) -> Result(Str, SerialError)`, `from_toml(text)` |
| [resid-yaml](https://github.com/larrydewey/resid-yaml) | YAML 1.2 (core schema, anchors and aliases, streams) | `to_yaml(x) -> Result(Str, SerialError)`, `from_yaml(text)` |
| [resid-cbor](https://github.com/larrydewey/resid-cbor) | CBOR (RFC 8949) | the package the standard library's `cbor.resid` comes from |
| [resid-serial](https://github.com/larrydewey/resid-serial) | the framework | the package the standard library's `serial*.resid` come from, with `tools/resid-derive`, the instance generator |

Each package's README maps the data model onto its format: what a record,
a variant, an option or a 128-bit integer becomes, and what the format
cannot spell (TOML has no null, BSON's maps need string keys).

A decoder for a self-describing format (JSON, CBOR, MessagePack, BSON,
YAML) decodes into `Value` without knowing the type in advance; TOML and
YAML parse the whole document first, so fields may come in any order.
