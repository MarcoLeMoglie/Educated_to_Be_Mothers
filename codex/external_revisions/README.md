# README - Analisi Con Dati Esterni Nuovi

Questo file riassume solo il lavoro fatto con fonti esterne nuove, separato dalle analisi gia fatte con i dati interni del progetto.

## Obiettivo

La cartella `codex/external_revisions/` contiene un bundle di analisi pensato per rispondere ai reviewer points che richiedono dati non ancora usati nel paper.

I quattro blocchi principali sono:
- `Law 56/1961` con timing legale piu preciso
- `crisi del 1973` con nuove proxy provinciali pre-crisi
- `migrazioni interne` con tavole ufficiali del Censo 1981
- `employment/fertility mechanism` con tavole ufficiali del Censo 1981

## Cartelle

- `do/`: nuovi do-file Stata
- `generated/`: dataset costruiti da fonti esterne
- `output/`: risultati finali in csv/dta
- `logs/`: log dei run Stata
- `notes/`: note metodologiche e diagnostica
- `scripts/`: script di supporto per costruire i dataset esterni

## Fonti Esterne Usate

### BOE

Usato per fissare correttamente il timing legale di:
- `Ley 56/1961`
- `Decreto 258/1962`
- `Decreto 2310/1970`

Output costruiti:
- `generated/law56_legal_timeline_external.dta`
- `generated/law56_external_timing_exposure.dta`

### INE 1950

Usato per costruire proxy pre-1973 della struttura economica, mantenendo il valore per l'intera provincia e aggiungendo le componenti separate per capitale provinciale e resto della provincia.

Fonte principale:
- `Cuadro VIII` del Censo 1950, gruppi di attivita economica

Output costruiti:
- `generated/province_pre73_crisis_proxies.dta`
- `generated/province_pre73_crisis_proxies.csv`
- `generated/province_pre73_cuadro_viii_raw.csv`

Nota metodologica:
- `notes/pre73_crisis_proxy_notes.md`

### INE Censo 1981

Usato per:
- migrazioni interne `1970 -> 1981`
- attivita femminile
- composizione settoriale delle donne movers/stayers
- fertilita per attivita economica

Tabelle usate:
- `01057`, `01058`, `01059`, `01061`
- `01025`, `01030`, `01072`

## File Eseguiti

Runner generale:
- `do/external_revision_run_all.do`

Do-file:
- `do/external_revision_01_law56_legal_timing.do`
- `do/external_revision_02_crisis73_macro_proxies.do`
- `do/external_revision_03_external_migration_censo1981.do`
- `do/external_revision_04_activity_fertility_censo1981.do`

Script:
- `scripts/build_pre73_crisis_proxies.py`

## 1. Law 56/1961 - Timing Legale

### Cosa fa

Questo blocco sostituisce la lettura semplice di `1961` con un timing piu preciso:
- esposizione da `1962`
- rafforzamento normativo da `1970`
- controllo con overlap sul post-`1973`

### Output

- `output/external_revision_01_law56_legal_timing.csv`

### Risultati principali

Su `nkids`:
- baseline `treat_3 = -0.344`, `p = 0.023`
- con exposure `1962`, `treat_3 = -0.364`, `p = 0.094`
- con `1962 + 1970`, `treat_3 = -0.395`, `p = 0.079`

Le nuove exposure legali non sono forti:
- `law56_share_20_35_1962`: molto piccola, non significativa
- `decree70_share_20_35`: negativa ma imprecisa

### Lettura

Questo test e utile soprattutto per dire che:
- il risultato non sembra spiegato banalmente dalla sola `Law 56/1961`
- una codifica piu precisa del timing legale non fa emergere un confound pulito che sostituisca il `1945`

### Cosa sembra worth keeping

Da tenere:
- specifica `1962`
- specifica `1962 + 1970`

Da usare con cautela:
- specifica `1962 + 1970 + 1973`, perche la sovrapposizione tra exposure rende l'interpretazione piu debole

## 2. Crisi Del 1973 - Proxy Provinciali Pre-Crisi

### Cosa fa

Questo blocco costruisce nuove proxy pre-crisi e le usa nel macro DiD con outcome non normalizzato `alive`, mantenendo i controlli per la composizione decennale delle eta fertili del design attivo di `Main_analysis.do`. Nella macro, le proxy vengono ora assegnate al livello corretto del panel: valore della capitale per le unita `municipality` e valore del resto della provincia per le unita `rest province`. Nella micro, invece, resta il merge sul valore dell'intera provincia di nascita.

Proxy principali:
- `industrial_core_share_1950`
- `oil_sensitive_share_1950`
- `manuf_trade_share_1950`
- `nonag_share_1950`

### Output

