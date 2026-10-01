#!/usr/bin/env python3
"""Compose App Store marketing screenshots from real Kido Chef UI captures."""

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
FONT_ARIAL_ROUND = "/System/Library/Fonts/Supplemental/Arial Rounded Bold.ttf"

IPHONE_SIZE = (1320, 2868)
IPAD_SIZE = (2064, 2752)
NAVY = (22, 52, 92)


@dataclass
class Slide:
    source: str
    kicker: str
    title: str
    subtitle: str
    top: str
    bottom: str
    art: tuple[str, ...]


SLIDES = [
    Slide("01-home", "KIDO CHEF", "Let’s cook!", "Tap, mix, and make yummy food.", "4EC3FF", "FFE9A8", ("ArtPizza", "ArtIceCream")),
    Slide("02-foods", "PICK A DISH", "So many kitchens!", "Pizza, dosa, nachos, ramen & more.", "FFE56A", "FFD0F0", ("ArtNachos", "ArtBiryani")),
    Slide("03-pizza", "TAP TOPPINGS", "Build a pizza", "Kids cook with their fingers.", "FF8A7A", "FFF4D6", ("IngCheese", "IngTomato")),
    Slide("04-dosa", "WORLD KITCHENS", "Dosa & chutney", "South Indian, Mexican, and more.", "7EE08A", "E8F8FF", ("ArtIdli", "ArtMangoLassi")),
    Slide("05-school", "INGREDIENT SCHOOL", "Learn foods", "What each topping is, and how we cook it.", "C8B6FF", "E8F7FF", ("IngMango", "IngPaneer")),
    Slide("06-result", "YUMMY", "You did it!", "Stars, cheers, and a shareable card.", "FFB6E8", "FFE56A", ("ArtCupcake", "ArtDonut")),
    Slide("07-howto", "FOR LITTLE CHEFS", "Easy to play", "Offline. No login. Just cooking fun.", "9FE4FF", "FFF8E8", ("ArtFalafel", "ArtRamen")),
]


def hex_color(value: str) -> tuple[int, int, int]:
    value = value.lstrip("#")
    return (int(value[0:2], 16), int(value[2:4], 16), int(value[4:6], 16))


def font(size: int) -> ImageFont.FreeTypeFont:
    for path in (FONT_ROUNDED, FONT_ARIAL_ROUND):
        if os.path.exists(path):
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def lerp(a: tuple[int, int, int], b: tuple[int, int, int], t: float) -> tuple[int, int, int]:
    return (
        int(a[0] + (b[0] - a[0]) * t),
        int(a[1] + (b[1] - a[1]) * t),
        int(a[2] + (b[2] - a[2]) * t),
    )


def vertical_gradient(size: tuple[int, int], top: str, bottom: str) -> Image.Image:
    w, h = size
    img = Image.new("RGB", size)
    start, end = hex_color(top), hex_color(bottom)
    cream = hex_color("FFF8EE")
    px = img.load()
    for y in range(h):
        t = y / max(h - 1, 1)
        color = lerp(start, cream, min(1, t * 1.15)) if t < 0.45 else lerp(cream, end, (t - 0.45) / 0.55)
        for x in range(w):
            px[x, y] = color
    return img


def rounded(im: Image.Image, radius: int) -> Image.Image:
    im = im.convert("RGBA")
    mask = Image.new("L", im.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, im.width, im.height), radius=radius, fill=255)
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


def load_art(name: str, box: int) -> Image.Image | None:
    path = find_art(name)
    if path is None:
        return None
    art = Image.open(path).convert("RGBA")
    art.thumbnail((box, box), Image.Resampling.LANCZOS)
    return art


def fit_device(path: Path, max_w: int, max_h: int, radius: int) -> Image.Image:
    shot = Image.open(path).convert("RGBA")
    shot.thumbnail((max_w, max_h), Image.Resampling.LANCZOS)
    bezel = max(12, int(shot.width * 0.018))
    framed = Image.new("RGBA", (shot.width + bezel * 2, shot.height + bezel * 2), (0, 0, 0, 0))
    plate = rounded(Image.new("RGBA", framed.size, (255, 255, 255, 255)), radius + bezel)
    framed.paste(plate, (0, 0), plate)
    inner = rounded(shot, radius)
    framed.paste(inner, (bezel, bezel), inner)
    return framed


def drop_shadow(im: Image.Image, blur: int, dy: int) -> Image.Image:
    pad = blur * 3
    canvas = Image.new("RGBA", (im.width + pad * 2, im.height + pad * 2 + dy), (0, 0, 0, 0))
    shadow = Image.new("RGBA", im.size, (22, 52, 92, 0))
    alpha = im.split()[-1].filter(ImageFilter.GaussianBlur(blur))
    shadow.putalpha(alpha.point(lambda a: min(140, a)))
    canvas.paste(shadow, (pad, pad + dy), shadow)
    canvas.paste(im, (pad, pad), im)
    return canvas


