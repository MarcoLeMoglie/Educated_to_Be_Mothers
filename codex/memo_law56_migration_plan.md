# Operational Research Memo

## Objective

Build a revision package for the JOLE paper that answers the strongest reviewer concerns on:
- the confounding role of Law 56/1961 in the cohort-based individual evidence
- the possibility that internal migration contaminates the locality-level fertility panel

Source of truth for this memo:
- `Marco/DO/new/Main_analysis.do`

I set Law 56/1961 as priority 1 because it is the cleanest reviewer attack on the individual strategy and because it can be addressed with existing data plus new cohort-level variables.

Method rule for this memo:
- active sections in `Marco/DO/new/Main_analysis.do` define the current paper baseline
- blocks inside `/* ... */` are treated as dormant code or previous alternatives, not as the current baseline
- section titles inside the file determine the empirical mapping of reviewer comments

## Reviewer workstreams in priority order

1. Law 56/1961
2. Internal migration and the local DiD
3. 1973 crisis
4. Birthplace and stayers vs movers
5. Civil war / repression / donut cohorts
6. Figure 3 and beliefs
7. Church vs 1945 reform package
8. Post-1950 cohorts
9. Portugal placebo
10. Parallel trends formalization

## What the current file already gives us

The single file `Marco/DO/new/Main_analysis.do` already bundles the main empirical architecture of the paper into clearly labeled sections.

### Active section map

1. `*_______________________________________________ Individual analysis CIS`
- current baseline individual block
- defines cohort treatment, age groups, partner timing, labor outcomes
- active subsections:
  - `***** Regression Fertility`
  - `***** Regression Fertility --- Robustness cluster`
  - `********* Event study`
  - `***** Unemployment, right, education, marriage`
  - `***** Primary beliefs`
  - `****** Event study`

2. `*_______________________________________________ Robustness Portugal -- IVS`
- active Portugal robustness block
- useful for the low-priority placebo workstream

3. `*_______________________________________________ Robustness Census`
- active census robustness block
- builds 1991 and 2011 cleaned samples inside the file
- runs DID and event-study style census exercises

4. `**# MACRO`
- active macro robustness area later in the file
- includes:
  - `**# Continuous Treatment ---- Base mobile`
  - `**# Discrete treatment ---- Base mobile`
  - `**# Placebo 15-24 1940`
  - `**# Weddings`
  - `**# Balancing`

### Dormant but informative blocks

The following appear in commented sections and should be treated as dormant alternatives:
- female split with `treat2_2 treat2_3 treat2_4`
- male fertility blocks
- interacted fertility blocks with `year_partner`
- an earlier primary-beliefs specification
- ESS Portugal block
- macro blocks with alternative municipality-type interaction and deaths
- `Placebo 0-14 1930 ----- ASSOLUTAMENTE NO`

These are still useful because they show how the author was thinking, but they are not the baseline to defend in the response.

## Key empirical insights before doing anything

A pure Law 56/1961 variable that only varies by birth cohort will be collinear with full birth-year fixed effects.

That means:
- do not try to drop `law56_exposure_cohort` into specifications that already absorb `i.year_birth`
- do use it in the older cohort-bin fertility designs, in RD-style designs with parsimonious cohort trends, or in models that replace full cohort FE with smooth birth-year controls

This matters because otherwise the new variable will look "implemented" but will do no econometric work.

Also, in this file the core individual designs are already organized in a way that is convenient for reviewer-facing extensions:
- binned cohort treatment in `treat_2` and `treat_3`
- cohort event studies by `year_birth_*`
- alternative partner-timing control via `year_partner`
- labor market outcomes already estimated for women

So the right strategy is to extend the active designs already in this file, not replace them.

On the macro side, the active local design is also very specific:
- the main dependent variable is `alive`
- the active exposure is based on `sum1` and `sum2`, which come from 1940 age-structure shares
- the active controls are the logged female population counts `flag4_3 flag4_4 flag4_5`
- the active event-study format is `b1945.year##c.sum1` plus the male counterpart

This matters for the migration plan because the clean reviewer-facing extension is not to invent a different local DiD from scratch, but to keep this exact skeleton and swap the outcome from birth counts to births per women 15-44, plus run female-population placebo outcomes on the same active design.

## Priority 1: Law 56/1961

### Research question

Does the estimated effect currently attributed to exposure to Francoist schooling survive once we control for cohort-specific exposure to the legal and labor-market environment created by Law 56/1961?

