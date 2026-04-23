version 17.0
clear all
set more off
set varabbrev off

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global paper_root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/Applicazioni/Overleaf/Educated to Be Mothers-slides"
global datain2 "$root/original_data/INE_microdatos/"
global jole "$paper_root/JOLE_comments"
global tables "$jole/tables"
global logs "$jole/logs"
global province "$root/output_data/dataset_PROVINCElevel.dta"

capture mkdir "$tables"
capture mkdir "$logs"
capture log close
log using "$logs/refresh_birthplace_war_table.log", replace text

use ${datain2}censo1991/por_provincias/censo1991_provincias.dta, clear
rename *, lower
replace fecha = . if fecha > 100
gen anac = 1992 - fecha
keep if inrange(anac, 1920, 1970)
gen year = 1991
rename prov codprov
rename pronacin codprov_born
rename mun cmun
rename hijos nhijos
gen weight = fe / 10000
tempfile c1991_base
save "`c1991_base'"

use ${datain2}censo2011/por_provincias/censo2011_provincias.dta, clear
rename *, lower
keep if inrange(anac, 1920, 1970)
replace nhijos = 0 if hijos == 0
gen year = 2011
rename cpro codprov
rename cpron codprov_born
append using "`c1991_base'"

gen treat = .
replace treat = 0 if anac <= 1929
replace treat = 1 if anac > 1929 & anac < 1939
replace treat = 2 if anac >= 1939
tab treat, gen(treat_)
gen weight2 = fe if year == 1991
replace weight2 = factor if year == 2011
gen age_c = floor(edad / 10)
label var nhijos "N. kids"
label var treat_2 "1930/1938"
label var treat_3 "1939/1950"

preserve
use "$province", clear
keep codprov sh_area_front
rename codprov codprov_born
duplicates drop
tempfile province_war
save "`province_war'"
restore

merge m:1 codprov_born using "`province_war'", keep(match master) nogen
gen front_treat2 = sh_area_front * treat_2 if sh_area_front < .
gen front_treat3 = sh_area_front * treat_3 if sh_area_front < .
label var front_treat2 "1930/1938 X War exposure"
label var front_treat3 "1939/1950 X War exposure"

quietly reghdfe nhijos treat_2 treat_3 if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)
quietly sum nhijos if e(sample) [aw=weight2], meanonly
local mean_nhijos_war : display %4.2f r(mean)
outreg2 using "$tables/table_selected_birthplace_war.tex", replace tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Baseline with birthplace FE, ///
            Census. X Mun. X Age-class FE, NO, ///
            Mun. X Year X Age-class X Birth Prov. FE, YES, ///
            Birthplace war interactions, NO) ///
    addstat(Mean of depvar, `mean_nhijos_war') nonotes

quietly reghdfe nhijos treat_2 treat_3 front_treat2 front_treat3 ///
    if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)
quietly sum nhijos if e(sample) [aw=weight2], meanonly
local mean_nhijos_war2 : display %4.2f r(mean)
outreg2 using "$tables/table_selected_birthplace_war.tex", append tex(frag) label ///
    keep(treat_2 treat_3 front_treat2 front_treat3) nocons ctitle("N. kids") ///
    addtext(Specification, Birthplace FE + war, ///
            Census. X Mun. X Age-class FE, NO, ///
            Mun. X Year X Age-class X Birth Prov. FE, YES, ///
            Birthplace war interactions, YES) ///
    addstat(Mean of depvar, `mean_nhijos_war2') nonotes

log close
