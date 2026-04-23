# External Round 2

Questo folder contiene solo il nuovo round di analisi costruito dopo il primo blocco `external_revisions`, con tre obiettivi:

1. aggiungere un placebo `Spain vs Portugal` con una fonte nuova e molto piu pulita sulla fertilita di coorte;
2. rifare il blocco `beliefs` in forma pooled `Spain vs Portugal` con un indice piu interpretabile;
3. integrare, senza sostituirli, i survey employment gia usati nel paper con nuove fonti ufficiali piu vicine al nodo `1960s-1970s`.

## Fonti esterne usate

- `OWID / HFD completed cohort fertility`
  - raw: [owid_hfd_spain_portugal_cohort_fertility.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_data/raw/owid_hfd_spain_portugal_cohort_fertility.csv)
  - cleaned: [portugal_spain_hfd_completed_fertility.dta](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/generated/portugal_spain_hfd_completed_fertility.dta)

- `Banco de Espana historical EPA dataset (1964-1992)`
  - raw: [bde_dt9409_series.xlsx](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_data/raw/bde_dt9409_series.xlsx)
  - cleaned quarterly: [bde_dt9409_series_quarterly.dta](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/generated/bde_dt9409_series_quarterly.dta)
  - cleaned annual: [bde_dt9409_series_annual.dta](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/generated/bde_dt9409_series_annual.dta)
  - index: [bde_dt9409_index.dta](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/generated/bde_dt9409_index.dta)

- `Integrated Values Surveys 1981-2022`
  - source already present in project: [Integrated_values_surveys_1981-2022.dta](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/original_data/IVS/Integrated_values_surveys_1981-2022.dta)

- `Censo 1981 female activity structure`
  - reused from round 1 external build: [external_revision_04_female_activity_structure_1981.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_revisions/output/external_revision_04_female_activity_structure_1981.csv)

## Build And Run

- build sources:
  - [build_round2_external_sources.py](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/scripts/build_round2_external_sources.py)
- run all:
  - [external2_run_all.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/do/external2_run_all.do)

Do-files:

- [external2_01_portugal_hfd.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/do/external2_01_portugal_hfd.do)
- [external2_02_beliefs_ivs_spain_portugal.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/do/external2_02_beliefs_ivs_spain_portugal.do)
- [external2_03_employment_support.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/do/external2_03_employment_support.do)

Logs:

- [external2_run_all.log](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/logs/external2_run_all.log)
- [external2_01_portugal_hfd.log](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/logs/external2_01_portugal_hfd.log)
- [external2_02_beliefs_ivs_spain_portugal.log](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/logs/external2_02_beliefs_ivs_spain_portugal.log)
- [external2_03_employment_support.log](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/logs/external2_03_employment_support.log)

## Main Outputs

- Portugal placebo:
  - [external2_01_portugal_hfd_results.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/output/external2_01_portugal_hfd_results.csv)
  - [external2_01_portugal_hfd_series.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/output/external2_01_portugal_hfd_series.csv)

- Beliefs:
  - [external2_02_beliefs_results.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/output/external2_02_beliefs_results.csv)
  - [external2_02_belief_sample_counts.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/output/external2_02_belief_sample_counts.csv)

- Employment support:
  - [external2_03_bde_break_results.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/output/external2_03_bde_break_results.csv)
  - [external2_03_bde_period_means.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/output/external2_03_bde_period_means.csv)
  - [external2_03_female_activity_structure_1981_copy.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/output/external2_03_female_activity_structure_1981_copy.csv)

## Short Read

### 1. Portugal placebo

Il placebo Portogallo non e abbastanza pulito per diventare una prova forte pro-paper.

- nel `PT only` senza trend, le coorti trattate mostrano anche in Portogallo un forte calo della completed fertility:
  - `treat_2 = -0.071`
  - `treat_3 = -0.549`
- nel pooled `Spain vs Portugal` senza trend, la Spagna sembra meno negativa del Portogallo:
  - `spain_treat2 = 0.192`
  - `spain_treat3 = 0.426`
- ma quando lascio trend lineari specifici per paese, la differenza Spagna-Portogallo si azzera:
  - `spain_treat2 = 0.043`, `p = 0.663`
  - `spain_treat3 = -0.012`, `p = 0.948`

Lettura: il placebo serve soprattutto per dire che il Portogallo non e un controfattuale “clean”. Lo terrei semmai in appendix, non come main rescue.

### 2. Beliefs

Il nuovo blocco pooled `Spain vs Portugal` e piu leggibile del vecchio `IVS` sparso, ma non genera una prova forte.

- campione comune sulle waves `1990`, `1999`, `2008`:
  - Spagna: `1951`, `468`, `548`
  - Portogallo: `527`, `474`, `709`
- sull’indice complessivo `traditional_index`, il differenziale Spagna per le fully treated non e significativo:
  - `spain_treat3 = -0.060`, `p = 0.292`
- sull’indice `family_gender_index`, stesso messaggio:
  - `spain_treat3 = -0.065`, `p = 0.286`
- l’unico segnale piu netto e su `women want a home and children`, dove la Spagna tra le partially treated appare meno tradizionale del Portogallo:
  - `spain_treat2 = -0.177`, `p = 0.018`

Lettura: questo round migliora l’organizzazione del blocco `beliefs`, ma conferma che va tenuto come evidenza suggestiva, non come pilastro identificativo.

### 3. Employment support

Qui il messaggio utile e doppio.

Primo: i dati survey che gia usate non vanno buttati.

- in [Main_analysis.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/DO/new/Main_analysis.do) il blocco employment usa outcome individuali `lab2_1`, `lab2_2`, `lab2_5`
- in [05_import_cis.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/progs/data/05_import_cis.do) la variabile `unemployed` include gia `1979` e `1986-1992`
- quindi avete gia un pezzo di evidenza individuale pre-1981, anche se da survey e non da censimento

Secondo: le nuove fonti esterne aiutano a triangolare il contesto.

- nel `Censo 1981`, la partecipazione femminile resta bassa:
  - `active_share_total = 22.37%`
  - `occupied_share_total = 17.72%`
  - in urbano `active_share_total = 24.71%`
- nel `BdE EPA 1964-1992`, il mercato del lavoro cambia davvero dopo il `1973`:
  - `unemployment_share` medio passa da `1.43%` a `6.51%`
  - `services_share` da `33.97%` a `41.99%`
  - `public_admin_share_wage` da `10.40%` a `12.58%`
  - `construction_share` mostra un break di trend negativo dopo il `1973`: `post73_trend = -0.00232`, `p = 0.001`

Lettura: il `1973` e un vero shock macro e quindi merita il blocco di robustness che gia abbiamo costruito; pero il lato femminile resta quantitativamente piccolo nel `1981`, quindi questi dati non supportano una storia in cui la sola espansione del lavoro femminile spiega interamente il vostro risultato.

## Provisional Recommendation

- `Portugal`: appendix o drop dal core narrative
- `beliefs`: appendix o meccanismo molto leggero
- `employment support`: keep come blocco di triangolazione, insieme ai survey gia usati nel paper, non in sostituzione
