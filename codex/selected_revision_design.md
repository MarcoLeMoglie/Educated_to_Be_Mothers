# Selected Revision Design

Questo file accumula, punto per punto, le analisi che decidiamo di tenere per la versione finale.

Per ogni punto annotiamo:

- cosa teniamo
- perche lo teniamo
- come lo runniamo
- cosa lasciamo fuori per ora

## Punto 1. Law 56 / 1961

### Cosa teniamo

- baseline micro con `a(i.year##i.id##age_c)` e `cluster(year#i.year_birth)`
- horse-race con `law56_share_20_35`
- specifica con `law56_share_20_35` + `crisis73_share_25_35`
- specifica con `law56_share_20_35` + `year_partner`

### Perche

- `20-35` e la misura piu difendibile sostantivamente per completed fertility, perche copre non solo l'ingresso nella vita adulta ma anche una parte plausibile del margine intensivo
- `20-35` mantiene il campione baseline e quindi rende il confronto piu pulito con la regressione senza controllo Law 56
- con `18-30` il coefficiente `treat_3` si indebolisce ulteriormente, ma quella specifica cambia anche finestra di coorti, quindi e meno adatta come confronto principale
- la specifica con `1973` serve per mostrare che il segnale Law 56 non diventa piu forte quando si controlla anche per lo shock macro successivo
- la specifica con `year_partner` serve per verificare se il margine passi attraverso timing del partner/matrimonio

### Come lo runniamo

File:

- `codex/do/revision_01_law56_horserace.do`

Specifiche chiave:

```stata
quietly reghdfe `outcome' treat_2 treat_3 ///
    if female == 1 & year_birth <= 1950, ///
    a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)

quietly reghdfe `outcome' treat_2 treat_3 law56_share_20_35 ///
    if female == 1 & year_birth <= 1950, ///
    a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)

quietly reghdfe `outcome' treat_2 treat_3 law56_share_20_35 crisis73_share_25_35 ///
    if female == 1 & year_birth <= 1950, ///
    a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)

quietly reghdfe `outcome' treat_2 treat_3 law56_share_20_35 year_partner ///
    if female == 1 & year_birth <= 1950, ///
    a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
```

Output di riferimento:

- `codex/output/revision_01_law56_results.csv`

### Cosa lasciamo fuori per ora

- `law56_share_18_30` come specifica principale
- donut sulle coorti `1936-1941`
- donut piu stretto `1936-1939`

### Motivo per cui lo lasciamo fuori

- `18-30` non e il confronto piu pulito con la baseline perche cambia anche il campione
- il donut `1936-1941` e fragile: restringendo a `1936-1939` il risultato sparisce
- quindi per ora e meglio non costruire la risposta al reviewer su quel blocco

## Punto 1b. Law 56 - Mechanism Con Censo 1981

### Cosa teniamo

- tabella gap di fertilita `attive vs inattive`
- celle compatte della finestra `1961_1965` e `1966_1970`
- tabella dei tassi di attivita femminile `1981`
- tabella donne vs uomini sui tassi di attivita
- tabella di struttura femminile `occupied / unemployed / inactive`

### Perche

- il blocco mostra che il reviewer point sul meccanismo non e assurdo: le donne attive hanno davvero meno figli delle inattive nelle finestre vicine a `Law 56`
- ma mostra anche che il mercato del lavoro femminile resta piccolo persino nel `1981`, quindi e difficile sostenere una storia di grande shock occupazionale generalizzato
- questa combinazione e utile per una risposta equilibrata: meccanismo plausibile, ma scala quantitativa limitata

### Come lo runniamo

File:

- `codex/external_revisions/do/external_revision_04_activity_fertility_censo1981.do`

Output di riferimento:

- `codex/external_revisions/output/external_revision_04_activity_fertility_gap.csv`
- `codex/external_revisions/output/external_revision_04_law56_window_cells.csv`
- `codex/external_revisions/output/external_revision_04_female_activity_1981.csv`
- `codex/external_revisions/output/external_revision_04_female_activity_structure_1981.csv`
- `codex/external_revisions/output/external_revision_04_sex_activity_gap_1981.csv`

### Risultati chiave da tenere

Gap figli tra attive e inattive:

