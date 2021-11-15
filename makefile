

out: emitter.o error.o init.o lexer.o main.o parser.o symbol.o
	cc -g -o out emitter.o error.o init.o lexer.o main.o parser.o symbol.o

emitter.o : emitter.c global.h
	cc -g -c emitter.c 

error.o : error.c global.h
	cc -g -c error.c

init.o : init.c global.h
	cc -g -c init.c

lexer.o : lexer.c global.h
	cc -g -c lexer.c

main.o : main.c global.h
	cc -g -c main.c

parser.o : parser.c global.h
	cc -g -c parser.c

symbol.o : symbol.c global.h
	cc -g -c symbol.c

clean:
	-rm -rf *.o
	-rm out