# What this version changes vs the rigorous branch

Base: the `rigorous` branch (`bfa3e06`, `140aeae`). This document records
every change made on top of it, grouped by area, with the identifier of the
review finding or design-critique item that motivated it in parentheses
(`slug-style` ids are the class review's findings; `R-n` are its confirmed
fixes and `Q-n` the critique's "missing" items). `CHANGELOG.md` is the short
release history; `README.md` documents the resulting API.

Constraints that held throughout: colour stays and is improved, not removed;
the measure, `\parskip`, `\parindent` and the type scale are unchanged; every
public command keeps its signature; the default `titlestyle` is `rigorous`.

## 1. Colour system

- The four semantic callout colours are no longer hard-coded hexes that
  ignored the `palette` option (Guidance failed 4.5:1 at 3.60, Discussion
  read as black at 1.27 vs ink). `semantic_palette.py` generates one block per
  palette (`\csdef{IP@sem@navy|teal|slate}`: `ipTakeaway`, `ipDiscussion`,
  `ipGuidance`, `ipObservation`, their `...Tint`s, `ipOurs`, `ipFindingTint`)
  in OKLCH, pasted into the class; the option value selects the block.
  (critique A, adopted by both reviewers)
- Hue system: Takeaway = accent hue, Discussion = accent +80 deg, Guidance =
  accent -62 deg, Observation = accent hue at chroma 0.010; one chroma per
  palette (navy 0.090, teal 0.085, slate 0.075). Minimum pairwise OKLab dE is
  9.1 / 9.0 / 8.2. (critique A + B)
- Bars sit on a lightness ladder, OKLab L 0.44 / 0.47 / 0.50 / 0.54 (Takeaway
  darkest), so a grayscale print keeps their order; Takeaway stays >= 2:1
  against body ink and Observation >= 5:1 for white text. (critique C)
- Generator gates: white-on-bar >= 5:1, bar vs ink >= 2:1, pairwise dE >= 8,
  exit 1 on failure; deuteranopia/protanopia simulation (Machado 2009) is
  reported as advisory. Under full CVD Discussion/Guidance can converge, which
  is why the printed label, not the hue, carries the role. (Q1)
- `ipOurs` (table row tint) is the accent at the callout-tint lightness
  instead of neutral `ipPanel`. (critique A; R2, R4, R10)
- New `ipLink` colour drives `\hypersetup` link/cite/url colours: equal to
  `ipAccent` in navy and teal, a steel blue `#2F5F8F` in slate, whose accent
  is too close to body ink for links to be recognisable (6.66:1 on white,
  >= 5.9:1 on every slate tint). (`slate-accent-indistinct`)

## 2. The callout family

- One grammar for every box (`ipcallout`): square corners, boxsep 0, 10pt
  inset (`\IP@boxinset`), top 7 / bottom 8pt, before/after skip 11pt plus 2pt
  minus 1pt, `\small` body at linespread 1.08 (`\IP@calloutbody`, overridable
  from the preamble), break padding. (critique A)
- Frames are 0.45pt stroked `borderline`s (`ipframe`), not tcolorbox's filled
  frame, which vanished at 100-112 dpi. (critique A)
- Semantic boxes (`takeaway`, `discussion`, `practicalguidance`,
  `observation`): solid title bar, white sans bold tracked-caps label
  (`\IP@boxlabel`, `\IP@boxcaps`), auto counter; a zero-width strut
  (`\IP@boxstrut`, height 5.4pt depth 1.6pt) fixes the bar at 12-13pt
  whatever the label's letters (R3); a box that breaks across pages repeats
  its bar as `WORD n (CONTINUED)` (Q3). The bar geometry is one shared style
  (`iptitlerow`) used by the semantic boxes and `promptbox`.
- `finding` is the quiet member: accent hairlines north/south over
  `ipFindingTint`, accent caps label on its own line, `unbreakable` so the
  hairlines are never lost at a page break (R6). `keybox` is the same box
  under its old name with its old default label `Key takeaway` (R5); `[]`
  suppresses the label line instead of printing a stray period (R4).
- `promptbox`: `ipRule` stroked frame, white title row, gray caps title,
  `(continued)` after a break. (critique C)
- `promptbox*`: new verbatim variant (`\newtcblisting` on the same `ipprompt`
  style): `{ } _ # % & \` are literal, source line breaks are kept, long lines
  wrap at spaces, common smart punctuation and accented letters are mapped
  through `literate`; writes `<jobname>.listing` only when used.
  (`promptbox-needs-escaping`)
- cleveref names for the four counters, registered only if the document loads
  cleveref: `\cref{tk:a}` prints `Takeaway 1` instead of `??`. (R5)

## 3. Title page, metadata and header

- First-page header is 32pt high (was 26pt): a two-line logo no longer
  triggers fancyhdr's headheight warning; the body position is unchanged and
  the first-page rule is 0.5pt (was 0.8pt). (R1, R9)
- One label voice on the title page: the tag, the `Date`/`Contact`/`\metadata`
  keys and the `Abstract` heading are sans scriptsize gray tracked caps
  (`\IP@label`); authors are regular weight; the hairline above the abstract
  is gone and the closing hairline is drawn even without an abstract.
  (critique B, design critique)
- The title stays 22/27 bold serif in `rigorous`. (reviewer decision)
- `\linkitem{icon}{word}{url}`: footnotesize accent icon plus regular sans
  word in ink, items separated by faint middle dots; an empty icon argument is
  allowed; the 3-argument signature is kept and icons are no longer gated by
  title style. (critique B; R9)
- `\author{A \and B}` works: `\and` is a `\quad` separator inside the author
  group of both heading macros. (`author-and-fatal`)
- `\thanks{...}` inside `\author` prints symbol-marked notes; `\maketitle`
  runs in a group with `\thefootnote` = `\@fnsymbol` and the title footnotes
  unlinked (`\H@@footnotemark`/`\H@@footnotetext`), then clears `\@thanks` and
  resets the footnote counter so body footnotes restart at 1. This also
  removes the "Ignoring empty anchor" warning. (`thanks-dropped`, subsumes
  `hyperref-empty-anchor`)
- `\thanks` texts and `\firstpagenote` are emitted right after the heading
  (rigorous and open) or before the panel (panel), so a title block that fills
  page 1 or breaks onto page 2 still puts its notes on page 1; both emitters
  are idempotent (`\ifIP@notesdone`). (`first-page-note-stays-on-page-1`)
- `\begin{abstract}...\end{abstract}` works in addition to `\abstract{...}`,
  before `\begin{document}`, before `\maketitle` or after it (then typeset in
  place: open box in `open`, the rigorous block otherwise). In `rigorous`
  style an abstract given after `\maketitle` lands below the closing hairline;
  the README says to put it before. (`abstract-env-eats-char`)
- `\papertag{}` removes the tag line and its gap. (`empty-papertag-gap`)
- `\metadata{L}{}` (hence `\date{}`, `\correspondence{}`) prints nothing; a
  label wider than the 6.2em column (e.g. CORRESPONDING AUTHOR) is set at
  natural width plus 0.8em instead of being overprinted by its value.
  (`empty-date-label`, `metadata-label-overflow`)
- Running head falls back to `\title` when `\shorttitle` is unset (line
  breaks flattened to spaces) and is set in `ipGray` (5.78:1) instead of
  `ipFaint`, matching the footer and the label voice.
  (`shorttitle-no-fallback`, `running-head-low-contrast`)
- `\maketitle` writes PDF Title/Author from `\title`/`\author` with `\\`,
  `\quad`, `\and`, `\textsuperscript` and `\thanks` neutralised for those two
  strings only. (`pdf-title-author-metadata-missing`)
- The open abstract box and the panel are `breakable`; the rigorous abstract
  is a plain paragraph block with the geometry of the former
  `center`/`minipage` (pixel-identical, but breakable), so a 9-author,
  600-word title block continues on page 2 instead of leaving page 1 empty.
  (`panel-unbreakable-overflow`)
- The panel footer row is emitted only when there is metadata or a
  `\panellogo`; under `titlealign=center` it is a centred stack.
  (`panel-footer-row-empty-and-center-misaligned`)
- The panel abstract is `\raggedright` (a no-op in the default left
  alignment). (`center-abstract-centered-paragraph`)
- `\placeholderlogo[fill|outline]{Mark}{Text\\Text}`: a TikZ badge plus a
  tabular, needing no image files and no `positioning` library, so deleting
  the pgfplots lines from the demo no longer breaks `\maketitle`. The 0.3333em
  on both sides of the text reproduces the inner sep of the node it replaced,
  so old renders are unchanged. (`logos-break-without-pgfplots`)

## 4. Class options, engines and package loading

- `\ProvidesClass{inkpaper}[2026/10/16 v0.1.0 ...]`; the version appears in
  every log. (`no-version-identifier`)
- Engine guard: XeLaTeX and LuaLaTeX stop with one class error and no PDF
  (`\expandafter\@@end` so nonstopmode cannot write a mis-fonted PDF); plain
  `latex` (DVI) still compiles. (`no-engine-guard-xelatex-lualatex`)
- `numbers` and `nonatbib` options; natbib is loaded inside
  `\ifIP@nonatbib\else ... \fi` as `[numbers,sort&compress]` or `[round]`, and
  the natbib-only settings (`\bibfont`, `\bibsep`, `\bibsection`) live in that
  branch so `[nonatbib]` + biblatex compiles.
  (`package-option-clash-natbib-hyperref-geometry-enumitem`)
- `twocolumn` raises a class error; `onecolumn` still passes through.
  (`twocolumn-broken`)
- `palette`, `titlestyle` and `titlealign` values are validated right after
  the palette chain; a typo is a class error instead of a silent fallback to
  navy / rigorous / left. (`invalid-option-values-silent`)
- `\IP@base` (10 / 10.95 / 12pt from `\@ptsize`) and
  `\IP@fontsize{<size>}{<skip>}`: section 1.25/1.5, subsection 1.05/1.3,
  open/panel title 2.1/2.6, rigorous title 2.2/2.7, authors 1.05/1.4, the
  Appendix word 2.0/2.4. At 10pt the output is unchanged; at 11pt/12pt the
  heading-to-body ratios stay constant. (`11pt-12pt-heading-scale-inverted`)
- The hard-coded `letterpaper` is gone from the geometry call, so
  `a4paper`/`letterpaper` reach geometry (default still letter).
  (`a4paper-ignored`)
- `amssymb` and `amsthm` are loaded before `newpxtext`/`newpxmath`, so a user
  `\usepackage{amssymb,amsthm}` is a no-op and no msam/msbm fonts are
  embedded. (`amsthm-amssymb-clash-newpxmath`)
- microtype no longer passes `expansion=true` (a hard error under
  latex/dvips; expansion is enabled automatically in PDF mode).
  (`dvi-mode-expansion-true-breaks-arxiv-fallback`)

## 5. Body typography and components

- `\footnoterule` has zero net height (`\kern-4.4pt`, 0.4pt rule,
  `\kern 4pt`) and `\skip\footins` is 13.4pt plus 4pt minus 2pt: same visual
  gap, correctly accounted, so a full page with footnotes is no longer 4.4pt
  overfull. (`footnoterule-nonzero-height`)
- Run-in `\paragraph` heads get their period only when the title does not
  already end in `. : ? !`. (`runin-double-period`)
- `enumerate` uses `leftmargin=*, labelindent=0pt, widest=10`: two-digit
  labels start on the margin instead of protruding into it.
  (`enumerate-two-digit-label-protrudes`)
- `\sidefigure[ratio]<placement>{content}{caption}` takes a float placement
  (default `t`, was fixed); a bare specifier in the bracket slot,
  `\sidefigure[h]{..}{..}`, is routed to the placement instead of dying with
  "Missing number"; `\sidefigure[0.6]{..}{..}` is unchanged.
  (`sidefigure-fixed-placement`, compatibility check)
- `\tableofcontents` in the body uses the appendix contents styles
  (`section`/`subsection`/`subsubsection`); References gets a TOC entry and a
  PDF bookmark via `\bibsection`.
  (`tableofcontents-unstyled-and-references-unbookmarked`)
- Under `\DocumentMetadata{tagging=on}` the appendix mini-TOC is emitted as an
  artifact (`\tagmcbegin{artifact}` + `\SuspendTagging`), with a
  `\providecommand{\IfDocumentMetadataTF}` fallback for kernels before 2022.
  (`tagged-pdf-structure-invalid`)
- References are set in `\small` with `\bibsep` 0.35em plus 0.1em.
  (`bibliography-font-and-spacing`)
- Table captions: `position=top, singlelinecheck=true`, so a one-line caption
  is centred over its tabular; `threeparttable` is preloaded to set a long
  caption to the tabular's width. (`table-caption-flush-left-over-centered-table`)
- pgfplots presets `inkpaper` (lines) and `inkpaper bars` (ybar on the
  ipRule -> ipFaint!70 -> ipAccent!55 -> ipAccent ramp), plus
  `\figurewidth`/`\figureheight`, defined only when the document loads
  pgfplots. Imported from the typography study, rewritten in this colour
  vocabulary; the presets reproduce the hand-styled demo exactly.
- Float policy: `\topfraction` 0.85, `\bottomfraction` 0.6, `\textfraction`
  0.1, `\floatpagefraction` 0.75, `topnumber` 3, `totalnumber` 4; float
  separations stay at article's defaults. (typography study)
- `\frenchspacing` by default; `\nonfrenchspacing` in the preamble restores
  the wide sentence space. This reflows every text page. (typography study)

## 6. The demo (`main.tex`)

- Both header logos use `\placeholderlogo`; the `positioning` library line is
  gone. (`logos-break-without-pgfplots`)
- `\begin{takeaway}[label=tk:main]` and a `finding` citing `Takeaway 1`
  (Q5); a short `observation` after the equation so all six callouts appear
  once, each separated by running text (Q2).
- Table preamble `lccccc` without `@{}` so the `\oursrow` tint ends on the
  booktabs rules; the table is wrapped in `threeparttable`; a DeepResearch
  column was added. (critique A; R10; `example-feature-coverage`)
- Contact e-mail appears once; the first-page note reads "Preprint, work in
  progress. Code and checkpoints will be released on the project page."
  (`example-text-nits`)
- `\metadata{Version}{v1 (under review)}` row; a comment on line 2 lists the
  other looks. (`example-feature-coverage`)
- Experiments section expanded: `\paragraph{Setup}` with a body footnote to
  the appendix, an enumerate of the benchmarks, `Main results`, a judge-sample
  ablation on the `inkpaper` preset, and a `Limitations` section. The demo is
  five pages (the appendix fills page 5; page 4 is about half full). A
  four-page cut that drops the ablation and Limitations was prepared and not
  shipped. (`example-float-layout-near-empty-page`)
- Appendix adds a `promptbox*` with raw braces, `#` and `_`, labelled from the
  Setup footnote. (`promptbox-needs-escaping`)

## 7. Repository and tooling

- `semantic_palette.py` (new): generator, contrast report and gates; `--tex`
  emits the class blocks, `--swatch` a PNG.
- `spec.tex` (new): one-page callout specimen built by `make spec` for
  navy/teal/slate via `\PassOptionsToClass`; the visual regression page.
- `Makefile`: `-halt-on-error`; `spec`, `palette`, `preview` (150 dpi page-1
  PNG) and `arxiv` targets (sources + `.bbl`, `COPYFILE_DISABLE=1`); clean
  rules for the specimen jobs and the `.listing`/`.ptc` scratch files.
  (`no-preview-image`, `no-arxiv-bundle-target`,
  `makefile-gitignore-inconsistency`)
- `.latexmkrc` (new): pdflatex, `-halt-on-error`, `-file-line-error`,
  `$clean_ext = 'ptc listing'`.
- `.gitignore`: build products only; the dead `build/` and `preview/` entries
  are gone; `main.pdf` and `preview.png` are committed on purpose. (R7)
- `.github/workflows/build.yml` (new): rebuilds the example, fails if the
  committed `main.pdf` text differs from the fresh build, runs the colour
  gates, uploads the PDF. (`no-ci-build`)
- `README.md`: complete option and command tables, callout key and usage
  guidance, logo recipes, Requirements with the TeX Live collection table,
  Overleaf badge, arXiv section, Upgrading notes from both earlier releases.
  (`readme-command-reference-incomplete`, `readme-requirements-and-engines`,
  `no-overleaf-link`)
- `CHANGELOG.md` (new) with the v0.1.0 entry matching `\ProvidesClass`.

## 8. Final maintenance pass (pixel-neutral)

- `etoolbox` is loaded next to `kvoptions` instead of mid-way through the
  colour block.
- The palette dispatch is `\csuse{IP@sem@\IP@palette}`; the navy fallback was
  unreachable once the option values are validated.
- `\ipRuninTitle` renamed `\IP@runintitle` (private helper, private prefix).
- The three copies of the footer page number are one `\IP@pagenumber`.
- The title-row geometry shared by the semantic boxes and `promptbox` is one
  `iptitlerow` style.
- A dead second `\global\let\@thanks\@empty` after `\maketitle`'s group was
  removed (`\IP@titlenotes` already clears it).
- Comments added for the 32pt headheight, the microtype expansion note and
  the placeholder logo's 0.3333em gaps.
- Running-head fallback flattens `\\` in `\title` to a space.

## Not adopted

- `type-scale-hierarchy`: changes heading sizes; conflicts with the frozen
  type scale.
- `tabularx` full-width table: reintroduces `@{}` edges and an unloaded
  package; `threeparttable` solves the caption alignment.
- `\sidefigure` with a second `[..]` optional argument: ambiguous with the
  ratio; `<placement>` plus the bare-specifier detection is used instead.
- `license-holder-vs-author`: rejected by the review; LICENSE untouched.
- `\pdfoutput=1` in `main.tex`: arXiv asks not to use it and auto-detects
  pdfLaTeX.
- From the typography study: the 5.3in measure, 14pt grid, `\parindent`,
  extra palettes, `paragraphs=` option, `ipSeries*`/`ipGrid`, footmisc,
  siunitx columns, `notebox`, `\bibhang`, 14pt float separations.
- From the design critiques: run-in labels, near-monochrome footprint,
  white-body finding, 20/25 title, serif small-caps Abstract, mono caps prompt
  title, pastel title rows, rotating hues with Takeaway off the accent,
  frameless bodies, mixed-case bold labels, neutral `\oursrow`, text-size
  callout bodies (available as the documented `\IP@calloutbody` override).
- CI `make spec` step: needs make and latexmk inside the TeX action container;
  not testable here, so the workflow stays minimal.
- `make distclean` deleting `preview.png`: it is a committed asset.

## Known limitations

- `biber` is not installed on the build machine, so `[nonatbib]` + biblatex
  was verified with `backend=bibtex`; the class has no backend-specific code.
- `\begin{abstract}` after `\maketitle` in `rigorous` style sits below the
  closing hairline; in `panel` style it falls back to the rigorous block.
- The open abstract box's continuation on page 2 carries no "(continued)"
  label (only the west line and tint).
- In the left-aligned `panel` style a title block that fills page 1 breaks the
  panel onto page 2 (a short tinted continuation with the metadata rows).
- The `inkpaper` preset uses `axis lines*=left` (no arrow tips); the demo's
  Figure 2 keeps explicit `axis lines=left` with arrows, so both looks appear.
- `zi4` has no italic: `\verb`/`\texttt` inside italic text logs a font-shape
  substitution, as in every earlier release.
- A `wrapfigure` started near a page bottom can overlap the footer (wrapfig's
  own limitation).

## Verification summary

- Default demo: `latexmk -C; make` -> 5 pages, PDF Title/Author set, zero
  warnings and zero over/underfull boxes outside microtype's info lines;
  `make spec` -> three one-page specimens, zero warnings; `make arxiv` bundle
  compiles with three plain pdflatex runs and no bibtex.
- Pixel comparison at 100 dpi against the renders from before this release's
  class work: every differing region is attributable to the intended changes
  (placeholder logos, Version row, `\frenchspacing` reflow, footnote-rule
  accounting, centred table caption, `\small` references, the expanded demo);
  callout bars, frames, tints, label voice, measure, parskip, indent and type
  scale show no differing rows. The final maintenance pass is pixel-identical
  on all five demo pages and the navy specimen.
- Options matrix: a4paper/letter/default page sizes; 10/11/12pt with constant
  heading ratios; `twocolumn` and misspelt values stop with class errors;
  `[numbers]` and `[nonatbib]` + biblatex; xelatex/lualatex refused with no
  PDF; `\thanks` + `\and`; abstract in all three positions; `\date{}`,
  `\papertag{}`, no `\shorttitle`; `promptbox*` with raw characters; the
  `\sidefigure` forms; a 9-page footnote stress with zero overfull boxes; the
  original main-branch demo (panel, tikz logos, keybox, `@{}` table,
  `\sidefigure[0.6]`) and the original rigorous demo both compile with the
  final class, 4 pages each.
- Layout matrix: all title styles x palettes x alignments, logos/no logos,
  3-line title, 9 authors, 395-word abstract, no abstract, no links/metadata,
  bare title, box breaking across pages, boxes back to back, box after a
  heading, 10+ enumerate items, body `\tableofcontents`, cleveref names.
