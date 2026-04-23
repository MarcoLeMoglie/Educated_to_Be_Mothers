import re
from pathlib import Path

import pandas as pd


ROOT = Path("/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE")
RAW = ROOT / "codex" / "external_data" / "raw"
OUT = ROOT / "codex" / "external_round2" / "generated"
NOTES = ROOT / "codex" / "external_round2" / "notes"


def clean_hfd_portugal_spain() -> None:
    raw_path = RAW / "owid_hfd_spain_portugal_cohort_fertility.csv"
    df = pd.read_csv(raw_path)
    df = df[df["Entity"].isin(["Spain", "Portugal"])].copy()
    df = df.rename(
        columns={
            "Entity": "country",
            "Code": "code",
            "Year": "cohort",
            "Completed cohort fertility rate": "completed_cohort_fertility",
        }
    )
    df["spain"] = (df["country"] == "Spain").astype(int)
    df = df.sort_values(["country", "cohort"]).reset_index(drop=True)

    df.to_csv(OUT / "portugal_spain_hfd_completed_fertility.csv", index=False)
    df.to_stata(OUT / "portugal_spain_hfd_completed_fertility.dta", write_index=False)


def _tidy_index_sheet(xls: pd.ExcelFile) -> pd.DataFrame:
    index_df = pd.read_excel(xls, sheet_name="Índice de series", header=None)
    rows = []
    for i in range(4, len(index_df)):
        series_code = index_df.iloc[i, 1]
        description = index_df.iloc[i, 3]
        date_start = index_df.iloc[i, 4]
        date_end = index_df.iloc[i, 5]
        frequency = index_df.iloc[i, 6]
        units = index_df.iloc[i, 7]
        series_type = index_df.iloc[i, 8]
        sheet = index_df.iloc[i, 9]
        if pd.isna(series_code) or pd.isna(description):
            continue
        series_code = str(series_code).strip()
        if not re.fullmatch(r"1994GG\d{4}", series_code):
            continue
        rows.append(
            {
                "series_code": series_code,
                "description": str(description).strip(),
                "date_start": str(date_start).strip(),
                "date_end": str(date_end).strip(),
                "frequency": str(frequency).strip(),
                "units": str(units).strip(),
                "series_type": str(series_type).strip(),
                "sheet": str(sheet).strip(),
            }
        )
    out = pd.DataFrame(rows).drop_duplicates()
    out.to_csv(OUT / "bde_dt9409_index.csv", index=False)
    out.to_stata(OUT / "bde_dt9409_index.dta", write_index=False)


def _row_description(row: pd.Series) -> str:
    pieces = []
    for pos in range(1, 9):
        value = row.iloc[pos]
        if pd.isna(value):
            continue
        text = str(value).strip()
        if not text or text == "NaN" or text == "Clave serie":
            continue
        if text.startswith("Véanse las notas"):
            continue
        pieces.append(text)
    return " | ".join(dict.fromkeys(pieces))


def clean_bde_historical_employment() -> None:
    xls = pd.ExcelFile(RAW / "bde_dt9409_series.xlsx")
    _tidy_index_sheet(xls)
    index_df = pd.read_csv(OUT / "bde_dt9409_index.csv")

    quarterly_rows = []
    for sheet_name in [name for name in xls.sheet_names if name.startswith("cuadro_")]:
        wide = pd.read_excel(xls, sheet_name=sheet_name, header=None)
        quarter_headers = wide.iloc[2, 10:].tolist()
        for i in range(3, len(wide)):
            series_code = wide.iloc[i, 9]
            if pd.isna(series_code):
                continue
            series_code = str(series_code).strip()
            if not re.fullmatch(r"1994GG\d{4}", series_code):
                continue
            row_desc = _row_description(wide.iloc[i, :])
            for j, quarter in enumerate(quarter_headers, start=10):
                value = wide.iloc[i, j]
                if pd.isna(quarter) or pd.isna(value):
                    continue
                quarter_text = str(quarter).strip().replace(" ", "")
                match = re.fullmatch(r"(\d{4}):([IVX]+)", quarter_text)
                if not match:
                    continue
                year = int(match.group(1))
                qroman = match.group(2)
                qmap = {"I": 1, "II": 2, "III": 3, "IV": 4}
                if qroman not in qmap:
                    continue
                quarterly_rows.append(
                    {
                        "sheet_raw": sheet_name,
                        "series_code": series_code,
                        "row_description": row_desc,
                        "quarter_label": quarter_text,
                        "year": year,
                        "quarter": qmap[qroman],
                        "value": float(value),
                    }
                )

    quarterly = pd.DataFrame(quarterly_rows)
    quarterly = quarterly.merge(index_df, on="series_code", how="left")
    quarterly["series_label"] = quarterly["description"].fillna(quarterly["row_description"])
    quarterly = quarterly.sort_values(["series_code", "year", "quarter"]).reset_index(drop=True)

    annual = (
        quarterly.groupby(
            ["series_code", "series_label", "description", "sheet", "series_type", "units", "year"],
            dropna=False,
        )["value"]
        .mean()
        .reset_index()
        .rename(columns={"value": "annual_mean"})
    )

    quarterly.to_csv(OUT / "bde_dt9409_series_quarterly.csv", index=False)
    quarterly.to_stata(OUT / "bde_dt9409_series_quarterly.dta", write_index=False)
    annual.to_csv(OUT / "bde_dt9409_series_annual.csv", index=False)
    annual.to_stata(OUT / "bde_dt9409_series_annual.dta", write_index=False)

    summary = index_df[["series_code", "description", "sheet"]].sort_values("series_code")
    (OUT / "bde_dt9409_index_preview.md").write_text(summary.head(20).to_string(index=False))


def write_manifest() -> None:
    manifest = """# Round 2 External Sources

- `portugal_spain_hfd_completed_fertility.*`
  - Source: OWID grapher series based on the Human Fertility Database.
  - Unit: country-by-cohort completed cohort fertility.
  - Countries kept: Spain, Portugal.

- `bde_dt9409_index.*`
  - Source: Banco de Espana dataset `Elaboracion de series historicas de empleo a partir de la EPA (1964-1992)`.
  - Content: series metadata from the official index sheet.

- `bde_dt9409_series_quarterly.*`
  - Source: Banco de Espana official Excel workbook.
  - Content: long quarterly format for every published historical labor-market series in the workbook.

- `bde_dt9409_series_annual.*`
  - Derived from the quarterly series as within-year averages.
"""
    (NOTES / "round2_source_manifest.md").write_text(manifest)


if __name__ == "__main__":
    OUT.mkdir(parents=True, exist_ok=True)
    NOTES.mkdir(parents=True, exist_ok=True)
    clean_hfd_portugal_spain()
    clean_bde_historical_employment()
    write_manifest()
