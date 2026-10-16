\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{inkpaper}[2026/10/15 Neutral single-column preprint class]

\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=IP,prefix=IP@}
\DeclareStringOption[navy]{palette}      % navy | teal | slate
\DeclareStringOption[left]{titlealign}   % left | center
\DeclareStringOption[open]{titlestyle}   % open | panel
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessKeyvalOptions*
\LoadClass[10pt]{article}

% ---------------------------------------------------------------- layout
\RequirePackage[letterpaper,top=1.05in,bottom=1.0in,left=1.2in,right=1.2in,
  headheight=26pt,headsep=0.25in,footskip=0.45in]{geometry}
\linespread{1.06}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.55em plus 0.1em}

% ---------------------------------------------------------------- fonts
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{amsmath}
\RequirePackage{newpxtext}
\RequirePackage{newpxmath}
\RequirePackage[scale=0.95]{sourcesanspro}
\RequirePackage[varqu,scaled=0.95]{zi4}
\RequirePackage[protrusion=true,expansion=true,tracking=true]{microtype}

% ---------------------------------------------------------------- colors
\RequirePackage[table]{xcolor}
\definecolor{ipInk}{HTML}{1B1F27}
\definecolor{ipGray}{HTML}{5F6672}
\definecolor{ipFaint}{HTML}{8A919C}
\RequirePackage{etoolbox}
\ifdefstring{\IP@palette}{teal}{%
  \definecolor{ipAccent}{HTML}{1D5C63}%
  \definecolor{ipPanel}{HTML}{EEF4F4}%
  \definecolor{ipRule}{HTML}{C5D8DA}%
}{\ifdefstring{\IP@palette}{slate}{%
  \definecolor{ipAccent}{HTML}{3A4556}%
  \definecolor{ipPanel}{HTML}{F3F4F6}%
  \definecolor{ipRule}{HTML}{D3D7DD}%
}{%
  \definecolor{ipAccent}{HTML}{1F3B60}%
  \definecolor{ipPanel}{HTML}{EFF2F7}%
  \definecolor{ipRule}{HTML}{C9D2DF}%
}}
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
\RequirePackage[round]{natbib}
\RequirePackage[hyphens]{url}
\RequirePackage{hyperref}
\hypersetup{colorlinks=true,linkcolor=ipAccent,citecolor=ipAccent,
  urlcolor=ipAccent,pdfborder={0 0 0}}

\setlist{leftmargin=1.4em,itemsep=0.15em,topsep=0.3em}
\renewcommand{\arraystretch}{1.12}

% ---------------------------------------------------------------- headings
\titleformat{\section}
  {\sffamily\bfseries\fontsize{12.5}{15}\selectfont\color{ipInk}}
  {\color{ipAccent}\thesection}{0.75em}{}
\titleformat{\subsection}
  {\sffamily\bfseries\fontsize{10.5}{13}\selectfont\color{ipInk}}
  {\color{ipAccent}\thesubsection}{0.75em}{}
\titleformat{\subsubsection}
  {\sffamily\bfseries\small\color{ipInk}}
  {\color{ipAccent}\thesubsubsection}{0.75em}{}
\titleformat{\paragraph}[runin]
  {\sffamily\bfseries\small\color{ipInk}}{}{0pt}{}[.]
\titlespacing*{\section}{0pt}{1.9em plus .4em}{0.7em}
\titlespacing*{\subsection}{0pt}{1.3em plus .3em}{0.45em}
\titlespacing*{\subsubsection}{0pt}{1.0em}{0.3em}
\titlespacing*{\paragraph}{0pt}{0.6em}{0.6em}

% ---------------------------------------------------------------- captions
\RequirePackage{caption}
\DeclareCaptionFont{ipaccent}{\color{ipAccent}}
\DeclareCaptionFont{ipgray}{\color{ipGray}}
\captionsetup{font={small,ipgray},labelfont={sf,bf,ipaccent},
  labelsep=quad,justification=justified,singlelinecheck=false,skip=6pt}
