# Detailed Reviewer Workstreams Report

## Scope

This report documents the revision bundle built directly from:
- `Marco/DO/new/Main_analysis.do`

Method rule used throughout:
- active sections in `Main_analysis.do` were treated as the paper baseline
- code inside `/* ... */` was treated as dormant unless explicitly reactivated for a reviewer-driven robustness

The implementation was split into runnable Stata do-files under:
- `codex/do/`

and the outputs were saved under:
- `codex/output/`
- `codex/generated/`
- `codex/logs/`

## Files Created And Run

Implemented and executed:
- `codex/do/revision_01_law56_horserace.do`
- `codex/do/revision_02_migration_macro.do`
- `codex/do/revision_03_birthplace_stayers.do`
- `codex/do/revision_04_macro_pretrends_heterogeneity.do`
- `codex/do/revision_05_ivs_placebo_beliefs.do`
- `codex/do/revision_06_post1950_census.do`
- `codex/do/revision_run_all.do`

Main result files:
- `codex/output/revision_01_law56_results.csv`
- `codex/output/revision_02_migration_results.csv`
- `codex/output/revision_03_birthplace_results.csv`
- `codex/output/revision_03_birthplace_shares.csv`
- `codex/output/revision_04_macro_pretrend_results.csv`
- `codex/output/revision_05_ivs_results.csv`
- `codex/output/revision_05_ivs_results_recomputed.csv`
- `codex/output/revision_06_post1950_results.csv`

Support datasets created:
- `codex/generated/law56_cohort_exposure.dta`
- `codex/generated/dataset_female1544_revision.dta`

## How The Bundle Maps To Reviewer Points

1. `Law 56/1961`
- implemented in `revision_01_law56_horserace.do`

2. `Internal migration and local DiD`
- implemented in `revision_02_migration_macro.do`

3. `1973 crisis`
- implemented inside `revision_01_law56_horserace.do` through `crisis73_share_25_35`
- implemented inside `revision_02_migration_macro.do` through the `year <= 1972` and `1940-1965` local windows

4. `Birthplace / stayers vs movers`
- implemented in `revision_03_birthplace_stayers.do`

5. `Civil war / repression / donut cohorts`
- donut cohorts implemented in `revision_01_law56_horserace.do`
- war heterogeneity implemented in `revision_04_macro_pretrends_heterogeneity.do`

6. `Figure 3 / beliefs`
- implemented in `revision_05_ivs_placebo_beliefs.do`

7. `Church vs 1945 reform package`
- implemented in `revision_04_macro_pretrends_heterogeneity.do`

8. `Post-1950 cohorts`
- implemented in `revision_06_post1950_census.do`

9. `Portugal placebo`
- implemented in `revision_05_ivs_placebo_beliefs.do`

10. `Parallel trends formalization`
- implemented in `revision_04_macro_pretrends_heterogeneity.do`

## 1. Law 56/1961

### Reviewer concern

The reviewer’s concern is that the cohort gradient attributed to the 1945 reform could instead reflect differential adult exposure to the legal opening created by Law 56/1961.

### Intuition

If later-born women spend more of their fertile and labor-market years after 1961, and if the 1961 law is the true driver, then adding a cohort-level post-1961 exposure variable should attenuate or kill the treatment coefficients from the baseline cohort bins.

### What I implemented

In `revision_01_law56_horserace.do` I built:
- `law56_share_18_30`
- `law56_share_20_35`
- `law56_share_25_35`
- `law56_age_in_1961`
- `law56_post1961_under25`
- `crisis73_share_25_35`

I then ran the horse-race on the active CIS fertility skeleton from `Main_analysis.do`:
- baseline `treat_2` and `treat_3`
- `+ law56_share_20_35`
- `+ law56_share_20_35 + crisis73_share_25_35`
- `law56_share_18_30`
- donut sample dropping `1936-1941`
- partner-timing extension with `year_partner`

### Main results

For `nkids`:
- baseline `treat_3 = -0.260`, `se = 0.142`, `p = 0.078`
- with `law56_share_20_35`, `treat_3 = -0.274`, `se = 0.241`, `p = 0.263`
- `law56_share_20_35` itself is tiny and imprecise
- when `crisis73_share_25_35` is added, the crisis coefficient is `-0.311`, `se = 0.156`, borderline at about `p = 0.054`

For `kids`:
- there is no meaningful evidence that the Law 56 exposure variable absorbs the treatment pattern

### Interpretation

This is a good first answer to the Law 56 reviewer point:
- the 1961 exposure proxy does not “explain away” the cohort-bin result
- the treatment coefficients do not collapse when Law 56 exposure is added

