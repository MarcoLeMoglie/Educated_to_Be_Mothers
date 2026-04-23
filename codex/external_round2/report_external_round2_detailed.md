# Report External Round 2

Questo report documenta solo il secondo round di analisi con fonti esterne nuove o riorganizzate, costruito dopo il primo pacchetto `external_revisions`.

L’obiettivo non era riscrivere il design del paper, ma chiudere tre domande rimaste aperte:

1. se il `Portugal placebo` puo diventare un controllo esterno credibile;
2. se il blocco `beliefs` puo essere reso piu coerente e piu leggibile;
3. se possiamo integrare il tema `employment` con dati piu vicini agli anni `1960s-1970s` senza buttare via i survey gia usati.

## 1. Cosa Ho Scaricato E Costruito

### Fonte 1. OWID / HFD completed cohort fertility

Ho usato il file scaricato in [owid_hfd_spain_portugal_cohort_fertility.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_data/raw/owid_hfd_spain_portugal_cohort_fertility.csv), che contiene la completed cohort fertility per Spagna e Portogallo.

Pulizia:

- filtro su `Spain` e `Portugal`
- rinomina variabili
- costruzione del dataset finale [portugal_spain_hfd_completed_fertility.dta](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/generated/portugal_spain_hfd_completed_fertility.dta)

Motivazione:

- e molto piu vicino al reviewer point `Portugal placebo` di quanto non lo sia un survey attitudinale
- usa outcome di fertilita, non beliefs o proxy indirette

### Fonte 2. Banco de Espana historical EPA dataset

Ho scaricato il workbook ufficiale [bde_dt9409_series.xlsx](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_data/raw/bde_dt9409_series.xlsx), che contiene `43` serie storiche trimestrali `1964-1992`.

Pulizia:

- parsing dell’indice ufficiale delle serie
- trasformazione dei fogli `cuadro_01`-`cuadro_08` in formato long
- creazione di:
  - [bde_dt9409_index.dta](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/generated/bde_dt9409_index.dta)
  - [bde_dt9409_series_quarterly.dta](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/generated/bde_dt9409_series_quarterly.dta)
  - [bde_dt9409_series_annual.dta](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/generated/bde_dt9409_series_annual.dta)

Motivazione:

- non sostituisce un microdataset femminile, ma aggiunge un supporto ufficiale pulito sul contesto macro del `1973`
- consente di vedere dove si concentra la riallocazione del lavoro: industria, costruzioni, servizi, settore pubblico

### Fonte 3. IVS integrato gia presente nel progetto

Ho riutilizzato [Integrated_values_surveys_1981-2022.dta](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/original_data/IVS/Integrated_values_surveys_1981-2022.dta), ma con una strategia diversa dal primo passaggio.

Differenza rispetto al round precedente:

- non ho piu stimato solo item sparsi in Spagna
- ho costruito un blocco pooled `Spain vs Portugal`
- ho ristretto l’analisi alle waves comuni `1990`, `1999`, `2008`
- ho costruito un `traditional_index` e un `family_gender_index`

## 2. File Creati Ed Eseguiti

Build:

- [build_round2_external_sources.py](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/scripts/build_round2_external_sources.py)

Do-files:

- [external2_01_portugal_hfd.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/do/external2_01_portugal_hfd.do)
- [external2_02_beliefs_ivs_spain_portugal.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/do/external2_02_beliefs_ivs_spain_portugal.do)
- [external2_03_employment_support.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/do/external2_03_employment_support.do)
- [external2_run_all.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/do/external2_run_all.do)

Output principali:

- [external2_01_portugal_hfd_results.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/output/external2_01_portugal_hfd_results.csv)
- [external2_01_portugal_hfd_series.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/output/external2_01_portugal_hfd_series.csv)
- [external2_02_beliefs_results.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/output/external2_02_beliefs_results.csv)
- [external2_02_belief_sample_counts.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/output/external2_02_belief_sample_counts.csv)
- [external2_03_bde_break_results.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/output/external2_03_bde_break_results.csv)
- [external2_03_bde_period_means.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/output/external2_03_bde_period_means.csv)
- [external2_03_female_activity_structure_1981_copy.csv](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_round2/output/external2_03_female_activity_structure_1981_copy.csv)

## 3. Workstream A. Portugal Placebo

### Reviewer concern

Il reviewer suggerisce che il pattern di coorte possa riflettere un trend sud-europeo comune, quindi chiede di guardare al Portogallo.

### Intuizione del test

Se la Spagna mostra un gradiente di fertility per coorte simile al Portogallo, il placebo non aiuta il paper.
Se invece il profilo spagnolo diverge chiaramente da quello portoghese, il placebo puo rafforzare l’interpretazione.

### Implementazione

Ho costruito lo stesso schema di coorti del paper:

