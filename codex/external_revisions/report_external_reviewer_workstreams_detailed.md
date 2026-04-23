# Detailed External-Data Reviewer Workstreams Report

## Scope

This report documents the external-data revision bundle built to complement the internal analyses already stored under:
- `codex/do/`
- `codex/output/`
- `codex/report_reviewer_workstreams_detailed.md`

The external bundle lives under:
- `codex/external_revisions/`

and adds:
- legal timing from BOE
- migration and activity tables from Censo 1981
- fertility-by-activity tables from Censo 1981
- new province-level pre-1973 crisis proxies built from INE 1950 historical tables

Method rule used throughout:
- the empirical skeleton remains anchored to the active sections of `Marco/DO/new/Main_analysis.do`
- external sources are used only to sharpen specific reviewer points, not to redefine the paper’s core estimand

## Files Created And Run

Implemented and executed:
- `codex/external_revisions/do/external_revision_01_law56_legal_timing.do`
- `codex/external_revisions/do/external_revision_02_crisis73_macro_proxies.do`
- `codex/external_revisions/do/external_revision_03_external_migration_censo1981.do`
- `codex/external_revisions/do/external_revision_04_activity_fertility_censo1981.do`
- `codex/external_revisions/do/external_revision_run_all.do`

Support script:
- `codex/external_revisions/scripts/build_pre73_crisis_proxies.py`

Main generated datasets:
- `codex/external_revisions/generated/law56_legal_timeline_external.dta`
- `codex/external_revisions/generated/law56_external_timing_exposure.dta`
- `codex/external_revisions/generated/province_pre73_crisis_proxies.dta`
- `codex/external_revisions/generated/province_pre73_crisis_proxies.csv`

Main output files:
- `codex/external_revisions/output/external_revision_01_law56_legal_timing.csv`
- `codex/external_revisions/output/external_revision_02_crisis73_macro_proxies.csv`
- `codex/external_revisions/output/external_revision_03_female_mobility_activity.csv`
- `codex/external_revisions/output/external_revision_03_female_mobility_sectors.csv`
- `codex/external_revisions/output/external_revision_03_province_stay_share_1970_1981.csv`
- `codex/external_revisions/output/external_revision_04_activity_fertility_gap.csv`
- `codex/external_revisions/output/external_revision_04_female_activity_1981.csv`
- `codex/external_revisions/output/external_revision_04_female_sector_age_profile.csv`

Documentation:
- `codex/external_revisions/notes/pre73_crisis_proxy_notes.md`

## How This Bundle Maps To Reviewer Points

1. `Law 56/1961 timing and alternative legal dates`
- implemented in `external_revision_01_law56_legal_timing.do`

2. `1973 crisis and sectoral heterogeneity`
- implemented in `external_revision_02_crisis73_macro_proxies.do`
- supported by `province_pre73_crisis_proxies.dta`

3. `Internal migration`
- implemented in `external_revision_03_external_migration_censo1981.do`

4. `Law 56 as employment mechanism`
- implemented in `external_revision_04_activity_fertility_censo1981.do`

5. `New province-level pre-crisis proxies`
- built in `build_pre73_crisis_proxies.py`

## 1. Law 56/1961 With External Legal Timing

### Reviewer concern

The reviewer’s concern is that the cohort pattern may be explained not by the 1945 school reform but by later labor-market liberalization for women. A second concern is that the current coding may attach too much weight to `1961` as a single date and ignore the fact that implementation happened through later decrees.

### Intuition

If the legal channel is the real driver, then the result should weaken once we move from a generic post-1961 proxy to a timing structure that distinguishes:
- the effective opening from `1962`
- the later regulatory reinforcement from `1970`
- the overlap with post-`1973` adult exposure

### What I implemented

In `external_revision_01_law56_legal_timing.do` I:
- imported the BOE legal timeline into `law56_legal_timeline_external.dta`
- built cohort-level exposure variables using legal thresholds at `1962` and `1970`
- re-ran the CIS fertility horse-race on the same active skeleton used in the internal bundle

The new exposure variables are:
- `law56_share_18_30_1962`
- `law56_share_20_35_1962`
- `decree70_share_20_35`
- `crisis73_share_25_35`

### Main results

For `nkids`:
- baseline `treat_3 = -0.344`, `p = 0.023`
- with `law56_share_20_35_1962`, `treat_3 = -0.364`, `p = 0.094`
- with `law56_share_20_35_1962 + decree70_share_20_35`, `treat_3 = -0.395`, `p = 0.079`
- with `1962 + 1970 + 1973`, `treat_3 = -0.243`, `p = 0.344`

