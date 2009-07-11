
.DEFAULT_GOAL := FrequencyAnalyzer

.PHONY: all clean cleanlib cleanall

# Compiler and tools

CXX = g++
CC  = gcc

# Paths

INCLUDE_PATH      = include
SOURCE_PATH       = src
OBJECT_PATH       = obj
LIBRARY_PATH      = lib

PROGRAM = FrequencyAnalyzer

OBJECTS =

LIBRARIES = \
    $(LIBRARY_PATH)/libCharFrequency.so

LD_LIBS = \
    -lstdc++ \
    -lCharFrequency

DEFINES =

INCLUDES = \
    -I$(INCLUDE_PATH)

LDPATHS = \
    -L$(LIBRARY_PATH)

CXXFLAGS = -g -fno-builtin -Wall -Wwrite-strings -Wsign-compare -Werror $(DEFINES) $(INCLUDES)
CFLAGS   = -g -fno-builtin -Wall -Wwrite-strings -Wsign-compare -Werror $(DEFINES) $(INCLUDES)

# Rules: Must use TAB before the command.

all: $(PROGRAM)

$(PROGRAM): $(OBJECT_PATH)/FrequencyAnalyzer_Main.o $(OBJECTS) $(LIBRARIES)
	$(CXX) -o $@ $(OBJECT_PATH)/FrequencyAnalyzer_Main.o $(OBJECTS) $(LDPATHS) $(LD_LIBS)

$(OBJECT_PATH)/FrequencyAnalyzer_Main.o: FrequencyAnalyzer_Main.cpp $(OBJECTS) $(LIBRARIES)
	$(CXX) -c $(CXXFLAGS) -o $(OBJECT_PATH)/FrequencyAnalyzer_Main.o FrequencyAnalyzer_Main.cpp

$(OBJECT_PATH)/%.o: $(SOURCE_PATH)/%.cc $(INCLUDE_PATH)/%.h
	$(CXX) -c $(CXXFLAGS) -o $@ $<

$(OBJECT_PATH)/%.o: $(SOURCE_PATH)/%.cpp $(INCLUDE_PATH)/%.h
	$(CXX) -c $(CXXFLAGS) -o $@ $<

$(OBJECT_PATH)/%.o: $(SOURCE_PATH)/%.cxx $(INCLUDE_PATH)/%.h
	$(CXX) -c $(CXXFLAGS) -o $@ $<

$(OBJECT_PATH)/%.o: $(SOURCE_PATH)/%.c $(INCLUDE_PATH)/%.h
	$(CC) -c $(CFLAGS) -o $@ $<

$(LIBRARY_PATH)/lib%.so: $(OBJECT_PATH)/%.o
	$(CC) $(CFLAGS) -shared -o $@ $<

# Use - before the command to ignore error.

clean:
	-rm -f $(OBJECT_PATH)/*

cleanlib:
	-rm -f $(LIBRARIES)

cleanall: clean cleanlib
	-rm -f $(PROGRAM)

