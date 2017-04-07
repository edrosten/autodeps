.PHONY: all clean

all: prog

prog: a.o b.o
	$(CXX) -o prog $^


#We can't use the built in rule for compiling c++.
#
#Let's say a header changed to include a new header.
#That change would cause a rebuild of the .cc file
#but not the .d file. 
#
# Arguments mean:
# -MMD output #include dependencies, but ignore system headers, while
#      the build continues
# -MF output dependencies to a file, so other crud goes to the screen
# -MP make a blank target for dependencies. That way if a dependency is
#     deleted, make won't fail to build stuff 
%.o %d: %.cc
	$(CXX) -c $< $(CXXFLAGS) -MMD -MP -MF $*.d


clean:
	rm -f *.o *.d prog .deps

#Search for all .d files and add them
#Note that .d files are built in with .o files. If there's no .o yet,
#then there's no .d. But that's OK; there are no precise dependencies,
#but we know we have to rebuild it anyway because the .o is not there.
#So, it's OK to only pick up .d files that have alredy been generted.
DEPFILES=$(wildcard *.d)


#This is the nice trick whereby make will run whatever is required
#to build this before including it.
include $(DEPFILES)
