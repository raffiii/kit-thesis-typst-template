//#import "@preview/cetz:0.2.2"

#let make-header(primary, secondary) = [
  #set text(size: 10pt)
  #grid(columns: 2, align: (left,right), [#primary #h(1fr)], secondary)
  #line(length: 100%)
]

#let get-header() = {
  context {
    let main-heading = query(heading.where(level:1)).filter(head => head.location().page() == here().page())
    
    if main-heading.len() > 0 {
      return []
    }

    let prev-main-heading = query(heading.where(level:1)).filter(head => head.location().page() < here().page()).sorted(key: head => head.location().page()).last()
    let prev-secondary-heading = query(heading.where(level:2)).filter(head => head.location().page() <= here().page() and head.location().page() >= prev-main-heading.location().page()).sorted(key: head => head.location().page()).last()
    return make-header(prev-main-heading.body, prev-secondary-heading.body)
    
  }
}

#let thesis(
  title: none,
  degree: "Master",
  abstract: (german: [], english: []),
  institute: none,
  author: (firstname: none, lastname: none),
  examiners: (),
  advisors: (),
  lang: "en",
  time: (from: none, to: none),
  sign: (loc: none, date: none),
  doc
) = {
  // Title page
  {
  set text(size: 13pt)
  set rect(width: 100%,
  height: 100%,
  inset: 4pt,
  radius: (top-right: 1cm, bottom-left: 1cm),
  stroke: 0.5pt
)
  let tablealign(a,b) = {
    let rows = a.zip(b).map(row=>row.map(c => [#c])).flatten()
    table(align: left, stroke: none, columns: 2,..rows)
  }
  let numbered = ("First", "Second", "Third", "Fourth", "Fifth")
  
  rect[
    #table(columns: 2,align: (left,right),stroke: none,
    pad(left:1cm,top:1.5cm,image("logos/kitlogo_de_cmyk.svg", width: 50%)),
    
    pad(right:1cm,top:1.5cm,image("logos/sdqlogo.svg", width: 50%))
  )
    #set align(center)
    #v(2cm)
    #text(20pt)[*#title*]

    #v(1cm)
    #degree's Thesis of
    #v(1cm)
    #text(17pt)[#author.firstname #author.lastname]
    #v(2.5cm)

    At the KIT Department of #institute.department\
    #institute.institute
    #tablealign(numbered.map(i => [#i Examiner:]),examiners)
    #tablealign(numbered.map(i => [#i Advisor:]),advisors)
    #v(1cm)
    #time.from - #time.to
  ]
  }
 
  
  // Postal Address of KIT
  [
    Karlsruher Institut für Technologie\
    Fakultät für Informatik\
    Postfach 6980\
    76128 Karlsruhe
  ]
  pagebreak()
  // Selbstständigkeitserklärung
  align(bottom)[
    #line(length: 100%)
    _Title of Thesis_

    I declare that I have developed and written the enclosed thesis completely by myself. I
have not used any other than the aids that I have mentioned. I have marked all parts of the
thesis that I have included from referenced literature, either in their original wording or
paraphrasing their contents. I have followed the by-laws to implement scientific integrity
at KIT.

*#sign.loc, #sign.date*

#v(1.5cm)
#line(length: 50%,stroke: (dash:"dotted"))
(#author.firstname #author.lastname)

  ]
  // Abstracts
  pagebreak(to: "odd") 
  set page(numbering: "i")
  
  counter(page).update(1)
  [= Abstract
  #abstract.english]
  
  pagebreak(to: "odd")
  [= Zusammenfassung
  #abstract.english]
  // ToC
  
  pagebreak(to: "odd")
  outline()
  context {
    if query(figure.where(kind: image)).len()>0 { 
      pagebreak(to: "odd")
      outline(
        title: [List of Figures],
        target: figure.where(kind: image),
      )  
    }
  }
  context {
    if query(figure.where(kind:table)).len()>0 { 
      pagebreak(to: "odd")
      outline(
        title: [List of Tables],
        target: figure.where(kind: table),
      )  
    }
  }
  
  
  // Thesis
  pagebreak(to: "odd")
  // typsetting stuff
  set figure(placement: auto, numbering: "1.1")
  set heading(numbering: "1.1")
  show heading: it => [#v(0.5cm) #it #v(0.5cm)]
  show heading.where(level: 1): it => [#pagebreak(weak: true) #v(2cm) #it #v(1cm)]
  
  set page(numbering: "1", header: get-header())
  counter(page).update(1)
  set math.equation(numbering: "(1.1)")
  doc
  

}

#let appendix(doc) = {
  set heading(numbering: "A.1")
  set page(numbering: "I")
  counter(page).update(1)
  bibliography("references.bib")
  counter(heading).update(0)
  doc
}