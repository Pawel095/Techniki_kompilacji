flex = flex
cc = cc
cflags = -g
libraries = -lfl

# ZADANIE 1 MAKEFILE
out: emitter.o error.o init.o lex.yy.o main.o parser.o symbol.o lexutils.o
	$(cc) $(clfags) $(libraries) -o out emitter.o error.o init.o lex.yy.o main.o parser.o symbol.o lexutils.o

emitter.o : emitter.c global.h
	$(cc) $(clfags) $(libraries) -c emitter.c 

error.o : error.c global.h
	$(cc) $(clfags) $(libraries) -c error.c

init.o : init.c global.h
	$(cc) $(clfags) $(libraries) -c init.c

main.o : main.c global.h
	$(cc) $(clfags) $(libraries) -c main.c

parser.o : parser.c global.h
	$(cc) $(clfags) $(libraries) -c parser.c

symbol.o : symbol.c global.h
	$(cc) $(clfags) $(libraries) -c symbol.c
# END: ZADANIE 1 MAKEFILE

lex.yy.c: lexer.l
	$(flex) lexer.l

lex.yy.o: lex.yy.c global.h lexutils/lexutils.h
	$(cc) $(clfags) $(libraries) -c lex.yy.c

lexutils.o: lexutils/lexutils.c lexutils/lexutils.h
	$(cc) $(clfags) $(libraries) -c lexutils/lexutils.c

clean:
	-rm -rf lex.yy.c
	-rm -rf *.o
	-rm out