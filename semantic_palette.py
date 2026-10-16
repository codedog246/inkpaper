#!/usr/bin/env python3
r"""Semantic callout colours for inkpaper, generated in OKLCH per palette.

The four coloured callouts (takeaway, discussion, practicalguidance,
observation) carry a solid title bar with a white label over a faint tint of
the same hue.  For each palette (navy / teal / slate) the bars are derived
from the palette accent so that the family follows the class option instead
of four unrelated hard-coded hexes:

  Takeaway     accent hue                         OKLab L 0.44
  Discussion   accent hue + ROT_DISC (default 80) OKLab L 0.47
  Guidance     accent hue - ROT_GUID (default 62) OKLab L 0.50
  Observation  accent hue, near-zero chroma       OKLab L 0.54

One chroma per palette.  The small lightness ladder (Takeaway darkest,
Observation lightest) keeps the four bars reading as equals in colour while
still telling them apart in a grayscale print; every bar is checked for
white-label contrast (>= 5:1), separation from the body ink (>= 2:1),
pairwise OKLab distance (>= 8, x100) and the same distance after a
deuteranopia / protanopia simulation (Machado et al. 2009).

Also emitted per palette: a tint for every role (OKLab L 0.975), the
\oursrow table tint (accent hue, L 0.96) and the finding tint (accent hue,
L 0.975).

    python3 semantic_palette.py          # report + checks (exit 1 on failure)
    python3 semantic_palette.py --tex    # the \csdef blocks for inkpaper.cls
    python3 semantic_palette.py --swatch swatch.png   # PNG of all bars/tints

Tunables: --rot-disc DEG  --rot-guid DEG  --L a,b,c,d (OKLab L ladder).
"""
import math
import sys

# --- colour math (sRGB <-> linear <-> OKLab / CIELAB) -----------------------
def s2l(c):
    c /= 255
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4

def l2s(c):
    c = max(0.0, min(1.0, c))
    return 12.92 * c if c <= 0.0031308 else 1.055 * c ** (1 / 2.4) - 0.055

def hex2rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))

def rgb2hex(r, g, b):
    return '%02X%02X%02X' % (round(r), round(g), round(b))

def lin(h):
    return [s2l(c) for c in hex2rgb(h)]

def Y(h):
    r, g, b = lin(h)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b

def contrast(a, b='FFFFFF'):
    ya, yb = Y(a), Y(b)
    if ya < yb:
        ya, yb = yb, ya
    return (ya + 0.05) / (yb + 0.05)

def Lstar(h):                      # CIELAB L* from luminance (grayscale value)
    y = Y(h)
    f = y ** (1 / 3) if y > 216 / 24389 else (841 / 108) * y + 4 / 29
    return 116 * f - 16

def lin_to_oklab(r, g, b):
    l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b
    m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b
    s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b
    l_, m_, s_ = (max(l, 0)) ** (1 / 3), (max(m, 0)) ** (1 / 3), (max(s, 0)) ** (1 / 3)
    return (0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
            1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
            0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_)

def rgb_to_oklab(h):
    return lin_to_oklab(*lin(h))

def oklab_to_rgb(L, a, b):
    l_ = L + 0.3963377774 * a + 0.2158037573 * b
    m_ = L - 0.1055613458 * a - 0.0638541728 * b
    s_ = L - 0.0894841775 * a - 1.2914855480 * b
    l, m, s = l_ ** 3, m_ ** 3, s_ ** 3
    return (+4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
            -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
            -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s)

def oklch(h):
    L, a, b = rgb_to_oklab(h)
    return L, math.hypot(a, b), math.degrees(math.atan2(b, a)) % 360

def from_oklch(L, C, H):
    """Hex for OKLCH; chroma is reduced until the colour is inside sRGB."""
    hr = math.radians(H)
    while C >= 0:
        rgb = oklab_to_rgb(L, C * math.cos(hr), C * math.sin(hr))
        if all(-0.0005 <= c <= 1.0005 for c in rgb):
            break
        C -= 0.001
    return rgb2hex(*[l2s(c) * 255 for c in rgb])

def dE(a, b):                      # OKLab Euclidean distance (x100)
    return 100 * math.dist(rgb_to_oklab(a), rgb_to_oklab(b))

