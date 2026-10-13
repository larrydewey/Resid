// AWFY Richards, after the Java reference: tasks are delegates over their
// data records, packets a linked list, null for NO_WORK/NO_TASK.
using System;

namespace Awfy.Richards {

public sealed class RichardsBench : RepeatingBenchmark {
  public override object Run() { return new Scheduler().Start(); }
  public override bool Verify(object r) { return (bool) r; }
}

static class K {
  public const int Idler = 0, Worker = 1, HandlerA = 2, HandlerB = 3, DeviceA = 4, DeviceB = 5, NumTypes = 6;
  public const int DevicePacketKind = 0, WorkPacketKind = 1;

  public static Packet Append(Packet packet, Packet queueHead) {
    packet.Link = null;
    if (queueHead == null) { return packet; }
    Packet mouse = queueHead;
    Packet link;
    while ((link = mouse.Link) != null) { mouse = link; }
    mouse.Link = packet;
    return queueHead;
  }
}

sealed class Packet {
  public const int DataSize = 4;
  public Packet Link;
  public int Identity;
  public readonly int Kind;
  public int Datum;
  public readonly int[] Data = new int[DataSize];
  public Packet(Packet link, int identity, int kind) { Link = link; Identity = identity; Kind = kind; }
}

class TaskState {
  public bool PacketPending, TaskWaiting, TaskHolding;
  public void SetPacketPendingState() { PacketPending = true; TaskWaiting = false; TaskHolding = false; }
  public void Running() { PacketPending = TaskWaiting = TaskHolding = false; }
  public void Waiting() { PacketPending = TaskHolding = false; TaskWaiting = true; }
  public void WaitingWithPacket() { TaskHolding = false; TaskWaiting = PacketPending = true; }
  public bool IsTaskHoldingOrWaiting() { return TaskHolding || (!PacketPending && TaskWaiting); }
  public bool IsWaitingWithPacket() { return PacketPending && TaskWaiting && !TaskHolding; }
  public static TaskState CreateRunning() { TaskState t = new TaskState(); t.Running(); return t; }
  public static TaskState CreateWaiting() { TaskState t = new TaskState(); t.Waiting(); return t; }
  public static TaskState CreateWaitingWithPacket() { TaskState t = new TaskState(); t.WaitingWithPacket(); return t; }
}

abstract class RBObject { }

sealed class DeviceTaskDataRecord : RBObject { public Packet Pending; }
sealed class HandlerTaskDataRecord : RBObject { public Packet WorkIn, DeviceIn; }
sealed class IdleTaskDataRecord : RBObject { public int Control = 1, Count = 10000; }
sealed class WorkerTaskDataRecord : RBObject { public int Destination = K.HandlerA, Count; }

delegate TaskControlBlock ProcessFunction(Packet work, RBObject word);

sealed class TaskControlBlock : TaskState {
  public readonly TaskControlBlock Link;
  public readonly int Identity;
  public readonly int Priority;
  Packet input;
  readonly ProcessFunction function;
  readonly RBObject handle;

  public TaskControlBlock(TaskControlBlock link, int identity, int priority, Packet initialWorkQueue,
                          TaskState initialState, ProcessFunction block, RBObject privateData) {
    Link = link;
    Identity = identity;
    Priority = priority;
    input = initialWorkQueue;
    PacketPending = initialState.PacketPending;
    TaskWaiting = initialState.TaskWaiting;
    TaskHolding = initialState.TaskHolding;
    function = block;
    handle = privateData;
  }

  public TaskControlBlock AddInputAndCheckPriority(Packet packet, TaskControlBlock oldTask) {
    if (input == null) {
      input = packet;
      PacketPending = true;
      if (Priority > oldTask.Priority) { return this; }
    } else {
      input = K.Append(packet, input);
    }
    return oldTask;
  }

  public TaskControlBlock RunTask() {
    Packet message;
    if (IsWaitingWithPacket()) {
      message = input;
      input = message.Link;
      if (input == null) { Running(); } else { SetPacketPendingState(); }
    } else {
      message = null;
    }
    return function(message, handle);
  }
}

sealed class Scheduler {
  TaskControlBlock taskList;
  TaskControlBlock currentTask;
  int currentTaskIdentity;
  readonly TaskControlBlock[] taskTable = new TaskControlBlock[K.NumTypes];
  int queuePacketCount;
  int holdCount;

  void CreateDevice(int identity, int priority, Packet workPacket, TaskState state) {
    CreateTask(identity, priority, workPacket, state, (work, word) => {
      DeviceTaskDataRecord data = (DeviceTaskDataRecord) word;
      Packet functionWork = work;
      if (functionWork == null) {
        if ((functionWork = data.Pending) == null) { return MarkWaiting(); }
        data.Pending = null;
        return QueuePacket(functionWork);
      }
      data.Pending = functionWork;
      return HoldSelf();
    }, new DeviceTaskDataRecord());
  }

