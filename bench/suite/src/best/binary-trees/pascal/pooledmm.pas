{ Minimal stand-in for the Lazarus LazUtils "PooledMM" unit.

  The Benchmarks Game binary-trees Free Pascal programs use
  PooledMM.TNonFreePooledMemManager, which ships with Lazarus (LazUtils), not
  with the Free Pascal compiler, and is not installed on this host.  This unit
  reproduces the part those programs use: Create(ItemSize), NewItem, Clear and
  Free.  As in LazUtils, items are carved sequentially out of chunks obtained
  with GetMem, chunk size doubles as the pool grows, individual items are never
  freed, and Clear releases every chunk. }
unit PooledMM;

{$mode objfpc}{$H+}

interface

type
  TNonFreePooledMemManager = class
  private
    FItemSize: PtrUInt;
    FChunks: array of Pointer;
    FChunkCount: SizeInt;
    FCurItem: PByte;
    FEndItem: PByte;
    FCurSize: PtrUInt;
  public
    constructor Create(TheItemSize: PtrUInt);
    destructor Destroy; override;
    procedure Clear;
    function NewItem: Pointer; inline;
    procedure NewChunk;
  end;

implementation

const
  MaxChunkSize = 4 * 1024 * 1024;

constructor TNonFreePooledMemManager.Create(TheItemSize: PtrUInt);
begin
  inherited Create;
  FItemSize := (TheItemSize + SizeOf(Pointer) - 1) and not PtrUInt(SizeOf(Pointer) - 1);
  FCurSize := FItemSize * 4;
end;

destructor TNonFreePooledMemManager.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TNonFreePooledMemManager.Clear;
var
  i: SizeInt;
begin
  for i := 0 to FChunkCount - 1 do FreeMem(FChunks[i]);
  FChunkCount := 0;
  FCurItem := nil;
  FEndItem := nil;
  FCurSize := FItemSize * 4;
end;

procedure TNonFreePooledMemManager.NewChunk;
begin
  if FCurSize < MaxChunkSize then FCurSize := FCurSize * 2;
  if FChunkCount = Length(FChunks) then SetLength(FChunks, 2 * FChunkCount + 16);
  GetMem(FCurItem, FCurSize);
  FChunks[FChunkCount] := FCurItem;
  Inc(FChunkCount);
  FEndItem := FCurItem + FCurSize;
end;

function TNonFreePooledMemManager.NewItem: Pointer;
begin
  if FCurItem + FItemSize > FEndItem then NewChunk;
  Result := FCurItem;
  Inc(FCurItem, FItemSize);
end;

end.
