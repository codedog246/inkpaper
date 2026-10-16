# InkPaper

A polished, institution-neutral, single-column LaTeX template for machine
learning and AI preprints.

InkPaper combines restrained typography with reusable components inspired by
modern research-lab technical reports, without embedding any organization's
branding.

## Features

- Three low-saturation palettes: `navy`, `teal`, and `slate`
- Rigorous, open, and panel-style title layouts
- Left-aligned or centered title blocks
- Optional institution and lab logos
- Metadata links for code, models, data, and project pages
- Colour-coded, numbered takeaway, discussion, guidance, and observation
  boxes whose colours are derived from the palette accent
- Formal finding statements, highlighted table rows, side captions, and
  appendix prompt blocks
- Styled appendix title and automatic appendix contents
- Standard `pdflatex` workflow suitable for arXiv

## Quick start

```latex
\documentclass[
  palette=navy,
  titlestyle=rigorous,
  titlealign=left
]{inkpaper}

\title{Your Paper Title}
\author{First Author, Second Author}
\affiliations{Your University or Research Organization}
\abstract{Your abstract.}

\begin{document}
\maketitle
\section{Introduction}
...
\end{document}
```

Compile the included example with:

```bash
make
```

The result is `main.pdf`. `make spec` builds the one-page callout specimen
(`spec-navy.pdf`, `spec-teal.pdf`, `spec-slate.pdf`), which shows every box
in each palette and is the visual regression page for the callout family.

## Class options

| Option | Values | Default |
| --- | --- | --- |
| `palette` | `navy`, `teal`, `slate` | `navy` |
| `titlestyle` | `rigorous`, `open`, `panel` | `rigorous` |
| `titlealign` | `left`, `center` | `left` |

For the formal single-column example shown in the repository:

```latex
\documentclass[
  palette=navy,
  titlestyle=rigorous,
  titlealign=left
]{inkpaper}
```

## Upgrading from the open/panel release

An existing `main.tex` compiles unchanged, but four things render
differently:

- The default `titlestyle` is now `rigorous`; pass `titlestyle=open` or
  `titlestyle=panel` explicitly to keep the previous title page.
- `keybox` is now the same box as `finding`: a short statement on a faint
  accent tint between two accent hairlines, with a small caps label on its
  own line. Its default label is still "Key takeaway". For a coloured,
  numbered callout use `takeaway` instead.
- `\oursrow` still shades the row, now with `ipOurs`, a tint of the palette
  accent generated with the callout colours. Write the table preamble
  without `@{}` at the outer edges (`lcccc`, not `@{}lcccc@{}`) so the tint
  ends exactly on the booktabs rules.
- `\code`, `\model`, `\data` and `\project` render as a small accent icon
  plus a regular-weight word, separated by middle dots. `\linkitem{}{Word}{url}`
  with an empty first argument gives a word without an icon.

## Components

```latex
\code{https://github.com/your-org/project}
\model{https://huggingface.co/your-org/model}
\data{https://huggingface.co/datasets/your-org/data}
\project{https://project.example.com}
\linkitem{\faFilePdf}{Slides}{https://example.com/slides}

\begin{takeaway}[label=tk:main]
\textbf{Primary conclusion.} Supporting evidence and scope.
\end{takeaway}

\begin{discussion}
\textbf{Connection to prior work.} A focused interpretation.
\end{discussion}

\begin{practicalguidance}
\textbf{Recommended practice.} Concrete guidance for practitioners.
\end{practicalguidance}

\begin{observation}
\textbf{Empirical pattern.} What was seen and under which conditions.
\end{observation}

\begin{finding}[Main finding]
The main finding in one or two sentences, consistent with Takeaway~\ref{tk:main}.
\end{finding}

\begin{keybox}[Key takeaway]   % legacy name; renders exactly like finding
...
\end{keybox}

\begin{promptbox}[Judge prompt]
Your prompt text.
\end{promptbox}

% In a tabular: tint the row of your own method (palette-aware), bold the best values
\oursrow \textbf{Ours} & \textbf{40.3} & \textbf{59.2} \\
```

### The callout family

Every callout shares one grammar: square corners, 0.45pt rules, a 10pt
inset, `\small` body text and one label voice (sans tracked caps, the same
voice as the PREPRINT tag and the running head). What the colour code means:

| Box | Colour | Use it for |
| --- | --- | --- |
| `takeaway` | palette accent hue, darkest bar | the conclusion a skimming reader must not miss |
| `discussion` | accent hue + 80 deg (plum in navy and slate, violet in teal) | interpretation, relation to prior work, caveats |
| `practicalguidance` | accent hue - 62 deg (teal in navy and slate, green in teal) | what a practitioner should do |
| `observation` | neutral gray, lightest bar | an empirical pattern, stated without interpretation |
| `finding` / `keybox` | accent hairlines on an accent tint, no bar | the formal result, one rank below the coloured boxes |
| `promptbox` | gray frame, white title row | quoted material (prompts, rubrics) |

The four coloured bars are generated per palette by `semantic_palette.py`
(OKLCH): one chroma per palette, hues anchored on the accent, and a small
lightness ladder (Takeaway darkest, Observation lightest) so a grayscale print
keeps their order; Takeaway and Discussion are close in gray, and under
red-green colour-vision deficiency Discussion and Guidance can converge, so
the printed label, not the hue alone, identifies the role. Every bar carries
white text at 5:1 or better.
Run `make palette` to see the contrast report and the generated colour blocks;
after changing the generator, paste its `--tex` output into the colours
section of `inkpaper.cls` and rebuild `make spec`.

Usage guidance:

- Keep at least one paragraph of running text between two callouts, and no
  more than three coloured callouts on a page; the bars are the loudest
  objects on the page by design.
- Labels are set in caps automatically; pass plain text (`[Key result]`),
  without a trailing period. An empty optional argument `[]` on `finding`
  or `keybox` suppresses the label line.
- The four numbered boxes take tcolorbox keys in their optional argument, so
  `\begin{takeaway}[label=tk:main]` makes `Takeaway~\ref{tk:main}` work; if
  the document loads `cleveref`, `\cref{tk:main}` prints "Takeaway 1".
  `finding`, `keybox` and `promptbox` take a title text, not keys.
- The numbered boxes may break across pages; the continuation repeats the
  bar with "(continued)". `finding`/`keybox` never break.
- To set callout bodies at text size instead of `\small`, put
  `\makeatletter\renewcommand{\IP@calloutbody}{\normalsize}\makeatother` in
  the preamble.

### Logos

`\leftlogo` and `\rightlogo` sit in a 32pt header. A two-line text logo
should set its font size outside the `tabular` and align on the bottom line,
as `main.tex` does:

```latex
\rightlogo{{\sffamily\scriptsize\begin{tabular}[b]{@{}r@{}}
  \bfseries Research Lab\\[-1pt]
  \color{ipGray}Institute Name
\end{tabular}}}
```

See `main.tex` for institutional headers, formal captions, tables, and
appendix formatting. The `open` and `panel` title styles remain available for
less conventional technical reports.

## Requirements

A reasonably complete TeX Live installation is recommended. The template uses
widely available packages including `newpx`, `sourcesanspro`, `tcolorbox`,
`fontawesome5`, and `titletoc`. `semantic_palette.py` needs only Python 3
(Pillow for the optional `--swatch` PNG).

## License

MIT