### Best current entry point in the file

The best entry point is the active `***** Regression Fertility` block in `Marco/DO/new/Main_analysis.do`.

That block already estimates completed fertility outcomes (`kids`, `nkids`) using:
- `treat_2 = 1930-1938`
- `treat_3 = 1939-1950`

This is the right starting point because:
- the cohort cutoffs line up better with the current paper narrative
- `year_partner` is already available there
- labor outcomes and mechanism blocks are already organized next to the fertility block

### Variables to construct

Build these at the birth-cohort level, then merge onto CIS and census microdata:

1. `law56_share_18_30`
- Share of ages 18 to 30 spent in years 1962 and later
- Use 1962, not 1961, as the default implementation date for the main variable

2. `law56_share_20_35`
- Same logic, but over ages 20 to 35
- This is a better fertility/opportunity-cost window

3. `law56_share_25_35`
- Late fertile/adult exposure window
- Useful because reviewer concern is about adult female opportunity costs, not schooling-age exposure

4. `law56_age_in_1961`
- `1961 - birthyear`
- Good for plots and sample splits

5. `law56_post1961_under25`
- Dummy equal to 1 if the woman was younger than 25 in 1961
- Simple communication device for appendix tables

6. Optional companion variable: `crisis73_share_25_35`
- Share of ages 25 to 35 spent in 1973 and later
- This should be included because reviewer 2 also links the intensive-margin fertility result to the 1973 shock

### Exact regressions to run

Start from the active female fertility regressions in this file and add the Law 56 variables sequentially.

Baseline family to replicate first:

```stata
reghdfe nkids treat_2 treat_3 if female==1 & year_birth<=1950, ///
    a(i.year i.id age_c) cluster(year#i.year_birth)
```

Then run the horse-race stack:

```stata
reghdfe nkids treat_2 treat_3 law56_share_20_35 ///
    if female==1 & year_birth<=1950, ///
    a(i.year i.id age_c) cluster(year#i.year_birth)
```

```stata
reghdfe nkids treat_2 treat_3 law56_share_20_35 crisis73_share_25_35 ///
    if female==1 & year_birth<=1950, ///
    a(i.year i.id age_c) cluster(year#i.year_birth)
```

```stata
reghdfe kids treat_2 treat_3 law56_share_20_35 ///
    if female==1 & year_birth<=1950, ///
    a(i.year i.id age_c) cluster(year#i.year_birth)
```

Recommended tighter versions:

```stata
reghdfe nkids treat_2 treat_3 law56_share_18_30 ///
    if female==1 & inrange(year_birth,1925,1950), ///
    a(i.year i.id age_c) cluster(year#i.year_birth)
```

```stata
reghdfe nkids treat_2 treat_3 law56_share_20_35 ///
    if female==1 & year_birth<=1950 & !inrange(year_birth,1936,1941), ///
    a(i.year i.id age_c) cluster(year#i.year_birth)
```

RD-style robustness:

```stata
rdrobust nkids birthyear if female==1 & inrange(birthyear,1931,1948), ///
    c(1939.5) covs(law56_share_20_35 crisis73_share_25_35)
```

Then reactivate and adapt the dormant partner-timing logic already present in the commented block:

```stata
reghdfe nkids treat_2##female treat_3##female year_partner law56_share_20_35 ///
    if year_birth<=1950, a(i.year i.id age_c) cluster(year#i.year_birth)
```

If the CIS fertility data are too noisy, repeat the same cohort-horse-race logic in the census microdata with completed fertility outcomes:
- 1991: `HIJOS`
- 2001: `NHIJO` or `NTOTHIJ` depending the exact cleaned variable you standardize
- 2011: `NHIJOS` / `NHIJO`

Use the active census section later in `Marco/DO/new/Main_analysis.do` as the first extension point for this census robustness.

### Data needed

Already in repo:
- CIS fertility and labor outcomes
- 1991, 2001, 2011 census microdata
- birth cohort

Need to construct locally:
- Law 56 cohort-exposure variables
- 1973 cohort-exposure variable

Optional external addition for appendix narrative only:
- clean BOE timing note for 1961 law and 1962 implementing decree

### Interpretation grid

If `treat_3` stays stable after adding `law56_share_*`:
- strong answer to reviewer
- schooling package remains the main cohort discontinuity of interest

