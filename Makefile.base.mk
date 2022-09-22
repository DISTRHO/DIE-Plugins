#!/usr/bin/make -f
# Makefile for DIE-Plugins #
# ------------------------ #
# Created by falkTX
#

AR  ?= ar
CC  ?= gcc
CXX ?= g++

# ---------------------------------------------------------------------------------------------------------------------
# Protect against multiple inclusion

ifneq ($(DIE_PLUGINS_MAKEFILE_BASE_INCLUDED),true)

DIE_PLUGINS_MAKEFILE_BASE_INCLUDED = true

# ---------------------------------------------------------------------------------------------------------------------
# Auto-detect OS if not defined

TARGET_MACHINE := $(shell $(CC) -dumpmachine)

ifneq ($(BSD),true)
ifneq ($(HAIKU),true)
ifneq ($(HURD),true)
ifneq ($(LINUX),true)
ifneq ($(MACOS),true)
ifneq ($(WASM),true)
ifneq ($(WINDOWS),true)

ifneq (,$(findstring bsd,$(TARGET_MACHINE)))
BSD = true
else ifneq (,$(findstring haiku,$(TARGET_MACHINE)))
HAIKU = true
else ifneq (,$(findstring linux,$(TARGET_MACHINE)))
LINUX = true
else ifneq (,$(findstring gnu,$(TARGET_MACHINE)))
HURD = true
else ifneq (,$(findstring apple,$(TARGET_MACHINE)))
MACOS = true
else ifneq (,$(findstring mingw,$(TARGET_MACHINE)))
WINDOWS = true
else ifneq (,$(findstring msys,$(TARGET_MACHINE)))
WINDOWS = true
else ifneq (,$(findstring wasm,$(TARGET_MACHINE)))
WASM = true
else ifneq (,$(findstring windows,$(TARGET_MACHINE)))
WINDOWS = true
endif

endif # WINDOWS
endif # WASM
endif # MACOS
endif # LINUX
endif # HURD
endif # HAIKU
endif # BSD

# ---------------------------------------------------------------------------------------------------------------------
# Auto-detect the processor

TARGET_PROCESSOR := $(firstword $(subst -, ,$(TARGET_MACHINE)))

ifneq (,$(filter i%86,$(TARGET_PROCESSOR)))
CPU_I386 = true
CPU_I386_OR_X86_64 = true
endif
ifneq (,$(filter wasm32,$(TARGET_PROCESSOR)))
CPU_I386 = true
CPU_I386_OR_X86_64 = true
endif
ifneq (,$(filter x86_64,$(TARGET_PROCESSOR)))
CPU_X86_64 = true
CPU_I386_OR_X86_64 = true
endif
ifneq (,$(filter arm%,$(TARGET_PROCESSOR)))
CPU_ARM = true
CPU_ARM_OR_ARM64 = true
endif
ifneq (,$(filter arm64%,$(TARGET_PROCESSOR)))
CPU_ARM64 = true
CPU_ARM_OR_ARM64 = true
endif
ifneq (,$(filter aarch64%,$(TARGET_PROCESSOR)))
CPU_ARM64 = true
CPU_ARM_OR_ARM64 = true
endif
ifneq (,$(filter riscv64%,$(TARGET_PROCESSOR)))
CPU_RISCV64 = true
endif

ifeq ($(CPU_ARM),true)
ifneq ($(CPU_ARM64),true)
CPU_ARM32 = true
endif
endif

# ---------------------------------------------------------------------------------------------------------------------
# Set PKG_CONFIG (can be overridden by environment variable)

ifeq ($(WASM),true)
# Skip on wasm by default
PKG_CONFIG ?= false
else ifeq ($(WINDOWS),true)
# Build statically on Windows by default
PKG_CONFIG ?= pkg-config --static
else
PKG_CONFIG ?= pkg-config
endif

# ---------------------------------------------------------------------------------------------------------------------
# Set LINUX_OR_MACOS

ifeq ($(LINUX),true)
LINUX_OR_MACOS = true
endif

ifeq ($(MACOS),true)
LINUX_OR_MACOS = true
endif

# ---------------------------------------------------------------------------------------------------------------------
# Set MACOS_OR_WINDOWS, MACOS_OR_WASM_OR_WINDOWS, HAIKU_OR_MACOS_OR_WINDOWS and HAIKU_OR_MACOS_OR_WASM_OR_WINDOWS

ifeq ($(HAIKU),true)
HAIKU_OR_MACOS_OR_WASM_OR_WINDOWS = true
HAIKU_OR_MACOS_OR_WINDOWS = true
endif

ifeq ($(MACOS),true)
HAIKU_OR_MACOS_OR_WASM_OR_WINDOWS = true
HAIKU_OR_MACOS_OR_WINDOWS = true
MACOS_OR_WASM_OR_WINDOWS = true
MACOS_OR_WINDOWS = true
endif

ifeq ($(WASM),true)
HAIKU_OR_MACOS_OR_WASM_OR_WINDOWS = true
MACOS_OR_WASM_OR_WINDOWS = true
endif

ifeq ($(WINDOWS),true)
HAIKU_OR_MACOS_OR_WASM_OR_WINDOWS = true
HAIKU_OR_MACOS_OR_WINDOWS = true
MACOS_OR_WASM_OR_WINDOWS = true
MACOS_OR_WINDOWS = true
endif

# ---------------------------------------------------------------------------------------------------------------------
# Set UNIX

ifeq ($(BSD),true)
UNIX = true
endif

ifeq ($(HURD),true)
UNIX = true
endif

ifeq ($(LINUX),true)
UNIX = true
endif

ifeq ($(MACOS),true)
UNIX = true
endif