def center_text(draw: ImageDraw.ImageDraw, text: str, y: int, fnt: ImageFont.FreeTypeFont, fill, width: int) -> int:
    bbox = draw.textbbox((0, 0), text, font=fnt)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    draw.text(((width - tw) / 2, y), text, font=fnt, fill=fill)
    return th


def candy_title(base: Image.Image, text: str, y: int, fnt: ImageFont.FreeTypeFont) -> int:
    draw = ImageDraw.Draw(base)
    bbox = draw.textbbox((0, 0), text, font=fnt)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    x = int((base.width - tw) / 2)
    pad_x, pad_y = 16, 18
    for dx, dy in ((-3, 0), (3, 0), (0, -3), (0, 3), (-2, -2), (2, 2)):
        draw.text((x + dx, y + dy), text, font=fnt, fill=(255, 255, 255, 220))
    band = Image.new("RGBA", (max(tw, 1) + pad_x * 2, max(th, 1) + pad_y * 2), (0, 0, 0, 0))
    gp = band.load()
    start, end = hex_color("FFB300"), hex_color("E02060")
    for gx in range(band.width):
        color = lerp(start, end, gx / max(band.width - 1, 1)) + (255,)
        for gy in range(band.height):
            gp[gx, gy] = color
    mask = Image.new("L", band.size, 0)
    ImageDraw.Draw(mask).text((pad_x, pad_y), text, font=fnt, fill=255)
    colored = Image.new("RGBA", base.size, (0, 0, 0, 0))
    colored.paste(band, (x - pad_x, y - pad_y), mask)
    base.alpha_composite(colored)
    return th


def compose(slide: Slide, source: Path, size: tuple[int, int], dest: Path) -> None:
    w, h = size
    header = int(h * 0.22) if h / w > 1.8 else int(h * 0.24)
    canvas = vertical_gradient(size, slide.top, slide.bottom).convert("RGBA")
    draw = ImageDraw.Draw(canvas, "RGBA")

    # playful circles
    for cx, cy, r, alpha in (
        (int(w * 0.08), int(h * 0.06), int(w * 0.10), 40),
        (int(w * 0.94), int(h * 0.08), int(w * 0.12), 36),
        (int(w * 0.9), int(h * 0.94), int(w * 0.10), 28),
    ):
        draw.ellipse((cx - r, cy - r, cx + r, cy + r), fill=hex_color(slide.top) + (alpha,))

    kicker_f = font(max(22, int(w * 0.034)))
    title_f = font(max(44, int(w * 0.078)))
    sub_f = font(max(22, int(w * 0.032)))

    y = int(h * 0.038)
    center_text(draw, slide.kicker, y, kicker_f, NAVY, w)
    y += int(h * 0.042)
    candy_title(canvas, slide.title, y, title_f)
    y += int(h * 0.078)
    center_text(draw, slide.subtitle, y, sub_f, NAVY, w)

    art_box = int(min(w, h) * 0.11)
    left = load_art(slide.art[0], art_box) if slide.art else None
    right = load_art(slide.art[1], art_box) if len(slide.art) > 1 else None
    if left:
        canvas.alpha_composite(left, (int(w * 0.06), int(h * 0.045)))
    if right:
        canvas.alpha_composite(right, (w - right.width - int(w * 0.06), int(h * 0.04)))

    bottom_pad = int(h * 0.028)
    device = fit_device(
        source,
        max_w=int(w * 0.86),
        max_h=int(h - header - bottom_pad),
        radius=int(min(w, h) * 0.048),
    )
    shadowed = drop_shadow(device, blur=max(12, int(w * 0.018)), dy=int(h * 0.006))
    while shadowed.height > h - header - bottom_pad and shadowed.height > 200:
        device = device.resize((int(device.width * 0.96), int(device.height * 0.96)), Image.Resampling.LANCZOS)
        shadowed = drop_shadow(device, blur=max(12, int(w * 0.018)), dy=int(h * 0.006))
    x = (w - shadowed.width) // 2
    y_shot = header + max(0, (h - header - bottom_pad - shadowed.height) // 2)
    canvas.alpha_composite(shadowed, (x, y_shot))

    dest.parent.mkdir(parents=True, exist_ok=True)
    canvas.convert("RGB").save(dest, "PNG", optimize=True)
    print(f"wrote {dest.name} {w}x{h}")


def run_folder(raw: Path, out: Path, size: tuple[int, int]) -> None:
    if not raw.exists():
        print(f"skip missing {raw}")
        return
    out.mkdir(parents=True, exist_ok=True)
    for slide in SLIDES:
        src = raw / f"{slide.source}.png"
        if not src.exists():
            print(f"missing {src}")
            continue
        compose(slide, src, size, out / f"{slide.source}.png")


def main() -> None:
    run_folder(RAW_IPHONE, OUT_IPHONE, IPHONE_SIZE)
    run_folder(RAW_IPAD, OUT_IPAD, IPAD_SIZE)


if __name__ == "__main__":
    main()