# Colour-vision-deficiency simulation (Machado, Oliveira, Fernandes 2009,
# severity 1.0), applied in linear RGB.
CVD = {
    'protan': ((0.152286, 1.052583, -0.204868),
               (0.114503, 0.786281, 0.099216),
               (-0.003882, -0.048116, 1.051998)),
    'deutan': ((0.367322, 0.860646, -0.227968),
               (0.280085, 0.672501, 0.047413),
               (-0.011820, 0.042940, 0.968881)),
}

def simulate(h, kind):
    r, g, b = lin(h)
    M = CVD[kind]
    out = [M[i][0] * r + M[i][1] * g + M[i][2] * b for i in range(3)]
    return rgb2hex(*[l2s(c) * 255 for c in out])

def dE_cvd(a, b, kind):
    return dE(simulate(a, kind), simulate(b, kind))

# --- system constants ---------------------------------------------------------
INK = '14171C'
ACCENTS = {'navy': '1F3B60', 'teal': '1D5C63', 'slate': '3A4556'}
ROLES = ('Takeaway', 'Discussion', 'Guidance', 'Observation')

def arg(flag, default, cast=float):
    if flag in sys.argv:
        return cast(sys.argv[sys.argv.index(flag) + 1])
    return default

ROT_DISC = arg('--rot-disc', 80.0)
ROT_GUID = arg('--rot-guid', 62.0)
L_BAR = dict(zip(ROLES, arg('--L', (0.44, 0.47, 0.50, 0.54),
                            lambda s: tuple(float(x) for x in s.split(',')))))
C_BAR = {'navy': 0.090, 'teal': 0.085, 'slate': 0.075}   # one chroma per palette
C_NEUT = 0.010                                           # Observation (near gray)
L_TINT, C_TINT = 0.975, 0.012                            # callout body tint
L_OURS, C_OURS = 0.960, 0.016                            # \oursrow table tint
L_FTINT, C_FTINT = 0.975, 0.010                          # finding tint (accent hue)

MIN_WHITE, MIN_INK, MIN_DE, MIN_DE_CVD = 5.0, 2.0, 8.0, 3.0   # CVD gate is advisory

def roles(name):
    H0 = oklch(ACCENTS[name])[2]
    C = C_BAR[name]
    return H0, [('Takeaway', H0, C),
                ('Discussion', (H0 + ROT_DISC) % 360, C),
                ('Guidance', (H0 - ROT_GUID) % 360, C),
                ('Observation', H0, C_NEUT)]

def build():
    out = {}
    for name in ACCENTS:
        H0, rs = roles(name)
        cols = {}
        for role, H, C in rs:
            tintC = 0.004 if role == 'Observation' else C_TINT
            cols[role] = (from_oklch(L_BAR[role], C, H), from_oklch(L_TINT, tintC, H))
        cols['_ours'] = from_oklch(L_OURS, C_OURS, H0)
        cols['_ftint'] = from_oklch(L_FTINT, C_FTINT, H0)
        out[name] = (H0, cols)
    return out

def emit_tex(out):
    print('% Generated by semantic_palette.py -- do not edit by hand.')
    print('%% Bars: OKLab L %s, hues accent / +%g / -%g / neutral; tints L %.3f.'
          % ('/'.join('%.2f' % L_BAR[r] for r in ROLES), ROT_DISC, ROT_GUID, L_TINT))
    for name, (H0, cols) in out.items():
        print('%% %s: accent hue %.0f, chroma %.3f' % (name, H0, C_BAR[name]))
        print('\\csdef{IP@sem@%s}{%%' % name)
        for role in ROLES:
            bar, tint = cols[role]
            print('  \\definecolor{ip%s}{HTML}{%s}%%' % (role, bar))
            print('  \\definecolor{ip%sTint}{HTML}{%s}%%' % (role, tint))
        print('  \\definecolor{ipOurs}{HTML}{%s}%%' % cols['_ours'])
        print('  \\definecolor{ipFindingTint}{HTML}{%s}}' % cols['_ftint'])