\captionsetup[table]{position=top}
% Bold lead-in sentence for captions: \caption{\captitle{Main result.} Details.}
\newcommand{\captitle}[1]{{\color{ipInk}\bfseries #1}}

% Caption beside the figure: \sidefigure[ratio]{content}{caption + label}
\newcommand{\sidefigure}[3][0.64]{%
  \begin{figure}[t]%
    \begin{minipage}[c]{#1\linewidth}\centering #2\end{minipage}\hfill
    \begin{minipage}[c]{\dimexpr\linewidth-#1\linewidth-1.6em\relax}%
      \captionsetup{justification=raggedright,skip=0pt}#3%
    \end{minipage}%
  \end{figure}}

% ---------------------------------------------------------------- footnotes
\renewcommand{\footnoterule}{{\color{ipRule}\hrule width 0.3\textwidth height 0.4pt}\vspace{4pt}}

% ---------------------------------------------------------------- tables
% Highlight the row of your own method: \oursrow Ours & ... \\
\newcommand{\oursrow}{\rowcolor{ipPanel}}

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
\renewcommand{\abstract}[1]{\renewcommand{\IP@abstract}{#1}}
\newcommand{\leftlogo}[1]{\renewcommand{\IP@leftlogo}{#1}}
\newcommand{\rightlogo}[1]{\renewcommand{\IP@rightlogo}{#1}}
\newcommand{\panellogo}[1]{\renewcommand{\IP@panellogo}{#1}}
\newcommand{\firstpagenote}[1]{\renewcommand{\IP@firstnote}{#1}}
\newcommand{\metadata}[2]{%
  \g@addto@macro\IP@meta{%
    \makebox[6.2em][l]{\sffamily\bfseries\footnotesize\color{ipAccent}#1}%
    {\small #2}\par}%
  \g@addto@macro\IP@metainline{%
    \mbox{{\sffamily\bfseries\footnotesize\color{ipAccent}#1}\enspace{\small #2}}\qquad}}
\renewcommand{\date}[1]{\metadata{Date}{#1}}
\newcommand{\correspondence}[1]{\metadata{Contact}{#1}}
\newcommand{\linkitem}[3]{\g@addto@macro\IP@links{%
  \mbox{\href{#3}{{\color{ipAccent}#1}\enspace{\sffamily\small\color{ipInk}#2}}}\qquad}}
\newcommand{\code}[1]{\linkitem{\faGithub}{Code}{#1}}
\newcommand{\project}[1]{\linkitem{\faGlobe}{Project}{#1}}
\newcommand{\data}[1]{\linkitem{\faDatabase}{Data}{#1}}
\newcommand{\model}[1]{\linkitem{\faCube}{Model}{#1}}

\ifdefstring{\IP@titlealign}{center}
  {\newcommand{\IP@align}{\centering}}
  {\newcommand{\IP@align}{\raggedright}}

% ---------------------------------------------------------------- header
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\sffamily\scriptsize\color{ipFaint}\IP@short}
\fancyhead[R]{\sffamily\scriptsize\color{ipFaint}\MakeUppercase{\IP@tag}}
\fancyfoot[C]{\sffamily\footnotesize\color{ipGray}\thepage}
\renewcommand{\headrule}{{\color{ipRule}\hrule height 0.4pt}}
\fancypagestyle{plain}{\fancyhf{}%
  \fancyfoot[C]{\sffamily\footnotesize\color{ipGray}\thepage}%
  \renewcommand{\headrule}{}}
\fancypagestyle{ipfirst}{\fancyhf{}%
  \fancyhead[L]{\IP@leftlogo}%
  \fancyhead[R]{\IP@rightlogo}%
  \fancyfoot[C]{\sffamily\footnotesize\color{ipGray}\thepage}%
  \renewcommand{\headrule}{\vspace{4pt}{\color{ipAccent}\hrule height 0.8pt}}}

% ---------------------------------------------------------------- title block
\newcommand{\IP@heading}{%
  {\sffamily\bfseries\scriptsize\color{ipAccent}%
    \textls[180]{\MakeUppercase{\IP@tag}}\par}\vspace{0.7em}
  {\sffamily\bfseries\fontsize{21}{26}\selectfont\color{ipInk}\@title\par}%
  \vspace{1.0em}
  {\sffamily\fontsize{10.5}{14}\selectfont\color{ipInk}\@author\par}%
  \ifx\IP@affil\@empty\else
    \vspace{0.45em}{\small\color{ipGray}\IP@affil\par}\fi
  \ifx\IP@notes\@empty\else
    \vspace{0.2em}{\footnotesize\color{ipGray}\IP@notes\par}\fi}

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

\newcommand{\IP@openstyle}{%
  \begingroup\IP@align
    \IP@heading\IP@linksblock\IP@metablock
  \endgroup
  \ifx\IP@abstract\@empty\else
    \vspace{1.1em}%
    \begin{tcolorbox}[enhanced,colback=ipPanel,boxrule=0pt,frame hidden,
      arc=3pt,left=16pt,right=16pt,top=12pt,bottom=12pt,
      borderline west={2pt}{0pt}{ipAccent}]
      {\sffamily\bfseries\small\color{ipAccent}Abstract\par}\vspace{0.35em}
      {\small\linespread{1.12}\selectfont\color{ipInk}\IP@abstract\par}
    \end{tcolorbox}%
  \fi}

\newcommand{\IP@panelstyle}{%
  \begin{tcolorbox}[enhanced,colback=ipPanel,boxrule=0pt,frame hidden,
    arc=6pt,left=22pt,right=22pt,top=20pt,bottom=18pt]
    \begingroup\IP@align
      \IP@heading
      \ifx\IP@abstract\@empty\else
        \vspace{1.0em}%
        {\small\linespread{1.14}\selectfont\color{ipInk!82}\IP@abstract\par}%
      \fi
      \IP@linksblock
    \endgroup
    \vspace{0.2em}%
    \begin{minipage}[b]{0.68\linewidth}\raggedright\IP@metablock\end{minipage}%
    \hfill
    \begin{minipage}[b]{0.3\linewidth}\raggedleft\IP@panellogo\end{minipage}%
  \end{tcolorbox}}

\renewcommand{\maketitle}{%
  \ifdefstring{\IP@titlestyle}{panel}{\ifx\IP@panellogo\@empty\else
    \let\IP@leftlogo\@empty\let\IP@rightlogo\@empty\fi}{}%
  \ifx\IP@leftlogo\@empty\ifx\IP@rightlogo\@empty
    \thispagestyle{plain}\else\thispagestyle{ipfirst}\fi
  \else\thispagestyle{ipfirst}\fi
  \ifdefstring{\IP@titlestyle}{panel}{\IP@panelstyle}{\IP@openstyle}%
  \ifx\IP@firstnote\@empty\else
    \begingroup\renewcommand{\thefootnote}{}%
    \footnotetext{\color{ipGray}\IP@firstnote}\endgroup
  \fi
  \vspace{0.6em}%
}

% ---------------------------------------------------------------- boxes
\newtcolorbox{keybox}[1][Key takeaway]{enhanced,colback=ipPanel,boxrule=0pt,
  frame hidden,arc=2pt,left=12pt,right=12pt,top=8pt,bottom=8pt,
  borderline west={2pt}{0pt}{ipAccent},fontupper=\small,
  before upper={{\sffamily\bfseries\small\color{ipAccent}#1\par}\vspace{0.25em}}}

\newtcolorbox{promptbox}[1][Prompt]{enhanced,breakable,colback=white,
  colframe=ipRule,boxrule=0.6pt,arc=3pt,colbacktitle=ipPanel,
  coltitle=ipAccent,fonttitle=\sffamily\bfseries\footnotesize,title=#1,
  titlerule=0.6pt,left=10pt,right=10pt,top=7pt,bottom=7pt,
  fontupper=\ttfamily\footnotesize,before upper=\raggedright}

% ---------------------------------------------------------------- appendix
\titlecontents{ipsection}[1.8em]{\vspace{0.3em}\sffamily\bfseries\small\color{ipInk}}
  {\contentslabel[\color{ipAccent}\thecontentslabel]{1.8em}}{}
  {\color{ipRule}\titlerule*[0.5pc]{.}\color{ipInk}\contentspage}
\titlecontents{ipsubsection}[3.9em]{\small\color{ipGray}}
  {\contentslabel{2.1em}}{}{\color{ipRule}\titlerule*[0.5pc]{.}\color{ipGray}\contentspage}

\newcommand{\beginappendix}{%
  \clearpage\appendix
  {\raggedright\sffamily\bfseries\fontsize{20}{24}\selectfont\color{ipInk}Appendix\par}%
  \vspace{0.5em}{\color{ipAccent}\rule{2.5em}{1.5pt}}\par\vspace{0.8em}%
  \startcontents[appendix]%
  \printcontents[appendix]{ip}{1}{\setcounter{tocdepth}{2}}%
  \vspace{1.2em}}

\endinput
