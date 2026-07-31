#!/usr/bin/env python3
"""Prüft das erzeugte PDF gegen die Vorgaben der Richtlinie.

Die Richtlinie stellt in §1 fest, dass Abweichungen im Bachelorstudium
unzulässig sind. Dieses Skript misst deshalb im fertigen PDF nach, statt sich
auf den Quelltext zu verlassen.

Aufruf aus dem Projektverzeichnis:

    python3 tests/pruefen.py

Benötigt `typst` und `pdftotext` (Paket poppler-utils) im PATH.
"""

from __future__ import annotations

import re
import subprocess
import sys
from collections import Counter
from pathlib import Path

WURZEL = Path(__file__).resolve().parent.parent
QUELLE = WURZEL / "thesis.typ"
PDF = WURZEL / "thesis.pdf"
CONFIG = WURZEL / "hfu" / "config.typ"

PT_JE_CM = 72 / 2.54
A4_BREITE, A4_HOEHE = 595.276, 841.89
TOLERANZ = 1.0  # pt

# Worthöhe geteilt durch Schriftgrad — aus der Schriftmetrik, empirisch stabil.
HOEHE_JE_PUNKT = 0.938


class Pruefung:
    def __init__(self) -> None:
        self.fehler: list[str] = []
        self.geprueft = 0

    def pruefe(self, bedingung: bool, beschreibung: str, detail: str = "") -> None:
        self.geprueft += 1
        if bedingung:
            print(f"  \033[32mok\033[0m   {beschreibung}")
        else:
            meldung = f"{beschreibung}{': ' + detail if detail else ''}"
            print(f"  \033[31mFEHL\033[0m {meldung}")
            self.fehler.append(meldung)


def cm(wert: float) -> float:
    return wert * PT_JE_CM


def lies_config() -> dict[str, float]:
    """Liest die Randmaße aus config.typ, damit der Test der Konfiguration folgt."""
    text = CONFIG.read_text(encoding="utf-8")
    werte = {}
    for name in ("rand-oben", "rand-unten", "rand-innen", "rand-aussen", "bundsteg"):
        treffer = re.search(rf"^#let {re.escape(name)} = ([\d.]+)cm", text, re.M)
        if not treffer:
            sys.exit(f"config.typ: '{name}' nicht gefunden")
        werte[name] = cm(float(treffer.group(1)))
    return werte


class Wort:
    __slots__ = ("x0", "y0", "x1", "y1", "text")

    def __init__(self, x0, y0, x1, y1, text):
        self.x0, self.y0, self.x1, self.y1, self.text = x0, y0, x1, y1, text

    @property
    def hoehe(self) -> float:
        return self.y1 - self.y0


def lies_pdf() -> list[list[Wort]]:
    roh = subprocess.run(
        ["pdftotext", "-bbox", str(PDF), "-"],
        capture_output=True, text=True, check=True,
    ).stdout
    seiten = []
    for block in roh.split("<page ")[1:]:
        seiten.append([
            Wort(float(a), float(b), float(c), float(d), e)
            for a, b, c, d, e in re.findall(
                r'xMin="([\d.]+)" yMin="([\d.]+)" xMax="([\d.]+)" yMax="([\d.]+)">([^<]*)',
                block,
            )
        ])
    return seiten


def kopfzeile(seite: list[Wort]) -> list[Wort]:
    return [w for w in seite if w.y0 < 70]


def rumpf(seite: list[Wort]) -> list[Wort]:
    return [w for w in seite if w.y0 >= 70]


ROEMISCH = re.compile(r"^[IVXLC]+$")
ARABISCH = re.compile(r"^\d+$")
ANHANG = re.compile(r"^[A-Z]-\d+$")


def ist_seitenzahl(text: str) -> bool:
    return bool(ROEMISCH.match(text) or ARABISCH.match(text) or ANHANG.match(text))


