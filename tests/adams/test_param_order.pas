program sort(input, output);
var x: array[1..10] of integer;
var y, z: integer;

function f(a: integer; b:integer; c, d, e:integer):integer;
begin
  a := 1;
  b := 2;
  c := 3;
  d := 4;
  e := 5;
  f := 6;
  write(a);
  write(b);
  write(c);
  write(d);
  write(e)
end;

begin
  z := f(x, y, 0, 0, 0);
  write(z)
end.
