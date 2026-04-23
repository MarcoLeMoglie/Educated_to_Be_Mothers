# Civil War Controls Source

Main role:

- direct macro civil-war intensity control
- birthplace-level war-intensity robustness in census microdata

Main source path:

- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/output_data/dataset_PROVINCElevel.dta`

Variables used:

- `deaths_male_cwar`
- `sh_area_front`
- `logdistance`
- `sancionados`

Relevant revision scripts:

- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/JOLE_comments/data/scripts/revision_07_birthplace_civilwar.do`
- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/JOLE_comments/code/selected_macro_war_control.do`
- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/JOLE_comments/code/selected_macro_church_war.do`

Notes:

- in the final selected design we keep the direct war control and the birthplace war interaction
- we do not keep the simple high-war / low-war split as a main result
