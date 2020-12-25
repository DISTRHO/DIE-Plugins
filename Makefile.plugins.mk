#!/usr/bin/make -f
# Makefile for DIE-Plugins #
# ------------------------ #
# Created by falkTX
#

# NOTE: NAME and FILES must have been defined before including this file!

include ../../Makefile.base.mk

# ---------------------------------------------------------------------------------------------------------------------
# Basic setup

TARGET_DIR = ../../bin
BUILD_DIR = ../../build/$(NAME)

BASE_FLAGS += -Wno-unused-function -Wno-unused-parameter -DHAVE_LV2_1_10_0
BASE_FLAGS += $(CUSTOM_BUILD_FLAGS)
LINK_FLAGS += $(CUSTOM_LINK_FLAGS)

BUILD_C_FLAGS   += -I.
BUILD_CXX_FLAGS += -I.

# ---------------------------------------------------------------------------------------------------------------------
# Set files to build

OBJS = $(FILES:%=$(BUILD_DIR)/%.o)

# ---------------------------------------------------------------------------------------------------------------------
# Default build target

BUNDLE_DIR = $(TARGET_DIR)/distrho-$(NAME).lv2
TARGET_FILES = $(BUNDLE_DIR)/$(NAME)$(LIB_EXT) $(BUNDLE_DIR)/manifest.ttl $(BUNDLE_DIR)/$(NAME).ttl

ifeq ($(HAS_PRESETS),true)
TARGET_FILES += $(BUNDLE_DIR)/presets.ttl
endif
ifeq ($(HAS_STEREO),true)
TARGET_FILES += $(BUNDLE_DIR)/$(NAME)\#stereo.ttl
endif

all: build

build: $(TARGET_FILES)

# ---------------------------------------------------------------------------------------------------------------------
# Build commands

$(BUILD_DIR)/%.c.o: %.c
	-@mkdir -p "$(shell dirname $(BUILD_DIR)/$<)"
	@echo "Compiling $<"
	$(SILENT)$(CC) $< $(BUILD_C_FLAGS) -c -o $@

$(BUILD_DIR)/%.cc.o: %.cc
	-@mkdir -p "$(shell dirname $(BUILD_DIR)/$<)"
	@echo "Compiling $<"
	$(SILENT)$(CXX) $< $(BUILD_CXX_FLAGS) -c -o $@

$(BUILD_DIR)/%.cpp.o: %.cpp
	-@mkdir -p "$(shell dirname $(BUILD_DIR)/$<)"
	@echo "Compiling $<"
	$(SILENT)$(CXX) $< $(BUILD_CXX_FLAGS) -c -o $@

$(BUNDLE_DIR)/%.ttl: %.ttl.in
	-@mkdir -p $(shell dirname $@)
	@echo "Adjusting $?"
	$(SILENT)sed -e "s/@LIB_EXT@/$(LIB_EXT)/" $< > $@

$(BUNDLE_DIR)/$(NAME)$(LIB_EXT): $(OBJS)
	-@mkdir -p $(shell dirname $@)
	@echo "Linking $(NAME)$(LIB_EXT)"
	$(SILENT)$(CXX) $^ $(LINK_FLAGS) $(SHARED) -o $@

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(BUNDLE_DIR)

# ---------------------------------------------------------------------------------------------------------------------

-include $(OBJS:%.o=%.d)

# ---------------------------------------------------------------------------------------------------------------------
