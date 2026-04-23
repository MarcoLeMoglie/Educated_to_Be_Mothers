#!/usr/bin/env python3
from __future__ import annotations

import re
from pathlib import Path

import pandas as pd
from pypdf import PdfReader


ROOT = Path("/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE")
RAW = ROOT / "codex" / "external_data" / "raw"
OUT = ROOT / "codex" / "external_revisions" / "generated"
NOTES = ROOT / "codex" / "external_revisions" / "notes"

OUT.mkdir(parents=True, exist_ok=True)
NOTES.mkdir(parents=True, exist_ok=True)


PROVINCES = [
    "alava",
    "albacete",
    "alicante",
    "almeria",
    "avila",
    "badajoz",
    "baleares",
    "barcelona",
    "burgos",
    "caceres",
    "cadiz",
    "castellon",
    "ciudad real",
    "cordoba",
    "a coruña",
    "cuenca",
    "gerona",
    "granada",
    "guadalajara",
    "guipuzcoa",
    "huelva",
    "huesca",
    "jaen",
    "leon",
    "lleida",
    "logrono",
    "lugo",
    "madrid",
    "malaga",
    "murcia",
    "navarra",
    "ourense",
    "asturias",
    "palencia",
    "laspalmas",
    "pontevedra",
    "salamanca",
    "santa cruz de tenerife",
    "cantabria",
    "segovia",
    "sevilla",
    "soria",
    "tarragona",
    "teruel",
    "toledo",
    "valencia",
    "valladolid",
    "vizcaya",
    "zamora",
    "zaragoza",
]

VIII_TOTAL_OMISSIONS = {"barcelona", "burgos", "toledo"}
VIII_CAPITAL_OMISSIONS = {"avila", "barcelona", "guadalajara"}
VIII_TOTAL_PROVINCES = [province for province in PROVINCES if province not in VIII_TOTAL_OMISSIONS]
VIII_CAPITAL_PROVINCES = [province for province in PROVINCES if province not in VIII_CAPITAL_OMISSIONS]

SECTOR_COLUMNS = [
    "active_total_1950",
    "agri_total_1950",
    "mining_total_1950",
    "manufacturing_total_1950",
    "construction_total_1950",
    "utilities_total_1950",
    "commerce_total_1950",
    "transport_total_1950",
    "services_total_1950",
    "unspecified_total_1950",
]

TOTAL_OVERRIDES = {
    "cordoba": [275521, 167752, 4135, 30722, 13697, 1394, 12274, 7238, 37143, 1166],
    "logrono": [86810, 46818, 1311, 15763, 2839, 467, 4529, 2149, 12162, 772],
    "madrid": [761717, 69348, 2838, 152534, 76605, 8962, 92992, 59519, 245139, 53780],
    "sevilla": [400773, 195232, 3118, 52532, 19762, 2756, 23319, 14604, 72164, 17286],
}

CAPITAL_OVERRIDES = {
    "albacete": [24353, 8213, 0, 3606, 1979, 61, 2896, 2142, 5324, 132],
    "badajoz": [29228, 11891, 10, 2868, 2585, 105, 2441, 742, 8471, 115],
    "baleares": [56390, 16634, 434, 16217, 6940, 383, 6581, 3500, 15187, 514],
    "caceres": [14754, 3770, 162, 1965, 1439, 0, 1327, 1215, 4865, 11],
    "huesca": [8718, 1210, 0, 1403, 743, 43, 1049, 421, 3482, 367],
    "logrono": [19558, 1647, 42, 6112, 1381, 170, 2990, 921, 6240, 55],
}


