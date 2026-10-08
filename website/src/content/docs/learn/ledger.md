---
title: The settlement ledger
description: The crown example — exact money, named behaviors, compile-time rules, untrusted native code, and signed provenance in one program.
---

A language is best judged by what its hardest program looks like. Resid's
is a **settlement ledger**: a double-entry journal whose money is exact,
whose posting rules are compile-time knowledge, whose fee schedule is
untrusted native code, and whose release binary can prove where it came
from.

The whole program is [`examples/ledger.resid`](https://github.com/larrydewey/Resid/blob/master/examples/ledger.resid),
with its definitions and tests in
[`examples/ledger_core.resid`](https://github.com/larrydewey/Resid/blob/master/examples/ledger_core.resid)
and its native module in
[`examples/ledger/fees.c`](https://github.com/larrydewey/Resid/blob/master/examples/ledger/fees.c).

## The core, in one runnable program

```resid
type Account = Cash | Checking | Savings | Fees;

Str acct_name(Account a) {
    return match a {
        Cash => "cash", Checking => "checking", Savings => "savings", Fees => "fees"
    };
}
Show(Account) = acct_name;

Int acct_rank(Account a) { return match a { Cash => 0, Checking => 1, Savings => 2, Fees => 3 }; }
Int acct_cmp(Account a, Account b) { return acct_rank(a) - acct_rank(b); }
Account acct_least(Account a, Account b) { return if (acct_rank(a) <= acct_rank(b)) { a } else { b }; }
Account acct_greatest(Account a, Account b) { return if (acct_rank(a) >= acct_rank(b)) { a } else { b }; }
Ord(Account) = { .compare = acct_cmp, .least = acct_least, .greatest = acct_greatest };

type Entry = { Str memo; Account debit; Account credit; Dec(4) amount; };

behavior Amount(T) { Dec(4) amount(T e); }
Dec(4) entry_amount(Entry e) { return e.amount; }
Amount(Entry) = entry_amount;

@needs(Amount(T))
Dec(4) total(List(T) xs) { return total_at(xs, 0, d4(0)); }
@needs(Amount(T))
Dec(4) total_at(List(T) xs, Int i, Dec(4) acc) {
    if (i >= xs.len()) { return acc; }
    return total_at(xs, i + 1, acc + amount(xs[i]));
}

Int schedule_bps(Int klass) {
    return if (klass <= 0) { 25 } else { if (klass == 1) { 50 } else { 100 } };
}

Int main() {
    List(Entry) es = [
        Entry {.memo = "opening", .debit = Cash, .credit = Checking, .amount = 12.34m},
        Entry {.memo = "fee", .debit = Checking, .credit = Fees, .amount = 0.3000m}
    ];
    comptime_print(schedule_bps(2));
    println(f"{sort([Fees, Cash, Savings])}");
    println(f"{total(es)}");
    println(f"{schedule_bps(1)}");
    return 0;
}
```

```text
[cash, savings, fees]
12.64
50
```

## What each piece is proving

**Money is exact.** `Dec(4)` holds four significant decimal digits. There
is no binary float in the ledger, so `12.34 + 0.3000` is exactly `12.64`,
and a hundredth of a cent never appears out of nowhere. Mixing `Dec` with
`Int` or `Float` is a compile error, not a silent coercion.

**Show and Ord are named.** How an account prints and how it sorts are
knowledge with a name, declared outside the type, not methods baked into
it. `f"{a}"` and `sort(xs)` pick them up at compile time.

**`total` is generic over a behavior.** It adds the amount of *any* `T`
that has an `Amount(T)` instance; `Entry` is one such type. The copy of
`total` for `Entry` is instantiated before reduction, so the loop is
emitted with `entry_amount` inlined.

**The rule schedule folds away.** `schedule_bps` is written as an if-chain
precisely so the reducer can evaluate it: `comptime_print(schedule_bps(2))`
prints `100` *while compiling*, and `known(schedule_bps(1))` proves the
value is a compile-time constant. The release binary carries no schedule
at all — only the literal it reduced to.

## The parts that stay residual, on purpose

The amounts (and the fee class) exist only at run time, so they are
*residual*: the compiler lowers them, and records why in the knowledge
graph. You can ask:

```text
$ residc examples/ledger.resid -o ledger \
      -native fees=examples/ledger/fees.ll
$ ./ledger post wire cash checking 250.00 2
wire: checking <- cash 250.0
escrow fee (class 2): 2.500
balances: true
$ ./ledger explain
12 residual note(s) remain in ./ledger
the journal's rule schedule folded away; what stayed residual
is the amount (and fee class) that only exist at run time:
  resid-why ./ledger --summary
$ resid-why ledger --summary
residual summary:
  provider-call: 12
```

## The fee schedule is native, and untrusted

The one thing the ledger does not trust is the fee schedule, so it is not
Resid. It is C, compiled to freestanding LLVM IR text and linked with
`@link("fees")`. Every call runs in a fresh, seccomp-confined process that
sees only its argument, keeps nothing between calls, and holds no
authority:

```resid
@link("fees") Int esc_bps(Int klass) {}

@requires(native_fees)
Dec(4) escrow_fee(Dec(4) amt, Int klass) {
    return amt * d4(esc_bps(klass)) / d4(10000);
}
```

Only an `Int` crosses the boundary; the exact `Dec` arithmetic happens
afterwards, in Resid. Reaching the module at all is a capability
(`native_fees`), granted by `main`'s `@requires` and checked transitively.

## Provenance

A release build signs the binary: the source it came from, the code hash,
the sidecars, the compiler that built it, the grant, and the SHA-256 of
each native artifact. `residc verify` re-derives what it can and tells
that apart from what the signer merely asserted:

```text
$ residc verify ledger
verify: ok (kid …, code …, trust supplied)
attestation: native module fees from an artifact with SHA-256 …
attestation: grant [args, filesystem(readonly), native_fees]
```

Clone the repository and run the suite that proves all of this:
`tests/ledger/run.sh` builds the ledger in both profiles, runs the
library's inline tests, checks the reduction output, exercises the native
schedule, and verifies — and then tampers with — the signed binary.
