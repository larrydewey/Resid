{ fannkuch-redux (Benchmarks Game algorithm), single-threaded, plain Free Pascal. }
program fannkuchredux;
{$mode objfpc}

var
  n, i, j, k, t, flips, maxflips, checksum, permcount, r, code: longint;
  perm, perm1, cnt: array of longint;
  done: boolean;
begin
  n := 7;
  if ParamCount >= 1 then Val(ParamStr(1), n, code);
  SetLength(perm, n);
  SetLength(perm1, n);
  SetLength(cnt, n);
  for i := 0 to n - 1 do perm1[i] := i;
  maxflips := 0;
  checksum := 0;
  permcount := 0;
  r := n;
  done := false;
  while not done do
  begin
    while r <> 1 do
    begin
      cnt[r - 1] := r;
      Dec(r);
    end;

    for i := 0 to n - 1 do perm[i] := perm1[i];
    flips := 0;
    k := perm[0];
    while k <> 0 do
    begin
      i := 0;
      j := k;
      while i < j do
      begin
        t := perm[i]; perm[i] := perm[j]; perm[j] := t;
        Inc(i);
        Dec(j);
      end;
      Inc(flips);
      k := perm[0];
    end;
    if flips > maxflips then maxflips := flips;
    if (permcount and 1) = 0 then checksum := checksum + flips
    else checksum := checksum - flips;

    { next permutation }
    while true do
    begin
      if r = n then
      begin
        done := true;
        break;
      end;
      t := perm1[0];
      for i := 0 to r - 1 do perm1[i] := perm1[i + 1];
      perm1[r] := t;
      Dec(cnt[r]);
      if cnt[r] > 0 then break;
      Inc(r);
    end;
    Inc(permcount);
  end;
  WriteLn(checksum);
  WriteLn('Pfannkuchen(', n, ') = ', maxflips);
end.