def normalize_text(text: str) -> str:
    trans = str.maketrans({"I": "1", "l": "1", "!": "1", "O": "0", "o": "0"})
    text = text.translate(trans)
    text = text.replace("~", " ").replace("•", " ").replace("'", " ").replace("`", " ")
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def initial_numeric_tokens(text: str) -> list[int]:
    text = normalize_text(text)
    raw = re.findall(r"[0-9.]+", text)
    out: list[int] = []
    idx = 0
    while idx < len(raw):
        cur = raw[idx].strip(".")
        if not cur:
            idx += 1
            continue
        while idx + 1 < len(raw):
            nxt_raw = raw[idx + 1]
            nxt = nxt_raw.strip(".")
            if not nxt:
                idx += 1
                continue
            cur_val = int(cur.replace(".", ""))
            if nxt_raw.startswith(".") and ((("." not in cur) and len(cur) <= 2) or cur_val < 2000):
                cur = cur + "." + nxt
                idx += 1
                continue
            if "." not in cur and nxt.isdigit() and len(nxt) == 3:
                cur = cur + "." + nxt
                idx += 1
                continue
            break
        out.append(int(cur.replace(".", "")))
        idx += 1
    return out


def repair_token_count(nums: list[int], expected: int) -> list[int]:
    fixed = nums[:]
    while len(fixed) > expected and fixed[-1] < 1000:
        fixed[-2] = int(f"{fixed[-2]}{fixed[-1]}")
        fixed.pop()
    return fixed


def extract_row_chunks(pdf_path: Path, row_type: str) -> list[tuple[int, str]]:
    rows: list[tuple[int, str]] = []
    reader = PdfReader(str(pdf_path))
    for page_no, page in enumerate(reader.pages, start=1):
        lines = (page.extract_text() or "").splitlines()
        idx = 0
        while idx < len(lines):
            line = lines[idx]
            lower = line.lower()
            is_match = ("total provincial" in lower) if row_type == "total" else ("capital" in lower)
            if is_match:
                if row_type == "total":
                    chunk = re.split(r"Total provincial|total provincial", line, maxsplit=1)[-1]
                else:
                    chunk = re.split(r"\(capital\)", line, maxsplit=1, flags=re.IGNORECASE)[-1]
                nxt = idx + 1
                while nxt < len(lines):
                    nxt_line = lines[nxt]
                    nxt_lower = nxt_line.lower()
                    if (
                        "varones" in nxt_line
                        or "va rones" in nxt_line
                        or "1varones" in nxt_line.lower()
                        or "mujeres" in nxt_lower
                        or "total provincial" in nxt_lower
                        or "capital" in nxt_lower
                    ):
                        break
                    chunk += " " + lines[nxt]
                    nxt += 1
                rows.append((page_no, chunk))
                idx = nxt
            else:
                idx += 1
    return rows


def parse_cuadro_viii(provinces: list[str], row_type: str, suffix: str) -> pd.DataFrame:
    rows = extract_row_chunks(RAW / "ine_censo1950_cuadro_viii_establecimientos.pdf", row_type=row_type)
    records: list[dict] = []
    for province, (page_no, chunk) in zip(provinces, rows):
        nums = repair_token_count(initial_numeric_tokens(chunk), expected=10)
        record = {
            "province": province,
            f"source_page_viii{suffix}": page_no,
            f"raw_chunk_viii{suffix}": normalize_text(chunk),
            f"parsed_token_count_viii{suffix}": len(nums),
        }
        for idx, col in enumerate(SECTOR_COLUMNS):
            out_col = f"{col}{suffix}" if suffix else col
            record[out_col] = nums[idx] if idx < len(nums) else None
        if len(nums) >= 10 and nums[0]:
            remainder = sum(nums[1:10])
            record[f"sector_sum_viii{suffix}"] = remainder
            record[f"sector_gap_viii{suffix}"] = remainder - nums[0]
            record[f"sector_gap_share_viii{suffix}"] = abs(remainder - nums[0]) / nums[0]
            record[f"usable_viii{suffix}"] = 1 if abs(remainder - nums[0]) / nums[0] <= 0.10 else 0
        else:
            record[f"sector_sum_viii{suffix}"] = None
            record[f"sector_gap_viii{suffix}"] = None
            record[f"sector_gap_share_viii{suffix}"] = None
            record[f"usable_viii{suffix}"] = 0
        records.append(record)
    return pd.DataFrame(records)