- `generated/province_pre73_crisis_proxies.dta`
- `output/external_revision_02_crisis73_macro_proxies.csv`

### Qualita del dataset

Le proxy sono state costruite con una regola di audit esplicita:
- `proxy_usable_pre73 = 1` se la riga provinciale totale estratta dal Censo 1950 ha coerenza interna sufficiente
- `proxy_usable_pre73_cap = 1` se la riga della capitale ha coerenza interna sufficiente
- `proxy_usable_pre73_rest = 1` se il resto della provincia derivato da `totale - capitale` resta coerente e non negativo

Province utilizzabili nel dataset totale di provincia:
- `37` su `50`

Province utilizzabili nel campione macro a due unita territoriali coerenti (`capital` + `rest province`):
- `28` su `50`

### Risultati principali

Nel sample con proxy valide:
- `interaction = -487.197`, `p = 0.0619`
- `interaction2 = -157.253`, `p = 0.2592`

Nel sample pre-`1972` con proxy valide:
- `interaction = -381.934`, `p = 0.0720`
- `interaction2 = -218.746`, `p = 0.0520`

I termini `post73 x proxy` sono deboli anche con outcome non normalizzato e controlli completi:
- `industrial_core_share_1950`: non significativo
- `oil_sensitive_share_1950`: non significativo
- `manuf_trade_share_1950`: borderline solo sul lato femminile (`p = 0.096`)
- `nonag_share_1950`: non significativo

### Lettura

Questo e uno dei pezzi piu utili del bundle esterno.

Messaggio:
- il segno del risultato locale resta negativo anche nel sample con proxy valide
- restringendo a pre-`1972`, il lato femminile resta simile e il lato maschile diventa borderline
- non emerge evidenza robusta che il post-`1973` sia piu negativo proprio dove l'economia era piu oil-sensitive
- nella tabella macro finale il confronto viene fatto sul campione appaiato `capital/rest province`, cosi ogni provincia entra con entrambe le unita territoriali oppure non entra affatto

### Cosa sembra worth keeping

Da tenere:
- baseline nel sample con proxy valide
- restrizione pre-`1972`
- una sola tabella di eterogeneita, preferibilmente con `oil_sensitive_share_1950`

Da non appesantire troppo:
- batteria lunga di proxy molto simili tra loro

## 3. Migrazioni Interne - Tavole Ufficiali Censo 1981

### Cosa fa

Questo blocco combina evidenza descrittiva ufficiale e un nuovo link provinciale con l'intensita del trattamento del paper.

Costruisce:
- donne movers vs stayers
- attivita e occupazione
- composizione settoriale
- stay shares provinciali `1970 -> 1981`
- regressioni provinciali `stay_share` su exposure storica del trattamento

### Output

- `output/external_revision_03_female_mobility_activity.csv`
- `output/external_revision_03_female_mobility_sectors.csv`
- `output/external_revision_03_province_stay_share_1970_1981.csv`
- `output/external_revision_03_province_mobility_link.csv`
- `output/external_revision_03_province_mobility_regs.csv`

### Risultati principali

Donne `25-34`:
- movers `active_share = 0.289`
- stayers `active_share = 0.327`
- movers `employed_share = 0.852`
- stayers `employed_share = 0.855`

Donne `35-44`:
- movers `active_share = 0.205`
- stayers `active_share = 0.192`
- movers `employed_share = 0.913`
- stayers `employed_share = 0.929`

Settori delle donne movers:
- prevalgono i `services`
- l'`industry` pesa ma meno dei servizi
- l'`agriculture` e molto meno importante che tra le stayers

Test provinciale agganciato al trattamento:
- in `stay_on_levels`, `sum1muni` e `sum2muni` non sono significativi
- in `stay_on_gaps`, `treat_gap_f` e positivo ma impreciso (`p = 0.156`)
- in `stay_on_gaps_ctrl`, controllando per `muni_share_1940` e `ln_origin_total`, `treat_gap_f = 0.00825` con `p = 0.016`
- `muni_share_1940` e fortemente positiva (`p = 0.002`)

### Lettura

Questo blocco conferma che:
- la migrazione interna e sostantivamente importante
- le movers sono piu legate a contesti urbani/terziari
- le province con piu retention sono soprattutto province piu urbanizzate
- non emerge evidenza che le province piu esposte al trattamento abbiano sistematicamente meno retention tra `1970` e `1981`

Ma non racconta una storia semplicissima del tipo:
- “le aree trattate perdono solo donne attive, quindi cade tutto”

La differenza piu chiara e di composizione settoriale e urbanizzazione, non di occupazione pura una volta dentro la forza lavoro.
Anzi, nel test provinciale controllato il gradiente femminile del trattamento va semmai nella direzione opposta a una storia di depopolamento meccanico.

