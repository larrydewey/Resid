#!/usr/bin/env python3
"""Random Resid programs for the ownership differential suite.

gen.py SEED > prog.resid

Each program defines a few record types (some with list fields, so they
carry a header), helper functions that rebuild, take from lists, keep and
pass records on, and a main that builds values, aliases them through
bindings, lists, records and sums, calls the helpers in random orders and
prints a checksum of everything still reachable. Compiled with ownership
off and on, the outputs must agree.
"""
import random
import sys

R = random.Random(int(sys.argv[1]) if len(sys.argv) > 1 else 0)

TYPES = {
    "Pa": [("x", "Int"), ("y", "Int")],
    "Pb": [("x", "Int"), ("xs", "List(Int)")],
    "Pc": [("a", "Pa"), ("n", "Int")],
    "Pd": [("ps", "List(Pa)"), ("k", "Int")],
    "Pe": [("ls", "List(List(Int))"), ("k", "Int")],
}
REC = list(TYPES)


def fields(t):
    return TYPES[t]


def lit(t, depth=0):
    """A literal of type t from small constants and rt values."""
    if t == "Int":
        return R.choice(["0", "1", "2", "rt 3", "rt 5", "7"])
    if t == "List(Int)":
        return "[" + ", ".join(lit("Int") for _ in range(R.randint(1, 3))) + "]"
    if t == "List(Pa)":
        return "[" + ", ".join(lit("Pa", depth + 1) for _ in range(R.randint(1, 3))) + "]"
    if t == "List(Pc)":
        return "[" + ", ".join(lit("Pc", depth + 1) for _ in range(R.randint(1, 3))) + "]"
    if t == "List(List(Int))":
        return "[" + ", ".join(lit("List(Int)") for _ in range(R.randint(1, 3))) + "]"
    return t + " {" + ", ".join(f".{f} = {lit(ft, depth + 1)}" for f, ft in fields(t)) + "}"


def checksum(t, e):
    """An Int expression summarising every scalar reachable from e."""
    if t == "Int":
        return e
    if t == "List(Int)":
        return f"lsum({e}, 0, 0)"
    if t == "List(Pa)":
        return f"lpa({e}, 0, 0)"
    if t == "List(Pc)":
        return f"lpc({e}, 0, 0)"
    if t == "List(List(Int))":
        return f"lll({e}, 0, 0)"
    return " + ".join(f"({checksum(ft, e + '.' + f)}) * {i + 2}" for i, (f, ft) in enumerate(fields(t)))