But the same exercise also reveals a second message:
- the 1973 crisis proxy is more threatening than Law 56 in the intensive-margin `nkids` regressions

So the clean interpretation is:
- Law 56/1961 is not the main confound in this first-pass horse-race
- the 1973 macro shock remains a live alternative channel, especially for `nkids`

## 2. Internal Migration And Local DiD

### Reviewer concern

The reviewer’s concern is that locality-level birth declines may reflect out-migration of women in fertile ages rather than genuine fertility changes.

### Intuition

If treated localities simply lose women aged 15-44, then births will fall mechanically. The right empirical response is:
- build a proper women-15-44 denominator
- re-estimate the local design on births per women 15-44
- run placebo regressions on the women-15-44 population itself

### What I implemented

In `revision_02_migration_macro.do` I extended the active macro design from `Main_analysis.do` without changing its skeleton.

I created:
- `female1544_step`
- `female1544_lin`
- `births_per_female1544_step`
- `births_per_female1544_lin`
- `ln_female1544_lin`

I kept the active local treatment structure:
- `interaction = post * sum1`
- `interaction2 = post * sum2`
- controls `flag4_3 flag4_4 flag4_5`
- absorb `i.id i.year#i.codprov`

I then ran:
- baseline on `alive`
- normalized outcome on `births_per_female1544_lin`
- placebo on `ln_female1544_lin`
- truncation `year <= 1972`
- early window `1940-1965`
- discrete-treatment robustness

### Main results

Normalized births:
- baseline continuous design: `interaction = -4.62`, `se = 1.43`, `p = 0.0017`
- `interaction2 = -8.31`, `se = 1.97`, `p < 0.001`

Pre-1973 truncation:
- `interaction = -4.44`, `se = 1.31`, `p = 0.0010`
- `interaction2 = -6.87`, `se = 1.49`, `p < 0.001`

Early window `1940-1965`:
- `interaction = -2.86`, `se = 0.91`, `p = 0.0023`
- `interaction2 = -4.22`, `se = 1.08`, `p < 0.001`

Population placebo:
- on `ln_female1544_lin`, the female interaction is tiny and not significant in the continuous design
- the male-side interaction is negative in some specifications

### Interpretation

This is one of the strongest new findings in the whole bundle.

The local result survives when births are normalized by women 15-44, and it survives even before 1973. That means the reviewer story:
- “you are only measuring out-migration”

is weakened materially by the data.

The clean way to write this is:
- composition changes matter enough to deserve explicit modeling
- but the treated-locality effect is not eliminated once the denominator is fixed

## 3. 1973 Crisis

### Reviewer concern

The reviewer’s concern is that what looks like a schooling effect may actually be the fertility consequences of the 1973 crisis when treated cohorts are fully in adult ages.

### Intuition

There are two places where the crisis can show up:
- in individual completed-fertility cohort regressions
- in local annual birth dynamics

### What I implemented

Individual side:
- `crisis73_share_25_35` in `revision_01_law56_horserace.do`

Local side:
- sample truncated to `year <= 1972`
- shorter early window `1940-1965`

### Main results

Individual side:
- `crisis73_share_25_35` is negative in `nkids` and borderline significant

Local side:
- the normalized birth result survives clearly in the pre-1973 and early windows

### Interpretation

The right synthesis is nuanced:
- the local panel is not mainly a 1973 artifact
- the individual `nkids` result may still be partially contaminated by crisis exposure

So in the revision:
- defend the local DiD more strongly
- soften the interpretation of the individual intensive-margin result

## 4. Birthplace / Stayers Vs Movers

### Reviewer concern

The reviewer’s concern is that current residence is the wrong geography for treatment assignment if the relevant mechanism is schooling/socialization around birthplace.

### Intuition

If the result disappears once birth province is incorporated, then the current paper may be assigning exposure to the wrong place. If it survives with birth-province controls and among stayers, the concern weakens.

### What I implemented

In `revision_03_birthplace_stayers.do` I rebuilt the active census section using the 1991 and 2011 raw microdata, harmonized:
- current province `codprov`
- birth province `codprov_born`
- `stayer_birthprov`
- `mover_birthprov`
- `moved_10y`

I estimated:
- baseline census treatment regression
- `+ birth province FE`
- `+ birth province FE + current province FE`
- stayers only
- movers only

### Main results

For `nhijos`:
- baseline `treat_3 = -0.070`, `p = 0.002`
- with birth province FE, `treat_3 = -0.114`, `p < 0.001`
- with birth and current province FE, `treat_3 = -0.108`, `p < 0.001`
- movers: `treat_3 = -0.127`, `p < 0.001`
- stayers: `treat_3 = -0.088`, `p = 0.001`