def aeusseres_wort(seite: list[Wort], nr: int) -> Wort | None:
    """Das Wort am äußeren Rand — dort steht laut §1.2.5 die Seitenzahl.

    Sie lässt sich nicht am Muster erkennen: In einer Kopfzeile wie
    „1 Einleitung … 1“ sähe die führende Kapitelnummer genauso aus.
    """
    kopf = kopfzeile(seite)
    if not kopf:
        return None
    return max(kopf, key=lambda w: w.x1) if nr % 2 else min(kopf, key=lambda w: w.x0)


def seitenzahl(seite: list[Wort], nr: int) -> str | None:
    wort = aeusseres_wort(seite, nr)
    return wort.text if wort is not None and ist_seitenzahl(wort.text) else None


def main() -> int:
    p = Pruefung()

    print("\n\033[1mKompilieren\033[0m")
    lauf = subprocess.run(
        ["typst", "compile", str(QUELLE)], capture_output=True, text=True, cwd=WURZEL
    )
    p.pruefe(lauf.returncode == 0, "typst compile thesis.typ", lauf.stderr.strip()[:400])
    if lauf.returncode != 0:
        return 1

    cfg = lies_config()
    seiten = lies_pdf()
    innen = cfg["rand-innen"] + cfg["bundsteg"]
    aussen = cfg["rand-aussen"]

    # ── Seitenränder (Tabelle 1) ─────────────────────────────────────────────
    print("\n\033[1mSeitenränder (Tabelle 1)\033[0m")
    abweichungen = []
    for nr, seite in enumerate(seiten, start=1):
        woerter = rumpf(seite) + kopfzeile(seite)
        # Wörter mit Trennstrich stehen typografisch korrekt minimal über den
        # Rand hinaus; ihre Bounding-Box würde die Messung verfälschen.
        woerter = [w for w in woerter if not w.text.endswith(("-", "­"))]
        if not woerter or nr == 1:
            continue
        links, rechts = min(w.x0 for w in woerter), max(w.x1 for w in woerter)
        soll_links = innen if nr % 2 else aussen
        soll_rechts = A4_BREITE - (aussen if nr % 2 else innen)
        # Rechts großzügiger: pdftotext leitet die Wortbreite aus der
        # Schriftmetrik ab und meldet für Wörter, die auf Satzzeichen enden,
        # bis zu 3 pt mehr, als tatsächlich gesetzt wurde.
        if abs(links - soll_links) > TOLERANZ or abs(rechts - soll_rechts) > 3.5:
            abweichungen.append(
                f"S.{nr}: links {links:.1f} (soll {soll_links:.1f}), "
                f"rechts {rechts:.1f} (soll {soll_rechts:.1f})"
            )
    p.pruefe(
        not abweichungen,
        f"innen {innen / PT_JE_CM:.1f} cm / außen {aussen / PT_JE_CM:.1f} cm, gespiegelt",
        "; ".join(abweichungen[:3]),
    )

    inhaltsseiten = [s for s in seiten[1:] if rumpf(s)]
    oben = min(min(w.y0 for w in rumpf(s)) for s in inhaltsseiten)
    unten = max(max(w.y1 for w in rumpf(s)) for s in inhaltsseiten)
    p.pruefe(
        abs(oben - cfg["rand-oben"]) < 2,
        f"oben {cfg['rand-oben'] / PT_JE_CM:.0f} cm",
        f"Text beginnt bei {oben:.1f} pt statt {cfg['rand-oben']:.1f} pt",
    )
    p.pruefe(
        unten <= A4_HOEHE - cfg["rand-unten"] + 2,
        f"unten {cfg['rand-unten'] / PT_JE_CM:.0f} cm",
        f"Text reicht bis {unten:.1f} pt",
    )

    # ── Zeilenabstand (§1.3.2) ───────────────────────────────────────────────
    print("\n\033[1mZeilenabstand (§1.3.2)\033[0m")
    text = CONFIG.read_text(encoding="utf-8")
    zeile_em = float(re.search(r"^#let zeile = ([\d.]+)em", text, re.M).group(1))
    grad = float(re.search(r"^\s*text: (\d+)pt", text, re.M).group(1))
    soll = zeile_em * grad

    grundlinien = Counter()
    for seite in inhaltsseiten:
        ys = sorted({round(w.y0, 1) for w in rumpf(seite)})
        grundlinien.update(round(b - a, 1) for a, b in zip(ys, ys[1:]))
    haeufigster = grundlinien.most_common(1)[0][0]
    p.pruefe(
        abs(haeufigster - soll) < 0.3,
        f"Grundlinienabstand {soll:.1f} pt (1,5-zeilig)",
        f"gemessen {haeufigster} pt",
    )

    # ── Schriftgrade (Tabelle 2) ─────────────────────────────────────────────
    print("\n\033[1mSchriftgrade (Tabelle 2)\033[0m")
    hoehen = Counter(round(w.hoehe, 1) for s in inhaltsseiten for w in rumpf(s))
    haeufigste_hoehe = hoehen.most_common(1)[0][0]
    p.pruefe(
        abs(haeufigste_hoehe - grad * HOEHE_JE_PUNKT) < 0.4,
        f"Fließtext {grad} pt",
        f"häufigste Worthöhe {haeufigste_hoehe} pt",
    )

    h1 = float(re.search(r"^\s*h1: (\d+)pt", text, re.M).group(1))
    ueberschriften = [
        max(w.hoehe for w in rumpf(s)[:3])
        for s in inhaltsseiten
        if rumpf(s) and max(w.hoehe for w in rumpf(s)) > grad * HOEHE_JE_PUNKT + 0.5
    ]
    p.pruefe(
        bool(ueberschriften)
        and abs(max(ueberschriften) - h1 * HOEHE_JE_PUNKT) < 0.4,
        f"Hauptkapitelüberschrift {h1:.0f} pt",
        f"gemessen {max(ueberschriften, default=0):.1f} pt",
    )

    # ── Nummerierung (Tabelle 4) ─────────────────────────────────────────────
    print("\n\033[1mSeitennummerierung (Tabelle 4)\033[0m")
    p.pruefe(not kopfzeile(seiten[0]), "Titelseite ohne Kopfzeile und Seitenzahl")
    p.pruefe(not seiten[1], "Leeres Trennblatt nach dem Titelblatt (§2.2)")

    zahlen = [seitenzahl(s, nr) for nr, s in enumerate(seiten, start=1)]
    roemisch = [z for z in zahlen if z and ROEMISCH.match(z)]
    p.pruefe(
        roemisch[:3] == ["I", "II", "III"],
        "Vorspann römisch, fortlaufend ab I",
        f"gefunden {roemisch[:5]}",
    )

    erste_arabisch = next(
        (i for i, z in enumerate(zahlen) if z and ARABISCH.match(z)), None
    )
    p.pruefe(
        erste_arabisch is not None and zahlen[erste_arabisch] == "1",
        "Inhaltlicher Teil arabisch ab 1",
    )
    p.pruefe(
        erste_arabisch is not None and (erste_arabisch + 1) % 2 == 1,
        "Inhaltlicher Teil beginnt auf einer rechten Seite (§1.2.3)",
    )

    anhang = [z for z in zahlen if z and ANHANG.match(z)]
    p.pruefe(
        not anhang or anhang[0] == "A-1",
        "Anhang nach dem Muster [Buchstabe]-[Zahl] (§2.13)",
        f"gefunden {anhang[:4]}",
    )

    # ── Kopfzeile (§1.2.5) ───────────────────────────────────────────────────
    print("\n\033[1mKopfzeile (§1.2.5)\033[0m")
    falsche_zahl, falsches_kapitel = [], []
    for nr, seite in enumerate(seiten, start=1):
        kopf = kopfzeile(seite)
        if len(kopf) < 2:
            continue
        aussen_wort = aeusseres_wort(seite, nr)
        kapitel = [w for w in kopf if w is not aussen_wort]

        # Ungerade Seiten liegen rechts; ihr äußerer Rand ist der rechte.
        if nr % 2:
            zahl_aussen = abs(aussen_wort.x1 - (A4_BREITE - aussen)) < 3.5
            kapitel_innen = abs(min(w.x0 for w in kapitel) - innen) < TOLERANZ
        else:
            zahl_aussen = abs(aussen_wort.x0 - aussen) < TOLERANZ
            kapitel_innen = abs(max(w.x1 for w in kapitel) - (A4_BREITE - innen)) < 3.5

        if not (zahl_aussen and ist_seitenzahl(aussen_wort.text)):
            falsche_zahl.append(str(nr))
        if not kapitel_innen:
            falsches_kapitel.append(str(nr))

    p.pruefe(
        not falsche_zahl,
        "Seitenzahl steht außen",
        f"falsch auf Seite {', '.join(falsche_zahl[:5])}",
    )
    p.pruefe(
        not falsches_kapitel,
        "Kapitelüberschrift steht innen",
        f"falsch auf Seite {', '.join(falsches_kapitel[:5])}",
    )

    # ── Hauptkapitel und Trennblätter ────────────────────────────────────────
    print("\n\033[1mDokumentstruktur (Tabelle 3)\033[0m")
    # Eine Kapitelanfangsseite trägt die Kapitelnummer im Schriftgrad der
    # Hauptkapitelüberschrift. Im Inhaltsverzeichnis steht dieselbe Nummer in
    # Fließtextgröße und zählt deshalb nicht mit.
    kapitelseiten = [
        nr
        for nr, s in enumerate(seiten, start=1)
        if any(
            re.match(r"^\d+\.$", w.text) and w.hoehe > grad * HOEHE_JE_PUNKT + 0.5
            for w in rumpf(s)
        )
    ]
    p.pruefe(
        all(nr % 2 == 1 for nr in kapitelseiten),
        "Jedes Hauptkapitel beginnt auf einer rechten Seite (§1.2.3)",
        f"gerade Seiten: {[n for n in kapitelseiten if n % 2 == 0]}",
    )

    volltext = subprocess.run(
        ["pdftotext", str(PDF), "-"], capture_output=True, text=True, check=True
    ).stdout
    for ueberschrift, fundstelle in [
        ("Inhaltsverzeichnis", "§2.5"),
        ("Abkürzungsverzeichnis", "§2.8"),
        ("Literaturverzeichnis", "§2.9.5"),
        ("Versicherung über redliches wissenschaftliches Arbeiten", "§2.11"),
        ("Declaration on honest academic work", "§2.11"),
    ]:
        p.pruefe(ueberschrift in volltext, f"Bestandteil „{ueberschrift}“ ({fundstelle})")

    trennblaetter = [nr for nr, s in enumerate(seiten, start=1) if not s]
    p.pruefe(
        len(trennblaetter) >= 3,
        "Trennblätter nach Titelblatt, vor Versicherung und vor Anhang",
        f"nur {len(trennblaetter)} leere Seiten gefunden: {trennblaetter}",
    )

    # ── Beschriftungen (§2.6, §2.7) ──────────────────────────────────────────
    print("\n\033[1mBeschriftungen (§2.6, §2.7)\033[0m")
    for muster, was in [
        (r"Abbildung \d+: ", "Abbildung [Nummer]: [Titel]"),
        (r"Tabelle \d+: ", "Tabelle [Nummer]: [Titel]"),
    ]:
        p.pruefe(bool(re.search(muster, volltext)), f"Muster „{was}“")

    print()
    if p.fehler:
        print(f"\033[31m{len(p.fehler)} von {p.geprueft} Prüfungen fehlgeschlagen.\033[0m\n")
        return 1
    print(f"\033[32mAlle {p.geprueft} Prüfungen bestanden.\033[0m\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
