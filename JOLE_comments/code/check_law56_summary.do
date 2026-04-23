version 17.0
clear all
set more off

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global cis "$root/original_data/CIS/_data_cis/"
global codex "$root/codex"

use "${cis}barometros.dta", clear
keep if female == 1 & year_birth <= 1950
merge m:1 year_birth using "$codex/generated/law56_cohort_exposure.dta", keep(match master) nogen
quietly sum law56_share_20_35 if kids < .
display "N=" %12.0fc r(N)
display "mean=" %9.6f r(mean)
display "sd=" %9.6f r(sd)
display "min=" %9.6f r(min)
display "max=" %9.6f r(max)
