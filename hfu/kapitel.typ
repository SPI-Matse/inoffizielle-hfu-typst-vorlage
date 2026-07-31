// Kopfzeile, Trennblätter und Kapitelgerüst.
//
// Eigenes Modul, damit sowohl layout.typ als auch versicherung.typ darauf
// zugreifen können, ohne sich gegenseitig zu importieren.

#import "config.typ" as cfg

// Jedes Kapitel hinterlegt den Text, der ab hier in der Kopfzeile stehen soll.
// Die Kopfzeile sucht sich davon die letzte Marke auf oder vor der aktuellen
// Seite. Der Umweg über Metadaten statt über `state` ist bewusst gewählt: er
// hängt nicht davon ab, in welcher Reihenfolge Typst die Seiten setzt.
#let kopfzeile-marke(inhalt) = [#metadata(inhalt)<hfu-kopf>]

// Wird überall dort gesetzt, wo der Seitenzähler neu beginnt. Die Kopfzeile
// wird oben auf der Seite gesetzt, der Zähler aber erst im Seiteninhalt
// zurückgesetzt — ohne diese Marke zeigte die erste Seite eines Abschnitts noch
// den alten Zählerstand.
#let seitenzahl-neustart() = [#metadata(none)<hfu-seitenreset>]

// §1.2.5: Hauptkapitelüberschrift stets innen, Seitenzahl stets außen,
// abgegrenzt durch einen horizontalen Strich.
#let kopfzeile() = context {
  let seite = here().page()

  let marken = query(<hfu-kopf>).filter(m => m.location().page() <= seite)
  let kapitel = if marken.len() > 0 { marken.last().value } else { none }

  // Auf Seiten mit Zählerneustart den Stand hinter dem Neustart ablesen.
  let neustarts = query(<hfu-seitenreset>).filter(m => m.location().page() == seite)
  let ort = if neustarts.len() > 0 { neustarts.first().location() } else { here() }

  let muster = ort.page-numbering()
  let nummer = if muster != none { numbering(muster, ..counter(page).at(ort)) }

  if kapitel == none and nummer == none { return }

  set text(size: cfg.groesse.kopfzeile, weight: "bold")

  // Ungerade Seiten liegen rechts, ihr innerer Rand ist links — und umgekehrt.
  // Die Seitenzahl bekommt nur ihre natürliche Breite, damit lange
  // Kapitelüberschriften nicht mit ihr kollidieren.
  let (spalten, links, rechts) = if calc.odd(seite) {
    ((1fr, auto), kapitel, nummer)
  } else {
    ((auto, 1fr), nummer, kapitel)
  }

  stack(
    spacing: 0.35em,
    grid(
      columns: spalten,
      column-gutter: 1em,
      align: (left, right),
      [#links], [#rechts],
    ),
    line(length: 100%, stroke: 0.5pt),
  )
}

// Eine vollständig leere Seite: ohne Kopfzeile, ohne Seitenzahl.
#let leerseite() = page(header: none, footer: none, numbering: none, [])

// §2.2, §2.11, §2.13: leeres Trennblatt zwischen bestimmten Bestandteilen.
#let trennblatt() = {
  pagebreak()
  leerseite()
}

// §1.2.3: Hauptkapitel beginnen immer auf der rechten Seite.
//
// Die dabei entstehende Füllseite trägt Kopfzeile und Seitenzahl — genau wie
// bei einem Abschnittswechsel "Ungerade Seite" in Word.
//
// Sie stattdessen als echte Leerseite zu setzen, würde bedeuten, ihre
// Notwendigkeit über `context here().page()` selbst zu bestimmen. Jede solche
// Entscheidung verschiebt aber die Seitenzahlen aller folgenden Kapitel und
// damit deren Entscheidung; Typsts Layout-Iteration konvergiert dann in einem
// vollständigen Dokument nicht mehr zuverlässig. `pagebreak(to: "odd")`
// überlässt die Parität dem Satzsystem und ist deterministisch.
#let auf-rechte-seite() = pagebreak(to: "odd", weak: true)

// Kapitel des Vorspanns (Vorwort, Abstract, Verzeichnisse). Sie tragen keine
// Kapitelnummer und beginnen — anders als Hauptkapitel — auf beliebiger Seite;
// so hält es auch das Referenz-PDF der Fakultät.
#let vorspann-kapitel(titel, body, im-inhaltsverzeichnis: true) = {
  pagebreak(weak: true)
  heading(level: 1, numbering: none, outlined: im-inhaltsverzeichnis, titel)
  kopfzeile-marke(titel)
  body
}

// Kapitel ohne Nummer im arabisch nummerierten Teil (Literaturverzeichnis,
// Versicherung). Standardmäßig auf der rechten Seite beginnend; die englische
// Fassung der Versicherung folgt laut Richtlinie (Seiten 13/14) direkt auf die
// deutsche und setzt deshalb `rechte-seite: false`.
#let unnummeriertes-kapitel(titel, body, rechte-seite: true) = {
  if rechte-seite { auf-rechte-seite() } else { pagebreak(weak: true) }
  heading(level: 1, numbering: none, outlined: true, titel)
  kopfzeile-marke(titel)
  body
}