def report(out):
    ok = True
    print('bars: OKLab L %s, Discussion +%g deg, Guidance -%g deg; gates: white >= %.1f, ink >= %.1f, dE >= %.0f, dE(CVD) >= %.0f'
          % ('/'.join('%.2f' % L_BAR[r] for r in ROLES), ROT_DISC, ROT_GUID, MIN_WHITE, MIN_INK, MIN_DE, MIN_DE_CVD))
    hdr = '%-6s %-12s %-7s %6s %6s %6s %6s %7s %7s | %-7s %6s %8s' % (
        'pal', 'role', 'bar', 'okL', 'okC', 'hue', 'L*', 'white', 'ink', 'tint', 'tintL*', 'bar/tint')
    print(hdr)
    for name, (H0, cols) in out.items():
        for role in ROLES:
            bar, tint = cols[role]
            L, C, H = oklch(bar)
            cw, ci, ct = contrast(bar), contrast(bar, INK), contrast(bar, tint)
            flags = []
            if cw < MIN_WHITE:
                flags.append('white<%.1f' % MIN_WHITE)
            if ci < MIN_INK:
                flags.append('ink<%.1f' % MIN_INK)
            ok &= not flags
            print('%-6s %-12s %-7s %6.3f %6.3f %6.1f %6.1f %7.2f %7.2f | %-7s %6.1f %8.2f %s'
                  % (name, role, bar, L, C, H, Lstar(bar), cw, ci, tint, Lstar(tint), ct,
                     ('  <-- ' + ' '.join(flags)) if flags else ''))
        print('%-6s %-12s %-7s L*=%.1f  vs white %.2f   (table row tint, accent hue)'
              % (name, 'oursrow', cols['_ours'], Lstar(cols['_ours']), contrast(cols['_ours'])))
        print('%-6s %-12s %-7s L*=%.1f' % (name, 'findingTint', cols['_ftint'], Lstar(cols['_ftint'])))
        pairs = [(a, b) for i, a in enumerate(ROLES) for b in ROLES[i + 1:]]
        for kind, fn in (('normal', dE), ('deutan', lambda a, b: dE_cvd(a, b, 'deutan')),
                         ('protan', lambda a, b: dE_cvd(a, b, 'protan'))):
            vals = [(a, b, fn(cols[a][0], cols[b][0])) for a, b in pairs]
            mn = min(v for _, _, v in vals)
            gate = MIN_DE if kind == 'normal' else MIN_DE_CVD
            if kind == 'normal':
                ok &= mn >= gate
            print('       dE x100 %-6s min %.1f%s : %s' % (
                kind, mn, '' if mn >= gate else ('  <-- below %.0f' % gate if kind == 'normal' else '  (advisory: below %.0f, label text carries the role)' % gate),
                ', '.join('%s/%s %.1f' % (a[:3], b[:3], v) for a, b, v in vals)))
        gl = [Lstar(cols[r][0]) for r in ROLES]
        steps = [gl[i] - gl[i + 1] for i in range(3)]
        print('       grayscale L* of bars: %s (steps %s)' % (
            ' / '.join('%.1f' % g for g in gl), ' / '.join('%.1f' % s for s in steps)))
        print()
    print('ALL GATES PASS' if ok else 'GATE FAILURE')
    return ok

def swatch(out, path):
    from PIL import Image, ImageDraw
    W, H = 760, 40 + 70 * len(out)
    im = Image.new('RGB', (W, H), 'white')
    d = ImageDraw.Draw(im)
    y = 10
    for name, (H0, cols) in out.items():
        d.text((10, y + 20), name, fill='black')
        x = 70
        for role in ROLES:
            bar, tint = cols[role]
            d.rectangle([x, y, x + 150, y + 24], fill='#' + bar)
            d.rectangle([x, y + 24, x + 150, y + 56], fill='#' + tint, outline='#' + bar)
            d.text((x + 6, y + 6), role.upper(), fill='white')
            x += 160
        d.rectangle([x, y, x + 40, y + 56], fill='#' + cols['_ours'], outline='#cccccc')
        y += 70
    im.save(path)

if __name__ == '__main__':
    out = build()
    if '--tex' in sys.argv:
        emit_tex(out)
        sys.exit(0)
    if '--swatch' in sys.argv:
        swatch(out, sys.argv[sys.argv.index('--swatch') + 1])
    sys.exit(0 if report(out) else 1)
