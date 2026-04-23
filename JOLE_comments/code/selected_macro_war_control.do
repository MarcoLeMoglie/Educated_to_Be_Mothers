version 17.0
clear all
set more off
set varabbrev off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global codex "$root/codex"
global paper_root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/Applicazioni/Overleaf/Educated to Be Mothers-slides"
global jole "$paper_root/JOLE_comments"
global out "$jole/tables"
global logs "$jole/logs"

log using "$logs/selected_macro_war_control.log", replace text

use "$codex/generated/dataset_female1544_revision.dta", clear
gen interaction3 = post * deaths_male_cwar

quietly reghdfe alive interaction interaction2 interaction3 ///
    1.post##c.sum1 1.post##c.sum2 1.post##c.deaths_male_cwar ///
    flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov) cluster(id)

outreg2 using "$out/table_selected_macro_war_control.tex", replace tex(frag) label ///
    keep(interaction interaction2 interaction3) nocons ctitle("Direct war control") ///
    addtext(Unit FE, YES, Province-Year FE, YES, Fertile-age controls, YES, War control, YES)

log close
