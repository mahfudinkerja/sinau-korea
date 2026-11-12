"""Generate Sinau Korea launcher assets.

Run from the project root:
    .venv/bin/python tool/generate_icon.py
"""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

SIZE = 1024
CENTER = SIZE // 2
TOP = (108, 140, 255)
BOTTOM = (59, 75, 194)
MINT = (55, 216, 164)
WHITE = (255, 255, 255)

OUT = Path(__file__).resolve().parent.parent / "assets" / "icon"
OUT.mkdir(parents=True, exist_ok=True)


def glyph_mask(size: int = SIZE, scale: float = 1.0) -> Image.Image:
    """White ㅎ glyph plus mint accent on a transparent L mask."""
    mask = Image.new("L", (size, size), 0)
    draw = ImageDraw.Draw(mask)
    s = scale
    ox = (size - size * s) / 2
    oy = (size - size * s) / 2

    def box(x0, y0, x1, y1):
        return [
            ox + x0 * s,
            oy + y0 * s,
            ox + x1 * s,
            oy + y1 * s,
        ]

    # ㅎ: short top stroke, long middle stroke, ring at the bottom.
    draw.rounded_rectangle(box(352, 296, 672, 356), radius=30 * s, fill=255)
    draw.rounded_rectangle(box(296, 424, 728, 484), radius=30 * s, fill=255)
    draw.ellipse(box(362, 512, 662, 812), fill=255)
    draw.ellipse(box(426, 576, 598, 748), fill=0)
    # Accent dot.
    draw.ellipse(box(730, 266, 786, 322), fill=255)
    return mask


def vertical_gradient() -> Image.Image:
    image = Image.new("RGB", (SIZE, SIZE))
    draw = ImageDraw.Draw(image)
    for y in range(SIZE):
        t = y / (SIZE - 1)
        color = tuple(
            round(TOP[i] + (BOTTOM[i] - TOP[i]) * t) for i in range(3)
        )
        draw.line([(0, y), (SIZE, y)], fill=color)
    return image


def legacy_icon() -> Image.Image:
    background = vertical_gradient().convert("RGBA")
    rounded = Image.new("L", (SIZE, SIZE), 0)
    ImageDraw.Draw(rounded).rounded_rectangle(
        [0, 0, SIZE - 1, SIZE - 1], radius=232, fill=255
    )

    mask = glyph_mask()

    # Soft drop shadow, clipped by the rounded icon shape.
    shadow = mask.filter(ImageFilter.GaussianBlur(22))
    shadow_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    shadow_layer.paste((8, 12, 32, 105), (0, 14), shadow)

    white_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    white_layer.paste(WHITE + (255,), (0, 0), mask)

    accent_mask = Image.new("L", (SIZE, SIZE), 0)
    ImageDraw.Draw(accent_mask).ellipse([730, 266, 786, 322], fill=255)
    accent_layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    accent_layer.paste(MINT + (255,), (0, 0), accent_mask)

    icon = Image.alpha_composite(background, shadow_layer)
    icon = Image.alpha_composite(icon, white_layer)
    icon = Image.alpha_composite(icon, accent_layer)

    clipped = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    clipped.paste(icon, (0, 0), rounded)
    return clipped


def adaptive_foreground() -> Image.Image:
    image = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    mask = glyph_mask(scale=0.88)
    image.paste(WHITE + (255,), (0, 0), mask)

    accent_mask = Image.new("L", (SIZE, SIZE), 0)
    scale = 0.88
    offset = (SIZE - SIZE * scale) / 2
    ImageDraw.Draw(accent_mask).ellipse(
        [
            offset + 730 * scale,
            offset + 266 * scale,
            offset + 786 * scale,
            offset + 322 * scale,
        ],
        fill=255,
    )
    image.paste(MINT + (255,), (0, 0), accent_mask)
    return image


def monochrome() -> Image.Image:
    image = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    image.paste(WHITE + (255,), (0, 0), glyph_mask(scale=0.88))
    return image


if __name__ == "__main__":
    legacy_icon().save(OUT / "icon.png")
    adaptive_foreground().save(OUT / "icon_foreground.png")
    monochrome().save(OUT / "icon_monochrome.png")
    print("Generated launcher assets in", OUT)
