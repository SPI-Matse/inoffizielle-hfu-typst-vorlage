// Öffentliche Schnittstelle der Vorlage.
//
// In thesis.typ und in den Kapiteldateien wird ausschließlich diese Datei
// importiert:
//
//   #import "hfu/lib.typ": *        (in thesis.typ)
//   #import "../hfu/lib.typ": *     (in inhalt/… und anhang/…)
//
// Dadurch lässt sich der Aufbau von hfu/ ändern, ohne dass ein einziges
// Kapitel angefasst werden muss.

// Dokumentgerüst — wird in thesis.typ als Show-Rule angewendet.
#import "layout.typ": hfu-thesis

// Bausteine für die Kapiteldateien.
#import "elemente.typ": abbildung, abk, abkuerzung, monatsbericht, quellcode
#import "elemente.typ": quellcode-datei, querformat, tabelle, zitat
