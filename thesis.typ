// ═══════════════════════════════════════════════════════════════════════════
//  Wissenschaftliche Arbeit an der Fakultät Informatik der HFU
//
//  Hier werden nur die Angaben zur Arbeit gepflegt und die Kapitel eingebunden.
//  Das Layout steckt in hfu/ und muss nicht angefasst werden.
//
//  Kompilieren:   typst compile thesis.typ
//  Live-Vorschau: typst watch thesis.typ
// ═══════════════════════════════════════════════════════════════════════════

#import "hfu/lib.typ": *

#show: hfu-thesis.with(
  // ── Titelblatt (Richtlinie Tabelle 5, Abbildung 4) ────────────────────────
  art: "Bachelorthesis",
  studiengang: "Allgemeine Informatik",
  titel: "Titel der Arbeit",
  untertitel: "Untertitel der Arbeit", // none, wenn es keinen gibt
  referent: "Prof. Dr. Vorname Nachname",
  korreferent: "Prof. Dr. Vorname Nachname",
  ersetztes-modul: none, // nur bei Projekt- und Studienarbeiten
  vorgelegt-am: datetime(year: 2026, month: 8, day: 15),
  autor: (
    name: "Vorname Nachname",
    matrikelnummer: "123456",
    strasse: "Musterstraße 1",
    ort: "78120 Furtwangen",
    email: "vorname.nachname@hs-furtwangen.de",
  ),

  // ── Vorspann (Richtlinie Tabelle 3) ───────────────────────────────────────
  // Das Vorwort ist optional (§2.3). Zum Verwenden auskommentieren:
  // vorwort: include "inhalt/vorwort.typ",
  vorwort: none,

  // Der Abstract ist in beiden Sprachen verpflichtend (§2.4).
  abstract-en: include "inhalt/abstract-en.typ",
  abstract-de: include "inhalt/abstract-de.typ",

  // §2.8: Abkürzung und Erklärung. Die Sortierung übernimmt die Vorlage.
  abkuerzungen: (
    ("APA", "American Psychological Association"),
    ("HFU", "Hochschule Furtwangen University"),
    ("IEEE", "Institute of Electrical and Electronics Engineers"),
    ("SPO", "Studien- und Prüfungsordnung"),
  ),

  // ── Literaturverzeichnis ──────────────────────────────────────────────────
  // §2.9.4: Die Fakultät empfiehlt "ieee" oder "apa". Der Stil ist mit den
  // Betreuer:innen abzusprechen.
  quellen: bibliography("literatur.bib", style: "ieee", title: none),

  // ── Anhang (§2.13, optional) ──────────────────────────────────────────────
  // Je Eintrag ein Anhangsteil; die Buchstaben A, B, C … vergibt die Vorlage.
  anhang: (
    ("Monatsberichte", include "anhang/a-monatsberichte.typ"),
    ("Quellcode des Beispielprogramms", include "anhang/b-quellcode.typ"),
  ),
)

// ═══════════════════════════════════════════════════════════════════════════
//  Ab hier folgt der inhaltliche Teil der Arbeit (§2.10).
//  Alles andere — Titelblatt, Verzeichnisse, Versicherung, Anhang — setzt die
//  Vorlage in der von Tabelle 3 vorgeschriebenen Reihenfolge selbst.
// ═══════════════════════════════════════════════════════════════════════════

#include "inhalt/01-einleitung.typ"
#include "inhalt/02-grundlagen.typ"
#include "inhalt/03-fazit.typ"
