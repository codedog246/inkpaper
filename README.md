# InkPaper

A polished, institution-neutral, single-column LaTeX template for machine
learning and AI preprints.

InkPaper combines restrained typography with reusable components inspired by
modern research-lab technical reports, without embedding any organization's
branding.

## Features

- Three low-saturation palettes: `navy`, `teal`, and `slate`
- Open and panel-style title layouts
- Left-aligned or centered title blocks
- Optional institution and lab logos
- Metadata links for code, models, data, and project pages
- Side captions, highlighted result rows, takeaway boxes, and prompt boxes
- Styled appendix title and automatic appendix contents
- Standard `pdflatex` workflow suitable for arXiv

## Quick start

```latex
\documentclass[
  palette=navy,
  titlestyle=panel,
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

The result is `main.pdf`.

## Class options

| Option | Values | Default |
| --- | --- | --- |
| `palette` | `navy`, `teal`, `slate` | `navy` |
| `titlestyle` | `open`, `panel` | `open` |
| `titlealign` | `left`, `center` | `left` |

For the panel-style example shown in the repository:

```latex
\documentclass[
  palette=navy,
  titlestyle=panel,
  titlealign=left
]{inkpaper}
```

## Components

```latex
\code{https://github.com/your-org/project}
\model{https://huggingface.co/your-org/model}
\data{https://huggingface.co/datasets/your-org/data}
\project{https://project.example.com}

\begin{keybox}[Key takeaway]
The main finding in one or two sentences.
\end{keybox}

\begin{promptbox}[Judge prompt]
Your prompt text.
\end{promptbox}
```

See `main.tex` for logo headers, side captions, highlighted table rows, and
appendix formatting.

## Requirements

A reasonably complete TeX Live installation is recommended. The template uses
widely available packages including `newpx`, `sourcesanspro`, `tcolorbox`,
`fontawesome5`, and `titletoc`.

## License

MIT
