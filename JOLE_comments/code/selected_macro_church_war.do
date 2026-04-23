version 17.0
clear all
set more off
set varabbrev off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global codex "$root/codex"
global paper_root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/Applicazioni/Overleaf/Educated to Be Mothers-slides"
global jole "$paper_root/JOLE_comments"
global tables "$jole/tables"
global logs "$jole/logs"

capture mkdir "$tables"
capture mkdir "$logs"

log using "$logs/selected_macro_church_war.log", replace text

use "$codex/generated/dataset_female1544_revision.dta", clear
egen church_med = median(relig_com_total1930)
gen high_church = relig_com_total1930 > church_med if relig_com_total1930 < .
gen interaction3 = post * deaths_male_cwar

quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 ///
    flag4_3 flag4_4 flag4_5 if high_church == 0, ///
    a(i.id i.year#i.codprov) cluster(id)
outreg2 using "$tables/table_selected_macro_church_war.tex", replace tex(frag) label ///
    keep(interaction interaction2) nocons ctitle("Low church") ///
    addtext(Unit FE, YES, Province-Year FE, YES, Fertile-age controls, YES)

quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 ///
    flag4_3 flag4_4 flag4_5 if high_church == 1, ///
    a(i.id i.year#i.codprov) cluster(id)
outreg2 using "$tables/table_selected_macro_church_war.tex", append tex(frag) label ///
    keep(interaction interaction2) nocons ctitle("High church") ///
    addtext(Unit FE, YES, Province-Year FE, YES, Fertile-age controls, YES)

quietly reghdfe alive interaction interaction2 interaction3 ///
    1.post##c.sum1 1.post##c.sum2 1.post##c.deaths_male_cwar ///
    flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov) cluster(id)
outreg2 using "$tables/table_selected_macro_church_war.tex", append tex(frag) label ///
    keep(interaction interaction2 interaction3) nocons ctitle("Direct war control") ///
    addtext(Unit FE, YES, Province-Year FE, YES, Fertile-age controls, YES, War control, YES)

log close
