# Macro Panel Source

Main role:

- original macro design from the paper
- internal migration robustness
- macro 1973 robustness
- church split and direct civil-war control

Main source path:

- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/output_data/dataset.dta`

Derived revision dataset:

- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/generated/dataset_female1544_revision.dta`

Relevant revision scripts:

- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/JOLE_comments/data/scripts/revision_02_migration_macro.do`
- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_revisions/do/external_revision_02_crisis73_macro_proxies.do`

Notes:

- this is the source for the baseline macro specification that must stay aligned with the active code in `Marco/DO/new/Main_analysis.do`
- the retained macro migration outcome is the non-normalized `alive` specification with fertile-age composition controls
- normalized birth-rate versions are kept only as secondary robustness