- `1961_1965`, età `25-29`: `2.1` vs `2.8`, gap `-0.7`
- `1966_1970`, età `25-29`: `2.56` vs `3.20`, gap `-0.64`
- `1971_1975`, età `25-29`: `1.76` vs `2.20`, gap `-0.44`

Scala del lavoro femminile nel `1981`:

- tasso di attivita femminile nazionale `22.37%`
- tasso di attivita femminile urbano `24.71%`
- tasso di attivita femminile rurale `18.67%`
- tasso di attivita maschile nazionale `73.12%`
- rapporto donne/uomini sul tasso di attivita solo `0.306` a livello nazionale
- tra tutte le donne, solo `17.7%` risultano occupate
- `77.6%` risultano inattive
- anche in urbano, le donne occupate sono solo `19.2%`

### Interpretazione

- il blocco va tenuto come supporto al meccanismo, non come identificazione causale
- e utile per dire che il segno del canale `female activity -> lower fertility` c'e gia vicino alla finestra `1961-1970`
- ma le percentuali del `1981` suggeriscono che il canale occupazionale fosse ancora troppo piccolo per spiegare da solo tutto il pattern del paper
- quindi il framing giusto e: evidenza coerente con il meccanismo, ma scala aggregata troppo limitata per sostenere che questo canale spieghi da solo il risultato principale

### Cosa lasciamo fuori per ora

- matrice completa zona x età x periodo matrimoniale
- profilo settoriale completo come tabella principale

### Motivo per cui lo lasciamo fuori

- la matrice completa e troppo ampia per il testo principale
- il profilo settoriale e utile come supporto, ma il messaggio forte qui e la piccola scala dell'occupazione femminile aggregata

## Punto 2. Migrazione interna nel macro panel

### Cosa teniamo

- baseline macro originale del paper con `alive` come outcome
- controlli per classi fertili femminili decennali `flag4_3 flag4_4 flag4_5`
- FE `a(i.id i.year#i.codprov)` e clustering per `id`
- specifica fino al `1972` come robustness temporale importante
- opzionalmente, una robustness secondaria con `births_per_female1544_lin`

### Perche

- questa e la specifica effettivamente usata nei tuoi codici attivi
- il reviewer non sta dicendo che non controlli per composizione; sta dicendo che il problema puo essere nei movimenti intradecennali
- la tua baseline controlla la dimensione delle classi fertili, ma solo usando livelli aggiornati a salti decennali
- la normalizzazione `step` non aggiunge sostanza rispetto alla tua specifica: sposta la stessa informazione dal lato destro al denominatore
- la normalizzazione `lin` aggiunge qualcosa solo perche approssima movimenti intradecennali tra un censimento e l'altro
- per questo la versione `lin` va bene come robustness secondaria, non come nuovo main result

### Come lo runniamo

Specifica baseline da tenere vicina al paper:

```stata
reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 ///
    flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
```

Specifica finestra pre-1973 da tenere:

```stata
reghdfe births_per_female1544_lin interaction interaction2 1.post##c.sum1 1.post##c.sum2 ///
    flag4_3 flag4_4 flag4_5 if year <= 1972, ///
    a(i.id i.year#i.codprov) cluster(id)
```

File di lavoro gia pronti:

- `codex/do/revision_02_migration_macro.do`
- `codex/output/revision_02_migration_results.csv`

### Cosa teniamo a mente nell'interpretazione

- la versione con `alive` + `flag4_3 flag4_4 flag4_5` resta il riferimento corretto per il paper
- la versione `lin` non dimostra che i movimenti intradecennali non contano; mostra solo che il risultato sopravvive anche con una correzione interpolata della popolazione fertile
- quindi il blocco macro puo aiutare contro il reviewer, ma non e la risposta piu forte

### Cosa lasciamo fuori per ora

- usare `births_per_female1544_step` come analisi da tenere
- vendere `ln_female1544` come risultato principale

### Motivo per cui lo lasciamo fuori

- `step` non aggiunge davvero nulla rispetto alla tua specifica originale
- `ln_female1544` e utile come diagnostica, ma non risponde da solo alla domanda causale del reviewer

## Punto 2c. Migrazioni Interne Con Censo 1981

### Cosa teniamo

- tabella `female mobility activity`
- tabella breve `female mobility sectors`
- regressione provinciale `stay_share` su exposure del trattamento con controllo per `muni_share_1940`

### Perche

