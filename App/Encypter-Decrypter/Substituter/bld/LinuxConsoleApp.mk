
.PHONY: all install clean cleanlib cleanall

#==============================================================================
# Module Name 
#==============================================================================

CATEGORY := Encypter-Decrypter
MODULE   := Substituter

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

OPT_LD_MOD  := \
            -lCharSubstituteConfigure \
            -lCharSubstituter

#==============================================================================
# Module Include Paths
#================================================= =============================

INCLUDE_MOD := \
            -I /usr/include/libxml2


#==============================================================================
# List of Objects to Link
#==============================================================================

OBJS_TO_LINK := \
             $(OBJ_DIR)/Substituter_Main.o
 

#==============================================================================
# External Libraries
#==============================================================================

LIBS_TO_LINK := \
             $(LIB_DIR)/libCharSubstituteConfigure.so \
             $(LIB_DIR)/libCharSubstituter.so


#==============================================================================
# Include the standard build rules
#==============================================================================

include $(RULES_ROOT)/rules.default


