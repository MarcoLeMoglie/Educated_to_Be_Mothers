#!/usr/bin/env python3
from __future__ import annotations

from difflib import SequenceMatcher
import re
from pathlib import Path

import pandas as pd
import pyreadstat
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

PROVINCE_ALIASES = {
    "acoruna": "a coruña",
    "corunala": "a coruña",
    "coruna": "a coruña",
    "lacoruna": "a coruña",
    "leov": "leon",
    "lobida": "lleida",
    "orense": "ourense",
    "oviedo": "asturias",
    "lerida": "lleida",
    "palmaslas": "laspalmas",
    "santander": "cantabria",
}

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
    "a coruña": [415028, 269429, 792, 50846, 21713, 1293, 17920, 8958, 43578, 499],
    "badajoz": [286181, 205055, 1330, 22869, 9168, 473, 10743, 4926, 30651, 966],
    "caceres": [185305, 139226, 665, 11662, 4884, 31, 6196, 3644, 18347, 650],
    "cordoba": [275521, 167752, 4135, 30722, 13697, 1394, 12274, 7238, 37143, 1166],
    "guipuzcoa": [153662, 31238, 665, 62246, 8159, 988, 12741, 7498, 28613, 1514],
    "leon": [193589, 114452, 20229, 13931, 7810, 1187, 8204, 8231, 18591, 954],
    "logrono": [86810, 46818, 311, 15763, 2839, 467, 4529, 2149, 12162, 1772],
    "madrid": [761717, 69348, 2838, 152534, 76605, 8962, 92992, 59519, 245139, 53780],
    "malaga": [262102, 145268, 131, 30022, 12025, 1048, 18141, 13599, 41580, 288],
    "navarra": [151380, 81304, 445, 22726, 7533, 748, 7427, 4487, 23732, 2978],
    "pontevedra": [290611, 188788, 653, 33792, 17877, 868, 10717, 7119, 29004, 1793],
    "laspalmas": [130783, 64207, 633, 14807, 12429, 1493, 13548, 5845, 17475, 346],
    "sevilla": [400773, 195232, 3118, 52532, 19762, 2756, 23319, 14604, 72164, 17286],
    "soria": [58751, 40499, 92, 4495, 1392, 164, 2436, 2510, 6128, 1035],
    "valladolid": [125511, 59994, 396, 19627, 5664, 427, 8619, 5822, 22916, 2046],
}

CAPITAL_OVERRIDES = {
    "albacete": [24353, 8213, 0, 3606, 1979, 61, 2896, 2142, 5324, 132],
    "avila": [7166, 342, 31, 768, 1015, 52, 1032, 765, 3151, 10],
    "badajoz": [29228, 11891, 10, 2868, 2585, 105, 2441, 742, 8471, 115],
    "baleares": [56390, 16634, 434, 16217, 6940, 383, 6581, 3500, 15187, 514],
    "caceres": [14754, 3770, 162, 1965, 1439, 0, 1327, 1215, 4865, 11],
    "ciudad real": [11892, 2009, 10, 1557, 1484, 111, 1273, 1444, 3973, 31],
    "huesca": [8718, 1210, 0, 1403, 743, 43, 1049, 421, 3482, 367],
    "jaen": [21314, 6613, 42, 3074, 1861, 146, 2151, 779, 6648, 0],
    "laspalmas": [53492, 10696, 29, 10468, 6539, 439, 8639, 3838, 12707, 137],
    "lleida": [21365, 4245, 199, 3928, 2595, 219, 3032, 2195, 4942, 10],
    "logrono": [19558, 1647, 42, 6112, 1381, 170, 2990, 921, 6240, 55],
    "lugo": [22810, 8758, 42, 2860, 2334, 126, 2518, 953, 5113, 106],
    "soria": [6233, 561, 0, 1320, 380, 30, 818, 583, 2300, 241],
}


