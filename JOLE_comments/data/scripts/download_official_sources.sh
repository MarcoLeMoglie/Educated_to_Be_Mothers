#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RAW_DIR="$ROOT_DIR/raw"

mkdir -p "$RAW_DIR"

download() {
  local url="$1"
  local out="$2"
  echo "Downloading $(basename "$out")"
  curl -L "$url" -o "$out"
}

# BOE legal sources: HTML already captured, XML is easier to parse reproducibly.
download "https://www.boe.es/diario_boe/xml.php?id=BOE-A-1961-14132" "$RAW_DIR/boe_law56_1961.xml"
download "https://www.boe.es/diario_boe/xml.php?id=BOE-A-1962-3718" "$RAW_DIR/boe_decreto_258_1962.xml"
download "https://www.boe.es/diario_boe/xml.php?id=BOE-A-1970-932" "$RAW_DIR/boe_decreto_2310_1970.xml"

# Banco de Espana working paper backing the historical EPA reconstruction.
download "https://www.bde.es/f/webbde/SES/Secciones/Publicaciones/PublicacionesSeriadas/DocumentosTrabajo/94/Fich/dt9409.pdf" "$RAW_DIR/bde_dt9409_historical_employment.pdf"

# INE Censo 1981 tables used for migration, activity, sector and fertility checks.
download "https://www.ine.es/jaxi/files/_px/es/csv_bd/t20/e243/e01/a1981/l0/01024.csv_bd" "$RAW_DIR/ine_01024.csv_bd"
download "https://www.ine.es/jaxi/files/_px/es/px/t20/e243/e01/a1981/l0/01024.px" "$RAW_DIR/ine_01024.px"
download "https://www.ine.es/jaxi/files/_px/es/csv_bd/t20/e243/e01/a1981/l0/01025.csv_bd" "$RAW_DIR/ine_01025.csv_bd"
download "https://www.ine.es/jaxi/files/_px/es/px/t20/e243/e01/a1981/l0/01025.px" "$RAW_DIR/ine_01025.px"
download "https://www.ine.es/jaxi/files/_px/es/csv_bd/t20/e243/e01/a1981/l0/01029.csv_bd" "$RAW_DIR/ine_01029.csv_bd"
download "https://www.ine.es/jaxi/files/_px/es/px/t20/e243/e01/a1981/l0/01029.px" "$RAW_DIR/ine_01029.px"
download "https://www.ine.es/jaxi/files/_px/es/csv_bd/t20/e243/e01/a1981/l0/01030.csv_bd" "$RAW_DIR/ine_01030.csv_bd"
download "https://www.ine.es/jaxi/files/_px/es/px/t20/e243/e01/a1981/l0/01030.px" "$RAW_DIR/ine_01030.px"
download "https://www.ine.es/jaxi/files/_px/es/csv_bd/t20/e243/e01/a1981/l0/01033.csv_bd" "$RAW_DIR/ine_01033.csv_bd"
download "https://www.ine.es/jaxi/files/_px/es/px/t20/e243/e01/a1981/l0/01033.px" "$RAW_DIR/ine_01033.px"
download "https://www.ine.es/jaxi/files/_px/es/csv_bd/t20/e243/e01/a1981/l0/01057.csv_bd" "$RAW_DIR/ine_01057.csv_bd"
download "https://www.ine.es/jaxi/files/_px/es/px/t20/e243/e01/a1981/l0/01057.px" "$RAW_DIR/ine_01057.px"
download "https://www.ine.es/jaxi/files/_px/es/csv_bd/t20/e243/e01/a1981/l0/01058.csv_bd" "$RAW_DIR/ine_01058.csv_bd"
download "https://www.ine.es/jaxi/files/_px/es/px/t20/e243/e01/a1981/l0/01058.px" "$RAW_DIR/ine_01058.px"
download "https://www.ine.es/jaxi/files/_px/es/csv_bd/t20/e243/e01/a1981/l0/01059.csv_bd" "$RAW_DIR/ine_01059.csv_bd"
download "https://www.ine.es/jaxi/files/_px/es/px/t20/e243/e01/a1981/l0/01059.px" "$RAW_DIR/ine_01059.px"
download "https://www.ine.es/jaxi/files/_px/es/csv_bd/t20/e243/e01/a1981/l0/01061.csv_bd" "$RAW_DIR/ine_01061.csv_bd"
download "https://www.ine.es/jaxi/files/_px/es/px/t20/e243/e01/a1981/l0/01061.px" "$RAW_DIR/ine_01061.px"
download "https://www.ine.es/jaxi/files/_px/es/csv_bd/t20/e243/e01/a1981/l0/01064.csv_bd" "$RAW_DIR/ine_01064.csv_bd"
download "https://www.ine.es/jaxi/files/_px/es/px/t20/e243/e01/a1981/l0/01064.px" "$RAW_DIR/ine_01064.px"
download "https://www.ine.es/jaxi/files/_px/es/csv_bd/t20/e243/e01/a1981/l0/01065.csv_bd" "$RAW_DIR/ine_01065.csv_bd"
download "https://www.ine.es/jaxi/files/_px/es/px/t20/e243/e01/a1981/l0/01065.px" "$RAW_DIR/ine_01065.px"
download "https://www.ine.es/jaxi/files/_px/es/csv_bd/t20/e243/e01/a1981/l0/01072.csv_bd" "$RAW_DIR/ine_01072.csv_bd"
download "https://www.ine.es/jaxi/files/_px/es/px/t20/e243/e01/a1981/l0/01072.px" "$RAW_DIR/ine_01072.px"

echo "All downloads completed into $RAW_DIR"
