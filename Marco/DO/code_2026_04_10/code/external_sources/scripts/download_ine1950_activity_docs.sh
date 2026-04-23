#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
RAW_DIR="$ROOT_DIR/raw"

mkdir -p "$RAW_DIR"

download() {
  local td="$1"
  local out="$2"
  echo "Downloading $out"
  curl -L "https://www.ine.es/inebaseweb/pdfDispacher.do?td=${td}&ext=.pdf" -o "$RAW_DIR/$out"
}

download "125363" "ine_censo1950_cuadro_v_condicion_economica.pdf"
download "125364" "ine_censo1950_cuadro_vi_forma_trabajo.pdf"
download "125365" "ine_censo1950_cuadro_vii_grupos_profesionales.pdf"
download "125366" "ine_censo1950_cuadro_viii_establecimientos.pdf"
download "125368" "ine_censo1950_cuadro_x_inactiva_dependiente_actividad.pdf"

echo "INE 1950 activity documents saved into $RAW_DIR"
