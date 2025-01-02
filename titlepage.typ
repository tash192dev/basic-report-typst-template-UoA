// ----- Title Page ------------------------

#let titlepage(
  doc-category,
  doc-title,
  author,
  affiliation,
  logo,
) = {

  // ----- Page-Setup ------------------------
  set page(
    paper: "a4",
    margin: (top: 2.8cm, left: 4.3cm, right: 3.6cm, bottom: 2.5cm),
  )

  // ----- Logo ------------------------
  place(top + right,
    logo,
  )

  v(7cm)

  // ----- Title Category & Title ------------------------
  align(
    left,
    text(font: "Ubuntu", weight: "regular", size: 14pt, 
      doc-category),
  )

  text(font: "Ubuntu", size: 36pt, weight: "light", fill: blue,
    doc-title,
  )

  v(10.5cm, weak: true)

  // ----- Info Block ------------------------
  set par(leading: 1em)  
  align(
    left,
    text(
      font: "Ubuntu", weight: "regular", size: 10pt, fill: black,    
      datetime.today().display("[day].[month].[year]") + str("\n") + author + str("\n") + 
      affiliation
    )  
  )

}