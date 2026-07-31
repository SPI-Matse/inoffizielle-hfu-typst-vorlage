// Seitenaufbau, Kopfzeile, Nummerierungsphasen und Überschriften.
//
// Der Kern ist `hfu-thesis`: eine Show-Rule-Funktion, die die von der
// Richtlinie in Tabelle 3 fest vorgegebene Reihenfolge der Bestandteile
// besitzt. Der Dokumentkörper enthält deshalb nur den inhaltlichen Teil der
// Arbeit; alles andere wird als benanntes Argument übergeben.

#import "config.typ" as cfg
#import "kapitel.typ": auf-rechte-seite, kopfzeile, kopfzeile-marke
#import "kapitel.typ": seitenzahl-neustart, trennblatt
#import "kapitel.typ": unnummeriertes-kapitel, vorspann-kapitel
#import "titelblatt.typ": titelblatt
#import "verzeichnisse.typ": abbildungsverzeichnis, abkuerzungsverzeichnis
#import "verzeichnisse.typ": inhaltsverzeichnis, quellcodeverzeichnis
#import "verzeichnisse.typ": tabellenverzeichnis
#import "versicherung.typ": versicherung

#let fehlt(feld, wert, fundstelle) = {
  if wert == none or wert == "" {
    panic(
      "hfu-vorlage: `" + feld + "` muss in thesis.typ gesetzt sein (Richtlinie " + fundstelle + ").",
    )
  }
}

// ── Hauptfunktion ───────────────────────────────────────────────────────────

