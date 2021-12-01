flex = flex
cc = cc
cflags = -g
libraries = -lfl
bison = bison
bflags = -d -g
cccmd = $(cc) $(clfags) $(libraries)

# ZADANIE 1
out: emitter.o error.o init.o lex.yy.o main.o symbol.o lexutils.o parser.tab.o
	$(cccmd) -o out emitter.o error.o init.o lex.yy.o main.o symbol.o lexutils.o parser.tab.o

emitter.o : emitter.c global.h parser.tab.h
	$(cccmd) -c emitter.c 

error.o : error.c global.h parser.tab.h
	$(cccmd) -c error.c

init.o : init.c global.h parser.tab.h
	$(cccmd) -c init.c

main.o : main.c global.h parser.tab.h
	$(cccmd) -c main.c

symbol.o : symbol.c global.h parser.tab.h
	$(cccmd) -c symbol.c


# ZADANIE 2
lex.yy.c: lexer.l
	$(flex) lexer.l

lex.yy.o: lex.yy.c global.h lexutils/lexutils.h parser.tab.h
	$(cccmd) -c lex.yy.c

lexutils.o: lexutils/lexutils.c lexutils/lexutils.h parser.tab.h
	$(cccmd) -c lexutils/lexutils.c

# ZADANIE 3
parser.tab.c parser.tab.h : parser.y
	$(bison) $(bflags) parser.y

parser.tab.o : parser.tab.c global.h
	$(cc) -c parser.tab.c 

clean:
	-rm -rf parser.tab.*
	-rm -rf parser.dot
	-rm -rf lex.yy.c 
	-rm -rf *.o
	-rm out