def add_missing_omissions(df: pd.DataFrame, omissions: set[str], suffix: str) -> pd.DataFrame:
    rows = []
    for province in omissions:
        row = {"province": province, f"usable_viii{suffix}": 0}
        for col in SECTOR_COLUMNS:
            out_col = f"{col}{suffix}" if suffix else col
            row[out_col] = None
        row[f"source_page_viii{suffix}"] = None
        row[f"raw_chunk_viii{suffix}"] = "OCR omission in Cuadro VIII"
        row[f"parsed_token_count_viii{suffix}"] = 0
        row[f"sector_sum_viii{suffix}"] = None
        row[f"sector_gap_viii{suffix}"] = None
        row[f"sector_gap_share_viii{suffix}"] = None
        rows.append(row)
    return pd.concat([df, pd.DataFrame(rows)], ignore_index=True)


def apply_manual_overrides(df: pd.DataFrame, overrides: dict[str, list[int]], suffix: str) -> pd.DataFrame:
    for province, values in overrides.items():
        mask = df["province"] == province
        if not mask.any():
            continue
        for col, value in zip(SECTOR_COLUMNS, values):
            out_col = f"{col}{suffix}" if suffix else col
            df.loc[mask, out_col] = value
        total = values[0]
        sector_sum = sum(values[1:])
        df.loc[mask, f"parsed_token_count_viii{suffix}"] = len(values)
        df.loc[mask, f"sector_sum_viii{suffix}"] = sector_sum
        df.loc[mask, f"sector_gap_viii{suffix}"] = sector_sum - total
        df.loc[mask, f"sector_gap_share_viii{suffix}"] = abs(sector_sum - total) / total if total else pd.NA
        df.loc[mask, f"usable_viii{suffix}"] = 1
    return df


def add_share_block(df: pd.DataFrame, suffix: str) -> None:
    total_col = f"active_total_1950{suffix}" if suffix else "active_total_1950"
    total = pd.to_numeric(df[total_col], errors="coerce").replace({0: pd.NA})
    for col in SECTOR_COLUMNS[1:]:
        source_col = f"{col}{suffix}" if suffix else col
        share_col = col.replace("_total_1950", f"_share_1950{suffix}")
        df[share_col] = pd.to_numeric(df[source_col], errors="coerce") / total

    df[f"industrial_core_share_1950{suffix}"] = (
        pd.to_numeric(df[f"manufacturing_total_1950{suffix}" if suffix else "manufacturing_total_1950"], errors="coerce")
        + pd.to_numeric(df[f"construction_total_1950{suffix}" if suffix else "construction_total_1950"], errors="coerce")
    ) / total
    df[f"oil_sensitive_share_1950{suffix}"] = (
        pd.to_numeric(df[f"manufacturing_total_1950{suffix}" if suffix else "manufacturing_total_1950"], errors="coerce")
        + pd.to_numeric(df[f"construction_total_1950{suffix}" if suffix else "construction_total_1950"], errors="coerce")
        + pd.to_numeric(df[f"utilities_total_1950{suffix}" if suffix else "utilities_total_1950"], errors="coerce")
        + pd.to_numeric(df[f"transport_total_1950{suffix}" if suffix else "transport_total_1950"], errors="coerce")
    ) / total
    df[f"manuf_trade_share_1950{suffix}"] = (
        pd.to_numeric(df[f"manufacturing_total_1950{suffix}" if suffix else "manufacturing_total_1950"], errors="coerce")
        + pd.to_numeric(df[f"commerce_total_1950{suffix}" if suffix else "commerce_total_1950"], errors="coerce")
    ) / total
    df[f"nonag_share_1950{suffix}"] = 1 - pd.to_numeric(
        df[f"agri_total_1950{suffix}" if suffix else "agri_total_1950"], errors="coerce"
    ) / total


