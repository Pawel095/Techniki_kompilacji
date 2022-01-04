VPATH = .:./program:./parser_utils

flex = flex
compiler = g++
cflags = -g
libraries =
bison = bison
bflags = -g 

ccmd = ${compiler} ${cflags} ${libraries}
bisoncmd = $(bison) $(bflags)
FLEX = $(flex)

# sources = main.cpp lexer.cpp parser.cpp l_h.cpp util_p.cpp global.cpp
# headers = global.hpp parser.hpp lexer.hpp l_h.hpp util_p.hpp
sources != find . -iname '*.cpp' -exec basename {} \;
sources += parser.cpp lexer.cpp

# $(info $(sources))
# $(info $(sort $(sources)))

headers != find . -iname '*.hpp' -exec basename {} \;
headers += parser.hpp

# Kill duplicates Xoff Xoff
sources := $(sort $(sources))
headers := $(sort $(headers))

objs = $(sources:.cpp=.o)

BIN_OUT = out

.PHONY: clean cleanobj cleangen headers


${BIN_OUT} : $(objs)
	$(ccmd) -o $(BIN_OUT) $(objs)

$(objs) : $(headers)

%.o : %.cpp
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
	rm -rf parser.hpp parser.cpp lexer.cpp parser.dot

clean: cleanobj cleangen
	rm -rf out