- controllo: `<= 1929`
- partially treated: `1930-1938`
- fully treated: `1939+`

Poi ho stimato:

1. `PT only`, senza trend
2. `PT only`, con trend lineare di coorte
3. pooled `Spain + Portugal`, senza trend
4. pooled `Spain + Portugal`, con trend lineare specifico per paese
5. pooled `Spain + Portugal`, con trend quadratico specifico per paese

### Risultati

Nel solo Portogallo:

- senza trend:
  - `treat_2 = -0.071`
  - `treat_3 = -0.549`
- con trend lineare:
  - `treat_2 = 0.245`, `p = 0.001`
  - `treat_3 = 0.241`, `p = 0.071`

Nel pooled `Spain vs Portugal`:

- senza trend:
  - `spain_treat2 = 0.192`, `p < 0.001`
  - `spain_treat3 = 0.426`, `p < 0.001`
- con trend lineare specifico per paese:
  - `spain_treat2 = 0.043`, `p = 0.663`
  - `spain_treat3 = -0.012`, `p = 0.948`
- con trend quadratico specifico per paese:
  - `spain_treat2 = 0.136`, `p = 0.006`
  - `spain_treat3 = 0.208`, `p = 0.010`

### Come leggere i risultati

Questo e un placebo molto sensibile alla forma del trend.

La figura numerica dei livelli aiuta a capire perche:

- nelle coorti di controllo, la Spagna parte sotto il Portogallo di circa `0.4-0.45` figli completati
- il gap si chiude gradualmente lungo gli anni `1930s`
- nelle coorti `1945-1950`, la Spagna arriva anche leggermente sopra il Portogallo

Quindi il risultato pooled dipende parecchio da come si parametrizza la convergenza pre-esistente tra i due paesi.

### Lettura rispetto al reviewer

Il test non salva il paper, ma neppure lo distrugge.

La conclusione corretta e:

- il Portogallo non e un controfattuale pulito
- il placebo puo stare come check descrittivo o appendix
- non lo userei come prova principale nella response letter

## 4. Workstream B. Beliefs Con IVS Pooled Spain vs Portugal

### Reviewer concern

Il reviewer dubita che la sezione beliefs sia abbastanza causale o abbastanza robusta.

### Intuizione del test

Il blocco beliefs migliora se:

- uso solo waves comuni tra Spagna e Portogallo
- costruisco un indice interpretabile
- leggo il risultato come differenziale Spagna rispetto al Portogallo, non come una collezione di singoli coefficienti su item eterogenei

### Variabili costruite

Ho usato questi item IVS:

- `C001`: jobs scarce, men should have more right to a job than women
- `D019`: a woman has to have children to be fulfilled
- `D057`: being a housewife just as fulfilling
- `D058`: husband and wife should both contribute to income
- `D061`: pre-school child suffers with working mother
- `D062`: women want a home and children
- `F120`: justifiable abortion

Ho orientato tutti gli item in direzione `piu tradizionale = valore piu alto`, poi li ho standardizzati e aggregati in:

- `traditional_index`
- `family_gender_index`

### Campione

Solo donne, solo `Spain` e `Portugal`, solo waves comuni:

- `1990`
- `1999`
- `2008`

Counts:

- Spagna: `1951`, `468`, `548`
- Portogallo: `527`, `474`, `709`

### Regressioni

1. `Spain only`
2. pooled `Spain + Portugal` con interazioni `spain_treat2` e `spain_treat3`

FE:

- region-country FE
- survey year FE
- age-class FE

### Risultati

Sull’indice complessivo:

- `traditional_index`, pooled:
  - `spain_treat2 = -0.040`, `p = 0.408`
  - `spain_treat3 = -0.060`, `p = 0.292`

Sull’indice famiglia/genere:

- `family_gender_index`, pooled:
  - `spain_treat2 = -0.053`, `p = 0.259`
  - `spain_treat3 = -0.065`, `p = 0.286`

Sul singolo item piu leggibile:

- `women want a home and children`:
  - `spain_treat2 = -0.177`, `p = 0.018`
  - `spain_treat3 = -0.093`, `p = 0.319`

Su Spagna soltanto:

- l’indice complessivo non raggiunge significativita
- alcuni item singoli vanno nella direzione attesa, ma con precisione limitata

### Come leggere i risultati

Questo round migliora molto la leggibilita del blocco beliefs, ma non cambia il verdetto sostantivo:

- gli effetti sono al massimo suggestivi
- gli indici complessivi non sono robusti
- la maggior parte dell’informazione arriva da pochi item specifici

### Lettura rispetto al reviewer

Qui il messaggio giusto e prudente:

- abbiamo rafforzato il blocco beliefs con una strategia pooled e un indice comune
- il segnale va in direzione coerente con una minore tradizionalita in alcune coorti spagnole
- ma questa non e evidenza causale forte

