{ mandelbrot (Benchmarks Game algorithm), single-threaded, plain Free Pascal. }
program mandelbrot;
{$mode objfpc}
uses SysUtils;

const
  ITER = 50;
  LIMIT2: double = 4.0;

var
  w, h, x, y, i, bitnum, bytesPerRow, pos, code: longint;
  byteacc: byte;
  zr, zi, tr, ti, cr, ci: double;
  pix: array of byte;
begin
  w := 200;
  if ParamCount >= 1 then Val(ParamStr(1), w, code);
  h := w;
  bytesPerRow := (w + 7) div 8;
  SetLength(pix, bytesPerRow * h);
  pos := 0;
  for y := 0 to h - 1 do
  begin
    ci := 2.0 * double(y) / double(h) - 1.0;
    byteacc := 0;
    bitnum := 0;
    for x := 0 to w - 1 do
    begin
      cr := 2.0 * double(x) / double(w) - 1.5;
      zr := 0; zi := 0; tr := 0; ti := 0;
      i := 0;
      while (i < ITER) and (tr + ti <= LIMIT2) do
      begin
        zi := 2.0 * zr * zi + ci;
        zr := tr - ti + cr;
        tr := zr * zr;
        ti := zi * zi;
        Inc(i);
      end;
      byteacc := byte(byteacc shl 1);
      if tr + ti <= LIMIT2 then byteacc := byteacc or 1;
      Inc(bitnum);
      if bitnum = 8 then
      begin
        pix[pos] := byteacc;
        Inc(pos);
        byteacc := 0;
        bitnum := 0;
      end;
    end;
    if bitnum <> 0 then
    begin
      byteacc := byte(byteacc shl (8 - bitnum));
      pix[pos] := byteacc;
      Inc(pos);
    end;
  end;
  Write('P4'#10, w, ' ', h, #10);
  Flush(Output);
  FileWrite(StdOutputHandle, pix[0], pos);
end.