If `treat_3` attenuates but stays economically meaningful:
- revised interpretation should become joint institutional exposure
- schooling package matters, but later legal change partly co-determines fertility

If `treat_3` collapses:
- reviewer likely identified a core confound
- paper should shift from strong causal language to bundled institutional sequence

## Priority 2: Internal migration

### Research question

Does the locality-level decline in births reflect true fertility changes among exposed women, or does it partly reflect migration-driven reallocation of where births are recorded?

### Strongest immediate advantage in this repo

You do not need new data to run the first migration diagnostics.

`output_data/dataset.dta` already contains:
- female population by age groups for 1930, 1940, 1950, 1960, 1970
- annual births
- locality identifiers
- the exact treatment ingredients used in the main DiD

And the microdata outputs already retain:
- province of current residence
- province/municipality of birth
- previous residence variables

The local DiD/event-study logic already lives in the active macro section later in this same file, so reviewer-facing migration tests should be coded there first.

The exact active anchors are:
- `**# Continuous Treatment ---- Base mobile`
- `**# Discrete treatment ---- Base mobile`
- `**# Placebo 15-24 1940`

The first two are the baseline local designs to extend.
The third is already a reviewer-style placebo scaffold and is the natural location for a fertile-population placebo discussion.

### Variables to construct

At municipality-year level:

1. `female1544_step`
- Step-function fertile female population
- For each year, use the same decennial assignment logic already implicit in `flag4_3 flag4_4 flag4_5`

2. `female1544_lin`
- Linear interpolation of women 15-44 between 1930, 1940, 1950, 1960, 1970
- This is the key migration robustness variable

3. `births_per_female1544_step`
- `alive_birth / female1544_step * 1000`

4. `births_per_female1544_lin`
- `alive_birth / female1544_lin * 1000`

5. `ln_female1544_lin`
- Placebo outcome for differential demographic emptying-out

6. `d_female1544_40_50`, `d_female1544_50_60`, `d_female1544_60_70`
- Decadal population shifts for descriptive heterogeneity

At individual microdata level:

7. `stayer_birthprov_currentprov`
- 1 if province of birth equals current province

8. `moved_5y` or `moved_10y`
- Built from 1991 `PROV86/PROV81/PROV10`, 2001 `CLPRO/CPROV10/RES10`, 2011 `CLPRO/CPRODANO/RES_DANO`

9. `origin_treatment`
- Keep treatment assignment based on birthplace

10. `destination_treatment`
- Add current-residence treatment separately for robustness

### Exact regressions to run

1. Migration placebo in the macro panel, following the active continuous-treatment skeleton:

```stata
reghdfe ln_female1544_lin interaction interaction2 ///
    1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
```

2. Main outcome normalized by fertile women, same continuous-treatment skeleton:

```stata
reghdfe births_per_female1544_lin interaction interaction2 ///
    1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
```

3. Truncated panel for the 1973 concern:

```stata
reghdfe births_per_female1544_lin interaction interaction2 ///
    1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5 ///
    if year<=1972, a(i.id i.year#i.codprov) cluster(id)
```

4. Early post-reform window:

```stata
reghdfe births_per_female1544_lin interaction interaction2 ///
    1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5 ///
    if inrange(year,1946,1965), a(i.id i.year#i.codprov) cluster(id)
```

File mapping:
- add these as a new subsection next to the active municipality-level continuous/discrete treatment blocks in `Marco/DO/new/Main_analysis.do`
- keep the original `alive_birth` regressions untouched, and append migration-robustness tables as new outputs
- also add a matching event-study plot using the existing macro template:

```stata
reghdfe births_per_female1544_lin b1945.year##c.sum1 b1945.year##c.sum2 ///
    flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
```

5. Province-of-birth vs current-residence individual tests:

```stata
reghdfe nkids treat_2 treat_3 if female==1 & stayer_birthprov_currentprov==1, ///
    a(i.year i.id age_c) cluster(year#i.year_birth)
```

```stata
reghdfe nkids treat_2 treat_3 if female==1 & stayer_birthprov_currentprov==0, ///
    a(i.year i.id age_c) cluster(year#i.year_birth)
```

6. Birthplace and destination jointly:

```stata
reghdfe nkids treat_2 treat_3 i.birthprov i.currentprov ///
    if female==1 & year_birth<=1950, ///
    a(i.year age_c) cluster(year#i.year_birth)
```

