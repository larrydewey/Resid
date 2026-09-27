---
title: resid-why, resid-graph, resid-debug
description: Ask the knowledge graph what was reduced and why, and debug a running program by node.
---

A debug build (`residc app.resid -o app --profile debug`) writes the
[knowledge graph](/Resid/reference/knowledge-graph/) next to the binary.
These tools read it; they never re-analyze source.

Take this program:

```resid
Int square(Int x) { return x * x; }

@requires(args)
Int main() {
    Int known = square(12);
    Int n = args.count();
    Int unknown = square(n + 1);
    println(f"{known} {unknown}");
    return 0;
}
```

```text title="Output"
144 4
```

## resid-why

`resid-why <artifact> [symbol] [--at FILE:LINE] [--node ID] [--summary]
[--kind K] [--file F] [--max N] [--json]`

```text
$ resid-why demo square
#8 fn square residual, unknown on #2 @ demo.resid:1:1
  use #22 call square: Int residual, unknown on #8 @ demo.resid:7:19
  2 use(s): 1 known, 1 residual or effect

$ resid-why demo --at demo.resid:5
#11 lit: Int(64) known = 12 @ demo.resid:5:24
#12 call square: Int residual, unknown on #8 @ demo.resid:5:17
  def #8 fn square residual, unknown on #2 @ demo.resid:1:1
  reduced to #47 lit: Int known = 144 <- beta #12 @ demo.resid:5:17
```

The call on line 5 was replaced by the constant 144 (rule `beta`); the one
on line 7 stayed residual because its argument depends on `n`, which comes
from `args`. `--summary` counts residual notes by kind.

## resid-graph

`resid-graph <file.resid> [--dot]` prints the call graph of a file.
`resid-graph <artifact> --node ID [--depth N]` prints, as Graphviz DOT, the
nodes within N edges of a node (operand, def and derive edges).
`resid-graph <artifact> --check` verifies the graph's invariants:

```text
$ resid-graph demo --check
graph check: 58 nodes (47 source, 44 residual), 0 violation(s)
```

## resid-debug

`resid-debug <binary> [-ex CMD]...` is a graph-aware debugger. Static
commands walk the artifact and the binary's DWARF: `info`, `node ID`,
`at FILE:LINE`, `sym NAME`, `kids ID`, `lowered [FN]`, `pc ADDR`, `check`.
Live commands run the program under its own ptrace backend (or gdb with
`backend gdb`): `break FILE:LINE|FN`, `run [ARGS]`, `stops N`, `step N`.

```text
$ resid-debug demo -ex "break demo.resid:8" -ex run
breakpoint 1 at demo.resid:8
stop 1 at resid_user_main+0x39 (0x11e9)
  #53 estmt residual, unknown on #52 <- rebuild #31 @ demo.resid:8:5
  unknown = 4   #23 bind unknown: Int residual, unknown on #22 @ demo.resid:7:5
  folded #48 lit: Int known = 144 <- known #25 @ demo.resid:8:16
144 4
program exited with code 0
```

At each stop the debugger maps the program counter to its node, reads
each variable from its DWARF location and pairs it with the node that
binds it, and lists the **folded** values: known nodes the compiler
computed into the code, with their values. `info` also checks that the
graph's hash matches the one recorded in the binary.

Run `residc verify` before trusting an artifact from someone else: the
graph tools do not check provenance themselves.
