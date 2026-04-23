# JOLE Comments Package

This folder is the curated revision package for the JOLE paper.

It contains:

- `code/`
  - the new master Stata do-file that collects the retained reviewer-facing tests
  - small helper do-files used for specific retained blocks, including the
    direct war-control and church-split exports

- `tables/`
  - LaTeX tables exported in the paper style, mostly via `outreg2`

- `figures/`
  - figure outputs collected from the original project results folders for the
    retained blocks and the main paper discussion

- `logs/`
  - logs produced by the JOLE revision package

- `data/`
  - source-by-source documentation of all old and new datasets used in the retained or rejected reviewer tests
  - copies of the main scripts used to download, clean, or build these data

- `kept_selected_revision_points.tex`
  - detailed English report for the tests we keep

- `dropped_selected_revision_points.tex`
  - detailed English report for the tests we do not keep

Main code entry point:

- [Main_analysis_selected_revision.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/JOLE_comments/code/Main_analysis_selected_revision.do)
- [selected_macro_church_war.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/JOLE_comments/code/selected_macro_church_war.do)
- [selected_macro_war_control.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/JOLE_comments/code/selected_macro_war_control.do)
- [collect_selected_figures.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/JOLE_comments/code/collect_selected_figures.do)

The original paper baseline still lives in:

- [Main_analysis.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/DO/new/Main_analysis.do)

The JOLE package is therefore a revision companion, not a replacement for the original project structure.