File mapping:
- use the active cohort-binned fertility block in `Marco/DO/new/Main_analysis.do`
- use the active census-cleaning section in the same file to standardize current-residence identifiers across 1991 and 2011 first

### Data needed

Already in repo:
- all census age-structure blocks needed to build women 15-44
- microdata fields for birthplace and prior residence
- the exact local-regression scaffolding already used for `alive`, `total_wedding`, and placebo age-group exercises

Potential extra data if you want a stronger migration appendix:
- INE historical migration flow tables by province
- province-level rural exodus series

These are optional. The first-pass diagnostics can be done entirely from existing files.

### Interpretation grid

If treatment strongly predicts falling `ln_female1544_lin` and the birth effect disappears after normalizing by fertile women:
- migration composition is a serious threat

If treatment does not predict large female-population decline and `births_per_female1544_lin` stays negative:
- the locality result looks much closer to true fertility behavior

If stayers show similar fertility effects to movers:
- strengthens the socialization interpretation

If the effect only survives among stayers:
- the aggregate DiD should be reframed as a stayer-weighted local effect

## Implementation roadmap

### Phase 1: Build variables

Create new data-prep scripts:
- `progs/data/07_law56_exposure.do`
- `progs/data/08_female1544_interpolation.do`

Deliverables:
- cohort-level Law 56 and 1973 exposure files
- municipality-year fertile-female interpolations
- optional harmonized microdata residence-history extracts for 1991/2001/2011

### Phase 2: Law 56 horse-race

Create:
- append a new `***** Law 56/1961` subsection to `Marco/DO/new/Main_analysis.do`

Deliverables:
- table with baseline, +Law56, +Law56+1973, donut sample
- simple cohort plot of `law56_share_*` against birth year

### Phase 3: Migration diagnostics

Create:
- append a new macro robustness subsection under the active `**# MACRO` area in `Marco/DO/new/Main_analysis.do`

Deliverables:
- placebo on fertile female population
- normalized births regressions
- panel truncated at 1972
- event-study on normalized births using the existing `b1945.year##c.sum1` template

### Phase 4: Birthplace/stayers layer

Create:
- append a new census robustness subsection under the active `*_______________________________________________ Robustness Census` area in `Marco/DO/new/Main_analysis.do`

Deliverables:
- birthplace FE spec
- birthplace + current residence spec
- stayers vs movers comparison

### Phase 5: Revision write-up

Update paper language so results map onto one of three honest interpretations:
- schooling package survives intact
- joint schooling-plus-later-institutions story
- stayer/composition-limited interpretation

## Practical recommendation

If time is constrained, do this order:

1. Law 56 horse-race on completed fertility
2. births per women 15-44 with interpolation
3. year<=1972 truncation
4. stayers vs movers
5. appendix-only external migration data

That sequence maximizes reviewer payoff per hour of implementation.

## Mapping of referee points to sections of `Marco/DO/new/Main_analysis.do`

### `***** Regression Fertility`
- Law 56/1961
- 1973 crisis
- donut cohorts

### `***** Regression Fertility --- Robustness cluster`
- clustering robustness for the main fertility results

### `********* Event study`
- cohort-shape diagnostics
- post-1950 cohort profiling

### `***** Unemployment, right, education, marriage`
- employment null-result reinterpretation
- partial test of opportunity-cost channels

### `***** Primary beliefs` and following `****** Event study`
- Figure 3 / beliefs workstream
- mechanism reframing

### `*_______________________________________________ Robustness Portugal -- IVS`
- Portugal placebo

### `*_______________________________________________ Robustness Census`
- birthplace
- stayers vs movers
- census completed fertility

### `**# MACRO`
- internal migration
- 1972 truncation
- parallel trends formalization
- local DiD redesign

### Active macro subsection map inside `**# MACRO`

`**# Continuous Treatment ---- Base mobile`
- main local design to extend for migration and 1973 truncation
- baseline outcome now is `alive`
- baseline exposure is continuous `sum1` and `sum2`

`**# Discrete treatment ---- Base mobile`
- discrete robustness for the same local story
- useful second-pass robustness after the continuous extension

`**# Placebo 15-24 1940`
- already an active placebo architecture
- best location for a population-composition placebo narrative

`**# Weddings`
- useful if reviewer concern shifts from fertility to marriage timing

`**# Balancing`
- useful for reframing and pre-treatment comparability