- questo blocco esterno risponde al reviewer con dati ufficiali indipendenti dal panel del paper
- le movers appaiono diverse soprattutto per composizione urbana/settoriale, non per occupazione pura una volta dentro la labor force
- nel test provinciale controllato, il gradiente femminile del trattamento va semmai nella direzione di piu retention, non meno retention

### Come lo runniamo

File:

- `codex/external_revisions/do/external_revision_03_external_migration_censo1981.do`

Output di riferimento:

- `codex/external_revisions/output/external_revision_03_female_mobility_activity.csv`
- `codex/external_revisions/output/external_revision_03_female_mobility_sectors.csv`
- `codex/external_revisions/output/external_revision_03_province_mobility_regs.csv`

### Risultati chiave da tenere

Movers vs stayers:

- età `25-34`: movers `active_share = 0.289`, stayers `0.327`
- età `25-34`: movers `employed_share = 0.852`, stayers `0.855`

Test provinciale:

- `stay_on_gaps_ctrl`: `treat_gap_f = 0.00825`, `p = 0.016`
- `muni_share_1940 = 0.604`, `p = 0.002`

### Interpretazione

- la storia forte che emerge e urbanizzazione/retention, non svuotamento meccanico delle aree piu trattate
- se prendiamo sul serio il coefficiente significativo, il segnale va nella direzione opposta a quella temuta dal reviewer: piu treatment gap femminile e associato a piu retention, non meno retention

### Frase da paper / response

- i dati ufficiali del Censo `1981` non supportano una lettura di puro `out-migration bias`; le differenze tra movers e stayers sembrano riflettere soprattutto composizione urbana e settoriale, e a livello provinciale il gradiente femminile del trattamento e associato, se mai, a maggiore retention

### Cosa lasciamo fuori per ora

- ranking completo delle province per `stay_share`

### Motivo per cui lo lasciamo fuori

- il ranking grezzo e descrittivo; la parte davvero utile per il paper e il link con l'intensita del trattamento

## Punto 2d. Proxy Provinciali Pre-1973

### Cosa teniamo

- il file `province_pre73_crisis_proxies.dta` come infrastruttura
- la regola di audit `proxy_usable_pre73`
- l'intero set di proxy principali in un'unica tabella:
  `industrial_core_share_1950`, `oil_sensitive_share_1950`, `manuf_trade_share_1950`, `nonag_share_1950`

### Perche

- questo non e un reviewer point autonomo, ma rende credibili e replicabili i test esterni sulla crisi del `1973`
- avere una regola di audit esplicita aiuta a difendere il fatto che i test eterogenei si fanno su un sottocampione storicamente informato, non arbitrario
- tenere tutte le proxy insieme aiuta a mostrare che il risultato non dipende da una scelta opportunistica di una sola misura

### Come lo usiamo

File:

- `codex/external_revisions/generated/province_pre73_crisis_proxies.dta`
- `codex/external_revisions/notes/pre73_crisis_proxy_notes.md`

Numeri chiave:

- province utilizzabili: `37` su `50`
- proxy da mostrare insieme: `industrial_core_share_1950`, `oil_sensitive_share_1950`, `manuf_trade_share_1950`, `nonag_share_1950`

### Interpretazione

- questo blocco va citato come asset metodologico, non come risultato sostantivo
- serve a giustificare i sottocampioni e le eterogeneita del punto `1973`
- conviene mostrarlo come una sola tabella compatta di supporto, non come una serie di tabelle separate

### Cosa lasciamo fuori per ora

- descrizione lunga proxy-per-proxy nel main text

### Motivo per cui lo lasciamo fuori

- l'estrazione OCR storica non e ugualmente forte per tutte le province
- il suo valore principale e nel rendere piu credibili i test successivi, non nel generare un messaggio autonomo

## Punto 2b. Crisi Del 1973 Con Proxy Provinciali Esterne

### Cosa teniamo

- `full_sample_reference` con la stessa formula della colonna 4 di `Main_analysis.do`
- `proxy_sample_baseline` sul sottocampione di province con proxy pre-`1973` utilizzabili
- `proxy_sample_pre1972` come test temporale principale contro la storia "oil shock"
- un'unica tabella compatta di eterogeneita con tutte le proxy provinciali principali:
  `industrial_core_share_1950`, `oil_sensitive_share_1950`, `manuf_trade_share_1950`, `nonag_share_1950`