# ---------------------------------------------------------------------------------------------------------------------
# Set build and link flags

BASE_FLAGS = -Wall -Wextra -pipe -MD -MP
BASE_OPTS  = -O3 -ffast-math -fdata-sections -ffunction-sections

ifeq ($(WASM),true)
BASE_OPTS += -msse -msse2 -msse3 -msimd128
else ifeq ($(CPU_ARM32),true)
BASE_OPTS += -mfpu=neon-vfpv4 -mfloat-abi=hard
else ifeq ($(CPU_I386_OR_X86_64),true)
BASE_OPTS += -mtune=generic -msse -msse2 -mfpmath=sse
endif

ifeq ($(WINDOWS),true)
# Assume we want posix
BASE_FLAGS += -posix -D__STDC_FORMAT_MACROS=1 -D__USE_MINGW_ANSI_STDIO=1
# Needed for windows, see https://github.com/falkTX/Carla/issues/855
BASE_FLAGS += -mstackrealign
else
# Not needed for Windows
BASE_FLAGS += -fPIC -DPIC
endif

ifeq ($(MACOS),true)
LINK_OPTS += -Wl,-dead_strip,-dead_strip_dylibs
else ifeq ($(WASM),true)
LINK_OPTS += -O3
LINK_OPTS += -Wl,--gc-sections
else
LINK_OPTS += -Wl,-O1,--as-needed,--gc-sections
endif

ifneq ($(SKIP_STRIPPING),true)
ifeq ($(MACOS),true)
LINK_OPTS += -Wl,-x
else ifeq ($(WASM),true)
LINK_OPTS += -sAGGRESSIVE_VARIABLE_ELIMINATION=1
else
LINK_OPTS += -Wl,--strip-all
endif
endif

ifeq ($(NOOPT),true)
# No CPU-specific optimization flags
BASE_OPTS  = -O2 -ffast-math -fdata-sections -ffunction-sections
endif

ifeq ($(DEBUG),true)
BASE_FLAGS += -DDEBUG -O0 -g
LINK_OPTS   =
ifeq ($(WASM),true)
LINK_OPTS  += -sASSERTIONS=1
endif
else
BASE_FLAGS += -DNDEBUG $(BASE_OPTS) -fvisibility=hidden
CXXFLAGS   += -fvisibility-inlines-hidden
endif

BUILD_C_FLAGS   = $(BASE_FLAGS) -std=gnu99 $(CFLAGS)
BUILD_CXX_FLAGS = $(BASE_FLAGS) -std=gnu++11 $(CXXFLAGS)
LINK_FLAGS      = $(LINK_OPTS) $(LDFLAGS)

ifeq ($(WASM),true)
# Special flag for emscripten
LINK_FLAGS += -sENVIRONMENT=web -sLLD_REPORT_UNDEFINED
else ifneq ($(MACOS),true)
# Not available on MacOS
LINK_FLAGS += -Wl,--no-undefined
endif

ifeq ($(MACOS_OLD),true)
BUILD_CXX_FLAGS = $(BASE_FLAGS) $(CXXFLAGS) -DHAVE_CPP11_SUPPORT=0
endif

ifeq ($(WINDOWS),true)
# Always build statically on windows
LINK_FLAGS     += -static -static-libgcc -static-libstdc++
endif

# ---------------------------------------------------------------------------------------------------------------------
# Strict test build

ifeq ($(TESTBUILD),true)
BASE_FLAGS += -Werror -Wcast-qual -Wconversion -Wformat -Wformat-security -Wredundant-decls -Wshadow -Wstrict-overflow -fstrict-overflow -Wundef -Wwrite-strings
BASE_FLAGS += -Wpointer-arith -Wabi -Winit-self -Wuninitialized -Wstrict-overflow=5
# BASE_FLAGS += -Wfloat-equal
ifeq ($(CC),clang)
BASE_FLAGS += -Wdocumentation -Wdocumentation-unknown-command
BASE_FLAGS += -Weverything -Wno-c++98-compat -Wno-c++98-compat-pedantic -Wno-padded -Wno-exit-time-destructors -Wno-float-equal
else
BASE_FLAGS += -Wcast-align -Wunsafe-loop-optimizations
endif
ifneq ($(MACOS),true)
BASE_FLAGS += -Wmissing-declarations -Wsign-conversion
ifneq ($(CC),clang)
BASE_FLAGS += -Wlogical-op
endif
endif
CFLAGS     += -Wold-style-definition -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes
CXXFLAGS   += -Weffc++ -Wnon-virtual-dtor -Woverloaded-virtual
endif

# ---------------------------------------------------------------------------------------------------------------------
# Set shared lib extension

ifeq ($(MACOS),true)
LIB_EXT = .dylib
else ifeq ($(WASM),true)
LIB_EXT = .wasm
else ifeq ($(WINDOWS),true)
LIB_EXT = .dll
else
LIB_EXT = .so
endif

# ---------------------------------------------------------------------------------------------------------------------
# Set shared library CLI arg

ifeq ($(MACOS),true)
SHARED = -dynamiclib
else ifeq ($(WASM),true)
SHARED = -sSIDE_MODULE=2
else
SHARED = -shared
endif

# ---------------------------------------------------------------------------------------------------------------------
# Handle the verbosity switch

SILENT =

ifeq ($(VERBOSE),1)
else ifeq ($(VERBOSE),y)
else ifeq ($(VERBOSE),yes)
else ifeq ($(VERBOSE),true)
else
SILENT = @
endif

# ---------------------------------------------------------------------------------------------------------------------
# Protect against multiple inclusion

endif # DIE_PLUGINS_MAKEFILE_BASE_INCLUDED

# ---------------------------------------------------------------------------------------------------------------------
