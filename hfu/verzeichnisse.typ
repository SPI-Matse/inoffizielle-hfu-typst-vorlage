// Inhalts-, Abbildungs-, Tabellen-, Quellcode- und Abkürzungsverzeichnis.
//
// Die Überschriften der Verzeichnisse setzt layout.typ; hier steht nur ihr
// Inhalt. Die Richtlinie schreibt die Überschriften wörtlich vor (§2.5, §2.8).

#import "config.typ" as cfg

// Zeilenabstand der Verzeichnisse — siehe `verzeichnis-zeile` in config.typ.
#let verzeichnis-satz(body) = {
  set par(
    leading: cfg.verzeichnis-zeile - 1em,
    spacing: cfg.verzeichnis-zeile - 1em,
    justify: false,
  )
  body
}

// Tabellen 7/8 und die Beispiele der Richtlinie schreiben Einträge der Form
// "Abbildung 1: Titel". Typst setzt standardmäßig "Abbildung 1 Titel".
#let mit-doppelpunkt(body) = {
  show outline.entry: it => {
    let bezeichnung = it.prefix()
    it.indented(
      if bezeichnung != none { [#bezeichnung:] },
      it.inner(),
    )
  }
  body
}

// §2.5 und Tabelle 6: alle Überschriften, maximal drei Gliederungsebenen,
// Hauptkapitel linksbündig, Unterkapitel eingerückt, Seitenzahlen rechtsbündig
// mit Punkten aufgefüllt (Typst-Standard).
#let inhaltsverzeichnis() = verzeichnis-satz(outline(
  title: none,
  depth: cfg.verzeichnis-tiefe,
  indent: auto,
))

// §2.6 und Tabelle 7
#let abbildungsverzeichnis() = verzeichnis-satz(mit-doppelpunkt(outline(
  title: none,
  target: figure.where(kind: image),
)))

// §2.7 und Tabelle 8
#let tabellenverzeichnis() = verzeichnis-satz(mit-doppelpunkt(outline(
  title: none,
  target: figure.where(kind: table),
)))

// Nicht in der Richtlinie geregelt, analog zu Tabelle 7/8 aufgebaut.
#let quellcodeverzeichnis() = verzeichnis-satz(mit-doppelpunkt(outline(
  title: none,
  target: figure.where(kind: "hfu-code"),
)))

// §2.8: "Das Abkürzungsverzeichnis besteht aus zwei Spalten. Die erste Spalte
// beinhaltet die Abkürzung, die zweite Spalte die zugehörige Erklärung."
#let abkuerzungsverzeichnis(liste) = {
  if liste == none or liste.len() == 0 { return }

  let sortiert = liste.sorted(key: eintrag => upper(eintrag.at(0)))

  verzeichnis-satz(grid(
    columns: (auto, 1fr),
    column-gutter: 1.5em,
    row-gutter: cfg.verzeichnis-zeile - 1em,
    align: (left, left),
    ..sortiert.map(eintrag => (eintrag.at(0), eintrag.at(1))).flatten(),
  ))
}
