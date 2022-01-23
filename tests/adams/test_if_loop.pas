program sort(input, output);
var x: array[1..10] of integer;
var y, z: integer;

begin
  z := 2;
  y := 4;
  x[1] := 6;

  while y < 12 do
  begin
    x[1] := x[1] -1 ;
    if (y < 10) and (y >= 0 ) then
      if not x[1] = 0 then
        write(111)
      else
        write(222)
    else
      write(333);
    y := y+1;
    while z = 2 do
    begin
      z:= z * 2;
      write(z)
    end

  end

  
end.