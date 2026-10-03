#!/usr/bin/env python3
"""Sreeo-studio App Store frames for iPhone and iPad.

Both sizes share one poster: pink kicker, navy title, orange dash,
white device, food on the top corners, NO ADS / AGES pills. iPad uses
the same rhythm as iPhone — only the device shape changes.
"""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parents[1]
RAW_IPHONE = ROOT / "AppStore" / "raw" / "iphone-69"
RAW_IPAD = ROOT / "AppStore" / "raw" / "ipad-13"
OUT_IPHONE = ROOT / "AppStore" / "screenshots" / "iphone-69"
OUT_IPAD = ROOT / "AppStore" / "screenshots" / "ipad-13"
ART = ROOT / "CrazyFoodFactory" / "Assets.xcassets"

FONT_ROUNDED = "/System/Library/Fonts/SFNSRounded.ttf"
FONT_ARIAL = "/System/Library/Fonts/Supplemental/Arial Rounded Bold.ttf"

IPHONE_SIZE = (1320, 2868)
IPAD_SIZE = (2064, 2752)

NAVY = (28, 32, 56)
PINK = (255, 79, 163)
ORANGE = (255, 154, 60)
CREAM = (255, 248, 238)
YELLOW = (255, 225, 74)
BADGE_PINK = (255, 138, 212)
SUBTLE = (28, 32, 56, 168)


@dataclass
class Slide:
    source: str
    title: str
    subtitle: str
    art: tuple[str, ...]


SLIDES = [
    Slide("01-home", "Let’s cook!", "Tap, mix, and make yummy food.", ("ArtPizza", "ArtIceCream")),
    Slide("02-foods", "Pick a dish!", "Pizza, dosa, nachos, ramen & more.", ("ArtNachos", "ArtBiryani")),
    Slide("03-pizza", "Build a pizza", "Kids cook with their fingers.", ("IngCheese", "IngTomato")),
    Slide("04-dosa", "World kitchens", "South Indian, Mexican, and more.", ("ArtIdli", "ArtMangoLassi")),
    Slide("05-school", "Learn foods", "What each topping is — and how we cook it.", ("IngMango", "IngPaneer")),
    Slide("06-result", "You did it!", "Stars, cheers, and a shareable card.", ("ArtCupcake", "ArtDonut")),
    Slide("07-howto", "Easy to play", "Offline. No login. Just cooking fun.", ("ArtFalafel", "ArtRamen")),
]


def font(size: int, weight: str = "Black") -> ImageFont.FreeTypeFont:
    size = max(12, int(size))
    if os.path.exists(FONT_ROUNDED):
        face = ImageFont.truetype(FONT_ROUNDED, size)
        try:
            face.set_variation_by_name(weight)
            return face
        except Exception:
            return face
    return ImageFont.truetype(FONT_ARIAL, size)


def rounded(im: Image.Image, radius: int) -> Image.Image:
    im = im.convert("RGBA")
    mask = Image.new("L", im.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, im.width - 1, im.height - 1), radius=radius, fill=255)
    im.putalpha(mask)
    return im


def find_art(name: str) -> Path | None:
    folder = ART / f"{name}.imageset"
    if not folder.exists():
        return None
    for item in sorted(folder.iterdir()):
        if item.suffix.lower() in {".png", ".jpg", ".jpeg"}:
            return item
    return None


def load_art(name: str, box: int, angle: float = 0) -> Image.Image | None:
    path = find_art(name)
    if path is None:
        return None
    art = Image.open(path).convert("RGBA")
    pix = art.load()
    w, h = art.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = pix[x, y]
            if a > 0 and r >= 242 and g >= 242 and b >= 242:
                pix[x, y] = (r, g, b, 0)
    art.thumbnail((box, box), Image.Resampling.LANCZOS)
    if angle:
        art = art.rotate(angle, resample=Image.Resampling.BICUBIC, expand=True)
    return art


def prep_screen(im: Image.Image, iphone: bool) -> Image.Image:
    """Keep the full UI. Only shave the iPhone island / home indicator."""
    w, h = im.size
    if iphone:
        top = int(h * 0.048)
        bottom = h - int(h * 0.006)
    else:
        top = 0
        bottom = h - int(h * 0.010)
    return im.crop((0, top, w, max(top + 10, bottom))).convert("RGBA")


