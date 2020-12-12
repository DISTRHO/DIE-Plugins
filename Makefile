#!/usr/bin/make -f
# Makefile for ACE #
# ---------------- #
# Created by falkTX
#

include Makefile.base.mk

all: build

# --------------------------------------------------------------

build:
	$(MAKE) -C plugins/a-comp.lv2
	$(MAKE) -C plugins/a-delay.lv2
	$(MAKE) -C plugins/a-eq.lv2
	$(MAKE) -C plugins/a-exp.lv2
# 	$(MAKE) -C plugins/a-fluidsynth.lv2
	$(MAKE) -C plugins/a-reverb.lv2

# --------------------------------------------------------------

clean:
	$(MAKE) clean -C plugins/a-comp.lv2
	$(MAKE) clean -C plugins/a-delay.lv2
	$(MAKE) clean -C plugins/a-eq.lv2
	$(MAKE) clean -C plugins/a-exp.lv2
# 	$(MAKE) clean -C plugins/a-fluidsynth.lv2
	$(MAKE) clean -C plugins/a-reverb.lv2

# --------------------------------------------------------------

.PHONY: build
