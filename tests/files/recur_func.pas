program proc(inp,out);
var g:integer;

function f1(start,i,koniec:integer):integer;
var trash:integer;
begin
    if koniec > i then
    begin
        i:=i+1;
        write(i);
        f1:=f1(start, i, koniec)
    end
    else
        f1:=i
end;


begin
    g:=f1(0,0,10);
    write(g)
end.
