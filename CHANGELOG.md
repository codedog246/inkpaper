# Changelog

All notable changes to InkPaper are recorded here. The version string also
appears in `\ProvidesClass` at the top of `inkpaper.cls` and in the first lines
of every compile log (`Document Class: inkpaper <date> v<version> ...`).
`CHANGES.md` gives the per-change rationale against the first `rigorous`
branch.

## v0.1.0 - 2026-10-16

First tagged release; earlier commits had no version string.

### Title page and options

- Three title styles: `rigorous` (default; Times, bold serif title, abstract
  in a light blue box, Date/Contact/metadata in the first-page footnote with
  `\firstpagenote`, black 0.8pt header rule), `open` (tinted abstract box)
  and `panel` (everything in a tinted box); `titlealign=center|left` (centre
  is the default); `palette=navy|teal|slate`.
- Page design from the upstream `rigorous` branch: `newtx` text and math,
  1.05in side margins, `\linespread{1.03}`, 1.1em paragraph indent, ink
  `#14171C`; metadata labels and links are bold black sans at text size.
- `numbers` option for numeric `[1]` citations and `nonatbib` to skip natbib
  so biblatex can be loaded.
- `a4paper`/`letterpaper` and `11pt`/`12pt` are honoured; headings and the
  title scale with the body size. `twocolumn` and misspelt option values stop
  with a class error instead of falling back silently.
- Engine guard: the class requires pdfLaTeX and stops with one class error
  (and no PDF) under XeLaTeX or LuaLaTeX. Plain `latex` (DVI) compiles.
- `\thanks{...}` inside `\author` works as in `article`; `\author{A \and B}`
  no longer fails; `\begin{abstract}...\end{abstract}` works in addition to
  the `\abstract{...}` command.
- `\papertag{}` removes the open/panel tag line and empties the running
  head; `\date{}`, `\correspondence{}`, `\code{}` and `\metadata{X}{}` print
  nothing; wide metadata labels no longer overprint their value;
  `\shorttitle` falls back to `\title` (line breaks flattened; a document
  with neither gets an empty running head instead of a kernel error); the
  running head is set in `ipGray`; the first-page header is 32pt high.
- `\maketitle` writes the PDF Title and Author metadata; `ipLink` colours
  hyperlinks (steel blue in `slate`, the accent otherwise); all three abstract
  renderings and the panel break across pages; the panel footer row is only
  emitted when non-empty and stacks in `titlealign=center`; the `\thanks`
  texts and the first-page footnote line stay on page 1 when the title block
  fills or breaks past it.

### Callouts and body

- Colour-coded callout family generated per palette by `semantic_palette.py`
  (OKLCH): numbered `takeaway`, `discussion`, `practicalguidance` and
  `observation` boxes with solid title bars on a lightness ladder;
  `finding` (and its legacy name `keybox`) as the quiet member; `promptbox`
  as the neutral member; one label voice (sans bold tracked caps).
- `promptbox*`: verbatim variant for raw prompts, JSON and templates
  (`{ } _ # % & \` literal, source line breaks kept, common non-ASCII
  punctuation mapped).
- `\placeholderlogo[fill|outline]{Mark}{Text\\Text}` for header logos that
  need no image files or extra packages (the example uses plain text marks).
- `\sidefigure[ratio]<placement>{content}{caption}` accepts a float
  placement (default `t`); a bare specifier in the bracket slot is accepted
  too.
- `\oursrow` shades a table row with `ipOurs`; `threeparttable` is preloaded
  so a table caption can be set to the width of its tabular.
- Enumerate labels sit on the margin for two-digit items; the footnote rule
  has zero net height (no overfull pages with footnotes); `\paragraph{Title}`
  adds its period only when the title does not already end in `. : ? !`.
- References are set in `\small`; `\tableofcontents` uses the appendix
  contents style; References gets a TOC entry and a PDF bookmark; the
  appendix mini-TOC is an artifact under `\DocumentMetadata{tagging=on}`.
- pgfplots presets `inkpaper` (lines) and `inkpaper bars` (ybar) plus the
  `\figurewidth`/`\figureheight` lengths, active only when the document loads
  pgfplots; float policy lets a page be mostly float before it is pushed;
  `\frenchspacing` by default (`\nonfrenchspacing` restores double spaces).
- A `\section` immediately followed by a `\subsection` can no longer be
  split across a page break (the heading colour whatsit no longer sits in
  the vertical list between them).

### Tooling

- `make` builds `main.pdf`; `make spec` builds the one-page callout specimen
  in each palette; `make palette` prints the colour report; `make preview`
  renders `preview.png` from page 1; `make arxiv` packs the sources and the
  generated `.bbl` into `main-arxiv.tar.gz`.
- `.latexmkrc` fixes pdfLaTeX, `-halt-on-error` and `-file-line-error`, and
  cleans the `.ptc` and `.listing` scratch files.
- GitHub Actions workflow (`.github/workflows/build.yml`) rebuilds the
  example, warns if the committed `main.pdf` is stale, runs the colour gates
  and uploads the PDF.
