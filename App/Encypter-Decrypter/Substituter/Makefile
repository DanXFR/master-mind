
.DEFAULT_GOAL := Substituter

.PHONY: all clean cleanlib cleanall

# Compiler and tools

CXX = g++
CC  = gcc

# Paths

INCLUDE_PATH      = include
SOURCE_PATH       = src
OBJECT_PATH       = obj
LIBRARY_PATH      = lib

PROGRAM = Substituter

OBJECTS =

LIBRARIES = \
    $(LIBRARY_PATH)/libCharSubstituteConfigure.so \
    $(LIBRARY_PATH)/libCharSubstituter.so

LD_LIBS = \
    -lCharSubstituteConfigure \
    -lCharSubstituter

DEFINES =

INCLUDES = \
    -I$(INCLUDE_PATH) \
	-I /usr/include/libxml2

LDPATHS = \
    -L$(LIBRARY_PATH)

CXXFLAGS = -g -fno-builtin -Wall -Wwrite-strings -Wsign-compare -Werror $(DEFINES) $(INCLUDES)
CFLAGS   = -g -fno-builtin -Wall -Wwrite-strings -Wsign-compare -Werror $(DEFINES) $(INCLUDES)

# Rules: Must use TAB before the command.

all: $(PROGRAM)

$(PROGRAM): $(OBJECT_PATH)/Substituter_Main.o $(OBJECTS) $(LIBRARIES)
	$(CXX) -o $@ $(OBJECT_PATH)/Substituter_Main.o $(OBJECTS) $(LDPATHS) $(LD_LIBS) -lncurses

$(OBJECT_PATH)/Substituter_Main.o: Substituter_Main.cpp $(OBJECTS) $(LIBRARIES)
	$(CXX) -c $(CXXFLAGS) -o $(OBJECT_PATH)/Substituter_Main.o Substituter_Main.cpp

$(OBJECT_PATH)/%.o: $(SOURCE_PATH)/%.cc $(INCLUDE_PATH)/%.h
	$(CXX) -c $(CXXFLAGS) -o $@ $<

$(OBJECT_PATH)/%.o: $(SOURCE_PATH)/%.cpp $(INCLUDE_PATH)/%.h
	$(CXX) -c $(CXXFLAGS) -o $@ $<

$(OBJECT_PATH)/%.o: $(SOURCE_PATH)/%.cxx $(INCLUDE_PATH)/%.h
	$(CXX) -c $(CXXFLAGS) -o $@ $<

$(OBJECT_PATH)/%.o: $(SOURCE_PATH)/%.c $(INCLUDE_PATH)/%.h
	$(CC) -c $(CFLAGS) -o $@ $<

$(LIBRARY_PATH)/lib%.so: $(OBJECT_PATH)/%.o
	$(CC) $(CFLAGS) -shared -o $@ $< -lstdc++ -lxml2

# Use - before the command to ignore error.

clean:
	-rm -f $(OBJECT_PATH)/*

cleanlib:
	-rm -f $(LIBRARIES)

cleanall: clean cleanlib
	-rm -f $(PROGRAM)