The new legal-timing variables themselves are weak:
- `law56_share_20_35_1962`: close to zero, `p = 0.912`
- `decree70_share_20_35`: negative but imprecise, `p = 0.108`
- `crisis73_share_25_35`: negative but imprecise, `p = 0.191`

For `kids`:
- baseline `treat_3 = 0.002`, `p = 0.919`
- all legal timing variables are small and imprecise

### Interpretation

This external timing exercise is useful mainly in two ways.

First:
- it does not support the strong reviewer story that `Law 56/1961` alone explains the cohort result
- once we code legal timing more carefully, the direct `1962` and `1970` exposures are not doing the work

Second:
- the `nkids` result becomes less stable once `1962`, `1970`, and `1973` exposures are all included jointly
- that instability looks more like cumulative collinearity across overlapping cohort timing variables than like clean evidence in favor of Law 56

So the right use in the paper is:
- strong as a defense against the claim that the result is simply a misdated legal liberalization story
- weaker as a standalone mechanism test

### Provisional recommendation

Keep:
- the `1962` and `1962+1970` horse-race

Use cautiously:
- the full `1962+1970+1973` version, because the interpretation becomes less clean

## 2. 1973 Crisis With New Province-Level Pre-Crisis Proxies

### Reviewer concern

The reviewer’s concern is that the local effect could be driven by exposure to the oil shock rather than by the reform-related mechanism.

### Intuition

If the local result is really an oil-shock artifact, then the treated-locality decline should become more negative after `1973` specifically in provinces with stronger pre-existing exposure to oil-sensitive sectors.

### What I implemented

In `build_pre73_crisis_proxies.py` I built a new province-level dataset from INE historical tables, using:
- INE 1950 Censo, Cuadro VIII, broad activity groups
- the project’s internal 1960 and 1970 province-level census geography

The resulting file is:
- `province_pre73_crisis_proxies.dta`

Main proxy variables:
- `industrial_core_share_1950`
- `oil_sensitive_share_1950`
- `manuf_trade_share_1950`
- `nonag_share_1950`

Audit rule:
- `proxy_usable_pre73 = 1` if the parsed province row had coherent sector totals within a 10% tolerance
- `37` provinces out of `50` satisfy that rule

In `external_revision_02_crisis73_macro_proxies.do` I merged those proxies into the already-normalized municipality panel and estimated:
- baseline on the subset of provinces with usable proxies
- the same baseline truncated at `year <= 1972`
- heterogeneity regressions with `post73 x interaction x proxy`

### Main results

Baseline in the proxy-valid sample:
- `interaction = -4.537`, `p = 0.0027`
- `interaction2 = -6.997`, `p = 0.0002`

Pre-1972 in the proxy-valid sample:
- `interaction = -4.342`, `p = 0.0019`
- `interaction2 = -6.346`, `p = 0.0001`

Heterogeneity by pre-crisis provincial structure:
- `crisis_f` is small and not significant for `industrial_core_share_1950`
- `crisis_f` is small and not significant for `oil_sensitive_share_1950`
- `crisis_f` is small and not significant for `nonag_share_1950`
- only `manuf_trade_share_1950` shows a borderline positive relationship on `alive`, not on normalized `birthrate_lin`

For `birthrate_lin`, all `post73 x proxy` terms are weak:
- `industrial_core_share_1950`: `p = 0.773`
- `oil_sensitive_share_1950`: `p = 0.804`
- `manuf_trade_share_1950`: `p = 0.612`
- `nonag_share_1950`: `p = 0.875`

### Interpretation

This is one of the more useful new bundles.

It says:
- the local normalized result survives cleanly even when we restrict to provinces with externally-built pre-crisis sector data
- the effect survives cleanly before `1973`
- there is no compelling evidence that the post-1973 decline is concentrated where pre-crisis oil sensitivity was greatest

That does not prove the oil crisis is irrelevant.
It does show:
- the reviewer’s strongest crisis story is not supported by these new heterogeneity tests

### Provisional recommendation

Keep:
- the proxy-valid-sample baseline
- the proxy-valid-sample pre-1972 result
- one compact heterogeneity table using `oil_sensitive_share_1950` and maybe `industrial_core_share_1950`

Drop or demote:
- a long battery of similar proxy interactions, because they all point in the same direction and could look repetitive

## 3. Internal Migration With Official 1981 Censo Tables

### Reviewer concern

The reviewer’s concern is that the local decline in births may just reflect population redistribution, especially the out-migration of women of fertile ages.

### Intuition

The most direct external answer is not another local DiD. It is to ask:
- do movers and stayers look very different in female activity and employment?
- do female movers disproportionately sort into particular sectors?
- which origin provinces retain or lose residents between 1970 and 1981?
- are low-retention provinces also the provinces that look more treated in the baseline local design?

