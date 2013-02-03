SHELL := /usr/bin/env bash
THEME = theme.sed
NANO_VERSION := 2.2

~/.nanorc: *.nanorc mixins/*.nanorc $(THEME)
	cat *.nanorc | sed -f mixins.sed | sed -f $(THEME) $(FILTER) > $@

ifeq ($(shell test -f ~/.nanotheme && echo 1),1)
  THEME = ~/.nanotheme
endif

ifeq ($(shell echo -e "$(NANO_VERSION)\n`nano -V | head -1 | sed 's/^ *//g' | cut -d \  -f 4`" | sort -nr | head -1),$(NANO_VERSION))
  OLDNANO = 1
endif

ifdef OLDNANO
  FILTER += | sed -e '/^header/d;/^bind/d;/^set undo/d'
endif

ifdef TEXT
  FILTER += | sed -e 's|^color \(bright\)\{0,1\}black|color \1$(TEXT)|'
endif

ifdef BSDREGEX
  FILTER += | sed -e 's|\\<|[[:<:]]|g;s|\\>|[[:>:]]|g'
endif


.PHONY: ~/.nanorc
