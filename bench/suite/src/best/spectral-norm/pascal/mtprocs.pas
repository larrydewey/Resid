{ Minimal stand-in for the Lazarus "MTProcs" unit (multithreadprocs package).

  The Benchmarks Game Free Pascal programs use MTProcs, which ships with
  Lazarus, not with the Free Pascal compiler, and is not installed on this
  host.  This unit implements the one call those programs use,
  ProcThreadPool.DoParallel, with the same signature and semantics: run
  AProc(Index, Data, Item) for every Index in [StartIndex, EndIndex] on a
  pool of worker threads (one per logical CPU) and return when all are done.
  Indices are handed out dynamically through an atomic counter.  Workers are
  created once and parked on events between calls. }
unit mtprocs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TMultiThreadProcItem = class
  end;

  TMTProcedure = procedure(Index: PtrInt; Data: Pointer; Item: TMultiThreadProcItem);

  TProcThreadPool = class
  private
    FWorkers: array of TThread;
    FStartEvents: array of PRTLEvent;
    FDoneEvents: array of PRTLEvent;
    FProc: TMTProcedure;
    FData: Pointer;
    FNext: Int64;
    FLast: PtrInt;
    FQuit: boolean;
    procedure RunItems(Item: TMultiThreadProcItem);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DoParallel(AProc: TMTProcedure; StartIndex, EndIndex: PtrInt;
      Data: Pointer = nil);
  end;

function ProcThreadPool: TProcThreadPool;

implementation

{ FPC 3.2.2's TThread.ProcessorCount reports 1 on Linux; like Lazarus'
  mtpcpu.GetSystemThreadCount, ask libc for the online CPU count. }
function sysconf(name: longint): PtrInt; cdecl; external 'c';

const
  _SC_NPROCESSORS_ONLN = 84;

type
  TWorker = class(TThread)
  private
    FPool: TProcThreadPool;
    FSlot: integer;
  protected
    procedure Execute; override;
  public
    constructor Create(APool: TProcThreadPool; ASlot: integer);
  end;

var
  GPool: TProcThreadPool = nil;

function ProcThreadPool: TProcThreadPool;
begin
  if GPool = nil then GPool := TProcThreadPool.Create;
  Result := GPool;
end;

constructor TWorker.Create(APool: TProcThreadPool; ASlot: integer);
begin
  FPool := APool;
  FSlot := ASlot;
  FreeOnTerminate := false;
  inherited Create(false);
end;

procedure TWorker.Execute;
var
  item: TMultiThreadProcItem;
begin
  item := TMultiThreadProcItem.Create;
  while true do
  begin
    RTLEventWaitFor(FPool.FStartEvents[FSlot]);
    if FPool.FQuit then break;
    FPool.RunItems(item);
    RTLEventSetEvent(FPool.FDoneEvents[FSlot]);
  end;
  item.Free;
end;

constructor TProcThreadPool.Create;
var
  i, n: integer;
begin
  inherited Create;
  n := sysconf(_SC_NPROCESSORS_ONLN) - 1; { the calling thread works too }
  if n < 0 then n := 0;
  SetLength(FWorkers, n);
  SetLength(FStartEvents, n);
  SetLength(FDoneEvents, n);
  for i := 0 to n - 1 do
  begin
    FStartEvents[i] := RTLEventCreate;
    FDoneEvents[i] := RTLEventCreate;
  end;
  for i := 0 to n - 1 do
    FWorkers[i] := TWorker.Create(Self, i);
end;

destructor TProcThreadPool.Destroy;
var
  i: integer;
begin
  FQuit := true;
  for i := 0 to High(FWorkers) do RTLEventSetEvent(FStartEvents[i]);
  for i := 0 to High(FWorkers) do
  begin
    FWorkers[i].WaitFor;
    FWorkers[i].Free;
    RTLEventDestroy(FStartEvents[i]);
    RTLEventDestroy(FDoneEvents[i]);
  end;
  inherited Destroy;
end;

procedure TProcThreadPool.RunItems(Item: TMultiThreadProcItem);
var
  idx: PtrInt;
begin
  while true do
  begin
    idx := InterLockedIncrement64(FNext);
    if idx > FLast then break;
    FProc(idx, FData, Item);
  end;
end;

procedure TProcThreadPool.DoParallel(AProc: TMTProcedure; StartIndex, EndIndex: PtrInt;
  Data: Pointer);
var
  i: integer;
  item: TMultiThreadProcItem;
begin
  if EndIndex < StartIndex then exit;
  FProc := AProc;
  FData := Data;
  FLast := EndIndex;
  FNext := StartIndex - 1;
  WriteBarrier;
  for i := 0 to High(FWorkers) do RTLEventSetEvent(FStartEvents[i]);
  item := TMultiThreadProcItem.Create;
  RunItems(item);
  item.Free;
  for i := 0 to High(FWorkers) do RTLEventWaitFor(FDoneEvents[i]);
  ReadBarrier;
end;

finalization
  FreeAndNil(GPool);
end.
