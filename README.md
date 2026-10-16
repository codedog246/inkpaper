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
- Numbered takeaway, discussion, guidance, and observation boxes
- Formal finding statements, side captions, and appendix prompt blocks
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

The result is `main.pdf`.

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

## Components

```latex
\code{https://github.com/your-org/project}
\model{https://huggingface.co/your-org/model}
\data{https://huggingface.co/datasets/your-org/data}
\project{https://project.example.com}

\begin{finding}[Main finding]
The main finding in one or two sentences.
\end{finding}

\begin{takeaway}
\textbf{Primary conclusion.} Supporting evidence and scope.
\end{takeaway}

\begin{discussion}
\textbf{Connection to prior work.} A focused interpretation.
\end{discussion}

\begin{practicalguidance}
\textbf{Recommended practice.} Concrete guidance for practitioners.
\end{practicalguidance}

\begin{promptbox}[Judge prompt]
Your prompt text.
\end{promptbox}
```

See `main.tex` for institutional headers, formal captions, tables, and
appendix formatting. The `open` and `panel` title styles remain available for
less conventional technical reports.

## Requirements

A reasonably complete TeX Live installation is recommended. The template uses
widely available packages including `newpx`, `sourcesanspro`, `tcolorbox`,
`fontawesome5`, and `titletoc`.

## License

MIT
