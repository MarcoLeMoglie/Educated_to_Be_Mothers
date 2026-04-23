# Rerun revisioni Stata con baseline corretta

Questo README documenta il rerun del bundle `codex/do/revision_run_all.do` fatto il 3 aprile 2026 usando la baseline dei codici attivi in `Marco/DO/new/Main_analysis.do`.

## Specifica usata

La richiesta era di usare come baseline micro la specifica con interazione completa tra fixed effects e clustering sull'interazione tra anno di intervista e anno di nascita.

In pratica il rerun ha usato:

- CIS / Law 56: `a(i.year##i.id##age_c)` con `cluster(year#i.year_birth)`
- IVS: `a(i.id_region##age_c##i.year)` con `cluster(year#i.year_birth)`
- Census 1991-2011: `a(cmun##i.age_c##year)` con `cluster(year#anac)`

I file aggiornati per allineare la baseline sono:

- `codex/do/revision_01_law56_horserace.do`
- `codex/do/revision_03_birthplace_stayers.do`
- `codex/do/revision_05_ivs_placebo_beliefs.do`

Gli script macro (`revision_02` e `revision_04`) non usano `year_birth`, quindi non richiedevano cambi di specifica, ma sono stati comunque rilanciati per avere un pacchetto coerente.

## Come rilanciare

Comando batch:

```bash
/Applications/Stata/StataMP.app/Contents/MacOS/stata-mp -b do /Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/do/revision_run_all.do
```

Output principali:

- `codex/output/revision_01_law56_results.csv`
- `codex/output/revision_02_migration_results.csv`
- `codex/output/revision_03_birthplace_results.csv`
- `codex/output/revision_03_birthplace_shares.csv`
- `codex/output/revision_04_macro_pretrend_results.csv`
- `codex/output/revision_05_ivs_results.csv`
- `codex/output/revision_06_post1950_results.csv`

Nota IVS:

- nel file `revision_05_ivs_results.csv` i `p-value` sono stati ricalcolati sul dataset finale come `2*normal(-abs(b/se))`, perché la colonna `p` postata dal blocco originario risultava non affidabile

## Lettura dei risultati

### 1. Law 56 / 1961

Con la baseline corretta la parte Law 56 diventa molto piu debole.

Risultati chiave:

- `kids`, baseline: `treat_2 = -0.0064` (`p = 0.735`), `treat_3 = 0.0025` (`p = 0.919`)
- `nkids`, baseline: `treat_2 = -0.1767` (`p = 0.179`), `treat_3 = -0.3438` (`p = 0.023`)
- aggiungendo `law56_share_20_35`, il coefficiente della share non e significativo per `kids` o `nkids`
- nella specifica con `crisis73_share_25_35`, la crisi del 1973 entra negativa su `nkids` (`p = 0.068`), mentre l'effetto Law 56 resta poco preciso
- nella donut che esclude le coorti `1936-1941`, `treat_3` diventa positivo sia per `kids` (`0.244`, `p = 0.044`) sia per `nkids` (`1.095`, `p = 0.035`)

Interpretazione:

- la narrativa "Law 56 spiega i risultati principali" non esce forte con questa baseline
- il risultato piu pulito nel baseline e una riduzione di `nkids` per le fully treated
- ma il segno si ribalta nella donut, quindi la lettura e sensibile alla finestra campionaria
- in sostanza: con la specifica corretta, Law 56 sembra al massimo una possibile concausa, non il driver robusto del pattern principale

### 2. Migrazione interna nel macro panel

I risultati macro restano quelli gia emersi nel primo run.

Risultati chiave:

- `birthrate_lin`, baseline continua: `interaction = -4.62` (`p = 0.0017`), `interaction2 = -8.31` (`p < 0.001`)
- il risultato resta negativo anche limitando a `year <= 1972`
- la versione discreta conferma un forte effetto negativo per `dinteraction`
- `alive` ha un coefficiente negativo su `interaction` (`p = 0.048`)
- `ln_female1544` non mostra movimento su `interaction`, ma `interaction2` e negativo (`p < 0.001`)

Interpretazione:

- il calo di fertilita nel macro panel rimane netto
- non c'e evidenza semplice che tutto sia solo un artefatto di composizione sulla popolazione femminile 15-44
- pero il fatto che anche `alive` e una misura di stock femminile reagiscano suggerisce prudenza: la mobilita interna puo contribuire alla dinamica territoriale, anche se non sembra assorbire da sola il risultato di fertilita

### 3. Birthplace vs residence nei census 1991-2011

Questo e il blocco che regge meglio dopo la correzione della baseline.

Risultati chiave:

