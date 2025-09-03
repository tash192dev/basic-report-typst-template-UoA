// ===== Functions for TITLE PAGE and COMPACT TITLE ===============


// ===== TITLE PAGE: `titlepage` ====================

#let titlepage(
  doc-category,
  doc-title,
  author,
  affiliation,
  logo,
  supervisor,
  project-partner,
  sponsor,
  heading-font, // the heading-font is also used for all text on the titlepage
  heading-color, // heading-color applies as well for the title
  info-size, // used throughout the document for "info text"
) = {
  // ----- Page-Setup ------------------------
  set page(
    paper: "a4",
    margin: (top: 2.5cm, left: 2cm, right: 2cm, bottom: 2.5cm),
  )
  let title-font-size = 28pt
  let other-font-size = 16pt
  let affiliation-font-size = 13pt

  // Some basic rules for the title page layout:
  // - logo is right-justified
  // - all other elements are left-justified
  // - the page uses a grid of 1.5 cm units

  // ----- Funcs ------------------------
  let my-date(..args) = {
  let date = if args.pos().len() == 0 {
    datetime.today()
  } else {
    args.pos().first()
  }
  let day = date.day()
  let suffix = if day in (11, 12, 13) { "th" } else {
    ("st", "nd", "rd").at(calc.rem(day - 1, 10), default: "th")
  }
  return date.display("[month repr:long] [day padding:none]" + suffix + " [year]")
}
  // ----- Title  ------------------------
  v(2cm)

  place(
    center,
    text(font: heading-font, weight: "regular", size: title-font-size, doc-title),
  )
  v(4cm)

  place(
    center,
    text(font: heading-font, weight: "bold", size: other-font-size, author),
  )
  v(1cm)

  place(
    center,
    text(font: heading-font, weight: "regular", size: affiliation-font-size, affiliation),
  )
  v(3cm)

  place(
    center,
    text(font: heading-font, weight: "bold", size: other-font-size,   my-date()),
  )
  v(2cm)

  place(
    center, 
    logo,
  )
  v(5cm)

  // ----- Affiliates Block ------------------------
  let project_affiliates = none

  if (sponsor == none) {
    project_affiliates = "Supervisor: " + supervisor + "\n" + "Project Partner: " + project-partner + "\n"
  } else {
    project_affiliates = "Supervisor: " + supervisor + "\n" + "Project Partner: " + project-partner + "\n" + "Sponsored by: " + sponsor + "\n"
  }
  set par(leading: 1.5em)

  place(
    center,
    text(
      font: heading-font,
      weight: "regular",
      size: 16pt,
      fill: black,
      project_affiliates
    ),
  )
}

// ===== COMPACT TITLE: `compact-title` ====================

#let compact-title(
  doc-category,
  doc-title,
  author,
  affiliation,
  logo,
  heading-font, // the heading-font is also used for all text on the titlepage
  heading-color, // heading-color applies as well for the title
  info-size, // used throughout the document for "info text"
  body-size,
  label-size,
) = {
  stack(
    v(1.5cm - 0.6cm), // 3.6cm top-margin -0.6cm + 1.5cm = 4.5cm
    box(height: 1.5cm, text(font: heading-font, size: 1 * body-size, top-edge: "ascender", doc-category)),
    box(
      height: 6cm,
      par(
        leading: 0.5em,
        text(
          font: heading-font,
          weight: "bold",
          size: 2 * body-size,
          fill: luma(40%).mix(heading-color),
          top-edge: "ascender",
          hyphenate: false,
          doc-title,
        )
          + "\n\n",
      )
        + text(
          font: heading-font,
          size: label-size,
          author + "\n" + affiliation + ", " + datetime.today().display("[day].[month].[year]"),
        ),
    ),
  )
}
