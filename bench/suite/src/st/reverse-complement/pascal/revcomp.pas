{ reverse-complement (Benchmarks Game algorithm), single-threaded, Free Pascal.
  Stdin is read whole with FileRead; output is written with FileWrite. }
program revcomp;
{$mode objfpc}
uses SysUtils;

const
  WIDTH = 60;
  FROMS = 'ACGTUMRWSYKVHDBNacgtumrwsykvhdbn';
  TOS   = 'TGCAAKYWSRMBDHVNTGCAAKYWSRMBDHVN';

var
  comp: array[char] of char;
  raw, obuf: array of char;
  rlen, got, i, p, hs, he, ss, se, m, j, olen, col, off: SizeInt;
  c: char;
begin
  for c := Low(char) to High(char) do comp[c] := c;
  for i := 1 to Length(FROMS) do comp[FROMS[i]] := TOS[i];

  SetLength(raw, 1 shl 20);
  rlen := 0;
  repeat
    if rlen = Length(raw) then SetLength(raw, 2 * Length(raw));
    got := FileRead(StdInputHandle, raw[rlen], Length(raw) - rlen);
    if got > 0 then Inc(rlen, got);
  until got <= 0;

  SetLength(obuf, rlen + rlen div WIDTH + 16);
  olen := 0;
  p := 0;
  while p < rlen do
  begin
    hs := p;
    while (p < rlen) and (raw[p] <> #10) do Inc(p);
    he := p; { exclusive end of header text }
    Inc(p);
    ss := p;
    m := ss;
    while (p < rlen) and (raw[p] <> '>') do
    begin
      if raw[p] <> #10 then
      begin
        raw[m] := raw[p];
        Inc(m);
      end;
      Inc(p);
    end;
    se := m; { exclusive }
    for i := hs to he - 1 do
    begin
      obuf[olen] := raw[i];
      Inc(olen);
    end;
    obuf[olen] := #10;
    Inc(olen);
    col := 0;
    for j := se - 1 downto ss do
    begin
      obuf[olen] := comp[raw[j]];
      Inc(olen);
      Inc(col);
      if col = WIDTH then
      begin
        obuf[olen] := #10;
        Inc(olen);
        col := 0;
      end;
    end;
    if col <> 0 then
    begin
      obuf[olen] := #10;
      Inc(olen);
    end;
  end;

  off := 0;
  while off < olen do
  begin
    got := FileWrite(StdOutputHandle, obuf[off], olen - off);
    if got <= 0 then break;
    Inc(off, got);
  end;
end.
