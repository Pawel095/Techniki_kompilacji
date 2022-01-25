program proc(inp,out);
var g:real;


procedure setg(r:real);
begin
    g:=r+g
end;

begin
    write(g);
    setg(5.0);
    write(g)
end.
