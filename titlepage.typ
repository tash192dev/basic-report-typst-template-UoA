// ----- Title Page ------------------------

#let titlepage(
  doc-category,
  doc-title,
  author,
  affiliation,
  logo,
  heading-font,             // the heading-font is also used for all text on the titlepage
  info-size,
) = {

  // ----- Page-Setup ------------------------
  set page(
    paper: "a4",
    margin: (top: 2.8cm, left: 4.3cm, right: 3.6cm, bottom: 2.5cm),
  )

  // Some basic rules for the titlepage layout:
  // - logo is right-justified
  // - all other elements are left-justified
  // - the page uses a vertical grid of 3.5 cm units

  // ----- Logo ------------------------
  place(top + right,        // `place` so that the remaining layout is independent of the size of the logo
    logo,
  )

  v(7cm)                    // = 2 x 3.5 cm

  // ----- Title Category & Title ------------------------
  align(
    left,                   // 14pt + 36 pt = 1 x 3.5 cm
    text(font: heading-font, weight: "regular", size: 14pt, 
      doc-category),
  )

  text(font: heading-font, weight: "light", size: 36pt,  fill: blue,
    doc-title,
  )

  v(10.5cm, weak: true)    // = 3 x 3.5 cm

  // ----- Info Block ------------------------
  set par(leading: 1em)  
  align(
    left,
    text(
      font: heading-font, weight: "regular", size: info-size, fill: black,    
      datetime.today().display("[day].[month].[year]") + str("\n") + author + str("\n") + 
      affiliation
    )  
  )

}