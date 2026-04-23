version 17.0
clear all
set more off

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global cis "$root/original_data/CIS/_data_cis/"
global codex "$root/codex"

use "${cis}barometros.dta", clear
replace kids = 0 if nkids == 0 & kids == .
keep if female == 1 & year_birth <= 1950
merge m:1 year_birth using "$codex/generated/law56_cohort_exposure.dta", keep(match master) nogen
quietly sum law56_share_20_35 if nkids < .
display "NKIDS_N=" %12.0fc r(N)
display "NKIDS_mean=" %9.6f r(mean)
display "NKIDS_sd=" %9.6f r(sd)
quietly sum law56_share_20_35 if kids < .
display "KIDS_N=" %12.0fc r(N)
display "KIDS_mean=" %9.6f r(mean)
display "KIDS_sd=" %9.6f r(sd)
quietly sum law56_share_20_35
display "ALL_N=" %12.0fc r(N)
display "ALL_mean=" %9.6f r(mean)
display "ALL_sd=" %9.6f r(sd)
