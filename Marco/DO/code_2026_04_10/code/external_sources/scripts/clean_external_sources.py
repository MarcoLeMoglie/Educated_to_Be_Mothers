#!/usr/bin/env python3
from __future__ import annotations

import csv
import re
import unicodedata
import xml.etree.ElementTree as ET
from pathlib import Path

import pandas as pd
from pypdf import PdfReader


ROOT = Path(__file__).resolve().parents[2]
RAW = ROOT / "raw"
PROCESSED = ROOT / "processed"
NOTES = ROOT / "notes"

PROCESSED.mkdir(parents=True, exist_ok=True)
NOTES.mkdir(parents=True, exist_ok=True)


def slugify(text: str) -> str:
    value = unicodedata.normalize("NFKD", text).encode("ascii", "ignore").decode("ascii")
    value = value.lower()
    value = re.sub(r"[^a-z0-9]+", "_", value)
    value = value.strip("_")
    return value[:32]


def read_px_title(px_path: Path) -> str:
    if not px_path.exists():
        return ""
    text = px_path.read_text(encoding="latin-1", errors="ignore")
    match = re.search(r'TITLE="?([^";\n]+)', text)
    return match.group(1).strip() if match else ""


def clean_value(value):
    if pd.isna(value):
        return value
    if isinstance(value, str):
        value = re.sub(r"\s+", " ", value).strip()
    return value


def coerce_numeric(series: pd.Series) -> pd.Series:
    if not pd.api.types.is_string_dtype(series):
        return series
    cleaned = (
        series.astype(str)
        .str.replace(".", "", regex=False)
        .str.replace(",", ".", regex=False)
        .str.replace("%", "", regex=False)
        .str.replace("..", "", regex=False)
        .str.strip()
    )
    numeric = pd.to_numeric(cleaned, errors="coerce")
    share_numeric = numeric.notna().mean()
    return numeric if share_numeric >= 0.75 else series


def read_text_with_fallback(path: Path) -> tuple[str, str]:
    for encoding in ("utf-8-sig", "utf-8", "latin-1"):
        try:
            return path.read_text(encoding=encoding), encoding
        except UnicodeDecodeError:
            continue
    return path.read_text(encoding="latin-1", errors="ignore"), "latin-1"


def read_ine_csv(path: Path) -> pd.DataFrame:
    text, encoding = read_text_with_fallback(path)
    sample = text.splitlines()[:5]
    dialect = csv.Sniffer().sniff("\n".join(sample), delimiters=";,|\t")
    return pd.read_csv(path, sep=dialect.delimiter, encoding=encoding, dtype=str)


def clean_ine_tables() -> list[dict]:
    metadata = []
    for csv_path in sorted(RAW.glob("ine_*.csv_bd")):
        code = csv_path.stem.replace("ine_", "")
        px_path = RAW / f"ine_{code}.px"
        df = read_ine_csv(csv_path)
        df.columns = [slugify(col) for col in df.columns]
        df = df.apply(lambda col: col.map(clean_value))
        for col in df.columns:
            df[col] = coerce_numeric(df[col])

        title = read_px_title(px_path)
        out_csv = PROCESSED / f"ine_{code}_clean.csv"
        out_dta = PROCESSED / f"ine_{code}_clean.dta"
        df.to_csv(out_csv, index=False)
        try:
            df.to_stata(out_dta, write_index=False, version=118)
        except Exception:
            out_dta = None

        metadata.append(
            {
                "source_family": "ine_censo_1981",
                "table_code": code,
                "title": title,
                "rows": len(df),
                "columns": len(df.columns),
                "raw_file": str(csv_path.relative_to(ROOT)),
                "clean_csv": str(out_csv.relative_to(ROOT)),
                "clean_dta": "" if out_dta is None else str(out_dta.relative_to(ROOT)),
            }
        )
    return metadata


def text_or_empty(node: ET.Element | None, path: str) -> str:
    if node is None:
        return ""
    found = node.find(path)
    return found.text.strip() if found is not None and found.text else ""


