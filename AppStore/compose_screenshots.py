#!/usr/bin/env python3
"""App Store frames that look like one studio set on iPhone and iPad.

Shared vertical rhythm (header band, device slot, badge band) so both sizes
line up the way Monkey Mayhem does: SREEO STUDIO, title, orange bar, white
device, food on the top corners, NO ADS / AGES pills. Real simulator UI is
never replaced.
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
SUB_INK = (28, 32, 56, 168)


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
    size = max(10, int(size))
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
    """Trim island / home indicator so the white bezel stays clean."""
    w, h = im.size
    if iphone:
        top = int(h * 0.048)
        bottom = h - int(h * 0.014)
    else:
        top = int(h * 0.018)
        bottom = h - int(h * 0.012)
    return im.crop((0, top, w, max(top + 10, bottom))).convert("RGBA")


def studio_canvas(size: tuple[int, int]) -> Image.Image:
    w, h = size
    base = Image.new("RGBA", size, CREAM)
    blobs = Image.new("RGBA", size, (0, 0, 0, 0))
    d = ImageDraw.Draw(blobs)
    d.ellipse((-int(w * 0.30), -int(h * 0.10), int(w * 0.64), int(h * 0.30)), fill=(168, 230, 255, 188))
    d.ellipse((int(w * 0.40), -int(h * 0.12), int(w * 1.24), int(h * 0.28)), fill=(255, 226, 140, 200))
    d.ellipse((-int(w * 0.22), int(h * 0.64), int(w * 0.50), int(h * 1.14)), fill=(186, 255, 214, 140))
    d.ellipse((int(w * 0.50), int(h * 0.70), int(w * 1.26), int(h * 1.16)), fill=(140, 214, 255, 150))
    d.ellipse((int(w * 0.68), int(h * 0.18), int(w * 1.20), int(h * 0.42)), fill=(255, 196, 230, 88))
    blobs = blobs.filter(ImageFilter.GaussianBlur(int(min(w, h) * 0.07)))
    return Image.alpha_composite(base, blobs)


def text_size(fnt: ImageFont.FreeTypeFont, text: str) -> tuple[int, int]:
    bbox = fnt.getbbox(text)
    return bbox[2] - bbox[0], bbox[3] - bbox[1]


def fit_font(text: str, target: int, max_width: int, weight: str = "Black") -> ImageFont.FreeTypeFont:
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


def wrap_lines(text: str, fnt: ImageFont.FreeTypeFont, max_width: int) -> list[str]:
    words = text.split()
    lines: list[str] = []
    current = ""
    for word in words:
        trial = f"{current} {word}".strip()
        if text_size(fnt, trial)[0] <= max_width:
            current = trial
        else:
            if current:
                lines.append(current)
            current = word
    if current:
        lines.append(current)
    return lines or [text]


def draw_wrapped(draw: ImageDraw.ImageDraw, text: str, y: int, fnt: ImageFont.FreeTypeFont, fill, canvas_w: int, max_width: int) -> int:
    lines = wrap_lines(text, fnt, max_width)
    line_h = text_size(fnt, "Ag")[1]
    gap = max(6, int(line_h * 0.22))
    for i, line in enumerate(lines):
        tw, _ = text_size(fnt, line)
        draw.text(((canvas_w - tw) / 2, y), line, font=fnt, fill=fill)
        y += line_h + (gap if i < len(lines) - 1 else 0)
    return y


def pill(canvas: Image.Image, text: str, fill: tuple[int, int, int], cx: int, cy: int, fnt: ImageFont.FreeTypeFont) -> tuple[int, int]:
    draw = ImageDraw.Draw(canvas)
    tw, th = text_size(fnt, text)
    pad_x, pad_y = int(fnt.size * 0.70), int(fnt.size * 0.36)
    w, h = tw + pad_x * 2, th + pad_y * 2
    x0, y0 = int(cx - w / 2), int(cy - h / 2)
    draw.rounded_rectangle((x0, y0, x0 + w, y0 + h), radius=h // 2, fill=fill)
    bbox = fnt.getbbox(text)
    draw.text((x0 + pad_x - bbox[0], y0 + pad_y - bbox[1]), text, font=fnt, fill=NAVY)
    return w, h


def device_frame(screen: Image.Image, max_w: int, max_h: int, iphone: bool) -> Image.Image:
    screen = screen.convert("RGBA")
    bezel = max(18, int(min(max_w, max_h) * (0.022 if iphone else 0.016)))
    inner_w = max_w - bezel * 2
    inner_h = max_h - bezel * 2
    scale = min(inner_w / screen.width, inner_h / screen.height)
    sw = max(1, int(screen.width * scale))
    sh = max(1, int(screen.height * scale))
    screen = screen.resize((sw, sh), Image.Resampling.LANCZOS)
    radius = int(min(sw, sh) * (0.105 if iphone else 0.048))
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

    # Same bands on both devices so the App Store pair lines up.
    header_bottom = int(h * 0.168)
    footer_top = int(h * 0.918)
    text_width = int(w * 0.86)

    kicker_f = font(max(20, int(h * 0.017)), "Heavy")
    title_target = max(54, int(h * (0.042 if iphone else 0.048)))
    title_f = fit_font(slide.title, title_target, text_width, "Black")
    sub_f = font(max(18, int(h * (0.0155 if iphone else 0.0168))), "Semibold")
    badge_f = font(max(16, int(h * 0.0138)), "Heavy")

    kicker_h = text_size(kicker_f, "SREEO STUDIO")[1]
    title_h = text_size(title_f, slide.title)[1]
    sub_lines = wrap_lines(slide.subtitle, sub_f, text_width)
    sub_h = text_size(sub_f, "Ag")[1]
    sub_gap = max(6, int(sub_h * 0.22))
    sub_block = len(sub_lines) * sub_h + max(0, len(sub_lines) - 1) * sub_gap
    bar_h = max(7, int(h * 0.0042))
    stack_gap = int(h * 0.010)
    stack_h = kicker_h + stack_gap + title_h + int(h * 0.008) + sub_block + int(h * 0.012) + bar_h
    y = max(int(h * 0.028), (header_bottom - stack_h) // 2)

    draw_tracked(draw, "SREEO STUDIO", y, kicker_f, PINK, w, tracking=max(2.4, w * 0.0036))
    y += kicker_h + stack_gap
    tw, _ = text_size(title_f, slide.title)
    draw.text(((w - tw) / 2, y), slide.title, font=title_f, fill=NAVY)
    y += title_h + int(h * 0.008)
    y = draw_wrapped(draw, slide.subtitle, y, sub_f, SUB_INK, w, text_width)
    y += int(h * 0.012)
    bar_w = int(min(w * 0.12, 220))
    draw.rounded_rectangle(
        ((w - bar_w) / 2, y, (w + bar_w) / 2, y + bar_h),
        radius=bar_h // 2,
        fill=ORANGE,
    )

    slot_top = header_bottom + int(h * 0.006)
    slot_bottom = footer_top - int(h * 0.008)
    max_w = int(w * (0.86 if iphone else 0.88))
    max_h = max(40, slot_bottom - slot_top)
    screen = prep_screen(Image.open(source), iphone=iphone)
    phone = device_frame(screen, max_w, max_h, iphone=iphone)

    px = (w - phone.width) // 2
    # Pin the device under the header. Leftover space stays above the pills.
    py = slot_top + max(0, min(int(h * 0.008), (max_h - phone.height) // 6))

    shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    radius = int(min(phone.width, phone.height) * (0.12 if iphone else 0.06))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (px + 8, py + 18, px + phone.width + 4, py + phone.height + 22),
        radius=radius,
        fill=(40, 64, 96, 64),
    )
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(26)))
    canvas.alpha_composite(phone, (px, py))

    # Same corner anchors on both sizes. iPad art is a bit smaller so it
    # sits on the bezel instead of covering the in-app chrome.
    art_box = int(phone.width * (0.22 if iphone else 0.155))
    left = load_art(slide.art[0], art_box, angle=-18) if slide.art else None
    right = load_art(slide.art[1], art_box, angle=14) if len(slide.art) > 1 else None
    if left:
        lx = max(-int(left.width * 0.08), px - int(left.width * 0.46))
        ly = py - int(left.height * 0.34)
        canvas.alpha_composite(left, (lx, ly))
    if right:
        rx = min(w - int(right.width * 0.92), px + phone.width - int(right.width * 0.54))
        ry = py - int(right.height * 0.28)
        canvas.alpha_composite(right, (rx, ry))

    badge_y = int((footer_top + h) / 2)

    def pill_width(label: str) -> int:
        tw, _ = text_size(badge_f, label)
        return tw + int(badge_f.size * 0.70) * 2

    w1, w2 = pill_width("NO ADS"), pill_width("AGES 4–10")
    gap = int(w * 0.028)
    pair = w1 + gap + w2
    x1 = w // 2 - pair // 2 + w1 // 2
    x2 = x1 + w1 // 2 + gap + w2 // 2
    pill(canvas, "NO ADS", YELLOW, x1, badge_y, badge_f)
    pill(canvas, "AGES 4–10", BADGE_PINK, x2, badge_y, badge_f)

    dest.parent.mkdir(parents=True, exist_ok=True)
    canvas.convert("RGB").save(dest, "PNG", optimize=True)
    print(f"wrote {dest.parent.name}/{dest.name} device={phone.size} origin=({px},{py})")


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