def merge_internal_geography(viii: pd.DataFrame, viii_cap: pd.DataFrame) -> pd.DataFrame:
    prov70 = pd.read_stata(ROOT / "original_data" / "census" / "census_1970_PROVINCElevel.dta", convert_categoricals=False)
    prov60 = pd.read_stata(ROOT / "original_data" / "census" / "census_1960_PROVINCElevel.dta", convert_categoricals=False)

    geo70 = prov70[
        [
            "codprov",
            "province",
            "popsharewomen_agegroup1_1970",
            "popsharewomen_agegroup2_1970",
            "popsharemen_agegroup1_1970",
            "popsharemen_agegroup2_1970",
        ]
    ].drop_duplicates()

    geo60 = prov60[
        [
            "codprov",
            "province",
            "popsharewomen_agegroup1_1960",
            "popsharewomen_agegroup2_1960",
            "popsharemen_agegroup1_1960",
            "popsharemen_agegroup2_1960",
        ]
    ].drop_duplicates()

    df = geo70.merge(geo60, on=["codprov", "province"], how="outer")
    df = df.merge(viii, on="province", how="left")
    df = df.merge(viii_cap, on="province", how="left")
    for col in df.columns:
        if col not in {"province", "raw_chunk_viii", "raw_chunk_viii_cap"}:
            try:
                df[col] = pd.to_numeric(df[col])
            except (TypeError, ValueError):
                pass

    add_share_block(df, "")
    add_share_block(df, "_cap")

    for col in SECTOR_COLUMNS:
        df[f"{col}_rest"] = df[col] - df[f"{col}_cap"]

    sector_rest_sum = pd.Series(0, index=df.index, dtype="float64")
    for col in SECTOR_COLUMNS[1:]:
        sector_rest_sum = sector_rest_sum.add(df[f"{col}_rest"], fill_value=0)
    df["sector_sum_viii_rest"] = sector_rest_sum
    df["sector_gap_viii_rest"] = sector_rest_sum - df["active_total_1950_rest"]
    valid_rest_total = df["active_total_1950_rest"] > 0
    df["sector_gap_share_viii_rest"] = pd.NA
    df.loc[valid_rest_total, "sector_gap_share_viii_rest"] = (
        df.loc[valid_rest_total, "sector_gap_viii_rest"].abs() / df.loc[valid_rest_total, "active_total_1950_rest"]
    )
    nonnegative_rest = pd.Series(True, index=df.index)
    for col in SECTOR_COLUMNS:
        nonnegative_rest &= df[f"{col}_rest"].ge(0) | df[f"{col}_rest"].isna()
    df["usable_viii_rest"] = (
        (df["usable_viii"] == 1)
        & (df["usable_viii_cap"] == 1)
        & valid_rest_total
        & nonnegative_rest
        & df["sector_gap_share_viii_rest"].le(0.10)
    ).astype("float")
    add_share_block(df, "_rest")

    df["female_young_share_1960"] = df["popsharewomen_agegroup1_1960"] + df["popsharewomen_agegroup2_1960"]
    df["female_young_share_1970"] = df["popsharewomen_agegroup1_1970"] + df["popsharewomen_agegroup2_1970"]
    df["male_young_share_1960"] = df["popsharemen_agegroup1_1960"] + df["popsharemen_agegroup2_1960"]
    df["male_young_share_1970"] = df["popsharemen_agegroup1_1970"] + df["popsharemen_agegroup2_1970"]

    df["proxy_usable_pre73"] = df["usable_viii"]
    df["proxy_usable_pre73_cap"] = df["usable_viii_cap"]
    df["proxy_usable_pre73_rest"] = df["usable_viii_rest"]
    return df.sort_values("codprov").reset_index(drop=True)