def pad_screen(im: Image.Image, pad: int, extra_bottom: int = 0) -> Image.Image:
    """Push chrome off the device corner radius so buttons stay whole."""
    if pad <= 0 and extra_bottom <= 0:
        return im
    def rgba(px: tuple) -> tuple[int, int, int, int]:
        return px if len(px) == 4 else px + (255,)

    sky = rgba(im.getpixel((im.width // 2, min(12, im.height - 1))))
    # Corners, not the center — the center is often PLAY / NEXT.
    corner = rgba(im.getpixel((min(16, im.width - 1), max(0, im.height - 16))))
    out = Image.new("RGBA", (im.width + pad * 2, im.height + pad * 2 + extra_bottom), sky)
    if extra_bottom:
        ImageDraw.Draw(out).rectangle(
            (0, im.height + pad, out.width, out.height),
            fill=corner,
        )
    out.paste(im, (pad, pad), im)
    return out


def studio_canvas(size: tuple[int, int]) -> Image.Image:
    w, h = size
    base = Image.new("RGBA", size, CREAM)
    blobs = Image.new("RGBA", size, (0, 0, 0, 0))
    d = ImageDraw.Draw(blobs)
    d.ellipse((-int(w * 0.28), -int(h * 0.08), int(w * 0.62), int(h * 0.28)), fill=(168, 230, 255, 190))
    d.ellipse((int(w * 0.42), -int(h * 0.10), int(w * 1.22), int(h * 0.26)), fill=(255, 226, 140, 200))
    d.ellipse((-int(w * 0.20), int(h * 0.62), int(w * 0.48), int(h * 1.12)), fill=(186, 255, 214, 140))
    d.ellipse((int(w * 0.52), int(h * 0.70), int(w * 1.24), int(h * 1.16)), fill=(140, 214, 255, 150))
    d.ellipse((int(w * 0.70), int(h * 0.18), int(w * 1.18), int(h * 0.42)), fill=(255, 196, 230, 90))
    blobs = blobs.filter(ImageFilter.GaussianBlur(int(w * 0.055)))
    return Image.alpha_composite(base, blobs)


def text_size(fnt: ImageFont.FreeTypeFont, text: str) -> tuple[int, int]:
    bbox = fnt.getbbox(text)
    return bbox[2] - bbox[0], bbox[3] - bbox[1]


def fit_font(text: str, target: int, max_width: int, weight: str) -> ImageFont.FreeTypeFont:
    size = target
    while size > 18:
        face = font(size, weight)
        if text_size(face, text)[0] <= max_width:
            return face
        size -= 2
    return font(max(18, size), weight)


def draw_tracked(draw: ImageDraw.ImageDraw, text: str, y: int, fnt: ImageFont.FreeTypeFont, fill, canvas_w: int, tracking: float) -> int:
    widths = [fnt.getlength(ch) for ch in text]
    total = sum(widths) + tracking * max(0, len(text) - 1)
    x = (canvas_w - total) / 2
    for ch, cw in zip(text, widths):
        draw.text((x, y), ch, font=fnt, fill=fill)
        x += cw + tracking
    return text_size(fnt, "Ag")[1]


def center_text(draw: ImageDraw.ImageDraw, text: str, y: int, fnt: ImageFont.FreeTypeFont, fill, canvas_w: int) -> int:
    tw, th = text_size(fnt, text)
    draw.text(((canvas_w - tw) / 2, y), text, font=fnt, fill=fill)
    return th


def wrap_subtitle(text: str, fnt: ImageFont.FreeTypeFont, max_width: int) -> list[str]:
    if text_size(fnt, text)[0] <= max_width:
        return [text]
    words = text.split()
    lines: list[str] = []
    current = ""
    for word in words:
        trial = word if not current else f"{current} {word}"
        if text_size(fnt, trial)[0] <= max_width:
            current = trial
        else:
            if current:
                lines.append(current)
            current = word
    if current:
        lines.append(current)
    return lines[:2]


def pill(canvas: Image.Image, text: str, fill: tuple[int, int, int], cx: int, cy: int, fnt: ImageFont.FreeTypeFont) -> int:
    draw = ImageDraw.Draw(canvas)
    bbox = draw.textbbox((0, 0), text, font=fnt)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    pad_x, pad_y = int(fnt.size * 0.70), int(fnt.size * 0.36)
    pw, ph = tw + pad_x * 2, th + pad_y * 2
    x0, y0 = int(cx - pw / 2), int(cy - ph / 2)
    draw.rounded_rectangle((x0, y0, x0 + pw, y0 + ph), radius=ph // 2, fill=fill)
    draw.text((x0 + pad_x, y0 + pad_y - bbox[1]), text, font=fnt, fill=NAVY)
    return pw


def device_frame(screen: Image.Image, max_w: int, max_h: int, iphone: bool) -> Image.Image:
    screen = screen.convert("RGBA")
    bezel = max(18, int(min(max_w, max_h) * (0.022 if iphone else 0.016)))
    inner_w = max_w - bezel * 2
    inner_h = max_h - bezel * 2
    scale = min(inner_w / screen.width, inner_h / screen.height)
    sw = max(1, int(screen.width * scale))
    sh = max(1, int(screen.height * scale))
    screen = screen.resize((sw, sh), Image.Resampling.LANCZOS)
    # Phones are squircles. iPads have gentler corners so grid rows stay visible.
    radius = int(min(sw, sh) * (0.088 if iphone else 0.032))
    screen = rounded(screen, radius)

    fw, fh = sw + bezel * 2, sh + bezel * 2
    body = Image.new("RGBA", (fw, fh), (0, 0, 0, 0))
    ImageDraw.Draw(body).rounded_rectangle(
        (0, 0, fw - 1, fh - 1),
        radius=radius + bezel,
        fill=(255, 255, 255, 255),
    )
    body.alpha_composite(screen, (bezel, bezel))
    return body


def compose(slide: Slide, source: Path, size: tuple[int, int], dest: Path, iphone: bool) -> None:
    w, h = size
    canvas = studio_canvas(size)
    draw = ImageDraw.Draw(canvas)

    # Shared vertical rhythm so iPhone and iPad posters match.
    kicker_f = font(h * 0.0155, "Heavy")
    title_f = fit_font(slide.title, int(h * 0.046), int(w * 0.86), "Black")
    sub_f = font(h * 0.0162, "Semibold")
    badge_f = font(h * 0.0144, "Heavy")

    y = int(h * 0.036)
    draw_tracked(draw, "SREEO STUDIO", y, kicker_f, PINK, w, tracking=max(3.0, w * 0.0034))
    y += int(h * 0.032)
    y += center_text(draw, slide.title, y, title_f, NAVY, w) + int(h * 0.010)
    for line in wrap_subtitle(slide.subtitle, sub_f, int(w * 0.82)):
        y += center_text(draw, line, y, sub_f, SUBTLE, w) + int(h * 0.004)
    y += int(h * 0.008)
    bar_w, bar_h = int(w * (0.13 if iphone else 0.10)), max(8, int(h * 0.0042))
    draw.rounded_rectangle(
        ((w - bar_w) / 2, y, (w + bar_w) / 2, y + bar_h),
        radius=bar_h // 2,
        fill=ORANGE,
    )
    header_bottom = y + bar_h + int(h * 0.016)
    footer_top = int(h * (0.924 if iphone else 0.936))
    badge_y = int(h * 0.962)

    max_w = int(w * (0.84 if iphone else 0.78))
    max_h = max(200, footer_top - header_bottom)
    screen = prep_screen(Image.open(source), iphone=iphone)
    inset = int(min(screen.size) * (0.016 if iphone else 0.024))
    extra_frac = 0.058 if iphone else 0.024
    if slide.source == "06-result" and iphone:
        extra_frac = 0.12
    extra_bottom = int(screen.height * extra_frac)
    screen = pad_screen(screen, inset, extra_bottom=extra_bottom)
    phone = device_frame(screen, max_w, max_h, iphone=iphone)

    px = (w - phone.width) // 2
    py = header_bottom + max(0, (max_h - phone.height) // 2)

    shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    corner = int(min(phone.width, phone.height) * (0.12 if iphone else 0.05))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (px + 8, py + 18, px + phone.width + 4, py + phone.height + 22),
        radius=corner,
        fill=(40, 64, 96, 62),
    )
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(26)))
    canvas.alpha_composite(phone, (px, py))

    # Food sits on the white bezel corners, not on pause / settings / stars.
    art_box = int(phone.width * (0.24 if iphone else 0.138))
    left = load_art(slide.art[0], art_box, angle=-16) if slide.art else None
    right = load_art(slide.art[1], art_box, angle=14) if len(slide.art) > 1 else None
    if left:
        lx = px - int(left.width * (0.34 if iphone else 0.40))
        ly = py - int(left.height * (0.32 if iphone else 0.36))
        canvas.alpha_composite(left, (max(int(w * 0.016), lx), ly))
    if right:
        rx = px + phone.width - int(right.width * (0.66 if iphone else 0.60))
        ry = py - int(right.height * (0.26 if iphone else 0.30))
        canvas.alpha_composite(right, (min(w - right.width - int(w * 0.016), rx), ry))

    tmp = Image.new("RGBA", (1, 1))
    td = ImageDraw.Draw(tmp)
    w1 = td.textbbox((0, 0), "NO ADS", font=badge_f)[2] + int(badge_f.size * 1.40)
    w2 = td.textbbox((0, 0), "AGES 4–10", font=badge_f)[2] + int(badge_f.size * 1.40)
    gap = int(h * 0.012)
    pair = w1 + gap + w2
    x1 = w // 2 - pair // 2 + w1 // 2
    x2 = x1 + w1 // 2 + gap + w2 // 2
    pill(canvas, "NO ADS", YELLOW, x1, badge_y, badge_f)
    pill(canvas, "AGES 4–10", BADGE_PINK, x2, badge_y, badge_f)

    dest.parent.mkdir(parents=True, exist_ok=True)
    canvas.convert("RGB").save(dest, "PNG", optimize=True)
    print(f"wrote {dest.parent.name}/{dest.name} device={phone.size} at=({px},{py})")


def run_folder(raw: Path, out: Path, size: tuple[int, int], iphone: bool) -> None:
    if not raw.exists():
        print(f"skip missing {raw}")
        return
    out.mkdir(parents=True, exist_ok=True)
    for slide in SLIDES:
        src = raw / f"{slide.source}.png"
        if not src.exists():
            print(f"missing {src}")
            continue
        compose(slide, src, size, out / f"{slide.source}.png", iphone=iphone)


def main() -> None:
    run_folder(RAW_IPHONE, OUT_IPHONE, IPHONE_SIZE, iphone=True)
    run_folder(RAW_IPAD, OUT_IPAD, IPAD_SIZE, iphone=False)


if __name__ == "__main__":
    main()
