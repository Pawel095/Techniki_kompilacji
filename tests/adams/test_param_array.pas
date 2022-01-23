program sort(input, output);
var x, r: array[1..10] of integer;
var y, z: integer;

function f(a: array[1..10] of integer; c, d, e:integer): integer;
begin
  a[1] := 10;
  f := a
end;

begin
  r := f(x, y, z, 0);
  write(x[1]);
  x[1] := 69;
  write(x[1]);
  write(r[1])
end.
