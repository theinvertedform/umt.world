#!/usr/bin/env python
"""
Extract typographic calibration metrics for umt.world font stacks.
Run from repo root:  python font_metrics.py
Deps: dev-python/fonttools

Maps each $font-stacks role to its concrete regular-weight file,
extracts vertical metrics, and derives Utopia base values calibrated
to the body face (serif-text / FCaslon Twelve).
"""

from pathlib import Path
from fontTools.ttLib import TTFont
from fontTools.pens.boundsPen import BoundsPen

ROOT = Path("assets/fonts")

# role -> the file that actually renders at that role's default weight
ROLES = {
    "logotype":      ROOT / "chandler-42" / "Chandler_42 W05 Regular.ttf",
    "display":       ROOT / "LTC Remington Typewriter" / "LTCRemingtonTypewriterPro.otf",
    "serif-text":    ROOT / "FCaslon" / "FCaslonTwelveITCStd-Roman.otf",
    "serif-display": ROOT / "FCaslon" / "FCaslonPosterITCStd-Roman.otf",
    "sans":          ROOT / "Akzidenz Grotesk" / "AkzidenzGrotesk-Regular.otf",
    "mono":          ROOT / "Courier Std" / "CourierStd.otf",
}

BODY_ROLE = "serif-text"

# Apparent-size targets: physical x-height in px for body copy
TARGET_X_MIN = 8.8   # at minWidth viewport
TARGET_X_MAX = 9.8   # at maxWidth viewport
TARGET_CPL = 75      # characters per line at maxFontSize
LEADING_DIVISOR = {  # line-height = 1ex / divisor; higher = tighter
    "body": 0.32,
    "heading": 0.40,
}


def glyph_ymax(font, name):
    gs = font.getGlyphSet()
    cmap = font.getBestCmap()
    gname = cmap.get(ord(name), name if name in gs else None)
    if gname is None or gname not in gs:
        return None
    pen = BoundsPen(gs)
    gs[gname].draw(pen)
    return pen.bounds[3] if pen.bounds else None


def avg_lc_advance(font):
    gs = font.getGlyphSet()
    cmap = font.getBestCmap()
    widths = []
    for c in "abcdefghijklmnopqrstuvwxyz":
        g = cmap.get(ord(c))
        if g and g in gs:
            widths.append(gs[g].width)
    return sum(widths) / len(widths) if widths else None


def extract(path):
    f = TTFont(path)
    upm = f["head"].unitsPerEm
    os2 = f.get("OS/2")
    hhea = f["hhea"]

    sx_os2 = getattr(os2, "sxHeight", 0) or 0
    cap_os2 = getattr(os2, "sCapHeight", 0) or 0
    sx_meas = glyph_ymax(f, "x") or 0
    cap_meas = glyph_ymax(f, "H") or 0
    # trust measured bounds; OS/2 v<2 or sloppy fonts report 0/garbage
    sx = sx_meas or sx_os2
    cap = cap_meas or cap_os2

    return {
        "path": str(path),
        "upm": upm,
        "x_ratio": sx / upm,
        "x_ratio_os2": sx_os2 / upm,
        "cap_ratio": cap / upm,
        "typo_asc": os2.sTypoAscender / upm,
        "typo_desc": os2.sTypoDescender / upm,
        "typo_gap": os2.sTypoLineGap / upm,
        "hhea_normal": (hhea.ascent - hhea.descent + hhea.lineGap) / upm,
        "avg_advance": (avg_lc_advance(f) or 0) / upm,
    }


def main():
    data = {}
    for role, path in ROLES.items():
        if not path.exists():
            print(f"!! missing: {path}")
            continue
        data[role] = extract(path)

    body = data[BODY_ROLE]
    xr = body["x_ratio"]

    print(f"{'role':<14}{'upm':>6}{'x':>8}{'x/os2':>8}{'cap':>7}"
          f"{'asc':>7}{'desc':>7}{'gap':>6}{'nrml':>7}{'advW':>7}")
    for role, m in data.items():
        print(f"{role:<14}{m['upm']:>6}{m['x_ratio']:>8.3f}"
              f"{m['x_ratio_os2']:>8.3f}{m['cap_ratio']:>7.3f}"
              f"{m['typo_asc']:>7.3f}{m['typo_desc']:>7.3f}"
              f"{m['typo_gap']:>6.2f}{m['hhea_normal']:>7.3f}"
              f"{m['avg_advance']:>7.3f}")

    min_fs = TARGET_X_MIN / xr
    max_fs = TARGET_X_MAX / xr
    max_measure = TARGET_CPL * body["avg_advance"] * max_fs

    print(f"\n== derived from body role '{BODY_ROLE}' (x-ratio {xr:.3f}) ==")
    print(f"minFontSize      = {TARGET_X_MIN} / {xr:.3f} = {min_fs:.1f}  -> use {round(min_fs * 2) / 2}")
    print(f"maxFontSize      = {TARGET_X_MAX} / {xr:.3f} = {max_fs:.1f}  -> use {round(max_fs * 2) / 2}")
    print(f"content maxWidth = {TARGET_CPL}ch * {body['avg_advance']:.3f} * {max_fs:.1f}px = {max_measure:.0f}px")
    print(f"body leading     = calc(1ex / {LEADING_DIVISOR['body']}) "
          f"~= {xr / LEADING_DIVISOR['body']:.2f} unitless")
    print(f"body 'normal' floor (hhea) = {body['hhea_normal']:.3f}")

    print("\n== per-role compensation vs body ==")
    print(f"{'role':<14}{'x-ratio':>8}{'size-comp':>10}{'fsa':>7}")
    for role, m in data.items():
        comp = xr / m["x_ratio"] if m["x_ratio"] else float("nan")
        print(f"{role:<14}{m['x_ratio']:>8.3f}{comp:>10.3f}{xr:>7.3f}")
    print("\nsize-comp: multiply this role's font-size to match body apparent size")
    print("fsa: font-size-adjust value normalising any role to body x-height")

    print("\n== paste into settings/_utopia-config.scss ==")
    print(f"""$utopia-type: (
  "minWidth": 320,
  "maxWidth": 1240,
  "minFontSize": {round(min_fs * 2) / 2},
  "maxFontSize": {round(max_fs * 2) / 2},
  "minTypeScale": 1.2,
  "maxTypeScale": 1.25,
  "positiveSteps": 5,
  "negativeSteps": 2,
);""")


if __name__ == "__main__":
    main()
