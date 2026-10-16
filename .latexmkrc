# latexmk configuration. Overleaf reads the same file if it is named
# `latexmkrc` (no dot) in the project root.
$pdf_mode = 1;   # pdflatex only: the class refuses xelatex/lualatex (Type 1 fonts via fontenc)
$pdflatex = 'pdflatex -interaction=nonstopmode -halt-on-error -file-line-error %O %S';
# Extra generated files removed by `latexmk -c`: the titletoc partial contents
# written by \beginappendix (.ptc) and the listings scratch file written by
# promptbox* (.listing).
$clean_ext = 'ptc listing';
