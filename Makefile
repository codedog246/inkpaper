LATEXMK ?= latexmk
MAIN ?= main

.PHONY: all clean distclean

all:
	$(LATEXMK) -pdf -interaction=nonstopmode $(MAIN).tex

clean:
	$(LATEXMK) -c $(MAIN).tex

distclean:
	$(LATEXMK) -C $(MAIN).tex