def normalize_text(text: str) -> str:
    trans = str.maketrans({"I": "1", "l": "1", "!": "1", "O": "0", "o": "0", "C": "0", "c": "0"})
    text = text.translate(trans)
    text = text.replace("&", "8")
    text = re.sub(r"(?<=\d)[:;](?=\d)", ".", text)
    text = text.replace("~", " ").replace("•", " ").replace("'", " ").replace("`", " ")
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def normalize_key(text: str) -> str:
    text = text.strip().lower()
    text = (
        text.replace("á", "a")
        .replace("é", "e")
        .replace("í", "i")
        .replace("ó", "o")
        .replace("ú", "u")
        .replace("ü", "u")
        .replace("ñ", "n")
    )
    text = re.sub(r"[^a-z]", "", text)
    return text


PROVINCE_KEYS = {normalize_key(p): p for p in PROVINCES}
PROVINCE_MATCH_KEYS = {**PROVINCE_KEYS, **PROVINCE_ALIASES}


def women_only_segment(text: str) -> str:
    text = normalize_text(text)
    text = re.split(r"(?i)\b(?:varones|var0nes|va rones|1varones)\b", text, maxsplit=1)[0]
    text = re.sub(r"(?<![\d.])(\d{1,3})\s+\.(\d{3})(?!\d)", r"\1.\2", text)
    text = re.sub(r"(?<![\d.])(\d{1,3})\s+\.(\d{2})\s+(\d)(?!\d)", r"\1.\2\3", text)
    text = re.sub(r"(?<=\d)\.\s+(\d{3})(?!\d)", r".\1", text)
    text = re.sub(r"(\d\.\d{2})\.(\d)(?!\d)", r"\1\2", text)
    text = re.sub(r"(\d\.\d{2})\s+(\d)(?!\d)", r"\1\2", text)
    text = re.sub(r"(?<=\s)\.(?=\s)", "0", text)
    text = re.sub(r"(?<=\s)-(?=\s)", "0", text)
    first_number = re.search(r"(?<![A-Za-zÁÉÍÓÚÜÑáéíóúüñ])(?:\d{1,3}(?:\.\d{3})+|\d{2,})", text)
    if first_number is not None:
        text = text[first_number.start() :]
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def token_candidates(token: str) -> list[int]:
    if not token:
        return []
    if re.fullmatch(r"\d+\.\d+", token):
        return [int(token.replace(".", ""))]
    if re.fullmatch(r"\d+", token):
        return [int(token)]
    if re.fullmatch(r"\.\d+", token):
        digits = token[1:]
        out = [int(digits)]
        if len(digits) == 3 and not digits.startswith("0"):
            out.append(int(f"1{digits}"))
        return out
    return []


def pair_candidates(left: str, right: str) -> list[int]:
    out: list[int] = []
    if re.fullmatch(r"\d{1,3}", left) and re.fullmatch(r"\d{3}", right):
        out.append(int(f"{left}{right}"))
    if re.fullmatch(r"\d{1,3}", left) and re.fullmatch(r"\.\d{3}", right):
        out.append(int(f"{left}{right[1:]}"))
    if re.fullmatch(r"\.\d{1,3}", left) and re.fullmatch(r"\.\d{3}", right):
        out.append(int(f"{left[1:]}{right[1:]}"))
    if re.fullmatch(r"\d{1,2}\.\d{2}", left) and re.fullmatch(r"\d{1,2}", right):
        out.append(int(left.replace(".", "") + right))
    return out


def score_candidate(nums: list[int], leftover: int) -> tuple[float, int]:
    if not nums or nums[0] <= 0:
        return (float("inf"), leftover)
    gap = abs(sum(nums[1:]) - nums[0]) / nums[0]
    return (gap, leftover)


def numeric_candidate_lists(text: str, expected: int = 10) -> list[tuple[list[int], tuple[float, int]]]:
    raw = re.findall(r"[0-9.]+", text)
    seen: dict[tuple[int, ...], tuple[float, int]] = {}

    def search(idx: int, used: list[int]) -> None:
        if len(used) == expected:
            key = tuple(used)
            score = score_candidate(used, len(raw) - idx)
            if key not in seen or score < seen[key]:
                seen[key] = score
            return
        if idx >= len(raw):
            return

        for value in token_candidates(raw[idx]):
            used.append(value)
            search(idx + 1, used)
            used.pop()

        if idx + 1 < len(raw):
            for value in pair_candidates(raw[idx], raw[idx + 1]):
                used.append(value)
                search(idx + 2, used)
                used.pop()

    search(0, [])
    if not seen:
        return []
    candidates = [(list(nums), score) for nums, score in seen.items()]
    candidates.sort(key=lambda item: item[1])
    return candidates


