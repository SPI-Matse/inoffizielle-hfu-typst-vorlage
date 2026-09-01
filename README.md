# Inoffizielle HFU-Typst-Vorlage für wissenschaftliche Arbeiten

Inoffizielle Typst-Vorlage für wissenschaftliche Arbeiten an der **Fakultät I
(Informatik) der Hochschule Furtwangen**. Sie basiert auf der *Richtlinie für
die Erstellung wissenschaftlicher Arbeiten*, Stand **Januar 2024**.

> [!IMPORTANT]
> **Diese Vorlage ist ein privates, inoffizielles Drittprojekt. Sie stammt nicht
> von der Hochschule Furtwangen, wurde von der HFU weder herausgegeben noch
> geprüft oder freigegeben und darf nicht als offizielle HFU-Vorlage verstanden
> werden.** Eine Gewähr für formale oder inhaltliche Richtigkeit wird nicht
> übernommen. Nutzende handeln eigenverantwortlich und müssen vor der Abgabe
> selbst prüfen, ob das erzeugte Dokument der aktuellen Richtlinie, der
> jeweiligen SPO und den Vorgaben ihrer Betreuer:innen entspricht. Die Nutzung
> erfolgt auf eigenes Risiko.

## Schnellstart

Voraussetzung ist [Typst](https://github.com/typst/typst#installation) `0.15.1`
oder neuer. Alternativ kann das Projekt vollständig in die
[Typst-Web-App](https://typst.app/) hochgeladen werden.

1. Über **[Use this template](https://github.com/SPI-Matse/inoffizielle-hfu-typst-vorlage/generate)**
   ein eigenes GitHub-Repository erstellen.
2. Das neue Repository klonen und die Vorschau starten:

   ```bash
   git clone https://github.com/DEIN-NAME/DEIN-REPOSITORY.git
   cd DEIN-REPOSITORY
   typst watch thesis.typ
   ```

3. Angaben und Wahlmöglichkeiten in `thesis.typ` anpassen.
4. Deutsche und englische Abstract-Datei ausfüllen.
5. Beispielkapitel ersetzen und Quellen in `literatur.bib` pflegen.

Nur zum Mitentwickeln an der Vorlage selbst wird dieses Repository direkt
geklont:

```bash
git clone https://github.com/SPI-Matse/inoffizielle-hfu-typst-vorlage.git
```

Versionierte Stände werden unter
[Releases](https://github.com/SPI-Matse/inoffizielle-hfu-typst-vorlage/releases)
bereitgestellt.

## Projektstruktur

```text
thesis.typ        Angaben, Wahlmöglichkeiten und Kapitel
inhalt/           Text der Arbeit
anhang/           Anhangsteile und Monatsberichte
bilder/           Abbildungen und Logo
code/             eingebundene Quelldateien
literatur.bib     Literaturdaten
hfu/              Layout der Vorlage
tests/pruefen.py  formale PDF-Prüfungen
```

Im Normalfall werden nur `thesis.typ`, `literatur.bib`, `inhalt/`, `bilder/`,
`code/` und `anhang/` bearbeitet.

## Wählbare Einstellungen

### Zitierstil

Am Anfang von `thesis.typ` wird zwischen IEEE und APA gewählt:

```typst
#let zitierstil = "ieee" // alternativ: "apa"
```

Die Fakultät empfiehlt beide Stile, verlangt aber die Abstimmung mit den
Betreuer:innen (§2.9.4). Typst `0.15.1` verwendet:

| Wert | Umsetzung |
|---|---|
| `"ieee"` | IEEE Reference Guide, Stand 29.11.2023; nummerische Verweise |
| `"apa"` | APA Style, 7. Auflage; Autor-Jahr-Verweise |

Weiterführend:

- [Typst: Bibliography Styles](https://typst.app/docs/reference/model/bibliography/#parameters-style)
- [APA Style: References](https://apastyle.apa.org/style-grammar-guidelines/references)
- [IEEE Reference Guide](https://ieeeauthorcenter.ieee.org/wp-content/uploads/IEEE-Reference-Guide.pdf)

Nur im Text zitierte Quellen erscheinen im Literaturverzeichnis. Bei
veränderlichen Onlinequellen ist ein Abrufdatum anzugeben; eine reine URL-Liste
genügt nicht.

### Schrift

Die Richtlinie schreibt **keine konkrete Schriftfamilie** vor. Gefordert sind
eine einheitliche Schrift und der Verzicht auf Zier- oder Schmuckschriften. Nur
Quellcode darf eine zweite Monospace-Schrift verwenden (§1.3).

Die Voreinstellung in `thesis.typ` lautet:

```typst
#let schrift = ("Arial", "Liberation Sans", "Nimbus Sans", "Helvetica")
#let schrift-mono = ("Liberation Mono", "DejaVu Sans Mono", "Consolas", "Menlo")
```

Typst probiert die Schriften in dieser Reihenfolge. Warnungen zu fehlenden
Fallback-Schriften sind unproblematisch, solange mindestens eine Schrift der
jeweiligen Kette installiert ist. Schriftdateien selbst werden nicht
mitgeliefert.

### Weitere Wahlmöglichkeiten

| Einstellung | Vorgabe beziehungsweise Spielraum |
|---|---|
| `blocksatz` | Blocksatz oder linksbündiger Flattersatz; Blocksatz empfohlen |
| `vorwort` | optional |
| `sperrvermerk` | optional und mit allen Betreuer:innen abzustimmen |
| `anhang` | optional; Monatsberichte der Thesis gehören hinein |
| `querformat` | nur für große Abbildungen oder Tabellen |
| `quellcodeverzeichnis` | nicht in der Richtlinie vorgesehen; standardmäßig aus |

Nicht frei wählbar sind unter anderem Seitenformat, Ränder, Bundsteg,
Schriftgrade, Kopfzeilenaufbau, Pflichtbestandteile, Rechtsbeginn der
Hauptkapitel und die vorgeschriebenen Trennblätter.

## Sperrvermerk

Der optionale Sperrvermerk steht unmittelbar nach dem Titelblatt und vor allen
weiteren Bestandteilen. Seine Seite besitzt weder Kopfzeile noch Seitenzahl und
erscheint nicht im Inhaltsverzeichnis. Anschließend folgt weiterhin das
vorgeschriebene leere Trennblatt.

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

Die Richtlinie erlaubt Sperrvermerke und Anonymisierung, gibt aber keinen
Wortlaut vor. Der verwendete Text muss daher vor der Abgabe bestätigt werden.

## Schreiben

Kapiteldateien importieren die öffentlichen Bausteine:

```typst
#import "../hfu/lib.typ": *

= Hauptkapitel
== Unterkapitel
=== Dritte Ebene
```

Das Inhaltsverzeichnis führt höchstens drei Ebenen. Hauptkapitel beginnen
automatisch auf einer rechten Seite.

### Abbildungen und Tabellen

```typst
#abbildung(
  image("/bilder/architektur.svg", width: 80%),
  caption: [Aufbau des Systems],
  quelle: [@mueller2021, S. 42],
) <abb-architektur>

#tabelle(
  columns: (auto, 1fr),
  [Kriterium], [Wert],
  [Durchsatz], [1,2 GB/s],
  caption: [Messergebnisse],
)
```

Beschriftungen sind verpflichtend und stehen unter dem Element. Quellen stehen
darunter, gehören aber nicht zum Verzeichniseintrag.

Abbildungs- und Tabellenverzeichnis werden nur erzeugt, wenn im Dokument
entsprechende Elemente vorkommen. Eine zusätzliche Referenz über `@label` ist
nicht erforderlich. Das optionale Quellcodeverzeichnis arbeitet nach
Aktivierung genauso.

### Quellcode und weitere Bausteine

```typst
#quellcode-datei(
  path("/code/beispiel.py"),
  lang: "python",
  caption: [Beispielprogramm],
)

#zitat(quelle: [@autor2021, S. 12])[Längeres direktes Zitat.]
#querformat[ ... breite Tabelle ... ]
#monatsbericht(path("/anhang/berichte/2026-01.pdf"), titel: "Januar")
```

`path(…)` löst Dateien im aufrufenden Projekt auf und ist damit auch für einen
späteren Paketimport geeignet.

## Automatisch umgesetzte Kernvorgaben

- DIN A4, beidseitiges Buchformat und Innen-/Außenränder einschließlich
  Bundsteg
- 12-pt-Fließtext, 1,5-zeiliger Abstand und definierte Überschriftengrößen
- Kapitelüberschrift innen und Seitenzahl außen in der Kopfzeile
- Titelblatt und leeres Trennblatt
- römische Nummerierung des Vorspanns, arabische Nummerierung des Inhalts
- Abstract auf Englisch und Deutsch
- dynamische Verzeichnisse und Abkürzungsverzeichnis
- Literaturverzeichnis mit eigenem Zeilenabstand
- deutsche und englische Versicherung
- eigener Nummerierungsbereich für jeden Anhangsteil

Nicht enthalten sind das optionale Stichwortverzeichnis und das separate
IEEE-Conference-Layout für Master-Seminararbeiten und -Berichte.

## Auslegungsentscheidungen

Die Richtlinie ist an einzelnen Stellen widersprüchlich oder nicht vollständig:

- **Verzeichnisse:** §1.3.2 verlangt 1,5-zeilig, die Tabellen 6–8 nennen
  1-zeilig. Standard ist 1,5-zeilig.
- **Inhaltsverzeichnis:** §2.5 fordert alle Überschriften außer dem Titelblatt.
  Daher listet sich das Inhaltsverzeichnis standardmäßig selbst.
- **Quellcodeverzeichnis:** nicht Bestandteil der festgelegten Struktur und
  deshalb standardmäßig deaktiviert.

Änderungen an diesen Punkten sollten mit den Betreuer:innen abgestimmt werden.

## Prüfen

```bash
python3 tests/pruefen.py
```

Benötigt werden `python3`, `typst` und `pdftotext` aus Poppler. Das Skript prüft
unter anderem Ränder, Zeilenabstand, Schriftgrade, Seitennummerierung,
Kopfzeilen, Rechtsbeginn der Hauptkapitel, Trennblätter und Beschriftungen.

## Hinweise

- Die vollständige HFU-Richtlinie wird nicht im Repository mitgeliefert. Die
  jeweils aktuelle Fassung ist direkt über die HFU zu beziehen.
- Das enthaltene HFU-Logo ist eine Marke der Hochschule. Vor einer
  Veröffentlichung als allgemeines Vorlagenpaket sind Nutzungs- und
  Weiterverteilungsrechte zu klären.
- Vorbild für Teile der Struktur ist die
  [SPI-Matse/HFU-LaTeX-Vorlage](https://github.com/SPI-Matse/HFU-LaTeX-Vorlage).

## Lizenz

Der selbst erstellte Quellcode steht unter der [MIT-Lizenz](LICENSE), Copyright
© 2026 Tom Seelig. Rechte an Namen, Marken, Logos und sonstigem Material Dritter
werden dadurch nicht übertragen.