Quindi io lo terrei solo come `mechanism suggestive evidence`.

## 5. Workstream C. Employment Support Con BdE E Censo 1981

### Reviewer concern

Ci sono due critiche vicine:

1. `Law 56` potrebbe aver inciso via lavoro femminile piu che via scuola/cultura;
2. la `crisi del 1973` potrebbe contaminare i risultati di fertilita attraverso il mercato del lavoro.

### Intuizione del test

Qui non ho provato a inventare un microtest che i dati non permettono.
Ho fatto una cosa piu onesta:

- usare il `BdE` per vedere se il `1973` produce davvero una rottura macro nei settori plausibilmente piu esposti;
- riusare il `Censo 1981` per ricordare quanto piccolo fosse ancora il mercato del lavoro femminile.

### Punto metodologico importante

I dati survey gia usati nel paper non vanno scartati.

Infatti:

- in [Main_analysis.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/DO/new/Main_analysis.do) esiste gia un blocco employment individuale con `lab2_1`, `lab2_2`, `lab2_5`
- in [05_import_cis.do](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/progs/data/05_import_cis.do) la variabile `unemployed` usa gia `1979` e `1986-1992`

Quindi il senso di questo workstream e:

- non sostituire i survey
- ma triangolarli con fonti ufficiali nuove

### Implementazione

Dal `BdE` ho costruito serie annuali `1964-1981` per:

- occupati totali
- occupati industria
- occupati costruzioni
- occupati servizi
- disoccupati totali
- salariati amministrazione pubblica
- salariati settore privato

Poi ho costruito:

- `industry_share`
- `construction_share`
- `services_share`
- `unemployment_share`
- `public_admin_share_wage`

e stimato un semplice break annuale al `1973`.

### Risultati macro BdE

Break annuale:

- `construction_share`: `post73_trend = -0.00232`, `p = 0.001`
- `unemployment_share`: `post73_trend = 0.01414`, `p < 0.001`
- `public_admin_share_wage`: `post73_trend = 0.00703`, `p < 0.001`
- `services_share`: trend crescente gia forte, `p < 0.001`

Confronto medie `1964-1972` vs `1973-1981`:

- `unemployment_share`: `1.43%` -> `6.51%`
- `industry_share`: `24.19%` -> `26.87%`
- `construction_share`: `8.81%` -> `9.37%`
- `services_share`: `33.97%` -> `41.99%`
- `public_admin_share_wage`: `10.40%` -> `12.58%`

### Risultati Censo 1981 lato femminile

- `active_share_total = 22.37%`
- `occupied_share_total = 17.72%`
- `inactive_share_total = 77.63%`
- `urban active_share_total = 24.71%`
- `urban occupied_share_total = 19.21%`

### Come leggere i risultati

Il `1973` e chiaramente un vero shock macro.

Il BdE lo conferma bene:

- la disoccupazione accelera
- la struttura occupazionale continua a spostarsi verso i servizi
- il peso del settore pubblico salariale aumenta
- le costruzioni smettono di crescere come prima

Ma il lato femminile resta piccolo anche nel `1981`.

Questo punto e cruciale:

- la critica `1973` merita di essere presa sul serio
- la critica `Law 56 = enorme shock occupazionale femminile generalizzato` riceve meno supporto quantitativo

### Lettura rispetto al reviewer

Per la response letter io userei questo blocco cosi:

- riconosciamo che il `1973` ha modificato davvero il contesto macro del lavoro
- per questo includiamo i robustness gia costruiti sul taglio pre-`1972` e sulle proxy di esposizione settoriale
- ma i nuovi dati esterni non sostengono una lettura in cui il vostro risultato e interamente un artefatto di una massiccia espansione del lavoro femminile

## 6. Cosa Terrei E Cosa No

### Terrei

- `employment support`
  - perche integra bene il punto sulla crisi del `1973`
  - perche aiuta a non buttare via i survey employment gia presenti
  - perche rende piu credibile una risposta equilibrata al reviewer

### Terrei Con Tono Prudente

- `beliefs`
  - solo come evidenza suggestiva
  - non come test chiave

### Appendix O Fuori Dal Core

- `Portugal placebo`
  - troppo sensibile alla specificazione del trend
  - utile solo per mostrare che il Portogallo non e un controfattuale semplice

## 7. Bottom Line

Questo secondo round esterno non aggiunge un nuovo “killer test”, ma fa tre cose utili:

1. mette ordine nel blocco `Portugal` e mostra perche va trattato con cautela;
2. rende i `beliefs` piu leggibili e meno impressionistici;
3. rafforza il framing su `employment` e `1973` senza rinunciare ai survey gia usati nel paper.

La mia sintesi operativa e:

- `employment support`: `keep`
- `beliefs`: `appendix / suggestive`
- `Portugal`: `appendix / maybe drop from main narrative`
