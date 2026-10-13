// AWFY DeltaBlue, after the Java reference: the same constraint class
// hierarchy with virtual dispatch; strengths are their arithmetic values.
using System;
using System.Collections.Generic;

namespace Awfy.DeltaBlue {

public sealed class DeltaBlueBench : Benchmark {
  public override bool InnerBenchmarkLoop(int inner) {
    Planner.ChainTest(inner);
    Planner.ProjectionTest(inner);
    return true;
  }
}

sealed class Strength {
  readonly int arithmeticValue;
  Strength(int v) { arithmeticValue = v; }
  public static readonly Strength AbsoluteStrongest = new Strength(-10000);
  public static readonly Strength Required = new Strength(-800);
  public static readonly Strength StrongPreferred = new Strength(-600);
  public static readonly Strength Preferred = new Strength(-400);
  public static readonly Strength StrongDefault = new Strength(-200);
  public static readonly Strength Default = new Strength(0);
  public static readonly Strength WeakDefault = new Strength(500);
  public static readonly Strength AbsoluteWeakest = new Strength(10000);
  public bool SameAs(Strength s) { return arithmeticValue == s.arithmeticValue; }
  public bool Stronger(Strength s) { return arithmeticValue < s.arithmeticValue; }
  public bool Weaker(Strength s) { return arithmeticValue > s.arithmeticValue; }
  public Strength Weakest(Strength s) { return s.Weaker(this) ? s : this; }
}

enum Direction { None, Forward, Backward }

sealed class Variable {
  public int Value;
  public readonly List<AbstractConstraint> Constraints = new List<AbstractConstraint>(2);
  public AbstractConstraint DeterminedBy;
  public int Mark;
  public Strength WalkStrength = Strength.AbsoluteWeakest;
  public bool Stay = true;
  public Variable(int value = 0) { Value = value; }
  public void RemoveConstraint(AbstractConstraint c) {
    Constraints.RemoveAll(x => x == c);
    if (DeterminedBy == c) { DeterminedBy = null; }
  }
}

abstract class AbstractConstraint {
  protected readonly Strength strength;
  protected AbstractConstraint(Strength s) { strength = s; }
  public Strength Strength => strength;
  public virtual bool IsInput() { return false; }
  public abstract bool IsSatisfied();
  protected void AddConstraint(Planner planner) {
    AddToGraph();
    planner.IncrementalAdd(this);
  }
  public abstract void AddToGraph();
  public void DestroyConstraint(Planner planner) {
    if (IsSatisfied()) { planner.IncrementalRemove(this); }
    RemoveFromGraph();
  }
  public abstract void RemoveFromGraph();
  public abstract void ChooseMethod(int mark);
  public abstract void Execute();
  public abstract void InputsDo(Action<Variable> fn);
  public abstract bool InputsHasOne(Func<Variable, bool> fn);
  public bool InputsKnown(int mark) {
    return !InputsHasOne(v => !(v.Mark == mark || v.Stay || v.DeterminedBy == null));
  }
  public abstract void MarkUnsatisfied();
  public abstract Variable GetOutput();
  public abstract void Recalculate();