HELPERS = """
Int lsum(List(Int) xs, Int i, Int acc) {
    if (i >= xs.len()) { return acc; }
    return lsum(xs, i + 1, acc * 3 + xs[i]);
}
Int lpa(List(Pa) xs, Int i, Int acc) {
    if (i >= xs.len()) { return acc; }
    return lpa(xs, i + 1, acc * 5 + xs[i].x * 7 + xs[i].y);
}
Int lll(List(List(Int)) xs, Int i, Int acc) {
    if (i >= xs.len()) { return acc; }
    return lll(xs, i + 1, acc * 3 + lsum(xs[i], 0, 0));
}
// Lists written through the records and slots that hold them.
Pb pb_seti(Pb b, Int i, Int v) {
    if (b.xs.len() == 0) { return b; }
    return Pb {.x = b.x, .xs = b.xs.with(i % b.xs.len(), v)};
}
Int pb_alias(Pb b, Int i) {
    List(Int) c = b.xs;
    Pb b2 = pb_push(pb_seti(b, i, 42), i);
    return lsum(c, 0, 0) * 7 + lsum(b2.xs, 0, 0);
}
List(Int) set_add(List(Int) s, Int x) { return if (s.contains(x)) { s } else { s.concat([x]) }; }
Pe pe_add(Pe e, Int i, Int v) {
    if (e.ls.len() == 0) { return e; }
    Int j = i % e.ls.len();
    return Pe {.ls = e.ls.with(j, set_add(e.ls[j], v)), .k = e.k + 1};
}
Pe pe_loop(Pe e, Int n) {
    if (n <= 0) { return e; }
    return pe_loop(pe_add(e, n, n * 5), n - 1);
}
Pe pe_dup(Pe e) {
    if (e.ls.len() < 2) { return e; }
    return Pe {.ls = e.ls.with(0, e.ls[1]), .k = e.k};
}
Int pe_alias(Pe e, Int i) {
    List(List(Int)) keep = e.ls;
    Pe e2 = pe_add(pe_add(e, i, 9), i + 1, 8);
    return lll(keep, 0, 0) * 5 + lll(e2.ls, 0, 0);
}
Pe pe_fill(Int n, Int k) {
    List(Int) one = [k];
    return Pe {.ls = pe_fill_loop(n, one, ListBuf()), .k = k};
}
List(List(Int)) pe_fill_loop(Int n, List(Int) v, ListBuf(List(Int)) acc) {
    if (n <= 0) { return acc.finish(); }
    return pe_fill_loop(n - 1, v, acc.push(v));
}
Pe pe_big(Pe e, Int n) {
    if (e.ls.len() == 0) { return e; }
    return pe_loop(Pe {.ls = e.ls.with(0, lrange(0, 300, ListBuf())), .k = e.k}, n);
}
List(Int) lrange(Int i, Int n, ListBuf(Int) acc) {
    if (i >= n) { return acc.finish(); }
    return lrange(i + 1, n, acc.push(i));
}
Int lpc(List(Pc) xs, Int i, Int acc) {
    if (i >= xs.len()) { return acc; }
    return lpc(xs, i + 1, acc * 5 + xs[i].a.x * 7 + xs[i].a.y * 3 + xs[i].n);
}
Pa pa_bump(Pa p) { return Pa {.x = p.x + 1, .y = p.y}; }
Pa pa_keep(Pa p) { return p; }
Pa pa_pick(Pa p, Pa q, Int c) { return if (c > 2) { p } else { q }; }
Pb pb_push(Pb b, Int v) { return Pb {.x = b.x + v, .xs = b.xs.concat([v])}; }
Pb pb_set(Pb b, Int v) { return Pb {.x = b.x, .xs = b.xs.with(0, v)}; }
Pc pc_bump(Pc c) { return Pc {.a = pa_bump(c.a), .n = c.n + 1}; }
Pc pc_swap(Pc c, Pa a) { return Pc {.a = a, .n = c.n}; }
Pd pd_bump(Pd d, Int i) {
    if (i >= d.ps.len()) { return d; }
    Pa p = d.ps[i];
    return Pd {.ps = d.ps.with(i, pa_bump(p)), .k = d.k + p.x};
}
Pd pd_loop(Pd d, Int i, Int n) {
    if (i >= n) { return d; }
    return pd_loop(pd_bump(d, i % d.ps.len()), i + 1, n);
}
Pa pd_get(Pd d, Int i) { return d.ps[i % d.ps.len()]; }
Pd pd_put(Pd d, Int i, Pa p) { return Pd {.ps = d.ps.with(i % d.ps.len(), p), .k = d.k}; }
Int pa_sum(Pa p) { return p.x * 3 + p.y; }
Pa pa_twice(Pa p) { return pa_bump(pa_bump(p)); }
Pa pa_both(Pa p, Pa q) { return Pa {.x = p.x + q.x, .y = pa_bump(q).y}; }
Pa pa_chain(Pa p, Int n) {
    if (n <= 0) { return p; }
    return pa_chain(pa_bump(p), n - 1);
}
Pb pb_loop(Pb b, Int n) {
    if (n <= 0) { return b; }
    return pb_loop(pb_push(b, n), n - 1);
}
Pa opt_or(Option(Pa) o, Pa d) { return match o { Some(p) => p, None => d }; }
Pd pd_swap(Pd d) {
    if (d.ps.len() < 2) { return d; }
    Pa a = d.ps[0];
    return Pd {.ps = d.ps.with(0, d.ps[1]).with(1, a), .k = d.k};
}
Pc pc_mix(Pc c, Pa a) {
    Pa b = pa_both(c.a, a);
    return Pc {.a = b, .n = c.n + b.x};
}
Pc lc_get(List(Pc) cs, Int i) { return cs[i % cs.len()]; }
Pc lc_first_bump(List(Pc) cs) {
    if (cs.len() == 0) { return Pc {.a = Pa {.x = 0, .y = 0}, .n = 0}; }
    Pc q = pc_bump(cs[0]);
    return q;
}
List(Pc) lc_set(List(Pc) cs, Int i, Pc c) { return cs.with(i % cs.len(), c); }
Pa lc_in(List(Pc) cs, Int i) {
    Pc c = cs[i % cs.len()];
    return pa_bump(c.a);
}
Pc lc_deep(List(Pc) cs, Int i) {
    if (cs.len() == 0) { return Pc {.a = Pa {.x = 0, .y = 0}, .n = 0}; }
    Pc c = cs[i % cs.len()];
    Pa b = pa_bump(c.a);
    return Pc {.a = b, .n = c.n};
}
// Long loops that allocate every iteration: their regions grow, compact
// and are taken lazily, with the carried records rebuilt in place.
Pa pa_spin(Pa p, Int n) {
    if (n <= 0) { return p; }
    List(Int) junk = [n, n + 1, n + 2];
    return pa_spin(Pa {.x = p.x + junk[1] % 3, .y = p.y}, n - 1);
}
Pc pc_spin(Pc c, Int n) {
    if (n <= 0) { return c; }
    Pa b = pa_bump(c.a);
    List(Int) junk = [b.x, n];
    return pc_spin(Pc {.a = b, .n = c.n + junk[1] % 2}, n - 1);
}
Pb pb_spin(Pb b, Int n) {
    if (n <= 0) { return b; }
    return pb_spin(Pb {.x = b.x + 1, .xs = b.xs.with(0, n % 7)}, n - 1);
}
Pc pc_nest(Pc c, Int n) {
    if (n <= 0) { return c; }
    return pc_nest(pc_spin(c, 300), n - 1);
}
Pa pa_cond(Pa p, Pa q) { return if (p.x > q.x) { pa_bump(p) } else { Pa {.x = q.x, .y = p.y} }; }
"""

