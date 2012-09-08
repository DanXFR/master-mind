#==============================================================================
# Mastermind
# Categories for Linux Console Application
#
#==============================================================================

BUILD := MasterMind

include $(RULES_ROOT)/defs.$(TARGET)
include $(RULES_ROOT)/macros.default


#==============================================================================
# Category Names
#==============================================================================

CATEGORIES := \
           Analyzer \
           Encrypter-Decrypter  


#==============================================================================
# Additional Libraries
#==============================================================================

EXTERNAL_LIBS := 


#==============================================================================
# Defines used in rules.load
#==============================================================================

EXTRA_LIB :=


#==============================================================================
# Load build rules
#==============================================================================

include $(RULES_ROOT)/rules.target


