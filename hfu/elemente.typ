// Bausteine für die Kapiteldateien: Abbildungen, Tabellen, Quellcode, Zitate,
// Querformat und Monatsberichte.
//
// Pfade werden mit führendem "/" angegeben ("/bilder/…", "/code/…"). Typst löst
// solche Pfade gegen die Projektwurzel auf, nicht gegen die aufrufende Datei —
// dadurch funktionieren sie aus jedem Unterordner gleich.

#import "config.typ" as cfg

// §2.6/§2.7: Der Quellenverweis steht direkt unterhalb der Beschriftung.
// §3.7: Er gehört nicht zum Titel und damit nicht ins Verzeichnis. Deshalb ist
// er kein Teil der `caption`, sondern eine eigene Zeile darunter.
#let mit-quelle(figur, quelle, zusammenhalten: false) = {
  if quelle == none { return figur }

  block(breakable: not zusammenhalten, {
    show figure: set block(below: 0.3 * cfg.zeile)
    figur
    align(cfg.figur-ausrichtung, text(size: cfg.groesse.beschriftung)[Quelle: #quelle])
  })
}

// §2.6: Jede Abbildung wird beschriftet, die Beschriftung steht unterhalb.
#let abbildung(inhalt, caption: none, quelle: none) = mit-quelle(
  figure(inhalt, caption: caption, kind: image, supplement: [Abbildung]),
  quelle,
  zusammenhalten: true,
)

// §2.7: Tabellen werden ausschließlich abgesetzt eingebunden, beschriftet wird
// unterhalb. Tabelle 2: Tabelleninhalt 10 pt.
#let tabelle(caption: none, quelle: none, ..args) = mit-quelle(
  figure(
    {
      set text(size: cfg.groesse.tabelle)
      table(..args)
    },
    caption: caption,
    kind: table,
    supplement: [Tabelle],
  ),
  quelle,
)

// Zeilennummern nur in Quellcode-Listings, nicht in Code im Fließtext.
#let mit-zeilennummern(body) = {
  show raw.line: zeile => {
    box(width: 1.8em, align(right, text(fill: luma(140), str(zeile.number))))
    h(0.8em)
    zeile.body
  }
  body
}

// Quellcode aus einem Raw-Block:
//   #quellcode(```python …```, caption: [Titel])
#let quellcode(inhalt, caption: none, zeilennummern: true) = figure(
  block(
    width: 100%,
    fill: luma(248),
    stroke: 0.5pt + luma(210),
    inset: 0.8em,
    align(left, {
      // Quellcode wird einzeilig gesetzt; der 1,5-zeilige Abstand des
      // Fließtextes (§1.3.2) würde Listings unnötig auseinanderziehen.
      set par(leading: cfg.zeile-einfach - 1em, justify: false)
      if zeilennummern { mit-zeilennummern(inhalt) } else { inhalt }
    }),
  ),
  caption: caption,
  kind: "hfu-code",
  supplement: [Quellcode],
)

// Quellcode aus einer Datei in code/ — der Code bleibt dadurch ausführbar
// und wird nicht in die Arbeit hineinkopiert:
//   #quellcode-datei("/code/beispiel.py", lang: "python", caption: [Titel])
#let quellcode-datei(pfad, lang: none, caption: none, zeilennummern: true) = quellcode(
  // Der abschließende Zeilenumbruch der Datei würde sonst als leere
  // nummerierte Zeile im Listing erscheinen.
  raw(read(pfad).trim("\n", at: end), lang: lang, block: true),
  caption: caption,
  zeilennummern: zeilennummern,
)

// §3.6: Zitate über zwei Zeilen werden komplett eingerückt, damit sie als Block
// aus dem Fließtext hervorstechen.
#let zitat(quelle: none, body) = block(
  inset: (left: 1cm, right: 0.5cm),
  above: cfg.absatzabstand,
  below: cfg.absatzabstand,
  {
    body
    if quelle != none {
      linebreak()
      align(right, quelle)
    }
  },
)

// §1.2.1: Für große Tabellen und Abbildungen ist Querformat zulässig.
#let querformat(body) = page(flipped: true, body)

// §2.13: Die Monatsberichte sind Bestandteil des Anhangs. Sie werden als
// PDF-Seite eingebunden, damit die Kopfzeile der Arbeit erhalten bleibt.
#let monatsbericht(pfad, titel: none) = {
  if titel != none {
    heading(level: 2, numbering: none, titel)
  }
  align(center, image(pfad, width: 100%))
  pagebreak(weak: true)
}