def clean_boe_xml() -> list[dict]:
    rows = []
    for xml_path in sorted(RAW.glob("boe_*.xml")):
        root = ET.parse(xml_path).getroot()
        metadata = root.find(".//metadatos")
        rows.append(
            {
                "boe_id": text_or_empty(metadata, "identificador"),
                "titulo": text_or_empty(metadata, "titulo"),
                "fecha_disposicion": text_or_empty(metadata, "fecha_disposicion"),
                "fecha_publicacion": text_or_empty(metadata, "fecha_publicacion"),
                "rango": text_or_empty(metadata, "rango"),
                "departamento": text_or_empty(metadata, "departamento"),
                "diario": text_or_empty(metadata, "diario"),
                "raw_file": str(xml_path.relative_to(ROOT)),
            }
        )

    df = pd.DataFrame(rows)
    out_csv = PROCESSED / "boe_legal_timeline.csv"
    out_dta = PROCESSED / "boe_legal_timeline.dta"
    df.to_csv(out_csv, index=False)
    try:
        df.to_stata(out_dta, write_index=False, version=118)
    except Exception:
        pass
    return [
        {
            "source_family": "boe_legal",
            "table_code": row["boe_id"],
            "title": row["titulo"],
            "rows": 1,
            "columns": len(df.columns),
            "raw_file": row["raw_file"],
            "clean_csv": str(out_csv.relative_to(ROOT)),
            "clean_dta": str(out_dta.relative_to(ROOT)),
        }
        for row in rows
    ]


def clean_bde_pdf() -> list[dict]:
    pdf_path = RAW / "bde_dt9409_historical_employment.pdf"
    if not pdf_path.exists():
        return []

    reader = PdfReader(str(pdf_path))
    pages = []
    keyword_pages = []
    keywords = ["agric", "industr", "constru", "servicios", "sector", "epa"]
    for idx, page in enumerate(reader.pages, start=1):
        text = (page.extract_text() or "").strip()
        pages.append(text)
        lowered = text.lower()
        if any(keyword in lowered for keyword in keywords):
            keyword_pages.append(idx)

    extract_path = NOTES / "bde_dt9409_extract.txt"
    extract_path.write_text("\n\n".join(pages), encoding="utf-8")

    meta = pd.DataFrame(
        [
            {
                "source_id": "bde_dt9409",
                "title": "Elaboracion de series historicas de empleo a partir de la encuesta de poblacion activa (1964-1992)",
                "pages": len(reader.pages),
                "keyword_pages": ",".join(str(page) for page in keyword_pages),
                "raw_file": str(pdf_path.relative_to(ROOT)),
                "text_extract": str(extract_path.relative_to(ROOT)),
            }
        ]
    )
    out_csv = PROCESSED / "bde_dt9409_metadata.csv"
    out_dta = PROCESSED / "bde_dt9409_metadata.dta"
    meta.to_csv(out_csv, index=False)
    try:
        meta.to_stata(out_dta, write_index=False, version=118)
    except Exception:
        out_dta = None

    return [
        {
            "source_family": "bde_historical_employment",
            "table_code": "dt9409",
            "title": meta.loc[0, "title"],
            "rows": 1,
            "columns": len(meta.columns),
            "raw_file": str(pdf_path.relative_to(ROOT)),
            "clean_csv": str(out_csv.relative_to(ROOT)),
            "clean_dta": "" if out_dta is None else str(out_dta.relative_to(ROOT)),
        }
    ]


def write_inventory(metadata: list[dict]) -> None:
    df = pd.DataFrame(metadata).sort_values(["source_family", "table_code"])
    out_csv = PROCESSED / "external_sources_inventory.csv"
    out_md = NOTES / "external_sources_inventory.md"
    df.to_csv(out_csv, index=False)

    lines = [
        "# External Sources Inventory",
        "",
        "| source_family | table_code | title | rows | columns | clean_csv | clean_dta |",
        "|---|---|---|---:|---:|---|---|",
    ]
    for _, row in df.iterrows():
        lines.append(
            f"| {row['source_family']} | {row['table_code']} | {str(row['title']).replace('|', ' ')} | {row['rows']} | {row['columns']} | {row['clean_csv']} | {row['clean_dta']} |"
        )
    out_md.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    metadata = []
    metadata.extend(clean_boe_xml())
    metadata.extend(clean_bde_pdf())
    metadata.extend(clean_ine_tables())
    write_inventory(metadata)


if __name__ == "__main__":
    main()
