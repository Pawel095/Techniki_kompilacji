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
    temp:= a/2;
    p1:=(temp-a)*3*temp
end;

function p2(a:integer):integer;
var temp:integer;
begin
    temp:= a*2;
    p2:=(temp-a)/(3*temp)
end;


begin
    show(p1(9999),p2(1.02E3));
    write(g)
end.