def initial_numeric_tokens(text: str, expected: int = 10) -> list[int]:
    text = women_only_segment(text)
    candidates = numeric_candidate_lists(text, expected=expected)
    if not candidates:
        return []
    return candidates[0][0]


def male_numeric_tokens(text: str, expected: int = 10) -> list[int]:
    parts = re.split(r"(?i)\b(?:varones|var0nes|va rones|1varones)\b", normalize_text(text), maxsplit=1)
    if len(parts) < 2:
        return []
    male = re.split(r"(?i)\bmujeres\b", parts[1], maxsplit=1)[0]
    nums = initial_numeric_tokens(male, expected=expected)
    return repair_token_count(nums, expected)


def repair_missing_zero_from_male(female_nums: list[int], male_nums: list[int], expected: int = 10) -> list[int]:
    if len(female_nums) != expected - 1 or len(male_nums) != expected:
        return female_nums
    insert_positions = [idx for idx, value in enumerate(male_nums[1:], start=1) if value == 0]
    if not insert_positions:
        insert_positions = list(range(1, expected))
    candidates: list[tuple[list[int], tuple[float, int]]] = []
    for pos in insert_positions:
        trial = female_nums[:pos] + [0] + female_nums[pos:]
        candidates.append((trial, score_candidate(trial, 0)))
    candidates.sort(key=lambda item: item[1])
    return candidates[0][0]


def male_penalty(nums: list[int], male_nums: list[int]) -> float:
    if len(nums) != 10 or len(male_nums) != 10:
        return 0.0
    penalty = 0.0
    for idx in range(1, 10):
        if nums[idx] < male_nums[idx]:
            penalty += (male_nums[idx] - nums[idx]) / max(1, male_nums[idx])
    return penalty


def parse_chunk_numbers(chunk: str, expected: int = 10) -> list[int]:
    nums = repair_token_count(initial_numeric_tokens(chunk), expected=expected)
    if not nums and expected == 10:
        nums = repair_token_count(initial_numeric_tokens(chunk, expected=9), expected=9)
    male_nums = male_numeric_tokens(chunk, expected=expected)
    return repair_missing_zero_from_male(nums, male_nums, expected=expected)


def chunk_quality(chunk: str) -> tuple[int, int, float, int]:
    nums = parse_chunk_numbers(chunk, expected=10)
    if len(nums) < 10 or not nums[0]:
        return (0, 0, float("-inf"), len(nums))
    gap = abs(sum(nums[1:10]) - nums[0]) / nums[0]
    usable = int(gap <= 0.10)
    return (usable, int(len(nums) >= 10), -gap, len(nums))


def should_prepend_continuation(line: str) -> bool:
    low = line.lower()
    if not re.search(r"\d", line):
        return False
    if any(token in low for token in ["varones", "mujeres", "zona", "capital", "total provincial"]):
        return False
    if province_heading(line) is not None:
        return False
    return True


def should_append_numeric_continuation(line: str) -> bool:
    low = line.lower()
    if not re.search(r"\d", line):
        return False
    if any(token in low for token in ["varones", "mujeres", "zona", "capital", "total provincial"]):
        return False
    if province_heading(line) is not None:
        return False
    return True


def repair_token_count(nums: list[int], expected: int) -> list[int]:
    fixed = nums[:]
    while len(fixed) > expected and fixed[-1] < 1000:
        fixed[-2] = int(f"{fixed[-2]}{fixed[-1]}")
        fixed.pop()
    return fixed