For `kids2`:
- the sign remains positive in the census coding of that outcome, but the key point is persistence across the birthplace/current-residence specifications and in both stayers and movers

Descriptive mobility:
- 1991 `stayer_birthprov ≈ 0.415`
- 2011 `stayer_birthprov ≈ 0.702`

### Interpretation

This is another strong result.

The completed-fertility signal in `nhijos` survives:
- after controlling for birthplace
- after controlling jointly for birthplace and current residence
- among stayers
- among movers

This makes it much harder for a reviewer to say that the result is purely an artefact of using current residence instead of place of origin.

The best wording is:
- birthplace matters and should be modeled explicitly
- but the main completed-fertility pattern is not driven away by doing so

## 5. Civil War / Repression / Donut Cohorts

### Reviewer concern

The reviewer’s concern is that the cohort pattern may partly reflect war trauma, repression, or extreme wartime conditions rather than the education reform.

### Intuition

Two clean checks are:
- drop the cohorts most exposed to the war period
- test whether the local treatment is stronger in high-war-intensity places

### What I implemented

Donut check:
- in `revision_01_law56_horserace.do`, I estimated a donut sample dropping `1936-1941`

War heterogeneity:
- in `revision_04_macro_pretrends_heterogeneity.do`, I split the local macro design by `deaths_male_cwar`

### Main results

Donut sample:
- on `nkids`, `treat_3` loses precision and becomes unstable in the donut sample

War heterogeneity:
- in low-war areas, the female interaction remains negative
- in high-war areas, the female interaction is near zero
- the male-side interaction is more negative in high-war areas

### Interpretation

This part is mixed, not cleanly supportive.

What I would say in the paper:
- the donut sample does not deliver a neat “nothing changes” reassurance
- the local heterogeneity is not consistent with a simple war-amplification story on the female treated side

So this reviewer point is not fatal, but it is not fully neutralized either.

## 6. Figure 3 / Beliefs

### Reviewer concern

The reviewer’s concern is that the current beliefs evidence may be too tied to a single CIS setting and may be more suggestive than causal.

### Intuition

The most useful first pass is to take a small set of face-valid IVS belief variables and check whether the cohort pattern is even directionally present in another source.

### What I implemented

In `revision_05_ivs_placebo_beliefs.do` I used female Spain observations from the IVS and estimated cohort-bin regressions on:
- `C001` men should have more right to a job than women
- `D019` a woman has to have children to be fulfilled
- `D057` being a housewife just as fulfilling
- `D058` husband and wife should both contribute income
- `D061` preschool child suffers with working mother
- `D062` women want a home and children
- `F120` justifiable abortion

Important note:
- the `p` column in the original Stata output for this file is unreliable
- the correct approximate p-values are in `revision_05_ivs_results_recomputed.csv`

### Main results

The only relatively clear signal is:
- `D019` for partially treated cohorts: positive and about `p ≈ 0.038`

Other items are weak or imprecise:
- `D057`, `D061`, `F120` show some directional movement but not robust precision
- most remaining items are close to zero

### Interpretation

This does not support a strong causal beliefs claim across waves.

The right revision move is:
- keep beliefs as suggestive evidence
- reduce the causal tone
- avoid over-claiming that Figure 3 alone identifies the mechanism

## 7. Church Vs 1945 Reform Package

### Reviewer concern

The reviewer’s concern is that the effect may reflect the Catholic package rather than schooling alone.

### Intuition

If the effect is really strongest where Catholic infrastructure was densest, that supports a bundled school-Church environment rather than a pure schooling-only channel.

### What I implemented

In `revision_04_macro_pretrends_heterogeneity.do` I split the normalized local design by `relig_com_total1930`.

### Main results

Female-side interaction on normalized births:
- low-church areas: `-10.57`, `p < 0.001`
- high-church areas: `-9.53`, `p = 0.002`

### Interpretation

The effect is present in both low- and high-Church areas and is not obviously stronger in high-Church places.

So this first pass does not support a simple:
- “the effect is just stronger where the Church was stronger”

story.

The safe interpretation is:
- the effect does not look mechanically tied to local church density alone

## 8. Post-1950 Cohorts

### Reviewer concern

The reviewer’s concern is that the whole pattern may just be a smooth secular birth-cohort trend rather than something special around the treated cohorts.

### Intuition

Because 2011 gives older completed or near-completed fertility for post-1950 cohorts, a simple cohort profile is informative even if it is descriptive rather than causal.

### What I implemented

In `revision_06_post1950_census.do` I switched to a descriptive 2011 cohort profile by bins:
- `1920-1929`
- `1930-1938`
- `1939-1950`
- `1951-1955`
- `1956-1960`
- `1961-1965`

