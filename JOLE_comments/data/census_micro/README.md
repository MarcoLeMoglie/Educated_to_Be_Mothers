# Census Microdata Source

Main role:

- birthplace and residence robustness
- movers vs stayers
- civil-war-at-birthplace controls
- birthplace pre-1973 proxy tests

Main source paths:

- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/original_data/INE_microdatos/censo1991/por_provincias/censo1991_provincias.dta`
- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/original_data/INE_microdatos/censo2011/por_provincias/censo2011_provincias.dta`

Relevant revision scripts:

- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/JOLE_comments/data/scripts/revision_03_birthplace_stayers.do`
- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/JOLE_comments/data/scripts/revision_07_birthplace_civilwar.do`
- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/JOLE_comments/data/scripts/revision_08_birthplace_crisis73.do`

Notes:

- these are the strongest reviewer-facing micro robustness checks
- the main retained outcome is `nhijos`
- `kids2` is kept only as secondary background, not as the main message
