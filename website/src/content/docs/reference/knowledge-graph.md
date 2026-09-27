---
title: The knowledge graph
description: The compiler's only intermediate representation, emitted as an artifact that tools and debuggers read.
---

Between parsing and code generation, the compiler works on one
representation: a **knowledge graph**, an enriched expression DAG. Name
resolution, type checking, capability checking, reduction and lowering all
read and extend it, and no phase re-reads source text. Debug and check
builds emit it as `<artifact>.resid-graph.cbor`.

## Nodes

Each node has an id (deterministic: source order, then reduction order), a
kind, a type, a knowledge state, a value when known, ordered operand
edges, the effects it may perform, the capabilities it requires, its
provenance (a source span, a provider result or a derivation), its doc
comments, and a content hash over kind, type and operands.

| State | Meaning |
|---|---|
| `known` | the value is fully determined at compile time |
| `effect` | the node performs an effect; its order is fixed |
| `residual` | the node depends on runtime values and is lowered |
| `invalid` | the node carries a diagnostic; the program is rejected |

## Edges

| Edge | From → to |
|---|---|
| operand | a node → its i-th dependency |
| def | a reference → the binding, parameter or function it names |
| seq | an effect → the effect before it |
| derive | a result node → the node it replaced, labelled with the rule |
| lowered | a node → the code range and runtime location emitted for it |

Operand, def and seq edges are acyclic; recursion is a def edge to a
function node.

## Derivation

Reduction adds nodes and never deletes one reachable from source. Each
result has a derive edge to what it replaced, labelled with its rule
(`fold`, `known`, `beta`, `eval`, `select`, `unwrap`, `interpolate`,
`concat`, `specialize`, `comptime`, `accumulate`, `rebuild`). A node left
residual records why: `unknown(dep)`, `effect(e)`, `capability(c)`,
`annotated` (`rt`), `budget(kind)`, `loop`, `whistle`.

Invariants: every node in the residual program is a source node or reaches
source through derive edges, and every source node is known, invalid,
lowered, or replaced.

## Lowering

Lowering reads only the residual part and records, for each emitted code
range, the node it lowers, and for each residual binding its runtime
location. Debug builds carry this as DWARF (line entries at each
statement's span, variables named after their bindings). The binary records
the graph's content hash (`resid_graph_hash`), so a debugger can check that
graph and binary match.

## Tools

[resid-why, resid-graph and resid-debug](/Resid/tools/why-graph-debug/)
answer questions by walking the graph, not by re-analyzing source:
what was reduced and by which rule, why something stayed residual, and,
live, which node the program counter is in and which folded values it
relies on.
