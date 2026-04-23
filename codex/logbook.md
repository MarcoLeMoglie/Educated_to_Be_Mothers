# Logbook

## 2026-04-02

### Task

Study the JOLE Franco school reform project in `Purge` and prepare an operational research plan on Law 56/1961 and internal migration, with new workspace files under `codex/`.

### What was reviewed

- Top-level project structure under `Purge`
- Main data construction do-files in `progs/`
- Main regression do-files for macro panel and CIS attitudes
- INE microdata import and merge logic
- Older individual fertility code in `Marco/DO/`
- JOLE reviewer memo in `Paper/JOLE_review_detailed_notes_it.md`

### Main findings

1. The current municipality panel is rich enough to run migration placebo tests immediately.
2. The microdata outputs are already merged by province of birth, which is very useful for the reviewer concern on birthplace vs residence.
3. The plan must start specifically from `Marco/DO/new/Main_analysis.do`, using its section titles and distinguishing active from commented-out blocks.
4. Inside the active macro section, the local design is currently organized around `interaction = post*sum1` and `interaction2 = post*sum2`, not around a live `teachers_pc` specification.
5. The reviewer note on interpolation of female 15-44 population is valid and should be answered by extending the active `alive` regressions into births-per-women outcomes and population placebos.
6. The active macro placebo to reuse is `Placebo 15-24 1940`, while `Placebo 0-14 1930 ----- ASSOLUTAMENTE NO` is explicitly dormant and should not anchor the plan.

### Files created today

- `codex/README.md`
- `codex/memo_law56_migration_plan.md`
- `codex/notes_codebase_audit.md`
- `codex/logbook.md`
- `codex/scripts/inventory_codebase.py`
- `codex/do/revision_01_law56_horserace.do`
- `codex/do/revision_02_migration_macro.do`
- `codex/do/revision_03_birthplace_stayers.do`
- `codex/do/revision_04_macro_pretrends_heterogeneity.do`
- `codex/do/revision_05_ivs_placebo_beliefs.do`
- `codex/do/revision_06_post1950_census.do`
- `codex/do/revision_run_all.do`
- `codex/report_reviewer_workstreams_detailed.md`

### Assumptions made

1. Law 56/1961 is treated as priority 1.
2. The main implementation date for exposure coding should be 1962, with 1961 as a robustness alternative.
3. The fastest high-value path is to work first on completed fertility and macro migration diagnostics, then on attitude re-framing.

### Next implementation step

Translate the strongest completed workstreams into paper-ready tables, appendix figures, and a response-letter structure centered on:
- `codex/output/revision_01_law56_results.csv`
- `codex/output/revision_02_migration_results.csv`
- `codex/output/revision_03_birthplace_results.csv`
- `codex/output/revision_04_macro_pretrend_results.csv`
- `codex/output/revision_05_ivs_results_recomputed.csv`
- `codex/output/revision_06_post1950_results.csv`
