flex = flex
cc = cc
cflags = -g
libraries = -lfl


out: emitter.o error.o init.o lexer.o main.o parser.o symbol.o
	cc -g -o out emitter.o error.o init.o lexer.o main.o parser.o symbol.o

emitter.o : emitter.c global.h
	$(cc) $(clfags) $(libraries) -c emitter.c 

error.o : error.c global.h
	$(cc) $(clfags) $(libraries) -c error.c

init.o : init.c global.h
	$(cc) $(clfags) $(libraries) -c init.c

lexer.o : lexer.c global.h
	$(cc) $(clfags) $(libraries) -c lexer.c

main.o : main.c global.h
	$(cc) $(clfags) $(libraries) -c main.c

parser.o : parser.c global.h
	$(cc) $(clfags) $(libraries) -c parser.c

symbol.o : symbol.c global.h
	$(cc) $(clfags) $(libraries) -c symbol.c
	cc -g -c symbol.c

clean:
	-rm -rf lex.yy.c
	-rm -rf *.o
	-rm out