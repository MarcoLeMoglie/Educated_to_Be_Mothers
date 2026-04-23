# Codebase Audit Notes

## Scope of the audit

Main correction after user guidance:
- the paper-level analysis plan should be anchored only in `Marco/DO/new/Main_analysis.do`
- titles and commented blocks inside that file determine what counts as baseline versus dormant code

This note is based first on a direct read of:
- `Marco/DO/new/Main_analysis.do`

Support files were read only to understand implementation feasibility after fixing the plan on the main file:
- `progs/02_dataset.do`
- `progs/data/06_ine_microdatos.do`
- `Paper/JOLE_review_detailed_notes_it.md`

## Backbone of the current project

### 0. Role of `Marco/DO/new/Main_analysis.do`

`Marco/DO/new/Main_analysis.do`
- is the starting point for the revision plan
- baseline cohort bins:
  - `treat_2 = 1930-1938`
  - `treat_3 = 1939-1950`
- active sections:
  - individual CIS
  - fertility baseline
  - cluster robustness
  - event study
  - labor and ideology outcomes
  - beliefs
  - Portugal IVS robustness
  - census robustness
  - macro robustness:
    - continuous treatment
    - discrete treatment
    - placebo 15-24 in 1940
    - weddings
    - balancing
- dormant sections:
  - male blocks
  - some partner-timing blocks
  - ESS Portugal
  - some alternative macro blocks
  - `Placebo 0-14 1930 ----- ASSOLUTAMENTE NO`

### 1. Macro panel construction

`progs/02_dataset.do` builds the municipality-level panel by merging:
- census age structure for 1930, 1940, 1950, 1960, 1970
- MNP births, abortions, weddings, annual population
- teacher purge intensity
- civil war controls
- pre-treatment education, religion, and elections

The resulting file `output_data/dataset.dta` already contains:
- `alive_birth`
- `total_wedding`
- `popwomen_agegroup3_1930` through `popwomen_agegroup5_1970`
- `teachers_pc`
- locality identifier `id`
- year panel 1930-1985

This is enough to build migration placebo outcomes without importing anything new.

### 2. Province-level panel

`progs/02_dataset_provincelevel.do` mirrors the same logic at province level and produces:
- `output_data/dataset_PROVINCElevel.dta`

This file is especially useful because all microdata files are merged to it.

### 3. Current macro regressions

The active paper-facing macro logic should be treated as the `**# MACRO` section inside `Marco/DO/new/Main_analysis.do`.

The active local design does not currently use `teachers_pc`.

The active treatment is:
- `interaction = post * sum1`
- `interaction2 = post * sum2`
- where `sum1` and `sum2` are built from 1940 age-structure shares
- with event-study versions using `b1945.year##c.sum1` and `b1945.year##c.sum2`

The working outcome most relevant for reviewer 2 is:
- `alive`

Important weakness:
- the active local outcome is a birth count, not a rate normalized by annual women 15-44
- the female-population controls `flag4_3 flag4_4 flag4_5` are stepwise decennial logs, not an explicit annual interpolation
- this is exactly why the migration reviewer point should be answered inside the active macro block

### 4. Current CIS code in the file

`Marco/DO/new/Main_analysis.do` already contains the actual building blocks needed for the referee response:
- completed fertility regressions on `kids` and `nkids`
- event studies over `year_birth_*`
- labor outcomes for women
- alternative control with `year_partner`

This is why Law 56 and 1973 should be implemented there first.

### 5. Why this file is the right place for Law 56

In `Marco/DO/new/Main_analysis.do`, the main female completed-fertility regressions use:
- `a(i.year i.id age_c)`
- `a(i.year##i.id##age_c)`

with cohort treatment bins rather than fully saturated birth-year FE in the baseline table.

This is the most natural place to implement the Law 56 horse-race because cohort-level exposure can still be identified.

## What is already available for birthplace and migration work

### 1991 microdata

In `progs/data/06_ine_microdatos.do`, the final merge does:
- `rename PRONACIN codprov // PRONACIN = province of birth, PROV = current residence`

So `output_data/dataset_microdata1991.dta` is already treatment-assigned by birthplace province.

Useful raw fields retained:
- `PROV`: current province
- `MUN`: current municipality
- `PROV90`, `PROV86`, `PROV81`: prior residences
- `PROV10`: place of origin/provenance
- `HIJOS`

### 2001 microdata

The merge does:
- `rename CPRON codprov // CPRO = residence province, CPRON = birth province`

Useful retained fields:
- `CPRO`: current province
- `CLPRO`: previous residence province
- `CPROV10`: residence 10 years earlier
- `RES10`
- `NHIJO`, `NTOTHIJ`

### 2011 microdata

The merge does:
- `rename CPRON codprov`

Useful retained fields:
- `CPRO`: current province
- `CLPRO`: previous residence province
- `CPRODANO`: residence 10 years earlier
- `RES_DANO`
- `HIJOS`, `NHIJOS`

Bottom line:
- birthplace FE
- birthplace plus current residence
- stayers vs movers

are all feasible with existing microdata outputs.

## Gaps that still need dedicated coding

1. No dedicated Law 56 cohort exposure variable exists yet.
2. No 1973 cohort exposure variable exists yet.
3. No clean annual `female1544` interpolation is visibly used in the main panel regressions.
4. No macro migration placebo regression currently exists.
5. No stayer vs mover comparison currently exists in the microdata workflow.
6. No paper-ready table currently forces the horse-race between schooling exposure and Law 56.

## Recommended coding approach

Data prep:
- `progs/data/07_law56_exposure.do`
- `progs/data/08_female1544_interpolation.do`

Analysis layer:
- append new subsections directly inside `Marco/DO/new/Main_analysis.do`
- keep the existing section structure intact
- place each new subsection next to the conceptually closest active section
- do not anchor new macro regressions on dormant blocks when an active counterpart already exists

Paper support:
- appendix figure for cohort exposure to Law 56
- appendix figure for women 15-44 trends by exposure group

## Main coding caution

Do not treat a commented block inside `/* ... */` as the current baseline.

Also, do not put `law56_exposure` into a regression that already includes full `i.year_birth` and then conclude from a dropped coefficient that the channel is irrelevant.

That would be a specification artifact, not evidence.

On the macro side, do not describe the current local design as teacher-purge based if the active file is not estimating that design anymore.

The reviewer response has to begin from the design that is actually active in `Marco/DO/new/Main_analysis.do`, then extend it transparently.