- `kids2`, baseline: `treat_2 = 0.0023` (`p < 0.001`), `treat_3 = 0.0048` (`p < 0.001`)
- `nhijos`, baseline: `treat_2 = -0.0167` (`p = 0.023`), `treat_3 = -0.0704` (`p = 0.001`)
- con FE di provincia di nascita o di nascita + residenza attuale, `nhijos` resta sempre negativo e significativo
- tra movers, `nhijos` per le fully treated e `-0.1270` (`p < 0.001`)
- tra stayers, `nhijos` per le fully treated e `-0.0876` (`p < 0.001`)

Quote descrittive:

- `stayer_birthprov = 0.415` nel 1991 e `0.702` nel 2011
- `moved_10y = 0.480` nel 1991 e `0.036` nel 2011

Interpretazione:

- il margine estensivo (`kids2`) si muove poco e in positivo, ma il margine intensivo (`nhijos`) e stabilmente negativo
- soprattutto, la penalita su `nhijos` sopravvive quando si controlla per provincia di nascita, provincia di residenza e quando si separano movers e stayers
- questo e il pezzo piu forte contro l'obiezione "state solo misurando sorting territoriale contemporaneo"

### 4. Macro pretrend e eterogeneita

Risultati chiave:

- test congiunto di pretrend: `p = 1.95e-19`
- sottocampione `church_0`: `interaction = -10.57` (`p < 0.001`)
- sottocampione `church_1`: `interaction = -9.53` (`p = 0.002`)
- sottocampione `war_1`: `interaction2 = -20.84` (`p = 0.020`)

Interpretazione:

- il macro panel non passa un test rassicurante di pretrend paralleli
- quindi questa parte va presentata come evidenza di supporto e di eterogeneita, non come la prova causale piu pulita del paper

### 5. IVS: placebo Portogallo e beliefs

Qui il messaggio e misto.

Fertilita in Portogallo:

- `PT`, `kids`: `treat_2 = 0.164` (`p < 0.001`), `treat_3 = 0.241` (`p < 0.001`)
- `PT`, `nkids`: `treat_2 = 0.445` (`p = 0.023`), `treat_3 = 0.748` (`p < 0.001`)

Differenza Spagna-Portogallo:

- nel pooled diff, `spain_treat2` e `spain_treat3` non sono significativi ne per `kids` ne per `nkids`

Beliefs in Spagna:

- `C001`: men should have more right to a job than women, nullo
- `D019`: a woman has to have children to be fulfilled, nullo
- `D057`: being a housewife just as fulfilling, nullo
- `D058`: husband and wife should both contribute income, nullo
- `D061`: preschool child suffers with working mother, `treat_3 = 0.294` (`p = 0.033`)
- `D062`: women want a home and children, `treat_2 = 0.180` (`p = 0.013`)
- `F120`: justifiable abortion, nullo

Interpretazione:

- il placebo portoghese non rafforza una lettura "solo Spagna", perche le coorti trattate in PT mostrano anch'esse differenze nette di fertilita
- inoltre le interazioni Spagna-Portogallo sono imprecise
- sui beliefs il pattern e sparso: solo 2 item mostrano qualche segnale, mentre il resto e vicino a zero
- quindi la parte beliefs va tenuta come evidenza suggestiva, non come meccanismo forte e univoco

### 6. Profili post-1950 nel census 2011

Questo file e descrittivo, non causale.

Risultati:

- `1920-1929`: `nhijos = 2.40`
- `1930-1938`: `nhijos = 1.74`
- `1939-1950`: `nhijos = 1.36`
- `1951-1955`: `nhijos = 1.46`
- `1956-1960`: `nhijos = 1.65`
- `1961-1965`: `nhijos = 1.75`

Interpretazione:

- la caduta per le coorti 1939-1950 e visibile
- la risalita nelle coorti piu giovani non va letta come "reversal" automatico, perche nel 2011 queste donne sono osservate a eta piu basse e quindi il confronto non e una misura perfetta di completed fertility

## Messaggio sintetico

Dopo il rerun con la baseline corretta:

- i risultati micro su completed fertility diventano piu credibili quando si guardano i census con birthplace/residence
- la parte Law 56 perde molta forza e appare sensibile alla scelta della finestra
- la parte macro resta informativa ma soffre di pretrend non paralleli
- la parte beliefs/IVS e debole e va presentata con tono prudente

Se dovessi costruire la risposta ai referee partendo da questo rerun, metterei al centro:

1. robustezza del risultato su `nhijos` nei census usando birthplace e movers/stayers
2. uso della parte macro come contesto e non come identificazione principale
3. ridimensionamento esplicito di Law 56 e beliefs come evidenza complementare
