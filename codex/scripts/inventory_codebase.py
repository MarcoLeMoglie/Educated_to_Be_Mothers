#!/usr/bin/env python3

from __future__ import annotations

import os
from collections import defaultdict
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
OUTDIR = ROOT / "codex" / "generated"
OUTFILE = OUTDIR / "codebase_inventory.md"

KEY_EXTS = {".do", ".py", ".md", ".tex", ".csv", ".dta", ".xlsx"}
TEXT_EXTS = {".do", ".py", ".md", ".tex", ".csv"}
KEY_DIRS = [
    "progs",
    "Paper",
    "Marco",
    "original_data",
    "output_data",
    "results",
    "comments",
]
SEARCH_TERMS = [
    "1961",
    "Law 56",
    "migration",
    "migracion",
    "migraciones",
    "birth",
    "stayer",
    "mover",
]


def iter_files(base: Path):
    for root, dirs, files in os.walk(base):
        dirs[:] = [
            d
            for d in dirs
            if d not in {".git", "__pycache__", ".DS_Store", "node_modules"}
        ]
        for name in files:
            path = Path(root) / name
            if path.suffix.lower() in KEY_EXTS:
                yield path


def safe_count_lines(path: Path) -> int | None:
    if path.suffix.lower() not in TEXT_EXTS:
        return None
    try:
        with path.open("r", encoding="utf-8", errors="ignore") as f:
            return sum(1 for _ in f)
    except Exception:
        return None


def term_hits(path: Path):
    if path.suffix.lower() not in TEXT_EXTS:
        return []
    hits = []
    try:
        text = path.read_text(encoding="utf-8", errors="ignore").lower()
    except Exception:
        return hits
    for term in SEARCH_TERMS:
        if term.lower() in text:
            hits.append(term)
    return hits


def main():
    OUTDIR.mkdir(parents=True, exist_ok=True)

    grouped = defaultdict(list)
    hit_rows = []

    for dirname in KEY_DIRS:
        base = ROOT / dirname
        if not base.exists():
            continue
        for path in iter_files(base):
            rel = path.relative_to(ROOT)
            grouped[dirname].append(rel)
            hits = term_hits(path)
            if hits:
                hit_rows.append((rel, hits, safe_count_lines(path)))

    lines = []
    lines.append("# Codebase Inventory")
    lines.append("")
    lines.append(f"Root: `{ROOT}`")
    lines.append("")

    lines.append("## By directory")
    lines.append("")
    for dirname in KEY_DIRS:
        files = sorted(grouped.get(dirname, []))
        if not files:
            continue
        lines.append(f"### {dirname}")
        lines.append("")
        lines.append(f"Tracked files: {len(files)}")
        lines.append("")
        for rel in files[:200]:
            nlines = safe_count_lines(ROOT / rel)
            suffix = f" ({nlines} lines)" if nlines is not None else ""
            lines.append(f"- `{rel}`{suffix}")
        if len(files) > 200:
            lines.append(f"- ... {len(files) - 200} more")
        lines.append("")

    lines.append("## Keyword hits")
    lines.append("")
    if hit_rows:
        for rel, hits, nlines in sorted(hit_rows):
            suffix = f" ({nlines} lines)" if nlines is not None else ""
            lines.append(f"- `{rel}`{suffix}: {', '.join(hits)}")
    else:
        lines.append("- No keyword hits found.")
    lines.append("")

    OUTFILE.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {OUTFILE}")


if __name__ == "__main__":
    main()