I collapsed mean:
- `kids2`
- `nhijos`
- age

### Main results

Mean `nhijos`:
- `1920-1929`: `2.40`
- `1930-1938`: `1.74`
- `1939-1950`: `1.36`
- `1951-1955`: `1.46`
- `1956-1960`: `1.65`
- `1961-1965`: `1.75`

Mean `kids2`:
- falls from older cohorts to `1939-1950`
- then rises again for the post-1950 cohorts

### Interpretation

This is useful descriptively:
- the profile is not a smooth monotonic decline
- post-1950 cohorts do not simply continue the same straight downward pattern

That helps against the pure secular-trend critique.

But it should be presented honestly as:
- descriptive cohort profiling
- not a new causal design

## 9. Portugal Placebo

### Reviewer concern

The reviewer’s concern is that the Spain cohort pattern may simply reflect broader Southern European timing rather than the Spanish reform package.

### Intuition

If Portugal shows a similar cohort pattern, then it is a weak placebo and should not be used aggressively as a clean counterfactual.

### What I implemented

In `revision_05_ivs_placebo_beliefs.do` I estimated:
- Portugal-only fertility regressions
- pooled Spain-Portugal models with interaction terms `spain_treat2` and `spain_treat3`

### Main results

Portugal-only:
- `kids`: both `treat_2` and `treat_3` are positive and significant
- `nkids`: both `treat_2` and `treat_3` are also positive and significant

Spain-vs-Portugal differential:
- `spain_treat2` and `spain_treat3` are small and not significant

### Interpretation

This is not a supportive placebo.

The right takeaway is:
- Portugal should not be sold as a strong validating placebo
- if kept, it should be reframed as a loose Southern European comparison, not as a clean counterfactual

## 10. Parallel Trends Formalization

### Reviewer concern

The reviewer’s concern is that the local DiD relies on parallel trends that may not actually hold.

### Intuition

The right formal check is a joint test of pre-1945 event-study coefficients.

### What I implemented

In `revision_04_macro_pretrends_heterogeneity.do` I estimated the continuous-treatment event study on `births_per_female1544_lin` and ran:
- a joint `testparm` on `1930.year#c.sum1` through `1944.year#c.sum1`

### Main results

Joint pretrend test:
- `F = 15.18`
- `p = 1.95e-19`

### Interpretation

This is the clearest negative result in the bundle.

The local design fails a formal parallel-trends test in this implementation.

That means the paper should not answer this reviewer point by simply saying:
- “pretrends look fine”

Instead, the right response is:
- acknowledge that formal pretrends are not flat
- emphasize the denominator-corrected robustness and the early-window results
- consider reframing the local panel as supportive but not stand-alone causal proof

## Bottom-Line Assessment By Reviewer Priority

### Strongest supportive results

1. `Internal migration`
- once births are normalized by women 15-44, the local effect survives strongly

2. `Birthplace / stayers vs movers`
- completed-fertility results survive birthplace controls and remain in both stayers and movers

3. `Law 56/1961`
- the Law 56 exposure proxy does not wipe out the cohort-bin treatment effect

### Mixed results

4. `1973 crisis`
- not the main story for the local panel
- still a live alternative channel for individual `nkids`

5. `Civil war / repression`
- not cleanly fatal
- not cleanly resolved either

6. `Church heterogeneity`
- no evidence that the local effect is concentrated only in high-Church places

### Weak or unfavorable results

7. `Parallel trends`
- formal pretrend rejection is strong

8. `Portugal placebo`
- Portugal does not behave like a reassuring placebo

9. `Beliefs`
- cross-wave IVS beliefs support is weak and should remain suggestive

## Recommended Writing Strategy For The Revision

### What to defend strongly

- The individual cohort story is not obviously a disguised Law 56 story.
- The local fertility result is not mechanically an out-migration result.
- Birthplace modeling does not overturn the completed-fertility evidence.

### What to soften

- Strong causal claims from Figure 3 / beliefs.
- Use of Portugal as a validating placebo.
- The idea that the local DiD fully satisfies formal parallel trends.

### What to reframe

- Present the local design as supportive and behaviorally informative, but not as the single cleanest causal design in the paper.
- Present the individual completed-fertility evidence as the central pillar, with local results and beliefs as reinforcing but imperfect layers.

## Practical Next Step

The next high-value step is not more breadth, but refinement of the best-performing blocks:

1. convert the strongest results into paper-ready tables
2. add one figure for normalized births per women 15-44
3. add one appendix table with birthplace FE and stayers/movers
4. rewrite the response letter around:
- Law 56 does not explain away the result
- migration is not the whole story
- parallel trends and Portugal require a more modest framing