### Cosa sembra worth keeping

Da tenere:
- tabella `female mobility activity`
- tabella breve `female mobility sectors`
- tabella/regressione provinciale `stay_share` su `treat_gap_f`, con controllo per `muni_share_1940`

Da mettere eventualmente in appendix:
- ranking completo `province stay share 1970_1981`

## 4. Employment/Fertility Mechanism - Censo 1981

### Cosa fa

Questo blocco serve a rafforzare il lato meccanismi del reviewer point su `Law 56`.

Costruisce:
- gap di fertilita tra donne economicamente attive e inattive
- tasso di attivita femminile nel 1981
- struttura `occupied / unemployed / inactive` delle donne nel 1981
- confronto diretto donne-uomini nei tassi di attivita
- profilo settoriale femminile per eta

### Output

- `output/external_revision_04_activity_fertility_gap.csv`
- `output/external_revision_04_law56_window_cells.csv`
- `output/external_revision_04_female_activity_1981.csv`
- `output/external_revision_04_female_activity_structure_1981.csv`
- `output/external_revision_04_sex_activity_gap_1981.csv`
- `output/external_revision_04_female_sector_age_profile.csv`

### Risultati principali

Tasso di attivita femminile nel 1981:
- nazionale `0.224`
- urbano `0.247`
- rurale `0.187`

Confronto donne-uomini nei tassi di attivita:
- nazionale: donne `22.37` vs uomini `73.12`
- urbano: donne `24.71` vs uomini `74.43`
- il rapporto donne/uomini resta solo tra `0.25` e `0.33`

Struttura della condizione femminile nel 1981:
- nazionale: `occupied_share_total = 0.177`, `inactive_share_total = 0.776`
- urbano: `occupied_share_total = 0.192`, `inactive_share_total = 0.753`
- rurale: `occupied_share_total = 0.160`, `inactive_share_total = 0.813`

Gap figli tra attive e inattive:
- matrimoni `1961_1965`, età `25-29`: `2.1` vs `2.8`, gap `-0.7`
- matrimoni `1966_1970`, età `25-29`: `2.56` vs `3.20`, gap `-0.64`
- matrimoni `1971_1975`, età `25-29`: `1.76` vs `2.20`, gap `-0.44`

In generale:
- le donne attive hanno meno figli delle inattive quasi ovunque nelle celle nazionali con dati utilizzabili
- questo gap e visibile anche nelle celle compatte vicine alla finestra `1961-1970`, sia a livello nazionale sia in urbano/rurale

### Lettura

Questo e un buon pezzo di meccanismo descrittivo.

Aiuta a dire che:
- il legame `female activity -> lower fertility` e reale nei dati storici vicini al periodo che interessa
- quindi il reviewer point su `Law 56` non e teoricamente assurdo
- ma il livello complessivo di partecipazione femminile al lavoro resta molto basso anche nel `1981`, quindi la storia di un grande shock occupazionale generalizzato resta poco plausibile

Ma non identifica causalmente:
- l'effetto della legge sull'occupazione
- ne tantomeno il passaggio completo `Law 56 -> employment -> fertility`

### Cosa sembra worth keeping

Da tenere:
- tabella gap attive vs inattive
- righe `1961_1965` e `1966_1970`
- tabella attivita femminile `1981`
- tabella donne vs uomini sui tassi di attivita
- struttura femminile `occupied / inactive`

Da lasciare in appendix:
- matrice completa per zona e classe d'eta

## File Da Aprire Per Primi

Se vuoi discutere il bundle esterno senza perderti:

1. `output/external_revision_01_law56_legal_timing.csv`
2. `output/external_revision_02_crisis73_macro_proxies.csv`
3. `output/external_revision_03_female_mobility_activity.csv`
4. `output/external_revision_04_activity_fertility_gap.csv`
5. `generated/province_pre73_crisis_proxies.dta`

## Shortlist Provvisoria Per Il Selected Revision Design

Se dovessi scegliere cosa tenere adesso nel design selezionato, sulla sola base dei dati esterni nuovi:

- `Law 56`: specifiche con timing `1962` e `1962 + 1970`
- `Crisi 1973`: baseline con proxy valide + restrizione pre-`1972` + una sola eterogeneita con `oil_sensitive_share_1950`
- `Migrazioni`: tabella movers/stayers su attivita e occupazione + tabella breve sui settori
- `Mechanism`: gap fertilita `attive vs inattive` per coorti matrimoniali vicine a `1961-1970`

## File Di Supporto

Per la lettura piu dettagliata:
- `report_external_reviewer_workstreams_detailed.md`
- `notes/pre73_crisis_proxy_notes.md`

Ma il file da usare come entry point per il lavoro sui soli dati esterni nuovi e questo `README.md`.
