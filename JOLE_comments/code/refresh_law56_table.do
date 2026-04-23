version 17.0
clear all
set more off
set varabbrev off

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global paper_root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/Applicazioni/Overleaf/Educated to Be Mothers-slides"
global cis "$root/original_data/CIS/_data_cis/"
global codex "$root/codex"
global jole "$paper_root/JOLE_comments"
global tables "$jole/tables"

use "${cis}barometros.dta", clear
egen id_type = group(type)
drop if year_birth < 1910
gen age_c = floor(age / 10)
gen treat = .
replace treat = 0 if year_birth <= 1929
replace treat = 1 if year_birth > 1929 & year_birth < 1939
replace treat = 2 if year_birth >= 1939
tab treat, gen(treat_)
label var treat_2 "1930/1938"
label var treat_3 "1939/1950"
replace kids = 0 if nkids == 0 & kids == .
merge m:1 year_birth using "$codex/generated/law56_cohort_exposure.dta", keep(match master) nogen
quietly reghdfe nkids treat_2 treat_3 if female == 1 & year_birth <= 1950, a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
outreg2 using "$tables/table_selected_law56_nkids.tex", replace tex(frag) label keep(treat_2 treat_3) nocons ctitle("Baseline") addtext(Survey-year FE, YES, Residence FE, YES, Age-class FE, YES, Survey-year X Residence X Age-class FE, YES) nonotes
quietly reghdfe nkids treat_2 treat_3 law56_share_20_35 if female == 1 & year_birth <= 1950, a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
outreg2 using "$tables/table_selected_law56_nkids.tex", append tex(frag) label keep(treat_2 treat_3 law56_share_20_35) nocons ctitle("+ Law 56/1961 exposure") addtext(Survey-year FE, YES, Residence FE, YES, Age-class FE, YES, Survey-year X Residence X Age-class FE, YES) nonotes