def write_outputs(df: pd.DataFrame) -> None:
    csv_path = OUT / "province_pre73_crisis_proxies.csv"
    dta_path = OUT / "province_pre73_crisis_proxies.dta"
    raw_csv = OUT / "province_pre73_cuadro_viii_raw.csv"

    string_cols = {"province", "raw_chunk_viii", "raw_chunk_viii_cap"}
    for col in df.columns:
        if col not in string_cols:
            df[col] = pd.to_numeric(df[col], errors="coerce")

    df.to_csv(csv_path, index=False)
    df.to_stata(dta_path, write_index=False, version=118)

    df[
        [
            "codprov",
            "province",
            "source_page_viii",
            "parsed_token_count_viii",
            "sector_gap_share_viii",
            "usable_viii",
            "source_page_viii_cap",
            "parsed_token_count_viii_cap",
            "sector_gap_share_viii_cap",
            "usable_viii_cap",
            "sector_gap_share_viii_rest",
            "usable_viii_rest",
            "active_total_1950",
            "active_total_1950_cap",
            "active_total_1950_rest",
            "agri_total_1950",
            "manufacturing_total_1950",
            "construction_total_1950",
            "utilities_total_1950",
            "commerce_total_1950",
            "transport_total_1950",
            "services_total_1950",
            "unspecified_total_1950",
        ]
    ].to_csv(raw_csv, index=False)

    usable = int(df["proxy_usable_pre73"].fillna(0).sum())
    usable_cap = int(df["proxy_usable_pre73_cap"].fillna(0).sum())
    usable_rest = int(df["proxy_usable_pre73_rest"].fillna(0).sum())
    lines = [
        "# Pre-1973 Crisis Proxies",
        "",
        "Source base:",
        "- INE 1950 Censo, Cuadro VIII (economic activity by establishment / broad sector)",
        "- Internal 1960 and 1970 province-level census geography already used in the project",
        "",
        f"Usable provinces under the province-total audit rule: `{usable}` / `{len(df)}`",
        f"Usable provinces for capital rows: `{usable_cap}` / `{len(df)}`",
        f"Usable provinces for derived rest-of-province rows: `{usable_rest}` / `{len(df)}`",
        "",
        "Audit rule:",
        "- `usable_viii = 1` if the parsed row has 10 sector fields and the sum of sector counts is within 10% of total active population",
        "- `usable_viii_cap = 1` applies the same rule to the capital row",
        "- `usable_viii_rest = 1` if both total and capital rows are usable, the implied rest-of-province counts are non-negative, and the derived sector sum is within 10% of the implied total active population",
        "- provinces with OCR omissions stay in the file with `usable_viii = 0` or `usable_viii_cap = 0`",
        "",
        "Main proxy variables:",
        "- `industrial_core_share_1950`",
        "- `oil_sensitive_share_1950`",
        "- `manuf_trade_share_1950`",
        "- `nonag_share_1950`",
        "- capital-specific counterparts use the `_cap` suffix",
        "- rest-of-province counterparts use the `_rest` suffix",
        "",
        f"Saved dataset: `{dta_path}`",
    ]
    (NOTES / "pre73_crisis_proxy_notes.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    viii = parse_cuadro_viii(VIII_TOTAL_PROVINCES, "total", "")
    viii = add_missing_omissions(viii, VIII_TOTAL_OMISSIONS, "")
    viii = apply_manual_overrides(viii, TOTAL_OVERRIDES, "")
    viii_cap = parse_cuadro_viii(VIII_CAPITAL_PROVINCES, "capital", "_cap")
    viii_cap = add_missing_omissions(viii_cap, VIII_CAPITAL_OMISSIONS, "_cap")
    viii_cap = apply_manual_overrides(viii_cap, CAPITAL_OVERRIDES, "_cap")
    final = merge_internal_geography(viii, viii_cap)
    write_outputs(final)


if __name__ == "__main__":
    main()
