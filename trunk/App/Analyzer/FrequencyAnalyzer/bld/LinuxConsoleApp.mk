
.PHONY: all install clean cleanlib cleanall

# Compiler and tools

CXX = g++
CC  = gcc

#==============================================================================
# Module Name 
#==============================================================================

CATEGORY = Analyzer
MODULE = FrequencyAnalyzer
MOD_DIR = $(MAP_ROOT)/$(TARGET)/category/$(CATEGORY)/module/$(MODULE)

# Defines target-specific variables
include $(RULES_ROOT)/defs.$(TARGET)

# Defines global variables applicable to all builds
#include $(RULES_ROOT)/macros.default


#==============================================================================
# Module Defines
#==============================================================================

DEF_MOD := 


#==============================================================================
# Assembler, Compiler and Linker Options for the Module
#==============================================================================

OPT_ASM_MOD :=
OPT_CC_MOD  :=
OPT_CXX_MOD :=
OPT_LD_MOD  :=


#==============================================================================
# Module Include Paths
#==============================================================================

INCLUDE_MOD := \
            -I$(MOD_DIR)/include


#==============================================================================
# List of objects to link
#==============================================================================

OBJS_TO_LINK := \
             $(OBJ_DIR)/FrequencyAnalyzer_Main.o
 

#==============================================================================
# External Libraries
#==============================================================================

LIBS_TO_LINK :=


# Paths

INCLUDE_PATH      = $(MOD_DIR)/include
SOURCE_PATH       = $(MOD_DIR)/src
OBJECT_PATH       = $(MOD_DIR)/obj
LIBRARY_PATH      = $(MOD_DIR)/lib
BINARY_PATH       = $(MOD_DIR)/bin
INSTALL_BIN_PATH  = /usr/local/master-mind/bin
INSTALL_LIB_PATH  = /usr/local/master-mind/lib

PROGRAM = FrequencyAnalyzer

OBJECTS =

LIBRARIES = \
    $(LIBRARY_PATH)/libCharFrequency.so

LD_LIBS = \
    -lCharFrequency

DEFINES =

INCLUDES = \
    -I$(INCLUDE_PATH)

LDPATHS = \
    -L$(LIBRARY_PATH)

CXXFLAGS = -g -fno-builtin -Wall -Wwrite-strings -Wsign-compare -Werror $(DEFINES) $(INCLUDES)
CFLAGS   = -g -fno-builtin -Wall -Wwrite-strings -Wsign-compare -Werror $(DEFINES) $(INCLUDES)

# Rules: Must use TAB before the command.

.DEFAULT_GOAL := $(BINARY_PATH)/$(PROGRAM)

all: $(BINARY_PATH)/$(PROGRAM)

$(BINARY_PATH)/$(PROGRAM): $(OBJECT_PATH)/FrequencyAnalyzer_Main.o $(OBJECTS) $(LIBRARIES)
	$(CXX) -o $@ $(OBJECT_PATH)/FrequencyAnalyzer_Main.o $(OBJECTS) $(LDPATHS) $(LD_LIBS)

$(OBJECT_PATH)/FrequencyAnalyzer_Main.o: $(MOD_DIR)/FrequencyAnalyzer_Main.cpp $(OBJECTS) $(LIBRARIES)
	$(CXX) -c $(CXXFLAGS) -o $(OBJECT_PATH)/FrequencyAnalyzer_Main.o $(MOD_DIR)/FrequencyAnalyzer_Main.cpp

$(OBJECT_PATH)/%.o: $(SOURCE_PATH)/%.cc $(INCLUDE_PATH)/%.hpp
	$(CXX) -c $(CXXFLAGS) -o $@ $<

$(OBJECT_PATH)/%.o: $(SOURCE_PATH)/%.cpp $(INCLUDE_PATH)/%.hpp
	$(CXX) -c $(CXXFLAGS) -o $@ $<

$(OBJECT_PATH)/%.o: $(SOURCE_PATH)/%.cxx $(INCLUDE_PATH)/%.hpp
	$(CXX) -c $(CXXFLAGS) -o $@ $<

$(OBJECT_PATH)/%.o: $(SOURCE_PATH)/%.c $(INCLUDE_PATH)/%.h
	$(CC) -c $(CFLAGS) -o $@ $<

$(LIBRARY_PATH)/lib%.so: $(OBJECT_PATH)/%.o
	$(CC) $(CFLAGS) -shared -o $@ $< -lstdc++

# Use - before the command to ignore error.

install:
	-mkdir -p $(INSTALL_BIN_PATH)
	-mkdir -p $(INSTALL_LIB_PATH)
	-cp $(PROGRAM) $(INSTALL_BIN_PATH)
	-cp $(LIBRARIES) $(INSTALL_LIB_PATH)

clean:
	-rm -f $(OBJECT_PATH)/*

cleanlib:
	-rm -f $(LIBRARIES)

cleanall: clean cleanlib
	-rm -f $(BINARY_PATH)/$(PROGRAM)


#==============================================================================
# Include the standard build rules
#==============================================================================

#include $(RULES_ROOT)/rules.default