### What I implemented

In `external_revision_03_external_migration_censo1981.do` I built five outputs:

1. `external_revision_03_female_mobility_activity.csv`
- female activity and employment shares by mobility status and age group

2. `external_revision_03_female_mobility_sectors.csv`
- sector composition of female movers and stayers

3. `external_revision_03_province_stay_share_1970_1981.csv`
- province-level stay shares between 1970 and 1981

4. `external_revision_03_province_mobility_link.csv`
- province-level match between `stay_share` and baseline treatment intensity from the internal panel

5. `external_revision_03_province_mobility_regs.csv`
- small cross-province regressions of retention on treatment exposure

### Main results

Female movers vs stayers:

Age `25-34`:
- movers `active_share = 0.289`
- stayers `active_share = 0.327`
- movers `employed_share = 0.852`
- stayers `employed_share = 0.855`

Age `35-44`:
- movers `active_share = 0.205`
- stayers `active_share = 0.192`
- movers `employed_share = 0.913`
- stayers `employed_share = 0.929`

Sector composition:
- women moving across municipalities are overwhelmingly in `services` (`0.771`)
- their `industry` share is `0.198`
- women staying in the same municipality have much more `agriculture` (`0.109`) and less `services` (`0.648`)

Province-level stay shares:
- very high retention in `S.C.Tenerife`, `Valencia`, `Las Palmas`, `Madrid`, `Barcelona`
- lower retention in interior provinces like `Ciudad Real`, `Ávila`, `Cuenca`, `Badajoz`, `Cáceres`, `Jaén`

Province-level link to treatment intensity:
- with raw treatment levels, there is no meaningful relationship between `stay_share` and `sum1muni` or `sum2muni`
- with municipality-minus-rest gaps only, `treat_gap_f` is positive but imprecise (`p = 0.156`)
- after controlling for `muni_share_1940` and `ln_origin_total`, `treat_gap_f = 0.00825`, `p = 0.016`
- `muni_share_1940` is strongly positive (`p = 0.002`)

### Interpretation

This block is descriptive, not causal, but it is still useful.

It suggests:
- migration is real and economically meaningful
- women who move are more urban-service oriented
- low-retention provinces are disproportionately interior and poorer provinces
- province retention is much more tightly linked to baseline urbanization than to the treatment intensity itself

At the same time:
- the raw activity comparison does not show a simple story where movers are dramatically more active than stayers at all ages
- among women already in the labor force, employment rates are very similar across movers and stayers
- once we connect the external migration data to the paper’s baseline exposure measure, we do not find evidence that more-treated provinces systematically lost more residents; if anything, the controlled female treatment gap goes in the opposite direction

So the migration story should be framed as:
- a real compositional force worth acknowledging
- not an obvious one-line alternative that mechanically explains away the local fertility result

### Provisional recommendation

Keep:
- the mover/stayer activity table
- one short sector-composition table
- one short province-level table linking `stay_share` to treatment intensity
- one appendix table with province stay shares

Use carefully:
- the raw province stay-share rankings, because by themselves they are descriptive

## 4. Activity And Fertility With 1981 Censo Tables

### Reviewer concern

The reviewer’s Law 56 objection is not just about legal timing. It is also about mechanism:
- if the law mattered because it changed women’s labor supply, then outcomes related to employment and fertility should line up more closely in data nearer to that institutional window

### Intuition

If the reviewer’s mechanism is correct, then:
- active women should show systematically lower fertility than inactive women
- this gap should already be visible for marriage cohorts tied to the `1961-1965` and `1966-1970` windows
- national female activity rates in 1981 should be high enough to make the mechanism substantively plausible

### What I implemented

In `external_revision_04_activity_fertility_censo1981.do` I built:
- `external_revision_04_activity_fertility_gap.csv`
- `external_revision_04_law56_window_cells.csv`
- `external_revision_04_female_activity_1981.csv`
- `external_revision_04_female_activity_structure_1981.csv`
- `external_revision_04_sex_activity_gap_1981.csv`
- `external_revision_04_female_sector_age_profile.csv`

### Main results

National female activity rate in 1981:
- `0.224` overall
- `0.247` in urban areas
- `0.187` in rural areas

Female versus male activity rates:
- women `22.37` versus men `73.12` nationally
- women `24.71` versus men `74.43` in urban areas
- the female-to-male activity ratio stays between roughly `0.25` and `0.33`

Female labor-market structure in 1981:
- nationally, only `17.7%` of all women are occupied
- `77.6%` are inactive
- even in urban areas, the occupied share is only `19.2%`

