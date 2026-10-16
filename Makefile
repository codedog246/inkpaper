LATEXMK ?= latexmk
MAIN ?= main
LATEXMKFLAGS = -pdf -interaction=nonstopmode -halt-on-error

.PHONY: all spec palette clean distclean

all:
	$(LATEXMK) $(LATEXMKFLAGS) $(MAIN).tex

# One-page callout specimen in each palette (visual regression page).
spec:
	for p in navy teal slate; do \
	  $(LATEXMK) $(LATEXMKFLAGS) -jobname=spec-$$p \
	    -usepretex='\PassOptionsToClass{palette='$$p'}{inkpaper}' spec.tex; \
	done

# Print the generated callout colour blocks and their contrast report.
palette:
	python3 semantic_palette.py
	python3 semantic_palette.py --tex

clean:
	$(LATEXMK) -c $(MAIN).tex
	-$(LATEXMK) -c -jobname=spec-navy spec.tex
	-$(LATEXMK) -c -jobname=spec-teal spec.tex
	-$(LATEXMK) -c -jobname=spec-slate spec.tex

distclean:
	$(LATEXMK) -C $(MAIN).tex
	-$(LATEXMK) -C -jobname=spec-navy spec.tex
	-$(LATEXMK) -C -jobname=spec-teal spec.tex
	-$(LATEXMK) -C -jobname=spec-slate spec.tex
