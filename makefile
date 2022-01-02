flex = flex
compiler = g++
cflags = -g
libraries =
bison = bison
bflags = -g 

ccmd = ${compiler} ${cflags} ${libraries}
bisoncmd = $(bison) $(bflags)
FLEX = $(flex)

CSRC = main.cpp lexer.cpp parser.cpp
HEAD = global.hpp parser.hpp
objs = $(CSRC:.cpp=.o)

BIN_OUT = out

.PHONY: clean cleanobj cleangen


${BIN_OUT} : $(objs)
	$(ccmd) -o $(BIN_OUT) $(objs)

$(objs) : $(HEAD)

%.o : %.cpp
	$(ccmd) -c -o $@ $<

lexer.cpp: lexer.l parser.hpp
	flex -o lexer.cpp lexer.l

parser.cpp parser.hpp: parser.y
	$(bisoncmd) --defines=parser.hpp -o parser.cpp parser.y

cleanobj:
	rm -rf $(objs)

cleangen:
	rm -rf parser.hpp parser.cpp lexer.cpp parser.dot

clean: cleanobj cleangen
	rm -rf out