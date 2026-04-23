from __future__ import annotations

import re
from pathlib import Path

import fitz


ROOT = Path("/Users/marcolemoglie_1_2/Desktop/Paper")
SOURCE = ROOT / "JOLE_review_detailed_notes_it.md"
OUTPUT = ROOT / "JOLE_review_detailed_notes_it.pdf"

PAGE_WIDTH = 595
PAGE_HEIGHT = 842
LEFT = 54
RIGHT = 54
TOP = 54
BOTTOM = 54
CONTENT_WIDTH = PAGE_WIDTH - LEFT - RIGHT


LINK_RE = re.compile(r"\[([^\]]+)\]\(([^)]+)\)")


def parse_blocks(text: str):
    blocks = []
    current = []
    for raw_line in text.splitlines():
        line = raw_line.rstrip()
        if line.startswith("## "):
            if current:
                blocks.append(("paragraph", " ".join(current).strip()))
                current = []
            blocks.append(("heading2", line[3:].strip()))
        elif line.startswith("# "):
            if current:
                blocks.append(("paragraph", " ".join(current).strip()))
                current = []
            blocks.append(("heading1", line[2:].strip()))
        elif re.match(r"^- ", line):
            if current:
                blocks.append(("paragraph", " ".join(current).strip()))
                current = []
            blocks.append(("bullet", line[2:].strip()))
        elif not line.strip():
            if current:
                blocks.append(("paragraph", " ".join(current).strip()))
                current = []
        else:
            current.append(line.strip())
    if current:
        blocks.append(("paragraph", " ".join(current).strip()))
    return blocks


def tokenize_inline(text: str):
    tokens = []
    pos = 0
    for match in LINK_RE.finditer(text):
        if match.start() > pos:
            tokens.append(("text", text[pos:match.start()]))
        tokens.append(("link", match.group(1), match.group(2)))
        pos = match.end()
    if pos < len(text):
        tokens.append(("text", text[pos:]))
    return tokens


def split_words(tokens):
    items = []
    for token in tokens:
        if token[0] == "text":
            parts = re.findall(r"\S+\s*|\s+", token[1])
            for part in parts:
                if part:
                    items.append(("text", part))
        else:
            label, url = token[1], token[2]
            parts = re.findall(r"\S+\s*|\s+", label)
            for part in parts:
                if part:
                    items.append(("link", part, url))
    return items


def wrap_items(items, max_chars):
    lines = []
    line = []
    count = 0
    for item in items:
        text = item[1]
        item_len = len(text)
        if count and count + item_len > max_chars:
            lines.append(line)
            line = []
            count = 0
            if item[0] == "text":
                text = text.lstrip()
                item = ("text", text)
                item_len = len(text)
            else:
                stripped = text.lstrip()
                item = ("link", stripped, item[2])
                item_len = len(stripped)
        line.append(item)
        count += item_len
    if line:
        lines.append(line)
    return lines


def make_page(doc):
    page = doc.new_page(width=PAGE_WIDTH, height=PAGE_HEIGHT)
    return page, TOP


def style_for(kind):
    if kind == "heading1":
        return {"size": 18, "leading": 24, "font": "courier-bold", "gap_after": 10}
    if kind == "heading2":
        return {"size": 13, "leading": 18, "font": "courier-bold", "gap_after": 6}
    if kind == "bullet":
        return {"size": 10.5, "leading": 15, "font": "courier", "gap_after": 2, "prefix": "- "}
    return {"size": 11, "leading": 16, "font": "courier", "gap_after": 8}


def draw_block(doc, page, y, kind, text):
    style = style_for(kind)
    fontname = style["font"]
    size = style["size"]
    leading = style["leading"]
    gap_after = style["gap_after"]
    prefix = style.get("prefix", "")
    char_width = size * 0.6
    x0 = LEFT
    max_chars = max(20, int(CONTENT_WIDTH / char_width))
    base_text = prefix + text if prefix else text
    items = split_words(tokenize_inline(base_text))
    lines = wrap_items(items, max_chars)

    for line in lines:
        if y + leading > PAGE_HEIGHT - BOTTOM:
            page, y = make_page(doc)
        x = x0
        for item in line:
            if item[0] == "text":
                snippet = item[1]
                if snippet:
                    page.insert_text((x, y), snippet, fontname=fontname, fontsize=size)
                    x += len(snippet) * char_width
            else:
                snippet, url = item[1], item[2]
                if snippet:
                    page.insert_text((x, y), snippet, fontname=fontname, fontsize=size, color=(0, 0, 0.8))
                    rect = fitz.Rect(x, y - size, x + len(snippet) * char_width, y + 2)
                    page.insert_link({"kind": fitz.LINK_URI, "from": rect, "uri": url})
                    underline_y = y + 1
                    page.draw_line((x, underline_y), (x + len(snippet) * char_width, underline_y), color=(0, 0, 0.8), width=0.5)
                    x += len(snippet) * char_width
        y += leading
    y += gap_after
    return page, y


def main():
    text = SOURCE.read_text(encoding="utf-8")
    blocks = parse_blocks(text)
    doc = fitz.open()
    page, y = make_page(doc)

    for kind, content in blocks:
        page, y = draw_block(doc, page, y, kind, content)

    doc.set_metadata(
        {
            "title": "JOLE review detailed notes",
            "author": "OpenAI Codex",
            "subject": "Detailed notes on reviewer comments",
            "keywords": "JOLE, review, Spain, Franco, fertility",
        }
    )
    doc.save(OUTPUT, garbage=4, deflate=True)
    doc.close()


if __name__ == "__main__":
    main()
