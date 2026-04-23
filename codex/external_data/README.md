# External Data Workspace

This folder collects new official external sources to strengthen the reviewer response on:
- Law 56/1961
- the 1973 crisis
- internal migration
- sectoral female employment
- birthplace, residence history, and activity status

Planned source families:
- `BOE`: legal texts and implementation timing for Law 56/1961 and follow-up decrees
- `Banco de Espana`: historical employment series built from the EPA
- `INEbase Historia / JAXI`: census 1981 migration, activity, and fertility tables
- `INE historical yearbooks`: province-level sector composition and female employment

Structure:
- `raw/`: original downloads
- `processed/`: cleaned outputs
- `scripts/`: download and cleaning scripts
- `notes/`: source notes, codebooks, and field mapping

Implemented first-pass sources:
- `BOE` XML + HTML for the 1961 law and the 1962/1970 labor decrees
- `INE Censo 1981` tables `01024`, `01025`, `01029`, `01030`, `01033`, `01057`, `01058`, `01059`, `01061`, `01064`, `01065`, `01072`
- `Banco de Espana` `dt9409` PDF plus searchable text extract and metadata

Main outputs already generated:
- `processed/boe_legal_timeline.csv` and `.dta`
- `processed/ine_*_clean.csv` and `.dta`
- `processed/bde_dt9409_metadata.csv` and `.dta`
- `notes/external_sources_inventory.md`
- `notes/bde_dt9409_extract.txt`

Execution:
- `bash scripts/download_official_sources.sh`
- `python3 scripts/clean_external_sources.py`

Still pending if we want a second ingestion pass:
- `INE historical yearbooks` around `1965-1974` for province-level sector exposure before the `1973` crisis
- any machine-readable `EPA` source with sex x sector x geography earlier than the harmonized post-1976 releases