  public AbstractConstraint Satisfy(int mark, Planner planner) {
    AbstractConstraint overridden;
    ChooseMethod(mark);
    if (IsSatisfied()) {
      InputsDo(i => i.Mark = mark);
      Variable output = GetOutput();
      overridden = output.DeterminedBy;
      if (overridden != null) { overridden.MarkUnsatisfied(); }
      output.DeterminedBy = this;
      if (!planner.AddPropagate(this, mark)) { throw new Exception("Cycle encountered"); }
      output.Mark = mark;
    } else {
      overridden = null;
      if (strength.SameAs(Strength.Required)) {
        throw new Exception("Could not satisfy a required constraint");
      }
    }
    return overridden;
  }
}

abstract class UnaryConstraint : AbstractConstraint {
  protected readonly Variable output;
  protected bool satisfied;
  protected UnaryConstraint(Variable v, Strength s, Planner planner) : base(s) {
    output = v;
    AddConstraint(planner);
  }
  public override bool IsSatisfied() { return satisfied; }
  public override void AddToGraph() { output.Constraints.Add(this); satisfied = false; }
  public override void RemoveFromGraph() {
    if (output != null) { output.RemoveConstraint(this); }
    satisfied = false;
  }
  public override void ChooseMethod(int mark) {
    satisfied = output.Mark != mark && strength.Stronger(output.WalkStrength);
  }
  public override void InputsDo(Action<Variable> fn) { }
  public override bool InputsHasOne(Func<Variable, bool> fn) { return false; }
  public override void MarkUnsatisfied() { satisfied = false; }
  public override Variable GetOutput() { return output; }
  public override void Recalculate() {
    output.WalkStrength = strength;
    output.Stay = !IsInput();
    if (output.Stay) { Execute(); }
  }
}

sealed class StayConstraint : UnaryConstraint {
  public StayConstraint(Variable v, Strength s, Planner planner) : base(v, s, planner) { }
  public override void Execute() { }
}

sealed class EditConstraint : UnaryConstraint {
  public EditConstraint(Variable v, Strength s, Planner planner) : base(v, s, planner) { }
  public override bool IsInput() { return true; }
  public override void Execute() { }
}

abstract class BinaryConstraint : AbstractConstraint {
  protected Variable v1, v2;
  protected Direction direction;
  protected BinaryConstraint(Variable var1, Variable var2, Strength s) : base(s) {
    v1 = var1;
    v2 = var2;
    direction = Direction.None;
  }
  public override bool IsSatisfied() { return direction != Direction.None; }
  public override void AddToGraph() {
    v1.Constraints.Add(this);
    v2.Constraints.Add(this);
    direction = Direction.None;
  }
  public override void RemoveFromGraph() {
    if (v1 != null) { v1.RemoveConstraint(this); }
    if (v2 != null) { v2.RemoveConstraint(this); }
    direction = Direction.None;
  }
  public override void ChooseMethod(int mark) {
    if (v1.Mark == mark) {
      direction = (v2.Mark != mark && strength.Stronger(v2.WalkStrength)) ? Direction.Forward : Direction.None;
      return;
    }
    if (v2.Mark == mark) {
      direction = (v1.Mark != mark && strength.Stronger(v1.WalkStrength)) ? Direction.Backward : Direction.None;
      return;
    }
    if (v1.WalkStrength.Weaker(v2.WalkStrength)) {
      direction = strength.Stronger(v1.WalkStrength) ? Direction.Backward : Direction.None;
    } else {
      direction = strength.Stronger(v2.WalkStrength) ? Direction.Forward : Direction.None;
    }
  }
  public override void InputsDo(Action<Variable> fn) { fn(direction == Direction.Forward ? v1 : v2); }
  public override bool InputsHasOne(Func<Variable, bool> fn) { return fn(direction == Direction.Forward ? v1 : v2); }
  public override void MarkUnsatisfied() { direction = Direction.None; }
  public override Variable GetOutput() { return direction == Direction.Forward ? v2 : v1; }
  public override void Recalculate() {
    Variable input, output;
    if (direction == Direction.Forward) { input = v1; output = v2; } else { input = v2; output = v1; }
    output.WalkStrength = strength.Weakest(input.WalkStrength);
    output.Stay = input.Stay;
    if (output.Stay) { Execute(); }
  }
}

sealed class EqualityConstraint : BinaryConstraint {
  public EqualityConstraint(Variable var1, Variable var2, Strength s, Planner planner) : base(var1, var2, s) {
    AddConstraint(planner);
  }
  public override void Execute() {
    if (direction == Direction.Forward) { v2.Value = v1.Value; } else { v1.Value = v2.Value; }
  }
}

sealed class ScaleConstraint : BinaryConstraint {
  readonly Variable scale, offset;
  public ScaleConstraint(Variable src, Variable scale, Variable offset, Variable dest, Strength s, Planner planner)
      : base(src, dest, s) {
    this.scale = scale;
    this.offset = offset;
    AddConstraint(planner);
  }
  public override void AddToGraph() {
    v1.Constraints.Add(this);
    v2.Constraints.Add(this);
    scale.Constraints.Add(this);
    offset.Constraints.Add(this);
    direction = Direction.None;
  }
  public override void RemoveFromGraph() {
    if (v1 != null) { v1.RemoveConstraint(this); }
    if (v2 != null) { v2.RemoveConstraint(this); }
    if (scale != null) { scale.RemoveConstraint(this); }
    if (offset != null) { offset.RemoveConstraint(this); }
    direction = Direction.None;
  }
  public override void Execute() {
    if (direction == Direction.Forward) {
      v2.Value = v1.Value * scale.Value + offset.Value;
    } else {
      v1.Value = (v2.Value - offset.Value) / scale.Value;
    }
  }
  public override void InputsDo(Action<Variable> fn) {
    fn(direction == Direction.Forward ? v1 : v2);
    fn(scale);
    fn(offset);
  }
  public override void Recalculate() {
    Variable input, output;
    if (direction == Direction.Forward) { input = v1; output = v2; } else { output = v1; input = v2; }
    output.WalkStrength = strength.Weakest(input.WalkStrength);
    output.Stay = input.Stay && scale.Stay && offset.Stay;
    if (output.Stay) { Execute(); }
  }
}

sealed class Planner {
  int currentMark = 1;

  public void IncrementalAdd(AbstractConstraint c) {
    int mark = NewMark();
    AbstractConstraint overridden = c.Satisfy(mark, this);
    while (overridden != null) { overridden = overridden.Satisfy(mark, this); }
  }

  public void IncrementalRemove(AbstractConstraint c) {
    Variable output = c.GetOutput();
    c.MarkUnsatisfied();
    c.RemoveFromGraph();
    foreach (AbstractConstraint u in RemovePropagateFrom(output)) { IncrementalAdd(u); }
  }

  List<AbstractConstraint> ExtractPlanFromConstraints(List<AbstractConstraint> constraints) {
    Queue<AbstractConstraint> sources = new Queue<AbstractConstraint>();
    foreach (AbstractConstraint c in constraints) {
      if (c.IsInput() && c.IsSatisfied()) { sources.Enqueue(c); }
    }
    return MakePlan(sources);
  }

