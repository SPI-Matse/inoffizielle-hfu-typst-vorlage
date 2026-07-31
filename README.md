# HFU-Typst-Vorlage für wissenschaftliche Arbeiten

Typst-Vorlage für Haus-, Projekt- und Abschlussarbeiten an der **Fakultät
Informatik der Hochschule Furtwangen**, umgesetzt nach der *Richtlinie für die
Erstellung wissenschaftlicher Arbeiten* (Fakultät I, Januar 2024).

Klonen, `typst watch thesis.typ` starten, schreiben. Ränder, Zeilenabstand,
Kopfzeilen, Nummerierung, Verzeichnisse, Versicherung und Anhang sind fertig
eingestellt.

> **Diese Vorlage ist nicht offiziell.** Sie wurde privat erstellt und kann
> Fehler enthalten. Die Verantwortung dafür, dass die Formalien der abgegebenen
> Arbeit stimmen, liegt bei deren Verfasser:in. Im Zweifel gilt die Richtlinie,
> nicht diese Vorlage.

## Voraussetzungen

| | | |
|---|---|---|
| **Typst** | zwingend | Entwickelt und geprüft mit **0.15.1**. Ältere Versionen ab 0.13 dürften funktionieren, sind aber nicht geprüft. |
| **Schriften** | zwingend | Arial *oder* Liberation Sans, plus eine Monospace-Schrift. Siehe unten. |
| **python3**, **pdftotext** | optional | Nur für `tests/pruefen.py`. `pdftotext` steckt im Paket `poppler-utils`. |

### Typst installieren

```bash
# Arch Linux
sudo pacman -S typst
# Debian / Ubuntu
sudo snap install typst
# macOS
brew install typst
# Windows
winget install --id Typst.Typst
```

