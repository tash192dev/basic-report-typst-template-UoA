#import "@preview/hydra:0.6.2": hydra
#import "titlepage.typ": *
#import "@preview/decasify:0.10.1": sentencecase


// ----- Main Template Function: `basic-report` ----------------------

#let basic-report(
  doc-category: none,
  doc-title: none,
  author: none,
  affiliation: none,
  logo: none,
  supervisor: none,
  project-partner: none,
  sponsor: none,
  language: "de",
  show-outline: true,
  compact-mode: false,
  heading-color: black,
  heading-font: "PT-Serrif", // recommended alternatives: "Fira Sans", "Lato", "Source Sans Pro"
  body,
) = {

  // ----- Global Parameters ------------------------

  set document(title: doc-title, author: author)
  set text(lang: language)


  let body-font = "PT-Serrif"
  let body-size = 11pt
  // let heading-font = "Ubuntu"

  // heading font is used in this size for kind of "information blocks"
  let info-size = 11pt              
  
  // heading font is used in this size for different sorts of labels            
  let label-size = 9pt                          
  let section-heading-size = 12pt // should be bold 
  let sub-heading = 11pt // shold be bold
  let sub-sub-heading = sub-heading // should be italics
  // are we inside or outside of the outline (for roman/arabic page numbers)?
  let in-outline = state("in-outline", if compact-mode {false} else {true})    

  // ----- Title Page ------------------------

  if (not compact-mode) {
    counter(page).update(0)                     // so TOC after titlepage begins with page no 1 (roman)
    titlepage(
      doc-category,
      doc-title,
      author,
      affiliation,
      logo,
      supervisor,
      project-partner,
      sponsor,
      heading-font,
      heading-color,
      info-size,
    )
  } 

  // ----- Basic Text- and Page-Setup ------------------------

  set text(
    font: body-font,
    size: body-size,
    // Vollkorn has a broader stroke than other fonts; in order to adapt the grey value (Grauwert)
    // of the page the font gets printed in a dark grey (instead of completely black)
    fill: luma(50)
  )

  set par(
    justify: true,
    leading: 0.75em,
    spacing: 1.65em,
    first-line-indent: 0em,
  )

  // Page Grid:
  // Horizontal 1.5cm-grid = 14u: 3u left margin, 9u text, 2u right margin
  //     Idea: one-sided document; if printed on paper, the pages are often bound or stapled
  //     on the left side; so more space needed on the left. On-screen it doesn't matter.
  // Vertical 1.5cm-grid ≈ 20u: 2u top margin, 14u text, 2u botttom margin
  //     header with height ≈ 0.6cm is visually part of text block --> top margin = 3cm + 0.6cm
  set page(               // standard page with header
    paper: "a4",
    margin: (top: 2.5cm, left: 2cm, right: 2cm, bottom: 2.5cm),
  )

  
  // ----- Headings & Numbering Schemes ------------------------

  set heading(numbering: "1.")
  
  show heading: set text(font: heading-font, fill: heading-color, 
      weight: if compact-mode {"bold"} else {"regular"})
  show heading: set par(justify: false)


  show heading.where(level: 1): it => {
    // set text(size: section-heading-size, weight: "regular")
    // upper(text(it)) 
    set text(size: section-heading-size, weight: "bold")
    upper(text(it))
  }
  show heading.where(level: 2): it => {     
    set text(size: sub-heading, weight: "regular")
    sentencecase(text(it)) // this should be sentence case but the template is missing it lol
  }
  show heading.where(level: 3): it => {
    set text(size: sub-heading, weight: "regular")
    emph(sentencecase(text(it)))
  }

  set figure(numbering: "1")
  show figure.caption: it => {
    set text(font: heading-font, size: label-size)
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
    set block(above: 2 * body-size)
    set text(font: heading-font, weight: "regular", size: info-size)
    link(
      it.element.location(),    // make entry linkable
      it.indented(it.prefix(), it.body() + box(width: 1fr,) +  strong(it.page()))
    )
  }

  // other TOC entries in regular with adapted filling
  show outline.entry.where(level: 2).or(outline.entry.where(level: 3)): it => {
    set block(above: 0.8 * body-size)
    set text(font: heading-font, size: info-size)
    link(
      it.element.location(),  // make entry linkable
      it.indented(
          it.prefix(),
          it.body() + "  " +
            box(width: 1fr, repeat([.], gap: 1pt)) +
            "  " + it.page()
      )
    )
  }

  if (show-outline and not compact-mode) {
    outline(
      title: if language == "de" { 
        "Inhalt"
      } else if language == "fr" {
        "Table des matières"
      } else if language == "es" {
        "Contenido"
      } else if language == "it" {
        "Indice"
      } else if language == "nl" {
        "Inhoud"
      } else if language == "pt" {
        "Índice"
      } else if language == "zh" {
        "目录"
      } else if language == "ja" {
        "目次"
      } else if language == "ru" {
        "Содержание"
      } else if language == "ar" {
        "المحتويات"
      } else {
        "Table of Contents"
      },
      indent: auto, 
    )
    counter(page).update(0)     // so the first chapter starts at page 1 (now in arabic numbers)
  } else {
    in-outline.update(false)    // even if outline is not shown, we want to continue with arabic page numbers
    counter(page).update(1)
  }

  if (not compact-mode) {
    pagebreak()
  }

  // ----- Body Text ------------------------
  
  if compact-mode {             // compact title infos in compact-mode
    compact-title(
      doc-category,
      doc-title,
      author,
      affiliation,
      logo,
      heading-font,             
      heading-color,            
      info-size,                
      body-size,
      label-size,
    )
  }

  body

}