### Perche

- il `full_sample_reference` serve a mostrare dentro lo stesso file che la specifica esterna non cambia la baseline del paper
- il `proxy_sample_baseline` serve a far vedere cosa succede quando si restringe il campione alle province con informazione storica auditata sulla struttura economica
- `proxy_sample_pre1972` e il test piu utile contro il reviewer: se il coefficiente resta negativo prima del `1973`, la lettura "e solo crisi petrolifera" perde forza
- tenere tutte le proxy in un'unica tabella compatta evita sia di perdere informazione sia di appesantire il paper con una batteria dispersa di risultati quasi uguali

### Come lo runniamo

File:

- `codex/external_revisions/do/external_revision_02_crisis73_macro_proxies.do`

Specifiche chiave:

```stata
reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 ///
    flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)

reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 ///
    flag4_3 flag4_4 flag4_5 if proxy_usable_pre73 == 1, ///
    a(i.id i.year#i.codprov) cluster(id)

reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 ///
    flag4_3 flag4_4 flag4_5 if proxy_usable_pre73 == 1 & year <= 1972, ///
    a(i.id i.year#i.codprov) cluster(id)

foreach proxy in industrial_core_share_1950 oil_sensitive_share_1950 manuf_trade_share_1950 nonag_share_1950 {
    gen crisis_f = interaction * post73 * z_`proxy'
    gen crisis_m = interaction2 * post73 * z_`proxy'

    reghdfe alive interaction interaction2 crisis_f crisis_m 1.post##c.sum1 1.post##c.sum2 ///
        flag4_3 flag4_4 flag4_5 if proxy_usable_pre73 == 1, ///
        a(i.id i.year#i.codprov) cluster(id)

    drop crisis_f crisis_m
}
```

Output di riferimento:

- `codex/external_revisions/output/external_revision_02_crisis73_macro_proxies.csv`

### Risultati chiave da tenere

Replica full sample della colonna 4 del main macro:

- `interaction = -478.0`, `p = 0.048`
- `interaction2 = -176.3`, `p = 0.238`

Sottocampione con proxy valide:

- `interaction = -487.2`, `p = 0.062`
- `interaction2 = -157.3`, `p = 0.259`

Sottocampione con proxy valide e finestra `<= 1972`:

- `interaction = -381.9`, `p = 0.072`
- `interaction2 = -218.7`, `p = 0.052`

Eterogeneita raccolta in una sola tabella:

- `industrial_core_share_1950`: nessun termine `post73 x proxy` significativo
- `oil_sensitive_share_1950`: `crisis_f = -346.6`, `p = 0.451`; `crisis_m = 344.0`, `p = 0.395`
- `manuf_trade_share_1950`: solo segnale borderline sul lato femminile (`p = 0.096`)
- `nonag_share_1950`: nessun termine `post73 x proxy` significativo

### Interpretazione

- la differenza tra baseline macro del paper e baseline del file esterno nasce dal campione, non dalla formula
- passando da `50` a `37` province il coefficiente femminile resta molto simile in magnitudine e segno, ma perde precisione
- il risultato non sparisce quando si restringe il campione o quando si taglia il periodo a pre-`1973`
- la tabella unica di eterogeneita non mostra un pattern robusto per cui il post-`1973` diventi piu negativo proprio nelle province piu esposte ai settori oil-sensitive o piu industriali

### Cosa lasciamo fuori per ora

- usare il blocco esterno come nuova baseline principale del paper
- tabelle separate per ciascuna proxy

### Motivo per cui lo lasciamo fuori

- il ruolo del blocco esterno e difensivo: mostrare che il risultato del paper non e un artefatto del sottocampione o della sola crisi del `1973`, non sostituire la baseline originale
- tabelle separate renderebbero il blocco ridondante; una tabella unica basta

## Punto 3. Birthplace, residence, movers and stayers

### Cosa teniamo

- baseline census esattamente coerente con `Main_analysis.do`
- specifica con FE del luogo di nascita
- specifica con FE del luogo di nascita + residenza attuale
- specifiche separate per movers e stayers
- outcome principale `nhijos`
- outcome complementare `kids2`

### Perche

