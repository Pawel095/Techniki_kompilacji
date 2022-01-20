program proc(inp,out);
var g:integer;


procedure show(b:integer;c:real);
var g:real;
begin
    g:=b-c*b;
    write(b);
    write(c);
    write(g)
end;

function p1(a:real):real;
var temp:real;
begin
    temp:= a;
    p1:=temp*a
end;

function p2(a:integer):integer;
var temp:integer;
begin
    temp:= a;
    p2:=temp/a
end;


begin
    show(p1(4),p2(1.0E2));
    write(g)
end.
