# Scripts

The scripts in this folder do three things:
- download official raw files
- transform them into tidy intermediate datasets
- write cleaned CSV/DTA outputs into `../processed/`

Implemented scripts:
- `download_official_sources.sh`: pulls BOE XML, INE Censo 1981 tables, and the Banco de Espana historical employment PDF
- `clean_external_sources.py`: parses BOE metadata, cleans INE tabulations, writes `.csv` and `.dta`, and extracts searchable text plus metadata from the Banco de Espana PDF
- `clean_ine_external_sources.do`: Stata version of the INE table cleaner for `ine_*.csv_bd`, writing cleaned `.csv` and `.dta` files plus a Stata-built inventory into `../processed/`

Current target datasets:
- legal timeline for Law 56/1961 and follow-up decrees
- 1981 migration tables
- 1981 activity and sector cross-tabs
- 1981 fertility/activity cross-tabs
- searchable source note for the Banco de Espana historical EPA reconstruction
