# Censo 1981 External Tables

Main role:

- migration diagnostics from official external tables
- fertility by activity and female labor-force structure

Processed source paths:

- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_data/processed/ine_01057_clean.dta`
- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_data/processed/ine_01058_clean.dta`
- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_data/processed/ine_01059_clean.dta`
- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_data/processed/ine_01061_clean.dta`
- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_data/processed/ine_01072_clean.dta`
- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_data/processed/ine_01024_clean.dta`
- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_data/processed/ine_01025_clean.dta`

Cleaning and download scripts:

- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/JOLE_comments/data/scripts/download_official_sources.sh`
- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/JOLE_comments/data/scripts/clean_external_sources.py`

Relevant analysis scripts:

- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_revisions/do/external_revision_03_external_migration_censo1981.do`
- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_revisions/do/external_revision_04_activity_fertility_censo1981.do`

Notes:

- this source is used only for the external migration and mechanism support blocks that we decided to keep
- the Portugal and IVS external placebo blocks are not part of the selected final design
