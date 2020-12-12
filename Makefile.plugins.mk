#!/usr/bin/make -f
# Makefile for DPF Example Plugins #
# -------------------------------- #
# Created by falkTX
#

# NOTE: NAME and FILES must have been defined before including this file!

include ../../Makefile.base.mk

# ---------------------------------------------------------------------------------------------------------------------
# Basic setup

TARGET_DIR = ../../bin
BUILD_DIR = ../../build/$(NAME)

BASE_FLAGS += -Wno-unused-function -Wno-unused-parameter -DHAVE_LV2_1_10_0

BUILD_C_FLAGS   += -I.
BUILD_CXX_FLAGS += -I.

# ---------------------------------------------------------------------------------------------------------------------
# Set files to build

OBJS = $(FILES:%=$(BUILD_DIR)/%.o)

# ---------------------------------------------------------------------------------------------------------------------
# Default build target

TARGET = $(TARGET_DIR)/$(NAME).lv2/$(NAME)$(LIB_EXT)

all: build

build: $(TARGET)

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

$(TARGET): $(OBJS)
	-@mkdir -p $(shell dirname $@)
	@echo "Linking $(NAME)"
	$(SILENT)$(CXX) $^ $(LINK_FLAGS) $(SHARED) -o $@

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(TARGET_DIR)/$(NAME).lv2

# ---------------------------------------------------------------------------------------------------------------------

-include $(OBJS:%.o=%.d)

# ---------------------------------------------------------------------------------------------------------------------
