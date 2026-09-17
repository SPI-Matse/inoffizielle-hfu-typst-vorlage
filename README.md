# Inoffizielle HFU-Typst-Vorlage für wissenschaftliche Arbeiten

[![Build and release](https://github.com/SPI-Matse/inoffizielle-hfu-typst-vorlage/actions/workflows/build-release.yml/badge.svg)](https://github.com/SPI-Matse/inoffizielle-hfu-typst-vorlage/actions/workflows/build-release.yml)

Aktuelle Version: **v1.0.1**

Inoffizielle Typst-Vorlage für wissenschaftliche Arbeiten an der **Fakultät I (Informatik) der Hochschule Furtwangen**.
Sie basiert auf der *Richtlinie für die Erstellung wissenschaftlicher Arbeiten*, Stand **Januar 2024**.

> [!IMPORTANT]
> **Diese Vorlage ist ein privates, inoffizielles Drittprojekt.**
> Sie stammt nicht von der Hochschule Furtwangen, wurde von der HFU weder herausgegeben noch geprüft oder freigegeben und darf nicht als offizielle HFU-Vorlage verstanden werden.
> Eine Gewähr für formale oder inhaltliche Richtigkeit wird nicht übernommen.
> Nutzende müssen vor der Abgabe selbst prüfen, ob das erzeugte Dokument der aktuellen Richtlinie, der jeweiligen SPO und den Vorgaben ihrer Betreuer:innen entspricht.

## Geltungsbereich

Die Vorlage bildet das allgemeine Layout für wissenschaftliche Arbeiten an der Fakultät Informatik ab.
**Master-Seminararbeiten und Master-Berichte müssen laut Richtlinie grundsätzlich im IEEE-Conference-Layout erstellt werden und dürfen diese Vorlage nicht verwenden.**

Die Richtlinie nennt unter anderem DIN A4, beidseitigen Druck im Buchformat, Klebebindung und festgelegte Innen- und Außenränder.
Vorgaben zum physischen Druck und zur Bindung können von Typst nicht überprüft werden.

## Schnellstart

Voraussetzung ist [Typst](https://github.com/typst/typst#installation) `0.15.1` oder neuer.
Alternativ kann das Projekt vollständig in die [Typst-Web-App](https://typst.app/) hochgeladen werden.

1. Über **[Use this template](https://github.com/SPI-Matse/inoffizielle-hfu-typst-vorlage/generate)** ein eigenes GitHub-Repository erstellen.
2. Das neue Repository klonen und die Vorschau starten:

   ```bash
   git clone https://github.com/DEIN-NAME/DEIN-REPOSITORY.git
   cd DEIN-REPOSITORY
   typst watch thesis.typ
   ```

3. Angaben und Wahlmöglichkeiten in `thesis.typ` anpassen.
4. Deutsche und englische Abstract-Datei sowie `inhalt/abkuerzungen.typ` ausfüllen.
5. Beispielkapitel ersetzen und Quellen in `literatur.bib` pflegen.
6. Vor der Abgabe die Checkliste in diesem README und die aktuelle HFU-Richtlinie vollständig prüfen.

Nur zum Mitentwickeln an der Vorlage selbst wird dieses Repository direkt geklont:

```bash
git clone https://github.com/SPI-Matse/inoffizielle-hfu-typst-vorlage.git
```

Versionierte Stände werden unter [Releases](https://github.com/SPI-Matse/inoffizielle-hfu-typst-vorlage/releases) bereitgestellt.

## Projektstruktur

```text
thesis.typ                    Angaben, Wahlmöglichkeiten und Kapitel
inhalt/                       Text der Arbeit und Vorspann
inhalt/abkuerzungen.typ       Abkürzungen mit Kurz- und Langformen
anhang/                       Anhangsteile und Monatsberichte
bilder/                       Abbildungen und Logo
code/                         eingebundene Quelldateien
literatur.bib                 Literaturdaten
hfu/                          Layout der Vorlage
tests/pruefen.py              formale PDF-Prüfungen
```

Im Normalfall werden nur `thesis.typ`, `literatur.bib`, `inhalt/`, `bilder/`, `code/` und `anhang/` bearbeitet.
Kapiteldateien benötigen lediglich den Import von `hfu/lib.typ`.

## Wählbare Einstellungen

### Abkürzungen

Abkürzungen werden zentral in `inhalt/abkuerzungen.typ` definiert:

```typst
#let abkuerzungen = (
  (kurz: "HFU", lang: "Hochschule Furtwangen University"),
  (kurz: "SPO", lang: "Studien- und Prüfungsordnung"),
)
```

Im Text wird ausschließlich der Baustein `ac` verwendet:

```typst
Die #ac("HFU") veröffentlicht ihre Richtlinien.
Die #ac("HFU") wird bei weiteren Verwendungen nur noch als Kurzform gesetzt.
```

Die erste Verwendung ergibt `Hochschule Furtwangen University (HFU)`.
Alle weiteren Verwendungen ergeben `HFU`.
Dieses Verhalten entspricht dem Grundprinzip von `\ac{...}` aus dem LaTeX-Paket `acronym`, das auch die als Vorbild genannte [HFU-LaTeX-Vorlage](https://github.com/SPI-Matse/HFU-LaTeX-Vorlage) verwendet.

Die Beispieldefinitionen verwenden die offiziellen Bezeichnungen der [Hochschule Furtwangen](https://www.hs-furtwangen.de/), der [American Psychological Association](https://www.apa.org/about) und des [Institute of Electrical and Electronics Engineers](https://www.ieee.org/about/).
`SPO` folgt der Bezeichnung „Studien- und Prüfungsordnung“ aus der HFU-Richtlinie.

Die Vorlage nimmt nur tatsächlich verwendete Abkürzungen in das Abkürzungsverzeichnis auf und sortiert sie alphabetisch.
Nach §2.8 sollten dort in der Regel nur nicht allgemein gebräuchliche Abkürzungen stehen.
Unbekannte oder doppelt definierte Kurzformen führen zu einer verständlichen Fehlermeldung.
Ein normal geschriebener Text wie `HFU` kann nicht automatisch als Abkürzungsverwendung erkannt werden und muss deshalb als `#ac("HFU")` gesetzt werden.
Abkürzungen in Tabellen und Abbildungen müssen laut §2.8 zusätzlich in einer Legende erklärt werden.

### Zitierstil

Am Anfang von `thesis.typ` wird zwischen IEEE und APA gewählt:

```typst
#let zitierstil = "ieee" // alternativ: "apa"
```

Die Fakultät empfiehlt beide Stile, verlangt aber die Abstimmung mit den Betreuer:innen (§2.9.4).
Typst `0.15.1` verwendet für `"ieee"` den IEEE Reference Guide vom 29.11.2023 und für `"apa"` APA Style in der 7. Auflage.

Nur im Text zitierte Quellen erscheinen im Literaturverzeichnis.
Dieses Verhalten ist der Typst-Standard für `bibliography` mit `full: false`.
Bei veränderlichen Onlinequellen muss ein Abrufdatum angegeben werden und eine reine URL-Liste genügt nicht.

Seitenzahlen und andere Fundstellen werden als Bestandteil der Zitation übergeben:

```typst
@autor2021[S. 12]
```

Weiterführende Dokumentation:

- [Typst: Bibliography](https://typst.app/docs/reference/model/bibliography/)
- [Typst: Cite](https://typst.app/docs/reference/model/cite/)
- [APA Style: References](https://apastyle.apa.org/style-grammar-guidelines/references)
- [IEEE Reference Guide](https://ieeeauthorcenter.ieee.org/wp-content/uploads/IEEE-Reference-Guide.pdf)

### Schrift

Die Richtlinie schreibt keine konkrete Schriftfamilie vor.
Gefordert sind eine einheitliche, gut lesbare Schrift und der Verzicht auf Zier- oder Schmuckschriften.
Nur Quellcode darf eine zweite Monospace-Schrift verwenden (§1.3).

Die Voreinstellung in `thesis.typ` lautet:

```typst
#let schrift = ("Arial", "Liberation Sans", "Nimbus Sans", "Helvetica")
#let schrift-mono = ("Liberation Mono", "DejaVu Sans Mono", "Consolas", "Menlo")
```

Typst probiert die Schriften in dieser Reihenfolge.
Warnungen zu fehlenden Fallback-Schriften sind unproblematisch, solange mindestens eine Schrift der jeweiligen Kette installiert ist.
Schriftdateien selbst werden nicht mitgeliefert.

### Weitere Wahlmöglichkeiten

| Einstellung | Vorgabe beziehungsweise Spielraum |
|---|---|
| `blocksatz` | Blocksatz oder linksbündiger Flattersatz; Blocksatz wird empfohlen |
| `vorwort` | optional |
| `sperrvermerk` | optional und mit allen Betreuer:innen abzustimmen |
| `anhang` | optional; Monatsberichte der Thesis gehören hinein |
| `querformat` | nur für große Abbildungen oder Tabellen |

Nicht frei wählbar sind unter anderem Seitenformat, Ränder, Bundsteg, Schriftgrade, Kopfzeilenaufbau, Pflichtbestandteile, Rechtsbeginn der Hauptkapitel und die vorgeschriebenen Trennblätter.

## Sperrvermerk

Der optionale Sperrvermerk steht unmittelbar nach dem Titelblatt und vor allen weiteren Bestandteilen.
Seine Seite besitzt weder Kopfzeile noch Seitenzahl.
Anschließend folgt weiterhin das vorgeschriebene leere Trennblatt.

Praxissemesterbericht beziehungsweise Bericht:

```typst
sperrvermerk: (
  firma: "Musterunternehmen GmbH",
  variante: "bericht",
),
```

Bachelorarbeit:

```typst
sperrvermerk: (
  firma: "Musterunternehmen GmbH",
  variante: "bachelorarbeit",
),
```

Ohne Sperrvermerk:

```typst
sperrvermerk: none,
```

Die Richtlinie erlaubt Sperrvermerke und Anonymisierung, gibt aber keinen Wortlaut vor.
Text, Position und Inhaltsverzeichniseintrag müssen deshalb vor der Abgabe mit allen Betreuer:innen bestätigt werden.

## Schreiben

Kapiteldateien importieren die öffentlichen Bausteine:

```typst
#import "../hfu/lib.typ": *

= Hauptkapitel
== Unterkapitel
=== Dritte Ebene
```

Das Inhaltsverzeichnis führt höchstens drei Ebenen.
Hauptkapitel beginnen automatisch auf einer rechten Seite.
Überschriften müssen ihren Inhalt aussagekräftig beschreiben und ein Gliederungspunkt darf nicht allein stehen.

### Öffentliche Bausteine

Die zusätzlichen Bausteine haben bewusst verständliche deutsche Namen:

| Baustein | Zweck |
|---|---|
| `ac` | führt eine definierte Abkürzung ein und setzt spätere Verwendungen als Kurzform |
| `abbildung` | erzwingt eine Beschriftung und unterstützt eine getrennte Quellenzeile |
| `tabelle` | setzt Tabellen im vorgeschriebenen Schriftgrad mit Beschriftung und optionaler Quelle |
| `quellcode` | setzt direkt angegebenen Quellcode |
| `quellcode-datei` | liest Quellcode aus einer separat ausführbaren Datei |
| `querformat` | begrenzt Querformat auf einzelne breite Inhalte |
| `monatsbericht` | bindet ausgewählte Seiten eines Monatsberichts in den Anhang ein |

`ac` ist die einzige bewusst kurze englische Bezeichnung.
Sie orientiert sich an `\ac{...}` aus dem verbreiteten LaTeX-Paket `acronym` und wird häufig mitten im Fließtext verwendet.
Für Funktionen, die Typst bereits anbietet, entstehen keine parallelen Wrapper.
Zitate verwenden deshalb beispielsweise direkt `quote`, Referenzen direkt `@label` und Literaturangaben direkt Typsts Bibliografiefunktionen.

### Abbildungen und Tabellen

```typst
#abbildung(
  image(
    "/bilder/architektur.svg",
    width: 80%,
    alt: "Komponenten und Datenflüsse der Architektur.",
  ),
  caption: [Aufbau des Systems],
  quelle: [Eigene Darstellung in Anlehnung an @mueller2021[S. 42]],
) <abb-architektur>

#tabelle(
  columns: (auto, 1fr),
  table.header([Kriterium], [Wert]),
  [Durchsatz], [1,2 GB/s],
  caption: [Messergebnisse],
)
```

Beschriftungen sind verpflichtend und stehen unter dem Element.
Bei übernommenen oder angelehnten Darstellungen steht die zitierte Quelle unmittelbar unter der Beschriftung.
Die Quelle gehört nicht zum Verzeichniseintrag.
Abbildungs- und Tabellenverzeichnis werden nur erzeugt, wenn entsprechende Elemente vorhanden sind.

Abkürzungen innerhalb einer Abbildung oder Tabelle benötigen zusätzlich eine Legende.
Ein Alternativtext beschreibt die relevante Aussage einer Abbildung für Screenreader und sollte nicht lediglich die Beschriftung wiederholen.

### Direkte Zitate

Typst besitzt mit `quote` bereits einen semantischen Baustein für Zitate.
Die Vorlage gestaltet mehrzeilige Blockzitate passend zur Richtlinie und baut dafür keinen parallelen eigenen Zitatbefehl nach.

```typst
#quote(
  block: true,
  quotes: true,
  attribution: [@autor2021[S. 12]],
)[
  Unveränderter Wortlaut des direkten Zitats in der Originalsprache.
]
```

Direkte Zitate müssen in Anführungszeichen stehen und eine genaue Fundstelle besitzen.
Bei mehr als zwei Zeilen werden sie zusätzlich eingerückt und sollten insgesamt nur sparsam verwendet werden.

### Quellcode, Querformat und Monatsberichte

```typst
#quellcode-datei(
  path("/code/beispiel.py"),
  lang: "python",
  caption: [Beispielprogramm],
)

#querformat[ ... breite Tabelle ... ]

#monatsbericht(
  path("/anhang/berichte/2026-01.pdf"),
  titel: "Januar 2026",
  seiten: (1, 2),
)
```

`path(...)` löst Dateien im aufrufenden Projekt auf und ist damit auch für einen späteren Paketimport geeignet.
Bei mehrseitigen PDF-Berichten müssen die einzubindenden Seiten ausdrücklich angegeben werden.

## Automatisch umgesetzte Kernvorgaben

- DIN A4, beidseitiges Buchformat und Innen-/Außenränder einschließlich Bundsteg
- 12-pt-Fließtext, 1,5-zeiliger Abstand und definierte Überschriftengrößen
- Kapitelüberschrift innen und Seitenzahl außen in der Kopfzeile
- Titelblatt und vorgeschriebene leere Trennblätter
- römische Nummerierung des Vorspanns und arabische Nummerierung des Inhalts
- Abstract auf Englisch und Deutsch
- dynamisches Abbildungs-, Tabellen- und Abkürzungsverzeichnis
- alphabetisches und verwendungsabhängiges Abkürzungsverzeichnis
- Literaturverzeichnis mit eigenem Zeilenabstand
- deutsche und englische Versicherung mit vorgeschriebenem Wortlaut
- eigener Nummerierungsbereich für jeden Anhangsteil

Nicht enthalten sind das optionale Stichwortverzeichnis und das separate IEEE-Conference-Layout für Master-Seminararbeiten und -Berichte.
Ein Quellcodeverzeichnis ist nicht Bestandteil der vorgeschriebenen Dokumentstruktur und wird deshalb nicht erzeugt.
Relevante Ausschnitte können im Haupttext referenziert werden; umfangreicher Quellcode gehört in einen eigenen Anhangsteil.

## Vor der Abgabe selbst prüfen

Die Vorlage kann nicht alle inhaltlichen und organisatorischen Vorgaben automatisch erzwingen.
Insbesondere sind folgende Punkte zu prüfen:

- Der deutsche und englische Abstract umfassen jeweils höchstens etwa 100 bis 120 Wörter und nennen Forschungsfrage, Ziel, Ansatz, Methodik, wichtigste Ergebnisse und Fazit.
- Alle Platzhalter auf dem Titelblatt und in den Kapiteln wurden ersetzt.
- Die Arbeit verwendet keine vierte Gliederungsebene.
- Jede erstmalig verwendete Abkürzung erscheint als `Langform (Kurzform)`.
- Abkürzungen in Abbildungen und Tabellen werden zusätzlich durch eine Legende erklärt.
- Jede fremde oder angelehnte Abbildung und Tabelle besitzt eine präzise Quellenangabe.
- Direkte Zitate sind unverändert, stehen in Anführungszeichen und besitzen eine genaue Fundstelle.
- Alle veränderlichen Onlinequellen besitzen ein Abrufdatum.
- Der Zitierstil wurde mit den Betreuer:innen abgestimmt und konsequent verwendet.
- Der vorgeschriebene Versicherungstext wurde nicht verändert und wird mit Ort, Datum und Unterschrift versehen.
- Ein Sperrvermerk oder eine Anonymisierung wurde mit allen Betreuer:innen abgestimmt.
- Umfangreiches Zusatzmaterial und Monatsberichte befinden sich im Anhang.
- Ausdruck, Duplexdruck, Papier und Klebebindung entsprechen der aktuellen Richtlinie.

## Auslegungsentscheidungen

Die Richtlinie ist an einzelnen Stellen widersprüchlich oder nicht vollständig:

- **Verzeichnisse:** §1.3.2 verlangt 1,5-zeiligen Abstand, während die Tabellen 6 bis 8 einzeiligen Abstand nennen.
  Die Vorlage verwendet 1,5-zeiligen Abstand.
- **Inhaltsverzeichnis:** §2.5 fordert alle Überschriften außer dem Titelblatt.
  Daher listet sich das Inhaltsverzeichnis selbst auf.
- **Sperrvermerk:** Die Richtlinie erlaubt ihn, gibt aber weder Wortlaut noch vollständige Layoutdetails vor.
  Die konkrete Verwendung muss mit den Betreuer:innen abgestimmt werden.

## Prüfen

```bash
python3 tests/pruefen.py
```

Benötigt werden `python3`, `typst` und `pdftotext` aus Poppler.
Das Skript prüft unter anderem Ränder, Zeilenabstand, Schriftgrade, Seitennummerierung, Kopfzeilen, Rechtsbeginn der Hauptkapitel, Trennblätter, Beschriftungen und das Abkürzungsverhalten.

Die Python-Prüfung selbst wird in der CI zusätzlich mit Ruff und Mypy geprüft:

```bash
python3 -m ruff check tests/pruefen.py
python3 -m ruff format --check tests/pruefen.py
python3 -m mypy --strict tests/pruefen.py
```

GitHub Actions führt diese Prüfungen bei Pushes und Pull Requests aus.
Tags nach dem Muster `v1.0.1` erzeugen zusätzlich ein GitHub Release mit der geprüften Beispiel-PDF.

## Quelltext-Stil

Dokumentation und Typst-Inhalte werden nicht auf eine feste Zeichenbreite umgebrochen.
Nach Möglichkeit steht jeder vollständige Satz in einer eigenen Quelltextzeile.
Lange Sätze werden nur an semantisch sinnvollen Stellen umgebrochen.
Code wird nach seiner Struktur und nicht nach einer festen Spaltenzahl formatiert.

## Hinweise

- Die vollständige HFU-Richtlinie wird nicht im Repository mitgeliefert.
  Die jeweils aktuelle Fassung ist direkt über die HFU zu beziehen.
- Das enthaltene HFU-Logo ist eine Marke der Hochschule.
  Vor einer Veröffentlichung als allgemeines Vorlagenpaket sind Nutzungs- und Weiterverteilungsrechte zu klären.
- Vorbild für Teile der Struktur ist die [SPI-Matse/HFU-LaTeX-Vorlage](https://github.com/SPI-Matse/HFU-LaTeX-Vorlage).

## Lizenz

Der selbst erstellte Quellcode steht unter der [MIT-Lizenz](LICENSE), Copyright © 2026 Tom Seelig.
Rechte an Namen, Marken, Logos und sonstigem Material Dritter werden dadurch nicht übertragen.