Fertility gap by activity:
- marriage period `1961_1965`, age `25-29`: active `2.1`, inactive `2.8`, gap `-0.7`
- marriage period `1966_1970`, age `25-29`: active `2.56`, inactive `3.20`, gap `-0.64`
- marriage period `1971_1975`, age `25-29`: active `1.76`, inactive `2.20`, gap `-0.44`

The sign is broadly stable:
- active women have fewer children than inactive women in almost all national cells with usable data
- the same negative gap appears in the compact `1961-1970` window table for both urban and rural zones

Female sector profile by age:
- services dominate in prime working ages
- industry remains important, especially `25-29` and `30-34`

### Interpretation

This block is useful as mechanism support, but not as causal identification.

What it gives you:
- a clear descriptive link between women’s economic activity and lower fertility
- direct evidence that the gap already exists in cohorts married close to the Law 56 window
- a more historically relevant employment picture than late survey waves alone
- evidence that female labor-force participation remained very limited even by `1981`

What it does not give you:
- a causal effect of Law 56 on employment
- a province-by-cohort mechanism estimate tied directly to treatment intensity

So the right use is:
- strengthen the mechanism section
- argue that the reviewer’s mechanism is descriptively plausible, but that the scale of female employment is too limited to make a broad generalized Law 56 story fully convincing on its own
- do not oversell it as decisive adjudication between the 1945 reform and Law 56

### Provisional recommendation

Keep:
- the national activity-fertility gap table
- the `1961_1965` and `1966_1970` rows in the main text or appendix
- the female activity-rate table for urban/rural comparison
- the female-versus-male activity-rate comparison
- the female activity-structure table (`occupied / inactive`)

Demote:
- the full age-by-zone matrix to appendix

## 5. New Province-Level Pre-1973 Proxies

### Why this matters

This is not a standalone reviewer point, but it materially changes what can be done next.

The file `province_pre73_crisis_proxies.dta` gives a new province-level layer for:
- crisis heterogeneity
- church/religion interactions if later matched to historical ecclesiastical density
- future checks using birthplace province in census-based work

### What is in the file

Core structure:
- `codprov`
- `province`
- `proxy_usable_pre73`

Core proxies:
- `industrial_core_share_1950`
- `oil_sensitive_share_1950`
- `manuf_trade_share_1950`
- `nonag_share_1950`

Quality controls:
- `parsed_token_count_viii`
- `sector_gap_viii`
- `sector_gap_share_viii`
- `usable_viii`

### Best-identified high-exposure provinces

By `oil_sensitive_share_1950`, the highest usable provinces are:
- `vizcaya`
- `guipuzcoa`
- `madrid`
- `gerona`
- `cantabria`
- `baleares`
- `alicante`
- `alava`

### Interpretation

This is a meaningful research asset even beyond the current revision round.

The main caveat is obvious:
- the OCR-based historical extraction is not equally reliable for all provinces

That is why the file explicitly carries:
- province-level quality flags
- a restricted “usable” sample

## Overall Takeaways

### What looks strongest

1. `Law 56 timing`
- the new legal-timing horse-race does not support the claim that the main cohort pattern is just a misdated `1961` labor reform effect

2. `1973 crisis`
- the normalized local result survives in the proxy-valid sample and before `1973`
- the new province-level sector interactions do not show stronger post-1973 deterioration in more oil-sensitive provinces

3. `Migration`
- migration is clearly important descriptively
- but the external tables do not suggest a clean simple story in which female out-migration alone explains the local fertility result

4. `Mechanism`
- active women consistently have lower fertility than inactive women in 1981 tables, including marriage cohorts close to the Law 56 window

### What is useful but should be handled carefully

1. `Province stay shares`
- informative and intuitive
- but descriptive rather than design-based

2. `Full 1962+1970+1973 horse-race in CIS`
- informative
- but vulnerable to overlap and collinearity across cohort exposure measures

3. `Wide set of crisis proxies`
- useful for robustness
- too many similar specifications could dilute the main message

## Suggested Next Discussion

The clean next step is to go point by point and decide:
- what enters the main response letter
- what enters the paper appendix
- what stays as internal reassurance only

My provisional shortlist to keep in the selected revision design is:
- `Law 56 timing`: `1962` and `1962+1970`
- `Crisis 1973`: proxy-valid sample baseline, pre-1972 restriction, one compact heterogeneity table with `oil_sensitive_share_1950`
- `Migration`: female mover/stayer activity table and one short sector table
- `Mechanism`: activity-fertility gap around `1961_1965` and `1966_1970`

The most likely candidates to leave out of the main narrative are:
- long rankings of province stay shares
- the full battery of similar crisis proxies
- the most saturated `1962+1970+1973` cohort horse-race
