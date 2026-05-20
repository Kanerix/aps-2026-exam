#import "@preview/rubber-article:0.5.2": *

#show: article.with(
  eq-chapterwise: true,
  eq-numbering: "(1.1)",
  fig-caption-width: 70%,
  header-display: true,
  header-title: "Algorithmic Problem Solving 2026",
  heading-numbering: "1.1",
  lang: "en",
  page-margins: 1.75in,
  page-numbering: "1",
  page-paper: "us-letter",
)

#set par(leading: 0.65em, spacing: 1.2em, first-line-indent: 0em)

#set text(
  font: "Libertinus Serif",
)

#include "frontpage.typ"

#outline()
#pagebreak()

#include "chapters/own-problem.typ"

= Solved Problems
#include "chapters/buzzwords.typ"
#include "chapters/cookie-selection.typ"
#include "chapters/exchange-rates.typ"

#pagebreak()

= Appendices
#include "appendices/buzzwords_solution.typ"
#pagebreak()
#include "appendices/cookie_selection_solution.typ"
#pagebreak()
#include "appendices/exchange_rates_solution.typ"
