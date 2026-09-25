{ binary-trees (Benchmarks Game algorithm), single-threaded, plain Free Pascal.
  Every node is individually allocated with New and released with Dispose. }
program binarytrees;
{$mode objfpc}

type
  PNode = ^TNode;
  TNode = record
    left, right: PNode;
  end;

function Make(depth: longint): PNode;
begin
  New(Result);
  if depth > 0 then
  begin
    Result^.left := Make(depth - 1);
    Result^.right := Make(depth - 1);
  end
  else
  begin
    Result^.left := nil;
    Result^.right := nil;
  end;
end;

function Check(t: PNode): longint;
begin
  if t^.left <> nil then
    Result := 1 + Check(t^.left) + Check(t^.right)
  else
    Result := 1;
end;

procedure Free(t: PNode);
begin
  if t^.left <> nil then
  begin
    Free(t^.left);
    Free(t^.right);
  end;
  Dispose(t);
end;

const
  MIN_DEPTH = 4;

var
  n, maxDepth, stretchDepth, depth, iterations, i, c, code: longint;
  t, longLived: PNode;
begin
  n := 10;
  if ParamCount >= 1 then Val(ParamStr(1), n, code);
  maxDepth := n;
  if maxDepth < MIN_DEPTH + 2 then maxDepth := MIN_DEPTH + 2;
  stretchDepth := maxDepth + 1;

  t := Make(stretchDepth);
  WriteLn('stretch tree of depth ', stretchDepth, #9' check: ', Check(t));
  Free(t);

  longLived := Make(maxDepth);
  depth := MIN_DEPTH;
  while depth <= maxDepth do
  begin
    iterations := 1 shl (maxDepth - depth + MIN_DEPTH);
    c := 0;
    for i := 1 to iterations do
    begin
      t := Make(depth);
      c := c + Check(t);
      Free(t);
    end;
    WriteLn(iterations, #9' trees of depth ', depth, #9' check: ', c);
    Inc(depth, 2);
  end;
  WriteLn('long lived tree of depth ', maxDepth, #9' check: ', Check(longLived));
  Free(longLived);
end.
