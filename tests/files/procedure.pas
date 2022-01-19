program proc(inp,out);
var g,i,j:integer;


procedure f(b:integer;c:real);
var g:real;
begin
    g:=b-c*b;
    write(b);
    write(c)
end;

procedure proc2(a:integer;b:real);
var g:real;
begin
    g:=a+b;
    write(g)
end;

begin
    i:=1;
    j:=2;
    g:=2 mod 3;
    f(i,j+g);
    proc2(1,3);
    write(g)
end.