def province_heading(line: str) -> str | None:
    candidates = [line]
    candidates.append(re.split(r"[\t\d]", line, maxsplit=1)[0])
    candidates.append(line.split("(", 1)[0])
    candidates.append(re.sub(r"\(.*", "", line))
    for candidate in candidates:
        key = normalize_key(candidate)
        if not key:
            continue
        if key in {"provincias", "zonas", "municipios", "sexo", "varones", "mujeres"}:
            continue
        if key in PROVINCE_MATCH_KEYS:
            return PROVINCE_MATCH_KEYS[key]
        best_name: str | None = None
        best_score = 0.0
        for candidate_key, province in PROVINCE_MATCH_KEYS.items():
            score = SequenceMatcher(None, key, candidate_key).ratio()
            if score > best_score:
                best_score = score
                best_name = province
        if best_name is not None and best_score >= 0.75:
            return best_name
    return None


def is_total_row(line: str) -> bool:
    return re.search(r"(?i)total\s+prov\w+", line) is not None


def is_capital_row(line: str) -> bool:
    low = line.lower()
    if "capital" in low or "capittal" in low or "iapital" in low:
        return True
    if "(" in line and province_heading(line.split("(", 1)[0]) is not None:
        return True
    return False


def infer_province_from_context(lines: list[str], idx: int, current_province: str | None) -> str | None:
    guess = province_heading(lines[idx])
    if guess is not None:
        return guess
    if idx + 1 < len(lines):
        guess = province_heading(f"{lines[idx]} {lines[idx + 1]}")
        if guess is not None:
            return guess
    for back in range(1, 5):
        j = idx - back
        if j < 0:
            break
        guess = province_heading(lines[j])
        if guess is not None:
            return guess
        if j + 1 < idx:
            guess = province_heading(f"{lines[j]} {lines[j + 1]}")
            if guess is not None:
                return guess
    return current_province


def extract_row_chunks(pdf_path: Path, row_type: str) -> dict[str, tuple[int, str]]:
    rows: dict[str, tuple[int, str]] = {}
    reader = PdfReader(str(pdf_path))
    current_province: str | None = None
    for page_no, page in enumerate(reader.pages, start=1):
        lines = (page.extract_text() or "").splitlines()
        idx = 0
        while idx < len(lines):
            line = lines[idx]
            match_province = province_heading(line)
            if match_province is not None:
                current_province = match_province
            lower = line.lower()
            is_match = is_total_row(line) if row_type == "total" else is_capital_row(line)
            if is_match:
                row_province = infer_province_from_context(lines, idx, current_province)
                if row_province is None:
                    idx += 1
                    continue
                if row_type == "total":
                    parts = re.split(r"(?i)total\s+prov\w*", line, maxsplit=1)
                    if len(parts) == 2:
                        chunk = f"{parts[1]} {parts[0]}".strip()
                    else:
                        chunk = line
                    if len(re.findall(r"[0-9.]+", chunk)) < 10:
                        back = idx - 1
                        while back >= 0 and should_prepend_continuation(lines[back]):
                            chunk = f"{lines[back]} {chunk}".strip()
                            back -= 1
                else:
                    chunk = re.split(r"(?i)\([^)]*cap[^)]*\)", line, maxsplit=1)[-1]
                    if chunk == line:
                        chunk = re.split(r"(?i)capital|capittal|iapital", line, maxsplit=1)[-1]
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
                        or is_capital_row(nxt_line)
                    ):
                        if "varones" in nxt_lower or "var0nes" in nxt_lower or "va rones" in nxt_lower or "1varones" in nxt_lower:
                            chunk += " " + nxt_line
                            nxt += 1
                            while nxt < len(lines) and should_append_numeric_continuation(lines[nxt]):
                                chunk += " " + lines[nxt]
                                nxt += 1
                        break
                    chunk += " " + lines[nxt]
                    nxt += 1
                previous = rows.get(row_province)
                if previous is None or chunk_quality(chunk) > chunk_quality(previous[1]):
                    rows[row_province] = (page_no, chunk)
                idx = nxt
            else:
                idx += 1
    return rows


