#==============================================================================
# bslDrvHsspc Library for DBA Application
#
#    ** PLEASE READ Loadbuild documentation before modifying this file. **
#
# References:
#   Customizing Builds - See $BTS_ROOT/build/home/templates/macros.extra
#   CDMA BTS Loadbuild - http://clue.ca.nortel.com/Calgary/
#   Makefiles - http://www.gnu.org/manual/make/html_node/make_toc.html
#
#==============================================================================

#==============================================================================
# Module Name
#==============================================================================
MODULE     = hsspc
MOD_DIR    = $(BASE_ROOT)/hsspc
EXPORT_DIR = $(BASE_EXPORT)

# Defines target-specific variables
include $(RULES_ROOT)/defs.$(CARD)$(LOAD)

# Defines global variables applicable to all builds
include $(RULES_ROOT)/macros.default


#==============================================================================
# Module Defines
#==============================================================================
DEF_STD := \
        -DCPU=PPC604 

#==============================================================================
# Assembler, Compiler and Linker Options for the Module
#==============================================================================
OPT_ASM_MOD :=

OPT_CC_MOD := -Werror
 
OPT_C++_MOD := -Werror
 
OPT_LD_MOD :=


#==============================================================================
# Module Include Paths
#==============================================================================
INCLUDE_MOD := \
        -I$(BASE_ROOT)   \
        -I$(NCP_ROOT)/include \
        -I$(BASE_ROOT)/npuapi/h 

#==============================================================================
# List of objects to link
#
# If you want to create the driver to run the unit test for HSSPC, change 
# bslDrvHsspcLld.o to bslDrvHsspcLld.otest. The above change will force the 
# compiler to pick up the bslDrvHsspcLld.c file from the test directory 
# (which is a dummy LLD) intead of src directory.
#==============================================================================
OBJS_TO_LINK := \
        $(OBJ_DIR)/bslDrvHsspcLitrUtil.o \
        $(OBJ_DIR)/bslDrvHsspcLitr.o \
        $(OBJ_DIR)/bslDrvHsspcLitrLld.o \
        $(OBJ_DIR)/bslDrvHsspcLitrThread.o \
        $(OBJ_DIR)/bslDrvHsspcIndShow.o \
        $(OBJ_DIR)/bslDrvHsspcDebounceCm2.o \
 

#==============================================================================
# External Libraries
#==============================================================================
LIBS_TO_LINK :=


#==============================================================================
# Flint Options
#==============================================================================
FLINT_PROFILE_MOD :=
 

#==============================================================================
# Include the standard build rules.
#==============================================================================
include $(RULES_ROOT)/rules.default