  void CreateHandler(int identity, int priority, Packet workPacket, TaskState state) {
    CreateTask(identity, priority, workPacket, state, (work, word) => {
      HandlerTaskDataRecord data = (HandlerTaskDataRecord) word;
      if (work != null) {
        if (work.Kind == K.WorkPacketKind) {
          data.WorkIn = K.Append(work, data.WorkIn);
        } else {
          data.DeviceIn = K.Append(work, data.DeviceIn);
        }
      }
      Packet wp = data.WorkIn;
      if (wp == null) { return MarkWaiting(); }
      int count = wp.Datum;
      if (count >= Packet.DataSize) {
        data.WorkIn = wp.Link;
        return QueuePacket(wp);
      }
      Packet devicePacket = data.DeviceIn;
      if (devicePacket == null) { return MarkWaiting(); }
      data.DeviceIn = devicePacket.Link;
      devicePacket.Datum = wp.Data[count];
      wp.Datum = count + 1;
      return QueuePacket(devicePacket);
    }, new HandlerTaskDataRecord());
  }

  void CreateIdler(int identity, int priority, Packet work, TaskState state) {
    CreateTask(identity, priority, work, state, (w, word) => {
      IdleTaskDataRecord data = (IdleTaskDataRecord) word;
      data.Count--;
      if (data.Count == 0) { return HoldSelf(); }
      if ((data.Control & 1) == 0) {
        data.Control = data.Control / 2;
        return Release(K.DeviceA);
      }
      data.Control = (data.Control / 2) ^ 53256;
      return Release(K.DeviceB);
    }, new IdleTaskDataRecord());
  }

  void CreateWorker(int identity, int priority, Packet workPacket, TaskState state) {
    CreateTask(identity, priority, workPacket, state, (work, word) => {
      WorkerTaskDataRecord data = (WorkerTaskDataRecord) word;
      if (work == null) { return MarkWaiting(); }
      data.Destination = (data.Destination == K.HandlerA) ? K.HandlerB : K.HandlerA;
      work.Identity = data.Destination;
      work.Datum = 0;
      for (int i = 0; i < Packet.DataSize; i++) {
        data.Count++;
        if (data.Count > 26) { data.Count = 1; }
        work.Data[i] = 65 + data.Count - 1;
      }
      return QueuePacket(work);
    }, new WorkerTaskDataRecord());
  }

  void CreateTask(int identity, int priority, Packet work, TaskState state, ProcessFunction block, RBObject data) {
    TaskControlBlock t = new TaskControlBlock(taskList, identity, priority, work, state, block, data);
    taskList = t;
    taskTable[identity] = t;
  }

  public bool Start() {
    CreateIdler(K.Idler, 0, null, TaskState.CreateRunning());
    Packet workQ = new Packet(null, K.Worker, K.WorkPacketKind);
    workQ = new Packet(workQ, K.Worker, K.WorkPacketKind);
    CreateWorker(K.Worker, 1000, workQ, TaskState.CreateWaitingWithPacket());
    workQ = new Packet(null, K.DeviceA, K.DevicePacketKind);
    workQ = new Packet(workQ, K.DeviceA, K.DevicePacketKind);
    workQ = new Packet(workQ, K.DeviceA, K.DevicePacketKind);
    CreateHandler(K.HandlerA, 2000, workQ, TaskState.CreateWaitingWithPacket());
    workQ = new Packet(null, K.DeviceB, K.DevicePacketKind);
    workQ = new Packet(workQ, K.DeviceB, K.DevicePacketKind);
    workQ = new Packet(workQ, K.DeviceB, K.DevicePacketKind);
    CreateHandler(K.HandlerB, 3000, workQ, TaskState.CreateWaitingWithPacket());
    CreateDevice(K.DeviceA, 4000, null, TaskState.CreateWaiting());
    CreateDevice(K.DeviceB, 5000, null, TaskState.CreateWaiting());
    Schedule();
    return queuePacketCount == 23246 && holdCount == 9297;
  }

  TaskControlBlock FindTask(int identity) {
    TaskControlBlock t = taskTable[identity];
    if (t == null) { throw new Exception("findTask failed"); }
    return t;
  }

  TaskControlBlock HoldSelf() {
    holdCount++;
    currentTask.TaskHolding = true;
    return currentTask.Link;
  }

  TaskControlBlock QueuePacket(Packet packet) {
    TaskControlBlock t = FindTask(packet.Identity);
    queuePacketCount++;
    packet.Link = null;
    packet.Identity = currentTaskIdentity;
    return t.AddInputAndCheckPriority(packet, currentTask);
  }

  TaskControlBlock Release(int identity) {
    TaskControlBlock t = FindTask(identity);
    t.TaskHolding = false;
    return t.Priority > currentTask.Priority ? t : currentTask;
  }

  TaskControlBlock MarkWaiting() {
    currentTask.TaskWaiting = true;
    return currentTask;
  }

  void Schedule() {
    currentTask = taskList;
    while (currentTask != null) {
      if (currentTask.IsTaskHoldingOrWaiting()) {
        currentTask = currentTask.Link;
      } else {
        currentTaskIdentity = currentTask.Identity;
        currentTask = currentTask.RunTask();
      }
    }
  }
}

}