# Operations: (result type, template over earlier bindings of given types).
OPS = [
    ("Pa", ["Pa"], "pa_bump({0})"),
    ("Pa", ["Pa"], "pa_keep({0})"),
    ("Pa", ["Pa", "Pa"], "pa_pick({0}, {1}, {i})"),
    ("Pa", ["Pa"], "pa_twice({0})"),
    ("Pa", ["Pa", "Pa"], "pa_both({0}, {1})"),
    ("Pa", ["Pa"], "Pa {{.x = {0}.x + {i}, .y = {0}.y}}"),
    ("Pa", ["Pc"], "{0}.a"),
    ("Pa", ["Pd"], "pd_get({0}, {i})"),
    ("Pb", ["Pb"], "pb_push({0}, {i})"),
    ("Pb", ["Pb"], "pb_set({0}, {i})"),
    ("Pb", ["Pb"], "Pb {{.x = {0}.x * 2, .xs = {0}.xs}}"),
    ("Pc", ["Pc"], "pc_bump({0})"),
    ("Pc", ["Pc", "Pa"], "pc_swap({0}, {1})"),
    ("Pc", ["Pa"], "Pc {{.a = {0}, .n = {i}}}"),
    ("Pd", ["Pd"], "pd_bump({0}, {i})"),
    ("Pd", ["Pd"], "pd_loop({0}, 0, {i} + 2)"),
    ("Pd", ["Pd", "Pa"], "pd_put({0}, {i}, {1})"),
    ("Pd", ["Pa", "Pa"], "Pd {{.ps = [{0}, {1}], .k = {i}}}"),
    ("Int", ["Pa"], "pa_sum({0})"),
    ("Pa", ["Pa"], "pa_chain({0}, {i})"),
    ("Pb", ["Pb"], "pb_loop({0}, {i})"),
    ("Pa", ["Opt", "Pa"], "opt_or({0}, {1})"),
    ("Pd", ["Pd"], "pd_swap({0})"),
    ("Pc", ["Pc", "Pa"], "pc_mix({0}, {1})"),
    ("Pa", ["Pa", "Pa"], "pa_cond({0}, {1})"),
    ("Pa", ["Pa", "Pa"], "if ({0}.x > {i}) {{ pa_bump({0}) }} else {{ {1} }}"),
    ("Pc", ["Pc"], "Pc {{.a = pa_bump({0}.a), .n = {0}.n + {i}}}"),
    ("Opt", ["Pa"], "Some({0})"),
    ("Pa", ["Pa"], "pa_spin({0}, 3000 + {i} * 1000)"),
    ("Pc", ["Pc"], "pc_spin({0}, 2000 + {i} * 500)"),
    ("Pb", ["Pb"], "pb_spin({0}, 1500 + {i} * 700)"),
    ("Pc", ["Pc"], "pc_nest({0}, 5 + {i})"),
    ("List(Pc)", ["Pc", "Pc"], "[{0}, {1}]"),
    ("Pc", ["List(Pc)"], "lc_get({0}, {i})"),
    ("Pc", ["List(Pc)"], "lc_first_bump({0})"),
    ("List(Pc)", ["List(Pc)", "Pc"], "lc_set({0}, {i}, {1})"),
    ("Pa", ["List(Pc)"], "lc_in({0}, {i})"),
    ("Pc", ["List(Pc)"], "lc_deep({0}, {i})"),
    ("Pc", ["List(Pc)"], "{0}[{i} % {0}.len()]"),
    ("Pb", ["Pb"], "pb_seti({0}, {i}, {i} + 3)"),
    ("Int", ["Pb"], "pb_alias({0}, {i})"),
    ("Pe", ["Pe"], "pe_add({0}, {i}, {i} * 2)"),
    ("Pe", ["Pe"], "pe_loop({0}, 4 + {i})"),
    ("Pe", ["Pe"], "pe_dup({0})"),
    ("Int", ["Pe"], "pe_alias({0}, {i})"),
    ("Pe", [], "pe_fill(3, {i})"),
    ("Pe", ["Pe"], "pe_big({0}, 5 + {i})"),
    ("List(Int)", ["Pe"], "{0}.ls[{i} % {0}.ls.len()]"),
    ("List(List(Int))", ["Pe"], "{0}.ls"),
    ("Pe", ["List(List(Int))"], "Pe {{.ls = {0}, .k = {i}}}"),
    ("Pa", ["List(Pc)"], "{0}[{i} % {0}.len()].a"),
]