def parse_cuadro_viii(row_type: str, suffix: str) -> pd.DataFrame:
    rows = extract_row_chunks(RAW / "ine_censo1950_cuadro_viii_establecimientos.pdf", row_type=row_type)
    records: list[dict] = []
    for province in PROVINCES:
        found = rows.get(province)
        if found is None:
            records.append(
                {
                    "province": province,
                    f"usable_viii{suffix}": 0,
                    **{(f"{col}{suffix}" if suffix else col): None for col in SECTOR_COLUMNS},
                    f"source_page_viii{suffix}": None,
                    f"raw_chunk_viii{suffix}": "OCR omission in Cuadro VIII",
                    f"parsed_token_count_viii{suffix}": 0,
                    f"sector_sum_viii{suffix}": None,
                    f"sector_gap_viii{suffix}": None,
                    f"sector_gap_share_viii{suffix}": None,
                }
            )
            continue
        page_no, chunk = found
        nums = parse_chunk_numbers(chunk, expected=10)
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
    negative_rest_count = pd.Series(0, index=df.index, dtype="int64")
    min_rest_value = pd.Series(0.0, index=df.index, dtype="float64")
    first_rest_col = True
    for col in SECTOR_COLUMNS:
        nonnegative_rest &= df[f"{col}_rest"].ge(0) | df[f"{col}_rest"].isna()
        if col == "active_total_1950":
            continue
        neg_mask = df[f"{col}_rest"].lt(0) & df[f"{col}_rest"].notna()
        negative_rest_count = negative_rest_count.add(neg_mask.astype("int64"), fill_value=0)
        current_min = df[f"{col}_rest"].where(neg_mask)
        if first_rest_col:
            min_rest_value = current_min.fillna(0.0)
            first_rest_col = False
        else:
            min_rest_value = pd.concat([min_rest_value, current_min.fillna(0.0)], axis=1).min(axis=1)

    soft_negative_rest = (
        (negative_rest_count == 1)
        & min_rest_value.ge(-25)
        & df["sector_gap_share_viii_rest"].le(0.001)
    )

    df["usable_viii_rest_strict"] = (
        (df["usable_viii"] == 1)
        & (df["usable_viii_cap"] == 1)
        & valid_rest_total
        & nonnegative_rest
        & df["sector_gap_share_viii_rest"].le(0.10)
    ).astype("float")
    df["usable_viii_rest_soft"] = (
        (df["usable_viii"] == 1)
        & (df["usable_viii_cap"] == 1)
        & valid_rest_total
        & soft_negative_rest
    ).astype("float")
    df["usable_viii_rest"] = (
        df["usable_viii_rest_strict"].eq(1) | df["usable_viii_rest_soft"].eq(1)
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


def suffix_description(column: str) -> str:
    if column.endswith("_cap"):
        return " (provincial capital)"
    if column.endswith("_rest"):
        return " (rest of province)"
    return " (whole province)"


def strip_suffix(column: str) -> str:
    for suffix in ("_cap", "_rest"):
        if column.endswith(suffix):
            return column[: -len(suffix)]
    return column


def build_column_labels(columns: list[str]) -> dict[str, str]:
    exact = {
        "codprov": "Province code",
        "province": "Province name",
        "popsharewomen_agegroup1_1970": "Women population share, age group 1, 1970 census geography",
        "popsharewomen_agegroup2_1970": "Women population share, age group 2, 1970 census geography",
        "popsharemen_agegroup1_1970": "Men population share, age group 1, 1970 census geography",
        "popsharemen_agegroup2_1970": "Men population share, age group 2, 1970 census geography",
        "popsharewomen_agegroup1_1960": "Women population share, age group 1, 1960 census geography",
        "popsharewomen_agegroup2_1960": "Women population share, age group 2, 1960 census geography",
        "popsharemen_agegroup1_1960": "Men population share, age group 1, 1960 census geography",
        "popsharemen_agegroup2_1960": "Men population share, age group 2, 1960 census geography",
        "source_page_viii": "PDF source page for Cuadro VIII whole-province row",
        "source_page_viii_cap": "PDF source page for Cuadro VIII capital row",
        "raw_chunk_viii": "Raw OCR chunk used for Cuadro VIII whole-province row",
        "raw_chunk_viii_cap": "Raw OCR chunk used for Cuadro VIII capital row",
        "parsed_token_count_viii": "Parsed token count in Cuadro VIII whole-province row",
        "parsed_token_count_viii_cap": "Parsed token count in Cuadro VIII capital row",
        "sector_sum_viii": "Sum of parsed sector counts in whole-province row",
        "sector_sum_viii_cap": "Sum of parsed sector counts in capital row",
        "sector_gap_viii": "Sector sum minus active total in whole-province row",
        "sector_gap_viii_cap": "Sector sum minus active total in capital row",
        "sector_gap_share_viii": "Absolute sector gap share in whole-province row",
        "sector_gap_share_viii_cap": "Absolute sector gap share in capital row",
        "sector_sum_viii_rest": "Sum of derived sector counts in rest-of-province row",
        "sector_gap_viii_rest": "Derived sector sum minus active total in rest-of-province row",
        "sector_gap_share_viii_rest": "Absolute sector gap share in rest-of-province row",
        "usable_viii": "Whole-province Cuadro VIII row passes audit",
        "usable_viii_cap": "Capital Cuadro VIII row passes audit",
        "usable_viii_rest_strict": "Rest-of-province row passes strict audit",
        "usable_viii_rest_soft": "Rest-of-province row recovered by soft audit",
        "usable_viii_rest": "Rest-of-province row passes strict or soft audit",
        "female_young_share_1960": "Female young-population share, 1960 census geography",
        "female_young_share_1970": "Female young-population share, 1970 census geography",
        "male_young_share_1960": "Male young-population share, 1960 census geography",
        "male_young_share_1970": "Male young-population share, 1970 census geography",
        "proxy_usable_pre73": "Whole-province proxy usable for pre-1973 analysis",
        "proxy_usable_pre73_cap": "Capital proxy usable for pre-1973 analysis",
        "proxy_usable_pre73_rest": "Rest-of-province proxy usable for pre-1973 analysis",
    }

    sector_labels = {
        "active_total_1950": "Economically active women, 1950",
        "agri_total_1950": "Women in agriculture, 1950",
        "mining_total_1950": "Women in mining, 1950",
        "manufacturing_total_1950": "Women in manufacturing, 1950",
        "construction_total_1950": "Women in construction, 1950",
        "utilities_total_1950": "Women in utilities, 1950",
        "commerce_total_1950": "Women in commerce, 1950",
        "transport_total_1950": "Women in transport, 1950",
        "services_total_1950": "Women in services, 1950",
        "unspecified_total_1950": "Women in unspecified sectors, 1950",
        "agri_share_1950": "Agriculture share of active women, 1950",
        "mining_share_1950": "Mining share of active women, 1950",
        "manufacturing_share_1950": "Manufacturing share of active women, 1950",
        "construction_share_1950": "Construction share of active women, 1950",
        "utilities_share_1950": "Utilities share of active women, 1950",
        "commerce_share_1950": "Commerce share of active women, 1950",
        "transport_share_1950": "Transport share of active women, 1950",
        "services_share_1950": "Services share of active women, 1950",
        "unspecified_share_1950": "Unspecified-sector share of active women, 1950",
        "industrial_core_share_1950": "Manufacturing plus construction share, 1950",
        "oil_sensitive_share_1950": "Oil-sensitive sector share, 1950",
        "manuf_trade_share_1950": "Manufacturing plus commerce share, 1950",
        "nonag_share_1950": "Non-agricultural share, 1950",
    }

    labels: dict[str, str] = {}
    for col in columns:
        if col in exact:
            labels[col] = exact[col]
            continue
        base = strip_suffix(col)
        if base in sector_labels:
            labels[col] = f"{sector_labels[base]}{suffix_description(col)}"
            continue
        labels[col] = col.replace("_", " ")
    return labels


def write_codebook(df: pd.DataFrame, labels: dict[str, str]) -> None:
    codebook_path = NOTES / "pre73_crisis_proxy_codebook.md"
    lines = [
        "# Codebook: province_pre73_crisis_proxies",
        "",
        "Files:",
        f"- Dataset: `{OUT / 'province_pre73_crisis_proxies.dta'}`",
        f"- CSV mirror: `{OUT / 'province_pre73_crisis_proxies.csv'}`",
        "",
        f"Observations: `{len(df)}` provinces",
        f"Variables: `{len(df.columns)}`",
        "",
        "Variable legend:",
        "- suffix `_cap`: provincial capital row from Cuadro VIII",
        "- suffix `_rest`: derived rest-of-province row = whole province minus capital",
        "- no suffix: whole-province row",
        "",
        "| Variable | Label | Type | Non-missing |",
        "|---|---|---:|---:|",
    ]
    for col in df.columns:
        dtype = str(df[col].dtype)
        nonmissing = int(df[col].notna().sum())
        label = labels.get(col, "")
        lines.append(f"| `{col}` | {label} | `{dtype}` | `{nonmissing}` |")
    codebook_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_outputs(df: pd.DataFrame) -> None:
    csv_path = OUT / "province_pre73_crisis_proxies.csv"
    dta_path = OUT / "province_pre73_crisis_proxies.dta"
    raw_csv = OUT / "province_pre73_cuadro_viii_raw.csv"

    string_cols = {"province", "raw_chunk_viii", "raw_chunk_viii_cap"}
    for col in df.columns:
        if col not in string_cols:
            df[col] = pd.to_numeric(df[col], errors="coerce")

    column_labels = build_column_labels(df.columns.tolist())
    yesno_labels = {0.0: "No", 1.0: "Yes"}
    value_labels = {
        col: yesno_labels
        for col in [
            "usable_viii",
            "usable_viii_cap",
            "usable_viii_rest_strict",
            "usable_viii_rest_soft",
            "usable_viii_rest",
            "proxy_usable_pre73",
            "proxy_usable_pre73_cap",
            "proxy_usable_pre73_rest",
        ]
        if col in df.columns
    }

    df.to_csv(csv_path, index=False)
    pyreadstat.write_dta(
        df,
        str(dta_path),
        file_label="Pre-1973 crisis proxies by province",
        column_labels=column_labels,
        version=15,
        variable_value_labels=value_labels,
    )
    write_codebook(df, column_labels)

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
            "usable_viii_rest_strict",
            "usable_viii_rest_soft",
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
    usable_rest_strict = int(df["usable_viii_rest_strict"].fillna(0).sum())
    usable_rest_soft = int(df["usable_viii_rest_soft"].fillna(0).sum())
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
        f"Strict derived rest-of-province rows: `{usable_rest_strict}` / `{len(df)}`",
        f"Soft-derived rest-of-province recoveries: `{usable_rest_soft}` / `{len(df)}`",
        "",
        "Audit rule:",
        "- `usable_viii = 1` if the parsed row has 10 sector fields and the sum of sector counts is within 10% of total active population",
        "- `usable_viii_cap = 1` applies the same rule to the capital row",
        "- `usable_viii_rest_strict = 1` if both total and capital rows are usable, the implied rest-of-province counts are non-negative, and the derived sector sum is within 10% of the implied total active population",
        "- `usable_viii_rest_soft = 1` only for edge cases with exactly one negative derived sector cell, that negative cell no smaller than `-25`, and derived gap share at or below `0.001`",
        "- `usable_viii_rest = 1` if either the strict or the soft rule is satisfied",
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
        "Additional documentation:",
        f"- Codebook: `{NOTES / 'pre73_crisis_proxy_codebook.md'}`",
        "",
        f"Saved dataset: `{dta_path}`",
    ]
    (NOTES / "pre73_crisis_proxy_notes.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    viii = parse_cuadro_viii("total", "")
    viii = apply_manual_overrides(viii, TOTAL_OVERRIDES, "")
    viii_cap = parse_cuadro_viii("capital", "_cap")
    viii_cap = apply_manual_overrides(viii_cap, CAPITAL_OVERRIDES, "_cap")
    final = merge_internal_geography(viii, viii_cap)
    write_outputs(final)


if __name__ == "__main__":
    main()