#let hfu-thesis(
  // Titelblatt — Tabelle 5 und Abbildung 4
  art: none,
  studiengang: none,
  titel: none,
  untertitel: none,
  referent: none,
  korreferent: none,
  ersetztes-modul: none,
  vorgelegt-am: none,
  autor: (:),
  // Bestandteile — Tabelle 3
  vorwort: none,
  abstract-en: none,
  abstract-de: none,
  abkuerzungen: (),
  quellen: none,
  anhang: (),
  body,
) = {
  fehlt("art", art, "Tabelle 5")
  fehlt("studiengang", studiengang, "Tabelle 5")
  fehlt("titel", titel, "Tabelle 5")
  fehlt("referent", referent, "Tabelle 5")
  fehlt("autor.name", autor.at("name", default: none), "Tabelle 5")
  if vorgelegt-am == none {
    panic("hfu-vorlage: `vorgelegt-am` muss gesetzt sein (Richtlinie Tabelle 5).")
  }
  if abstract-de == none or abstract-en == none {
    panic("hfu-vorlage: Der Abstract ist in deutscher und englischer Sprache verpflichtend (Richtlinie §2.4).")
  }

  set document(title: titel, author: autor.at("name"))

  // ── Seite ─────────────────────────────────────────────────────────────────
  // §1.1 DIN A4, §1.2.1 Hochformat, §1.2.2 beidseitiger Druck im Buchformat,
  // Tabelle 1 Ränder und Bundsteg. Der Bundsteg liegt am inneren Rand.
  set page(
    paper: "a4",
    binding: left,
    margin: (
      top: cfg.rand-oben,
      bottom: cfg.rand-unten,
      inside: cfg.rand-innen + cfg.bundsteg,
      outside: cfg.rand-aussen,
    ),
    header: kopfzeile(),
    header-ascent: 40%,
    // Die Seitenzahl steht laut §1.2.5 in der Kopfzeile, nicht in der Fußzeile.
    footer: none,
    numbering: none,
  )

  // ── Text ──────────────────────────────────────────────────────────────────
  // top-edge/bottom-edge fixieren die Zeilenbox auf exakt 1 em. Erst dadurch
  // ergibt `leading` schriftunabhängig den in config.typ geforderten
  // Grundlinienabstand.
  set text(
    font: cfg.schrift,
    size: cfg.groesse.text,
    lang: "de",
    top-edge: 0.75em,
    bottom-edge: -0.25em,
  )
  set par(
    justify: cfg.blocksatz, // §1.3.2
    leading: cfg.zeile - 1em, // §1.3.2
    spacing: cfg.absatzabstand, // §1.2.6
    first-line-indent: 0pt,
  )
  show link: set text(font: cfg.schrift-mono, size: 0.9em)

  // ── Überschriften ─────────────────────────────────────────────────────────
  // Ebene 1 mit Punkt ("1. Einleitung"), Ebene 2 und 3 ohne ("1.1", "1.2.3") —
  // so wie im Referenz-PDF der Fakultät.
  set heading(numbering: (..n) => {
    let z = n.pos()
    if z.len() == 1 { numbering("1.", ..z) } else { numbering("1.1", ..z) }
  })
  // Tabelle 2
  show heading.where(level: 1): set text(size: cfg.groesse.h1, weight: "bold")
  show heading.where(level: 2): set text(size: cfg.groesse.h2, weight: "bold")
  show heading.where(level: 3): set text(size: cfg.groesse.h3, weight: "regular")
  show heading: set block(above: 1.2 * cfg.zeile, below: 0.7 * cfg.zeile)

  // ── Abbildungen, Tabellen, Quellcode ──────────────────────────────────────
  // §2.6/§2.7: Beschriftung unterhalb, Muster "Abbildung [Nummer]: [Titel]".
  // Beides ist Typst-Standard; die Wörter "Abbildung"/"Tabelle" liefert lang.
  show figure: set align(cfg.figur-ausrichtung)
  show figure.caption: set align(cfg.figur-ausrichtung)
  show figure.caption: set text(size: cfg.groesse.beschriftung)
  set figure(gap: 0.6 * cfg.zeile)
  // Tabellen 7/8: fortlaufende Nummerierung, nicht kapitelweise (Typst-Standard)

  show footnote.entry: set text(size: cfg.groesse.fussnote) // Tabelle 2
  show raw: set text(font: cfg.schrift-mono, size: cfg.groesse.quellcode)

  // ── 1. Titelblatt (ohne Seitenzahl, ohne Kopfzeile) ───────────────────────
  titelblatt(
    art: art,
    studiengang: studiengang,
    titel: titel,
    untertitel: untertitel,
    referent: referent,
    korreferent: korreferent,
    ersetztes-modul: ersetztes-modul,
    vorgelegt-am: vorgelegt-am,
    autor: autor,
  )

  // ── 2. Leeres Trennblatt (§2.2) ───────────────────────────────────────────
  trennblatt()

  // ── 3.–9. Vorspann: römische Ziffern ab I (Tabelle 4) ─────────────────────
  set page(numbering: "I")
  counter(page).update(1)
  seitenzahl-neustart()

  if vorwort != none {
    vorspann-kapitel("Vorwort", vorwort)
  }

  // §2.4, Abbildung 5: englische Fassung zuerst, danach die deutsche.
  vorspann-kapitel("Abstract", {
    set text(lang: "en")
    abstract-en
    v(cfg.zeile)
    set text(lang: "de")
    abstract-de
  })

  vorspann-kapitel(
    "Inhaltsverzeichnis",
    inhaltsverzeichnis(),
    im-inhaltsverzeichnis: cfg.inhaltsverzeichnis-listet-sich-selbst,
  )

  // Tabelle 3: verpflichtend, sofern Abbildungen bzw. Tabellen vorhanden sind.
  context {
    if query(figure.where(kind: image)).len() > 0 {
      vorspann-kapitel("Abbildungsverzeichnis", abbildungsverzeichnis())
    }
  }
  context {
    if query(figure.where(kind: table)).len() > 0 {
      vorspann-kapitel("Tabellenverzeichnis", tabellenverzeichnis())
    }
  }
  context {
    if cfg.quellcodeverzeichnis and query(figure.where(kind: "hfu-code")).len() > 0 {
      vorspann-kapitel("Quellcodeverzeichnis", quellcodeverzeichnis())
    }
  }

  vorspann-kapitel("Abkürzungsverzeichnis", abkuerzungsverzeichnis(abkuerzungen))

  // ── 10. Inhaltlicher Teil: arabische Ziffern ab 1 (Tabelle 4) ─────────────
  set page(numbering: "1")
  counter(page).update(1)
  seitenzahl-neustart()

  {
    // §1.2.3: Hauptkapitel beginnen immer auf der rechten Seite. Diese Regel
    // gilt nur hier — der Vorspann kennt sie nicht.
    show heading.where(level: 1): it => {
      auf-rechte-seite()
      it
      context {
        let nummer = if it.numbering != none {
          numbering("1", counter(heading).get().first())
        }
        kopfzeile-marke(if nummer != none { [#nummer #it.body] } else { it.body })
      }
    }

    body

    // ── 11. Literaturverzeichnis (§2.9.5) ───────────────────────────────────
    if quellen != none {
      unnummeriertes-kapitel("Literaturverzeichnis", {
        // §2.9.5: zwischen den Quellenangaben 1,5-zeilig, innerhalb einer
        // Quelle 1-zeilig.
        set par(leading: cfg.zeile-einfach - 1em, spacing: cfg.zeile - 1em)
        quellen
      })
    }
  }

  // ── 12. Leeres Trennblatt und Versicherung (§2.11) ────────────────────────
  trennblatt()
  versicherung(autor.at("name"))

  // ── 13. Anhang (§2.13) ────────────────────────────────────────────────────
  if anhang != none and anhang.len() > 0 {
    trennblatt()
    // Überschriften im Anhang tragen keine Kapitelnummern; die Gliederung
    // erfolgt über die Anhangsbuchstaben.
    set heading(numbering: none)
    for (i, teil) in anhang.enumerate() {
      let buchstabe = numbering("A", i + 1)
      // Erst auf die rechte Seite wechseln, dann umnummerieren — sonst trüge
      // schon die Füllseite davor die Seitenzahlen des Anhangsteils.
      auf-rechte-seite()
      // Tabelle 4: Seitenzahl nach dem Muster "[Buchstabe]-[Zahl]".
      set page(numbering: (..n) => buchstabe + "-" + str(n.pos().first()))
      counter(page).update(1)
      seitenzahl-neustart()
      heading(level: 1, numbering: none, outlined: true)[
        Anhang #buchstabe: #teil.at(0)
      ]
      // §2.13: Die Kopfzeile folgt dem Muster "Anhang [Buchstabe]".
      kopfzeile-marke("Anhang " + buchstabe)
      teil.at(1)
    }
  }
}