- questo e il blocco piu diretto per rispondere all'obiezione sul sorting geografico
- dopo la correzione del do-file la baseline ora replica il tuo `Main_analysis`
- il risultato su `nhijos` resta negativo e significativo anche quando si controlla il birthplace, quando si controllano insieme birthplace e current residence, e quando si separano movers e stayers
- quindi questo e il pezzo piu forte da mettere al centro della risposta al reviewer

### Come lo runniamo

File:

- `codex/do/revision_03_birthplace_stayers.do`

Costruzione da tenere uguale a `Main_analysis.do`:

- nel 1991: `kids2 = hijos > 0`
- nel 2011: `kids2 = hijos == 1`
- `nhijos = 0 if kids2 == 0`
- `age_c = floor(edad/10)`
- `weight2 = fe` nel 1991 e `factor` nel 2011

Specifiche:

```stata
quietly reghdfe `outcome' treat_2 treat_3 ///
    if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
    a(cmun##i.age_c##year) cluster(year#anac) version(5)

quietly reghdfe `outcome' treat_2 treat_3 ///
    if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)

quietly reghdfe `outcome' treat_2 treat_3 ///
    if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
    a(i.year##i.age_c##i.codprov##i.codprov_born) cluster(year#anac) version(5)
```

Output:

- `codex/output/revision_03_birthplace_results.csv`
- `codex/output/revision_03_birthplace_shares.csv`

### Risultati chiave da tenere

Per `nhijos`:

- baseline: `treat_3 = -0.0777`, `p = 0.000028`
- `birthprov_fe`: `treat_3 = -0.1518`, `p < 0.001`
- `birth_current_fe`: `treat_3 = -0.1435`, `p < 0.001`
- movers: `treat_3 = -0.1615`, `p < 0.001`
- stayers: `treat_3 = -0.1174`, `p < 0.001`

Per `kids2`:

- i coefficienti sono negativi e imprecisi nelle specifiche corrette, quindi non vanno enfatizzati

Quote descrittive utili:

- `stayer_birthprov = 0.415` nel 1991 e `0.702` nel 2011
- `moved_10y = 0.480` nel 1991 e `0.036` nel 2011

### Cosa lasciamo fuori per ora

- usare `kids2` come messaggio principale

### Motivo per cui lo lasciamo fuori

- nella versione coerente con il tuo `Main_analysis` il segnale forte e pulito e su `nhijos`, non su `kids2`

## Punto 3b. Guerra civile nel luogo di nascita

### Guerra civile nel luogo di nascita

Stato:

- da tenere

Cosa abbiamo gia:

- nei vecchi script `progs/data/06_ine_microdatos.do` il merge microdata-territorio per 1991/2001/2011 avviene usando la provincia di nascita come chiave
- nei microdata risultanti sono gia presenti almeno:
  - `sh_area_front`
  - `distance`
  - `logdistance`
  - `sancionados`

File rilevanti:

- `output_data/dataset_microdata1991.dta`
- `output_data/dataset_microdata2001.dta`
- `output_data/dataset_microdata2011.dta`
- `output_data/dataset_PROVINCElevel.dta`

Specifica scelta:

- usare `sh_area_front` nel luogo di nascita
- non come semplice controllo additivo, ma interagito con le coorti trattate

Perche:

- con FE di birthplace il main effect di `sh_area_front` e assorbito
- il punto del reviewer non e solo che i luoghi di nascita differiscono, ma che le coorti trattate possano reagire diversamente in luoghi piu colpiti dalla guerra
- quindi la specifica giusta e lasciare che `sh_area_front` abbia un effetto differenziale per `treat_2` e `treat_3`

Come la runniamo:

- file `codex/do/revision_07_birthplace_civilwar.do`
- merge di `sh_area_front` sul `codprov_born`
- specifiche:

```stata
gen front_treat2 = sh_area_front * treat_2 if sh_area_front < .
gen front_treat3 = sh_area_front * treat_3 if sh_area_front < .

quietly reghdfe `outcome' treat_2 treat_3 front_treat2 front_treat3 ///
    if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)

quietly reghdfe `outcome' treat_2 treat_3 front_treat2 front_treat3 ///
    if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
    a(i.year##i.age_c##i.codprov##i.codprov_born) cluster(year#anac) version(5)
```

Output:

- `codex/output/revision_07_birthplace_civilwar_results.csv`

Risultato da tenere a mente:

- per `nhijos`, `treat_3` resta negativo e significativo anche con il controllo di guerra civile nel birthplace
- nella specifica con FE di nascita + residenza attuale: `treat_3 = -0.0917`, `p < 0.001`
- nella specifica con FE di birthplace: `treat_3 = -0.1050`, `p < 0.001`
- quindi il risultato principale su completed fertility non sembra essere guidato solo dall'intensita della guerra civile nel luogo di nascita

Cautele:

- il match con le covariate territoriali di guerra riduce il campione
- per ora stiamo usando `sh_area_front`; volendo, `logdistance` e `sancionados` restano misure alternative da esplorare

## Punto 3c. Proxy pre-1973 nel luogo di nascita

### Cosa teniamo

- il test micro che assegna le proxy pre-`1973` al luogo di nascita
- sia la specifica con FE di birthplace sia la specifica con FE di birthplace + residenza attuale
- outcome principale `nhijos`
- tabella compatta con le quattro proxy:
  `industrial_core_share_1950`, `oil_sensitive_share_1950`, `manuf_trade_share_1950`, `nonag_share_1950`

### Perche

- questa e la versione micro piu pulita della risposta alla storia alternativa sullo `oil shock`
- l'exposure e predeterminata e assegnata sul luogo di nascita, quindi evita il problema di usare una misura occupazionale individuale osservata molti anni dopo
- tenere anche la specifica con FE di nascita + residenza attuale permette di mostrare che il risultato non dipende da sorting successivo verso luoghi diversi
- la tabella con quattro proxy rende il blocco coerente con il test macro esterno e permette di mostrare che il messaggio non dipende da una sola misura settoriale

### Come lo runniamo

File:

- `codex/do/revision_08_birthplace_crisis73.do`

Logica:

- merge di `province_pre73_crisis_proxies.dta` sul `codprov_born`
- restrizione a `proxy_usable_pre73 == 1`
- standardizzazione delle proxy nel campione utilizzabile
- interazioni tra proxy standardizzata e `treat_2`, `treat_3`

Specifiche chiave:

```stata
reghdfe nhijos treat_2 treat_3 oilsens_t2 oilsens_t3 ///
    if sexo == 6 & inrange(anac, 1920, 1950) & proxy_usable_pre73 == 1 [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)

reghdfe nhijos treat_2 treat_3 oilsens_t2 oilsens_t3 ///
    if sexo == 6 & inrange(anac, 1920, 1950) & proxy_usable_pre73 == 1 [aw=weight2], ///
    a(i.year##i.age_c##i.codprov##i.codprov_born) cluster(year#anac) version(5)
```

Output:

- `codex/output/revision_08_birthplace_crisis73_results.csv`

### Risultati chiave da tenere

Baseline nel sottocampione con proxy valide:

- `birthprov_fe_proxy`: `treat_3 = -0.1884`, `p < 0.001`
- `birth_current_fe_proxy`: `treat_3 = -0.1821`, `p < 0.001`

Con `oil_sensitive_share_1950`:

- `birthprov_oil_sensitive_share_1950`: `oilsens_t3 = 0.0961`, `p < 0.001`, ma `treat_3` resta `-0.1742`, `p < 0.001`
- `birth_current_oil_sensitive_share_1950`: `oilsens_t3 = 0.0965`, `p < 0.001`, ma `treat_3` resta `-0.1677`, `p < 0.001`

Coerenza con le altre proxy:

- `industrial_core_share_1950` e `nonag_share_1950` mostrano interazioni positive e significative, ma il coefficiente `treat_3` resta sempre negativo e molto preciso
- `manuf_trade_share_1950` ha interazioni piccole e imprecise, e anche li `treat_3` resta quasi invariato

### Interpretazione

- questo blocco non dice che le province piu oil-exposed non siano diverse
- dice che, anche consentendo a queste differenze pre-`1973` di interagire con le coorti trattate nel luogo di nascita, il risultato principale su `nhijos` non sparisce
- quindi la storia "state solo prendendo esposizione territoriale preesistente allo shock petrolifero" non sembra sufficiente a spiegare il risultato micro

### Cosa lasciamo fuori per ora

- usare questi test su `kids2` come pezzo principale
- interpretare le interazioni positive delle proxy come meccanismo strutturale forte

### Motivo per cui lo lasciamo fuori

- su `kids2` il segnale di baseline resta debole
- le interazioni con le proxy sono interessanti ma per ora vanno lette come robustness reviewer-facing, non come nuovo risultato meccanicistico del paper

## Punto 2b-3c. Sintesi finale del blocco 1973

### Cosa teniamo insieme

- test macro con le quattro proxy pre-`1973` in un'unica tabella
- test micro sul luogo di nascita con le stesse quattro proxy in un'unica tabella
- specifica micro con FE di birthplace
- specifica micro con FE di birthplace + residenza attuale

### Messaggio unitario

- nel macro, il coefficiente principale resta negativo e di magnitudine simile quando si restringe il campione alle province con proxy valide e quando si ferma il campione prima del `1973`
- nel macro, la tabella unica di eterogeneita non mostra un pattern robusto per cui il post-`1973` diventi piu negativo proprio nelle province piu oil-sensitive
- nel micro, assegnando al luogo di nascita proxy predeterminate di esposizione settoriale pre-`1973`, il coefficiente su `nhijos` resta negativo e molto preciso
- nel micro, questo resta vero anche quando si controllano simultaneamente FE di luogo di nascita e di residenza attuale

### Frase da paper / response

- nel complesso, i test macro e micro non supportano la lettura secondo cui il risultato principale sarebbe generato soprattutto dall'esposizione territoriale preesistente allo shock petrolifero del `1973`; il pattern sopravvive sia prima del `1973` sia quando l'esposizione pre-crisi viene assegnata al luogo di nascita nelle regressioni micro

## Punto 4. Macro pretrend ed eterogeneita

### Cosa teniamo

- split per church intensity
- test macro che controlla esplicitamente per `civil war intensity × post`

### Cosa non teniamo come evidenza principale

- il test complessivo di pretrend
- la split per war intensity per median split

### Perche

- l'event study e gia presente nel paper e basta per mostrare la dinamica temporale
- il test complessivo di pretrend aggiunge poco e rischia solo di indebolire inutilmente la presentazione
- lo split per church intensity sembra invece informativo e coerente
- per la guerra la cosa giusta non e dividere il campione high/low war, ma controllare direttamente per `intensity × post`

### Come lo runniamo

File / logica:

- `codex/do/revision_04_macro_pretrends_heterogeneity.do`
- split per church con `alive`
- test di guerra da prendere dal blocco attivo in `Marco/DO/new/Main_analysis.do` con:

```stata
gen interaction3 = post * deaths_male_cwar

reghdfe alive interaction interaction2 interaction3 ///
    1.post##c.sum1 1.post##c.sum2 1.post##c.deaths_male_cwar ///
    flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
```

Output:

- `codex/output/revision_04_macro_pretrend_results.csv`

### Risultati chiave da tenere

Church split con `alive`:

- `church_0`: `interaction = -1535.18`, `p = 0.0019`
- `church_1`: `interaction = -218.67`, `p = 0.0210`

War control da tenere:

- non la split `high_war / low_war`
- si tiene invece il controllo diretto `interaction3 = post * deaths_male_cwar`

### Interpretazione

- la split per church puo essere citata come evidenza coerente ma secondaria
- per la guerra la risposta piu pulita e mostrare che il risultato non dipende solo dall'intensita della guerra civile locale quando la si controlla direttamente nel modello
- il test complessivo di pretrend non entra nella selezione finale

### Decisione pratica

- tenere church split
- tenere controllo diretto `civil war intensity × post`
- lasciare fuori il pretrend joint test e la split war high/low

## Punto 5. IVS, Portogallo e confronti esterni

### Decisione

- lasciare fuori questo blocco dalla selezione finale

### Perche

- il Portogallo non funziona come placebo rassicurante: sulle misure di fertilita compaiono effetti significativi di segno opposto alla Spagna
- il pooled diff `Spain-Portugal` non mostra un differenziale spagnolo pulito e preciso
- il check rapido con l'Italia e meno dannoso del Portogallo, ma non fornisce comunque un differenziale `Spain-Italy` abbastanza preciso da aiutare il paper
- i beliefs IVS sono troppo sparsi per sostenere un meccanismo in modo convincente

### Cosa teniamo a mente

- il blocco puo restare eventualmente come esplorazione interna o appendix remota
- non va usato nella risposta principale al reviewer e non entra nel do finale integrato
