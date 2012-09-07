
.PHONY: all install clean cleanlib cleanall

#==============================================================================
# Module Name 
#==============================================================================

CATEGORY := Analyzer
MODULE   := FrequencyAnalyzer

include $(RULES_ROOT)/defs.$(TARGET)
include $(RULES_ROOT)/macros.default

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
#================================================= =============================

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

OBJECTS :=

LIBRARIES := \
    $(LIB_DIR)/libCharFrequency.so

LD_LIBS := \
    -lCharFrequency

INCLUDES := \
    -I$(INC_DIR)

LDPATHS := \
    -L$(LIB_DIR)

CXXFLAGS := -g -fno-builtin -Wall -Wwrite-strings -Wsign-compare -Werror $(DEF_MOD) $(INCLUDES)
CFLAGS   := -g -fno-builtin -Wall -Wwrite-strings -Wsign-compare -Werror $(DEF_MOD) $(INCLUDES)

# Rules: Must use TAB before the command.

.DEFAULT_GOAL := $(BUILD_TARGET)

all: $(BUILD_TARGET)

$(BUILD_TARGET): $(OBJ_DIR)/FrequencyAnalyzer_Main.o $(OBJECTS) $(LIBRARIES)
	$(CXX) -o $@ $(OBJ_DIR)/FrequencyAnalyzer_Main.o $(OBJECTS) $(LDPATHS) $(LD_LIBS)

$(OBJ_DIR)/FrequencyAnalyzer_Main.o: $(MOD_DIR)/FrequencyAnalyzer_Main.cpp $(OBJECTS) $(LIBRARIES)
	$(CXX) -c $(CXXFLAGS) -o $(OBJ_DIR)/FrequencyAnalyzer_Main.o $(MOD_DIR)/FrequencyAnalyzer_Main.cpp

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cc $(INC_DIR)/%.hpp
	$(CXX) -c $(CXXFLAGS) -o $@ $<

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp $(INC_DIR)/%.hpp
	$(CXX) -c $(CXXFLAGS) -o $@ $<

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cxx $(INC_DIR)/%.hpp
	$(CXX) -c $(CXXFLAGS) -o $@ $<

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(INC_DIR)/%.h
	$(CC) -c $(CFLAGS) -o $@ $<

$(LIB_DIR)/lib%.so: $(OBJ_DIR)/%.o
	$(CC) $(CFLAGS) -shared -o $@ $< -lstdc++

# Use - before the command to ignore error.

install:
	-mkdir -p $(INSTALL_BIN_PATH)
	-mkdir -p $(INSTALL_LIB_PATH)
	-cp $(BUILD_TARGET) $(INSTALL_BIN_PATH)
	-cp $(LIBRARIES) $(INSTALL_LIB_PATH)

clean:
	-rm -f $(OBJ_DIR)/*

cleanlib:
	-rm -f $(LIB_DIR)/*

cleanall: clean cleanlib
	-rm -f $(BIN_DIR)/*


#==============================================================================
# Include the standard build rules
#==============================================================================

#include $(RULES_ROOT)/rules.default


