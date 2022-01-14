program p0(inp,out);
var a,result:integer;
var c,b:real;

begin
    a:=0.2E+2;
    b:=2.0;
    c:=1;

    result := a/b*c mod 5;

    write(a);
    write(b);
    write(c);
    write(result)
end.
