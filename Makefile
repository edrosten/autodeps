.PHONY: all clean

all: prog

OBJS=a.o b.o

prog: $(OBJS)
	$(CXX) -o prog $^


%.d: %.cc
	gcc -MM $(CXXFLAGS) $< > $@


%.o: %.cc
	$(CXX) -c $^ $(CXXFLAGS)
	#Let's say a header changed to include a new header.
	#That change would cause a rebuild of the .cc file
	#but not the .d file. So update it now
	$(CXX) -MM $(CXXFLAGS) $< > $*.d


clean:
	rm -f *.o *.d prog

CCFILES:=$(wildcard *.cc)
DEPFILES=$(CCFILES:.cc=.d)

.deps: $(DEPFILES)
	cat $(DEPFILES) > .deps

include .deps
