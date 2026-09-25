{ Minimal stand-in for Benjamin Rosseaux's PasMP library.

  The Benchmarks Game binary-trees Free Pascal programs use PasMP
  (https://github.com/BeRo1985/pasmp), which is a third-party library and is
  not installed on this host.  This unit reproduces only the calls those
  programs make: TPasMP.CreateGlobalInstance, ParallelFor(Data, FromIndex,
  ToIndex, Method) and Invoke(Job).  Invoke runs Method once per index (so
  FromIndex = ToIndex for every call, i.e. granularity 1) on one thread per
  online CPU, handing out indices dynamically, and returns when all are done. }
unit PasMP;

{$mode delphi}

interface

uses
  Classes, SysUtils;

type
  PPasMPJob = ^TPasMPJob;

  TPasMPParallelForJobMethod = procedure(const Job: PPasMPJob; const ThreadIndex: Int32;
    const Data: Pointer; const FromIndex, ToIndex: SizeInt);

  TPasMPJob = record
    Method: TPasMPParallelForJobMethod;
    Data: Pointer;
    FromIndex, ToIndex: SizeInt;
    Next: Int64;
  end;

  TPasMP = class
  public
    class function CreateGlobalInstance: TPasMP;
    function ParallelFor(const Data: Pointer; const FromIndex, ToIndex: SizeInt;
      const Method: Pointer): PPasMPJob;
    procedure Invoke(const Job: PPasMPJob);
  end;

implementation

function sysconf(name: longint): PtrInt; cdecl; external 'c';

const
  _SC_NPROCESSORS_ONLN = 84;

type
  TJobThread = class(TThread)
  private
    FJob: PPasMPJob;
    FIndex: Int32;
  protected
    procedure Execute; override;
  public
    constructor Create(AJob: PPasMPJob; AIndex: Int32);
  end;

var
  GInstance: TPasMP = nil;

procedure RunJob(Job: PPasMPJob; ThreadIndex: Int32);
var
  i: Int64;
begin
  while true do
  begin
    i := InterLockedIncrement64(Job^.Next);
    if i > Job^.ToIndex then break;
    Job^.Method(Job, ThreadIndex, Job^.Data, i, i);
  end;
end;

constructor TJobThread.Create(AJob: PPasMPJob; AIndex: Int32);
begin
  FJob := AJob;
  FIndex := AIndex;
  FreeOnTerminate := false;
  inherited Create(false);
end;

procedure TJobThread.Execute;
begin
  RunJob(FJob, FIndex);
end;

class function TPasMP.CreateGlobalInstance: TPasMP;
begin
  if GInstance = nil then GInstance := TPasMP.Create;
  Result := GInstance;
end;

function TPasMP.ParallelFor(const Data: Pointer; const FromIndex, ToIndex: SizeInt;
  const Method: Pointer): PPasMPJob;
begin
  New(Result);
  Result^.Method := TPasMPParallelForJobMethod(Method);
  Result^.Data := Data;
  Result^.FromIndex := FromIndex;
  Result^.ToIndex := ToIndex;
  Result^.Next := FromIndex - 1;
end;

procedure TPasMP.Invoke(const Job: PPasMPJob);
var
  threads: array of TThread;
  i, n: Integer;
begin
  n := sysconf(_SC_NPROCESSORS_ONLN) - 1; { the calling thread works too }
  if n > Job^.ToIndex - Job^.FromIndex then n := Job^.ToIndex - Job^.FromIndex;
  if n < 0 then n := 0;
  SetLength(threads, n);
  for i := 0 to n - 1 do threads[i] := TJobThread.Create(Job, i + 1);
  RunJob(Job, 0);
  for i := 0 to n - 1 do
  begin
    threads[i].WaitFor;
    threads[i].Free;
  end;
  Dispose(Job);
end;

finalization
  FreeAndNil(GInstance);
end.
