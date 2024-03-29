#!/usr/bin/make -f
# Makefile for ACE #
# ---------------- #
# Created by falkTX
#

# --------------------------------------------------------------
# Project name, used for binaries

NAME = a-fluidsynth

# --------------------------------------------------------------
# Files to build

FILES = \
	$(NAME).cc \
	fluidsynth/src/fluid_adsr_env.c \
	fluidsynth/src/fluid_chan.c \
	fluidsynth/src/fluid_chorus.c \
	fluidsynth/src/fluid_conv.c \
	fluidsynth/src/fluid_defsfont.c \
	fluidsynth/src/fluid_event.c \
	fluidsynth/src/fluid_gen.c \
	fluidsynth/src/fluid_hash.c \
	fluidsynth/src/fluid_iir_filter.c \
	fluidsynth/src/fluid_lfo.c \
	fluidsynth/src/fluid_list.c \
	fluidsynth/src/fluid_midi.c \
	fluidsynth/src/fluid_mod.c \
	fluidsynth/src/fluid_rev.c \
	fluidsynth/src/fluid_ringbuffer.c \
	fluidsynth/src/fluid_rvoice.c \
	fluidsynth/src/fluid_rvoice_dsp.c \
	fluidsynth/src/fluid_rvoice_event.c \
	fluidsynth/src/fluid_rvoice_mixer.c \
	fluidsynth/src/fluid_samplecache.c \
	fluidsynth/src/fluid_settings.c \
	fluidsynth/src/fluid_sffile.c \
	fluidsynth/src/fluid_sfont.c \
	fluidsynth/src/fluid_synth.c \
	fluidsynth/src/fluid_synth_monopoly.c \
	fluidsynth/src/fluid_sys.c \
	fluidsynth/src/fluid_tuning.c \
	fluidsynth/src/fluid_voice.c

# --------------------------------------------------------------
# Extra params

CUSTOM_BUILD_FLAGS  = -DHAVE_CONFIG_H -DDEFAULT_SOUNDFONT=\"\"
CUSTOM_BUILD_FLAGS += -DHAVE_COSF=1 -DHAVE_FABSF=1 -DHAVE_LOGF=1 -DHAVE_POWF=1 -DHAVE_SINF=1 -DHAVE_SQRTF=1
CUSTOM_BUILD_FLAGS += -Ifluidsynth -Ifluidsynth/fluidsynth -Ifluidsynth/src
CUSTOM_BUILD_FLAGS += $(shell pkg-config --cflags gthread-2.0 glib-2.0 sndfile) -pthread

CUSTOM_LINK_FLAGS   = $(shell pkg-config --libs gthread-2.0 glib-2.0 sndfile) -pthread

# import base definitions, to test for target OS
include ../../Makefile.base.mk

ifeq ($(DISABLE_OPENMP),)
ifneq ($(MACOS),true)
ifneq ($(WASM),true)
CUSTOM_BUILD_FLAGS += -DHAVE_OPENMP -fopenmp
CUSTOM_LINK_FLAGS  += -fopenmp
endif
endif
endif

ifeq ($(WINDOWS),true)
CUSTOM_BUILD_FLAGS += -DFLUIDSYNTH_NOT_A_DLL -DWIN32
CUSTOM_LINK_FLAGS  += -lole32 -lws2_32
endif

# --------------------------------------------------------------
# Do some magic

include ../../Makefile.plugins.mk

# --------------------------------------------------------------