  List<AbstractConstraint> MakePlan(Queue<AbstractConstraint> todo) {
    int mark = NewMark();
    List<AbstractConstraint> plan = new List<AbstractConstraint>(15);
    while (todo.Count > 0) {
      AbstractConstraint c = todo.Dequeue();
      if (c.GetOutput().Mark != mark && c.InputsKnown(mark)) {
        plan.Add(c);
        c.GetOutput().Mark = mark;
        AddConstraintsConsumingTo(c.GetOutput(), todo);
      }
    }
    return plan;
  }

  static void ExecutePlan(List<AbstractConstraint> plan) {
    foreach (AbstractConstraint c in plan) { c.Execute(); }
  }

  static void AddConstraintsConsumingTo(Variable v, Queue<AbstractConstraint> coll) {
    AbstractConstraint determiningC = v.DeterminedBy;
    foreach (AbstractConstraint c in v.Constraints) {
      if (c != determiningC && c.IsSatisfied()) { coll.Enqueue(c); }
    }
  }

  public bool AddPropagate(AbstractConstraint c, int mark) {
    Queue<AbstractConstraint> todo = new Queue<AbstractConstraint>();
    todo.Enqueue(c);
    while (todo.Count > 0) {
      AbstractConstraint d = todo.Dequeue();
      if (d.GetOutput().Mark == mark) {
        IncrementalRemove(c);
        return false;
      }
      d.Recalculate();
      AddConstraintsConsumingTo(d.GetOutput(), todo);
    }
    return true;
  }

  void Change(Variable v, int newValue) {
    EditConstraint editC = new EditConstraint(v, Strength.Preferred, this);
    List<AbstractConstraint> plan = ExtractPlanFromConstraints(new List<AbstractConstraint> { editC });
    for (int i = 0; i < 10; i++) {
      v.Value = newValue;
      ExecutePlan(plan);
    }
    editC.DestroyConstraint(this);
  }

  int NewMark() { return ++currentMark; }

  List<AbstractConstraint> RemovePropagateFrom(Variable output) {
    List<AbstractConstraint> unsatisfied = new List<AbstractConstraint>();
    output.DeterminedBy = null;
    output.WalkStrength = Strength.AbsoluteWeakest;
    output.Stay = true;
    Queue<Variable> todo = new Queue<Variable>();
    todo.Enqueue(output);
    while (todo.Count > 0) {
      Variable v = todo.Dequeue();
      foreach (AbstractConstraint c in v.Constraints) {
        if (!c.IsSatisfied()) { unsatisfied.Add(c); }
      }
      AbstractConstraint determiningC = v.DeterminedBy;
      foreach (AbstractConstraint c in v.Constraints) {
        if (c != determiningC && c.IsSatisfied()) {
          c.Recalculate();
          todo.Enqueue(c.GetOutput());
        }
      }
    }
    // The reference sorts strongest first with a Vector.sort that implements
    // no swap: it only ever sees lists already in that order.
    return unsatisfied;
  }

  public static void ChainTest(int n) {
    Planner planner = new Planner();
    Variable[] vars = new Variable[n + 1];
    for (int i = 0; i <= n; i++) { vars[i] = new Variable(); }
    for (int i = 0; i < n; i++) { new EqualityConstraint(vars[i], vars[i + 1], Strength.Required, planner); }
    new StayConstraint(vars[n], Strength.StrongDefault, planner);
    AbstractConstraint editC = new EditConstraint(vars[0], Strength.Preferred, planner);
    List<AbstractConstraint> plan = planner.ExtractPlanFromConstraints(new List<AbstractConstraint> { editC });
    for (int i = 0; i < 100; i++) {
      vars[0].Value = i;
      ExecutePlan(plan);
      if (vars[n].Value != i) { throw new Exception("Chain test failed!"); }
    }
    editC.DestroyConstraint(planner);
  }

  public static void ProjectionTest(int n) {
    Planner planner = new Planner();
    List<Variable> dests = new List<Variable>();
    Variable scale = new Variable(10);
    Variable offset = new Variable(1000);
    Variable src = null, dst = null;
    for (int i = 1; i <= n; i++) {
      src = new Variable(i);
      dst = new Variable(i);
      dests.Add(dst);
      new StayConstraint(src, Strength.Default, planner);
      new ScaleConstraint(src, scale, offset, dst, Strength.Required, planner);
    }
    planner.Change(src, 17);
    if (dst.Value != 1170) { throw new Exception("Projection test 1 failed!"); }
    planner.Change(dst, 1050);
    if (src.Value != 5) { throw new Exception("Projection test 2 failed!"); }
    planner.Change(scale, 5);
    for (int i = 0; i < n - 1; i++) {
      if (dests[i].Value != (i + 1) * 5 + 1000) { throw new Exception("Projection test 3 failed!"); }
    }
    planner.Change(offset, 2000);
    for (int i = 0; i < n - 1; i++) {
      if (dests[i].Value != (i + 1) * 5 + 2000) { throw new Exception("Projection test 4 failed!"); }
    }
  }
}

}
