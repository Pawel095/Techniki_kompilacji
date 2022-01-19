VPATH = .:./program:./debug:./libfort/lib:./asmfor

flex = flex
compiler = g++
cflags = -g --std=c++2a
libraries =
bison = bison
bflags = -g --verbose --debug

ccmd = ${compiler} ${cflags} ${libraries}
bisoncmd = $(bison) $(bflags)
FLEX = $(flex)

sources != find . -iname '*.cpp' -exec basename {} \;
sources += parser.cpp lexer.cpp libfort/lib/fort.c

# $(info $(sources))
# $(info $(sort $(sources)))

headers != find . -iname '*.hpp' -exec basename {} \;
headers += parser.hpp libfort/lib/fort.hpp

# Kill duplicates Xoff Xoff
sources := $(sort $(sources))
headers := $(sort $(headers))

objs = $(filter-out %.c,$(sources:.cpp=.o))
# Special case for libfort
objs += libfort/lib/fort.o

BIN_OUT = out

.PHONY: clean cleanobj cleangen headers


${BIN_OUT} : $(objs)
	$(ccmd) -o $(BIN_OUT) $(objs)

$(objs) : $(headers)

%.o : %.cpp
	$(ccmd) -c -o $@ $<

%.o : %.c
	$(ccmd) -c -o $@ $<

lexer.cpp: lexer.l
	flex -o lexer.cpp lexer.l

parser.cpp parser.hpp: parser.y lexer.cpp
	$(bisoncmd) --defines=parser.hpp -o parser.cpp parser.y

# REMLAT: Only for debug, kill later
headers: $(headers)

cleanobj:
	rm -rf $(objs)

cleangen:
	rm -rf parser.hpp parser.cpp lexer.cpp parser.dot parser.output output.asm

clean: cleanobj cleangen
	rm -rf out