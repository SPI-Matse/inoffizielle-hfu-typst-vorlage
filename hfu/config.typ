// Alle Vorgaben der "Richtlinie für die Erstellung wissenschaftlicher Arbeiten"
// (Fakultät Informatik, Hochschule Furtwangen, Januar 2024) an einer Stelle.
//
// Diese Datei enthält ausschließlich Werte, keine Logik. Wer eine Vorgabe
// nachschlagen oder ändern will, muss nur hierher schauen. Die Kommentare
// nennen jeweils die Fundstelle in der Richtlinie.

// ── Schriftarten ────────────────────────────────────────────────────────────
// §1.3: eine einheitliche Schriftart, keine Zier- oder Schmuckschrift.
// Die Richtlinie selbst ist in Arial gesetzt. Liberation Sans ist metrik-
// kompatibel zu Arial, deshalb bricht der Text auf jeder Plattform gleich um.
#let schrift = ("Arial", "Liberation Sans", "Nimbus Sans", "Helvetica")

// §1.3: für Quellcode ist eine zweite, nicht-proportionale Schrift zulässig.
#let schrift-mono = ("Liberation Mono", "DejaVu Sans Mono", "Consolas", "Menlo")

// ── Seitenränder ────────────────────────────────────────────────────────────
// Tabelle 1. Der Bundsteg wird auf den inneren Rand aufgeschlagen.
// Auf 0cm setzen, wenn die Arbeit nicht klebegebunden abgegeben wird — dann
// entspricht der Textspiegel dem Referenz-PDF der Fakultät (2,5 cm symmetrisch).
#let rand-oben = 3cm
#let rand-unten = 2cm
#let rand-innen = 2.5cm
#let rand-aussen = 2.5cm
#let bundsteg = 1.5cm

// ── Schriftgrößen ───────────────────────────────────────────────────────────
// Tabelle 2. Die Namen entsprechen den Zeilen der Tabelle.
#let groesse = (
  art: 18pt, // Art der Arbeit
  titel: 22pt, // Titel (fett)
  untertitel: 18pt, // Untertitel
  titelblatt: 12pt, // Referent:in, Korreferent:in, Vorgelegt am / von
  h1: 14pt, // Hauptkapitelüberschrift (Ebene 1, fett)
  h2: 12pt, // Unterkapitelüberschrift (Ebene 2, fett)
  h3: 12pt, // Unterkapitelüberschrift (Ebene 3, normal)
  text: 12pt, // Fließtext, Quellenverweis
  kopfzeile: 12pt, // Kopfzeile (fett)
  beschriftung: 12pt, // Beschriftung von Tabelle oder Abbildung
  fussnote: 10pt, // Fußnote
  tabelle: 10pt, // Tabelleninhalt
  quellcode: 10pt, // nicht in der Richtlinie geregelt; wie Tabelleninhalt
)

// ── Zeilenabstand ───────────────────────────────────────────────────────────
// §1.3.2: Fließtext und Verzeichnisse 1,5-zeilig.
//
// "1,5-zeilig" ist eine Word-Angabe. Im Referenz-PDF der Fakultät gemessen
// entspricht sie 20,7 pt Grundlinienabstand bei 12 pt Schrift, also 1,725 em.
//
// layout.typ fixiert die Zeilenbox über top-edge/bottom-edge auf exakt 1 em.
// Dadurch gilt schriftunabhängig:  Grundlinienabstand = 1 em + leading.
#let zeile = 1.725em // 1,5-zeilig  = 20,7 pt bei 12 pt
#let zeile-einfach = 1.15em // 1-zeilig    = 13,8 pt bei 12 pt

// §1.2.6: Absätze werden durch Abstand getrennt, nicht durch Einzug.
// Eine halbe Leerzeile zusätzlich, wie in der LaTeX-Vorlage (parskip=half).
#let absatzabstand = zeile - 1em + 0.5 * zeile

// §1.3.2 vs. Tabellen 6/7/8: Die Richtlinie widerspricht sich beim
// Zeilenabstand der Verzeichnisse — §1.3.2 sagt 1,5-zeilig, die Tabellen sagen
// 1-zeilig. Das Referenz-PDF der Fakultät setzt seine Verzeichnisse mit
// 20,7 pt, also 1,5-zeilig. Dieser Messung folgt die Vorlage.
// Auf `zeile-einfach` setzen, wenn die Tabellen 6/7/8 gelten sollen.
#let verzeichnis-zeile = zeile

// ── Satz ────────────────────────────────────────────────────────────────────
// §1.3.2: linksbündiger Flattersatz oder Blocksatz zulässig, Blocksatz
// empfohlen. Auf false setzen für Flattersatz.
#let blocksatz = true

// Ausrichtung von Abbildungen, Tabellen und ihren Beschriftungen.
// Das Referenz-PDF der Fakultät setzt beides linksbündig.
#let figur-ausrichtung = left

// ── Verzeichnisse ───────────────────────────────────────────────────────────
// Tabelle 6: maximal drei Gliederungsebenen (z. B. 1.1.2).
#let verzeichnis-tiefe = 3

// §2.5: "alle Überschriften ... jedoch nicht das Titelblatt" — wörtlich gelesen
// listet das Inhaltsverzeichnis also auch sich selbst auf.
#let inhaltsverzeichnis-listet-sich-selbst = true

// Ein Quellcodeverzeichnis steht nicht in Tabelle 3 der Richtlinie. Es folgt
// der Logik von Abbildungs- und Tabellenverzeichnis ("verpflichtend, sofern
// vorhanden") und erscheint nur, wenn Listings existieren.
#let quellcodeverzeichnis = true

// ── Titelblatt ──────────────────────────────────────────────────────────────
// Abbildung 4 zeigt das HFU-Logo oben rechts. Auf `none` setzen, um es
// wegzulassen.
#let logo = "/bilder/hfu-logo.svg"
#let logo-hoehe = 2cm
