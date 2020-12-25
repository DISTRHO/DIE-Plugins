#!/usr/bin/make -f
# Makefile for DIE-Plugins #
# ------------------------ #
# Created by falkTX
#

include Makefile.base.mk

PREFIX ?= /usr/local

# --------------------------------------------------------------

all: build

# --------------------------------------------------------------

build:
	$(MAKE) -C plugins/a-comp.lv2
	$(MAKE) -C plugins/a-delay.lv2
	$(MAKE) -C plugins/a-eq.lv2
	$(MAKE) -C plugins/a-exp.lv2
	$(MAKE) -C plugins/a-fluidsynth.lv2
	$(MAKE) -C plugins/a-reverb.lv2

# --------------------------------------------------------------

clean:
	$(MAKE) clean -C plugins/a-comp.lv2
	$(MAKE) clean -C plugins/a-delay.lv2
	$(MAKE) clean -C plugins/a-eq.lv2
	$(MAKE) clean -C plugins/a-exp.lv2
	$(MAKE) clean -C plugins/a-fluidsynth.lv2
	$(MAKE) clean -C plugins/a-reverb.lv2

# --------------------------------------------------------------

install:
	install -d $(DESTDIR)$(PREFIX)/lib/lv2/distrho-a-comp.lv2
	install -d $(DESTDIR)$(PREFIX)/lib/lv2/distrho-a-delay.lv2
	install -d $(DESTDIR)$(PREFIX)/lib/lv2/distrho-a-eq.lv2
	install -d $(DESTDIR)$(PREFIX)/lib/lv2/distrho-a-exp.lv2
	install -d $(DESTDIR)$(PREFIX)/lib/lv2/distrho-a-fluidsynth.lv2
	install -d $(DESTDIR)$(PREFIX)/lib/lv2/distrho-a-reverb.lv2

	install -m 644 bin/distrho-a-comp.lv2/*.*       $(DESTDIR)$(PREFIX)/lib/lv2/distrho-a-comp.lv2/
	install -m 644 bin/distrho-a-delay.lv2/*.*      $(DESTDIR)$(PREFIX)/lib/lv2/distrho-a-delay.lv2/
	install -m 644 bin/distrho-a-eq.lv2/*.*         $(DESTDIR)$(PREFIX)/lib/lv2/distrho-a-eq.lv2/
	install -m 644 bin/distrho-a-exp.lv2/*.*        $(DESTDIR)$(PREFIX)/lib/lv2/distrho-a-exp.lv2/
	install -m 644 bin/distrho-a-fluidsynth.lv2/*.* $(DESTDIR)$(PREFIX)/lib/lv2/distrho-a-fluidsynth.lv2/
	install -m 644 bin/distrho-a-reverb.lv2/*.*     $(DESTDIR)$(PREFIX)/lib/lv2/distrho-a-reverb.lv2/

# --------------------------------------------------------------

.PHONY: build
