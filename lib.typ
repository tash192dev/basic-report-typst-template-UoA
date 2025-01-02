#import "@preview/hydra:0.5.1": hydra
#import "titlepage.typ": *

// ----- Main Template Function: `basic-report` ----------------------

#let basic-report(
  doc-category: none,
  doc-title: none,
  author: none,
  affiliation: none,
  logo: none,
  language: "de",
  body,
) = {

  // ----- Global Parameters ------------------------

  set document(title: doc-title, author: author)
  set text(lang: language)

  counter(page).update(0)                       // so TOC after titlepage begins with page 1

  let body-font = "Vollkorn"
  let body-size = 11pt
  let heading-font = "Ubuntu"
  let in-outline = state("in-outline", true)    // are we inside or outside of the outline (for roman/arabic page numbers)?

  // ----- Title Page ------------------------

  titlepage(
    doc-category,
    doc-title,
    author,
    affiliation,
    logo,
    heading-font,
  )

  // ----- Basic Text- and Page-Setup ------------------------

  set text(
    font: body-font,
    size: body-size,
    // Vollkorn has a broader stroke than other fonts; in order to adapt the grey value (Grauwert)
    // of the page the font gets printed in a dark grey (80% instead of completely black)
    fill: luma(80)
  )

  set par(
    justify: true,
    leading: 0.65em,
    spacing: 1.65em,
    first-line-indent: 0em,
  )

  set page(
    paper: "a4",
    margin: (top: 4cm, left: 4.3cm, right: 3.6cm, bottom: 2.5cm),
    // the header shows the main chapter heading  on the left and the page number on the right
    header:  
      grid(
        columns: (1fr, 1fr),
        align: (left, right),
        row-gutter: 0.5em,
        text(font: heading-font, size: 9pt,
          context {hydra(1, use-last: true, skip-starting: false)},),
        text(font: heading-font, size: 9pt, 
          number-type: "lining",
          context {if in-outline.get() {
              counter(page).display("i")      // roman page numbers for the TOC
            } else {
              counter(page).display("1")      // arabic page numbers for the rest of the document
            }
          }
        ),
        grid.cell(colspan: 2, line(length: 100%, stroke: 0.5pt)),
      ),
    header-ascent: 1.5em,
  )
  
  // ----- Numbering Schemes ------------------------

  set heading(numbering: "1.")
  show heading: it => {
    set text(font: heading-font, fill: blue, weight: "regular")
    block(it,  
      height: 1 * body-size, 
      above:  2 * body-size, 
      below:  1 * body-size, 
      sticky: true)
  }

  set figure(numbering: "1")
  show figure.caption: it => {
    set text(font: heading-font, size: 9pt)
    block(it)
  }

  // ----- Table of Contents ------------------------
  
  // to detect, if inside or outside the outline (for different page numbers)
  show outline: it => {
    in-outline.update(true)
    it
    in-outline.update(false)
  }
 
  // top-level TOC entries in bold without filling
  show outline.entry.where(level: 1): it => {
    v(2 * body-size, weak: true)
    set text(font: heading-font, weight: "bold", size: 10pt)
    it.body
    box(width: 1fr,)
    strong(it.page)
  }

  // TO-DO: https://forum.typst.app/t/how-to-customize-outline-entry-filling-per-level/1211/2?u=roland_schatzle

  // other TOC entries in regular with adapted filling
  show outline.entry.where(level: 2).or(outline.entry.where(level: 3)): it => {
    set text(font: heading-font, size: 10pt)
    it.body + "  "
    box(width: 1fr, repeat([.], gap: 2pt))
    "  " + it.page
  }

  outline(
    title: "Inhalt",
    indent: auto,
  )

  counter(page).update(0)     // so the first chapter starts at page 1 (now in arabic numbers)
  pagebreak()

  // ----- Body Text ------------------------
  
  body

}