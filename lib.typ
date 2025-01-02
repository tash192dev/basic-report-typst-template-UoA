#import "@preview/hydra:0.5.1": hydra
#import "titlepage.typ": *

// ----- Main Template Function: `basic-report` ----------------------

#let basic-report(
  doc-category: none,
  doc-title: none,
  doc-author: none,
  affiliation: none,
  logo: none,
  language: "de",
  body,
) = {

  set document(title: doc-title, author: doc-author)
  set text(lang: language)
  counter(page).update(0)

  // ----- Title Page ------------------------

  titlepage(
    doc-category,
    doc-title,
    doc-author,
    affiliation,
    logo,
  )

  // ----- Basic Text- and Page-Setup ------------------------

  let body-font = "Vollkorn"
  let body-size = 11pt
  let heading-font = "Ubuntu"
  let in-outline = state("in-outline", true)

  set text(
    font: body-font,
    size: body-size,
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
              counter(page).display("i")
            } else {
              counter(page).display("1")
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
      above: 2 * body-size, 
      below: 1 * body-size, 
      sticky: true)
  }

  set figure(numbering: "1")
  show figure.caption: it => {
    set text(font: heading-font, size: 9pt)
    block(it)
  }

  // ----- Table of Contents ------------------------
  
  // detect, if inside or outside the outline
  show outline: it => {
    in-outline.update(true)
    it
    in-outline.update(false)
  }
 
  show outline.entry.where(level: 1): it => {
    v(2 * body-size, weak: true)
    set text(font: heading-font, weight: "bold", size: 10pt)
    it.body
    box(width: 1fr,)
    strong(it.page)
  }

  // https://forum.typst.app/t/how-to-customize-outline-entry-filling-per-level/1211/2?u=roland_schatzle

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

  counter(page).update(0)
  pagebreak()

  // ----- Body Text ------------------------
  
  body

}