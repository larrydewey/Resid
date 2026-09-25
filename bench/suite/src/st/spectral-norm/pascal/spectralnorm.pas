{ spectral-norm (Benchmarks Game algorithm), single-threaded, plain Free Pascal. }
program spectralnorm;
{$mode objfpc}

type
  TVec = array of double;

var
  n: longint;

function A(i, j: longint): double; inline;
begin
  A := 1.0 / double((i + j) * (i + j + 1) div 2 + i + 1);
end;

procedure MulAv(const x: TVec; var y: TVec);
var
  i, j: longint;
  s: double;
begin
  for i := 0 to n - 1 do
  begin
    s := 0;
    for j := 0 to n - 1 do s := s + A(i, j) * x[j];
    y[i] := s;
  end;
end;

procedure MulAtv(const x: TVec; var y: TVec);
var
  i, j: longint;
  s: double;
begin
  for i := 0 to n - 1 do
  begin
    s := 0;
    for j := 0 to n - 1 do s := s + A(j, i) * x[j];
    y[i] := s;
  end;
end;

var
  u, v, tmp: TVec;
  i, code: longint;
  vbv, vv: double;

procedure MulAtAv(const x: TVec; var y: TVec);
begin
  MulAv(x, tmp);
  MulAtv(tmp, y);
end;

begin
  n := 100;
  if ParamCount >= 1 then Val(ParamStr(1), n, code);
  SetLength(u, n);
  SetLength(v, n);
  SetLength(tmp, n);
  for i := 0 to n - 1 do u[i] := 1.0;
  for i := 1 to 10 do
  begin
    MulAtAv(u, v);
    MulAtAv(v, u);
  end;
  vbv := 0;
  vv := 0;
  for i := 0 to n - 1 do
  begin
    vbv := vbv + u[i] * v[i];
    vv := vv + v[i] * v[i];
  end;
  WriteLn(Sqrt(vbv / vv):0:9);
end.
