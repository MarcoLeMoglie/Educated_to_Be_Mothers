#!/usr/bin/env python3

from __future__ import annotations

import argparse
from pathlib import Path

import pandas as pd
from PIL import Image, ImageDraw, ImageFont


LINE_BLUE = (22, 95, 130)
GRID = (220, 220, 220)
BLACK = (20, 20, 20)
WHITE = (255, 255, 255)


def get_font(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    for candidate in [
        "/System/Library/Fonts/Supplemental/Arial.ttf",
        "/System/Library/Fonts/Supplemental/Helvetica.ttc",
        "/Library/Fonts/Arial.ttf",
    ]:
        if Path(candidate).exists():
            try:
                return ImageFont.truetype(candidate, size=size)
            except Exception:
                pass
    return ImageFont.load_default()


def build_tfr_figure(data_path: Path, output_path: Path) -> None:
    df = pd.read_stata(data_path).sort_values("year").reset_index(drop=True)

    width, height = 1653, 993
    image = Image.new("RGB", (width, height), WHITE)
    draw = ImageDraw.Draw(image)

    left, right = 120, 80
    top, bottom = 90, 150
    plot_x0, plot_x1 = left, width - right
    plot_y0, plot_y1 = top, height - bottom

    x_min, x_max = float(df["year"].min()), float(df["year"].max())
    y_min, y_max = 0.0, 5.5

    def xcoord(x: float) -> float:
        return plot_x0 + (x - x_min) / (x_max - x_min) * (plot_x1 - plot_x0)

    def ycoord(y: float) -> float:
        return plot_y1 - (y - y_min) / (y_max - y_min) * (plot_y1 - plot_y0)

    axis_font = get_font(20)
    small_font = get_font(16)
    title_font = get_font(22)

    for y in [0, 1, 2, 3, 4, 5]:
        py = ycoord(y)
        draw.line([(plot_x0, py), (plot_x1, py)], fill=GRID, width=2)
        draw.text((plot_x0 - 40, py - 10), f"{y}", fill=BLACK, font=axis_font)

    for year in range(1850, 2030, 10):
        px = xcoord(year)
        draw.line([(px, plot_y0), (px, plot_y1)], fill=(245, 245, 245), width=1)
        draw.text((px - 22, plot_y1 + 18), str(year), fill=BLACK, font=axis_font)

    draw.line([(plot_x0, plot_y1), (plot_x1, plot_y1)], fill=BLACK, width=3)
    draw.line([(plot_x0, plot_y0), (plot_x0, plot_y1)], fill=BLACK, width=3)

    points = [(xcoord(float(r.year)), ycoord(float(r.tfr))) for r in df.itertuples()]
    draw.line(points, fill=LINE_BLUE, width=5, joint="curve")
    for px, py in points:
        draw.ellipse((px - 5, py - 5, px + 5, py + 5), fill=LINE_BLUE, outline=LINE_BLUE)

    x_label = "Year"
    xb = draw.textbbox((0, 0), x_label, font=axis_font)
    draw.text(
        ((plot_x0 + plot_x1 - (xb[2] - xb[0])) / 2, height - 65),
        x_label,
        fill=BLACK,
        font=axis_font,
    )

    y_label = "National TFR"
    yb = draw.textbbox((0, 0), y_label, font=axis_font)
    text_img = Image.new("RGBA", (yb[2] - yb[0] + 8, yb[3] - yb[1] + 8), (255, 255, 255, 0))
    text_draw = ImageDraw.Draw(text_img)
    text_draw.text((4, 4), y_label, fill=BLACK, font=axis_font)
    rotated = text_img.rotate(90, expand=True)
    image.paste(rotated, (22, int((plot_y0 + plot_y1 - rotated.height) / 2)), rotated)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    image.save(output_path, quality=95)


def main() -> None:
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest="command", required=True)

    tfr_parser = sub.add_parser("tfr")
    tfr_parser.add_argument("--data", required=True)
    tfr_parser.add_argument("--out", required=True)

    args = parser.parse_args()

    if args.command == "tfr":
        build_tfr_figure(Path(args.data), Path(args.out))


if __name__ == "__main__":
    main()
