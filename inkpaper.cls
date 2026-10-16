\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{inkpaper}[2026/10/16 v0.1.0 Neutral single-column preprint class]

% ---------------------------------------------------------------- engine guard
\RequirePackage{iftex}
\ifpdftex\else
  \ClassError{inkpaper}{inkpaper requires pdflatex}
    {This class loads Type 1 fonts (newpx, sourcesanspro, zi4) via fontenc/inputenc,\MessageBreak
     which do not work under xelatex/lualatex (no TU encoding for zi4).\MessageBreak
     Compile with: latexmk -pdf main.tex}%
  \expandafter\@@end
\fi

\RequirePackage{kvoptions}
\RequirePackage{etoolbox}
\SetupKeyvalOptions{family=IP,prefix=IP@}
\DeclareStringOption[navy]{palette}      % navy | teal | slate
\DeclareStringOption[left]{titlealign}   % left | center
\DeclareStringOption[rigorous]{titlestyle} % rigorous | open | panel
\DeclareBoolOption{numbers}              % numeric citations instead of author-year
\DeclareBoolOption{nonatbib}             % skip natbib so biblatex can be used
\DeclareVoidOption{twocolumn}{\ClassError{inkpaper}{twocolumn is not supported}{inkpaper is a single-column class.}}
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessKeyvalOptions*
\LoadClass[10pt]{article}
% Base body size (10 / 10.95 / 12pt per article's size option); every
% hard-coded \fontsize below is expressed as a multiple of it so that
% \documentclass[11pt] / [12pt] keep the heading hierarchy intact.
\newlength{\IP@base}
\ifcase\@ptsize\relax
  \setlength{\IP@base}{10pt}\or
  \setlength{\IP@base}{10.95pt}\or
  \setlength{\IP@base}{12pt}\fi
% \IP@fontsize{<size factor>}{<baselineskip factor>}
\newcommand{\IP@fontsize}[2]{\fontsize{#1\IP@base}{#2\IP@base}\selectfont}

% ---------------------------------------------------------------- layout
% headheight 32pt: room for a 16pt logo badge with two lines of text in the
% first-page header without fancyhdr's headheight warning.
\RequirePackage[top=1.05in,bottom=1.0in,left=1.2in,right=1.2in,
  headheight=32pt,headsep=0.25in,footskip=0.45in]{geometry}
\linespread{1.06}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.55em plus 0.1em}
% Single inter-sentence space; \nonfrenchspacing in the preamble restores
% TeX's wider sentence space.
\frenchspacing
% Float policy: let a page be mostly float before it is pushed.
\renewcommand{\topfraction}{0.85}
\renewcommand{\bottomfraction}{0.6}
\renewcommand{\textfraction}{0.1}
\renewcommand{\floatpagefraction}{0.75}
\setcounter{topnumber}{3}
\setcounter{totalnumber}{4}

% ---------------------------------------------------------------- fonts
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{amsmath}
\RequirePackage{amssymb}   % must precede newpxmath (newpx docs)
\RequirePackage{amsthm}    % must precede newpxmath (\openbox clash)
\RequirePackage{newpxtext}
\RequirePackage{newpxmath}
\RequirePackage[scale=0.95]{sourcesanspro}
\RequirePackage[varqu,scaled=0.95]{zi4}
% Font expansion is enabled automatically in PDF mode; an explicit
% expansion=true is a hard error under latex/dvips.
\RequirePackage[protrusion=true,tracking=true]{microtype}

% ---------------------------------------------------------------- colors
\RequirePackage[table]{xcolor}
\definecolor{ipInk}{HTML}{1B1F27}
\definecolor{ipGray}{HTML}{5F6672}
\definecolor{ipFaint}{HTML}{8A919C}
\ifdefstring{\IP@palette}{teal}{%
  \definecolor{ipAccent}{HTML}{1D5C63}%
  \colorlet{ipLink}{ipAccent}%
  \definecolor{ipPanel}{HTML}{EEF4F4}%
  \definecolor{ipRule}{HTML}{C5D8DA}%
}{\ifdefstring{\IP@palette}{slate}{%
  \definecolor{ipAccent}{HTML}{3A4556}%
  \definecolor{ipLink}{HTML}{2F5F8F}%  % slate accent is near-gray; links need their own ink
  \definecolor{ipPanel}{HTML}{F3F4F6}%
  \definecolor{ipRule}{HTML}{D3D7DD}%
}{%
  \definecolor{ipAccent}{HTML}{1F3B60}%
  \colorlet{ipLink}{ipAccent}%
  \definecolor{ipPanel}{HTML}{EFF2F7}%
  \definecolor{ipRule}{HTML}{C9D2DF}%
}}
% Option validation: a typo must stop with a class error, not silently fall
% back to navy / rigorous / left.
\ifboolexpr{test{\ifdefstring{\IP@palette}{navy}} or test{\ifdefstring{\IP@palette}{teal}} or test{\ifdefstring{\IP@palette}{slate}}}{}{%
  \ClassError{inkpaper}{Unknown palette '\IP@palette'}{Use palette=navy, teal, or slate.}}
\ifboolexpr{test{\ifdefstring{\IP@titlestyle}{rigorous}} or test{\ifdefstring{\IP@titlestyle}{open}} or test{\ifdefstring{\IP@titlestyle}{panel}}}{}{%
  \ClassError{inkpaper}{Unknown titlestyle '\IP@titlestyle'}{Use titlestyle=rigorous, open, or panel.}}
\ifboolexpr{test{\ifdefstring{\IP@titlealign}{left}} or test{\ifdefstring{\IP@titlealign}{center}}}{}{%
  \ClassError{inkpaper}{Unknown titlealign '\IP@titlealign'}{Use titlealign=left or center.}}
% Semantic callout colours.  Generated per palette by semantic_palette.py
% (OKLCH) so the four coloured callouts follow the palette accent instead of
% four unrelated hard-coded hues: Takeaway = accent hue, Discussion = accent
% +80 deg, Guidance = accent -62 deg, Observation = accent hue at near-zero
% chroma; one chroma per palette; title bars on a small lightness ladder
% (OKLab L 0.44 / 0.47 / 0.50 / 0.54, Takeaway darkest) so they read as
% equals in colour and keep their order in a grayscale print (Takeaway and
% Discussion sit only ~2 L* apart there; the printed label carries the role
% when hue is lost, including under red-green colour-vision deficiency).
% Every bar gives white label text >= 5:1 and sits >= 2:1 from the body ink.
% Tints share one light L (0.975); ipOurs (table row) and ipFindingTint take
% the accent hue.
% Regenerate with:  python3 semantic_palette.py --tex
% Generated by semantic_palette.py -- do not edit by hand.
% Bars: OKLab L 0.44/0.47/0.50/0.54, hues accent / +80 / -62 / neutral; tints L 0.975.
% navy: accent hue 256, chroma 0.090
\csdef{IP@sem@navy}{%
  \definecolor{ipTakeaway}{HTML}{2F5383}%
  \definecolor{ipTakeawayTint}{HTML}{F2F7FF}%
  \definecolor{ipDiscussion}{HTML}{7A466E}%
  \definecolor{ipDiscussionTint}{HTML}{FCF4FA}%
  \definecolor{ipGuidance}{HTML}{027271}%
  \definecolor{ipGuidanceTint}{HTML}{EEF9F9}%
  \definecolor{ipObservation}{HTML}{6B6F75}%
  \definecolor{ipObservationTint}{HTML}{F5F7F9}%
  \definecolor{ipOurs}{HTML}{EBF3FD}%
  \definecolor{ipFindingTint}{HTML}{F2F7FE}}
% teal: accent hue 206, chroma 0.085
\csdef{IP@sem@teal}{%
  \definecolor{ipTakeaway}{HTML}{015E67}%
  \definecolor{ipTakeawayTint}{HTML}{EEF9FB}%
  \definecolor{ipDiscussion}{HTML}{575388}%
  \definecolor{ipDiscussionTint}{HTML}{F6F6FF}%
  \definecolor{ipGuidance}{HTML}{447043}%
  \definecolor{ipGuidanceTint}{HTML}{F2F9F2}%
  \definecolor{ipObservation}{HTML}{687071}%
  \definecolor{ipObservationTint}{HTML}{F4F8F8}%
  \definecolor{ipOurs}{HTML}{E6F5F7}%
  \definecolor{ipFindingTint}{HTML}{F0F9FA}}
% slate: accent hue 259, chroma 0.075
\csdef{IP@sem@slate}{%
  \definecolor{ipTakeaway}{HTML}{39537C}%
  \definecolor{ipTakeawayTint}{HTML}{F2F7FE}%
  \definecolor{ipDiscussion}{HTML}{774A69}%
  \definecolor{ipDiscussionTint}{HTML}{FDF4F9}%
  \definecolor{ipGuidance}{HTML}{1F7072}%
  \definecolor{ipGuidanceTint}{HTML}{EEF9F9}%
  \definecolor{ipObservation}{HTML}{6B6F75}%
  \definecolor{ipObservationTint}{HTML}{F5F7F9}%
  \definecolor{ipOurs}{HTML}{EBF2FD}%
  \definecolor{ipFindingTint}{HTML}{F3F7FE}}
\csuse{IP@sem@\IP@palette}  % value validated above
\color{ipInk}

% ---------------------------------------------------------------- packages
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{enumitem}
\RequirePackage{titlesec}
\RequirePackage{titletoc}
\RequirePackage{fontawesome5}
\RequirePackage[most]{tcolorbox}
\RequirePackage{fancyhdr}
\ifIP@nonatbib\else
  \ifIP@numbers
    \RequirePackage[numbers,sort&compress]{natbib}
  \else
    \RequirePackage[round]{natbib}
  \fi
  % References in \small with a 0.35em entry gap (subordinate to the body,
  % as in NeurIPS/ICML styles); skipped under [nonatbib] where biblatex
  % defines neither macro.
  \renewcommand{\bibfont}{\small}
  \setlength{\bibsep}{0.35em plus 0.1em}
  % Give the unnumbered References heading a TOC entry and a PDF bookmark.
  % \phantomsection sits inside the title so the anchor is on the heading
  % itself (titlesec's starred headings create no hyperref anchor).
  \renewcommand{\bibsection}{\section*{\phantomsection\refname}%
    \addcontentsline{toc}{section}{\refname}}
\fi
\RequirePackage[hyphens]{url}
\RequirePackage{hyperref}
% Hyperlink ink is ipLink (= ipAccent in navy/teal; a steel blue in slate, whose
% accent is too close to body ink for links to be recognisable).
\hypersetup{colorlinks=true,linkcolor=ipLink,citecolor=ipLink,
  urlcolor=ipLink,pdfborder={0 0 0}}

% ---------------------------------------------------------------- label voice
% One label voice for the document: sans tracked caps.  On the title page
% (tag, Date, Contact, Abstract) it is scriptsize regular in gray; in the
% callouts it is footnotesize bold (white on a bar, accent on a finding).
\newcommand{\IP@label}[1]{{\sffamily\scriptsize\color{ipGray}%
  \textls[140]{\MakeUppercase{#1}}}}
\newcommand{\IP@boxlabel}{\sffamily\bfseries\footnotesize}
\newcommand{\IP@boxcaps}[1]{\textls[110]{\MakeUppercase{#1}}}

\setlist{itemsep=0.15em,topsep=0.3em}
\setlist[itemize]{leftmargin=1.4em}
\setlist[enumerate]{leftmargin=*,labelindent=0pt,widest=10}
\setlist[description]{leftmargin=1.4em}
\renewcommand{\arraystretch}{1.12}

% ---------------------------------------------------------------- headings
\titleformat{\section}
  {\sffamily\bfseries\IP@fontsize{1.25}{1.5}\color{ipInk}}
  {\color{ipAccent}\thesection}{0.75em}{}
\titleformat{\subsection}
  {\sffamily\bfseries\IP@fontsize{1.05}{1.3}\color{ipInk}}
  {\color{ipAccent}\thesubsection}{0.75em}{}
\titleformat{\subsubsection}
  {\sffamily\bfseries\small\color{ipInk}}
  {\color{ipAccent}\thesubsubsection}{0.75em}{}
% Run-in heads get a trailing period automatically, unless the title already
% ends in terminal punctuation (so \paragraph{Title.} does not render "Title..").
\ExplSyntaxOn
\NewDocumentCommand \IP@runintitle { m }
  {
    #1
    \tl_if_empty:nF {#1}
      {
        \exp_args:Ne \str_case:nnF { \tl_item:nn {#1} {-1} }
          { {.}{} {:}{} {?}{} {!}{} }
          { . }
      }
  }
\ExplSyntaxOff
\titleformat{\paragraph}[runin]
  {\sffamily\bfseries\small\color{ipInk}}{}{0pt}{\IP@runintitle}
\titlespacing*{\section}{0pt}{1.9em plus .4em}{0.7em}
\titlespacing*{\subsection}{0pt}{1.3em plus .3em}{0.45em}
\titlespacing*{\subsubsection}{0pt}{1.0em}{0.3em}
\titlespacing*{\paragraph}{0pt}{0.6em}{0.6em}

% ---------------------------------------------------------------- captions
\RequirePackage{caption}
\RequirePackage{threeparttable}  % \begin{threeparttable} makes a caption as wide as its tabular
\DeclareCaptionFont{ipaccent}{\color{ipAccent}}
\DeclareCaptionFont{ipgray}{\color{ipGray}}
\captionsetup{font={small,ipgray},labelfont={sf,bf,ipaccent},
  labelsep=quad,justification=justified,singlelinecheck=false,skip=6pt}
% Table captions sit above a centred tabular: a one-line caption is centred
% over it; wrap the table in threeparttable to set a long caption to the
% tabular's width.
\captionsetup[table]{position=top,singlelinecheck=true}
% Bold lead-in sentence for captions: \caption{\captitle{Main result.} Details.}
\newcommand{\captitle}[1]{{\color{ipInk}\bfseries #1}}

% Caption beside the figure: \sidefigure[ratio]<placement>{content}{caption + label}
%   ratio     = fraction of \linewidth for the content (default 0.64)
%   placement = float specifier as for figure, e.g. <h>, <b>, <htbp> (default t);
%               a bare specifier in the bracket slot, \sidefigure[h]{..}{..},
%               is accepted as well (it cannot be mistaken for a ratio)
\ExplSyntaxOn
\cs_new:Npn \IP@ifplacement #1 { \regex_match:nnTF { \A [htbpH!]+ \Z } {#1} }
\ExplSyntaxOff
\NewDocumentCommand{\sidefigure}{O{0.64} D<>{t} m m}{%
  \IP@ifplacement{#1}{\IP@sidefigure{0.64}{#1}{#3}{#4}}{\IP@sidefigure{#1}{#2}{#3}{#4}}}
\newcommand{\IP@sidefigure}[4]{%
  \begin{figure}[#2]%
    \begin{minipage}[c]{#1\linewidth}\centering #3\end{minipage}\hfill
    \begin{minipage}[c]{\dimexpr\linewidth-#1\linewidth-1.6em\relax}%
      \captionsetup{justification=raggedright,skip=0pt}#4%
    \end{minipage}%
  \end{figure}}

% ---------------------------------------------------------------- footnotes
% Net height must be zero (as in the kernel default), or full pages with a
% footnote become overfull by 4.4pt.
\renewcommand{\footnoterule}{\kern-4.4pt{\color{ipRule}\hrule width 0.3\textwidth height 0.4pt}\kern 4pt}
\setlength{\skip\footins}{13.4pt plus 4pt minus 2pt}  % keeps the previous visual gap (9pt + rule + 4pt) while being correctly accounted

% ---------------------------------------------------------------- tables
% Highlight the row of your own method: \oursrow Ours & ... \\
% ipOurs is the palette accent at the callout-tint lightness.  colortbl paints
% each cell plus \tabcolsep on both sides, which is exactly the span of the
% booktabs rules when the preamble has no @{} at the edges; write lcccc (not
% @{}lcccc@{}) so the tint ends where the rules end.
\newcommand{\oursrow}{\rowcolor{ipOurs}}

% ---------------------------------------------------------------- metadata
\newcommand{\IP@tag}{Preprint}
\newcommand{\IP@short}{}
\newcommand{\IP@affil}{}
\newcommand{\IP@notes}{}
\newcommand{\IP@meta}{}
\newcommand{\IP@metainline}{}
\newcommand{\IP@links}{}
\newcommand{\IP@abstract}{}
\newcommand{\IP@leftlogo}{}
\newcommand{\IP@rightlogo}{}
\newcommand{\IP@panellogo}{}
\newcommand{\IP@firstnote}{}
\newcommand{\papertag}[1]{\renewcommand{\IP@tag}{#1}}
\newcommand{\shorttitle}[1]{\renewcommand{\IP@short}{#1}}
\newcommand{\affiliations}[1]{\renewcommand{\IP@affil}{#1}}
\newcommand{\authornotes}[1]{\renewcommand{\IP@notes}{#1}}
% \abstract{...} (preamble command) and \begin{abstract}...\end{abstract}
% (environment, before or after \maketitle) both work.  Used after
% \maketitle the environment typesets the abstract in place (rigorous and
% panel styles use the rigorous block there, since the title block has
% already been shipped).
\newif\ifIP@titledone
\newcommand{\IP@abstractcmd}[1]{\long\gdef\IP@abstract{#1}}
\NewDocumentEnvironment{IP@abstractenv}{+b}{%
  \IP@abstractcmd{#1}\ifIP@titledone\IP@abstractbox\fi}{}
\renewcommand{\abstract}{%
  \ifdefstring{\@currenvir}{abstract}{\IP@abstractenv}{\IP@abstractcmd}}
\let\endabstract\endIP@abstractenv
\newcommand{\leftlogo}[1]{\renewcommand{\IP@leftlogo}{#1}}
\newcommand{\rightlogo}[1]{\renewcommand{\IP@rightlogo}{#1}}
\newcommand{\panellogo}[1]{\renewcommand{\IP@panellogo}{#1}}
\newcommand{\firstpagenote}[1]{\renewcommand{\IP@firstnote}{#1}}
% \metadata{<label>}{<value>}: an empty value prints nothing (so \date{} and
% \correspondence{} are no-ops); a label wider than the 6.2em column is set at
% its natural width + 0.8em instead of being overprinted by the value.
\newcommand{\metadata}[2]{\ifblank{#2}{}{%
  \g@addto@macro\IP@meta{%
    \sbox\@tempboxa{\IP@label{#1}}%
    \ifdim\wd\@tempboxa>\dimexpr6.2em-0.8em\relax
      \usebox\@tempboxa\hspace{0.8em}%
    \else\makebox[6.2em][l]{\usebox\@tempboxa}\fi
    {\small #2}\par}%
  \g@addto@macro\IP@metainline{%
    \mbox{\IP@label{#1}\enspace{\small #2}}\qquad}}}
\renewcommand{\date}[1]{\metadata{Date}{#1}}
\newcommand{\correspondence}[1]{\metadata{Contact}{#1}}
% \linkitem{<icon>}{<word>}{<url>}: a small accent icon (FontAwesome; may be
% empty) and the word in regular sans; items are separated by faint middle
% dots.  The 3-argument signature is unchanged from earlier releases.
\newcommand{\IP@linksep}{\hspace{0.7em}{\color{ipFaint}\textperiodcentered}\hspace{0.7em}}
\newcommand{\linkitem}[3]{%
  \ifx\IP@links\@empty\else\g@addto@macro\IP@links{\IP@linksep}\fi
  \ifblank{#1}%
    {\g@addto@macro\IP@links{\mbox{\href{#3}{\sffamily\footnotesize\color{ipInk}#2}}}}%
    {\g@addto@macro\IP@links{\mbox{\href{#3}{{\footnotesize\color{ipAccent}#1}\hspace{0.35em}%
      {\sffamily\footnotesize\color{ipInk}#2}}}}}}
\newcommand{\code}[1]{\linkitem{\faGithub}{Code}{#1}}
\newcommand{\project}[1]{\linkitem{\faGlobe}{Project}{#1}}
\newcommand{\data}[1]{\linkitem{\faDatabase}{Data}{#1}}
\newcommand{\model}[1]{\linkitem{\faCube}{Model}{#1}}

% Placeholder logos that need no image files and no extra packages:
%   \leftlogo{\placeholderlogo{U}{University Name}}
%   \rightlogo{\placeholderlogo[outline]{L}{Research Lab\\Institute Name}}
% Replace with \includegraphics[height=16pt]{logo/university.pdf} for real use.
% The 0.3333em on both sides of the text reproduces the inner sep of the TikZ
% text node this helper replaced, so documents that used it render unchanged.
\tikzset{ip logo fill/.style={fill=ipAccent,text=white},
  ip logo outline/.style={draw=ipAccent,line width=0.8pt,text=ipAccent}}
\newcommand{\placeholderlogo}[3][fill]{%
  \mbox{\tikz[baseline=-0.6ex]{\node[ip logo #1,font=\sffamily\bfseries\small,
      minimum size=16pt,inner sep=0pt,rounded corners=2pt]{#2};}%
    \hspace{3pt}\hspace{0.3333em}%
    {\ifstrequal{#1}{outline}{\sffamily\scriptsize\color{ipGray}}%
        {\sffamily\bfseries\footnotesize\color{ipInk}}%
      \begin{tabular}[c]{@{}l@{}}#3\end{tabular}}\hspace{0.3333em}}}

\ifdefstring{\IP@titlealign}{center}
  {\newcommand{\IP@align}{\centering}}
  {\newcommand{\IP@align}{\raggedright}}

% ---------------------------------------------------------------- header
% Running head: short title (or the title, with its line breaks flattened)
% left, the tag right; page number centred in the footer on every page.
\newcommand{\IP@pagenumber}{\sffamily\footnotesize\color{ipGray}\thepage}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\sffamily\scriptsize\color{ipGray}%
  \ifdefempty{\IP@short}{\let\\\space\@title}{\IP@short}}
\fancyhead[R]{\sffamily\scriptsize\color{ipGray}\MakeUppercase{\IP@tag}}
\fancyfoot[C]{\IP@pagenumber}
\renewcommand{\headrule}{{\color{ipRule}\hrule height 0.4pt}}
\fancypagestyle{plain}{\fancyhf{}%
  \fancyfoot[C]{\IP@pagenumber}%
  \renewcommand{\headrule}{}}
\fancypagestyle{ipfirst}{\fancyhf{}%
  \fancyhead[L]{\IP@leftlogo}%
  \fancyhead[R]{\IP@rightlogo}%
  \fancyfoot[C]{\IP@pagenumber}%
  \renewcommand{\headrule}{\vspace{4pt}{\color{ipAccent}\hrule height 0.5pt}}}

% ---------------------------------------------------------------- title block
% \papertag{} suppresses the tag line and its gap; \and inside \author is a
% \quad separator (scoped to the author group, so it keeps its kernel meaning
% elsewhere).
\newcommand{\IP@heading}{%
  \ifx\IP@tag\@empty\else
  {\sffamily\bfseries\scriptsize\color{ipAccent}%
    \textls[180]{\MakeUppercase{\IP@tag}}\par}\vspace{0.7em}\fi
  {\sffamily\bfseries\IP@fontsize{2.1}{2.6}\color{ipInk}\@title\par}%
  \vspace{1.0em}
  {\sffamily\IP@fontsize{1.05}{1.4}\color{ipInk}%
    \renewcommand{\and}{\unskip\quad}\@author\par}%
  \ifx\IP@affil\@empty\else
    \vspace{0.45em}{\small\color{ipGray}\IP@affil\par}\fi
  \ifx\IP@notes\@empty\else
    \vspace{0.2em}{\footnotesize\color{ipGray}\IP@notes\par}\fi}

\newcommand{\IP@rigorousheading}{%
  \ifx\IP@tag\@empty\else{\IP@label{\IP@tag}\par}\vspace{0.8em}\fi
  {\bfseries\IP@fontsize{2.2}{2.7}\color{ipInk}\@title\par}%
  \vspace{0.9em}
  {\IP@fontsize{1.05}{1.4}\color{ipInk}%
    \renewcommand{\and}{\unskip\quad}\@author\par}%
  \ifx\IP@affil\@empty\else
    \vspace{0.4em}{\small\color{ipGray}\IP@affil\par}\fi
  \ifx\IP@notes\@empty\else
    \vspace{0.15em}{\footnotesize\color{ipGray}\IP@notes\par}\fi}

\newcommand{\IP@linksblock}{%
  \ifx\IP@links\@empty\else
    \vspace{0.8em}{\IP@links\unskip\par}\fi}

\newcommand{\IP@metablock}{%
  \ifx\IP@meta\@empty\else
    \vspace{0.6em}%
    \ifdefstring{\IP@titlealign}{center}%
      {{\color{ipInk}\IP@metainline\unskip\par}}%
      {{\color{ipInk}\IP@meta}}%
  \fi}

% Title footnotes.  They are emitted before the abstract (rigorous and open:
% right after the heading; panel: the first-page note before the box, since a
% footnote cannot be placed from inside it), so that a title block which fills
% page 1 or breaks onto page 2 still puts its notes on page 1.  Order at the
% foot of the page: \thanks texts, then the first-page note (panel: the note
% first, the \thanks texts after the box).  Both macros are idempotent.
\newif\ifIP@notesdone
\newcommand{\IP@firstnotetext}{%
  \ifIP@notesdone\else
    \ifx\IP@firstnote\@empty\else
      \begingroup\renewcommand{\thefootnote}{}%
      \footnotetext{\color{ipGray}\IP@firstnote}\endgroup
    \fi
    \global\IP@notesdonetrue
  \fi}
\newcommand{\IP@titlenotes}{\@thanks\global\let\@thanks\@empty\IP@firstnotetext}

% Abstract renderings.  Both are breakable, so a very long abstract (or a
% long author list) continues on page 2 instead of leaving page 1 empty.
\newcommand{\IP@openabstractbox}{%
  \vspace{1.1em}%
  \begin{tcolorbox}[enhanced,breakable,colback=ipPanel,boxrule=0pt,frame hidden,
    arc=3pt,left=16pt,right=16pt,top=12pt,bottom=12pt,
    borderline west={2pt}{0pt}{ipAccent}]
    {\sffamily\bfseries\small\color{ipAccent}Abstract\par}\vspace{0.35em}
    {\small\linespread{1.12}\selectfont\color{ipInk}\IP@abstract\par}
  \end{tcolorbox}}
% Rigorous: a plain paragraph block with the geometry of the former
% \begin{center}\begin{minipage}{0.90\linewidth} (trivlist skips above and
% below, \lineskip at the top, no \parskip inside, \sloppy), so the output is
% unchanged but the block can break across pages.
\newcommand{\IP@rigorousabstractbox}{%
  \par\vspace{1.1em}%
  \begingroup
    \vskip\topsep\vskip\partopsep\vskip\parskip
    \setlength{\leftskip}{0.05\linewidth}\setlength{\rightskip}{0.05\linewidth}%
    \setlength{\parskip}{\z@}\setlength{\parindent}{\z@}\sloppy
    \nointerlineskip\vskip\lineskip
    {\IP@label{Abstract}\par}\nobreak\vspace{0.45em}
    {\small\linespread{1.10}\selectfont\color{ipInk}\IP@abstract\par}
    \vskip\topsep\vskip\partopsep
  \endgroup
  \vspace{0.5em}}
% \begin{abstract} after \maketitle: typeset in place in the style's voice
% (panel falls back to the rigorous block; its inline abstract cannot be added
% once the panel has been shipped).
\newcommand{\IP@abstractbox}{%
  \ifdefstring{\IP@titlestyle}{open}{\IP@openabstractbox}{\IP@rigorousabstractbox}}

\newcommand{\IP@openstyle}{%
  \begingroup\IP@align
    \IP@heading\IP@linksblock\IP@metablock
  \endgroup
  \IP@titlenotes
  \ifx\IP@abstract\@empty\else\IP@openabstractbox\fi}

\newcommand{\IP@rigorousstyle}{%
  \begingroup\IP@align
    \IP@rigorousheading\IP@linksblock\IP@metablock
  \endgroup
  \IP@titlenotes
  \ifx\IP@abstract\@empty
    \vspace{0.9em}%
  \else
    \IP@rigorousabstractbox
  \fi
  {\color{ipRule}\hrule height 0.45pt}}

\newcommand{\IP@panelstyle}{%
  \begin{tcolorbox}[enhanced,breakable,colback=ipPanel,boxrule=0pt,frame hidden,
    arc=6pt,left=22pt,right=22pt,top=20pt,bottom=18pt]
    \begingroup\IP@align
      \IP@heading
      \ifx\IP@abstract\@empty\else
        \vspace{1.0em}%
        {\small\linespread{1.14}\selectfont\color{ipInk!82}\raggedright\IP@abstract\par}%
      \fi
      \IP@linksblock
    \endgroup
    \ifx\IP@meta\@empty\ifx\IP@panellogo\@empty\else\IP@panelfoot\fi\else\IP@panelfoot\fi
  \end{tcolorbox}}

% Footer row of the panel: metadata (left) + logo (right); centered stack in
% titlealign=center.  Only emitted when there is something to show.
\newcommand{\IP@panelfoot}{%
  \vspace{0.2em}%
  \ifdefstring{\IP@titlealign}{center}{%
    \begingroup\centering\IP@metablock
      \ifx\IP@panellogo\@empty\else\vspace{0.8em}\IP@panellogo\par\fi
    \endgroup}{%
    \begin{minipage}[b]{0.68\linewidth}\raggedright\IP@metablock\end{minipage}%
    \hfill
    \begin{minipage}[b]{0.3\linewidth}\raggedleft\IP@panellogo\end{minipage}}}

% PDF Title/Author metadata from \title/\author.  The \let's are applied only
% while converting these two strings (local copy of hyperref's pre-hook), so
% section bookmarks are unaffected: \\ -> space, \quad/\and separators and
% \textsuperscript{...}/\thanks{...} markers dropped.
\newcommand{\IP@setpdfmeta}{%
  \begingroup
    \toks@\expandafter{\pdfstringdefPreHook
      \let\\\space\let\quad\@empty\let\qquad\@empty\let\and\@empty
      \let\textsuperscript\@gobble\let\thanks\@gobble}%
    \edef\pdfstringdefPreHook{\the\toks@}%
    \hypersetup{pdftitle={\@title},pdfauthor={\@author}}%
  \endgroup}

\renewcommand{\maketitle}{%
  \IP@setpdfmeta
  \begingroup
  % \thanks marks as symbols; title footnotes unlinked, as hyperref itself
  % does for article's \maketitle (its wrapper was lost by this \renewcommand)
  \renewcommand{\thefootnote}{\@fnsymbol\c@footnote}%
  \@ifundefined{H@@footnotemark}{}{\let\@footnotemark\H@@footnotemark}%
  \@ifundefined{H@@footnotetext}{}{\let\@footnotetext\H@@footnotetext}%
  \ifdefstring{\IP@titlestyle}{panel}{\ifx\IP@panellogo\@empty\else
    \let\IP@leftlogo\@empty\let\IP@rightlogo\@empty\fi}{}%
  \ifx\IP@leftlogo\@empty\ifx\IP@rightlogo\@empty
    \thispagestyle{plain}\else\thispagestyle{ipfirst}\fi
  \else\thispagestyle{ipfirst}\fi
  \ifdefstring{\IP@titlestyle}{panel}{\IP@firstnotetext\IP@panelstyle}{%
    \ifdefstring{\IP@titlestyle}{open}{\IP@openstyle}{\IP@rigorousstyle}}%
  \IP@titlenotes
  \endgroup
  \setcounter{footnote}{0}%
  \vspace{0.6em}%
  \global\IP@titledonetrue
}

% ---------------------------------------------------------------- boxes
% One callout family.  Shared tokens: 0.45pt rules, square corners, a 10pt
% inset, \small body, one label voice (sans bold tracked caps, the same voice
% as the PREPRINT tag and the running head).  The four semantic boxes add a
% solid title bar in their hue over a tint of the same hue; finding/keybox is
% the quiet member (accent hairlines over the accent tint, no bar); promptbox
% is the neutral member (ipRule frame, white title row, gray label).
% Frames are drawn as stroked border lines (ipframe), not as tcolorbox's
% filled frame: a filled 0.45pt frame disappears at screen resolution when
% its edges straddle a pixel, while a stroke is always rendered at least one
% pixel wide.  The stroke is centred on the box boundary, so the box stays on
% the measure.
% To set callout bodies at text size instead of \small, redefine
% \IP@calloutbody in the preamble (\makeatletter ... \makeatother).
\newcommand{\IP@calloutbody}{\small\linespread{1.08}\selectfont}
\newlength{\IP@boxinset}\setlength{\IP@boxinset}{10pt}
\tcbset{ipcallout/.style={enhanced,breakable,arc=0pt,outer arc=0pt,boxsep=0pt,
  left=\IP@boxinset,right=\IP@boxinset,top=7pt,bottom=8pt,
  before skip=11pt plus 2pt minus 1pt,after skip=11pt plus 2pt minus 1pt,
  fontupper=\IP@calloutbody,
  pad at break=5pt,pad before break=5pt,pad after break=7pt}}

\tcbset{ipframe/.style={boxrule=0pt,frame hidden,borderline={0.45pt}{0pt}{#1}}}

% finding / keybox: unbreakable, so the two hairlines are never lost at a
% page break (the statement is one to three sentences).
\tcbset{ipfinding/.style={ipcallout,unbreakable,colback=ipFindingTint,
  boxrule=0pt,frame hidden,top=8pt,
  borderline north={0.45pt}{0pt}{ipAccent},
  borderline south={0.45pt}{0pt}{ipAccent}}}

% The optional argument is a plain-text label, set in caps on its own line;
% an empty optional argument [] suppresses the label line.
\newcommand{\IP@findinglabel}[1]{\ifblank{#1}{}{%
  {\IP@boxlabel\color{ipAccent}\IP@boxcaps{#1}\par}\vspace{3pt}}}

\newtcolorbox{finding}[1][Main finding]{ipfinding,
  before upper={\IP@findinglabel{#1}}}

% Backward-compatible name for the same box; keeps its original default label.
\newtcolorbox{keybox}[1][Key takeaway]{ipfinding,
  before upper={\IP@findinglabel{#1}}}

% Semantic boxes: solid title bar, white tracked-caps label, auto counter.
% The zero-width strut fixes the bar height whatever the label's letters.
\newcommand{\IP@boxstrut}{\vrule height 5.4pt depth 1.6pt width 0pt\relax}
% Title row geometry shared by the semantic boxes and promptbox: 12-13pt bar.
\tcbset{iptitlerow/.style={lefttitle=\IP@boxinset,righttitle=\IP@boxinset,
  toptitle=3.2pt,bottomtitle=2.4pt,fonttitle=\IP@boxlabel\IP@boxstrut}}
\tcbset{ipsemantic/.style={ipcallout,iptitlerow,coltitle=white,titlerule=0pt}}
% iprole={<colour stem>}{<role word>}: uses <stem> and <stem>Tint.  A box that
% breaks across pages repeats its label with "(continued)" on the next part.
\tcbset{iprole/.style 2 args={ipsemantic,ipframe=#1,colback=#1Tint,colbacktitle=#1,
  title=\IP@boxcaps{#2~\thetcbcounter},
  title after break=\IP@boxcaps{#2~\thetcbcounter\ (continued)}}}

\newtcolorbox[auto counter]{takeaway}[1][]{iprole={ipTakeaway}{Takeaway},#1}
\newtcolorbox[auto counter]{discussion}[1][]{iprole={ipDiscussion}{Discussion},#1}
\newtcolorbox[auto counter]{practicalguidance}[1][]{iprole={ipGuidance}{Practical Guidance},#1}
\newtcolorbox[auto counter]{observation}[1][]{iprole={ipObservation}{Observation},#1}

% cleveref names for the auto-counted boxes (only if the document loads it);
% \begin{takeaway}[label=tk:main] ... then \cref{tk:main} -> "Takeaway 1".
\AtBeginDocument{\@ifpackageloaded{cleveref}{%
  \crefname{tcb@cnt@takeaway}{Takeaway}{Takeaways}\Crefname{tcb@cnt@takeaway}{Takeaway}{Takeaways}%
  \crefname{tcb@cnt@discussion}{Discussion}{Discussions}\Crefname{tcb@cnt@discussion}{Discussion}{Discussions}%
  \crefname{tcb@cnt@practicalguidance}{Practical Guidance}{Practical Guidance}\Crefname{tcb@cnt@practicalguidance}{Practical Guidance}{Practical Guidance}%
  \crefname{tcb@cnt@observation}{Observation}{Observations}\Crefname{tcb@cnt@observation}{Observation}{Observations}}{}}

% promptbox: the neutral member; the title is quoted-material metadata, so it
% takes the same caps label voice in gray on a white title row.
% Frame and title row shared by promptbox and promptbox*.
\tcbset{ipprompt/.style={ipcallout,iptitlerow,colback=white,
  ipframe=ipRule,colbacktitle=white,coltitle=ipGray,title=\IP@boxcaps{#1},
  title after break=\IP@boxcaps{#1 (continued)},
  titlerule=0.45pt,titlerule style={ipRule}}}
\newtcolorbox{promptbox}[1][Prompt]{ipprompt={#1},
  fontupper=\ttfamily\footnotesize,before upper=\raggedright}

% Verbatim-safe variant: \begin{promptbox*}[Title] ... \end{promptbox*}
% The body is typeset by listings, so _ # % & { } \ need no escaping and
% line breaks in the source are kept. Common non-ASCII punctuation and
% accented letters are mapped via `literate' (listings cannot read raw
% multi-byte UTF-8 under pdflatex); extend the list if you need more.
% Long lines wrap at spaces only; a single token wider than the text block
% sticks out of the frame.  Writes a <jobname>.listing scratch file.
\newtcblisting{promptbox*}[1][Prompt]{ipprompt={#1},
  listing only,listing options={basicstyle=\ttfamily\footnotesize\color{ipInk},
    breaklines=true,breakatwhitespace=true,breakindent=0pt,
    columns=fullflexible,keepspaces=true,showstringspaces=false,
    showlines=true,upquote=true,aboveskip=0pt,belowskip=0pt,
    inputencoding=utf8,extendedchars=true,
    literate={—}{{---}}1 {–}{{--}}1 {“}{{``}}1 {”}{{''}}1
      {‘}{{`}}1 {’}{{'}}1 {…}{{\dots}}1 {→}{{$\rightarrow$}}1
      {é}{{\'e}}1 {è}{{\`e}}1 {ï}{{\"i}}1 {à}{{\`a}}1 {ü}{{\"u}}1 {ö}{{\"o}}1 {ä}{{\"a}}1}}

% ---------------------------------------------------------------- plots
% If the document loads pgfplots, two presets carry the page's face and palette:
%   \begin{axis}[inkpaper, ...]       lines: accent, faint dashed, accent!55
%                                     dotted, faint!70 dash-dot
%   \begin{axis}[inkpaper bars, ...]  ybar on the ramp (ipRule -> ipFaint!70 ->
%                                     ipAccent!55 -> ipAccent), top legend; add
%                                     nodes near coords to a series for accent
%                                     value labels
% Both default to width=\linewidth, height=\figureheight.  Nothing is loaded
% or defined unless pgfplots is present; the two lengths always exist.
\newlength{\figurewidth}
\newlength{\figureheight}
\AtBeginDocument{\setlength{\figurewidth}{\textwidth}%
  \setlength{\figureheight}{0.32\textwidth}}
\AtEndPreamble{\@ifpackageloaded{pgfplots}{%
  \pgfplotscreateplotcyclelist{inkpaper}{%
    {ipAccent,line width=1.3pt},
    {ipFaint,line width=1.1pt,dashed},
    {ipAccent!55,line width=1.1pt,densely dotted},
    {ipFaint!70,line width=1.1pt,dash dot}}
  \pgfplotscreateplotcyclelist{inkpaper ramp}{%
    {fill=ipRule,draw=none},
    {fill=ipFaint!70,draw=none},
    {fill=ipAccent!55,draw=none},
    {fill=ipAccent,draw=none}}
  \pgfplotsset{
    inkpaper/.style={
      width=\linewidth,height=\figureheight,
      cycle list name=inkpaper,
      axis lines*=left,axis line style={ipRule,line width=0.4pt},
      major tick style={ipRule},minor tick style={ipRule},
      tick label style={font=\sffamily\scriptsize,text=ipGray,
        /pgf/number format/assume math mode=true},
      every axis label/.style={font=\sffamily\footnotesize,text=ipGray},
      title style={font=\sffamily\bfseries\small,text=ipInk},
      ymajorgrids,grid style={ipRule!50,line width=0.4pt},
      legend style={draw=none,fill=none,font=\sffamily\scriptsize},
      legend cell align=left,
      every node near coord/.style={font=\sffamily\bfseries\scriptsize,
        text=ipAccent,/pgf/number format/assume math mode=true,
        /pgf/number format/fixed,/pgf/number format/fixed zerofill,
        /pgf/number format/precision=1}},
    inkpaper bars/.style={
      inkpaper,ybar,bar width=9pt,enlarge x limits=0.18,
      cycle list name=inkpaper ramp,
      major tick style={draw=none},
      legend style={at={(0.5,1.04)},anchor=south,legend columns=-1,
        /tikz/every even column/.append style={column sep=8pt}},
      legend image code/.code={\draw[##1,draw=none] (0cm,-0.1cm) rectangle (0.25cm,0.1cm);}}}}{}}

% ---------------------------------------------------------------- contents
% Shared by \tableofcontents and the appendix contents printed by \beginappendix.
\titlecontents{section}[1.8em]{\vspace{0.3em}\sffamily\bfseries\small\color{ipInk}}
  {\contentslabel[\color{ipAccent}\thecontentslabel]{1.8em}}{}
  {\color{ipRule}\titlerule*[0.5pc]{.}\color{ipInk}\contentspage}
\titlecontents{subsection}[3.9em]{\small\color{ipGray}}
  {\contentslabel{2.1em}}{}{\color{ipRule}\titlerule*[0.5pc]{.}\color{ipGray}\contentspage}
\titlecontents{subsubsection}[6.6em]{\small\color{ipGray}}
  {\contentslabel{2.7em}}{}{\color{ipRule}\titlerule*[0.5pc]{.}\color{ipGray}\contentspage}

% ---------------------------------------------------------------- appendix
% \IfDocumentMetadataTF exists in LaTeX kernels from 2022-06; older kernels
% take the plain (untagged) path.
\providecommand{\IfDocumentMetadataTF}[2]{#2}
% With \DocumentMetadata{tagging=on} the mini-TOC is emitted as an artifact,
% so it creates no TOC/TOCI structures and the appendix sections stay
% children of Document.
\newcommand{\beginappendix}{%
  \clearpage\appendix
  {\raggedright\sffamily\bfseries\IP@fontsize{2.0}{2.4}\color{ipInk}Appendix\par}%
  \vspace{0.5em}{\color{ipAccent}\rule{2.5em}{1.5pt}}\par\vspace{0.8em}%
  \startcontents[appendix]%
  \IfDocumentMetadataTF{\tagmcbegin{artifact}\SuspendTagging{ipappendix}}{}%
  \printcontents[appendix]{}{1}{\setcounter{tocdepth}{2}}%
  \IfDocumentMetadataTF{\ResumeTagging{ipappendix}\tagmcend}{}%
  \vspace{1.2em}}

\endinput