Alternativ ohne Installation über [typst.app](https://typst.app) — dort das
gesamte Projektverzeichnis hochladen, damit die relativen Pfade stimmen.

### Schriften

Die Richtlinie verlangt eine einheitliche Schriftart ohne Zier- oder
Schmuckelemente (§1.3); die Richtlinie selbst ist in Arial gesetzt. Die Vorlage
verwendet deshalb diese Kette:

```
Arial → Liberation Sans → Nimbus Sans → Helvetica
```

Liberation Sans ist metrikkompatibel zu Arial — der Text bricht also identisch
um, egal welche der beiden greift. **Auf Windows und macOS ist Arial bereits
vorhanden, hier ist nichts zu tun.** Unter Linux:

```bash
sudo pacman -S ttf-liberation        # Arch
sudo apt install fonts-liberation    # Debian / Ubuntu
```

Für Quellcode: `Liberation Mono → DejaVu Sans Mono → Consolas → Menlo`. Mindestens
eine davon ist praktisch überall installiert.

Prüfen, was verfügbar ist:

```bash
typst fonts | grep -iE 'arial|liberation|nimbus sans|dejavu sans mono'
```

> **Warnungen wie `unknown font family: arial` sind normal.** Typst meldet jede
> Schrift der Fallback-Kette, die auf diesem System fehlt — unter Linux also
> Arial, unter Windows Liberation Sans. Solange *eine* Schrift der Kette
> vorhanden ist, ist das Ergebnis korrekt.

## Schnellstart

```bash
git clone <dieses-repo> meine-thesis && cd meine-thesis
typst watch thesis.typ          # Live-Vorschau, erzeugt thesis.pdf
```

Danach:

1. In `thesis.typ` die Angaben zur Arbeit eintragen — Titel, Studiengang,
   Referent:in, eigene Daten.
2. `inhalt/abstract-de.typ` und `inhalt/abstract-en.typ` schreiben.
3. Die Beispielkapitel in `inhalt/` durch eigene ersetzen und in `thesis.typ`
   einbinden.
4. Quellen in `literatur.bib` pflegen.

## Projektstruktur

```
thesis.typ           Angaben zur Arbeit + Einbinden der Kapitel  ← hier startest du
literatur.bib        Quellen im BibTeX-Format
inhalt/              Der Text der Arbeit, eine Datei je Kapitel
anhang/              Anhangsteile;  anhang/berichte/ für Monatsberichts-PDFs
bilder/              Abbildungen (SVG, PNG, JPG, PDF) und das HFU-Logo
code/                Quelldateien, die als Listing eingebunden werden
tests/pruefen.py     Misst das erzeugte PDF gegen die Richtlinie
hfu/                 Die Vorlage — im Normalfall unangetastet
```

Der Aufbau von `hfu/`:

| Datei | Aufgabe |
|---|---|
| `config.typ` | **Alle** Vorgaben der Richtlinie als Werte, mit Fundstelle. Nur hier wird etwas verstellt. |
| `layout.typ` | Dokumentgerüst: Seite, Schrift, Überschriften, Reihenfolge der Bestandteile |
| `kapitel.typ` | Kopfzeile, Trennblätter, Kapitelgerüst |
| `titelblatt.typ` | Titelblatt nach Tabelle 5 und Abbildung 4 |
| `verzeichnisse.typ` | Inhalts-, Abbildungs-, Tabellen-, Quellcode-, Abkürzungsverzeichnis |
| `versicherung.typ` | Versicherung über redliches wissenschaftliches Arbeiten (DE + EN) |
| `elemente.typ` | Bausteine für die Kapitel: `abbildung`, `tabelle`, `quellcode`, … |
| `lib.typ` | Öffentliche Schnittstelle — nur diese Datei wird importiert |

## Die Reihenfolge macht die Vorlage

Tabelle 3 der Richtlinie gibt die Bestandteile einer Arbeit und ihre Reihenfolge
fest vor. Statt sie selbst zusammenzustecken, übergibst du sie als benannte
Argumente; den Rest — Trennblätter, Wechsel der Seitennummerierung,
Kapitelbeginn auf der rechten Seite — erledigt die Vorlage:

```typst
#show: hfu-thesis.with(
  art: "Bachelorthesis",
  studiengang: "Allgemeine Informatik",
  titel: "Titel der Arbeit",
  untertitel: "Untertitel der Arbeit",     // none, wenn es keinen gibt
  referent: "Prof. Dr. Vorname Nachname",
  korreferent: "Prof. Dr. Vorname Nachname",
  ersetztes-modul: none,                   // nur bei Projekt- und Studienarbeiten
  vorgelegt-am: datetime(year: 2026, month: 8, day: 15),
  autor: (
    name: "Vorname Nachname",
    matrikelnummer: "123456",
    strasse: "Musterstraße 1",
    ort: "78120 Furtwangen",
    email: "vorname.nachname@hs-furtwangen.de",
  ),

  vorwort: none,                           // optional (§2.3)
  abstract-en: include "inhalt/abstract-en.typ",
  abstract-de: include "inhalt/abstract-de.typ",
  abkuerzungen: (
    ("HFU", "Hochschule Furtwangen University"),
  ),
  quellen: bibliography("literatur.bib", style: "ieee", title: none),
  anhang: (
    ("Monatsberichte", include "anhang/a-monatsberichte.typ"),
  ),
)

#include "inhalt/01-einleitung.typ"        // ab hier nur noch der Inhalt
```

Fehlt eine Pflichtangabe, bricht die Vorlage mit einer Meldung ab, die die
Fundstelle in der Richtlinie nennt.

## Schreiben

Jede Kapiteldatei beginnt mit dem Import der Bausteine:

```typst
#import "../hfu/lib.typ": *
```

### Überschriften und Text

```typst
= Hauptkapitel        // Ebene 1, beginnt automatisch auf der rechten Seite
== Unterkapitel       // Ebene 2
=== Unterkapitel      // Ebene 3, tiefer geht das Inhaltsverzeichnis nicht (Tabelle 6)
```

Absätze werden durch eine Leerzeile getrennt und bekommen automatisch den
Absatzabstand nach §1.2.6.

### Abbildungen

```typst
#abbildung(
  image("/bilder/architektur.svg", width: 80%),
  caption: [Aufbau des Systems],       // steht im Abbildungsverzeichnis
  quelle: [@mueller2021, S. 42],       // steht darunter, aber NICHT im Verzeichnis
) <abb-architektur>
```

Die Trennung ist Absicht: §2.6 verlangt die Quellenangabe unter der Beschriftung,
§3.7 stellt klar, dass sie nicht zum Abbildungstitel gehört. Verweise im Text
über `@abb-architektur`.

### Tabellen

```typst
#tabelle(
  columns: (auto, 1fr),
  [Kriterium], [Wert],
  [Durchsatz], [1,2 GB/s],
  caption: [Messergebnisse],
  quelle: none,
)
```

Der Tabelleninhalt wird automatisch auf 10 pt gesetzt (Tabelle 2).

### Quellcode

Kurze Listings direkt im Text:

```typst
#quellcode(
  ```python
  def hallo():
      print("Hallo")
  ```,
  caption: [Minimalbeispiel],
)
```

Längerer Code gehört nach `code/` und wird von dort eingebunden — so bleibt er
ausführbar und lintbar:

```typst
#quellcode-datei("/code/beispiel.py", lang: "python", caption: [Beispielprogramm])
```

Pfade beginnen mit `/` und beziehen sich damit auf die Projektwurzel. Sie
funktionieren dadurch aus jedem Unterordner gleich.

### Weitere Bausteine

```typst
#zitat(quelle: [@autor2021, S. 12])[Wörtliches Zitat über mehrere Zeilen (§3.6).]
#querformat[ ... sehr breite Tabelle ... ]
#monatsbericht("/anhang/berichte/2026-01.pdf", titel: "Monatsbericht Januar")
```

### Zitieren

```typst
Wie @knuth1984 zeigt, ...        // Verweis im Text
... mehrere Quellen @a2020 @b2021.
```

Zitierstil in `thesis.typ` umstellen: `style: "ieee"` oder `style: "apa"` — beide
werden von der Fakultät empfohlen (§2.9.4) und sind in Typst eingebaut. Der Stil
ist mit den Betreuer:innen abzusprechen.

## Konfiguration

Alles Einstellbare steht in **`hfu/config.typ`**, jeder Wert mit Verweis auf die
Fundstelle in der Richtlinie. Die üblichen Verdächtigen:

| Wert | Standard | Wirkung |
|---|---|---|
| `bundsteg` | `1.5cm` | Zusatzrand für die Klebebindung. Auf `0cm` setzen, wenn nicht gebunden abgegeben wird. |
| `blocksatz` | `true` | `false` ergibt linksbündigen Flattersatz — beides ist nach §1.3.2 zulässig. |
| `figur-ausrichtung` | `left` | Ausrichtung von Abbildungen, Tabellen und Beschriftungen. `center` für zentriert. |
| `verzeichnis-zeile` | `zeile` | Zeilenabstand der Verzeichnisse, siehe unten. |
| `quellcodeverzeichnis` | `true` | Quellcodeverzeichnis erzeugen, sofern Listings vorhanden sind. |
| `inhaltsverzeichnis-listet-sich-selbst` | `true` | Ob „Inhaltsverzeichnis“ als eigener Eintrag erscheint. |
| `logo` | `"/bilder/hfu-logo.svg"` | `none` lässt das Logo auf dem Titelblatt weg. |

## Prüfen

Die Richtlinie stellt in §1 fest, dass Abweichungen im Bachelorstudium unzulässig
sind. Damit „richtlinienkonform“ nicht nur eine Behauptung ist, misst
`tests/pruefen.py` das **fertige PDF** nach:

```bash
python3 tests/pruefen.py
```

Geprüft werden unter anderem Seitenränder und ihre Spiegelung, der
Grundlinienabstand, die Schriftgrade, der Wechsel von römischer auf arabische
Nummerierung, Position von Seitenzahl und Kapitelüberschrift in der Kopfzeile,
der Kapitelbeginn auf rechten Seiten, die Trennblätter und das Muster der
Beschriftungen.

Wer `config.typ` ändert, sollte das Skript danach laufen lassen — es liest die
Randmaße von dort und prüft gegen die eigene Konfiguration.

## Auslegungsentscheidungen

An drei Stellen ist die Richtlinie nicht eindeutig. Die Vorlage entscheidet so:

**Zeilenabstand der Verzeichnisse.** §1.3.2 schreibt 1,5-zeilig vor, die Tabellen
6, 7 und 8 schreiben 1-zeilig vor. Nachgemessen im Referenz-PDF der Fakultät:
dessen eigene Verzeichnisse laufen mit 20,7 pt, also 1,5-zeilig. Dieser Messung
folgt die Vorlage. Umschaltbar über `verzeichnis-zeile`.

**Bundsteg.** Tabelle 1 nennt 1,5 cm; das Referenz-PDF der Fakultät ist dagegen
symmetrisch mit 2,5 cm gesetzt. Die Vorlage folgt der Tabelle und schlägt den
Bundsteg auf den Innenrand auf (innen 4 cm, außen 2,5 cm). Über `bundsteg`
abschaltbar.

**Selbsteintrag des Inhaltsverzeichnisses.** §2.5 verlangt „alle Überschriften …
jedoch nicht das Titelblatt“ — wörtlich gelesen also auch das Inhaltsverzeichnis
selbst. Die Vorlage liest wörtlich; über
`inhaltsverzeichnis-listet-sich-selbst` abschaltbar.

Nicht enthalten sind das optionale Stichwortverzeichnis (Tabelle 3) und die
IEEE-Conference-Vorlage für Seminararbeiten in Masterstudiengängen (§1) — die ist
ein eigenes Layout.

## Hinweise

**Leere Füllseiten tragen Kopfzeile und Seitenzahl.** Hauptkapitel beginnen laut
§1.2.3 immer rechts; die dabei entstehende Füllseite bleibt inhaltlich leer, führt
aber Kopfzeile und Seitenzahl weiter — genauso wie ein Abschnittswechsel
„Ungerade Seite“ in Word. Die nach §2.2, §2.11 und §2.13 vorgeschriebenen
Trennblätter sind davon unberührt und vollständig leer.

**Das HFU-Logo** liegt als Vektorgrafik unter `bilder/hfu-logo.svg` bei. Es ist
eine Marke der Hochschule Furtwangen und darf nur im Rahmen von HFU-Arbeiten
verwendet werden.

## Quellen

- *Richtlinie für die Erstellung wissenschaftlicher Arbeiten*, Fakultät
  Informatik der Hochschule Furtwangen, Januar 2024 — im Repo unter
  `Richtlinie_fur_die_Erstellung_wissenschaftlicher_Arbeiten_01.2024-2-1.pdf`
- [SPI-Matse/HFU-LaTeX-Vorlage](https://github.com/SPI-Matse/HFU-LaTeX-Vorlage) —
  Vorbild für Ordnerstruktur, Quellcodeverzeichnis und die Zusatzfelder des
  Titelblatts; von dort stammt auch die Vektorfassung des Logos.