def main():
    out = ["type " + t + " = { " + " ".join(f"{ft} {f};" for f, ft in fs) + " };" for t, fs in TYPES.items()]
    out.append(HELPERS)
    out.append("Int unwrap(Option(Pa) o) { return match o { Some(p) => p.x * 11 + p.y, None => 0 }; }")
    out.append("Int main() {")
    binds = []  # (name, type)
    for t in REC + ["List(Pc)", "List(List(Int))"]:
        for _ in range(2):
            n = f"v{len(binds)}"
            out.append(f"    {t} {n} = {lit(t)};")
            binds.append((n, t))
    for step in range(R.randint(6, 18)):
        rt, args, tpl = R.choice(OPS)
        pools = [[b for b in binds if b[1] == a] for a in args]
        if any(not p for p in pools):
            continue
        picked = [R.choice(p)[0] for p in pools]
        e = tpl.format(*picked, i=R.randint(0, 4))
        n = f"v{len(binds)}"
        if rt == "Opt":
            out.append(f"    Option(Pa) {n} = {e};")
            binds.append((n, "Opt"))
        elif rt == "Int":
            out.append(f"    Int w{step} = {e};")
            out.append(f"    println(f\"i{step} {{w{step}}}\");")
            continue
        else:
            out.append(f"    {rt} {n} = {e};")
            binds.append((n, rt))
        # Sometimes read an earlier value right away (keeps it live).
        if R.random() < 0.3:
            old, ot = R.choice(binds)
            if ot in TYPES or ot == "List(Pc)" or ot == "List(List(Int))":
                out.append(f"    println(f\"r{step} {{{checksum(ot, old)}}}\");")
    # Print everything, in a random order.
    order = binds[:]
    R.shuffle(order)
    for n, t in order:
        if t == "Opt":
            out.append(f"    println(f\"{n} {{unwrap({n})}}\");")
        else:
            out.append(f"    println(f\"{n} {{{checksum(t, n)}}}\");")
    out.append("    return 0;")
    out.append("}")
    print("\n".join(out))


main()
